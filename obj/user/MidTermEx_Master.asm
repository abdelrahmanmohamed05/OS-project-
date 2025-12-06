
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 dc 02 00 00       	call   800312 <libmain>
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
  80003b:	83 ec 38             	sub    $0x38,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 00 43 80 00       	push   $0x804300
  80004a:	e8 82 1c 00 00       	call   801cd1 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	char select;
	sys_lock_cons();
  80005e:	e8 f9 2c 00 00       	call   802d5c <sys_lock_cons>
	{
		cprintf("%~Which type of concurrency protection do you want to use? \n") ;
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 04 43 80 00       	push   $0x804304
  80006b:	e8 32 05 00 00       	call   8005a2 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("%~0) Nothing\n") ;
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 41 43 80 00       	push   $0x804341
  80007b:	e8 22 05 00 00       	call   8005a2 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("%~1) Semaphores\n") ;
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 4f 43 80 00       	push   $0x80434f
  80008b:	e8 12 05 00 00       	call   8005a2 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("%~2) SpinLock\n") ;
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 60 43 80 00       	push   $0x804360
  80009b:	e8 02 05 00 00       	call   8005a2 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("%~your choice (0, 1, 2): ") ;
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 6f 43 80 00       	push   $0x80436f
  8000ab:	e8 f2 04 00 00       	call   8005a2 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp
		select = getchar() ;
  8000b3:	e8 3d 02 00 00       	call   8002f5 <getchar>
  8000b8:	88 45 f3             	mov    %al,-0xd(%ebp)
		cputchar(select);
  8000bb:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  8000bf:	83 ec 0c             	sub    $0xc,%esp
  8000c2:	50                   	push   %eax
  8000c3:	e8 0e 02 00 00       	call   8002d6 <cputchar>
  8000c8:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	6a 0a                	push   $0xa
  8000d0:	e8 01 02 00 00       	call   8002d6 <cputchar>
  8000d5:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8000d8:	e8 99 2c 00 00       	call   802d76 <sys_unlock_cons>

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *protType = smalloc("protType", sizeof(int) , 0) ;
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	6a 00                	push   $0x0
  8000e2:	6a 04                	push   $0x4
  8000e4:	68 89 43 80 00       	push   $0x804389
  8000e9:	e8 e3 1b 00 00       	call   801cd1 <smalloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*protType = 0 ;
  8000f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == '1') 		*protType = 1 ;
  8000fd:	80 7d f3 31          	cmpb   $0x31,-0xd(%ebp)
  800101:	75 0b                	jne    80010e <_main+0xd6>
  800103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800106:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  80010c:	eb 0f                	jmp    80011d <_main+0xe5>
	else if (select == '2') *protType = 2 ;
  80010e:	80 7d f3 32          	cmpb   $0x32,-0xd(%ebp)
  800112:	75 09                	jne    80011d <_main+0xe5>
  800114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800117:	c7 00 02 00 00 00    	movl   $0x2,(%eax)

	struct semaphore T, finished, finishedCountMutex;
	struct uspinlock *sT, *sfinishedCountMutex;
	int *numOfFinished ;
	if (*protType == 1)
  80011d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800120:	8b 00                	mov    (%eax),%eax
  800122:	83 f8 01             	cmp    $0x1,%eax
  800125:	75 44                	jne    80016b <_main+0x133>
	{
		T = create_semaphore("T", 0);
  800127:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80012a:	83 ec 04             	sub    $0x4,%esp
  80012d:	6a 00                	push   $0x0
  80012f:	68 92 43 80 00       	push   $0x804392
  800134:	50                   	push   %eax
  800135:	e8 f2 3b 00 00       	call   803d2c <create_semaphore>
  80013a:	83 c4 0c             	add    $0xc,%esp
		finished = create_semaphore("finished", 0);
  80013d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 00                	push   $0x0
  800145:	68 94 43 80 00       	push   $0x804394
  80014a:	50                   	push   %eax
  80014b:	e8 dc 3b 00 00       	call   803d2c <create_semaphore>
  800150:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = create_semaphore("finishedCountMutex", 1);
  800153:	8d 45 cc             	lea    -0x34(%ebp),%eax
  800156:	83 ec 04             	sub    $0x4,%esp
  800159:	6a 01                	push   $0x1
  80015b:	68 9d 43 80 00       	push   $0x80439d
  800160:	50                   	push   %eax
  800161:	e8 c6 3b 00 00       	call   803d2c <create_semaphore>
  800166:	83 c4 0c             	add    $0xc,%esp
  800169:	eb 62                	jmp    8001cd <_main+0x195>
	}
	else if (*protType == 2)
  80016b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016e:	8b 00                	mov    (%eax),%eax
  800170:	83 f8 02             	cmp    $0x2,%eax
  800173:	75 58                	jne    8001cd <_main+0x195>
	{
		sT = smalloc("T", sizeof(struct uspinlock), 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 44                	push   $0x44
  80017c:	68 92 43 80 00       	push   $0x804392
  800181:	e8 4b 1b 00 00       	call   801cd1 <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e8             	mov    %eax,-0x18(%ebp)
		init_uspinlock(sT, "T", 0);
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	6a 00                	push   $0x0
  800191:	68 92 43 80 00       	push   $0x804392
  800196:	ff 75 e8             	pushl  -0x18(%ebp)
  800199:	e8 01 3c 00 00       	call   803d9f <init_uspinlock>
  80019e:	83 c4 10             	add    $0x10,%esp
		sfinishedCountMutex = smalloc("finishedCountMutex", sizeof(struct uspinlock), 1);
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	6a 01                	push   $0x1
  8001a6:	6a 44                	push   $0x44
  8001a8:	68 9d 43 80 00       	push   $0x80439d
  8001ad:	e8 1f 1b 00 00       	call   801cd1 <smalloc>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		init_uspinlock(sfinishedCountMutex, "finishedCountMutex", 1);
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	6a 01                	push   $0x1
  8001bd:	68 9d 43 80 00       	push   $0x80439d
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 d5 3b 00 00       	call   803d9f <init_uspinlock>
  8001ca:	83 c4 10             	add    $0x10,%esp
	}
	//Create the check-finishing counter
	numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001cd:	83 ec 04             	sub    $0x4,%esp
  8001d0:	6a 01                	push   $0x1
  8001d2:	6a 04                	push   $0x4
  8001d4:	68 b0 43 80 00       	push   $0x8043b0
  8001d9:	e8 f3 1a 00 00       	call   801cd1 <smalloc>
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  8001e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f2:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8001f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8001fd:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800203:	89 c1                	mov    %eax,%ecx
  800205:	a1 20 50 80 00       	mov    0x805020,%eax
  80020a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800210:	52                   	push   %edx
  800211:	51                   	push   %ecx
  800212:	50                   	push   %eax
  800213:	68 be 43 80 00       	push   $0x8043be
  800218:	e8 4a 2d 00 00       	call   802f67 <sys_create_env>
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800223:	a1 20 50 80 00       	mov    0x805020,%eax
  800228:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80022e:	a1 20 50 80 00       	mov    0x805020,%eax
  800233:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800239:	89 c1                	mov    %eax,%ecx
  80023b:	a1 20 50 80 00       	mov    0x805020,%eax
  800240:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800246:	52                   	push   %edx
  800247:	51                   	push   %ecx
  800248:	50                   	push   %eax
  800249:	68 c8 43 80 00       	push   $0x8043c8
  80024e:	e8 14 2d 00 00       	call   802f67 <sys_create_env>
  800253:	83 c4 10             	add    $0x10,%esp
  800256:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 dc             	pushl  -0x24(%ebp)
  80025f:	e8 21 2d 00 00       	call   802f85 <sys_run_env>
  800264:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	ff 75 d8             	pushl  -0x28(%ebp)
  80026d:	e8 13 2d 00 00       	call   802f85 <sys_run_env>
  800272:	83 c4 10             	add    $0x10,%esp

	/*[5] WAIT TILL FINISHING BOTH PROCESSES*/
	if (*protType == 1)
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	83 f8 01             	cmp    $0x1,%eax
  80027d:	75 1c                	jne    80029b <_main+0x263>
	{
		wait_semaphore(finished);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	ff 75 d0             	pushl  -0x30(%ebp)
  800285:	e8 d6 3a 00 00       	call   803d60 <wait_semaphore>
  80028a:	83 c4 10             	add    $0x10,%esp
		wait_semaphore(finished);
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	ff 75 d0             	pushl  -0x30(%ebp)
  800293:	e8 c8 3a 00 00       	call   803d60 <wait_semaphore>
  800298:	83 c4 10             	add    $0x10,%esp
	}
	if (*protType == 2)
  80029b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029e:	8b 00                	mov    (%eax),%eax
  8002a0:	83 f8 02             	cmp    $0x2,%eax
  8002a3:	75 0d                	jne    8002b2 <_main+0x27a>
	{
		while (*numOfFinished != 2) ;
  8002a5:	90                   	nop
  8002a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a9:	8b 00                	mov    (%eax),%eax
  8002ab:	83 f8 02             	cmp    $0x2,%eax
  8002ae:	75 f6                	jne    8002a6 <_main+0x26e>
  8002b0:	eb 0b                	jmp    8002bd <_main+0x285>
	}
	else
	{
		while (*numOfFinished != 2) ;
  8002b2:	90                   	nop
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	8b 00                	mov    (%eax),%eax
  8002b8:	83 f8 02             	cmp    $0x2,%eax
  8002bb:	75 f6                	jne    8002b3 <_main+0x27b>
	}

	/*[6] PRINT X*/
	atomic_cprintf("%~Final value of X = %d\n", *X);
  8002bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c0:	8b 00                	mov    (%eax),%eax
  8002c2:	83 ec 08             	sub    $0x8,%esp
  8002c5:	50                   	push   %eax
  8002c6:	68 d2 43 80 00       	push   $0x8043d2
  8002cb:	e8 44 03 00 00       	call   800614 <atomic_cprintf>
  8002d0:	83 c4 10             	add    $0x10,%esp

	return;
  8002d3:	90                   	nop
}
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002df:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8002e2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	50                   	push   %eax
  8002ea:	e8 b5 2b 00 00       	call   802ea4 <sys_cputc>
  8002ef:	83 c4 10             	add    $0x10,%esp
}
  8002f2:	90                   	nop
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <getchar>:


int
getchar(void)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8002fb:	e8 43 2a 00 00       	call   802d43 <sys_cgetc>
  800300:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <iscons>:

int iscons(int fdnum)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80030b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	57                   	push   %edi
  800316:	56                   	push   %esi
  800317:	53                   	push   %ebx
  800318:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80031b:	e8 b5 2c 00 00       	call   802fd5 <sys_getenvindex>
  800320:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800323:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800326:	89 d0                	mov    %edx,%eax
  800328:	c1 e0 03             	shl    $0x3,%eax
  80032b:	01 d0                	add    %edx,%eax
  80032d:	c1 e0 02             	shl    $0x2,%eax
  800330:	01 d0                	add    %edx,%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	01 d0                	add    %edx,%eax
  80033b:	c1 e0 03             	shl    $0x3,%eax
  80033e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800343:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800348:	a1 20 50 80 00       	mov    0x805020,%eax
  80034d:	8a 40 20             	mov    0x20(%eax),%al
  800350:	84 c0                	test   %al,%al
  800352:	74 0d                	je     800361 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800354:	a1 20 50 80 00       	mov    0x805020,%eax
  800359:	83 c0 20             	add    $0x20,%eax
  80035c:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800361:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800365:	7e 0a                	jle    800371 <libmain+0x5f>
		binaryname = argv[0];
  800367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036a:	8b 00                	mov    (%eax),%eax
  80036c:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	ff 75 0c             	pushl  0xc(%ebp)
  800377:	ff 75 08             	pushl  0x8(%ebp)
  80037a:	e8 b9 fc ff ff       	call   800038 <_main>
  80037f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800382:	a1 00 50 80 00       	mov    0x805000,%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	0f 84 01 01 00 00    	je     800490 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80038f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800395:	bb e4 44 80 00       	mov    $0x8044e4,%ebx
  80039a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80039f:	89 c7                	mov    %eax,%edi
  8003a1:	89 de                	mov    %ebx,%esi
  8003a3:	89 d1                	mov    %edx,%ecx
  8003a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003a7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003aa:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003af:	b0 00                	mov    $0x0,%al
  8003b1:	89 d7                	mov    %edx,%edi
  8003b3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	50                   	push   %eax
  8003c3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003c9:	50                   	push   %eax
  8003ca:	e8 3c 2e 00 00       	call   80320b <sys_utilities>
  8003cf:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003d2:	e8 85 29 00 00       	call   802d5c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003d7:	83 ec 0c             	sub    $0xc,%esp
  8003da:	68 04 44 80 00       	push   $0x804404
  8003df:	e8 be 01 00 00       	call   8005a2 <cprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ea:	85 c0                	test   %eax,%eax
  8003ec:	74 18                	je     800406 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003ee:	e8 36 2e 00 00       	call   803229 <sys_get_optimal_num_faults>
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	50                   	push   %eax
  8003f7:	68 2c 44 80 00       	push   $0x80442c
  8003fc:	e8 a1 01 00 00       	call   8005a2 <cprintf>
  800401:	83 c4 10             	add    $0x10,%esp
  800404:	eb 59                	jmp    80045f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800406:	a1 20 50 80 00       	mov    0x805020,%eax
  80040b:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800411:	a1 20 50 80 00       	mov    0x805020,%eax
  800416:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80041c:	83 ec 04             	sub    $0x4,%esp
  80041f:	52                   	push   %edx
  800420:	50                   	push   %eax
  800421:	68 50 44 80 00       	push   $0x804450
  800426:	e8 77 01 00 00       	call   8005a2 <cprintf>
  80042b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80042e:	a1 20 50 80 00       	mov    0x805020,%eax
  800433:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800439:	a1 20 50 80 00       	mov    0x805020,%eax
  80043e:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800444:	a1 20 50 80 00       	mov    0x805020,%eax
  800449:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80044f:	51                   	push   %ecx
  800450:	52                   	push   %edx
  800451:	50                   	push   %eax
  800452:	68 78 44 80 00       	push   $0x804478
  800457:	e8 46 01 00 00       	call   8005a2 <cprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045f:	a1 20 50 80 00       	mov    0x805020,%eax
  800464:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	50                   	push   %eax
  80046e:	68 d0 44 80 00       	push   $0x8044d0
  800473:	e8 2a 01 00 00       	call   8005a2 <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80047b:	83 ec 0c             	sub    $0xc,%esp
  80047e:	68 04 44 80 00       	push   $0x804404
  800483:	e8 1a 01 00 00       	call   8005a2 <cprintf>
  800488:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80048b:	e8 e6 28 00 00       	call   802d76 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800490:	e8 1f 00 00 00       	call   8004b4 <exit>
}
  800495:	90                   	nop
  800496:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800499:	5b                   	pop    %ebx
  80049a:	5e                   	pop    %esi
  80049b:	5f                   	pop    %edi
  80049c:	5d                   	pop    %ebp
  80049d:	c3                   	ret    

0080049e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004a4:	83 ec 0c             	sub    $0xc,%esp
  8004a7:	6a 00                	push   $0x0
  8004a9:	e8 f3 2a 00 00       	call   802fa1 <sys_destroy_env>
  8004ae:	83 c4 10             	add    $0x10,%esp
}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <exit>:

void
exit(void)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ba:	e8 48 2b 00 00       	call   803007 <sys_exit_env>
}
  8004bf:	90                   	nop
  8004c0:	c9                   	leave  
  8004c1:	c3                   	ret    

008004c2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004c2:	55                   	push   %ebp
  8004c3:	89 e5                	mov    %esp,%ebp
  8004c5:	53                   	push   %ebx
  8004c6:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d4:	89 0a                	mov    %ecx,(%edx)
  8004d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d9:	88 d1                	mov    %dl,%cl
  8004db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004de:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ec:	75 30                	jne    80051e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004ee:	8b 15 38 51 83 00    	mov    0x835138,%edx
  8004f4:	a0 64 d0 81 00       	mov    0x81d064,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ff:	8b 09                	mov    (%ecx),%ecx
  800501:	89 cb                	mov    %ecx,%ebx
  800503:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800506:	83 c1 08             	add    $0x8,%ecx
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	53                   	push   %ebx
  80050c:	51                   	push   %ecx
  80050d:	e8 06 28 00 00       	call   802d18 <sys_cputs>
  800512:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800521:	8b 40 04             	mov    0x4(%eax),%eax
  800524:	8d 50 01             	lea    0x1(%eax),%edx
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052d:	90                   	nop
  80052e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800543:	00 00 00 
	b.cnt = 0;
  800546:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800550:	ff 75 0c             	pushl  0xc(%ebp)
  800553:	ff 75 08             	pushl  0x8(%ebp)
  800556:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055c:	50                   	push   %eax
  80055d:	68 c2 04 80 00       	push   $0x8004c2
  800562:	e8 5a 02 00 00       	call   8007c1 <vprintfmt>
  800567:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80056a:	8b 15 38 51 83 00    	mov    0x835138,%edx
  800570:	a0 64 d0 81 00       	mov    0x81d064,%al
  800575:	0f b6 c0             	movzbl %al,%eax
  800578:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80057e:	52                   	push   %edx
  80057f:	50                   	push   %eax
  800580:	51                   	push   %ecx
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	83 c0 08             	add    $0x8,%eax
  80058a:	50                   	push   %eax
  80058b:	e8 88 27 00 00       	call   802d18 <sys_cputs>
  800590:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800593:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  80059a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    

008005a2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a8:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  8005af:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8005be:	50                   	push   %eax
  8005bf:	e8 6f ff ff ff       	call   800533 <vcprintf>
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cd:	c9                   	leave  
  8005ce:	c3                   	ret    

008005cf <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d5:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	c1 e0 08             	shl    $0x8,%eax
  8005e2:	a3 38 51 83 00       	mov    %eax,0x835138
	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	83 c0 04             	add    $0x4,%eax
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f9:	50                   	push   %eax
  8005fa:	e8 34 ff ff ff       	call   800533 <vcprintf>
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800605:	c7 05 38 51 83 00 00 	movl   $0x700,0x835138
  80060c:	07 00 00 

	return cnt;
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80061a:	e8 3d 27 00 00       	call   802d5c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80061f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800622:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	ff 75 f4             	pushl  -0xc(%ebp)
  80062e:	50                   	push   %eax
  80062f:	e8 ff fe ff ff       	call   800533 <vcprintf>
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80063a:	e8 37 27 00 00       	call   802d76 <sys_unlock_cons>
	return cnt;
  80063f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	53                   	push   %ebx
  800648:	83 ec 14             	sub    $0x14,%esp
  80064b:	8b 45 10             	mov    0x10(%ebp),%eax
  80064e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800657:	8b 45 18             	mov    0x18(%ebp),%eax
  80065a:	ba 00 00 00 00       	mov    $0x0,%edx
  80065f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800662:	77 55                	ja     8006b9 <printnum+0x75>
  800664:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800667:	72 05                	jb     80066e <printnum+0x2a>
  800669:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066c:	77 4b                	ja     8006b9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80066e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800671:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800674:	8b 45 18             	mov    0x18(%ebp),%eax
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	52                   	push   %edx
  80067d:	50                   	push   %eax
  80067e:	ff 75 f4             	pushl  -0xc(%ebp)
  800681:	ff 75 f0             	pushl  -0x10(%ebp)
  800684:	e8 0f 3a 00 00       	call   804098 <__udivdi3>
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	83 ec 04             	sub    $0x4,%esp
  80068f:	ff 75 20             	pushl  0x20(%ebp)
  800692:	53                   	push   %ebx
  800693:	ff 75 18             	pushl  0x18(%ebp)
  800696:	52                   	push   %edx
  800697:	50                   	push   %eax
  800698:	ff 75 0c             	pushl  0xc(%ebp)
  80069b:	ff 75 08             	pushl  0x8(%ebp)
  80069e:	e8 a1 ff ff ff       	call   800644 <printnum>
  8006a3:	83 c4 20             	add    $0x20,%esp
  8006a6:	eb 1a                	jmp    8006c2 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	ff 75 0c             	pushl  0xc(%ebp)
  8006ae:	ff 75 20             	pushl  0x20(%ebp)
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	ff d0                	call   *%eax
  8006b6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006b9:	ff 4d 1c             	decl   0x1c(%ebp)
  8006bc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c0:	7f e6                	jg     8006a8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c2:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d0:	53                   	push   %ebx
  8006d1:	51                   	push   %ecx
  8006d2:	52                   	push   %edx
  8006d3:	50                   	push   %eax
  8006d4:	e8 cf 3a 00 00       	call   8041a8 <__umoddi3>
  8006d9:	83 c4 10             	add    $0x10,%esp
  8006dc:	05 74 47 80 00       	add    $0x804774,%eax
  8006e1:	8a 00                	mov    (%eax),%al
  8006e3:	0f be c0             	movsbl %al,%eax
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	ff d0                	call   *%eax
  8006f2:	83 c4 10             	add    $0x10,%esp
}
  8006f5:	90                   	nop
  8006f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006fe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800702:	7e 1c                	jle    800720 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 08             	lea    0x8(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 08             	sub    $0x8,%eax
  800719:	8b 50 04             	mov    0x4(%eax),%edx
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	eb 40                	jmp    800760 <getuint+0x65>
	else if (lflag)
  800720:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800724:	74 1e                	je     800744 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
  800742:	eb 1c                	jmp    800760 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	8d 50 04             	lea    0x4(%eax),%edx
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	89 10                	mov    %edx,(%eax)
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	83 e8 04             	sub    $0x4,%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800765:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800769:	7e 1c                	jle    800787 <getint+0x25>
		return va_arg(*ap, long long);
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	8d 50 08             	lea    0x8(%eax),%edx
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	89 10                	mov    %edx,(%eax)
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	83 e8 08             	sub    $0x8,%eax
  800780:	8b 50 04             	mov    0x4(%eax),%edx
  800783:	8b 00                	mov    (%eax),%eax
  800785:	eb 38                	jmp    8007bf <getint+0x5d>
	else if (lflag)
  800787:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078b:	74 1a                	je     8007a7 <getint+0x45>
		return va_arg(*ap, long);
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	8d 50 04             	lea    0x4(%eax),%edx
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	89 10                	mov    %edx,(%eax)
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	83 e8 04             	sub    $0x4,%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	99                   	cltd   
  8007a5:	eb 18                	jmp    8007bf <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	8d 50 04             	lea    0x4(%eax),%edx
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	89 10                	mov    %edx,(%eax)
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	83 e8 04             	sub    $0x4,%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	99                   	cltd   
}
  8007bf:	5d                   	pop    %ebp
  8007c0:	c3                   	ret    

008007c1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	56                   	push   %esi
  8007c5:	53                   	push   %ebx
  8007c6:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c9:	eb 17                	jmp    8007e2 <vprintfmt+0x21>
			if (ch == '\0')
  8007cb:	85 db                	test   %ebx,%ebx
  8007cd:	0f 84 c1 03 00 00    	je     800b94 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 0c             	pushl  0xc(%ebp)
  8007d9:	53                   	push   %ebx
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	ff d0                	call   *%eax
  8007df:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8d 50 01             	lea    0x1(%eax),%edx
  8007e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8007eb:	8a 00                	mov    (%eax),%al
  8007ed:	0f b6 d8             	movzbl %al,%ebx
  8007f0:	83 fb 25             	cmp    $0x25,%ebx
  8007f3:	75 d6                	jne    8007cb <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007f9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800800:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800807:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80080e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8d 50 01             	lea    0x1(%eax),%edx
  80081b:	89 55 10             	mov    %edx,0x10(%ebp)
  80081e:	8a 00                	mov    (%eax),%al
  800820:	0f b6 d8             	movzbl %al,%ebx
  800823:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800826:	83 f8 5b             	cmp    $0x5b,%eax
  800829:	0f 87 3d 03 00 00    	ja     800b6c <vprintfmt+0x3ab>
  80082f:	8b 04 85 98 47 80 00 	mov    0x804798(,%eax,4),%eax
  800836:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800838:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083c:	eb d7                	jmp    800815 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80083e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800842:	eb d1                	jmp    800815 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800844:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80084e:	89 d0                	mov    %edx,%eax
  800850:	c1 e0 02             	shl    $0x2,%eax
  800853:	01 d0                	add    %edx,%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	01 d8                	add    %ebx,%eax
  800859:	83 e8 30             	sub    $0x30,%eax
  80085c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80085f:	8b 45 10             	mov    0x10(%ebp),%eax
  800862:	8a 00                	mov    (%eax),%al
  800864:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800867:	83 fb 2f             	cmp    $0x2f,%ebx
  80086a:	7e 3e                	jle    8008aa <vprintfmt+0xe9>
  80086c:	83 fb 39             	cmp    $0x39,%ebx
  80086f:	7f 39                	jg     8008aa <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800871:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800874:	eb d5                	jmp    80084b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088a:	eb 1f                	jmp    8008ab <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800890:	79 83                	jns    800815 <vprintfmt+0x54>
				width = 0;
  800892:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800899:	e9 77 ff ff ff       	jmp    800815 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80089e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a5:	e9 6b ff ff ff       	jmp    800815 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008aa:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	0f 89 60 ff ff ff    	jns    800815 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c2:	e9 4e ff ff ff       	jmp    800815 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c7:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ca:	e9 46 ff ff ff       	jmp    800815 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	83 c0 04             	add    $0x4,%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	ff 75 0c             	pushl  0xc(%ebp)
  8008e6:	50                   	push   %eax
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	ff d0                	call   *%eax
  8008ec:	83 c4 10             	add    $0x10,%esp
			break;
  8008ef:	e9 9b 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 c0 04             	add    $0x4,%eax
  8008fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	83 e8 04             	sub    $0x4,%eax
  800903:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800905:	85 db                	test   %ebx,%ebx
  800907:	79 02                	jns    80090b <vprintfmt+0x14a>
				err = -err;
  800909:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090b:	83 fb 64             	cmp    $0x64,%ebx
  80090e:	7f 0b                	jg     80091b <vprintfmt+0x15a>
  800910:	8b 34 9d e0 45 80 00 	mov    0x8045e0(,%ebx,4),%esi
  800917:	85 f6                	test   %esi,%esi
  800919:	75 19                	jne    800934 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091b:	53                   	push   %ebx
  80091c:	68 85 47 80 00       	push   $0x804785
  800921:	ff 75 0c             	pushl  0xc(%ebp)
  800924:	ff 75 08             	pushl  0x8(%ebp)
  800927:	e8 70 02 00 00       	call   800b9c <printfmt>
  80092c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80092f:	e9 5b 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800934:	56                   	push   %esi
  800935:	68 8e 47 80 00       	push   $0x80478e
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	ff 75 08             	pushl  0x8(%ebp)
  800940:	e8 57 02 00 00       	call   800b9c <printfmt>
  800945:	83 c4 10             	add    $0x10,%esp
			break;
  800948:	e9 42 02 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	83 c0 04             	add    $0x4,%eax
  800953:	89 45 14             	mov    %eax,0x14(%ebp)
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	83 e8 04             	sub    $0x4,%eax
  80095c:	8b 30                	mov    (%eax),%esi
  80095e:	85 f6                	test   %esi,%esi
  800960:	75 05                	jne    800967 <vprintfmt+0x1a6>
				p = "(null)";
  800962:	be 91 47 80 00       	mov    $0x804791,%esi
			if (width > 0 && padc != '-')
  800967:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096b:	7e 6d                	jle    8009da <vprintfmt+0x219>
  80096d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800971:	74 67                	je     8009da <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800973:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	50                   	push   %eax
  80097a:	56                   	push   %esi
  80097b:	e8 1e 03 00 00       	call   800c9e <strnlen>
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800986:	eb 16                	jmp    80099e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800988:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	ff 75 0c             	pushl  0xc(%ebp)
  800992:	50                   	push   %eax
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	ff d0                	call   *%eax
  800998:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099b:	ff 4d e4             	decl   -0x1c(%ebp)
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	7f e4                	jg     800988 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a4:	eb 34                	jmp    8009da <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009aa:	74 1c                	je     8009c8 <vprintfmt+0x207>
  8009ac:	83 fb 1f             	cmp    $0x1f,%ebx
  8009af:	7e 05                	jle    8009b6 <vprintfmt+0x1f5>
  8009b1:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b4:	7e 12                	jle    8009c8 <vprintfmt+0x207>
					putch('?', putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	6a 3f                	push   $0x3f
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	ff d0                	call   *%eax
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	eb 0f                	jmp    8009d7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ce:	53                   	push   %ebx
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	ff d0                	call   *%eax
  8009d4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009da:	89 f0                	mov    %esi,%eax
  8009dc:	8d 70 01             	lea    0x1(%eax),%esi
  8009df:	8a 00                	mov    (%eax),%al
  8009e1:	0f be d8             	movsbl %al,%ebx
  8009e4:	85 db                	test   %ebx,%ebx
  8009e6:	74 24                	je     800a0c <vprintfmt+0x24b>
  8009e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ec:	78 b8                	js     8009a6 <vprintfmt+0x1e5>
  8009ee:	ff 4d e0             	decl   -0x20(%ebp)
  8009f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f5:	79 af                	jns    8009a6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f7:	eb 13                	jmp    800a0c <vprintfmt+0x24b>
				putch(' ', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 20                	push   $0x20
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a09:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a10:	7f e7                	jg     8009f9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a12:	e9 78 01 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a17:	83 ec 08             	sub    $0x8,%esp
  800a1a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a20:	50                   	push   %eax
  800a21:	e8 3c fd ff ff       	call   800762 <getint>
  800a26:	83 c4 10             	add    $0x10,%esp
  800a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a35:	85 d2                	test   %edx,%edx
  800a37:	79 23                	jns    800a5c <vprintfmt+0x29b>
				putch('-', putdat);
  800a39:	83 ec 08             	sub    $0x8,%esp
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	6a 2d                	push   $0x2d
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	ff d0                	call   *%eax
  800a46:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a4f:	f7 d8                	neg    %eax
  800a51:	83 d2 00             	adc    $0x0,%edx
  800a54:	f7 da                	neg    %edx
  800a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a59:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a63:	e9 bc 00 00 00       	jmp    800b24 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a6e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a71:	50                   	push   %eax
  800a72:	e8 84 fc ff ff       	call   8006fb <getuint>
  800a77:	83 c4 10             	add    $0x10,%esp
  800a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a87:	e9 98 00 00 00       	jmp    800b24 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	6a 58                	push   $0x58
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	6a 58                	push   $0x58
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	6a 58                	push   $0x58
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	ff d0                	call   *%eax
  800ab9:	83 c4 10             	add    $0x10,%esp
			break;
  800abc:	e9 ce 00 00 00       	jmp    800b8f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	6a 30                	push   $0x30
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	6a 78                	push   $0x78
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	ff d0                	call   *%eax
  800ade:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	83 c0 04             	add    $0x4,%eax
  800ae7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	83 e8 04             	sub    $0x4,%eax
  800af0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b03:	eb 1f                	jmp    800b24 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0e:	50                   	push   %eax
  800b0f:	e8 e7 fb ff ff       	call   8006fb <getuint>
  800b14:	83 c4 10             	add    $0x10,%esp
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b24:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	52                   	push   %edx
  800b2f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b32:	50                   	push   %eax
  800b33:	ff 75 f4             	pushl  -0xc(%ebp)
  800b36:	ff 75 f0             	pushl  -0x10(%ebp)
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	ff 75 08             	pushl  0x8(%ebp)
  800b3f:	e8 00 fb ff ff       	call   800644 <printnum>
  800b44:	83 c4 20             	add    $0x20,%esp
			break;
  800b47:	eb 46                	jmp    800b8f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	53                   	push   %ebx
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			break;
  800b58:	eb 35                	jmp    800b8f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b5a:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800b61:	eb 2c                	jmp    800b8f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b63:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800b6a:	eb 23                	jmp    800b8f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	6a 25                	push   $0x25
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	ff d0                	call   *%eax
  800b79:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b7c:	ff 4d 10             	decl   0x10(%ebp)
  800b7f:	eb 03                	jmp    800b84 <vprintfmt+0x3c3>
  800b81:	ff 4d 10             	decl   0x10(%ebp)
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	48                   	dec    %eax
  800b88:	8a 00                	mov    (%eax),%al
  800b8a:	3c 25                	cmp    $0x25,%al
  800b8c:	75 f3                	jne    800b81 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b8e:	90                   	nop
		}
	}
  800b8f:	e9 35 fc ff ff       	jmp    8007c9 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b94:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ba2:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bab:	8b 45 10             	mov    0x10(%ebp),%eax
  800bae:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb1:	50                   	push   %eax
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	ff 75 08             	pushl  0x8(%ebp)
  800bb8:	e8 04 fc ff ff       	call   8007c1 <vprintfmt>
  800bbd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bc0:	90                   	nop
  800bc1:	c9                   	leave  
  800bc2:	c3                   	ret    

