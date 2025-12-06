
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 5e 02 00 00       	call   800294 <libmain>
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
  800048:	e8 23 2f 00 00       	call   802f70 <sys_getparentenvid>
  80004d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	68 40 43 80 00       	push   $0x804340
  800058:	ff 75 ec             	pushl  -0x14(%ebp)
  80005b:	e8 4d 1f 00 00       	call   801fad <sget>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int *protType = sget(parentenvID, "protType") ;
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	68 42 43 80 00       	push   $0x804342
  80006e:	ff 75 ec             	pushl  -0x14(%ebp)
  800071:	e8 37 1f 00 00       	call   801fad <sget>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	68 4b 43 80 00       	push   $0x80434b
  800084:	ff 75 ec             	pushl  -0x14(%ebp)
  800087:	e8 21 1f 00 00       	call   801fad <sget>
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
  8000ab:	e8 18 3c 00 00       	call   803cc8 <get_semaphore>
  8000b0:	83 c4 0c             	add    $0xc,%esp
		finished = get_semaphore(parentenvID, "finished");
  8000b3:	8d 45 b8             	lea    -0x48(%ebp),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	68 5b 43 80 00       	push   $0x80435b
  8000be:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	e8 01 3c 00 00       	call   803cc8 <get_semaphore>
  8000c7:	83 c4 0c             	add    $0xc,%esp
		finishedCountMutex = get_semaphore(parentenvID, "finishedCountMutex");
  8000ca:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 64 43 80 00       	push   $0x804364
  8000d5:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d8:	50                   	push   %eax
  8000d9:	e8 ea 3b 00 00       	call   803cc8 <get_semaphore>
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
  8000f8:	e8 b0 1e 00 00       	call   801fad <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 f4             	mov    %eax,-0xc(%ebp)
		sfinishedCountMutex = sget(parentenvID, "finishedCountMutex");
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	68 64 43 80 00       	push   $0x804364
  80010b:	ff 75 ec             	pushl  -0x14(%ebp)
  80010e:	e8 9a 1e 00 00       	call   801fad <sget>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800119:	8d 45 c0             	lea    -0x40(%ebp),%eax
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	50                   	push   %eax
  800120:	e8 7e 2e 00 00       	call   802fa3 <sys_get_virtual_time>
  800125:	83 c4 0c             	add    $0xc,%esp
  800128:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80012b:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	f7 f1                	div    %ecx
  800137:	89 d0                	mov    %edx,%eax
  800139:	05 d0 07 00 00       	add    $0x7d0,%eax
  80013e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800141:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	50                   	push   %eax
  800148:	e8 d4 3b 00 00       	call   803d21 <env_sleep>
  80014d:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  800150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800153:	8b 00                	mov    (%eax),%eax
  800155:	01 c0                	add    %eax,%eax
  800157:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  80015a:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	50                   	push   %eax
  800161:	e8 3d 2e 00 00       	call   802fa3 <sys_get_virtual_time>
  800166:	83 c4 0c             	add    $0xc,%esp
  800169:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80016c:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  800171:	ba 00 00 00 00       	mov    $0x0,%edx
  800176:	f7 f1                	div    %ecx
  800178:	89 d0                	mov    %edx,%eax
  80017a:	05 d0 07 00 00       	add    $0x7d0,%eax
  80017f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  800182:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 93 3b 00 00       	call   803d21 <env_sleep>
  80018e:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800194:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800197:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800199:	8d 45 d0             	lea    -0x30(%ebp),%eax
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	50                   	push   %eax
  8001a0:	e8 fe 2d 00 00       	call   802fa3 <sys_get_virtual_time>
  8001a5:	83 c4 0c             	add    $0xc,%esp
  8001a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001ab:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8001b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b5:	f7 f1                	div    %ecx
  8001b7:	89 d0                	mov    %edx,%eax
  8001b9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8001be:	89 45 dc             	mov    %eax,-0x24(%ebp)
	env_sleep(delay);
  8001c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	e8 54 3b 00 00       	call   803d21 <env_sleep>
  8001cd:	83 c4 10             	add    $0x10,%esp
	//	cprintf("delay = %d\n", delay);

	if (*protType == 1)
  8001d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	83 f8 01             	cmp    $0x1,%eax
  8001d8:	75 10                	jne    8001ea <_main+0x1b2>
	{
		signal_semaphore(T);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8001e0:	e8 17 3b 00 00       	call   803cfc <signal_semaphore>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	eb 18                	jmp    800202 <_main+0x1ca>
	}
	else if (*protType == 2)
  8001ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ed:	8b 00                	mov    (%eax),%eax
  8001ef:	83 f8 02             	cmp    $0x2,%eax
  8001f2:	75 0e                	jne    800202 <_main+0x1ca>
	{
		release_uspinlock(sT);
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001fa:	e8 87 3c 00 00       	call   803e86 <release_uspinlock>
  8001ff:	83 c4 10             	add    $0x10,%esp
	}
	/*[3] DECLARE FINISHING*/
	if (*protType == 1)
  800202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800205:	8b 00                	mov    (%eax),%eax
  800207:	83 f8 01             	cmp    $0x1,%eax
  80020a:	75 39                	jne    800245 <_main+0x20d>
	{
		signal_semaphore(finished);
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	ff 75 b8             	pushl  -0x48(%ebp)
  800212:	e8 e5 3a 00 00       	call   803cfc <signal_semaphore>
  800217:	83 c4 10             	add    $0x10,%esp

		wait_semaphore(finishedCountMutex);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	ff 75 b4             	pushl  -0x4c(%ebp)
  800220:	e8 bd 3a 00 00       	call   803ce2 <wait_semaphore>
  800225:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  800228:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022b:	8b 00                	mov    (%eax),%eax
  80022d:	8d 50 01             	lea    0x1(%eax),%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(finishedCountMutex);
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	ff 75 b4             	pushl  -0x4c(%ebp)
  80023b:	e8 bc 3a 00 00       	call   803cfc <signal_semaphore>
  800240:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
	}


}
  800243:	eb 4c                	jmp    800291 <_main+0x259>
		{
			(*finishedCount)++ ;
		}
		signal_semaphore(finishedCountMutex);
	}
	else if (*protType == 2)
  800245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800248:	8b 00                	mov    (%eax),%eax
  80024a:	83 f8 02             	cmp    $0x2,%eax
  80024d:	75 2b                	jne    80027a <_main+0x242>
	{
		acquire_uspinlock(sfinishedCountMutex);
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 f0             	pushl  -0x10(%ebp)
  800255:	e8 d4 3b 00 00       	call   803e2e <acquire_uspinlock>
  80025a:	83 c4 10             	add    $0x10,%esp
		{
			(*finishedCount)++ ;
  80025d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800260:	8b 00                	mov    (%eax),%eax
  800262:	8d 50 01             	lea    0x1(%eax),%edx
  800265:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800268:	89 10                	mov    %edx,(%eax)
		}
		release_uspinlock(sfinishedCountMutex);
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	ff 75 f0             	pushl  -0x10(%ebp)
  800270:	e8 11 3c 00 00       	call   803e86 <release_uspinlock>
  800275:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
	}


}
  800278:	eb 17                	jmp    800291 <_main+0x259>
		}
		release_uspinlock(sfinishedCountMutex);
	}
	else
	{
		sys_lock_cons();
  80027a:	e8 5f 2a 00 00       	call   802cde <sys_lock_cons>
		{
			(*finishedCount)++ ;
  80027f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800282:	8b 00                	mov    (%eax),%eax
  800284:	8d 50 01             	lea    0x1(%eax),%edx
  800287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028a:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80028c:	e8 67 2a 00 00       	call   802cf8 <sys_unlock_cons>
	}


}
  800291:	90                   	nop
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80029d:	e8 b5 2c 00 00       	call   802f57 <sys_getenvindex>
  8002a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a8:	89 d0                	mov    %edx,%eax
  8002aa:	c1 e0 03             	shl    $0x3,%eax
  8002ad:	01 d0                	add    %edx,%eax
  8002af:	c1 e0 02             	shl    $0x2,%eax
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002bb:	01 d0                	add    %edx,%eax
  8002bd:	c1 e0 03             	shl    $0x3,%eax
  8002c0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002c5:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8002cf:	8a 40 20             	mov    0x20(%eax),%al
  8002d2:	84 c0                	test   %al,%al
  8002d4:	74 0d                	je     8002e3 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8002db:	83 c0 20             	add    $0x20,%eax
  8002de:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002e7:	7e 0a                	jle    8002f3 <libmain+0x5f>
		binaryname = argv[0];
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002f3:	83 ec 08             	sub    $0x8,%esp
  8002f6:	ff 75 0c             	pushl  0xc(%ebp)
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	e8 37 fd ff ff       	call   800038 <_main>
  800301:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800304:	a1 00 50 80 00       	mov    0x805000,%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	0f 84 01 01 00 00    	je     800412 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800311:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800317:	bb 70 44 80 00       	mov    $0x804470,%ebx
  80031c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800321:	89 c7                	mov    %eax,%edi
  800323:	89 de                	mov    %ebx,%esi
  800325:	89 d1                	mov    %edx,%ecx
  800327:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800329:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80032c:	b9 56 00 00 00       	mov    $0x56,%ecx
  800331:	b0 00                	mov    $0x0,%al
  800333:	89 d7                	mov    %edx,%edi
  800335:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800337:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80033e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	50                   	push   %eax
  800345:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80034b:	50                   	push   %eax
  80034c:	e8 3c 2e 00 00       	call   80318d <sys_utilities>
  800351:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800354:	e8 85 29 00 00       	call   802cde <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	68 90 43 80 00       	push   $0x804390
  800361:	e8 be 01 00 00       	call   800524 <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800369:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80036c:	85 c0                	test   %eax,%eax
  80036e:	74 18                	je     800388 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800370:	e8 36 2e 00 00       	call   8031ab <sys_get_optimal_num_faults>
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	50                   	push   %eax
  800379:	68 b8 43 80 00       	push   $0x8043b8
  80037e:	e8 a1 01 00 00       	call   800524 <cprintf>
  800383:	83 c4 10             	add    $0x10,%esp
  800386:	eb 59                	jmp    8003e1 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800388:	a1 20 50 80 00       	mov    0x805020,%eax
  80038d:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800393:	a1 20 50 80 00       	mov    0x805020,%eax
  800398:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	52                   	push   %edx
  8003a2:	50                   	push   %eax
  8003a3:	68 dc 43 80 00       	push   $0x8043dc
  8003a8:	e8 77 01 00 00       	call   800524 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b5:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8003bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c0:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003cb:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003d1:	51                   	push   %ecx
  8003d2:	52                   	push   %edx
  8003d3:	50                   	push   %eax
  8003d4:	68 04 44 80 00       	push   $0x804404
  8003d9:	e8 46 01 00 00       	call   800524 <cprintf>
  8003de:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e6:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	50                   	push   %eax
  8003f0:	68 5c 44 80 00       	push   $0x80445c
  8003f5:	e8 2a 01 00 00       	call   800524 <cprintf>
  8003fa:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	68 90 43 80 00       	push   $0x804390
  800405:	e8 1a 01 00 00       	call   800524 <cprintf>
  80040a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80040d:	e8 e6 28 00 00       	call   802cf8 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800412:	e8 1f 00 00 00       	call   800436 <exit>
}
  800417:	90                   	nop
  800418:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041b:	5b                   	pop    %ebx
  80041c:	5e                   	pop    %esi
  80041d:	5f                   	pop    %edi
  80041e:	5d                   	pop    %ebp
  80041f:	c3                   	ret    

00800420 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800426:	83 ec 0c             	sub    $0xc,%esp
  800429:	6a 00                	push   $0x0
  80042b:	e8 f3 2a 00 00       	call   802f23 <sys_destroy_env>
  800430:	83 c4 10             	add    $0x10,%esp
}
  800433:	90                   	nop
  800434:	c9                   	leave  
  800435:	c3                   	ret    

00800436 <exit>:

void
exit(void)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80043c:	e8 48 2b 00 00       	call   802f89 <sys_exit_env>
}
  800441:	90                   	nop
  800442:	c9                   	leave  
  800443:	c3                   	ret    

00800444 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	53                   	push   %ebx
  800448:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80044b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	8d 48 01             	lea    0x1(%eax),%ecx
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	89 0a                	mov    %ecx,(%edx)
  800458:	8b 55 08             	mov    0x8(%ebp),%edx
  80045b:	88 d1                	mov    %dl,%cl
  80045d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800460:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	3d ff 00 00 00       	cmp    $0xff,%eax
  80046e:	75 30                	jne    8004a0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800470:	8b 15 38 51 83 00    	mov    0x835138,%edx
  800476:	a0 64 d0 81 00       	mov    0x81d064,%al
  80047b:	0f b6 c0             	movzbl %al,%eax
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	8b 09                	mov    (%ecx),%ecx
  800483:	89 cb                	mov    %ecx,%ebx
  800485:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800488:	83 c1 08             	add    $0x8,%ecx
  80048b:	52                   	push   %edx
  80048c:	50                   	push   %eax
  80048d:	53                   	push   %ebx
  80048e:	51                   	push   %ecx
  80048f:	e8 06 28 00 00       	call   802c9a <sys_cputs>
  800494:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a3:	8b 40 04             	mov    0x4(%eax),%eax
  8004a6:	8d 50 01             	lea    0x1(%eax),%edx
  8004a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ac:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004af:	90                   	nop
  8004b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b3:	c9                   	leave  
  8004b4:	c3                   	ret    

008004b5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004c5:	00 00 00 
	b.cnt = 0;
  8004c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004cf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004de:	50                   	push   %eax
  8004df:	68 44 04 80 00       	push   $0x800444
  8004e4:	e8 5a 02 00 00       	call   800743 <vprintfmt>
  8004e9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004ec:	8b 15 38 51 83 00    	mov    0x835138,%edx
  8004f2:	a0 64 d0 81 00       	mov    0x81d064,%al
  8004f7:	0f b6 c0             	movzbl %al,%eax
  8004fa:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800500:	52                   	push   %edx
  800501:	50                   	push   %eax
  800502:	51                   	push   %ecx
  800503:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800509:	83 c0 08             	add    $0x8,%eax
  80050c:	50                   	push   %eax
  80050d:	e8 88 27 00 00       	call   802c9a <sys_cputs>
  800512:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800515:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  80051c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800522:	c9                   	leave  
  800523:	c3                   	ret    

00800524 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052a:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800531:	8d 45 0c             	lea    0xc(%ebp),%eax
  800534:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	ff 75 f4             	pushl  -0xc(%ebp)
  800540:	50                   	push   %eax
  800541:	e8 6f ff ff ff       	call   8004b5 <vcprintf>
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80054f:	c9                   	leave  
  800550:	c3                   	ret    

00800551 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
  800554:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800557:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	c1 e0 08             	shl    $0x8,%eax
  800564:	a3 38 51 83 00       	mov    %eax,0x835138
	va_start(ap, fmt);
  800569:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056c:	83 c0 04             	add    $0x4,%eax
  80056f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	83 ec 08             	sub    $0x8,%esp
  800578:	ff 75 f4             	pushl  -0xc(%ebp)
  80057b:	50                   	push   %eax
  80057c:	e8 34 ff ff ff       	call   8004b5 <vcprintf>
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800587:	c7 05 38 51 83 00 00 	movl   $0x700,0x835138
  80058e:	07 00 00 

	return cnt;
  800591:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800594:	c9                   	leave  
  800595:	c3                   	ret    

00800596 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800596:	55                   	push   %ebp
  800597:	89 e5                	mov    %esp,%ebp
  800599:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80059c:	e8 3d 27 00 00       	call   802cde <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005a1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b0:	50                   	push   %eax
  8005b1:	e8 ff fe ff ff       	call   8004b5 <vcprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005bc:	e8 37 27 00 00       	call   802cf8 <sys_unlock_cons>
	return cnt;
  8005c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c4:	c9                   	leave  
  8005c5:	c3                   	ret    

008005c6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	53                   	push   %ebx
  8005ca:	83 ec 14             	sub    $0x14,%esp
  8005cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e4:	77 55                	ja     80063b <printnum+0x75>
  8005e6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e9:	72 05                	jb     8005f0 <printnum+0x2a>
  8005eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ee:	77 4b                	ja     80063b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fe:	52                   	push   %edx
  8005ff:	50                   	push   %eax
  800600:	ff 75 f4             	pushl  -0xc(%ebp)
  800603:	ff 75 f0             	pushl  -0x10(%ebp)
  800606:	e8 cd 3a 00 00       	call   8040d8 <__udivdi3>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	ff 75 20             	pushl  0x20(%ebp)
  800614:	53                   	push   %ebx
  800615:	ff 75 18             	pushl  0x18(%ebp)
  800618:	52                   	push   %edx
  800619:	50                   	push   %eax
  80061a:	ff 75 0c             	pushl  0xc(%ebp)
  80061d:	ff 75 08             	pushl  0x8(%ebp)
  800620:	e8 a1 ff ff ff       	call   8005c6 <printnum>
  800625:	83 c4 20             	add    $0x20,%esp
  800628:	eb 1a                	jmp    800644 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	ff 75 20             	pushl  0x20(%ebp)
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	ff d0                	call   *%eax
  800638:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063b:	ff 4d 1c             	decl   0x1c(%ebp)
  80063e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800642:	7f e6                	jg     80062a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800644:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800647:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800652:	53                   	push   %ebx
  800653:	51                   	push   %ecx
  800654:	52                   	push   %edx
  800655:	50                   	push   %eax
  800656:	e8 8d 3b 00 00       	call   8041e8 <__umoddi3>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	05 f4 46 80 00       	add    $0x8046f4,%eax
  800663:	8a 00                	mov    (%eax),%al
  800665:	0f be c0             	movsbl %al,%eax
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	50                   	push   %eax
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	ff d0                	call   *%eax
  800674:	83 c4 10             	add    $0x10,%esp
}
  800677:	90                   	nop
  800678:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067b:	c9                   	leave  
  80067c:	c3                   	ret    

0080067d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800680:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800684:	7e 1c                	jle    8006a2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800686:	8b 45 08             	mov    0x8(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	8d 50 08             	lea    0x8(%eax),%edx
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	89 10                	mov    %edx,(%eax)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	83 e8 08             	sub    $0x8,%eax
  80069b:	8b 50 04             	mov    0x4(%eax),%edx
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	eb 40                	jmp    8006e2 <getuint+0x65>
	else if (lflag)
  8006a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a6:	74 1e                	je     8006c6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	8d 50 04             	lea    0x4(%eax),%edx
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	89 10                	mov    %edx,(%eax)
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c4:	eb 1c                	jmp    8006e2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	8d 50 04             	lea    0x4(%eax),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 10                	mov    %edx,(%eax)
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	83 e8 04             	sub    $0x4,%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006eb:	7e 1c                	jle    800709 <getint+0x25>
		return va_arg(*ap, long long);
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	8d 50 08             	lea    0x8(%eax),%edx
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	89 10                	mov    %edx,(%eax)
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	83 e8 08             	sub    $0x8,%eax
  800702:	8b 50 04             	mov    0x4(%eax),%edx
  800705:	8b 00                	mov    (%eax),%eax
  800707:	eb 38                	jmp    800741 <getint+0x5d>
	else if (lflag)
  800709:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070d:	74 1a                	je     800729 <getint+0x45>
		return va_arg(*ap, long);
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	8d 50 04             	lea    0x4(%eax),%edx
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	89 10                	mov    %edx,(%eax)
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	83 e8 04             	sub    $0x4,%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	99                   	cltd   
  800727:	eb 18                	jmp    800741 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	8d 50 04             	lea    0x4(%eax),%edx
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	89 10                	mov    %edx,(%eax)
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	83 e8 04             	sub    $0x4,%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	99                   	cltd   
}
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	56                   	push   %esi
  800747:	53                   	push   %ebx
  800748:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074b:	eb 17                	jmp    800764 <vprintfmt+0x21>
			if (ch == '\0')
  80074d:	85 db                	test   %ebx,%ebx
  80074f:	0f 84 c1 03 00 00    	je     800b16 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	83 fb 25             	cmp    $0x25,%ebx
  800775:	75 d6                	jne    80074d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800777:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800782:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800789:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800790:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	8d 50 01             	lea    0x1(%eax),%edx
  80079d:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f b6 d8             	movzbl %al,%ebx
  8007a5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a8:	83 f8 5b             	cmp    $0x5b,%eax
  8007ab:	0f 87 3d 03 00 00    	ja     800aee <vprintfmt+0x3ab>
  8007b1:	8b 04 85 18 47 80 00 	mov    0x804718(,%eax,4),%eax
  8007b8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007be:	eb d7                	jmp    800797 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c4:	eb d1                	jmp    800797 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d0:	89 d0                	mov    %edx,%eax
  8007d2:	c1 e0 02             	shl    $0x2,%eax
  8007d5:	01 d0                	add    %edx,%eax
  8007d7:	01 c0                	add    %eax,%eax
  8007d9:	01 d8                	add    %ebx,%eax
  8007db:	83 e8 30             	sub    $0x30,%eax
  8007de:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e4:	8a 00                	mov    (%eax),%al
  8007e6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e9:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ec:	7e 3e                	jle    80082c <vprintfmt+0xe9>
  8007ee:	83 fb 39             	cmp    $0x39,%ebx
  8007f1:	7f 39                	jg     80082c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f6:	eb d5                	jmp    8007cd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 c0 04             	add    $0x4,%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080c:	eb 1f                	jmp    80082d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800812:	79 83                	jns    800797 <vprintfmt+0x54>
				width = 0;
  800814:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081b:	e9 77 ff ff ff       	jmp    800797 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800820:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800827:	e9 6b ff ff ff       	jmp    800797 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800831:	0f 89 60 ff ff ff    	jns    800797 <vprintfmt+0x54>
				width = precision, precision = -1;
  800837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800844:	e9 4e ff ff ff       	jmp    800797 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800849:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084c:	e9 46 ff ff ff       	jmp    800797 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	50                   	push   %eax
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	ff d0                	call   *%eax
  80086e:	83 c4 10             	add    $0x10,%esp
			break;
  800871:	e9 9b 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800887:	85 db                	test   %ebx,%ebx
  800889:	79 02                	jns    80088d <vprintfmt+0x14a>
				err = -err;
  80088b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088d:	83 fb 64             	cmp    $0x64,%ebx
  800890:	7f 0b                	jg     80089d <vprintfmt+0x15a>
  800892:	8b 34 9d 60 45 80 00 	mov    0x804560(,%ebx,4),%esi
  800899:	85 f6                	test   %esi,%esi
  80089b:	75 19                	jne    8008b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089d:	53                   	push   %ebx
  80089e:	68 05 47 80 00       	push   $0x804705
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 70 02 00 00       	call   800b1e <printfmt>
  8008ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b1:	e9 5b 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b6:	56                   	push   %esi
  8008b7:	68 0e 47 80 00       	push   $0x80470e
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 57 02 00 00       	call   800b1e <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			break;
  8008ca:	e9 42 02 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	83 c0 04             	add    $0x4,%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 30                	mov    (%eax),%esi
  8008e0:	85 f6                	test   %esi,%esi
  8008e2:	75 05                	jne    8008e9 <vprintfmt+0x1a6>
				p = "(null)";
  8008e4:	be 11 47 80 00       	mov    $0x804711,%esi
			if (width > 0 && padc != '-')
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	7e 6d                	jle    80095c <vprintfmt+0x219>
  8008ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f3:	74 67                	je     80095c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	50                   	push   %eax
  8008fc:	56                   	push   %esi
  8008fd:	e8 1e 03 00 00       	call   800c20 <strnlen>
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800908:	eb 16                	jmp    800920 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	50                   	push   %eax
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091d:	ff 4d e4             	decl   -0x1c(%ebp)
  800920:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800924:	7f e4                	jg     80090a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	eb 34                	jmp    80095c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800928:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092c:	74 1c                	je     80094a <vprintfmt+0x207>
  80092e:	83 fb 1f             	cmp    $0x1f,%ebx
  800931:	7e 05                	jle    800938 <vprintfmt+0x1f5>
  800933:	83 fb 7e             	cmp    $0x7e,%ebx
  800936:	7e 12                	jle    80094a <vprintfmt+0x207>
					putch('?', putdat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	6a 3f                	push   $0x3f
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	eb 0f                	jmp    800959 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	53                   	push   %ebx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800959:	ff 4d e4             	decl   -0x1c(%ebp)
  80095c:	89 f0                	mov    %esi,%eax
  80095e:	8d 70 01             	lea    0x1(%eax),%esi
  800961:	8a 00                	mov    (%eax),%al
  800963:	0f be d8             	movsbl %al,%ebx
  800966:	85 db                	test   %ebx,%ebx
  800968:	74 24                	je     80098e <vprintfmt+0x24b>
  80096a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096e:	78 b8                	js     800928 <vprintfmt+0x1e5>
  800970:	ff 4d e0             	decl   -0x20(%ebp)
  800973:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800977:	79 af                	jns    800928 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800979:	eb 13                	jmp    80098e <vprintfmt+0x24b>
				putch(' ', putdat);
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	6a 20                	push   $0x20
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098b:	ff 4d e4             	decl   -0x1c(%ebp)
  80098e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800992:	7f e7                	jg     80097b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800994:	e9 78 01 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 e8             	pushl  -0x18(%ebp)
  80099f:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a2:	50                   	push   %eax
  8009a3:	e8 3c fd ff ff       	call   8006e4 <getint>
  8009a8:	83 c4 10             	add    $0x10,%esp
  8009ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b7:	85 d2                	test   %edx,%edx
  8009b9:	79 23                	jns    8009de <vprintfmt+0x29b>
				putch('-', putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	6a 2d                	push   $0x2d
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d1:	f7 d8                	neg    %eax
  8009d3:	83 d2 00             	adc    $0x0,%edx
  8009d6:	f7 da                	neg    %edx
  8009d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e5:	e9 bc 00 00 00       	jmp    800aa6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f3:	50                   	push   %eax
  8009f4:	e8 84 fc ff ff       	call   80067d <getuint>
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a02:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a09:	e9 98 00 00 00       	jmp    800aa6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 58                	push   $0x58
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 58                	push   $0x58
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 58                	push   $0x58
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			break;
  800a3e:	e9 ce 00 00 00       	jmp    800b11 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	6a 30                	push   $0x30
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a53:	83 ec 08             	sub    $0x8,%esp
  800a56:	ff 75 0c             	pushl  0xc(%ebp)
  800a59:	6a 78                	push   $0x78
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 c0 04             	add    $0x4,%eax
  800a69:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 e8 04             	sub    $0x4,%eax
  800a72:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a85:	eb 1f                	jmp    800aa6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8d:	8d 45 14             	lea    0x14(%ebp),%eax
  800a90:	50                   	push   %eax
  800a91:	e8 e7 fb ff ff       	call   80067d <getuint>
  800a96:	83 c4 10             	add    $0x10,%esp
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	52                   	push   %edx
  800ab1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab4:	50                   	push   %eax
  800ab5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab8:	ff 75 f0             	pushl  -0x10(%ebp)
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	ff 75 08             	pushl  0x8(%ebp)
  800ac1:	e8 00 fb ff ff       	call   8005c6 <printnum>
  800ac6:	83 c4 20             	add    $0x20,%esp
			break;
  800ac9:	eb 46                	jmp    800b11 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	53                   	push   %ebx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			break;
  800ada:	eb 35                	jmp    800b11 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800adc:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800ae3:	eb 2c                	jmp    800b11 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ae5:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800aec:	eb 23                	jmp    800b11 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	6a 25                	push   $0x25
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	ff d0                	call   *%eax
  800afb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800afe:	ff 4d 10             	decl   0x10(%ebp)
  800b01:	eb 03                	jmp    800b06 <vprintfmt+0x3c3>
  800b03:	ff 4d 10             	decl   0x10(%ebp)
  800b06:	8b 45 10             	mov    0x10(%ebp),%eax
  800b09:	48                   	dec    %eax
  800b0a:	8a 00                	mov    (%eax),%al
  800b0c:	3c 25                	cmp    $0x25,%al
  800b0e:	75 f3                	jne    800b03 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b10:	90                   	nop
		}
	}
  800b11:	e9 35 fc ff ff       	jmp    80074b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b16:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b1a:	5b                   	pop    %ebx
  800b1b:	5e                   	pop    %esi
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b24:	8d 45 10             	lea    0x10(%ebp),%eax
  800b27:	83 c0 04             	add    $0x4,%eax
  800b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b30:	ff 75 f4             	pushl  -0xc(%ebp)
  800b33:	50                   	push   %eax
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 08             	pushl  0x8(%ebp)
  800b3a:	e8 04 fc ff ff       	call   800743 <vprintfmt>
  800b3f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b42:	90                   	nop
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	8b 40 08             	mov    0x8(%eax),%eax
  800b4e:	8d 50 01             	lea    0x1(%eax),%edx
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	8b 10                	mov    (%eax),%edx
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 40 04             	mov    0x4(%eax),%eax
  800b62:	39 c2                	cmp    %eax,%edx
  800b64:	73 12                	jae    800b78 <sprintputch+0x33>
		*b->buf++ = ch;
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b71:	89 0a                	mov    %ecx,(%edx)
  800b73:	8b 55 08             	mov    0x8(%ebp),%edx
  800b76:	88 10                	mov    %dl,(%eax)
}
  800b78:	90                   	nop
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	01 d0                	add    %edx,%eax
  800b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba0:	74 06                	je     800ba8 <vsnprintf+0x2d>
  800ba2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba6:	7f 07                	jg     800baf <vsnprintf+0x34>
		return -E_INVAL;
  800ba8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bad:	eb 20                	jmp    800bcf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800baf:	ff 75 14             	pushl  0x14(%ebp)
  800bb2:	ff 75 10             	pushl  0x10(%ebp)
  800bb5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bb8:	50                   	push   %eax
  800bb9:	68 45 0b 80 00       	push   $0x800b45
  800bbe:	e8 80 fb ff ff       	call   800743 <vprintfmt>
  800bc3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bcf:	c9                   	leave  
  800bd0:	c3                   	ret    

