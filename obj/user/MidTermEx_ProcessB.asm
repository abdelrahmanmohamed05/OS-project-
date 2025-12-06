
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 5d 02 00 00       	call   800293 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
extern volatile bool printStats;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	printStats = 0;
  80003e:	c7 05 00 50 80 00 00 	movl   $0x0,0x805000
  800045:	00 00 00 

	int32 parentenvID = sys_getparentenvid();
  800048:	e8 22 2f 00 00       	call   802f6f <sys_getparentenvid>
  80004d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	68 40 43 80 00       	push   $0x804340
  800058:	ff 75 ec             	pushl  -0x14(%ebp)
  80005b:	e8 4c 1f 00 00       	call   801fac <sget>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int *protType = sget(parentenvID, "protType") ;
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	68 42 43 80 00       	push   $0x804342
  80006e:	ff 75 ec             	pushl  -0x14(%ebp)
  800071:	e8 36 1f 00 00       	call   801fac <sget>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int * finishedCount = sget(parentenvID, "finishedCount") ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	68 4b 43 80 00       	push   $0x80434b
  800084:	ff 75 ec             	pushl  -0x14(%ebp)
  800087:	e8 20 1f 00 00       	call   801fac <sget>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	struct semaphore T, finished, finishedCountMutex ;
	struct uspinlock *sT, *sfinishedCountMutex;

	if (*protType == 1)
  800092:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800095:	8b 00                	mov    (%eax),%eax
  800097:	83 f8 01             	cmp    $0x1,%eax
  80009a:	75 47                	jne    8000e3 <_main+0xab>
	{
		T = get_semaphore(parentenvID, "T");
  80009c:	8d 45 bc             	lea    -0x44(%ebp),%eax
  80009f:	83 ec 04             	sub    $0x4,%esp
  8000a2:	68 59 43 80 00       	push   $0x804359
  8000a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8000aa:	50                   	push   %eax
  8000ab:	e8 17 3c 00 00       	call   803cc7 <get_semaphore>
  8000b0:	83 c4 0c             	add    $0xc,%esp
		finished = get_semaphore(parentenvID, "finished");
  8000b3:	8d 45 b8             	lea    -0x48(%ebp),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	68 5b 43 80 00       	push   $0x80435b
  8000be:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	e8 00 3c 00 00       	call   803cc7 <get_semaphore>
  8000c7:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = get_semaphore(parentenvID, "finishedCountMutex");
  8000ca:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 64 43 80 00       	push   $0x804364
  8000d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d8:	50                   	push   %eax
  8000d9:	e8 e9 3b 00 00       	call   803cc7 <get_semaphore>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	eb 36                	jmp    800119 <_main+0xe1>
	}
	else if (*protType == 2)
  8000e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e6:	8b 00                	mov    (%eax),%eax
  8000e8:	83 f8 02             	cmp    $0x2,%eax
  8000eb:	75 2c                	jne    800119 <_main+0xe1>
	{
		sT = sget(parentenvID, "T");
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	68 59 43 80 00       	push   $0x804359
  8000f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f8:	e8 af 1e 00 00       	call   801fac <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		sfinishedCountMutex = sget(parentenvID, "finishedCountMutex");
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 64 43 80 00       	push   $0x804364
  80010b:	ff 75 ec             	pushl  -0x14(%ebp)
  80010e:	e8 99 1e 00 00       	call   801fac <sget>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	/*[2] DO THE JOB*/
	int Z ;
	if (*protType == 1)
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	83 f8 01             	cmp    $0x1,%eax
  800121:	75 10                	jne    800133 <_main+0xfb>
	{
		wait_semaphore(T);
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	ff 75 bc             	pushl  -0x44(%ebp)
  800129:	e8 b3 3b 00 00       	call   803ce1 <wait_semaphore>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	eb 18                	jmp    80014b <_main+0x113>
	}
	else if (*protType == 2)
  800133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800136:	8b 00                	mov    (%eax),%eax
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	75 0e                	jne    80014b <_main+0x113>
	{
		acquire_uspinlock(sT);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 f4             	pushl  -0xc(%ebp)
  800143:	e8 e5 3c 00 00       	call   803e2d <acquire_uspinlock>
  800148:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  80014b:	8d 45 c0             	lea    -0x40(%ebp),%eax
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	50                   	push   %eax
  800152:	e8 4b 2e 00 00       	call   802fa2 <sys_get_virtual_time>
  800157:	83 c4 0c             	add    $0xc,%esp
  80015a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80015d:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800162:	ba 00 00 00 00       	mov    $0x0,%edx
  800167:	f7 f1                	div    %ecx
  800169:	89 d0                	mov    %edx,%eax
  80016b:	05 d0 07 00 00       	add    $0x7d0,%eax
  800170:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800173:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	50                   	push   %eax
  80017a:	e8 a1 3b 00 00       	call   803d20 <env_sleep>
  80017f:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  800182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800185:	8b 00                	mov    (%eax),%eax
  800187:	40                   	inc    %eax
  800188:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  80018b:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	50                   	push   %eax
  800192:	e8 0b 2e 00 00       	call   802fa2 <sys_get_virtual_time>
  800197:	83 c4 0c             	add    $0xc,%esp
  80019a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80019d:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a7:	f7 f1                	div    %ecx
  8001a9:	89 d0                	mov    %edx,%eax
  8001ab:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	50                   	push   %eax
  8001ba:	e8 61 3b 00 00       	call   803d20 <env_sleep>
  8001bf:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001c8:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  8001ca:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	50                   	push   %eax
  8001d1:	e8 cc 2d 00 00       	call   802fa2 <sys_get_virtual_time>
  8001d6:	83 c4 0c             	add    $0xc,%esp
  8001d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001dc:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8001e6:	f7 f1                	div    %ecx
  8001e8:	89 d0                	mov    %edx,%eax
  8001ea:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 22 3b 00 00       	call   803d20 <env_sleep>
  8001fe:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	if (*protType == 1)
  800201:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800204:	8b 00                	mov    (%eax),%eax
  800206:	83 f8 01             	cmp    $0x1,%eax
  800209:	75 39                	jne    800244 <_main+0x20c>
	{
		signal_semaphore(finished);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 b8             	pushl  -0x48(%ebp)
  800211:	e8 e5 3a 00 00       	call   803cfb <signal_semaphore>
  800216:	83 c4 10             	add    $0x10,%esp

		wait_semaphore(finishedCountMutex);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	ff 75 b4             	pushl  -0x4c(%ebp)
  80021f:	e8 bd 3a 00 00       	call   803ce1 <wait_semaphore>
  800224:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  800227:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022a:	8b 00                	mov    (%eax),%eax
  80022c:	8d 50 01             	lea    0x1(%eax),%edx
  80022f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800232:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(finishedCountMutex);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	ff 75 b4             	pushl  -0x4c(%ebp)
  80023a:	e8 bc 3a 00 00       	call   803cfb <signal_semaphore>
  80023f:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
		}
		sys_unlock_cons();
	}
}
  800242:	eb 4c                	jmp    800290 <_main+0x258>
		{
			(*finishedCount)++ ;
		}
		signal_semaphore(finishedCountMutex);
	}
	else if (*protType == 2)
  800244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800247:	8b 00                	mov    (%eax),%eax
  800249:	83 f8 02             	cmp    $0x2,%eax
  80024c:	75 2b                	jne    800279 <_main+0x241>
	{
		acquire_uspinlock(sfinishedCountMutex);
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	ff 75 f0             	pushl  -0x10(%ebp)
  800254:	e8 d4 3b 00 00       	call   803e2d <acquire_uspinlock>
  800259:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  80025c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80025f:	8b 00                	mov    (%eax),%eax
  800261:	8d 50 01             	lea    0x1(%eax),%edx
  800264:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800267:	89 10                	mov    %edx,(%eax)
		}
		release_uspinlock(sfinishedCountMutex);
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	ff 75 f0             	pushl  -0x10(%ebp)
  80026f:	e8 11 3c 00 00       	call   803e85 <release_uspinlock>
  800274:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
		}
		sys_unlock_cons();
	}
}
  800277:	eb 17                	jmp    800290 <_main+0x258>
			(*finishedCount)++ ;
		}
		release_uspinlock(sfinishedCountMutex);
	}else
	{
		sys_lock_cons();
  800279:	e8 5f 2a 00 00       	call   802cdd <sys_lock_cons>
		{
			(*finishedCount)++ ;
  80027e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800281:	8b 00                	mov    (%eax),%eax
  800283:	8d 50 01             	lea    0x1(%eax),%edx
  800286:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800289:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80028b:	e8 67 2a 00 00       	call   802cf7 <sys_unlock_cons>
	}
}
  800290:	90                   	nop
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	57                   	push   %edi
  800297:	56                   	push   %esi
  800298:	53                   	push   %ebx
  800299:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80029c:	e8 b5 2c 00 00       	call   802f56 <sys_getenvindex>
  8002a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a7:	89 d0                	mov    %edx,%eax
  8002a9:	c1 e0 03             	shl    $0x3,%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	c1 e0 02             	shl    $0x2,%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ba:	01 d0                	add    %edx,%eax
  8002bc:	c1 e0 03             	shl    $0x3,%eax
  8002bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002c4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ce:	8a 40 20             	mov    0x20(%eax),%al
  8002d1:	84 c0                	test   %al,%al
  8002d3:	74 0d                	je     8002e2 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8002da:	83 c0 20             	add    $0x20,%eax
  8002dd:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e6:	7e 0a                	jle    8002f2 <libmain+0x5f>
		binaryname = argv[0];
  8002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	ff 75 0c             	pushl  0xc(%ebp)
  8002f8:	ff 75 08             	pushl  0x8(%ebp)
  8002fb:	e8 38 fd ff ff       	call   800038 <_main>
  800300:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800303:	a1 00 50 80 00       	mov    0x805000,%eax
  800308:	85 c0                	test   %eax,%eax
  80030a:	0f 84 01 01 00 00    	je     800411 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800310:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800316:	bb 70 44 80 00       	mov    $0x804470,%ebx
  80031b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800320:	89 c7                	mov    %eax,%edi
  800322:	89 de                	mov    %ebx,%esi
  800324:	89 d1                	mov    %edx,%ecx
  800326:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800328:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80032b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800330:	b0 00                	mov    $0x0,%al
  800332:	89 d7                	mov    %edx,%edi
  800334:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800336:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80033d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800340:	83 ec 08             	sub    $0x8,%esp
  800343:	50                   	push   %eax
  800344:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80034a:	50                   	push   %eax
  80034b:	e8 3c 2e 00 00       	call   80318c <sys_utilities>
  800350:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800353:	e8 85 29 00 00       	call   802cdd <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800358:	83 ec 0c             	sub    $0xc,%esp
  80035b:	68 90 43 80 00       	push   $0x804390
  800360:	e8 be 01 00 00       	call   800523 <cprintf>
  800365:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036b:	85 c0                	test   %eax,%eax
  80036d:	74 18                	je     800387 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80036f:	e8 36 2e 00 00       	call   8031aa <sys_get_optimal_num_faults>
  800374:	83 ec 08             	sub    $0x8,%esp
  800377:	50                   	push   %eax
  800378:	68 b8 43 80 00       	push   $0x8043b8
  80037d:	e8 a1 01 00 00       	call   800523 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp
  800385:	eb 59                	jmp    8003e0 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800387:	a1 20 50 80 00       	mov    0x805020,%eax
  80038c:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800392:	a1 20 50 80 00       	mov    0x805020,%eax
  800397:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	52                   	push   %edx
  8003a1:	50                   	push   %eax
  8003a2:	68 dc 43 80 00       	push   $0x8043dc
  8003a7:	e8 77 01 00 00       	call   800523 <cprintf>
  8003ac:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003af:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b4:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8003ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8003bf:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ca:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003d0:	51                   	push   %ecx
  8003d1:	52                   	push   %edx
  8003d2:	50                   	push   %eax
  8003d3:	68 04 44 80 00       	push   $0x804404
  8003d8:	e8 46 01 00 00       	call   800523 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e5:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	50                   	push   %eax
  8003ef:	68 5c 44 80 00       	push   $0x80445c
  8003f4:	e8 2a 01 00 00       	call   800523 <cprintf>
  8003f9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003fc:	83 ec 0c             	sub    $0xc,%esp
  8003ff:	68 90 43 80 00       	push   $0x804390
  800404:	e8 1a 01 00 00       	call   800523 <cprintf>
  800409:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80040c:	e8 e6 28 00 00       	call   802cf7 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800411:	e8 1f 00 00 00       	call   800435 <exit>
}
  800416:	90                   	nop
  800417:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041a:	5b                   	pop    %ebx
  80041b:	5e                   	pop    %esi
  80041c:	5f                   	pop    %edi
  80041d:	5d                   	pop    %ebp
  80041e:	c3                   	ret    

0080041f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800425:	83 ec 0c             	sub    $0xc,%esp
  800428:	6a 00                	push   $0x0
  80042a:	e8 f3 2a 00 00       	call   802f22 <sys_destroy_env>
  80042f:	83 c4 10             	add    $0x10,%esp
}
  800432:	90                   	nop
  800433:	c9                   	leave  
  800434:	c3                   	ret    

00800435 <exit>:

void
exit(void)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80043b:	e8 48 2b 00 00       	call   802f88 <sys_exit_env>
}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	53                   	push   %ebx
  800447:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80044a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	8d 48 01             	lea    0x1(%eax),%ecx
  800452:	8b 55 0c             	mov    0xc(%ebp),%edx
  800455:	89 0a                	mov    %ecx,(%edx)
  800457:	8b 55 08             	mov    0x8(%ebp),%edx
  80045a:	88 d1                	mov    %dl,%cl
  80045c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	3d ff 00 00 00       	cmp    $0xff,%eax
  80046d:	75 30                	jne    80049f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80046f:	8b 15 38 51 83 00    	mov    0x835138,%edx
  800475:	a0 64 d0 81 00       	mov    0x81d064,%al
  80047a:	0f b6 c0             	movzbl %al,%eax
  80047d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800480:	8b 09                	mov    (%ecx),%ecx
  800482:	89 cb                	mov    %ecx,%ebx
  800484:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800487:	83 c1 08             	add    $0x8,%ecx
  80048a:	52                   	push   %edx
  80048b:	50                   	push   %eax
  80048c:	53                   	push   %ebx
  80048d:	51                   	push   %ecx
  80048e:	e8 06 28 00 00       	call   802c99 <sys_cputs>
  800493:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
  800499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	8b 40 04             	mov    0x4(%eax),%eax
  8004a5:	8d 50 01             	lea    0x1(%eax),%edx
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ae:	90                   	nop
  8004af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c4:	00 00 00 
	b.cnt = 0;
  8004c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004ce:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d1:	ff 75 0c             	pushl  0xc(%ebp)
  8004d4:	ff 75 08             	pushl  0x8(%ebp)
  8004d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004dd:	50                   	push   %eax
  8004de:	68 43 04 80 00       	push   $0x800443
  8004e3:	e8 5a 02 00 00       	call   800742 <vprintfmt>
  8004e8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004eb:	8b 15 38 51 83 00    	mov    0x835138,%edx
  8004f1:	a0 64 d0 81 00       	mov    0x81d064,%al
  8004f6:	0f b6 c0             	movzbl %al,%eax
  8004f9:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004ff:	52                   	push   %edx
  800500:	50                   	push   %eax
  800501:	51                   	push   %ecx
  800502:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800508:	83 c0 08             	add    $0x8,%eax
  80050b:	50                   	push   %eax
  80050c:	e8 88 27 00 00       	call   802c99 <sys_cputs>
  800511:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800514:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  80051b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800521:	c9                   	leave  
  800522:	c3                   	ret    

00800523 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800529:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800530:	8d 45 0c             	lea    0xc(%ebp),%eax
  800533:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	ff 75 f4             	pushl  -0xc(%ebp)
  80053f:	50                   	push   %eax
  800540:	e8 6f ff ff ff       	call   8004b4 <vcprintf>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054e:	c9                   	leave  
  80054f:	c3                   	ret    

00800550 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800550:	55                   	push   %ebp
  800551:	89 e5                	mov    %esp,%ebp
  800553:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800556:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	c1 e0 08             	shl    $0x8,%eax
  800563:	a3 38 51 83 00       	mov    %eax,0x835138
	va_start(ap, fmt);
  800568:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056b:	83 c0 04             	add    $0x4,%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 0c             	mov    0xc(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 34 ff ff ff       	call   8004b4 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800586:	c7 05 38 51 83 00 00 	movl   $0x700,0x835138
  80058d:	07 00 00 

	return cnt;
  800590:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800593:	c9                   	leave  
  800594:	c3                   	ret    

00800595 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80059b:	e8 3d 27 00 00       	call   802cdd <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8005af:	50                   	push   %eax
  8005b0:	e8 ff fe ff ff       	call   8004b4 <vcprintf>
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005bb:	e8 37 27 00 00       	call   802cf7 <sys_unlock_cons>
	return cnt;
  8005c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c3:	c9                   	leave  
  8005c4:	c3                   	ret    

008005c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	53                   	push   %ebx
  8005c9:	83 ec 14             	sub    $0x14,%esp
  8005cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005db:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e3:	77 55                	ja     80063a <printnum+0x75>
  8005e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e8:	72 05                	jb     8005ef <printnum+0x2a>
  8005ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ed:	77 4b                	ja     80063a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ef:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	ff 75 f4             	pushl  -0xc(%ebp)
  800602:	ff 75 f0             	pushl  -0x10(%ebp)
  800605:	e8 ca 3a 00 00       	call   8040d4 <__udivdi3>
  80060a:	83 c4 10             	add    $0x10,%esp
  80060d:	83 ec 04             	sub    $0x4,%esp
  800610:	ff 75 20             	pushl  0x20(%ebp)
  800613:	53                   	push   %ebx
  800614:	ff 75 18             	pushl  0x18(%ebp)
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	ff 75 08             	pushl  0x8(%ebp)
  80061f:	e8 a1 ff ff ff       	call   8005c5 <printnum>
  800624:	83 c4 20             	add    $0x20,%esp
  800627:	eb 1a                	jmp    800643 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	ff 75 0c             	pushl  0xc(%ebp)
  80062f:	ff 75 20             	pushl  0x20(%ebp)
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	ff d0                	call   *%eax
  800637:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063a:	ff 4d 1c             	decl   0x1c(%ebp)
  80063d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800641:	7f e6                	jg     800629 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800643:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800646:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800651:	53                   	push   %ebx
  800652:	51                   	push   %ecx
  800653:	52                   	push   %edx
  800654:	50                   	push   %eax
  800655:	e8 8a 3b 00 00       	call   8041e4 <__umoddi3>
  80065a:	83 c4 10             	add    $0x10,%esp
  80065d:	05 f4 46 80 00       	add    $0x8046f4,%eax
  800662:	8a 00                	mov    (%eax),%al
  800664:	0f be c0             	movsbl %al,%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	ff d0                	call   *%eax
  800673:	83 c4 10             	add    $0x10,%esp
}
  800676:	90                   	nop
  800677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067a:	c9                   	leave  
  80067b:	c3                   	ret    

0080067c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800683:	7e 1c                	jle    8006a1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	8d 50 08             	lea    0x8(%eax),%edx
  80068d:	8b 45 08             	mov    0x8(%ebp),%eax
  800690:	89 10                	mov    %edx,(%eax)
  800692:	8b 45 08             	mov    0x8(%ebp),%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	83 e8 08             	sub    $0x8,%eax
  80069a:	8b 50 04             	mov    0x4(%eax),%edx
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	eb 40                	jmp    8006e1 <getuint+0x65>
	else if (lflag)
  8006a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a5:	74 1e                	je     8006c5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	8d 50 04             	lea    0x4(%eax),%edx
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	89 10                	mov    %edx,(%eax)
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	83 e8 04             	sub    $0x4,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c3:	eb 1c                	jmp    8006e1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	89 10                	mov    %edx,(%eax)
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	83 e8 04             	sub    $0x4,%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e1:	5d                   	pop    %ebp
  8006e2:	c3                   	ret    

008006e3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ea:	7e 1c                	jle    800708 <getint+0x25>
		return va_arg(*ap, long long);
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	8d 50 08             	lea    0x8(%eax),%edx
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	89 10                	mov    %edx,(%eax)
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	83 e8 08             	sub    $0x8,%eax
  800701:	8b 50 04             	mov    0x4(%eax),%edx
  800704:	8b 00                	mov    (%eax),%eax
  800706:	eb 38                	jmp    800740 <getint+0x5d>
	else if (lflag)
  800708:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070c:	74 1a                	je     800728 <getint+0x45>
		return va_arg(*ap, long);
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	8b 00                	mov    (%eax),%eax
  800713:	8d 50 04             	lea    0x4(%eax),%edx
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	89 10                	mov    %edx,(%eax)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	83 e8 04             	sub    $0x4,%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	99                   	cltd   
  800726:	eb 18                	jmp    800740 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
}
  800740:	5d                   	pop    %ebp
  800741:	c3                   	ret    

00800742 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	56                   	push   %esi
  800746:	53                   	push   %ebx
  800747:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074a:	eb 17                	jmp    800763 <vprintfmt+0x21>
			if (ch == '\0')
  80074c:	85 db                	test   %ebx,%ebx
  80074e:	0f 84 c1 03 00 00    	je     800b15 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	53                   	push   %ebx
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800763:	8b 45 10             	mov    0x10(%ebp),%eax
  800766:	8d 50 01             	lea    0x1(%eax),%edx
  800769:	89 55 10             	mov    %edx,0x10(%ebp)
  80076c:	8a 00                	mov    (%eax),%al
  80076e:	0f b6 d8             	movzbl %al,%ebx
  800771:	83 fb 25             	cmp    $0x25,%ebx
  800774:	75 d6                	jne    80074c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800776:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800781:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800788:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800796:	8b 45 10             	mov    0x10(%ebp),%eax
  800799:	8d 50 01             	lea    0x1(%eax),%edx
  80079c:	89 55 10             	mov    %edx,0x10(%ebp)
  80079f:	8a 00                	mov    (%eax),%al
  8007a1:	0f b6 d8             	movzbl %al,%ebx
  8007a4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a7:	83 f8 5b             	cmp    $0x5b,%eax
  8007aa:	0f 87 3d 03 00 00    	ja     800aed <vprintfmt+0x3ab>
  8007b0:	8b 04 85 18 47 80 00 	mov    0x804718(,%eax,4),%eax
  8007b7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bd:	eb d7                	jmp    800796 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c3:	eb d1                	jmp    800796 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cf:	89 d0                	mov    %edx,%eax
  8007d1:	c1 e0 02             	shl    $0x2,%eax
  8007d4:	01 d0                	add    %edx,%eax
  8007d6:	01 c0                	add    %eax,%eax
  8007d8:	01 d8                	add    %ebx,%eax
  8007da:	83 e8 30             	sub    $0x30,%eax
  8007dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e3:	8a 00                	mov    (%eax),%al
  8007e5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e8:	83 fb 2f             	cmp    $0x2f,%ebx
  8007eb:	7e 3e                	jle    80082b <vprintfmt+0xe9>
  8007ed:	83 fb 39             	cmp    $0x39,%ebx
  8007f0:	7f 39                	jg     80082b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f5:	eb d5                	jmp    8007cc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080b:	eb 1f                	jmp    80082c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800811:	79 83                	jns    800796 <vprintfmt+0x54>
				width = 0;
  800813:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081a:	e9 77 ff ff ff       	jmp    800796 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800826:	e9 6b ff ff ff       	jmp    800796 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800830:	0f 89 60 ff ff ff    	jns    800796 <vprintfmt+0x54>
				width = precision, precision = -1;
  800836:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800843:	e9 4e ff ff ff       	jmp    800796 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800848:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084b:	e9 46 ff ff ff       	jmp    800796 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	83 c0 04             	add    $0x4,%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 e8 04             	sub    $0x4,%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	50                   	push   %eax
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	ff d0                	call   *%eax
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 9b 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800886:	85 db                	test   %ebx,%ebx
  800888:	79 02                	jns    80088c <vprintfmt+0x14a>
				err = -err;
  80088a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088c:	83 fb 64             	cmp    $0x64,%ebx
  80088f:	7f 0b                	jg     80089c <vprintfmt+0x15a>
  800891:	8b 34 9d 60 45 80 00 	mov    0x804560(,%ebx,4),%esi
  800898:	85 f6                	test   %esi,%esi
  80089a:	75 19                	jne    8008b5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089c:	53                   	push   %ebx
  80089d:	68 05 47 80 00       	push   $0x804705
  8008a2:	ff 75 0c             	pushl  0xc(%ebp)
  8008a5:	ff 75 08             	pushl  0x8(%ebp)
  8008a8:	e8 70 02 00 00       	call   800b1d <printfmt>
  8008ad:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b0:	e9 5b 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b5:	56                   	push   %esi
  8008b6:	68 0e 47 80 00       	push   $0x80470e
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	ff 75 08             	pushl  0x8(%ebp)
  8008c1:	e8 57 02 00 00       	call   800b1d <printfmt>
  8008c6:	83 c4 10             	add    $0x10,%esp
			break;
  8008c9:	e9 42 02 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	83 c0 04             	add    $0x4,%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 e8 04             	sub    $0x4,%eax
  8008dd:	8b 30                	mov    (%eax),%esi
  8008df:	85 f6                	test   %esi,%esi
  8008e1:	75 05                	jne    8008e8 <vprintfmt+0x1a6>
				p = "(null)";
  8008e3:	be 11 47 80 00       	mov    $0x804711,%esi
			if (width > 0 && padc != '-')
  8008e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ec:	7e 6d                	jle    80095b <vprintfmt+0x219>
  8008ee:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f2:	74 67                	je     80095b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	50                   	push   %eax
  8008fb:	56                   	push   %esi
  8008fc:	e8 1e 03 00 00       	call   800c1f <strnlen>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800907:	eb 16                	jmp    80091f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800909:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 0c             	pushl  0xc(%ebp)
  800913:	50                   	push   %eax
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	ff d0                	call   *%eax
  800919:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091c:	ff 4d e4             	decl   -0x1c(%ebp)
  80091f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800923:	7f e4                	jg     800909 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800925:	eb 34                	jmp    80095b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800927:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092b:	74 1c                	je     800949 <vprintfmt+0x207>
  80092d:	83 fb 1f             	cmp    $0x1f,%ebx
  800930:	7e 05                	jle    800937 <vprintfmt+0x1f5>
  800932:	83 fb 7e             	cmp    $0x7e,%ebx
  800935:	7e 12                	jle    800949 <vprintfmt+0x207>
					putch('?', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 3f                	push   $0x3f
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
  800947:	eb 0f                	jmp    800958 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800949:	83 ec 08             	sub    $0x8,%esp
  80094c:	ff 75 0c             	pushl  0xc(%ebp)
  80094f:	53                   	push   %ebx
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	89 f0                	mov    %esi,%eax
  80095d:	8d 70 01             	lea    0x1(%eax),%esi
  800960:	8a 00                	mov    (%eax),%al
  800962:	0f be d8             	movsbl %al,%ebx
  800965:	85 db                	test   %ebx,%ebx
  800967:	74 24                	je     80098d <vprintfmt+0x24b>
  800969:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096d:	78 b8                	js     800927 <vprintfmt+0x1e5>
  80096f:	ff 4d e0             	decl   -0x20(%ebp)
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	79 af                	jns    800927 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800978:	eb 13                	jmp    80098d <vprintfmt+0x24b>
				putch(' ', putdat);
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	6a 20                	push   $0x20
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	ff d0                	call   *%eax
  800987:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098a:	ff 4d e4             	decl   -0x1c(%ebp)
  80098d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800991:	7f e7                	jg     80097a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800993:	e9 78 01 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 e8             	pushl  -0x18(%ebp)
  80099e:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a1:	50                   	push   %eax
  8009a2:	e8 3c fd ff ff       	call   8006e3 <getint>
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b6:	85 d2                	test   %edx,%edx
  8009b8:	79 23                	jns    8009dd <vprintfmt+0x29b>
				putch('-', putdat);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	6a 2d                	push   $0x2d
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	f7 d8                	neg    %eax
  8009d2:	83 d2 00             	adc    $0x0,%edx
  8009d5:	f7 da                	neg    %edx
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	e8 84 fc ff ff       	call   80067c <getuint>
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a01:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a08:	e9 98 00 00 00       	jmp    800aa5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 58                	push   $0x58
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 58                	push   $0x58
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	6a 58                	push   $0x58
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
			break;
  800a3d:	e9 ce 00 00 00       	jmp    800b10 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 30                	push   $0x30
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 78                	push   $0x78
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a62:	8b 45 14             	mov    0x14(%ebp),%eax
  800a65:	83 c0 04             	add    $0x4,%eax
  800a68:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 e8 04             	sub    $0x4,%eax
  800a71:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a84:	eb 1f                	jmp    800aa5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8f:	50                   	push   %eax
  800a90:	e8 e7 fb ff ff       	call   80067c <getuint>
  800a95:	83 c4 10             	add    $0x10,%esp
  800a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	52                   	push   %edx
  800ab0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab3:	50                   	push   %eax
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	ff 75 08             	pushl  0x8(%ebp)
  800ac0:	e8 00 fb ff ff       	call   8005c5 <printnum>
  800ac5:	83 c4 20             	add    $0x20,%esp
			break;
  800ac8:	eb 46                	jmp    800b10 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	53                   	push   %ebx
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
			break;
  800ad9:	eb 35                	jmp    800b10 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800adb:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800ae2:	eb 2c                	jmp    800b10 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ae4:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800aeb:	eb 23                	jmp    800b10 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aed:	83 ec 08             	sub    $0x8,%esp
  800af0:	ff 75 0c             	pushl  0xc(%ebp)
  800af3:	6a 25                	push   $0x25
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	ff d0                	call   *%eax
  800afa:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afd:	ff 4d 10             	decl   0x10(%ebp)
  800b00:	eb 03                	jmp    800b05 <vprintfmt+0x3c3>
  800b02:	ff 4d 10             	decl   0x10(%ebp)
  800b05:	8b 45 10             	mov    0x10(%ebp),%eax
  800b08:	48                   	dec    %eax
  800b09:	8a 00                	mov    (%eax),%al
  800b0b:	3c 25                	cmp    $0x25,%al
  800b0d:	75 f3                	jne    800b02 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b0f:	90                   	nop
		}
	}
  800b10:	e9 35 fc ff ff       	jmp    80074a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b15:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b19:	5b                   	pop    %ebx
  800b1a:	5e                   	pop    %esi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    