00800bc3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	8b 40 08             	mov    0x8(%eax),%eax
  800bcc:	8d 50 01             	lea    0x1(%eax),%edx
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8b 10                	mov    (%eax),%edx
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	8b 40 04             	mov    0x4(%eax),%eax
  800be0:	39 c2                	cmp    %eax,%edx
  800be2:	73 12                	jae    800bf6 <sprintputch+0x33>
		*b->buf++ = ch;
  800be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be7:	8b 00                	mov    (%eax),%eax
  800be9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bef:	89 0a                	mov    %ecx,(%edx)
  800bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf4:	88 10                	mov    %dl,(%eax)
}
  800bf6:	90                   	nop
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	01 d0                	add    %edx,%eax
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c1e:	74 06                	je     800c26 <vsnprintf+0x2d>
  800c20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c24:	7f 07                	jg     800c2d <vsnprintf+0x34>
		return -E_INVAL;
  800c26:	b8 03 00 00 00       	mov    $0x3,%eax
  800c2b:	eb 20                	jmp    800c4d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c2d:	ff 75 14             	pushl  0x14(%ebp)
  800c30:	ff 75 10             	pushl  0x10(%ebp)
  800c33:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c36:	50                   	push   %eax
  800c37:	68 c3 0b 80 00       	push   $0x800bc3
  800c3c:	e8 80 fb ff ff       	call   8007c1 <vprintfmt>
  800c41:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c47:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c55:	8d 45 10             	lea    0x10(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c61:	ff 75 f4             	pushl  -0xc(%ebp)
  800c64:	50                   	push   %eax
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	ff 75 08             	pushl  0x8(%ebp)
  800c6b:	e8 89 ff ff ff       	call   800bf9 <vsnprintf>
  800c70:	83 c4 10             	add    $0x10,%esp
  800c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c88:	eb 06                	jmp    800c90 <strlen+0x15>
		n++;
  800c8a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c8d:	ff 45 08             	incl   0x8(%ebp)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	84 c0                	test   %al,%al
  800c97:	75 f1                	jne    800c8a <strlen+0xf>
		n++;
	return n;
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cab:	eb 09                	jmp    800cb6 <strnlen+0x18>
		n++;
  800cad:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb0:	ff 45 08             	incl   0x8(%ebp)
  800cb3:	ff 4d 0c             	decl   0xc(%ebp)
  800cb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cba:	74 09                	je     800cc5 <strnlen+0x27>
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	75 e8                	jne    800cad <strnlen+0xf>
		n++;
	return n;
  800cc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cd6:	90                   	nop
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8d 50 01             	lea    0x1(%eax),%edx
  800cdd:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	84 c0                	test   %al,%al
  800cf1:	75 e4                	jne    800cd7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d0b:	eb 1f                	jmp    800d2c <strncpy+0x34>
		*dst++ = *src;
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8d 50 01             	lea    0x1(%eax),%edx
  800d13:	89 55 08             	mov    %edx,0x8(%ebp)
  800d16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d19:	8a 12                	mov    (%edx),%dl
  800d1b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	74 03                	je     800d29 <strncpy+0x31>
			src++;
  800d26:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d29:	ff 45 fc             	incl   -0x4(%ebp)
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d32:	72 d9                	jb     800d0d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d34:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 30                	je     800d7b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d4b:	eb 16                	jmp    800d63 <strlcpy+0x2a>
			*dst++ = *src++;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8d 50 01             	lea    0x1(%eax),%edx
  800d53:	89 55 08             	mov    %edx,0x8(%ebp)
  800d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d5f:	8a 12                	mov    (%edx),%dl
  800d61:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d63:	ff 4d 10             	decl   0x10(%ebp)
  800d66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6a:	74 09                	je     800d75 <strlcpy+0x3c>
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	84 c0                	test   %al,%al
  800d73:	75 d8                	jne    800d4d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d81:	29 c2                	sub    %eax,%edx
  800d83:	89 d0                	mov    %edx,%eax
}
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d8a:	eb 06                	jmp    800d92 <strcmp+0xb>
		p++, q++;
  800d8c:	ff 45 08             	incl   0x8(%ebp)
  800d8f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	74 0e                	je     800da9 <strcmp+0x22>
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 10                	mov    (%eax),%dl
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	38 c2                	cmp    %al,%dl
  800da7:	74 e3                	je     800d8c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	0f b6 d0             	movzbl %al,%edx
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	0f b6 c0             	movzbl %al,%eax
  800db9:	29 c2                	sub    %eax,%edx
  800dbb:	89 d0                	mov    %edx,%eax
}
  800dbd:	5d                   	pop    %ebp
  800dbe:	c3                   	ret    