00800bd1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bda:	83 c0 04             	add    $0x4,%eax
  800bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be0:	8b 45 10             	mov    0x10(%ebp),%eax
  800be3:	ff 75 f4             	pushl  -0xc(%ebp)
  800be6:	50                   	push   %eax
  800be7:	ff 75 0c             	pushl  0xc(%ebp)
  800bea:	ff 75 08             	pushl  0x8(%ebp)
  800bed:	e8 89 ff ff ff       	call   800b7b <vsnprintf>
  800bf2:	83 c4 10             	add    $0x10,%esp
  800bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c0a:	eb 06                	jmp    800c12 <strlen+0x15>
		n++;
  800c0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0f:	ff 45 08             	incl   0x8(%ebp)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	84 c0                	test   %al,%al
  800c19:	75 f1                	jne    800c0c <strlen+0xf>
		n++;
	return n;
  800c1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2d:	eb 09                	jmp    800c38 <strnlen+0x18>
		n++;
  800c2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c32:	ff 45 08             	incl   0x8(%ebp)
  800c35:	ff 4d 0c             	decl   0xc(%ebp)
  800c38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3c:	74 09                	je     800c47 <strnlen+0x27>
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8a 00                	mov    (%eax),%al
  800c43:	84 c0                	test   %al,%al
  800c45:	75 e8                	jne    800c2f <strnlen+0xf>
		n++;
	return n;
  800c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c58:	90                   	nop
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	8d 50 01             	lea    0x1(%eax),%edx
  800c5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c6b:	8a 12                	mov    (%edx),%dl
  800c6d:	88 10                	mov    %dl,(%eax)
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	84 c0                	test   %al,%al
  800c73:	75 e4                	jne    800c59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8d:	eb 1f                	jmp    800cae <strncpy+0x34>
		*dst++ = *src;
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8d 50 01             	lea    0x1(%eax),%edx
  800c95:	89 55 08             	mov    %edx,0x8(%ebp)
  800c98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9b:	8a 12                	mov    (%edx),%dl
  800c9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	74 03                	je     800cab <strncpy+0x31>
			src++;
  800ca8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cab:	ff 45 fc             	incl   -0x4(%ebp)
  800cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cb4:	72 d9                	jb     800c8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccb:	74 30                	je     800cfd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ccd:	eb 16                	jmp    800ce5 <strlcpy+0x2a>
			*dst++ = *src++;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8d 50 01             	lea    0x1(%eax),%edx
  800cd5:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cde:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce1:	8a 12                	mov    (%edx),%dl
  800ce3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ce5:	ff 4d 10             	decl   0x10(%ebp)
  800ce8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cec:	74 09                	je     800cf7 <strlcpy+0x3c>
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	75 d8                	jne    800ccf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d03:	29 c2                	sub    %eax,%edx
  800d05:	89 d0                	mov    %edx,%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d0c:	eb 06                	jmp    800d14 <strcmp+0xb>
		p++, q++;
  800d0e:	ff 45 08             	incl   0x8(%ebp)
  800d11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	74 0e                	je     800d2b <strcmp+0x22>
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 10                	mov    (%eax),%dl
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	38 c2                	cmp    %al,%dl
  800d29:	74 e3                	je     800d0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 d0             	movzbl %al,%edx
  800d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	0f b6 c0             	movzbl %al,%eax
  800d3b:	29 c2                	sub    %eax,%edx
  800d3d:	89 d0                	mov    %edx,%eax
}
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d44:	eb 09                	jmp    800d4f <strncmp+0xe>
		n--, p++, q++;
  800d46:	ff 4d 10             	decl   0x10(%ebp)
  800d49:	ff 45 08             	incl   0x8(%ebp)
  800d4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d53:	74 17                	je     800d6c <strncmp+0x2b>
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	84 c0                	test   %al,%al
  800d5c:	74 0e                	je     800d6c <strncmp+0x2b>
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 10                	mov    (%eax),%dl
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	38 c2                	cmp    %al,%dl
  800d6a:	74 da                	je     800d46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d70:	75 07                	jne    800d79 <strncmp+0x38>
		return 0;
  800d72:	b8 00 00 00 00       	mov    $0x0,%eax
  800d77:	eb 14                	jmp    800d8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	83 ec 04             	sub    $0x4,%esp
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d9b:	eb 12                	jmp    800daf <strchr+0x20>
		if (*s == c)
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800da5:	75 05                	jne    800dac <strchr+0x1d>
			return (char *) s;
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	eb 11                	jmp    800dbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dac:	ff 45 08             	incl   0x8(%ebp)
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	84 c0                	test   %al,%al
  800db6:	75 e5                	jne    800d9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 04             	sub    $0x4,%esp
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dcb:	eb 0d                	jmp    800dda <strfind+0x1b>
		if (*s == c)
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd5:	74 0e                	je     800de5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	84 c0                	test   %al,%al
  800de1:	75 ea                	jne    800dcd <strfind+0xe>
  800de3:	eb 01                	jmp    800de6 <strfind+0x27>
		if (*s == c)
			break;
  800de5:	90                   	nop
	return (char *) s;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800df7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dfb:	76 63                	jbe    800e60 <memset+0x75>
		uint64 data_block = c;
  800dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e00:	99                   	cltd   
  800e01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e04:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e11:	c1 e0 08             	shl    $0x8,%eax
  800e14:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e17:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e24:	c1 e0 10             	shl    $0x10,%eax
  800e27:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e2a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e33:	89 c2                	mov    %eax,%edx
  800e35:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e3d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e40:	eb 18                	jmp    800e5a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e42:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e45:	8d 41 08             	lea    0x8(%ecx),%eax
  800e48:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e51:	89 01                	mov    %eax,(%ecx)
  800e53:	89 51 04             	mov    %edx,0x4(%ecx)
  800e56:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e5a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e5e:	77 e2                	ja     800e42 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e64:	74 23                	je     800e89 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e69:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e6c:	eb 0e                	jmp    800e7c <memset+0x91>
			*p8++ = (uint8)c;
  800e6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e71:	8d 50 01             	lea    0x1(%eax),%edx
  800e74:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 e5                	jne    800e6e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ea0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea4:	76 24                	jbe    800eca <memcpy+0x3c>
		while(n >= 8){
  800ea6:	eb 1c                	jmp    800ec4 <memcpy+0x36>
			*d64 = *s64;
  800ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eab:	8b 50 04             	mov    0x4(%eax),%edx
  800eae:	8b 00                	mov    (%eax),%eax
  800eb0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eb3:	89 01                	mov    %eax,(%ecx)
  800eb5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800eb8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ebc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ec0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ec4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec8:	77 de                	ja     800ea8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800eca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ece:	74 31                	je     800f01 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800edc:	eb 16                	jmp    800ef4 <memcpy+0x66>
			*d8++ = *s8++;
  800ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efa:	89 55 10             	mov    %edx,0x10(%ebp)
  800efd:	85 c0                	test   %eax,%eax
  800eff:	75 dd                	jne    800ede <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f04:	c9                   	leave  
  800f05:	c3                   	ret    

00800f06 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1e:	73 50                	jae    800f70 <memmove+0x6a>
  800f20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f23:	8b 45 10             	mov    0x10(%ebp),%eax
  800f26:	01 d0                	add    %edx,%eax
  800f28:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f2b:	76 43                	jbe    800f70 <memmove+0x6a>
		s += n;
  800f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f30:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f39:	eb 10                	jmp    800f4b <memmove+0x45>
			*--d = *--s;
  800f3b:	ff 4d f8             	decl   -0x8(%ebp)
  800f3e:	ff 4d fc             	decl   -0x4(%ebp)
  800f41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f44:	8a 10                	mov    (%eax),%dl
  800f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f49:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f51:	89 55 10             	mov    %edx,0x10(%ebp)
  800f54:	85 c0                	test   %eax,%eax
  800f56:	75 e3                	jne    800f3b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f58:	eb 23                	jmp    800f7d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	8d 50 01             	lea    0x1(%eax),%edx
  800f60:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f69:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6c:	8a 12                	mov    (%edx),%dl
  800f6e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 dd                	jne    800f5a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f94:	eb 2a                	jmp    800fc0 <memcmp+0x3e>
		if (*s1 != *s2)
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	8a 10                	mov    (%eax),%dl
  800f9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	38 c2                	cmp    %al,%dl
  800fa2:	74 16                	je     800fba <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
  800fb8:	eb 18                	jmp    800fd2 <memcmp+0x50>
		s1++, s2++;
  800fba:	ff 45 fc             	incl   -0x4(%ebp)
  800fbd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	75 c9                	jne    800f96 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd2:	c9                   	leave  
  800fd3:	c3                   	ret    

00800fd4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fda:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fe5:	eb 15                	jmp    800ffc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f b6 d0             	movzbl %al,%edx
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	0f b6 c0             	movzbl %al,%eax
  800ff5:	39 c2                	cmp    %eax,%edx
  800ff7:	74 0d                	je     801006 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff9:	ff 45 08             	incl   0x8(%ebp)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801002:	72 e3                	jb     800fe7 <memfind+0x13>
  801004:	eb 01                	jmp    801007 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801006:	90                   	nop
	return (void *) s;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801019:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801020:	eb 03                	jmp    801025 <strtol+0x19>
		s++;
  801022:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	3c 20                	cmp    $0x20,%al
  80102c:	74 f4                	je     801022 <strtol+0x16>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	3c 09                	cmp    $0x9,%al
  801035:	74 eb                	je     801022 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 2b                	cmp    $0x2b,%al
  80103e:	75 05                	jne    801045 <strtol+0x39>
		s++;
  801040:	ff 45 08             	incl   0x8(%ebp)
  801043:	eb 13                	jmp    801058 <strtol+0x4c>
	else if (*s == '-')
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	3c 2d                	cmp    $0x2d,%al
  80104c:	75 0a                	jne    801058 <strtol+0x4c>
		s++, neg = 1;
  80104e:	ff 45 08             	incl   0x8(%ebp)
  801051:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801058:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105c:	74 06                	je     801064 <strtol+0x58>
  80105e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801062:	75 20                	jne    801084 <strtol+0x78>
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	3c 30                	cmp    $0x30,%al
  80106b:	75 17                	jne    801084 <strtol+0x78>
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	40                   	inc    %eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	3c 78                	cmp    $0x78,%al
  801075:	75 0d                	jne    801084 <strtol+0x78>
		s += 2, base = 16;
  801077:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80107b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801082:	eb 28                	jmp    8010ac <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801084:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801088:	75 15                	jne    80109f <strtol+0x93>
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	3c 30                	cmp    $0x30,%al
  801091:	75 0c                	jne    80109f <strtol+0x93>
		s++, base = 8;
  801093:	ff 45 08             	incl   0x8(%ebp)
  801096:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80109d:	eb 0d                	jmp    8010ac <strtol+0xa0>
	else if (base == 0)
  80109f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a3:	75 07                	jne    8010ac <strtol+0xa0>
		base = 10;
  8010a5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 2f                	cmp    $0x2f,%al
  8010b3:	7e 19                	jle    8010ce <strtol+0xc2>
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 39                	cmp    $0x39,%al
  8010bc:	7f 10                	jg     8010ce <strtol+0xc2>
			dig = *s - '0';
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	0f be c0             	movsbl %al,%eax
  8010c6:	83 e8 30             	sub    $0x30,%eax
  8010c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010cc:	eb 42                	jmp    801110 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	3c 60                	cmp    $0x60,%al
  8010d5:	7e 19                	jle    8010f0 <strtol+0xe4>
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 7a                	cmp    $0x7a,%al
  8010de:	7f 10                	jg     8010f0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	0f be c0             	movsbl %al,%eax
  8010e8:	83 e8 57             	sub    $0x57,%eax
  8010eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ee:	eb 20                	jmp    801110 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	3c 40                	cmp    $0x40,%al
  8010f7:	7e 39                	jle    801132 <strtol+0x126>
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	3c 5a                	cmp    $0x5a,%al
  801100:	7f 30                	jg     801132 <strtol+0x126>
			dig = *s - 'A' + 10;
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	0f be c0             	movsbl %al,%eax
  80110a:	83 e8 37             	sub    $0x37,%eax
  80110d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801113:	3b 45 10             	cmp    0x10(%ebp),%eax
  801116:	7d 19                	jge    801131 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801118:	ff 45 08             	incl   0x8(%ebp)
  80111b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801122:	89 c2                	mov    %eax,%edx
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80112c:	e9 7b ff ff ff       	jmp    8010ac <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801131:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801132:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801136:	74 08                	je     801140 <strtol+0x134>
		*endptr = (char *) s;
  801138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113b:	8b 55 08             	mov    0x8(%ebp),%edx
  80113e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801140:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801144:	74 07                	je     80114d <strtol+0x141>
  801146:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801149:	f7 d8                	neg    %eax
  80114b:	eb 03                	jmp    801150 <strtol+0x144>
  80114d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <ltostr>:

void
ltostr(long value, char *str)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80115f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116a:	79 13                	jns    80117f <ltostr+0x2d>
	{
		neg = 1;
  80116c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801179:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80117c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801187:	99                   	cltd   
  801188:	f7 f9                	idiv   %ecx
  80118a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	8d 50 01             	lea    0x1(%eax),%edx
  801193:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801196:	89 c2                	mov    %eax,%edx
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	01 d0                	add    %edx,%eax
  80119d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a0:	83 c2 30             	add    $0x30,%edx
  8011a3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ad:	f7 e9                	imul   %ecx
  8011af:	c1 fa 02             	sar    $0x2,%edx
  8011b2:	89 c8                	mov    %ecx,%eax
  8011b4:	c1 f8 1f             	sar    $0x1f,%eax
  8011b7:	29 c2                	sub    %eax,%edx
  8011b9:	89 d0                	mov    %edx,%eax
  8011bb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	75 bb                	jne    80117f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	48                   	dec    %eax
  8011cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d6:	74 3d                	je     801215 <ltostr+0xc3>
		start = 1 ;
  8011d8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011df:	eb 34                	jmp    801215 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e7:	01 d0                	add    %edx,%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 c2                	add    %eax,%edx
  8011f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	01 c8                	add    %ecx,%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801202:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c2                	add    %eax,%edx
  80120a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80120d:	88 02                	mov    %al,(%edx)
		start++ ;
  80120f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801212:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801218:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80121b:	7c c4                	jl     8011e1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80121d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	01 d0                	add    %edx,%eax
  801225:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801228:	90                   	nop
  801229:	c9                   	leave  
  80122a:	c3                   	ret    

0080122b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801231:	ff 75 08             	pushl  0x8(%ebp)
  801234:	e8 c4 f9 ff ff       	call   800bfd <strlen>
  801239:	83 c4 04             	add    $0x4,%esp
  80123c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80123f:	ff 75 0c             	pushl  0xc(%ebp)
  801242:	e8 b6 f9 ff ff       	call   800bfd <strlen>
  801247:	83 c4 04             	add    $0x4,%esp
  80124a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80124d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80125b:	eb 17                	jmp    801274 <strcconcat+0x49>
		final[s] = str1[s] ;
  80125d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 c2                	add    %eax,%edx
  801265:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	01 c8                	add    %ecx,%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801271:	ff 45 fc             	incl   -0x4(%ebp)
  801274:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801277:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80127a:	7c e1                	jl     80125d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80127c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801283:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80128a:	eb 1f                	jmp    8012ab <strcconcat+0x80>
		final[s++] = str2[i] ;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128f:	8d 50 01             	lea    0x1(%eax),%edx
  801292:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801295:	89 c2                	mov    %eax,%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 c2                	add    %eax,%edx
  80129c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	01 c8                	add    %ecx,%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012a8:	ff 45 f8             	incl   -0x8(%ebp)
  8012ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b1:	7c d9                	jl     80128c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	01 d0                	add    %edx,%eax
  8012bb:	c6 00 00             	movb   $0x0,(%eax)
}
  8012be:	90                   	nop
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	8b 00                	mov    (%eax),%eax
  8012d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dc:	01 d0                	add    %edx,%eax
  8012de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012e4:	eb 0c                	jmp    8012f2 <strsplit+0x31>
			*string++ = 0;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8d 50 01             	lea    0x1(%eax),%edx
  8012ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ef:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	84 c0                	test   %al,%al
  8012f9:	74 18                	je     801313 <strsplit+0x52>
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	0f be c0             	movsbl %al,%eax
  801303:	50                   	push   %eax
  801304:	ff 75 0c             	pushl  0xc(%ebp)
  801307:	e8 83 fa ff ff       	call   800d8f <strchr>
  80130c:	83 c4 08             	add    $0x8,%esp
  80130f:	85 c0                	test   %eax,%eax
  801311:	75 d3                	jne    8012e6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	84 c0                	test   %al,%al
  80131a:	74 5a                	je     801376 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80131c:	8b 45 14             	mov    0x14(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	83 f8 0f             	cmp    $0xf,%eax
  801324:	75 07                	jne    80132d <strsplit+0x6c>
		{
			return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
  80132b:	eb 66                	jmp    801393 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80132d:	8b 45 14             	mov    0x14(%ebp),%eax
  801330:	8b 00                	mov    (%eax),%eax
  801332:	8d 48 01             	lea    0x1(%eax),%ecx
  801335:	8b 55 14             	mov    0x14(%ebp),%edx
  801338:	89 0a                	mov    %ecx,(%edx)
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 c2                	add    %eax,%edx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80134b:	eb 03                	jmp    801350 <strsplit+0x8f>
			string++;
  80134d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	8a 00                	mov    (%eax),%al
  801355:	84 c0                	test   %al,%al
  801357:	74 8b                	je     8012e4 <strsplit+0x23>
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	0f be c0             	movsbl %al,%eax
  801361:	50                   	push   %eax
  801362:	ff 75 0c             	pushl  0xc(%ebp)
  801365:	e8 25 fa ff ff       	call   800d8f <strchr>
  80136a:	83 c4 08             	add    $0x8,%esp
  80136d:	85 c0                	test   %eax,%eax
  80136f:	74 dc                	je     80134d <strsplit+0x8c>
			string++;
	}
  801371:	e9 6e ff ff ff       	jmp    8012e4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801376:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801377:	8b 45 14             	mov    0x14(%ebp),%eax
  80137a:	8b 00                	mov    (%eax),%eax
  80137c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801383:	8b 45 10             	mov    0x10(%ebp),%eax
  801386:	01 d0                	add    %edx,%eax
  801388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80138e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a8:	eb 4a                	jmp    8013f4 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	01 c2                	add    %eax,%edx
  8013b2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b8:	01 c8                	add    %ecx,%eax
  8013ba:	8a 00                	mov    (%eax),%al
  8013bc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	01 d0                	add    %edx,%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	3c 40                	cmp    $0x40,%al
  8013ca:	7e 25                	jle    8013f1 <str2lower+0x5c>
  8013cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	3c 5a                	cmp    $0x5a,%al
  8013d8:	7f 17                	jg     8013f1 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	01 d0                	add    %edx,%eax
  8013e2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e8:	01 ca                	add    %ecx,%edx
  8013ea:	8a 12                	mov    (%edx),%dl
  8013ec:	83 c2 20             	add    $0x20,%edx
  8013ef:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013f1:	ff 45 fc             	incl   -0x4(%ebp)
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	e8 01 f8 ff ff       	call   800bfd <strlen>
  8013fc:	83 c4 04             	add    $0x4,%esp
  8013ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801402:	7f a6                	jg     8013aa <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801404:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80140f:	a1 08 50 80 00       	mov    0x805008,%eax
  801414:	85 c0                	test   %eax,%eax
  801416:	74 42                	je     80145a <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801418:	83 ec 08             	sub    $0x8,%esp
  80141b:	68 00 00 00 82       	push   $0x82000000
  801420:	68 00 00 00 80       	push   $0x80000000
  801425:	e8 b0 1e 00 00       	call   8032da <initialize_dynamic_allocator>
  80142a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80142d:	e8 96 1c 00 00       	call   8030c8 <sys_get_uheap_strategy>
  801432:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801437:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80143c:	05 00 10 00 00       	add    $0x1000,%eax
  801441:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801446:	a1 30 51 83 00       	mov    0x835130,%eax
  80144b:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  801450:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801457:	00 00 00 
	}
}
  80145a:	90                   	nop
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801471:	83 ec 08             	sub    $0x8,%esp
  801474:	68 06 04 00 00       	push   $0x406
  801479:	50                   	push   %eax
  80147a:	e8 93 18 00 00       	call   802d12 <__sys_allocate_page>
  80147f:	83 c4 10             	add    $0x10,%esp
  801482:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801485:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801489:	79 14                	jns    80149f <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	68 88 48 80 00       	push   $0x804888
  801493:	6a 1f                	push   $0x1f
  801495:	68 c4 48 80 00       	push   $0x8048c4
  80149a:	e8 48 2a 00 00       	call   803ee7 <_panic>
	return 0;
  80149f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a4:	c9                   	leave  
  8014a5:	c3                   	ret    