00800b1d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b23:	8d 45 10             	lea    0x10(%ebp),%eax
  800b26:	83 c0 04             	add    $0x4,%eax
  800b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b32:	50                   	push   %eax
  800b33:	ff 75 0c             	pushl  0xc(%ebp)
  800b36:	ff 75 08             	pushl  0x8(%ebp)
  800b39:	e8 04 fc ff ff       	call   800742 <vprintfmt>
  800b3e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b41:	90                   	nop
  800b42:	c9                   	leave  
  800b43:	c3                   	ret    

00800b44 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 08             	mov    0x8(%eax),%eax
  800b4d:	8d 50 01             	lea    0x1(%eax),%edx
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	8b 10                	mov    (%eax),%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8b 40 04             	mov    0x4(%eax),%eax
  800b61:	39 c2                	cmp    %eax,%edx
  800b63:	73 12                	jae    800b77 <sprintputch+0x33>
		*b->buf++ = ch;
  800b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b68:	8b 00                	mov    (%eax),%eax
  800b6a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b70:	89 0a                	mov    %ecx,(%edx)
  800b72:	8b 55 08             	mov    0x8(%ebp),%edx
  800b75:	88 10                	mov    %dl,(%eax)
}
  800b77:	90                   	nop
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	01 d0                	add    %edx,%eax
  800b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9f:	74 06                	je     800ba7 <vsnprintf+0x2d>
  800ba1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba5:	7f 07                	jg     800bae <vsnprintf+0x34>
		return -E_INVAL;
  800ba7:	b8 03 00 00 00       	mov    $0x3,%eax
  800bac:	eb 20                	jmp    800bce <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bae:	ff 75 14             	pushl  0x14(%ebp)
  800bb1:	ff 75 10             	pushl  0x10(%ebp)
  800bb4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb7:	50                   	push   %eax
  800bb8:	68 44 0b 80 00       	push   $0x800b44
  800bbd:	e8 80 fb ff ff       	call   800742 <vprintfmt>
  800bc2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd9:	83 c0 04             	add    $0x4,%eax
  800bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	ff 75 f4             	pushl  -0xc(%ebp)
  800be5:	50                   	push   %eax
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	ff 75 08             	pushl  0x8(%ebp)
  800bec:	e8 89 ff ff ff       	call   800b7a <vsnprintf>
  800bf1:	83 c4 10             	add    $0x10,%esp
  800bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c09:	eb 06                	jmp    800c11 <strlen+0x15>
		n++;
  800c0b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0e:	ff 45 08             	incl   0x8(%ebp)
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8a 00                	mov    (%eax),%al
  800c16:	84 c0                	test   %al,%al
  800c18:	75 f1                	jne    800c0b <strlen+0xf>
		n++;
	return n;
  800c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 09                	jmp    800c37 <strnlen+0x18>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	ff 4d 0c             	decl   0xc(%ebp)
  800c37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3b:	74 09                	je     800c46 <strnlen+0x27>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 00                	mov    (%eax),%al
  800c42:	84 c0                	test   %al,%al
  800c44:	75 e8                	jne    800c2e <strnlen+0xf>
		n++;
	return n;
  800c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c57:	90                   	nop
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6a:	8a 12                	mov    (%edx),%dl
  800c6c:	88 10                	mov    %dl,(%eax)
  800c6e:	8a 00                	mov    (%eax),%al
  800c70:	84 c0                	test   %al,%al
  800c72:	75 e4                	jne    800c58 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 1f                	jmp    800cad <strncpy+0x34>
		*dst++ = *src;
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8d 50 01             	lea    0x1(%eax),%edx
  800c94:	89 55 08             	mov    %edx,0x8(%ebp)
  800c97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9a:	8a 12                	mov    (%edx),%dl
  800c9c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	74 03                	je     800caa <strncpy+0x31>
			src++;
  800ca7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800caa:	ff 45 fc             	incl   -0x4(%ebp)
  800cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb3:	72 d9                	jb     800c8e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cca:	74 30                	je     800cfc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ccc:	eb 16                	jmp    800ce4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8d 50 01             	lea    0x1(%eax),%edx
  800cd4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cdd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce0:	8a 12                	mov    (%edx),%dl
  800ce2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce4:	ff 4d 10             	decl   0x10(%ebp)
  800ce7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ceb:	74 09                	je     800cf6 <strlcpy+0x3c>
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	84 c0                	test   %al,%al
  800cf4:	75 d8                	jne    800cce <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d02:	29 c2                	sub    %eax,%edx
  800d04:	89 d0                	mov    %edx,%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d0b:	eb 06                	jmp    800d13 <strcmp+0xb>
		p++, q++;
  800d0d:	ff 45 08             	incl   0x8(%ebp)
  800d10:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	74 0e                	je     800d2a <strcmp+0x22>
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8a 10                	mov    (%eax),%dl
  800d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	38 c2                	cmp    %al,%dl
  800d28:	74 e3                	je     800d0d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	0f b6 d0             	movzbl %al,%edx
  800d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 c0             	movzbl %al,%eax
  800d3a:	29 c2                	sub    %eax,%edx
  800d3c:	89 d0                	mov    %edx,%eax
}
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d43:	eb 09                	jmp    800d4e <strncmp+0xe>
		n--, p++, q++;
  800d45:	ff 4d 10             	decl   0x10(%ebp)
  800d48:	ff 45 08             	incl   0x8(%ebp)
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d52:	74 17                	je     800d6b <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	84 c0                	test   %al,%al
  800d5b:	74 0e                	je     800d6b <strncmp+0x2b>
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 10                	mov    (%eax),%dl
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	38 c2                	cmp    %al,%dl
  800d69:	74 da                	je     800d45 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6f:	75 07                	jne    800d78 <strncmp+0x38>
		return 0;
  800d71:	b8 00 00 00 00       	mov    $0x0,%eax
  800d76:	eb 14                	jmp    800d8c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f b6 d0             	movzbl %al,%edx
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 c0             	movzbl %al,%eax
  800d88:	29 c2                	sub    %eax,%edx
  800d8a:	89 d0                	mov    %edx,%eax
}
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    

00800d8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	83 ec 04             	sub    $0x4,%esp
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9a:	eb 12                	jmp    800dae <strchr+0x20>
		if (*s == c)
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8a 00                	mov    (%eax),%al
  800da1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da4:	75 05                	jne    800dab <strchr+0x1d>
			return (char *) s;
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	eb 11                	jmp    800dbc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dab:	ff 45 08             	incl   0x8(%ebp)
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	84 c0                	test   %al,%al
  800db5:	75 e5                	jne    800d9c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbc:	c9                   	leave  
  800dbd:	c3                   	ret    