00800dbf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dc2:	eb 09                	jmp    800dcd <strncmp+0xe>
		n--, p++, q++;
  800dc4:	ff 4d 10             	decl   0x10(%ebp)
  800dc7:	ff 45 08             	incl   0x8(%ebp)
  800dca:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd1:	74 17                	je     800dea <strncmp+0x2b>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	84 c0                	test   %al,%al
  800dda:	74 0e                	je     800dea <strncmp+0x2b>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 10                	mov    (%eax),%dl
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	38 c2                	cmp    %al,%dl
  800de8:	74 da                	je     800dc4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dee:	75 07                	jne    800df7 <strncmp+0x38>
		return 0;
  800df0:	b8 00 00 00 00       	mov    $0x0,%eax
  800df5:	eb 14                	jmp    800e0b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f b6 d0             	movzbl %al,%edx
  800dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	0f b6 c0             	movzbl %al,%eax
  800e07:	29 c2                	sub    %eax,%edx
  800e09:	89 d0                	mov    %edx,%eax
}
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e19:	eb 12                	jmp    800e2d <strchr+0x20>
		if (*s == c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e23:	75 05                	jne    800e2a <strchr+0x1d>
			return (char *) s;
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	eb 11                	jmp    800e3b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e2a:	ff 45 08             	incl   0x8(%ebp)
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	84 c0                	test   %al,%al
  800e34:	75 e5                	jne    800e1b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 04             	sub    $0x4,%esp
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e49:	eb 0d                	jmp    800e58 <strfind+0x1b>
		if (*s == c)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e53:	74 0e                	je     800e63 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e55:	ff 45 08             	incl   0x8(%ebp)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	84 c0                	test   %al,%al
  800e5f:	75 ea                	jne    800e4b <strfind+0xe>
  800e61:	eb 01                	jmp    800e64 <strfind+0x27>
		if (*s == c)
			break;
  800e63:	90                   	nop
	return (char *) s;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e75:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e79:	76 63                	jbe    800ede <memset+0x75>
		uint64 data_block = c;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	99                   	cltd   
  800e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e82:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8b:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e8f:	c1 e0 08             	shl    $0x8,%eax
  800e92:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e95:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9e:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ea2:	c1 e0 10             	shl    $0x10,%eax
  800ea5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb1:	89 c2                	mov    %eax,%edx
  800eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ebb:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ebe:	eb 18                	jmp    800ed8 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ec0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ec3:	8d 41 08             	lea    0x8(%ecx),%eax
  800ec6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecf:	89 01                	mov    %eax,(%ecx)
  800ed1:	89 51 04             	mov    %edx,0x4(%ecx)
  800ed4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ed8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800edc:	77 e2                	ja     800ec0 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ede:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee2:	74 23                	je     800f07 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eea:	eb 0e                	jmp    800efa <memset+0x91>
			*p8++ = (uint8)c;
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8d 50 01             	lea    0x1(%eax),%edx
  800ef2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef8:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800efa:	8b 45 10             	mov    0x10(%ebp),%eax
  800efd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f00:	89 55 10             	mov    %edx,0x10(%ebp)
  800f03:	85 c0                	test   %eax,%eax
  800f05:	75 e5                	jne    800eec <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f1e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f22:	76 24                	jbe    800f48 <memcpy+0x3c>
		while(n >= 8){
  800f24:	eb 1c                	jmp    800f42 <memcpy+0x36>
			*d64 = *s64;
  800f26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f29:	8b 50 04             	mov    0x4(%eax),%edx
  800f2c:	8b 00                	mov    (%eax),%eax
  800f2e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f31:	89 01                	mov    %eax,(%ecx)
  800f33:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f36:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f3a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f3e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f42:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f46:	77 de                	ja     800f26 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4c:	74 31                	je     800f7f <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f5a:	eb 16                	jmp    800f72 <memcpy+0x66>
			*d8++ = *s8++;
  800f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	73 50                	jae    800fee <memmove+0x6a>
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa9:	76 43                	jbe    800fee <memmove+0x6a>
		s += n;
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 10                	jmp    800fc9 <memmove+0x45>
			*--d = *--s;
  800fb9:	ff 4d f8             	decl   -0x8(%ebp)
  800fbc:	ff 4d fc             	decl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8a 10                	mov    (%eax),%dl
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 e3                	jne    800fb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd6:	eb 23                	jmp    800ffb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fea:	8a 12                	mov    (%edx),%dl
  800fec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 dd                	jne    800fd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801012:	eb 2a                	jmp    80103e <memcmp+0x3e>
		if (*s1 != *s2)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	38 c2                	cmp    %al,%dl
  801020:	74 16                	je     801038 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	eb 18                	jmp    801050 <memcmp+0x50>
		s1++, s2++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	8d 50 ff             	lea    -0x1(%eax),%edx
  801044:	89 55 10             	mov    %edx,0x10(%ebp)
  801047:	85 c0                	test   %eax,%eax
  801049:	75 c9                	jne    801014 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801063:	eb 15                	jmp    80107a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	39 c2                	cmp    %eax,%edx
  801075:	74 0d                	je     801084 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801080:	72 e3                	jb     801065 <memfind+0x13>
  801082:	eb 01                	jmp    801085 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801084:	90                   	nop
	return (void *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801097:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109e:	eb 03                	jmp    8010a3 <strtol+0x19>
		s++;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 20                	cmp    $0x20,%al
  8010aa:	74 f4                	je     8010a0 <strtol+0x16>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 eb                	je     8010a0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2b                	cmp    $0x2b,%al
  8010bc:	75 05                	jne    8010c3 <strtol+0x39>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	eb 13                	jmp    8010d6 <strtol+0x4c>
	else if (*s == '-')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2d                	cmp    $0x2d,%al
  8010ca:	75 0a                	jne    8010d6 <strtol+0x4c>
		s++, neg = 1;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 06                	je     8010e2 <strtol+0x58>
  8010dc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e0:	75 20                	jne    801102 <strtol+0x78>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 17                	jne    801102 <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	40                   	inc    %eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 78                	cmp    $0x78,%al
  8010f3:	75 0d                	jne    801102 <strtol+0x78>
		s += 2, base = 16;
  8010f5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801100:	eb 28                	jmp    80112a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	75 15                	jne    80111d <strtol+0x93>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 30                	cmp    $0x30,%al
  80110f:	75 0c                	jne    80111d <strtol+0x93>
		s++, base = 8;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111b:	eb 0d                	jmp    80112a <strtol+0xa0>
	else if (base == 0)
  80111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801121:	75 07                	jne    80112a <strtol+0xa0>
		base = 10;
  801123:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 2f                	cmp    $0x2f,%al
  801131:	7e 19                	jle    80114c <strtol+0xc2>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 39                	cmp    $0x39,%al
  80113a:	7f 10                	jg     80114c <strtol+0xc2>
			dig = *s - '0';
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 30             	sub    $0x30,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114a:	eb 42                	jmp    80118e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 60                	cmp    $0x60,%al
  801153:	7e 19                	jle    80116e <strtol+0xe4>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 7a                	cmp    $0x7a,%al
  80115c:	7f 10                	jg     80116e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	83 e8 57             	sub    $0x57,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116c:	eb 20                	jmp    80118e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 40                	cmp    $0x40,%al
  801175:	7e 39                	jle    8011b0 <strtol+0x126>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 5a                	cmp    $0x5a,%al
  80117e:	7f 30                	jg     8011b0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	83 e8 37             	sub    $0x37,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 10             	cmp    0x10(%ebp),%eax
  801194:	7d 19                	jge    8011af <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011aa:	e9 7b ff ff ff       	jmp    80112a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011af:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b4:	74 08                	je     8011be <strtol+0x134>
		*endptr = (char *) s;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 07                	je     8011cb <strtol+0x141>
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	f7 d8                	neg    %eax
  8011c9:	eb 03                	jmp    8011ce <strtol+0x144>
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e8:	79 13                	jns    8011fd <ltostr+0x2d>
	{
		neg = 1;
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801205:	99                   	cltd   
  801206:	f7 f9                	idiv   %ecx
  801208:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801214:	89 c2                	mov    %eax,%edx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121e:	83 c2 30             	add    $0x30,%edx
  801221:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122b:	f7 e9                	imul   %ecx
  80122d:	c1 fa 02             	sar    $0x2,%edx
  801230:	89 c8                	mov    %ecx,%eax
  801232:	c1 f8 1f             	sar    $0x1f,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80123c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801240:	75 bb                	jne    8011fd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801242:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	48                   	dec    %eax
  80124d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801250:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801254:	74 3d                	je     801293 <ltostr+0xc3>
		start = 1 ;
  801256:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80125d:	eb 34                	jmp    801293 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80125f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	01 d0                	add    %edx,%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80126c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 c2                	add    %eax,%edx
  801274:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	01 c8                	add    %ecx,%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801280:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 c2                	add    %eax,%edx
  801288:	8a 45 eb             	mov    -0x15(%ebp),%al
  80128b:	88 02                	mov    %al,(%edx)
		start++ ;
  80128d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801290:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801296:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801299:	7c c4                	jl     80125f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80129b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 d0                	add    %edx,%eax
  8012a3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a6:	90                   	nop
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012af:	ff 75 08             	pushl  0x8(%ebp)
  8012b2:	e8 c4 f9 ff ff       	call   800c7b <strlen>
  8012b7:	83 c4 04             	add    $0x4,%esp
  8012ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	e8 b6 f9 ff ff       	call   800c7b <strlen>
  8012c5:	83 c4 04             	add    $0x4,%esp
  8012c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d9:	eb 17                	jmp    8012f2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 c2                	add    %eax,%edx
  8012e3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	01 c8                	add    %ecx,%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ef:	ff 45 fc             	incl   -0x4(%ebp)
  8012f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f8:	7c e1                	jl     8012db <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801301:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801308:	eb 1f                	jmp    801329 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80130a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130d:	8d 50 01             	lea    0x1(%eax),%edx
  801310:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801313:	89 c2                	mov    %eax,%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 c2                	add    %eax,%edx
  80131a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80131d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801320:	01 c8                	add    %ecx,%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801326:	ff 45 f8             	incl   -0x8(%ebp)
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80132f:	7c d9                	jl     80130a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801331:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	c6 00 00             	movb   $0x0,(%eax)
}
  80133c:	90                   	nop
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	8b 00                	mov    (%eax),%eax
  801350:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801357:	8b 45 10             	mov    0x10(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801362:	eb 0c                	jmp    801370 <strsplit+0x31>
			*string++ = 0;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8d 50 01             	lea    0x1(%eax),%edx
  80136a:	89 55 08             	mov    %edx,0x8(%ebp)
  80136d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	84 c0                	test   %al,%al
  801377:	74 18                	je     801391 <strsplit+0x52>
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	0f be c0             	movsbl %al,%eax
  801381:	50                   	push   %eax
  801382:	ff 75 0c             	pushl  0xc(%ebp)
  801385:	e8 83 fa ff ff       	call   800e0d <strchr>
  80138a:	83 c4 08             	add    $0x8,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	75 d3                	jne    801364 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	84 c0                	test   %al,%al
  801398:	74 5a                	je     8013f4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80139a:	8b 45 14             	mov    0x14(%ebp),%eax
  80139d:	8b 00                	mov    (%eax),%eax
  80139f:	83 f8 0f             	cmp    $0xf,%eax
  8013a2:	75 07                	jne    8013ab <strsplit+0x6c>
		{
			return 0;
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a9:	eb 66                	jmp    801411 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ae:	8b 00                	mov    (%eax),%eax
  8013b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8013b3:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b6:	89 0a                	mov    %ecx,(%edx)
  8013b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c2:	01 c2                	add    %eax,%edx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c9:	eb 03                	jmp    8013ce <strsplit+0x8f>
			string++;
  8013cb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	84 c0                	test   %al,%al
  8013d5:	74 8b                	je     801362 <strsplit+0x23>
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	0f be c0             	movsbl %al,%eax
  8013df:	50                   	push   %eax
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	e8 25 fa ff ff       	call   800e0d <strchr>
  8013e8:	83 c4 08             	add    $0x8,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	74 dc                	je     8013cb <strsplit+0x8c>
			string++;
	}
  8013ef:	e9 6e ff ff ff       	jmp    801362 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013f4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f8:	8b 00                	mov    (%eax),%eax
  8013fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	01 d0                	add    %edx,%eax
  801406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80140c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80141f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801426:	eb 4a                	jmp    801472 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801428:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	01 c2                	add    %eax,%edx
  801430:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	01 c8                	add    %ecx,%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80143c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	01 d0                	add    %edx,%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	3c 40                	cmp    $0x40,%al
  801448:	7e 25                	jle    80146f <str2lower+0x5c>
  80144a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	8a 00                	mov    (%eax),%al
  801454:	3c 5a                	cmp    $0x5a,%al
  801456:	7f 17                	jg     80146f <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801458:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	01 d0                	add    %edx,%eax
  801460:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801463:	8b 55 08             	mov    0x8(%ebp),%edx
  801466:	01 ca                	add    %ecx,%edx
  801468:	8a 12                	mov    (%edx),%dl
  80146a:	83 c2 20             	add    $0x20,%edx
  80146d:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80146f:	ff 45 fc             	incl   -0x4(%ebp)
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	e8 01 f8 ff ff       	call   800c7b <strlen>
  80147a:	83 c4 04             	add    $0x4,%esp
  80147d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801480:	7f a6                	jg     801428 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801482:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80148d:	a1 08 50 80 00       	mov    0x805008,%eax
  801492:	85 c0                	test   %eax,%eax
  801494:	74 42                	je     8014d8 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801496:	83 ec 08             	sub    $0x8,%esp
  801499:	68 00 00 00 82       	push   $0x82000000
  80149e:	68 00 00 00 80       	push   $0x80000000
  8014a3:	e8 b0 1e 00 00       	call   803358 <initialize_dynamic_allocator>
  8014a8:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014ab:	e8 96 1c 00 00       	call   803146 <sys_get_uheap_strategy>
  8014b0:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014b5:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8014ba:	05 00 10 00 00       	add    $0x1000,%eax
  8014bf:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8014c4:	a1 30 51 83 00       	mov    0x835130,%eax
  8014c9:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8014ce:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8014d5:	00 00 00 
	}
}
  8014d8:	90                   	nop
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	68 06 04 00 00       	push   $0x406
  8014f7:	50                   	push   %eax
  8014f8:	e8 93 18 00 00       	call   802d90 <__sys_allocate_page>
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801503:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801507:	79 14                	jns    80151d <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	68 08 49 80 00       	push   $0x804908
  801511:	6a 1f                	push   $0x1f
  801513:	68 44 49 80 00       	push   $0x804944
  801518:	e8 8a 29 00 00       	call   803ea7 <_panic>
	return 0;
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801533:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801538:	83 ec 0c             	sub    $0xc,%esp
  80153b:	50                   	push   %eax
  80153c:	e8 96 18 00 00       	call   802dd7 <__sys_unmap_frame>
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801547:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80154b:	79 14                	jns    801561 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80154d:	83 ec 04             	sub    $0x4,%esp
  801550:	68 50 49 80 00       	push   $0x804950
  801555:	6a 2a                	push   $0x2a
  801557:	68 44 49 80 00       	push   $0x804944
  80155c:	e8 46 29 00 00       	call   803ea7 <_panic>
}
  801561:	90                   	nop
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80156a:	e8 18 ff ff ff       	call   801487 <uheap_init>
	if (size == 0) return NULL ;
  80156f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801573:	75 0a                	jne    80157f <malloc+0x1b>
  801575:	b8 00 00 00 00       	mov    $0x0,%eax
  80157a:	e9 43 03 00 00       	jmp    8018c2 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80157f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801586:	77 13                	ja     80159b <malloc+0x37>
    {
        return alloc_block(size);
  801588:	83 ec 0c             	sub    $0xc,%esp
  80158b:	ff 75 08             	pushl  0x8(%ebp)
  80158e:	e8 78 20 00 00       	call   80360b <alloc_block>
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	e9 27 03 00 00       	jmp    8018c2 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80159b:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8015a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a8:	01 d0                	add    %edx,%eax
  8015aa:	48                   	dec    %eax
  8015ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b6:	f7 75 dc             	divl   -0x24(%ebp)
  8015b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015bc:	29 d0                	sub    %edx,%eax
  8015be:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8015c1:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	75 0a                	jne    8015d4 <malloc+0x70>
    {
        uhp_inited = 1;
  8015ca:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  8015d1:	00 00 00 
    }

    int exactIdx = -1;
  8015d4:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8015db:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8015e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8015e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8015f0:	e9 85 00 00 00       	jmp    80167a <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8015f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015f8:	89 d0                	mov    %edx,%eax
  8015fa:	01 c0                	add    %eax,%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	c1 e0 02             	shl    $0x2,%eax
  801601:	05 48 10 81 00       	add    $0x811048,%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	84 c0                	test   %al,%al
  80160a:	74 20                	je     80162c <malloc+0xc8>
  80160c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80160f:	89 d0                	mov    %edx,%eax
  801611:	01 c0                	add    %eax,%eax
  801613:	01 d0                	add    %edx,%eax
  801615:	c1 e0 02             	shl    $0x2,%eax
  801618:	05 44 10 81 00       	add    $0x811044,%eax
  80161d:	8b 00                	mov    (%eax),%eax
  80161f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801622:	75 08                	jne    80162c <malloc+0xc8>
        {
            exactIdx = i;
  801624:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801627:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80162a:	eb 5b                	jmp    801687 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80162c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80162f:	89 d0                	mov    %edx,%eax
  801631:	01 c0                	add    %eax,%eax
  801633:	01 d0                	add    %edx,%eax
  801635:	c1 e0 02             	shl    $0x2,%eax
  801638:	05 48 10 81 00       	add    $0x811048,%eax
  80163d:	8a 00                	mov    (%eax),%al
  80163f:	84 c0                	test   %al,%al
  801641:	74 34                	je     801677 <malloc+0x113>
  801643:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801646:	89 d0                	mov    %edx,%eax
  801648:	01 c0                	add    %eax,%eax
  80164a:	01 d0                	add    %edx,%eax
  80164c:	c1 e0 02             	shl    $0x2,%eax
  80164f:	05 44 10 81 00       	add    $0x811044,%eax
  801654:	8b 00                	mov    (%eax),%eax
  801656:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801659:	76 1c                	jbe    801677 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  80165b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80165e:	89 d0                	mov    %edx,%eax
  801660:	01 c0                	add    %eax,%eax
  801662:	01 d0                	add    %edx,%eax
  801664:	c1 e0 02             	shl    $0x2,%eax
  801667:	05 44 10 81 00       	add    $0x811044,%eax
  80166c:	8b 00                	mov    (%eax),%eax
  80166e:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801671:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801674:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801677:	ff 45 e8             	incl   -0x18(%ebp)
  80167a:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801681:	0f 8e 6e ff ff ff    	jle    8015f5 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801687:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80168e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801692:	74 7d                	je     801711 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801694:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80169b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169e:	89 d0                	mov    %edx,%eax
  8016a0:	01 c0                	add    %eax,%eax
  8016a2:	01 d0                	add    %edx,%eax
  8016a4:	c1 e0 02             	shl    $0x2,%eax
  8016a7:	05 40 10 81 00       	add    $0x811040,%eax
  8016ac:	8b 10                	mov    (%eax),%edx
  8016ae:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8016b1:	01 d0                	add    %edx,%eax
  8016b3:	48                   	dec    %eax
  8016b4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8016b7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bf:	f7 75 bc             	divl   -0x44(%ebp)
  8016c2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016c5:	29 d0                	sub    %edx,%eax
  8016c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8016ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cd:	89 d0                	mov    %edx,%eax
  8016cf:	01 c0                	add    %eax,%eax
  8016d1:	01 d0                	add    %edx,%eax
  8016d3:	c1 e0 02             	shl    $0x2,%eax
  8016d6:	05 48 10 81 00       	add    $0x811048,%eax
  8016db:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8016de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e1:	89 d0                	mov    %edx,%eax
  8016e3:	01 c0                	add    %eax,%eax
  8016e5:	01 d0                	add    %edx,%eax
  8016e7:	c1 e0 02             	shl    $0x2,%eax
  8016ea:	05 44 10 81 00       	add    $0x811044,%eax
  8016ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8016f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f8:	89 d0                	mov    %edx,%eax
  8016fa:	01 c0                	add    %eax,%eax
  8016fc:	01 d0                	add    %edx,%eax
  8016fe:	c1 e0 02             	shl    $0x2,%eax
  801701:	05 40 10 81 00       	add    $0x811040,%eax
  801706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80170c:	e9 2d 01 00 00       	jmp    80183e <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801711:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801715:	0f 84 ce 00 00 00    	je     8017e9 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80171b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801722:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801725:	89 d0                	mov    %edx,%eax
  801727:	01 c0                	add    %eax,%eax
  801729:	01 d0                	add    %edx,%eax
  80172b:	c1 e0 02             	shl    $0x2,%eax
  80172e:	05 40 10 81 00       	add    $0x811040,%eax
  801733:	8b 10                	mov    (%eax),%edx
  801735:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801738:	01 d0                	add    %edx,%eax
  80173a:	48                   	dec    %eax
  80173b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80173e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801741:	ba 00 00 00 00       	mov    $0x0,%edx
  801746:	f7 75 c4             	divl   -0x3c(%ebp)
  801749:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80174c:	29 d0                	sub    %edx,%eax
  80174e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801751:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801754:	89 d0                	mov    %edx,%eax
  801756:	01 c0                	add    %eax,%eax
  801758:	01 d0                	add    %edx,%eax
  80175a:	c1 e0 02             	shl    $0x2,%eax
  80175d:	05 44 10 81 00       	add    $0x811044,%eax
  801762:	8b 00                	mov    (%eax),%eax
  801764:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801767:	75 47                	jne    8017b0 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801769:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80176c:	89 d0                	mov    %edx,%eax
  80176e:	01 c0                	add    %eax,%eax
  801770:	01 d0                	add    %edx,%eax
  801772:	c1 e0 02             	shl    $0x2,%eax
  801775:	05 48 10 81 00       	add    $0x811048,%eax
  80177a:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80177d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801780:	89 d0                	mov    %edx,%eax
  801782:	01 c0                	add    %eax,%eax
  801784:	01 d0                	add    %edx,%eax
  801786:	c1 e0 02             	shl    $0x2,%eax
  801789:	05 44 10 81 00       	add    $0x811044,%eax
  80178e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801794:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801797:	89 d0                	mov    %edx,%eax
  801799:	01 c0                	add    %eax,%eax
  80179b:	01 d0                	add    %edx,%eax
  80179d:	c1 e0 02             	shl    $0x2,%eax
  8017a0:	05 40 10 81 00       	add    $0x811040,%eax
  8017a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017ab:	e9 8e 00 00 00       	jmp    80183e <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8017b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017b6:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8017b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017bc:	89 d0                	mov    %edx,%eax
  8017be:	01 c0                	add    %eax,%eax
  8017c0:	01 d0                	add    %edx,%eax
  8017c2:	c1 e0 02             	shl    $0x2,%eax
  8017c5:	05 40 10 81 00       	add    $0x811040,%eax
  8017ca:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8017cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017cf:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017d2:	89 c2                	mov    %eax,%edx
  8017d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017d7:	89 c8                	mov    %ecx,%eax
  8017d9:	01 c0                	add    %eax,%eax
  8017db:	01 c8                	add    %ecx,%eax
  8017dd:	c1 e0 02             	shl    $0x2,%eax
  8017e0:	05 44 10 81 00       	add    $0x811044,%eax
  8017e5:	89 10                	mov    %edx,(%eax)
  8017e7:	eb 55                	jmp    80183e <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8017e9:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8017f0:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8017f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017f9:	01 d0                	add    %edx,%eax
  8017fb:	48                   	dec    %eax
  8017fc:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801802:	ba 00 00 00 00       	mov    $0x0,%edx
  801807:	f7 75 d0             	divl   -0x30(%ebp)
  80180a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80180d:	29 d0                	sub    %edx,%eax
  80180f:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801812:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801818:	01 d0                	add    %edx,%eax
  80181a:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80181f:	76 0a                	jbe    80182b <malloc+0x2c7>
            return NULL;
  801821:	b8 00 00 00 00       	mov    $0x0,%eax
  801826:	e9 97 00 00 00       	jmp    8018c2 <malloc+0x35e>
        va = start;
  80182b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80182e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801831:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801834:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80183e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801845:	eb 5e                	jmp    8018a5 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801847:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80184a:	89 d0                	mov    %edx,%eax
  80184c:	01 c0                	add    %eax,%eax
  80184e:	01 d0                	add    %edx,%eax
  801850:	c1 e0 02             	shl    $0x2,%eax
  801853:	05 48 50 80 00       	add    $0x805048,%eax
  801858:	8a 00                	mov    (%eax),%al
  80185a:	84 c0                	test   %al,%al
  80185c:	75 44                	jne    8018a2 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  80185e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801861:	89 d0                	mov    %edx,%eax
  801863:	01 c0                	add    %eax,%eax
  801865:	01 d0                	add    %edx,%eax
  801867:	c1 e0 02             	shl    $0x2,%eax
  80186a:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801873:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801875:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801878:	89 d0                	mov    %edx,%eax
  80187a:	01 c0                	add    %eax,%eax
  80187c:	01 d0                	add    %edx,%eax
  80187e:	c1 e0 02             	shl    $0x2,%eax
  801881:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801887:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80188a:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80188c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80188f:	89 d0                	mov    %edx,%eax
  801891:	01 c0                	add    %eax,%eax
  801893:	01 d0                	add    %edx,%eax
  801895:	c1 e0 02             	shl    $0x2,%eax
  801898:	05 48 50 80 00       	add    $0x805048,%eax
  80189d:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8018a0:	eb 0c                	jmp    8018ae <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8018a2:	ff 45 e0             	incl   -0x20(%ebp)
  8018a5:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8018ac:	7e 99                	jle    801847 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8018b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018b7:	e8 a2 19 00 00       	call   80325e <sys_allocate_user_mem>
  8018bc:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8018bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8018ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ce:	0f 84 fa 03 00 00    	je     801cce <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8018da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	79 1c                	jns    8018fd <free+0x39>
  8018e1:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  8018e8:	77 13                	ja     8018fd <free+0x39>
    {
        free_block(virtual_address);
  8018ea:	83 ec 0c             	sub    $0xc,%esp
  8018ed:	ff 75 08             	pushl  0x8(%ebp)
  8018f0:	e8 09 21 00 00       	call   8039fe <free_block>
  8018f5:	83 c4 10             	add    $0x10,%esp
        return;
  8018f8:	e9 d2 03 00 00       	jmp    801ccf <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8018fd:	a1 30 51 83 00       	mov    0x835130,%eax
  801902:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801905:	72 09                	jb     801910 <free+0x4c>
  801907:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  80190e:	76 17                	jbe    801927 <free+0x63>
        panic("free: invalid address");
  801910:	83 ec 04             	sub    $0x4,%esp
  801913:	68 8d 49 80 00       	push   $0x80498d
  801918:	68 9b 00 00 00       	push   $0x9b
  80191d:	68 44 49 80 00       	push   $0x804944
  801922:	e8 80 25 00 00       	call   803ea7 <_panic>

    uint32 size = 0;
  801927:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  80192e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801935:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80193c:	eb 50                	jmp    80198e <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80193e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801941:	89 d0                	mov    %edx,%eax
  801943:	01 c0                	add    %eax,%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	c1 e0 02             	shl    $0x2,%eax
  80194a:	05 48 50 80 00       	add    $0x805048,%eax
  80194f:	8a 00                	mov    (%eax),%al
  801951:	84 c0                	test   %al,%al
  801953:	74 36                	je     80198b <free+0xc7>
  801955:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801958:	89 d0                	mov    %edx,%eax
  80195a:	01 c0                	add    %eax,%eax
  80195c:	01 d0                	add    %edx,%eax
  80195e:	c1 e0 02             	shl    $0x2,%eax
  801961:	05 40 50 80 00       	add    $0x805040,%eax
  801966:	8b 00                	mov    (%eax),%eax
  801968:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80196b:	75 1e                	jne    80198b <free+0xc7>
        {
            size = uhp_allocs[i].size;
  80196d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801970:	89 d0                	mov    %edx,%eax
  801972:	01 c0                	add    %eax,%eax
  801974:	01 d0                	add    %edx,%eax
  801976:	c1 e0 02             	shl    $0x2,%eax
  801979:	05 44 50 80 00       	add    $0x805044,%eax
  80197e:	8b 00                	mov    (%eax),%eax
  801980:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801986:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801989:	eb 0c                	jmp    801997 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80198b:	ff 45 ec             	incl   -0x14(%ebp)
  80198e:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801995:	7e a7                	jle    80193e <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801997:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80199b:	74 06                	je     8019a3 <free+0xdf>
  80199d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019a1:	75 17                	jne    8019ba <free+0xf6>
        panic("free: unknown block");
  8019a3:	83 ec 04             	sub    $0x4,%esp
  8019a6:	68 a3 49 80 00       	push   $0x8049a3
  8019ab:	68 a9 00 00 00       	push   $0xa9
  8019b0:	68 44 49 80 00       	push   $0x804944
  8019b5:	e8 ed 24 00 00       	call   803ea7 <_panic>

    uhp_allocs[idx].used = 0;
  8019ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019bd:	89 d0                	mov    %edx,%eax
  8019bf:	01 c0                	add    %eax,%eax
  8019c1:	01 d0                	add    %edx,%eax
  8019c3:	c1 e0 02             	shl    $0x2,%eax
  8019c6:	05 48 50 80 00       	add    $0x805048,%eax
  8019cb:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8019ce:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8019dc:	eb 64                	jmp    801a42 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  8019de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019e1:	89 d0                	mov    %edx,%eax
  8019e3:	01 c0                	add    %eax,%eax
  8019e5:	01 d0                	add    %edx,%eax
  8019e7:	c1 e0 02             	shl    $0x2,%eax
  8019ea:	05 48 10 81 00       	add    $0x811048,%eax
  8019ef:	8a 00                	mov    (%eax),%al
  8019f1:	84 c0                	test   %al,%al
  8019f3:	75 4a                	jne    801a3f <free+0x17b>
        {
            uhp_frees[i].va = va;
  8019f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019f8:	89 d0                	mov    %edx,%eax
  8019fa:	01 c0                	add    %eax,%eax
  8019fc:	01 d0                	add    %edx,%eax
  8019fe:	c1 e0 02             	shl    $0x2,%eax
  801a01:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801a07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a0a:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801a0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a0f:	89 d0                	mov    %edx,%eax
  801a11:	01 c0                	add    %eax,%eax
  801a13:	01 d0                	add    %edx,%eax
  801a15:	c1 e0 02             	shl    $0x2,%eax
  801a18:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a21:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801a23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a26:	89 d0                	mov    %edx,%eax
  801a28:	01 c0                	add    %eax,%eax
  801a2a:	01 d0                	add    %edx,%eax
  801a2c:	c1 e0 02             	shl    $0x2,%eax
  801a2f:	05 48 10 81 00       	add    $0x811048,%eax
  801a34:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801a37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801a3d:	eb 0c                	jmp    801a4b <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a3f:	ff 45 e4             	incl   -0x1c(%ebp)
  801a42:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801a49:	7e 93                	jle    8019de <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801a4b:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801a4f:	0f 84 f1 01 00 00    	je     801c46 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a55:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a5c:	e9 d8 01 00 00       	jmp    801c39 <free+0x375>
        {
            if (i == fidx) continue;
  801a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a64:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a67:	0f 84 c8 01 00 00    	je     801c35 <free+0x371>
            if (uhp_frees[i].free)
  801a6d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a70:	89 d0                	mov    %edx,%eax
  801a72:	01 c0                	add    %eax,%eax
  801a74:	01 d0                	add    %edx,%eax
  801a76:	c1 e0 02             	shl    $0x2,%eax
  801a79:	05 48 10 81 00       	add    $0x811048,%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	84 c0                	test   %al,%al
  801a82:	0f 84 ae 01 00 00    	je     801c36 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801a88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a8b:	89 d0                	mov    %edx,%eax
  801a8d:	01 c0                	add    %eax,%eax
  801a8f:	01 d0                	add    %edx,%eax
  801a91:	c1 e0 02             	shl    $0x2,%eax
  801a94:	05 40 10 81 00       	add    $0x811040,%eax
  801a99:	8b 08                	mov    (%eax),%ecx
  801a9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a9e:	89 d0                	mov    %edx,%eax
  801aa0:	01 c0                	add    %eax,%eax
  801aa2:	01 d0                	add    %edx,%eax
  801aa4:	c1 e0 02             	shl    $0x2,%eax
  801aa7:	05 44 10 81 00       	add    $0x811044,%eax
  801aac:	8b 00                	mov    (%eax),%eax
  801aae:	01 c1                	add    %eax,%ecx
  801ab0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ab3:	89 d0                	mov    %edx,%eax
  801ab5:	01 c0                	add    %eax,%eax
  801ab7:	01 d0                	add    %edx,%eax
  801ab9:	c1 e0 02             	shl    $0x2,%eax
  801abc:	05 40 10 81 00       	add    $0x811040,%eax
  801ac1:	8b 00                	mov    (%eax),%eax
  801ac3:	39 c1                	cmp    %eax,%ecx
  801ac5:	0f 85 a8 00 00 00    	jne    801b73 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801acb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ace:	89 d0                	mov    %edx,%eax
  801ad0:	01 c0                	add    %eax,%eax
  801ad2:	01 d0                	add    %edx,%eax
  801ad4:	c1 e0 02             	shl    $0x2,%eax
  801ad7:	05 40 10 81 00       	add    $0x811040,%eax
  801adc:	8b 10                	mov    (%eax),%edx
  801ade:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801ae1:	89 c8                	mov    %ecx,%eax
  801ae3:	01 c0                	add    %eax,%eax
  801ae5:	01 c8                	add    %ecx,%eax
  801ae7:	c1 e0 02             	shl    $0x2,%eax
  801aea:	05 40 10 81 00       	add    $0x811040,%eax
  801aef:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801af1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801af4:	89 d0                	mov    %edx,%eax
  801af6:	01 c0                	add    %eax,%eax
  801af8:	01 d0                	add    %edx,%eax
  801afa:	c1 e0 02             	shl    $0x2,%eax
  801afd:	05 44 10 81 00       	add    $0x811044,%eax
  801b02:	8b 08                	mov    (%eax),%ecx
  801b04:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b07:	89 d0                	mov    %edx,%eax
  801b09:	01 c0                	add    %eax,%eax
  801b0b:	01 d0                	add    %edx,%eax
  801b0d:	c1 e0 02             	shl    $0x2,%eax
  801b10:	05 44 10 81 00       	add    $0x811044,%eax
  801b15:	8b 00                	mov    (%eax),%eax
  801b17:	01 c1                	add    %eax,%ecx
  801b19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b1c:	89 d0                	mov    %edx,%eax
  801b1e:	01 c0                	add    %eax,%eax
  801b20:	01 d0                	add    %edx,%eax
  801b22:	c1 e0 02             	shl    $0x2,%eax
  801b25:	05 44 10 81 00       	add    $0x811044,%eax
  801b2a:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801b2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b2f:	89 d0                	mov    %edx,%eax
  801b31:	01 c0                	add    %eax,%eax
  801b33:	01 d0                	add    %edx,%eax
  801b35:	c1 e0 02             	shl    $0x2,%eax
  801b38:	05 48 10 81 00       	add    $0x811048,%eax
  801b3d:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801b40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b43:	89 d0                	mov    %edx,%eax
  801b45:	01 c0                	add    %eax,%eax
  801b47:	01 d0                	add    %edx,%eax
  801b49:	c1 e0 02             	shl    $0x2,%eax
  801b4c:	05 40 10 81 00       	add    $0x811040,%eax
  801b51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801b57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b5a:	89 d0                	mov    %edx,%eax
  801b5c:	01 c0                	add    %eax,%eax
  801b5e:	01 d0                	add    %edx,%eax
  801b60:	c1 e0 02             	shl    $0x2,%eax
  801b63:	05 44 10 81 00       	add    $0x811044,%eax
  801b68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b6e:	e9 c3 00 00 00       	jmp    801c36 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801b73:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b76:	89 d0                	mov    %edx,%eax
  801b78:	01 c0                	add    %eax,%eax
  801b7a:	01 d0                	add    %edx,%eax
  801b7c:	c1 e0 02             	shl    $0x2,%eax
  801b7f:	05 40 10 81 00       	add    $0x811040,%eax
  801b84:	8b 08                	mov    (%eax),%ecx
  801b86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b89:	89 d0                	mov    %edx,%eax
  801b8b:	01 c0                	add    %eax,%eax
  801b8d:	01 d0                	add    %edx,%eax
  801b8f:	c1 e0 02             	shl    $0x2,%eax
  801b92:	05 44 10 81 00       	add    $0x811044,%eax
  801b97:	8b 00                	mov    (%eax),%eax
  801b99:	01 c1                	add    %eax,%ecx
  801b9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b9e:	89 d0                	mov    %edx,%eax
  801ba0:	01 c0                	add    %eax,%eax
  801ba2:	01 d0                	add    %edx,%eax
  801ba4:	c1 e0 02             	shl    $0x2,%eax
  801ba7:	05 40 10 81 00       	add    $0x811040,%eax
  801bac:	8b 00                	mov    (%eax),%eax
  801bae:	39 c1                	cmp    %eax,%ecx
  801bb0:	0f 85 80 00 00 00    	jne    801c36 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801bb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bb9:	89 d0                	mov    %edx,%eax
  801bbb:	01 c0                	add    %eax,%eax
  801bbd:	01 d0                	add    %edx,%eax
  801bbf:	c1 e0 02             	shl    $0x2,%eax
  801bc2:	05 44 10 81 00       	add    $0x811044,%eax
  801bc7:	8b 08                	mov    (%eax),%ecx
  801bc9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bcc:	89 d0                	mov    %edx,%eax
  801bce:	01 c0                	add    %eax,%eax
  801bd0:	01 d0                	add    %edx,%eax
  801bd2:	c1 e0 02             	shl    $0x2,%eax
  801bd5:	05 44 10 81 00       	add    $0x811044,%eax
  801bda:	8b 00                	mov    (%eax),%eax
  801bdc:	01 c1                	add    %eax,%ecx
  801bde:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801be1:	89 d0                	mov    %edx,%eax
  801be3:	01 c0                	add    %eax,%eax
  801be5:	01 d0                	add    %edx,%eax
  801be7:	c1 e0 02             	shl    $0x2,%eax
  801bea:	05 44 10 81 00       	add    $0x811044,%eax
  801bef:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801bf1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bf4:	89 d0                	mov    %edx,%eax
  801bf6:	01 c0                	add    %eax,%eax
  801bf8:	01 d0                	add    %edx,%eax
  801bfa:	c1 e0 02             	shl    $0x2,%eax
  801bfd:	05 48 10 81 00       	add    $0x811048,%eax
  801c02:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801c05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c08:	89 d0                	mov    %edx,%eax
  801c0a:	01 c0                	add    %eax,%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c1 e0 02             	shl    $0x2,%eax
  801c11:	05 40 10 81 00       	add    $0x811040,%eax
  801c16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801c1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c1f:	89 d0                	mov    %edx,%eax
  801c21:	01 c0                	add    %eax,%eax
  801c23:	01 d0                	add    %edx,%eax
  801c25:	c1 e0 02             	shl    $0x2,%eax
  801c28:	05 44 10 81 00       	add    $0x811044,%eax
  801c2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c33:	eb 01                	jmp    801c36 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801c35:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c36:	ff 45 e0             	incl   -0x20(%ebp)
  801c39:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801c40:	0f 8e 1b fe ff ff    	jle    801a61 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801c46:	a1 30 51 83 00       	mov    0x835130,%eax
  801c4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c4e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801c55:	eb 53                	jmp    801caa <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801c57:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c5a:	89 d0                	mov    %edx,%eax
  801c5c:	01 c0                	add    %eax,%eax
  801c5e:	01 d0                	add    %edx,%eax
  801c60:	c1 e0 02             	shl    $0x2,%eax
  801c63:	05 48 50 80 00       	add    $0x805048,%eax
  801c68:	8a 00                	mov    (%eax),%al
  801c6a:	84 c0                	test   %al,%al
  801c6c:	74 39                	je     801ca7 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801c6e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c71:	89 d0                	mov    %edx,%eax
  801c73:	01 c0                	add    %eax,%eax
  801c75:	01 d0                	add    %edx,%eax
  801c77:	c1 e0 02             	shl    $0x2,%eax
  801c7a:	05 40 50 80 00       	add    $0x805040,%eax
  801c7f:	8b 08                	mov    (%eax),%ecx
  801c81:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c84:	89 d0                	mov    %edx,%eax
  801c86:	01 c0                	add    %eax,%eax
  801c88:	01 d0                	add    %edx,%eax
  801c8a:	c1 e0 02             	shl    $0x2,%eax
  801c8d:	05 44 50 80 00       	add    $0x805044,%eax
  801c92:	8b 00                	mov    (%eax),%eax
  801c94:	01 c8                	add    %ecx,%eax
  801c96:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801c99:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c9c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801c9f:	76 06                	jbe    801ca7 <free+0x3e3>
  801ca1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ca4:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ca7:	ff 45 d8             	incl   -0x28(%ebp)
  801caa:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801cb1:	7e a4                	jle    801c57 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801cb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cb6:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801cbb:	83 ec 08             	sub    $0x8,%esp
  801cbe:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc1:	ff 75 d4             	pushl  -0x2c(%ebp)
  801cc4:	e8 79 15 00 00       	call   803242 <sys_free_user_mem>
  801cc9:	83 c4 10             	add    $0x10,%esp
  801ccc:	eb 01                	jmp    801ccf <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801cce:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	83 ec 68             	sub    $0x68,%esp
  801cd7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cda:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cdd:	e8 a5 f7 ff ff       	call   801487 <uheap_init>
	if (size == 0) return NULL ;
  801ce2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ce6:	75 0a                	jne    801cf2 <smalloc+0x21>
  801ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ced:	e9 37 03 00 00       	jmp    802029 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801cf2:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cff:	01 d0                	add    %edx,%eax
  801d01:	48                   	dec    %eax
  801d02:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d05:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d08:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0d:	f7 75 dc             	divl   -0x24(%ebp)
  801d10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d13:	29 d0                	sub    %edx,%eax
  801d15:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801d18:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801d1f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801d26:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d2d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d34:	e9 85 00 00 00       	jmp    801dbe <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801d39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d3c:	89 d0                	mov    %edx,%eax
  801d3e:	01 c0                	add    %eax,%eax
  801d40:	01 d0                	add    %edx,%eax
  801d42:	c1 e0 02             	shl    $0x2,%eax
  801d45:	05 48 10 81 00       	add    $0x811048,%eax
  801d4a:	8a 00                	mov    (%eax),%al
  801d4c:	84 c0                	test   %al,%al
  801d4e:	74 20                	je     801d70 <smalloc+0x9f>
  801d50:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d53:	89 d0                	mov    %edx,%eax
  801d55:	01 c0                	add    %eax,%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	c1 e0 02             	shl    $0x2,%eax
  801d5c:	05 44 10 81 00       	add    $0x811044,%eax
  801d61:	8b 00                	mov    (%eax),%eax
  801d63:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d66:	75 08                	jne    801d70 <smalloc+0x9f>
        {
            exactIdx = i;
  801d68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801d6e:	eb 5b                	jmp    801dcb <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801d70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d73:	89 d0                	mov    %edx,%eax
  801d75:	01 c0                	add    %eax,%eax
  801d77:	01 d0                	add    %edx,%eax
  801d79:	c1 e0 02             	shl    $0x2,%eax
  801d7c:	05 48 10 81 00       	add    $0x811048,%eax
  801d81:	8a 00                	mov    (%eax),%al
  801d83:	84 c0                	test   %al,%al
  801d85:	74 34                	je     801dbb <smalloc+0xea>
  801d87:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d8a:	89 d0                	mov    %edx,%eax
  801d8c:	01 c0                	add    %eax,%eax
  801d8e:	01 d0                	add    %edx,%eax
  801d90:	c1 e0 02             	shl    $0x2,%eax
  801d93:	05 44 10 81 00       	add    $0x811044,%eax
  801d98:	8b 00                	mov    (%eax),%eax
  801d9a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d9d:	76 1c                	jbe    801dbb <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801d9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801da2:	89 d0                	mov    %edx,%eax
  801da4:	01 c0                	add    %eax,%eax
  801da6:	01 d0                	add    %edx,%eax
  801da8:	c1 e0 02             	shl    $0x2,%eax
  801dab:	05 44 10 81 00       	add    $0x811044,%eax
  801db0:	8b 00                	mov    (%eax),%eax
  801db2:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801db5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801db8:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801dbb:	ff 45 e8             	incl   -0x18(%ebp)
  801dbe:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801dc5:	0f 8e 6e ff ff ff    	jle    801d39 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801dcb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801dd2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801dd6:	74 7d                	je     801e55 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801dd8:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de2:	89 d0                	mov    %edx,%eax
  801de4:	01 c0                	add    %eax,%eax
  801de6:	01 d0                	add    %edx,%eax
  801de8:	c1 e0 02             	shl    $0x2,%eax
  801deb:	05 40 10 81 00       	add    $0x811040,%eax
  801df0:	8b 10                	mov    (%eax),%edx
  801df2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801df5:	01 d0                	add    %edx,%eax
  801df7:	48                   	dec    %eax
  801df8:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801dfb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801dfe:	ba 00 00 00 00       	mov    $0x0,%edx
  801e03:	f7 75 bc             	divl   -0x44(%ebp)
  801e06:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e09:	29 d0                	sub    %edx,%eax
  801e0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e11:	89 d0                	mov    %edx,%eax
  801e13:	01 c0                	add    %eax,%eax
  801e15:	01 d0                	add    %edx,%eax
  801e17:	c1 e0 02             	shl    $0x2,%eax
  801e1a:	05 48 10 81 00       	add    $0x811048,%eax
  801e1f:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801e22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e25:	89 d0                	mov    %edx,%eax
  801e27:	01 c0                	add    %eax,%eax
  801e29:	01 d0                	add    %edx,%eax
  801e2b:	c1 e0 02             	shl    $0x2,%eax
  801e2e:	05 44 10 81 00       	add    $0x811044,%eax
  801e33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801e39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3c:	89 d0                	mov    %edx,%eax
  801e3e:	01 c0                	add    %eax,%eax
  801e40:	01 d0                	add    %edx,%eax
  801e42:	c1 e0 02             	shl    $0x2,%eax
  801e45:	05 40 10 81 00       	add    $0x811040,%eax
  801e4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e50:	e9 2d 01 00 00       	jmp    801f82 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801e55:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e59:	0f 84 ce 00 00 00    	je     801f2d <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801e5f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801e66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e69:	89 d0                	mov    %edx,%eax
  801e6b:	01 c0                	add    %eax,%eax
  801e6d:	01 d0                	add    %edx,%eax
  801e6f:	c1 e0 02             	shl    $0x2,%eax
  801e72:	05 40 10 81 00       	add    $0x811040,%eax
  801e77:	8b 10                	mov    (%eax),%edx
  801e79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e7c:	01 d0                	add    %edx,%eax
  801e7e:	48                   	dec    %eax
  801e7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801e82:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e85:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8a:	f7 75 c4             	divl   -0x3c(%ebp)
  801e8d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e90:	29 d0                	sub    %edx,%eax
  801e92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801e95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e98:	89 d0                	mov    %edx,%eax
  801e9a:	01 c0                	add    %eax,%eax
  801e9c:	01 d0                	add    %edx,%eax
  801e9e:	c1 e0 02             	shl    $0x2,%eax
  801ea1:	05 44 10 81 00       	add    $0x811044,%eax
  801ea6:	8b 00                	mov    (%eax),%eax
  801ea8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801eab:	75 47                	jne    801ef4 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801ead:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eb0:	89 d0                	mov    %edx,%eax
  801eb2:	01 c0                	add    %eax,%eax
  801eb4:	01 d0                	add    %edx,%eax
  801eb6:	c1 e0 02             	shl    $0x2,%eax
  801eb9:	05 48 10 81 00       	add    $0x811048,%eax
  801ebe:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801ec1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ec4:	89 d0                	mov    %edx,%eax
  801ec6:	01 c0                	add    %eax,%eax
  801ec8:	01 d0                	add    %edx,%eax
  801eca:	c1 e0 02             	shl    $0x2,%eax
  801ecd:	05 44 10 81 00       	add    $0x811044,%eax
  801ed2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801ed8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801edb:	89 d0                	mov    %edx,%eax
  801edd:	01 c0                	add    %eax,%eax
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	c1 e0 02             	shl    $0x2,%eax
  801ee4:	05 40 10 81 00       	add    $0x811040,%eax
  801ee9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801eef:	e9 8e 00 00 00       	jmp    801f82 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801ef4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ef7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801efa:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801efd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f00:	89 d0                	mov    %edx,%eax
  801f02:	01 c0                	add    %eax,%eax
  801f04:	01 d0                	add    %edx,%eax
  801f06:	c1 e0 02             	shl    $0x2,%eax
  801f09:	05 40 10 81 00       	add    $0x811040,%eax
  801f0e:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801f10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f13:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f16:	89 c2                	mov    %eax,%edx
  801f18:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f1b:	89 c8                	mov    %ecx,%eax
  801f1d:	01 c0                	add    %eax,%eax
  801f1f:	01 c8                	add    %ecx,%eax
  801f21:	c1 e0 02             	shl    $0x2,%eax
  801f24:	05 44 10 81 00       	add    $0x811044,%eax
  801f29:	89 10                	mov    %edx,(%eax)
  801f2b:	eb 55                	jmp    801f82 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801f2d:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801f34:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801f3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f3d:	01 d0                	add    %edx,%eax
  801f3f:	48                   	dec    %eax
  801f40:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801f43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f46:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4b:	f7 75 d0             	divl   -0x30(%ebp)
  801f4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f51:	29 d0                	sub    %edx,%eax
  801f53:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801f56:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f5c:	01 d0                	add    %edx,%eax
  801f5e:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f63:	76 0a                	jbe    801f6f <smalloc+0x29e>
            return NULL;
  801f65:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6a:	e9 ba 00 00 00       	jmp    802029 <smalloc+0x358>
        va = start;
  801f6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801f75:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f7b:	01 d0                	add    %edx,%eax
  801f7d:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f82:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f89:	eb 5e                	jmp    801fe9 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  801f8b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f8e:	89 d0                	mov    %edx,%eax
  801f90:	01 c0                	add    %eax,%eax
  801f92:	01 d0                	add    %edx,%eax
  801f94:	c1 e0 02             	shl    $0x2,%eax
  801f97:	05 48 50 80 00       	add    $0x805048,%eax
  801f9c:	8a 00                	mov    (%eax),%al
  801f9e:	84 c0                	test   %al,%al
  801fa0:	75 44                	jne    801fe6 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  801fa2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fa5:	89 d0                	mov    %edx,%eax
  801fa7:	01 c0                	add    %eax,%eax
  801fa9:	01 d0                	add    %edx,%eax
  801fab:	c1 e0 02             	shl    $0x2,%eax
  801fae:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801fb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fb7:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801fb9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fbc:	89 d0                	mov    %edx,%eax
  801fbe:	01 c0                	add    %eax,%eax
  801fc0:	01 d0                	add    %edx,%eax
  801fc2:	c1 e0 02             	shl    $0x2,%eax
  801fc5:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801fcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fce:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801fd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fd3:	89 d0                	mov    %edx,%eax
  801fd5:	01 c0                	add    %eax,%eax
  801fd7:	01 d0                	add    %edx,%eax
  801fd9:	c1 e0 02             	shl    $0x2,%eax
  801fdc:	05 48 50 80 00       	add    $0x805048,%eax
  801fe1:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801fe4:	eb 0c                	jmp    801ff2 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fe6:	ff 45 e0             	incl   -0x20(%ebp)
  801fe9:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801ff0:	7e 99                	jle    801f8b <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  801ff2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ff5:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  801ff9:	52                   	push   %edx
  801ffa:	50                   	push   %eax
  801ffb:	ff 75 d4             	pushl  -0x2c(%ebp)
  801ffe:	ff 75 08             	pushl  0x8(%ebp)
  802001:	e8 de 0e 00 00       	call   802ee4 <sys_create_shared_object>
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  80200c:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802010:	75 07                	jne    802019 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802012:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802017:	eb 10                	jmp    802029 <smalloc+0x358>
    if (r < 0)
  802019:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80201d:	79 07                	jns    802026 <smalloc+0x355>
        return NULL;
  80201f:	b8 00 00 00 00       	mov    $0x0,%eax
  802024:	eb 03                	jmp    802029 <smalloc+0x358>
    return (void*)va;
  802026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802031:	e8 51 f4 ff ff       	call   801487 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802036:	83 ec 08             	sub    $0x8,%esp
  802039:	ff 75 0c             	pushl  0xc(%ebp)
  80203c:	ff 75 08             	pushl  0x8(%ebp)
  80203f:	e8 ca 0e 00 00       	call   802f0e <sys_size_of_shared_object>
  802044:	83 c4 10             	add    $0x10,%esp
  802047:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  80204a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80204e:	7f 0a                	jg     80205a <sget+0x2f>
        return NULL;
  802050:	b8 00 00 00 00       	mov    $0x0,%eax
  802055:	e9 28 03 00 00       	jmp    802382 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80205a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802061:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802064:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802067:	01 d0                	add    %edx,%eax
  802069:	48                   	dec    %eax
  80206a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80206d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802070:	ba 00 00 00 00       	mov    $0x0,%edx
  802075:	f7 75 d8             	divl   -0x28(%ebp)
  802078:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80207b:	29 d0                	sub    %edx,%eax
  80207d:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802080:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802087:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80208e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802095:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80209c:	e9 85 00 00 00       	jmp    802126 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8020a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020a4:	89 d0                	mov    %edx,%eax
  8020a6:	01 c0                	add    %eax,%eax
  8020a8:	01 d0                	add    %edx,%eax
  8020aa:	c1 e0 02             	shl    $0x2,%eax
  8020ad:	05 48 10 81 00       	add    $0x811048,%eax
  8020b2:	8a 00                	mov    (%eax),%al
  8020b4:	84 c0                	test   %al,%al
  8020b6:	74 20                	je     8020d8 <sget+0xad>
  8020b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020bb:	89 d0                	mov    %edx,%eax
  8020bd:	01 c0                	add    %eax,%eax
  8020bf:	01 d0                	add    %edx,%eax
  8020c1:	c1 e0 02             	shl    $0x2,%eax
  8020c4:	05 44 10 81 00       	add    $0x811044,%eax
  8020c9:	8b 00                	mov    (%eax),%eax
  8020cb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020ce:	75 08                	jne    8020d8 <sget+0xad>
        {
            exactIdx = i;
  8020d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8020d6:	eb 5b                	jmp    802133 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8020d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020db:	89 d0                	mov    %edx,%eax
  8020dd:	01 c0                	add    %eax,%eax
  8020df:	01 d0                	add    %edx,%eax
  8020e1:	c1 e0 02             	shl    $0x2,%eax
  8020e4:	05 48 10 81 00       	add    $0x811048,%eax
  8020e9:	8a 00                	mov    (%eax),%al
  8020eb:	84 c0                	test   %al,%al
  8020ed:	74 34                	je     802123 <sget+0xf8>
  8020ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020f2:	89 d0                	mov    %edx,%eax
  8020f4:	01 c0                	add    %eax,%eax
  8020f6:	01 d0                	add    %edx,%eax
  8020f8:	c1 e0 02             	shl    $0x2,%eax
  8020fb:	05 44 10 81 00       	add    $0x811044,%eax
  802100:	8b 00                	mov    (%eax),%eax
  802102:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802105:	76 1c                	jbe    802123 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802107:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80210a:	89 d0                	mov    %edx,%eax
  80210c:	01 c0                	add    %eax,%eax
  80210e:	01 d0                	add    %edx,%eax
  802110:	c1 e0 02             	shl    $0x2,%eax
  802113:	05 44 10 81 00       	add    $0x811044,%eax
  802118:	8b 00                	mov    (%eax),%eax
  80211a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80211d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802120:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802123:	ff 45 e8             	incl   -0x18(%ebp)
  802126:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80212d:	0f 8e 6e ff ff ff    	jle    8020a1 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802133:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80213a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80213e:	74 7d                	je     8021bd <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802140:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214a:	89 d0                	mov    %edx,%eax
  80214c:	01 c0                	add    %eax,%eax
  80214e:	01 d0                	add    %edx,%eax
  802150:	c1 e0 02             	shl    $0x2,%eax
  802153:	05 40 10 81 00       	add    $0x811040,%eax
  802158:	8b 10                	mov    (%eax),%edx
  80215a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80215d:	01 d0                	add    %edx,%eax
  80215f:	48                   	dec    %eax
  802160:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802163:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802166:	ba 00 00 00 00       	mov    $0x0,%edx
  80216b:	f7 75 b8             	divl   -0x48(%ebp)
  80216e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802171:	29 d0                	sub    %edx,%eax
  802173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802176:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802179:	89 d0                	mov    %edx,%eax
  80217b:	01 c0                	add    %eax,%eax
  80217d:	01 d0                	add    %edx,%eax
  80217f:	c1 e0 02             	shl    $0x2,%eax
  802182:	05 48 10 81 00       	add    $0x811048,%eax
  802187:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80218a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218d:	89 d0                	mov    %edx,%eax
  80218f:	01 c0                	add    %eax,%eax
  802191:	01 d0                	add    %edx,%eax
  802193:	c1 e0 02             	shl    $0x2,%eax
  802196:	05 44 10 81 00       	add    $0x811044,%eax
  80219b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8021a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a4:	89 d0                	mov    %edx,%eax
  8021a6:	01 c0                	add    %eax,%eax
  8021a8:	01 d0                	add    %edx,%eax
  8021aa:	c1 e0 02             	shl    $0x2,%eax
  8021ad:	05 40 10 81 00       	add    $0x811040,%eax
  8021b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021b8:	e9 2d 01 00 00       	jmp    8022ea <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8021bd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021c1:	0f 84 ce 00 00 00    	je     802295 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8021c7:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8021ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021d1:	89 d0                	mov    %edx,%eax
  8021d3:	01 c0                	add    %eax,%eax
  8021d5:	01 d0                	add    %edx,%eax
  8021d7:	c1 e0 02             	shl    $0x2,%eax
  8021da:	05 40 10 81 00       	add    $0x811040,%eax
  8021df:	8b 10                	mov    (%eax),%edx
  8021e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021e4:	01 d0                	add    %edx,%eax
  8021e6:	48                   	dec    %eax
  8021e7:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8021ea:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8021f2:	f7 75 c0             	divl   -0x40(%ebp)
  8021f5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021f8:	29 d0                	sub    %edx,%eax
  8021fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8021fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802200:	89 d0                	mov    %edx,%eax
  802202:	01 c0                	add    %eax,%eax
  802204:	01 d0                	add    %edx,%eax
  802206:	c1 e0 02             	shl    $0x2,%eax
  802209:	05 44 10 81 00       	add    $0x811044,%eax
  80220e:	8b 00                	mov    (%eax),%eax
  802210:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802213:	75 47                	jne    80225c <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802218:	89 d0                	mov    %edx,%eax
  80221a:	01 c0                	add    %eax,%eax
  80221c:	01 d0                	add    %edx,%eax
  80221e:	c1 e0 02             	shl    $0x2,%eax
  802221:	05 48 10 81 00       	add    $0x811048,%eax
  802226:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802229:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80222c:	89 d0                	mov    %edx,%eax
  80222e:	01 c0                	add    %eax,%eax
  802230:	01 d0                	add    %edx,%eax
  802232:	c1 e0 02             	shl    $0x2,%eax
  802235:	05 44 10 81 00       	add    $0x811044,%eax
  80223a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802240:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802243:	89 d0                	mov    %edx,%eax
  802245:	01 c0                	add    %eax,%eax
  802247:	01 d0                	add    %edx,%eax
  802249:	c1 e0 02             	shl    $0x2,%eax
  80224c:	05 40 10 81 00       	add    $0x811040,%eax
  802251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802257:	e9 8e 00 00 00       	jmp    8022ea <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80225c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80225f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802262:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802265:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802268:	89 d0                	mov    %edx,%eax
  80226a:	01 c0                	add    %eax,%eax
  80226c:	01 d0                	add    %edx,%eax
  80226e:	c1 e0 02             	shl    $0x2,%eax
  802271:	05 40 10 81 00       	add    $0x811040,%eax
  802276:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802278:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227b:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80227e:	89 c2                	mov    %eax,%edx
  802280:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802283:	89 c8                	mov    %ecx,%eax
  802285:	01 c0                	add    %eax,%eax
  802287:	01 c8                	add    %ecx,%eax
  802289:	c1 e0 02             	shl    $0x2,%eax
  80228c:	05 44 10 81 00       	add    $0x811044,%eax
  802291:	89 10                	mov    %edx,(%eax)
  802293:	eb 55                	jmp    8022ea <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802295:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80229c:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8022a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8022a5:	01 d0                	add    %edx,%eax
  8022a7:	48                   	dec    %eax
  8022a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8022ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8022b3:	f7 75 cc             	divl   -0x34(%ebp)
  8022b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022b9:	29 d0                	sub    %edx,%eax
  8022bb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8022be:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8022c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022c4:	01 d0                	add    %edx,%eax
  8022c6:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8022cb:	76 0a                	jbe    8022d7 <sget+0x2ac>
            return NULL;
  8022cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d2:	e9 ab 00 00 00       	jmp    802382 <sget+0x357>
        va = start;
  8022d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8022da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8022dd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8022e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022e3:	01 d0                	add    %edx,%eax
  8022e5:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022ea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8022f1:	eb 5e                	jmp    802351 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8022f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022f6:	89 d0                	mov    %edx,%eax
  8022f8:	01 c0                	add    %eax,%eax
  8022fa:	01 d0                	add    %edx,%eax
  8022fc:	c1 e0 02             	shl    $0x2,%eax
  8022ff:	05 48 50 80 00       	add    $0x805048,%eax
  802304:	8a 00                	mov    (%eax),%al
  802306:	84 c0                	test   %al,%al
  802308:	75 44                	jne    80234e <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80230a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80230d:	89 d0                	mov    %edx,%eax
  80230f:	01 c0                	add    %eax,%eax
  802311:	01 d0                	add    %edx,%eax
  802313:	c1 e0 02             	shl    $0x2,%eax
  802316:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80231c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80231f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802321:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802324:	89 d0                	mov    %edx,%eax
  802326:	01 c0                	add    %eax,%eax
  802328:	01 d0                	add    %edx,%eax
  80232a:	c1 e0 02             	shl    $0x2,%eax
  80232d:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802333:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802336:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802338:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80233b:	89 d0                	mov    %edx,%eax
  80233d:	01 c0                	add    %eax,%eax
  80233f:	01 d0                	add    %edx,%eax
  802341:	c1 e0 02             	shl    $0x2,%eax
  802344:	05 48 50 80 00       	add    $0x805048,%eax
  802349:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80234c:	eb 0c                	jmp    80235a <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80234e:	ff 45 e0             	incl   -0x20(%ebp)
  802351:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802358:	7e 99                	jle    8022f3 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  80235a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80235d:	83 ec 04             	sub    $0x4,%esp
  802360:	50                   	push   %eax
  802361:	ff 75 0c             	pushl  0xc(%ebp)
  802364:	ff 75 08             	pushl  0x8(%ebp)
  802367:	e8 bf 0b 00 00       	call   802f2b <sys_get_shared_object>
  80236c:	83 c4 10             	add    $0x10,%esp
  80236f:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802372:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802376:	79 07                	jns    80237f <sget+0x354>
        return NULL;
  802378:	b8 00 00 00 00       	mov    $0x0,%eax
  80237d:	eb 03                	jmp    802382 <sget+0x357>
    return (void*)va;
  80237f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80238a:	e8 f8 f0 ff ff       	call   801487 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  80238f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802393:	75 13                	jne    8023a8 <realloc+0x24>
		return malloc(new_size);
  802395:	83 ec 0c             	sub    $0xc,%esp
  802398:	ff 75 0c             	pushl  0xc(%ebp)
  80239b:	e8 c4 f1 ff ff       	call   801564 <malloc>
  8023a0:	83 c4 10             	add    $0x10,%esp
  8023a3:	e9 f4 05 00 00       	jmp    80299c <realloc+0x618>
	if (new_size == 0)
  8023a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023ac:	75 18                	jne    8023c6 <realloc+0x42>
	{
		free(virtual_address);
  8023ae:	83 ec 0c             	sub    $0xc,%esp
  8023b1:	ff 75 08             	pushl  0x8(%ebp)
  8023b4:	e8 0b f5 ff ff       	call   8018c4 <free>
  8023b9:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8023bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c1:	e9 d6 05 00 00       	jmp    80299c <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8023cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	79 74                	jns    802447 <realloc+0xc3>
  8023d3:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8023da:	77 6b                	ja     802447 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  8023dc:	83 ec 0c             	sub    $0xc,%esp
  8023df:	ff 75 0c             	pushl  0xc(%ebp)
  8023e2:	e8 7d f1 ff ff       	call   801564 <malloc>
  8023e7:	83 c4 10             	add    $0x10,%esp
  8023ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8023ed:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8023f1:	75 0a                	jne    8023fd <realloc+0x79>
			return NULL;
  8023f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f8:	e9 9f 05 00 00       	jmp    80299c <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8023fd:	83 ec 0c             	sub    $0xc,%esp
  802400:	ff 75 08             	pushl  0x8(%ebp)
  802403:	e8 e0 11 00 00       	call   8035e8 <get_block_size>
  802408:	83 c4 10             	add    $0x10,%esp
  80240b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  80240e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802411:	8b 45 0c             	mov    0xc(%ebp),%eax
  802414:	39 d0                	cmp    %edx,%eax
  802416:	76 02                	jbe    80241a <realloc+0x96>
  802418:	89 d0                	mov    %edx,%eax
  80241a:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  80241d:	83 ec 04             	sub    $0x4,%esp
  802420:	ff 75 c0             	pushl  -0x40(%ebp)
  802423:	ff 75 08             	pushl  0x8(%ebp)
  802426:	ff 75 c8             	pushl  -0x38(%ebp)
  802429:	e8 56 eb ff ff       	call   800f84 <memmove>
  80242e:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802431:	83 ec 0c             	sub    $0xc,%esp
  802434:	ff 75 08             	pushl  0x8(%ebp)
  802437:	e8 88 f4 ff ff       	call   8018c4 <free>
  80243c:	83 c4 10             	add    $0x10,%esp
		return newptr;
  80243f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802442:	e9 55 05 00 00       	jmp    80299c <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802447:	a1 30 51 83 00       	mov    0x835130,%eax
  80244c:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  80244f:	72 09                	jb     80245a <realloc+0xd6>
  802451:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802458:	76 0a                	jbe    802464 <realloc+0xe0>
		return NULL;
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	e9 38 05 00 00       	jmp    80299c <realloc+0x618>
	uint32 oldsz = 0;
  802464:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  80246b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802472:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802479:	eb 50                	jmp    8024cb <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80247b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80247e:	89 d0                	mov    %edx,%eax
  802480:	01 c0                	add    %eax,%eax
  802482:	01 d0                	add    %edx,%eax
  802484:	c1 e0 02             	shl    $0x2,%eax
  802487:	05 48 50 80 00       	add    $0x805048,%eax
  80248c:	8a 00                	mov    (%eax),%al
  80248e:	84 c0                	test   %al,%al
  802490:	74 36                	je     8024c8 <realloc+0x144>
  802492:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802495:	89 d0                	mov    %edx,%eax
  802497:	01 c0                	add    %eax,%eax
  802499:	01 d0                	add    %edx,%eax
  80249b:	c1 e0 02             	shl    $0x2,%eax
  80249e:	05 40 50 80 00       	add    $0x805040,%eax
  8024a3:	8b 00                	mov    (%eax),%eax
  8024a5:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8024a8:	75 1e                	jne    8024c8 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  8024aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024ad:	89 d0                	mov    %edx,%eax
  8024af:	01 c0                	add    %eax,%eax
  8024b1:	01 d0                	add    %edx,%eax
  8024b3:	c1 e0 02             	shl    $0x2,%eax
  8024b6:	05 44 50 80 00       	add    $0x805044,%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8024c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8024c6:	eb 0c                	jmp    8024d4 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024c8:	ff 45 ec             	incl   -0x14(%ebp)
  8024cb:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8024d2:	7e a7                	jle    80247b <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8024d4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8024d8:	75 0a                	jne    8024e4 <realloc+0x160>
		return NULL;
  8024da:	b8 00 00 00 00       	mov    $0x0,%eax
  8024df:	e9 b8 04 00 00       	jmp    80299c <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  8024e4:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8024eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ee:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	48                   	dec    %eax
  8024f4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8024f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ff:	f7 75 bc             	divl   -0x44(%ebp)
  802502:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802505:	29 d0                	sub    %edx,%eax
  802507:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  80250a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80250d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802510:	75 08                	jne    80251a <realloc+0x196>
		return virtual_address;
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	e9 82 04 00 00       	jmp    80299c <realloc+0x618>
	if (req < oldsz)
  80251a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80251d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802520:	0f 83 cd 02 00 00    	jae    8027f3 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  80252c:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  80252f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802532:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802535:	01 d0                	add    %edx,%eax
  802537:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  80253a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80253d:	89 d0                	mov    %edx,%eax
  80253f:	01 c0                	add    %eax,%eax
  802541:	01 d0                	add    %edx,%eax
  802543:	c1 e0 02             	shl    $0x2,%eax
  802546:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80254c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80254f:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802551:	83 ec 08             	sub    $0x8,%esp
  802554:	ff 75 b0             	pushl  -0x50(%ebp)
  802557:	ff 75 ac             	pushl  -0x54(%ebp)
  80255a:	e8 e3 0c 00 00       	call   803242 <sys_free_user_mem>
  80255f:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802562:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802569:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802570:	eb 64                	jmp    8025d6 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802572:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802575:	89 d0                	mov    %edx,%eax
  802577:	01 c0                	add    %eax,%eax
  802579:	01 d0                	add    %edx,%eax
  80257b:	c1 e0 02             	shl    $0x2,%eax
  80257e:	05 48 10 81 00       	add    $0x811048,%eax
  802583:	8a 00                	mov    (%eax),%al
  802585:	84 c0                	test   %al,%al
  802587:	75 4a                	jne    8025d3 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802589:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80258c:	89 d0                	mov    %edx,%eax
  80258e:	01 c0                	add    %eax,%eax
  802590:	01 d0                	add    %edx,%eax
  802592:	c1 e0 02             	shl    $0x2,%eax
  802595:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  80259b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80259e:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  8025a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a3:	89 d0                	mov    %edx,%eax
  8025a5:	01 c0                	add    %eax,%eax
  8025a7:	01 d0                	add    %edx,%eax
  8025a9:	c1 e0 02             	shl    $0x2,%eax
  8025ac:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  8025b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b5:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  8025b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025ba:	89 d0                	mov    %edx,%eax
  8025bc:	01 c0                	add    %eax,%eax
  8025be:	01 d0                	add    %edx,%eax
  8025c0:	c1 e0 02             	shl    $0x2,%eax
  8025c3:	05 48 10 81 00       	add    $0x811048,%eax
  8025c8:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8025cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8025d1:	eb 0c                	jmp    8025df <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8025d3:	ff 45 e4             	incl   -0x1c(%ebp)
  8025d6:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8025dd:	7e 93                	jle    802572 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  8025df:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8025e3:	0f 84 8d 01 00 00    	je     802776 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8025e9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8025f0:	e9 74 01 00 00       	jmp    802769 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8025f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025fb:	0f 84 64 01 00 00    	je     802765 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802601:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802604:	89 d0                	mov    %edx,%eax
  802606:	01 c0                	add    %eax,%eax
  802608:	01 d0                	add    %edx,%eax
  80260a:	c1 e0 02             	shl    $0x2,%eax
  80260d:	05 48 10 81 00       	add    $0x811048,%eax
  802612:	8a 00                	mov    (%eax),%al
  802614:	84 c0                	test   %al,%al
  802616:	0f 84 4a 01 00 00    	je     802766 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80261c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80261f:	89 d0                	mov    %edx,%eax
  802621:	01 c0                	add    %eax,%eax
  802623:	01 d0                	add    %edx,%eax
  802625:	c1 e0 02             	shl    $0x2,%eax
  802628:	05 40 10 81 00       	add    $0x811040,%eax
  80262d:	8b 08                	mov    (%eax),%ecx
  80262f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802632:	89 d0                	mov    %edx,%eax
  802634:	01 c0                	add    %eax,%eax
  802636:	01 d0                	add    %edx,%eax
  802638:	c1 e0 02             	shl    $0x2,%eax
  80263b:	05 44 10 81 00       	add    $0x811044,%eax
  802640:	8b 00                	mov    (%eax),%eax
  802642:	01 c1                	add    %eax,%ecx
  802644:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802647:	89 d0                	mov    %edx,%eax
  802649:	01 c0                	add    %eax,%eax
  80264b:	01 d0                	add    %edx,%eax
  80264d:	c1 e0 02             	shl    $0x2,%eax
  802650:	05 40 10 81 00       	add    $0x811040,%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	39 c1                	cmp    %eax,%ecx
  802659:	75 7a                	jne    8026d5 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  80265b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80265e:	89 d0                	mov    %edx,%eax
  802660:	01 c0                	add    %eax,%eax
  802662:	01 d0                	add    %edx,%eax
  802664:	c1 e0 02             	shl    $0x2,%eax
  802667:	05 40 10 81 00       	add    $0x811040,%eax
  80266c:	8b 10                	mov    (%eax),%edx
  80266e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802671:	89 c8                	mov    %ecx,%eax
  802673:	01 c0                	add    %eax,%eax
  802675:	01 c8                	add    %ecx,%eax
  802677:	c1 e0 02             	shl    $0x2,%eax
  80267a:	05 40 10 81 00       	add    $0x811040,%eax
  80267f:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802681:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802684:	89 d0                	mov    %edx,%eax
  802686:	01 c0                	add    %eax,%eax
  802688:	01 d0                	add    %edx,%eax
  80268a:	c1 e0 02             	shl    $0x2,%eax
  80268d:	05 44 10 81 00       	add    $0x811044,%eax
  802692:	8b 08                	mov    (%eax),%ecx
  802694:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802697:	89 d0                	mov    %edx,%eax
  802699:	01 c0                	add    %eax,%eax
  80269b:	01 d0                	add    %edx,%eax
  80269d:	c1 e0 02             	shl    $0x2,%eax
  8026a0:	05 44 10 81 00       	add    $0x811044,%eax
  8026a5:	8b 00                	mov    (%eax),%eax
  8026a7:	01 c1                	add    %eax,%ecx
  8026a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ac:	89 d0                	mov    %edx,%eax
  8026ae:	01 c0                	add    %eax,%eax
  8026b0:	01 d0                	add    %edx,%eax
  8026b2:	c1 e0 02             	shl    $0x2,%eax
  8026b5:	05 44 10 81 00       	add    $0x811044,%eax
  8026ba:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8026bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026bf:	89 d0                	mov    %edx,%eax
  8026c1:	01 c0                	add    %eax,%eax
  8026c3:	01 d0                	add    %edx,%eax
  8026c5:	c1 e0 02             	shl    $0x2,%eax
  8026c8:	05 48 10 81 00       	add    $0x811048,%eax
  8026cd:	c6 00 00             	movb   $0x0,(%eax)
  8026d0:	e9 91 00 00 00       	jmp    802766 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8026d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026d8:	89 d0                	mov    %edx,%eax
  8026da:	01 c0                	add    %eax,%eax
  8026dc:	01 d0                	add    %edx,%eax
  8026de:	c1 e0 02             	shl    $0x2,%eax
  8026e1:	05 40 10 81 00       	add    $0x811040,%eax
  8026e6:	8b 08                	mov    (%eax),%ecx
  8026e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026eb:	89 d0                	mov    %edx,%eax
  8026ed:	01 c0                	add    %eax,%eax
  8026ef:	01 d0                	add    %edx,%eax
  8026f1:	c1 e0 02             	shl    $0x2,%eax
  8026f4:	05 44 10 81 00       	add    $0x811044,%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	01 c1                	add    %eax,%ecx
  8026fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802700:	89 d0                	mov    %edx,%eax
  802702:	01 c0                	add    %eax,%eax
  802704:	01 d0                	add    %edx,%eax
  802706:	c1 e0 02             	shl    $0x2,%eax
  802709:	05 40 10 81 00       	add    $0x811040,%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	39 c1                	cmp    %eax,%ecx
  802712:	75 52                	jne    802766 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802714:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802717:	89 d0                	mov    %edx,%eax
  802719:	01 c0                	add    %eax,%eax
  80271b:	01 d0                	add    %edx,%eax
  80271d:	c1 e0 02             	shl    $0x2,%eax
  802720:	05 44 10 81 00       	add    $0x811044,%eax
  802725:	8b 08                	mov    (%eax),%ecx
  802727:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80272a:	89 d0                	mov    %edx,%eax
  80272c:	01 c0                	add    %eax,%eax
  80272e:	01 d0                	add    %edx,%eax
  802730:	c1 e0 02             	shl    $0x2,%eax
  802733:	05 44 10 81 00       	add    $0x811044,%eax
  802738:	8b 00                	mov    (%eax),%eax
  80273a:	01 c1                	add    %eax,%ecx
  80273c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80273f:	89 d0                	mov    %edx,%eax
  802741:	01 c0                	add    %eax,%eax
  802743:	01 d0                	add    %edx,%eax
  802745:	c1 e0 02             	shl    $0x2,%eax
  802748:	05 44 10 81 00       	add    $0x811044,%eax
  80274d:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80274f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802752:	89 d0                	mov    %edx,%eax
  802754:	01 c0                	add    %eax,%eax
  802756:	01 d0                	add    %edx,%eax
  802758:	c1 e0 02             	shl    $0x2,%eax
  80275b:	05 48 10 81 00       	add    $0x811048,%eax
  802760:	c6 00 00             	movb   $0x0,(%eax)
  802763:	eb 01                	jmp    802766 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802765:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802766:	ff 45 e0             	incl   -0x20(%ebp)
  802769:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802770:	0f 8e 7f fe ff ff    	jle    8025f5 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802776:	a1 30 51 83 00       	mov    0x835130,%eax
  80277b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80277e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802785:	eb 53                	jmp    8027da <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802787:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80278a:	89 d0                	mov    %edx,%eax
  80278c:	01 c0                	add    %eax,%eax
  80278e:	01 d0                	add    %edx,%eax
  802790:	c1 e0 02             	shl    $0x2,%eax
  802793:	05 48 50 80 00       	add    $0x805048,%eax
  802798:	8a 00                	mov    (%eax),%al
  80279a:	84 c0                	test   %al,%al
  80279c:	74 39                	je     8027d7 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80279e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027a1:	89 d0                	mov    %edx,%eax
  8027a3:	01 c0                	add    %eax,%eax
  8027a5:	01 d0                	add    %edx,%eax
  8027a7:	c1 e0 02             	shl    $0x2,%eax
  8027aa:	05 40 50 80 00       	add    $0x805040,%eax
  8027af:	8b 08                	mov    (%eax),%ecx
  8027b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027b4:	89 d0                	mov    %edx,%eax
  8027b6:	01 c0                	add    %eax,%eax
  8027b8:	01 d0                	add    %edx,%eax
  8027ba:	c1 e0 02             	shl    $0x2,%eax
  8027bd:	05 44 50 80 00       	add    $0x805044,%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	01 c8                	add    %ecx,%eax
  8027c6:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8027c9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027cc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8027cf:	76 06                	jbe    8027d7 <realloc+0x453>
  8027d1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8027d7:	ff 45 d8             	incl   -0x28(%ebp)
  8027da:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8027e1:	7e a4                	jle    802787 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  8027e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027e6:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	e9 a9 01 00 00       	jmp    80299c <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8027f3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	01 d0                	add    %edx,%eax
  8027fb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8027fe:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802805:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80280c:	eb 57                	jmp    802865 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  80280e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802811:	89 d0                	mov    %edx,%eax
  802813:	01 c0                	add    %eax,%eax
  802815:	01 d0                	add    %edx,%eax
  802817:	c1 e0 02             	shl    $0x2,%eax
  80281a:	05 48 10 81 00       	add    $0x811048,%eax
  80281f:	8a 00                	mov    (%eax),%al
  802821:	84 c0                	test   %al,%al
  802823:	74 3d                	je     802862 <realloc+0x4de>
  802825:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802828:	89 d0                	mov    %edx,%eax
  80282a:	01 c0                	add    %eax,%eax
  80282c:	01 d0                	add    %edx,%eax
  80282e:	c1 e0 02             	shl    $0x2,%eax
  802831:	05 40 10 81 00       	add    $0x811040,%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80283b:	75 25                	jne    802862 <realloc+0x4de>
  80283d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802840:	89 d0                	mov    %edx,%eax
  802842:	01 c0                	add    %eax,%eax
  802844:	01 d0                	add    %edx,%eax
  802846:	c1 e0 02             	shl    $0x2,%eax
  802849:	05 44 10 81 00       	add    $0x811044,%eax
  80284e:	8b 10                	mov    (%eax),%edx
  802850:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802853:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802856:	39 c2                	cmp    %eax,%edx
  802858:	72 08                	jb     802862 <realloc+0x4de>
		{
			adjIdx = j; break;
  80285a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80285d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802860:	eb 0c                	jmp    80286e <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802862:	ff 45 d0             	incl   -0x30(%ebp)
  802865:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  80286c:	7e a0                	jle    80280e <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  80286e:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802872:	0f 84 d6 00 00 00    	je     80294e <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802878:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80287b:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80287e:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802881:	83 ec 08             	sub    $0x8,%esp
  802884:	ff 75 a0             	pushl  -0x60(%ebp)
  802887:	ff 75 a4             	pushl  -0x5c(%ebp)
  80288a:	e8 cf 09 00 00       	call   80325e <sys_allocate_user_mem>
  80288f:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802892:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802895:	89 d0                	mov    %edx,%eax
  802897:	01 c0                	add    %eax,%eax
  802899:	01 d0                	add    %edx,%eax
  80289b:	c1 e0 02             	shl    $0x2,%eax
  80289e:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8028a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028a7:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  8028a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028ac:	89 d0                	mov    %edx,%eax
  8028ae:	01 c0                	add    %eax,%eax
  8028b0:	01 d0                	add    %edx,%eax
  8028b2:	c1 e0 02             	shl    $0x2,%eax
  8028b5:	05 40 10 81 00       	add    $0x811040,%eax
  8028ba:	8b 10                	mov    (%eax),%edx
  8028bc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8028bf:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8028c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028c5:	89 d0                	mov    %edx,%eax
  8028c7:	01 c0                	add    %eax,%eax
  8028c9:	01 d0                	add    %edx,%eax
  8028cb:	c1 e0 02             	shl    $0x2,%eax
  8028ce:	05 40 10 81 00       	add    $0x811040,%eax
  8028d3:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8028d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028d8:	89 d0                	mov    %edx,%eax
  8028da:	01 c0                	add    %eax,%eax
  8028dc:	01 d0                	add    %edx,%eax
  8028de:	c1 e0 02             	shl    $0x2,%eax
  8028e1:	05 44 10 81 00       	add    $0x811044,%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	2b 45 a0             	sub    -0x60(%ebp),%eax
  8028eb:	89 c2                	mov    %eax,%edx
  8028ed:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8028f0:	89 c8                	mov    %ecx,%eax
  8028f2:	01 c0                	add    %eax,%eax
  8028f4:	01 c8                	add    %ecx,%eax
  8028f6:	c1 e0 02             	shl    $0x2,%eax
  8028f9:	05 44 10 81 00       	add    $0x811044,%eax
  8028fe:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802900:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802903:	89 d0                	mov    %edx,%eax
  802905:	01 c0                	add    %eax,%eax
  802907:	01 d0                	add    %edx,%eax
  802909:	c1 e0 02             	shl    $0x2,%eax
  80290c:	05 44 10 81 00       	add    $0x811044,%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	85 c0                	test   %eax,%eax
  802915:	75 14                	jne    80292b <realloc+0x5a7>
  802917:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80291a:	89 d0                	mov    %edx,%eax
  80291c:	01 c0                	add    %eax,%eax
  80291e:	01 d0                	add    %edx,%eax
  802920:	c1 e0 02             	shl    $0x2,%eax
  802923:	05 48 10 81 00       	add    $0x811048,%eax
  802928:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  80292b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80292e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802931:	01 c2                	add    %eax,%edx
  802933:	a1 88 50 83 00       	mov    0x835088,%eax
  802938:	39 c2                	cmp    %eax,%edx
  80293a:	76 0d                	jbe    802949 <realloc+0x5c5>
  80293c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80293f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802942:	01 d0                	add    %edx,%eax
  802944:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802949:	8b 45 08             	mov    0x8(%ebp),%eax
  80294c:	eb 4e                	jmp    80299c <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  80294e:	83 ec 0c             	sub    $0xc,%esp
  802951:	ff 75 0c             	pushl  0xc(%ebp)
  802954:	e8 0b ec ff ff       	call   801564 <malloc>
  802959:	83 c4 10             	add    $0x10,%esp
  80295c:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  80295f:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802963:	75 07                	jne    80296c <realloc+0x5e8>
		return NULL;
  802965:	b8 00 00 00 00       	mov    $0x0,%eax
  80296a:	eb 30                	jmp    80299c <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  80296c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802972:	39 d0                	cmp    %edx,%eax
  802974:	76 02                	jbe    802978 <realloc+0x5f4>
  802976:	89 d0                	mov    %edx,%eax
  802978:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80297b:	83 ec 04             	sub    $0x4,%esp
  80297e:	50                   	push   %eax
  80297f:	52                   	push   %edx
  802980:	ff 75 cc             	pushl  -0x34(%ebp)
  802983:	e8 cf 06 00 00       	call   803057 <sys_move_user_mem>
  802988:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  80298b:	83 ec 0c             	sub    $0xc,%esp
  80298e:	ff 75 08             	pushl  0x8(%ebp)
  802991:	e8 2e ef ff ff       	call   8018c4 <free>
  802996:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802999:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  80299c:	c9                   	leave  
  80299d:	c3                   	ret    

0080299e <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80299e:	55                   	push   %ebp
  80299f:	89 e5                	mov    %esp,%ebp
  8029a1:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  8029aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8029ae:	0f 84 33 03 00 00    	je     802ce7 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  8029b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029b7:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  8029bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8029bf:	83 ec 08             	sub    $0x8,%esp
  8029c2:	ff 75 08             	pushl  0x8(%ebp)
  8029c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8029c8:	e8 7d 05 00 00       	call   802f4a <sys_delete_shared_object>
  8029cd:	83 c4 10             	add    $0x10,%esp
  8029d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8029d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8029d7:	0f 88 0d 03 00 00    	js     802cea <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029e4:	e9 ef 02 00 00       	jmp    802cd8 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8029e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ec:	89 d0                	mov    %edx,%eax
  8029ee:	01 c0                	add    %eax,%eax
  8029f0:	01 d0                	add    %edx,%eax
  8029f2:	c1 e0 02             	shl    $0x2,%eax
  8029f5:	05 48 50 80 00       	add    $0x805048,%eax
  8029fa:	8a 00                	mov    (%eax),%al
  8029fc:	84 c0                	test   %al,%al
  8029fe:	0f 84 d1 02 00 00    	je     802cd5 <sfree+0x337>
  802a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a07:	89 d0                	mov    %edx,%eax
  802a09:	01 c0                	add    %eax,%eax
  802a0b:	01 d0                	add    %edx,%eax
  802a0d:	c1 e0 02             	shl    $0x2,%eax
  802a10:	05 40 50 80 00       	add    $0x805040,%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802a1a:	0f 85 b5 02 00 00    	jne    802cd5 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a23:	89 d0                	mov    %edx,%eax
  802a25:	01 c0                	add    %eax,%eax
  802a27:	01 d0                	add    %edx,%eax
  802a29:	c1 e0 02             	shl    $0x2,%eax
  802a2c:	05 44 50 80 00       	add    $0x805044,%eax
  802a31:	8b 00                	mov    (%eax),%eax
  802a33:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a39:	89 d0                	mov    %edx,%eax
  802a3b:	01 c0                	add    %eax,%eax
  802a3d:	01 d0                	add    %edx,%eax
  802a3f:	c1 e0 02             	shl    $0x2,%eax
  802a42:	05 48 50 80 00       	add    $0x805048,%eax
  802a47:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802a4a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a51:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802a58:	eb 64                	jmp    802abe <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802a5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a5d:	89 d0                	mov    %edx,%eax
  802a5f:	01 c0                	add    %eax,%eax
  802a61:	01 d0                	add    %edx,%eax
  802a63:	c1 e0 02             	shl    $0x2,%eax
  802a66:	05 48 10 81 00       	add    $0x811048,%eax
  802a6b:	8a 00                	mov    (%eax),%al
  802a6d:	84 c0                	test   %al,%al
  802a6f:	75 4a                	jne    802abb <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802a71:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a74:	89 d0                	mov    %edx,%eax
  802a76:	01 c0                	add    %eax,%eax
  802a78:	01 d0                	add    %edx,%eax
  802a7a:	c1 e0 02             	shl    $0x2,%eax
  802a7d:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802a83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a86:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802a88:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a8b:	89 d0                	mov    %edx,%eax
  802a8d:	01 c0                	add    %eax,%eax
  802a8f:	01 d0                	add    %edx,%eax
  802a91:	c1 e0 02             	shl    $0x2,%eax
  802a94:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802a9a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a9d:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802a9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aa2:	89 d0                	mov    %edx,%eax
  802aa4:	01 c0                	add    %eax,%eax
  802aa6:	01 d0                	add    %edx,%eax
  802aa8:	c1 e0 02             	shl    $0x2,%eax
  802aab:	05 48 10 81 00       	add    $0x811048,%eax
  802ab0:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802ab9:	eb 0c                	jmp    802ac7 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802abb:	ff 45 ec             	incl   -0x14(%ebp)
  802abe:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802ac5:	7e 93                	jle    802a5a <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802ac7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802acb:	0f 84 8d 01 00 00    	je     802c5e <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ad1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802ad8:	e9 74 01 00 00       	jmp    802c51 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ae3:	0f 84 64 01 00 00    	je     802c4d <sfree+0x2af>
					if (uhp_frees[k].free)
  802ae9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aec:	89 d0                	mov    %edx,%eax
  802aee:	01 c0                	add    %eax,%eax
  802af0:	01 d0                	add    %edx,%eax
  802af2:	c1 e0 02             	shl    $0x2,%eax
  802af5:	05 48 10 81 00       	add    $0x811048,%eax
  802afa:	8a 00                	mov    (%eax),%al
  802afc:	84 c0                	test   %al,%al
  802afe:	0f 84 4a 01 00 00    	je     802c4e <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802b04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b07:	89 d0                	mov    %edx,%eax
  802b09:	01 c0                	add    %eax,%eax
  802b0b:	01 d0                	add    %edx,%eax
  802b0d:	c1 e0 02             	shl    $0x2,%eax
  802b10:	05 40 10 81 00       	add    $0x811040,%eax
  802b15:	8b 08                	mov    (%eax),%ecx
  802b17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b1a:	89 d0                	mov    %edx,%eax
  802b1c:	01 c0                	add    %eax,%eax
  802b1e:	01 d0                	add    %edx,%eax
  802b20:	c1 e0 02             	shl    $0x2,%eax
  802b23:	05 44 10 81 00       	add    $0x811044,%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	01 c1                	add    %eax,%ecx
  802b2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2f:	89 d0                	mov    %edx,%eax
  802b31:	01 c0                	add    %eax,%eax
  802b33:	01 d0                	add    %edx,%eax
  802b35:	c1 e0 02             	shl    $0x2,%eax
  802b38:	05 40 10 81 00       	add    $0x811040,%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	39 c1                	cmp    %eax,%ecx
  802b41:	75 7a                	jne    802bbd <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802b43:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b46:	89 d0                	mov    %edx,%eax
  802b48:	01 c0                	add    %eax,%eax
  802b4a:	01 d0                	add    %edx,%eax
  802b4c:	c1 e0 02             	shl    $0x2,%eax
  802b4f:	05 40 10 81 00       	add    $0x811040,%eax
  802b54:	8b 10                	mov    (%eax),%edx
  802b56:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b59:	89 c8                	mov    %ecx,%eax
  802b5b:	01 c0                	add    %eax,%eax
  802b5d:	01 c8                	add    %ecx,%eax
  802b5f:	c1 e0 02             	shl    $0x2,%eax
  802b62:	05 40 10 81 00       	add    $0x811040,%eax
  802b67:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802b69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6c:	89 d0                	mov    %edx,%eax
  802b6e:	01 c0                	add    %eax,%eax
  802b70:	01 d0                	add    %edx,%eax
  802b72:	c1 e0 02             	shl    $0x2,%eax
  802b75:	05 44 10 81 00       	add    $0x811044,%eax
  802b7a:	8b 08                	mov    (%eax),%ecx
  802b7c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b7f:	89 d0                	mov    %edx,%eax
  802b81:	01 c0                	add    %eax,%eax
  802b83:	01 d0                	add    %edx,%eax
  802b85:	c1 e0 02             	shl    $0x2,%eax
  802b88:	05 44 10 81 00       	add    $0x811044,%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	01 c1                	add    %eax,%ecx
  802b91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b94:	89 d0                	mov    %edx,%eax
  802b96:	01 c0                	add    %eax,%eax
  802b98:	01 d0                	add    %edx,%eax
  802b9a:	c1 e0 02             	shl    $0x2,%eax
  802b9d:	05 44 10 81 00       	add    $0x811044,%eax
  802ba2:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802ba4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ba7:	89 d0                	mov    %edx,%eax
  802ba9:	01 c0                	add    %eax,%eax
  802bab:	01 d0                	add    %edx,%eax
  802bad:	c1 e0 02             	shl    $0x2,%eax
  802bb0:	05 48 10 81 00       	add    $0x811048,%eax
  802bb5:	c6 00 00             	movb   $0x0,(%eax)
  802bb8:	e9 91 00 00 00       	jmp    802c4e <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802bbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc0:	89 d0                	mov    %edx,%eax
  802bc2:	01 c0                	add    %eax,%eax
  802bc4:	01 d0                	add    %edx,%eax
  802bc6:	c1 e0 02             	shl    $0x2,%eax
  802bc9:	05 40 10 81 00       	add    $0x811040,%eax
  802bce:	8b 08                	mov    (%eax),%ecx
  802bd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd3:	89 d0                	mov    %edx,%eax
  802bd5:	01 c0                	add    %eax,%eax
  802bd7:	01 d0                	add    %edx,%eax
  802bd9:	c1 e0 02             	shl    $0x2,%eax
  802bdc:	05 44 10 81 00       	add    $0x811044,%eax
  802be1:	8b 00                	mov    (%eax),%eax
  802be3:	01 c1                	add    %eax,%ecx
  802be5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802be8:	89 d0                	mov    %edx,%eax
  802bea:	01 c0                	add    %eax,%eax
  802bec:	01 d0                	add    %edx,%eax
  802bee:	c1 e0 02             	shl    $0x2,%eax
  802bf1:	05 40 10 81 00       	add    $0x811040,%eax
  802bf6:	8b 00                	mov    (%eax),%eax
  802bf8:	39 c1                	cmp    %eax,%ecx
  802bfa:	75 52                	jne    802c4e <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802bfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bff:	89 d0                	mov    %edx,%eax
  802c01:	01 c0                	add    %eax,%eax
  802c03:	01 d0                	add    %edx,%eax
  802c05:	c1 e0 02             	shl    $0x2,%eax
  802c08:	05 44 10 81 00       	add    $0x811044,%eax
  802c0d:	8b 08                	mov    (%eax),%ecx
  802c0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c12:	89 d0                	mov    %edx,%eax
  802c14:	01 c0                	add    %eax,%eax
  802c16:	01 d0                	add    %edx,%eax
  802c18:	c1 e0 02             	shl    $0x2,%eax
  802c1b:	05 44 10 81 00       	add    $0x811044,%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	01 c1                	add    %eax,%ecx
  802c24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c27:	89 d0                	mov    %edx,%eax
  802c29:	01 c0                	add    %eax,%eax
  802c2b:	01 d0                	add    %edx,%eax
  802c2d:	c1 e0 02             	shl    $0x2,%eax
  802c30:	05 44 10 81 00       	add    $0x811044,%eax
  802c35:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802c37:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c3a:	89 d0                	mov    %edx,%eax
  802c3c:	01 c0                	add    %eax,%eax
  802c3e:	01 d0                	add    %edx,%eax
  802c40:	c1 e0 02             	shl    $0x2,%eax
  802c43:	05 48 10 81 00       	add    $0x811048,%eax
  802c48:	c6 00 00             	movb   $0x0,(%eax)
  802c4b:	eb 01                	jmp    802c4e <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802c4d:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c4e:	ff 45 e8             	incl   -0x18(%ebp)
  802c51:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802c58:	0f 8e 7f fe ff ff    	jle    802add <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802c5e:	a1 30 51 83 00       	mov    0x835130,%eax
  802c63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802c66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802c6d:	eb 53                	jmp    802cc2 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802c6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c72:	89 d0                	mov    %edx,%eax
  802c74:	01 c0                	add    %eax,%eax
  802c76:	01 d0                	add    %edx,%eax
  802c78:	c1 e0 02             	shl    $0x2,%eax
  802c7b:	05 48 50 80 00       	add    $0x805048,%eax
  802c80:	8a 00                	mov    (%eax),%al
  802c82:	84 c0                	test   %al,%al
  802c84:	74 39                	je     802cbf <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802c86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c89:	89 d0                	mov    %edx,%eax
  802c8b:	01 c0                	add    %eax,%eax
  802c8d:	01 d0                	add    %edx,%eax
  802c8f:	c1 e0 02             	shl    $0x2,%eax
  802c92:	05 40 50 80 00       	add    $0x805040,%eax
  802c97:	8b 08                	mov    (%eax),%ecx
  802c99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c9c:	89 d0                	mov    %edx,%eax
  802c9e:	01 c0                	add    %eax,%eax
  802ca0:	01 d0                	add    %edx,%eax
  802ca2:	c1 e0 02             	shl    $0x2,%eax
  802ca5:	05 44 50 80 00       	add    $0x805044,%eax
  802caa:	8b 00                	mov    (%eax),%eax
  802cac:	01 c8                	add    %ecx,%eax
  802cae:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802cb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cb7:	76 06                	jbe    802cbf <sfree+0x321>
  802cb9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802cbf:	ff 45 e0             	incl   -0x20(%ebp)
  802cc2:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802cc9:	7e a4                	jle    802c6f <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802ccb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cce:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802cd3:	eb 16                	jmp    802ceb <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802cd5:	ff 45 f4             	incl   -0xc(%ebp)
  802cd8:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802cdf:	0f 8e 04 fd ff ff    	jle    8029e9 <sfree+0x4b>
  802ce5:	eb 04                	jmp    802ceb <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802ce7:	90                   	nop
  802ce8:	eb 01                	jmp    802ceb <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802cea:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802ceb:	c9                   	leave  
  802cec:	c3                   	ret    

00802ced <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802ced:	55                   	push   %ebp
  802cee:	89 e5                	mov    %esp,%ebp
  802cf0:	57                   	push   %edi
  802cf1:	56                   	push   %esi
  802cf2:	53                   	push   %ebx
  802cf3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cfc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d02:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d05:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d08:	cd 30                	int    $0x30
  802d0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d10:	83 c4 10             	add    $0x10,%esp
  802d13:	5b                   	pop    %ebx
  802d14:	5e                   	pop    %esi
  802d15:	5f                   	pop    %edi
  802d16:	5d                   	pop    %ebp
  802d17:	c3                   	ret    

00802d18 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802d18:	55                   	push   %ebp
  802d19:	89 e5                	mov    %esp,%ebp
  802d1b:	83 ec 04             	sub    $0x4,%esp
  802d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  802d21:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802d24:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d27:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	6a 00                	push   $0x0
  802d30:	51                   	push   %ecx
  802d31:	52                   	push   %edx
  802d32:	ff 75 0c             	pushl  0xc(%ebp)
  802d35:	50                   	push   %eax
  802d36:	6a 00                	push   $0x0
  802d38:	e8 b0 ff ff ff       	call   802ced <syscall>
  802d3d:	83 c4 18             	add    $0x18,%esp
}
  802d40:	90                   	nop
  802d41:	c9                   	leave  
  802d42:	c3                   	ret    

00802d43 <sys_cgetc>:

int
sys_cgetc(void)
{
  802d43:	55                   	push   %ebp
  802d44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802d46:	6a 00                	push   $0x0
  802d48:	6a 00                	push   $0x0
  802d4a:	6a 00                	push   $0x0
  802d4c:	6a 00                	push   $0x0
  802d4e:	6a 00                	push   $0x0
  802d50:	6a 02                	push   $0x2
  802d52:	e8 96 ff ff ff       	call   802ced <syscall>
  802d57:	83 c4 18             	add    $0x18,%esp
}
  802d5a:	c9                   	leave  
  802d5b:	c3                   	ret    

00802d5c <sys_lock_cons>:

void sys_lock_cons(void)
{
  802d5c:	55                   	push   %ebp
  802d5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802d5f:	6a 00                	push   $0x0
  802d61:	6a 00                	push   $0x0
  802d63:	6a 00                	push   $0x0
  802d65:	6a 00                	push   $0x0
  802d67:	6a 00                	push   $0x0
  802d69:	6a 03                	push   $0x3
  802d6b:	e8 7d ff ff ff       	call   802ced <syscall>
  802d70:	83 c4 18             	add    $0x18,%esp
}
  802d73:	90                   	nop
  802d74:	c9                   	leave  
  802d75:	c3                   	ret    

00802d76 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802d76:	55                   	push   %ebp
  802d77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802d79:	6a 00                	push   $0x0
  802d7b:	6a 00                	push   $0x0
  802d7d:	6a 00                	push   $0x0
  802d7f:	6a 00                	push   $0x0
  802d81:	6a 00                	push   $0x0
  802d83:	6a 04                	push   $0x4
  802d85:	e8 63 ff ff ff       	call   802ced <syscall>
  802d8a:	83 c4 18             	add    $0x18,%esp
}
  802d8d:	90                   	nop
  802d8e:	c9                   	leave  
  802d8f:	c3                   	ret    

00802d90 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802d90:	55                   	push   %ebp
  802d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802d93:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	6a 00                	push   $0x0
  802d9b:	6a 00                	push   $0x0
  802d9d:	6a 00                	push   $0x0
  802d9f:	52                   	push   %edx
  802da0:	50                   	push   %eax
  802da1:	6a 08                	push   $0x8
  802da3:	e8 45 ff ff ff       	call   802ced <syscall>
  802da8:	83 c4 18             	add    $0x18,%esp
}
  802dab:	c9                   	leave  
  802dac:	c3                   	ret    

00802dad <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802dad:	55                   	push   %ebp
  802dae:	89 e5                	mov    %esp,%ebp
  802db0:	56                   	push   %esi
  802db1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802db2:	8b 75 18             	mov    0x18(%ebp),%esi
  802db5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802db8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	56                   	push   %esi
  802dc2:	53                   	push   %ebx
  802dc3:	51                   	push   %ecx
  802dc4:	52                   	push   %edx
  802dc5:	50                   	push   %eax
  802dc6:	6a 09                	push   $0x9
  802dc8:	e8 20 ff ff ff       	call   802ced <syscall>
  802dcd:	83 c4 18             	add    $0x18,%esp
}
  802dd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802dd3:	5b                   	pop    %ebx
  802dd4:	5e                   	pop    %esi
  802dd5:	5d                   	pop    %ebp
  802dd6:	c3                   	ret    

00802dd7 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802dd7:	55                   	push   %ebp
  802dd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802dda:	6a 00                	push   $0x0
  802ddc:	6a 00                	push   $0x0
  802dde:	6a 00                	push   $0x0
  802de0:	6a 00                	push   $0x0
  802de2:	ff 75 08             	pushl  0x8(%ebp)
  802de5:	6a 0a                	push   $0xa
  802de7:	e8 01 ff ff ff       	call   802ced <syscall>
  802dec:	83 c4 18             	add    $0x18,%esp
}
  802def:	c9                   	leave  
  802df0:	c3                   	ret    

00802df1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802df1:	55                   	push   %ebp
  802df2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802df4:	6a 00                	push   $0x0
  802df6:	6a 00                	push   $0x0
  802df8:	6a 00                	push   $0x0
  802dfa:	ff 75 0c             	pushl  0xc(%ebp)
  802dfd:	ff 75 08             	pushl  0x8(%ebp)
  802e00:	6a 0b                	push   $0xb
  802e02:	e8 e6 fe ff ff       	call   802ced <syscall>
  802e07:	83 c4 18             	add    $0x18,%esp
}
  802e0a:	c9                   	leave  
  802e0b:	c3                   	ret    

00802e0c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802e0c:	55                   	push   %ebp
  802e0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802e0f:	6a 00                	push   $0x0
  802e11:	6a 00                	push   $0x0
  802e13:	6a 00                	push   $0x0
  802e15:	6a 00                	push   $0x0
  802e17:	6a 00                	push   $0x0
  802e19:	6a 0c                	push   $0xc
  802e1b:	e8 cd fe ff ff       	call   802ced <syscall>
  802e20:	83 c4 18             	add    $0x18,%esp
}
  802e23:	c9                   	leave  
  802e24:	c3                   	ret    

00802e25 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e25:	55                   	push   %ebp
  802e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e28:	6a 00                	push   $0x0
  802e2a:	6a 00                	push   $0x0
  802e2c:	6a 00                	push   $0x0
  802e2e:	6a 00                	push   $0x0
  802e30:	6a 00                	push   $0x0
  802e32:	6a 0d                	push   $0xd
  802e34:	e8 b4 fe ff ff       	call   802ced <syscall>
  802e39:	83 c4 18             	add    $0x18,%esp
}
  802e3c:	c9                   	leave  
  802e3d:	c3                   	ret    

00802e3e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802e3e:	55                   	push   %ebp
  802e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e41:	6a 00                	push   $0x0
  802e43:	6a 00                	push   $0x0
  802e45:	6a 00                	push   $0x0
  802e47:	6a 00                	push   $0x0
  802e49:	6a 00                	push   $0x0
  802e4b:	6a 0e                	push   $0xe
  802e4d:	e8 9b fe ff ff       	call   802ced <syscall>
  802e52:	83 c4 18             	add    $0x18,%esp
}
  802e55:	c9                   	leave  
  802e56:	c3                   	ret    

00802e57 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802e57:	55                   	push   %ebp
  802e58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 00                	push   $0x0
  802e5e:	6a 00                	push   $0x0
  802e60:	6a 00                	push   $0x0
  802e62:	6a 00                	push   $0x0
  802e64:	6a 0f                	push   $0xf
  802e66:	e8 82 fe ff ff       	call   802ced <syscall>
  802e6b:	83 c4 18             	add    $0x18,%esp
}
  802e6e:	c9                   	leave  
  802e6f:	c3                   	ret    

00802e70 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802e70:	55                   	push   %ebp
  802e71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802e73:	6a 00                	push   $0x0
  802e75:	6a 00                	push   $0x0
  802e77:	6a 00                	push   $0x0
  802e79:	6a 00                	push   $0x0
  802e7b:	ff 75 08             	pushl  0x8(%ebp)
  802e7e:	6a 10                	push   $0x10
  802e80:	e8 68 fe ff ff       	call   802ced <syscall>
  802e85:	83 c4 18             	add    $0x18,%esp
}
  802e88:	c9                   	leave  
  802e89:	c3                   	ret    