008014a6 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ba:	83 ec 0c             	sub    $0xc,%esp
  8014bd:	50                   	push   %eax
  8014be:	e8 96 18 00 00       	call   802d59 <__sys_unmap_frame>
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8014c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014cd:	79 14                	jns    8014e3 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8014cf:	83 ec 04             	sub    $0x4,%esp
  8014d2:	68 d0 48 80 00       	push   $0x8048d0
  8014d7:	6a 2a                	push   $0x2a
  8014d9:	68 c4 48 80 00       	push   $0x8048c4
  8014de:	e8 04 2a 00 00       	call   803ee7 <_panic>
}
  8014e3:	90                   	nop
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8014ec:	e8 18 ff ff ff       	call   801409 <uheap_init>
	if (size == 0) return NULL ;
  8014f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f5:	75 0a                	jne    801501 <malloc+0x1b>
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fc:	e9 43 03 00 00       	jmp    801844 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801501:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801508:	77 13                	ja     80151d <malloc+0x37>
    {
        return alloc_block(size);
  80150a:	83 ec 0c             	sub    $0xc,%esp
  80150d:	ff 75 08             	pushl  0x8(%ebp)
  801510:	e8 78 20 00 00       	call   80358d <alloc_block>
  801515:	83 c4 10             	add    $0x10,%esp
  801518:	e9 27 03 00 00       	jmp    801844 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80151d:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801524:	8b 55 08             	mov    0x8(%ebp),%edx
  801527:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80152a:	01 d0                	add    %edx,%eax
  80152c:	48                   	dec    %eax
  80152d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801530:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801533:	ba 00 00 00 00       	mov    $0x0,%edx
  801538:	f7 75 dc             	divl   -0x24(%ebp)
  80153b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80153e:	29 d0                	sub    %edx,%eax
  801540:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801543:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801548:	85 c0                	test   %eax,%eax
  80154a:	75 0a                	jne    801556 <malloc+0x70>
    {
        uhp_inited = 1;
  80154c:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  801553:	00 00 00 
    }

    int exactIdx = -1;
  801556:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80155d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801564:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80156b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801572:	e9 85 00 00 00       	jmp    8015fc <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801577:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80157a:	89 d0                	mov    %edx,%eax
  80157c:	01 c0                	add    %eax,%eax
  80157e:	01 d0                	add    %edx,%eax
  801580:	c1 e0 02             	shl    $0x2,%eax
  801583:	05 48 10 81 00       	add    $0x811048,%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	84 c0                	test   %al,%al
  80158c:	74 20                	je     8015ae <malloc+0xc8>
  80158e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801591:	89 d0                	mov    %edx,%eax
  801593:	01 c0                	add    %eax,%eax
  801595:	01 d0                	add    %edx,%eax
  801597:	c1 e0 02             	shl    $0x2,%eax
  80159a:	05 44 10 81 00       	add    $0x811044,%eax
  80159f:	8b 00                	mov    (%eax),%eax
  8015a1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8015a4:	75 08                	jne    8015ae <malloc+0xc8>
        {
            exactIdx = i;
  8015a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8015ac:	eb 5b                	jmp    801609 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8015ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015b1:	89 d0                	mov    %edx,%eax
  8015b3:	01 c0                	add    %eax,%eax
  8015b5:	01 d0                	add    %edx,%eax
  8015b7:	c1 e0 02             	shl    $0x2,%eax
  8015ba:	05 48 10 81 00       	add    $0x811048,%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	84 c0                	test   %al,%al
  8015c3:	74 34                	je     8015f9 <malloc+0x113>
  8015c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015c8:	89 d0                	mov    %edx,%eax
  8015ca:	01 c0                	add    %eax,%eax
  8015cc:	01 d0                	add    %edx,%eax
  8015ce:	c1 e0 02             	shl    $0x2,%eax
  8015d1:	05 44 10 81 00       	add    $0x811044,%eax
  8015d6:	8b 00                	mov    (%eax),%eax
  8015d8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8015db:	76 1c                	jbe    8015f9 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8015dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015e0:	89 d0                	mov    %edx,%eax
  8015e2:	01 c0                	add    %eax,%eax
  8015e4:	01 d0                	add    %edx,%eax
  8015e6:	c1 e0 02             	shl    $0x2,%eax
  8015e9:	05 44 10 81 00       	add    $0x811044,%eax
  8015ee:	8b 00                	mov    (%eax),%eax
  8015f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8015f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8015f9:	ff 45 e8             	incl   -0x18(%ebp)
  8015fc:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801603:	0f 8e 6e ff ff ff    	jle    801577 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801609:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801610:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801614:	74 7d                	je     801693 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801616:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80161d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801620:	89 d0                	mov    %edx,%eax
  801622:	01 c0                	add    %eax,%eax
  801624:	01 d0                	add    %edx,%eax
  801626:	c1 e0 02             	shl    $0x2,%eax
  801629:	05 40 10 81 00       	add    $0x811040,%eax
  80162e:	8b 10                	mov    (%eax),%edx
  801630:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801633:	01 d0                	add    %edx,%eax
  801635:	48                   	dec    %eax
  801636:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801639:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80163c:	ba 00 00 00 00       	mov    $0x0,%edx
  801641:	f7 75 bc             	divl   -0x44(%ebp)
  801644:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801647:	29 d0                	sub    %edx,%eax
  801649:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80164c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164f:	89 d0                	mov    %edx,%eax
  801651:	01 c0                	add    %eax,%eax
  801653:	01 d0                	add    %edx,%eax
  801655:	c1 e0 02             	shl    $0x2,%eax
  801658:	05 48 10 81 00       	add    $0x811048,%eax
  80165d:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801660:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801663:	89 d0                	mov    %edx,%eax
  801665:	01 c0                	add    %eax,%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	c1 e0 02             	shl    $0x2,%eax
  80166c:	05 44 10 81 00       	add    $0x811044,%eax
  801671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801677:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80167a:	89 d0                	mov    %edx,%eax
  80167c:	01 c0                	add    %eax,%eax
  80167e:	01 d0                	add    %edx,%eax
  801680:	c1 e0 02             	shl    $0x2,%eax
  801683:	05 40 10 81 00       	add    $0x811040,%eax
  801688:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80168e:	e9 2d 01 00 00       	jmp    8017c0 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801693:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801697:	0f 84 ce 00 00 00    	je     80176b <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80169d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8016a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016a7:	89 d0                	mov    %edx,%eax
  8016a9:	01 c0                	add    %eax,%eax
  8016ab:	01 d0                	add    %edx,%eax
  8016ad:	c1 e0 02             	shl    $0x2,%eax
  8016b0:	05 40 10 81 00       	add    $0x811040,%eax
  8016b5:	8b 10                	mov    (%eax),%edx
  8016b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016ba:	01 d0                	add    %edx,%eax
  8016bc:	48                   	dec    %eax
  8016bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8016c0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8016c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c8:	f7 75 c4             	divl   -0x3c(%ebp)
  8016cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8016ce:	29 d0                	sub    %edx,%eax
  8016d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8016d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d6:	89 d0                	mov    %edx,%eax
  8016d8:	01 c0                	add    %eax,%eax
  8016da:	01 d0                	add    %edx,%eax
  8016dc:	c1 e0 02             	shl    $0x2,%eax
  8016df:	05 44 10 81 00       	add    $0x811044,%eax
  8016e4:	8b 00                	mov    (%eax),%eax
  8016e6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8016e9:	75 47                	jne    801732 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  8016eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ee:	89 d0                	mov    %edx,%eax
  8016f0:	01 c0                	add    %eax,%eax
  8016f2:	01 d0                	add    %edx,%eax
  8016f4:	c1 e0 02             	shl    $0x2,%eax
  8016f7:	05 48 10 81 00       	add    $0x811048,%eax
  8016fc:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8016ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801702:	89 d0                	mov    %edx,%eax
  801704:	01 c0                	add    %eax,%eax
  801706:	01 d0                	add    %edx,%eax
  801708:	c1 e0 02             	shl    $0x2,%eax
  80170b:	05 44 10 81 00       	add    $0x811044,%eax
  801710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801716:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801719:	89 d0                	mov    %edx,%eax
  80171b:	01 c0                	add    %eax,%eax
  80171d:	01 d0                	add    %edx,%eax
  80171f:	c1 e0 02             	shl    $0x2,%eax
  801722:	05 40 10 81 00       	add    $0x811040,%eax
  801727:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80172d:	e9 8e 00 00 00       	jmp    8017c0 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801732:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801735:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801738:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80173b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80173e:	89 d0                	mov    %edx,%eax
  801740:	01 c0                	add    %eax,%eax
  801742:	01 d0                	add    %edx,%eax
  801744:	c1 e0 02             	shl    $0x2,%eax
  801747:	05 40 10 81 00       	add    $0x811040,%eax
  80174c:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80174e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801751:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801754:	89 c2                	mov    %eax,%edx
  801756:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801759:	89 c8                	mov    %ecx,%eax
  80175b:	01 c0                	add    %eax,%eax
  80175d:	01 c8                	add    %ecx,%eax
  80175f:	c1 e0 02             	shl    $0x2,%eax
  801762:	05 44 10 81 00       	add    $0x811044,%eax
  801767:	89 10                	mov    %edx,(%eax)
  801769:	eb 55                	jmp    8017c0 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80176b:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801772:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801778:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80177b:	01 d0                	add    %edx,%eax
  80177d:	48                   	dec    %eax
  80177e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801781:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801784:	ba 00 00 00 00       	mov    $0x0,%edx
  801789:	f7 75 d0             	divl   -0x30(%ebp)
  80178c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80178f:	29 d0                	sub    %edx,%eax
  801791:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801794:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801797:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80179a:	01 d0                	add    %edx,%eax
  80179c:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8017a1:	76 0a                	jbe    8017ad <malloc+0x2c7>
            return NULL;
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a8:	e9 97 00 00 00       	jmp    801844 <malloc+0x35e>
        va = start;
  8017ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8017b3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8017b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017b9:	01 d0                	add    %edx,%eax
  8017bb:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8017c0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8017c7:	eb 5e                	jmp    801827 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8017c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017cc:	89 d0                	mov    %edx,%eax
  8017ce:	01 c0                	add    %eax,%eax
  8017d0:	01 d0                	add    %edx,%eax
  8017d2:	c1 e0 02             	shl    $0x2,%eax
  8017d5:	05 48 50 80 00       	add    $0x805048,%eax
  8017da:	8a 00                	mov    (%eax),%al
  8017dc:	84 c0                	test   %al,%al
  8017de:	75 44                	jne    801824 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  8017e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017e3:	89 d0                	mov    %edx,%eax
  8017e5:	01 c0                	add    %eax,%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	c1 e0 02             	shl    $0x2,%eax
  8017ec:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8017f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017f5:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8017f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017fa:	89 d0                	mov    %edx,%eax
  8017fc:	01 c0                	add    %eax,%eax
  8017fe:	01 d0                	add    %edx,%eax
  801800:	c1 e0 02             	shl    $0x2,%eax
  801803:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801809:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80180c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80180e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801811:	89 d0                	mov    %edx,%eax
  801813:	01 c0                	add    %eax,%eax
  801815:	01 d0                	add    %edx,%eax
  801817:	c1 e0 02             	shl    $0x2,%eax
  80181a:	05 48 50 80 00       	add    $0x805048,%eax
  80181f:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801822:	eb 0c                	jmp    801830 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801824:	ff 45 e0             	incl   -0x20(%ebp)
  801827:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80182e:	7e 99                	jle    8017c9 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801830:	83 ec 08             	sub    $0x8,%esp
  801833:	ff 75 d4             	pushl  -0x2c(%ebp)
  801836:	ff 75 e4             	pushl  -0x1c(%ebp)
  801839:	e8 a2 19 00 00       	call   8031e0 <sys_allocate_user_mem>
  80183e:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  80184c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801850:	0f 84 fa 03 00 00    	je     801c50 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80185c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80185f:	85 c0                	test   %eax,%eax
  801861:	79 1c                	jns    80187f <free+0x39>
  801863:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  80186a:	77 13                	ja     80187f <free+0x39>
    {
        free_block(virtual_address);
  80186c:	83 ec 0c             	sub    $0xc,%esp
  80186f:	ff 75 08             	pushl  0x8(%ebp)
  801872:	e8 09 21 00 00       	call   803980 <free_block>
  801877:	83 c4 10             	add    $0x10,%esp
        return;
  80187a:	e9 d2 03 00 00       	jmp    801c51 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80187f:	a1 30 51 83 00       	mov    0x835130,%eax
  801884:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801887:	72 09                	jb     801892 <free+0x4c>
  801889:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801890:	76 17                	jbe    8018a9 <free+0x63>
        panic("free: invalid address");
  801892:	83 ec 04             	sub    $0x4,%esp
  801895:	68 0d 49 80 00       	push   $0x80490d
  80189a:	68 9b 00 00 00       	push   $0x9b
  80189f:	68 c4 48 80 00       	push   $0x8048c4
  8018a4:	e8 3e 26 00 00       	call   803ee7 <_panic>

    uint32 size = 0;
  8018a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  8018b0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8018b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8018be:	eb 50                	jmp    801910 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8018c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018c3:	89 d0                	mov    %edx,%eax
  8018c5:	01 c0                	add    %eax,%eax
  8018c7:	01 d0                	add    %edx,%eax
  8018c9:	c1 e0 02             	shl    $0x2,%eax
  8018cc:	05 48 50 80 00       	add    $0x805048,%eax
  8018d1:	8a 00                	mov    (%eax),%al
  8018d3:	84 c0                	test   %al,%al
  8018d5:	74 36                	je     80190d <free+0xc7>
  8018d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018da:	89 d0                	mov    %edx,%eax
  8018dc:	01 c0                	add    %eax,%eax
  8018de:	01 d0                	add    %edx,%eax
  8018e0:	c1 e0 02             	shl    $0x2,%eax
  8018e3:	05 40 50 80 00       	add    $0x805040,%eax
  8018e8:	8b 00                	mov    (%eax),%eax
  8018ea:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8018ed:	75 1e                	jne    80190d <free+0xc7>
        {
            size = uhp_allocs[i].size;
  8018ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018f2:	89 d0                	mov    %edx,%eax
  8018f4:	01 c0                	add    %eax,%eax
  8018f6:	01 d0                	add    %edx,%eax
  8018f8:	c1 e0 02             	shl    $0x2,%eax
  8018fb:	05 44 50 80 00       	add    $0x805044,%eax
  801900:	8b 00                	mov    (%eax),%eax
  801902:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801905:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801908:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  80190b:	eb 0c                	jmp    801919 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80190d:	ff 45 ec             	incl   -0x14(%ebp)
  801910:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801917:	7e a7                	jle    8018c0 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801919:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80191d:	74 06                	je     801925 <free+0xdf>
  80191f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801923:	75 17                	jne    80193c <free+0xf6>
        panic("free: unknown block");
  801925:	83 ec 04             	sub    $0x4,%esp
  801928:	68 23 49 80 00       	push   $0x804923
  80192d:	68 a9 00 00 00       	push   $0xa9
  801932:	68 c4 48 80 00       	push   $0x8048c4
  801937:	e8 ab 25 00 00       	call   803ee7 <_panic>

    uhp_allocs[idx].used = 0;
  80193c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80193f:	89 d0                	mov    %edx,%eax
  801941:	01 c0                	add    %eax,%eax
  801943:	01 d0                	add    %edx,%eax
  801945:	c1 e0 02             	shl    $0x2,%eax
  801948:	05 48 50 80 00       	add    $0x805048,%eax
  80194d:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801950:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801957:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80195e:	eb 64                	jmp    8019c4 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801960:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801963:	89 d0                	mov    %edx,%eax
  801965:	01 c0                	add    %eax,%eax
  801967:	01 d0                	add    %edx,%eax
  801969:	c1 e0 02             	shl    $0x2,%eax
  80196c:	05 48 10 81 00       	add    $0x811048,%eax
  801971:	8a 00                	mov    (%eax),%al
  801973:	84 c0                	test   %al,%al
  801975:	75 4a                	jne    8019c1 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801977:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80197a:	89 d0                	mov    %edx,%eax
  80197c:	01 c0                	add    %eax,%eax
  80197e:	01 d0                	add    %edx,%eax
  801980:	c1 e0 02             	shl    $0x2,%eax
  801983:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801989:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80198c:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  80198e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801991:	89 d0                	mov    %edx,%eax
  801993:	01 c0                	add    %eax,%eax
  801995:	01 d0                	add    %edx,%eax
  801997:	c1 e0 02             	shl    $0x2,%eax
  80199a:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  8019a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a3:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  8019a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019a8:	89 d0                	mov    %edx,%eax
  8019aa:	01 c0                	add    %eax,%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	c1 e0 02             	shl    $0x2,%eax
  8019b1:	05 48 10 81 00       	add    $0x811048,%eax
  8019b6:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  8019b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  8019bf:	eb 0c                	jmp    8019cd <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019c1:	ff 45 e4             	incl   -0x1c(%ebp)
  8019c4:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8019cb:	7e 93                	jle    801960 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  8019cd:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8019d1:	0f 84 f1 01 00 00    	je     801bc8 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019d7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019de:	e9 d8 01 00 00       	jmp    801bbb <free+0x375>
        {
            if (i == fidx) continue;
  8019e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8019e9:	0f 84 c8 01 00 00    	je     801bb7 <free+0x371>
            if (uhp_frees[i].free)
  8019ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019f2:	89 d0                	mov    %edx,%eax
  8019f4:	01 c0                	add    %eax,%eax
  8019f6:	01 d0                	add    %edx,%eax
  8019f8:	c1 e0 02             	shl    $0x2,%eax
  8019fb:	05 48 10 81 00       	add    $0x811048,%eax
  801a00:	8a 00                	mov    (%eax),%al
  801a02:	84 c0                	test   %al,%al
  801a04:	0f 84 ae 01 00 00    	je     801bb8 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a0d:	89 d0                	mov    %edx,%eax
  801a0f:	01 c0                	add    %eax,%eax
  801a11:	01 d0                	add    %edx,%eax
  801a13:	c1 e0 02             	shl    $0x2,%eax
  801a16:	05 40 10 81 00       	add    $0x811040,%eax
  801a1b:	8b 08                	mov    (%eax),%ecx
  801a1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a20:	89 d0                	mov    %edx,%eax
  801a22:	01 c0                	add    %eax,%eax
  801a24:	01 d0                	add    %edx,%eax
  801a26:	c1 e0 02             	shl    $0x2,%eax
  801a29:	05 44 10 81 00       	add    $0x811044,%eax
  801a2e:	8b 00                	mov    (%eax),%eax
  801a30:	01 c1                	add    %eax,%ecx
  801a32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a35:	89 d0                	mov    %edx,%eax
  801a37:	01 c0                	add    %eax,%eax
  801a39:	01 d0                	add    %edx,%eax
  801a3b:	c1 e0 02             	shl    $0x2,%eax
  801a3e:	05 40 10 81 00       	add    $0x811040,%eax
  801a43:	8b 00                	mov    (%eax),%eax
  801a45:	39 c1                	cmp    %eax,%ecx
  801a47:	0f 85 a8 00 00 00    	jne    801af5 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801a4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a50:	89 d0                	mov    %edx,%eax
  801a52:	01 c0                	add    %eax,%eax
  801a54:	01 d0                	add    %edx,%eax
  801a56:	c1 e0 02             	shl    $0x2,%eax
  801a59:	05 40 10 81 00       	add    $0x811040,%eax
  801a5e:	8b 10                	mov    (%eax),%edx
  801a60:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801a63:	89 c8                	mov    %ecx,%eax
  801a65:	01 c0                	add    %eax,%eax
  801a67:	01 c8                	add    %ecx,%eax
  801a69:	c1 e0 02             	shl    $0x2,%eax
  801a6c:	05 40 10 81 00       	add    $0x811040,%eax
  801a71:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801a73:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a76:	89 d0                	mov    %edx,%eax
  801a78:	01 c0                	add    %eax,%eax
  801a7a:	01 d0                	add    %edx,%eax
  801a7c:	c1 e0 02             	shl    $0x2,%eax
  801a7f:	05 44 10 81 00       	add    $0x811044,%eax
  801a84:	8b 08                	mov    (%eax),%ecx
  801a86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a89:	89 d0                	mov    %edx,%eax
  801a8b:	01 c0                	add    %eax,%eax
  801a8d:	01 d0                	add    %edx,%eax
  801a8f:	c1 e0 02             	shl    $0x2,%eax
  801a92:	05 44 10 81 00       	add    $0x811044,%eax
  801a97:	8b 00                	mov    (%eax),%eax
  801a99:	01 c1                	add    %eax,%ecx
  801a9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a9e:	89 d0                	mov    %edx,%eax
  801aa0:	01 c0                	add    %eax,%eax
  801aa2:	01 d0                	add    %edx,%eax
  801aa4:	c1 e0 02             	shl    $0x2,%eax
  801aa7:	05 44 10 81 00       	add    $0x811044,%eax
  801aac:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801aae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ab1:	89 d0                	mov    %edx,%eax
  801ab3:	01 c0                	add    %eax,%eax
  801ab5:	01 d0                	add    %edx,%eax
  801ab7:	c1 e0 02             	shl    $0x2,%eax
  801aba:	05 48 10 81 00       	add    $0x811048,%eax
  801abf:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801ac2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ac5:	89 d0                	mov    %edx,%eax
  801ac7:	01 c0                	add    %eax,%eax
  801ac9:	01 d0                	add    %edx,%eax
  801acb:	c1 e0 02             	shl    $0x2,%eax
  801ace:	05 40 10 81 00       	add    $0x811040,%eax
  801ad3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801ad9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801adc:	89 d0                	mov    %edx,%eax
  801ade:	01 c0                	add    %eax,%eax
  801ae0:	01 d0                	add    %edx,%eax
  801ae2:	c1 e0 02             	shl    $0x2,%eax
  801ae5:	05 44 10 81 00       	add    $0x811044,%eax
  801aea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801af0:	e9 c3 00 00 00       	jmp    801bb8 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801af5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801af8:	89 d0                	mov    %edx,%eax
  801afa:	01 c0                	add    %eax,%eax
  801afc:	01 d0                	add    %edx,%eax
  801afe:	c1 e0 02             	shl    $0x2,%eax
  801b01:	05 40 10 81 00       	add    $0x811040,%eax
  801b06:	8b 08                	mov    (%eax),%ecx
  801b08:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b0b:	89 d0                	mov    %edx,%eax
  801b0d:	01 c0                	add    %eax,%eax
  801b0f:	01 d0                	add    %edx,%eax
  801b11:	c1 e0 02             	shl    $0x2,%eax
  801b14:	05 44 10 81 00       	add    $0x811044,%eax
  801b19:	8b 00                	mov    (%eax),%eax
  801b1b:	01 c1                	add    %eax,%ecx
  801b1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b20:	89 d0                	mov    %edx,%eax
  801b22:	01 c0                	add    %eax,%eax
  801b24:	01 d0                	add    %edx,%eax
  801b26:	c1 e0 02             	shl    $0x2,%eax
  801b29:	05 40 10 81 00       	add    $0x811040,%eax
  801b2e:	8b 00                	mov    (%eax),%eax
  801b30:	39 c1                	cmp    %eax,%ecx
  801b32:	0f 85 80 00 00 00    	jne    801bb8 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801b38:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b3b:	89 d0                	mov    %edx,%eax
  801b3d:	01 c0                	add    %eax,%eax
  801b3f:	01 d0                	add    %edx,%eax
  801b41:	c1 e0 02             	shl    $0x2,%eax
  801b44:	05 44 10 81 00       	add    $0x811044,%eax
  801b49:	8b 08                	mov    (%eax),%ecx
  801b4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b4e:	89 d0                	mov    %edx,%eax
  801b50:	01 c0                	add    %eax,%eax
  801b52:	01 d0                	add    %edx,%eax
  801b54:	c1 e0 02             	shl    $0x2,%eax
  801b57:	05 44 10 81 00       	add    $0x811044,%eax
  801b5c:	8b 00                	mov    (%eax),%eax
  801b5e:	01 c1                	add    %eax,%ecx
  801b60:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b63:	89 d0                	mov    %edx,%eax
  801b65:	01 c0                	add    %eax,%eax
  801b67:	01 d0                	add    %edx,%eax
  801b69:	c1 e0 02             	shl    $0x2,%eax
  801b6c:	05 44 10 81 00       	add    $0x811044,%eax
  801b71:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801b73:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b76:	89 d0                	mov    %edx,%eax
  801b78:	01 c0                	add    %eax,%eax
  801b7a:	01 d0                	add    %edx,%eax
  801b7c:	c1 e0 02             	shl    $0x2,%eax
  801b7f:	05 48 10 81 00       	add    $0x811048,%eax
  801b84:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801b87:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b8a:	89 d0                	mov    %edx,%eax
  801b8c:	01 c0                	add    %eax,%eax
  801b8e:	01 d0                	add    %edx,%eax
  801b90:	c1 e0 02             	shl    $0x2,%eax
  801b93:	05 40 10 81 00       	add    $0x811040,%eax
  801b98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801b9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ba1:	89 d0                	mov    %edx,%eax
  801ba3:	01 c0                	add    %eax,%eax
  801ba5:	01 d0                	add    %edx,%eax
  801ba7:	c1 e0 02             	shl    $0x2,%eax
  801baa:	05 44 10 81 00       	add    $0x811044,%eax
  801baf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801bb5:	eb 01                	jmp    801bb8 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801bb7:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bb8:	ff 45 e0             	incl   -0x20(%ebp)
  801bbb:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801bc2:	0f 8e 1b fe ff ff    	jle    8019e3 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801bc8:	a1 30 51 83 00       	mov    0x835130,%eax
  801bcd:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801bd0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801bd7:	eb 53                	jmp    801c2c <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801bd9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801bdc:	89 d0                	mov    %edx,%eax
  801bde:	01 c0                	add    %eax,%eax
  801be0:	01 d0                	add    %edx,%eax
  801be2:	c1 e0 02             	shl    $0x2,%eax
  801be5:	05 48 50 80 00       	add    $0x805048,%eax
  801bea:	8a 00                	mov    (%eax),%al
  801bec:	84 c0                	test   %al,%al
  801bee:	74 39                	je     801c29 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801bf0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801bf3:	89 d0                	mov    %edx,%eax
  801bf5:	01 c0                	add    %eax,%eax
  801bf7:	01 d0                	add    %edx,%eax
  801bf9:	c1 e0 02             	shl    $0x2,%eax
  801bfc:	05 40 50 80 00       	add    $0x805040,%eax
  801c01:	8b 08                	mov    (%eax),%ecx
  801c03:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c06:	89 d0                	mov    %edx,%eax
  801c08:	01 c0                	add    %eax,%eax
  801c0a:	01 d0                	add    %edx,%eax
  801c0c:	c1 e0 02             	shl    $0x2,%eax
  801c0f:	05 44 50 80 00       	add    $0x805044,%eax
  801c14:	8b 00                	mov    (%eax),%eax
  801c16:	01 c8                	add    %ecx,%eax
  801c18:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801c1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c1e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801c21:	76 06                	jbe    801c29 <free+0x3e3>
  801c23:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801c26:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c29:	ff 45 d8             	incl   -0x28(%ebp)
  801c2c:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801c33:	7e a4                	jle    801bd9 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801c35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c38:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801c3d:	83 ec 08             	sub    $0x8,%esp
  801c40:	ff 75 f4             	pushl  -0xc(%ebp)
  801c43:	ff 75 d4             	pushl  -0x2c(%ebp)
  801c46:	e8 79 15 00 00       	call   8031c4 <sys_free_user_mem>
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	eb 01                	jmp    801c51 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801c50:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	83 ec 68             	sub    $0x68,%esp
  801c59:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5c:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c5f:	e8 a5 f7 ff ff       	call   801409 <uheap_init>
	if (size == 0) return NULL ;
  801c64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c68:	75 0a                	jne    801c74 <smalloc+0x21>
  801c6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6f:	e9 37 03 00 00       	jmp    801fab <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801c74:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c81:	01 d0                	add    %edx,%eax
  801c83:	48                   	dec    %eax
  801c84:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c87:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8f:	f7 75 dc             	divl   -0x24(%ebp)
  801c92:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c95:	29 d0                	sub    %edx,%eax
  801c97:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801c9a:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ca1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801ca8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801caf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801cb6:	e9 85 00 00 00       	jmp    801d40 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801cbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cbe:	89 d0                	mov    %edx,%eax
  801cc0:	01 c0                	add    %eax,%eax
  801cc2:	01 d0                	add    %edx,%eax
  801cc4:	c1 e0 02             	shl    $0x2,%eax
  801cc7:	05 48 10 81 00       	add    $0x811048,%eax
  801ccc:	8a 00                	mov    (%eax),%al
  801cce:	84 c0                	test   %al,%al
  801cd0:	74 20                	je     801cf2 <smalloc+0x9f>
  801cd2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cd5:	89 d0                	mov    %edx,%eax
  801cd7:	01 c0                	add    %eax,%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	c1 e0 02             	shl    $0x2,%eax
  801cde:	05 44 10 81 00       	add    $0x811044,%eax
  801ce3:	8b 00                	mov    (%eax),%eax
  801ce5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ce8:	75 08                	jne    801cf2 <smalloc+0x9f>
        {
            exactIdx = i;
  801cea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801cf0:	eb 5b                	jmp    801d4d <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801cf2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cf5:	89 d0                	mov    %edx,%eax
  801cf7:	01 c0                	add    %eax,%eax
  801cf9:	01 d0                	add    %edx,%eax
  801cfb:	c1 e0 02             	shl    $0x2,%eax
  801cfe:	05 48 10 81 00       	add    $0x811048,%eax
  801d03:	8a 00                	mov    (%eax),%al
  801d05:	84 c0                	test   %al,%al
  801d07:	74 34                	je     801d3d <smalloc+0xea>
  801d09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d0c:	89 d0                	mov    %edx,%eax
  801d0e:	01 c0                	add    %eax,%eax
  801d10:	01 d0                	add    %edx,%eax
  801d12:	c1 e0 02             	shl    $0x2,%eax
  801d15:	05 44 10 81 00       	add    $0x811044,%eax
  801d1a:	8b 00                	mov    (%eax),%eax
  801d1c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d1f:	76 1c                	jbe    801d3d <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801d21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d24:	89 d0                	mov    %edx,%eax
  801d26:	01 c0                	add    %eax,%eax
  801d28:	01 d0                	add    %edx,%eax
  801d2a:	c1 e0 02             	shl    $0x2,%eax
  801d2d:	05 44 10 81 00       	add    $0x811044,%eax
  801d32:	8b 00                	mov    (%eax),%eax
  801d34:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801d37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d3d:	ff 45 e8             	incl   -0x18(%ebp)
  801d40:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801d47:	0f 8e 6e ff ff ff    	jle    801cbb <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801d4d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801d54:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801d58:	74 7d                	je     801dd7 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801d5a:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d64:	89 d0                	mov    %edx,%eax
  801d66:	01 c0                	add    %eax,%eax
  801d68:	01 d0                	add    %edx,%eax
  801d6a:	c1 e0 02             	shl    $0x2,%eax
  801d6d:	05 40 10 81 00       	add    $0x811040,%eax
  801d72:	8b 10                	mov    (%eax),%edx
  801d74:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d77:	01 d0                	add    %edx,%eax
  801d79:	48                   	dec    %eax
  801d7a:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801d7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d80:	ba 00 00 00 00       	mov    $0x0,%edx
  801d85:	f7 75 bc             	divl   -0x44(%ebp)
  801d88:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d8b:	29 d0                	sub    %edx,%eax
  801d8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801d90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d93:	89 d0                	mov    %edx,%eax
  801d95:	01 c0                	add    %eax,%eax
  801d97:	01 d0                	add    %edx,%eax
  801d99:	c1 e0 02             	shl    $0x2,%eax
  801d9c:	05 48 10 81 00       	add    $0x811048,%eax
  801da1:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801da4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da7:	89 d0                	mov    %edx,%eax
  801da9:	01 c0                	add    %eax,%eax
  801dab:	01 d0                	add    %edx,%eax
  801dad:	c1 e0 02             	shl    $0x2,%eax
  801db0:	05 44 10 81 00       	add    $0x811044,%eax
  801db5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbe:	89 d0                	mov    %edx,%eax
  801dc0:	01 c0                	add    %eax,%eax
  801dc2:	01 d0                	add    %edx,%eax
  801dc4:	c1 e0 02             	shl    $0x2,%eax
  801dc7:	05 40 10 81 00       	add    $0x811040,%eax
  801dcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dd2:	e9 2d 01 00 00       	jmp    801f04 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801dd7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ddb:	0f 84 ce 00 00 00    	je     801eaf <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801de1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801de8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801deb:	89 d0                	mov    %edx,%eax
  801ded:	01 c0                	add    %eax,%eax
  801def:	01 d0                	add    %edx,%eax
  801df1:	c1 e0 02             	shl    $0x2,%eax
  801df4:	05 40 10 81 00       	add    $0x811040,%eax
  801df9:	8b 10                	mov    (%eax),%edx
  801dfb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801dfe:	01 d0                	add    %edx,%eax
  801e00:	48                   	dec    %eax
  801e01:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801e04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e07:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0c:	f7 75 c4             	divl   -0x3c(%ebp)
  801e0f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e12:	29 d0                	sub    %edx,%eax
  801e14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801e17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e1a:	89 d0                	mov    %edx,%eax
  801e1c:	01 c0                	add    %eax,%eax
  801e1e:	01 d0                	add    %edx,%eax
  801e20:	c1 e0 02             	shl    $0x2,%eax
  801e23:	05 44 10 81 00       	add    $0x811044,%eax
  801e28:	8b 00                	mov    (%eax),%eax
  801e2a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e2d:	75 47                	jne    801e76 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801e2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e32:	89 d0                	mov    %edx,%eax
  801e34:	01 c0                	add    %eax,%eax
  801e36:	01 d0                	add    %edx,%eax
  801e38:	c1 e0 02             	shl    $0x2,%eax
  801e3b:	05 48 10 81 00       	add    $0x811048,%eax
  801e40:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801e43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e46:	89 d0                	mov    %edx,%eax
  801e48:	01 c0                	add    %eax,%eax
  801e4a:	01 d0                	add    %edx,%eax
  801e4c:	c1 e0 02             	shl    $0x2,%eax
  801e4f:	05 44 10 81 00       	add    $0x811044,%eax
  801e54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801e5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e5d:	89 d0                	mov    %edx,%eax
  801e5f:	01 c0                	add    %eax,%eax
  801e61:	01 d0                	add    %edx,%eax
  801e63:	c1 e0 02             	shl    $0x2,%eax
  801e66:	05 40 10 81 00       	add    $0x811040,%eax
  801e6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e71:	e9 8e 00 00 00       	jmp    801f04 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801e76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e7c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801e7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e82:	89 d0                	mov    %edx,%eax
  801e84:	01 c0                	add    %eax,%eax
  801e86:	01 d0                	add    %edx,%eax
  801e88:	c1 e0 02             	shl    $0x2,%eax
  801e8b:	05 40 10 81 00       	add    $0x811040,%eax
  801e90:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801e92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e95:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801e98:	89 c2                	mov    %eax,%edx
  801e9a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e9d:	89 c8                	mov    %ecx,%eax
  801e9f:	01 c0                	add    %eax,%eax
  801ea1:	01 c8                	add    %ecx,%eax
  801ea3:	c1 e0 02             	shl    $0x2,%eax
  801ea6:	05 44 10 81 00       	add    $0x811044,%eax
  801eab:	89 10                	mov    %edx,(%eax)
  801ead:	eb 55                	jmp    801f04 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801eaf:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801eb6:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801ebc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ebf:	01 d0                	add    %edx,%eax
  801ec1:	48                   	dec    %eax
  801ec2:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801ec5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ec8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ecd:	f7 75 d0             	divl   -0x30(%ebp)
  801ed0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ed3:	29 d0                	sub    %edx,%eax
  801ed5:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801ed8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801edb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ede:	01 d0                	add    %edx,%eax
  801ee0:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801ee5:	76 0a                	jbe    801ef1 <smalloc+0x29e>
            return NULL;
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eec:	e9 ba 00 00 00       	jmp    801fab <smalloc+0x358>
        va = start;
  801ef1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ef4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801ef7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801efa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801efd:	01 d0                	add    %edx,%eax
  801eff:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f04:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f0b:	eb 5e                	jmp    801f6b <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  801f0d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f10:	89 d0                	mov    %edx,%eax
  801f12:	01 c0                	add    %eax,%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	c1 e0 02             	shl    $0x2,%eax
  801f19:	05 48 50 80 00       	add    $0x805048,%eax
  801f1e:	8a 00                	mov    (%eax),%al
  801f20:	84 c0                	test   %al,%al
  801f22:	75 44                	jne    801f68 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  801f24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f27:	89 d0                	mov    %edx,%eax
  801f29:	01 c0                	add    %eax,%eax
  801f2b:	01 d0                	add    %edx,%eax
  801f2d:	c1 e0 02             	shl    $0x2,%eax
  801f30:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f39:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801f3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f3e:	89 d0                	mov    %edx,%eax
  801f40:	01 c0                	add    %eax,%eax
  801f42:	01 d0                	add    %edx,%eax
  801f44:	c1 e0 02             	shl    $0x2,%eax
  801f47:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801f4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f50:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801f52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f55:	89 d0                	mov    %edx,%eax
  801f57:	01 c0                	add    %eax,%eax
  801f59:	01 d0                	add    %edx,%eax
  801f5b:	c1 e0 02             	shl    $0x2,%eax
  801f5e:	05 48 50 80 00       	add    $0x805048,%eax
  801f63:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801f66:	eb 0c                	jmp    801f74 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f68:	ff 45 e0             	incl   -0x20(%ebp)
  801f6b:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f72:	7e 99                	jle    801f0d <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  801f74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f77:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  801f7b:	52                   	push   %edx
  801f7c:	50                   	push   %eax
  801f7d:	ff 75 d4             	pushl  -0x2c(%ebp)
  801f80:	ff 75 08             	pushl  0x8(%ebp)
  801f83:	e8 de 0e 00 00       	call   802e66 <sys_create_shared_object>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  801f8e:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  801f92:	75 07                	jne    801f9b <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  801f94:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f99:	eb 10                	jmp    801fab <smalloc+0x358>
    if (r < 0)
  801f9b:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  801f9f:	79 07                	jns    801fa8 <smalloc+0x355>
        return NULL;
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa6:	eb 03                	jmp    801fab <smalloc+0x358>
    return (void*)va;
  801fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801fb3:	e8 51 f4 ff ff       	call   801409 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  801fb8:	83 ec 08             	sub    $0x8,%esp
  801fbb:	ff 75 0c             	pushl  0xc(%ebp)
  801fbe:	ff 75 08             	pushl  0x8(%ebp)
  801fc1:	e8 ca 0e 00 00       	call   802e90 <sys_size_of_shared_object>
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  801fcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fd0:	7f 0a                	jg     801fdc <sget+0x2f>
        return NULL;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd7:	e9 28 03 00 00       	jmp    802304 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  801fdc:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801fe3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801fe6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fe9:	01 d0                	add    %edx,%eax
  801feb:	48                   	dec    %eax
  801fec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801fef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ff2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff7:	f7 75 d8             	divl   -0x28(%ebp)
  801ffa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ffd:	29 d0                	sub    %edx,%eax
  801fff:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802002:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802009:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802010:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802017:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80201e:	e9 85 00 00 00       	jmp    8020a8 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802023:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802026:	89 d0                	mov    %edx,%eax
  802028:	01 c0                	add    %eax,%eax
  80202a:	01 d0                	add    %edx,%eax
  80202c:	c1 e0 02             	shl    $0x2,%eax
  80202f:	05 48 10 81 00       	add    $0x811048,%eax
  802034:	8a 00                	mov    (%eax),%al
  802036:	84 c0                	test   %al,%al
  802038:	74 20                	je     80205a <sget+0xad>
  80203a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80203d:	89 d0                	mov    %edx,%eax
  80203f:	01 c0                	add    %eax,%eax
  802041:	01 d0                	add    %edx,%eax
  802043:	c1 e0 02             	shl    $0x2,%eax
  802046:	05 44 10 81 00       	add    $0x811044,%eax
  80204b:	8b 00                	mov    (%eax),%eax
  80204d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802050:	75 08                	jne    80205a <sget+0xad>
        {
            exactIdx = i;
  802052:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802055:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802058:	eb 5b                	jmp    8020b5 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80205a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80205d:	89 d0                	mov    %edx,%eax
  80205f:	01 c0                	add    %eax,%eax
  802061:	01 d0                	add    %edx,%eax
  802063:	c1 e0 02             	shl    $0x2,%eax
  802066:	05 48 10 81 00       	add    $0x811048,%eax
  80206b:	8a 00                	mov    (%eax),%al
  80206d:	84 c0                	test   %al,%al
  80206f:	74 34                	je     8020a5 <sget+0xf8>
  802071:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802074:	89 d0                	mov    %edx,%eax
  802076:	01 c0                	add    %eax,%eax
  802078:	01 d0                	add    %edx,%eax
  80207a:	c1 e0 02             	shl    $0x2,%eax
  80207d:	05 44 10 81 00       	add    $0x811044,%eax
  802082:	8b 00                	mov    (%eax),%eax
  802084:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802087:	76 1c                	jbe    8020a5 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802089:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80208c:	89 d0                	mov    %edx,%eax
  80208e:	01 c0                	add    %eax,%eax
  802090:	01 d0                	add    %edx,%eax
  802092:	c1 e0 02             	shl    $0x2,%eax
  802095:	05 44 10 81 00       	add    $0x811044,%eax
  80209a:	8b 00                	mov    (%eax),%eax
  80209c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80209f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020a5:	ff 45 e8             	incl   -0x18(%ebp)
  8020a8:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8020af:	0f 8e 6e ff ff ff    	jle    802023 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8020b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8020bc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8020c0:	74 7d                	je     80213f <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8020c2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8020c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cc:	89 d0                	mov    %edx,%eax
  8020ce:	01 c0                	add    %eax,%eax
  8020d0:	01 d0                	add    %edx,%eax
  8020d2:	c1 e0 02             	shl    $0x2,%eax
  8020d5:	05 40 10 81 00       	add    $0x811040,%eax
  8020da:	8b 10                	mov    (%eax),%edx
  8020dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020df:	01 d0                	add    %edx,%eax
  8020e1:	48                   	dec    %eax
  8020e2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8020e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8020e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ed:	f7 75 b8             	divl   -0x48(%ebp)
  8020f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8020f3:	29 d0                	sub    %edx,%eax
  8020f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8020f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fb:	89 d0                	mov    %edx,%eax
  8020fd:	01 c0                	add    %eax,%eax
  8020ff:	01 d0                	add    %edx,%eax
  802101:	c1 e0 02             	shl    $0x2,%eax
  802104:	05 48 10 81 00       	add    $0x811048,%eax
  802109:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80210c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210f:	89 d0                	mov    %edx,%eax
  802111:	01 c0                	add    %eax,%eax
  802113:	01 d0                	add    %edx,%eax
  802115:	c1 e0 02             	shl    $0x2,%eax
  802118:	05 44 10 81 00       	add    $0x811044,%eax
  80211d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802123:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802126:	89 d0                	mov    %edx,%eax
  802128:	01 c0                	add    %eax,%eax
  80212a:	01 d0                	add    %edx,%eax
  80212c:	c1 e0 02             	shl    $0x2,%eax
  80212f:	05 40 10 81 00       	add    $0x811040,%eax
  802134:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80213a:	e9 2d 01 00 00       	jmp    80226c <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80213f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802143:	0f 84 ce 00 00 00    	je     802217 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802149:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802150:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802153:	89 d0                	mov    %edx,%eax
  802155:	01 c0                	add    %eax,%eax
  802157:	01 d0                	add    %edx,%eax
  802159:	c1 e0 02             	shl    $0x2,%eax
  80215c:	05 40 10 81 00       	add    $0x811040,%eax
  802161:	8b 10                	mov    (%eax),%edx
  802163:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802166:	01 d0                	add    %edx,%eax
  802168:	48                   	dec    %eax
  802169:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80216c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80216f:	ba 00 00 00 00       	mov    $0x0,%edx
  802174:	f7 75 c0             	divl   -0x40(%ebp)
  802177:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80217a:	29 d0                	sub    %edx,%eax
  80217c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80217f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802182:	89 d0                	mov    %edx,%eax
  802184:	01 c0                	add    %eax,%eax
  802186:	01 d0                	add    %edx,%eax
  802188:	c1 e0 02             	shl    $0x2,%eax
  80218b:	05 44 10 81 00       	add    $0x811044,%eax
  802190:	8b 00                	mov    (%eax),%eax
  802192:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802195:	75 47                	jne    8021de <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802197:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80219a:	89 d0                	mov    %edx,%eax
  80219c:	01 c0                	add    %eax,%eax
  80219e:	01 d0                	add    %edx,%eax
  8021a0:	c1 e0 02             	shl    $0x2,%eax
  8021a3:	05 48 10 81 00       	add    $0x811048,%eax
  8021a8:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8021ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ae:	89 d0                	mov    %edx,%eax
  8021b0:	01 c0                	add    %eax,%eax
  8021b2:	01 d0                	add    %edx,%eax
  8021b4:	c1 e0 02             	shl    $0x2,%eax
  8021b7:	05 44 10 81 00       	add    $0x811044,%eax
  8021bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8021c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c5:	89 d0                	mov    %edx,%eax
  8021c7:	01 c0                	add    %eax,%eax
  8021c9:	01 d0                	add    %edx,%eax
  8021cb:	c1 e0 02             	shl    $0x2,%eax
  8021ce:	05 40 10 81 00       	add    $0x811040,%eax
  8021d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d9:	e9 8e 00 00 00       	jmp    80226c <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8021de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021e4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8021e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ea:	89 d0                	mov    %edx,%eax
  8021ec:	01 c0                	add    %eax,%eax
  8021ee:	01 d0                	add    %edx,%eax
  8021f0:	c1 e0 02             	shl    $0x2,%eax
  8021f3:	05 40 10 81 00       	add    $0x811040,%eax
  8021f8:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8021fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fd:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802200:	89 c2                	mov    %eax,%edx
  802202:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802205:	89 c8                	mov    %ecx,%eax
  802207:	01 c0                	add    %eax,%eax
  802209:	01 c8                	add    %ecx,%eax
  80220b:	c1 e0 02             	shl    $0x2,%eax
  80220e:	05 44 10 81 00       	add    $0x811044,%eax
  802213:	89 10                	mov    %edx,(%eax)
  802215:	eb 55                	jmp    80226c <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802217:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80221e:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802224:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802227:	01 d0                	add    %edx,%eax
  802229:	48                   	dec    %eax
  80222a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80222d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802230:	ba 00 00 00 00       	mov    $0x0,%edx
  802235:	f7 75 cc             	divl   -0x34(%ebp)
  802238:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80223b:	29 d0                	sub    %edx,%eax
  80223d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802240:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802243:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802246:	01 d0                	add    %edx,%eax
  802248:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80224d:	76 0a                	jbe    802259 <sget+0x2ac>
            return NULL;
  80224f:	b8 00 00 00 00       	mov    $0x0,%eax
  802254:	e9 ab 00 00 00       	jmp    802304 <sget+0x357>
        va = start;
  802259:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80225c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80225f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802262:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802265:	01 d0                	add    %edx,%eax
  802267:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80226c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802273:	eb 5e                	jmp    8022d3 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802275:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802278:	89 d0                	mov    %edx,%eax
  80227a:	01 c0                	add    %eax,%eax
  80227c:	01 d0                	add    %edx,%eax
  80227e:	c1 e0 02             	shl    $0x2,%eax
  802281:	05 48 50 80 00       	add    $0x805048,%eax
  802286:	8a 00                	mov    (%eax),%al
  802288:	84 c0                	test   %al,%al
  80228a:	75 44                	jne    8022d0 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80228c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80228f:	89 d0                	mov    %edx,%eax
  802291:	01 c0                	add    %eax,%eax
  802293:	01 d0                	add    %edx,%eax
  802295:	c1 e0 02             	shl    $0x2,%eax
  802298:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80229e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a1:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8022a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022a6:	89 d0                	mov    %edx,%eax
  8022a8:	01 c0                	add    %eax,%eax
  8022aa:	01 d0                	add    %edx,%eax
  8022ac:	c1 e0 02             	shl    $0x2,%eax
  8022af:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8022b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022b8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8022ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022bd:	89 d0                	mov    %edx,%eax
  8022bf:	01 c0                	add    %eax,%eax
  8022c1:	01 d0                	add    %edx,%eax
  8022c3:	c1 e0 02             	shl    $0x2,%eax
  8022c6:	05 48 50 80 00       	add    $0x805048,%eax
  8022cb:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8022ce:	eb 0c                	jmp    8022dc <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022d0:	ff 45 e0             	incl   -0x20(%ebp)
  8022d3:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8022da:	7e 99                	jle    802275 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8022dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022df:	83 ec 04             	sub    $0x4,%esp
  8022e2:	50                   	push   %eax
  8022e3:	ff 75 0c             	pushl  0xc(%ebp)
  8022e6:	ff 75 08             	pushl  0x8(%ebp)
  8022e9:	e8 bf 0b 00 00       	call   802ead <sys_get_shared_object>
  8022ee:	83 c4 10             	add    $0x10,%esp
  8022f1:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8022f4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022f8:	79 07                	jns    802301 <sget+0x354>
        return NULL;
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ff:	eb 03                	jmp    802304 <sget+0x357>
    return (void*)va;
  802301:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80230c:	e8 f8 f0 ff ff       	call   801409 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802315:	75 13                	jne    80232a <realloc+0x24>
		return malloc(new_size);
  802317:	83 ec 0c             	sub    $0xc,%esp
  80231a:	ff 75 0c             	pushl  0xc(%ebp)
  80231d:	e8 c4 f1 ff ff       	call   8014e6 <malloc>
  802322:	83 c4 10             	add    $0x10,%esp
  802325:	e9 f4 05 00 00       	jmp    80291e <realloc+0x618>
	if (new_size == 0)
  80232a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80232e:	75 18                	jne    802348 <realloc+0x42>
	{
		free(virtual_address);
  802330:	83 ec 0c             	sub    $0xc,%esp
  802333:	ff 75 08             	pushl  0x8(%ebp)
  802336:	e8 0b f5 ff ff       	call   801846 <free>
  80233b:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
  802343:	e9 d6 05 00 00       	jmp    80291e <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80234e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802351:	85 c0                	test   %eax,%eax
  802353:	79 74                	jns    8023c9 <realloc+0xc3>
  802355:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  80235c:	77 6b                	ja     8023c9 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  80235e:	83 ec 0c             	sub    $0xc,%esp
  802361:	ff 75 0c             	pushl  0xc(%ebp)
  802364:	e8 7d f1 ff ff       	call   8014e6 <malloc>
  802369:	83 c4 10             	add    $0x10,%esp
  80236c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80236f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802373:	75 0a                	jne    80237f <realloc+0x79>
			return NULL;
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	e9 9f 05 00 00       	jmp    80291e <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  80237f:	83 ec 0c             	sub    $0xc,%esp
  802382:	ff 75 08             	pushl  0x8(%ebp)
  802385:	e8 e0 11 00 00       	call   80356a <get_block_size>
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802390:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802393:	8b 45 0c             	mov    0xc(%ebp),%eax
  802396:	39 d0                	cmp    %edx,%eax
  802398:	76 02                	jbe    80239c <realloc+0x96>
  80239a:	89 d0                	mov    %edx,%eax
  80239c:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  80239f:	83 ec 04             	sub    $0x4,%esp
  8023a2:	ff 75 c0             	pushl  -0x40(%ebp)
  8023a5:	ff 75 08             	pushl  0x8(%ebp)
  8023a8:	ff 75 c8             	pushl  -0x38(%ebp)
  8023ab:	e8 56 eb ff ff       	call   800f06 <memmove>
  8023b0:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8023b3:	83 ec 0c             	sub    $0xc,%esp
  8023b6:	ff 75 08             	pushl  0x8(%ebp)
  8023b9:	e8 88 f4 ff ff       	call   801846 <free>
  8023be:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8023c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023c4:	e9 55 05 00 00       	jmp    80291e <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8023c9:	a1 30 51 83 00       	mov    0x835130,%eax
  8023ce:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8023d1:	72 09                	jb     8023dc <realloc+0xd6>
  8023d3:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8023da:	76 0a                	jbe    8023e6 <realloc+0xe0>
		return NULL;
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e1:	e9 38 05 00 00       	jmp    80291e <realloc+0x618>
	uint32 oldsz = 0;
  8023e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8023ed:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8023f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8023fb:	eb 50                	jmp    80244d <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8023fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802400:	89 d0                	mov    %edx,%eax
  802402:	01 c0                	add    %eax,%eax
  802404:	01 d0                	add    %edx,%eax
  802406:	c1 e0 02             	shl    $0x2,%eax
  802409:	05 48 50 80 00       	add    $0x805048,%eax
  80240e:	8a 00                	mov    (%eax),%al
  802410:	84 c0                	test   %al,%al
  802412:	74 36                	je     80244a <realloc+0x144>
  802414:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802417:	89 d0                	mov    %edx,%eax
  802419:	01 c0                	add    %eax,%eax
  80241b:	01 d0                	add    %edx,%eax
  80241d:	c1 e0 02             	shl    $0x2,%eax
  802420:	05 40 50 80 00       	add    $0x805040,%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80242a:	75 1e                	jne    80244a <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  80242c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80242f:	89 d0                	mov    %edx,%eax
  802431:	01 c0                	add    %eax,%eax
  802433:	01 d0                	add    %edx,%eax
  802435:	c1 e0 02             	shl    $0x2,%eax
  802438:	05 44 50 80 00       	add    $0x805044,%eax
  80243d:	8b 00                	mov    (%eax),%eax
  80243f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802445:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802448:	eb 0c                	jmp    802456 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80244a:	ff 45 ec             	incl   -0x14(%ebp)
  80244d:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802454:	7e a7                	jle    8023fd <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802456:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80245a:	75 0a                	jne    802466 <realloc+0x160>
		return NULL;
  80245c:	b8 00 00 00 00       	mov    $0x0,%eax
  802461:	e9 b8 04 00 00       	jmp    80291e <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802466:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80246d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802470:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802473:	01 d0                	add    %edx,%eax
  802475:	48                   	dec    %eax
  802476:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802479:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80247c:	ba 00 00 00 00       	mov    $0x0,%edx
  802481:	f7 75 bc             	divl   -0x44(%ebp)
  802484:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802487:	29 d0                	sub    %edx,%eax
  802489:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  80248c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80248f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802492:	75 08                	jne    80249c <realloc+0x196>
		return virtual_address;
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	e9 82 04 00 00       	jmp    80291e <realloc+0x618>
	if (req < oldsz)
  80249c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80249f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024a2:	0f 83 cd 02 00 00    	jae    802775 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8024ae:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8024b1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8024b4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8024b7:	01 d0                	add    %edx,%eax
  8024b9:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8024bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024bf:	89 d0                	mov    %edx,%eax
  8024c1:	01 c0                	add    %eax,%eax
  8024c3:	01 d0                	add    %edx,%eax
  8024c5:	c1 e0 02             	shl    $0x2,%eax
  8024c8:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8024ce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8024d1:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8024d3:	83 ec 08             	sub    $0x8,%esp
  8024d6:	ff 75 b0             	pushl  -0x50(%ebp)
  8024d9:	ff 75 ac             	pushl  -0x54(%ebp)
  8024dc:	e8 e3 0c 00 00       	call   8031c4 <sys_free_user_mem>
  8024e1:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8024e4:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8024eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8024f2:	eb 64                	jmp    802558 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8024f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024f7:	89 d0                	mov    %edx,%eax
  8024f9:	01 c0                	add    %eax,%eax
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	c1 e0 02             	shl    $0x2,%eax
  802500:	05 48 10 81 00       	add    $0x811048,%eax
  802505:	8a 00                	mov    (%eax),%al
  802507:	84 c0                	test   %al,%al
  802509:	75 4a                	jne    802555 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  80250b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80250e:	89 d0                	mov    %edx,%eax
  802510:	01 c0                	add    %eax,%eax
  802512:	01 d0                	add    %edx,%eax
  802514:	c1 e0 02             	shl    $0x2,%eax
  802517:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  80251d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802520:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802522:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802525:	89 d0                	mov    %edx,%eax
  802527:	01 c0                	add    %eax,%eax
  802529:	01 d0                	add    %edx,%eax
  80252b:	c1 e0 02             	shl    $0x2,%eax
  80252e:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802534:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802537:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802539:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80253c:	89 d0                	mov    %edx,%eax
  80253e:	01 c0                	add    %eax,%eax
  802540:	01 d0                	add    %edx,%eax
  802542:	c1 e0 02             	shl    $0x2,%eax
  802545:	05 48 10 81 00       	add    $0x811048,%eax
  80254a:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  80254d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802550:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802553:	eb 0c                	jmp    802561 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802555:	ff 45 e4             	incl   -0x1c(%ebp)
  802558:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80255f:	7e 93                	jle    8024f4 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802561:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802565:	0f 84 8d 01 00 00    	je     8026f8 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80256b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802572:	e9 74 01 00 00       	jmp    8026eb <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80257d:	0f 84 64 01 00 00    	je     8026e7 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802583:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802586:	89 d0                	mov    %edx,%eax
  802588:	01 c0                	add    %eax,%eax
  80258a:	01 d0                	add    %edx,%eax
  80258c:	c1 e0 02             	shl    $0x2,%eax
  80258f:	05 48 10 81 00       	add    $0x811048,%eax
  802594:	8a 00                	mov    (%eax),%al
  802596:	84 c0                	test   %al,%al
  802598:	0f 84 4a 01 00 00    	je     8026e8 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80259e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025a1:	89 d0                	mov    %edx,%eax
  8025a3:	01 c0                	add    %eax,%eax
  8025a5:	01 d0                	add    %edx,%eax
  8025a7:	c1 e0 02             	shl    $0x2,%eax
  8025aa:	05 40 10 81 00       	add    $0x811040,%eax
  8025af:	8b 08                	mov    (%eax),%ecx
  8025b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025b4:	89 d0                	mov    %edx,%eax
  8025b6:	01 c0                	add    %eax,%eax
  8025b8:	01 d0                	add    %edx,%eax
  8025ba:	c1 e0 02             	shl    $0x2,%eax
  8025bd:	05 44 10 81 00       	add    $0x811044,%eax
  8025c2:	8b 00                	mov    (%eax),%eax
  8025c4:	01 c1                	add    %eax,%ecx
  8025c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025c9:	89 d0                	mov    %edx,%eax
  8025cb:	01 c0                	add    %eax,%eax
  8025cd:	01 d0                	add    %edx,%eax
  8025cf:	c1 e0 02             	shl    $0x2,%eax
  8025d2:	05 40 10 81 00       	add    $0x811040,%eax
  8025d7:	8b 00                	mov    (%eax),%eax
  8025d9:	39 c1                	cmp    %eax,%ecx
  8025db:	75 7a                	jne    802657 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8025dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025e0:	89 d0                	mov    %edx,%eax
  8025e2:	01 c0                	add    %eax,%eax
  8025e4:	01 d0                	add    %edx,%eax
  8025e6:	c1 e0 02             	shl    $0x2,%eax
  8025e9:	05 40 10 81 00       	add    $0x811040,%eax
  8025ee:	8b 10                	mov    (%eax),%edx
  8025f0:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8025f3:	89 c8                	mov    %ecx,%eax
  8025f5:	01 c0                	add    %eax,%eax
  8025f7:	01 c8                	add    %ecx,%eax
  8025f9:	c1 e0 02             	shl    $0x2,%eax
  8025fc:	05 40 10 81 00       	add    $0x811040,%eax
  802601:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802603:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802606:	89 d0                	mov    %edx,%eax
  802608:	01 c0                	add    %eax,%eax
  80260a:	01 d0                	add    %edx,%eax
  80260c:	c1 e0 02             	shl    $0x2,%eax
  80260f:	05 44 10 81 00       	add    $0x811044,%eax
  802614:	8b 08                	mov    (%eax),%ecx
  802616:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802619:	89 d0                	mov    %edx,%eax
  80261b:	01 c0                	add    %eax,%eax
  80261d:	01 d0                	add    %edx,%eax
  80261f:	c1 e0 02             	shl    $0x2,%eax
  802622:	05 44 10 81 00       	add    $0x811044,%eax
  802627:	8b 00                	mov    (%eax),%eax
  802629:	01 c1                	add    %eax,%ecx
  80262b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80262e:	89 d0                	mov    %edx,%eax
  802630:	01 c0                	add    %eax,%eax
  802632:	01 d0                	add    %edx,%eax
  802634:	c1 e0 02             	shl    $0x2,%eax
  802637:	05 44 10 81 00       	add    $0x811044,%eax
  80263c:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80263e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802641:	89 d0                	mov    %edx,%eax
  802643:	01 c0                	add    %eax,%eax
  802645:	01 d0                	add    %edx,%eax
  802647:	c1 e0 02             	shl    $0x2,%eax
  80264a:	05 48 10 81 00       	add    $0x811048,%eax
  80264f:	c6 00 00             	movb   $0x0,(%eax)
  802652:	e9 91 00 00 00       	jmp    8026e8 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802657:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80265a:	89 d0                	mov    %edx,%eax
  80265c:	01 c0                	add    %eax,%eax
  80265e:	01 d0                	add    %edx,%eax
  802660:	c1 e0 02             	shl    $0x2,%eax
  802663:	05 40 10 81 00       	add    $0x811040,%eax
  802668:	8b 08                	mov    (%eax),%ecx
  80266a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80266d:	89 d0                	mov    %edx,%eax
  80266f:	01 c0                	add    %eax,%eax
  802671:	01 d0                	add    %edx,%eax
  802673:	c1 e0 02             	shl    $0x2,%eax
  802676:	05 44 10 81 00       	add    $0x811044,%eax
  80267b:	8b 00                	mov    (%eax),%eax
  80267d:	01 c1                	add    %eax,%ecx
  80267f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802682:	89 d0                	mov    %edx,%eax
  802684:	01 c0                	add    %eax,%eax
  802686:	01 d0                	add    %edx,%eax
  802688:	c1 e0 02             	shl    $0x2,%eax
  80268b:	05 40 10 81 00       	add    $0x811040,%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	39 c1                	cmp    %eax,%ecx
  802694:	75 52                	jne    8026e8 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802696:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802699:	89 d0                	mov    %edx,%eax
  80269b:	01 c0                	add    %eax,%eax
  80269d:	01 d0                	add    %edx,%eax
  80269f:	c1 e0 02             	shl    $0x2,%eax
  8026a2:	05 44 10 81 00       	add    $0x811044,%eax
  8026a7:	8b 08                	mov    (%eax),%ecx
  8026a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ac:	89 d0                	mov    %edx,%eax
  8026ae:	01 c0                	add    %eax,%eax
  8026b0:	01 d0                	add    %edx,%eax
  8026b2:	c1 e0 02             	shl    $0x2,%eax
  8026b5:	05 44 10 81 00       	add    $0x811044,%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	01 c1                	add    %eax,%ecx
  8026be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026c1:	89 d0                	mov    %edx,%eax
  8026c3:	01 c0                	add    %eax,%eax
  8026c5:	01 d0                	add    %edx,%eax
  8026c7:	c1 e0 02             	shl    $0x2,%eax
  8026ca:	05 44 10 81 00       	add    $0x811044,%eax
  8026cf:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8026d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026d4:	89 d0                	mov    %edx,%eax
  8026d6:	01 c0                	add    %eax,%eax
  8026d8:	01 d0                	add    %edx,%eax
  8026da:	c1 e0 02             	shl    $0x2,%eax
  8026dd:	05 48 10 81 00       	add    $0x811048,%eax
  8026e2:	c6 00 00             	movb   $0x0,(%eax)
  8026e5:	eb 01                	jmp    8026e8 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  8026e7:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8026e8:	ff 45 e0             	incl   -0x20(%ebp)
  8026eb:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8026f2:	0f 8e 7f fe ff ff    	jle    802577 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  8026f8:	a1 30 51 83 00       	mov    0x835130,%eax
  8026fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802700:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802707:	eb 53                	jmp    80275c <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802709:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80270c:	89 d0                	mov    %edx,%eax
  80270e:	01 c0                	add    %eax,%eax
  802710:	01 d0                	add    %edx,%eax
  802712:	c1 e0 02             	shl    $0x2,%eax
  802715:	05 48 50 80 00       	add    $0x805048,%eax
  80271a:	8a 00                	mov    (%eax),%al
  80271c:	84 c0                	test   %al,%al
  80271e:	74 39                	je     802759 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802720:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802723:	89 d0                	mov    %edx,%eax
  802725:	01 c0                	add    %eax,%eax
  802727:	01 d0                	add    %edx,%eax
  802729:	c1 e0 02             	shl    $0x2,%eax
  80272c:	05 40 50 80 00       	add    $0x805040,%eax
  802731:	8b 08                	mov    (%eax),%ecx
  802733:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802736:	89 d0                	mov    %edx,%eax
  802738:	01 c0                	add    %eax,%eax
  80273a:	01 d0                	add    %edx,%eax
  80273c:	c1 e0 02             	shl    $0x2,%eax
  80273f:	05 44 50 80 00       	add    $0x805044,%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	01 c8                	add    %ecx,%eax
  802748:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  80274b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80274e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802751:	76 06                	jbe    802759 <realloc+0x453>
  802753:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802756:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802759:	ff 45 d8             	incl   -0x28(%ebp)
  80275c:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802763:	7e a4                	jle    802709 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802765:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802768:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  80276d:	8b 45 08             	mov    0x8(%ebp),%eax
  802770:	e9 a9 01 00 00       	jmp    80291e <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802775:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	01 d0                	add    %edx,%eax
  80277d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802780:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802787:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80278e:	eb 57                	jmp    8027e7 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802790:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802793:	89 d0                	mov    %edx,%eax
  802795:	01 c0                	add    %eax,%eax
  802797:	01 d0                	add    %edx,%eax
  802799:	c1 e0 02             	shl    $0x2,%eax
  80279c:	05 48 10 81 00       	add    $0x811048,%eax
  8027a1:	8a 00                	mov    (%eax),%al
  8027a3:	84 c0                	test   %al,%al
  8027a5:	74 3d                	je     8027e4 <realloc+0x4de>
  8027a7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8027aa:	89 d0                	mov    %edx,%eax
  8027ac:	01 c0                	add    %eax,%eax
  8027ae:	01 d0                	add    %edx,%eax
  8027b0:	c1 e0 02             	shl    $0x2,%eax
  8027b3:	05 40 10 81 00       	add    $0x811040,%eax
  8027b8:	8b 00                	mov    (%eax),%eax
  8027ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027bd:	75 25                	jne    8027e4 <realloc+0x4de>
  8027bf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8027c2:	89 d0                	mov    %edx,%eax
  8027c4:	01 c0                	add    %eax,%eax
  8027c6:	01 d0                	add    %edx,%eax
  8027c8:	c1 e0 02             	shl    $0x2,%eax
  8027cb:	05 44 10 81 00       	add    $0x811044,%eax
  8027d0:	8b 10                	mov    (%eax),%edx
  8027d2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027d5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8027d8:	39 c2                	cmp    %eax,%edx
  8027da:	72 08                	jb     8027e4 <realloc+0x4de>
		{
			adjIdx = j; break;
  8027dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027e2:	eb 0c                	jmp    8027f0 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8027e4:	ff 45 d0             	incl   -0x30(%ebp)
  8027e7:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  8027ee:	7e a0                	jle    802790 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  8027f0:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  8027f4:	0f 84 d6 00 00 00    	je     8028d0 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  8027fa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027fd:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802800:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802803:	83 ec 08             	sub    $0x8,%esp
  802806:	ff 75 a0             	pushl  -0x60(%ebp)
  802809:	ff 75 a4             	pushl  -0x5c(%ebp)
  80280c:	e8 cf 09 00 00       	call   8031e0 <sys_allocate_user_mem>
  802811:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802814:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802817:	89 d0                	mov    %edx,%eax
  802819:	01 c0                	add    %eax,%eax
  80281b:	01 d0                	add    %edx,%eax
  80281d:	c1 e0 02             	shl    $0x2,%eax
  802820:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802826:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802829:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  80282b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80282e:	89 d0                	mov    %edx,%eax
  802830:	01 c0                	add    %eax,%eax
  802832:	01 d0                	add    %edx,%eax
  802834:	c1 e0 02             	shl    $0x2,%eax
  802837:	05 40 10 81 00       	add    $0x811040,%eax
  80283c:	8b 10                	mov    (%eax),%edx
  80283e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802841:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802844:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802847:	89 d0                	mov    %edx,%eax
  802849:	01 c0                	add    %eax,%eax
  80284b:	01 d0                	add    %edx,%eax
  80284d:	c1 e0 02             	shl    $0x2,%eax
  802850:	05 40 10 81 00       	add    $0x811040,%eax
  802855:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802857:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80285a:	89 d0                	mov    %edx,%eax
  80285c:	01 c0                	add    %eax,%eax
  80285e:	01 d0                	add    %edx,%eax
  802860:	c1 e0 02             	shl    $0x2,%eax
  802863:	05 44 10 81 00       	add    $0x811044,%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	2b 45 a0             	sub    -0x60(%ebp),%eax
  80286d:	89 c2                	mov    %eax,%edx
  80286f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802872:	89 c8                	mov    %ecx,%eax
  802874:	01 c0                	add    %eax,%eax
  802876:	01 c8                	add    %ecx,%eax
  802878:	c1 e0 02             	shl    $0x2,%eax
  80287b:	05 44 10 81 00       	add    $0x811044,%eax
  802880:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802882:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802885:	89 d0                	mov    %edx,%eax
  802887:	01 c0                	add    %eax,%eax
  802889:	01 d0                	add    %edx,%eax
  80288b:	c1 e0 02             	shl    $0x2,%eax
  80288e:	05 44 10 81 00       	add    $0x811044,%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	75 14                	jne    8028ad <realloc+0x5a7>
  802899:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80289c:	89 d0                	mov    %edx,%eax
  80289e:	01 c0                	add    %eax,%eax
  8028a0:	01 d0                	add    %edx,%eax
  8028a2:	c1 e0 02             	shl    $0x2,%eax
  8028a5:	05 48 10 81 00       	add    $0x811048,%eax
  8028aa:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  8028ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028b0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028b3:	01 c2                	add    %eax,%edx
  8028b5:	a1 88 50 83 00       	mov    0x835088,%eax
  8028ba:	39 c2                	cmp    %eax,%edx
  8028bc:	76 0d                	jbe    8028cb <realloc+0x5c5>
  8028be:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028c1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028c4:	01 d0                	add    %edx,%eax
  8028c6:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ce:	eb 4e                	jmp    80291e <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  8028d0:	83 ec 0c             	sub    $0xc,%esp
  8028d3:	ff 75 0c             	pushl  0xc(%ebp)
  8028d6:	e8 0b ec ff ff       	call   8014e6 <malloc>
  8028db:	83 c4 10             	add    $0x10,%esp
  8028de:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  8028e1:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8028e5:	75 07                	jne    8028ee <realloc+0x5e8>
		return NULL;
  8028e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ec:	eb 30                	jmp    80291e <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  8028ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028f4:	39 d0                	cmp    %edx,%eax
  8028f6:	76 02                	jbe    8028fa <realloc+0x5f4>
  8028f8:	89 d0                	mov    %edx,%eax
  8028fa:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8028fd:	83 ec 04             	sub    $0x4,%esp
  802900:	50                   	push   %eax
  802901:	52                   	push   %edx
  802902:	ff 75 cc             	pushl  -0x34(%ebp)
  802905:	e8 cf 06 00 00       	call   802fd9 <sys_move_user_mem>
  80290a:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  80290d:	83 ec 0c             	sub    $0xc,%esp
  802910:	ff 75 08             	pushl  0x8(%ebp)
  802913:	e8 2e ef ff ff       	call   801846 <free>
  802918:	83 c4 10             	add    $0x10,%esp
	return newptr;
  80291b:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  80292c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802930:	0f 84 33 03 00 00    	je     802c69 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802936:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802939:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  80293e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802941:	83 ec 08             	sub    $0x8,%esp
  802944:	ff 75 08             	pushl  0x8(%ebp)
  802947:	ff 75 d8             	pushl  -0x28(%ebp)
  80294a:	e8 7d 05 00 00       	call   802ecc <sys_delete_shared_object>
  80294f:	83 c4 10             	add    $0x10,%esp
  802952:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802955:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802959:	0f 88 0d 03 00 00    	js     802c6c <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80295f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802966:	e9 ef 02 00 00       	jmp    802c5a <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80296b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296e:	89 d0                	mov    %edx,%eax
  802970:	01 c0                	add    %eax,%eax
  802972:	01 d0                	add    %edx,%eax
  802974:	c1 e0 02             	shl    $0x2,%eax
  802977:	05 48 50 80 00       	add    $0x805048,%eax
  80297c:	8a 00                	mov    (%eax),%al
  80297e:	84 c0                	test   %al,%al
  802980:	0f 84 d1 02 00 00    	je     802c57 <sfree+0x337>
  802986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802989:	89 d0                	mov    %edx,%eax
  80298b:	01 c0                	add    %eax,%eax
  80298d:	01 d0                	add    %edx,%eax
  80298f:	c1 e0 02             	shl    $0x2,%eax
  802992:	05 40 50 80 00       	add    $0x805040,%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80299c:	0f 85 b5 02 00 00    	jne    802c57 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  8029a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a5:	89 d0                	mov    %edx,%eax
  8029a7:	01 c0                	add    %eax,%eax
  8029a9:	01 d0                	add    %edx,%eax
  8029ab:	c1 e0 02             	shl    $0x2,%eax
  8029ae:	05 44 50 80 00       	add    $0x805044,%eax
  8029b3:	8b 00                	mov    (%eax),%eax
  8029b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  8029b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bb:	89 d0                	mov    %edx,%eax
  8029bd:	01 c0                	add    %eax,%eax
  8029bf:	01 d0                	add    %edx,%eax
  8029c1:	c1 e0 02             	shl    $0x2,%eax
  8029c4:	05 48 50 80 00       	add    $0x805048,%eax
  8029c9:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  8029cc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8029da:	eb 64                	jmp    802a40 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  8029dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029df:	89 d0                	mov    %edx,%eax
  8029e1:	01 c0                	add    %eax,%eax
  8029e3:	01 d0                	add    %edx,%eax
  8029e5:	c1 e0 02             	shl    $0x2,%eax
  8029e8:	05 48 10 81 00       	add    $0x811048,%eax
  8029ed:	8a 00                	mov    (%eax),%al
  8029ef:	84 c0                	test   %al,%al
  8029f1:	75 4a                	jne    802a3d <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  8029f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f6:	89 d0                	mov    %edx,%eax
  8029f8:	01 c0                	add    %eax,%eax
  8029fa:	01 d0                	add    %edx,%eax
  8029fc:	c1 e0 02             	shl    $0x2,%eax
  8029ff:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802a05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a08:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802a0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a0d:	89 d0                	mov    %edx,%eax
  802a0f:	01 c0                	add    %eax,%eax
  802a11:	01 d0                	add    %edx,%eax
  802a13:	c1 e0 02             	shl    $0x2,%eax
  802a16:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802a1c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a1f:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802a21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a24:	89 d0                	mov    %edx,%eax
  802a26:	01 c0                	add    %eax,%eax
  802a28:	01 d0                	add    %edx,%eax
  802a2a:	c1 e0 02             	shl    $0x2,%eax
  802a2d:	05 48 10 81 00       	add    $0x811048,%eax
  802a32:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802a3b:	eb 0c                	jmp    802a49 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a3d:	ff 45 ec             	incl   -0x14(%ebp)
  802a40:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802a47:	7e 93                	jle    8029dc <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802a49:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802a4d:	0f 84 8d 01 00 00    	je     802be0 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802a53:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802a5a:	e9 74 01 00 00       	jmp    802bd3 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a62:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a65:	0f 84 64 01 00 00    	je     802bcf <sfree+0x2af>
					if (uhp_frees[k].free)
  802a6b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a6e:	89 d0                	mov    %edx,%eax
  802a70:	01 c0                	add    %eax,%eax
  802a72:	01 d0                	add    %edx,%eax
  802a74:	c1 e0 02             	shl    $0x2,%eax
  802a77:	05 48 10 81 00       	add    $0x811048,%eax
  802a7c:	8a 00                	mov    (%eax),%al
  802a7e:	84 c0                	test   %al,%al
  802a80:	0f 84 4a 01 00 00    	je     802bd0 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802a86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a89:	89 d0                	mov    %edx,%eax
  802a8b:	01 c0                	add    %eax,%eax
  802a8d:	01 d0                	add    %edx,%eax
  802a8f:	c1 e0 02             	shl    $0x2,%eax
  802a92:	05 40 10 81 00       	add    $0x811040,%eax
  802a97:	8b 08                	mov    (%eax),%ecx
  802a99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a9c:	89 d0                	mov    %edx,%eax
  802a9e:	01 c0                	add    %eax,%eax
  802aa0:	01 d0                	add    %edx,%eax
  802aa2:	c1 e0 02             	shl    $0x2,%eax
  802aa5:	05 44 10 81 00       	add    $0x811044,%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	01 c1                	add    %eax,%ecx
  802aae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab1:	89 d0                	mov    %edx,%eax
  802ab3:	01 c0                	add    %eax,%eax
  802ab5:	01 d0                	add    %edx,%eax
  802ab7:	c1 e0 02             	shl    $0x2,%eax
  802aba:	05 40 10 81 00       	add    $0x811040,%eax
  802abf:	8b 00                	mov    (%eax),%eax
  802ac1:	39 c1                	cmp    %eax,%ecx
  802ac3:	75 7a                	jne    802b3f <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802ac5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ac8:	89 d0                	mov    %edx,%eax
  802aca:	01 c0                	add    %eax,%eax
  802acc:	01 d0                	add    %edx,%eax
  802ace:	c1 e0 02             	shl    $0x2,%eax
  802ad1:	05 40 10 81 00       	add    $0x811040,%eax
  802ad6:	8b 10                	mov    (%eax),%edx
  802ad8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802adb:	89 c8                	mov    %ecx,%eax
  802add:	01 c0                	add    %eax,%eax
  802adf:	01 c8                	add    %ecx,%eax
  802ae1:	c1 e0 02             	shl    $0x2,%eax
  802ae4:	05 40 10 81 00       	add    $0x811040,%eax
  802ae9:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802aeb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aee:	89 d0                	mov    %edx,%eax
  802af0:	01 c0                	add    %eax,%eax
  802af2:	01 d0                	add    %edx,%eax
  802af4:	c1 e0 02             	shl    $0x2,%eax
  802af7:	05 44 10 81 00       	add    $0x811044,%eax
  802afc:	8b 08                	mov    (%eax),%ecx
  802afe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b01:	89 d0                	mov    %edx,%eax
  802b03:	01 c0                	add    %eax,%eax
  802b05:	01 d0                	add    %edx,%eax
  802b07:	c1 e0 02             	shl    $0x2,%eax
  802b0a:	05 44 10 81 00       	add    $0x811044,%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	01 c1                	add    %eax,%ecx
  802b13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b16:	89 d0                	mov    %edx,%eax
  802b18:	01 c0                	add    %eax,%eax
  802b1a:	01 d0                	add    %edx,%eax
  802b1c:	c1 e0 02             	shl    $0x2,%eax
  802b1f:	05 44 10 81 00       	add    $0x811044,%eax
  802b24:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802b26:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b29:	89 d0                	mov    %edx,%eax
  802b2b:	01 c0                	add    %eax,%eax
  802b2d:	01 d0                	add    %edx,%eax
  802b2f:	c1 e0 02             	shl    $0x2,%eax
  802b32:	05 48 10 81 00       	add    $0x811048,%eax
  802b37:	c6 00 00             	movb   $0x0,(%eax)
  802b3a:	e9 91 00 00 00       	jmp    802bd0 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802b3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b42:	89 d0                	mov    %edx,%eax
  802b44:	01 c0                	add    %eax,%eax
  802b46:	01 d0                	add    %edx,%eax
  802b48:	c1 e0 02             	shl    $0x2,%eax
  802b4b:	05 40 10 81 00       	add    $0x811040,%eax
  802b50:	8b 08                	mov    (%eax),%ecx
  802b52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b55:	89 d0                	mov    %edx,%eax
  802b57:	01 c0                	add    %eax,%eax
  802b59:	01 d0                	add    %edx,%eax
  802b5b:	c1 e0 02             	shl    $0x2,%eax
  802b5e:	05 44 10 81 00       	add    $0x811044,%eax
  802b63:	8b 00                	mov    (%eax),%eax
  802b65:	01 c1                	add    %eax,%ecx
  802b67:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b6a:	89 d0                	mov    %edx,%eax
  802b6c:	01 c0                	add    %eax,%eax
  802b6e:	01 d0                	add    %edx,%eax
  802b70:	c1 e0 02             	shl    $0x2,%eax
  802b73:	05 40 10 81 00       	add    $0x811040,%eax
  802b78:	8b 00                	mov    (%eax),%eax
  802b7a:	39 c1                	cmp    %eax,%ecx
  802b7c:	75 52                	jne    802bd0 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802b7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b81:	89 d0                	mov    %edx,%eax
  802b83:	01 c0                	add    %eax,%eax
  802b85:	01 d0                	add    %edx,%eax
  802b87:	c1 e0 02             	shl    $0x2,%eax
  802b8a:	05 44 10 81 00       	add    $0x811044,%eax
  802b8f:	8b 08                	mov    (%eax),%ecx
  802b91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b94:	89 d0                	mov    %edx,%eax
  802b96:	01 c0                	add    %eax,%eax
  802b98:	01 d0                	add    %edx,%eax
  802b9a:	c1 e0 02             	shl    $0x2,%eax
  802b9d:	05 44 10 81 00       	add    $0x811044,%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	01 c1                	add    %eax,%ecx
  802ba6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba9:	89 d0                	mov    %edx,%eax
  802bab:	01 c0                	add    %eax,%eax
  802bad:	01 d0                	add    %edx,%eax
  802baf:	c1 e0 02             	shl    $0x2,%eax
  802bb2:	05 44 10 81 00       	add    $0x811044,%eax
  802bb7:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802bb9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bbc:	89 d0                	mov    %edx,%eax
  802bbe:	01 c0                	add    %eax,%eax
  802bc0:	01 d0                	add    %edx,%eax
  802bc2:	c1 e0 02             	shl    $0x2,%eax
  802bc5:	05 48 10 81 00       	add    $0x811048,%eax
  802bca:	c6 00 00             	movb   $0x0,(%eax)
  802bcd:	eb 01                	jmp    802bd0 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802bcf:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802bd0:	ff 45 e8             	incl   -0x18(%ebp)
  802bd3:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802bda:	0f 8e 7f fe ff ff    	jle    802a5f <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802be0:	a1 30 51 83 00       	mov    0x835130,%eax
  802be5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802be8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802bef:	eb 53                	jmp    802c44 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802bf1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bf4:	89 d0                	mov    %edx,%eax
  802bf6:	01 c0                	add    %eax,%eax
  802bf8:	01 d0                	add    %edx,%eax
  802bfa:	c1 e0 02             	shl    $0x2,%eax
  802bfd:	05 48 50 80 00       	add    $0x805048,%eax
  802c02:	8a 00                	mov    (%eax),%al
  802c04:	84 c0                	test   %al,%al
  802c06:	74 39                	je     802c41 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802c08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c0b:	89 d0                	mov    %edx,%eax
  802c0d:	01 c0                	add    %eax,%eax
  802c0f:	01 d0                	add    %edx,%eax
  802c11:	c1 e0 02             	shl    $0x2,%eax
  802c14:	05 40 50 80 00       	add    $0x805040,%eax
  802c19:	8b 08                	mov    (%eax),%ecx
  802c1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c1e:	89 d0                	mov    %edx,%eax
  802c20:	01 c0                	add    %eax,%eax
  802c22:	01 d0                	add    %edx,%eax
  802c24:	c1 e0 02             	shl    $0x2,%eax
  802c27:	05 44 50 80 00       	add    $0x805044,%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	01 c8                	add    %ecx,%eax
  802c30:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802c33:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c36:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c39:	76 06                	jbe    802c41 <sfree+0x321>
  802c3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802c41:	ff 45 e0             	incl   -0x20(%ebp)
  802c44:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802c4b:	7e a4                	jle    802bf1 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c50:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802c55:	eb 16                	jmp    802c6d <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802c57:	ff 45 f4             	incl   -0xc(%ebp)
  802c5a:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802c61:	0f 8e 04 fd ff ff    	jle    80296b <sfree+0x4b>
  802c67:	eb 04                	jmp    802c6d <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802c69:	90                   	nop
  802c6a:	eb 01                	jmp    802c6d <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802c6c:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802c6d:	c9                   	leave  
  802c6e:	c3                   	ret    

00802c6f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802c6f:	55                   	push   %ebp
  802c70:	89 e5                	mov    %esp,%ebp
  802c72:	57                   	push   %edi
  802c73:	56                   	push   %esi
  802c74:	53                   	push   %ebx
  802c75:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c81:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c84:	8b 7d 18             	mov    0x18(%ebp),%edi
  802c87:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802c8a:	cd 30                	int    $0x30
  802c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802c92:	83 c4 10             	add    $0x10,%esp
  802c95:	5b                   	pop    %ebx
  802c96:	5e                   	pop    %esi
  802c97:	5f                   	pop    %edi
  802c98:	5d                   	pop    %ebp
  802c99:	c3                   	ret    

00802c9a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802c9a:	55                   	push   %ebp
  802c9b:	89 e5                	mov    %esp,%ebp
  802c9d:	83 ec 04             	sub    $0x4,%esp
  802ca0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ca3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802ca6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ca9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	6a 00                	push   $0x0
  802cb2:	51                   	push   %ecx
  802cb3:	52                   	push   %edx
  802cb4:	ff 75 0c             	pushl  0xc(%ebp)
  802cb7:	50                   	push   %eax
  802cb8:	6a 00                	push   $0x0
  802cba:	e8 b0 ff ff ff       	call   802c6f <syscall>
  802cbf:	83 c4 18             	add    $0x18,%esp
}
  802cc2:	90                   	nop
  802cc3:	c9                   	leave  
  802cc4:	c3                   	ret    

00802cc5 <sys_cgetc>:

int
sys_cgetc(void)
{
  802cc5:	55                   	push   %ebp
  802cc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802cc8:	6a 00                	push   $0x0
  802cca:	6a 00                	push   $0x0
  802ccc:	6a 00                	push   $0x0
  802cce:	6a 00                	push   $0x0
  802cd0:	6a 00                	push   $0x0
  802cd2:	6a 02                	push   $0x2
  802cd4:	e8 96 ff ff ff       	call   802c6f <syscall>
  802cd9:	83 c4 18             	add    $0x18,%esp
}
  802cdc:	c9                   	leave  
  802cdd:	c3                   	ret    

00802cde <sys_lock_cons>:

void sys_lock_cons(void)
{
  802cde:	55                   	push   %ebp
  802cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802ce1:	6a 00                	push   $0x0
  802ce3:	6a 00                	push   $0x0
  802ce5:	6a 00                	push   $0x0
  802ce7:	6a 00                	push   $0x0
  802ce9:	6a 00                	push   $0x0
  802ceb:	6a 03                	push   $0x3
  802ced:	e8 7d ff ff ff       	call   802c6f <syscall>
  802cf2:	83 c4 18             	add    $0x18,%esp
}
  802cf5:	90                   	nop
  802cf6:	c9                   	leave  
  802cf7:	c3                   	ret    

00802cf8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802cf8:	55                   	push   %ebp
  802cf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802cfb:	6a 00                	push   $0x0
  802cfd:	6a 00                	push   $0x0
  802cff:	6a 00                	push   $0x0
  802d01:	6a 00                	push   $0x0
  802d03:	6a 00                	push   $0x0
  802d05:	6a 04                	push   $0x4
  802d07:	e8 63 ff ff ff       	call   802c6f <syscall>
  802d0c:	83 c4 18             	add    $0x18,%esp
}
  802d0f:	90                   	nop
  802d10:	c9                   	leave  
  802d11:	c3                   	ret    

00802d12 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802d12:	55                   	push   %ebp
  802d13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802d15:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	6a 00                	push   $0x0
  802d1d:	6a 00                	push   $0x0
  802d1f:	6a 00                	push   $0x0
  802d21:	52                   	push   %edx
  802d22:	50                   	push   %eax
  802d23:	6a 08                	push   $0x8
  802d25:	e8 45 ff ff ff       	call   802c6f <syscall>
  802d2a:	83 c4 18             	add    $0x18,%esp
}
  802d2d:	c9                   	leave  
  802d2e:	c3                   	ret    

00802d2f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802d2f:	55                   	push   %ebp
  802d30:	89 e5                	mov    %esp,%ebp
  802d32:	56                   	push   %esi
  802d33:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802d34:	8b 75 18             	mov    0x18(%ebp),%esi
  802d37:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	56                   	push   %esi
  802d44:	53                   	push   %ebx
  802d45:	51                   	push   %ecx
  802d46:	52                   	push   %edx
  802d47:	50                   	push   %eax
  802d48:	6a 09                	push   $0x9
  802d4a:	e8 20 ff ff ff       	call   802c6f <syscall>
  802d4f:	83 c4 18             	add    $0x18,%esp
}
  802d52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d55:	5b                   	pop    %ebx
  802d56:	5e                   	pop    %esi
  802d57:	5d                   	pop    %ebp
  802d58:	c3                   	ret    

00802d59 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802d59:	55                   	push   %ebp
  802d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802d5c:	6a 00                	push   $0x0
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 00                	push   $0x0
  802d62:	6a 00                	push   $0x0
  802d64:	ff 75 08             	pushl  0x8(%ebp)
  802d67:	6a 0a                	push   $0xa
  802d69:	e8 01 ff ff ff       	call   802c6f <syscall>
  802d6e:	83 c4 18             	add    $0x18,%esp
}
  802d71:	c9                   	leave  
  802d72:	c3                   	ret    

00802d73 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802d73:	55                   	push   %ebp
  802d74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802d76:	6a 00                	push   $0x0
  802d78:	6a 00                	push   $0x0
  802d7a:	6a 00                	push   $0x0
  802d7c:	ff 75 0c             	pushl  0xc(%ebp)
  802d7f:	ff 75 08             	pushl  0x8(%ebp)
  802d82:	6a 0b                	push   $0xb
  802d84:	e8 e6 fe ff ff       	call   802c6f <syscall>
  802d89:	83 c4 18             	add    $0x18,%esp
}
  802d8c:	c9                   	leave  
  802d8d:	c3                   	ret    

00802d8e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802d8e:	55                   	push   %ebp
  802d8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802d91:	6a 00                	push   $0x0
  802d93:	6a 00                	push   $0x0
  802d95:	6a 00                	push   $0x0
  802d97:	6a 00                	push   $0x0
  802d99:	6a 00                	push   $0x0
  802d9b:	6a 0c                	push   $0xc
  802d9d:	e8 cd fe ff ff       	call   802c6f <syscall>
  802da2:	83 c4 18             	add    $0x18,%esp
}
  802da5:	c9                   	leave  
  802da6:	c3                   	ret    

00802da7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802da7:	55                   	push   %ebp
  802da8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802daa:	6a 00                	push   $0x0
  802dac:	6a 00                	push   $0x0
  802dae:	6a 00                	push   $0x0
  802db0:	6a 00                	push   $0x0
  802db2:	6a 00                	push   $0x0
  802db4:	6a 0d                	push   $0xd
  802db6:	e8 b4 fe ff ff       	call   802c6f <syscall>
  802dbb:	83 c4 18             	add    $0x18,%esp
}
  802dbe:	c9                   	leave  
  802dbf:	c3                   	ret    

00802dc0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802dc0:	55                   	push   %ebp
  802dc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802dc3:	6a 00                	push   $0x0
  802dc5:	6a 00                	push   $0x0
  802dc7:	6a 00                	push   $0x0
  802dc9:	6a 00                	push   $0x0
  802dcb:	6a 00                	push   $0x0
  802dcd:	6a 0e                	push   $0xe
  802dcf:	e8 9b fe ff ff       	call   802c6f <syscall>
  802dd4:	83 c4 18             	add    $0x18,%esp
}
  802dd7:	c9                   	leave  
  802dd8:	c3                   	ret    