00800dbe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	83 ec 04             	sub    $0x4,%esp
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dca:	eb 0d                	jmp    800dd9 <strfind+0x1b>
		if (*s == c)
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd4:	74 0e                	je     800de4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dd6:	ff 45 08             	incl   0x8(%ebp)
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	84 c0                	test   %al,%al
  800de0:	75 ea                	jne    800dcc <strfind+0xe>
  800de2:	eb 01                	jmp    800de5 <strfind+0x27>
		if (*s == c)
			break;
  800de4:	90                   	nop
	return (char *) s;
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800df6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dfa:	76 63                	jbe    800e5f <memset+0x75>
		uint64 data_block = c;
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	99                   	cltd   
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e03:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e10:	c1 e0 08             	shl    $0x8,%eax
  800e13:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e16:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e23:	c1 e0 10             	shl    $0x10,%eax
  800e26:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e29:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e32:	89 c2                	mov    %eax,%edx
  800e34:	b8 00 00 00 00       	mov    $0x0,%eax
  800e39:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e3c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e3f:	eb 18                	jmp    800e59 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e41:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e44:	8d 41 08             	lea    0x8(%ecx),%eax
  800e47:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e50:	89 01                	mov    %eax,(%ecx)
  800e52:	89 51 04             	mov    %edx,0x4(%ecx)
  800e55:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e59:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e5d:	77 e2                	ja     800e41 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e63:	74 23                	je     800e88 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e6b:	eb 0e                	jmp    800e7b <memset+0x91>
			*p8++ = (uint8)c;
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e81:	89 55 10             	mov    %edx,0x10(%ebp)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	75 e5                	jne    800e6d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e9f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea3:	76 24                	jbe    800ec9 <memcpy+0x3c>
		while(n >= 8){
  800ea5:	eb 1c                	jmp    800ec3 <memcpy+0x36>
			*d64 = *s64;
  800ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eaa:	8b 50 04             	mov    0x4(%eax),%edx
  800ead:	8b 00                	mov    (%eax),%eax
  800eaf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eb2:	89 01                	mov    %eax,(%ecx)
  800eb4:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800eb7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ebb:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ebf:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ec3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec7:	77 de                	ja     800ea7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ec9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecd:	74 31                	je     800f00 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ed5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800edb:	eb 16                	jmp    800ef3 <memcpy+0x66>
			*d8++ = *s8++;
  800edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee0:	8d 50 01             	lea    0x1(%eax),%edx
  800ee3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ee6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eec:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800eef:	8a 12                	mov    (%edx),%dl
  800ef1:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ef3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef9:	89 55 10             	mov    %edx,0x10(%ebp)
  800efc:	85 c0                	test   %eax,%eax
  800efe:	75 dd                	jne    800edd <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f03:	c9                   	leave  
  800f04:	c3                   	ret    

00800f05 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1d:	73 50                	jae    800f6f <memmove+0x6a>
  800f1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	01 d0                	add    %edx,%eax
  800f27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f2a:	76 43                	jbe    800f6f <memmove+0x6a>
		s += n;
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f32:	8b 45 10             	mov    0x10(%ebp),%eax
  800f35:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f38:	eb 10                	jmp    800f4a <memmove+0x45>
			*--d = *--s;
  800f3a:	ff 4d f8             	decl   -0x8(%ebp)
  800f3d:	ff 4d fc             	decl   -0x4(%ebp)
  800f40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f43:	8a 10                	mov    (%eax),%dl
  800f45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f48:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f50:	89 55 10             	mov    %edx,0x10(%ebp)
  800f53:	85 c0                	test   %eax,%eax
  800f55:	75 e3                	jne    800f3a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f57:	eb 23                	jmp    800f7c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	8d 50 01             	lea    0x1(%eax),%edx
  800f5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f68:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6b:	8a 12                	mov    (%edx),%dl
  800f6d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f75:	89 55 10             	mov    %edx,0x10(%ebp)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	75 dd                	jne    800f59 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f90:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f93:	eb 2a                	jmp    800fbf <memcmp+0x3e>
		if (*s1 != *s2)
  800f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f98:	8a 10                	mov    (%eax),%dl
  800f9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	38 c2                	cmp    %al,%dl
  800fa1:	74 16                	je     800fb9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f b6 d0             	movzbl %al,%edx
  800fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f b6 c0             	movzbl %al,%eax
  800fb3:	29 c2                	sub    %eax,%edx
  800fb5:	89 d0                	mov    %edx,%eax
  800fb7:	eb 18                	jmp    800fd1 <memcmp+0x50>
		s1++, s2++;
  800fb9:	ff 45 fc             	incl   -0x4(%ebp)
  800fbc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	75 c9                	jne    800f95 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdf:	01 d0                	add    %edx,%eax
  800fe1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fe4:	eb 15                	jmp    800ffb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	0f b6 d0             	movzbl %al,%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	0f b6 c0             	movzbl %al,%eax
  800ff4:	39 c2                	cmp    %eax,%edx
  800ff6:	74 0d                	je     801005 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff8:	ff 45 08             	incl   0x8(%ebp)
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801001:	72 e3                	jb     800fe6 <memfind+0x13>
  801003:	eb 01                	jmp    801006 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801005:	90                   	nop
	return (void *) s;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801011:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801018:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101f:	eb 03                	jmp    801024 <strtol+0x19>
		s++;
  801021:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	3c 20                	cmp    $0x20,%al
  80102b:	74 f4                	je     801021 <strtol+0x16>
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 09                	cmp    $0x9,%al
  801034:	74 eb                	je     801021 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 2b                	cmp    $0x2b,%al
  80103d:	75 05                	jne    801044 <strtol+0x39>
		s++;
  80103f:	ff 45 08             	incl   0x8(%ebp)
  801042:	eb 13                	jmp    801057 <strtol+0x4c>
	else if (*s == '-')
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	3c 2d                	cmp    $0x2d,%al
  80104b:	75 0a                	jne    801057 <strtol+0x4c>
		s++, neg = 1;
  80104d:	ff 45 08             	incl   0x8(%ebp)
  801050:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801057:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105b:	74 06                	je     801063 <strtol+0x58>
  80105d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801061:	75 20                	jne    801083 <strtol+0x78>
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 30                	cmp    $0x30,%al
  80106a:	75 17                	jne    801083 <strtol+0x78>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	40                   	inc    %eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 78                	cmp    $0x78,%al
  801074:	75 0d                	jne    801083 <strtol+0x78>
		s += 2, base = 16;
  801076:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80107a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801081:	eb 28                	jmp    8010ab <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801083:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801087:	75 15                	jne    80109e <strtol+0x93>
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	3c 30                	cmp    $0x30,%al
  801090:	75 0c                	jne    80109e <strtol+0x93>
		s++, base = 8;
  801092:	ff 45 08             	incl   0x8(%ebp)
  801095:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80109c:	eb 0d                	jmp    8010ab <strtol+0xa0>
	else if (base == 0)
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 07                	jne    8010ab <strtol+0xa0>
		base = 10;
  8010a4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 2f                	cmp    $0x2f,%al
  8010b2:	7e 19                	jle    8010cd <strtol+0xc2>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 39                	cmp    $0x39,%al
  8010bb:	7f 10                	jg     8010cd <strtol+0xc2>
			dig = *s - '0';
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	0f be c0             	movsbl %al,%eax
  8010c5:	83 e8 30             	sub    $0x30,%eax
  8010c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010cb:	eb 42                	jmp    80110f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	3c 60                	cmp    $0x60,%al
  8010d4:	7e 19                	jle    8010ef <strtol+0xe4>
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 7a                	cmp    $0x7a,%al
  8010dd:	7f 10                	jg     8010ef <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	0f be c0             	movsbl %al,%eax
  8010e7:	83 e8 57             	sub    $0x57,%eax
  8010ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ed:	eb 20                	jmp    80110f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 40                	cmp    $0x40,%al
  8010f6:	7e 39                	jle    801131 <strtol+0x126>
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 5a                	cmp    $0x5a,%al
  8010ff:	7f 30                	jg     801131 <strtol+0x126>
			dig = *s - 'A' + 10;
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	0f be c0             	movsbl %al,%eax
  801109:	83 e8 37             	sub    $0x37,%eax
  80110c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80110f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801112:	3b 45 10             	cmp    0x10(%ebp),%eax
  801115:	7d 19                	jge    801130 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801117:	ff 45 08             	incl   0x8(%ebp)
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801121:	89 c2                	mov    %eax,%edx
  801123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801126:	01 d0                	add    %edx,%eax
  801128:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80112b:	e9 7b ff ff ff       	jmp    8010ab <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801130:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801131:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801135:	74 08                	je     80113f <strtol+0x134>
		*endptr = (char *) s;
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80113f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801143:	74 07                	je     80114c <strtol+0x141>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	f7 d8                	neg    %eax
  80114a:	eb 03                	jmp    80114f <strtol+0x144>
  80114c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <ltostr>:

void
ltostr(long value, char *str)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	79 13                	jns    80117e <ltostr+0x2d>
	{
		neg = 1;
  80116b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801178:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80117b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801186:	99                   	cltd   
  801187:	f7 f9                	idiv   %ecx
  801189:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801195:	89 c2                	mov    %eax,%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80119f:	83 c2 30             	add    $0x30,%edx
  8011a2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ac:	f7 e9                	imul   %ecx
  8011ae:	c1 fa 02             	sar    $0x2,%edx
  8011b1:	89 c8                	mov    %ecx,%eax
  8011b3:	c1 f8 1f             	sar    $0x1f,%eax
  8011b6:	29 c2                	sub    %eax,%edx
  8011b8:	89 d0                	mov    %edx,%eax
  8011ba:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c1:	75 bb                	jne    80117e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	48                   	dec    %eax
  8011ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d5:	74 3d                	je     801214 <ltostr+0xc3>
		start = 1 ;
  8011d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011de:	eb 34                	jmp    801214 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 d0                	add    %edx,%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	01 c2                	add    %eax,%edx
  8011f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fb:	01 c8                	add    %ecx,%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801201:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8a 45 eb             	mov    -0x15(%ebp),%al
  80120c:	88 02                	mov    %al,(%edx)
		start++ ;
  80120e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801211:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801217:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80121a:	7c c4                	jl     8011e0 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80121c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80121f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801222:	01 d0                	add    %edx,%eax
  801224:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801227:	90                   	nop
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 c4 f9 ff ff       	call   800bfc <strlen>
  801238:	83 c4 04             	add    $0x4,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80123e:	ff 75 0c             	pushl  0xc(%ebp)
  801241:	e8 b6 f9 ff ff       	call   800bfc <strlen>
  801246:	83 c4 04             	add    $0x4,%esp
  801249:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80124c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801253:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80125a:	eb 17                	jmp    801273 <strcconcat+0x49>
		final[s] = str1[s] ;
  80125c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	01 c2                	add    %eax,%edx
  801264:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	01 c8                	add    %ecx,%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801270:	ff 45 fc             	incl   -0x4(%ebp)
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801276:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801279:	7c e1                	jl     80125c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80127b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801289:	eb 1f                	jmp    8012aa <strcconcat+0x80>
		final[s++] = str2[i] ;
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	8d 50 01             	lea    0x1(%eax),%edx
  801291:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801294:	89 c2                	mov    %eax,%edx
  801296:	8b 45 10             	mov    0x10(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012a7:	ff 45 f8             	incl   -0x8(%ebp)
  8012aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b0:	7c d9                	jl     80128b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b8:	01 d0                	add    %edx,%eax
  8012ba:	c6 00 00             	movb   $0x0,(%eax)
}
  8012bd:	90                   	nop
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cf:	8b 00                	mov    (%eax),%eax
  8012d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 d0                	add    %edx,%eax
  8012dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012e3:	eb 0c                	jmp    8012f1 <strsplit+0x31>
			*string++ = 0;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8d 50 01             	lea    0x1(%eax),%edx
  8012eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ee:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 18                	je     801312 <strsplit+0x52>
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8a 00                	mov    (%eax),%al
  8012ff:	0f be c0             	movsbl %al,%eax
  801302:	50                   	push   %eax
  801303:	ff 75 0c             	pushl  0xc(%ebp)
  801306:	e8 83 fa ff ff       	call   800d8e <strchr>
  80130b:	83 c4 08             	add    $0x8,%esp
  80130e:	85 c0                	test   %eax,%eax
  801310:	75 d3                	jne    8012e5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	84 c0                	test   %al,%al
  801319:	74 5a                	je     801375 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80131b:	8b 45 14             	mov    0x14(%ebp),%eax
  80131e:	8b 00                	mov    (%eax),%eax
  801320:	83 f8 0f             	cmp    $0xf,%eax
  801323:	75 07                	jne    80132c <strsplit+0x6c>
		{
			return 0;
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	eb 66                	jmp    801392 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80132c:	8b 45 14             	mov    0x14(%ebp),%eax
  80132f:	8b 00                	mov    (%eax),%eax
  801331:	8d 48 01             	lea    0x1(%eax),%ecx
  801334:	8b 55 14             	mov    0x14(%ebp),%edx
  801337:	89 0a                	mov    %ecx,(%edx)
  801339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	01 c2                	add    %eax,%edx
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134a:	eb 03                	jmp    80134f <strsplit+0x8f>
			string++;
  80134c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	8a 00                	mov    (%eax),%al
  801354:	84 c0                	test   %al,%al
  801356:	74 8b                	je     8012e3 <strsplit+0x23>
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	8a 00                	mov    (%eax),%al
  80135d:	0f be c0             	movsbl %al,%eax
  801360:	50                   	push   %eax
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	e8 25 fa ff ff       	call   800d8e <strchr>
  801369:	83 c4 08             	add    $0x8,%esp
  80136c:	85 c0                	test   %eax,%eax
  80136e:	74 dc                	je     80134c <strsplit+0x8c>
			string++;
	}
  801370:	e9 6e ff ff ff       	jmp    8012e3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801375:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801376:	8b 45 14             	mov    0x14(%ebp),%eax
  801379:	8b 00                	mov    (%eax),%eax
  80137b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80138d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a7:	eb 4a                	jmp    8013f3 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	01 c2                	add    %eax,%edx
  8013b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	01 c8                	add    %ecx,%eax
  8013b9:	8a 00                	mov    (%eax),%al
  8013bb:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	3c 40                	cmp    $0x40,%al
  8013c9:	7e 25                	jle    8013f0 <str2lower+0x5c>
  8013cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	3c 5a                	cmp    $0x5a,%al
  8013d7:	7f 17                	jg     8013f0 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	01 d0                	add    %edx,%eax
  8013e1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e7:	01 ca                	add    %ecx,%edx
  8013e9:	8a 12                	mov    (%edx),%dl
  8013eb:	83 c2 20             	add    $0x20,%edx
  8013ee:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	e8 01 f8 ff ff       	call   800bfc <strlen>
  8013fb:	83 c4 04             	add    $0x4,%esp
  8013fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801401:	7f a6                	jg     8013a9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801403:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80140e:	a1 08 50 80 00       	mov    0x805008,%eax
  801413:	85 c0                	test   %eax,%eax
  801415:	74 42                	je     801459 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801417:	83 ec 08             	sub    $0x8,%esp
  80141a:	68 00 00 00 82       	push   $0x82000000
  80141f:	68 00 00 00 80       	push   $0x80000000
  801424:	e8 b0 1e 00 00       	call   8032d9 <initialize_dynamic_allocator>
  801429:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80142c:	e8 96 1c 00 00       	call   8030c7 <sys_get_uheap_strategy>
  801431:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801436:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80143b:	05 00 10 00 00       	add    $0x1000,%eax
  801440:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801445:	a1 30 51 83 00       	mov    0x835130,%eax
  80144a:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  80144f:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801456:	00 00 00 
	}
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801470:	83 ec 08             	sub    $0x8,%esp
  801473:	68 06 04 00 00       	push   $0x406
  801478:	50                   	push   %eax
  801479:	e8 93 18 00 00       	call   802d11 <__sys_allocate_page>
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801484:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801488:	79 14                	jns    80149e <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	68 88 48 80 00       	push   $0x804888
  801492:	6a 1f                	push   $0x1f
  801494:	68 c4 48 80 00       	push   $0x8048c4
  801499:	e8 48 2a 00 00       	call   803ee6 <_panic>
	return 0;
  80149e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b9:	83 ec 0c             	sub    $0xc,%esp
  8014bc:	50                   	push   %eax
  8014bd:	e8 96 18 00 00       	call   802d58 <__sys_unmap_frame>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8014c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014cc:	79 14                	jns    8014e2 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	68 d0 48 80 00       	push   $0x8048d0
  8014d6:	6a 2a                	push   $0x2a
  8014d8:	68 c4 48 80 00       	push   $0x8048c4
  8014dd:	e8 04 2a 00 00       	call   803ee6 <_panic>
}
  8014e2:	90                   	nop
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8014eb:	e8 18 ff ff ff       	call   801408 <uheap_init>
	if (size == 0) return NULL ;
  8014f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f4:	75 0a                	jne    801500 <malloc+0x1b>
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	e9 43 03 00 00       	jmp    801843 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801500:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801507:	77 13                	ja     80151c <malloc+0x37>
    {
        return alloc_block(size);
  801509:	83 ec 0c             	sub    $0xc,%esp
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	e8 78 20 00 00       	call   80358c <alloc_block>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	e9 27 03 00 00       	jmp    801843 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80151c:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801523:	8b 55 08             	mov    0x8(%ebp),%edx
  801526:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801529:	01 d0                	add    %edx,%eax
  80152b:	48                   	dec    %eax
  80152c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80152f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801532:	ba 00 00 00 00       	mov    $0x0,%edx
  801537:	f7 75 dc             	divl   -0x24(%ebp)
  80153a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80153d:	29 d0                	sub    %edx,%eax
  80153f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801542:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801547:	85 c0                	test   %eax,%eax
  801549:	75 0a                	jne    801555 <malloc+0x70>
    {
        uhp_inited = 1;
  80154b:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  801552:	00 00 00 
    }

    int exactIdx = -1;
  801555:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80155c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801563:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80156a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801571:	e9 85 00 00 00       	jmp    8015fb <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801576:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801579:	89 d0                	mov    %edx,%eax
  80157b:	01 c0                	add    %eax,%eax
  80157d:	01 d0                	add    %edx,%eax
  80157f:	c1 e0 02             	shl    $0x2,%eax
  801582:	05 48 10 81 00       	add    $0x811048,%eax
  801587:	8a 00                	mov    (%eax),%al
  801589:	84 c0                	test   %al,%al
  80158b:	74 20                	je     8015ad <malloc+0xc8>
  80158d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801590:	89 d0                	mov    %edx,%eax
  801592:	01 c0                	add    %eax,%eax
  801594:	01 d0                	add    %edx,%eax
  801596:	c1 e0 02             	shl    $0x2,%eax
  801599:	05 44 10 81 00       	add    $0x811044,%eax
  80159e:	8b 00                	mov    (%eax),%eax
  8015a0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8015a3:	75 08                	jne    8015ad <malloc+0xc8>
        {
            exactIdx = i;
  8015a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8015ab:	eb 5b                	jmp    801608 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8015ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015b0:	89 d0                	mov    %edx,%eax
  8015b2:	01 c0                	add    %eax,%eax
  8015b4:	01 d0                	add    %edx,%eax
  8015b6:	c1 e0 02             	shl    $0x2,%eax
  8015b9:	05 48 10 81 00       	add    $0x811048,%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	84 c0                	test   %al,%al
  8015c2:	74 34                	je     8015f8 <malloc+0x113>
  8015c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015c7:	89 d0                	mov    %edx,%eax
  8015c9:	01 c0                	add    %eax,%eax
  8015cb:	01 d0                	add    %edx,%eax
  8015cd:	c1 e0 02             	shl    $0x2,%eax
  8015d0:	05 44 10 81 00       	add    $0x811044,%eax
  8015d5:	8b 00                	mov    (%eax),%eax
  8015d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8015da:	76 1c                	jbe    8015f8 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8015dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015df:	89 d0                	mov    %edx,%eax
  8015e1:	01 c0                	add    %eax,%eax
  8015e3:	01 d0                	add    %edx,%eax
  8015e5:	c1 e0 02             	shl    $0x2,%eax
  8015e8:	05 44 10 81 00       	add    $0x811044,%eax
  8015ed:	8b 00                	mov    (%eax),%eax
  8015ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8015f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8015f8:	ff 45 e8             	incl   -0x18(%ebp)
  8015fb:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801602:	0f 8e 6e ff ff ff    	jle    801576 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801608:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80160f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801613:	74 7d                	je     801692 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801615:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80161c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161f:	89 d0                	mov    %edx,%eax
  801621:	01 c0                	add    %eax,%eax
  801623:	01 d0                	add    %edx,%eax
  801625:	c1 e0 02             	shl    $0x2,%eax
  801628:	05 40 10 81 00       	add    $0x811040,%eax
  80162d:	8b 10                	mov    (%eax),%edx
  80162f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801632:	01 d0                	add    %edx,%eax
  801634:	48                   	dec    %eax
  801635:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801638:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80163b:	ba 00 00 00 00       	mov    $0x0,%edx
  801640:	f7 75 bc             	divl   -0x44(%ebp)
  801643:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801646:	29 d0                	sub    %edx,%eax
  801648:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80164b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164e:	89 d0                	mov    %edx,%eax
  801650:	01 c0                	add    %eax,%eax
  801652:	01 d0                	add    %edx,%eax
  801654:	c1 e0 02             	shl    $0x2,%eax
  801657:	05 48 10 81 00       	add    $0x811048,%eax
  80165c:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80165f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801662:	89 d0                	mov    %edx,%eax
  801664:	01 c0                	add    %eax,%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	c1 e0 02             	shl    $0x2,%eax
  80166b:	05 44 10 81 00       	add    $0x811044,%eax
  801670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801676:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801679:	89 d0                	mov    %edx,%eax
  80167b:	01 c0                	add    %eax,%eax
  80167d:	01 d0                	add    %edx,%eax
  80167f:	c1 e0 02             	shl    $0x2,%eax
  801682:	05 40 10 81 00       	add    $0x811040,%eax
  801687:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80168d:	e9 2d 01 00 00       	jmp    8017bf <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801692:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801696:	0f 84 ce 00 00 00    	je     80176a <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80169c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8016a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016a6:	89 d0                	mov    %edx,%eax
  8016a8:	01 c0                	add    %eax,%eax
  8016aa:	01 d0                	add    %edx,%eax
  8016ac:	c1 e0 02             	shl    $0x2,%eax
  8016af:	05 40 10 81 00       	add    $0x811040,%eax
  8016b4:	8b 10                	mov    (%eax),%edx
  8016b6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016b9:	01 d0                	add    %edx,%eax
  8016bb:	48                   	dec    %eax
  8016bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8016bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8016c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c7:	f7 75 c4             	divl   -0x3c(%ebp)
  8016ca:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8016cd:	29 d0                	sub    %edx,%eax
  8016cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8016d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d5:	89 d0                	mov    %edx,%eax
  8016d7:	01 c0                	add    %eax,%eax
  8016d9:	01 d0                	add    %edx,%eax
  8016db:	c1 e0 02             	shl    $0x2,%eax
  8016de:	05 44 10 81 00       	add    $0x811044,%eax
  8016e3:	8b 00                	mov    (%eax),%eax
  8016e5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8016e8:	75 47                	jne    801731 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  8016ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ed:	89 d0                	mov    %edx,%eax
  8016ef:	01 c0                	add    %eax,%eax
  8016f1:	01 d0                	add    %edx,%eax
  8016f3:	c1 e0 02             	shl    $0x2,%eax
  8016f6:	05 48 10 81 00       	add    $0x811048,%eax
  8016fb:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8016fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801701:	89 d0                	mov    %edx,%eax
  801703:	01 c0                	add    %eax,%eax
  801705:	01 d0                	add    %edx,%eax
  801707:	c1 e0 02             	shl    $0x2,%eax
  80170a:	05 44 10 81 00       	add    $0x811044,%eax
  80170f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801715:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801718:	89 d0                	mov    %edx,%eax
  80171a:	01 c0                	add    %eax,%eax
  80171c:	01 d0                	add    %edx,%eax
  80171e:	c1 e0 02             	shl    $0x2,%eax
  801721:	05 40 10 81 00       	add    $0x811040,%eax
  801726:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80172c:	e9 8e 00 00 00       	jmp    8017bf <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801731:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801734:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801737:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80173a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80173d:	89 d0                	mov    %edx,%eax
  80173f:	01 c0                	add    %eax,%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	c1 e0 02             	shl    $0x2,%eax
  801746:	05 40 10 81 00       	add    $0x811040,%eax
  80174b:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80174d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801750:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801753:	89 c2                	mov    %eax,%edx
  801755:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801758:	89 c8                	mov    %ecx,%eax
  80175a:	01 c0                	add    %eax,%eax
  80175c:	01 c8                	add    %ecx,%eax
  80175e:	c1 e0 02             	shl    $0x2,%eax
  801761:	05 44 10 81 00       	add    $0x811044,%eax
  801766:	89 10                	mov    %edx,(%eax)
  801768:	eb 55                	jmp    8017bf <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80176a:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801771:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801777:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80177a:	01 d0                	add    %edx,%eax
  80177c:	48                   	dec    %eax
  80177d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801780:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801783:	ba 00 00 00 00       	mov    $0x0,%edx
  801788:	f7 75 d0             	divl   -0x30(%ebp)
  80178b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80178e:	29 d0                	sub    %edx,%eax
  801790:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801793:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801796:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801799:	01 d0                	add    %edx,%eax
  80179b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8017a0:	76 0a                	jbe    8017ac <malloc+0x2c7>
            return NULL;
  8017a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a7:	e9 97 00 00 00       	jmp    801843 <malloc+0x35e>
        va = start;
  8017ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8017b2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8017b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017b8:	01 d0                	add    %edx,%eax
  8017ba:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8017bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8017c6:	eb 5e                	jmp    801826 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8017c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017cb:	89 d0                	mov    %edx,%eax
  8017cd:	01 c0                	add    %eax,%eax
  8017cf:	01 d0                	add    %edx,%eax
  8017d1:	c1 e0 02             	shl    $0x2,%eax
  8017d4:	05 48 50 80 00       	add    $0x805048,%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	84 c0                	test   %al,%al
  8017dd:	75 44                	jne    801823 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  8017df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017e2:	89 d0                	mov    %edx,%eax
  8017e4:	01 c0                	add    %eax,%eax
  8017e6:	01 d0                	add    %edx,%eax
  8017e8:	c1 e0 02             	shl    $0x2,%eax
  8017eb:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8017f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017f4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8017f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017f9:	89 d0                	mov    %edx,%eax
  8017fb:	01 c0                	add    %eax,%eax
  8017fd:	01 d0                	add    %edx,%eax
  8017ff:	c1 e0 02             	shl    $0x2,%eax
  801802:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801808:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80180b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80180d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801810:	89 d0                	mov    %edx,%eax
  801812:	01 c0                	add    %eax,%eax
  801814:	01 d0                	add    %edx,%eax
  801816:	c1 e0 02             	shl    $0x2,%eax
  801819:	05 48 50 80 00       	add    $0x805048,%eax
  80181e:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801821:	eb 0c                	jmp    80182f <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801823:	ff 45 e0             	incl   -0x20(%ebp)
  801826:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80182d:	7e 99                	jle    8017c8 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	ff 75 d4             	pushl  -0x2c(%ebp)
  801835:	ff 75 e4             	pushl  -0x1c(%ebp)
  801838:	e8 a2 19 00 00       	call   8031df <sys_allocate_user_mem>
  80183d:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  80184b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80184f:	0f 84 fa 03 00 00    	je     801c4f <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80185b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80185e:	85 c0                	test   %eax,%eax
  801860:	79 1c                	jns    80187e <free+0x39>
  801862:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801869:	77 13                	ja     80187e <free+0x39>
    {
        free_block(virtual_address);
  80186b:	83 ec 0c             	sub    $0xc,%esp
  80186e:	ff 75 08             	pushl  0x8(%ebp)
  801871:	e8 09 21 00 00       	call   80397f <free_block>
  801876:	83 c4 10             	add    $0x10,%esp
        return;
  801879:	e9 d2 03 00 00       	jmp    801c50 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80187e:	a1 30 51 83 00       	mov    0x835130,%eax
  801883:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801886:	72 09                	jb     801891 <free+0x4c>
  801888:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  80188f:	76 17                	jbe    8018a8 <free+0x63>
        panic("free: invalid address");
  801891:	83 ec 04             	sub    $0x4,%esp
  801894:	68 0d 49 80 00       	push   $0x80490d
  801899:	68 9b 00 00 00       	push   $0x9b
  80189e:	68 c4 48 80 00       	push   $0x8048c4
  8018a3:	e8 3e 26 00 00       	call   803ee6 <_panic>

    uint32 size = 0;
  8018a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  8018af:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8018b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8018bd:	eb 50                	jmp    80190f <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8018bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018c2:	89 d0                	mov    %edx,%eax
  8018c4:	01 c0                	add    %eax,%eax
  8018c6:	01 d0                	add    %edx,%eax
  8018c8:	c1 e0 02             	shl    $0x2,%eax
  8018cb:	05 48 50 80 00       	add    $0x805048,%eax
  8018d0:	8a 00                	mov    (%eax),%al
  8018d2:	84 c0                	test   %al,%al
  8018d4:	74 36                	je     80190c <free+0xc7>
  8018d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018d9:	89 d0                	mov    %edx,%eax
  8018db:	01 c0                	add    %eax,%eax
  8018dd:	01 d0                	add    %edx,%eax
  8018df:	c1 e0 02             	shl    $0x2,%eax
  8018e2:	05 40 50 80 00       	add    $0x805040,%eax
  8018e7:	8b 00                	mov    (%eax),%eax
  8018e9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8018ec:	75 1e                	jne    80190c <free+0xc7>
        {
            size = uhp_allocs[i].size;
  8018ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018f1:	89 d0                	mov    %edx,%eax
  8018f3:	01 c0                	add    %eax,%eax
  8018f5:	01 d0                	add    %edx,%eax
  8018f7:	c1 e0 02             	shl    $0x2,%eax
  8018fa:	05 44 50 80 00       	add    $0x805044,%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801904:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801907:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  80190a:	eb 0c                	jmp    801918 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80190c:	ff 45 ec             	incl   -0x14(%ebp)
  80190f:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801916:	7e a7                	jle    8018bf <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801918:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80191c:	74 06                	je     801924 <free+0xdf>
  80191e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801922:	75 17                	jne    80193b <free+0xf6>
        panic("free: unknown block");
  801924:	83 ec 04             	sub    $0x4,%esp
  801927:	68 23 49 80 00       	push   $0x804923
  80192c:	68 a9 00 00 00       	push   $0xa9
  801931:	68 c4 48 80 00       	push   $0x8048c4
  801936:	e8 ab 25 00 00       	call   803ee6 <_panic>

    uhp_allocs[idx].used = 0;
  80193b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80193e:	89 d0                	mov    %edx,%eax
  801940:	01 c0                	add    %eax,%eax
  801942:	01 d0                	add    %edx,%eax
  801944:	c1 e0 02             	shl    $0x2,%eax
  801947:	05 48 50 80 00       	add    $0x805048,%eax
  80194c:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  80194f:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801956:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80195d:	eb 64                	jmp    8019c3 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  80195f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801962:	89 d0                	mov    %edx,%eax
  801964:	01 c0                	add    %eax,%eax
  801966:	01 d0                	add    %edx,%eax
  801968:	c1 e0 02             	shl    $0x2,%eax
  80196b:	05 48 10 81 00       	add    $0x811048,%eax
  801970:	8a 00                	mov    (%eax),%al
  801972:	84 c0                	test   %al,%al
  801974:	75 4a                	jne    8019c0 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801976:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801979:	89 d0                	mov    %edx,%eax
  80197b:	01 c0                	add    %eax,%eax
  80197d:	01 d0                	add    %edx,%eax
  80197f:	c1 e0 02             	shl    $0x2,%eax
  801982:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801988:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80198b:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  80198d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801990:	89 d0                	mov    %edx,%eax
  801992:	01 c0                	add    %eax,%eax
  801994:	01 d0                	add    %edx,%eax
  801996:	c1 e0 02             	shl    $0x2,%eax
  801999:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  80199f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a2:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  8019a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019a7:	89 d0                	mov    %edx,%eax
  8019a9:	01 c0                	add    %eax,%eax
  8019ab:	01 d0                	add    %edx,%eax
  8019ad:	c1 e0 02             	shl    $0x2,%eax
  8019b0:	05 48 10 81 00       	add    $0x811048,%eax
  8019b5:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  8019b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  8019be:	eb 0c                	jmp    8019cc <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019c0:	ff 45 e4             	incl   -0x1c(%ebp)
  8019c3:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8019ca:	7e 93                	jle    80195f <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  8019cc:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8019d0:	0f 84 f1 01 00 00    	je     801bc7 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019dd:	e9 d8 01 00 00       	jmp    801bba <free+0x375>
        {
            if (i == fidx) continue;
  8019e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8019e8:	0f 84 c8 01 00 00    	je     801bb6 <free+0x371>
            if (uhp_frees[i].free)
  8019ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019f1:	89 d0                	mov    %edx,%eax
  8019f3:	01 c0                	add    %eax,%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	c1 e0 02             	shl    $0x2,%eax
  8019fa:	05 48 10 81 00       	add    $0x811048,%eax
  8019ff:	8a 00                	mov    (%eax),%al
  801a01:	84 c0                	test   %al,%al
  801a03:	0f 84 ae 01 00 00    	je     801bb7 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801a09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a0c:	89 d0                	mov    %edx,%eax
  801a0e:	01 c0                	add    %eax,%eax
  801a10:	01 d0                	add    %edx,%eax
  801a12:	c1 e0 02             	shl    $0x2,%eax
  801a15:	05 40 10 81 00       	add    $0x811040,%eax
  801a1a:	8b 08                	mov    (%eax),%ecx
  801a1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a1f:	89 d0                	mov    %edx,%eax
  801a21:	01 c0                	add    %eax,%eax
  801a23:	01 d0                	add    %edx,%eax
  801a25:	c1 e0 02             	shl    $0x2,%eax
  801a28:	05 44 10 81 00       	add    $0x811044,%eax
  801a2d:	8b 00                	mov    (%eax),%eax
  801a2f:	01 c1                	add    %eax,%ecx
  801a31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a34:	89 d0                	mov    %edx,%eax
  801a36:	01 c0                	add    %eax,%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	c1 e0 02             	shl    $0x2,%eax
  801a3d:	05 40 10 81 00       	add    $0x811040,%eax
  801a42:	8b 00                	mov    (%eax),%eax
  801a44:	39 c1                	cmp    %eax,%ecx
  801a46:	0f 85 a8 00 00 00    	jne    801af4 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801a4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a4f:	89 d0                	mov    %edx,%eax
  801a51:	01 c0                	add    %eax,%eax
  801a53:	01 d0                	add    %edx,%eax
  801a55:	c1 e0 02             	shl    $0x2,%eax
  801a58:	05 40 10 81 00       	add    $0x811040,%eax
  801a5d:	8b 10                	mov    (%eax),%edx
  801a5f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801a62:	89 c8                	mov    %ecx,%eax
  801a64:	01 c0                	add    %eax,%eax
  801a66:	01 c8                	add    %ecx,%eax
  801a68:	c1 e0 02             	shl    $0x2,%eax
  801a6b:	05 40 10 81 00       	add    $0x811040,%eax
  801a70:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801a72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a75:	89 d0                	mov    %edx,%eax
  801a77:	01 c0                	add    %eax,%eax
  801a79:	01 d0                	add    %edx,%eax
  801a7b:	c1 e0 02             	shl    $0x2,%eax
  801a7e:	05 44 10 81 00       	add    $0x811044,%eax
  801a83:	8b 08                	mov    (%eax),%ecx
  801a85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a88:	89 d0                	mov    %edx,%eax
  801a8a:	01 c0                	add    %eax,%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c1 e0 02             	shl    $0x2,%eax
  801a91:	05 44 10 81 00       	add    $0x811044,%eax
  801a96:	8b 00                	mov    (%eax),%eax
  801a98:	01 c1                	add    %eax,%ecx
  801a9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a9d:	89 d0                	mov    %edx,%eax
  801a9f:	01 c0                	add    %eax,%eax
  801aa1:	01 d0                	add    %edx,%eax
  801aa3:	c1 e0 02             	shl    $0x2,%eax
  801aa6:	05 44 10 81 00       	add    $0x811044,%eax
  801aab:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801aad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ab0:	89 d0                	mov    %edx,%eax
  801ab2:	01 c0                	add    %eax,%eax
  801ab4:	01 d0                	add    %edx,%eax
  801ab6:	c1 e0 02             	shl    $0x2,%eax
  801ab9:	05 48 10 81 00       	add    $0x811048,%eax
  801abe:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801ac1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	01 c0                	add    %eax,%eax
  801ac8:	01 d0                	add    %edx,%eax
  801aca:	c1 e0 02             	shl    $0x2,%eax
  801acd:	05 40 10 81 00       	add    $0x811040,%eax
  801ad2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801ad8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801adb:	89 d0                	mov    %edx,%eax
  801add:	01 c0                	add    %eax,%eax
  801adf:	01 d0                	add    %edx,%eax
  801ae1:	c1 e0 02             	shl    $0x2,%eax
  801ae4:	05 44 10 81 00       	add    $0x811044,%eax
  801ae9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801aef:	e9 c3 00 00 00       	jmp    801bb7 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801af4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801af7:	89 d0                	mov    %edx,%eax
  801af9:	01 c0                	add    %eax,%eax
  801afb:	01 d0                	add    %edx,%eax
  801afd:	c1 e0 02             	shl    $0x2,%eax
  801b00:	05 40 10 81 00       	add    $0x811040,%eax
  801b05:	8b 08                	mov    (%eax),%ecx
  801b07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b0a:	89 d0                	mov    %edx,%eax
  801b0c:	01 c0                	add    %eax,%eax
  801b0e:	01 d0                	add    %edx,%eax
  801b10:	c1 e0 02             	shl    $0x2,%eax
  801b13:	05 44 10 81 00       	add    $0x811044,%eax
  801b18:	8b 00                	mov    (%eax),%eax
  801b1a:	01 c1                	add    %eax,%ecx
  801b1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b1f:	89 d0                	mov    %edx,%eax
  801b21:	01 c0                	add    %eax,%eax
  801b23:	01 d0                	add    %edx,%eax
  801b25:	c1 e0 02             	shl    $0x2,%eax
  801b28:	05 40 10 81 00       	add    $0x811040,%eax
  801b2d:	8b 00                	mov    (%eax),%eax
  801b2f:	39 c1                	cmp    %eax,%ecx
  801b31:	0f 85 80 00 00 00    	jne    801bb7 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801b37:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b3a:	89 d0                	mov    %edx,%eax
  801b3c:	01 c0                	add    %eax,%eax
  801b3e:	01 d0                	add    %edx,%eax
  801b40:	c1 e0 02             	shl    $0x2,%eax
  801b43:	05 44 10 81 00       	add    $0x811044,%eax
  801b48:	8b 08                	mov    (%eax),%ecx
  801b4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b4d:	89 d0                	mov    %edx,%eax
  801b4f:	01 c0                	add    %eax,%eax
  801b51:	01 d0                	add    %edx,%eax
  801b53:	c1 e0 02             	shl    $0x2,%eax
  801b56:	05 44 10 81 00       	add    $0x811044,%eax
  801b5b:	8b 00                	mov    (%eax),%eax
  801b5d:	01 c1                	add    %eax,%ecx
  801b5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b62:	89 d0                	mov    %edx,%eax
  801b64:	01 c0                	add    %eax,%eax
  801b66:	01 d0                	add    %edx,%eax
  801b68:	c1 e0 02             	shl    $0x2,%eax
  801b6b:	05 44 10 81 00       	add    $0x811044,%eax
  801b70:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801b72:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b75:	89 d0                	mov    %edx,%eax
  801b77:	01 c0                	add    %eax,%eax
  801b79:	01 d0                	add    %edx,%eax
  801b7b:	c1 e0 02             	shl    $0x2,%eax
  801b7e:	05 48 10 81 00       	add    $0x811048,%eax
  801b83:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801b86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b89:	89 d0                	mov    %edx,%eax
  801b8b:	01 c0                	add    %eax,%eax
  801b8d:	01 d0                	add    %edx,%eax
  801b8f:	c1 e0 02             	shl    $0x2,%eax
  801b92:	05 40 10 81 00       	add    $0x811040,%eax
  801b97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801b9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ba0:	89 d0                	mov    %edx,%eax
  801ba2:	01 c0                	add    %eax,%eax
  801ba4:	01 d0                	add    %edx,%eax
  801ba6:	c1 e0 02             	shl    $0x2,%eax
  801ba9:	05 44 10 81 00       	add    $0x811044,%eax
  801bae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801bb4:	eb 01                	jmp    801bb7 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801bb6:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bb7:	ff 45 e0             	incl   -0x20(%ebp)
  801bba:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801bc1:	0f 8e 1b fe ff ff    	jle    8019e2 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801bc7:	a1 30 51 83 00       	mov    0x835130,%eax
  801bcc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801bcf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801bd6:	eb 53                	jmp    801c2b <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801bd8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801bdb:	89 d0                	mov    %edx,%eax
  801bdd:	01 c0                	add    %eax,%eax
  801bdf:	01 d0                	add    %edx,%eax
  801be1:	c1 e0 02             	shl    $0x2,%eax
  801be4:	05 48 50 80 00       	add    $0x805048,%eax
  801be9:	8a 00                	mov    (%eax),%al
  801beb:	84 c0                	test   %al,%al
  801bed:	74 39                	je     801c28 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801bef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801bf2:	89 d0                	mov    %edx,%eax
  801bf4:	01 c0                	add    %eax,%eax
  801bf6:	01 d0                	add    %edx,%eax
  801bf8:	c1 e0 02             	shl    $0x2,%eax
  801bfb:	05 40 50 80 00       	add    $0x805040,%eax
  801c00:	8b 08                	mov    (%eax),%ecx
  801c02:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c05:	89 d0                	mov    %edx,%eax
  801c07:	01 c0                	add    %eax,%eax
  801c09:	01 d0                	add    %edx,%eax
  801c0b:	c1 e0 02             	shl    $0x2,%eax
  801c0e:	05 44 50 80 00       	add    $0x805044,%eax
  801c13:	8b 00                	mov    (%eax),%eax
  801c15:	01 c8                	add    %ecx,%eax
  801c17:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801c1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c1d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801c20:	76 06                	jbe    801c28 <free+0x3e3>
  801c22:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c25:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c28:	ff 45 d8             	incl   -0x28(%ebp)
  801c2b:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801c32:	7e a4                	jle    801bd8 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801c34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c37:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801c3c:	83 ec 08             	sub    $0x8,%esp
  801c3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c42:	ff 75 d4             	pushl  -0x2c(%ebp)
  801c45:	e8 79 15 00 00       	call   8031c3 <sys_free_user_mem>
  801c4a:	83 c4 10             	add    $0x10,%esp
  801c4d:	eb 01                	jmp    801c50 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801c4f:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	83 ec 68             	sub    $0x68,%esp
  801c58:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5b:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c5e:	e8 a5 f7 ff ff       	call   801408 <uheap_init>
	if (size == 0) return NULL ;
  801c63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c67:	75 0a                	jne    801c73 <smalloc+0x21>
  801c69:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6e:	e9 37 03 00 00       	jmp    801faa <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801c73:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801c7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c80:	01 d0                	add    %edx,%eax
  801c82:	48                   	dec    %eax
  801c83:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c86:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c89:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8e:	f7 75 dc             	divl   -0x24(%ebp)
  801c91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c94:	29 d0                	sub    %edx,%eax
  801c96:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801c99:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ca0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801ca7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801cae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801cb5:	e9 85 00 00 00       	jmp    801d3f <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801cba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cbd:	89 d0                	mov    %edx,%eax
  801cbf:	01 c0                	add    %eax,%eax
  801cc1:	01 d0                	add    %edx,%eax
  801cc3:	c1 e0 02             	shl    $0x2,%eax
  801cc6:	05 48 10 81 00       	add    $0x811048,%eax
  801ccb:	8a 00                	mov    (%eax),%al
  801ccd:	84 c0                	test   %al,%al
  801ccf:	74 20                	je     801cf1 <smalloc+0x9f>
  801cd1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cd4:	89 d0                	mov    %edx,%eax
  801cd6:	01 c0                	add    %eax,%eax
  801cd8:	01 d0                	add    %edx,%eax
  801cda:	c1 e0 02             	shl    $0x2,%eax
  801cdd:	05 44 10 81 00       	add    $0x811044,%eax
  801ce2:	8b 00                	mov    (%eax),%eax
  801ce4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ce7:	75 08                	jne    801cf1 <smalloc+0x9f>
        {
            exactIdx = i;
  801ce9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801cef:	eb 5b                	jmp    801d4c <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801cf1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cf4:	89 d0                	mov    %edx,%eax
  801cf6:	01 c0                	add    %eax,%eax
  801cf8:	01 d0                	add    %edx,%eax
  801cfa:	c1 e0 02             	shl    $0x2,%eax
  801cfd:	05 48 10 81 00       	add    $0x811048,%eax
  801d02:	8a 00                	mov    (%eax),%al
  801d04:	84 c0                	test   %al,%al
  801d06:	74 34                	je     801d3c <smalloc+0xea>
  801d08:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	01 c0                	add    %eax,%eax
  801d0f:	01 d0                	add    %edx,%eax
  801d11:	c1 e0 02             	shl    $0x2,%eax
  801d14:	05 44 10 81 00       	add    $0x811044,%eax
  801d19:	8b 00                	mov    (%eax),%eax
  801d1b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d1e:	76 1c                	jbe    801d3c <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801d20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d23:	89 d0                	mov    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	01 d0                	add    %edx,%eax
  801d29:	c1 e0 02             	shl    $0x2,%eax
  801d2c:	05 44 10 81 00       	add    $0x811044,%eax
  801d31:	8b 00                	mov    (%eax),%eax
  801d33:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d39:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d3c:	ff 45 e8             	incl   -0x18(%ebp)
  801d3f:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801d46:	0f 8e 6e ff ff ff    	jle    801cba <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801d4c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801d53:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801d57:	74 7d                	je     801dd6 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801d59:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801d60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d63:	89 d0                	mov    %edx,%eax
  801d65:	01 c0                	add    %eax,%eax
  801d67:	01 d0                	add    %edx,%eax
  801d69:	c1 e0 02             	shl    $0x2,%eax
  801d6c:	05 40 10 81 00       	add    $0x811040,%eax
  801d71:	8b 10                	mov    (%eax),%edx
  801d73:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d76:	01 d0                	add    %edx,%eax
  801d78:	48                   	dec    %eax
  801d79:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801d7c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d84:	f7 75 bc             	divl   -0x44(%ebp)
  801d87:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d8a:	29 d0                	sub    %edx,%eax
  801d8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801d8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d92:	89 d0                	mov    %edx,%eax
  801d94:	01 c0                	add    %eax,%eax
  801d96:	01 d0                	add    %edx,%eax
  801d98:	c1 e0 02             	shl    $0x2,%eax
  801d9b:	05 48 10 81 00       	add    $0x811048,%eax
  801da0:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801da3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da6:	89 d0                	mov    %edx,%eax
  801da8:	01 c0                	add    %eax,%eax
  801daa:	01 d0                	add    %edx,%eax
  801dac:	c1 e0 02             	shl    $0x2,%eax
  801daf:	05 44 10 81 00       	add    $0x811044,%eax
  801db4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801dba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbd:	89 d0                	mov    %edx,%eax
  801dbf:	01 c0                	add    %eax,%eax
  801dc1:	01 d0                	add    %edx,%eax
  801dc3:	c1 e0 02             	shl    $0x2,%eax
  801dc6:	05 40 10 81 00       	add    $0x811040,%eax
  801dcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dd1:	e9 2d 01 00 00       	jmp    801f03 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801dd6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801dda:	0f 84 ce 00 00 00    	je     801eae <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801de0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801de7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dea:	89 d0                	mov    %edx,%eax
  801dec:	01 c0                	add    %eax,%eax
  801dee:	01 d0                	add    %edx,%eax
  801df0:	c1 e0 02             	shl    $0x2,%eax
  801df3:	05 40 10 81 00       	add    $0x811040,%eax
  801df8:	8b 10                	mov    (%eax),%edx
  801dfa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801dfd:	01 d0                	add    %edx,%eax
  801dff:	48                   	dec    %eax
  801e00:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801e03:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e06:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0b:	f7 75 c4             	divl   -0x3c(%ebp)
  801e0e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e11:	29 d0                	sub    %edx,%eax
  801e13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801e16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e19:	89 d0                	mov    %edx,%eax
  801e1b:	01 c0                	add    %eax,%eax
  801e1d:	01 d0                	add    %edx,%eax
  801e1f:	c1 e0 02             	shl    $0x2,%eax
  801e22:	05 44 10 81 00       	add    $0x811044,%eax
  801e27:	8b 00                	mov    (%eax),%eax
  801e29:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e2c:	75 47                	jne    801e75 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801e2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e31:	89 d0                	mov    %edx,%eax
  801e33:	01 c0                	add    %eax,%eax
  801e35:	01 d0                	add    %edx,%eax
  801e37:	c1 e0 02             	shl    $0x2,%eax
  801e3a:	05 48 10 81 00       	add    $0x811048,%eax
  801e3f:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801e42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e45:	89 d0                	mov    %edx,%eax
  801e47:	01 c0                	add    %eax,%eax
  801e49:	01 d0                	add    %edx,%eax
  801e4b:	c1 e0 02             	shl    $0x2,%eax
  801e4e:	05 44 10 81 00       	add    $0x811044,%eax
  801e53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801e59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e5c:	89 d0                	mov    %edx,%eax
  801e5e:	01 c0                	add    %eax,%eax
  801e60:	01 d0                	add    %edx,%eax
  801e62:	c1 e0 02             	shl    $0x2,%eax
  801e65:	05 40 10 81 00       	add    $0x811040,%eax
  801e6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e70:	e9 8e 00 00 00       	jmp    801f03 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801e75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e7b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801e7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e81:	89 d0                	mov    %edx,%eax
  801e83:	01 c0                	add    %eax,%eax
  801e85:	01 d0                	add    %edx,%eax
  801e87:	c1 e0 02             	shl    $0x2,%eax
  801e8a:	05 40 10 81 00       	add    $0x811040,%eax
  801e8f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e94:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801e97:	89 c2                	mov    %eax,%edx
  801e99:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e9c:	89 c8                	mov    %ecx,%eax
  801e9e:	01 c0                	add    %eax,%eax
  801ea0:	01 c8                	add    %ecx,%eax
  801ea2:	c1 e0 02             	shl    $0x2,%eax
  801ea5:	05 44 10 81 00       	add    $0x811044,%eax
  801eaa:	89 10                	mov    %edx,(%eax)
  801eac:	eb 55                	jmp    801f03 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801eae:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801eb5:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801ebb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ebe:	01 d0                	add    %edx,%eax
  801ec0:	48                   	dec    %eax
  801ec1:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801ec4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ec7:	ba 00 00 00 00       	mov    $0x0,%edx
  801ecc:	f7 75 d0             	divl   -0x30(%ebp)
  801ecf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ed2:	29 d0                	sub    %edx,%eax
  801ed4:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801ed7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801eda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801edd:	01 d0                	add    %edx,%eax
  801edf:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801ee4:	76 0a                	jbe    801ef0 <smalloc+0x29e>
            return NULL;
  801ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  801eeb:	e9 ba 00 00 00       	jmp    801faa <smalloc+0x358>
        va = start;
  801ef0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ef3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801ef6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801ef9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801efc:	01 d0                	add    %edx,%eax
  801efe:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f0a:	eb 5e                	jmp    801f6a <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  801f0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f0f:	89 d0                	mov    %edx,%eax
  801f11:	01 c0                	add    %eax,%eax
  801f13:	01 d0                	add    %edx,%eax
  801f15:	c1 e0 02             	shl    $0x2,%eax
  801f18:	05 48 50 80 00       	add    $0x805048,%eax
  801f1d:	8a 00                	mov    (%eax),%al
  801f1f:	84 c0                	test   %al,%al
  801f21:	75 44                	jne    801f67 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  801f23:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f26:	89 d0                	mov    %edx,%eax
  801f28:	01 c0                	add    %eax,%eax
  801f2a:	01 d0                	add    %edx,%eax
  801f2c:	c1 e0 02             	shl    $0x2,%eax
  801f2f:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f38:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801f3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f3d:	89 d0                	mov    %edx,%eax
  801f3f:	01 c0                	add    %eax,%eax
  801f41:	01 d0                	add    %edx,%eax
  801f43:	c1 e0 02             	shl    $0x2,%eax
  801f46:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801f4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f4f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801f51:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f54:	89 d0                	mov    %edx,%eax
  801f56:	01 c0                	add    %eax,%eax
  801f58:	01 d0                	add    %edx,%eax
  801f5a:	c1 e0 02             	shl    $0x2,%eax
  801f5d:	05 48 50 80 00       	add    $0x805048,%eax
  801f62:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801f65:	eb 0c                	jmp    801f73 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f67:	ff 45 e0             	incl   -0x20(%ebp)
  801f6a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f71:	7e 99                	jle    801f0c <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  801f73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f76:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  801f7a:	52                   	push   %edx
  801f7b:	50                   	push   %eax
  801f7c:	ff 75 d4             	pushl  -0x2c(%ebp)
  801f7f:	ff 75 08             	pushl  0x8(%ebp)
  801f82:	e8 de 0e 00 00       	call   802e65 <sys_create_shared_object>
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  801f8d:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  801f91:	75 07                	jne    801f9a <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  801f93:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f98:	eb 10                	jmp    801faa <smalloc+0x358>
    if (r < 0)
  801f9a:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  801f9e:	79 07                	jns    801fa7 <smalloc+0x355>
        return NULL;
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	eb 03                	jmp    801faa <smalloc+0x358>
    return (void*)va;
  801fa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801fb2:	e8 51 f4 ff ff       	call   801408 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  801fb7:	83 ec 08             	sub    $0x8,%esp
  801fba:	ff 75 0c             	pushl  0xc(%ebp)
  801fbd:	ff 75 08             	pushl  0x8(%ebp)
  801fc0:	e8 ca 0e 00 00       	call   802e8f <sys_size_of_shared_object>
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  801fcb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fcf:	7f 0a                	jg     801fdb <sget+0x2f>
        return NULL;
  801fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd6:	e9 28 03 00 00       	jmp    802303 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  801fdb:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801fe2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801fe5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fe8:	01 d0                	add    %edx,%eax
  801fea:	48                   	dec    %eax
  801feb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801fee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ff1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff6:	f7 75 d8             	divl   -0x28(%ebp)
  801ff9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ffc:	29 d0                	sub    %edx,%eax
  801ffe:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802001:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802008:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80200f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802016:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80201d:	e9 85 00 00 00       	jmp    8020a7 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802022:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802025:	89 d0                	mov    %edx,%eax
  802027:	01 c0                	add    %eax,%eax
  802029:	01 d0                	add    %edx,%eax
  80202b:	c1 e0 02             	shl    $0x2,%eax
  80202e:	05 48 10 81 00       	add    $0x811048,%eax
  802033:	8a 00                	mov    (%eax),%al
  802035:	84 c0                	test   %al,%al
  802037:	74 20                	je     802059 <sget+0xad>
  802039:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80203c:	89 d0                	mov    %edx,%eax
  80203e:	01 c0                	add    %eax,%eax
  802040:	01 d0                	add    %edx,%eax
  802042:	c1 e0 02             	shl    $0x2,%eax
  802045:	05 44 10 81 00       	add    $0x811044,%eax
  80204a:	8b 00                	mov    (%eax),%eax
  80204c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80204f:	75 08                	jne    802059 <sget+0xad>
        {
            exactIdx = i;
  802051:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802054:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802057:	eb 5b                	jmp    8020b4 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802059:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80205c:	89 d0                	mov    %edx,%eax
  80205e:	01 c0                	add    %eax,%eax
  802060:	01 d0                	add    %edx,%eax
  802062:	c1 e0 02             	shl    $0x2,%eax
  802065:	05 48 10 81 00       	add    $0x811048,%eax
  80206a:	8a 00                	mov    (%eax),%al
  80206c:	84 c0                	test   %al,%al
  80206e:	74 34                	je     8020a4 <sget+0xf8>
  802070:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802073:	89 d0                	mov    %edx,%eax
  802075:	01 c0                	add    %eax,%eax
  802077:	01 d0                	add    %edx,%eax
  802079:	c1 e0 02             	shl    $0x2,%eax
  80207c:	05 44 10 81 00       	add    $0x811044,%eax
  802081:	8b 00                	mov    (%eax),%eax
  802083:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802086:	76 1c                	jbe    8020a4 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802088:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80208b:	89 d0                	mov    %edx,%eax
  80208d:	01 c0                	add    %eax,%eax
  80208f:	01 d0                	add    %edx,%eax
  802091:	c1 e0 02             	shl    $0x2,%eax
  802094:	05 44 10 81 00       	add    $0x811044,%eax
  802099:	8b 00                	mov    (%eax),%eax
  80209b:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80209e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020a4:	ff 45 e8             	incl   -0x18(%ebp)
  8020a7:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8020ae:	0f 8e 6e ff ff ff    	jle    802022 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8020b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8020bb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8020bf:	74 7d                	je     80213e <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8020c1:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8020c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cb:	89 d0                	mov    %edx,%eax
  8020cd:	01 c0                	add    %eax,%eax
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	c1 e0 02             	shl    $0x2,%eax
  8020d4:	05 40 10 81 00       	add    $0x811040,%eax
  8020d9:	8b 10                	mov    (%eax),%edx
  8020db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020de:	01 d0                	add    %edx,%eax
  8020e0:	48                   	dec    %eax
  8020e1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8020e4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8020e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ec:	f7 75 b8             	divl   -0x48(%ebp)
  8020ef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8020f2:	29 d0                	sub    %edx,%eax
  8020f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8020f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fa:	89 d0                	mov    %edx,%eax
  8020fc:	01 c0                	add    %eax,%eax
  8020fe:	01 d0                	add    %edx,%eax
  802100:	c1 e0 02             	shl    $0x2,%eax
  802103:	05 48 10 81 00       	add    $0x811048,%eax
  802108:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80210b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210e:	89 d0                	mov    %edx,%eax
  802110:	01 c0                	add    %eax,%eax
  802112:	01 d0                	add    %edx,%eax
  802114:	c1 e0 02             	shl    $0x2,%eax
  802117:	05 44 10 81 00       	add    $0x811044,%eax
  80211c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802125:	89 d0                	mov    %edx,%eax
  802127:	01 c0                	add    %eax,%eax
  802129:	01 d0                	add    %edx,%eax
  80212b:	c1 e0 02             	shl    $0x2,%eax
  80212e:	05 40 10 81 00       	add    $0x811040,%eax
  802133:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802139:	e9 2d 01 00 00       	jmp    80226b <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80213e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802142:	0f 84 ce 00 00 00    	je     802216 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802148:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80214f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802152:	89 d0                	mov    %edx,%eax
  802154:	01 c0                	add    %eax,%eax
  802156:	01 d0                	add    %edx,%eax
  802158:	c1 e0 02             	shl    $0x2,%eax
  80215b:	05 40 10 81 00       	add    $0x811040,%eax
  802160:	8b 10                	mov    (%eax),%edx
  802162:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802165:	01 d0                	add    %edx,%eax
  802167:	48                   	dec    %eax
  802168:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80216b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80216e:	ba 00 00 00 00       	mov    $0x0,%edx
  802173:	f7 75 c0             	divl   -0x40(%ebp)
  802176:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802179:	29 d0                	sub    %edx,%eax
  80217b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80217e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802181:	89 d0                	mov    %edx,%eax
  802183:	01 c0                	add    %eax,%eax
  802185:	01 d0                	add    %edx,%eax
  802187:	c1 e0 02             	shl    $0x2,%eax
  80218a:	05 44 10 81 00       	add    $0x811044,%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802194:	75 47                	jne    8021dd <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802196:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802199:	89 d0                	mov    %edx,%eax
  80219b:	01 c0                	add    %eax,%eax
  80219d:	01 d0                	add    %edx,%eax
  80219f:	c1 e0 02             	shl    $0x2,%eax
  8021a2:	05 48 10 81 00       	add    $0x811048,%eax
  8021a7:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8021aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ad:	89 d0                	mov    %edx,%eax
  8021af:	01 c0                	add    %eax,%eax
  8021b1:	01 d0                	add    %edx,%eax
  8021b3:	c1 e0 02             	shl    $0x2,%eax
  8021b6:	05 44 10 81 00       	add    $0x811044,%eax
  8021bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8021c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c4:	89 d0                	mov    %edx,%eax
  8021c6:	01 c0                	add    %eax,%eax
  8021c8:	01 d0                	add    %edx,%eax
  8021ca:	c1 e0 02             	shl    $0x2,%eax
  8021cd:	05 40 10 81 00       	add    $0x811040,%eax
  8021d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d8:	e9 8e 00 00 00       	jmp    80226b <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8021dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021e3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8021e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	01 c0                	add    %eax,%eax
  8021ed:	01 d0                	add    %edx,%eax
  8021ef:	c1 e0 02             	shl    $0x2,%eax
  8021f2:	05 40 10 81 00       	add    $0x811040,%eax
  8021f7:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8021f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8021ff:	89 c2                	mov    %eax,%edx
  802201:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802204:	89 c8                	mov    %ecx,%eax
  802206:	01 c0                	add    %eax,%eax
  802208:	01 c8                	add    %ecx,%eax
  80220a:	c1 e0 02             	shl    $0x2,%eax
  80220d:	05 44 10 81 00       	add    $0x811044,%eax
  802212:	89 10                	mov    %edx,(%eax)
  802214:	eb 55                	jmp    80226b <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802216:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80221d:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802223:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802226:	01 d0                	add    %edx,%eax
  802228:	48                   	dec    %eax
  802229:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80222c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80222f:	ba 00 00 00 00       	mov    $0x0,%edx
  802234:	f7 75 cc             	divl   -0x34(%ebp)
  802237:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80223a:	29 d0                	sub    %edx,%eax
  80223c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  80223f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802242:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802245:	01 d0                	add    %edx,%eax
  802247:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80224c:	76 0a                	jbe    802258 <sget+0x2ac>
            return NULL;
  80224e:	b8 00 00 00 00       	mov    $0x0,%eax
  802253:	e9 ab 00 00 00       	jmp    802303 <sget+0x357>
        va = start;
  802258:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80225b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80225e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802261:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802264:	01 d0                	add    %edx,%eax
  802266:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80226b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802272:	eb 5e                	jmp    8022d2 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802274:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802277:	89 d0                	mov    %edx,%eax
  802279:	01 c0                	add    %eax,%eax
  80227b:	01 d0                	add    %edx,%eax
  80227d:	c1 e0 02             	shl    $0x2,%eax
  802280:	05 48 50 80 00       	add    $0x805048,%eax
  802285:	8a 00                	mov    (%eax),%al
  802287:	84 c0                	test   %al,%al
  802289:	75 44                	jne    8022cf <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80228b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80228e:	89 d0                	mov    %edx,%eax
  802290:	01 c0                	add    %eax,%eax
  802292:	01 d0                	add    %edx,%eax
  802294:	c1 e0 02             	shl    $0x2,%eax
  802297:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80229d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a0:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8022a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022a5:	89 d0                	mov    %edx,%eax
  8022a7:	01 c0                	add    %eax,%eax
  8022a9:	01 d0                	add    %edx,%eax
  8022ab:	c1 e0 02             	shl    $0x2,%eax
  8022ae:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8022b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022b7:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8022b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022bc:	89 d0                	mov    %edx,%eax
  8022be:	01 c0                	add    %eax,%eax
  8022c0:	01 d0                	add    %edx,%eax
  8022c2:	c1 e0 02             	shl    $0x2,%eax
  8022c5:	05 48 50 80 00       	add    $0x805048,%eax
  8022ca:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8022cd:	eb 0c                	jmp    8022db <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022cf:	ff 45 e0             	incl   -0x20(%ebp)
  8022d2:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8022d9:	7e 99                	jle    802274 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8022db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022de:	83 ec 04             	sub    $0x4,%esp
  8022e1:	50                   	push   %eax
  8022e2:	ff 75 0c             	pushl  0xc(%ebp)
  8022e5:	ff 75 08             	pushl  0x8(%ebp)
  8022e8:	e8 bf 0b 00 00       	call   802eac <sys_get_shared_object>
  8022ed:	83 c4 10             	add    $0x10,%esp
  8022f0:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8022f3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022f7:	79 07                	jns    802300 <sget+0x354>
        return NULL;
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fe:	eb 03                	jmp    802303 <sget+0x357>
    return (void*)va;
  802300:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80230b:	e8 f8 f0 ff ff       	call   801408 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802314:	75 13                	jne    802329 <realloc+0x24>
		return malloc(new_size);
  802316:	83 ec 0c             	sub    $0xc,%esp
  802319:	ff 75 0c             	pushl  0xc(%ebp)
  80231c:	e8 c4 f1 ff ff       	call   8014e5 <malloc>
  802321:	83 c4 10             	add    $0x10,%esp
  802324:	e9 f4 05 00 00       	jmp    80291d <realloc+0x618>
	if (new_size == 0)
  802329:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80232d:	75 18                	jne    802347 <realloc+0x42>
	{
		free(virtual_address);
  80232f:	83 ec 0c             	sub    $0xc,%esp
  802332:	ff 75 08             	pushl  0x8(%ebp)
  802335:	e8 0b f5 ff ff       	call   801845 <free>
  80233a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80233d:	b8 00 00 00 00       	mov    $0x0,%eax
  802342:	e9 d6 05 00 00       	jmp    80291d <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80234d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802350:	85 c0                	test   %eax,%eax
  802352:	79 74                	jns    8023c8 <realloc+0xc3>
  802354:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  80235b:	77 6b                	ja     8023c8 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  80235d:	83 ec 0c             	sub    $0xc,%esp
  802360:	ff 75 0c             	pushl  0xc(%ebp)
  802363:	e8 7d f1 ff ff       	call   8014e5 <malloc>
  802368:	83 c4 10             	add    $0x10,%esp
  80236b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80236e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802372:	75 0a                	jne    80237e <realloc+0x79>
			return NULL;
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
  802379:	e9 9f 05 00 00       	jmp    80291d <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  80237e:	83 ec 0c             	sub    $0xc,%esp
  802381:	ff 75 08             	pushl  0x8(%ebp)
  802384:	e8 e0 11 00 00       	call   803569 <get_block_size>
  802389:	83 c4 10             	add    $0x10,%esp
  80238c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  80238f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802392:	8b 45 0c             	mov    0xc(%ebp),%eax
  802395:	39 d0                	cmp    %edx,%eax
  802397:	76 02                	jbe    80239b <realloc+0x96>
  802399:	89 d0                	mov    %edx,%eax
  80239b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  80239e:	83 ec 04             	sub    $0x4,%esp
  8023a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8023a4:	ff 75 08             	pushl  0x8(%ebp)
  8023a7:	ff 75 c8             	pushl  -0x38(%ebp)
  8023aa:	e8 56 eb ff ff       	call   800f05 <memmove>
  8023af:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8023b2:	83 ec 0c             	sub    $0xc,%esp
  8023b5:	ff 75 08             	pushl  0x8(%ebp)
  8023b8:	e8 88 f4 ff ff       	call   801845 <free>
  8023bd:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8023c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023c3:	e9 55 05 00 00       	jmp    80291d <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8023c8:	a1 30 51 83 00       	mov    0x835130,%eax
  8023cd:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8023d0:	72 09                	jb     8023db <realloc+0xd6>
  8023d2:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8023d9:	76 0a                	jbe    8023e5 <realloc+0xe0>
		return NULL;
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e0:	e9 38 05 00 00       	jmp    80291d <realloc+0x618>
	uint32 oldsz = 0;
  8023e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8023ec:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8023f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8023fa:	eb 50                	jmp    80244c <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8023fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ff:	89 d0                	mov    %edx,%eax
  802401:	01 c0                	add    %eax,%eax
  802403:	01 d0                	add    %edx,%eax
  802405:	c1 e0 02             	shl    $0x2,%eax
  802408:	05 48 50 80 00       	add    $0x805048,%eax
  80240d:	8a 00                	mov    (%eax),%al
  80240f:	84 c0                	test   %al,%al
  802411:	74 36                	je     802449 <realloc+0x144>
  802413:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802416:	89 d0                	mov    %edx,%eax
  802418:	01 c0                	add    %eax,%eax
  80241a:	01 d0                	add    %edx,%eax
  80241c:	c1 e0 02             	shl    $0x2,%eax
  80241f:	05 40 50 80 00       	add    $0x805040,%eax
  802424:	8b 00                	mov    (%eax),%eax
  802426:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802429:	75 1e                	jne    802449 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  80242b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80242e:	89 d0                	mov    %edx,%eax
  802430:	01 c0                	add    %eax,%eax
  802432:	01 d0                	add    %edx,%eax
  802434:	c1 e0 02             	shl    $0x2,%eax
  802437:	05 44 50 80 00       	add    $0x805044,%eax
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802441:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802444:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802447:	eb 0c                	jmp    802455 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802449:	ff 45 ec             	incl   -0x14(%ebp)
  80244c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802453:	7e a7                	jle    8023fc <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802455:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802459:	75 0a                	jne    802465 <realloc+0x160>
		return NULL;
  80245b:	b8 00 00 00 00       	mov    $0x0,%eax
  802460:	e9 b8 04 00 00       	jmp    80291d <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802465:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80246c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802472:	01 d0                	add    %edx,%eax
  802474:	48                   	dec    %eax
  802475:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802478:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80247b:	ba 00 00 00 00       	mov    $0x0,%edx
  802480:	f7 75 bc             	divl   -0x44(%ebp)
  802483:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802486:	29 d0                	sub    %edx,%eax
  802488:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  80248b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80248e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802491:	75 08                	jne    80249b <realloc+0x196>
		return virtual_address;
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	e9 82 04 00 00       	jmp    80291d <realloc+0x618>
	if (req < oldsz)
  80249b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80249e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024a1:	0f 83 cd 02 00 00    	jae    802774 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8024ad:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8024b0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8024b3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8024b6:	01 d0                	add    %edx,%eax
  8024b8:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8024bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024be:	89 d0                	mov    %edx,%eax
  8024c0:	01 c0                	add    %eax,%eax
  8024c2:	01 d0                	add    %edx,%eax
  8024c4:	c1 e0 02             	shl    $0x2,%eax
  8024c7:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8024cd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8024d0:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8024d2:	83 ec 08             	sub    $0x8,%esp
  8024d5:	ff 75 b0             	pushl  -0x50(%ebp)
  8024d8:	ff 75 ac             	pushl  -0x54(%ebp)
  8024db:	e8 e3 0c 00 00       	call   8031c3 <sys_free_user_mem>
  8024e0:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8024e3:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8024ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8024f1:	eb 64                	jmp    802557 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8024f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024f6:	89 d0                	mov    %edx,%eax
  8024f8:	01 c0                	add    %eax,%eax
  8024fa:	01 d0                	add    %edx,%eax
  8024fc:	c1 e0 02             	shl    $0x2,%eax
  8024ff:	05 48 10 81 00       	add    $0x811048,%eax
  802504:	8a 00                	mov    (%eax),%al
  802506:	84 c0                	test   %al,%al
  802508:	75 4a                	jne    802554 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  80250a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80250d:	89 d0                	mov    %edx,%eax
  80250f:	01 c0                	add    %eax,%eax
  802511:	01 d0                	add    %edx,%eax
  802513:	c1 e0 02             	shl    $0x2,%eax
  802516:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  80251c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80251f:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802521:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802524:	89 d0                	mov    %edx,%eax
  802526:	01 c0                	add    %eax,%eax
  802528:	01 d0                	add    %edx,%eax
  80252a:	c1 e0 02             	shl    $0x2,%eax
  80252d:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802533:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802536:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802538:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80253b:	89 d0                	mov    %edx,%eax
  80253d:	01 c0                	add    %eax,%eax
  80253f:	01 d0                	add    %edx,%eax
  802541:	c1 e0 02             	shl    $0x2,%eax
  802544:	05 48 10 81 00       	add    $0x811048,%eax
  802549:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  80254c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802552:	eb 0c                	jmp    802560 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802554:	ff 45 e4             	incl   -0x1c(%ebp)
  802557:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80255e:	7e 93                	jle    8024f3 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802560:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802564:	0f 84 8d 01 00 00    	je     8026f7 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80256a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802571:	e9 74 01 00 00       	jmp    8026ea <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802576:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802579:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80257c:	0f 84 64 01 00 00    	je     8026e6 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802582:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802585:	89 d0                	mov    %edx,%eax
  802587:	01 c0                	add    %eax,%eax
  802589:	01 d0                	add    %edx,%eax
  80258b:	c1 e0 02             	shl    $0x2,%eax
  80258e:	05 48 10 81 00       	add    $0x811048,%eax
  802593:	8a 00                	mov    (%eax),%al
  802595:	84 c0                	test   %al,%al
  802597:	0f 84 4a 01 00 00    	je     8026e7 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80259d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025a0:	89 d0                	mov    %edx,%eax
  8025a2:	01 c0                	add    %eax,%eax
  8025a4:	01 d0                	add    %edx,%eax
  8025a6:	c1 e0 02             	shl    $0x2,%eax
  8025a9:	05 40 10 81 00       	add    $0x811040,%eax
  8025ae:	8b 08                	mov    (%eax),%ecx
  8025b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025b3:	89 d0                	mov    %edx,%eax
  8025b5:	01 c0                	add    %eax,%eax
  8025b7:	01 d0                	add    %edx,%eax
  8025b9:	c1 e0 02             	shl    $0x2,%eax
  8025bc:	05 44 10 81 00       	add    $0x811044,%eax
  8025c1:	8b 00                	mov    (%eax),%eax
  8025c3:	01 c1                	add    %eax,%ecx
  8025c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025c8:	89 d0                	mov    %edx,%eax
  8025ca:	01 c0                	add    %eax,%eax
  8025cc:	01 d0                	add    %edx,%eax
  8025ce:	c1 e0 02             	shl    $0x2,%eax
  8025d1:	05 40 10 81 00       	add    $0x811040,%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	39 c1                	cmp    %eax,%ecx
  8025da:	75 7a                	jne    802656 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8025dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025df:	89 d0                	mov    %edx,%eax
  8025e1:	01 c0                	add    %eax,%eax
  8025e3:	01 d0                	add    %edx,%eax
  8025e5:	c1 e0 02             	shl    $0x2,%eax
  8025e8:	05 40 10 81 00       	add    $0x811040,%eax
  8025ed:	8b 10                	mov    (%eax),%edx
  8025ef:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8025f2:	89 c8                	mov    %ecx,%eax
  8025f4:	01 c0                	add    %eax,%eax
  8025f6:	01 c8                	add    %ecx,%eax
  8025f8:	c1 e0 02             	shl    $0x2,%eax
  8025fb:	05 40 10 81 00       	add    $0x811040,%eax
  802600:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802602:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802605:	89 d0                	mov    %edx,%eax
  802607:	01 c0                	add    %eax,%eax
  802609:	01 d0                	add    %edx,%eax
  80260b:	c1 e0 02             	shl    $0x2,%eax
  80260e:	05 44 10 81 00       	add    $0x811044,%eax
  802613:	8b 08                	mov    (%eax),%ecx
  802615:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802618:	89 d0                	mov    %edx,%eax
  80261a:	01 c0                	add    %eax,%eax
  80261c:	01 d0                	add    %edx,%eax
  80261e:	c1 e0 02             	shl    $0x2,%eax
  802621:	05 44 10 81 00       	add    $0x811044,%eax
  802626:	8b 00                	mov    (%eax),%eax
  802628:	01 c1                	add    %eax,%ecx
  80262a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80262d:	89 d0                	mov    %edx,%eax
  80262f:	01 c0                	add    %eax,%eax
  802631:	01 d0                	add    %edx,%eax
  802633:	c1 e0 02             	shl    $0x2,%eax
  802636:	05 44 10 81 00       	add    $0x811044,%eax
  80263b:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80263d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802640:	89 d0                	mov    %edx,%eax
  802642:	01 c0                	add    %eax,%eax
  802644:	01 d0                	add    %edx,%eax
  802646:	c1 e0 02             	shl    $0x2,%eax
  802649:	05 48 10 81 00       	add    $0x811048,%eax
  80264e:	c6 00 00             	movb   $0x0,(%eax)
  802651:	e9 91 00 00 00       	jmp    8026e7 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802656:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802659:	89 d0                	mov    %edx,%eax
  80265b:	01 c0                	add    %eax,%eax
  80265d:	01 d0                	add    %edx,%eax
  80265f:	c1 e0 02             	shl    $0x2,%eax
  802662:	05 40 10 81 00       	add    $0x811040,%eax
  802667:	8b 08                	mov    (%eax),%ecx
  802669:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80266c:	89 d0                	mov    %edx,%eax
  80266e:	01 c0                	add    %eax,%eax
  802670:	01 d0                	add    %edx,%eax
  802672:	c1 e0 02             	shl    $0x2,%eax
  802675:	05 44 10 81 00       	add    $0x811044,%eax
  80267a:	8b 00                	mov    (%eax),%eax
  80267c:	01 c1                	add    %eax,%ecx
  80267e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802681:	89 d0                	mov    %edx,%eax
  802683:	01 c0                	add    %eax,%eax
  802685:	01 d0                	add    %edx,%eax
  802687:	c1 e0 02             	shl    $0x2,%eax
  80268a:	05 40 10 81 00       	add    $0x811040,%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	39 c1                	cmp    %eax,%ecx
  802693:	75 52                	jne    8026e7 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802698:	89 d0                	mov    %edx,%eax
  80269a:	01 c0                	add    %eax,%eax
  80269c:	01 d0                	add    %edx,%eax
  80269e:	c1 e0 02             	shl    $0x2,%eax
  8026a1:	05 44 10 81 00       	add    $0x811044,%eax
  8026a6:	8b 08                	mov    (%eax),%ecx
  8026a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ab:	89 d0                	mov    %edx,%eax
  8026ad:	01 c0                	add    %eax,%eax
  8026af:	01 d0                	add    %edx,%eax
  8026b1:	c1 e0 02             	shl    $0x2,%eax
  8026b4:	05 44 10 81 00       	add    $0x811044,%eax
  8026b9:	8b 00                	mov    (%eax),%eax
  8026bb:	01 c1                	add    %eax,%ecx
  8026bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026c0:	89 d0                	mov    %edx,%eax
  8026c2:	01 c0                	add    %eax,%eax
  8026c4:	01 d0                	add    %edx,%eax
  8026c6:	c1 e0 02             	shl    $0x2,%eax
  8026c9:	05 44 10 81 00       	add    $0x811044,%eax
  8026ce:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8026d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026d3:	89 d0                	mov    %edx,%eax
  8026d5:	01 c0                	add    %eax,%eax
  8026d7:	01 d0                	add    %edx,%eax
  8026d9:	c1 e0 02             	shl    $0x2,%eax
  8026dc:	05 48 10 81 00       	add    $0x811048,%eax
  8026e1:	c6 00 00             	movb   $0x0,(%eax)
  8026e4:	eb 01                	jmp    8026e7 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  8026e6:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8026e7:	ff 45 e0             	incl   -0x20(%ebp)
  8026ea:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8026f1:	0f 8e 7f fe ff ff    	jle    802576 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  8026f7:	a1 30 51 83 00       	mov    0x835130,%eax
  8026fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8026ff:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802706:	eb 53                	jmp    80275b <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802708:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80270b:	89 d0                	mov    %edx,%eax
  80270d:	01 c0                	add    %eax,%eax
  80270f:	01 d0                	add    %edx,%eax
  802711:	c1 e0 02             	shl    $0x2,%eax
  802714:	05 48 50 80 00       	add    $0x805048,%eax
  802719:	8a 00                	mov    (%eax),%al
  80271b:	84 c0                	test   %al,%al
  80271d:	74 39                	je     802758 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80271f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802722:	89 d0                	mov    %edx,%eax
  802724:	01 c0                	add    %eax,%eax
  802726:	01 d0                	add    %edx,%eax
  802728:	c1 e0 02             	shl    $0x2,%eax
  80272b:	05 40 50 80 00       	add    $0x805040,%eax
  802730:	8b 08                	mov    (%eax),%ecx
  802732:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802735:	89 d0                	mov    %edx,%eax
  802737:	01 c0                	add    %eax,%eax
  802739:	01 d0                	add    %edx,%eax
  80273b:	c1 e0 02             	shl    $0x2,%eax
  80273e:	05 44 50 80 00       	add    $0x805044,%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	01 c8                	add    %ecx,%eax
  802747:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  80274a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80274d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802750:	76 06                	jbe    802758 <realloc+0x453>
  802752:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802755:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802758:	ff 45 d8             	incl   -0x28(%ebp)
  80275b:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802762:	7e a4                	jle    802708 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802764:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802767:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  80276c:	8b 45 08             	mov    0x8(%ebp),%eax
  80276f:	e9 a9 01 00 00       	jmp    80291d <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802774:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	01 d0                	add    %edx,%eax
  80277c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  80277f:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802786:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80278d:	eb 57                	jmp    8027e6 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  80278f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802792:	89 d0                	mov    %edx,%eax
  802794:	01 c0                	add    %eax,%eax
  802796:	01 d0                	add    %edx,%eax
  802798:	c1 e0 02             	shl    $0x2,%eax
  80279b:	05 48 10 81 00       	add    $0x811048,%eax
  8027a0:	8a 00                	mov    (%eax),%al
  8027a2:	84 c0                	test   %al,%al
  8027a4:	74 3d                	je     8027e3 <realloc+0x4de>
  8027a6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8027a9:	89 d0                	mov    %edx,%eax
  8027ab:	01 c0                	add    %eax,%eax
  8027ad:	01 d0                	add    %edx,%eax
  8027af:	c1 e0 02             	shl    $0x2,%eax
  8027b2:	05 40 10 81 00       	add    $0x811040,%eax
  8027b7:	8b 00                	mov    (%eax),%eax
  8027b9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027bc:	75 25                	jne    8027e3 <realloc+0x4de>
  8027be:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8027c1:	89 d0                	mov    %edx,%eax
  8027c3:	01 c0                	add    %eax,%eax
  8027c5:	01 d0                	add    %edx,%eax
  8027c7:	c1 e0 02             	shl    $0x2,%eax
  8027ca:	05 44 10 81 00       	add    $0x811044,%eax
  8027cf:	8b 10                	mov    (%eax),%edx
  8027d1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027d4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8027d7:	39 c2                	cmp    %eax,%edx
  8027d9:	72 08                	jb     8027e3 <realloc+0x4de>
		{
			adjIdx = j; break;
  8027db:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027de:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027e1:	eb 0c                	jmp    8027ef <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8027e3:	ff 45 d0             	incl   -0x30(%ebp)
  8027e6:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  8027ed:	7e a0                	jle    80278f <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  8027ef:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  8027f3:	0f 84 d6 00 00 00    	je     8028cf <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  8027f9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027fc:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8027ff:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802802:	83 ec 08             	sub    $0x8,%esp
  802805:	ff 75 a0             	pushl  -0x60(%ebp)
  802808:	ff 75 a4             	pushl  -0x5c(%ebp)
  80280b:	e8 cf 09 00 00       	call   8031df <sys_allocate_user_mem>
  802810:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802813:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802816:	89 d0                	mov    %edx,%eax
  802818:	01 c0                	add    %eax,%eax
  80281a:	01 d0                	add    %edx,%eax
  80281c:	c1 e0 02             	shl    $0x2,%eax
  80281f:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802825:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802828:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  80282a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80282d:	89 d0                	mov    %edx,%eax
  80282f:	01 c0                	add    %eax,%eax
  802831:	01 d0                	add    %edx,%eax
  802833:	c1 e0 02             	shl    $0x2,%eax
  802836:	05 40 10 81 00       	add    $0x811040,%eax
  80283b:	8b 10                	mov    (%eax),%edx
  80283d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802840:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802843:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802846:	89 d0                	mov    %edx,%eax
  802848:	01 c0                	add    %eax,%eax
  80284a:	01 d0                	add    %edx,%eax
  80284c:	c1 e0 02             	shl    $0x2,%eax
  80284f:	05 40 10 81 00       	add    $0x811040,%eax
  802854:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802856:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802859:	89 d0                	mov    %edx,%eax
  80285b:	01 c0                	add    %eax,%eax
  80285d:	01 d0                	add    %edx,%eax
  80285f:	c1 e0 02             	shl    $0x2,%eax
  802862:	05 44 10 81 00       	add    $0x811044,%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	2b 45 a0             	sub    -0x60(%ebp),%eax
  80286c:	89 c2                	mov    %eax,%edx
  80286e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802871:	89 c8                	mov    %ecx,%eax
  802873:	01 c0                	add    %eax,%eax
  802875:	01 c8                	add    %ecx,%eax
  802877:	c1 e0 02             	shl    $0x2,%eax
  80287a:	05 44 10 81 00       	add    $0x811044,%eax
  80287f:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802881:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802884:	89 d0                	mov    %edx,%eax
  802886:	01 c0                	add    %eax,%eax
  802888:	01 d0                	add    %edx,%eax
  80288a:	c1 e0 02             	shl    $0x2,%eax
  80288d:	05 44 10 81 00       	add    $0x811044,%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	85 c0                	test   %eax,%eax
  802896:	75 14                	jne    8028ac <realloc+0x5a7>
  802898:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80289b:	89 d0                	mov    %edx,%eax
  80289d:	01 c0                	add    %eax,%eax
  80289f:	01 d0                	add    %edx,%eax
  8028a1:	c1 e0 02             	shl    $0x2,%eax
  8028a4:	05 48 10 81 00       	add    $0x811048,%eax
  8028a9:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  8028ac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028af:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028b2:	01 c2                	add    %eax,%edx
  8028b4:	a1 88 50 83 00       	mov    0x835088,%eax
  8028b9:	39 c2                	cmp    %eax,%edx
  8028bb:	76 0d                	jbe    8028ca <realloc+0x5c5>
  8028bd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028c3:	01 d0                	add    %edx,%eax
  8028c5:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	eb 4e                	jmp    80291d <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  8028cf:	83 ec 0c             	sub    $0xc,%esp
  8028d2:	ff 75 0c             	pushl  0xc(%ebp)
  8028d5:	e8 0b ec ff ff       	call   8014e5 <malloc>
  8028da:	83 c4 10             	add    $0x10,%esp
  8028dd:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  8028e0:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8028e4:	75 07                	jne    8028ed <realloc+0x5e8>
		return NULL;
  8028e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028eb:	eb 30                	jmp    80291d <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  8028ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028f3:	39 d0                	cmp    %edx,%eax
  8028f5:	76 02                	jbe    8028f9 <realloc+0x5f4>
  8028f7:	89 d0                	mov    %edx,%eax
  8028f9:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8028fc:	83 ec 04             	sub    $0x4,%esp
  8028ff:	50                   	push   %eax
  802900:	52                   	push   %edx
  802901:	ff 75 cc             	pushl  -0x34(%ebp)
  802904:	e8 cf 06 00 00       	call   802fd8 <sys_move_user_mem>
  802909:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  80290c:	83 ec 0c             	sub    $0xc,%esp
  80290f:	ff 75 08             	pushl  0x8(%ebp)
  802912:	e8 2e ef ff ff       	call   801845 <free>
  802917:	83 c4 10             	add    $0x10,%esp
	return newptr;
  80291a:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  80291d:	c9                   	leave  
  80291e:	c3                   	ret    

0080291f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80291f:	55                   	push   %ebp
  802920:	89 e5                	mov    %esp,%ebp
  802922:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802925:	8b 45 08             	mov    0x8(%ebp),%eax
  802928:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  80292b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80292f:	0f 84 33 03 00 00    	je     802c68 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802935:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802938:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  80293d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802940:	83 ec 08             	sub    $0x8,%esp
  802943:	ff 75 08             	pushl  0x8(%ebp)
  802946:	ff 75 d8             	pushl  -0x28(%ebp)
  802949:	e8 7d 05 00 00       	call   802ecb <sys_delete_shared_object>
  80294e:	83 c4 10             	add    $0x10,%esp
  802951:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802954:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802958:	0f 88 0d 03 00 00    	js     802c6b <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80295e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802965:	e9 ef 02 00 00       	jmp    802c59 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80296a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296d:	89 d0                	mov    %edx,%eax
  80296f:	01 c0                	add    %eax,%eax
  802971:	01 d0                	add    %edx,%eax
  802973:	c1 e0 02             	shl    $0x2,%eax
  802976:	05 48 50 80 00       	add    $0x805048,%eax
  80297b:	8a 00                	mov    (%eax),%al
  80297d:	84 c0                	test   %al,%al
  80297f:	0f 84 d1 02 00 00    	je     802c56 <sfree+0x337>
  802985:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802988:	89 d0                	mov    %edx,%eax
  80298a:	01 c0                	add    %eax,%eax
  80298c:	01 d0                	add    %edx,%eax
  80298e:	c1 e0 02             	shl    $0x2,%eax
  802991:	05 40 50 80 00       	add    $0x805040,%eax
  802996:	8b 00                	mov    (%eax),%eax
  802998:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80299b:	0f 85 b5 02 00 00    	jne    802c56 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  8029a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a4:	89 d0                	mov    %edx,%eax
  8029a6:	01 c0                	add    %eax,%eax
  8029a8:	01 d0                	add    %edx,%eax
  8029aa:	c1 e0 02             	shl    $0x2,%eax
  8029ad:	05 44 50 80 00       	add    $0x805044,%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  8029b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ba:	89 d0                	mov    %edx,%eax
  8029bc:	01 c0                	add    %eax,%eax
  8029be:	01 d0                	add    %edx,%eax
  8029c0:	c1 e0 02             	shl    $0x2,%eax
  8029c3:	05 48 50 80 00       	add    $0x805048,%eax
  8029c8:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  8029cb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8029d9:	eb 64                	jmp    802a3f <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  8029db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029de:	89 d0                	mov    %edx,%eax
  8029e0:	01 c0                	add    %eax,%eax
  8029e2:	01 d0                	add    %edx,%eax
  8029e4:	c1 e0 02             	shl    $0x2,%eax
  8029e7:	05 48 10 81 00       	add    $0x811048,%eax
  8029ec:	8a 00                	mov    (%eax),%al
  8029ee:	84 c0                	test   %al,%al
  8029f0:	75 4a                	jne    802a3c <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  8029f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f5:	89 d0                	mov    %edx,%eax
  8029f7:	01 c0                	add    %eax,%eax
  8029f9:	01 d0                	add    %edx,%eax
  8029fb:	c1 e0 02             	shl    $0x2,%eax
  8029fe:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802a04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a07:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802a09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a0c:	89 d0                	mov    %edx,%eax
  802a0e:	01 c0                	add    %eax,%eax
  802a10:	01 d0                	add    %edx,%eax
  802a12:	c1 e0 02             	shl    $0x2,%eax
  802a15:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802a1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a1e:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802a20:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a23:	89 d0                	mov    %edx,%eax
  802a25:	01 c0                	add    %eax,%eax
  802a27:	01 d0                	add    %edx,%eax
  802a29:	c1 e0 02             	shl    $0x2,%eax
  802a2c:	05 48 10 81 00       	add    $0x811048,%eax
  802a31:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802a34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802a3a:	eb 0c                	jmp    802a48 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a3c:	ff 45 ec             	incl   -0x14(%ebp)
  802a3f:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802a46:	7e 93                	jle    8029db <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802a48:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802a4c:	0f 84 8d 01 00 00    	je     802bdf <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802a52:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802a59:	e9 74 01 00 00       	jmp    802bd2 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a61:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a64:	0f 84 64 01 00 00    	je     802bce <sfree+0x2af>
					if (uhp_frees[k].free)
  802a6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a6d:	89 d0                	mov    %edx,%eax
  802a6f:	01 c0                	add    %eax,%eax
  802a71:	01 d0                	add    %edx,%eax
  802a73:	c1 e0 02             	shl    $0x2,%eax
  802a76:	05 48 10 81 00       	add    $0x811048,%eax
  802a7b:	8a 00                	mov    (%eax),%al
  802a7d:	84 c0                	test   %al,%al
  802a7f:	0f 84 4a 01 00 00    	je     802bcf <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802a85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a88:	89 d0                	mov    %edx,%eax
  802a8a:	01 c0                	add    %eax,%eax
  802a8c:	01 d0                	add    %edx,%eax
  802a8e:	c1 e0 02             	shl    $0x2,%eax
  802a91:	05 40 10 81 00       	add    $0x811040,%eax
  802a96:	8b 08                	mov    (%eax),%ecx
  802a98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a9b:	89 d0                	mov    %edx,%eax
  802a9d:	01 c0                	add    %eax,%eax
  802a9f:	01 d0                	add    %edx,%eax
  802aa1:	c1 e0 02             	shl    $0x2,%eax
  802aa4:	05 44 10 81 00       	add    $0x811044,%eax
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	01 c1                	add    %eax,%ecx
  802aad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab0:	89 d0                	mov    %edx,%eax
  802ab2:	01 c0                	add    %eax,%eax
  802ab4:	01 d0                	add    %edx,%eax
  802ab6:	c1 e0 02             	shl    $0x2,%eax
  802ab9:	05 40 10 81 00       	add    $0x811040,%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	39 c1                	cmp    %eax,%ecx
  802ac2:	75 7a                	jne    802b3e <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802ac4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ac7:	89 d0                	mov    %edx,%eax
  802ac9:	01 c0                	add    %eax,%eax
  802acb:	01 d0                	add    %edx,%eax
  802acd:	c1 e0 02             	shl    $0x2,%eax
  802ad0:	05 40 10 81 00       	add    $0x811040,%eax
  802ad5:	8b 10                	mov    (%eax),%edx
  802ad7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ada:	89 c8                	mov    %ecx,%eax
  802adc:	01 c0                	add    %eax,%eax
  802ade:	01 c8                	add    %ecx,%eax
  802ae0:	c1 e0 02             	shl    $0x2,%eax
  802ae3:	05 40 10 81 00       	add    $0x811040,%eax
  802ae8:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802aea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aed:	89 d0                	mov    %edx,%eax
  802aef:	01 c0                	add    %eax,%eax
  802af1:	01 d0                	add    %edx,%eax
  802af3:	c1 e0 02             	shl    $0x2,%eax
  802af6:	05 44 10 81 00       	add    $0x811044,%eax
  802afb:	8b 08                	mov    (%eax),%ecx
  802afd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b00:	89 d0                	mov    %edx,%eax
  802b02:	01 c0                	add    %eax,%eax
  802b04:	01 d0                	add    %edx,%eax
  802b06:	c1 e0 02             	shl    $0x2,%eax
  802b09:	05 44 10 81 00       	add    $0x811044,%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	01 c1                	add    %eax,%ecx
  802b12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b15:	89 d0                	mov    %edx,%eax
  802b17:	01 c0                	add    %eax,%eax
  802b19:	01 d0                	add    %edx,%eax
  802b1b:	c1 e0 02             	shl    $0x2,%eax
  802b1e:	05 44 10 81 00       	add    $0x811044,%eax
  802b23:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b28:	89 d0                	mov    %edx,%eax
  802b2a:	01 c0                	add    %eax,%eax
  802b2c:	01 d0                	add    %edx,%eax
  802b2e:	c1 e0 02             	shl    $0x2,%eax
  802b31:	05 48 10 81 00       	add    $0x811048,%eax
  802b36:	c6 00 00             	movb   $0x0,(%eax)
  802b39:	e9 91 00 00 00       	jmp    802bcf <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802b3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b41:	89 d0                	mov    %edx,%eax
  802b43:	01 c0                	add    %eax,%eax
  802b45:	01 d0                	add    %edx,%eax
  802b47:	c1 e0 02             	shl    $0x2,%eax
  802b4a:	05 40 10 81 00       	add    $0x811040,%eax
  802b4f:	8b 08                	mov    (%eax),%ecx
  802b51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b54:	89 d0                	mov    %edx,%eax
  802b56:	01 c0                	add    %eax,%eax
  802b58:	01 d0                	add    %edx,%eax
  802b5a:	c1 e0 02             	shl    $0x2,%eax
  802b5d:	05 44 10 81 00       	add    $0x811044,%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	01 c1                	add    %eax,%ecx
  802b66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b69:	89 d0                	mov    %edx,%eax
  802b6b:	01 c0                	add    %eax,%eax
  802b6d:	01 d0                	add    %edx,%eax
  802b6f:	c1 e0 02             	shl    $0x2,%eax
  802b72:	05 40 10 81 00       	add    $0x811040,%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	39 c1                	cmp    %eax,%ecx
  802b7b:	75 52                	jne    802bcf <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802b7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b80:	89 d0                	mov    %edx,%eax
  802b82:	01 c0                	add    %eax,%eax
  802b84:	01 d0                	add    %edx,%eax
  802b86:	c1 e0 02             	shl    $0x2,%eax
  802b89:	05 44 10 81 00       	add    $0x811044,%eax
  802b8e:	8b 08                	mov    (%eax),%ecx
  802b90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b93:	89 d0                	mov    %edx,%eax
  802b95:	01 c0                	add    %eax,%eax
  802b97:	01 d0                	add    %edx,%eax
  802b99:	c1 e0 02             	shl    $0x2,%eax
  802b9c:	05 44 10 81 00       	add    $0x811044,%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	01 c1                	add    %eax,%ecx
  802ba5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba8:	89 d0                	mov    %edx,%eax
  802baa:	01 c0                	add    %eax,%eax
  802bac:	01 d0                	add    %edx,%eax
  802bae:	c1 e0 02             	shl    $0x2,%eax
  802bb1:	05 44 10 81 00       	add    $0x811044,%eax
  802bb6:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802bb8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bbb:	89 d0                	mov    %edx,%eax
  802bbd:	01 c0                	add    %eax,%eax
  802bbf:	01 d0                	add    %edx,%eax
  802bc1:	c1 e0 02             	shl    $0x2,%eax
  802bc4:	05 48 10 81 00       	add    $0x811048,%eax
  802bc9:	c6 00 00             	movb   $0x0,(%eax)
  802bcc:	eb 01                	jmp    802bcf <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802bce:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802bcf:	ff 45 e8             	incl   -0x18(%ebp)
  802bd2:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802bd9:	0f 8e 7f fe ff ff    	jle    802a5e <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802bdf:	a1 30 51 83 00       	mov    0x835130,%eax
  802be4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802be7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802bee:	eb 53                	jmp    802c43 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802bf0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bf3:	89 d0                	mov    %edx,%eax
  802bf5:	01 c0                	add    %eax,%eax
  802bf7:	01 d0                	add    %edx,%eax
  802bf9:	c1 e0 02             	shl    $0x2,%eax
  802bfc:	05 48 50 80 00       	add    $0x805048,%eax
  802c01:	8a 00                	mov    (%eax),%al
  802c03:	84 c0                	test   %al,%al
  802c05:	74 39                	je     802c40 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802c07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c0a:	89 d0                	mov    %edx,%eax
  802c0c:	01 c0                	add    %eax,%eax
  802c0e:	01 d0                	add    %edx,%eax
  802c10:	c1 e0 02             	shl    $0x2,%eax
  802c13:	05 40 50 80 00       	add    $0x805040,%eax
  802c18:	8b 08                	mov    (%eax),%ecx
  802c1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c1d:	89 d0                	mov    %edx,%eax
  802c1f:	01 c0                	add    %eax,%eax
  802c21:	01 d0                	add    %edx,%eax
  802c23:	c1 e0 02             	shl    $0x2,%eax
  802c26:	05 44 50 80 00       	add    $0x805044,%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	01 c8                	add    %ecx,%eax
  802c2f:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802c32:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c35:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c38:	76 06                	jbe    802c40 <sfree+0x321>
  802c3a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802c40:	ff 45 e0             	incl   -0x20(%ebp)
  802c43:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802c4a:	7e a4                	jle    802bf0 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4f:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802c54:	eb 16                	jmp    802c6c <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802c56:	ff 45 f4             	incl   -0xc(%ebp)
  802c59:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802c60:	0f 8e 04 fd ff ff    	jle    80296a <sfree+0x4b>
  802c66:	eb 04                	jmp    802c6c <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802c68:	90                   	nop
  802c69:	eb 01                	jmp    802c6c <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802c6b:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802c6c:	c9                   	leave  
  802c6d:	c3                   	ret    

00802c6e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802c6e:	55                   	push   %ebp
  802c6f:	89 e5                	mov    %esp,%ebp
  802c71:	57                   	push   %edi
  802c72:	56                   	push   %esi
  802c73:	53                   	push   %ebx
  802c74:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c83:	8b 7d 18             	mov    0x18(%ebp),%edi
  802c86:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802c89:	cd 30                	int    $0x30
  802c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802c91:	83 c4 10             	add    $0x10,%esp
  802c94:	5b                   	pop    %ebx
  802c95:	5e                   	pop    %esi
  802c96:	5f                   	pop    %edi
  802c97:	5d                   	pop    %ebp
  802c98:	c3                   	ret    

00802c99 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802c99:	55                   	push   %ebp
  802c9a:	89 e5                	mov    %esp,%ebp
  802c9c:	83 ec 04             	sub    $0x4,%esp
  802c9f:	8b 45 10             	mov    0x10(%ebp),%eax
  802ca2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802ca5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ca8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	6a 00                	push   $0x0
  802cb1:	51                   	push   %ecx
  802cb2:	52                   	push   %edx
  802cb3:	ff 75 0c             	pushl  0xc(%ebp)
  802cb6:	50                   	push   %eax
  802cb7:	6a 00                	push   $0x0
  802cb9:	e8 b0 ff ff ff       	call   802c6e <syscall>
  802cbe:	83 c4 18             	add    $0x18,%esp
}
  802cc1:	90                   	nop
  802cc2:	c9                   	leave  
  802cc3:	c3                   	ret    

00802cc4 <sys_cgetc>:

int
sys_cgetc(void)
{
  802cc4:	55                   	push   %ebp
  802cc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802cc7:	6a 00                	push   $0x0
  802cc9:	6a 00                	push   $0x0
  802ccb:	6a 00                	push   $0x0
  802ccd:	6a 00                	push   $0x0
  802ccf:	6a 00                	push   $0x0
  802cd1:	6a 02                	push   $0x2
  802cd3:	e8 96 ff ff ff       	call   802c6e <syscall>
  802cd8:	83 c4 18             	add    $0x18,%esp
}
  802cdb:	c9                   	leave  
  802cdc:	c3                   	ret    

00802cdd <sys_lock_cons>:

void sys_lock_cons(void)
{
  802cdd:	55                   	push   %ebp
  802cde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802ce0:	6a 00                	push   $0x0
  802ce2:	6a 00                	push   $0x0
  802ce4:	6a 00                	push   $0x0
  802ce6:	6a 00                	push   $0x0
  802ce8:	6a 00                	push   $0x0
  802cea:	6a 03                	push   $0x3
  802cec:	e8 7d ff ff ff       	call   802c6e <syscall>
  802cf1:	83 c4 18             	add    $0x18,%esp
}
  802cf4:	90                   	nop
  802cf5:	c9                   	leave  
  802cf6:	c3                   	ret    

00802cf7 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802cf7:	55                   	push   %ebp
  802cf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802cfa:	6a 00                	push   $0x0
  802cfc:	6a 00                	push   $0x0
  802cfe:	6a 00                	push   $0x0
  802d00:	6a 00                	push   $0x0
  802d02:	6a 00                	push   $0x0
  802d04:	6a 04                	push   $0x4
  802d06:	e8 63 ff ff ff       	call   802c6e <syscall>
  802d0b:	83 c4 18             	add    $0x18,%esp
}
  802d0e:	90                   	nop
  802d0f:	c9                   	leave  
  802d10:	c3                   	ret    

00802d11 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802d11:	55                   	push   %ebp
  802d12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	6a 00                	push   $0x0
  802d1c:	6a 00                	push   $0x0
  802d1e:	6a 00                	push   $0x0
  802d20:	52                   	push   %edx
  802d21:	50                   	push   %eax
  802d22:	6a 08                	push   $0x8
  802d24:	e8 45 ff ff ff       	call   802c6e <syscall>
  802d29:	83 c4 18             	add    $0x18,%esp
}
  802d2c:	c9                   	leave  
  802d2d:	c3                   	ret    

00802d2e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802d2e:	55                   	push   %ebp
  802d2f:	89 e5                	mov    %esp,%ebp
  802d31:	56                   	push   %esi
  802d32:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802d33:	8b 75 18             	mov    0x18(%ebp),%esi
  802d36:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	56                   	push   %esi
  802d43:	53                   	push   %ebx
  802d44:	51                   	push   %ecx
  802d45:	52                   	push   %edx
  802d46:	50                   	push   %eax
  802d47:	6a 09                	push   $0x9
  802d49:	e8 20 ff ff ff       	call   802c6e <syscall>
  802d4e:	83 c4 18             	add    $0x18,%esp
}
  802d51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d54:	5b                   	pop    %ebx
  802d55:	5e                   	pop    %esi
  802d56:	5d                   	pop    %ebp
  802d57:	c3                   	ret    

00802d58 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802d58:	55                   	push   %ebp
  802d59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802d5b:	6a 00                	push   $0x0
  802d5d:	6a 00                	push   $0x0
  802d5f:	6a 00                	push   $0x0
  802d61:	6a 00                	push   $0x0
  802d63:	ff 75 08             	pushl  0x8(%ebp)
  802d66:	6a 0a                	push   $0xa
  802d68:	e8 01 ff ff ff       	call   802c6e <syscall>
  802d6d:	83 c4 18             	add    $0x18,%esp
}
  802d70:	c9                   	leave  
  802d71:	c3                   	ret    

00802d72 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802d72:	55                   	push   %ebp
  802d73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802d75:	6a 00                	push   $0x0
  802d77:	6a 00                	push   $0x0
  802d79:	6a 00                	push   $0x0
  802d7b:	ff 75 0c             	pushl  0xc(%ebp)
  802d7e:	ff 75 08             	pushl  0x8(%ebp)
  802d81:	6a 0b                	push   $0xb
  802d83:	e8 e6 fe ff ff       	call   802c6e <syscall>
  802d88:	83 c4 18             	add    $0x18,%esp
}
  802d8b:	c9                   	leave  
  802d8c:	c3                   	ret    

00802d8d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802d8d:	55                   	push   %ebp
  802d8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802d90:	6a 00                	push   $0x0
  802d92:	6a 00                	push   $0x0
  802d94:	6a 00                	push   $0x0
  802d96:	6a 00                	push   $0x0
  802d98:	6a 00                	push   $0x0
  802d9a:	6a 0c                	push   $0xc
  802d9c:	e8 cd fe ff ff       	call   802c6e <syscall>
  802da1:	83 c4 18             	add    $0x18,%esp
}
  802da4:	c9                   	leave  
  802da5:	c3                   	ret    

00802da6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802da6:	55                   	push   %ebp
  802da7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802da9:	6a 00                	push   $0x0
  802dab:	6a 00                	push   $0x0
  802dad:	6a 00                	push   $0x0
  802daf:	6a 00                	push   $0x0
  802db1:	6a 00                	push   $0x0
  802db3:	6a 0d                	push   $0xd
  802db5:	e8 b4 fe ff ff       	call   802c6e <syscall>
  802dba:	83 c4 18             	add    $0x18,%esp
}
  802dbd:	c9                   	leave  
  802dbe:	c3                   	ret    

00802dbf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802dbf:	55                   	push   %ebp
  802dc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802dc2:	6a 00                	push   $0x0
  802dc4:	6a 00                	push   $0x0
  802dc6:	6a 00                	push   $0x0
  802dc8:	6a 00                	push   $0x0
  802dca:	6a 00                	push   $0x0
  802dcc:	6a 0e                	push   $0xe
  802dce:	e8 9b fe ff ff       	call   802c6e <syscall>
  802dd3:	83 c4 18             	add    $0x18,%esp
}
  802dd6:	c9                   	leave  
  802dd7:	c3                   	ret    