00802e8a <sys_scarce_memory>:

void sys_scarce_memory()
{
  802e8a:	55                   	push   %ebp
  802e8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802e8d:	6a 00                	push   $0x0
  802e8f:	6a 00                	push   $0x0
  802e91:	6a 00                	push   $0x0
  802e93:	6a 00                	push   $0x0
  802e95:	6a 00                	push   $0x0
  802e97:	6a 11                	push   $0x11
  802e99:	e8 4f fe ff ff       	call   802ced <syscall>
  802e9e:	83 c4 18             	add    $0x18,%esp
}
  802ea1:	90                   	nop
  802ea2:	c9                   	leave  
  802ea3:	c3                   	ret    

00802ea4 <sys_cputc>:

void
sys_cputc(const char c)
{
  802ea4:	55                   	push   %ebp
  802ea5:	89 e5                	mov    %esp,%ebp
  802ea7:	83 ec 04             	sub    $0x4,%esp
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802eb0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	50                   	push   %eax
  802ebd:	6a 01                	push   $0x1
  802ebf:	e8 29 fe ff ff       	call   802ced <syscall>
  802ec4:	83 c4 18             	add    $0x18,%esp
}
  802ec7:	90                   	nop
  802ec8:	c9                   	leave  
  802ec9:	c3                   	ret    