00802dd9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802dd9:	55                   	push   %ebp
  802dda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802ddc:	6a 00                	push   $0x0
  802dde:	6a 00                	push   $0x0
  802de0:	6a 00                	push   $0x0
  802de2:	6a 00                	push   $0x0
  802de4:	6a 00                	push   $0x0
  802de6:	6a 0f                	push   $0xf
  802de8:	e8 82 fe ff ff       	call   802c6f <syscall>
  802ded:	83 c4 18             	add    $0x18,%esp
}
  802df0:	c9                   	leave  
  802df1:	c3                   	ret    

00802df2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802df2:	55                   	push   %ebp
  802df3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802df5:	6a 00                	push   $0x0
  802df7:	6a 00                	push   $0x0
  802df9:	6a 00                	push   $0x0
  802dfb:	6a 00                	push   $0x0
  802dfd:	ff 75 08             	pushl  0x8(%ebp)
  802e00:	6a 10                	push   $0x10
  802e02:	e8 68 fe ff ff       	call   802c6f <syscall>
  802e07:	83 c4 18             	add    $0x18,%esp
}
  802e0a:	c9                   	leave  
  802e0b:	c3                   	ret    

00802e0c <sys_scarce_memory>:

void sys_scarce_memory()
{
  802e0c:	55                   	push   %ebp
  802e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802e0f:	6a 00                	push   $0x0
  802e11:	6a 00                	push   $0x0
  802e13:	6a 00                	push   $0x0
  802e15:	6a 00                	push   $0x0
  802e17:	6a 00                	push   $0x0
  802e19:	6a 11                	push   $0x11
  802e1b:	e8 4f fe ff ff       	call   802c6f <syscall>
  802e20:	83 c4 18             	add    $0x18,%esp
}
  802e23:	90                   	nop
  802e24:	c9                   	leave  
  802e25:	c3                   	ret    