00802dd8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802dd8:	55                   	push   %ebp
  802dd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802ddb:	6a 00                	push   $0x0
  802ddd:	6a 00                	push   $0x0
  802ddf:	6a 00                	push   $0x0
  802de1:	6a 00                	push   $0x0
  802de3:	6a 00                	push   $0x0
  802de5:	6a 0f                	push   $0xf
  802de7:	e8 82 fe ff ff       	call   802c6e <syscall>
  802dec:	83 c4 18             	add    $0x18,%esp
}
  802def:	c9                   	leave  
  802df0:	c3                   	ret    

00802df1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802df1:	55                   	push   %ebp
  802df2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802df4:	6a 00                	push   $0x0
  802df6:	6a 00                	push   $0x0
  802df8:	6a 00                	push   $0x0
  802dfa:	6a 00                	push   $0x0
  802dfc:	ff 75 08             	pushl  0x8(%ebp)
  802dff:	6a 10                	push   $0x10
  802e01:	e8 68 fe ff ff       	call   802c6e <syscall>
  802e06:	83 c4 18             	add    $0x18,%esp
}
  802e09:	c9                   	leave  
  802e0a:	c3                   	ret    

00802e0b <sys_scarce_memory>:

void sys_scarce_memory()
{
  802e0b:	55                   	push   %ebp
  802e0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802e0e:	6a 00                	push   $0x0
  802e10:	6a 00                	push   $0x0
  802e12:	6a 00                	push   $0x0
  802e14:	6a 00                	push   $0x0
  802e16:	6a 00                	push   $0x0
  802e18:	6a 11                	push   $0x11
  802e1a:	e8 4f fe ff ff       	call   802c6e <syscall>
  802e1f:	83 c4 18             	add    $0x18,%esp
}
  802e22:	90                   	nop
  802e23:	c9                   	leave  
  802e24:	c3                   	ret    