00802eca <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802eca:	55                   	push   %ebp
  802ecb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ecd:	6a 00                	push   $0x0
  802ecf:	6a 00                	push   $0x0
  802ed1:	6a 00                	push   $0x0
  802ed3:	6a 00                	push   $0x0
  802ed5:	6a 00                	push   $0x0
  802ed7:	6a 14                	push   $0x14
  802ed9:	e8 0f fe ff ff       	call   802ced <syscall>
  802ede:	83 c4 18             	add    $0x18,%esp
}
  802ee1:	90                   	nop
  802ee2:	c9                   	leave  
  802ee3:	c3                   	ret    

00802ee4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802ee4:	55                   	push   %ebp
  802ee5:	89 e5                	mov    %esp,%ebp
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	8b 45 10             	mov    0x10(%ebp),%eax
  802eed:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802ef0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ef3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	6a 00                	push   $0x0
  802efc:	51                   	push   %ecx
  802efd:	52                   	push   %edx
  802efe:	ff 75 0c             	pushl  0xc(%ebp)
  802f01:	50                   	push   %eax
  802f02:	6a 15                	push   $0x15
  802f04:	e8 e4 fd ff ff       	call   802ced <syscall>
  802f09:	83 c4 18             	add    $0x18,%esp
}
  802f0c:	c9                   	leave  
  802f0d:	c3                   	ret    