00802e26 <sys_cputc>:

void
sys_cputc(const char c)
{
  802e26:	55                   	push   %ebp
  802e27:	89 e5                	mov    %esp,%ebp
  802e29:	83 ec 04             	sub    $0x4,%esp
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802e32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e36:	6a 00                	push   $0x0
  802e38:	6a 00                	push   $0x0
  802e3a:	6a 00                	push   $0x0
  802e3c:	6a 00                	push   $0x0
  802e3e:	50                   	push   %eax
  802e3f:	6a 01                	push   $0x1
  802e41:	e8 29 fe ff ff       	call   802c6f <syscall>
  802e46:	83 c4 18             	add    $0x18,%esp
}
  802e49:	90                   	nop
  802e4a:	c9                   	leave  
  802e4b:	c3                   	ret    

00802e4c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802e4c:	55                   	push   %ebp
  802e4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802e4f:	6a 00                	push   $0x0
  802e51:	6a 00                	push   $0x0
  802e53:	6a 00                	push   $0x0
  802e55:	6a 00                	push   $0x0
  802e57:	6a 00                	push   $0x0
  802e59:	6a 14                	push   $0x14
  802e5b:	e8 0f fe ff ff       	call   802c6f <syscall>
  802e60:	83 c4 18             	add    $0x18,%esp
}
  802e63:	90                   	nop
  802e64:	c9                   	leave  
  802e65:	c3                   	ret    