00802e25 <sys_cputc>:

void
sys_cputc(const char c)
{
  802e25:	55                   	push   %ebp
  802e26:	89 e5                	mov    %esp,%ebp
  802e28:	83 ec 04             	sub    $0x4,%esp
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802e31:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e35:	6a 00                	push   $0x0
  802e37:	6a 00                	push   $0x0
  802e39:	6a 00                	push   $0x0
  802e3b:	6a 00                	push   $0x0
  802e3d:	50                   	push   %eax
  802e3e:	6a 01                	push   $0x1
  802e40:	e8 29 fe ff ff       	call   802c6e <syscall>
  802e45:	83 c4 18             	add    $0x18,%esp
}
  802e48:	90                   	nop
  802e49:	c9                   	leave  
  802e4a:	c3                   	ret    

00802e4b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802e4b:	55                   	push   %ebp
  802e4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802e4e:	6a 00                	push   $0x0
  802e50:	6a 00                	push   $0x0
  802e52:	6a 00                	push   $0x0
  802e54:	6a 00                	push   $0x0
  802e56:	6a 00                	push   $0x0
  802e58:	6a 14                	push   $0x14
  802e5a:	e8 0f fe ff ff       	call   802c6e <syscall>
  802e5f:	83 c4 18             	add    $0x18,%esp
}
  802e62:	90                   	nop
  802e63:	c9                   	leave  
  802e64:	c3                   	ret    