00802f0e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802f0e:	55                   	push   %ebp
  802f0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802f11:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	6a 00                	push   $0x0
  802f19:	6a 00                	push   $0x0
  802f1b:	6a 00                	push   $0x0
  802f1d:	52                   	push   %edx
  802f1e:	50                   	push   %eax
  802f1f:	6a 16                	push   $0x16
  802f21:	e8 c7 fd ff ff       	call   802ced <syscall>
  802f26:	83 c4 18             	add    $0x18,%esp
}
  802f29:	c9                   	leave  
  802f2a:	c3                   	ret    

00802f2b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802f2b:	55                   	push   %ebp
  802f2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802f2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f31:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	6a 00                	push   $0x0
  802f39:	6a 00                	push   $0x0
  802f3b:	51                   	push   %ecx
  802f3c:	52                   	push   %edx
  802f3d:	50                   	push   %eax
  802f3e:	6a 17                	push   $0x17
  802f40:	e8 a8 fd ff ff       	call   802ced <syscall>
  802f45:	83 c4 18             	add    $0x18,%esp
}
  802f48:	c9                   	leave  
  802f49:	c3                   	ret    

00802f4a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802f4a:	55                   	push   %ebp
  802f4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	6a 00                	push   $0x0
  802f55:	6a 00                	push   $0x0
  802f57:	6a 00                	push   $0x0
  802f59:	52                   	push   %edx
  802f5a:	50                   	push   %eax
  802f5b:	6a 18                	push   $0x18
  802f5d:	e8 8b fd ff ff       	call   802ced <syscall>
  802f62:	83 c4 18             	add    $0x18,%esp
}
  802f65:	c9                   	leave  
  802f66:	c3                   	ret    

00802f67 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802f67:	55                   	push   %ebp
  802f68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	6a 00                	push   $0x0
  802f6f:	ff 75 14             	pushl  0x14(%ebp)
  802f72:	ff 75 10             	pushl  0x10(%ebp)
  802f75:	ff 75 0c             	pushl  0xc(%ebp)
  802f78:	50                   	push   %eax
  802f79:	6a 19                	push   $0x19
  802f7b:	e8 6d fd ff ff       	call   802ced <syscall>
  802f80:	83 c4 18             	add    $0x18,%esp
}
  802f83:	c9                   	leave  
  802f84:	c3                   	ret    

00802f85 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802f85:	55                   	push   %ebp
  802f86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	6a 00                	push   $0x0
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	50                   	push   %eax
  802f94:	6a 1a                	push   $0x1a
  802f96:	e8 52 fd ff ff       	call   802ced <syscall>
  802f9b:	83 c4 18             	add    $0x18,%esp
}
  802f9e:	90                   	nop
  802f9f:	c9                   	leave  
  802fa0:	c3                   	ret    

00802fa1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802fa1:	55                   	push   %ebp
  802fa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	6a 00                	push   $0x0
  802fa9:	6a 00                	push   $0x0
  802fab:	6a 00                	push   $0x0
  802fad:	6a 00                	push   $0x0
  802faf:	50                   	push   %eax
  802fb0:	6a 1b                	push   $0x1b
  802fb2:	e8 36 fd ff ff       	call   802ced <syscall>
  802fb7:	83 c4 18             	add    $0x18,%esp
}
  802fba:	c9                   	leave  
  802fbb:	c3                   	ret    

00802fbc <sys_getenvid>:

int32 sys_getenvid(void)
{
  802fbc:	55                   	push   %ebp
  802fbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802fbf:	6a 00                	push   $0x0
  802fc1:	6a 00                	push   $0x0
  802fc3:	6a 00                	push   $0x0
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 05                	push   $0x5
  802fcb:	e8 1d fd ff ff       	call   802ced <syscall>
  802fd0:	83 c4 18             	add    $0x18,%esp
}
  802fd3:	c9                   	leave  
  802fd4:	c3                   	ret    

00802fd5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802fd8:	6a 00                	push   $0x0
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 06                	push   $0x6
  802fe4:	e8 04 fd ff ff       	call   802ced <syscall>
  802fe9:	83 c4 18             	add    $0x18,%esp
}
  802fec:	c9                   	leave  
  802fed:	c3                   	ret    

00802fee <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802fee:	55                   	push   %ebp
  802fef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802ff1:	6a 00                	push   $0x0
  802ff3:	6a 00                	push   $0x0
  802ff5:	6a 00                	push   $0x0
  802ff7:	6a 00                	push   $0x0
  802ff9:	6a 00                	push   $0x0
  802ffb:	6a 07                	push   $0x7
  802ffd:	e8 eb fc ff ff       	call   802ced <syscall>
  803002:	83 c4 18             	add    $0x18,%esp
}
  803005:	c9                   	leave  
  803006:	c3                   	ret    

00803007 <sys_exit_env>:


void sys_exit_env(void)
{
  803007:	55                   	push   %ebp
  803008:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80300a:	6a 00                	push   $0x0
  80300c:	6a 00                	push   $0x0
  80300e:	6a 00                	push   $0x0
  803010:	6a 00                	push   $0x0
  803012:	6a 00                	push   $0x0
  803014:	6a 1c                	push   $0x1c
  803016:	e8 d2 fc ff ff       	call   802ced <syscall>
  80301b:	83 c4 18             	add    $0x18,%esp
}
  80301e:	90                   	nop
  80301f:	c9                   	leave  
  803020:	c3                   	ret    

00803021 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803021:	55                   	push   %ebp
  803022:	89 e5                	mov    %esp,%ebp
  803024:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803027:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80302a:	8d 50 04             	lea    0x4(%eax),%edx
  80302d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803030:	6a 00                	push   $0x0
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	52                   	push   %edx
  803037:	50                   	push   %eax
  803038:	6a 1d                	push   $0x1d
  80303a:	e8 ae fc ff ff       	call   802ced <syscall>
  80303f:	83 c4 18             	add    $0x18,%esp
	return result;
  803042:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803045:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803048:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80304b:	89 01                	mov    %eax,(%ecx)
  80304d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	c9                   	leave  
  803054:	c2 04 00             	ret    $0x4

00803057 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803057:	55                   	push   %ebp
  803058:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80305a:	6a 00                	push   $0x0
  80305c:	6a 00                	push   $0x0
  80305e:	ff 75 10             	pushl  0x10(%ebp)
  803061:	ff 75 0c             	pushl  0xc(%ebp)
  803064:	ff 75 08             	pushl  0x8(%ebp)
  803067:	6a 13                	push   $0x13
  803069:	e8 7f fc ff ff       	call   802ced <syscall>
  80306e:	83 c4 18             	add    $0x18,%esp
	return ;
  803071:	90                   	nop
}
  803072:	c9                   	leave  
  803073:	c3                   	ret    

00803074 <sys_rcr2>:
uint32 sys_rcr2()
{
  803074:	55                   	push   %ebp
  803075:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803077:	6a 00                	push   $0x0
  803079:	6a 00                	push   $0x0
  80307b:	6a 00                	push   $0x0
  80307d:	6a 00                	push   $0x0
  80307f:	6a 00                	push   $0x0
  803081:	6a 1e                	push   $0x1e
  803083:	e8 65 fc ff ff       	call   802ced <syscall>
  803088:	83 c4 18             	add    $0x18,%esp
}
  80308b:	c9                   	leave  
  80308c:	c3                   	ret    

0080308d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80308d:	55                   	push   %ebp
  80308e:	89 e5                	mov    %esp,%ebp
  803090:	83 ec 04             	sub    $0x4,%esp
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803099:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80309d:	6a 00                	push   $0x0
  80309f:	6a 00                	push   $0x0
  8030a1:	6a 00                	push   $0x0
  8030a3:	6a 00                	push   $0x0
  8030a5:	50                   	push   %eax
  8030a6:	6a 1f                	push   $0x1f
  8030a8:	e8 40 fc ff ff       	call   802ced <syscall>
  8030ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8030b0:	90                   	nop
}
  8030b1:	c9                   	leave  
  8030b2:	c3                   	ret    

008030b3 <rsttst>:
void rsttst()
{
  8030b3:	55                   	push   %ebp
  8030b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8030b6:	6a 00                	push   $0x0
  8030b8:	6a 00                	push   $0x0
  8030ba:	6a 00                	push   $0x0
  8030bc:	6a 00                	push   $0x0
  8030be:	6a 00                	push   $0x0
  8030c0:	6a 21                	push   $0x21
  8030c2:	e8 26 fc ff ff       	call   802ced <syscall>
  8030c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8030ca:	90                   	nop
}
  8030cb:	c9                   	leave  
  8030cc:	c3                   	ret    

008030cd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8030cd:	55                   	push   %ebp
  8030ce:	89 e5                	mov    %esp,%ebp
  8030d0:	83 ec 04             	sub    $0x4,%esp
  8030d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8030d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8030d9:	8b 55 18             	mov    0x18(%ebp),%edx
  8030dc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030e0:	52                   	push   %edx
  8030e1:	50                   	push   %eax
  8030e2:	ff 75 10             	pushl  0x10(%ebp)
  8030e5:	ff 75 0c             	pushl  0xc(%ebp)
  8030e8:	ff 75 08             	pushl  0x8(%ebp)
  8030eb:	6a 20                	push   $0x20
  8030ed:	e8 fb fb ff ff       	call   802ced <syscall>
  8030f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8030f5:	90                   	nop
}
  8030f6:	c9                   	leave  
  8030f7:	c3                   	ret    

008030f8 <chktst>:
void chktst(uint32 n)
{
  8030f8:	55                   	push   %ebp
  8030f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8030fb:	6a 00                	push   $0x0
  8030fd:	6a 00                	push   $0x0
  8030ff:	6a 00                	push   $0x0
  803101:	6a 00                	push   $0x0
  803103:	ff 75 08             	pushl  0x8(%ebp)
  803106:	6a 22                	push   $0x22
  803108:	e8 e0 fb ff ff       	call   802ced <syscall>
  80310d:	83 c4 18             	add    $0x18,%esp
	return ;
  803110:	90                   	nop
}
  803111:	c9                   	leave  
  803112:	c3                   	ret    

00803113 <inctst>:

void inctst()
{
  803113:	55                   	push   %ebp
  803114:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803116:	6a 00                	push   $0x0
  803118:	6a 00                	push   $0x0
  80311a:	6a 00                	push   $0x0
  80311c:	6a 00                	push   $0x0
  80311e:	6a 00                	push   $0x0
  803120:	6a 23                	push   $0x23
  803122:	e8 c6 fb ff ff       	call   802ced <syscall>
  803127:	83 c4 18             	add    $0x18,%esp
	return ;
  80312a:	90                   	nop
}
  80312b:	c9                   	leave  
  80312c:	c3                   	ret    

0080312d <gettst>:
uint32 gettst()
{
  80312d:	55                   	push   %ebp
  80312e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803130:	6a 00                	push   $0x0
  803132:	6a 00                	push   $0x0
  803134:	6a 00                	push   $0x0
  803136:	6a 00                	push   $0x0
  803138:	6a 00                	push   $0x0
  80313a:	6a 24                	push   $0x24
  80313c:	e8 ac fb ff ff       	call   802ced <syscall>
  803141:	83 c4 18             	add    $0x18,%esp
}
  803144:	c9                   	leave  
  803145:	c3                   	ret    

00803146 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803146:	55                   	push   %ebp
  803147:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803149:	6a 00                	push   $0x0
  80314b:	6a 00                	push   $0x0
  80314d:	6a 00                	push   $0x0
  80314f:	6a 00                	push   $0x0
  803151:	6a 00                	push   $0x0
  803153:	6a 25                	push   $0x25
  803155:	e8 93 fb ff ff       	call   802ced <syscall>
  80315a:	83 c4 18             	add    $0x18,%esp
  80315d:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803162:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803167:	c9                   	leave  
  803168:	c3                   	ret    

00803169 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803169:	55                   	push   %ebp
  80316a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	ff 75 08             	pushl  0x8(%ebp)
  80317f:	6a 26                	push   $0x26
  803181:	e8 67 fb ff ff       	call   802ced <syscall>
  803186:	83 c4 18             	add    $0x18,%esp
	return ;
  803189:	90                   	nop
}
  80318a:	c9                   	leave  
  80318b:	c3                   	ret    

0080318c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80318c:	55                   	push   %ebp
  80318d:	89 e5                	mov    %esp,%ebp
  80318f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803190:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803193:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803196:	8b 55 0c             	mov    0xc(%ebp),%edx
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	6a 00                	push   $0x0
  80319e:	53                   	push   %ebx
  80319f:	51                   	push   %ecx
  8031a0:	52                   	push   %edx
  8031a1:	50                   	push   %eax
  8031a2:	6a 27                	push   $0x27
  8031a4:	e8 44 fb ff ff       	call   802ced <syscall>
  8031a9:	83 c4 18             	add    $0x18,%esp
}
  8031ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031af:	c9                   	leave  
  8031b0:	c3                   	ret    

008031b1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8031b1:	55                   	push   %ebp
  8031b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8031b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	6a 00                	push   $0x0
  8031bc:	6a 00                	push   $0x0
  8031be:	6a 00                	push   $0x0
  8031c0:	52                   	push   %edx
  8031c1:	50                   	push   %eax
  8031c2:	6a 28                	push   $0x28
  8031c4:	e8 24 fb ff ff       	call   802ced <syscall>
  8031c9:	83 c4 18             	add    $0x18,%esp
}
  8031cc:	c9                   	leave  
  8031cd:	c3                   	ret    

008031ce <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8031ce:	55                   	push   %ebp
  8031cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8031d1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	6a 00                	push   $0x0
  8031dc:	51                   	push   %ecx
  8031dd:	ff 75 10             	pushl  0x10(%ebp)
  8031e0:	52                   	push   %edx
  8031e1:	50                   	push   %eax
  8031e2:	6a 29                	push   $0x29
  8031e4:	e8 04 fb ff ff       	call   802ced <syscall>
  8031e9:	83 c4 18             	add    $0x18,%esp
}
  8031ec:	c9                   	leave  
  8031ed:	c3                   	ret    

008031ee <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8031ee:	55                   	push   %ebp
  8031ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8031f1:	6a 00                	push   $0x0
  8031f3:	6a 00                	push   $0x0
  8031f5:	ff 75 10             	pushl  0x10(%ebp)
  8031f8:	ff 75 0c             	pushl  0xc(%ebp)
  8031fb:	ff 75 08             	pushl  0x8(%ebp)
  8031fe:	6a 12                	push   $0x12
  803200:	e8 e8 fa ff ff       	call   802ced <syscall>
  803205:	83 c4 18             	add    $0x18,%esp
	return ;
  803208:	90                   	nop
}
  803209:	c9                   	leave  
  80320a:	c3                   	ret    

0080320b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80320b:	55                   	push   %ebp
  80320c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80320e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	6a 00                	push   $0x0
  803216:	6a 00                	push   $0x0
  803218:	6a 00                	push   $0x0
  80321a:	52                   	push   %edx
  80321b:	50                   	push   %eax
  80321c:	6a 2a                	push   $0x2a
  80321e:	e8 ca fa ff ff       	call   802ced <syscall>
  803223:	83 c4 18             	add    $0x18,%esp
	return;
  803226:	90                   	nop
}
  803227:	c9                   	leave  
  803228:	c3                   	ret    

00803229 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803229:	55                   	push   %ebp
  80322a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80322c:	6a 00                	push   $0x0
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	6a 00                	push   $0x0
  803234:	6a 00                	push   $0x0
  803236:	6a 2b                	push   $0x2b
  803238:	e8 b0 fa ff ff       	call   802ced <syscall>
  80323d:	83 c4 18             	add    $0x18,%esp
}
  803240:	c9                   	leave  
  803241:	c3                   	ret    

00803242 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803242:	55                   	push   %ebp
  803243:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803245:	6a 00                	push   $0x0
  803247:	6a 00                	push   $0x0
  803249:	6a 00                	push   $0x0
  80324b:	ff 75 0c             	pushl  0xc(%ebp)
  80324e:	ff 75 08             	pushl  0x8(%ebp)
  803251:	6a 2d                	push   $0x2d
  803253:	e8 95 fa ff ff       	call   802ced <syscall>
  803258:	83 c4 18             	add    $0x18,%esp
	return;
  80325b:	90                   	nop
}
  80325c:	c9                   	leave  
  80325d:	c3                   	ret    

0080325e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80325e:	55                   	push   %ebp
  80325f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803261:	6a 00                	push   $0x0
  803263:	6a 00                	push   $0x0
  803265:	6a 00                	push   $0x0
  803267:	ff 75 0c             	pushl  0xc(%ebp)
  80326a:	ff 75 08             	pushl  0x8(%ebp)
  80326d:	6a 2c                	push   $0x2c
  80326f:	e8 79 fa ff ff       	call   802ced <syscall>
  803274:	83 c4 18             	add    $0x18,%esp
	return ;
  803277:	90                   	nop
}
  803278:	c9                   	leave  
  803279:	c3                   	ret    

0080327a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80327a:	55                   	push   %ebp
  80327b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80327d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	6a 00                	push   $0x0
  803285:	6a 00                	push   $0x0
  803287:	6a 00                	push   $0x0
  803289:	52                   	push   %edx
  80328a:	50                   	push   %eax
  80328b:	6a 2e                	push   $0x2e
  80328d:	e8 5b fa ff ff       	call   802ced <syscall>
  803292:	83 c4 18             	add    $0x18,%esp
}
  803295:	90                   	nop
  803296:	c9                   	leave  
  803297:	c3                   	ret    

00803298 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803298:	55                   	push   %ebp
  803299:	89 e5                	mov    %esp,%ebp
  80329b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80329e:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  8032a5:	72 09                	jb     8032b0 <to_page_va+0x18>
  8032a7:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  8032ae:	72 14                	jb     8032c4 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8032b0:	83 ec 04             	sub    $0x4,%esp
  8032b3:	68 b8 49 80 00       	push   $0x8049b8
  8032b8:	6a 15                	push   $0x15
  8032ba:	68 e3 49 80 00       	push   $0x8049e3
  8032bf:	e8 e3 0b 00 00       	call   803ea7 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8032cc:	29 d0                	sub    %edx,%eax
  8032ce:	c1 f8 02             	sar    $0x2,%eax
  8032d1:	89 c2                	mov    %eax,%edx
  8032d3:	89 d0                	mov    %edx,%eax
  8032d5:	c1 e0 02             	shl    $0x2,%eax
  8032d8:	01 d0                	add    %edx,%eax
  8032da:	c1 e0 02             	shl    $0x2,%eax
  8032dd:	01 d0                	add    %edx,%eax
  8032df:	c1 e0 02             	shl    $0x2,%eax
  8032e2:	01 d0                	add    %edx,%eax
  8032e4:	89 c1                	mov    %eax,%ecx
  8032e6:	c1 e1 08             	shl    $0x8,%ecx
  8032e9:	01 c8                	add    %ecx,%eax
  8032eb:	89 c1                	mov    %eax,%ecx
  8032ed:	c1 e1 10             	shl    $0x10,%ecx
  8032f0:	01 c8                	add    %ecx,%eax
  8032f2:	01 c0                	add    %eax,%eax
  8032f4:	01 d0                	add    %edx,%eax
  8032f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8032f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fc:	c1 e0 0c             	shl    $0xc,%eax
  8032ff:	89 c2                	mov    %eax,%edx
  803301:	a1 84 50 83 00       	mov    0x835084,%eax
  803306:	01 d0                	add    %edx,%eax
}
  803308:	c9                   	leave  
  803309:	c3                   	ret    

0080330a <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80330a:	55                   	push   %ebp
  80330b:	89 e5                	mov    %esp,%ebp
  80330d:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803310:	a1 84 50 83 00       	mov    0x835084,%eax
  803315:	8b 55 08             	mov    0x8(%ebp),%edx
  803318:	29 c2                	sub    %eax,%edx
  80331a:	89 d0                	mov    %edx,%eax
  80331c:	c1 e8 0c             	shr    $0xc,%eax
  80331f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803326:	78 09                	js     803331 <to_page_info+0x27>
  803328:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80332f:	7e 14                	jle    803345 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803331:	83 ec 04             	sub    $0x4,%esp
  803334:	68 fc 49 80 00       	push   $0x8049fc
  803339:	6a 21                	push   $0x21
  80333b:	68 e3 49 80 00       	push   $0x8049e3
  803340:	e8 62 0b 00 00       	call   803ea7 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803348:	89 d0                	mov    %edx,%eax
  80334a:	01 c0                	add    %eax,%eax
  80334c:	01 d0                	add    %edx,%eax
  80334e:	c1 e0 02             	shl    $0x2,%eax
  803351:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  803356:	c9                   	leave  
  803357:	c3                   	ret    