00802e66 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802e66:	55                   	push   %ebp
  802e67:	89 e5                	mov    %esp,%ebp
  802e69:	83 ec 04             	sub    $0x4,%esp
  802e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  802e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802e72:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e75:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	6a 00                	push   $0x0
  802e7e:	51                   	push   %ecx
  802e7f:	52                   	push   %edx
  802e80:	ff 75 0c             	pushl  0xc(%ebp)
  802e83:	50                   	push   %eax
  802e84:	6a 15                	push   $0x15
  802e86:	e8 e4 fd ff ff       	call   802c6f <syscall>
  802e8b:	83 c4 18             	add    $0x18,%esp
}
  802e8e:	c9                   	leave  
  802e8f:	c3                   	ret    

00802e90 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802e90:	55                   	push   %ebp
  802e91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802e93:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	6a 00                	push   $0x0
  802e9f:	52                   	push   %edx
  802ea0:	50                   	push   %eax
  802ea1:	6a 16                	push   $0x16
  802ea3:	e8 c7 fd ff ff       	call   802c6f <syscall>
  802ea8:	83 c4 18             	add    $0x18,%esp
}
  802eab:	c9                   	leave  
  802eac:	c3                   	ret    

00802ead <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802ead:	55                   	push   %ebp
  802eae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802eb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	6a 00                	push   $0x0
  802ebb:	6a 00                	push   $0x0
  802ebd:	51                   	push   %ecx
  802ebe:	52                   	push   %edx
  802ebf:	50                   	push   %eax
  802ec0:	6a 17                	push   $0x17
  802ec2:	e8 a8 fd ff ff       	call   802c6f <syscall>
  802ec7:	83 c4 18             	add    $0x18,%esp
}
  802eca:	c9                   	leave  
  802ecb:	c3                   	ret    

00802ecc <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802ecc:	55                   	push   %ebp
  802ecd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	6a 00                	push   $0x0
  802ed7:	6a 00                	push   $0x0
  802ed9:	6a 00                	push   $0x0
  802edb:	52                   	push   %edx
  802edc:	50                   	push   %eax
  802edd:	6a 18                	push   $0x18
  802edf:	e8 8b fd ff ff       	call   802c6f <syscall>
  802ee4:	83 c4 18             	add    $0x18,%esp
}
  802ee7:	c9                   	leave  
  802ee8:	c3                   	ret    

00802ee9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ee9:	55                   	push   %ebp
  802eea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	6a 00                	push   $0x0
  802ef1:	ff 75 14             	pushl  0x14(%ebp)
  802ef4:	ff 75 10             	pushl  0x10(%ebp)
  802ef7:	ff 75 0c             	pushl  0xc(%ebp)
  802efa:	50                   	push   %eax
  802efb:	6a 19                	push   $0x19
  802efd:	e8 6d fd ff ff       	call   802c6f <syscall>
  802f02:	83 c4 18             	add    $0x18,%esp
}
  802f05:	c9                   	leave  
  802f06:	c3                   	ret    

00802f07 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802f07:	55                   	push   %ebp
  802f08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	6a 00                	push   $0x0
  802f0f:	6a 00                	push   $0x0
  802f11:	6a 00                	push   $0x0
  802f13:	6a 00                	push   $0x0
  802f15:	50                   	push   %eax
  802f16:	6a 1a                	push   $0x1a
  802f18:	e8 52 fd ff ff       	call   802c6f <syscall>
  802f1d:	83 c4 18             	add    $0x18,%esp
}
  802f20:	90                   	nop
  802f21:	c9                   	leave  
  802f22:	c3                   	ret    

00802f23 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802f23:	55                   	push   %ebp
  802f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	6a 00                	push   $0x0
  802f31:	50                   	push   %eax
  802f32:	6a 1b                	push   $0x1b
  802f34:	e8 36 fd ff ff       	call   802c6f <syscall>
  802f39:	83 c4 18             	add    $0x18,%esp
}
  802f3c:	c9                   	leave  
  802f3d:	c3                   	ret    

00802f3e <sys_getenvid>:

int32 sys_getenvid(void)
{
  802f3e:	55                   	push   %ebp
  802f3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802f41:	6a 00                	push   $0x0
  802f43:	6a 00                	push   $0x0
  802f45:	6a 00                	push   $0x0
  802f47:	6a 00                	push   $0x0
  802f49:	6a 00                	push   $0x0
  802f4b:	6a 05                	push   $0x5
  802f4d:	e8 1d fd ff ff       	call   802c6f <syscall>
  802f52:	83 c4 18             	add    $0x18,%esp
}
  802f55:	c9                   	leave  
  802f56:	c3                   	ret    

00802f57 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802f57:	55                   	push   %ebp
  802f58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802f5a:	6a 00                	push   $0x0
  802f5c:	6a 00                	push   $0x0
  802f5e:	6a 00                	push   $0x0
  802f60:	6a 00                	push   $0x0
  802f62:	6a 00                	push   $0x0
  802f64:	6a 06                	push   $0x6
  802f66:	e8 04 fd ff ff       	call   802c6f <syscall>
  802f6b:	83 c4 18             	add    $0x18,%esp
}
  802f6e:	c9                   	leave  
  802f6f:	c3                   	ret    

00802f70 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802f70:	55                   	push   %ebp
  802f71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802f73:	6a 00                	push   $0x0
  802f75:	6a 00                	push   $0x0
  802f77:	6a 00                	push   $0x0
  802f79:	6a 00                	push   $0x0
  802f7b:	6a 00                	push   $0x0
  802f7d:	6a 07                	push   $0x7
  802f7f:	e8 eb fc ff ff       	call   802c6f <syscall>
  802f84:	83 c4 18             	add    $0x18,%esp
}
  802f87:	c9                   	leave  
  802f88:	c3                   	ret    

00802f89 <sys_exit_env>:


void sys_exit_env(void)
{
  802f89:	55                   	push   %ebp
  802f8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802f8c:	6a 00                	push   $0x0
  802f8e:	6a 00                	push   $0x0
  802f90:	6a 00                	push   $0x0
  802f92:	6a 00                	push   $0x0
  802f94:	6a 00                	push   $0x0
  802f96:	6a 1c                	push   $0x1c
  802f98:	e8 d2 fc ff ff       	call   802c6f <syscall>
  802f9d:	83 c4 18             	add    $0x18,%esp
}
  802fa0:	90                   	nop
  802fa1:	c9                   	leave  
  802fa2:	c3                   	ret    

00802fa3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802fa3:	55                   	push   %ebp
  802fa4:	89 e5                	mov    %esp,%ebp
  802fa6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802fa9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802fac:	8d 50 04             	lea    0x4(%eax),%edx
  802faf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802fb2:	6a 00                	push   $0x0
  802fb4:	6a 00                	push   $0x0
  802fb6:	6a 00                	push   $0x0
  802fb8:	52                   	push   %edx
  802fb9:	50                   	push   %eax
  802fba:	6a 1d                	push   $0x1d
  802fbc:	e8 ae fc ff ff       	call   802c6f <syscall>
  802fc1:	83 c4 18             	add    $0x18,%esp
	return result;
  802fc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802fca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802fcd:	89 01                	mov    %eax,(%ecx)
  802fcf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	c9                   	leave  
  802fd6:	c2 04 00             	ret    $0x4

00802fd9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802fd9:	55                   	push   %ebp
  802fda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	ff 75 10             	pushl  0x10(%ebp)
  802fe3:	ff 75 0c             	pushl  0xc(%ebp)
  802fe6:	ff 75 08             	pushl  0x8(%ebp)
  802fe9:	6a 13                	push   $0x13
  802feb:	e8 7f fc ff ff       	call   802c6f <syscall>
  802ff0:	83 c4 18             	add    $0x18,%esp
	return ;
  802ff3:	90                   	nop
}
  802ff4:	c9                   	leave  
  802ff5:	c3                   	ret    

00802ff6 <sys_rcr2>:
uint32 sys_rcr2()
{
  802ff6:	55                   	push   %ebp
  802ff7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802ff9:	6a 00                	push   $0x0
  802ffb:	6a 00                	push   $0x0
  802ffd:	6a 00                	push   $0x0
  802fff:	6a 00                	push   $0x0
  803001:	6a 00                	push   $0x0
  803003:	6a 1e                	push   $0x1e
  803005:	e8 65 fc ff ff       	call   802c6f <syscall>
  80300a:	83 c4 18             	add    $0x18,%esp
}
  80300d:	c9                   	leave  
  80300e:	c3                   	ret    

0080300f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80300f:	55                   	push   %ebp
  803010:	89 e5                	mov    %esp,%ebp
  803012:	83 ec 04             	sub    $0x4,%esp
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80301b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80301f:	6a 00                	push   $0x0
  803021:	6a 00                	push   $0x0
  803023:	6a 00                	push   $0x0
  803025:	6a 00                	push   $0x0
  803027:	50                   	push   %eax
  803028:	6a 1f                	push   $0x1f
  80302a:	e8 40 fc ff ff       	call   802c6f <syscall>
  80302f:	83 c4 18             	add    $0x18,%esp
	return ;
  803032:	90                   	nop
}
  803033:	c9                   	leave  
  803034:	c3                   	ret    

00803035 <rsttst>:
void rsttst()
{
  803035:	55                   	push   %ebp
  803036:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803038:	6a 00                	push   $0x0
  80303a:	6a 00                	push   $0x0
  80303c:	6a 00                	push   $0x0
  80303e:	6a 00                	push   $0x0
  803040:	6a 00                	push   $0x0
  803042:	6a 21                	push   $0x21
  803044:	e8 26 fc ff ff       	call   802c6f <syscall>
  803049:	83 c4 18             	add    $0x18,%esp
	return ;
  80304c:	90                   	nop
}
  80304d:	c9                   	leave  
  80304e:	c3                   	ret    

0080304f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80304f:	55                   	push   %ebp
  803050:	89 e5                	mov    %esp,%ebp
  803052:	83 ec 04             	sub    $0x4,%esp
  803055:	8b 45 14             	mov    0x14(%ebp),%eax
  803058:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80305b:	8b 55 18             	mov    0x18(%ebp),%edx
  80305e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803062:	52                   	push   %edx
  803063:	50                   	push   %eax
  803064:	ff 75 10             	pushl  0x10(%ebp)
  803067:	ff 75 0c             	pushl  0xc(%ebp)
  80306a:	ff 75 08             	pushl  0x8(%ebp)
  80306d:	6a 20                	push   $0x20
  80306f:	e8 fb fb ff ff       	call   802c6f <syscall>
  803074:	83 c4 18             	add    $0x18,%esp
	return ;
  803077:	90                   	nop
}
  803078:	c9                   	leave  
  803079:	c3                   	ret    

0080307a <chktst>:
void chktst(uint32 n)
{
  80307a:	55                   	push   %ebp
  80307b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80307d:	6a 00                	push   $0x0
  80307f:	6a 00                	push   $0x0
  803081:	6a 00                	push   $0x0
  803083:	6a 00                	push   $0x0
  803085:	ff 75 08             	pushl  0x8(%ebp)
  803088:	6a 22                	push   $0x22
  80308a:	e8 e0 fb ff ff       	call   802c6f <syscall>
  80308f:	83 c4 18             	add    $0x18,%esp
	return ;
  803092:	90                   	nop
}
  803093:	c9                   	leave  
  803094:	c3                   	ret    

00803095 <inctst>:

void inctst()
{
  803095:	55                   	push   %ebp
  803096:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803098:	6a 00                	push   $0x0
  80309a:	6a 00                	push   $0x0
  80309c:	6a 00                	push   $0x0
  80309e:	6a 00                	push   $0x0
  8030a0:	6a 00                	push   $0x0
  8030a2:	6a 23                	push   $0x23
  8030a4:	e8 c6 fb ff ff       	call   802c6f <syscall>
  8030a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8030ac:	90                   	nop
}
  8030ad:	c9                   	leave  
  8030ae:	c3                   	ret    

008030af <gettst>:
uint32 gettst()
{
  8030af:	55                   	push   %ebp
  8030b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8030b2:	6a 00                	push   $0x0
  8030b4:	6a 00                	push   $0x0
  8030b6:	6a 00                	push   $0x0
  8030b8:	6a 00                	push   $0x0
  8030ba:	6a 00                	push   $0x0
  8030bc:	6a 24                	push   $0x24
  8030be:	e8 ac fb ff ff       	call   802c6f <syscall>
  8030c3:	83 c4 18             	add    $0x18,%esp
}
  8030c6:	c9                   	leave  
  8030c7:	c3                   	ret    

008030c8 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8030c8:	55                   	push   %ebp
  8030c9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8030cb:	6a 00                	push   $0x0
  8030cd:	6a 00                	push   $0x0
  8030cf:	6a 00                	push   $0x0
  8030d1:	6a 00                	push   $0x0
  8030d3:	6a 00                	push   $0x0
  8030d5:	6a 25                	push   $0x25
  8030d7:	e8 93 fb ff ff       	call   802c6f <syscall>
  8030dc:	83 c4 18             	add    $0x18,%esp
  8030df:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  8030e4:	a1 80 50 83 00       	mov    0x835080,%eax
}
  8030e9:	c9                   	leave  
  8030ea:	c3                   	ret    

008030eb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8030eb:	55                   	push   %ebp
  8030ec:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8030f6:	6a 00                	push   $0x0
  8030f8:	6a 00                	push   $0x0
  8030fa:	6a 00                	push   $0x0
  8030fc:	6a 00                	push   $0x0
  8030fe:	ff 75 08             	pushl  0x8(%ebp)
  803101:	6a 26                	push   $0x26
  803103:	e8 67 fb ff ff       	call   802c6f <syscall>
  803108:	83 c4 18             	add    $0x18,%esp
	return ;
  80310b:	90                   	nop
}
  80310c:	c9                   	leave  
  80310d:	c3                   	ret    

0080310e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80310e:	55                   	push   %ebp
  80310f:	89 e5                	mov    %esp,%ebp
  803111:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803112:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803115:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803118:	8b 55 0c             	mov    0xc(%ebp),%edx
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	6a 00                	push   $0x0
  803120:	53                   	push   %ebx
  803121:	51                   	push   %ecx
  803122:	52                   	push   %edx
  803123:	50                   	push   %eax
  803124:	6a 27                	push   $0x27
  803126:	e8 44 fb ff ff       	call   802c6f <syscall>
  80312b:	83 c4 18             	add    $0x18,%esp
}
  80312e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803131:	c9                   	leave  
  803132:	c3                   	ret    

00803133 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803133:	55                   	push   %ebp
  803134:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803136:	8b 55 0c             	mov    0xc(%ebp),%edx
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	6a 00                	push   $0x0
  80313e:	6a 00                	push   $0x0
  803140:	6a 00                	push   $0x0
  803142:	52                   	push   %edx
  803143:	50                   	push   %eax
  803144:	6a 28                	push   $0x28
  803146:	e8 24 fb ff ff       	call   802c6f <syscall>
  80314b:	83 c4 18             	add    $0x18,%esp
}
  80314e:	c9                   	leave  
  80314f:	c3                   	ret    

00803150 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803150:	55                   	push   %ebp
  803151:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803153:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803156:	8b 55 0c             	mov    0xc(%ebp),%edx
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	6a 00                	push   $0x0
  80315e:	51                   	push   %ecx
  80315f:	ff 75 10             	pushl  0x10(%ebp)
  803162:	52                   	push   %edx
  803163:	50                   	push   %eax
  803164:	6a 29                	push   $0x29
  803166:	e8 04 fb ff ff       	call   802c6f <syscall>
  80316b:	83 c4 18             	add    $0x18,%esp
}
  80316e:	c9                   	leave  
  80316f:	c3                   	ret    

00803170 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803170:	55                   	push   %ebp
  803171:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803173:	6a 00                	push   $0x0
  803175:	6a 00                	push   $0x0
  803177:	ff 75 10             	pushl  0x10(%ebp)
  80317a:	ff 75 0c             	pushl  0xc(%ebp)
  80317d:	ff 75 08             	pushl  0x8(%ebp)
  803180:	6a 12                	push   $0x12
  803182:	e8 e8 fa ff ff       	call   802c6f <syscall>
  803187:	83 c4 18             	add    $0x18,%esp
	return ;
  80318a:	90                   	nop
}
  80318b:	c9                   	leave  
  80318c:	c3                   	ret    

0080318d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80318d:	55                   	push   %ebp
  80318e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803190:	8b 55 0c             	mov    0xc(%ebp),%edx
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	6a 00                	push   $0x0
  803198:	6a 00                	push   $0x0
  80319a:	6a 00                	push   $0x0
  80319c:	52                   	push   %edx
  80319d:	50                   	push   %eax
  80319e:	6a 2a                	push   $0x2a
  8031a0:	e8 ca fa ff ff       	call   802c6f <syscall>
  8031a5:	83 c4 18             	add    $0x18,%esp
	return;
  8031a8:	90                   	nop
}
  8031a9:	c9                   	leave  
  8031aa:	c3                   	ret    

008031ab <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8031ab:	55                   	push   %ebp
  8031ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8031ae:	6a 00                	push   $0x0
  8031b0:	6a 00                	push   $0x0
  8031b2:	6a 00                	push   $0x0
  8031b4:	6a 00                	push   $0x0
  8031b6:	6a 00                	push   $0x0
  8031b8:	6a 2b                	push   $0x2b
  8031ba:	e8 b0 fa ff ff       	call   802c6f <syscall>
  8031bf:	83 c4 18             	add    $0x18,%esp
}
  8031c2:	c9                   	leave  
  8031c3:	c3                   	ret    

008031c4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8031c4:	55                   	push   %ebp
  8031c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8031c7:	6a 00                	push   $0x0
  8031c9:	6a 00                	push   $0x0
  8031cb:	6a 00                	push   $0x0
  8031cd:	ff 75 0c             	pushl  0xc(%ebp)
  8031d0:	ff 75 08             	pushl  0x8(%ebp)
  8031d3:	6a 2d                	push   $0x2d
  8031d5:	e8 95 fa ff ff       	call   802c6f <syscall>
  8031da:	83 c4 18             	add    $0x18,%esp
	return;
  8031dd:	90                   	nop
}
  8031de:	c9                   	leave  
  8031df:	c3                   	ret    

008031e0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8031e0:	55                   	push   %ebp
  8031e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8031e3:	6a 00                	push   $0x0
  8031e5:	6a 00                	push   $0x0
  8031e7:	6a 00                	push   $0x0
  8031e9:	ff 75 0c             	pushl  0xc(%ebp)
  8031ec:	ff 75 08             	pushl  0x8(%ebp)
  8031ef:	6a 2c                	push   $0x2c
  8031f1:	e8 79 fa ff ff       	call   802c6f <syscall>
  8031f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8031f9:	90                   	nop
}
  8031fa:	c9                   	leave  
  8031fb:	c3                   	ret    

008031fc <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8031fc:	55                   	push   %ebp
  8031fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8031ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	6a 00                	push   $0x0
  803207:	6a 00                	push   $0x0
  803209:	6a 00                	push   $0x0
  80320b:	52                   	push   %edx
  80320c:	50                   	push   %eax
  80320d:	6a 2e                	push   $0x2e
  80320f:	e8 5b fa ff ff       	call   802c6f <syscall>
  803214:	83 c4 18             	add    $0x18,%esp
}
  803217:	90                   	nop
  803218:	c9                   	leave  
  803219:	c3                   	ret    

0080321a <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80321a:	55                   	push   %ebp
  80321b:	89 e5                	mov    %esp,%ebp
  80321d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803220:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803227:	72 09                	jb     803232 <to_page_va+0x18>
  803229:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  803230:	72 14                	jb     803246 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803232:	83 ec 04             	sub    $0x4,%esp
  803235:	68 38 49 80 00       	push   $0x804938
  80323a:	6a 15                	push   $0x15
  80323c:	68 63 49 80 00       	push   $0x804963
  803241:	e8 a1 0c 00 00       	call   803ee7 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  80324e:	29 d0                	sub    %edx,%eax
  803250:	c1 f8 02             	sar    $0x2,%eax
  803253:	89 c2                	mov    %eax,%edx
  803255:	89 d0                	mov    %edx,%eax
  803257:	c1 e0 02             	shl    $0x2,%eax
  80325a:	01 d0                	add    %edx,%eax
  80325c:	c1 e0 02             	shl    $0x2,%eax
  80325f:	01 d0                	add    %edx,%eax
  803261:	c1 e0 02             	shl    $0x2,%eax
  803264:	01 d0                	add    %edx,%eax
  803266:	89 c1                	mov    %eax,%ecx
  803268:	c1 e1 08             	shl    $0x8,%ecx
  80326b:	01 c8                	add    %ecx,%eax
  80326d:	89 c1                	mov    %eax,%ecx
  80326f:	c1 e1 10             	shl    $0x10,%ecx
  803272:	01 c8                	add    %ecx,%eax
  803274:	01 c0                	add    %eax,%eax
  803276:	01 d0                	add    %edx,%eax
  803278:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80327b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327e:	c1 e0 0c             	shl    $0xc,%eax
  803281:	89 c2                	mov    %eax,%edx
  803283:	a1 84 50 83 00       	mov    0x835084,%eax
  803288:	01 d0                	add    %edx,%eax
}
  80328a:	c9                   	leave  
  80328b:	c3                   	ret    

0080328c <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80328c:	55                   	push   %ebp
  80328d:	89 e5                	mov    %esp,%ebp
  80328f:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803292:	a1 84 50 83 00       	mov    0x835084,%eax
  803297:	8b 55 08             	mov    0x8(%ebp),%edx
  80329a:	29 c2                	sub    %eax,%edx
  80329c:	89 d0                	mov    %edx,%eax
  80329e:	c1 e8 0c             	shr    $0xc,%eax
  8032a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8032a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a8:	78 09                	js     8032b3 <to_page_info+0x27>
  8032aa:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8032b1:	7e 14                	jle    8032c7 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8032b3:	83 ec 04             	sub    $0x4,%esp
  8032b6:	68 7c 49 80 00       	push   $0x80497c
  8032bb:	6a 21                	push   $0x21
  8032bd:	68 63 49 80 00       	push   $0x804963
  8032c2:	e8 20 0c 00 00       	call   803ee7 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8032c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ca:	89 d0                	mov    %edx,%eax
  8032cc:	01 c0                	add    %eax,%eax
  8032ce:	01 d0                	add    %edx,%eax
  8032d0:	c1 e0 02             	shl    $0x2,%eax
  8032d3:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  8032d8:	c9                   	leave  
  8032d9:	c3                   	ret    