00802e65 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802e65:	55                   	push   %ebp
  802e66:	89 e5                	mov    %esp,%ebp
  802e68:	83 ec 04             	sub    $0x4,%esp
  802e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  802e6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802e71:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e74:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	6a 00                	push   $0x0
  802e7d:	51                   	push   %ecx
  802e7e:	52                   	push   %edx
  802e7f:	ff 75 0c             	pushl  0xc(%ebp)
  802e82:	50                   	push   %eax
  802e83:	6a 15                	push   $0x15
  802e85:	e8 e4 fd ff ff       	call   802c6e <syscall>
  802e8a:	83 c4 18             	add    $0x18,%esp
}
  802e8d:	c9                   	leave  
  802e8e:	c3                   	ret    

00802e8f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802e8f:	55                   	push   %ebp
  802e90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	6a 00                	push   $0x0
  802e9a:	6a 00                	push   $0x0
  802e9c:	6a 00                	push   $0x0
  802e9e:	52                   	push   %edx
  802e9f:	50                   	push   %eax
  802ea0:	6a 16                	push   $0x16
  802ea2:	e8 c7 fd ff ff       	call   802c6e <syscall>
  802ea7:	83 c4 18             	add    $0x18,%esp
}
  802eaa:	c9                   	leave  
  802eab:	c3                   	ret    

00802eac <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802eac:	55                   	push   %ebp
  802ead:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802eaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	51                   	push   %ecx
  802ebd:	52                   	push   %edx
  802ebe:	50                   	push   %eax
  802ebf:	6a 17                	push   $0x17
  802ec1:	e8 a8 fd ff ff       	call   802c6e <syscall>
  802ec6:	83 c4 18             	add    $0x18,%esp
}
  802ec9:	c9                   	leave  
  802eca:	c3                   	ret    

00802ecb <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802ecb:	55                   	push   %ebp
  802ecc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802ece:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 00                	push   $0x0
  802ed8:	6a 00                	push   $0x0
  802eda:	52                   	push   %edx
  802edb:	50                   	push   %eax
  802edc:	6a 18                	push   $0x18
  802ede:	e8 8b fd ff ff       	call   802c6e <syscall>
  802ee3:	83 c4 18             	add    $0x18,%esp
}
  802ee6:	c9                   	leave  
  802ee7:	c3                   	ret    

00802ee8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ee8:	55                   	push   %ebp
  802ee9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	6a 00                	push   $0x0
  802ef0:	ff 75 14             	pushl  0x14(%ebp)
  802ef3:	ff 75 10             	pushl  0x10(%ebp)
  802ef6:	ff 75 0c             	pushl  0xc(%ebp)
  802ef9:	50                   	push   %eax
  802efa:	6a 19                	push   $0x19
  802efc:	e8 6d fd ff ff       	call   802c6e <syscall>
  802f01:	83 c4 18             	add    $0x18,%esp
}
  802f04:	c9                   	leave  
  802f05:	c3                   	ret    

00802f06 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802f06:	55                   	push   %ebp
  802f07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 00                	push   $0x0
  802f12:	6a 00                	push   $0x0
  802f14:	50                   	push   %eax
  802f15:	6a 1a                	push   $0x1a
  802f17:	e8 52 fd ff ff       	call   802c6e <syscall>
  802f1c:	83 c4 18             	add    $0x18,%esp
}
  802f1f:	90                   	nop
  802f20:	c9                   	leave  
  802f21:	c3                   	ret    

00802f22 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802f22:	55                   	push   %ebp
  802f23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	6a 00                	push   $0x0
  802f2a:	6a 00                	push   $0x0
  802f2c:	6a 00                	push   $0x0
  802f2e:	6a 00                	push   $0x0
  802f30:	50                   	push   %eax
  802f31:	6a 1b                	push   $0x1b
  802f33:	e8 36 fd ff ff       	call   802c6e <syscall>
  802f38:	83 c4 18             	add    $0x18,%esp
}
  802f3b:	c9                   	leave  
  802f3c:	c3                   	ret    

00802f3d <sys_getenvid>:

int32 sys_getenvid(void)
{
  802f3d:	55                   	push   %ebp
  802f3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802f40:	6a 00                	push   $0x0
  802f42:	6a 00                	push   $0x0
  802f44:	6a 00                	push   $0x0
  802f46:	6a 00                	push   $0x0
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 05                	push   $0x5
  802f4c:	e8 1d fd ff ff       	call   802c6e <syscall>
  802f51:	83 c4 18             	add    $0x18,%esp
}
  802f54:	c9                   	leave  
  802f55:	c3                   	ret    

00802f56 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802f56:	55                   	push   %ebp
  802f57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802f59:	6a 00                	push   $0x0
  802f5b:	6a 00                	push   $0x0
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 00                	push   $0x0
  802f61:	6a 00                	push   $0x0
  802f63:	6a 06                	push   $0x6
  802f65:	e8 04 fd ff ff       	call   802c6e <syscall>
  802f6a:	83 c4 18             	add    $0x18,%esp
}
  802f6d:	c9                   	leave  
  802f6e:	c3                   	ret    

00802f6f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802f6f:	55                   	push   %ebp
  802f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802f72:	6a 00                	push   $0x0
  802f74:	6a 00                	push   $0x0
  802f76:	6a 00                	push   $0x0
  802f78:	6a 00                	push   $0x0
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 07                	push   $0x7
  802f7e:	e8 eb fc ff ff       	call   802c6e <syscall>
  802f83:	83 c4 18             	add    $0x18,%esp
}
  802f86:	c9                   	leave  
  802f87:	c3                   	ret    

00802f88 <sys_exit_env>:


void sys_exit_env(void)
{
  802f88:	55                   	push   %ebp
  802f89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802f8b:	6a 00                	push   $0x0
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 1c                	push   $0x1c
  802f97:	e8 d2 fc ff ff       	call   802c6e <syscall>
  802f9c:	83 c4 18             	add    $0x18,%esp
}
  802f9f:	90                   	nop
  802fa0:	c9                   	leave  
  802fa1:	c3                   	ret    

00802fa2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802fa2:	55                   	push   %ebp
  802fa3:	89 e5                	mov    %esp,%ebp
  802fa5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802fa8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802fab:	8d 50 04             	lea    0x4(%eax),%edx
  802fae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	52                   	push   %edx
  802fb8:	50                   	push   %eax
  802fb9:	6a 1d                	push   $0x1d
  802fbb:	e8 ae fc ff ff       	call   802c6e <syscall>
  802fc0:	83 c4 18             	add    $0x18,%esp
	return result;
  802fc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802fc9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802fcc:	89 01                	mov    %eax,(%ecx)
  802fce:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	c9                   	leave  
  802fd5:	c2 04 00             	ret    $0x4

00802fd8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802fd8:	55                   	push   %ebp
  802fd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 00                	push   $0x0
  802fdf:	ff 75 10             	pushl  0x10(%ebp)
  802fe2:	ff 75 0c             	pushl  0xc(%ebp)
  802fe5:	ff 75 08             	pushl  0x8(%ebp)
  802fe8:	6a 13                	push   $0x13
  802fea:	e8 7f fc ff ff       	call   802c6e <syscall>
  802fef:	83 c4 18             	add    $0x18,%esp
	return ;
  802ff2:	90                   	nop
}
  802ff3:	c9                   	leave  
  802ff4:	c3                   	ret    

00802ff5 <sys_rcr2>:
uint32 sys_rcr2()
{
  802ff5:	55                   	push   %ebp
  802ff6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	6a 00                	push   $0x0
  802ffe:	6a 00                	push   $0x0
  803000:	6a 00                	push   $0x0
  803002:	6a 1e                	push   $0x1e
  803004:	e8 65 fc ff ff       	call   802c6e <syscall>
  803009:	83 c4 18             	add    $0x18,%esp
}
  80300c:	c9                   	leave  
  80300d:	c3                   	ret    

0080300e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80300e:	55                   	push   %ebp
  80300f:	89 e5                	mov    %esp,%ebp
  803011:	83 ec 04             	sub    $0x4,%esp
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80301a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	6a 00                	push   $0x0
  803026:	50                   	push   %eax
  803027:	6a 1f                	push   $0x1f
  803029:	e8 40 fc ff ff       	call   802c6e <syscall>
  80302e:	83 c4 18             	add    $0x18,%esp
	return ;
  803031:	90                   	nop
}
  803032:	c9                   	leave  
  803033:	c3                   	ret    

00803034 <rsttst>:
void rsttst()
{
  803034:	55                   	push   %ebp
  803035:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803037:	6a 00                	push   $0x0
  803039:	6a 00                	push   $0x0
  80303b:	6a 00                	push   $0x0
  80303d:	6a 00                	push   $0x0
  80303f:	6a 00                	push   $0x0
  803041:	6a 21                	push   $0x21
  803043:	e8 26 fc ff ff       	call   802c6e <syscall>
  803048:	83 c4 18             	add    $0x18,%esp
	return ;
  80304b:	90                   	nop
}
  80304c:	c9                   	leave  
  80304d:	c3                   	ret    

0080304e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80304e:	55                   	push   %ebp
  80304f:	89 e5                	mov    %esp,%ebp
  803051:	83 ec 04             	sub    $0x4,%esp
  803054:	8b 45 14             	mov    0x14(%ebp),%eax
  803057:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80305a:	8b 55 18             	mov    0x18(%ebp),%edx
  80305d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803061:	52                   	push   %edx
  803062:	50                   	push   %eax
  803063:	ff 75 10             	pushl  0x10(%ebp)
  803066:	ff 75 0c             	pushl  0xc(%ebp)
  803069:	ff 75 08             	pushl  0x8(%ebp)
  80306c:	6a 20                	push   $0x20
  80306e:	e8 fb fb ff ff       	call   802c6e <syscall>
  803073:	83 c4 18             	add    $0x18,%esp
	return ;
  803076:	90                   	nop
}
  803077:	c9                   	leave  
  803078:	c3                   	ret    

00803079 <chktst>:
void chktst(uint32 n)
{
  803079:	55                   	push   %ebp
  80307a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80307c:	6a 00                	push   $0x0
  80307e:	6a 00                	push   $0x0
  803080:	6a 00                	push   $0x0
  803082:	6a 00                	push   $0x0
  803084:	ff 75 08             	pushl  0x8(%ebp)
  803087:	6a 22                	push   $0x22
  803089:	e8 e0 fb ff ff       	call   802c6e <syscall>
  80308e:	83 c4 18             	add    $0x18,%esp
	return ;
  803091:	90                   	nop
}
  803092:	c9                   	leave  
  803093:	c3                   	ret    

00803094 <inctst>:

void inctst()
{
  803094:	55                   	push   %ebp
  803095:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803097:	6a 00                	push   $0x0
  803099:	6a 00                	push   $0x0
  80309b:	6a 00                	push   $0x0
  80309d:	6a 00                	push   $0x0
  80309f:	6a 00                	push   $0x0
  8030a1:	6a 23                	push   $0x23
  8030a3:	e8 c6 fb ff ff       	call   802c6e <syscall>
  8030a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8030ab:	90                   	nop
}
  8030ac:	c9                   	leave  
  8030ad:	c3                   	ret    

008030ae <gettst>:
uint32 gettst()
{
  8030ae:	55                   	push   %ebp
  8030af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 00                	push   $0x0
  8030b9:	6a 00                	push   $0x0
  8030bb:	6a 24                	push   $0x24
  8030bd:	e8 ac fb ff ff       	call   802c6e <syscall>
  8030c2:	83 c4 18             	add    $0x18,%esp
}
  8030c5:	c9                   	leave  
  8030c6:	c3                   	ret    

008030c7 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8030c7:	55                   	push   %ebp
  8030c8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8030ca:	6a 00                	push   $0x0
  8030cc:	6a 00                	push   $0x0
  8030ce:	6a 00                	push   $0x0
  8030d0:	6a 00                	push   $0x0
  8030d2:	6a 00                	push   $0x0
  8030d4:	6a 25                	push   $0x25
  8030d6:	e8 93 fb ff ff       	call   802c6e <syscall>
  8030db:	83 c4 18             	add    $0x18,%esp
  8030de:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  8030e3:	a1 80 50 83 00       	mov    0x835080,%eax
}
  8030e8:	c9                   	leave  
  8030e9:	c3                   	ret    

008030ea <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8030ea:	55                   	push   %ebp
  8030eb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8030f5:	6a 00                	push   $0x0
  8030f7:	6a 00                	push   $0x0
  8030f9:	6a 00                	push   $0x0
  8030fb:	6a 00                	push   $0x0
  8030fd:	ff 75 08             	pushl  0x8(%ebp)
  803100:	6a 26                	push   $0x26
  803102:	e8 67 fb ff ff       	call   802c6e <syscall>
  803107:	83 c4 18             	add    $0x18,%esp
	return ;
  80310a:	90                   	nop
}
  80310b:	c9                   	leave  
  80310c:	c3                   	ret    

0080310d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80310d:	55                   	push   %ebp
  80310e:	89 e5                	mov    %esp,%ebp
  803110:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803111:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803114:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803117:	8b 55 0c             	mov    0xc(%ebp),%edx
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	6a 00                	push   $0x0
  80311f:	53                   	push   %ebx
  803120:	51                   	push   %ecx
  803121:	52                   	push   %edx
  803122:	50                   	push   %eax
  803123:	6a 27                	push   $0x27
  803125:	e8 44 fb ff ff       	call   802c6e <syscall>
  80312a:	83 c4 18             	add    $0x18,%esp
}
  80312d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803130:	c9                   	leave  
  803131:	c3                   	ret    

00803132 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803132:	55                   	push   %ebp
  803133:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803135:	8b 55 0c             	mov    0xc(%ebp),%edx
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	6a 00                	push   $0x0
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	52                   	push   %edx
  803142:	50                   	push   %eax
  803143:	6a 28                	push   $0x28
  803145:	e8 24 fb ff ff       	call   802c6e <syscall>
  80314a:	83 c4 18             	add    $0x18,%esp
}
  80314d:	c9                   	leave  
  80314e:	c3                   	ret    

0080314f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80314f:	55                   	push   %ebp
  803150:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803152:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803155:	8b 55 0c             	mov    0xc(%ebp),%edx
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	6a 00                	push   $0x0
  80315d:	51                   	push   %ecx
  80315e:	ff 75 10             	pushl  0x10(%ebp)
  803161:	52                   	push   %edx
  803162:	50                   	push   %eax
  803163:	6a 29                	push   $0x29
  803165:	e8 04 fb ff ff       	call   802c6e <syscall>
  80316a:	83 c4 18             	add    $0x18,%esp
}
  80316d:	c9                   	leave  
  80316e:	c3                   	ret    

0080316f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80316f:	55                   	push   %ebp
  803170:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803172:	6a 00                	push   $0x0
  803174:	6a 00                	push   $0x0
  803176:	ff 75 10             	pushl  0x10(%ebp)
  803179:	ff 75 0c             	pushl  0xc(%ebp)
  80317c:	ff 75 08             	pushl  0x8(%ebp)
  80317f:	6a 12                	push   $0x12
  803181:	e8 e8 fa ff ff       	call   802c6e <syscall>
  803186:	83 c4 18             	add    $0x18,%esp
	return ;
  803189:	90                   	nop
}
  80318a:	c9                   	leave  
  80318b:	c3                   	ret    

0080318c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80318c:	55                   	push   %ebp
  80318d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80318f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	6a 00                	push   $0x0
  803197:	6a 00                	push   $0x0
  803199:	6a 00                	push   $0x0
  80319b:	52                   	push   %edx
  80319c:	50                   	push   %eax
  80319d:	6a 2a                	push   $0x2a
  80319f:	e8 ca fa ff ff       	call   802c6e <syscall>
  8031a4:	83 c4 18             	add    $0x18,%esp
	return;
  8031a7:	90                   	nop
}
  8031a8:	c9                   	leave  
  8031a9:	c3                   	ret    

008031aa <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8031aa:	55                   	push   %ebp
  8031ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8031ad:	6a 00                	push   $0x0
  8031af:	6a 00                	push   $0x0
  8031b1:	6a 00                	push   $0x0
  8031b3:	6a 00                	push   $0x0
  8031b5:	6a 00                	push   $0x0
  8031b7:	6a 2b                	push   $0x2b
  8031b9:	e8 b0 fa ff ff       	call   802c6e <syscall>
  8031be:	83 c4 18             	add    $0x18,%esp
}
  8031c1:	c9                   	leave  
  8031c2:	c3                   	ret    

008031c3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8031c3:	55                   	push   %ebp
  8031c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8031c6:	6a 00                	push   $0x0
  8031c8:	6a 00                	push   $0x0
  8031ca:	6a 00                	push   $0x0
  8031cc:	ff 75 0c             	pushl  0xc(%ebp)
  8031cf:	ff 75 08             	pushl  0x8(%ebp)
  8031d2:	6a 2d                	push   $0x2d
  8031d4:	e8 95 fa ff ff       	call   802c6e <syscall>
  8031d9:	83 c4 18             	add    $0x18,%esp
	return;
  8031dc:	90                   	nop
}
  8031dd:	c9                   	leave  
  8031de:	c3                   	ret    

008031df <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8031df:	55                   	push   %ebp
  8031e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8031e2:	6a 00                	push   $0x0
  8031e4:	6a 00                	push   $0x0
  8031e6:	6a 00                	push   $0x0
  8031e8:	ff 75 0c             	pushl  0xc(%ebp)
  8031eb:	ff 75 08             	pushl  0x8(%ebp)
  8031ee:	6a 2c                	push   $0x2c
  8031f0:	e8 79 fa ff ff       	call   802c6e <syscall>
  8031f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8031f8:	90                   	nop
}
  8031f9:	c9                   	leave  
  8031fa:	c3                   	ret    

008031fb <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8031fb:	55                   	push   %ebp
  8031fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8031fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	6a 00                	push   $0x0
  803206:	6a 00                	push   $0x0
  803208:	6a 00                	push   $0x0
  80320a:	52                   	push   %edx
  80320b:	50                   	push   %eax
  80320c:	6a 2e                	push   $0x2e
  80320e:	e8 5b fa ff ff       	call   802c6e <syscall>
  803213:	83 c4 18             	add    $0x18,%esp
}
  803216:	90                   	nop
  803217:	c9                   	leave  
  803218:	c3                   	ret    

00803219 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803219:	55                   	push   %ebp
  80321a:	89 e5                	mov    %esp,%ebp
  80321c:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80321f:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803226:	72 09                	jb     803231 <to_page_va+0x18>
  803228:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  80322f:	72 14                	jb     803245 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803231:	83 ec 04             	sub    $0x4,%esp
  803234:	68 38 49 80 00       	push   $0x804938
  803239:	6a 15                	push   $0x15
  80323b:	68 63 49 80 00       	push   $0x804963
  803240:	e8 a1 0c 00 00       	call   803ee6 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  80324d:	29 d0                	sub    %edx,%eax
  80324f:	c1 f8 02             	sar    $0x2,%eax
  803252:	89 c2                	mov    %eax,%edx
  803254:	89 d0                	mov    %edx,%eax
  803256:	c1 e0 02             	shl    $0x2,%eax
  803259:	01 d0                	add    %edx,%eax
  80325b:	c1 e0 02             	shl    $0x2,%eax
  80325e:	01 d0                	add    %edx,%eax
  803260:	c1 e0 02             	shl    $0x2,%eax
  803263:	01 d0                	add    %edx,%eax
  803265:	89 c1                	mov    %eax,%ecx
  803267:	c1 e1 08             	shl    $0x8,%ecx
  80326a:	01 c8                	add    %ecx,%eax
  80326c:	89 c1                	mov    %eax,%ecx
  80326e:	c1 e1 10             	shl    $0x10,%ecx
  803271:	01 c8                	add    %ecx,%eax
  803273:	01 c0                	add    %eax,%eax
  803275:	01 d0                	add    %edx,%eax
  803277:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80327a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327d:	c1 e0 0c             	shl    $0xc,%eax
  803280:	89 c2                	mov    %eax,%edx
  803282:	a1 84 50 83 00       	mov    0x835084,%eax
  803287:	01 d0                	add    %edx,%eax
}
  803289:	c9                   	leave  
  80328a:	c3                   	ret    

0080328b <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80328b:	55                   	push   %ebp
  80328c:	89 e5                	mov    %esp,%ebp
  80328e:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803291:	a1 84 50 83 00       	mov    0x835084,%eax
  803296:	8b 55 08             	mov    0x8(%ebp),%edx
  803299:	29 c2                	sub    %eax,%edx
  80329b:	89 d0                	mov    %edx,%eax
  80329d:	c1 e8 0c             	shr    $0xc,%eax
  8032a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8032a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a7:	78 09                	js     8032b2 <to_page_info+0x27>
  8032a9:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8032b0:	7e 14                	jle    8032c6 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8032b2:	83 ec 04             	sub    $0x4,%esp
  8032b5:	68 7c 49 80 00       	push   $0x80497c
  8032ba:	6a 21                	push   $0x21
  8032bc:	68 63 49 80 00       	push   $0x804963
  8032c1:	e8 20 0c 00 00       	call   803ee6 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8032c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c9:	89 d0                	mov    %edx,%eax
  8032cb:	01 c0                	add    %eax,%eax
  8032cd:	01 d0                	add    %edx,%eax
  8032cf:	c1 e0 02             	shl    $0x2,%eax
  8032d2:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  8032d7:	c9                   	leave  
  8032d8:	c3                   	ret    