00803358 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803358:	55                   	push   %ebp
  803359:	89 e5                	mov    %esp,%ebp
  80335b:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80335e:	8b 45 08             	mov    0x8(%ebp),%eax
  803361:	05 00 00 00 02       	add    $0x2000000,%eax
  803366:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803369:	73 16                	jae    803381 <initialize_dynamic_allocator+0x29>
  80336b:	68 20 4a 80 00       	push   $0x804a20
  803370:	68 46 4a 80 00       	push   $0x804a46
  803375:	6a 2f                	push   $0x2f
  803377:	68 e3 49 80 00       	push   $0x8049e3
  80337c:	e8 26 0b 00 00       	call   803ea7 <_panic>
	dynAllocStart = daStart;
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80338c:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803391:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803398:	eb 36                	jmp    8033d0 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  80339a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339d:	c1 e0 04             	shl    $0x4,%eax
  8033a0:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8033a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ae:	c1 e0 04             	shl    $0x4,%eax
  8033b1:	05 a4 50 83 00       	add    $0x8350a4,%eax
  8033b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bf:	c1 e0 04             	shl    $0x4,%eax
  8033c2:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8033c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8033cd:	ff 45 f4             	incl   -0xc(%ebp)
  8033d0:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8033d4:	7e c4                	jle    80339a <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8033d6:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  8033dd:	00 00 00 
  8033e0:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  8033e7:	00 00 00 
  8033ea:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  8033f1:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8033f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8033fb:	e9 1b 01 00 00       	jmp    80351b <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803400:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803403:	89 d0                	mov    %edx,%eax
  803405:	01 c0                	add    %eax,%eax
  803407:	01 d0                	add    %edx,%eax
  803409:	c1 e0 02             	shl    $0x2,%eax
  80340c:	05 88 d0 81 00       	add    $0x81d088,%eax
  803411:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803416:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803419:	89 d0                	mov    %edx,%eax
  80341b:	01 c0                	add    %eax,%eax
  80341d:	01 d0                	add    %edx,%eax
  80341f:	c1 e0 02             	shl    $0x2,%eax
  803422:	05 8a d0 81 00       	add    $0x81d08a,%eax
  803427:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  80342c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80342f:	89 d0                	mov    %edx,%eax
  803431:	01 c0                	add    %eax,%eax
  803433:	01 d0                	add    %edx,%eax
  803435:	c1 e0 02             	shl    $0x2,%eax
  803438:	05 80 d0 81 00       	add    $0x81d080,%eax
  80343d:	8b 00                	mov    (%eax),%eax
  80343f:	85 c0                	test   %eax,%eax
  803441:	74 2b                	je     80346e <initialize_dynamic_allocator+0x116>
  803443:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803446:	89 d0                	mov    %edx,%eax
  803448:	01 c0                	add    %eax,%eax
  80344a:	01 d0                	add    %edx,%eax
  80344c:	c1 e0 02             	shl    $0x2,%eax
  80344f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803454:	8b 10                	mov    (%eax),%edx
  803456:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803459:	89 c8                	mov    %ecx,%eax
  80345b:	01 c0                	add    %eax,%eax
  80345d:	01 c8                	add    %ecx,%eax
  80345f:	c1 e0 02             	shl    $0x2,%eax
  803462:	05 84 d0 81 00       	add    $0x81d084,%eax
  803467:	8b 00                	mov    (%eax),%eax
  803469:	89 42 04             	mov    %eax,0x4(%edx)
  80346c:	eb 18                	jmp    803486 <initialize_dynamic_allocator+0x12e>
  80346e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803471:	89 d0                	mov    %edx,%eax
  803473:	01 c0                	add    %eax,%eax
  803475:	01 d0                	add    %edx,%eax
  803477:	c1 e0 02             	shl    $0x2,%eax
  80347a:	05 84 d0 81 00       	add    $0x81d084,%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803486:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803489:	89 d0                	mov    %edx,%eax
  80348b:	01 c0                	add    %eax,%eax
  80348d:	01 d0                	add    %edx,%eax
  80348f:	c1 e0 02             	shl    $0x2,%eax
  803492:	05 84 d0 81 00       	add    $0x81d084,%eax
  803497:	8b 00                	mov    (%eax),%eax
  803499:	85 c0                	test   %eax,%eax
  80349b:	74 2a                	je     8034c7 <initialize_dynamic_allocator+0x16f>
  80349d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034a0:	89 d0                	mov    %edx,%eax
  8034a2:	01 c0                	add    %eax,%eax
  8034a4:	01 d0                	add    %edx,%eax
  8034a6:	c1 e0 02             	shl    $0x2,%eax
  8034a9:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034ae:	8b 10                	mov    (%eax),%edx
  8034b0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8034b3:	89 c8                	mov    %ecx,%eax
  8034b5:	01 c0                	add    %eax,%eax
  8034b7:	01 c8                	add    %ecx,%eax
  8034b9:	c1 e0 02             	shl    $0x2,%eax
  8034bc:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034c1:	8b 00                	mov    (%eax),%eax
  8034c3:	89 02                	mov    %eax,(%edx)
  8034c5:	eb 18                	jmp    8034df <initialize_dynamic_allocator+0x187>
  8034c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ca:	89 d0                	mov    %edx,%eax
  8034cc:	01 c0                	add    %eax,%eax
  8034ce:	01 d0                	add    %edx,%eax
  8034d0:	c1 e0 02             	shl    $0x2,%eax
  8034d3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034d8:	8b 00                	mov    (%eax),%eax
  8034da:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8034df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034e2:	89 d0                	mov    %edx,%eax
  8034e4:	01 c0                	add    %eax,%eax
  8034e6:	01 d0                	add    %edx,%eax
  8034e8:	c1 e0 02             	shl    $0x2,%eax
  8034eb:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f9:	89 d0                	mov    %edx,%eax
  8034fb:	01 c0                	add    %eax,%eax
  8034fd:	01 d0                	add    %edx,%eax
  8034ff:	c1 e0 02             	shl    $0x2,%eax
  803502:	05 84 d0 81 00       	add    $0x81d084,%eax
  803507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80350d:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803512:	48                   	dec    %eax
  803513:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803518:	ff 45 f0             	incl   -0x10(%ebp)
  80351b:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803522:	0f 8e d8 fe ff ff    	jle    803400 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803528:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  80352f:	e9 9d 00 00 00       	jmp    8035d1 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803534:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80353a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80353d:	89 c8                	mov    %ecx,%eax
  80353f:	01 c0                	add    %eax,%eax
  803541:	01 c8                	add    %ecx,%eax
  803543:	c1 e0 02             	shl    $0x2,%eax
  803546:	05 80 d0 81 00       	add    $0x81d080,%eax
  80354b:	89 10                	mov    %edx,(%eax)
  80354d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803550:	89 d0                	mov    %edx,%eax
  803552:	01 c0                	add    %eax,%eax
  803554:	01 d0                	add    %edx,%eax
  803556:	c1 e0 02             	shl    $0x2,%eax
  803559:	05 80 d0 81 00       	add    $0x81d080,%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 1c                	je     803580 <initialize_dynamic_allocator+0x228>
  803564:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80356a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80356d:	89 c8                	mov    %ecx,%eax
  80356f:	01 c0                	add    %eax,%eax
  803571:	01 c8                	add    %ecx,%eax
  803573:	c1 e0 02             	shl    $0x2,%eax
  803576:	05 80 d0 81 00       	add    $0x81d080,%eax
  80357b:	89 42 04             	mov    %eax,0x4(%edx)
  80357e:	eb 16                	jmp    803596 <initialize_dynamic_allocator+0x23e>
  803580:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803583:	89 d0                	mov    %edx,%eax
  803585:	01 c0                	add    %eax,%eax
  803587:	01 d0                	add    %edx,%eax
  803589:	c1 e0 02             	shl    $0x2,%eax
  80358c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803591:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803596:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803599:	89 d0                	mov    %edx,%eax
  80359b:	01 c0                	add    %eax,%eax
  80359d:	01 d0                	add    %edx,%eax
  80359f:	c1 e0 02             	shl    $0x2,%eax
  8035a2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035a7:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8035ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035af:	89 d0                	mov    %edx,%eax
  8035b1:	01 c0                	add    %eax,%eax
  8035b3:	01 d0                	add    %edx,%eax
  8035b5:	c1 e0 02             	shl    $0x2,%eax
  8035b8:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035c3:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8035c8:	40                   	inc    %eax
  8035c9:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8035ce:	ff 4d ec             	decl   -0x14(%ebp)
  8035d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035d5:	0f 89 59 ff ff ff    	jns    803534 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8035db:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  8035e2:	00 00 00 
}
  8035e5:	90                   	nop
  8035e6:	c9                   	leave  
  8035e7:	c3                   	ret    

008035e8 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8035e8:	55                   	push   %ebp
  8035e9:	89 e5                	mov    %esp,%ebp
  8035eb:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8035ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f1:	83 ec 0c             	sub    $0xc,%esp
  8035f4:	50                   	push   %eax
  8035f5:	e8 10 fd ff ff       	call   80330a <to_page_info>
  8035fa:	83 c4 10             	add    $0x10,%esp
  8035fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803603:	8b 40 08             	mov    0x8(%eax),%eax
  803606:	0f b7 c0             	movzwl %ax,%eax
}
  803609:	c9                   	leave  
  80360a:	c3                   	ret    

0080360b <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80360b:	55                   	push   %ebp
  80360c:	89 e5                	mov    %esp,%ebp
  80360e:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803611:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803618:	76 16                	jbe    803630 <alloc_block+0x25>
  80361a:	68 5c 4a 80 00       	push   $0x804a5c
  80361f:	68 46 4a 80 00       	push   $0x804a46
  803624:	6a 59                	push   $0x59
  803626:	68 e3 49 80 00       	push   $0x8049e3
  80362b:	e8 77 08 00 00       	call   803ea7 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803630:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803637:	eb 08                	jmp    803641 <alloc_block+0x36>
		allocSize <<= 1;
  803639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363c:	01 c0                	add    %eax,%eax
  80363e:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803644:	3b 45 08             	cmp    0x8(%ebp),%eax
  803647:	73 09                	jae    803652 <alloc_block+0x47>
  803649:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803650:	76 e7                	jbe    803639 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803652:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803659:	eb 03                	jmp    80365e <alloc_block+0x53>
		listIndex++;
  80365b:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80365e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803661:	ba 08 00 00 00       	mov    $0x8,%edx
  803666:	88 c1                	mov    %al,%cl
  803668:	d3 e2                	shl    %cl,%edx
  80366a:	89 d0                	mov    %edx,%eax
  80366c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80366f:	72 ea                	jb     80365b <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803674:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803677:	e9 f4 00 00 00       	jmp    803770 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  80367c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80367f:	c1 e0 04             	shl    $0x4,%eax
  803682:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803687:	8b 00                	mov    (%eax),%eax
  803689:	85 c0                	test   %eax,%eax
  80368b:	0f 84 dc 00 00 00    	je     80376d <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803694:	c1 e0 04             	shl    $0x4,%eax
  803697:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  8036a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036a5:	75 14                	jne    8036bb <alloc_block+0xb0>
  8036a7:	83 ec 04             	sub    $0x4,%esp
  8036aa:	68 7d 4a 80 00       	push   $0x804a7d
  8036af:	6a 6b                	push   $0x6b
  8036b1:	68 e3 49 80 00       	push   $0x8049e3
  8036b6:	e8 ec 07 00 00       	call   803ea7 <_panic>
  8036bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036be:	8b 00                	mov    (%eax),%eax
  8036c0:	85 c0                	test   %eax,%eax
  8036c2:	74 10                	je     8036d4 <alloc_block+0xc9>
  8036c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c7:	8b 00                	mov    (%eax),%eax
  8036c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036cc:	8b 52 04             	mov    0x4(%edx),%edx
  8036cf:	89 50 04             	mov    %edx,0x4(%eax)
  8036d2:	eb 14                	jmp    8036e8 <alloc_block+0xdd>
  8036d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d7:	8b 40 04             	mov    0x4(%eax),%eax
  8036da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036dd:	c1 e2 04             	shl    $0x4,%edx
  8036e0:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8036e6:	89 02                	mov    %eax,(%edx)
  8036e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036eb:	8b 40 04             	mov    0x4(%eax),%eax
  8036ee:	85 c0                	test   %eax,%eax
  8036f0:	74 0f                	je     803701 <alloc_block+0xf6>
  8036f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f5:	8b 40 04             	mov    0x4(%eax),%eax
  8036f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036fb:	8b 12                	mov    (%edx),%edx
  8036fd:	89 10                	mov    %edx,(%eax)
  8036ff:	eb 13                	jmp    803714 <alloc_block+0x109>
  803701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803704:	8b 00                	mov    (%eax),%eax
  803706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803709:	c1 e2 04             	shl    $0x4,%edx
  80370c:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803712:	89 02                	mov    %eax,(%edx)
  803714:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803717:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80371d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803720:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372a:	c1 e0 04             	shl    $0x4,%eax
  80372d:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803732:	8b 00                	mov    (%eax),%eax
  803734:	8d 50 ff             	lea    -0x1(%eax),%edx
  803737:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80373a:	c1 e0 04             	shl    $0x4,%eax
  80373d:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803742:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803747:	83 ec 0c             	sub    $0xc,%esp
  80374a:	50                   	push   %eax
  80374b:	e8 ba fb ff ff       	call   80330a <to_page_info>
  803750:	83 c4 10             	add    $0x10,%esp
  803753:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803756:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803759:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80375d:	48                   	dec    %eax
  80375e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803761:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803768:	e9 8f 02 00 00       	jmp    8039fc <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80376d:	ff 45 ec             	incl   -0x14(%ebp)
  803770:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803774:	0f 8e 02 ff ff ff    	jle    80367c <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  80377a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80377f:	85 c0                	test   %eax,%eax
  803781:	75 14                	jne    803797 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803783:	83 ec 04             	sub    $0x4,%esp
  803786:	68 9c 4a 80 00       	push   $0x804a9c
  80378b:	6a 77                	push   $0x77
  80378d:	68 e3 49 80 00       	push   $0x8049e3
  803792:	e8 10 07 00 00       	call   803ea7 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803797:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80379c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  80379f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037a3:	75 14                	jne    8037b9 <alloc_block+0x1ae>
  8037a5:	83 ec 04             	sub    $0x4,%esp
  8037a8:	68 7d 4a 80 00       	push   $0x804a7d
  8037ad:	6a 7a                	push   $0x7a
  8037af:	68 e3 49 80 00       	push   $0x8049e3
  8037b4:	e8 ee 06 00 00       	call   803ea7 <_panic>
  8037b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037bc:	8b 00                	mov    (%eax),%eax
  8037be:	85 c0                	test   %eax,%eax
  8037c0:	74 10                	je     8037d2 <alloc_block+0x1c7>
  8037c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c5:	8b 00                	mov    (%eax),%eax
  8037c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037ca:	8b 52 04             	mov    0x4(%edx),%edx
  8037cd:	89 50 04             	mov    %edx,0x4(%eax)
  8037d0:	eb 0b                	jmp    8037dd <alloc_block+0x1d2>
  8037d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d5:	8b 40 04             	mov    0x4(%eax),%eax
  8037d8:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8037dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e0:	8b 40 04             	mov    0x4(%eax),%eax
  8037e3:	85 c0                	test   %eax,%eax
  8037e5:	74 0f                	je     8037f6 <alloc_block+0x1eb>
  8037e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ea:	8b 40 04             	mov    0x4(%eax),%eax
  8037ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037f0:	8b 12                	mov    (%edx),%edx
  8037f2:	89 10                	mov    %edx,(%eax)
  8037f4:	eb 0a                	jmp    803800 <alloc_block+0x1f5>
  8037f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f9:	8b 00                	mov    (%eax),%eax
  8037fb:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803800:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803803:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803809:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80380c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803813:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803818:	48                   	dec    %eax
  803819:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  80381e:	83 ec 0c             	sub    $0xc,%esp
  803821:	ff 75 dc             	pushl  -0x24(%ebp)
  803824:	e8 6f fa ff ff       	call   803298 <to_page_va>
  803829:	83 c4 10             	add    $0x10,%esp
  80382c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  80382f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803832:	83 ec 0c             	sub    $0xc,%esp
  803835:	50                   	push   %eax
  803836:	e8 a0 dc ff ff       	call   8014db <get_page>
  80383b:	83 c4 10             	add    $0x10,%esp
  80383e:	85 c0                	test   %eax,%eax
  803840:	74 14                	je     803856 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803842:	83 ec 04             	sub    $0x4,%esp
  803845:	68 c4 4a 80 00       	push   $0x804ac4
  80384a:	6a 7f                	push   $0x7f
  80384c:	68 e3 49 80 00       	push   $0x8049e3
  803851:	e8 51 06 00 00       	call   803ea7 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803859:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80385c:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803860:	b8 00 10 00 00       	mov    $0x1000,%eax
  803865:	ba 00 00 00 00       	mov    $0x0,%edx
  80386a:	f7 75 f4             	divl   -0xc(%ebp)
  80386d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803870:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803874:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80387b:	e9 a7 00 00 00       	jmp    803927 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803880:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803883:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803886:	01 d0                	add    %edx,%eax
  803888:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  80388b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80388f:	75 17                	jne    8038a8 <alloc_block+0x29d>
  803891:	83 ec 04             	sub    $0x4,%esp
  803894:	68 ec 4a 80 00       	push   $0x804aec
  803899:	68 88 00 00 00       	push   $0x88
  80389e:	68 e3 49 80 00       	push   $0x8049e3
  8038a3:	e8 ff 05 00 00       	call   803ea7 <_panic>
  8038a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ab:	c1 e0 04             	shl    $0x4,%eax
  8038ae:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038b3:	8b 10                	mov    (%eax),%edx
  8038b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038b8:	89 10                	mov    %edx,(%eax)
  8038ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038bd:	8b 00                	mov    (%eax),%eax
  8038bf:	85 c0                	test   %eax,%eax
  8038c1:	74 15                	je     8038d8 <alloc_block+0x2cd>
  8038c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c6:	c1 e0 04             	shl    $0x4,%eax
  8038c9:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038ce:	8b 00                	mov    (%eax),%eax
  8038d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038d3:	89 50 04             	mov    %edx,0x4(%eax)
  8038d6:	eb 11                	jmp    8038e9 <alloc_block+0x2de>
  8038d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038db:	c1 e0 04             	shl    $0x4,%eax
  8038de:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  8038e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038e7:	89 02                	mov    %eax,(%edx)
  8038e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ec:	c1 e0 04             	shl    $0x4,%eax
  8038ef:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  8038f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038f8:	89 02                	mov    %eax,(%edx)
  8038fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803907:	c1 e0 04             	shl    $0x4,%eax
  80390a:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80390f:	8b 00                	mov    (%eax),%eax
  803911:	8d 50 01             	lea    0x1(%eax),%edx
  803914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803917:	c1 e0 04             	shl    $0x4,%eax
  80391a:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80391f:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803924:	01 45 e8             	add    %eax,-0x18(%ebp)
  803927:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80392e:	0f 86 4c ff ff ff    	jbe    803880 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803937:	c1 e0 04             	shl    $0x4,%eax
  80393a:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80393f:	8b 00                	mov    (%eax),%eax
  803941:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803944:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803948:	75 17                	jne    803961 <alloc_block+0x356>
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	68 7d 4a 80 00       	push   $0x804a7d
  803952:	68 8d 00 00 00       	push   $0x8d
  803957:	68 e3 49 80 00       	push   $0x8049e3
  80395c:	e8 46 05 00 00       	call   803ea7 <_panic>
  803961:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803964:	8b 00                	mov    (%eax),%eax
  803966:	85 c0                	test   %eax,%eax
  803968:	74 10                	je     80397a <alloc_block+0x36f>
  80396a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80396d:	8b 00                	mov    (%eax),%eax
  80396f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803972:	8b 52 04             	mov    0x4(%edx),%edx
  803975:	89 50 04             	mov    %edx,0x4(%eax)
  803978:	eb 14                	jmp    80398e <alloc_block+0x383>
  80397a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80397d:	8b 40 04             	mov    0x4(%eax),%eax
  803980:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803983:	c1 e2 04             	shl    $0x4,%edx
  803986:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  80398c:	89 02                	mov    %eax,(%edx)
  80398e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803991:	8b 40 04             	mov    0x4(%eax),%eax
  803994:	85 c0                	test   %eax,%eax
  803996:	74 0f                	je     8039a7 <alloc_block+0x39c>
  803998:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80399b:	8b 40 04             	mov    0x4(%eax),%eax
  80399e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8039a1:	8b 12                	mov    (%edx),%edx
  8039a3:	89 10                	mov    %edx,(%eax)
  8039a5:	eb 13                	jmp    8039ba <alloc_block+0x3af>
  8039a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039aa:	8b 00                	mov    (%eax),%eax
  8039ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039af:	c1 e2 04             	shl    $0x4,%edx
  8039b2:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8039b8:	89 02                	mov    %eax,(%edx)
  8039ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d0:	c1 e0 04             	shl    $0x4,%eax
  8039d3:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039d8:	8b 00                	mov    (%eax),%eax
  8039da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e0:	c1 e0 04             	shl    $0x4,%eax
  8039e3:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039e8:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  8039ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ed:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8039f1:	48                   	dec    %eax
  8039f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039f5:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  8039f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  8039fc:	c9                   	leave  
  8039fd:	c3                   	ret    

008039fe <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8039fe:	55                   	push   %ebp
  8039ff:	89 e5                	mov    %esp,%ebp
  803a01:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803a04:	8b 55 08             	mov    0x8(%ebp),%edx
  803a07:	a1 84 50 83 00       	mov    0x835084,%eax
  803a0c:	39 c2                	cmp    %eax,%edx
  803a0e:	72 0c                	jb     803a1c <free_block+0x1e>
  803a10:	8b 55 08             	mov    0x8(%ebp),%edx
  803a13:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803a18:	39 c2                	cmp    %eax,%edx
  803a1a:	72 19                	jb     803a35 <free_block+0x37>
  803a1c:	68 10 4b 80 00       	push   $0x804b10
  803a21:	68 46 4a 80 00       	push   $0x804a46
  803a26:	68 98 00 00 00       	push   $0x98
  803a2b:	68 e3 49 80 00       	push   $0x8049e3
  803a30:	e8 72 04 00 00       	call   803ea7 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803a35:	8b 45 08             	mov    0x8(%ebp),%eax
  803a38:	83 ec 0c             	sub    $0xc,%esp
  803a3b:	50                   	push   %eax
  803a3c:	e8 c9 f8 ff ff       	call   80330a <to_page_info>
  803a41:	83 c4 10             	add    $0x10,%esp
  803a44:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803a47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a4a:	8b 40 08             	mov    0x8(%eax),%eax
  803a4d:	0f b7 c0             	movzwl %ax,%eax
  803a50:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803a53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803a5a:	eb 03                	jmp    803a5f <free_block+0x61>
		listIndex++;
  803a5c:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a62:	ba 08 00 00 00       	mov    $0x8,%edx
  803a67:	88 c1                	mov    %al,%cl
  803a69:	d3 e2                	shl    %cl,%edx
  803a6b:	89 d0                	mov    %edx,%eax
  803a6d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a70:	72 ea                	jb     803a5c <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803a72:	8b 45 08             	mov    0x8(%ebp),%eax
  803a75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803a78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a7c:	75 17                	jne    803a95 <free_block+0x97>
  803a7e:	83 ec 04             	sub    $0x4,%esp
  803a81:	68 ec 4a 80 00       	push   $0x804aec
  803a86:	68 a2 00 00 00       	push   $0xa2
  803a8b:	68 e3 49 80 00       	push   $0x8049e3
  803a90:	e8 12 04 00 00       	call   803ea7 <_panic>
  803a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a98:	c1 e0 04             	shl    $0x4,%eax
  803a9b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803aa0:	8b 10                	mov    (%eax),%edx
  803aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa5:	89 10                	mov    %edx,(%eax)
  803aa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aaa:	8b 00                	mov    (%eax),%eax
  803aac:	85 c0                	test   %eax,%eax
  803aae:	74 15                	je     803ac5 <free_block+0xc7>
  803ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab3:	c1 e0 04             	shl    $0x4,%eax
  803ab6:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803abb:	8b 00                	mov    (%eax),%eax
  803abd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ac0:	89 50 04             	mov    %edx,0x4(%eax)
  803ac3:	eb 11                	jmp    803ad6 <free_block+0xd8>
  803ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac8:	c1 e0 04             	shl    $0x4,%eax
  803acb:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad4:	89 02                	mov    %eax,(%edx)
  803ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad9:	c1 e0 04             	shl    $0x4,%eax
  803adc:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae5:	89 02                	mov    %eax,(%edx)
  803ae7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af4:	c1 e0 04             	shl    $0x4,%eax
  803af7:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803afc:	8b 00                	mov    (%eax),%eax
  803afe:	8d 50 01             	lea    0x1(%eax),%edx
  803b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b04:	c1 e0 04             	shl    $0x4,%eax
  803b07:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b0c:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b11:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b15:	40                   	inc    %eax
  803b16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b19:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b20:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b24:	0f b7 c8             	movzwl %ax,%ecx
  803b27:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b2c:	ba 00 00 00 00       	mov    $0x0,%edx
  803b31:	f7 75 e8             	divl   -0x18(%ebp)
  803b34:	39 c1                	cmp    %eax,%ecx
  803b36:	0f 85 ed 01 00 00    	jne    803d29 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3f:	c1 e0 04             	shl    $0x4,%eax
  803b42:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b47:	8b 00                	mov    (%eax),%eax
  803b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803b4c:	eb 2a                	jmp    803b78 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b51:	83 ec 0c             	sub    $0xc,%esp
  803b54:	50                   	push   %eax
  803b55:	e8 b0 f7 ff ff       	call   80330a <to_page_info>
  803b5a:	83 c4 10             	add    $0x10,%esp
  803b5d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803b60:	75 06                	jne    803b68 <free_block+0x16a>
				tmp = b;
  803b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b65:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6b:	c1 e0 04             	shl    $0x4,%eax
  803b6e:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803b73:	8b 00                	mov    (%eax),%eax
  803b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803b78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b7c:	74 07                	je     803b85 <free_block+0x187>
  803b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b81:	8b 00                	mov    (%eax),%eax
  803b83:	eb 05                	jmp    803b8a <free_block+0x18c>
  803b85:	b8 00 00 00 00       	mov    $0x0,%eax
  803b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b8d:	c1 e2 04             	shl    $0x4,%edx
  803b90:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803b96:	89 02                	mov    %eax,(%edx)
  803b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9b:	c1 e0 04             	shl    $0x4,%eax
  803b9e:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803ba3:	8b 00                	mov    (%eax),%eax
  803ba5:	85 c0                	test   %eax,%eax
  803ba7:	75 a5                	jne    803b4e <free_block+0x150>
  803ba9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bad:	75 9f                	jne    803b4e <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb2:	c1 e0 04             	shl    $0x4,%eax
  803bb5:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bba:	8b 00                	mov    (%eax),%eax
  803bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803bbf:	e9 cc 00 00 00       	jmp    803c90 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc7:	8b 00                	mov    (%eax),%eax
  803bc9:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bcf:	83 ec 0c             	sub    $0xc,%esp
  803bd2:	50                   	push   %eax
  803bd3:	e8 32 f7 ff ff       	call   80330a <to_page_info>
  803bd8:	83 c4 10             	add    $0x10,%esp
  803bdb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803bde:	0f 85 a6 00 00 00    	jne    803c8a <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803be4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803be8:	75 17                	jne    803c01 <free_block+0x203>
  803bea:	83 ec 04             	sub    $0x4,%esp
  803bed:	68 7d 4a 80 00       	push   $0x804a7d
  803bf2:	68 b5 00 00 00       	push   $0xb5
  803bf7:	68 e3 49 80 00       	push   $0x8049e3
  803bfc:	e8 a6 02 00 00       	call   803ea7 <_panic>
  803c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c04:	8b 00                	mov    (%eax),%eax
  803c06:	85 c0                	test   %eax,%eax
  803c08:	74 10                	je     803c1a <free_block+0x21c>
  803c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c0d:	8b 00                	mov    (%eax),%eax
  803c0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c12:	8b 52 04             	mov    0x4(%edx),%edx
  803c15:	89 50 04             	mov    %edx,0x4(%eax)
  803c18:	eb 14                	jmp    803c2e <free_block+0x230>
  803c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c1d:	8b 40 04             	mov    0x4(%eax),%eax
  803c20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c23:	c1 e2 04             	shl    $0x4,%edx
  803c26:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803c2c:	89 02                	mov    %eax,(%edx)
  803c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c31:	8b 40 04             	mov    0x4(%eax),%eax
  803c34:	85 c0                	test   %eax,%eax
  803c36:	74 0f                	je     803c47 <free_block+0x249>
  803c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c3b:	8b 40 04             	mov    0x4(%eax),%eax
  803c3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c41:	8b 12                	mov    (%edx),%edx
  803c43:	89 10                	mov    %edx,(%eax)
  803c45:	eb 13                	jmp    803c5a <free_block+0x25c>
  803c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c4a:	8b 00                	mov    (%eax),%eax
  803c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c4f:	c1 e2 04             	shl    $0x4,%edx
  803c52:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803c58:	89 02                	mov    %eax,(%edx)
  803c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c70:	c1 e0 04             	shl    $0x4,%eax
  803c73:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c78:	8b 00                	mov    (%eax),%eax
  803c7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c80:	c1 e0 04             	shl    $0x4,%eax
  803c83:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c88:	89 10                	mov    %edx,(%eax)
			b = next;
  803c8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803c90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c94:	0f 85 2a ff ff ff    	jne    803bc4 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c9d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ca6:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803cac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cb0:	75 17                	jne    803cc9 <free_block+0x2cb>
  803cb2:	83 ec 04             	sub    $0x4,%esp
  803cb5:	68 ec 4a 80 00       	push   $0x804aec
  803cba:	68 bc 00 00 00       	push   $0xbc
  803cbf:	68 e3 49 80 00       	push   $0x8049e3
  803cc4:	e8 de 01 00 00       	call   803ea7 <_panic>
  803cc9:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803ccf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cd2:	89 10                	mov    %edx,(%eax)
  803cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cd7:	8b 00                	mov    (%eax),%eax
  803cd9:	85 c0                	test   %eax,%eax
  803cdb:	74 0d                	je     803cea <free_block+0x2ec>
  803cdd:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803ce2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ce5:	89 50 04             	mov    %edx,0x4(%eax)
  803ce8:	eb 08                	jmp    803cf2 <free_block+0x2f4>
  803cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ced:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cf5:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d04:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803d09:	40                   	inc    %eax
  803d0a:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803d0f:	83 ec 0c             	sub    $0xc,%esp
  803d12:	ff 75 ec             	pushl  -0x14(%ebp)
  803d15:	e8 7e f5 ff ff       	call   803298 <to_page_va>
  803d1a:	83 c4 10             	add    $0x10,%esp
  803d1d:	83 ec 0c             	sub    $0xc,%esp
  803d20:	50                   	push   %eax
  803d21:	e8 fe d7 ff ff       	call   801524 <return_page>
  803d26:	83 c4 10             	add    $0x10,%esp
	}
}
  803d29:	90                   	nop
  803d2a:	c9                   	leave  
  803d2b:	c3                   	ret    