008032da <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8032da:	55                   	push   %ebp
  8032db:	89 e5                	mov    %esp,%ebp
  8032dd:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	05 00 00 00 02       	add    $0x2000000,%eax
  8032e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032eb:	73 16                	jae    803303 <initialize_dynamic_allocator+0x29>
  8032ed:	68 a0 49 80 00       	push   $0x8049a0
  8032f2:	68 c6 49 80 00       	push   $0x8049c6
  8032f7:	6a 2f                	push   $0x2f
  8032f9:	68 63 49 80 00       	push   $0x804963
  8032fe:	e8 e4 0b 00 00       	call   803ee7 <_panic>
	dynAllocStart = daStart;
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  80330b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330e:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803313:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80331a:	eb 36                	jmp    803352 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  80331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331f:	c1 e0 04             	shl    $0x4,%eax
  803322:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803327:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803330:	c1 e0 04             	shl    $0x4,%eax
  803333:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803341:	c1 e0 04             	shl    $0x4,%eax
  803344:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80334f:	ff 45 f4             	incl   -0xc(%ebp)
  803352:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803356:	7e c4                	jle    80331c <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803358:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  80335f:	00 00 00 
  803362:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803369:	00 00 00 
  80336c:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  803373:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803376:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80337d:	e9 1b 01 00 00       	jmp    80349d <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803382:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803385:	89 d0                	mov    %edx,%eax
  803387:	01 c0                	add    %eax,%eax
  803389:	01 d0                	add    %edx,%eax
  80338b:	c1 e0 02             	shl    $0x2,%eax
  80338e:	05 88 d0 81 00       	add    $0x81d088,%eax
  803393:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803398:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80339b:	89 d0                	mov    %edx,%eax
  80339d:	01 c0                	add    %eax,%eax
  80339f:	01 d0                	add    %edx,%eax
  8033a1:	c1 e0 02             	shl    $0x2,%eax
  8033a4:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8033a9:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8033ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b1:	89 d0                	mov    %edx,%eax
  8033b3:	01 c0                	add    %eax,%eax
  8033b5:	01 d0                	add    %edx,%eax
  8033b7:	c1 e0 02             	shl    $0x2,%eax
  8033ba:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	85 c0                	test   %eax,%eax
  8033c3:	74 2b                	je     8033f0 <initialize_dynamic_allocator+0x116>
  8033c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033c8:	89 d0                	mov    %edx,%eax
  8033ca:	01 c0                	add    %eax,%eax
  8033cc:	01 d0                	add    %edx,%eax
  8033ce:	c1 e0 02             	shl    $0x2,%eax
  8033d1:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033d6:	8b 10                	mov    (%eax),%edx
  8033d8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8033db:	89 c8                	mov    %ecx,%eax
  8033dd:	01 c0                	add    %eax,%eax
  8033df:	01 c8                	add    %ecx,%eax
  8033e1:	c1 e0 02             	shl    $0x2,%eax
  8033e4:	05 84 d0 81 00       	add    $0x81d084,%eax
  8033e9:	8b 00                	mov    (%eax),%eax
  8033eb:	89 42 04             	mov    %eax,0x4(%edx)
  8033ee:	eb 18                	jmp    803408 <initialize_dynamic_allocator+0x12e>
  8033f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f3:	89 d0                	mov    %edx,%eax
  8033f5:	01 c0                	add    %eax,%eax
  8033f7:	01 d0                	add    %edx,%eax
  8033f9:	c1 e0 02             	shl    $0x2,%eax
  8033fc:	05 84 d0 81 00       	add    $0x81d084,%eax
  803401:	8b 00                	mov    (%eax),%eax
  803403:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803408:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80340b:	89 d0                	mov    %edx,%eax
  80340d:	01 c0                	add    %eax,%eax
  80340f:	01 d0                	add    %edx,%eax
  803411:	c1 e0 02             	shl    $0x2,%eax
  803414:	05 84 d0 81 00       	add    $0x81d084,%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	74 2a                	je     803449 <initialize_dynamic_allocator+0x16f>
  80341f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803422:	89 d0                	mov    %edx,%eax
  803424:	01 c0                	add    %eax,%eax
  803426:	01 d0                	add    %edx,%eax
  803428:	c1 e0 02             	shl    $0x2,%eax
  80342b:	05 84 d0 81 00       	add    $0x81d084,%eax
  803430:	8b 10                	mov    (%eax),%edx
  803432:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803435:	89 c8                	mov    %ecx,%eax
  803437:	01 c0                	add    %eax,%eax
  803439:	01 c8                	add    %ecx,%eax
  80343b:	c1 e0 02             	shl    $0x2,%eax
  80343e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803443:	8b 00                	mov    (%eax),%eax
  803445:	89 02                	mov    %eax,(%edx)
  803447:	eb 18                	jmp    803461 <initialize_dynamic_allocator+0x187>
  803449:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80344c:	89 d0                	mov    %edx,%eax
  80344e:	01 c0                	add    %eax,%eax
  803450:	01 d0                	add    %edx,%eax
  803452:	c1 e0 02             	shl    $0x2,%eax
  803455:	05 80 d0 81 00       	add    $0x81d080,%eax
  80345a:	8b 00                	mov    (%eax),%eax
  80345c:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803461:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803464:	89 d0                	mov    %edx,%eax
  803466:	01 c0                	add    %eax,%eax
  803468:	01 d0                	add    %edx,%eax
  80346a:	c1 e0 02             	shl    $0x2,%eax
  80346d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803472:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803478:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80347b:	89 d0                	mov    %edx,%eax
  80347d:	01 c0                	add    %eax,%eax
  80347f:	01 d0                	add    %edx,%eax
  803481:	c1 e0 02             	shl    $0x2,%eax
  803484:	05 84 d0 81 00       	add    $0x81d084,%eax
  803489:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80348f:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803494:	48                   	dec    %eax
  803495:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80349a:	ff 45 f0             	incl   -0x10(%ebp)
  80349d:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8034a4:	0f 8e d8 fe ff ff    	jle    803382 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8034aa:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8034b1:	e9 9d 00 00 00       	jmp    803553 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8034b6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8034bc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8034bf:	89 c8                	mov    %ecx,%eax
  8034c1:	01 c0                	add    %eax,%eax
  8034c3:	01 c8                	add    %ecx,%eax
  8034c5:	c1 e0 02             	shl    $0x2,%eax
  8034c8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034cd:	89 10                	mov    %edx,(%eax)
  8034cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034d2:	89 d0                	mov    %edx,%eax
  8034d4:	01 c0                	add    %eax,%eax
  8034d6:	01 d0                	add    %edx,%eax
  8034d8:	c1 e0 02             	shl    $0x2,%eax
  8034db:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034e0:	8b 00                	mov    (%eax),%eax
  8034e2:	85 c0                	test   %eax,%eax
  8034e4:	74 1c                	je     803502 <initialize_dynamic_allocator+0x228>
  8034e6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8034ec:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8034ef:	89 c8                	mov    %ecx,%eax
  8034f1:	01 c0                	add    %eax,%eax
  8034f3:	01 c8                	add    %ecx,%eax
  8034f5:	c1 e0 02             	shl    $0x2,%eax
  8034f8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034fd:	89 42 04             	mov    %eax,0x4(%edx)
  803500:	eb 16                	jmp    803518 <initialize_dynamic_allocator+0x23e>
  803502:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803505:	89 d0                	mov    %edx,%eax
  803507:	01 c0                	add    %eax,%eax
  803509:	01 d0                	add    %edx,%eax
  80350b:	c1 e0 02             	shl    $0x2,%eax
  80350e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803513:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803518:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80351b:	89 d0                	mov    %edx,%eax
  80351d:	01 c0                	add    %eax,%eax
  80351f:	01 d0                	add    %edx,%eax
  803521:	c1 e0 02             	shl    $0x2,%eax
  803524:	05 80 d0 81 00       	add    $0x81d080,%eax
  803529:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80352e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803531:	89 d0                	mov    %edx,%eax
  803533:	01 c0                	add    %eax,%eax
  803535:	01 d0                	add    %edx,%eax
  803537:	c1 e0 02             	shl    $0x2,%eax
  80353a:	05 84 d0 81 00       	add    $0x81d084,%eax
  80353f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803545:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80354a:	40                   	inc    %eax
  80354b:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803550:	ff 4d ec             	decl   -0x14(%ebp)
  803553:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803557:	0f 89 59 ff ff ff    	jns    8034b6 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  80355d:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803564:	00 00 00 
}
  803567:	90                   	nop
  803568:	c9                   	leave  
  803569:	c3                   	ret    

0080356a <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80356a:	55                   	push   %ebp
  80356b:	89 e5                	mov    %esp,%ebp
  80356d:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803570:	8b 45 08             	mov    0x8(%ebp),%eax
  803573:	83 ec 0c             	sub    $0xc,%esp
  803576:	50                   	push   %eax
  803577:	e8 10 fd ff ff       	call   80328c <to_page_info>
  80357c:	83 c4 10             	add    $0x10,%esp
  80357f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803585:	8b 40 08             	mov    0x8(%eax),%eax
  803588:	0f b7 c0             	movzwl %ax,%eax
}
  80358b:	c9                   	leave  
  80358c:	c3                   	ret    

0080358d <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80358d:	55                   	push   %ebp
  80358e:	89 e5                	mov    %esp,%ebp
  803590:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803593:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80359a:	76 16                	jbe    8035b2 <alloc_block+0x25>
  80359c:	68 dc 49 80 00       	push   $0x8049dc
  8035a1:	68 c6 49 80 00       	push   $0x8049c6
  8035a6:	6a 59                	push   $0x59
  8035a8:	68 63 49 80 00       	push   $0x804963
  8035ad:	e8 35 09 00 00       	call   803ee7 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8035b2:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8035b9:	eb 08                	jmp    8035c3 <alloc_block+0x36>
		allocSize <<= 1;
  8035bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035be:	01 c0                	add    %eax,%eax
  8035c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8035c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035c9:	73 09                	jae    8035d4 <alloc_block+0x47>
  8035cb:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8035d2:	76 e7                	jbe    8035bb <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8035d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8035db:	eb 03                	jmp    8035e0 <alloc_block+0x53>
		listIndex++;
  8035dd:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8035e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e3:	ba 08 00 00 00       	mov    $0x8,%edx
  8035e8:	88 c1                	mov    %al,%cl
  8035ea:	d3 e2                	shl    %cl,%edx
  8035ec:	89 d0                	mov    %edx,%eax
  8035ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8035f1:	72 ea                	jb     8035dd <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8035f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8035f9:	e9 f4 00 00 00       	jmp    8036f2 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8035fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803601:	c1 e0 04             	shl    $0x4,%eax
  803604:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803609:	8b 00                	mov    (%eax),%eax
  80360b:	85 c0                	test   %eax,%eax
  80360d:	0f 84 dc 00 00 00    	je     8036ef <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803616:	c1 e0 04             	shl    $0x4,%eax
  803619:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80361e:	8b 00                	mov    (%eax),%eax
  803620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803623:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803627:	75 14                	jne    80363d <alloc_block+0xb0>
  803629:	83 ec 04             	sub    $0x4,%esp
  80362c:	68 fd 49 80 00       	push   $0x8049fd
  803631:	6a 6b                	push   $0x6b
  803633:	68 63 49 80 00       	push   $0x804963
  803638:	e8 aa 08 00 00       	call   803ee7 <_panic>
  80363d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803640:	8b 00                	mov    (%eax),%eax
  803642:	85 c0                	test   %eax,%eax
  803644:	74 10                	je     803656 <alloc_block+0xc9>
  803646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803649:	8b 00                	mov    (%eax),%eax
  80364b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80364e:	8b 52 04             	mov    0x4(%edx),%edx
  803651:	89 50 04             	mov    %edx,0x4(%eax)
  803654:	eb 14                	jmp    80366a <alloc_block+0xdd>
  803656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803659:	8b 40 04             	mov    0x4(%eax),%eax
  80365c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80365f:	c1 e2 04             	shl    $0x4,%edx
  803662:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803668:	89 02                	mov    %eax,(%edx)
  80366a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366d:	8b 40 04             	mov    0x4(%eax),%eax
  803670:	85 c0                	test   %eax,%eax
  803672:	74 0f                	je     803683 <alloc_block+0xf6>
  803674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803677:	8b 40 04             	mov    0x4(%eax),%eax
  80367a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80367d:	8b 12                	mov    (%edx),%edx
  80367f:	89 10                	mov    %edx,(%eax)
  803681:	eb 13                	jmp    803696 <alloc_block+0x109>
  803683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803686:	8b 00                	mov    (%eax),%eax
  803688:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80368b:	c1 e2 04             	shl    $0x4,%edx
  80368e:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803694:	89 02                	mov    %eax,(%edx)
  803696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803699:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80369f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ac:	c1 e0 04             	shl    $0x4,%eax
  8036af:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8036b4:	8b 00                	mov    (%eax),%eax
  8036b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8036b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036bc:	c1 e0 04             	shl    $0x4,%eax
  8036bf:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8036c4:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8036c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c9:	83 ec 0c             	sub    $0xc,%esp
  8036cc:	50                   	push   %eax
  8036cd:	e8 ba fb ff ff       	call   80328c <to_page_info>
  8036d2:	83 c4 10             	add    $0x10,%esp
  8036d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  8036d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036db:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8036df:	48                   	dec    %eax
  8036e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036e3:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  8036e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ea:	e9 8f 02 00 00       	jmp    80397e <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8036ef:	ff 45 ec             	incl   -0x14(%ebp)
  8036f2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8036f6:	0f 8e 02 ff ff ff    	jle    8035fe <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  8036fc:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803701:	85 c0                	test   %eax,%eax
  803703:	75 14                	jne    803719 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803705:	83 ec 04             	sub    $0x4,%esp
  803708:	68 1c 4a 80 00       	push   $0x804a1c
  80370d:	6a 77                	push   $0x77
  80370f:	68 63 49 80 00       	push   $0x804963
  803714:	e8 ce 07 00 00       	call   803ee7 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803719:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80371e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803721:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803725:	75 14                	jne    80373b <alloc_block+0x1ae>
  803727:	83 ec 04             	sub    $0x4,%esp
  80372a:	68 fd 49 80 00       	push   $0x8049fd
  80372f:	6a 7a                	push   $0x7a
  803731:	68 63 49 80 00       	push   $0x804963
  803736:	e8 ac 07 00 00       	call   803ee7 <_panic>
  80373b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80373e:	8b 00                	mov    (%eax),%eax
  803740:	85 c0                	test   %eax,%eax
  803742:	74 10                	je     803754 <alloc_block+0x1c7>
  803744:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803747:	8b 00                	mov    (%eax),%eax
  803749:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80374c:	8b 52 04             	mov    0x4(%edx),%edx
  80374f:	89 50 04             	mov    %edx,0x4(%eax)
  803752:	eb 0b                	jmp    80375f <alloc_block+0x1d2>
  803754:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803757:	8b 40 04             	mov    0x4(%eax),%eax
  80375a:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80375f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803762:	8b 40 04             	mov    0x4(%eax),%eax
  803765:	85 c0                	test   %eax,%eax
  803767:	74 0f                	je     803778 <alloc_block+0x1eb>
  803769:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376c:	8b 40 04             	mov    0x4(%eax),%eax
  80376f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803772:	8b 12                	mov    (%edx),%edx
  803774:	89 10                	mov    %edx,(%eax)
  803776:	eb 0a                	jmp    803782 <alloc_block+0x1f5>
  803778:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80377b:	8b 00                	mov    (%eax),%eax
  80377d:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803782:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803785:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803795:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80379a:	48                   	dec    %eax
  80379b:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8037a0:	83 ec 0c             	sub    $0xc,%esp
  8037a3:	ff 75 dc             	pushl  -0x24(%ebp)
  8037a6:	e8 6f fa ff ff       	call   80321a <to_page_va>
  8037ab:	83 c4 10             	add    $0x10,%esp
  8037ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8037b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037b4:	83 ec 0c             	sub    $0xc,%esp
  8037b7:	50                   	push   %eax
  8037b8:	e8 a0 dc ff ff       	call   80145d <get_page>
  8037bd:	83 c4 10             	add    $0x10,%esp
  8037c0:	85 c0                	test   %eax,%eax
  8037c2:	74 14                	je     8037d8 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8037c4:	83 ec 04             	sub    $0x4,%esp
  8037c7:	68 44 4a 80 00       	push   $0x804a44
  8037cc:	6a 7f                	push   $0x7f
  8037ce:	68 63 49 80 00       	push   $0x804963
  8037d3:	e8 0f 07 00 00       	call   803ee7 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  8037d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037de:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  8037e2:	b8 00 10 00 00       	mov    $0x1000,%eax
  8037e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8037ec:	f7 75 f4             	divl   -0xc(%ebp)
  8037ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037f2:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8037f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8037fd:	e9 a7 00 00 00       	jmp    8038a9 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803802:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803805:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803808:	01 d0                	add    %edx,%eax
  80380a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  80380d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803811:	75 17                	jne    80382a <alloc_block+0x29d>
  803813:	83 ec 04             	sub    $0x4,%esp
  803816:	68 6c 4a 80 00       	push   $0x804a6c
  80381b:	68 88 00 00 00       	push   $0x88
  803820:	68 63 49 80 00       	push   $0x804963
  803825:	e8 bd 06 00 00       	call   803ee7 <_panic>
  80382a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382d:	c1 e0 04             	shl    $0x4,%eax
  803830:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803835:	8b 10                	mov    (%eax),%edx
  803837:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383a:	89 10                	mov    %edx,(%eax)
  80383c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383f:	8b 00                	mov    (%eax),%eax
  803841:	85 c0                	test   %eax,%eax
  803843:	74 15                	je     80385a <alloc_block+0x2cd>
  803845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803848:	c1 e0 04             	shl    $0x4,%eax
  80384b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803850:	8b 00                	mov    (%eax),%eax
  803852:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803855:	89 50 04             	mov    %edx,0x4(%eax)
  803858:	eb 11                	jmp    80386b <alloc_block+0x2de>
  80385a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385d:	c1 e0 04             	shl    $0x4,%eax
  803860:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803866:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803869:	89 02                	mov    %eax,(%edx)
  80386b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386e:	c1 e0 04             	shl    $0x4,%eax
  803871:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803877:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80387a:	89 02                	mov    %eax,(%edx)
  80387c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80387f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803889:	c1 e0 04             	shl    $0x4,%eax
  80388c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803891:	8b 00                	mov    (%eax),%eax
  803893:	8d 50 01             	lea    0x1(%eax),%edx
  803896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803899:	c1 e0 04             	shl    $0x4,%eax
  80389c:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8038a1:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8038a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a6:	01 45 e8             	add    %eax,-0x18(%ebp)
  8038a9:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8038b0:	0f 86 4c ff ff ff    	jbe    803802 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  8038b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b9:	c1 e0 04             	shl    $0x4,%eax
  8038bc:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038c1:	8b 00                	mov    (%eax),%eax
  8038c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  8038c6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8038ca:	75 17                	jne    8038e3 <alloc_block+0x356>
  8038cc:	83 ec 04             	sub    $0x4,%esp
  8038cf:	68 fd 49 80 00       	push   $0x8049fd
  8038d4:	68 8d 00 00 00       	push   $0x8d
  8038d9:	68 63 49 80 00       	push   $0x804963
  8038de:	e8 04 06 00 00       	call   803ee7 <_panic>
  8038e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038e6:	8b 00                	mov    (%eax),%eax
  8038e8:	85 c0                	test   %eax,%eax
  8038ea:	74 10                	je     8038fc <alloc_block+0x36f>
  8038ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038ef:	8b 00                	mov    (%eax),%eax
  8038f1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8038f4:	8b 52 04             	mov    0x4(%edx),%edx
  8038f7:	89 50 04             	mov    %edx,0x4(%eax)
  8038fa:	eb 14                	jmp    803910 <alloc_block+0x383>
  8038fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038ff:	8b 40 04             	mov    0x4(%eax),%eax
  803902:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803905:	c1 e2 04             	shl    $0x4,%edx
  803908:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  80390e:	89 02                	mov    %eax,(%edx)
  803910:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803913:	8b 40 04             	mov    0x4(%eax),%eax
  803916:	85 c0                	test   %eax,%eax
  803918:	74 0f                	je     803929 <alloc_block+0x39c>
  80391a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80391d:	8b 40 04             	mov    0x4(%eax),%eax
  803920:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803923:	8b 12                	mov    (%edx),%edx
  803925:	89 10                	mov    %edx,(%eax)
  803927:	eb 13                	jmp    80393c <alloc_block+0x3af>
  803929:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80392c:	8b 00                	mov    (%eax),%eax
  80392e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803931:	c1 e2 04             	shl    $0x4,%edx
  803934:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  80393a:	89 02                	mov    %eax,(%edx)
  80393c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80393f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803945:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803948:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80394f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803952:	c1 e0 04             	shl    $0x4,%eax
  803955:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80395a:	8b 00                	mov    (%eax),%eax
  80395c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80395f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803962:	c1 e0 04             	shl    $0x4,%eax
  803965:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80396a:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  80396c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80396f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803973:	48                   	dec    %eax
  803974:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803977:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  80397b:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  80397e:	c9                   	leave  
  80397f:	c3                   	ret    

00803980 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803980:	55                   	push   %ebp
  803981:	89 e5                	mov    %esp,%ebp
  803983:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803986:	8b 55 08             	mov    0x8(%ebp),%edx
  803989:	a1 84 50 83 00       	mov    0x835084,%eax
  80398e:	39 c2                	cmp    %eax,%edx
  803990:	72 0c                	jb     80399e <free_block+0x1e>
  803992:	8b 55 08             	mov    0x8(%ebp),%edx
  803995:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80399a:	39 c2                	cmp    %eax,%edx
  80399c:	72 19                	jb     8039b7 <free_block+0x37>
  80399e:	68 90 4a 80 00       	push   $0x804a90
  8039a3:	68 c6 49 80 00       	push   $0x8049c6
  8039a8:	68 98 00 00 00       	push   $0x98
  8039ad:	68 63 49 80 00       	push   $0x804963
  8039b2:	e8 30 05 00 00       	call   803ee7 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8039b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ba:	83 ec 0c             	sub    $0xc,%esp
  8039bd:	50                   	push   %eax
  8039be:	e8 c9 f8 ff ff       	call   80328c <to_page_info>
  8039c3:	83 c4 10             	add    $0x10,%esp
  8039c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  8039c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039cc:	8b 40 08             	mov    0x8(%eax),%eax
  8039cf:	0f b7 c0             	movzwl %ax,%eax
  8039d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  8039d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8039dc:	eb 03                	jmp    8039e1 <free_block+0x61>
		listIndex++;
  8039de:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e4:	ba 08 00 00 00       	mov    $0x8,%edx
  8039e9:	88 c1                	mov    %al,%cl
  8039eb:	d3 e2                	shl    %cl,%edx
  8039ed:	89 d0                	mov    %edx,%eax
  8039ef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039f2:	72 ea                	jb     8039de <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  8039f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  8039fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039fe:	75 17                	jne    803a17 <free_block+0x97>
  803a00:	83 ec 04             	sub    $0x4,%esp
  803a03:	68 6c 4a 80 00       	push   $0x804a6c
  803a08:	68 a2 00 00 00       	push   $0xa2
  803a0d:	68 63 49 80 00       	push   $0x804963
  803a12:	e8 d0 04 00 00       	call   803ee7 <_panic>
  803a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1a:	c1 e0 04             	shl    $0x4,%eax
  803a1d:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a22:	8b 10                	mov    (%eax),%edx
  803a24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a27:	89 10                	mov    %edx,(%eax)
  803a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2c:	8b 00                	mov    (%eax),%eax
  803a2e:	85 c0                	test   %eax,%eax
  803a30:	74 15                	je     803a47 <free_block+0xc7>
  803a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a35:	c1 e0 04             	shl    $0x4,%eax
  803a38:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a3d:	8b 00                	mov    (%eax),%eax
  803a3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a42:	89 50 04             	mov    %edx,0x4(%eax)
  803a45:	eb 11                	jmp    803a58 <free_block+0xd8>
  803a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4a:	c1 e0 04             	shl    $0x4,%eax
  803a4d:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803a53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a56:	89 02                	mov    %eax,(%edx)
  803a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5b:	c1 e0 04             	shl    $0x4,%eax
  803a5e:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803a64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a67:	89 02                	mov    %eax,(%edx)
  803a69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a76:	c1 e0 04             	shl    $0x4,%eax
  803a79:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a7e:	8b 00                	mov    (%eax),%eax
  803a80:	8d 50 01             	lea    0x1(%eax),%edx
  803a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a86:	c1 e0 04             	shl    $0x4,%eax
  803a89:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a8e:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a93:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a97:	40                   	inc    %eax
  803a98:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a9b:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aa2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803aa6:	0f b7 c8             	movzwl %ax,%ecx
  803aa9:	b8 00 10 00 00       	mov    $0x1000,%eax
  803aae:	ba 00 00 00 00       	mov    $0x0,%edx
  803ab3:	f7 75 e8             	divl   -0x18(%ebp)
  803ab6:	39 c1                	cmp    %eax,%ecx
  803ab8:	0f 85 ed 01 00 00    	jne    803cab <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac1:	c1 e0 04             	shl    $0x4,%eax
  803ac4:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ac9:	8b 00                	mov    (%eax),%eax
  803acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ace:	eb 2a                	jmp    803afa <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad3:	83 ec 0c             	sub    $0xc,%esp
  803ad6:	50                   	push   %eax
  803ad7:	e8 b0 f7 ff ff       	call   80328c <to_page_info>
  803adc:	83 c4 10             	add    $0x10,%esp
  803adf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803ae2:	75 06                	jne    803aea <free_block+0x16a>
				tmp = b;
  803ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aed:	c1 e0 04             	shl    $0x4,%eax
  803af0:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803af5:	8b 00                	mov    (%eax),%eax
  803af7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803afa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803afe:	74 07                	je     803b07 <free_block+0x187>
  803b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b03:	8b 00                	mov    (%eax),%eax
  803b05:	eb 05                	jmp    803b0c <free_block+0x18c>
  803b07:	b8 00 00 00 00       	mov    $0x0,%eax
  803b0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b0f:	c1 e2 04             	shl    $0x4,%edx
  803b12:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803b18:	89 02                	mov    %eax,(%edx)
  803b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1d:	c1 e0 04             	shl    $0x4,%eax
  803b20:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803b25:	8b 00                	mov    (%eax),%eax
  803b27:	85 c0                	test   %eax,%eax
  803b29:	75 a5                	jne    803ad0 <free_block+0x150>
  803b2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b2f:	75 9f                	jne    803ad0 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b34:	c1 e0 04             	shl    $0x4,%eax
  803b37:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b3c:	8b 00                	mov    (%eax),%eax
  803b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803b41:	e9 cc 00 00 00       	jmp    803c12 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b49:	8b 00                	mov    (%eax),%eax
  803b4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b51:	83 ec 0c             	sub    $0xc,%esp
  803b54:	50                   	push   %eax
  803b55:	e8 32 f7 ff ff       	call   80328c <to_page_info>
  803b5a:	83 c4 10             	add    $0x10,%esp
  803b5d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803b60:	0f 85 a6 00 00 00    	jne    803c0c <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803b66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b6a:	75 17                	jne    803b83 <free_block+0x203>
  803b6c:	83 ec 04             	sub    $0x4,%esp
  803b6f:	68 fd 49 80 00       	push   $0x8049fd
  803b74:	68 b5 00 00 00       	push   $0xb5
  803b79:	68 63 49 80 00       	push   $0x804963
  803b7e:	e8 64 03 00 00       	call   803ee7 <_panic>
  803b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b86:	8b 00                	mov    (%eax),%eax
  803b88:	85 c0                	test   %eax,%eax
  803b8a:	74 10                	je     803b9c <free_block+0x21c>
  803b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b8f:	8b 00                	mov    (%eax),%eax
  803b91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b94:	8b 52 04             	mov    0x4(%edx),%edx
  803b97:	89 50 04             	mov    %edx,0x4(%eax)
  803b9a:	eb 14                	jmp    803bb0 <free_block+0x230>
  803b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b9f:	8b 40 04             	mov    0x4(%eax),%eax
  803ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ba5:	c1 e2 04             	shl    $0x4,%edx
  803ba8:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803bae:	89 02                	mov    %eax,(%edx)
  803bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bb3:	8b 40 04             	mov    0x4(%eax),%eax
  803bb6:	85 c0                	test   %eax,%eax
  803bb8:	74 0f                	je     803bc9 <free_block+0x249>
  803bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bbd:	8b 40 04             	mov    0x4(%eax),%eax
  803bc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bc3:	8b 12                	mov    (%edx),%edx
  803bc5:	89 10                	mov    %edx,(%eax)
  803bc7:	eb 13                	jmp    803bdc <free_block+0x25c>
  803bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bcc:	8b 00                	mov    (%eax),%eax
  803bce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bd1:	c1 e2 04             	shl    $0x4,%edx
  803bd4:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803bda:	89 02                	mov    %eax,(%edx)
  803bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803be8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf2:	c1 e0 04             	shl    $0x4,%eax
  803bf5:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803bfa:	8b 00                	mov    (%eax),%eax
  803bfc:	8d 50 ff             	lea    -0x1(%eax),%edx
  803bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c02:	c1 e0 04             	shl    $0x4,%eax
  803c05:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c0a:	89 10                	mov    %edx,(%eax)
			b = next;
  803c0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803c12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c16:	0f 85 2a ff ff ff    	jne    803b46 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c1f:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c28:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803c2e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c32:	75 17                	jne    803c4b <free_block+0x2cb>
  803c34:	83 ec 04             	sub    $0x4,%esp
  803c37:	68 6c 4a 80 00       	push   $0x804a6c
  803c3c:	68 bc 00 00 00       	push   $0xbc
  803c41:	68 63 49 80 00       	push   $0x804963
  803c46:	e8 9c 02 00 00       	call   803ee7 <_panic>
  803c4b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c54:	89 10                	mov    %edx,(%eax)
  803c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c59:	8b 00                	mov    (%eax),%eax
  803c5b:	85 c0                	test   %eax,%eax
  803c5d:	74 0d                	je     803c6c <free_block+0x2ec>
  803c5f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803c64:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c67:	89 50 04             	mov    %edx,0x4(%eax)
  803c6a:	eb 08                	jmp    803c74 <free_block+0x2f4>
  803c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c6f:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c77:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c86:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803c8b:	40                   	inc    %eax
  803c8c:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803c91:	83 ec 0c             	sub    $0xc,%esp
  803c94:	ff 75 ec             	pushl  -0x14(%ebp)
  803c97:	e8 7e f5 ff ff       	call   80321a <to_page_va>
  803c9c:	83 c4 10             	add    $0x10,%esp
  803c9f:	83 ec 0c             	sub    $0xc,%esp
  803ca2:	50                   	push   %eax
  803ca3:	e8 fe d7 ff ff       	call   8014a6 <return_page>
  803ca8:	83 c4 10             	add    $0x10,%esp
	}
}
  803cab:	90                   	nop
  803cac:	c9                   	leave  
  803cad:	c3                   	ret    

00803cae <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803cae:	55                   	push   %ebp
  803caf:	89 e5                	mov    %esp,%ebp
  803cb1:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803cb4:	83 ec 04             	sub    $0x4,%esp
  803cb7:	68 c8 4a 80 00       	push   $0x804ac8
  803cbc:	6a 07                	push   $0x7
  803cbe:	68 f7 4a 80 00       	push   $0x804af7
  803cc3:	e8 1f 02 00 00       	call   803ee7 <_panic>