008032d9 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8032d9:	55                   	push   %ebp
  8032da:	89 e5                	mov    %esp,%ebp
  8032dc:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	05 00 00 00 02       	add    $0x2000000,%eax
  8032e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032ea:	73 16                	jae    803302 <initialize_dynamic_allocator+0x29>
  8032ec:	68 a0 49 80 00       	push   $0x8049a0
  8032f1:	68 c6 49 80 00       	push   $0x8049c6
  8032f6:	6a 2f                	push   $0x2f
  8032f8:	68 63 49 80 00       	push   $0x804963
  8032fd:	e8 e4 0b 00 00       	call   803ee6 <_panic>
	dynAllocStart = daStart;
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  80330a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330d:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803319:	eb 36                	jmp    803351 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  80331b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331e:	c1 e0 04             	shl    $0x4,%eax
  803321:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803326:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332f:	c1 e0 04             	shl    $0x4,%eax
  803332:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803337:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803340:	c1 e0 04             	shl    $0x4,%eax
  803343:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803348:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80334e:	ff 45 f4             	incl   -0xc(%ebp)
  803351:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803355:	7e c4                	jle    80331b <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803357:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  80335e:	00 00 00 
  803361:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803368:	00 00 00 
  80336b:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  803372:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803375:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80337c:	e9 1b 01 00 00       	jmp    80349c <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803384:	89 d0                	mov    %edx,%eax
  803386:	01 c0                	add    %eax,%eax
  803388:	01 d0                	add    %edx,%eax
  80338a:	c1 e0 02             	shl    $0x2,%eax
  80338d:	05 88 d0 81 00       	add    $0x81d088,%eax
  803392:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803397:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80339a:	89 d0                	mov    %edx,%eax
  80339c:	01 c0                	add    %eax,%eax
  80339e:	01 d0                	add    %edx,%eax
  8033a0:	c1 e0 02             	shl    $0x2,%eax
  8033a3:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8033a8:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8033ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b0:	89 d0                	mov    %edx,%eax
  8033b2:	01 c0                	add    %eax,%eax
  8033b4:	01 d0                	add    %edx,%eax
  8033b6:	c1 e0 02             	shl    $0x2,%eax
  8033b9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033be:	8b 00                	mov    (%eax),%eax
  8033c0:	85 c0                	test   %eax,%eax
  8033c2:	74 2b                	je     8033ef <initialize_dynamic_allocator+0x116>
  8033c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033c7:	89 d0                	mov    %edx,%eax
  8033c9:	01 c0                	add    %eax,%eax
  8033cb:	01 d0                	add    %edx,%eax
  8033cd:	c1 e0 02             	shl    $0x2,%eax
  8033d0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033d5:	8b 10                	mov    (%eax),%edx
  8033d7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8033da:	89 c8                	mov    %ecx,%eax
  8033dc:	01 c0                	add    %eax,%eax
  8033de:	01 c8                	add    %ecx,%eax
  8033e0:	c1 e0 02             	shl    $0x2,%eax
  8033e3:	05 84 d0 81 00       	add    $0x81d084,%eax
  8033e8:	8b 00                	mov    (%eax),%eax
  8033ea:	89 42 04             	mov    %eax,0x4(%edx)
  8033ed:	eb 18                	jmp    803407 <initialize_dynamic_allocator+0x12e>
  8033ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f2:	89 d0                	mov    %edx,%eax
  8033f4:	01 c0                	add    %eax,%eax
  8033f6:	01 d0                	add    %edx,%eax
  8033f8:	c1 e0 02             	shl    $0x2,%eax
  8033fb:	05 84 d0 81 00       	add    $0x81d084,%eax
  803400:	8b 00                	mov    (%eax),%eax
  803402:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803407:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340a:	89 d0                	mov    %edx,%eax
  80340c:	01 c0                	add    %eax,%eax
  80340e:	01 d0                	add    %edx,%eax
  803410:	c1 e0 02             	shl    $0x2,%eax
  803413:	05 84 d0 81 00       	add    $0x81d084,%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	85 c0                	test   %eax,%eax
  80341c:	74 2a                	je     803448 <initialize_dynamic_allocator+0x16f>
  80341e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803421:	89 d0                	mov    %edx,%eax
  803423:	01 c0                	add    %eax,%eax
  803425:	01 d0                	add    %edx,%eax
  803427:	c1 e0 02             	shl    $0x2,%eax
  80342a:	05 84 d0 81 00       	add    $0x81d084,%eax
  80342f:	8b 10                	mov    (%eax),%edx
  803431:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803434:	89 c8                	mov    %ecx,%eax
  803436:	01 c0                	add    %eax,%eax
  803438:	01 c8                	add    %ecx,%eax
  80343a:	c1 e0 02             	shl    $0x2,%eax
  80343d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	89 02                	mov    %eax,(%edx)
  803446:	eb 18                	jmp    803460 <initialize_dynamic_allocator+0x187>
  803448:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80344b:	89 d0                	mov    %edx,%eax
  80344d:	01 c0                	add    %eax,%eax
  80344f:	01 d0                	add    %edx,%eax
  803451:	c1 e0 02             	shl    $0x2,%eax
  803454:	05 80 d0 81 00       	add    $0x81d080,%eax
  803459:	8b 00                	mov    (%eax),%eax
  80345b:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803463:	89 d0                	mov    %edx,%eax
  803465:	01 c0                	add    %eax,%eax
  803467:	01 d0                	add    %edx,%eax
  803469:	c1 e0 02             	shl    $0x2,%eax
  80346c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803477:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80347a:	89 d0                	mov    %edx,%eax
  80347c:	01 c0                	add    %eax,%eax
  80347e:	01 d0                	add    %edx,%eax
  803480:	c1 e0 02             	shl    $0x2,%eax
  803483:	05 84 d0 81 00       	add    $0x81d084,%eax
  803488:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80348e:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803493:	48                   	dec    %eax
  803494:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803499:	ff 45 f0             	incl   -0x10(%ebp)
  80349c:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8034a3:	0f 8e d8 fe ff ff    	jle    803381 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8034a9:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8034b0:	e9 9d 00 00 00       	jmp    803552 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8034b5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8034bb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8034be:	89 c8                	mov    %ecx,%eax
  8034c0:	01 c0                	add    %eax,%eax
  8034c2:	01 c8                	add    %ecx,%eax
  8034c4:	c1 e0 02             	shl    $0x2,%eax
  8034c7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034cc:	89 10                	mov    %edx,(%eax)
  8034ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034d1:	89 d0                	mov    %edx,%eax
  8034d3:	01 c0                	add    %eax,%eax
  8034d5:	01 d0                	add    %edx,%eax
  8034d7:	c1 e0 02             	shl    $0x2,%eax
  8034da:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	85 c0                	test   %eax,%eax
  8034e3:	74 1c                	je     803501 <initialize_dynamic_allocator+0x228>
  8034e5:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8034eb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8034ee:	89 c8                	mov    %ecx,%eax
  8034f0:	01 c0                	add    %eax,%eax
  8034f2:	01 c8                	add    %ecx,%eax
  8034f4:	c1 e0 02             	shl    $0x2,%eax
  8034f7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034fc:	89 42 04             	mov    %eax,0x4(%edx)
  8034ff:	eb 16                	jmp    803517 <initialize_dynamic_allocator+0x23e>
  803501:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803504:	89 d0                	mov    %edx,%eax
  803506:	01 c0                	add    %eax,%eax
  803508:	01 d0                	add    %edx,%eax
  80350a:	c1 e0 02             	shl    $0x2,%eax
  80350d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803512:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803517:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80351a:	89 d0                	mov    %edx,%eax
  80351c:	01 c0                	add    %eax,%eax
  80351e:	01 d0                	add    %edx,%eax
  803520:	c1 e0 02             	shl    $0x2,%eax
  803523:	05 80 d0 81 00       	add    $0x81d080,%eax
  803528:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80352d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803530:	89 d0                	mov    %edx,%eax
  803532:	01 c0                	add    %eax,%eax
  803534:	01 d0                	add    %edx,%eax
  803536:	c1 e0 02             	shl    $0x2,%eax
  803539:	05 84 d0 81 00       	add    $0x81d084,%eax
  80353e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803544:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803549:	40                   	inc    %eax
  80354a:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80354f:	ff 4d ec             	decl   -0x14(%ebp)
  803552:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803556:	0f 89 59 ff ff ff    	jns    8034b5 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  80355c:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803563:	00 00 00 
}
  803566:	90                   	nop
  803567:	c9                   	leave  
  803568:	c3                   	ret    

00803569 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803569:	55                   	push   %ebp
  80356a:	89 e5                	mov    %esp,%ebp
  80356c:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80356f:	8b 45 08             	mov    0x8(%ebp),%eax
  803572:	83 ec 0c             	sub    $0xc,%esp
  803575:	50                   	push   %eax
  803576:	e8 10 fd ff ff       	call   80328b <to_page_info>
  80357b:	83 c4 10             	add    $0x10,%esp
  80357e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803584:	8b 40 08             	mov    0x8(%eax),%eax
  803587:	0f b7 c0             	movzwl %ax,%eax
}
  80358a:	c9                   	leave  
  80358b:	c3                   	ret    

0080358c <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80358c:	55                   	push   %ebp
  80358d:	89 e5                	mov    %esp,%ebp
  80358f:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803592:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803599:	76 16                	jbe    8035b1 <alloc_block+0x25>
  80359b:	68 dc 49 80 00       	push   $0x8049dc
  8035a0:	68 c6 49 80 00       	push   $0x8049c6
  8035a5:	6a 59                	push   $0x59
  8035a7:	68 63 49 80 00       	push   $0x804963
  8035ac:	e8 35 09 00 00       	call   803ee6 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8035b1:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8035b8:	eb 08                	jmp    8035c2 <alloc_block+0x36>
		allocSize <<= 1;
  8035ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bd:	01 c0                	add    %eax,%eax
  8035bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035c8:	73 09                	jae    8035d3 <alloc_block+0x47>
  8035ca:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8035d1:	76 e7                	jbe    8035ba <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8035d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8035da:	eb 03                	jmp    8035df <alloc_block+0x53>
		listIndex++;
  8035dc:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8035df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e2:	ba 08 00 00 00       	mov    $0x8,%edx
  8035e7:	88 c1                	mov    %al,%cl
  8035e9:	d3 e2                	shl    %cl,%edx
  8035eb:	89 d0                	mov    %edx,%eax
  8035ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8035f0:	72 ea                	jb     8035dc <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8035f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8035f8:	e9 f4 00 00 00       	jmp    8036f1 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8035fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803600:	c1 e0 04             	shl    $0x4,%eax
  803603:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803608:	8b 00                	mov    (%eax),%eax
  80360a:	85 c0                	test   %eax,%eax
  80360c:	0f 84 dc 00 00 00    	je     8036ee <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803615:	c1 e0 04             	shl    $0x4,%eax
  803618:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80361d:	8b 00                	mov    (%eax),%eax
  80361f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803622:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803626:	75 14                	jne    80363c <alloc_block+0xb0>
  803628:	83 ec 04             	sub    $0x4,%esp
  80362b:	68 fd 49 80 00       	push   $0x8049fd
  803630:	6a 6b                	push   $0x6b
  803632:	68 63 49 80 00       	push   $0x804963
  803637:	e8 aa 08 00 00       	call   803ee6 <_panic>
  80363c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363f:	8b 00                	mov    (%eax),%eax
  803641:	85 c0                	test   %eax,%eax
  803643:	74 10                	je     803655 <alloc_block+0xc9>
  803645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803648:	8b 00                	mov    (%eax),%eax
  80364a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80364d:	8b 52 04             	mov    0x4(%edx),%edx
  803650:	89 50 04             	mov    %edx,0x4(%eax)
  803653:	eb 14                	jmp    803669 <alloc_block+0xdd>
  803655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80365e:	c1 e2 04             	shl    $0x4,%edx
  803661:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803667:	89 02                	mov    %eax,(%edx)
  803669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366c:	8b 40 04             	mov    0x4(%eax),%eax
  80366f:	85 c0                	test   %eax,%eax
  803671:	74 0f                	je     803682 <alloc_block+0xf6>
  803673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803676:	8b 40 04             	mov    0x4(%eax),%eax
  803679:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80367c:	8b 12                	mov    (%edx),%edx
  80367e:	89 10                	mov    %edx,(%eax)
  803680:	eb 13                	jmp    803695 <alloc_block+0x109>
  803682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803685:	8b 00                	mov    (%eax),%eax
  803687:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80368a:	c1 e2 04             	shl    $0x4,%edx
  80368d:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803693:	89 02                	mov    %eax,(%edx)
  803695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803698:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80369e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ab:	c1 e0 04             	shl    $0x4,%eax
  8036ae:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8036b3:	8b 00                	mov    (%eax),%eax
  8036b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8036b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036bb:	c1 e0 04             	shl    $0x4,%eax
  8036be:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8036c3:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8036c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c8:	83 ec 0c             	sub    $0xc,%esp
  8036cb:	50                   	push   %eax
  8036cc:	e8 ba fb ff ff       	call   80328b <to_page_info>
  8036d1:	83 c4 10             	add    $0x10,%esp
  8036d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  8036d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036da:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8036de:	48                   	dec    %eax
  8036df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036e2:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  8036e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e9:	e9 8f 02 00 00       	jmp    80397d <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8036ee:	ff 45 ec             	incl   -0x14(%ebp)
  8036f1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8036f5:	0f 8e 02 ff ff ff    	jle    8035fd <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  8036fb:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803700:	85 c0                	test   %eax,%eax
  803702:	75 14                	jne    803718 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803704:	83 ec 04             	sub    $0x4,%esp
  803707:	68 1c 4a 80 00       	push   $0x804a1c
  80370c:	6a 77                	push   $0x77
  80370e:	68 63 49 80 00       	push   $0x804963
  803713:	e8 ce 07 00 00       	call   803ee6 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803718:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80371d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803720:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803724:	75 14                	jne    80373a <alloc_block+0x1ae>
  803726:	83 ec 04             	sub    $0x4,%esp
  803729:	68 fd 49 80 00       	push   $0x8049fd
  80372e:	6a 7a                	push   $0x7a
  803730:	68 63 49 80 00       	push   $0x804963
  803735:	e8 ac 07 00 00       	call   803ee6 <_panic>
  80373a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80373d:	8b 00                	mov    (%eax),%eax
  80373f:	85 c0                	test   %eax,%eax
  803741:	74 10                	je     803753 <alloc_block+0x1c7>
  803743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803746:	8b 00                	mov    (%eax),%eax
  803748:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80374b:	8b 52 04             	mov    0x4(%edx),%edx
  80374e:	89 50 04             	mov    %edx,0x4(%eax)
  803751:	eb 0b                	jmp    80375e <alloc_block+0x1d2>
  803753:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803756:	8b 40 04             	mov    0x4(%eax),%eax
  803759:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80375e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803761:	8b 40 04             	mov    0x4(%eax),%eax
  803764:	85 c0                	test   %eax,%eax
  803766:	74 0f                	je     803777 <alloc_block+0x1eb>
  803768:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376b:	8b 40 04             	mov    0x4(%eax),%eax
  80376e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803771:	8b 12                	mov    (%edx),%edx
  803773:	89 10                	mov    %edx,(%eax)
  803775:	eb 0a                	jmp    803781 <alloc_block+0x1f5>
  803777:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80377a:	8b 00                	mov    (%eax),%eax
  80377c:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803781:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803784:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803794:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803799:	48                   	dec    %eax
  80379a:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  80379f:	83 ec 0c             	sub    $0xc,%esp
  8037a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8037a5:	e8 6f fa ff ff       	call   803219 <to_page_va>
  8037aa:	83 c4 10             	add    $0x10,%esp
  8037ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8037b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037b3:	83 ec 0c             	sub    $0xc,%esp
  8037b6:	50                   	push   %eax
  8037b7:	e8 a0 dc ff ff       	call   80145c <get_page>
  8037bc:	83 c4 10             	add    $0x10,%esp
  8037bf:	85 c0                	test   %eax,%eax
  8037c1:	74 14                	je     8037d7 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8037c3:	83 ec 04             	sub    $0x4,%esp
  8037c6:	68 44 4a 80 00       	push   $0x804a44
  8037cb:	6a 7f                	push   $0x7f
  8037cd:	68 63 49 80 00       	push   $0x804963
  8037d2:	e8 0f 07 00 00       	call   803ee6 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  8037d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037dd:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  8037e1:	b8 00 10 00 00       	mov    $0x1000,%eax
  8037e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8037eb:	f7 75 f4             	divl   -0xc(%ebp)
  8037ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037f1:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8037f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8037fc:	e9 a7 00 00 00       	jmp    8038a8 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803801:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803804:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803807:	01 d0                	add    %edx,%eax
  803809:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  80380c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803810:	75 17                	jne    803829 <alloc_block+0x29d>
  803812:	83 ec 04             	sub    $0x4,%esp
  803815:	68 6c 4a 80 00       	push   $0x804a6c
  80381a:	68 88 00 00 00       	push   $0x88
  80381f:	68 63 49 80 00       	push   $0x804963
  803824:	e8 bd 06 00 00       	call   803ee6 <_panic>
  803829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382c:	c1 e0 04             	shl    $0x4,%eax
  80382f:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803834:	8b 10                	mov    (%eax),%edx
  803836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803839:	89 10                	mov    %edx,(%eax)
  80383b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383e:	8b 00                	mov    (%eax),%eax
  803840:	85 c0                	test   %eax,%eax
  803842:	74 15                	je     803859 <alloc_block+0x2cd>
  803844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803847:	c1 e0 04             	shl    $0x4,%eax
  80384a:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80384f:	8b 00                	mov    (%eax),%eax
  803851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803854:	89 50 04             	mov    %edx,0x4(%eax)
  803857:	eb 11                	jmp    80386a <alloc_block+0x2de>
  803859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385c:	c1 e0 04             	shl    $0x4,%eax
  80385f:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803865:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803868:	89 02                	mov    %eax,(%edx)
  80386a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386d:	c1 e0 04             	shl    $0x4,%eax
  803870:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803876:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803879:	89 02                	mov    %eax,(%edx)
  80387b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80387e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803888:	c1 e0 04             	shl    $0x4,%eax
  80388b:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803890:	8b 00                	mov    (%eax),%eax
  803892:	8d 50 01             	lea    0x1(%eax),%edx
  803895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803898:	c1 e0 04             	shl    $0x4,%eax
  80389b:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038a0:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8038a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a5:	01 45 e8             	add    %eax,-0x18(%ebp)
  8038a8:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8038af:	0f 86 4c ff ff ff    	jbe    803801 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  8038b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b8:	c1 e0 04             	shl    $0x4,%eax
  8038bb:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038c0:	8b 00                	mov    (%eax),%eax
  8038c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  8038c5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8038c9:	75 17                	jne    8038e2 <alloc_block+0x356>
  8038cb:	83 ec 04             	sub    $0x4,%esp
  8038ce:	68 fd 49 80 00       	push   $0x8049fd
  8038d3:	68 8d 00 00 00       	push   $0x8d
  8038d8:	68 63 49 80 00       	push   $0x804963
  8038dd:	e8 04 06 00 00       	call   803ee6 <_panic>
  8038e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038e5:	8b 00                	mov    (%eax),%eax
  8038e7:	85 c0                	test   %eax,%eax
  8038e9:	74 10                	je     8038fb <alloc_block+0x36f>
  8038eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038ee:	8b 00                	mov    (%eax),%eax
  8038f0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8038f3:	8b 52 04             	mov    0x4(%edx),%edx
  8038f6:	89 50 04             	mov    %edx,0x4(%eax)
  8038f9:	eb 14                	jmp    80390f <alloc_block+0x383>
  8038fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038fe:	8b 40 04             	mov    0x4(%eax),%eax
  803901:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803904:	c1 e2 04             	shl    $0x4,%edx
  803907:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  80390d:	89 02                	mov    %eax,(%edx)
  80390f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803912:	8b 40 04             	mov    0x4(%eax),%eax
  803915:	85 c0                	test   %eax,%eax
  803917:	74 0f                	je     803928 <alloc_block+0x39c>
  803919:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80391c:	8b 40 04             	mov    0x4(%eax),%eax
  80391f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803922:	8b 12                	mov    (%edx),%edx
  803924:	89 10                	mov    %edx,(%eax)
  803926:	eb 13                	jmp    80393b <alloc_block+0x3af>
  803928:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80392b:	8b 00                	mov    (%eax),%eax
  80392d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803930:	c1 e2 04             	shl    $0x4,%edx
  803933:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803939:	89 02                	mov    %eax,(%edx)
  80393b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80393e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803944:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803947:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80394e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803951:	c1 e0 04             	shl    $0x4,%eax
  803954:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803959:	8b 00                	mov    (%eax),%eax
  80395b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80395e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803961:	c1 e0 04             	shl    $0x4,%eax
  803964:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803969:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  80396b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803972:	48                   	dec    %eax
  803973:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803976:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  80397a:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  80397d:	c9                   	leave  
  80397e:	c3                   	ret    

0080397f <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80397f:	55                   	push   %ebp
  803980:	89 e5                	mov    %esp,%ebp
  803982:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803985:	8b 55 08             	mov    0x8(%ebp),%edx
  803988:	a1 84 50 83 00       	mov    0x835084,%eax
  80398d:	39 c2                	cmp    %eax,%edx
  80398f:	72 0c                	jb     80399d <free_block+0x1e>
  803991:	8b 55 08             	mov    0x8(%ebp),%edx
  803994:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803999:	39 c2                	cmp    %eax,%edx
  80399b:	72 19                	jb     8039b6 <free_block+0x37>
  80399d:	68 90 4a 80 00       	push   $0x804a90
  8039a2:	68 c6 49 80 00       	push   $0x8049c6
  8039a7:	68 98 00 00 00       	push   $0x98
  8039ac:	68 63 49 80 00       	push   $0x804963
  8039b1:	e8 30 05 00 00       	call   803ee6 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8039b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b9:	83 ec 0c             	sub    $0xc,%esp
  8039bc:	50                   	push   %eax
  8039bd:	e8 c9 f8 ff ff       	call   80328b <to_page_info>
  8039c2:	83 c4 10             	add    $0x10,%esp
  8039c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  8039c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039cb:	8b 40 08             	mov    0x8(%eax),%eax
  8039ce:	0f b7 c0             	movzwl %ax,%eax
  8039d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  8039d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8039db:	eb 03                	jmp    8039e0 <free_block+0x61>
		listIndex++;
  8039dd:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8039e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e3:	ba 08 00 00 00       	mov    $0x8,%edx
  8039e8:	88 c1                	mov    %al,%cl
  8039ea:	d3 e2                	shl    %cl,%edx
  8039ec:	89 d0                	mov    %edx,%eax
  8039ee:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039f1:	72 ea                	jb     8039dd <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  8039f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  8039f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039fd:	75 17                	jne    803a16 <free_block+0x97>
  8039ff:	83 ec 04             	sub    $0x4,%esp
  803a02:	68 6c 4a 80 00       	push   $0x804a6c
  803a07:	68 a2 00 00 00       	push   $0xa2
  803a0c:	68 63 49 80 00       	push   $0x804963
  803a11:	e8 d0 04 00 00       	call   803ee6 <_panic>
  803a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a19:	c1 e0 04             	shl    $0x4,%eax
  803a1c:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a21:	8b 10                	mov    (%eax),%edx
  803a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a26:	89 10                	mov    %edx,(%eax)
  803a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2b:	8b 00                	mov    (%eax),%eax
  803a2d:	85 c0                	test   %eax,%eax
  803a2f:	74 15                	je     803a46 <free_block+0xc7>
  803a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a34:	c1 e0 04             	shl    $0x4,%eax
  803a37:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a3c:	8b 00                	mov    (%eax),%eax
  803a3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a41:	89 50 04             	mov    %edx,0x4(%eax)
  803a44:	eb 11                	jmp    803a57 <free_block+0xd8>
  803a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a49:	c1 e0 04             	shl    $0x4,%eax
  803a4c:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a55:	89 02                	mov    %eax,(%edx)
  803a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5a:	c1 e0 04             	shl    $0x4,%eax
  803a5d:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803a63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a66:	89 02                	mov    %eax,(%edx)
  803a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a75:	c1 e0 04             	shl    $0x4,%eax
  803a78:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a7d:	8b 00                	mov    (%eax),%eax
  803a7f:	8d 50 01             	lea    0x1(%eax),%edx
  803a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a85:	c1 e0 04             	shl    $0x4,%eax
  803a88:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a8d:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a92:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a96:	40                   	inc    %eax
  803a97:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a9a:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aa1:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803aa5:	0f b7 c8             	movzwl %ax,%ecx
  803aa8:	b8 00 10 00 00       	mov    $0x1000,%eax
  803aad:	ba 00 00 00 00       	mov    $0x0,%edx
  803ab2:	f7 75 e8             	divl   -0x18(%ebp)
  803ab5:	39 c1                	cmp    %eax,%ecx
  803ab7:	0f 85 ed 01 00 00    	jne    803caa <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac0:	c1 e0 04             	shl    $0x4,%eax
  803ac3:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ac8:	8b 00                	mov    (%eax),%eax
  803aca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803acd:	eb 2a                	jmp    803af9 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad2:	83 ec 0c             	sub    $0xc,%esp
  803ad5:	50                   	push   %eax
  803ad6:	e8 b0 f7 ff ff       	call   80328b <to_page_info>
  803adb:	83 c4 10             	add    $0x10,%esp
  803ade:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803ae1:	75 06                	jne    803ae9 <free_block+0x16a>
				tmp = b;
  803ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aec:	c1 e0 04             	shl    $0x4,%eax
  803aef:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803af4:	8b 00                	mov    (%eax),%eax
  803af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803af9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803afd:	74 07                	je     803b06 <free_block+0x187>
  803aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b02:	8b 00                	mov    (%eax),%eax
  803b04:	eb 05                	jmp    803b0b <free_block+0x18c>
  803b06:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b0e:	c1 e2 04             	shl    $0x4,%edx
  803b11:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803b17:	89 02                	mov    %eax,(%edx)
  803b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1c:	c1 e0 04             	shl    $0x4,%eax
  803b1f:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803b24:	8b 00                	mov    (%eax),%eax
  803b26:	85 c0                	test   %eax,%eax
  803b28:	75 a5                	jne    803acf <free_block+0x150>
  803b2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b2e:	75 9f                	jne    803acf <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b33:	c1 e0 04             	shl    $0x4,%eax
  803b36:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b3b:	8b 00                	mov    (%eax),%eax
  803b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803b40:	e9 cc 00 00 00       	jmp    803c11 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b48:	8b 00                	mov    (%eax),%eax
  803b4a:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b50:	83 ec 0c             	sub    $0xc,%esp
  803b53:	50                   	push   %eax
  803b54:	e8 32 f7 ff ff       	call   80328b <to_page_info>
  803b59:	83 c4 10             	add    $0x10,%esp
  803b5c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803b5f:	0f 85 a6 00 00 00    	jne    803c0b <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b69:	75 17                	jne    803b82 <free_block+0x203>
  803b6b:	83 ec 04             	sub    $0x4,%esp
  803b6e:	68 fd 49 80 00       	push   $0x8049fd
  803b73:	68 b5 00 00 00       	push   $0xb5
  803b78:	68 63 49 80 00       	push   $0x804963
  803b7d:	e8 64 03 00 00       	call   803ee6 <_panic>
  803b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b85:	8b 00                	mov    (%eax),%eax
  803b87:	85 c0                	test   %eax,%eax
  803b89:	74 10                	je     803b9b <free_block+0x21c>
  803b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b8e:	8b 00                	mov    (%eax),%eax
  803b90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b93:	8b 52 04             	mov    0x4(%edx),%edx
  803b96:	89 50 04             	mov    %edx,0x4(%eax)
  803b99:	eb 14                	jmp    803baf <free_block+0x230>
  803b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ba1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ba4:	c1 e2 04             	shl    $0x4,%edx
  803ba7:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803bad:	89 02                	mov    %eax,(%edx)
  803baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bb2:	8b 40 04             	mov    0x4(%eax),%eax
  803bb5:	85 c0                	test   %eax,%eax
  803bb7:	74 0f                	je     803bc8 <free_block+0x249>
  803bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bbc:	8b 40 04             	mov    0x4(%eax),%eax
  803bbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bc2:	8b 12                	mov    (%edx),%edx
  803bc4:	89 10                	mov    %edx,(%eax)
  803bc6:	eb 13                	jmp    803bdb <free_block+0x25c>
  803bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bcb:	8b 00                	mov    (%eax),%eax
  803bcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bd0:	c1 e2 04             	shl    $0x4,%edx
  803bd3:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803bd9:	89 02                	mov    %eax,(%edx)
  803bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803be7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf1:	c1 e0 04             	shl    $0x4,%eax
  803bf4:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803bf9:	8b 00                	mov    (%eax),%eax
  803bfb:	8d 50 ff             	lea    -0x1(%eax),%edx
  803bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c01:	c1 e0 04             	shl    $0x4,%eax
  803c04:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c09:	89 10                	mov    %edx,(%eax)
			b = next;
  803c0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803c11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c15:	0f 85 2a ff ff ff    	jne    803b45 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c1e:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c27:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803c2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c31:	75 17                	jne    803c4a <free_block+0x2cb>
  803c33:	83 ec 04             	sub    $0x4,%esp
  803c36:	68 6c 4a 80 00       	push   $0x804a6c
  803c3b:	68 bc 00 00 00       	push   $0xbc
  803c40:	68 63 49 80 00       	push   $0x804963
  803c45:	e8 9c 02 00 00       	call   803ee6 <_panic>
  803c4a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c53:	89 10                	mov    %edx,(%eax)
  803c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c58:	8b 00                	mov    (%eax),%eax
  803c5a:	85 c0                	test   %eax,%eax
  803c5c:	74 0d                	je     803c6b <free_block+0x2ec>
  803c5e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803c63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c66:	89 50 04             	mov    %edx,0x4(%eax)
  803c69:	eb 08                	jmp    803c73 <free_block+0x2f4>
  803c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c6e:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803c73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c76:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c85:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803c8a:	40                   	inc    %eax
  803c8b:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803c90:	83 ec 0c             	sub    $0xc,%esp
  803c93:	ff 75 ec             	pushl  -0x14(%ebp)
  803c96:	e8 7e f5 ff ff       	call   803219 <to_page_va>
  803c9b:	83 c4 10             	add    $0x10,%esp
  803c9e:	83 ec 0c             	sub    $0xc,%esp
  803ca1:	50                   	push   %eax
  803ca2:	e8 fe d7 ff ff       	call   8014a5 <return_page>
  803ca7:	83 c4 10             	add    $0x10,%esp
	}
}
  803caa:	90                   	nop
  803cab:	c9                   	leave  
  803cac:	c3                   	ret    

00803cad <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803cad:	55                   	push   %ebp
  803cae:	89 e5                	mov    %esp,%ebp
  803cb0:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803cb3:	83 ec 04             	sub    $0x4,%esp
  803cb6:	68 c8 4a 80 00       	push   $0x804ac8
  803cbb:	6a 07                	push   $0x7
  803cbd:	68 f7 4a 80 00       	push   $0x804af7
  803cc2:	e8 1f 02 00 00       	call   803ee6 <_panic>