00803d2c <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803d2c:	55                   	push   %ebp
  803d2d:	89 e5                	mov    %esp,%ebp
  803d2f:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803d32:	83 ec 04             	sub    $0x4,%esp
  803d35:	68 48 4b 80 00       	push   $0x804b48
  803d3a:	6a 07                	push   $0x7
  803d3c:	68 77 4b 80 00       	push   $0x804b77
  803d41:	e8 61 01 00 00       	call   803ea7 <_panic>

00803d46 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803d46:	55                   	push   %ebp
  803d47:	89 e5                	mov    %esp,%ebp
  803d49:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803d4c:	83 ec 04             	sub    $0x4,%esp
  803d4f:	68 88 4b 80 00       	push   $0x804b88
  803d54:	6a 0b                	push   $0xb
  803d56:	68 77 4b 80 00       	push   $0x804b77
  803d5b:	e8 47 01 00 00       	call   803ea7 <_panic>

00803d60 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803d60:	55                   	push   %ebp
  803d61:	89 e5                	mov    %esp,%ebp
  803d63:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803d66:	83 ec 04             	sub    $0x4,%esp
  803d69:	68 b4 4b 80 00       	push   $0x804bb4
  803d6e:	6a 10                	push   $0x10
  803d70:	68 77 4b 80 00       	push   $0x804b77
  803d75:	e8 2d 01 00 00       	call   803ea7 <_panic>

00803d7a <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803d7a:	55                   	push   %ebp
  803d7b:	89 e5                	mov    %esp,%ebp
  803d7d:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803d80:	83 ec 04             	sub    $0x4,%esp
  803d83:	68 e4 4b 80 00       	push   $0x804be4
  803d88:	6a 15                	push   $0x15
  803d8a:	68 77 4b 80 00       	push   $0x804b77
  803d8f:	e8 13 01 00 00       	call   803ea7 <_panic>

00803d94 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803d94:	55                   	push   %ebp
  803d95:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803d97:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9a:	8b 40 10             	mov    0x10(%eax),%eax
}
  803d9d:	5d                   	pop    %ebp
  803d9e:	c3                   	ret    

00803d9f <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803d9f:	55                   	push   %ebp
  803da0:	89 e5                	mov    %esp,%ebp
  803da2:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803da5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803da9:	74 1c                	je     803dc7 <init_uspinlock+0x28>
  803dab:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803daf:	74 16                	je     803dc7 <init_uspinlock+0x28>
  803db1:	68 14 4c 80 00       	push   $0x804c14
  803db6:	68 33 4c 80 00       	push   $0x804c33
  803dbb:	6a 10                	push   $0x10
  803dbd:	68 48 4c 80 00       	push   $0x804c48
  803dc2:	e8 e0 00 00 00       	call   803ea7 <_panic>
	strcpy(lk->name, name);
  803dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803dca:	83 c0 04             	add    $0x4,%eax
  803dcd:	83 ec 08             	sub    $0x8,%esp
  803dd0:	ff 75 0c             	pushl  0xc(%ebp)
  803dd3:	50                   	push   %eax
  803dd4:	e8 f1 ce ff ff       	call   800cca <strcpy>
  803dd9:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  803ddc:	b8 01 00 00 00       	mov    $0x1,%eax
  803de1:	2b 45 10             	sub    0x10(%ebp),%eax
  803de4:	89 c2                	mov    %eax,%edx
  803de6:	8b 45 08             	mov    0x8(%ebp),%eax
  803de9:	89 10                	mov    %edx,(%eax)
}
  803deb:	90                   	nop
  803dec:	c9                   	leave  
  803ded:	c3                   	ret    

00803dee <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  803dee:	55                   	push   %ebp
  803def:	89 e5                	mov    %esp,%ebp
  803df1:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803df4:	90                   	nop
  803df5:	8b 45 08             	mov    0x8(%ebp),%eax
  803df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dfb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e08:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803e0b:	f0 87 02             	lock xchg %eax,(%edx)
  803e0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  803e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e14:	85 c0                	test   %eax,%eax
  803e16:	75 dd                	jne    803df5 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803e18:	8b 45 08             	mov    0x8(%ebp),%eax
  803e1b:	8d 48 04             	lea    0x4(%eax),%ecx
  803e1e:	a1 20 50 80 00       	mov    0x805020,%eax
  803e23:	8d 50 20             	lea    0x20(%eax),%edx
  803e26:	a1 20 50 80 00       	mov    0x805020,%eax
  803e2b:	8b 40 10             	mov    0x10(%eax),%eax
  803e2e:	51                   	push   %ecx
  803e2f:	52                   	push   %edx
  803e30:	50                   	push   %eax
  803e31:	68 58 4c 80 00       	push   $0x804c58
  803e36:	e8 67 c7 ff ff       	call   8005a2 <cprintf>
  803e3b:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  803e3e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  803e43:	90                   	nop
  803e44:	c9                   	leave  
  803e45:	c3                   	ret    

00803e46 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  803e46:	55                   	push   %ebp
  803e47:	89 e5                	mov    %esp,%ebp
  803e49:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  803e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4f:	8b 00                	mov    (%eax),%eax
  803e51:	85 c0                	test   %eax,%eax
  803e53:	75 18                	jne    803e6d <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  803e55:	8b 45 08             	mov    0x8(%ebp),%eax
  803e58:	83 c0 04             	add    $0x4,%eax
  803e5b:	50                   	push   %eax
  803e5c:	68 7c 4c 80 00       	push   $0x804c7c
  803e61:	6a 2b                	push   $0x2b
  803e63:	68 48 4c 80 00       	push   $0x804c48
  803e68:	e8 3a 00 00 00       	call   803ea7 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  803e6d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  803e72:	8b 45 08             	mov    0x8(%ebp),%eax
  803e75:	8b 55 08             	mov    0x8(%ebp),%edx
  803e78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e81:	8d 48 04             	lea    0x4(%eax),%ecx
  803e84:	a1 20 50 80 00       	mov    0x805020,%eax
  803e89:	8d 50 20             	lea    0x20(%eax),%edx
  803e8c:	a1 20 50 80 00       	mov    0x805020,%eax
  803e91:	8b 40 10             	mov    0x10(%eax),%eax
  803e94:	51                   	push   %ecx
  803e95:	52                   	push   %edx
  803e96:	50                   	push   %eax
  803e97:	68 9c 4c 80 00       	push   $0x804c9c
  803e9c:	e8 01 c7 ff ff       	call   8005a2 <cprintf>
  803ea1:	83 c4 10             	add    $0x10,%esp
}
  803ea4:	90                   	nop
  803ea5:	c9                   	leave  
  803ea6:	c3                   	ret    

00803ea7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803ea7:	55                   	push   %ebp
  803ea8:	89 e5                	mov    %esp,%ebp
  803eaa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803ead:	8d 45 10             	lea    0x10(%ebp),%eax
  803eb0:	83 c0 04             	add    $0x4,%eax
  803eb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803eb6:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803ebb:	85 c0                	test   %eax,%eax
  803ebd:	74 16                	je     803ed5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803ebf:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803ec4:	83 ec 08             	sub    $0x8,%esp
  803ec7:	50                   	push   %eax
  803ec8:	68 c0 4c 80 00       	push   $0x804cc0
  803ecd:	e8 d0 c6 ff ff       	call   8005a2 <cprintf>
  803ed2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803ed5:	a1 04 50 80 00       	mov    0x805004,%eax
  803eda:	83 ec 0c             	sub    $0xc,%esp
  803edd:	ff 75 0c             	pushl  0xc(%ebp)
  803ee0:	ff 75 08             	pushl  0x8(%ebp)
  803ee3:	50                   	push   %eax
  803ee4:	68 c8 4c 80 00       	push   $0x804cc8
  803ee9:	6a 74                	push   $0x74
  803eeb:	e8 df c6 ff ff       	call   8005cf <cprintf_colored>
  803ef0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803ef3:	8b 45 10             	mov    0x10(%ebp),%eax
  803ef6:	83 ec 08             	sub    $0x8,%esp
  803ef9:	ff 75 f4             	pushl  -0xc(%ebp)
  803efc:	50                   	push   %eax
  803efd:	e8 31 c6 ff ff       	call   800533 <vcprintf>
  803f02:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803f05:	83 ec 08             	sub    $0x8,%esp
  803f08:	6a 00                	push   $0x0
  803f0a:	68 f0 4c 80 00       	push   $0x804cf0
  803f0f:	e8 1f c6 ff ff       	call   800533 <vcprintf>
  803f14:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803f17:	e8 98 c5 ff ff       	call   8004b4 <exit>

	// should not return here
	while (1) ;
  803f1c:	eb fe                	jmp    803f1c <_panic+0x75>

00803f1e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803f1e:	55                   	push   %ebp
  803f1f:	89 e5                	mov    %esp,%ebp
  803f21:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803f24:	a1 20 50 80 00       	mov    0x805020,%eax
  803f29:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f32:	39 c2                	cmp    %eax,%edx
  803f34:	74 14                	je     803f4a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803f36:	83 ec 04             	sub    $0x4,%esp
  803f39:	68 f4 4c 80 00       	push   $0x804cf4
  803f3e:	6a 26                	push   $0x26
  803f40:	68 40 4d 80 00       	push   $0x804d40
  803f45:	e8 5d ff ff ff       	call   803ea7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803f4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803f51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803f58:	e9 c5 00 00 00       	jmp    804022 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f60:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803f67:	8b 45 08             	mov    0x8(%ebp),%eax
  803f6a:	01 d0                	add    %edx,%eax
  803f6c:	8b 00                	mov    (%eax),%eax
  803f6e:	85 c0                	test   %eax,%eax
  803f70:	75 08                	jne    803f7a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803f72:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803f75:	e9 a5 00 00 00       	jmp    80401f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803f7a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803f81:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803f88:	eb 69                	jmp    803ff3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803f8a:	a1 20 50 80 00       	mov    0x805020,%eax
  803f8f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803f95:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f98:	89 d0                	mov    %edx,%eax
  803f9a:	01 c0                	add    %eax,%eax
  803f9c:	01 d0                	add    %edx,%eax
  803f9e:	c1 e0 03             	shl    $0x3,%eax
  803fa1:	01 c8                	add    %ecx,%eax
  803fa3:	8a 40 04             	mov    0x4(%eax),%al
  803fa6:	84 c0                	test   %al,%al
  803fa8:	75 46                	jne    803ff0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803faa:	a1 20 50 80 00       	mov    0x805020,%eax
  803faf:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803fb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fb8:	89 d0                	mov    %edx,%eax
  803fba:	01 c0                	add    %eax,%eax
  803fbc:	01 d0                	add    %edx,%eax
  803fbe:	c1 e0 03             	shl    $0x3,%eax
  803fc1:	01 c8                	add    %ecx,%eax
  803fc3:	8b 00                	mov    (%eax),%eax
  803fc5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803fc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803fd0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fd5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  803fdf:	01 c8                	add    %ecx,%eax
  803fe1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803fe3:	39 c2                	cmp    %eax,%edx
  803fe5:	75 09                	jne    803ff0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803fe7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803fee:	eb 15                	jmp    804005 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ff0:	ff 45 e8             	incl   -0x18(%ebp)
  803ff3:	a1 20 50 80 00       	mov    0x805020,%eax
  803ff8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804001:	39 c2                	cmp    %eax,%edx
  804003:	77 85                	ja     803f8a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  804005:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804009:	75 14                	jne    80401f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80400b:	83 ec 04             	sub    $0x4,%esp
  80400e:	68 4c 4d 80 00       	push   $0x804d4c
  804013:	6a 3a                	push   $0x3a
  804015:	68 40 4d 80 00       	push   $0x804d40
  80401a:	e8 88 fe ff ff       	call   803ea7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80401f:	ff 45 f0             	incl   -0x10(%ebp)
  804022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804025:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804028:	0f 8c 2f ff ff ff    	jl     803f5d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80402e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804035:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80403c:	eb 26                	jmp    804064 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80403e:	a1 20 50 80 00       	mov    0x805020,%eax
  804043:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  804049:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80404c:	89 d0                	mov    %edx,%eax
  80404e:	01 c0                	add    %eax,%eax
  804050:	01 d0                	add    %edx,%eax
  804052:	c1 e0 03             	shl    $0x3,%eax
  804055:	01 c8                	add    %ecx,%eax
  804057:	8a 40 04             	mov    0x4(%eax),%al
  80405a:	3c 01                	cmp    $0x1,%al
  80405c:	75 03                	jne    804061 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80405e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804061:	ff 45 e0             	incl   -0x20(%ebp)
  804064:	a1 20 50 80 00       	mov    0x805020,%eax
  804069:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80406f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804072:	39 c2                	cmp    %eax,%edx
  804074:	77 c8                	ja     80403e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  804076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804079:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80407c:	74 14                	je     804092 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80407e:	83 ec 04             	sub    $0x4,%esp
  804081:	68 a0 4d 80 00       	push   $0x804da0
  804086:	6a 44                	push   $0x44
  804088:	68 40 4d 80 00       	push   $0x804d40
  80408d:	e8 15 fe ff ff       	call   803ea7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  804092:	90                   	nop
  804093:	c9                   	leave  
  804094:	c3                   	ret    
  804095:	66 90                	xchg   %ax,%ax
  804097:	90                   	nop

00804098 <__udivdi3>:
  804098:	55                   	push   %ebp
  804099:	57                   	push   %edi
  80409a:	56                   	push   %esi
  80409b:	53                   	push   %ebx
  80409c:	83 ec 1c             	sub    $0x1c,%esp
  80409f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040af:	89 ca                	mov    %ecx,%edx
  8040b1:	89 f8                	mov    %edi,%eax
  8040b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040b7:	85 f6                	test   %esi,%esi
  8040b9:	75 2d                	jne    8040e8 <__udivdi3+0x50>
  8040bb:	39 cf                	cmp    %ecx,%edi
  8040bd:	77 65                	ja     804124 <__udivdi3+0x8c>
  8040bf:	89 fd                	mov    %edi,%ebp
  8040c1:	85 ff                	test   %edi,%edi
  8040c3:	75 0b                	jne    8040d0 <__udivdi3+0x38>
  8040c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8040ca:	31 d2                	xor    %edx,%edx
  8040cc:	f7 f7                	div    %edi
  8040ce:	89 c5                	mov    %eax,%ebp
  8040d0:	31 d2                	xor    %edx,%edx
  8040d2:	89 c8                	mov    %ecx,%eax
  8040d4:	f7 f5                	div    %ebp
  8040d6:	89 c1                	mov    %eax,%ecx
  8040d8:	89 d8                	mov    %ebx,%eax
  8040da:	f7 f5                	div    %ebp
  8040dc:	89 cf                	mov    %ecx,%edi
  8040de:	89 fa                	mov    %edi,%edx
  8040e0:	83 c4 1c             	add    $0x1c,%esp
  8040e3:	5b                   	pop    %ebx
  8040e4:	5e                   	pop    %esi
  8040e5:	5f                   	pop    %edi
  8040e6:	5d                   	pop    %ebp
  8040e7:	c3                   	ret    
  8040e8:	39 ce                	cmp    %ecx,%esi
  8040ea:	77 28                	ja     804114 <__udivdi3+0x7c>
  8040ec:	0f bd fe             	bsr    %esi,%edi
  8040ef:	83 f7 1f             	xor    $0x1f,%edi
  8040f2:	75 40                	jne    804134 <__udivdi3+0x9c>
  8040f4:	39 ce                	cmp    %ecx,%esi
  8040f6:	72 0a                	jb     804102 <__udivdi3+0x6a>
  8040f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040fc:	0f 87 9e 00 00 00    	ja     8041a0 <__udivdi3+0x108>
  804102:	b8 01 00 00 00       	mov    $0x1,%eax
  804107:	89 fa                	mov    %edi,%edx
  804109:	83 c4 1c             	add    $0x1c,%esp
  80410c:	5b                   	pop    %ebx
  80410d:	5e                   	pop    %esi
  80410e:	5f                   	pop    %edi
  80410f:	5d                   	pop    %ebp
  804110:	c3                   	ret    
  804111:	8d 76 00             	lea    0x0(%esi),%esi
  804114:	31 ff                	xor    %edi,%edi
  804116:	31 c0                	xor    %eax,%eax
  804118:	89 fa                	mov    %edi,%edx
  80411a:	83 c4 1c             	add    $0x1c,%esp
  80411d:	5b                   	pop    %ebx
  80411e:	5e                   	pop    %esi
  80411f:	5f                   	pop    %edi
  804120:	5d                   	pop    %ebp
  804121:	c3                   	ret    
  804122:	66 90                	xchg   %ax,%ax
  804124:	89 d8                	mov    %ebx,%eax
  804126:	f7 f7                	div    %edi
  804128:	31 ff                	xor    %edi,%edi
  80412a:	89 fa                	mov    %edi,%edx
  80412c:	83 c4 1c             	add    $0x1c,%esp
  80412f:	5b                   	pop    %ebx
  804130:	5e                   	pop    %esi
  804131:	5f                   	pop    %edi
  804132:	5d                   	pop    %ebp
  804133:	c3                   	ret    
  804134:	bd 20 00 00 00       	mov    $0x20,%ebp
  804139:	89 eb                	mov    %ebp,%ebx
  80413b:	29 fb                	sub    %edi,%ebx
  80413d:	89 f9                	mov    %edi,%ecx
  80413f:	d3 e6                	shl    %cl,%esi
  804141:	89 c5                	mov    %eax,%ebp
  804143:	88 d9                	mov    %bl,%cl
  804145:	d3 ed                	shr    %cl,%ebp
  804147:	89 e9                	mov    %ebp,%ecx
  804149:	09 f1                	or     %esi,%ecx
  80414b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80414f:	89 f9                	mov    %edi,%ecx
  804151:	d3 e0                	shl    %cl,%eax
  804153:	89 c5                	mov    %eax,%ebp
  804155:	89 d6                	mov    %edx,%esi
  804157:	88 d9                	mov    %bl,%cl
  804159:	d3 ee                	shr    %cl,%esi
  80415b:	89 f9                	mov    %edi,%ecx
  80415d:	d3 e2                	shl    %cl,%edx
  80415f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804163:	88 d9                	mov    %bl,%cl
  804165:	d3 e8                	shr    %cl,%eax
  804167:	09 c2                	or     %eax,%edx
  804169:	89 d0                	mov    %edx,%eax
  80416b:	89 f2                	mov    %esi,%edx
  80416d:	f7 74 24 0c          	divl   0xc(%esp)
  804171:	89 d6                	mov    %edx,%esi
  804173:	89 c3                	mov    %eax,%ebx
  804175:	f7 e5                	mul    %ebp
  804177:	39 d6                	cmp    %edx,%esi
  804179:	72 19                	jb     804194 <__udivdi3+0xfc>
  80417b:	74 0b                	je     804188 <__udivdi3+0xf0>
  80417d:	89 d8                	mov    %ebx,%eax
  80417f:	31 ff                	xor    %edi,%edi
  804181:	e9 58 ff ff ff       	jmp    8040de <__udivdi3+0x46>
  804186:	66 90                	xchg   %ax,%ax
  804188:	8b 54 24 08          	mov    0x8(%esp),%edx
  80418c:	89 f9                	mov    %edi,%ecx
  80418e:	d3 e2                	shl    %cl,%edx
  804190:	39 c2                	cmp    %eax,%edx
  804192:	73 e9                	jae    80417d <__udivdi3+0xe5>
  804194:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804197:	31 ff                	xor    %edi,%edi
  804199:	e9 40 ff ff ff       	jmp    8040de <__udivdi3+0x46>
  80419e:	66 90                	xchg   %ax,%ax
  8041a0:	31 c0                	xor    %eax,%eax
  8041a2:	e9 37 ff ff ff       	jmp    8040de <__udivdi3+0x46>
  8041a7:	90                   	nop

008041a8 <__umoddi3>:
  8041a8:	55                   	push   %ebp
  8041a9:	57                   	push   %edi
  8041aa:	56                   	push   %esi
  8041ab:	53                   	push   %ebx
  8041ac:	83 ec 1c             	sub    $0x1c,%esp
  8041af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8041c7:	89 f3                	mov    %esi,%ebx
  8041c9:	89 fa                	mov    %edi,%edx
  8041cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041cf:	89 34 24             	mov    %esi,(%esp)
  8041d2:	85 c0                	test   %eax,%eax
  8041d4:	75 1a                	jne    8041f0 <__umoddi3+0x48>
  8041d6:	39 f7                	cmp    %esi,%edi
  8041d8:	0f 86 a2 00 00 00    	jbe    804280 <__umoddi3+0xd8>
  8041de:	89 c8                	mov    %ecx,%eax
  8041e0:	89 f2                	mov    %esi,%edx
  8041e2:	f7 f7                	div    %edi
  8041e4:	89 d0                	mov    %edx,%eax
  8041e6:	31 d2                	xor    %edx,%edx
  8041e8:	83 c4 1c             	add    $0x1c,%esp
  8041eb:	5b                   	pop    %ebx
  8041ec:	5e                   	pop    %esi
  8041ed:	5f                   	pop    %edi
  8041ee:	5d                   	pop    %ebp
  8041ef:	c3                   	ret    
  8041f0:	39 f0                	cmp    %esi,%eax
  8041f2:	0f 87 ac 00 00 00    	ja     8042a4 <__umoddi3+0xfc>
  8041f8:	0f bd e8             	bsr    %eax,%ebp
  8041fb:	83 f5 1f             	xor    $0x1f,%ebp
  8041fe:	0f 84 ac 00 00 00    	je     8042b0 <__umoddi3+0x108>
  804204:	bf 20 00 00 00       	mov    $0x20,%edi
  804209:	29 ef                	sub    %ebp,%edi
  80420b:	89 fe                	mov    %edi,%esi
  80420d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804211:	89 e9                	mov    %ebp,%ecx
  804213:	d3 e0                	shl    %cl,%eax
  804215:	89 d7                	mov    %edx,%edi
  804217:	89 f1                	mov    %esi,%ecx
  804219:	d3 ef                	shr    %cl,%edi
  80421b:	09 c7                	or     %eax,%edi
  80421d:	89 e9                	mov    %ebp,%ecx
  80421f:	d3 e2                	shl    %cl,%edx
  804221:	89 14 24             	mov    %edx,(%esp)
  804224:	89 d8                	mov    %ebx,%eax
  804226:	d3 e0                	shl    %cl,%eax
  804228:	89 c2                	mov    %eax,%edx
  80422a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80422e:	d3 e0                	shl    %cl,%eax
  804230:	89 44 24 04          	mov    %eax,0x4(%esp)
  804234:	8b 44 24 08          	mov    0x8(%esp),%eax
  804238:	89 f1                	mov    %esi,%ecx
  80423a:	d3 e8                	shr    %cl,%eax
  80423c:	09 d0                	or     %edx,%eax
  80423e:	d3 eb                	shr    %cl,%ebx
  804240:	89 da                	mov    %ebx,%edx
  804242:	f7 f7                	div    %edi
  804244:	89 d3                	mov    %edx,%ebx
  804246:	f7 24 24             	mull   (%esp)
  804249:	89 c6                	mov    %eax,%esi
  80424b:	89 d1                	mov    %edx,%ecx
  80424d:	39 d3                	cmp    %edx,%ebx
  80424f:	0f 82 87 00 00 00    	jb     8042dc <__umoddi3+0x134>
  804255:	0f 84 91 00 00 00    	je     8042ec <__umoddi3+0x144>
  80425b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80425f:	29 f2                	sub    %esi,%edx
  804261:	19 cb                	sbb    %ecx,%ebx
  804263:	89 d8                	mov    %ebx,%eax
  804265:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804269:	d3 e0                	shl    %cl,%eax
  80426b:	89 e9                	mov    %ebp,%ecx
  80426d:	d3 ea                	shr    %cl,%edx
  80426f:	09 d0                	or     %edx,%eax
  804271:	89 e9                	mov    %ebp,%ecx
  804273:	d3 eb                	shr    %cl,%ebx
  804275:	89 da                	mov    %ebx,%edx
  804277:	83 c4 1c             	add    $0x1c,%esp
  80427a:	5b                   	pop    %ebx
  80427b:	5e                   	pop    %esi
  80427c:	5f                   	pop    %edi
  80427d:	5d                   	pop    %ebp
  80427e:	c3                   	ret    
  80427f:	90                   	nop
  804280:	89 fd                	mov    %edi,%ebp
  804282:	85 ff                	test   %edi,%edi
  804284:	75 0b                	jne    804291 <__umoddi3+0xe9>
  804286:	b8 01 00 00 00       	mov    $0x1,%eax
  80428b:	31 d2                	xor    %edx,%edx
  80428d:	f7 f7                	div    %edi
  80428f:	89 c5                	mov    %eax,%ebp
  804291:	89 f0                	mov    %esi,%eax
  804293:	31 d2                	xor    %edx,%edx
  804295:	f7 f5                	div    %ebp
  804297:	89 c8                	mov    %ecx,%eax
  804299:	f7 f5                	div    %ebp
  80429b:	89 d0                	mov    %edx,%eax
  80429d:	e9 44 ff ff ff       	jmp    8041e6 <__umoddi3+0x3e>
  8042a2:	66 90                	xchg   %ax,%ax
  8042a4:	89 c8                	mov    %ecx,%eax
  8042a6:	89 f2                	mov    %esi,%edx
  8042a8:	83 c4 1c             	add    $0x1c,%esp
  8042ab:	5b                   	pop    %ebx
  8042ac:	5e                   	pop    %esi
  8042ad:	5f                   	pop    %edi
  8042ae:	5d                   	pop    %ebp
  8042af:	c3                   	ret    
  8042b0:	3b 04 24             	cmp    (%esp),%eax
  8042b3:	72 06                	jb     8042bb <__umoddi3+0x113>
  8042b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042b9:	77 0f                	ja     8042ca <__umoddi3+0x122>
  8042bb:	89 f2                	mov    %esi,%edx
  8042bd:	29 f9                	sub    %edi,%ecx
  8042bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042c3:	89 14 24             	mov    %edx,(%esp)
  8042c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8042ce:	8b 14 24             	mov    (%esp),%edx
  8042d1:	83 c4 1c             	add    $0x1c,%esp
  8042d4:	5b                   	pop    %ebx
  8042d5:	5e                   	pop    %esi
  8042d6:	5f                   	pop    %edi
  8042d7:	5d                   	pop    %ebp
  8042d8:	c3                   	ret    
  8042d9:	8d 76 00             	lea    0x0(%esi),%esi
  8042dc:	2b 04 24             	sub    (%esp),%eax
  8042df:	19 fa                	sbb    %edi,%edx
  8042e1:	89 d1                	mov    %edx,%ecx
  8042e3:	89 c6                	mov    %eax,%esi
  8042e5:	e9 71 ff ff ff       	jmp    80425b <__umoddi3+0xb3>
  8042ea:	66 90                	xchg   %ax,%ax
  8042ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042f0:	72 ea                	jb     8042dc <__umoddi3+0x134>
  8042f2:	89 d9                	mov    %ebx,%ecx
  8042f4:	e9 62 ff ff ff       	jmp    80425b <__umoddi3+0xb3>