00803cc8 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803cc8:	55                   	push   %ebp
  803cc9:	89 e5                	mov    %esp,%ebp
  803ccb:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803cce:	83 ec 04             	sub    $0x4,%esp
  803cd1:	68 08 4b 80 00       	push   $0x804b08
  803cd6:	6a 0b                	push   $0xb
  803cd8:	68 f7 4a 80 00       	push   $0x804af7
  803cdd:	e8 05 02 00 00       	call   803ee7 <_panic>

00803ce2 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803ce2:	55                   	push   %ebp
  803ce3:	89 e5                	mov    %esp,%ebp
  803ce5:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803ce8:	83 ec 04             	sub    $0x4,%esp
  803ceb:	68 34 4b 80 00       	push   $0x804b34
  803cf0:	6a 10                	push   $0x10
  803cf2:	68 f7 4a 80 00       	push   $0x804af7
  803cf7:	e8 eb 01 00 00       	call   803ee7 <_panic>

00803cfc <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803cfc:	55                   	push   %ebp
  803cfd:	89 e5                	mov    %esp,%ebp
  803cff:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803d02:	83 ec 04             	sub    $0x4,%esp
  803d05:	68 64 4b 80 00       	push   $0x804b64
  803d0a:	6a 15                	push   $0x15
  803d0c:	68 f7 4a 80 00       	push   $0x804af7
  803d11:	e8 d1 01 00 00       	call   803ee7 <_panic>

00803d16 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803d16:	55                   	push   %ebp
  803d17:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803d19:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1c:	8b 40 10             	mov    0x10(%eax),%eax
}
  803d1f:	5d                   	pop    %ebp
  803d20:	c3                   	ret    

00803d21 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803d21:	55                   	push   %ebp
  803d22:	89 e5                	mov    %esp,%ebp
  803d24:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803d27:	8b 55 08             	mov    0x8(%ebp),%edx
  803d2a:	89 d0                	mov    %edx,%eax
  803d2c:	c1 e0 02             	shl    $0x2,%eax
  803d2f:	01 d0                	add    %edx,%eax
  803d31:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d38:	01 d0                	add    %edx,%eax
  803d3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d41:	01 d0                	add    %edx,%eax
  803d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803d4a:	01 d0                	add    %edx,%eax
  803d4c:	c1 e0 04             	shl    $0x4,%eax
  803d4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  803d52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803d59:	0f 31                	rdtsc  
  803d5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803d5e:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803d61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d64:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d6a:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803d6d:	eb 46                	jmp    803db5 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  803d6f:	0f 31                	rdtsc  
  803d71:	89 45 d0             	mov    %eax,-0x30(%ebp)
  803d74:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  803d77:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d7a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  803d80:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803d83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d89:	29 c2                	sub    %eax,%edx
  803d8b:	89 d0                	mov    %edx,%eax
  803d8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803d90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d96:	89 d1                	mov    %edx,%ecx
  803d98:	29 c1                	sub    %eax,%ecx
  803d9a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803da0:	39 c2                	cmp    %eax,%edx
  803da2:	0f 97 c0             	seta   %al
  803da5:	0f b6 c0             	movzbl %al,%eax
  803da8:	29 c1                	sub    %eax,%ecx
  803daa:	89 c8                	mov    %ecx,%eax
  803dac:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803daf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803db2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  803db5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803db8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803dbb:	72 b2                	jb     803d6f <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803dbd:	90                   	nop
  803dbe:	c9                   	leave  
  803dbf:	c3                   	ret    

00803dc0 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803dc0:	55                   	push   %ebp
  803dc1:	89 e5                	mov    %esp,%ebp
  803dc3:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803dc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803dcd:	eb 03                	jmp    803dd2 <busy_wait+0x12>
  803dcf:	ff 45 fc             	incl   -0x4(%ebp)
  803dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803dd5:	3b 45 08             	cmp    0x8(%ebp),%eax
  803dd8:	72 f5                	jb     803dcf <busy_wait+0xf>
	return i;
  803dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803ddd:	c9                   	leave  
  803dde:	c3                   	ret    

00803ddf <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  803ddf:	55                   	push   %ebp
  803de0:	89 e5                	mov    %esp,%ebp
  803de2:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  803de5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803de9:	74 1c                	je     803e07 <init_uspinlock+0x28>
  803deb:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  803def:	74 16                	je     803e07 <init_uspinlock+0x28>
  803df1:	68 94 4b 80 00       	push   $0x804b94
  803df6:	68 b3 4b 80 00       	push   $0x804bb3
  803dfb:	6a 10                	push   $0x10
  803dfd:	68 c8 4b 80 00       	push   $0x804bc8
  803e02:	e8 e0 00 00 00       	call   803ee7 <_panic>
	strcpy(lk->name, name);
  803e07:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0a:	83 c0 04             	add    $0x4,%eax
  803e0d:	83 ec 08             	sub    $0x8,%esp
  803e10:	ff 75 0c             	pushl  0xc(%ebp)
  803e13:	50                   	push   %eax
  803e14:	e8 33 ce ff ff       	call   800c4c <strcpy>
  803e19:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  803e1c:	b8 01 00 00 00       	mov    $0x1,%eax
  803e21:	2b 45 10             	sub    0x10(%ebp),%eax
  803e24:	89 c2                	mov    %eax,%edx
  803e26:	8b 45 08             	mov    0x8(%ebp),%eax
  803e29:	89 10                	mov    %edx,(%eax)
}
  803e2b:	90                   	nop
  803e2c:	c9                   	leave  
  803e2d:	c3                   	ret    

00803e2e <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  803e2e:	55                   	push   %ebp
  803e2f:	89 e5                	mov    %esp,%ebp
  803e31:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  803e34:	90                   	nop
  803e35:	8b 45 08             	mov    0x8(%ebp),%eax
  803e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e3b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803e42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e48:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803e4b:	f0 87 02             	lock xchg %eax,(%edx)
  803e4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  803e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e54:	85 c0                	test   %eax,%eax
  803e56:	75 dd                	jne    803e35 <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803e58:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5b:	8d 48 04             	lea    0x4(%eax),%ecx
  803e5e:	a1 20 50 80 00       	mov    0x805020,%eax
  803e63:	8d 50 20             	lea    0x20(%eax),%edx
  803e66:	a1 20 50 80 00       	mov    0x805020,%eax
  803e6b:	8b 40 10             	mov    0x10(%eax),%eax
  803e6e:	51                   	push   %ecx
  803e6f:	52                   	push   %edx
  803e70:	50                   	push   %eax
  803e71:	68 d8 4b 80 00       	push   $0x804bd8
  803e76:	e8 a9 c6 ff ff       	call   800524 <cprintf>
  803e7b:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  803e7e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  803e83:	90                   	nop
  803e84:	c9                   	leave  
  803e85:	c3                   	ret    

00803e86 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  803e86:	55                   	push   %ebp
  803e87:	89 e5                	mov    %esp,%ebp
  803e89:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  803e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e8f:	8b 00                	mov    (%eax),%eax
  803e91:	85 c0                	test   %eax,%eax
  803e93:	75 18                	jne    803ead <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  803e95:	8b 45 08             	mov    0x8(%ebp),%eax
  803e98:	83 c0 04             	add    $0x4,%eax
  803e9b:	50                   	push   %eax
  803e9c:	68 fc 4b 80 00       	push   $0x804bfc
  803ea1:	6a 2b                	push   $0x2b
  803ea3:	68 c8 4b 80 00       	push   $0x804bc8
  803ea8:	e8 3a 00 00 00       	call   803ee7 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  803ead:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  803eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  803eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  803ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec1:	8d 48 04             	lea    0x4(%eax),%ecx
  803ec4:	a1 20 50 80 00       	mov    0x805020,%eax
  803ec9:	8d 50 20             	lea    0x20(%eax),%edx
  803ecc:	a1 20 50 80 00       	mov    0x805020,%eax
  803ed1:	8b 40 10             	mov    0x10(%eax),%eax
  803ed4:	51                   	push   %ecx
  803ed5:	52                   	push   %edx
  803ed6:	50                   	push   %eax
  803ed7:	68 1c 4c 80 00       	push   $0x804c1c
  803edc:	e8 43 c6 ff ff       	call   800524 <cprintf>
  803ee1:	83 c4 10             	add    $0x10,%esp
}
  803ee4:	90                   	nop
  803ee5:	c9                   	leave  
  803ee6:	c3                   	ret    

00803ee7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803ee7:	55                   	push   %ebp
  803ee8:	89 e5                	mov    %esp,%ebp
  803eea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803eed:	8d 45 10             	lea    0x10(%ebp),%eax
  803ef0:	83 c0 04             	add    $0x4,%eax
  803ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803ef6:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803efb:	85 c0                	test   %eax,%eax
  803efd:	74 16                	je     803f15 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803eff:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803f04:	83 ec 08             	sub    $0x8,%esp
  803f07:	50                   	push   %eax
  803f08:	68 40 4c 80 00       	push   $0x804c40
  803f0d:	e8 12 c6 ff ff       	call   800524 <cprintf>
  803f12:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803f15:	a1 04 50 80 00       	mov    0x805004,%eax
  803f1a:	83 ec 0c             	sub    $0xc,%esp
  803f1d:	ff 75 0c             	pushl  0xc(%ebp)
  803f20:	ff 75 08             	pushl  0x8(%ebp)
  803f23:	50                   	push   %eax
  803f24:	68 48 4c 80 00       	push   $0x804c48
  803f29:	6a 74                	push   $0x74
  803f2b:	e8 21 c6 ff ff       	call   800551 <cprintf_colored>
  803f30:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803f33:	8b 45 10             	mov    0x10(%ebp),%eax
  803f36:	83 ec 08             	sub    $0x8,%esp
  803f39:	ff 75 f4             	pushl  -0xc(%ebp)
  803f3c:	50                   	push   %eax
  803f3d:	e8 73 c5 ff ff       	call   8004b5 <vcprintf>
  803f42:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803f45:	83 ec 08             	sub    $0x8,%esp
  803f48:	6a 00                	push   $0x0
  803f4a:	68 70 4c 80 00       	push   $0x804c70
  803f4f:	e8 61 c5 ff ff       	call   8004b5 <vcprintf>
  803f54:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803f57:	e8 da c4 ff ff       	call   800436 <exit>

	// should not return here
	while (1) ;
  803f5c:	eb fe                	jmp    803f5c <_panic+0x75>

00803f5e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803f5e:	55                   	push   %ebp
  803f5f:	89 e5                	mov    %esp,%ebp
  803f61:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803f64:	a1 20 50 80 00       	mov    0x805020,%eax
  803f69:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f72:	39 c2                	cmp    %eax,%edx
  803f74:	74 14                	je     803f8a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803f76:	83 ec 04             	sub    $0x4,%esp
  803f79:	68 74 4c 80 00       	push   $0x804c74
  803f7e:	6a 26                	push   $0x26
  803f80:	68 c0 4c 80 00       	push   $0x804cc0
  803f85:	e8 5d ff ff ff       	call   803ee7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803f8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803f91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803f98:	e9 c5 00 00 00       	jmp    804062 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  803faa:	01 d0                	add    %edx,%eax
  803fac:	8b 00                	mov    (%eax),%eax
  803fae:	85 c0                	test   %eax,%eax
  803fb0:	75 08                	jne    803fba <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803fb2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803fb5:	e9 a5 00 00 00       	jmp    80405f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803fba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803fc1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803fc8:	eb 69                	jmp    804033 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803fca:	a1 20 50 80 00       	mov    0x805020,%eax
  803fcf:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803fd5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fd8:	89 d0                	mov    %edx,%eax
  803fda:	01 c0                	add    %eax,%eax
  803fdc:	01 d0                	add    %edx,%eax
  803fde:	c1 e0 03             	shl    $0x3,%eax
  803fe1:	01 c8                	add    %ecx,%eax
  803fe3:	8a 40 04             	mov    0x4(%eax),%al
  803fe6:	84 c0                	test   %al,%al
  803fe8:	75 46                	jne    804030 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803fea:	a1 20 50 80 00       	mov    0x805020,%eax
  803fef:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803ff5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ff8:	89 d0                	mov    %edx,%eax
  803ffa:	01 c0                	add    %eax,%eax
  803ffc:	01 d0                	add    %edx,%eax
  803ffe:	c1 e0 03             	shl    $0x3,%eax
  804001:	01 c8                	add    %ecx,%eax
  804003:	8b 00                	mov    (%eax),%eax
  804005:	89 45 dc             	mov    %eax,-0x24(%ebp)
  804008:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80400b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  804010:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  804012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804015:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80401c:	8b 45 08             	mov    0x8(%ebp),%eax
  80401f:	01 c8                	add    %ecx,%eax
  804021:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804023:	39 c2                	cmp    %eax,%edx
  804025:	75 09                	jne    804030 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804027:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80402e:	eb 15                	jmp    804045 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804030:	ff 45 e8             	incl   -0x18(%ebp)
  804033:	a1 20 50 80 00       	mov    0x805020,%eax
  804038:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80403e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804041:	39 c2                	cmp    %eax,%edx
  804043:	77 85                	ja     803fca <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  804045:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804049:	75 14                	jne    80405f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80404b:	83 ec 04             	sub    $0x4,%esp
  80404e:	68 cc 4c 80 00       	push   $0x804ccc
  804053:	6a 3a                	push   $0x3a
  804055:	68 c0 4c 80 00       	push   $0x804cc0
  80405a:	e8 88 fe ff ff       	call   803ee7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80405f:	ff 45 f0             	incl   -0x10(%ebp)
  804062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804065:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804068:	0f 8c 2f ff ff ff    	jl     803f9d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80406e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804075:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80407c:	eb 26                	jmp    8040a4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80407e:	a1 20 50 80 00       	mov    0x805020,%eax
  804083:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  804089:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80408c:	89 d0                	mov    %edx,%eax
  80408e:	01 c0                	add    %eax,%eax
  804090:	01 d0                	add    %edx,%eax
  804092:	c1 e0 03             	shl    $0x3,%eax
  804095:	01 c8                	add    %ecx,%eax
  804097:	8a 40 04             	mov    0x4(%eax),%al
  80409a:	3c 01                	cmp    $0x1,%al
  80409c:	75 03                	jne    8040a1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80409e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8040a1:	ff 45 e0             	incl   -0x20(%ebp)
  8040a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8040a9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8040af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040b2:	39 c2                	cmp    %eax,%edx
  8040b4:	77 c8                	ja     80407e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8040b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8040bc:	74 14                	je     8040d2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8040be:	83 ec 04             	sub    $0x4,%esp
  8040c1:	68 20 4d 80 00       	push   $0x804d20
  8040c6:	6a 44                	push   $0x44
  8040c8:	68 c0 4c 80 00       	push   $0x804cc0
  8040cd:	e8 15 fe ff ff       	call   803ee7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8040d2:	90                   	nop
  8040d3:	c9                   	leave  
  8040d4:	c3                   	ret    
  8040d5:	66 90                	xchg   %ax,%ax
  8040d7:	90                   	nop

008040d8 <__udivdi3>:
  8040d8:	55                   	push   %ebp
  8040d9:	57                   	push   %edi
  8040da:	56                   	push   %esi
  8040db:	53                   	push   %ebx
  8040dc:	83 ec 1c             	sub    $0x1c,%esp
  8040df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040ef:	89 ca                	mov    %ecx,%edx
  8040f1:	89 f8                	mov    %edi,%eax
  8040f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040f7:	85 f6                	test   %esi,%esi
  8040f9:	75 2d                	jne    804128 <__udivdi3+0x50>
  8040fb:	39 cf                	cmp    %ecx,%edi
  8040fd:	77 65                	ja     804164 <__udivdi3+0x8c>
  8040ff:	89 fd                	mov    %edi,%ebp
  804101:	85 ff                	test   %edi,%edi
  804103:	75 0b                	jne    804110 <__udivdi3+0x38>
  804105:	b8 01 00 00 00       	mov    $0x1,%eax
  80410a:	31 d2                	xor    %edx,%edx
  80410c:	f7 f7                	div    %edi
  80410e:	89 c5                	mov    %eax,%ebp
  804110:	31 d2                	xor    %edx,%edx
  804112:	89 c8                	mov    %ecx,%eax
  804114:	f7 f5                	div    %ebp
  804116:	89 c1                	mov    %eax,%ecx
  804118:	89 d8                	mov    %ebx,%eax
  80411a:	f7 f5                	div    %ebp
  80411c:	89 cf                	mov    %ecx,%edi
  80411e:	89 fa                	mov    %edi,%edx
  804120:	83 c4 1c             	add    $0x1c,%esp
  804123:	5b                   	pop    %ebx
  804124:	5e                   	pop    %esi
  804125:	5f                   	pop    %edi
  804126:	5d                   	pop    %ebp
  804127:	c3                   	ret    
  804128:	39 ce                	cmp    %ecx,%esi
  80412a:	77 28                	ja     804154 <__udivdi3+0x7c>
  80412c:	0f bd fe             	bsr    %esi,%edi
  80412f:	83 f7 1f             	xor    $0x1f,%edi
  804132:	75 40                	jne    804174 <__udivdi3+0x9c>
  804134:	39 ce                	cmp    %ecx,%esi
  804136:	72 0a                	jb     804142 <__udivdi3+0x6a>
  804138:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80413c:	0f 87 9e 00 00 00    	ja     8041e0 <__udivdi3+0x108>
  804142:	b8 01 00 00 00       	mov    $0x1,%eax
  804147:	89 fa                	mov    %edi,%edx
  804149:	83 c4 1c             	add    $0x1c,%esp
  80414c:	5b                   	pop    %ebx
  80414d:	5e                   	pop    %esi
  80414e:	5f                   	pop    %edi
  80414f:	5d                   	pop    %ebp
  804150:	c3                   	ret    
  804151:	8d 76 00             	lea    0x0(%esi),%esi
  804154:	31 ff                	xor    %edi,%edi
  804156:	31 c0                	xor    %eax,%eax
  804158:	89 fa                	mov    %edi,%edx
  80415a:	83 c4 1c             	add    $0x1c,%esp
  80415d:	5b                   	pop    %ebx
  80415e:	5e                   	pop    %esi
  80415f:	5f                   	pop    %edi
  804160:	5d                   	pop    %ebp
  804161:	c3                   	ret    
  804162:	66 90                	xchg   %ax,%ax
  804164:	89 d8                	mov    %ebx,%eax
  804166:	f7 f7                	div    %edi
  804168:	31 ff                	xor    %edi,%edi
  80416a:	89 fa                	mov    %edi,%edx
  80416c:	83 c4 1c             	add    $0x1c,%esp
  80416f:	5b                   	pop    %ebx
  804170:	5e                   	pop    %esi
  804171:	5f                   	pop    %edi
  804172:	5d                   	pop    %ebp
  804173:	c3                   	ret    
  804174:	bd 20 00 00 00       	mov    $0x20,%ebp
  804179:	89 eb                	mov    %ebp,%ebx
  80417b:	29 fb                	sub    %edi,%ebx
  80417d:	89 f9                	mov    %edi,%ecx
  80417f:	d3 e6                	shl    %cl,%esi
  804181:	89 c5                	mov    %eax,%ebp
  804183:	88 d9                	mov    %bl,%cl
  804185:	d3 ed                	shr    %cl,%ebp
  804187:	89 e9                	mov    %ebp,%ecx
  804189:	09 f1                	or     %esi,%ecx
  80418b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80418f:	89 f9                	mov    %edi,%ecx
  804191:	d3 e0                	shl    %cl,%eax
  804193:	89 c5                	mov    %eax,%ebp
  804195:	89 d6                	mov    %edx,%esi
  804197:	88 d9                	mov    %bl,%cl
  804199:	d3 ee                	shr    %cl,%esi
  80419b:	89 f9                	mov    %edi,%ecx
  80419d:	d3 e2                	shl    %cl,%edx
  80419f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041a3:	88 d9                	mov    %bl,%cl
  8041a5:	d3 e8                	shr    %cl,%eax
  8041a7:	09 c2                	or     %eax,%edx
  8041a9:	89 d0                	mov    %edx,%eax
  8041ab:	89 f2                	mov    %esi,%edx
  8041ad:	f7 74 24 0c          	divl   0xc(%esp)
  8041b1:	89 d6                	mov    %edx,%esi
  8041b3:	89 c3                	mov    %eax,%ebx
  8041b5:	f7 e5                	mul    %ebp
  8041b7:	39 d6                	cmp    %edx,%esi
  8041b9:	72 19                	jb     8041d4 <__udivdi3+0xfc>
  8041bb:	74 0b                	je     8041c8 <__udivdi3+0xf0>
  8041bd:	89 d8                	mov    %ebx,%eax
  8041bf:	31 ff                	xor    %edi,%edi
  8041c1:	e9 58 ff ff ff       	jmp    80411e <__udivdi3+0x46>
  8041c6:	66 90                	xchg   %ax,%ax
  8041c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041cc:	89 f9                	mov    %edi,%ecx
  8041ce:	d3 e2                	shl    %cl,%edx
  8041d0:	39 c2                	cmp    %eax,%edx
  8041d2:	73 e9                	jae    8041bd <__udivdi3+0xe5>
  8041d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041d7:	31 ff                	xor    %edi,%edi
  8041d9:	e9 40 ff ff ff       	jmp    80411e <__udivdi3+0x46>
  8041de:	66 90                	xchg   %ax,%ax
  8041e0:	31 c0                	xor    %eax,%eax
  8041e2:	e9 37 ff ff ff       	jmp    80411e <__udivdi3+0x46>
  8041e7:	90                   	nop

008041e8 <__umoddi3>:
  8041e8:	55                   	push   %ebp
  8041e9:	57                   	push   %edi
  8041ea:	56                   	push   %esi
  8041eb:	53                   	push   %ebx
  8041ec:	83 ec 1c             	sub    $0x1c,%esp
  8041ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804203:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804207:	89 f3                	mov    %esi,%ebx
  804209:	89 fa                	mov    %edi,%edx
  80420b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80420f:	89 34 24             	mov    %esi,(%esp)
  804212:	85 c0                	test   %eax,%eax
  804214:	75 1a                	jne    804230 <__umoddi3+0x48>
  804216:	39 f7                	cmp    %esi,%edi
  804218:	0f 86 a2 00 00 00    	jbe    8042c0 <__umoddi3+0xd8>
  80421e:	89 c8                	mov    %ecx,%eax
  804220:	89 f2                	mov    %esi,%edx
  804222:	f7 f7                	div    %edi
  804224:	89 d0                	mov    %edx,%eax
  804226:	31 d2                	xor    %edx,%edx
  804228:	83 c4 1c             	add    $0x1c,%esp
  80422b:	5b                   	pop    %ebx
  80422c:	5e                   	pop    %esi
  80422d:	5f                   	pop    %edi
  80422e:	5d                   	pop    %ebp
  80422f:	c3                   	ret    
  804230:	39 f0                	cmp    %esi,%eax
  804232:	0f 87 ac 00 00 00    	ja     8042e4 <__umoddi3+0xfc>
  804238:	0f bd e8             	bsr    %eax,%ebp
  80423b:	83 f5 1f             	xor    $0x1f,%ebp
  80423e:	0f 84 ac 00 00 00    	je     8042f0 <__umoddi3+0x108>
  804244:	bf 20 00 00 00       	mov    $0x20,%edi
  804249:	29 ef                	sub    %ebp,%edi
  80424b:	89 fe                	mov    %edi,%esi
  80424d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804251:	89 e9                	mov    %ebp,%ecx
  804253:	d3 e0                	shl    %cl,%eax
  804255:	89 d7                	mov    %edx,%edi
  804257:	89 f1                	mov    %esi,%ecx
  804259:	d3 ef                	shr    %cl,%edi
  80425b:	09 c7                	or     %eax,%edi
  80425d:	89 e9                	mov    %ebp,%ecx
  80425f:	d3 e2                	shl    %cl,%edx
  804261:	89 14 24             	mov    %edx,(%esp)
  804264:	89 d8                	mov    %ebx,%eax
  804266:	d3 e0                	shl    %cl,%eax
  804268:	89 c2                	mov    %eax,%edx
  80426a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80426e:	d3 e0                	shl    %cl,%eax
  804270:	89 44 24 04          	mov    %eax,0x4(%esp)
  804274:	8b 44 24 08          	mov    0x8(%esp),%eax
  804278:	89 f1                	mov    %esi,%ecx
  80427a:	d3 e8                	shr    %cl,%eax
  80427c:	09 d0                	or     %edx,%eax
  80427e:	d3 eb                	shr    %cl,%ebx
  804280:	89 da                	mov    %ebx,%edx
  804282:	f7 f7                	div    %edi
  804284:	89 d3                	mov    %edx,%ebx
  804286:	f7 24 24             	mull   (%esp)
  804289:	89 c6                	mov    %eax,%esi
  80428b:	89 d1                	mov    %edx,%ecx
  80428d:	39 d3                	cmp    %edx,%ebx
  80428f:	0f 82 87 00 00 00    	jb     80431c <__umoddi3+0x134>
  804295:	0f 84 91 00 00 00    	je     80432c <__umoddi3+0x144>
  80429b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80429f:	29 f2                	sub    %esi,%edx
  8042a1:	19 cb                	sbb    %ecx,%ebx
  8042a3:	89 d8                	mov    %ebx,%eax
  8042a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042a9:	d3 e0                	shl    %cl,%eax
  8042ab:	89 e9                	mov    %ebp,%ecx
  8042ad:	d3 ea                	shr    %cl,%edx
  8042af:	09 d0                	or     %edx,%eax
  8042b1:	89 e9                	mov    %ebp,%ecx
  8042b3:	d3 eb                	shr    %cl,%ebx
  8042b5:	89 da                	mov    %ebx,%edx
  8042b7:	83 c4 1c             	add    $0x1c,%esp
  8042ba:	5b                   	pop    %ebx
  8042bb:	5e                   	pop    %esi
  8042bc:	5f                   	pop    %edi
  8042bd:	5d                   	pop    %ebp
  8042be:	c3                   	ret    
  8042bf:	90                   	nop
  8042c0:	89 fd                	mov    %edi,%ebp
  8042c2:	85 ff                	test   %edi,%edi
  8042c4:	75 0b                	jne    8042d1 <__umoddi3+0xe9>
  8042c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8042cb:	31 d2                	xor    %edx,%edx
  8042cd:	f7 f7                	div    %edi
  8042cf:	89 c5                	mov    %eax,%ebp
  8042d1:	89 f0                	mov    %esi,%eax
  8042d3:	31 d2                	xor    %edx,%edx
  8042d5:	f7 f5                	div    %ebp
  8042d7:	89 c8                	mov    %ecx,%eax
  8042d9:	f7 f5                	div    %ebp
  8042db:	89 d0                	mov    %edx,%eax
  8042dd:	e9 44 ff ff ff       	jmp    804226 <__umoddi3+0x3e>
  8042e2:	66 90                	xchg   %ax,%ax
  8042e4:	89 c8                	mov    %ecx,%eax
  8042e6:	89 f2                	mov    %esi,%edx
  8042e8:	83 c4 1c             	add    $0x1c,%esp
  8042eb:	5b                   	pop    %ebx
  8042ec:	5e                   	pop    %esi
  8042ed:	5f                   	pop    %edi
  8042ee:	5d                   	pop    %ebp
  8042ef:	c3                   	ret    
  8042f0:	3b 04 24             	cmp    (%esp),%eax
  8042f3:	72 06                	jb     8042fb <__umoddi3+0x113>
  8042f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042f9:	77 0f                	ja     80430a <__umoddi3+0x122>
  8042fb:	89 f2                	mov    %esi,%edx
  8042fd:	29 f9                	sub    %edi,%ecx
  8042ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804303:	89 14 24             	mov    %edx,(%esp)
  804306:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80430a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80430e:	8b 14 24             	mov    (%esp),%edx
  804311:	83 c4 1c             	add    $0x1c,%esp
  804314:	5b                   	pop    %ebx
  804315:	5e                   	pop    %esi
  804316:	5f                   	pop    %edi
  804317:	5d                   	pop    %ebp
  804318:	c3                   	ret    
  804319:	8d 76 00             	lea    0x0(%esi),%esi
  80431c:	2b 04 24             	sub    (%esp),%eax
  80431f:	19 fa                	sbb    %edi,%edx
  804321:	89 d1                	mov    %edx,%ecx
  804323:	89 c6                	mov    %eax,%esi
  804325:	e9 71 ff ff ff       	jmp    80429b <__umoddi3+0xb3>
  80432a:	66 90                	xchg   %ax,%ax
  80432c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804330:	72 ea                	jb     80431c <__umoddi3+0x134>
  804332:	89 d9                	mov    %ebx,%ecx
  804334:	e9 62 ff ff ff       	jmp    80429b <__umoddi3+0xb3>