00803cc7 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803cc7:	55                   	push   %ebp
  803cc8:	89 e5                	mov    %esp,%ebp
  803cca:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803ccd:	83 ec 04             	sub    $0x4,%esp
  803cd0:	68 08 4b 80 00       	push   $0x804b08
  803cd5:	6a 0b                	push   $0xb
  803cd7:	68 f7 4a 80 00       	push   $0x804af7
  803cdc:	e8 05 02 00 00       	call   803ee6 <_panic>

00803ce1 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803ce1:	55                   	push   %ebp
  803ce2:	89 e5                	mov    %esp,%ebp
  803ce4:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803ce7:	83 ec 04             	sub    $0x4,%esp
  803cea:	68 34 4b 80 00       	push   $0x804b34
  803cef:	6a 10                	push   $0x10
  803cf1:	68 f7 4a 80 00       	push   $0x804af7
  803cf6:	e8 eb 01 00 00       	call   803ee6 <_panic>

00803cfb <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803cfb:	55                   	push   %ebp
  803cfc:	89 e5                	mov    %esp,%ebp
  803cfe:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803d01:	83 ec 04             	sub    $0x4,%esp
  803d04:	68 64 4b 80 00       	push   $0x804b64
  803d09:	6a 15                	push   $0x15
  803d0b:	68 f7 4a 80 00       	push   $0x804af7
  803d10:	e8 d1 01 00 00       	call   803ee6 <_panic>

00803d15 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803d15:	55                   	push   %ebp
  803d16:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803d18:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1b:	8b 40 10             	mov    0x10(%eax),%eax
}
  803d1e:	5d                   	pop    %ebp
  803d1f:	c3                   	ret    

00803d20 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803d20:	55                   	push   %ebp
  803d21:	89 e5                	mov    %esp,%ebp
  803d23:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803d26:	8b 55 08             	mov    0x8(%ebp),%edx
  803d29:	89 d0                	mov    %edx,%eax
  803d2b:	c1 e0 02             	shl    $0x2,%eax
  803d2e:	01 d0                	add    %edx,%eax
  803d30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d37:	01 d0                	add    %edx,%eax
  803d39:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d40:	01 d0                	add    %edx,%eax
  803d42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d49:	01 d0                	add    %edx,%eax
  803d4b:	c1 e0 04             	shl    $0x4,%eax
  803d4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803d51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803d58:	0f 31                	rdtsc  
  803d5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803d5d:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803d60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d69:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803d6c:	eb 46                	jmp    803db4 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803d6e:	0f 31                	rdtsc  
  803d70:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803d73:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803d76:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d79:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  803d7f:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803d82:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d88:	29 c2                	sub    %eax,%edx
  803d8a:	89 d0                	mov    %edx,%eax
  803d8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803d8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d95:	89 d1                	mov    %edx,%ecx
  803d97:	29 c1                	sub    %eax,%ecx
  803d99:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d9f:	39 c2                	cmp    %eax,%edx
  803da1:	0f 97 c0             	seta   %al
  803da4:	0f b6 c0             	movzbl %al,%eax
  803da7:	29 c1                	sub    %eax,%ecx
  803da9:	89 c8                	mov    %ecx,%eax
  803dab:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803dae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803db1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803db4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803db7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803dba:	72 b2                	jb     803d6e <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803dbc:	90                   	nop
  803dbd:	c9                   	leave  
  803dbe:	c3                   	ret    

00803dbf <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803dbf:	55                   	push   %ebp
  803dc0:	89 e5                	mov    %esp,%ebp
  803dc2:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803dc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803dcc:	eb 03                	jmp    803dd1 <busy_wait+0x12>
  803dce:	ff 45 fc             	incl   -0x4(%ebp)
  803dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803dd4:	3b 45 08             	cmp    0x8(%ebp),%eax
  803dd7:	72 f5                	jb     803dce <busy_wait+0xf>
	return i;
  803dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803ddc:	c9                   	leave  
  803ddd:	c3                   	ret    

00803dde <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803dde:	55                   	push   %ebp
  803ddf:	89 e5                	mov    %esp,%ebp
  803de1:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803de4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803de8:	74 1c                	je     803e06 <init_uspinlock+0x28>
  803dea:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803dee:	74 16                	je     803e06 <init_uspinlock+0x28>
  803df0:	68 94 4b 80 00       	push   $0x804b94
  803df5:	68 b3 4b 80 00       	push   $0x804bb3
  803dfa:	6a 10                	push   $0x10
  803dfc:	68 c8 4b 80 00       	push   $0x804bc8
  803e01:	e8 e0 00 00 00       	call   803ee6 <_panic>
	strcpy(lk->name, name);
  803e06:	8b 45 08             	mov    0x8(%ebp),%eax
  803e09:	83 c0 04             	add    $0x4,%eax
  803e0c:	83 ec 08             	sub    $0x8,%esp
  803e0f:	ff 75 0c             	pushl  0xc(%ebp)
  803e12:	50                   	push   %eax
  803e13:	e8 33 ce ff ff       	call   800c4b <strcpy>
  803e18:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  803e1b:	b8 01 00 00 00       	mov    $0x1,%eax
  803e20:	2b 45 10             	sub    0x10(%ebp),%eax
  803e23:	89 c2                	mov    %eax,%edx
  803e25:	8b 45 08             	mov    0x8(%ebp),%eax
  803e28:	89 10                	mov    %edx,(%eax)
}
  803e2a:	90                   	nop
  803e2b:	c9                   	leave  
  803e2c:	c3                   	ret    

00803e2d <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  803e2d:	55                   	push   %ebp
  803e2e:	89 e5                	mov    %esp,%ebp
  803e30:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803e33:	90                   	nop
  803e34:	8b 45 08             	mov    0x8(%ebp),%eax
  803e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e3a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803e41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e47:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803e4a:	f0 87 02             	lock xchg %eax,(%edx)
  803e4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  803e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e53:	85 c0                	test   %eax,%eax
  803e55:	75 dd                	jne    803e34 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803e57:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5a:	8d 48 04             	lea    0x4(%eax),%ecx
  803e5d:	a1 20 50 80 00       	mov    0x805020,%eax
  803e62:	8d 50 20             	lea    0x20(%eax),%edx
  803e65:	a1 20 50 80 00       	mov    0x805020,%eax
  803e6a:	8b 40 10             	mov    0x10(%eax),%eax
  803e6d:	51                   	push   %ecx
  803e6e:	52                   	push   %edx
  803e6f:	50                   	push   %eax
  803e70:	68 d8 4b 80 00       	push   $0x804bd8
  803e75:	e8 a9 c6 ff ff       	call   800523 <cprintf>
  803e7a:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  803e7d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  803e82:	90                   	nop
  803e83:	c9                   	leave  
  803e84:	c3                   	ret    

00803e85 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  803e85:	55                   	push   %ebp
  803e86:	89 e5                	mov    %esp,%ebp
  803e88:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  803e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e8e:	8b 00                	mov    (%eax),%eax
  803e90:	85 c0                	test   %eax,%eax
  803e92:	75 18                	jne    803eac <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  803e94:	8b 45 08             	mov    0x8(%ebp),%eax
  803e97:	83 c0 04             	add    $0x4,%eax
  803e9a:	50                   	push   %eax
  803e9b:	68 fc 4b 80 00       	push   $0x804bfc
  803ea0:	6a 2b                	push   $0x2b
  803ea2:	68 c8 4b 80 00       	push   $0x804bc8
  803ea7:	e8 3a 00 00 00       	call   803ee6 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  803eac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  803eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  803eb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec0:	8d 48 04             	lea    0x4(%eax),%ecx
  803ec3:	a1 20 50 80 00       	mov    0x805020,%eax
  803ec8:	8d 50 20             	lea    0x20(%eax),%edx
  803ecb:	a1 20 50 80 00       	mov    0x805020,%eax
  803ed0:	8b 40 10             	mov    0x10(%eax),%eax
  803ed3:	51                   	push   %ecx
  803ed4:	52                   	push   %edx
  803ed5:	50                   	push   %eax
  803ed6:	68 1c 4c 80 00       	push   $0x804c1c
  803edb:	e8 43 c6 ff ff       	call   800523 <cprintf>
  803ee0:	83 c4 10             	add    $0x10,%esp
}
  803ee3:	90                   	nop
  803ee4:	c9                   	leave  
  803ee5:	c3                   	ret    

00803ee6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803ee6:	55                   	push   %ebp
  803ee7:	89 e5                	mov    %esp,%ebp
  803ee9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803eec:	8d 45 10             	lea    0x10(%ebp),%eax
  803eef:	83 c0 04             	add    $0x4,%eax
  803ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803ef5:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803efa:	85 c0                	test   %eax,%eax
  803efc:	74 16                	je     803f14 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803efe:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803f03:	83 ec 08             	sub    $0x8,%esp
  803f06:	50                   	push   %eax
  803f07:	68 40 4c 80 00       	push   $0x804c40
  803f0c:	e8 12 c6 ff ff       	call   800523 <cprintf>
  803f11:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803f14:	a1 04 50 80 00       	mov    0x805004,%eax
  803f19:	83 ec 0c             	sub    $0xc,%esp
  803f1c:	ff 75 0c             	pushl  0xc(%ebp)
  803f1f:	ff 75 08             	pushl  0x8(%ebp)
  803f22:	50                   	push   %eax
  803f23:	68 48 4c 80 00       	push   $0x804c48
  803f28:	6a 74                	push   $0x74
  803f2a:	e8 21 c6 ff ff       	call   800550 <cprintf_colored>
  803f2f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803f32:	8b 45 10             	mov    0x10(%ebp),%eax
  803f35:	83 ec 08             	sub    $0x8,%esp
  803f38:	ff 75 f4             	pushl  -0xc(%ebp)
  803f3b:	50                   	push   %eax
  803f3c:	e8 73 c5 ff ff       	call   8004b4 <vcprintf>
  803f41:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803f44:	83 ec 08             	sub    $0x8,%esp
  803f47:	6a 00                	push   $0x0
  803f49:	68 70 4c 80 00       	push   $0x804c70
  803f4e:	e8 61 c5 ff ff       	call   8004b4 <vcprintf>
  803f53:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803f56:	e8 da c4 ff ff       	call   800435 <exit>

	// should not return here
	while (1) ;
  803f5b:	eb fe                	jmp    803f5b <_panic+0x75>

00803f5d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803f5d:	55                   	push   %ebp
  803f5e:	89 e5                	mov    %esp,%ebp
  803f60:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803f63:	a1 20 50 80 00       	mov    0x805020,%eax
  803f68:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f71:	39 c2                	cmp    %eax,%edx
  803f73:	74 14                	je     803f89 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803f75:	83 ec 04             	sub    $0x4,%esp
  803f78:	68 74 4c 80 00       	push   $0x804c74
  803f7d:	6a 26                	push   $0x26
  803f7f:	68 c0 4c 80 00       	push   $0x804cc0
  803f84:	e8 5d ff ff ff       	call   803ee6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803f89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803f90:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803f97:	e9 c5 00 00 00       	jmp    804061 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa9:	01 d0                	add    %edx,%eax
  803fab:	8b 00                	mov    (%eax),%eax
  803fad:	85 c0                	test   %eax,%eax
  803faf:	75 08                	jne    803fb9 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803fb1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803fb4:	e9 a5 00 00 00       	jmp    80405e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803fb9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803fc0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803fc7:	eb 69                	jmp    804032 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803fc9:	a1 20 50 80 00       	mov    0x805020,%eax
  803fce:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803fd4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fd7:	89 d0                	mov    %edx,%eax
  803fd9:	01 c0                	add    %eax,%eax
  803fdb:	01 d0                	add    %edx,%eax
  803fdd:	c1 e0 03             	shl    $0x3,%eax
  803fe0:	01 c8                	add    %ecx,%eax
  803fe2:	8a 40 04             	mov    0x4(%eax),%al
  803fe5:	84 c0                	test   %al,%al
  803fe7:	75 46                	jne    80402f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803fe9:	a1 20 50 80 00       	mov    0x805020,%eax
  803fee:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803ff4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ff7:	89 d0                	mov    %edx,%eax
  803ff9:	01 c0                	add    %eax,%eax
  803ffb:	01 d0                	add    %edx,%eax
  803ffd:	c1 e0 03             	shl    $0x3,%eax
  804000:	01 c8                	add    %ecx,%eax
  804002:	8b 00                	mov    (%eax),%eax
  804004:	89 45 dc             	mov    %eax,-0x24(%ebp)
  804007:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80400a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80400f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  804011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804014:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80401b:	8b 45 08             	mov    0x8(%ebp),%eax
  80401e:	01 c8                	add    %ecx,%eax
  804020:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804022:	39 c2                	cmp    %eax,%edx
  804024:	75 09                	jne    80402f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804026:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80402d:	eb 15                	jmp    804044 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80402f:	ff 45 e8             	incl   -0x18(%ebp)
  804032:	a1 20 50 80 00       	mov    0x805020,%eax
  804037:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80403d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804040:	39 c2                	cmp    %eax,%edx
  804042:	77 85                	ja     803fc9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  804044:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804048:	75 14                	jne    80405e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80404a:	83 ec 04             	sub    $0x4,%esp
  80404d:	68 cc 4c 80 00       	push   $0x804ccc
  804052:	6a 3a                	push   $0x3a
  804054:	68 c0 4c 80 00       	push   $0x804cc0
  804059:	e8 88 fe ff ff       	call   803ee6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80405e:	ff 45 f0             	incl   -0x10(%ebp)
  804061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804064:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804067:	0f 8c 2f ff ff ff    	jl     803f9c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80406d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804074:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80407b:	eb 26                	jmp    8040a3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80407d:	a1 20 50 80 00       	mov    0x805020,%eax
  804082:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  804088:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80408b:	89 d0                	mov    %edx,%eax
  80408d:	01 c0                	add    %eax,%eax
  80408f:	01 d0                	add    %edx,%eax
  804091:	c1 e0 03             	shl    $0x3,%eax
  804094:	01 c8                	add    %ecx,%eax
  804096:	8a 40 04             	mov    0x4(%eax),%al
  804099:	3c 01                	cmp    $0x1,%al
  80409b:	75 03                	jne    8040a0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80409d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8040a0:	ff 45 e0             	incl   -0x20(%ebp)
  8040a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8040a8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8040ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040b1:	39 c2                	cmp    %eax,%edx
  8040b3:	77 c8                	ja     80407d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8040b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8040bb:	74 14                	je     8040d1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8040bd:	83 ec 04             	sub    $0x4,%esp
  8040c0:	68 20 4d 80 00       	push   $0x804d20
  8040c5:	6a 44                	push   $0x44
  8040c7:	68 c0 4c 80 00       	push   $0x804cc0
  8040cc:	e8 15 fe ff ff       	call   803ee6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8040d1:	90                   	nop
  8040d2:	c9                   	leave  
  8040d3:	c3                   	ret    

008040d4 <__udivdi3>:
  8040d4:	55                   	push   %ebp
  8040d5:	57                   	push   %edi
  8040d6:	56                   	push   %esi
  8040d7:	53                   	push   %ebx
  8040d8:	83 ec 1c             	sub    $0x1c,%esp
  8040db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040eb:	89 ca                	mov    %ecx,%edx
  8040ed:	89 f8                	mov    %edi,%eax
  8040ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040f3:	85 f6                	test   %esi,%esi
  8040f5:	75 2d                	jne    804124 <__udivdi3+0x50>
  8040f7:	39 cf                	cmp    %ecx,%edi
  8040f9:	77 65                	ja     804160 <__udivdi3+0x8c>
  8040fb:	89 fd                	mov    %edi,%ebp
  8040fd:	85 ff                	test   %edi,%edi
  8040ff:	75 0b                	jne    80410c <__udivdi3+0x38>
  804101:	b8 01 00 00 00       	mov    $0x1,%eax
  804106:	31 d2                	xor    %edx,%edx
  804108:	f7 f7                	div    %edi
  80410a:	89 c5                	mov    %eax,%ebp
  80410c:	31 d2                	xor    %edx,%edx
  80410e:	89 c8                	mov    %ecx,%eax
  804110:	f7 f5                	div    %ebp
  804112:	89 c1                	mov    %eax,%ecx
  804114:	89 d8                	mov    %ebx,%eax
  804116:	f7 f5                	div    %ebp
  804118:	89 cf                	mov    %ecx,%edi
  80411a:	89 fa                	mov    %edi,%edx
  80411c:	83 c4 1c             	add    $0x1c,%esp
  80411f:	5b                   	pop    %ebx
  804120:	5e                   	pop    %esi
  804121:	5f                   	pop    %edi
  804122:	5d                   	pop    %ebp
  804123:	c3                   	ret    
  804124:	39 ce                	cmp    %ecx,%esi
  804126:	77 28                	ja     804150 <__udivdi3+0x7c>
  804128:	0f bd fe             	bsr    %esi,%edi
  80412b:	83 f7 1f             	xor    $0x1f,%edi
  80412e:	75 40                	jne    804170 <__udivdi3+0x9c>
  804130:	39 ce                	cmp    %ecx,%esi
  804132:	72 0a                	jb     80413e <__udivdi3+0x6a>
  804134:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804138:	0f 87 9e 00 00 00    	ja     8041dc <__udivdi3+0x108>
  80413e:	b8 01 00 00 00       	mov    $0x1,%eax
  804143:	89 fa                	mov    %edi,%edx
  804145:	83 c4 1c             	add    $0x1c,%esp
  804148:	5b                   	pop    %ebx
  804149:	5e                   	pop    %esi
  80414a:	5f                   	pop    %edi
  80414b:	5d                   	pop    %ebp
  80414c:	c3                   	ret    
  80414d:	8d 76 00             	lea    0x0(%esi),%esi
  804150:	31 ff                	xor    %edi,%edi
  804152:	31 c0                	xor    %eax,%eax
  804154:	89 fa                	mov    %edi,%edx
  804156:	83 c4 1c             	add    $0x1c,%esp
  804159:	5b                   	pop    %ebx
  80415a:	5e                   	pop    %esi
  80415b:	5f                   	pop    %edi
  80415c:	5d                   	pop    %ebp
  80415d:	c3                   	ret    
  80415e:	66 90                	xchg   %ax,%ax
  804160:	89 d8                	mov    %ebx,%eax
  804162:	f7 f7                	div    %edi
  804164:	31 ff                	xor    %edi,%edi
  804166:	89 fa                	mov    %edi,%edx
  804168:	83 c4 1c             	add    $0x1c,%esp
  80416b:	5b                   	pop    %ebx
  80416c:	5e                   	pop    %esi
  80416d:	5f                   	pop    %edi
  80416e:	5d                   	pop    %ebp
  80416f:	c3                   	ret    
  804170:	bd 20 00 00 00       	mov    $0x20,%ebp
  804175:	89 eb                	mov    %ebp,%ebx
  804177:	29 fb                	sub    %edi,%ebx
  804179:	89 f9                	mov    %edi,%ecx
  80417b:	d3 e6                	shl    %cl,%esi
  80417d:	89 c5                	mov    %eax,%ebp
  80417f:	88 d9                	mov    %bl,%cl
  804181:	d3 ed                	shr    %cl,%ebp
  804183:	89 e9                	mov    %ebp,%ecx
  804185:	09 f1                	or     %esi,%ecx
  804187:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80418b:	89 f9                	mov    %edi,%ecx
  80418d:	d3 e0                	shl    %cl,%eax
  80418f:	89 c5                	mov    %eax,%ebp
  804191:	89 d6                	mov    %edx,%esi
  804193:	88 d9                	mov    %bl,%cl
  804195:	d3 ee                	shr    %cl,%esi
  804197:	89 f9                	mov    %edi,%ecx
  804199:	d3 e2                	shl    %cl,%edx
  80419b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80419f:	88 d9                	mov    %bl,%cl
  8041a1:	d3 e8                	shr    %cl,%eax
  8041a3:	09 c2                	or     %eax,%edx
  8041a5:	89 d0                	mov    %edx,%eax
  8041a7:	89 f2                	mov    %esi,%edx
  8041a9:	f7 74 24 0c          	divl   0xc(%esp)
  8041ad:	89 d6                	mov    %edx,%esi
  8041af:	89 c3                	mov    %eax,%ebx
  8041b1:	f7 e5                	mul    %ebp
  8041b3:	39 d6                	cmp    %edx,%esi
  8041b5:	72 19                	jb     8041d0 <__udivdi3+0xfc>
  8041b7:	74 0b                	je     8041c4 <__udivdi3+0xf0>
  8041b9:	89 d8                	mov    %ebx,%eax
  8041bb:	31 ff                	xor    %edi,%edi
  8041bd:	e9 58 ff ff ff       	jmp    80411a <__udivdi3+0x46>
  8041c2:	66 90                	xchg   %ax,%ax
  8041c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041c8:	89 f9                	mov    %edi,%ecx
  8041ca:	d3 e2                	shl    %cl,%edx
  8041cc:	39 c2                	cmp    %eax,%edx
  8041ce:	73 e9                	jae    8041b9 <__udivdi3+0xe5>
  8041d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041d3:	31 ff                	xor    %edi,%edi
  8041d5:	e9 40 ff ff ff       	jmp    80411a <__udivdi3+0x46>
  8041da:	66 90                	xchg   %ax,%ax
  8041dc:	31 c0                	xor    %eax,%eax
  8041de:	e9 37 ff ff ff       	jmp    80411a <__udivdi3+0x46>
  8041e3:	90                   	nop

008041e4 <__umoddi3>:
  8041e4:	55                   	push   %ebp
  8041e5:	57                   	push   %edi
  8041e6:	56                   	push   %esi
  8041e7:	53                   	push   %ebx
  8041e8:	83 ec 1c             	sub    $0x1c,%esp
  8041eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804203:	89 f3                	mov    %esi,%ebx
  804205:	89 fa                	mov    %edi,%edx
  804207:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80420b:	89 34 24             	mov    %esi,(%esp)
  80420e:	85 c0                	test   %eax,%eax
  804210:	75 1a                	jne    80422c <__umoddi3+0x48>
  804212:	39 f7                	cmp    %esi,%edi
  804214:	0f 86 a2 00 00 00    	jbe    8042bc <__umoddi3+0xd8>
  80421a:	89 c8                	mov    %ecx,%eax
  80421c:	89 f2                	mov    %esi,%edx
  80421e:	f7 f7                	div    %edi
  804220:	89 d0                	mov    %edx,%eax
  804222:	31 d2                	xor    %edx,%edx
  804224:	83 c4 1c             	add    $0x1c,%esp
  804227:	5b                   	pop    %ebx
  804228:	5e                   	pop    %esi
  804229:	5f                   	pop    %edi
  80422a:	5d                   	pop    %ebp
  80422b:	c3                   	ret    
  80422c:	39 f0                	cmp    %esi,%eax
  80422e:	0f 87 ac 00 00 00    	ja     8042e0 <__umoddi3+0xfc>
  804234:	0f bd e8             	bsr    %eax,%ebp
  804237:	83 f5 1f             	xor    $0x1f,%ebp
  80423a:	0f 84 ac 00 00 00    	je     8042ec <__umoddi3+0x108>
  804240:	bf 20 00 00 00       	mov    $0x20,%edi
  804245:	29 ef                	sub    %ebp,%edi
  804247:	89 fe                	mov    %edi,%esi
  804249:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80424d:	89 e9                	mov    %ebp,%ecx
  80424f:	d3 e0                	shl    %cl,%eax
  804251:	89 d7                	mov    %edx,%edi
  804253:	89 f1                	mov    %esi,%ecx
  804255:	d3 ef                	shr    %cl,%edi
  804257:	09 c7                	or     %eax,%edi
  804259:	89 e9                	mov    %ebp,%ecx
  80425b:	d3 e2                	shl    %cl,%edx
  80425d:	89 14 24             	mov    %edx,(%esp)
  804260:	89 d8                	mov    %ebx,%eax
  804262:	d3 e0                	shl    %cl,%eax
  804264:	89 c2                	mov    %eax,%edx
  804266:	8b 44 24 08          	mov    0x8(%esp),%eax
  80426a:	d3 e0                	shl    %cl,%eax
  80426c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804270:	8b 44 24 08          	mov    0x8(%esp),%eax
  804274:	89 f1                	mov    %esi,%ecx
  804276:	d3 e8                	shr    %cl,%eax
  804278:	09 d0                	or     %edx,%eax
  80427a:	d3 eb                	shr    %cl,%ebx
  80427c:	89 da                	mov    %ebx,%edx
  80427e:	f7 f7                	div    %edi
  804280:	89 d3                	mov    %edx,%ebx
  804282:	f7 24 24             	mull   (%esp)
  804285:	89 c6                	mov    %eax,%esi
  804287:	89 d1                	mov    %edx,%ecx
  804289:	39 d3                	cmp    %edx,%ebx
  80428b:	0f 82 87 00 00 00    	jb     804318 <__umoddi3+0x134>
  804291:	0f 84 91 00 00 00    	je     804328 <__umoddi3+0x144>
  804297:	8b 54 24 04          	mov    0x4(%esp),%edx
  80429b:	29 f2                	sub    %esi,%edx
  80429d:	19 cb                	sbb    %ecx,%ebx
  80429f:	89 d8                	mov    %ebx,%eax
  8042a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042a5:	d3 e0                	shl    %cl,%eax
  8042a7:	89 e9                	mov    %ebp,%ecx
  8042a9:	d3 ea                	shr    %cl,%edx
  8042ab:	09 d0                	or     %edx,%eax
  8042ad:	89 e9                	mov    %ebp,%ecx
  8042af:	d3 eb                	shr    %cl,%ebx
  8042b1:	89 da                	mov    %ebx,%edx
  8042b3:	83 c4 1c             	add    $0x1c,%esp
  8042b6:	5b                   	pop    %ebx
  8042b7:	5e                   	pop    %esi
  8042b8:	5f                   	pop    %edi
  8042b9:	5d                   	pop    %ebp
  8042ba:	c3                   	ret    
  8042bb:	90                   	nop
  8042bc:	89 fd                	mov    %edi,%ebp
  8042be:	85 ff                	test   %edi,%edi
  8042c0:	75 0b                	jne    8042cd <__umoddi3+0xe9>
  8042c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8042c7:	31 d2                	xor    %edx,%edx
  8042c9:	f7 f7                	div    %edi
  8042cb:	89 c5                	mov    %eax,%ebp
  8042cd:	89 f0                	mov    %esi,%eax
  8042cf:	31 d2                	xor    %edx,%edx
  8042d1:	f7 f5                	div    %ebp
  8042d3:	89 c8                	mov    %ecx,%eax
  8042d5:	f7 f5                	div    %ebp
  8042d7:	89 d0                	mov    %edx,%eax
  8042d9:	e9 44 ff ff ff       	jmp    804222 <__umoddi3+0x3e>
  8042de:	66 90                	xchg   %ax,%ax
  8042e0:	89 c8                	mov    %ecx,%eax
  8042e2:	89 f2                	mov    %esi,%edx
  8042e4:	83 c4 1c             	add    $0x1c,%esp
  8042e7:	5b                   	pop    %ebx
  8042e8:	5e                   	pop    %esi
  8042e9:	5f                   	pop    %edi
  8042ea:	5d                   	pop    %ebp
  8042eb:	c3                   	ret    
  8042ec:	3b 04 24             	cmp    (%esp),%eax
  8042ef:	72 06                	jb     8042f7 <__umoddi3+0x113>
  8042f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042f5:	77 0f                	ja     804306 <__umoddi3+0x122>
  8042f7:	89 f2                	mov    %esi,%edx
  8042f9:	29 f9                	sub    %edi,%ecx
  8042fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042ff:	89 14 24             	mov    %edx,(%esp)
  804302:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804306:	8b 44 24 04          	mov    0x4(%esp),%eax
  80430a:	8b 14 24             	mov    (%esp),%edx
  80430d:	83 c4 1c             	add    $0x1c,%esp
  804310:	5b                   	pop    %ebx
  804311:	5e                   	pop    %esi
  804312:	5f                   	pop    %edi
  804313:	5d                   	pop    %ebp
  804314:	c3                   	ret    
  804315:	8d 76 00             	lea    0x0(%esi),%esi
  804318:	2b 04 24             	sub    (%esp),%eax
  80431b:	19 fa                	sbb    %edi,%edx
  80431d:	89 d1                	mov    %edx,%ecx
  80431f:	89 c6                	mov    %eax,%esi
  804321:	e9 71 ff ff ff       	jmp    804297 <__umoddi3+0xb3>
  804326:	66 90                	xchg   %ax,%ax
  804328:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80432c:	72 ea                	jb     804318 <__umoddi3+0x134>
  80432e:	89 d9                	mov    %ebx,%ecx
  804330:	e9 62 ff ff ff       	jmp    804297 <__umoddi3+0xb3>
