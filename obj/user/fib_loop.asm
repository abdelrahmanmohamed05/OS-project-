
obj/user/fib_loop:     file format elf32-i386


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
  800031:	e8 41 01 00 00       	call   800177 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n, int64 *memo);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int index=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 40 42 80 00       	push   $0x804240
  800057:	e8 83 0b 00 00       	call   800bdf <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 85 10 00 00       	call   8010f7 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 49 15 00 00       	call   8015d1 <malloc>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 res = fibonacci(index, memo) ;
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	ff 75 f4             	pushl  -0xc(%ebp)
  800097:	e8 35 00 00 00       	call   8000d1 <fibonacci>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8000a2:	89 55 ec             	mov    %edx,-0x14(%ebp)

	free(memo);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ab:	e8 81 18 00 00       	call   801931 <free>
  8000b0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000bc:	68 5e 42 80 00       	push   $0x80425e
  8000c1:	e8 b3 03 00 00       	call   800479 <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 b2 30 00 00       	call   803180 <inctst>
	return;
  8000ce:	90                   	nop
}
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    

008000d1 <fibonacci>:


int64 fibonacci(int n, int64 *memo)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i <= n; ++i)
  8000d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000e0:	eb 72                	jmp    800154 <fibonacci+0x83>
	{
		if (i <= 1)
  8000e2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8000e6:	7f 1e                	jg     800106 <fibonacci+0x35>
			memo[i] = 1;
  8000e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  8000fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  800104:	eb 4b                	jmp    800151 <fibonacci+0x80>
		else
			memo[i] = memo[i-1] + memo[i-2] ;
  800106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800109:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800110:	8b 45 0c             	mov    0xc(%ebp),%eax
  800113:	8d 34 02             	lea    (%edx,%eax,1),%esi
  800116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800119:	05 ff ff ff 1f       	add    $0x1fffffff,%eax
  80011e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	01 d0                	add    %edx,%eax
  80012a:	8b 08                	mov    (%eax),%ecx
  80012c:	8b 58 04             	mov    0x4(%eax),%ebx
  80012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800132:	05 fe ff ff 1f       	add    $0x1ffffffe,%eax
  800137:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80013e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800141:	01 d0                	add    %edx,%eax
  800143:	8b 50 04             	mov    0x4(%eax),%edx
  800146:	8b 00                	mov    (%eax),%eax
  800148:	01 c8                	add    %ecx,%eax
  80014a:	11 da                	adc    %ebx,%edx
  80014c:	89 06                	mov    %eax,(%esi)
  80014e:	89 56 04             	mov    %edx,0x4(%esi)
}


int64 fibonacci(int n, int64 *memo)
{
	for (int i = 0; i <= n; ++i)
  800151:	ff 45 f4             	incl   -0xc(%ebp)
  800154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800157:	3b 45 08             	cmp    0x8(%ebp),%eax
  80015a:	7e 86                	jle    8000e2 <fibonacci+0x11>
		if (i <= 1)
			memo[i] = 1;
		else
			memo[i] = memo[i-1] + memo[i-2] ;
	}
	return memo[n];
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800166:	8b 45 0c             	mov    0xc(%ebp),%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	8b 50 04             	mov    0x4(%eax),%edx
  80016e:	8b 00                	mov    (%eax),%eax
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	5b                   	pop    %ebx
  800174:	5e                   	pop    %esi
  800175:	5d                   	pop    %ebp
  800176:	c3                   	ret    

00800177 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	57                   	push   %edi
  80017b:	56                   	push   %esi
  80017c:	53                   	push   %ebx
  80017d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800180:	e8 bd 2e 00 00       	call   803042 <sys_getenvindex>
  800185:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800188:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	c1 e0 03             	shl    $0x3,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	c1 e0 02             	shl    $0x2,%eax
  800195:	01 d0                	add    %edx,%eax
  800197:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80019e:	01 d0                	add    %edx,%eax
  8001a0:	c1 e0 03             	shl    $0x3,%eax
  8001a3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a8:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b2:	8a 40 20             	mov    0x20(%eax),%al
  8001b5:	84 c0                	test   %al,%al
  8001b7:	74 0d                	je     8001c6 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8001be:	83 c0 20             	add    $0x20,%eax
  8001c1:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ca:	7e 0a                	jle    8001d6 <libmain+0x5f>
		binaryname = argv[0];
  8001cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cf:	8b 00                	mov    (%eax),%eax
  8001d1:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	ff 75 0c             	pushl  0xc(%ebp)
  8001dc:	ff 75 08             	pushl  0x8(%ebp)
  8001df:	e8 54 fe ff ff       	call   800038 <_main>
  8001e4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001e7:	a1 00 50 80 00       	mov    0x805000,%eax
  8001ec:	85 c0                	test   %eax,%eax
  8001ee:	0f 84 01 01 00 00    	je     8002f5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001f4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001fa:	bb 6c 43 80 00       	mov    $0x80436c,%ebx
  8001ff:	ba 0e 00 00 00       	mov    $0xe,%edx
  800204:	89 c7                	mov    %eax,%edi
  800206:	89 de                	mov    %ebx,%esi
  800208:	89 d1                	mov    %edx,%ecx
  80020a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80020c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80020f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800214:	b0 00                	mov    $0x0,%al
  800216:	89 d7                	mov    %edx,%edi
  800218:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80021a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800221:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	50                   	push   %eax
  800228:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80022e:	50                   	push   %eax
  80022f:	e8 44 30 00 00       	call   803278 <sys_utilities>
  800234:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800237:	e8 8d 2b 00 00       	call   802dc9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	68 8c 42 80 00       	push   $0x80428c
  800244:	e8 be 01 00 00       	call   800407 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80024c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024f:	85 c0                	test   %eax,%eax
  800251:	74 18                	je     80026b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800253:	e8 3e 30 00 00       	call   803296 <sys_get_optimal_num_faults>
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	50                   	push   %eax
  80025c:	68 b4 42 80 00       	push   $0x8042b4
  800261:	e8 a1 01 00 00       	call   800407 <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	eb 59                	jmp    8002c4 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80026b:	a1 20 50 80 00       	mov    0x805020,%eax
  800270:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800276:	a1 20 50 80 00       	mov    0x805020,%eax
  80027b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800281:	83 ec 04             	sub    $0x4,%esp
  800284:	52                   	push   %edx
  800285:	50                   	push   %eax
  800286:	68 d8 42 80 00       	push   $0x8042d8
  80028b:	e8 77 01 00 00       	call   800407 <cprintf>
  800290:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800293:	a1 20 50 80 00       	mov    0x805020,%eax
  800298:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80029e:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a3:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8002a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ae:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002b4:	51                   	push   %ecx
  8002b5:	52                   	push   %edx
  8002b6:	50                   	push   %eax
  8002b7:	68 00 43 80 00       	push   $0x804300
  8002bc:	e8 46 01 00 00       	call   800407 <cprintf>
  8002c1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c9:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8002cf:	83 ec 08             	sub    $0x8,%esp
  8002d2:	50                   	push   %eax
  8002d3:	68 58 43 80 00       	push   $0x804358
  8002d8:	e8 2a 01 00 00       	call   800407 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 8c 42 80 00       	push   $0x80428c
  8002e8:	e8 1a 01 00 00       	call   800407 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002f0:	e8 ee 2a 00 00       	call   802de3 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002f5:	e8 1f 00 00 00       	call   800319 <exit>
}
  8002fa:	90                   	nop
  8002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fe:	5b                   	pop    %ebx
  8002ff:	5e                   	pop    %esi
  800300:	5f                   	pop    %edi
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	6a 00                	push   $0x0
  80030e:	e8 fb 2c 00 00       	call   80300e <sys_destroy_env>
  800313:	83 c4 10             	add    $0x10,%esp
}
  800316:	90                   	nop
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <exit>:

void
exit(void)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031f:	e8 50 2d 00 00       	call   803074 <sys_exit_env>
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	53                   	push   %ebx
  80032b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80032e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800331:	8b 00                	mov    (%eax),%eax
  800333:	8d 48 01             	lea    0x1(%eax),%ecx
  800336:	8b 55 0c             	mov    0xc(%ebp),%edx
  800339:	89 0a                	mov    %ecx,(%edx)
  80033b:	8b 55 08             	mov    0x8(%ebp),%edx
  80033e:	88 d1                	mov    %dl,%cl
  800340:	8b 55 0c             	mov    0xc(%ebp),%edx
  800343:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	8b 00                	mov    (%eax),%eax
  80034c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800351:	75 30                	jne    800383 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800353:	8b 15 38 51 83 00    	mov    0x835138,%edx
  800359:	a0 64 d0 81 00       	mov    0x81d064,%al
  80035e:	0f b6 c0             	movzbl %al,%eax
  800361:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800364:	8b 09                	mov    (%ecx),%ecx
  800366:	89 cb                	mov    %ecx,%ebx
  800368:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80036b:	83 c1 08             	add    $0x8,%ecx
  80036e:	52                   	push   %edx
  80036f:	50                   	push   %eax
  800370:	53                   	push   %ebx
  800371:	51                   	push   %ecx
  800372:	e8 0e 2a 00 00       	call   802d85 <sys_cputs>
  800377:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80037a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800383:	8b 45 0c             	mov    0xc(%ebp),%eax
  800386:	8b 40 04             	mov    0x4(%eax),%eax
  800389:	8d 50 01             	lea    0x1(%eax),%edx
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800392:	90                   	nop
  800393:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800396:	c9                   	leave  
  800397:	c3                   	ret    

00800398 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003a1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a8:	00 00 00 
	b.cnt = 0;
  8003ab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003b5:	ff 75 0c             	pushl  0xc(%ebp)
  8003b8:	ff 75 08             	pushl  0x8(%ebp)
  8003bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c1:	50                   	push   %eax
  8003c2:	68 27 03 80 00       	push   $0x800327
  8003c7:	e8 5a 02 00 00       	call   800626 <vprintfmt>
  8003cc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8003cf:	8b 15 38 51 83 00    	mov    0x835138,%edx
  8003d5:	a0 64 d0 81 00       	mov    0x81d064,%al
  8003da:	0f b6 c0             	movzbl %al,%eax
  8003dd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003e3:	52                   	push   %edx
  8003e4:	50                   	push   %eax
  8003e5:	51                   	push   %ecx
  8003e6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ec:	83 c0 08             	add    $0x8,%eax
  8003ef:	50                   	push   %eax
  8003f0:	e8 90 29 00 00       	call   802d85 <sys_cputs>
  8003f5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003f8:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  8003ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800405:	c9                   	leave  
  800406:	c3                   	ret    

00800407 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80040d:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800414:	8d 45 0c             	lea    0xc(%ebp),%eax
  800417:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	ff 75 f4             	pushl  -0xc(%ebp)
  800423:	50                   	push   %eax
  800424:	e8 6f ff ff ff       	call   800398 <vcprintf>
  800429:	83 c4 10             	add    $0x10,%esp
  80042c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80042f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80043a:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	c1 e0 08             	shl    $0x8,%eax
  800447:	a3 38 51 83 00       	mov    %eax,0x835138
	va_start(ap, fmt);
  80044c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80044f:	83 c0 04             	add    $0x4,%eax
  800452:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800455:	8b 45 0c             	mov    0xc(%ebp),%eax
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 f4             	pushl  -0xc(%ebp)
  80045e:	50                   	push   %eax
  80045f:	e8 34 ff ff ff       	call   800398 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
  800467:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80046a:	c7 05 38 51 83 00 00 	movl   $0x700,0x835138
  800471:	07 00 00 

	return cnt;
  800474:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800477:	c9                   	leave  
  800478:	c3                   	ret    

00800479 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80047f:	e8 45 29 00 00       	call   802dc9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800484:	8d 45 0c             	lea    0xc(%ebp),%eax
  800487:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	ff 75 f4             	pushl  -0xc(%ebp)
  800493:	50                   	push   %eax
  800494:	e8 ff fe ff ff       	call   800398 <vcprintf>
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80049f:	e8 3f 29 00 00       	call   802de3 <sys_unlock_cons>
	return cnt;
  8004a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004a7:	c9                   	leave  
  8004a8:	c3                   	ret    

008004a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a9:	55                   	push   %ebp
  8004aa:	89 e5                	mov    %esp,%ebp
  8004ac:	53                   	push   %ebx
  8004ad:	83 ec 14             	sub    $0x14,%esp
  8004b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004bc:	8b 45 18             	mov    0x18(%ebp),%eax
  8004bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004c7:	77 55                	ja     80051e <printnum+0x75>
  8004c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004cc:	72 05                	jb     8004d3 <printnum+0x2a>
  8004ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004d1:	77 4b                	ja     80051e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004d6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8004dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e1:	52                   	push   %edx
  8004e2:	50                   	push   %eax
  8004e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8004e9:	e8 d6 3a 00 00       	call   803fc4 <__udivdi3>
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	ff 75 20             	pushl  0x20(%ebp)
  8004f7:	53                   	push   %ebx
  8004f8:	ff 75 18             	pushl  0x18(%ebp)
  8004fb:	52                   	push   %edx
  8004fc:	50                   	push   %eax
  8004fd:	ff 75 0c             	pushl  0xc(%ebp)
  800500:	ff 75 08             	pushl  0x8(%ebp)
  800503:	e8 a1 ff ff ff       	call   8004a9 <printnum>
  800508:	83 c4 20             	add    $0x20,%esp
  80050b:	eb 1a                	jmp    800527 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	ff 75 0c             	pushl  0xc(%ebp)
  800513:	ff 75 20             	pushl  0x20(%ebp)
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	ff d0                	call   *%eax
  80051b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051e:	ff 4d 1c             	decl   0x1c(%ebp)
  800521:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800525:	7f e6                	jg     80050d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800527:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80052a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80052f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800535:	53                   	push   %ebx
  800536:	51                   	push   %ecx
  800537:	52                   	push   %edx
  800538:	50                   	push   %eax
  800539:	e8 96 3b 00 00       	call   8040d4 <__umoddi3>
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	05 f4 45 80 00       	add    $0x8045f4,%eax
  800546:	8a 00                	mov    (%eax),%al
  800548:	0f be c0             	movsbl %al,%eax
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	ff 75 0c             	pushl  0xc(%ebp)
  800551:	50                   	push   %eax
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	ff d0                	call   *%eax
  800557:	83 c4 10             	add    $0x10,%esp
}
  80055a:	90                   	nop
  80055b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800563:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800567:	7e 1c                	jle    800585 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	8d 50 08             	lea    0x8(%eax),%edx
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	89 10                	mov    %edx,(%eax)
  800576:	8b 45 08             	mov    0x8(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	83 e8 08             	sub    $0x8,%eax
  80057e:	8b 50 04             	mov    0x4(%eax),%edx
  800581:	8b 00                	mov    (%eax),%eax
  800583:	eb 40                	jmp    8005c5 <getuint+0x65>
	else if (lflag)
  800585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800589:	74 1e                	je     8005a9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	8d 50 04             	lea    0x4(%eax),%edx
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	89 10                	mov    %edx,(%eax)
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	83 e8 04             	sub    $0x4,%eax
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a7:	eb 1c                	jmp    8005c5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	8d 50 04             	lea    0x4(%eax),%edx
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	89 10                	mov    %edx,(%eax)
  8005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	83 e8 04             	sub    $0x4,%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005c5:	5d                   	pop    %ebp
  8005c6:	c3                   	ret    

008005c7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005ca:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ce:	7e 1c                	jle    8005ec <getint+0x25>
		return va_arg(*ap, long long);
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	8d 50 08             	lea    0x8(%eax),%edx
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	89 10                	mov    %edx,(%eax)
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 e8 08             	sub    $0x8,%eax
  8005e5:	8b 50 04             	mov    0x4(%eax),%edx
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	eb 38                	jmp    800624 <getint+0x5d>
	else if (lflag)
  8005ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f0:	74 1a                	je     80060c <getint+0x45>
		return va_arg(*ap, long);
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	8d 50 04             	lea    0x4(%eax),%edx
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	89 10                	mov    %edx,(%eax)
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	83 e8 04             	sub    $0x4,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	99                   	cltd   
  80060a:	eb 18                	jmp    800624 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80060c:	8b 45 08             	mov    0x8(%ebp),%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	8d 50 04             	lea    0x4(%eax),%edx
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	89 10                	mov    %edx,(%eax)
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	8b 00                	mov    (%eax),%eax
  80061e:	83 e8 04             	sub    $0x4,%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	99                   	cltd   
}
  800624:	5d                   	pop    %ebp
  800625:	c3                   	ret    

00800626 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	56                   	push   %esi
  80062a:	53                   	push   %ebx
  80062b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80062e:	eb 17                	jmp    800647 <vprintfmt+0x21>
			if (ch == '\0')
  800630:	85 db                	test   %ebx,%ebx
  800632:	0f 84 c1 03 00 00    	je     8009f9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 0c             	pushl  0xc(%ebp)
  80063e:	53                   	push   %ebx
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	ff d0                	call   *%eax
  800644:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800647:	8b 45 10             	mov    0x10(%ebp),%eax
  80064a:	8d 50 01             	lea    0x1(%eax),%edx
  80064d:	89 55 10             	mov    %edx,0x10(%ebp)
  800650:	8a 00                	mov    (%eax),%al
  800652:	0f b6 d8             	movzbl %al,%ebx
  800655:	83 fb 25             	cmp    $0x25,%ebx
  800658:	75 d6                	jne    800630 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80065a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80065e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800665:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80066c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800673:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067a:	8b 45 10             	mov    0x10(%ebp),%eax
  80067d:	8d 50 01             	lea    0x1(%eax),%edx
  800680:	89 55 10             	mov    %edx,0x10(%ebp)
  800683:	8a 00                	mov    (%eax),%al
  800685:	0f b6 d8             	movzbl %al,%ebx
  800688:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80068b:	83 f8 5b             	cmp    $0x5b,%eax
  80068e:	0f 87 3d 03 00 00    	ja     8009d1 <vprintfmt+0x3ab>
  800694:	8b 04 85 18 46 80 00 	mov    0x804618(,%eax,4),%eax
  80069b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80069d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006a1:	eb d7                	jmp    80067a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006a3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006a7:	eb d1                	jmp    80067a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006b3:	89 d0                	mov    %edx,%eax
  8006b5:	c1 e0 02             	shl    $0x2,%eax
  8006b8:	01 d0                	add    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d8                	add    %ebx,%eax
  8006be:	83 e8 30             	sub    $0x30,%eax
  8006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c7:	8a 00                	mov    (%eax),%al
  8006c9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006cc:	83 fb 2f             	cmp    $0x2f,%ebx
  8006cf:	7e 3e                	jle    80070f <vprintfmt+0xe9>
  8006d1:	83 fb 39             	cmp    $0x39,%ebx
  8006d4:	7f 39                	jg     80070f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006d9:	eb d5                	jmp    8006b0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	83 c0 04             	add    $0x4,%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	83 e8 04             	sub    $0x4,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006ef:	eb 1f                	jmp    800710 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f5:	79 83                	jns    80067a <vprintfmt+0x54>
				width = 0;
  8006f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006fe:	e9 77 ff ff ff       	jmp    80067a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800703:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80070a:	e9 6b ff ff ff       	jmp    80067a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80070f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800714:	0f 89 60 ff ff ff    	jns    80067a <vprintfmt+0x54>
				width = precision, precision = -1;
  80071a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800720:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800727:	e9 4e ff ff ff       	jmp    80067a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80072c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80072f:	e9 46 ff ff ff       	jmp    80067a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	83 c0 04             	add    $0x4,%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	83 e8 04             	sub    $0x4,%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 0c             	pushl  0xc(%ebp)
  80074b:	50                   	push   %eax
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	ff d0                	call   *%eax
  800751:	83 c4 10             	add    $0x10,%esp
			break;
  800754:	e9 9b 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	83 c0 04             	add    $0x4,%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	83 e8 04             	sub    $0x4,%eax
  800768:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80076a:	85 db                	test   %ebx,%ebx
  80076c:	79 02                	jns    800770 <vprintfmt+0x14a>
				err = -err;
  80076e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800770:	83 fb 64             	cmp    $0x64,%ebx
  800773:	7f 0b                	jg     800780 <vprintfmt+0x15a>
  800775:	8b 34 9d 60 44 80 00 	mov    0x804460(,%ebx,4),%esi
  80077c:	85 f6                	test   %esi,%esi
  80077e:	75 19                	jne    800799 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800780:	53                   	push   %ebx
  800781:	68 05 46 80 00       	push   $0x804605
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	ff 75 08             	pushl  0x8(%ebp)
  80078c:	e8 70 02 00 00       	call   800a01 <printfmt>
  800791:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800794:	e9 5b 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800799:	56                   	push   %esi
  80079a:	68 0e 46 80 00       	push   $0x80460e
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	ff 75 08             	pushl  0x8(%ebp)
  8007a5:	e8 57 02 00 00       	call   800a01 <printfmt>
  8007aa:	83 c4 10             	add    $0x10,%esp
			break;
  8007ad:	e9 42 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	83 c0 04             	add    $0x4,%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	83 e8 04             	sub    $0x4,%eax
  8007c1:	8b 30                	mov    (%eax),%esi
  8007c3:	85 f6                	test   %esi,%esi
  8007c5:	75 05                	jne    8007cc <vprintfmt+0x1a6>
				p = "(null)";
  8007c7:	be 11 46 80 00       	mov    $0x804611,%esi
			if (width > 0 && padc != '-')
  8007cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d0:	7e 6d                	jle    80083f <vprintfmt+0x219>
  8007d2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007d6:	74 67                	je     80083f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	50                   	push   %eax
  8007df:	56                   	push   %esi
  8007e0:	e8 26 05 00 00       	call   800d0b <strnlen>
  8007e5:	83 c4 10             	add    $0x10,%esp
  8007e8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007eb:	eb 16                	jmp    800803 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007ed:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	ff d0                	call   *%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800800:	ff 4d e4             	decl   -0x1c(%ebp)
  800803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800807:	7f e4                	jg     8007ed <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800809:	eb 34                	jmp    80083f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80080b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80080f:	74 1c                	je     80082d <vprintfmt+0x207>
  800811:	83 fb 1f             	cmp    $0x1f,%ebx
  800814:	7e 05                	jle    80081b <vprintfmt+0x1f5>
  800816:	83 fb 7e             	cmp    $0x7e,%ebx
  800819:	7e 12                	jle    80082d <vprintfmt+0x207>
					putch('?', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	6a 3f                	push   $0x3f
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	eb 0f                	jmp    80083c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	53                   	push   %ebx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	ff d0                	call   *%eax
  800839:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083c:	ff 4d e4             	decl   -0x1c(%ebp)
  80083f:	89 f0                	mov    %esi,%eax
  800841:	8d 70 01             	lea    0x1(%eax),%esi
  800844:	8a 00                	mov    (%eax),%al
  800846:	0f be d8             	movsbl %al,%ebx
  800849:	85 db                	test   %ebx,%ebx
  80084b:	74 24                	je     800871 <vprintfmt+0x24b>
  80084d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800851:	78 b8                	js     80080b <vprintfmt+0x1e5>
  800853:	ff 4d e0             	decl   -0x20(%ebp)
  800856:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085a:	79 af                	jns    80080b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80085c:	eb 13                	jmp    800871 <vprintfmt+0x24b>
				putch(' ', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	6a 20                	push   $0x20
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086e:	ff 4d e4             	decl   -0x1c(%ebp)
  800871:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800875:	7f e7                	jg     80085e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800877:	e9 78 01 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	ff 75 e8             	pushl  -0x18(%ebp)
  800882:	8d 45 14             	lea    0x14(%ebp),%eax
  800885:	50                   	push   %eax
  800886:	e8 3c fd ff ff       	call   8005c7 <getint>
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800891:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089a:	85 d2                	test   %edx,%edx
  80089c:	79 23                	jns    8008c1 <vprintfmt+0x29b>
				putch('-', putdat);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	6a 2d                	push   $0x2d
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	ff d0                	call   *%eax
  8008ab:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b4:	f7 d8                	neg    %eax
  8008b6:	83 d2 00             	adc    $0x0,%edx
  8008b9:	f7 da                	neg    %edx
  8008bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008c8:	e9 bc 00 00 00       	jmp    800989 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d6:	50                   	push   %eax
  8008d7:	e8 84 fc ff ff       	call   800560 <getuint>
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008e5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ec:	e9 98 00 00 00       	jmp    800989 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	6a 58                	push   $0x58
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	ff d0                	call   *%eax
  8008fe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	6a 58                	push   $0x58
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	ff d0                	call   *%eax
  80090e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	6a 58                	push   $0x58
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	ff d0                	call   *%eax
  80091e:	83 c4 10             	add    $0x10,%esp
			break;
  800921:	e9 ce 00 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	6a 30                	push   $0x30
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	6a 78                	push   $0x78
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	ff d0                	call   *%eax
  800943:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	83 c0 04             	add    $0x4,%eax
  80094c:	89 45 14             	mov    %eax,0x14(%ebp)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 e8 04             	sub    $0x4,%eax
  800955:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800957:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800961:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800968:	eb 1f                	jmp    800989 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	ff 75 e8             	pushl  -0x18(%ebp)
  800970:	8d 45 14             	lea    0x14(%ebp),%eax
  800973:	50                   	push   %eax
  800974:	e8 e7 fb ff ff       	call   800560 <getuint>
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800982:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800989:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80098d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800990:	83 ec 04             	sub    $0x4,%esp
  800993:	52                   	push   %edx
  800994:	ff 75 e4             	pushl  -0x1c(%ebp)
  800997:	50                   	push   %eax
  800998:	ff 75 f4             	pushl  -0xc(%ebp)
  80099b:	ff 75 f0             	pushl  -0x10(%ebp)
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	ff 75 08             	pushl  0x8(%ebp)
  8009a4:	e8 00 fb ff ff       	call   8004a9 <printnum>
  8009a9:	83 c4 20             	add    $0x20,%esp
			break;
  8009ac:	eb 46                	jmp    8009f4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	53                   	push   %ebx
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	ff d0                	call   *%eax
  8009ba:	83 c4 10             	add    $0x10,%esp
			break;
  8009bd:	eb 35                	jmp    8009f4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009bf:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  8009c6:	eb 2c                	jmp    8009f4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009c8:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  8009cf:	eb 23                	jmp    8009f4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	6a 25                	push   $0x25
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	ff d0                	call   *%eax
  8009de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e1:	ff 4d 10             	decl   0x10(%ebp)
  8009e4:	eb 03                	jmp    8009e9 <vprintfmt+0x3c3>
  8009e6:	ff 4d 10             	decl   0x10(%ebp)
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	48                   	dec    %eax
  8009ed:	8a 00                	mov    (%eax),%al
  8009ef:	3c 25                	cmp    $0x25,%al
  8009f1:	75 f3                	jne    8009e6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009f3:	90                   	nop
		}
	}
  8009f4:	e9 35 fc ff ff       	jmp    80062e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009fd:	5b                   	pop    %ebx
  8009fe:	5e                   	pop    %esi
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a07:	8d 45 10             	lea    0x10(%ebp),%eax
  800a0a:	83 c0 04             	add    $0x4,%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a10:	8b 45 10             	mov    0x10(%ebp),%eax
  800a13:	ff 75 f4             	pushl  -0xc(%ebp)
  800a16:	50                   	push   %eax
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	ff 75 08             	pushl  0x8(%ebp)
  800a1d:	e8 04 fc ff ff       	call   800626 <vprintfmt>
  800a22:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a25:	90                   	nop
  800a26:	c9                   	leave  
  800a27:	c3                   	ret    

00800a28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	8b 40 08             	mov    0x8(%eax),%eax
  800a31:	8d 50 01             	lea    0x1(%eax),%edx
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3d:	8b 10                	mov    (%eax),%edx
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	8b 40 04             	mov    0x4(%eax),%eax
  800a45:	39 c2                	cmp    %eax,%edx
  800a47:	73 12                	jae    800a5b <sprintputch+0x33>
		*b->buf++ = ch;
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	8b 00                	mov    (%eax),%eax
  800a4e:	8d 48 01             	lea    0x1(%eax),%ecx
  800a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a54:	89 0a                	mov    %ecx,(%edx)
  800a56:	8b 55 08             	mov    0x8(%ebp),%edx
  800a59:	88 10                	mov    %dl,(%eax)
}
  800a5b:	90                   	nop
  800a5c:	5d                   	pop    %ebp
  800a5d:	c3                   	ret    

00800a5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	01 d0                	add    %edx,%eax
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a83:	74 06                	je     800a8b <vsnprintf+0x2d>
  800a85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a89:	7f 07                	jg     800a92 <vsnprintf+0x34>
		return -E_INVAL;
  800a8b:	b8 03 00 00 00       	mov    $0x3,%eax
  800a90:	eb 20                	jmp    800ab2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a92:	ff 75 14             	pushl  0x14(%ebp)
  800a95:	ff 75 10             	pushl  0x10(%ebp)
  800a98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a9b:	50                   	push   %eax
  800a9c:	68 28 0a 80 00       	push   $0x800a28
  800aa1:	e8 80 fb ff ff       	call   800626 <vprintfmt>
  800aa6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ab2:	c9                   	leave  
  800ab3:	c3                   	ret    

00800ab4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aba:	8d 45 10             	lea    0x10(%ebp),%eax
  800abd:	83 c0 04             	add    $0x4,%eax
  800ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ac3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac9:	50                   	push   %eax
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	ff 75 08             	pushl  0x8(%ebp)
  800ad0:	e8 89 ff ff ff       	call   800a5e <vsnprintf>
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ade:	c9                   	leave  
  800adf:	c3                   	ret    

00800ae0 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800ae6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aea:	74 13                	je     800aff <readline+0x1f>
		cprintf("%s", prompt);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	68 88 47 80 00       	push   $0x804788
  800af7:	e8 0b f9 ff ff       	call   800407 <cprintf>
  800afc:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800b06:	83 ec 0c             	sub    $0xc,%esp
  800b09:	6a 00                	push   $0x0
  800b0b:	e8 bb 32 00 00       	call   803dcb <iscons>
  800b10:	83 c4 10             	add    $0x10,%esp
  800b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800b16:	e8 9d 32 00 00       	call   803db8 <getchar>
  800b1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800b1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b22:	79 22                	jns    800b46 <readline+0x66>
			if (c != -E_EOF)
  800b24:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b28:	0f 84 ad 00 00 00    	je     800bdb <readline+0xfb>
				cprintf("read error: %e\n", c);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 ec             	pushl  -0x14(%ebp)
  800b34:	68 8b 47 80 00       	push   $0x80478b
  800b39:	e8 c9 f8 ff ff       	call   800407 <cprintf>
  800b3e:	83 c4 10             	add    $0x10,%esp
			break;
  800b41:	e9 95 00 00 00       	jmp    800bdb <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b46:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b4a:	7e 34                	jle    800b80 <readline+0xa0>
  800b4c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b53:	7f 2b                	jg     800b80 <readline+0xa0>
			if (echoing)
  800b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b59:	74 0e                	je     800b69 <readline+0x89>
				cputchar(c);
  800b5b:	83 ec 0c             	sub    $0xc,%esp
  800b5e:	ff 75 ec             	pushl  -0x14(%ebp)
  800b61:	e8 33 32 00 00       	call   803d99 <cputchar>
  800b66:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b6c:	8d 50 01             	lea    0x1(%eax),%edx
  800b6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b72:	89 c2                	mov    %eax,%edx
  800b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b77:	01 d0                	add    %edx,%eax
  800b79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b7c:	88 10                	mov    %dl,(%eax)
  800b7e:	eb 56                	jmp    800bd6 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800b80:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b84:	75 1f                	jne    800ba5 <readline+0xc5>
  800b86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b8a:	7e 19                	jle    800ba5 <readline+0xc5>
			if (echoing)
  800b8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b90:	74 0e                	je     800ba0 <readline+0xc0>
				cputchar(c);
  800b92:	83 ec 0c             	sub    $0xc,%esp
  800b95:	ff 75 ec             	pushl  -0x14(%ebp)
  800b98:	e8 fc 31 00 00       	call   803d99 <cputchar>
  800b9d:	83 c4 10             	add    $0x10,%esp

			i--;
  800ba0:	ff 4d f4             	decl   -0xc(%ebp)
  800ba3:	eb 31                	jmp    800bd6 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ba5:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ba9:	74 0a                	je     800bb5 <readline+0xd5>
  800bab:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800baf:	0f 85 61 ff ff ff    	jne    800b16 <readline+0x36>
			if (echoing)
  800bb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bb9:	74 0e                	je     800bc9 <readline+0xe9>
				cputchar(c);
  800bbb:	83 ec 0c             	sub    $0xc,%esp
  800bbe:	ff 75 ec             	pushl  -0x14(%ebp)
  800bc1:	e8 d3 31 00 00       	call   803d99 <cputchar>
  800bc6:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcf:	01 d0                	add    %edx,%eax
  800bd1:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800bd4:	eb 06                	jmp    800bdc <readline+0xfc>
		}
	}
  800bd6:	e9 3b ff ff ff       	jmp    800b16 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800bdb:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800bdc:	90                   	nop
  800bdd:	c9                   	leave  
  800bde:	c3                   	ret    

00800bdf <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800be5:	e8 df 21 00 00       	call   802dc9 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bee:	74 13                	je     800c03 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 08             	pushl  0x8(%ebp)
  800bf6:	68 88 47 80 00       	push   $0x804788
  800bfb:	e8 07 f8 ff ff       	call   800407 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800c0a:	83 ec 0c             	sub    $0xc,%esp
  800c0d:	6a 00                	push   $0x0
  800c0f:	e8 b7 31 00 00       	call   803dcb <iscons>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800c1a:	e8 99 31 00 00       	call   803db8 <getchar>
  800c1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800c22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c26:	79 22                	jns    800c4a <atomic_readline+0x6b>
				if (c != -E_EOF)
  800c28:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800c2c:	0f 84 ad 00 00 00    	je     800cdf <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 ec             	pushl  -0x14(%ebp)
  800c38:	68 8b 47 80 00       	push   $0x80478b
  800c3d:	e8 c5 f7 ff ff       	call   800407 <cprintf>
  800c42:	83 c4 10             	add    $0x10,%esp
				break;
  800c45:	e9 95 00 00 00       	jmp    800cdf <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800c4a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800c4e:	7e 34                	jle    800c84 <atomic_readline+0xa5>
  800c50:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800c57:	7f 2b                	jg     800c84 <atomic_readline+0xa5>
				if (echoing)
  800c59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c5d:	74 0e                	je     800c6d <atomic_readline+0x8e>
					cputchar(c);
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	ff 75 ec             	pushl  -0x14(%ebp)
  800c65:	e8 2f 31 00 00       	call   803d99 <cputchar>
  800c6a:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c70:	8d 50 01             	lea    0x1(%eax),%edx
  800c73:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800c76:	89 c2                	mov    %eax,%edx
  800c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7b:	01 d0                	add    %edx,%eax
  800c7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c80:	88 10                	mov    %dl,(%eax)
  800c82:	eb 56                	jmp    800cda <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800c84:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c88:	75 1f                	jne    800ca9 <atomic_readline+0xca>
  800c8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c8e:	7e 19                	jle    800ca9 <atomic_readline+0xca>
				if (echoing)
  800c90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c94:	74 0e                	je     800ca4 <atomic_readline+0xc5>
					cputchar(c);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	ff 75 ec             	pushl  -0x14(%ebp)
  800c9c:	e8 f8 30 00 00       	call   803d99 <cputchar>
  800ca1:	83 c4 10             	add    $0x10,%esp
				i--;
  800ca4:	ff 4d f4             	decl   -0xc(%ebp)
  800ca7:	eb 31                	jmp    800cda <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800ca9:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800cad:	74 0a                	je     800cb9 <atomic_readline+0xda>
  800caf:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800cb3:	0f 85 61 ff ff ff    	jne    800c1a <atomic_readline+0x3b>
				if (echoing)
  800cb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cbd:	74 0e                	je     800ccd <atomic_readline+0xee>
					cputchar(c);
  800cbf:	83 ec 0c             	sub    $0xc,%esp
  800cc2:	ff 75 ec             	pushl  -0x14(%ebp)
  800cc5:	e8 cf 30 00 00       	call   803d99 <cputchar>
  800cca:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd3:	01 d0                	add    %edx,%eax
  800cd5:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800cd8:	eb 06                	jmp    800ce0 <atomic_readline+0x101>
			}
		}
  800cda:	e9 3b ff ff ff       	jmp    800c1a <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800cdf:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800ce0:	e8 fe 20 00 00       	call   802de3 <sys_unlock_cons>
}
  800ce5:	90                   	nop
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf5:	eb 06                	jmp    800cfd <strlen+0x15>
		n++;
  800cf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cfa:	ff 45 08             	incl   0x8(%ebp)
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	84 c0                	test   %al,%al
  800d04:	75 f1                	jne    800cf7 <strlen+0xf>
		n++;
	return n;
  800d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d09:	c9                   	leave  
  800d0a:	c3                   	ret    

00800d0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d18:	eb 09                	jmp    800d23 <strnlen+0x18>
		n++;
  800d1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d1d:	ff 45 08             	incl   0x8(%ebp)
  800d20:	ff 4d 0c             	decl   0xc(%ebp)
  800d23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d27:	74 09                	je     800d32 <strnlen+0x27>
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	84 c0                	test   %al,%al
  800d30:	75 e8                	jne    800d1a <strnlen+0xf>
		n++;
	return n;
  800d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d35:	c9                   	leave  
  800d36:	c3                   	ret    

00800d37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d43:	90                   	nop
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8d 50 01             	lea    0x1(%eax),%edx
  800d4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d56:	8a 12                	mov    (%edx),%dl
  800d58:	88 10                	mov    %dl,(%eax)
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	84 c0                	test   %al,%al
  800d5e:	75 e4                	jne    800d44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d78:	eb 1f                	jmp    800d99 <strncpy+0x34>
		*dst++ = *src;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8d 50 01             	lea    0x1(%eax),%edx
  800d80:	89 55 08             	mov    %edx,0x8(%ebp)
  800d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d86:	8a 12                	mov    (%edx),%dl
  800d88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	74 03                	je     800d96 <strncpy+0x31>
			src++;
  800d93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d96:	ff 45 fc             	incl   -0x4(%ebp)
  800d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d9f:	72 d9                	jb     800d7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800da1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800db2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db6:	74 30                	je     800de8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800db8:	eb 16                	jmp    800dd0 <strlcpy+0x2a>
			*dst++ = *src++;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dcc:	8a 12                	mov    (%edx),%dl
  800dce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dd0:	ff 4d 10             	decl   0x10(%ebp)
  800dd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd7:	74 09                	je     800de2 <strlcpy+0x3c>
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	84 c0                	test   %al,%al
  800de0:	75 d8                	jne    800dba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dee:	29 c2                	sub    %eax,%edx
  800df0:	89 d0                	mov    %edx,%eax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800df7:	eb 06                	jmp    800dff <strcmp+0xb>
		p++, q++;
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	84 c0                	test   %al,%al
  800e06:	74 0e                	je     800e16 <strcmp+0x22>
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 10                	mov    (%eax),%dl
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	38 c2                	cmp    %al,%dl
  800e14:	74 e3                	je     800df9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	0f b6 d0             	movzbl %al,%edx
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	0f b6 c0             	movzbl %al,%eax
  800e26:	29 c2                	sub    %eax,%edx
  800e28:	89 d0                	mov    %edx,%eax
}
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e2f:	eb 09                	jmp    800e3a <strncmp+0xe>
		n--, p++, q++;
  800e31:	ff 4d 10             	decl   0x10(%ebp)
  800e34:	ff 45 08             	incl   0x8(%ebp)
  800e37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3e:	74 17                	je     800e57 <strncmp+0x2b>
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	84 c0                	test   %al,%al
  800e47:	74 0e                	je     800e57 <strncmp+0x2b>
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 10                	mov    (%eax),%dl
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	38 c2                	cmp    %al,%dl
  800e55:	74 da                	je     800e31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	75 07                	jne    800e64 <strncmp+0x38>
		return 0;
  800e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e62:	eb 14                	jmp    800e78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	0f b6 d0             	movzbl %al,%edx
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	0f b6 c0             	movzbl %al,%eax
  800e74:	29 c2                	sub    %eax,%edx
  800e76:	89 d0                	mov    %edx,%eax
}
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 04             	sub    $0x4,%esp
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e86:	eb 12                	jmp    800e9a <strchr+0x20>
		if (*s == c)
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e90:	75 05                	jne    800e97 <strchr+0x1d>
			return (char *) s;
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	eb 11                	jmp    800ea8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e97:	ff 45 08             	incl   0x8(%ebp)
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	84 c0                	test   %al,%al
  800ea1:	75 e5                	jne    800e88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 04             	sub    $0x4,%esp
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eb6:	eb 0d                	jmp    800ec5 <strfind+0x1b>
		if (*s == c)
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec0:	74 0e                	je     800ed0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ec2:	ff 45 08             	incl   0x8(%ebp)
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	84 c0                	test   %al,%al
  800ecc:	75 ea                	jne    800eb8 <strfind+0xe>
  800ece:	eb 01                	jmp    800ed1 <strfind+0x27>
		if (*s == c)
			break;
  800ed0:	90                   	nop
	return (char *) s;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed4:	c9                   	leave  
  800ed5:	c3                   	ret    

00800ed6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ee2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ee6:	76 63                	jbe    800f4b <memset+0x75>
		uint64 data_block = c;
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	99                   	cltd   
  800eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eef:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800efc:	c1 e0 08             	shl    $0x8,%eax
  800eff:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f02:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f0f:	c1 e0 10             	shl    $0x10,%eax
  800f12:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f15:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1e:	89 c2                	mov    %eax,%edx
  800f20:	b8 00 00 00 00       	mov    $0x0,%eax
  800f25:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f28:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f2b:	eb 18                	jmp    800f45 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f2d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f30:	8d 41 08             	lea    0x8(%ecx),%eax
  800f33:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3c:	89 01                	mov    %eax,(%ecx)
  800f3e:	89 51 04             	mov    %edx,0x4(%ecx)
  800f41:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f45:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f49:	77 e2                	ja     800f2d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4f:	74 23                	je     800f74 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f54:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f57:	eb 0e                	jmp    800f67 <memset+0x91>
			*p8++ = (uint8)c;
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	8d 50 01             	lea    0x1(%eax),%edx
  800f5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f65:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f67:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	75 e5                	jne    800f59 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f8b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f8f:	76 24                	jbe    800fb5 <memcpy+0x3c>
		while(n >= 8){
  800f91:	eb 1c                	jmp    800faf <memcpy+0x36>
			*d64 = *s64;
  800f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f96:	8b 50 04             	mov    0x4(%eax),%edx
  800f99:	8b 00                	mov    (%eax),%eax
  800f9b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f9e:	89 01                	mov    %eax,(%ecx)
  800fa0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fa3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fa7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fab:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800faf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fb3:	77 de                	ja     800f93 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800fb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb9:	74 31                	je     800fec <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fc7:	eb 16                	jmp    800fdf <memcpy+0x66>
			*d8++ = *s8++;
  800fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fcc:	8d 50 01             	lea    0x1(%eax),%edx
  800fcf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fdb:	8a 12                	mov    (%edx),%dl
  800fdd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	75 dd                	jne    800fc9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801003:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801006:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801009:	73 50                	jae    80105b <memmove+0x6a>
  80100b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100e:	8b 45 10             	mov    0x10(%ebp),%eax
  801011:	01 d0                	add    %edx,%eax
  801013:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801016:	76 43                	jbe    80105b <memmove+0x6a>
		s += n;
  801018:	8b 45 10             	mov    0x10(%ebp),%eax
  80101b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80101e:	8b 45 10             	mov    0x10(%ebp),%eax
  801021:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801024:	eb 10                	jmp    801036 <memmove+0x45>
			*--d = *--s;
  801026:	ff 4d f8             	decl   -0x8(%ebp)
  801029:	ff 4d fc             	decl   -0x4(%ebp)
  80102c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102f:	8a 10                	mov    (%eax),%dl
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801034:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103c:	89 55 10             	mov    %edx,0x10(%ebp)
  80103f:	85 c0                	test   %eax,%eax
  801041:	75 e3                	jne    801026 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801043:	eb 23                	jmp    801068 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801045:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801048:	8d 50 01             	lea    0x1(%eax),%edx
  80104b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801051:	8d 4a 01             	lea    0x1(%edx),%ecx
  801054:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801057:	8a 12                	mov    (%edx),%dl
  801059:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	89 55 10             	mov    %edx,0x10(%ebp)
  801064:	85 c0                	test   %eax,%eax
  801066:	75 dd                	jne    801045 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

0080106d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80107f:	eb 2a                	jmp    8010ab <memcmp+0x3e>
		if (*s1 != *s2)
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801084:	8a 10                	mov    (%eax),%dl
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	38 c2                	cmp    %al,%dl
  80108d:	74 16                	je     8010a5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	0f b6 d0             	movzbl %al,%edx
  801097:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	0f b6 c0             	movzbl %al,%eax
  80109f:	29 c2                	sub    %eax,%edx
  8010a1:	89 d0                	mov    %edx,%eax
  8010a3:	eb 18                	jmp    8010bd <memcmp+0x50>
		s1++, s2++;
  8010a5:	ff 45 fc             	incl   -0x4(%ebp)
  8010a8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 c9                	jne    801081 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	01 d0                	add    %edx,%eax
  8010cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010d0:	eb 15                	jmp    8010e7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	0f b6 d0             	movzbl %al,%edx
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	0f b6 c0             	movzbl %al,%eax
  8010e0:	39 c2                	cmp    %eax,%edx
  8010e2:	74 0d                	je     8010f1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010e4:	ff 45 08             	incl   0x8(%ebp)
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010ed:	72 e3                	jb     8010d2 <memfind+0x13>
  8010ef:	eb 01                	jmp    8010f2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010f1:	90                   	nop
	return (void *) s;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801104:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80110b:	eb 03                	jmp    801110 <strtol+0x19>
		s++;
  80110d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 20                	cmp    $0x20,%al
  801117:	74 f4                	je     80110d <strtol+0x16>
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	3c 09                	cmp    $0x9,%al
  801120:	74 eb                	je     80110d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	3c 2b                	cmp    $0x2b,%al
  801129:	75 05                	jne    801130 <strtol+0x39>
		s++;
  80112b:	ff 45 08             	incl   0x8(%ebp)
  80112e:	eb 13                	jmp    801143 <strtol+0x4c>
	else if (*s == '-')
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 2d                	cmp    $0x2d,%al
  801137:	75 0a                	jne    801143 <strtol+0x4c>
		s++, neg = 1;
  801139:	ff 45 08             	incl   0x8(%ebp)
  80113c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801143:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801147:	74 06                	je     80114f <strtol+0x58>
  801149:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80114d:	75 20                	jne    80116f <strtol+0x78>
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	3c 30                	cmp    $0x30,%al
  801156:	75 17                	jne    80116f <strtol+0x78>
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	40                   	inc    %eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	3c 78                	cmp    $0x78,%al
  801160:	75 0d                	jne    80116f <strtol+0x78>
		s += 2, base = 16;
  801162:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801166:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80116d:	eb 28                	jmp    801197 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80116f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801173:	75 15                	jne    80118a <strtol+0x93>
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 30                	cmp    $0x30,%al
  80117c:	75 0c                	jne    80118a <strtol+0x93>
		s++, base = 8;
  80117e:	ff 45 08             	incl   0x8(%ebp)
  801181:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801188:	eb 0d                	jmp    801197 <strtol+0xa0>
	else if (base == 0)
  80118a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118e:	75 07                	jne    801197 <strtol+0xa0>
		base = 10;
  801190:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2f                	cmp    $0x2f,%al
  80119e:	7e 19                	jle    8011b9 <strtol+0xc2>
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3c 39                	cmp    $0x39,%al
  8011a7:	7f 10                	jg     8011b9 <strtol+0xc2>
			dig = *s - '0';
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f be c0             	movsbl %al,%eax
  8011b1:	83 e8 30             	sub    $0x30,%eax
  8011b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011b7:	eb 42                	jmp    8011fb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3c 60                	cmp    $0x60,%al
  8011c0:	7e 19                	jle    8011db <strtol+0xe4>
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	3c 7a                	cmp    $0x7a,%al
  8011c9:	7f 10                	jg     8011db <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	0f be c0             	movsbl %al,%eax
  8011d3:	83 e8 57             	sub    $0x57,%eax
  8011d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011d9:	eb 20                	jmp    8011fb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	3c 40                	cmp    $0x40,%al
  8011e2:	7e 39                	jle    80121d <strtol+0x126>
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	3c 5a                	cmp    $0x5a,%al
  8011eb:	7f 30                	jg     80121d <strtol+0x126>
			dig = *s - 'A' + 10;
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	0f be c0             	movsbl %al,%eax
  8011f5:	83 e8 37             	sub    $0x37,%eax
  8011f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011fe:	3b 45 10             	cmp    0x10(%ebp),%eax
  801201:	7d 19                	jge    80121c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	0f af 45 10          	imul   0x10(%ebp),%eax
  80120d:	89 c2                	mov    %eax,%edx
  80120f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
  801214:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801217:	e9 7b ff ff ff       	jmp    801197 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80121c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80121d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801221:	74 08                	je     80122b <strtol+0x134>
		*endptr = (char *) s;
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	8b 55 08             	mov    0x8(%ebp),%edx
  801229:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80122b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122f:	74 07                	je     801238 <strtol+0x141>
  801231:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801234:	f7 d8                	neg    %eax
  801236:	eb 03                	jmp    80123b <strtol+0x144>
  801238:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <ltostr>:

void
ltostr(long value, char *str)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80124a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801255:	79 13                	jns    80126a <ltostr+0x2d>
	{
		neg = 1;
  801257:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801264:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801267:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801272:	99                   	cltd   
  801273:	f7 f9                	idiv   %ecx
  801275:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801278:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801281:	89 c2                	mov    %eax,%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 d0                	add    %edx,%eax
  801288:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80128b:	83 c2 30             	add    $0x30,%edx
  80128e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801290:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801293:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801298:	f7 e9                	imul   %ecx
  80129a:	c1 fa 02             	sar    $0x2,%edx
  80129d:	89 c8                	mov    %ecx,%eax
  80129f:	c1 f8 1f             	sar    $0x1f,%eax
  8012a2:	29 c2                	sub    %eax,%edx
  8012a4:	89 d0                	mov    %edx,%eax
  8012a6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ad:	75 bb                	jne    80126a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b9:	48                   	dec    %eax
  8012ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c1:	74 3d                	je     801300 <ltostr+0xc3>
		start = 1 ;
  8012c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012ca:	eb 34                	jmp    801300 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d2:	01 d0                	add    %edx,%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	01 c2                	add    %eax,%edx
  8012e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	01 c8                	add    %ecx,%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f3:	01 c2                	add    %eax,%edx
  8012f5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012f8:	88 02                	mov    %al,(%edx)
		start++ ;
  8012fa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012fd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801303:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801306:	7c c4                	jl     8012cc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801308:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	01 d0                	add    %edx,%eax
  801310:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801313:	90                   	nop
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80131c:	ff 75 08             	pushl  0x8(%ebp)
  80131f:	e8 c4 f9 ff ff       	call   800ce8 <strlen>
  801324:	83 c4 04             	add    $0x4,%esp
  801327:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	e8 b6 f9 ff ff       	call   800ce8 <strlen>
  801332:	83 c4 04             	add    $0x4,%esp
  801335:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801338:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80133f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801346:	eb 17                	jmp    80135f <strcconcat+0x49>
		final[s] = str1[s] ;
  801348:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134b:	8b 45 10             	mov    0x10(%ebp),%eax
  80134e:	01 c2                	add    %eax,%edx
  801350:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	01 c8                	add    %ecx,%eax
  801358:	8a 00                	mov    (%eax),%al
  80135a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80135c:	ff 45 fc             	incl   -0x4(%ebp)
  80135f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801362:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801365:	7c e1                	jl     801348 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801367:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80136e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801375:	eb 1f                	jmp    801396 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801377:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137a:	8d 50 01             	lea    0x1(%eax),%edx
  80137d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801380:	89 c2                	mov    %eax,%edx
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 c2                	add    %eax,%edx
  801387:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80138a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138d:	01 c8                	add    %ecx,%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801393:	ff 45 f8             	incl   -0x8(%ebp)
  801396:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801399:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139c:	7c d9                	jl     801377 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80139e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a4:	01 d0                	add    %edx,%eax
  8013a6:	c6 00 00             	movb   $0x0,(%eax)
}
  8013a9:	90                   	nop
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013af:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bb:	8b 00                	mov    (%eax),%eax
  8013bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013cf:	eb 0c                	jmp    8013dd <strsplit+0x31>
			*string++ = 0;
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8d 50 01             	lea    0x1(%eax),%edx
  8013d7:	89 55 08             	mov    %edx,0x8(%ebp)
  8013da:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	84 c0                	test   %al,%al
  8013e4:	74 18                	je     8013fe <strsplit+0x52>
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f be c0             	movsbl %al,%eax
  8013ee:	50                   	push   %eax
  8013ef:	ff 75 0c             	pushl  0xc(%ebp)
  8013f2:	e8 83 fa ff ff       	call   800e7a <strchr>
  8013f7:	83 c4 08             	add    $0x8,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	75 d3                	jne    8013d1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	84 c0                	test   %al,%al
  801405:	74 5a                	je     801461 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801407:	8b 45 14             	mov    0x14(%ebp),%eax
  80140a:	8b 00                	mov    (%eax),%eax
  80140c:	83 f8 0f             	cmp    $0xf,%eax
  80140f:	75 07                	jne    801418 <strsplit+0x6c>
		{
			return 0;
  801411:	b8 00 00 00 00       	mov    $0x0,%eax
  801416:	eb 66                	jmp    80147e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801418:	8b 45 14             	mov    0x14(%ebp),%eax
  80141b:	8b 00                	mov    (%eax),%eax
  80141d:	8d 48 01             	lea    0x1(%eax),%ecx
  801420:	8b 55 14             	mov    0x14(%ebp),%edx
  801423:	89 0a                	mov    %ecx,(%edx)
  801425:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142c:	8b 45 10             	mov    0x10(%ebp),%eax
  80142f:	01 c2                	add    %eax,%edx
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801436:	eb 03                	jmp    80143b <strsplit+0x8f>
			string++;
  801438:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	84 c0                	test   %al,%al
  801442:	74 8b                	je     8013cf <strsplit+0x23>
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	0f be c0             	movsbl %al,%eax
  80144c:	50                   	push   %eax
  80144d:	ff 75 0c             	pushl  0xc(%ebp)
  801450:	e8 25 fa ff ff       	call   800e7a <strchr>
  801455:	83 c4 08             	add    $0x8,%esp
  801458:	85 c0                	test   %eax,%eax
  80145a:	74 dc                	je     801438 <strsplit+0x8c>
			string++;
	}
  80145c:	e9 6e ff ff ff       	jmp    8013cf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801461:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801462:	8b 45 14             	mov    0x14(%ebp),%eax
  801465:	8b 00                	mov    (%eax),%eax
  801467:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146e:	8b 45 10             	mov    0x10(%ebp),%eax
  801471:	01 d0                	add    %edx,%eax
  801473:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801479:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80148c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801493:	eb 4a                	jmp    8014df <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801495:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	01 c2                	add    %eax,%edx
  80149d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a3:	01 c8                	add    %ecx,%eax
  8014a5:	8a 00                	mov    (%eax),%al
  8014a7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014af:	01 d0                	add    %edx,%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	3c 40                	cmp    $0x40,%al
  8014b5:	7e 25                	jle    8014dc <str2lower+0x5c>
  8014b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	01 d0                	add    %edx,%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	3c 5a                	cmp    $0x5a,%al
  8014c3:	7f 17                	jg     8014dc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d3:	01 ca                	add    %ecx,%edx
  8014d5:	8a 12                	mov    (%edx),%dl
  8014d7:	83 c2 20             	add    $0x20,%edx
  8014da:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014dc:	ff 45 fc             	incl   -0x4(%ebp)
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	e8 01 f8 ff ff       	call   800ce8 <strlen>
  8014e7:	83 c4 04             	add    $0x4,%esp
  8014ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014ed:	7f a6                	jg     801495 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014fa:	a1 08 50 80 00       	mov    0x805008,%eax
  8014ff:	85 c0                	test   %eax,%eax
  801501:	74 42                	je     801545 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	68 00 00 00 82       	push   $0x82000000
  80150b:	68 00 00 00 80       	push   $0x80000000
  801510:	e8 b0 1e 00 00       	call   8033c5 <initialize_dynamic_allocator>
  801515:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801518:	e8 96 1c 00 00       	call   8031b3 <sys_get_uheap_strategy>
  80151d:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801522:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801527:	05 00 10 00 00       	add    $0x1000,%eax
  80152c:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801531:	a1 30 51 83 00       	mov    0x835130,%eax
  801536:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  80153b:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801542:	00 00 00 
	}
}
  801545:	90                   	nop
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801557:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	68 06 04 00 00       	push   $0x406
  801564:	50                   	push   %eax
  801565:	e8 93 18 00 00       	call   802dfd <__sys_allocate_page>
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801570:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801574:	79 14                	jns    80158a <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 9c 47 80 00       	push   $0x80479c
  80157e:	6a 1f                	push   $0x1f
  801580:	68 d8 47 80 00       	push   $0x8047d8
  801585:	e8 4b 28 00 00       	call   803dd5 <_panic>
	return 0;
  80158a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a5:	83 ec 0c             	sub    $0xc,%esp
  8015a8:	50                   	push   %eax
  8015a9:	e8 96 18 00 00       	call   802e44 <__sys_unmap_frame>
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015b8:	79 14                	jns    8015ce <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	68 e4 47 80 00       	push   $0x8047e4
  8015c2:	6a 2a                	push   $0x2a
  8015c4:	68 d8 47 80 00       	push   $0x8047d8
  8015c9:	e8 07 28 00 00       	call   803dd5 <_panic>
}
  8015ce:	90                   	nop
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015d7:	e8 18 ff ff ff       	call   8014f4 <uheap_init>
	if (size == 0) return NULL ;
  8015dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e0:	75 0a                	jne    8015ec <malloc+0x1b>
  8015e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e7:	e9 43 03 00 00       	jmp    80192f <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8015ec:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8015f3:	77 13                	ja     801608 <malloc+0x37>
    {
        return alloc_block(size);
  8015f5:	83 ec 0c             	sub    $0xc,%esp
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	e8 78 20 00 00       	call   803678 <alloc_block>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	e9 27 03 00 00       	jmp    80192f <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801608:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80160f:	8b 55 08             	mov    0x8(%ebp),%edx
  801612:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	48                   	dec    %eax
  801618:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80161b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80161e:	ba 00 00 00 00       	mov    $0x0,%edx
  801623:	f7 75 dc             	divl   -0x24(%ebp)
  801626:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801629:	29 d0                	sub    %edx,%eax
  80162b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  80162e:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801633:	85 c0                	test   %eax,%eax
  801635:	75 0a                	jne    801641 <malloc+0x70>
    {
        uhp_inited = 1;
  801637:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  80163e:	00 00 00 
    }

    int exactIdx = -1;
  801641:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801648:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80164f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801656:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80165d:	e9 85 00 00 00       	jmp    8016e7 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801662:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801665:	89 d0                	mov    %edx,%eax
  801667:	01 c0                	add    %eax,%eax
  801669:	01 d0                	add    %edx,%eax
  80166b:	c1 e0 02             	shl    $0x2,%eax
  80166e:	05 48 10 81 00       	add    $0x811048,%eax
  801673:	8a 00                	mov    (%eax),%al
  801675:	84 c0                	test   %al,%al
  801677:	74 20                	je     801699 <malloc+0xc8>
  801679:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80167c:	89 d0                	mov    %edx,%eax
  80167e:	01 c0                	add    %eax,%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	c1 e0 02             	shl    $0x2,%eax
  801685:	05 44 10 81 00       	add    $0x811044,%eax
  80168a:	8b 00                	mov    (%eax),%eax
  80168c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80168f:	75 08                	jne    801699 <malloc+0xc8>
        {
            exactIdx = i;
  801691:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801694:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801697:	eb 5b                	jmp    8016f4 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801699:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80169c:	89 d0                	mov    %edx,%eax
  80169e:	01 c0                	add    %eax,%eax
  8016a0:	01 d0                	add    %edx,%eax
  8016a2:	c1 e0 02             	shl    $0x2,%eax
  8016a5:	05 48 10 81 00       	add    $0x811048,%eax
  8016aa:	8a 00                	mov    (%eax),%al
  8016ac:	84 c0                	test   %al,%al
  8016ae:	74 34                	je     8016e4 <malloc+0x113>
  8016b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016b3:	89 d0                	mov    %edx,%eax
  8016b5:	01 c0                	add    %eax,%eax
  8016b7:	01 d0                	add    %edx,%eax
  8016b9:	c1 e0 02             	shl    $0x2,%eax
  8016bc:	05 44 10 81 00       	add    $0x811044,%eax
  8016c1:	8b 00                	mov    (%eax),%eax
  8016c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8016c6:	76 1c                	jbe    8016e4 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8016c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016cb:	89 d0                	mov    %edx,%eax
  8016cd:	01 c0                	add    %eax,%eax
  8016cf:	01 d0                	add    %edx,%eax
  8016d1:	c1 e0 02             	shl    $0x2,%eax
  8016d4:	05 44 10 81 00       	add    $0x811044,%eax
  8016d9:	8b 00                	mov    (%eax),%eax
  8016db:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8016de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8016e4:	ff 45 e8             	incl   -0x18(%ebp)
  8016e7:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8016ee:	0f 8e 6e ff ff ff    	jle    801662 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8016f4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8016fb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8016ff:	74 7d                	je     80177e <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801701:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170b:	89 d0                	mov    %edx,%eax
  80170d:	01 c0                	add    %eax,%eax
  80170f:	01 d0                	add    %edx,%eax
  801711:	c1 e0 02             	shl    $0x2,%eax
  801714:	05 40 10 81 00       	add    $0x811040,%eax
  801719:	8b 10                	mov    (%eax),%edx
  80171b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80171e:	01 d0                	add    %edx,%eax
  801720:	48                   	dec    %eax
  801721:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801724:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801727:	ba 00 00 00 00       	mov    $0x0,%edx
  80172c:	f7 75 bc             	divl   -0x44(%ebp)
  80172f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801732:	29 d0                	sub    %edx,%eax
  801734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173a:	89 d0                	mov    %edx,%eax
  80173c:	01 c0                	add    %eax,%eax
  80173e:	01 d0                	add    %edx,%eax
  801740:	c1 e0 02             	shl    $0x2,%eax
  801743:	05 48 10 81 00       	add    $0x811048,%eax
  801748:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80174b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174e:	89 d0                	mov    %edx,%eax
  801750:	01 c0                	add    %eax,%eax
  801752:	01 d0                	add    %edx,%eax
  801754:	c1 e0 02             	shl    $0x2,%eax
  801757:	05 44 10 81 00       	add    $0x811044,%eax
  80175c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801762:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801765:	89 d0                	mov    %edx,%eax
  801767:	01 c0                	add    %eax,%eax
  801769:	01 d0                	add    %edx,%eax
  80176b:	c1 e0 02             	shl    $0x2,%eax
  80176e:	05 40 10 81 00       	add    $0x811040,%eax
  801773:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801779:	e9 2d 01 00 00       	jmp    8018ab <malloc+0x2da>
    }
    else if (worstIdx != -1)
  80177e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801782:	0f 84 ce 00 00 00    	je     801856 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801788:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80178f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801792:	89 d0                	mov    %edx,%eax
  801794:	01 c0                	add    %eax,%eax
  801796:	01 d0                	add    %edx,%eax
  801798:	c1 e0 02             	shl    $0x2,%eax
  80179b:	05 40 10 81 00       	add    $0x811040,%eax
  8017a0:	8b 10                	mov    (%eax),%edx
  8017a2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017a5:	01 d0                	add    %edx,%eax
  8017a7:	48                   	dec    %eax
  8017a8:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8017ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b3:	f7 75 c4             	divl   -0x3c(%ebp)
  8017b6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017b9:	29 d0                	sub    %edx,%eax
  8017bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8017be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c1:	89 d0                	mov    %edx,%eax
  8017c3:	01 c0                	add    %eax,%eax
  8017c5:	01 d0                	add    %edx,%eax
  8017c7:	c1 e0 02             	shl    $0x2,%eax
  8017ca:	05 44 10 81 00       	add    $0x811044,%eax
  8017cf:	8b 00                	mov    (%eax),%eax
  8017d1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017d4:	75 47                	jne    80181d <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  8017d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d9:	89 d0                	mov    %edx,%eax
  8017db:	01 c0                	add    %eax,%eax
  8017dd:	01 d0                	add    %edx,%eax
  8017df:	c1 e0 02             	shl    $0x2,%eax
  8017e2:	05 48 10 81 00       	add    $0x811048,%eax
  8017e7:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8017ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ed:	89 d0                	mov    %edx,%eax
  8017ef:	01 c0                	add    %eax,%eax
  8017f1:	01 d0                	add    %edx,%eax
  8017f3:	c1 e0 02             	shl    $0x2,%eax
  8017f6:	05 44 10 81 00       	add    $0x811044,%eax
  8017fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801801:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801804:	89 d0                	mov    %edx,%eax
  801806:	01 c0                	add    %eax,%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	c1 e0 02             	shl    $0x2,%eax
  80180d:	05 40 10 81 00       	add    $0x811040,%eax
  801812:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801818:	e9 8e 00 00 00       	jmp    8018ab <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80181d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801820:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801823:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801826:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801829:	89 d0                	mov    %edx,%eax
  80182b:	01 c0                	add    %eax,%eax
  80182d:	01 d0                	add    %edx,%eax
  80182f:	c1 e0 02             	shl    $0x2,%eax
  801832:	05 40 10 81 00       	add    $0x811040,%eax
  801837:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80183c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80183f:	89 c2                	mov    %eax,%edx
  801841:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801844:	89 c8                	mov    %ecx,%eax
  801846:	01 c0                	add    %eax,%eax
  801848:	01 c8                	add    %ecx,%eax
  80184a:	c1 e0 02             	shl    $0x2,%eax
  80184d:	05 44 10 81 00       	add    $0x811044,%eax
  801852:	89 10                	mov    %edx,(%eax)
  801854:	eb 55                	jmp    8018ab <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801856:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80185d:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801863:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	48                   	dec    %eax
  801869:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80186c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80186f:	ba 00 00 00 00       	mov    $0x0,%edx
  801874:	f7 75 d0             	divl   -0x30(%ebp)
  801877:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80187a:	29 d0                	sub    %edx,%eax
  80187c:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80187f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801882:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801885:	01 d0                	add    %edx,%eax
  801887:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80188c:	76 0a                	jbe    801898 <malloc+0x2c7>
            return NULL;
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
  801893:	e9 97 00 00 00       	jmp    80192f <malloc+0x35e>
        va = start;
  801898:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80189b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80189e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8018a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018a4:	01 d0                	add    %edx,%eax
  8018a6:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8018ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8018b2:	eb 5e                	jmp    801912 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8018b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018b7:	89 d0                	mov    %edx,%eax
  8018b9:	01 c0                	add    %eax,%eax
  8018bb:	01 d0                	add    %edx,%eax
  8018bd:	c1 e0 02             	shl    $0x2,%eax
  8018c0:	05 48 50 80 00       	add    $0x805048,%eax
  8018c5:	8a 00                	mov    (%eax),%al
  8018c7:	84 c0                	test   %al,%al
  8018c9:	75 44                	jne    80190f <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  8018cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018ce:	89 d0                	mov    %edx,%eax
  8018d0:	01 c0                	add    %eax,%eax
  8018d2:	01 d0                	add    %edx,%eax
  8018d4:	c1 e0 02             	shl    $0x2,%eax
  8018d7:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8018dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018e0:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8018e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018e5:	89 d0                	mov    %edx,%eax
  8018e7:	01 c0                	add    %eax,%eax
  8018e9:	01 d0                	add    %edx,%eax
  8018eb:	c1 e0 02             	shl    $0x2,%eax
  8018ee:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8018f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018f7:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8018f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018fc:	89 d0                	mov    %edx,%eax
  8018fe:	01 c0                	add    %eax,%eax
  801900:	01 d0                	add    %edx,%eax
  801902:	c1 e0 02             	shl    $0x2,%eax
  801905:	05 48 50 80 00       	add    $0x805048,%eax
  80190a:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80190d:	eb 0c                	jmp    80191b <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80190f:	ff 45 e0             	incl   -0x20(%ebp)
  801912:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801919:	7e 99                	jle    8018b4 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  80191b:	83 ec 08             	sub    $0x8,%esp
  80191e:	ff 75 d4             	pushl  -0x2c(%ebp)
  801921:	ff 75 e4             	pushl  -0x1c(%ebp)
  801924:	e8 a2 19 00 00       	call   8032cb <sys_allocate_user_mem>
  801929:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  80192c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801937:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80193b:	0f 84 fa 03 00 00    	je     801d3b <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801947:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80194a:	85 c0                	test   %eax,%eax
  80194c:	79 1c                	jns    80196a <free+0x39>
  80194e:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801955:	77 13                	ja     80196a <free+0x39>
    {
        free_block(virtual_address);
  801957:	83 ec 0c             	sub    $0xc,%esp
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	e8 09 21 00 00       	call   803a6b <free_block>
  801962:	83 c4 10             	add    $0x10,%esp
        return;
  801965:	e9 d2 03 00 00       	jmp    801d3c <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80196a:	a1 30 51 83 00       	mov    0x835130,%eax
  80196f:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801972:	72 09                	jb     80197d <free+0x4c>
  801974:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  80197b:	76 17                	jbe    801994 <free+0x63>
        panic("free: invalid address");
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	68 21 48 80 00       	push   $0x804821
  801985:	68 9b 00 00 00       	push   $0x9b
  80198a:	68 d8 47 80 00       	push   $0x8047d8
  80198f:	e8 41 24 00 00       	call   803dd5 <_panic>

    uint32 size = 0;
  801994:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  80199b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8019a9:	eb 50                	jmp    8019fb <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8019ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019ae:	89 d0                	mov    %edx,%eax
  8019b0:	01 c0                	add    %eax,%eax
  8019b2:	01 d0                	add    %edx,%eax
  8019b4:	c1 e0 02             	shl    $0x2,%eax
  8019b7:	05 48 50 80 00       	add    $0x805048,%eax
  8019bc:	8a 00                	mov    (%eax),%al
  8019be:	84 c0                	test   %al,%al
  8019c0:	74 36                	je     8019f8 <free+0xc7>
  8019c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019c5:	89 d0                	mov    %edx,%eax
  8019c7:	01 c0                	add    %eax,%eax
  8019c9:	01 d0                	add    %edx,%eax
  8019cb:	c1 e0 02             	shl    $0x2,%eax
  8019ce:	05 40 50 80 00       	add    $0x805040,%eax
  8019d3:	8b 00                	mov    (%eax),%eax
  8019d5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8019d8:	75 1e                	jne    8019f8 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  8019da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019dd:	89 d0                	mov    %edx,%eax
  8019df:	01 c0                	add    %eax,%eax
  8019e1:	01 d0                	add    %edx,%eax
  8019e3:	c1 e0 02             	shl    $0x2,%eax
  8019e6:	05 44 50 80 00       	add    $0x805044,%eax
  8019eb:	8b 00                	mov    (%eax),%eax
  8019ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  8019f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  8019f6:	eb 0c                	jmp    801a04 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019f8:	ff 45 ec             	incl   -0x14(%ebp)
  8019fb:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801a02:	7e a7                	jle    8019ab <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801a04:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801a08:	74 06                	je     801a10 <free+0xdf>
  801a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a0e:	75 17                	jne    801a27 <free+0xf6>
        panic("free: unknown block");
  801a10:	83 ec 04             	sub    $0x4,%esp
  801a13:	68 37 48 80 00       	push   $0x804837
  801a18:	68 a9 00 00 00       	push   $0xa9
  801a1d:	68 d8 47 80 00       	push   $0x8047d8
  801a22:	e8 ae 23 00 00       	call   803dd5 <_panic>

    uhp_allocs[idx].used = 0;
  801a27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a2a:	89 d0                	mov    %edx,%eax
  801a2c:	01 c0                	add    %eax,%eax
  801a2e:	01 d0                	add    %edx,%eax
  801a30:	c1 e0 02             	shl    $0x2,%eax
  801a33:	05 48 50 80 00       	add    $0x805048,%eax
  801a38:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801a3b:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a42:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801a49:	eb 64                	jmp    801aaf <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801a4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a4e:	89 d0                	mov    %edx,%eax
  801a50:	01 c0                	add    %eax,%eax
  801a52:	01 d0                	add    %edx,%eax
  801a54:	c1 e0 02             	shl    $0x2,%eax
  801a57:	05 48 10 81 00       	add    $0x811048,%eax
  801a5c:	8a 00                	mov    (%eax),%al
  801a5e:	84 c0                	test   %al,%al
  801a60:	75 4a                	jne    801aac <free+0x17b>
        {
            uhp_frees[i].va = va;
  801a62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a65:	89 d0                	mov    %edx,%eax
  801a67:	01 c0                	add    %eax,%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	c1 e0 02             	shl    $0x2,%eax
  801a6e:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801a74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a77:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801a79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a7c:	89 d0                	mov    %edx,%eax
  801a7e:	01 c0                	add    %eax,%eax
  801a80:	01 d0                	add    %edx,%eax
  801a82:	c1 e0 02             	shl    $0x2,%eax
  801a85:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8e:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801a90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a93:	89 d0                	mov    %edx,%eax
  801a95:	01 c0                	add    %eax,%eax
  801a97:	01 d0                	add    %edx,%eax
  801a99:	c1 e0 02             	shl    $0x2,%eax
  801a9c:	05 48 10 81 00       	add    $0x811048,%eax
  801aa1:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801aa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa7:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801aaa:	eb 0c                	jmp    801ab8 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801aac:	ff 45 e4             	incl   -0x1c(%ebp)
  801aaf:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801ab6:	7e 93                	jle    801a4b <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801ab8:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801abc:	0f 84 f1 01 00 00    	je     801cb3 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ac2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ac9:	e9 d8 01 00 00       	jmp    801ca6 <free+0x375>
        {
            if (i == fidx) continue;
  801ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ad4:	0f 84 c8 01 00 00    	je     801ca2 <free+0x371>
            if (uhp_frees[i].free)
  801ada:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801add:	89 d0                	mov    %edx,%eax
  801adf:	01 c0                	add    %eax,%eax
  801ae1:	01 d0                	add    %edx,%eax
  801ae3:	c1 e0 02             	shl    $0x2,%eax
  801ae6:	05 48 10 81 00       	add    $0x811048,%eax
  801aeb:	8a 00                	mov    (%eax),%al
  801aed:	84 c0                	test   %al,%al
  801aef:	0f 84 ae 01 00 00    	je     801ca3 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801af5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801af8:	89 d0                	mov    %edx,%eax
  801afa:	01 c0                	add    %eax,%eax
  801afc:	01 d0                	add    %edx,%eax
  801afe:	c1 e0 02             	shl    $0x2,%eax
  801b01:	05 40 10 81 00       	add    $0x811040,%eax
  801b06:	8b 08                	mov    (%eax),%ecx
  801b08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b0b:	89 d0                	mov    %edx,%eax
  801b0d:	01 c0                	add    %eax,%eax
  801b0f:	01 d0                	add    %edx,%eax
  801b11:	c1 e0 02             	shl    $0x2,%eax
  801b14:	05 44 10 81 00       	add    $0x811044,%eax
  801b19:	8b 00                	mov    (%eax),%eax
  801b1b:	01 c1                	add    %eax,%ecx
  801b1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b20:	89 d0                	mov    %edx,%eax
  801b22:	01 c0                	add    %eax,%eax
  801b24:	01 d0                	add    %edx,%eax
  801b26:	c1 e0 02             	shl    $0x2,%eax
  801b29:	05 40 10 81 00       	add    $0x811040,%eax
  801b2e:	8b 00                	mov    (%eax),%eax
  801b30:	39 c1                	cmp    %eax,%ecx
  801b32:	0f 85 a8 00 00 00    	jne    801be0 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801b38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b3b:	89 d0                	mov    %edx,%eax
  801b3d:	01 c0                	add    %eax,%eax
  801b3f:	01 d0                	add    %edx,%eax
  801b41:	c1 e0 02             	shl    $0x2,%eax
  801b44:	05 40 10 81 00       	add    $0x811040,%eax
  801b49:	8b 10                	mov    (%eax),%edx
  801b4b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801b4e:	89 c8                	mov    %ecx,%eax
  801b50:	01 c0                	add    %eax,%eax
  801b52:	01 c8                	add    %ecx,%eax
  801b54:	c1 e0 02             	shl    $0x2,%eax
  801b57:	05 40 10 81 00       	add    $0x811040,%eax
  801b5c:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801b5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b61:	89 d0                	mov    %edx,%eax
  801b63:	01 c0                	add    %eax,%eax
  801b65:	01 d0                	add    %edx,%eax
  801b67:	c1 e0 02             	shl    $0x2,%eax
  801b6a:	05 44 10 81 00       	add    $0x811044,%eax
  801b6f:	8b 08                	mov    (%eax),%ecx
  801b71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b74:	89 d0                	mov    %edx,%eax
  801b76:	01 c0                	add    %eax,%eax
  801b78:	01 d0                	add    %edx,%eax
  801b7a:	c1 e0 02             	shl    $0x2,%eax
  801b7d:	05 44 10 81 00       	add    $0x811044,%eax
  801b82:	8b 00                	mov    (%eax),%eax
  801b84:	01 c1                	add    %eax,%ecx
  801b86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b89:	89 d0                	mov    %edx,%eax
  801b8b:	01 c0                	add    %eax,%eax
  801b8d:	01 d0                	add    %edx,%eax
  801b8f:	c1 e0 02             	shl    $0x2,%eax
  801b92:	05 44 10 81 00       	add    $0x811044,%eax
  801b97:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801b99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b9c:	89 d0                	mov    %edx,%eax
  801b9e:	01 c0                	add    %eax,%eax
  801ba0:	01 d0                	add    %edx,%eax
  801ba2:	c1 e0 02             	shl    $0x2,%eax
  801ba5:	05 48 10 81 00       	add    $0x811048,%eax
  801baa:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801bad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bb0:	89 d0                	mov    %edx,%eax
  801bb2:	01 c0                	add    %eax,%eax
  801bb4:	01 d0                	add    %edx,%eax
  801bb6:	c1 e0 02             	shl    $0x2,%eax
  801bb9:	05 40 10 81 00       	add    $0x811040,%eax
  801bbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801bc4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bc7:	89 d0                	mov    %edx,%eax
  801bc9:	01 c0                	add    %eax,%eax
  801bcb:	01 d0                	add    %edx,%eax
  801bcd:	c1 e0 02             	shl    $0x2,%eax
  801bd0:	05 44 10 81 00       	add    $0x811044,%eax
  801bd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801bdb:	e9 c3 00 00 00       	jmp    801ca3 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801be0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801be3:	89 d0                	mov    %edx,%eax
  801be5:	01 c0                	add    %eax,%eax
  801be7:	01 d0                	add    %edx,%eax
  801be9:	c1 e0 02             	shl    $0x2,%eax
  801bec:	05 40 10 81 00       	add    $0x811040,%eax
  801bf1:	8b 08                	mov    (%eax),%ecx
  801bf3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bf6:	89 d0                	mov    %edx,%eax
  801bf8:	01 c0                	add    %eax,%eax
  801bfa:	01 d0                	add    %edx,%eax
  801bfc:	c1 e0 02             	shl    $0x2,%eax
  801bff:	05 44 10 81 00       	add    $0x811044,%eax
  801c04:	8b 00                	mov    (%eax),%eax
  801c06:	01 c1                	add    %eax,%ecx
  801c08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c0b:	89 d0                	mov    %edx,%eax
  801c0d:	01 c0                	add    %eax,%eax
  801c0f:	01 d0                	add    %edx,%eax
  801c11:	c1 e0 02             	shl    $0x2,%eax
  801c14:	05 40 10 81 00       	add    $0x811040,%eax
  801c19:	8b 00                	mov    (%eax),%eax
  801c1b:	39 c1                	cmp    %eax,%ecx
  801c1d:	0f 85 80 00 00 00    	jne    801ca3 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c26:	89 d0                	mov    %edx,%eax
  801c28:	01 c0                	add    %eax,%eax
  801c2a:	01 d0                	add    %edx,%eax
  801c2c:	c1 e0 02             	shl    $0x2,%eax
  801c2f:	05 44 10 81 00       	add    $0x811044,%eax
  801c34:	8b 08                	mov    (%eax),%ecx
  801c36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c39:	89 d0                	mov    %edx,%eax
  801c3b:	01 c0                	add    %eax,%eax
  801c3d:	01 d0                	add    %edx,%eax
  801c3f:	c1 e0 02             	shl    $0x2,%eax
  801c42:	05 44 10 81 00       	add    $0x811044,%eax
  801c47:	8b 00                	mov    (%eax),%eax
  801c49:	01 c1                	add    %eax,%ecx
  801c4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c4e:	89 d0                	mov    %edx,%eax
  801c50:	01 c0                	add    %eax,%eax
  801c52:	01 d0                	add    %edx,%eax
  801c54:	c1 e0 02             	shl    $0x2,%eax
  801c57:	05 44 10 81 00       	add    $0x811044,%eax
  801c5c:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801c5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c61:	89 d0                	mov    %edx,%eax
  801c63:	01 c0                	add    %eax,%eax
  801c65:	01 d0                	add    %edx,%eax
  801c67:	c1 e0 02             	shl    $0x2,%eax
  801c6a:	05 48 10 81 00       	add    $0x811048,%eax
  801c6f:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801c72:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c75:	89 d0                	mov    %edx,%eax
  801c77:	01 c0                	add    %eax,%eax
  801c79:	01 d0                	add    %edx,%eax
  801c7b:	c1 e0 02             	shl    $0x2,%eax
  801c7e:	05 40 10 81 00       	add    $0x811040,%eax
  801c83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801c89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c8c:	89 d0                	mov    %edx,%eax
  801c8e:	01 c0                	add    %eax,%eax
  801c90:	01 d0                	add    %edx,%eax
  801c92:	c1 e0 02             	shl    $0x2,%eax
  801c95:	05 44 10 81 00       	add    $0x811044,%eax
  801c9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ca0:	eb 01                	jmp    801ca3 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801ca2:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ca3:	ff 45 e0             	incl   -0x20(%ebp)
  801ca6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801cad:	0f 8e 1b fe ff ff    	jle    801ace <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801cb3:	a1 30 51 83 00       	mov    0x835130,%eax
  801cb8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801cbb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801cc2:	eb 53                	jmp    801d17 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801cc4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cc7:	89 d0                	mov    %edx,%eax
  801cc9:	01 c0                	add    %eax,%eax
  801ccb:	01 d0                	add    %edx,%eax
  801ccd:	c1 e0 02             	shl    $0x2,%eax
  801cd0:	05 48 50 80 00       	add    $0x805048,%eax
  801cd5:	8a 00                	mov    (%eax),%al
  801cd7:	84 c0                	test   %al,%al
  801cd9:	74 39                	je     801d14 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801cdb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cde:	89 d0                	mov    %edx,%eax
  801ce0:	01 c0                	add    %eax,%eax
  801ce2:	01 d0                	add    %edx,%eax
  801ce4:	c1 e0 02             	shl    $0x2,%eax
  801ce7:	05 40 50 80 00       	add    $0x805040,%eax
  801cec:	8b 08                	mov    (%eax),%ecx
  801cee:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cf1:	89 d0                	mov    %edx,%eax
  801cf3:	01 c0                	add    %eax,%eax
  801cf5:	01 d0                	add    %edx,%eax
  801cf7:	c1 e0 02             	shl    $0x2,%eax
  801cfa:	05 44 50 80 00       	add    $0x805044,%eax
  801cff:	8b 00                	mov    (%eax),%eax
  801d01:	01 c8                	add    %ecx,%eax
  801d03:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801d06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d09:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801d0c:	76 06                	jbe    801d14 <free+0x3e3>
  801d0e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d11:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801d14:	ff 45 d8             	incl   -0x28(%ebp)
  801d17:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801d1e:	7e a4                	jle    801cc4 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801d20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d23:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801d28:	83 ec 08             	sub    $0x8,%esp
  801d2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2e:	ff 75 d4             	pushl  -0x2c(%ebp)
  801d31:	e8 79 15 00 00       	call   8032af <sys_free_user_mem>
  801d36:	83 c4 10             	add    $0x10,%esp
  801d39:	eb 01                	jmp    801d3c <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801d3b:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 68             	sub    $0x68,%esp
  801d44:	8b 45 10             	mov    0x10(%ebp),%eax
  801d47:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d4a:	e8 a5 f7 ff ff       	call   8014f4 <uheap_init>
	if (size == 0) return NULL ;
  801d4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d53:	75 0a                	jne    801d5f <smalloc+0x21>
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	e9 37 03 00 00       	jmp    802096 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801d5f:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d69:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d6c:	01 d0                	add    %edx,%eax
  801d6e:	48                   	dec    %eax
  801d6f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d72:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d75:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7a:	f7 75 dc             	divl   -0x24(%ebp)
  801d7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d80:	29 d0                	sub    %edx,%eax
  801d82:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801d85:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801d8c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801d93:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d9a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801da1:	e9 85 00 00 00       	jmp    801e2b <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801da6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801da9:	89 d0                	mov    %edx,%eax
  801dab:	01 c0                	add    %eax,%eax
  801dad:	01 d0                	add    %edx,%eax
  801daf:	c1 e0 02             	shl    $0x2,%eax
  801db2:	05 48 10 81 00       	add    $0x811048,%eax
  801db7:	8a 00                	mov    (%eax),%al
  801db9:	84 c0                	test   %al,%al
  801dbb:	74 20                	je     801ddd <smalloc+0x9f>
  801dbd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dc0:	89 d0                	mov    %edx,%eax
  801dc2:	01 c0                	add    %eax,%eax
  801dc4:	01 d0                	add    %edx,%eax
  801dc6:	c1 e0 02             	shl    $0x2,%eax
  801dc9:	05 44 10 81 00       	add    $0x811044,%eax
  801dce:	8b 00                	mov    (%eax),%eax
  801dd0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801dd3:	75 08                	jne    801ddd <smalloc+0x9f>
        {
            exactIdx = i;
  801dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801ddb:	eb 5b                	jmp    801e38 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801ddd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801de0:	89 d0                	mov    %edx,%eax
  801de2:	01 c0                	add    %eax,%eax
  801de4:	01 d0                	add    %edx,%eax
  801de6:	c1 e0 02             	shl    $0x2,%eax
  801de9:	05 48 10 81 00       	add    $0x811048,%eax
  801dee:	8a 00                	mov    (%eax),%al
  801df0:	84 c0                	test   %al,%al
  801df2:	74 34                	je     801e28 <smalloc+0xea>
  801df4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801df7:	89 d0                	mov    %edx,%eax
  801df9:	01 c0                	add    %eax,%eax
  801dfb:	01 d0                	add    %edx,%eax
  801dfd:	c1 e0 02             	shl    $0x2,%eax
  801e00:	05 44 10 81 00       	add    $0x811044,%eax
  801e05:	8b 00                	mov    (%eax),%eax
  801e07:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e0a:	76 1c                	jbe    801e28 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801e0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e0f:	89 d0                	mov    %edx,%eax
  801e11:	01 c0                	add    %eax,%eax
  801e13:	01 d0                	add    %edx,%eax
  801e15:	c1 e0 02             	shl    $0x2,%eax
  801e18:	05 44 10 81 00       	add    $0x811044,%eax
  801e1d:	8b 00                	mov    (%eax),%eax
  801e1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e25:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e28:	ff 45 e8             	incl   -0x18(%ebp)
  801e2b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801e32:	0f 8e 6e ff ff ff    	jle    801da6 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801e38:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801e3f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801e43:	74 7d                	je     801ec2 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801e45:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4f:	89 d0                	mov    %edx,%eax
  801e51:	01 c0                	add    %eax,%eax
  801e53:	01 d0                	add    %edx,%eax
  801e55:	c1 e0 02             	shl    $0x2,%eax
  801e58:	05 40 10 81 00       	add    $0x811040,%eax
  801e5d:	8b 10                	mov    (%eax),%edx
  801e5f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e62:	01 d0                	add    %edx,%eax
  801e64:	48                   	dec    %eax
  801e65:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801e68:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e70:	f7 75 bc             	divl   -0x44(%ebp)
  801e73:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e76:	29 d0                	sub    %edx,%eax
  801e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7e:	89 d0                	mov    %edx,%eax
  801e80:	01 c0                	add    %eax,%eax
  801e82:	01 d0                	add    %edx,%eax
  801e84:	c1 e0 02             	shl    $0x2,%eax
  801e87:	05 48 10 81 00       	add    $0x811048,%eax
  801e8c:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801e8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e92:	89 d0                	mov    %edx,%eax
  801e94:	01 c0                	add    %eax,%eax
  801e96:	01 d0                	add    %edx,%eax
  801e98:	c1 e0 02             	shl    $0x2,%eax
  801e9b:	05 44 10 81 00       	add    $0x811044,%eax
  801ea0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea9:	89 d0                	mov    %edx,%eax
  801eab:	01 c0                	add    %eax,%eax
  801ead:	01 d0                	add    %edx,%eax
  801eaf:	c1 e0 02             	shl    $0x2,%eax
  801eb2:	05 40 10 81 00       	add    $0x811040,%eax
  801eb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ebd:	e9 2d 01 00 00       	jmp    801fef <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801ec2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ec6:	0f 84 ce 00 00 00    	je     801f9a <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801ecc:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801ed3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed6:	89 d0                	mov    %edx,%eax
  801ed8:	01 c0                	add    %eax,%eax
  801eda:	01 d0                	add    %edx,%eax
  801edc:	c1 e0 02             	shl    $0x2,%eax
  801edf:	05 40 10 81 00       	add    $0x811040,%eax
  801ee4:	8b 10                	mov    (%eax),%edx
  801ee6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ee9:	01 d0                	add    %edx,%eax
  801eeb:	48                   	dec    %eax
  801eec:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801eef:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ef2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef7:	f7 75 c4             	divl   -0x3c(%ebp)
  801efa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801efd:	29 d0                	sub    %edx,%eax
  801eff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801f02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f05:	89 d0                	mov    %edx,%eax
  801f07:	01 c0                	add    %eax,%eax
  801f09:	01 d0                	add    %edx,%eax
  801f0b:	c1 e0 02             	shl    $0x2,%eax
  801f0e:	05 44 10 81 00       	add    $0x811044,%eax
  801f13:	8b 00                	mov    (%eax),%eax
  801f15:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f18:	75 47                	jne    801f61 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801f1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f1d:	89 d0                	mov    %edx,%eax
  801f1f:	01 c0                	add    %eax,%eax
  801f21:	01 d0                	add    %edx,%eax
  801f23:	c1 e0 02             	shl    $0x2,%eax
  801f26:	05 48 10 81 00       	add    $0x811048,%eax
  801f2b:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801f2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f31:	89 d0                	mov    %edx,%eax
  801f33:	01 c0                	add    %eax,%eax
  801f35:	01 d0                	add    %edx,%eax
  801f37:	c1 e0 02             	shl    $0x2,%eax
  801f3a:	05 44 10 81 00       	add    $0x811044,%eax
  801f3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801f45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f48:	89 d0                	mov    %edx,%eax
  801f4a:	01 c0                	add    %eax,%eax
  801f4c:	01 d0                	add    %edx,%eax
  801f4e:	c1 e0 02             	shl    $0x2,%eax
  801f51:	05 40 10 81 00       	add    $0x811040,%eax
  801f56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f5c:	e9 8e 00 00 00       	jmp    801fef <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801f61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f67:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801f6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f6d:	89 d0                	mov    %edx,%eax
  801f6f:	01 c0                	add    %eax,%eax
  801f71:	01 d0                	add    %edx,%eax
  801f73:	c1 e0 02             	shl    $0x2,%eax
  801f76:	05 40 10 81 00       	add    $0x811040,%eax
  801f7b:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f80:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f83:	89 c2                	mov    %eax,%edx
  801f85:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f88:	89 c8                	mov    %ecx,%eax
  801f8a:	01 c0                	add    %eax,%eax
  801f8c:	01 c8                	add    %ecx,%eax
  801f8e:	c1 e0 02             	shl    $0x2,%eax
  801f91:	05 44 10 81 00       	add    $0x811044,%eax
  801f96:	89 10                	mov    %edx,(%eax)
  801f98:	eb 55                	jmp    801fef <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801f9a:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801fa1:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801fa7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801faa:	01 d0                	add    %edx,%eax
  801fac:	48                   	dec    %eax
  801fad:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801fb0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fb3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb8:	f7 75 d0             	divl   -0x30(%ebp)
  801fbb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fbe:	29 d0                	sub    %edx,%eax
  801fc0:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801fc3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801fc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fc9:	01 d0                	add    %edx,%eax
  801fcb:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801fd0:	76 0a                	jbe    801fdc <smalloc+0x29e>
            return NULL;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd7:	e9 ba 00 00 00       	jmp    802096 <smalloc+0x358>
        va = start;
  801fdc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801fdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801fe2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801fe5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fe8:	01 d0                	add    %edx,%eax
  801fea:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ff6:	eb 5e                	jmp    802056 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  801ff8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ffb:	89 d0                	mov    %edx,%eax
  801ffd:	01 c0                	add    %eax,%eax
  801fff:	01 d0                	add    %edx,%eax
  802001:	c1 e0 02             	shl    $0x2,%eax
  802004:	05 48 50 80 00       	add    $0x805048,%eax
  802009:	8a 00                	mov    (%eax),%al
  80200b:	84 c0                	test   %al,%al
  80200d:	75 44                	jne    802053 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80200f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802012:	89 d0                	mov    %edx,%eax
  802014:	01 c0                	add    %eax,%eax
  802016:	01 d0                	add    %edx,%eax
  802018:	c1 e0 02             	shl    $0x2,%eax
  80201b:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802021:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802024:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802026:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802029:	89 d0                	mov    %edx,%eax
  80202b:	01 c0                	add    %eax,%eax
  80202d:	01 d0                	add    %edx,%eax
  80202f:	c1 e0 02             	shl    $0x2,%eax
  802032:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802038:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80203b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80203d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802040:	89 d0                	mov    %edx,%eax
  802042:	01 c0                	add    %eax,%eax
  802044:	01 d0                	add    %edx,%eax
  802046:	c1 e0 02             	shl    $0x2,%eax
  802049:	05 48 50 80 00       	add    $0x805048,%eax
  80204e:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802051:	eb 0c                	jmp    80205f <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802053:	ff 45 e0             	incl   -0x20(%ebp)
  802056:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80205d:	7e 99                	jle    801ff8 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80205f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802062:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802066:	52                   	push   %edx
  802067:	50                   	push   %eax
  802068:	ff 75 d4             	pushl  -0x2c(%ebp)
  80206b:	ff 75 08             	pushl  0x8(%ebp)
  80206e:	e8 de 0e 00 00       	call   802f51 <sys_create_shared_object>
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802079:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80207d:	75 07                	jne    802086 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  80207f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802084:	eb 10                	jmp    802096 <smalloc+0x358>
    if (r < 0)
  802086:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80208a:	79 07                	jns    802093 <smalloc+0x355>
        return NULL;
  80208c:	b8 00 00 00 00       	mov    $0x0,%eax
  802091:	eb 03                	jmp    802096 <smalloc+0x358>
    return (void*)va;
  802093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80209e:	e8 51 f4 ff ff       	call   8014f4 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8020a3:	83 ec 08             	sub    $0x8,%esp
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	ff 75 08             	pushl  0x8(%ebp)
  8020ac:	e8 ca 0e 00 00       	call   802f7b <sys_size_of_shared_object>
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8020b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8020bb:	7f 0a                	jg     8020c7 <sget+0x2f>
        return NULL;
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	e9 28 03 00 00       	jmp    8023ef <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8020c7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8020ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8020d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020d4:	01 d0                	add    %edx,%eax
  8020d6:	48                   	dec    %eax
  8020d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8020da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e2:	f7 75 d8             	divl   -0x28(%ebp)
  8020e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020e8:	29 d0                	sub    %edx,%eax
  8020ea:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8020ed:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8020f4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8020fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802102:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802109:	e9 85 00 00 00       	jmp    802193 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80210e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802111:	89 d0                	mov    %edx,%eax
  802113:	01 c0                	add    %eax,%eax
  802115:	01 d0                	add    %edx,%eax
  802117:	c1 e0 02             	shl    $0x2,%eax
  80211a:	05 48 10 81 00       	add    $0x811048,%eax
  80211f:	8a 00                	mov    (%eax),%al
  802121:	84 c0                	test   %al,%al
  802123:	74 20                	je     802145 <sget+0xad>
  802125:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802128:	89 d0                	mov    %edx,%eax
  80212a:	01 c0                	add    %eax,%eax
  80212c:	01 d0                	add    %edx,%eax
  80212e:	c1 e0 02             	shl    $0x2,%eax
  802131:	05 44 10 81 00       	add    $0x811044,%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80213b:	75 08                	jne    802145 <sget+0xad>
        {
            exactIdx = i;
  80213d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802140:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802143:	eb 5b                	jmp    8021a0 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802145:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802148:	89 d0                	mov    %edx,%eax
  80214a:	01 c0                	add    %eax,%eax
  80214c:	01 d0                	add    %edx,%eax
  80214e:	c1 e0 02             	shl    $0x2,%eax
  802151:	05 48 10 81 00       	add    $0x811048,%eax
  802156:	8a 00                	mov    (%eax),%al
  802158:	84 c0                	test   %al,%al
  80215a:	74 34                	je     802190 <sget+0xf8>
  80215c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80215f:	89 d0                	mov    %edx,%eax
  802161:	01 c0                	add    %eax,%eax
  802163:	01 d0                	add    %edx,%eax
  802165:	c1 e0 02             	shl    $0x2,%eax
  802168:	05 44 10 81 00       	add    $0x811044,%eax
  80216d:	8b 00                	mov    (%eax),%eax
  80216f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802172:	76 1c                	jbe    802190 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802174:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802177:	89 d0                	mov    %edx,%eax
  802179:	01 c0                	add    %eax,%eax
  80217b:	01 d0                	add    %edx,%eax
  80217d:	c1 e0 02             	shl    $0x2,%eax
  802180:	05 44 10 81 00       	add    $0x811044,%eax
  802185:	8b 00                	mov    (%eax),%eax
  802187:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80218a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80218d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802190:	ff 45 e8             	incl   -0x18(%ebp)
  802193:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80219a:	0f 8e 6e ff ff ff    	jle    80210e <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8021a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8021a7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8021ab:	74 7d                	je     80222a <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8021ad:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8021b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b7:	89 d0                	mov    %edx,%eax
  8021b9:	01 c0                	add    %eax,%eax
  8021bb:	01 d0                	add    %edx,%eax
  8021bd:	c1 e0 02             	shl    $0x2,%eax
  8021c0:	05 40 10 81 00       	add    $0x811040,%eax
  8021c5:	8b 10                	mov    (%eax),%edx
  8021c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021ca:	01 d0                	add    %edx,%eax
  8021cc:	48                   	dec    %eax
  8021cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8021d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8021d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d8:	f7 75 b8             	divl   -0x48(%ebp)
  8021db:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8021de:	29 d0                	sub    %edx,%eax
  8021e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8021e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e6:	89 d0                	mov    %edx,%eax
  8021e8:	01 c0                	add    %eax,%eax
  8021ea:	01 d0                	add    %edx,%eax
  8021ec:	c1 e0 02             	shl    $0x2,%eax
  8021ef:	05 48 10 81 00       	add    $0x811048,%eax
  8021f4:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8021f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fa:	89 d0                	mov    %edx,%eax
  8021fc:	01 c0                	add    %eax,%eax
  8021fe:	01 d0                	add    %edx,%eax
  802200:	c1 e0 02             	shl    $0x2,%eax
  802203:	05 44 10 81 00       	add    $0x811044,%eax
  802208:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80220e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802211:	89 d0                	mov    %edx,%eax
  802213:	01 c0                	add    %eax,%eax
  802215:	01 d0                	add    %edx,%eax
  802217:	c1 e0 02             	shl    $0x2,%eax
  80221a:	05 40 10 81 00       	add    $0x811040,%eax
  80221f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802225:	e9 2d 01 00 00       	jmp    802357 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80222a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80222e:	0f 84 ce 00 00 00    	je     802302 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802234:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80223b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80223e:	89 d0                	mov    %edx,%eax
  802240:	01 c0                	add    %eax,%eax
  802242:	01 d0                	add    %edx,%eax
  802244:	c1 e0 02             	shl    $0x2,%eax
  802247:	05 40 10 81 00       	add    $0x811040,%eax
  80224c:	8b 10                	mov    (%eax),%edx
  80224e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802251:	01 d0                	add    %edx,%eax
  802253:	48                   	dec    %eax
  802254:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802257:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80225a:	ba 00 00 00 00       	mov    $0x0,%edx
  80225f:	f7 75 c0             	divl   -0x40(%ebp)
  802262:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802265:	29 d0                	sub    %edx,%eax
  802267:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80226a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80226d:	89 d0                	mov    %edx,%eax
  80226f:	01 c0                	add    %eax,%eax
  802271:	01 d0                	add    %edx,%eax
  802273:	c1 e0 02             	shl    $0x2,%eax
  802276:	05 44 10 81 00       	add    $0x811044,%eax
  80227b:	8b 00                	mov    (%eax),%eax
  80227d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802280:	75 47                	jne    8022c9 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802282:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802285:	89 d0                	mov    %edx,%eax
  802287:	01 c0                	add    %eax,%eax
  802289:	01 d0                	add    %edx,%eax
  80228b:	c1 e0 02             	shl    $0x2,%eax
  80228e:	05 48 10 81 00       	add    $0x811048,%eax
  802293:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802296:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802299:	89 d0                	mov    %edx,%eax
  80229b:	01 c0                	add    %eax,%eax
  80229d:	01 d0                	add    %edx,%eax
  80229f:	c1 e0 02             	shl    $0x2,%eax
  8022a2:	05 44 10 81 00       	add    $0x811044,%eax
  8022a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8022ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b0:	89 d0                	mov    %edx,%eax
  8022b2:	01 c0                	add    %eax,%eax
  8022b4:	01 d0                	add    %edx,%eax
  8022b6:	c1 e0 02             	shl    $0x2,%eax
  8022b9:	05 40 10 81 00       	add    $0x811040,%eax
  8022be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c4:	e9 8e 00 00 00       	jmp    802357 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8022c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022cf:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8022d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d5:	89 d0                	mov    %edx,%eax
  8022d7:	01 c0                	add    %eax,%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	c1 e0 02             	shl    $0x2,%eax
  8022de:	05 40 10 81 00       	add    $0x811040,%eax
  8022e3:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8022e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e8:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8022eb:	89 c2                	mov    %eax,%edx
  8022ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022f0:	89 c8                	mov    %ecx,%eax
  8022f2:	01 c0                	add    %eax,%eax
  8022f4:	01 c8                	add    %ecx,%eax
  8022f6:	c1 e0 02             	shl    $0x2,%eax
  8022f9:	05 44 10 81 00       	add    $0x811044,%eax
  8022fe:	89 10                	mov    %edx,(%eax)
  802300:	eb 55                	jmp    802357 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802302:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802309:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80230f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802312:	01 d0                	add    %edx,%eax
  802314:	48                   	dec    %eax
  802315:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802318:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80231b:	ba 00 00 00 00       	mov    $0x0,%edx
  802320:	f7 75 cc             	divl   -0x34(%ebp)
  802323:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802326:	29 d0                	sub    %edx,%eax
  802328:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  80232b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80232e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802331:	01 d0                	add    %edx,%eax
  802333:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802338:	76 0a                	jbe    802344 <sget+0x2ac>
            return NULL;
  80233a:	b8 00 00 00 00       	mov    $0x0,%eax
  80233f:	e9 ab 00 00 00       	jmp    8023ef <sget+0x357>
        va = start;
  802344:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802347:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80234a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80234d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802350:	01 d0                	add    %edx,%eax
  802352:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802357:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80235e:	eb 5e                	jmp    8023be <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802360:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802363:	89 d0                	mov    %edx,%eax
  802365:	01 c0                	add    %eax,%eax
  802367:	01 d0                	add    %edx,%eax
  802369:	c1 e0 02             	shl    $0x2,%eax
  80236c:	05 48 50 80 00       	add    $0x805048,%eax
  802371:	8a 00                	mov    (%eax),%al
  802373:	84 c0                	test   %al,%al
  802375:	75 44                	jne    8023bb <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802377:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80237a:	89 d0                	mov    %edx,%eax
  80237c:	01 c0                	add    %eax,%eax
  80237e:	01 d0                	add    %edx,%eax
  802380:	c1 e0 02             	shl    $0x2,%eax
  802383:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80238c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80238e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802391:	89 d0                	mov    %edx,%eax
  802393:	01 c0                	add    %eax,%eax
  802395:	01 d0                	add    %edx,%eax
  802397:	c1 e0 02             	shl    $0x2,%eax
  80239a:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8023a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023a3:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8023a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023a8:	89 d0                	mov    %edx,%eax
  8023aa:	01 c0                	add    %eax,%eax
  8023ac:	01 d0                	add    %edx,%eax
  8023ae:	c1 e0 02             	shl    $0x2,%eax
  8023b1:	05 48 50 80 00       	add    $0x805048,%eax
  8023b6:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8023b9:	eb 0c                	jmp    8023c7 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8023bb:	ff 45 e0             	incl   -0x20(%ebp)
  8023be:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8023c5:	7e 99                	jle    802360 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8023c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ca:	83 ec 04             	sub    $0x4,%esp
  8023cd:	50                   	push   %eax
  8023ce:	ff 75 0c             	pushl  0xc(%ebp)
  8023d1:	ff 75 08             	pushl  0x8(%ebp)
  8023d4:	e8 bf 0b 00 00       	call   802f98 <sys_get_shared_object>
  8023d9:	83 c4 10             	add    $0x10,%esp
  8023dc:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8023df:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023e3:	79 07                	jns    8023ec <sget+0x354>
        return NULL;
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ea:	eb 03                	jmp    8023ef <sget+0x357>
    return (void*)va;
  8023ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8023f7:	e8 f8 f0 ff ff       	call   8014f4 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8023fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802400:	75 13                	jne    802415 <realloc+0x24>
		return malloc(new_size);
  802402:	83 ec 0c             	sub    $0xc,%esp
  802405:	ff 75 0c             	pushl  0xc(%ebp)
  802408:	e8 c4 f1 ff ff       	call   8015d1 <malloc>
  80240d:	83 c4 10             	add    $0x10,%esp
  802410:	e9 f4 05 00 00       	jmp    802a09 <realloc+0x618>
	if (new_size == 0)
  802415:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802419:	75 18                	jne    802433 <realloc+0x42>
	{
		free(virtual_address);
  80241b:	83 ec 0c             	sub    $0xc,%esp
  80241e:	ff 75 08             	pushl  0x8(%ebp)
  802421:	e8 0b f5 ff ff       	call   801931 <free>
  802426:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802429:	b8 00 00 00 00       	mov    $0x0,%eax
  80242e:	e9 d6 05 00 00       	jmp    802a09 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802439:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80243c:	85 c0                	test   %eax,%eax
  80243e:	79 74                	jns    8024b4 <realloc+0xc3>
  802440:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802447:	77 6b                	ja     8024b4 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802449:	83 ec 0c             	sub    $0xc,%esp
  80244c:	ff 75 0c             	pushl  0xc(%ebp)
  80244f:	e8 7d f1 ff ff       	call   8015d1 <malloc>
  802454:	83 c4 10             	add    $0x10,%esp
  802457:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80245a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80245e:	75 0a                	jne    80246a <realloc+0x79>
			return NULL;
  802460:	b8 00 00 00 00       	mov    $0x0,%eax
  802465:	e9 9f 05 00 00       	jmp    802a09 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  80246a:	83 ec 0c             	sub    $0xc,%esp
  80246d:	ff 75 08             	pushl  0x8(%ebp)
  802470:	e8 e0 11 00 00       	call   803655 <get_block_size>
  802475:	83 c4 10             	add    $0x10,%esp
  802478:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  80247b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80247e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802481:	39 d0                	cmp    %edx,%eax
  802483:	76 02                	jbe    802487 <realloc+0x96>
  802485:	89 d0                	mov    %edx,%eax
  802487:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  80248a:	83 ec 04             	sub    $0x4,%esp
  80248d:	ff 75 c0             	pushl  -0x40(%ebp)
  802490:	ff 75 08             	pushl  0x8(%ebp)
  802493:	ff 75 c8             	pushl  -0x38(%ebp)
  802496:	e8 56 eb ff ff       	call   800ff1 <memmove>
  80249b:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  80249e:	83 ec 0c             	sub    $0xc,%esp
  8024a1:	ff 75 08             	pushl  0x8(%ebp)
  8024a4:	e8 88 f4 ff ff       	call   801931 <free>
  8024a9:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8024ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024af:	e9 55 05 00 00       	jmp    802a09 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8024b4:	a1 30 51 83 00       	mov    0x835130,%eax
  8024b9:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8024bc:	72 09                	jb     8024c7 <realloc+0xd6>
  8024be:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8024c5:	76 0a                	jbe    8024d1 <realloc+0xe0>
		return NULL;
  8024c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cc:	e9 38 05 00 00       	jmp    802a09 <realloc+0x618>
	uint32 oldsz = 0;
  8024d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8024d8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8024e6:	eb 50                	jmp    802538 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8024e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024eb:	89 d0                	mov    %edx,%eax
  8024ed:	01 c0                	add    %eax,%eax
  8024ef:	01 d0                	add    %edx,%eax
  8024f1:	c1 e0 02             	shl    $0x2,%eax
  8024f4:	05 48 50 80 00       	add    $0x805048,%eax
  8024f9:	8a 00                	mov    (%eax),%al
  8024fb:	84 c0                	test   %al,%al
  8024fd:	74 36                	je     802535 <realloc+0x144>
  8024ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802502:	89 d0                	mov    %edx,%eax
  802504:	01 c0                	add    %eax,%eax
  802506:	01 d0                	add    %edx,%eax
  802508:	c1 e0 02             	shl    $0x2,%eax
  80250b:	05 40 50 80 00       	add    $0x805040,%eax
  802510:	8b 00                	mov    (%eax),%eax
  802512:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802515:	75 1e                	jne    802535 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802517:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80251a:	89 d0                	mov    %edx,%eax
  80251c:	01 c0                	add    %eax,%eax
  80251e:	01 d0                	add    %edx,%eax
  802520:	c1 e0 02             	shl    $0x2,%eax
  802523:	05 44 50 80 00       	add    $0x805044,%eax
  802528:	8b 00                	mov    (%eax),%eax
  80252a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  80252d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802530:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802533:	eb 0c                	jmp    802541 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802535:	ff 45 ec             	incl   -0x14(%ebp)
  802538:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80253f:	7e a7                	jle    8024e8 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802541:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802545:	75 0a                	jne    802551 <realloc+0x160>
		return NULL;
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
  80254c:	e9 b8 04 00 00       	jmp    802a09 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802551:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80255e:	01 d0                	add    %edx,%eax
  802560:	48                   	dec    %eax
  802561:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802564:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802567:	ba 00 00 00 00       	mov    $0x0,%edx
  80256c:	f7 75 bc             	divl   -0x44(%ebp)
  80256f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802572:	29 d0                	sub    %edx,%eax
  802574:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802577:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80257a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80257d:	75 08                	jne    802587 <realloc+0x196>
		return virtual_address;
  80257f:	8b 45 08             	mov    0x8(%ebp),%eax
  802582:	e9 82 04 00 00       	jmp    802a09 <realloc+0x618>
	if (req < oldsz)
  802587:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80258a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80258d:	0f 83 cd 02 00 00    	jae    802860 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802599:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  80259c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80259f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8025a2:	01 d0                	add    %edx,%eax
  8025a4:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8025a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025aa:	89 d0                	mov    %edx,%eax
  8025ac:	01 c0                	add    %eax,%eax
  8025ae:	01 d0                	add    %edx,%eax
  8025b0:	c1 e0 02             	shl    $0x2,%eax
  8025b3:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8025b9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8025bc:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8025be:	83 ec 08             	sub    $0x8,%esp
  8025c1:	ff 75 b0             	pushl  -0x50(%ebp)
  8025c4:	ff 75 ac             	pushl  -0x54(%ebp)
  8025c7:	e8 e3 0c 00 00       	call   8032af <sys_free_user_mem>
  8025cc:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8025cf:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8025d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8025dd:	eb 64                	jmp    802643 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8025df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025e2:	89 d0                	mov    %edx,%eax
  8025e4:	01 c0                	add    %eax,%eax
  8025e6:	01 d0                	add    %edx,%eax
  8025e8:	c1 e0 02             	shl    $0x2,%eax
  8025eb:	05 48 10 81 00       	add    $0x811048,%eax
  8025f0:	8a 00                	mov    (%eax),%al
  8025f2:	84 c0                	test   %al,%al
  8025f4:	75 4a                	jne    802640 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8025f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025f9:	89 d0                	mov    %edx,%eax
  8025fb:	01 c0                	add    %eax,%eax
  8025fd:	01 d0                	add    %edx,%eax
  8025ff:	c1 e0 02             	shl    $0x2,%eax
  802602:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802608:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80260b:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  80260d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802610:	89 d0                	mov    %edx,%eax
  802612:	01 c0                	add    %eax,%eax
  802614:	01 d0                	add    %edx,%eax
  802616:	c1 e0 02             	shl    $0x2,%eax
  802619:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  80261f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802622:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802624:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802627:	89 d0                	mov    %edx,%eax
  802629:	01 c0                	add    %eax,%eax
  80262b:	01 d0                	add    %edx,%eax
  80262d:	c1 e0 02             	shl    $0x2,%eax
  802630:	05 48 10 81 00       	add    $0x811048,%eax
  802635:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  80263e:	eb 0c                	jmp    80264c <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802640:	ff 45 e4             	incl   -0x1c(%ebp)
  802643:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80264a:	7e 93                	jle    8025df <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  80264c:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802650:	0f 84 8d 01 00 00    	je     8027e3 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802656:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80265d:	e9 74 01 00 00       	jmp    8027d6 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802665:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802668:	0f 84 64 01 00 00    	je     8027d2 <realloc+0x3e1>
				if (uhp_frees[k].free)
  80266e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802671:	89 d0                	mov    %edx,%eax
  802673:	01 c0                	add    %eax,%eax
  802675:	01 d0                	add    %edx,%eax
  802677:	c1 e0 02             	shl    $0x2,%eax
  80267a:	05 48 10 81 00       	add    $0x811048,%eax
  80267f:	8a 00                	mov    (%eax),%al
  802681:	84 c0                	test   %al,%al
  802683:	0f 84 4a 01 00 00    	je     8027d3 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80268c:	89 d0                	mov    %edx,%eax
  80268e:	01 c0                	add    %eax,%eax
  802690:	01 d0                	add    %edx,%eax
  802692:	c1 e0 02             	shl    $0x2,%eax
  802695:	05 40 10 81 00       	add    $0x811040,%eax
  80269a:	8b 08                	mov    (%eax),%ecx
  80269c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80269f:	89 d0                	mov    %edx,%eax
  8026a1:	01 c0                	add    %eax,%eax
  8026a3:	01 d0                	add    %edx,%eax
  8026a5:	c1 e0 02             	shl    $0x2,%eax
  8026a8:	05 44 10 81 00       	add    $0x811044,%eax
  8026ad:	8b 00                	mov    (%eax),%eax
  8026af:	01 c1                	add    %eax,%ecx
  8026b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026b4:	89 d0                	mov    %edx,%eax
  8026b6:	01 c0                	add    %eax,%eax
  8026b8:	01 d0                	add    %edx,%eax
  8026ba:	c1 e0 02             	shl    $0x2,%eax
  8026bd:	05 40 10 81 00       	add    $0x811040,%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	39 c1                	cmp    %eax,%ecx
  8026c6:	75 7a                	jne    802742 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8026c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026cb:	89 d0                	mov    %edx,%eax
  8026cd:	01 c0                	add    %eax,%eax
  8026cf:	01 d0                	add    %edx,%eax
  8026d1:	c1 e0 02             	shl    $0x2,%eax
  8026d4:	05 40 10 81 00       	add    $0x811040,%eax
  8026d9:	8b 10                	mov    (%eax),%edx
  8026db:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8026de:	89 c8                	mov    %ecx,%eax
  8026e0:	01 c0                	add    %eax,%eax
  8026e2:	01 c8                	add    %ecx,%eax
  8026e4:	c1 e0 02             	shl    $0x2,%eax
  8026e7:	05 40 10 81 00       	add    $0x811040,%eax
  8026ec:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  8026ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026f1:	89 d0                	mov    %edx,%eax
  8026f3:	01 c0                	add    %eax,%eax
  8026f5:	01 d0                	add    %edx,%eax
  8026f7:	c1 e0 02             	shl    $0x2,%eax
  8026fa:	05 44 10 81 00       	add    $0x811044,%eax
  8026ff:	8b 08                	mov    (%eax),%ecx
  802701:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802704:	89 d0                	mov    %edx,%eax
  802706:	01 c0                	add    %eax,%eax
  802708:	01 d0                	add    %edx,%eax
  80270a:	c1 e0 02             	shl    $0x2,%eax
  80270d:	05 44 10 81 00       	add    $0x811044,%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	01 c1                	add    %eax,%ecx
  802716:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802719:	89 d0                	mov    %edx,%eax
  80271b:	01 c0                	add    %eax,%eax
  80271d:	01 d0                	add    %edx,%eax
  80271f:	c1 e0 02             	shl    $0x2,%eax
  802722:	05 44 10 81 00       	add    $0x811044,%eax
  802727:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802729:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80272c:	89 d0                	mov    %edx,%eax
  80272e:	01 c0                	add    %eax,%eax
  802730:	01 d0                	add    %edx,%eax
  802732:	c1 e0 02             	shl    $0x2,%eax
  802735:	05 48 10 81 00       	add    $0x811048,%eax
  80273a:	c6 00 00             	movb   $0x0,(%eax)
  80273d:	e9 91 00 00 00       	jmp    8027d3 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802742:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802745:	89 d0                	mov    %edx,%eax
  802747:	01 c0                	add    %eax,%eax
  802749:	01 d0                	add    %edx,%eax
  80274b:	c1 e0 02             	shl    $0x2,%eax
  80274e:	05 40 10 81 00       	add    $0x811040,%eax
  802753:	8b 08                	mov    (%eax),%ecx
  802755:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802758:	89 d0                	mov    %edx,%eax
  80275a:	01 c0                	add    %eax,%eax
  80275c:	01 d0                	add    %edx,%eax
  80275e:	c1 e0 02             	shl    $0x2,%eax
  802761:	05 44 10 81 00       	add    $0x811044,%eax
  802766:	8b 00                	mov    (%eax),%eax
  802768:	01 c1                	add    %eax,%ecx
  80276a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80276d:	89 d0                	mov    %edx,%eax
  80276f:	01 c0                	add    %eax,%eax
  802771:	01 d0                	add    %edx,%eax
  802773:	c1 e0 02             	shl    $0x2,%eax
  802776:	05 40 10 81 00       	add    $0x811040,%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	39 c1                	cmp    %eax,%ecx
  80277f:	75 52                	jne    8027d3 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802781:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802784:	89 d0                	mov    %edx,%eax
  802786:	01 c0                	add    %eax,%eax
  802788:	01 d0                	add    %edx,%eax
  80278a:	c1 e0 02             	shl    $0x2,%eax
  80278d:	05 44 10 81 00       	add    $0x811044,%eax
  802792:	8b 08                	mov    (%eax),%ecx
  802794:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802797:	89 d0                	mov    %edx,%eax
  802799:	01 c0                	add    %eax,%eax
  80279b:	01 d0                	add    %edx,%eax
  80279d:	c1 e0 02             	shl    $0x2,%eax
  8027a0:	05 44 10 81 00       	add    $0x811044,%eax
  8027a5:	8b 00                	mov    (%eax),%eax
  8027a7:	01 c1                	add    %eax,%ecx
  8027a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ac:	89 d0                	mov    %edx,%eax
  8027ae:	01 c0                	add    %eax,%eax
  8027b0:	01 d0                	add    %edx,%eax
  8027b2:	c1 e0 02             	shl    $0x2,%eax
  8027b5:	05 44 10 81 00       	add    $0x811044,%eax
  8027ba:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8027bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027bf:	89 d0                	mov    %edx,%eax
  8027c1:	01 c0                	add    %eax,%eax
  8027c3:	01 d0                	add    %edx,%eax
  8027c5:	c1 e0 02             	shl    $0x2,%eax
  8027c8:	05 48 10 81 00       	add    $0x811048,%eax
  8027cd:	c6 00 00             	movb   $0x0,(%eax)
  8027d0:	eb 01                	jmp    8027d3 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  8027d2:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8027d3:	ff 45 e0             	incl   -0x20(%ebp)
  8027d6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8027dd:	0f 8e 7f fe ff ff    	jle    802662 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  8027e3:	a1 30 51 83 00       	mov    0x835130,%eax
  8027e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8027eb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8027f2:	eb 53                	jmp    802847 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  8027f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027f7:	89 d0                	mov    %edx,%eax
  8027f9:	01 c0                	add    %eax,%eax
  8027fb:	01 d0                	add    %edx,%eax
  8027fd:	c1 e0 02             	shl    $0x2,%eax
  802800:	05 48 50 80 00       	add    $0x805048,%eax
  802805:	8a 00                	mov    (%eax),%al
  802807:	84 c0                	test   %al,%al
  802809:	74 39                	je     802844 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80280b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80280e:	89 d0                	mov    %edx,%eax
  802810:	01 c0                	add    %eax,%eax
  802812:	01 d0                	add    %edx,%eax
  802814:	c1 e0 02             	shl    $0x2,%eax
  802817:	05 40 50 80 00       	add    $0x805040,%eax
  80281c:	8b 08                	mov    (%eax),%ecx
  80281e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802821:	89 d0                	mov    %edx,%eax
  802823:	01 c0                	add    %eax,%eax
  802825:	01 d0                	add    %edx,%eax
  802827:	c1 e0 02             	shl    $0x2,%eax
  80282a:	05 44 50 80 00       	add    $0x805044,%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	01 c8                	add    %ecx,%eax
  802833:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802836:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802839:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80283c:	76 06                	jbe    802844 <realloc+0x453>
  80283e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802841:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802844:	ff 45 d8             	incl   -0x28(%ebp)
  802847:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80284e:	7e a4                	jle    8027f4 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802850:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802853:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802858:	8b 45 08             	mov    0x8(%ebp),%eax
  80285b:	e9 a9 01 00 00       	jmp    802a09 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802860:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	01 d0                	add    %edx,%eax
  802868:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  80286b:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802872:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802879:	eb 57                	jmp    8028d2 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  80287b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80287e:	89 d0                	mov    %edx,%eax
  802880:	01 c0                	add    %eax,%eax
  802882:	01 d0                	add    %edx,%eax
  802884:	c1 e0 02             	shl    $0x2,%eax
  802887:	05 48 10 81 00       	add    $0x811048,%eax
  80288c:	8a 00                	mov    (%eax),%al
  80288e:	84 c0                	test   %al,%al
  802890:	74 3d                	je     8028cf <realloc+0x4de>
  802892:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802895:	89 d0                	mov    %edx,%eax
  802897:	01 c0                	add    %eax,%eax
  802899:	01 d0                	add    %edx,%eax
  80289b:	c1 e0 02             	shl    $0x2,%eax
  80289e:	05 40 10 81 00       	add    $0x811040,%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a8:	75 25                	jne    8028cf <realloc+0x4de>
  8028aa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028ad:	89 d0                	mov    %edx,%eax
  8028af:	01 c0                	add    %eax,%eax
  8028b1:	01 d0                	add    %edx,%eax
  8028b3:	c1 e0 02             	shl    $0x2,%eax
  8028b6:	05 44 10 81 00       	add    $0x811044,%eax
  8028bb:	8b 10                	mov    (%eax),%edx
  8028bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8028c3:	39 c2                	cmp    %eax,%edx
  8028c5:	72 08                	jb     8028cf <realloc+0x4de>
		{
			adjIdx = j; break;
  8028c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8028cd:	eb 0c                	jmp    8028db <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8028cf:	ff 45 d0             	incl   -0x30(%ebp)
  8028d2:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  8028d9:	7e a0                	jle    80287b <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  8028db:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  8028df:	0f 84 d6 00 00 00    	je     8029bb <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  8028e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028e8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8028eb:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  8028ee:	83 ec 08             	sub    $0x8,%esp
  8028f1:	ff 75 a0             	pushl  -0x60(%ebp)
  8028f4:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028f7:	e8 cf 09 00 00       	call   8032cb <sys_allocate_user_mem>
  8028fc:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  8028ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802902:	89 d0                	mov    %edx,%eax
  802904:	01 c0                	add    %eax,%eax
  802906:	01 d0                	add    %edx,%eax
  802908:	c1 e0 02             	shl    $0x2,%eax
  80290b:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802911:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802914:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802916:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802919:	89 d0                	mov    %edx,%eax
  80291b:	01 c0                	add    %eax,%eax
  80291d:	01 d0                	add    %edx,%eax
  80291f:	c1 e0 02             	shl    $0x2,%eax
  802922:	05 40 10 81 00       	add    $0x811040,%eax
  802927:	8b 10                	mov    (%eax),%edx
  802929:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80292c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80292f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802932:	89 d0                	mov    %edx,%eax
  802934:	01 c0                	add    %eax,%eax
  802936:	01 d0                	add    %edx,%eax
  802938:	c1 e0 02             	shl    $0x2,%eax
  80293b:	05 40 10 81 00       	add    $0x811040,%eax
  802940:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802942:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802945:	89 d0                	mov    %edx,%eax
  802947:	01 c0                	add    %eax,%eax
  802949:	01 d0                	add    %edx,%eax
  80294b:	c1 e0 02             	shl    $0x2,%eax
  80294e:	05 44 10 81 00       	add    $0x811044,%eax
  802953:	8b 00                	mov    (%eax),%eax
  802955:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802958:	89 c2                	mov    %eax,%edx
  80295a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80295d:	89 c8                	mov    %ecx,%eax
  80295f:	01 c0                	add    %eax,%eax
  802961:	01 c8                	add    %ecx,%eax
  802963:	c1 e0 02             	shl    $0x2,%eax
  802966:	05 44 10 81 00       	add    $0x811044,%eax
  80296b:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  80296d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802970:	89 d0                	mov    %edx,%eax
  802972:	01 c0                	add    %eax,%eax
  802974:	01 d0                	add    %edx,%eax
  802976:	c1 e0 02             	shl    $0x2,%eax
  802979:	05 44 10 81 00       	add    $0x811044,%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	75 14                	jne    802998 <realloc+0x5a7>
  802984:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802987:	89 d0                	mov    %edx,%eax
  802989:	01 c0                	add    %eax,%eax
  80298b:	01 d0                	add    %edx,%eax
  80298d:	c1 e0 02             	shl    $0x2,%eax
  802990:	05 48 10 81 00       	add    $0x811048,%eax
  802995:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802998:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80299b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80299e:	01 c2                	add    %eax,%edx
  8029a0:	a1 88 50 83 00       	mov    0x835088,%eax
  8029a5:	39 c2                	cmp    %eax,%edx
  8029a7:	76 0d                	jbe    8029b6 <realloc+0x5c5>
  8029a9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029ac:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029af:	01 d0                	add    %edx,%eax
  8029b1:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	eb 4e                	jmp    802a09 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  8029bb:	83 ec 0c             	sub    $0xc,%esp
  8029be:	ff 75 0c             	pushl  0xc(%ebp)
  8029c1:	e8 0b ec ff ff       	call   8015d1 <malloc>
  8029c6:	83 c4 10             	add    $0x10,%esp
  8029c9:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  8029cc:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  8029d0:	75 07                	jne    8029d9 <realloc+0x5e8>
		return NULL;
  8029d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d7:	eb 30                	jmp    802a09 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  8029d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029dc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029df:	39 d0                	cmp    %edx,%eax
  8029e1:	76 02                	jbe    8029e5 <realloc+0x5f4>
  8029e3:	89 d0                	mov    %edx,%eax
  8029e5:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8029e8:	83 ec 04             	sub    $0x4,%esp
  8029eb:	50                   	push   %eax
  8029ec:	52                   	push   %edx
  8029ed:	ff 75 cc             	pushl  -0x34(%ebp)
  8029f0:	e8 cf 06 00 00       	call   8030c4 <sys_move_user_mem>
  8029f5:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  8029f8:	83 ec 0c             	sub    $0xc,%esp
  8029fb:	ff 75 08             	pushl  0x8(%ebp)
  8029fe:	e8 2e ef ff ff       	call   801931 <free>
  802a03:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802a06:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802a09:	c9                   	leave  
  802a0a:	c3                   	ret    

00802a0b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802a0b:	55                   	push   %ebp
  802a0c:	89 e5                	mov    %esp,%ebp
  802a0e:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802a17:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a1b:	0f 84 33 03 00 00    	je     802d54 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802a21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a24:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802a29:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802a2c:	83 ec 08             	sub    $0x8,%esp
  802a2f:	ff 75 08             	pushl  0x8(%ebp)
  802a32:	ff 75 d8             	pushl  -0x28(%ebp)
  802a35:	e8 7d 05 00 00       	call   802fb7 <sys_delete_shared_object>
  802a3a:	83 c4 10             	add    $0x10,%esp
  802a3d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802a40:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802a44:	0f 88 0d 03 00 00    	js     802d57 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802a4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a51:	e9 ef 02 00 00       	jmp    802d45 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a59:	89 d0                	mov    %edx,%eax
  802a5b:	01 c0                	add    %eax,%eax
  802a5d:	01 d0                	add    %edx,%eax
  802a5f:	c1 e0 02             	shl    $0x2,%eax
  802a62:	05 48 50 80 00       	add    $0x805048,%eax
  802a67:	8a 00                	mov    (%eax),%al
  802a69:	84 c0                	test   %al,%al
  802a6b:	0f 84 d1 02 00 00    	je     802d42 <sfree+0x337>
  802a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a74:	89 d0                	mov    %edx,%eax
  802a76:	01 c0                	add    %eax,%eax
  802a78:	01 d0                	add    %edx,%eax
  802a7a:	c1 e0 02             	shl    $0x2,%eax
  802a7d:	05 40 50 80 00       	add    $0x805040,%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802a87:	0f 85 b5 02 00 00    	jne    802d42 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802a8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a90:	89 d0                	mov    %edx,%eax
  802a92:	01 c0                	add    %eax,%eax
  802a94:	01 d0                	add    %edx,%eax
  802a96:	c1 e0 02             	shl    $0x2,%eax
  802a99:	05 44 50 80 00       	add    $0x805044,%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802aa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa6:	89 d0                	mov    %edx,%eax
  802aa8:	01 c0                	add    %eax,%eax
  802aaa:	01 d0                	add    %edx,%eax
  802aac:	c1 e0 02             	shl    $0x2,%eax
  802aaf:	05 48 50 80 00       	add    $0x805048,%eax
  802ab4:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802ab7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802abe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802ac5:	eb 64                	jmp    802b2b <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802ac7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aca:	89 d0                	mov    %edx,%eax
  802acc:	01 c0                	add    %eax,%eax
  802ace:	01 d0                	add    %edx,%eax
  802ad0:	c1 e0 02             	shl    $0x2,%eax
  802ad3:	05 48 10 81 00       	add    $0x811048,%eax
  802ad8:	8a 00                	mov    (%eax),%al
  802ada:	84 c0                	test   %al,%al
  802adc:	75 4a                	jne    802b28 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802ade:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae1:	89 d0                	mov    %edx,%eax
  802ae3:	01 c0                	add    %eax,%eax
  802ae5:	01 d0                	add    %edx,%eax
  802ae7:	c1 e0 02             	shl    $0x2,%eax
  802aea:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802af0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802af3:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802af5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af8:	89 d0                	mov    %edx,%eax
  802afa:	01 c0                	add    %eax,%eax
  802afc:	01 d0                	add    %edx,%eax
  802afe:	c1 e0 02             	shl    $0x2,%eax
  802b01:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802b07:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b0a:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802b0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b0f:	89 d0                	mov    %edx,%eax
  802b11:	01 c0                	add    %eax,%eax
  802b13:	01 d0                	add    %edx,%eax
  802b15:	c1 e0 02             	shl    $0x2,%eax
  802b18:	05 48 10 81 00       	add    $0x811048,%eax
  802b1d:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802b26:	eb 0c                	jmp    802b34 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b28:	ff 45 ec             	incl   -0x14(%ebp)
  802b2b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802b32:	7e 93                	jle    802ac7 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802b34:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b38:	0f 84 8d 01 00 00    	je     802ccb <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802b3e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802b45:	e9 74 01 00 00       	jmp    802cbe <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802b4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b50:	0f 84 64 01 00 00    	je     802cba <sfree+0x2af>
					if (uhp_frees[k].free)
  802b56:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b59:	89 d0                	mov    %edx,%eax
  802b5b:	01 c0                	add    %eax,%eax
  802b5d:	01 d0                	add    %edx,%eax
  802b5f:	c1 e0 02             	shl    $0x2,%eax
  802b62:	05 48 10 81 00       	add    $0x811048,%eax
  802b67:	8a 00                	mov    (%eax),%al
  802b69:	84 c0                	test   %al,%al
  802b6b:	0f 84 4a 01 00 00    	je     802cbb <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802b71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b74:	89 d0                	mov    %edx,%eax
  802b76:	01 c0                	add    %eax,%eax
  802b78:	01 d0                	add    %edx,%eax
  802b7a:	c1 e0 02             	shl    $0x2,%eax
  802b7d:	05 40 10 81 00       	add    $0x811040,%eax
  802b82:	8b 08                	mov    (%eax),%ecx
  802b84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b87:	89 d0                	mov    %edx,%eax
  802b89:	01 c0                	add    %eax,%eax
  802b8b:	01 d0                	add    %edx,%eax
  802b8d:	c1 e0 02             	shl    $0x2,%eax
  802b90:	05 44 10 81 00       	add    $0x811044,%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	01 c1                	add    %eax,%ecx
  802b99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9c:	89 d0                	mov    %edx,%eax
  802b9e:	01 c0                	add    %eax,%eax
  802ba0:	01 d0                	add    %edx,%eax
  802ba2:	c1 e0 02             	shl    $0x2,%eax
  802ba5:	05 40 10 81 00       	add    $0x811040,%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	39 c1                	cmp    %eax,%ecx
  802bae:	75 7a                	jne    802c2a <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802bb0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb3:	89 d0                	mov    %edx,%eax
  802bb5:	01 c0                	add    %eax,%eax
  802bb7:	01 d0                	add    %edx,%eax
  802bb9:	c1 e0 02             	shl    $0x2,%eax
  802bbc:	05 40 10 81 00       	add    $0x811040,%eax
  802bc1:	8b 10                	mov    (%eax),%edx
  802bc3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802bc6:	89 c8                	mov    %ecx,%eax
  802bc8:	01 c0                	add    %eax,%eax
  802bca:	01 c8                	add    %ecx,%eax
  802bcc:	c1 e0 02             	shl    $0x2,%eax
  802bcf:	05 40 10 81 00       	add    $0x811040,%eax
  802bd4:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802bd6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd9:	89 d0                	mov    %edx,%eax
  802bdb:	01 c0                	add    %eax,%eax
  802bdd:	01 d0                	add    %edx,%eax
  802bdf:	c1 e0 02             	shl    $0x2,%eax
  802be2:	05 44 10 81 00       	add    $0x811044,%eax
  802be7:	8b 08                	mov    (%eax),%ecx
  802be9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bec:	89 d0                	mov    %edx,%eax
  802bee:	01 c0                	add    %eax,%eax
  802bf0:	01 d0                	add    %edx,%eax
  802bf2:	c1 e0 02             	shl    $0x2,%eax
  802bf5:	05 44 10 81 00       	add    $0x811044,%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	01 c1                	add    %eax,%ecx
  802bfe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c01:	89 d0                	mov    %edx,%eax
  802c03:	01 c0                	add    %eax,%eax
  802c05:	01 d0                	add    %edx,%eax
  802c07:	c1 e0 02             	shl    $0x2,%eax
  802c0a:	05 44 10 81 00       	add    $0x811044,%eax
  802c0f:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802c11:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c14:	89 d0                	mov    %edx,%eax
  802c16:	01 c0                	add    %eax,%eax
  802c18:	01 d0                	add    %edx,%eax
  802c1a:	c1 e0 02             	shl    $0x2,%eax
  802c1d:	05 48 10 81 00       	add    $0x811048,%eax
  802c22:	c6 00 00             	movb   $0x0,(%eax)
  802c25:	e9 91 00 00 00       	jmp    802cbb <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802c2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c2d:	89 d0                	mov    %edx,%eax
  802c2f:	01 c0                	add    %eax,%eax
  802c31:	01 d0                	add    %edx,%eax
  802c33:	c1 e0 02             	shl    $0x2,%eax
  802c36:	05 40 10 81 00       	add    $0x811040,%eax
  802c3b:	8b 08                	mov    (%eax),%ecx
  802c3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c40:	89 d0                	mov    %edx,%eax
  802c42:	01 c0                	add    %eax,%eax
  802c44:	01 d0                	add    %edx,%eax
  802c46:	c1 e0 02             	shl    $0x2,%eax
  802c49:	05 44 10 81 00       	add    $0x811044,%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	01 c1                	add    %eax,%ecx
  802c52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c55:	89 d0                	mov    %edx,%eax
  802c57:	01 c0                	add    %eax,%eax
  802c59:	01 d0                	add    %edx,%eax
  802c5b:	c1 e0 02             	shl    $0x2,%eax
  802c5e:	05 40 10 81 00       	add    $0x811040,%eax
  802c63:	8b 00                	mov    (%eax),%eax
  802c65:	39 c1                	cmp    %eax,%ecx
  802c67:	75 52                	jne    802cbb <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802c69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c6c:	89 d0                	mov    %edx,%eax
  802c6e:	01 c0                	add    %eax,%eax
  802c70:	01 d0                	add    %edx,%eax
  802c72:	c1 e0 02             	shl    $0x2,%eax
  802c75:	05 44 10 81 00       	add    $0x811044,%eax
  802c7a:	8b 08                	mov    (%eax),%ecx
  802c7c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c7f:	89 d0                	mov    %edx,%eax
  802c81:	01 c0                	add    %eax,%eax
  802c83:	01 d0                	add    %edx,%eax
  802c85:	c1 e0 02             	shl    $0x2,%eax
  802c88:	05 44 10 81 00       	add    $0x811044,%eax
  802c8d:	8b 00                	mov    (%eax),%eax
  802c8f:	01 c1                	add    %eax,%ecx
  802c91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c94:	89 d0                	mov    %edx,%eax
  802c96:	01 c0                	add    %eax,%eax
  802c98:	01 d0                	add    %edx,%eax
  802c9a:	c1 e0 02             	shl    $0x2,%eax
  802c9d:	05 44 10 81 00       	add    $0x811044,%eax
  802ca2:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802ca4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ca7:	89 d0                	mov    %edx,%eax
  802ca9:	01 c0                	add    %eax,%eax
  802cab:	01 d0                	add    %edx,%eax
  802cad:	c1 e0 02             	shl    $0x2,%eax
  802cb0:	05 48 10 81 00       	add    $0x811048,%eax
  802cb5:	c6 00 00             	movb   $0x0,(%eax)
  802cb8:	eb 01                	jmp    802cbb <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802cba:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802cbb:	ff 45 e8             	incl   -0x18(%ebp)
  802cbe:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802cc5:	0f 8e 7f fe ff ff    	jle    802b4a <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802ccb:	a1 30 51 83 00       	mov    0x835130,%eax
  802cd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802cd3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802cda:	eb 53                	jmp    802d2f <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802cdc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cdf:	89 d0                	mov    %edx,%eax
  802ce1:	01 c0                	add    %eax,%eax
  802ce3:	01 d0                	add    %edx,%eax
  802ce5:	c1 e0 02             	shl    $0x2,%eax
  802ce8:	05 48 50 80 00       	add    $0x805048,%eax
  802ced:	8a 00                	mov    (%eax),%al
  802cef:	84 c0                	test   %al,%al
  802cf1:	74 39                	je     802d2c <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802cf3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cf6:	89 d0                	mov    %edx,%eax
  802cf8:	01 c0                	add    %eax,%eax
  802cfa:	01 d0                	add    %edx,%eax
  802cfc:	c1 e0 02             	shl    $0x2,%eax
  802cff:	05 40 50 80 00       	add    $0x805040,%eax
  802d04:	8b 08                	mov    (%eax),%ecx
  802d06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d09:	89 d0                	mov    %edx,%eax
  802d0b:	01 c0                	add    %eax,%eax
  802d0d:	01 d0                	add    %edx,%eax
  802d0f:	c1 e0 02             	shl    $0x2,%eax
  802d12:	05 44 50 80 00       	add    $0x805044,%eax
  802d17:	8b 00                	mov    (%eax),%eax
  802d19:	01 c8                	add    %ecx,%eax
  802d1b:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802d1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d21:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d24:	76 06                	jbe    802d2c <sfree+0x321>
  802d26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802d2c:	ff 45 e0             	incl   -0x20(%ebp)
  802d2f:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802d36:	7e a4                	jle    802cdc <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3b:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802d40:	eb 16                	jmp    802d58 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802d42:	ff 45 f4             	incl   -0xc(%ebp)
  802d45:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802d4c:	0f 8e 04 fd ff ff    	jle    802a56 <sfree+0x4b>
  802d52:	eb 04                	jmp    802d58 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802d54:	90                   	nop
  802d55:	eb 01                	jmp    802d58 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802d57:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802d58:	c9                   	leave  
  802d59:	c3                   	ret    

00802d5a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d5a:	55                   	push   %ebp
  802d5b:	89 e5                	mov    %esp,%ebp
  802d5d:	57                   	push   %edi
  802d5e:	56                   	push   %esi
  802d5f:	53                   	push   %ebx
  802d60:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d6c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d6f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d72:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d75:	cd 30                	int    $0x30
  802d77:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d7d:	83 c4 10             	add    $0x10,%esp
  802d80:	5b                   	pop    %ebx
  802d81:	5e                   	pop    %esi
  802d82:	5f                   	pop    %edi
  802d83:	5d                   	pop    %ebp
  802d84:	c3                   	ret    

00802d85 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802d85:	55                   	push   %ebp
  802d86:	89 e5                	mov    %esp,%ebp
  802d88:	83 ec 04             	sub    $0x4,%esp
  802d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  802d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802d91:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d94:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	6a 00                	push   $0x0
  802d9d:	51                   	push   %ecx
  802d9e:	52                   	push   %edx
  802d9f:	ff 75 0c             	pushl  0xc(%ebp)
  802da2:	50                   	push   %eax
  802da3:	6a 00                	push   $0x0
  802da5:	e8 b0 ff ff ff       	call   802d5a <syscall>
  802daa:	83 c4 18             	add    $0x18,%esp
}
  802dad:	90                   	nop
  802dae:	c9                   	leave  
  802daf:	c3                   	ret    

00802db0 <sys_cgetc>:

int
sys_cgetc(void)
{
  802db0:	55                   	push   %ebp
  802db1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802db3:	6a 00                	push   $0x0
  802db5:	6a 00                	push   $0x0
  802db7:	6a 00                	push   $0x0
  802db9:	6a 00                	push   $0x0
  802dbb:	6a 00                	push   $0x0
  802dbd:	6a 02                	push   $0x2
  802dbf:	e8 96 ff ff ff       	call   802d5a <syscall>
  802dc4:	83 c4 18             	add    $0x18,%esp
}
  802dc7:	c9                   	leave  
  802dc8:	c3                   	ret    

00802dc9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802dc9:	55                   	push   %ebp
  802dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 03                	push   $0x3
  802dd8:	e8 7d ff ff ff       	call   802d5a <syscall>
  802ddd:	83 c4 18             	add    $0x18,%esp
}
  802de0:	90                   	nop
  802de1:	c9                   	leave  
  802de2:	c3                   	ret    

00802de3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802de3:	55                   	push   %ebp
  802de4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802de6:	6a 00                	push   $0x0
  802de8:	6a 00                	push   $0x0
  802dea:	6a 00                	push   $0x0
  802dec:	6a 00                	push   $0x0
  802dee:	6a 00                	push   $0x0
  802df0:	6a 04                	push   $0x4
  802df2:	e8 63 ff ff ff       	call   802d5a <syscall>
  802df7:	83 c4 18             	add    $0x18,%esp
}
  802dfa:	90                   	nop
  802dfb:	c9                   	leave  
  802dfc:	c3                   	ret    

00802dfd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802dfd:	55                   	push   %ebp
  802dfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802e00:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	6a 00                	push   $0x0
  802e08:	6a 00                	push   $0x0
  802e0a:	6a 00                	push   $0x0
  802e0c:	52                   	push   %edx
  802e0d:	50                   	push   %eax
  802e0e:	6a 08                	push   $0x8
  802e10:	e8 45 ff ff ff       	call   802d5a <syscall>
  802e15:	83 c4 18             	add    $0x18,%esp
}
  802e18:	c9                   	leave  
  802e19:	c3                   	ret    

00802e1a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802e1a:	55                   	push   %ebp
  802e1b:	89 e5                	mov    %esp,%ebp
  802e1d:	56                   	push   %esi
  802e1e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802e1f:	8b 75 18             	mov    0x18(%ebp),%esi
  802e22:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e28:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	56                   	push   %esi
  802e2f:	53                   	push   %ebx
  802e30:	51                   	push   %ecx
  802e31:	52                   	push   %edx
  802e32:	50                   	push   %eax
  802e33:	6a 09                	push   $0x9
  802e35:	e8 20 ff ff ff       	call   802d5a <syscall>
  802e3a:	83 c4 18             	add    $0x18,%esp
}
  802e3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e40:	5b                   	pop    %ebx
  802e41:	5e                   	pop    %esi
  802e42:	5d                   	pop    %ebp
  802e43:	c3                   	ret    

00802e44 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802e44:	55                   	push   %ebp
  802e45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802e47:	6a 00                	push   $0x0
  802e49:	6a 00                	push   $0x0
  802e4b:	6a 00                	push   $0x0
  802e4d:	6a 00                	push   $0x0
  802e4f:	ff 75 08             	pushl  0x8(%ebp)
  802e52:	6a 0a                	push   $0xa
  802e54:	e8 01 ff ff ff       	call   802d5a <syscall>
  802e59:	83 c4 18             	add    $0x18,%esp
}
  802e5c:	c9                   	leave  
  802e5d:	c3                   	ret    

00802e5e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802e5e:	55                   	push   %ebp
  802e5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 00                	push   $0x0
  802e67:	ff 75 0c             	pushl  0xc(%ebp)
  802e6a:	ff 75 08             	pushl  0x8(%ebp)
  802e6d:	6a 0b                	push   $0xb
  802e6f:	e8 e6 fe ff ff       	call   802d5a <syscall>
  802e74:	83 c4 18             	add    $0x18,%esp
}
  802e77:	c9                   	leave  
  802e78:	c3                   	ret    

00802e79 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802e79:	55                   	push   %ebp
  802e7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802e7c:	6a 00                	push   $0x0
  802e7e:	6a 00                	push   $0x0
  802e80:	6a 00                	push   $0x0
  802e82:	6a 00                	push   $0x0
  802e84:	6a 00                	push   $0x0
  802e86:	6a 0c                	push   $0xc
  802e88:	e8 cd fe ff ff       	call   802d5a <syscall>
  802e8d:	83 c4 18             	add    $0x18,%esp
}
  802e90:	c9                   	leave  
  802e91:	c3                   	ret    

00802e92 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e92:	55                   	push   %ebp
  802e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e95:	6a 00                	push   $0x0
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	6a 00                	push   $0x0
  802e9f:	6a 0d                	push   $0xd
  802ea1:	e8 b4 fe ff ff       	call   802d5a <syscall>
  802ea6:	83 c4 18             	add    $0x18,%esp
}
  802ea9:	c9                   	leave  
  802eaa:	c3                   	ret    

00802eab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802eab:	55                   	push   %ebp
  802eac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802eae:	6a 00                	push   $0x0
  802eb0:	6a 00                	push   $0x0
  802eb2:	6a 00                	push   $0x0
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 0e                	push   $0xe
  802eba:	e8 9b fe ff ff       	call   802d5a <syscall>
  802ebf:	83 c4 18             	add    $0x18,%esp
}
  802ec2:	c9                   	leave  
  802ec3:	c3                   	ret    

00802ec4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802ec4:	55                   	push   %ebp
  802ec5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802ec7:	6a 00                	push   $0x0
  802ec9:	6a 00                	push   $0x0
  802ecb:	6a 00                	push   $0x0
  802ecd:	6a 00                	push   $0x0
  802ecf:	6a 00                	push   $0x0
  802ed1:	6a 0f                	push   $0xf
  802ed3:	e8 82 fe ff ff       	call   802d5a <syscall>
  802ed8:	83 c4 18             	add    $0x18,%esp
}
  802edb:	c9                   	leave  
  802edc:	c3                   	ret    

00802edd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802edd:	55                   	push   %ebp
  802ede:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802ee0:	6a 00                	push   $0x0
  802ee2:	6a 00                	push   $0x0
  802ee4:	6a 00                	push   $0x0
  802ee6:	6a 00                	push   $0x0
  802ee8:	ff 75 08             	pushl  0x8(%ebp)
  802eeb:	6a 10                	push   $0x10
  802eed:	e8 68 fe ff ff       	call   802d5a <syscall>
  802ef2:	83 c4 18             	add    $0x18,%esp
}
  802ef5:	c9                   	leave  
  802ef6:	c3                   	ret    

00802ef7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802ef7:	55                   	push   %ebp
  802ef8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802efa:	6a 00                	push   $0x0
  802efc:	6a 00                	push   $0x0
  802efe:	6a 00                	push   $0x0
  802f00:	6a 00                	push   $0x0
  802f02:	6a 00                	push   $0x0
  802f04:	6a 11                	push   $0x11
  802f06:	e8 4f fe ff ff       	call   802d5a <syscall>
  802f0b:	83 c4 18             	add    $0x18,%esp
}
  802f0e:	90                   	nop
  802f0f:	c9                   	leave  
  802f10:	c3                   	ret    

00802f11 <sys_cputc>:

void
sys_cputc(const char c)
{
  802f11:	55                   	push   %ebp
  802f12:	89 e5                	mov    %esp,%ebp
  802f14:	83 ec 04             	sub    $0x4,%esp
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802f1d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f21:	6a 00                	push   $0x0
  802f23:	6a 00                	push   $0x0
  802f25:	6a 00                	push   $0x0
  802f27:	6a 00                	push   $0x0
  802f29:	50                   	push   %eax
  802f2a:	6a 01                	push   $0x1
  802f2c:	e8 29 fe ff ff       	call   802d5a <syscall>
  802f31:	83 c4 18             	add    $0x18,%esp
}
  802f34:	90                   	nop
  802f35:	c9                   	leave  
  802f36:	c3                   	ret    

00802f37 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802f37:	55                   	push   %ebp
  802f38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 00                	push   $0x0
  802f3e:	6a 00                	push   $0x0
  802f40:	6a 00                	push   $0x0
  802f42:	6a 00                	push   $0x0
  802f44:	6a 14                	push   $0x14
  802f46:	e8 0f fe ff ff       	call   802d5a <syscall>
  802f4b:	83 c4 18             	add    $0x18,%esp
}
  802f4e:	90                   	nop
  802f4f:	c9                   	leave  
  802f50:	c3                   	ret    

00802f51 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802f51:	55                   	push   %ebp
  802f52:	89 e5                	mov    %esp,%ebp
  802f54:	83 ec 04             	sub    $0x4,%esp
  802f57:	8b 45 10             	mov    0x10(%ebp),%eax
  802f5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802f5d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f60:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	6a 00                	push   $0x0
  802f69:	51                   	push   %ecx
  802f6a:	52                   	push   %edx
  802f6b:	ff 75 0c             	pushl  0xc(%ebp)
  802f6e:	50                   	push   %eax
  802f6f:	6a 15                	push   $0x15
  802f71:	e8 e4 fd ff ff       	call   802d5a <syscall>
  802f76:	83 c4 18             	add    $0x18,%esp
}
  802f79:	c9                   	leave  
  802f7a:	c3                   	ret    

00802f7b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802f7b:	55                   	push   %ebp
  802f7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	6a 00                	push   $0x0
  802f86:	6a 00                	push   $0x0
  802f88:	6a 00                	push   $0x0
  802f8a:	52                   	push   %edx
  802f8b:	50                   	push   %eax
  802f8c:	6a 16                	push   $0x16
  802f8e:	e8 c7 fd ff ff       	call   802d5a <syscall>
  802f93:	83 c4 18             	add    $0x18,%esp
}
  802f96:	c9                   	leave  
  802f97:	c3                   	ret    

00802f98 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802f98:	55                   	push   %ebp
  802f99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802f9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	6a 00                	push   $0x0
  802fa6:	6a 00                	push   $0x0
  802fa8:	51                   	push   %ecx
  802fa9:	52                   	push   %edx
  802faa:	50                   	push   %eax
  802fab:	6a 17                	push   $0x17
  802fad:	e8 a8 fd ff ff       	call   802d5a <syscall>
  802fb2:	83 c4 18             	add    $0x18,%esp
}
  802fb5:	c9                   	leave  
  802fb6:	c3                   	ret    

00802fb7 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802fb7:	55                   	push   %ebp
  802fb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	6a 00                	push   $0x0
  802fc2:	6a 00                	push   $0x0
  802fc4:	6a 00                	push   $0x0
  802fc6:	52                   	push   %edx
  802fc7:	50                   	push   %eax
  802fc8:	6a 18                	push   $0x18
  802fca:	e8 8b fd ff ff       	call   802d5a <syscall>
  802fcf:	83 c4 18             	add    $0x18,%esp
}
  802fd2:	c9                   	leave  
  802fd3:	c3                   	ret    

00802fd4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802fd4:	55                   	push   %ebp
  802fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	6a 00                	push   $0x0
  802fdc:	ff 75 14             	pushl  0x14(%ebp)
  802fdf:	ff 75 10             	pushl  0x10(%ebp)
  802fe2:	ff 75 0c             	pushl  0xc(%ebp)
  802fe5:	50                   	push   %eax
  802fe6:	6a 19                	push   $0x19
  802fe8:	e8 6d fd ff ff       	call   802d5a <syscall>
  802fed:	83 c4 18             	add    $0x18,%esp
}
  802ff0:	c9                   	leave  
  802ff1:	c3                   	ret    

00802ff2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802ff2:	55                   	push   %ebp
  802ff3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	6a 00                	push   $0x0
  802ffe:	6a 00                	push   $0x0
  803000:	50                   	push   %eax
  803001:	6a 1a                	push   $0x1a
  803003:	e8 52 fd ff ff       	call   802d5a <syscall>
  803008:	83 c4 18             	add    $0x18,%esp
}
  80300b:	90                   	nop
  80300c:	c9                   	leave  
  80300d:	c3                   	ret    

0080300e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80300e:	55                   	push   %ebp
  80300f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	6a 00                	push   $0x0
  803016:	6a 00                	push   $0x0
  803018:	6a 00                	push   $0x0
  80301a:	6a 00                	push   $0x0
  80301c:	50                   	push   %eax
  80301d:	6a 1b                	push   $0x1b
  80301f:	e8 36 fd ff ff       	call   802d5a <syscall>
  803024:	83 c4 18             	add    $0x18,%esp
}
  803027:	c9                   	leave  
  803028:	c3                   	ret    

00803029 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803029:	55                   	push   %ebp
  80302a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80302c:	6a 00                	push   $0x0
  80302e:	6a 00                	push   $0x0
  803030:	6a 00                	push   $0x0
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	6a 05                	push   $0x5
  803038:	e8 1d fd ff ff       	call   802d5a <syscall>
  80303d:	83 c4 18             	add    $0x18,%esp
}
  803040:	c9                   	leave  
  803041:	c3                   	ret    

00803042 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803042:	55                   	push   %ebp
  803043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803045:	6a 00                	push   $0x0
  803047:	6a 00                	push   $0x0
  803049:	6a 00                	push   $0x0
  80304b:	6a 00                	push   $0x0
  80304d:	6a 00                	push   $0x0
  80304f:	6a 06                	push   $0x6
  803051:	e8 04 fd ff ff       	call   802d5a <syscall>
  803056:	83 c4 18             	add    $0x18,%esp
}
  803059:	c9                   	leave  
  80305a:	c3                   	ret    

0080305b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80305b:	55                   	push   %ebp
  80305c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80305e:	6a 00                	push   $0x0
  803060:	6a 00                	push   $0x0
  803062:	6a 00                	push   $0x0
  803064:	6a 00                	push   $0x0
  803066:	6a 00                	push   $0x0
  803068:	6a 07                	push   $0x7
  80306a:	e8 eb fc ff ff       	call   802d5a <syscall>
  80306f:	83 c4 18             	add    $0x18,%esp
}
  803072:	c9                   	leave  
  803073:	c3                   	ret    

00803074 <sys_exit_env>:


void sys_exit_env(void)
{
  803074:	55                   	push   %ebp
  803075:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803077:	6a 00                	push   $0x0
  803079:	6a 00                	push   $0x0
  80307b:	6a 00                	push   $0x0
  80307d:	6a 00                	push   $0x0
  80307f:	6a 00                	push   $0x0
  803081:	6a 1c                	push   $0x1c
  803083:	e8 d2 fc ff ff       	call   802d5a <syscall>
  803088:	83 c4 18             	add    $0x18,%esp
}
  80308b:	90                   	nop
  80308c:	c9                   	leave  
  80308d:	c3                   	ret    

0080308e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80308e:	55                   	push   %ebp
  80308f:	89 e5                	mov    %esp,%ebp
  803091:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803094:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803097:	8d 50 04             	lea    0x4(%eax),%edx
  80309a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80309d:	6a 00                	push   $0x0
  80309f:	6a 00                	push   $0x0
  8030a1:	6a 00                	push   $0x0
  8030a3:	52                   	push   %edx
  8030a4:	50                   	push   %eax
  8030a5:	6a 1d                	push   $0x1d
  8030a7:	e8 ae fc ff ff       	call   802d5a <syscall>
  8030ac:	83 c4 18             	add    $0x18,%esp
	return result;
  8030af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8030b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8030b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030b8:	89 01                	mov    %eax,(%ecx)
  8030ba:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	c9                   	leave  
  8030c1:	c2 04 00             	ret    $0x4

008030c4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8030c7:	6a 00                	push   $0x0
  8030c9:	6a 00                	push   $0x0
  8030cb:	ff 75 10             	pushl  0x10(%ebp)
  8030ce:	ff 75 0c             	pushl  0xc(%ebp)
  8030d1:	ff 75 08             	pushl  0x8(%ebp)
  8030d4:	6a 13                	push   $0x13
  8030d6:	e8 7f fc ff ff       	call   802d5a <syscall>
  8030db:	83 c4 18             	add    $0x18,%esp
	return ;
  8030de:	90                   	nop
}
  8030df:	c9                   	leave  
  8030e0:	c3                   	ret    

008030e1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8030e1:	55                   	push   %ebp
  8030e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8030e4:	6a 00                	push   $0x0
  8030e6:	6a 00                	push   $0x0
  8030e8:	6a 00                	push   $0x0
  8030ea:	6a 00                	push   $0x0
  8030ec:	6a 00                	push   $0x0
  8030ee:	6a 1e                	push   $0x1e
  8030f0:	e8 65 fc ff ff       	call   802d5a <syscall>
  8030f5:	83 c4 18             	add    $0x18,%esp
}
  8030f8:	c9                   	leave  
  8030f9:	c3                   	ret    

008030fa <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8030fa:	55                   	push   %ebp
  8030fb:	89 e5                	mov    %esp,%ebp
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803106:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80310a:	6a 00                	push   $0x0
  80310c:	6a 00                	push   $0x0
  80310e:	6a 00                	push   $0x0
  803110:	6a 00                	push   $0x0
  803112:	50                   	push   %eax
  803113:	6a 1f                	push   $0x1f
  803115:	e8 40 fc ff ff       	call   802d5a <syscall>
  80311a:	83 c4 18             	add    $0x18,%esp
	return ;
  80311d:	90                   	nop
}
  80311e:	c9                   	leave  
  80311f:	c3                   	ret    

00803120 <rsttst>:
void rsttst()
{
  803120:	55                   	push   %ebp
  803121:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803123:	6a 00                	push   $0x0
  803125:	6a 00                	push   $0x0
  803127:	6a 00                	push   $0x0
  803129:	6a 00                	push   $0x0
  80312b:	6a 00                	push   $0x0
  80312d:	6a 21                	push   $0x21
  80312f:	e8 26 fc ff ff       	call   802d5a <syscall>
  803134:	83 c4 18             	add    $0x18,%esp
	return ;
  803137:	90                   	nop
}
  803138:	c9                   	leave  
  803139:	c3                   	ret    

0080313a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80313a:	55                   	push   %ebp
  80313b:	89 e5                	mov    %esp,%ebp
  80313d:	83 ec 04             	sub    $0x4,%esp
  803140:	8b 45 14             	mov    0x14(%ebp),%eax
  803143:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803146:	8b 55 18             	mov    0x18(%ebp),%edx
  803149:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80314d:	52                   	push   %edx
  80314e:	50                   	push   %eax
  80314f:	ff 75 10             	pushl  0x10(%ebp)
  803152:	ff 75 0c             	pushl  0xc(%ebp)
  803155:	ff 75 08             	pushl  0x8(%ebp)
  803158:	6a 20                	push   $0x20
  80315a:	e8 fb fb ff ff       	call   802d5a <syscall>
  80315f:	83 c4 18             	add    $0x18,%esp
	return ;
  803162:	90                   	nop
}
  803163:	c9                   	leave  
  803164:	c3                   	ret    

00803165 <chktst>:
void chktst(uint32 n)
{
  803165:	55                   	push   %ebp
  803166:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803168:	6a 00                	push   $0x0
  80316a:	6a 00                	push   $0x0
  80316c:	6a 00                	push   $0x0
  80316e:	6a 00                	push   $0x0
  803170:	ff 75 08             	pushl  0x8(%ebp)
  803173:	6a 22                	push   $0x22
  803175:	e8 e0 fb ff ff       	call   802d5a <syscall>
  80317a:	83 c4 18             	add    $0x18,%esp
	return ;
  80317d:	90                   	nop
}
  80317e:	c9                   	leave  
  80317f:	c3                   	ret    

00803180 <inctst>:

void inctst()
{
  803180:	55                   	push   %ebp
  803181:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803183:	6a 00                	push   $0x0
  803185:	6a 00                	push   $0x0
  803187:	6a 00                	push   $0x0
  803189:	6a 00                	push   $0x0
  80318b:	6a 00                	push   $0x0
  80318d:	6a 23                	push   $0x23
  80318f:	e8 c6 fb ff ff       	call   802d5a <syscall>
  803194:	83 c4 18             	add    $0x18,%esp
	return ;
  803197:	90                   	nop
}
  803198:	c9                   	leave  
  803199:	c3                   	ret    

0080319a <gettst>:
uint32 gettst()
{
  80319a:	55                   	push   %ebp
  80319b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80319d:	6a 00                	push   $0x0
  80319f:	6a 00                	push   $0x0
  8031a1:	6a 00                	push   $0x0
  8031a3:	6a 00                	push   $0x0
  8031a5:	6a 00                	push   $0x0
  8031a7:	6a 24                	push   $0x24
  8031a9:	e8 ac fb ff ff       	call   802d5a <syscall>
  8031ae:	83 c4 18             	add    $0x18,%esp
}
  8031b1:	c9                   	leave  
  8031b2:	c3                   	ret    

008031b3 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8031b3:	55                   	push   %ebp
  8031b4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031b6:	6a 00                	push   $0x0
  8031b8:	6a 00                	push   $0x0
  8031ba:	6a 00                	push   $0x0
  8031bc:	6a 00                	push   $0x0
  8031be:	6a 00                	push   $0x0
  8031c0:	6a 25                	push   $0x25
  8031c2:	e8 93 fb ff ff       	call   802d5a <syscall>
  8031c7:	83 c4 18             	add    $0x18,%esp
  8031ca:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  8031cf:	a1 80 50 83 00       	mov    0x835080,%eax
}
  8031d4:	c9                   	leave  
  8031d5:	c3                   	ret    

008031d6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8031d6:	55                   	push   %ebp
  8031d7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8031e1:	6a 00                	push   $0x0
  8031e3:	6a 00                	push   $0x0
  8031e5:	6a 00                	push   $0x0
  8031e7:	6a 00                	push   $0x0
  8031e9:	ff 75 08             	pushl  0x8(%ebp)
  8031ec:	6a 26                	push   $0x26
  8031ee:	e8 67 fb ff ff       	call   802d5a <syscall>
  8031f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8031f6:	90                   	nop
}
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    

008031f9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8031f9:	55                   	push   %ebp
  8031fa:	89 e5                	mov    %esp,%ebp
  8031fc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8031fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803200:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803203:	8b 55 0c             	mov    0xc(%ebp),%edx
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	6a 00                	push   $0x0
  80320b:	53                   	push   %ebx
  80320c:	51                   	push   %ecx
  80320d:	52                   	push   %edx
  80320e:	50                   	push   %eax
  80320f:	6a 27                	push   $0x27
  803211:	e8 44 fb ff ff       	call   802d5a <syscall>
  803216:	83 c4 18             	add    $0x18,%esp
}
  803219:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80321c:	c9                   	leave  
  80321d:	c3                   	ret    

0080321e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80321e:	55                   	push   %ebp
  80321f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803221:	8b 55 0c             	mov    0xc(%ebp),%edx
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	6a 00                	push   $0x0
  803229:	6a 00                	push   $0x0
  80322b:	6a 00                	push   $0x0
  80322d:	52                   	push   %edx
  80322e:	50                   	push   %eax
  80322f:	6a 28                	push   $0x28
  803231:	e8 24 fb ff ff       	call   802d5a <syscall>
  803236:	83 c4 18             	add    $0x18,%esp
}
  803239:	c9                   	leave  
  80323a:	c3                   	ret    

0080323b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80323b:	55                   	push   %ebp
  80323c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80323e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803241:	8b 55 0c             	mov    0xc(%ebp),%edx
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	6a 00                	push   $0x0
  803249:	51                   	push   %ecx
  80324a:	ff 75 10             	pushl  0x10(%ebp)
  80324d:	52                   	push   %edx
  80324e:	50                   	push   %eax
  80324f:	6a 29                	push   $0x29
  803251:	e8 04 fb ff ff       	call   802d5a <syscall>
  803256:	83 c4 18             	add    $0x18,%esp
}
  803259:	c9                   	leave  
  80325a:	c3                   	ret    

0080325b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80325b:	55                   	push   %ebp
  80325c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80325e:	6a 00                	push   $0x0
  803260:	6a 00                	push   $0x0
  803262:	ff 75 10             	pushl  0x10(%ebp)
  803265:	ff 75 0c             	pushl  0xc(%ebp)
  803268:	ff 75 08             	pushl  0x8(%ebp)
  80326b:	6a 12                	push   $0x12
  80326d:	e8 e8 fa ff ff       	call   802d5a <syscall>
  803272:	83 c4 18             	add    $0x18,%esp
	return ;
  803275:	90                   	nop
}
  803276:	c9                   	leave  
  803277:	c3                   	ret    

00803278 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803278:	55                   	push   %ebp
  803279:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80327b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	6a 00                	push   $0x0
  803283:	6a 00                	push   $0x0
  803285:	6a 00                	push   $0x0
  803287:	52                   	push   %edx
  803288:	50                   	push   %eax
  803289:	6a 2a                	push   $0x2a
  80328b:	e8 ca fa ff ff       	call   802d5a <syscall>
  803290:	83 c4 18             	add    $0x18,%esp
	return;
  803293:	90                   	nop
}
  803294:	c9                   	leave  
  803295:	c3                   	ret    

00803296 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803296:	55                   	push   %ebp
  803297:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803299:	6a 00                	push   $0x0
  80329b:	6a 00                	push   $0x0
  80329d:	6a 00                	push   $0x0
  80329f:	6a 00                	push   $0x0
  8032a1:	6a 00                	push   $0x0
  8032a3:	6a 2b                	push   $0x2b
  8032a5:	e8 b0 fa ff ff       	call   802d5a <syscall>
  8032aa:	83 c4 18             	add    $0x18,%esp
}
  8032ad:	c9                   	leave  
  8032ae:	c3                   	ret    

008032af <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8032af:	55                   	push   %ebp
  8032b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8032b2:	6a 00                	push   $0x0
  8032b4:	6a 00                	push   $0x0
  8032b6:	6a 00                	push   $0x0
  8032b8:	ff 75 0c             	pushl  0xc(%ebp)
  8032bb:	ff 75 08             	pushl  0x8(%ebp)
  8032be:	6a 2d                	push   $0x2d
  8032c0:	e8 95 fa ff ff       	call   802d5a <syscall>
  8032c5:	83 c4 18             	add    $0x18,%esp
	return;
  8032c8:	90                   	nop
}
  8032c9:	c9                   	leave  
  8032ca:	c3                   	ret    

008032cb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8032cb:	55                   	push   %ebp
  8032cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8032ce:	6a 00                	push   $0x0
  8032d0:	6a 00                	push   $0x0
  8032d2:	6a 00                	push   $0x0
  8032d4:	ff 75 0c             	pushl  0xc(%ebp)
  8032d7:	ff 75 08             	pushl  0x8(%ebp)
  8032da:	6a 2c                	push   $0x2c
  8032dc:	e8 79 fa ff ff       	call   802d5a <syscall>
  8032e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8032e4:	90                   	nop
}
  8032e5:	c9                   	leave  
  8032e6:	c3                   	ret    

008032e7 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8032e7:	55                   	push   %ebp
  8032e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8032ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f0:	6a 00                	push   $0x0
  8032f2:	6a 00                	push   $0x0
  8032f4:	6a 00                	push   $0x0
  8032f6:	52                   	push   %edx
  8032f7:	50                   	push   %eax
  8032f8:	6a 2e                	push   $0x2e
  8032fa:	e8 5b fa ff ff       	call   802d5a <syscall>
  8032ff:	83 c4 18             	add    $0x18,%esp
}
  803302:	90                   	nop
  803303:	c9                   	leave  
  803304:	c3                   	ret    

00803305 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803305:	55                   	push   %ebp
  803306:	89 e5                	mov    %esp,%ebp
  803308:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80330b:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803312:	72 09                	jb     80331d <to_page_va+0x18>
  803314:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  80331b:	72 14                	jb     803331 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80331d:	83 ec 04             	sub    $0x4,%esp
  803320:	68 4c 48 80 00       	push   $0x80484c
  803325:	6a 15                	push   $0x15
  803327:	68 77 48 80 00       	push   $0x804877
  80332c:	e8 a4 0a 00 00       	call   803dd5 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  803339:	29 d0                	sub    %edx,%eax
  80333b:	c1 f8 02             	sar    $0x2,%eax
  80333e:	89 c2                	mov    %eax,%edx
  803340:	89 d0                	mov    %edx,%eax
  803342:	c1 e0 02             	shl    $0x2,%eax
  803345:	01 d0                	add    %edx,%eax
  803347:	c1 e0 02             	shl    $0x2,%eax
  80334a:	01 d0                	add    %edx,%eax
  80334c:	c1 e0 02             	shl    $0x2,%eax
  80334f:	01 d0                	add    %edx,%eax
  803351:	89 c1                	mov    %eax,%ecx
  803353:	c1 e1 08             	shl    $0x8,%ecx
  803356:	01 c8                	add    %ecx,%eax
  803358:	89 c1                	mov    %eax,%ecx
  80335a:	c1 e1 10             	shl    $0x10,%ecx
  80335d:	01 c8                	add    %ecx,%eax
  80335f:	01 c0                	add    %eax,%eax
  803361:	01 d0                	add    %edx,%eax
  803363:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	c1 e0 0c             	shl    $0xc,%eax
  80336c:	89 c2                	mov    %eax,%edx
  80336e:	a1 84 50 83 00       	mov    0x835084,%eax
  803373:	01 d0                	add    %edx,%eax
}
  803375:	c9                   	leave  
  803376:	c3                   	ret    

00803377 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803377:	55                   	push   %ebp
  803378:	89 e5                	mov    %esp,%ebp
  80337a:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80337d:	a1 84 50 83 00       	mov    0x835084,%eax
  803382:	8b 55 08             	mov    0x8(%ebp),%edx
  803385:	29 c2                	sub    %eax,%edx
  803387:	89 d0                	mov    %edx,%eax
  803389:	c1 e8 0c             	shr    $0xc,%eax
  80338c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80338f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803393:	78 09                	js     80339e <to_page_info+0x27>
  803395:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80339c:	7e 14                	jle    8033b2 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  80339e:	83 ec 04             	sub    $0x4,%esp
  8033a1:	68 90 48 80 00       	push   $0x804890
  8033a6:	6a 21                	push   $0x21
  8033a8:	68 77 48 80 00       	push   $0x804877
  8033ad:	e8 23 0a 00 00       	call   803dd5 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8033b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033b5:	89 d0                	mov    %edx,%eax
  8033b7:	01 c0                	add    %eax,%eax
  8033b9:	01 d0                	add    %edx,%eax
  8033bb:	c1 e0 02             	shl    $0x2,%eax
  8033be:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  8033c3:	c9                   	leave  
  8033c4:	c3                   	ret    

008033c5 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8033c5:	55                   	push   %ebp
  8033c6:	89 e5                	mov    %esp,%ebp
  8033c8:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	05 00 00 00 02       	add    $0x2000000,%eax
  8033d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033d6:	73 16                	jae    8033ee <initialize_dynamic_allocator+0x29>
  8033d8:	68 b4 48 80 00       	push   $0x8048b4
  8033dd:	68 da 48 80 00       	push   $0x8048da
  8033e2:	6a 2f                	push   $0x2f
  8033e4:	68 77 48 80 00       	push   $0x804877
  8033e9:	e8 e7 09 00 00       	call   803dd5 <_panic>
	dynAllocStart = daStart;
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  8033f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f9:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8033fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803405:	eb 36                	jmp    80343d <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340a:	c1 e0 04             	shl    $0x4,%eax
  80340d:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341b:	c1 e0 04             	shl    $0x4,%eax
  80341e:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342c:	c1 e0 04             	shl    $0x4,%eax
  80342f:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803434:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80343a:	ff 45 f4             	incl   -0xc(%ebp)
  80343d:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803441:	7e c4                	jle    803407 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803443:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  80344a:	00 00 00 
  80344d:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803454:	00 00 00 
  803457:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  80345e:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803461:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803468:	e9 1b 01 00 00       	jmp    803588 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  80346d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803470:	89 d0                	mov    %edx,%eax
  803472:	01 c0                	add    %eax,%eax
  803474:	01 d0                	add    %edx,%eax
  803476:	c1 e0 02             	shl    $0x2,%eax
  803479:	05 88 d0 81 00       	add    $0x81d088,%eax
  80347e:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803483:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803486:	89 d0                	mov    %edx,%eax
  803488:	01 c0                	add    %eax,%eax
  80348a:	01 d0                	add    %edx,%eax
  80348c:	c1 e0 02             	shl    $0x2,%eax
  80348f:	05 8a d0 81 00       	add    $0x81d08a,%eax
  803494:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803499:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80349c:	89 d0                	mov    %edx,%eax
  80349e:	01 c0                	add    %eax,%eax
  8034a0:	01 d0                	add    %edx,%eax
  8034a2:	c1 e0 02             	shl    $0x2,%eax
  8034a5:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034aa:	8b 00                	mov    (%eax),%eax
  8034ac:	85 c0                	test   %eax,%eax
  8034ae:	74 2b                	je     8034db <initialize_dynamic_allocator+0x116>
  8034b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b3:	89 d0                	mov    %edx,%eax
  8034b5:	01 c0                	add    %eax,%eax
  8034b7:	01 d0                	add    %edx,%eax
  8034b9:	c1 e0 02             	shl    $0x2,%eax
  8034bc:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034c1:	8b 10                	mov    (%eax),%edx
  8034c3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8034c6:	89 c8                	mov    %ecx,%eax
  8034c8:	01 c0                	add    %eax,%eax
  8034ca:	01 c8                	add    %ecx,%eax
  8034cc:	c1 e0 02             	shl    $0x2,%eax
  8034cf:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034d4:	8b 00                	mov    (%eax),%eax
  8034d6:	89 42 04             	mov    %eax,0x4(%edx)
  8034d9:	eb 18                	jmp    8034f3 <initialize_dynamic_allocator+0x12e>
  8034db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034de:	89 d0                	mov    %edx,%eax
  8034e0:	01 c0                	add    %eax,%eax
  8034e2:	01 d0                	add    %edx,%eax
  8034e4:	c1 e0 02             	shl    $0x2,%eax
  8034e7:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8034f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f6:	89 d0                	mov    %edx,%eax
  8034f8:	01 c0                	add    %eax,%eax
  8034fa:	01 d0                	add    %edx,%eax
  8034fc:	c1 e0 02             	shl    $0x2,%eax
  8034ff:	05 84 d0 81 00       	add    $0x81d084,%eax
  803504:	8b 00                	mov    (%eax),%eax
  803506:	85 c0                	test   %eax,%eax
  803508:	74 2a                	je     803534 <initialize_dynamic_allocator+0x16f>
  80350a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80350d:	89 d0                	mov    %edx,%eax
  80350f:	01 c0                	add    %eax,%eax
  803511:	01 d0                	add    %edx,%eax
  803513:	c1 e0 02             	shl    $0x2,%eax
  803516:	05 84 d0 81 00       	add    $0x81d084,%eax
  80351b:	8b 10                	mov    (%eax),%edx
  80351d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803520:	89 c8                	mov    %ecx,%eax
  803522:	01 c0                	add    %eax,%eax
  803524:	01 c8                	add    %ecx,%eax
  803526:	c1 e0 02             	shl    $0x2,%eax
  803529:	05 80 d0 81 00       	add    $0x81d080,%eax
  80352e:	8b 00                	mov    (%eax),%eax
  803530:	89 02                	mov    %eax,(%edx)
  803532:	eb 18                	jmp    80354c <initialize_dynamic_allocator+0x187>
  803534:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803537:	89 d0                	mov    %edx,%eax
  803539:	01 c0                	add    %eax,%eax
  80353b:	01 d0                	add    %edx,%eax
  80353d:	c1 e0 02             	shl    $0x2,%eax
  803540:	05 80 d0 81 00       	add    $0x81d080,%eax
  803545:	8b 00                	mov    (%eax),%eax
  803547:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80354c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80354f:	89 d0                	mov    %edx,%eax
  803551:	01 c0                	add    %eax,%eax
  803553:	01 d0                	add    %edx,%eax
  803555:	c1 e0 02             	shl    $0x2,%eax
  803558:	05 80 d0 81 00       	add    $0x81d080,%eax
  80355d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803563:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803566:	89 d0                	mov    %edx,%eax
  803568:	01 c0                	add    %eax,%eax
  80356a:	01 d0                	add    %edx,%eax
  80356c:	c1 e0 02             	shl    $0x2,%eax
  80356f:	05 84 d0 81 00       	add    $0x81d084,%eax
  803574:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357a:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80357f:	48                   	dec    %eax
  803580:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803585:	ff 45 f0             	incl   -0x10(%ebp)
  803588:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  80358f:	0f 8e d8 fe ff ff    	jle    80346d <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803595:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  80359c:	e9 9d 00 00 00       	jmp    80363e <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8035a1:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8035a7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8035aa:	89 c8                	mov    %ecx,%eax
  8035ac:	01 c0                	add    %eax,%eax
  8035ae:	01 c8                	add    %ecx,%eax
  8035b0:	c1 e0 02             	shl    $0x2,%eax
  8035b3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035b8:	89 10                	mov    %edx,(%eax)
  8035ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035bd:	89 d0                	mov    %edx,%eax
  8035bf:	01 c0                	add    %eax,%eax
  8035c1:	01 d0                	add    %edx,%eax
  8035c3:	c1 e0 02             	shl    $0x2,%eax
  8035c6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	85 c0                	test   %eax,%eax
  8035cf:	74 1c                	je     8035ed <initialize_dynamic_allocator+0x228>
  8035d1:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8035d7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8035da:	89 c8                	mov    %ecx,%eax
  8035dc:	01 c0                	add    %eax,%eax
  8035de:	01 c8                	add    %ecx,%eax
  8035e0:	c1 e0 02             	shl    $0x2,%eax
  8035e3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035e8:	89 42 04             	mov    %eax,0x4(%edx)
  8035eb:	eb 16                	jmp    803603 <initialize_dynamic_allocator+0x23e>
  8035ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035f0:	89 d0                	mov    %edx,%eax
  8035f2:	01 c0                	add    %eax,%eax
  8035f4:	01 d0                	add    %edx,%eax
  8035f6:	c1 e0 02             	shl    $0x2,%eax
  8035f9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035fe:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803603:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803606:	89 d0                	mov    %edx,%eax
  803608:	01 c0                	add    %eax,%eax
  80360a:	01 d0                	add    %edx,%eax
  80360c:	c1 e0 02             	shl    $0x2,%eax
  80360f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803614:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803619:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80361c:	89 d0                	mov    %edx,%eax
  80361e:	01 c0                	add    %eax,%eax
  803620:	01 d0                	add    %edx,%eax
  803622:	c1 e0 02             	shl    $0x2,%eax
  803625:	05 84 d0 81 00       	add    $0x81d084,%eax
  80362a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803630:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803635:	40                   	inc    %eax
  803636:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80363b:	ff 4d ec             	decl   -0x14(%ebp)
  80363e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803642:	0f 89 59 ff ff ff    	jns    8035a1 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803648:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  80364f:	00 00 00 
}
  803652:	90                   	nop
  803653:	c9                   	leave  
  803654:	c3                   	ret    

00803655 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803655:	55                   	push   %ebp
  803656:	89 e5                	mov    %esp,%ebp
  803658:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	83 ec 0c             	sub    $0xc,%esp
  803661:	50                   	push   %eax
  803662:	e8 10 fd ff ff       	call   803377 <to_page_info>
  803667:	83 c4 10             	add    $0x10,%esp
  80366a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  80366d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803670:	8b 40 08             	mov    0x8(%eax),%eax
  803673:	0f b7 c0             	movzwl %ax,%eax
}
  803676:	c9                   	leave  
  803677:	c3                   	ret    

00803678 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803678:	55                   	push   %ebp
  803679:	89 e5                	mov    %esp,%ebp
  80367b:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80367e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803685:	76 16                	jbe    80369d <alloc_block+0x25>
  803687:	68 f0 48 80 00       	push   $0x8048f0
  80368c:	68 da 48 80 00       	push   $0x8048da
  803691:	6a 59                	push   $0x59
  803693:	68 77 48 80 00       	push   $0x804877
  803698:	e8 38 07 00 00       	call   803dd5 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  80369d:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8036a4:	eb 08                	jmp    8036ae <alloc_block+0x36>
		allocSize <<= 1;
  8036a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a9:	01 c0                	add    %eax,%eax
  8036ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036b4:	73 09                	jae    8036bf <alloc_block+0x47>
  8036b6:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8036bd:	76 e7                	jbe    8036a6 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8036bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8036c6:	eb 03                	jmp    8036cb <alloc_block+0x53>
		listIndex++;
  8036c8:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8036cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ce:	ba 08 00 00 00       	mov    $0x8,%edx
  8036d3:	88 c1                	mov    %al,%cl
  8036d5:	d3 e2                	shl    %cl,%edx
  8036d7:	89 d0                	mov    %edx,%eax
  8036d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8036dc:	72 ea                	jb     8036c8 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8036de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8036e4:	e9 f4 00 00 00       	jmp    8037dd <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8036e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ec:	c1 e0 04             	shl    $0x4,%eax
  8036ef:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8036f4:	8b 00                	mov    (%eax),%eax
  8036f6:	85 c0                	test   %eax,%eax
  8036f8:	0f 84 dc 00 00 00    	je     8037da <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8036fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803701:	c1 e0 04             	shl    $0x4,%eax
  803704:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803709:	8b 00                	mov    (%eax),%eax
  80370b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80370e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803712:	75 14                	jne    803728 <alloc_block+0xb0>
  803714:	83 ec 04             	sub    $0x4,%esp
  803717:	68 11 49 80 00       	push   $0x804911
  80371c:	6a 6b                	push   $0x6b
  80371e:	68 77 48 80 00       	push   $0x804877
  803723:	e8 ad 06 00 00       	call   803dd5 <_panic>
  803728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372b:	8b 00                	mov    (%eax),%eax
  80372d:	85 c0                	test   %eax,%eax
  80372f:	74 10                	je     803741 <alloc_block+0xc9>
  803731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803734:	8b 00                	mov    (%eax),%eax
  803736:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803739:	8b 52 04             	mov    0x4(%edx),%edx
  80373c:	89 50 04             	mov    %edx,0x4(%eax)
  80373f:	eb 14                	jmp    803755 <alloc_block+0xdd>
  803741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803744:	8b 40 04             	mov    0x4(%eax),%eax
  803747:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80374a:	c1 e2 04             	shl    $0x4,%edx
  80374d:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803753:	89 02                	mov    %eax,(%edx)
  803755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803758:	8b 40 04             	mov    0x4(%eax),%eax
  80375b:	85 c0                	test   %eax,%eax
  80375d:	74 0f                	je     80376e <alloc_block+0xf6>
  80375f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803762:	8b 40 04             	mov    0x4(%eax),%eax
  803765:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803768:	8b 12                	mov    (%edx),%edx
  80376a:	89 10                	mov    %edx,(%eax)
  80376c:	eb 13                	jmp    803781 <alloc_block+0x109>
  80376e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803771:	8b 00                	mov    (%eax),%eax
  803773:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803776:	c1 e2 04             	shl    $0x4,%edx
  803779:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  80377f:	89 02                	mov    %eax,(%edx)
  803781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803784:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803797:	c1 e0 04             	shl    $0x4,%eax
  80379a:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80379f:	8b 00                	mov    (%eax),%eax
  8037a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8037a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a7:	c1 e0 04             	shl    $0x4,%eax
  8037aa:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8037af:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8037b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b4:	83 ec 0c             	sub    $0xc,%esp
  8037b7:	50                   	push   %eax
  8037b8:	e8 ba fb ff ff       	call   803377 <to_page_info>
  8037bd:	83 c4 10             	add    $0x10,%esp
  8037c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  8037c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8037ca:	48                   	dec    %eax
  8037cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037ce:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  8037d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d5:	e9 8f 02 00 00       	jmp    803a69 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8037da:	ff 45 ec             	incl   -0x14(%ebp)
  8037dd:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8037e1:	0f 8e 02 ff ff ff    	jle    8036e9 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  8037e7:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8037ec:	85 c0                	test   %eax,%eax
  8037ee:	75 14                	jne    803804 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  8037f0:	83 ec 04             	sub    $0x4,%esp
  8037f3:	68 30 49 80 00       	push   $0x804930
  8037f8:	6a 77                	push   $0x77
  8037fa:	68 77 48 80 00       	push   $0x804877
  8037ff:	e8 d1 05 00 00       	call   803dd5 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803804:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803809:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  80380c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803810:	75 14                	jne    803826 <alloc_block+0x1ae>
  803812:	83 ec 04             	sub    $0x4,%esp
  803815:	68 11 49 80 00       	push   $0x804911
  80381a:	6a 7a                	push   $0x7a
  80381c:	68 77 48 80 00       	push   $0x804877
  803821:	e8 af 05 00 00       	call   803dd5 <_panic>
  803826:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803829:	8b 00                	mov    (%eax),%eax
  80382b:	85 c0                	test   %eax,%eax
  80382d:	74 10                	je     80383f <alloc_block+0x1c7>
  80382f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803832:	8b 00                	mov    (%eax),%eax
  803834:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803837:	8b 52 04             	mov    0x4(%edx),%edx
  80383a:	89 50 04             	mov    %edx,0x4(%eax)
  80383d:	eb 0b                	jmp    80384a <alloc_block+0x1d2>
  80383f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803842:	8b 40 04             	mov    0x4(%eax),%eax
  803845:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80384a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80384d:	8b 40 04             	mov    0x4(%eax),%eax
  803850:	85 c0                	test   %eax,%eax
  803852:	74 0f                	je     803863 <alloc_block+0x1eb>
  803854:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803857:	8b 40 04             	mov    0x4(%eax),%eax
  80385a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80385d:	8b 12                	mov    (%edx),%edx
  80385f:	89 10                	mov    %edx,(%eax)
  803861:	eb 0a                	jmp    80386d <alloc_block+0x1f5>
  803863:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803866:	8b 00                	mov    (%eax),%eax
  803868:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80386d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803870:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803876:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803879:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803880:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803885:	48                   	dec    %eax
  803886:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  80388b:	83 ec 0c             	sub    $0xc,%esp
  80388e:	ff 75 dc             	pushl  -0x24(%ebp)
  803891:	e8 6f fa ff ff       	call   803305 <to_page_va>
  803896:	83 c4 10             	add    $0x10,%esp
  803899:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  80389c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80389f:	83 ec 0c             	sub    $0xc,%esp
  8038a2:	50                   	push   %eax
  8038a3:	e8 a0 dc ff ff       	call   801548 <get_page>
  8038a8:	83 c4 10             	add    $0x10,%esp
  8038ab:	85 c0                	test   %eax,%eax
  8038ad:	74 14                	je     8038c3 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8038af:	83 ec 04             	sub    $0x4,%esp
  8038b2:	68 58 49 80 00       	push   $0x804958
  8038b7:	6a 7f                	push   $0x7f
  8038b9:	68 77 48 80 00       	push   $0x804877
  8038be:	e8 12 05 00 00       	call   803dd5 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  8038c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038c9:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  8038cd:	b8 00 10 00 00       	mov    $0x1000,%eax
  8038d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8038d7:	f7 75 f4             	divl   -0xc(%ebp)
  8038da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038dd:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8038e1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8038e8:	e9 a7 00 00 00       	jmp    803994 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  8038ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8038f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f3:	01 d0                	add    %edx,%eax
  8038f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  8038f8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038fc:	75 17                	jne    803915 <alloc_block+0x29d>
  8038fe:	83 ec 04             	sub    $0x4,%esp
  803901:	68 80 49 80 00       	push   $0x804980
  803906:	68 88 00 00 00       	push   $0x88
  80390b:	68 77 48 80 00       	push   $0x804877
  803910:	e8 c0 04 00 00       	call   803dd5 <_panic>
  803915:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803918:	c1 e0 04             	shl    $0x4,%eax
  80391b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803920:	8b 10                	mov    (%eax),%edx
  803922:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803925:	89 10                	mov    %edx,(%eax)
  803927:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80392a:	8b 00                	mov    (%eax),%eax
  80392c:	85 c0                	test   %eax,%eax
  80392e:	74 15                	je     803945 <alloc_block+0x2cd>
  803930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803933:	c1 e0 04             	shl    $0x4,%eax
  803936:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80393b:	8b 00                	mov    (%eax),%eax
  80393d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803940:	89 50 04             	mov    %edx,0x4(%eax)
  803943:	eb 11                	jmp    803956 <alloc_block+0x2de>
  803945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803948:	c1 e0 04             	shl    $0x4,%eax
  80394b:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803951:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803954:	89 02                	mov    %eax,(%edx)
  803956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803959:	c1 e0 04             	shl    $0x4,%eax
  80395c:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803962:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803965:	89 02                	mov    %eax,(%edx)
  803967:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80396a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803974:	c1 e0 04             	shl    $0x4,%eax
  803977:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80397c:	8b 00                	mov    (%eax),%eax
  80397e:	8d 50 01             	lea    0x1(%eax),%edx
  803981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803984:	c1 e0 04             	shl    $0x4,%eax
  803987:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80398c:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80398e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803991:	01 45 e8             	add    %eax,-0x18(%ebp)
  803994:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80399b:	0f 86 4c ff ff ff    	jbe    8038ed <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  8039a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a4:	c1 e0 04             	shl    $0x4,%eax
  8039a7:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8039ac:	8b 00                	mov    (%eax),%eax
  8039ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  8039b1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8039b5:	75 17                	jne    8039ce <alloc_block+0x356>
  8039b7:	83 ec 04             	sub    $0x4,%esp
  8039ba:	68 11 49 80 00       	push   $0x804911
  8039bf:	68 8d 00 00 00       	push   $0x8d
  8039c4:	68 77 48 80 00       	push   $0x804877
  8039c9:	e8 07 04 00 00       	call   803dd5 <_panic>
  8039ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039d1:	8b 00                	mov    (%eax),%eax
  8039d3:	85 c0                	test   %eax,%eax
  8039d5:	74 10                	je     8039e7 <alloc_block+0x36f>
  8039d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039da:	8b 00                	mov    (%eax),%eax
  8039dc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8039df:	8b 52 04             	mov    0x4(%edx),%edx
  8039e2:	89 50 04             	mov    %edx,0x4(%eax)
  8039e5:	eb 14                	jmp    8039fb <alloc_block+0x383>
  8039e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039ea:	8b 40 04             	mov    0x4(%eax),%eax
  8039ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039f0:	c1 e2 04             	shl    $0x4,%edx
  8039f3:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8039f9:	89 02                	mov    %eax,(%edx)
  8039fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039fe:	8b 40 04             	mov    0x4(%eax),%eax
  803a01:	85 c0                	test   %eax,%eax
  803a03:	74 0f                	je     803a14 <alloc_block+0x39c>
  803a05:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a08:	8b 40 04             	mov    0x4(%eax),%eax
  803a0b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803a0e:	8b 12                	mov    (%edx),%edx
  803a10:	89 10                	mov    %edx,(%eax)
  803a12:	eb 13                	jmp    803a27 <alloc_block+0x3af>
  803a14:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a17:	8b 00                	mov    (%eax),%eax
  803a19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a1c:	c1 e2 04             	shl    $0x4,%edx
  803a1f:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803a25:	89 02                	mov    %eax,(%edx)
  803a27:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a30:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3d:	c1 e0 04             	shl    $0x4,%eax
  803a40:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a45:	8b 00                	mov    (%eax),%eax
  803a47:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a4d:	c1 e0 04             	shl    $0x4,%eax
  803a50:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a55:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803a57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a5a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a5e:	48                   	dec    %eax
  803a5f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a62:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803a66:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803a69:	c9                   	leave  
  803a6a:	c3                   	ret    

00803a6b <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803a6b:	55                   	push   %ebp
  803a6c:	89 e5                	mov    %esp,%ebp
  803a6e:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803a71:	8b 55 08             	mov    0x8(%ebp),%edx
  803a74:	a1 84 50 83 00       	mov    0x835084,%eax
  803a79:	39 c2                	cmp    %eax,%edx
  803a7b:	72 0c                	jb     803a89 <free_block+0x1e>
  803a7d:	8b 55 08             	mov    0x8(%ebp),%edx
  803a80:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803a85:	39 c2                	cmp    %eax,%edx
  803a87:	72 19                	jb     803aa2 <free_block+0x37>
  803a89:	68 a4 49 80 00       	push   $0x8049a4
  803a8e:	68 da 48 80 00       	push   $0x8048da
  803a93:	68 98 00 00 00       	push   $0x98
  803a98:	68 77 48 80 00       	push   $0x804877
  803a9d:	e8 33 03 00 00       	call   803dd5 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa5:	83 ec 0c             	sub    $0xc,%esp
  803aa8:	50                   	push   %eax
  803aa9:	e8 c9 f8 ff ff       	call   803377 <to_page_info>
  803aae:	83 c4 10             	add    $0x10,%esp
  803ab1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ab7:	8b 40 08             	mov    0x8(%eax),%eax
  803aba:	0f b7 c0             	movzwl %ax,%eax
  803abd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803ac0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803ac7:	eb 03                	jmp    803acc <free_block+0x61>
		listIndex++;
  803ac9:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acf:	ba 08 00 00 00       	mov    $0x8,%edx
  803ad4:	88 c1                	mov    %al,%cl
  803ad6:	d3 e2                	shl    %cl,%edx
  803ad8:	89 d0                	mov    %edx,%eax
  803ada:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803add:	72 ea                	jb     803ac9 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803adf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803ae5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ae9:	75 17                	jne    803b02 <free_block+0x97>
  803aeb:	83 ec 04             	sub    $0x4,%esp
  803aee:	68 80 49 80 00       	push   $0x804980
  803af3:	68 a2 00 00 00       	push   $0xa2
  803af8:	68 77 48 80 00       	push   $0x804877
  803afd:	e8 d3 02 00 00       	call   803dd5 <_panic>
  803b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b05:	c1 e0 04             	shl    $0x4,%eax
  803b08:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b0d:	8b 10                	mov    (%eax),%edx
  803b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b12:	89 10                	mov    %edx,(%eax)
  803b14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b17:	8b 00                	mov    (%eax),%eax
  803b19:	85 c0                	test   %eax,%eax
  803b1b:	74 15                	je     803b32 <free_block+0xc7>
  803b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b20:	c1 e0 04             	shl    $0x4,%eax
  803b23:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b28:	8b 00                	mov    (%eax),%eax
  803b2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b2d:	89 50 04             	mov    %edx,0x4(%eax)
  803b30:	eb 11                	jmp    803b43 <free_block+0xd8>
  803b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b35:	c1 e0 04             	shl    $0x4,%eax
  803b38:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803b3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b41:	89 02                	mov    %eax,(%edx)
  803b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b46:	c1 e0 04             	shl    $0x4,%eax
  803b49:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803b4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b52:	89 02                	mov    %eax,(%edx)
  803b54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b61:	c1 e0 04             	shl    $0x4,%eax
  803b64:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b69:	8b 00                	mov    (%eax),%eax
  803b6b:	8d 50 01             	lea    0x1(%eax),%edx
  803b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b71:	c1 e0 04             	shl    $0x4,%eax
  803b74:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b79:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b7e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b82:	40                   	inc    %eax
  803b83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b86:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b8d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b91:	0f b7 c8             	movzwl %ax,%ecx
  803b94:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b99:	ba 00 00 00 00       	mov    $0x0,%edx
  803b9e:	f7 75 e8             	divl   -0x18(%ebp)
  803ba1:	39 c1                	cmp    %eax,%ecx
  803ba3:	0f 85 ed 01 00 00    	jne    803d96 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bac:	c1 e0 04             	shl    $0x4,%eax
  803baf:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bb4:	8b 00                	mov    (%eax),%eax
  803bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803bb9:	eb 2a                	jmp    803be5 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bbe:	83 ec 0c             	sub    $0xc,%esp
  803bc1:	50                   	push   %eax
  803bc2:	e8 b0 f7 ff ff       	call   803377 <to_page_info>
  803bc7:	83 c4 10             	add    $0x10,%esp
  803bca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803bcd:	75 06                	jne    803bd5 <free_block+0x16a>
				tmp = b;
  803bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd8:	c1 e0 04             	shl    $0x4,%eax
  803bdb:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803be0:	8b 00                	mov    (%eax),%eax
  803be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803be5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803be9:	74 07                	je     803bf2 <free_block+0x187>
  803beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bee:	8b 00                	mov    (%eax),%eax
  803bf0:	eb 05                	jmp    803bf7 <free_block+0x18c>
  803bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bfa:	c1 e2 04             	shl    $0x4,%edx
  803bfd:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803c03:	89 02                	mov    %eax,(%edx)
  803c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c08:	c1 e0 04             	shl    $0x4,%eax
  803c0b:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803c10:	8b 00                	mov    (%eax),%eax
  803c12:	85 c0                	test   %eax,%eax
  803c14:	75 a5                	jne    803bbb <free_block+0x150>
  803c16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c1a:	75 9f                	jne    803bbb <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c1f:	c1 e0 04             	shl    $0x4,%eax
  803c22:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c27:	8b 00                	mov    (%eax),%eax
  803c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803c2c:	e9 cc 00 00 00       	jmp    803cfd <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c34:	8b 00                	mov    (%eax),%eax
  803c36:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c3c:	83 ec 0c             	sub    $0xc,%esp
  803c3f:	50                   	push   %eax
  803c40:	e8 32 f7 ff ff       	call   803377 <to_page_info>
  803c45:	83 c4 10             	add    $0x10,%esp
  803c48:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803c4b:	0f 85 a6 00 00 00    	jne    803cf7 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803c51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c55:	75 17                	jne    803c6e <free_block+0x203>
  803c57:	83 ec 04             	sub    $0x4,%esp
  803c5a:	68 11 49 80 00       	push   $0x804911
  803c5f:	68 b5 00 00 00       	push   $0xb5
  803c64:	68 77 48 80 00       	push   $0x804877
  803c69:	e8 67 01 00 00       	call   803dd5 <_panic>
  803c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c71:	8b 00                	mov    (%eax),%eax
  803c73:	85 c0                	test   %eax,%eax
  803c75:	74 10                	je     803c87 <free_block+0x21c>
  803c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c7a:	8b 00                	mov    (%eax),%eax
  803c7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c7f:	8b 52 04             	mov    0x4(%edx),%edx
  803c82:	89 50 04             	mov    %edx,0x4(%eax)
  803c85:	eb 14                	jmp    803c9b <free_block+0x230>
  803c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c8a:	8b 40 04             	mov    0x4(%eax),%eax
  803c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c90:	c1 e2 04             	shl    $0x4,%edx
  803c93:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803c99:	89 02                	mov    %eax,(%edx)
  803c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ca1:	85 c0                	test   %eax,%eax
  803ca3:	74 0f                	je     803cb4 <free_block+0x249>
  803ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca8:	8b 40 04             	mov    0x4(%eax),%eax
  803cab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cae:	8b 12                	mov    (%edx),%edx
  803cb0:	89 10                	mov    %edx,(%eax)
  803cb2:	eb 13                	jmp    803cc7 <free_block+0x25c>
  803cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb7:	8b 00                	mov    (%eax),%eax
  803cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cbc:	c1 e2 04             	shl    $0x4,%edx
  803cbf:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803cc5:	89 02                	mov    %eax,(%edx)
  803cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdd:	c1 e0 04             	shl    $0x4,%eax
  803ce0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ce5:	8b 00                	mov    (%eax),%eax
  803ce7:	8d 50 ff             	lea    -0x1(%eax),%edx
  803cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ced:	c1 e0 04             	shl    $0x4,%eax
  803cf0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cf5:	89 10                	mov    %edx,(%eax)
			b = next;
  803cf7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803cfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d01:	0f 85 2a ff ff ff    	jne    803c31 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803d07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d0a:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d13:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803d19:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803d1d:	75 17                	jne    803d36 <free_block+0x2cb>
  803d1f:	83 ec 04             	sub    $0x4,%esp
  803d22:	68 80 49 80 00       	push   $0x804980
  803d27:	68 bc 00 00 00       	push   $0xbc
  803d2c:	68 77 48 80 00       	push   $0x804877
  803d31:	e8 9f 00 00 00       	call   803dd5 <_panic>
  803d36:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d3f:	89 10                	mov    %edx,(%eax)
  803d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d44:	8b 00                	mov    (%eax),%eax
  803d46:	85 c0                	test   %eax,%eax
  803d48:	74 0d                	je     803d57 <free_block+0x2ec>
  803d4a:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803d4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d52:	89 50 04             	mov    %edx,0x4(%eax)
  803d55:	eb 08                	jmp    803d5f <free_block+0x2f4>
  803d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d5a:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d62:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d71:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803d76:	40                   	inc    %eax
  803d77:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803d7c:	83 ec 0c             	sub    $0xc,%esp
  803d7f:	ff 75 ec             	pushl  -0x14(%ebp)
  803d82:	e8 7e f5 ff ff       	call   803305 <to_page_va>
  803d87:	83 c4 10             	add    $0x10,%esp
  803d8a:	83 ec 0c             	sub    $0xc,%esp
  803d8d:	50                   	push   %eax
  803d8e:	e8 fe d7 ff ff       	call   801591 <return_page>
  803d93:	83 c4 10             	add    $0x10,%esp
	}
}
  803d96:	90                   	nop
  803d97:	c9                   	leave  
  803d98:	c3                   	ret    

00803d99 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  803d99:	55                   	push   %ebp
  803d9a:	89 e5                	mov    %esp,%ebp
  803d9c:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  803d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803da2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  803da5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803da9:	83 ec 0c             	sub    $0xc,%esp
  803dac:	50                   	push   %eax
  803dad:	e8 5f f1 ff ff       	call   802f11 <sys_cputc>
  803db2:	83 c4 10             	add    $0x10,%esp
}
  803db5:	90                   	nop
  803db6:	c9                   	leave  
  803db7:	c3                   	ret    

00803db8 <getchar>:


int
getchar(void)
{
  803db8:	55                   	push   %ebp
  803db9:	89 e5                	mov    %esp,%ebp
  803dbb:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803dbe:	e8 ed ef ff ff       	call   802db0 <sys_cgetc>
  803dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  803dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803dc9:	c9                   	leave  
  803dca:	c3                   	ret    

00803dcb <iscons>:

int iscons(int fdnum)
{
  803dcb:	55                   	push   %ebp
  803dcc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803dce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803dd3:	5d                   	pop    %ebp
  803dd4:	c3                   	ret    

00803dd5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803dd5:	55                   	push   %ebp
  803dd6:	89 e5                	mov    %esp,%ebp
  803dd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803ddb:	8d 45 10             	lea    0x10(%ebp),%eax
  803dde:	83 c0 04             	add    $0x4,%eax
  803de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803de4:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803de9:	85 c0                	test   %eax,%eax
  803deb:	74 16                	je     803e03 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803ded:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803df2:	83 ec 08             	sub    $0x8,%esp
  803df5:	50                   	push   %eax
  803df6:	68 dc 49 80 00       	push   $0x8049dc
  803dfb:	e8 07 c6 ff ff       	call   800407 <cprintf>
  803e00:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803e03:	a1 04 50 80 00       	mov    0x805004,%eax
  803e08:	83 ec 0c             	sub    $0xc,%esp
  803e0b:	ff 75 0c             	pushl  0xc(%ebp)
  803e0e:	ff 75 08             	pushl  0x8(%ebp)
  803e11:	50                   	push   %eax
  803e12:	68 e4 49 80 00       	push   $0x8049e4
  803e17:	6a 74                	push   $0x74
  803e19:	e8 16 c6 ff ff       	call   800434 <cprintf_colored>
  803e1e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803e21:	8b 45 10             	mov    0x10(%ebp),%eax
  803e24:	83 ec 08             	sub    $0x8,%esp
  803e27:	ff 75 f4             	pushl  -0xc(%ebp)
  803e2a:	50                   	push   %eax
  803e2b:	e8 68 c5 ff ff       	call   800398 <vcprintf>
  803e30:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803e33:	83 ec 08             	sub    $0x8,%esp
  803e36:	6a 00                	push   $0x0
  803e38:	68 0c 4a 80 00       	push   $0x804a0c
  803e3d:	e8 56 c5 ff ff       	call   800398 <vcprintf>
  803e42:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803e45:	e8 cf c4 ff ff       	call   800319 <exit>

	// should not return here
	while (1) ;
  803e4a:	eb fe                	jmp    803e4a <_panic+0x75>

00803e4c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803e4c:	55                   	push   %ebp
  803e4d:	89 e5                	mov    %esp,%ebp
  803e4f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803e52:	a1 20 50 80 00       	mov    0x805020,%eax
  803e57:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e60:	39 c2                	cmp    %eax,%edx
  803e62:	74 14                	je     803e78 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803e64:	83 ec 04             	sub    $0x4,%esp
  803e67:	68 10 4a 80 00       	push   $0x804a10
  803e6c:	6a 26                	push   $0x26
  803e6e:	68 5c 4a 80 00       	push   $0x804a5c
  803e73:	e8 5d ff ff ff       	call   803dd5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803e78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803e7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803e86:	e9 c5 00 00 00       	jmp    803f50 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803e95:	8b 45 08             	mov    0x8(%ebp),%eax
  803e98:	01 d0                	add    %edx,%eax
  803e9a:	8b 00                	mov    (%eax),%eax
  803e9c:	85 c0                	test   %eax,%eax
  803e9e:	75 08                	jne    803ea8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803ea0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803ea3:	e9 a5 00 00 00       	jmp    803f4d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803ea8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803eaf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803eb6:	eb 69                	jmp    803f21 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803eb8:	a1 20 50 80 00       	mov    0x805020,%eax
  803ebd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803ec3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ec6:	89 d0                	mov    %edx,%eax
  803ec8:	01 c0                	add    %eax,%eax
  803eca:	01 d0                	add    %edx,%eax
  803ecc:	c1 e0 03             	shl    $0x3,%eax
  803ecf:	01 c8                	add    %ecx,%eax
  803ed1:	8a 40 04             	mov    0x4(%eax),%al
  803ed4:	84 c0                	test   %al,%al
  803ed6:	75 46                	jne    803f1e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803ed8:	a1 20 50 80 00       	mov    0x805020,%eax
  803edd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803ee3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ee6:	89 d0                	mov    %edx,%eax
  803ee8:	01 c0                	add    %eax,%eax
  803eea:	01 d0                	add    %edx,%eax
  803eec:	c1 e0 03             	shl    $0x3,%eax
  803eef:	01 c8                	add    %ecx,%eax
  803ef1:	8b 00                	mov    (%eax),%eax
  803ef3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803ef6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ef9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803efe:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f03:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0d:	01 c8                	add    %ecx,%eax
  803f0f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803f11:	39 c2                	cmp    %eax,%edx
  803f13:	75 09                	jne    803f1e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803f15:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803f1c:	eb 15                	jmp    803f33 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803f1e:	ff 45 e8             	incl   -0x18(%ebp)
  803f21:	a1 20 50 80 00       	mov    0x805020,%eax
  803f26:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f2f:	39 c2                	cmp    %eax,%edx
  803f31:	77 85                	ja     803eb8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803f33:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803f37:	75 14                	jne    803f4d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803f39:	83 ec 04             	sub    $0x4,%esp
  803f3c:	68 68 4a 80 00       	push   $0x804a68
  803f41:	6a 3a                	push   $0x3a
  803f43:	68 5c 4a 80 00       	push   $0x804a5c
  803f48:	e8 88 fe ff ff       	call   803dd5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803f4d:	ff 45 f0             	incl   -0x10(%ebp)
  803f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f53:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803f56:	0f 8c 2f ff ff ff    	jl     803e8b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803f5c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803f63:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803f6a:	eb 26                	jmp    803f92 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803f6c:	a1 20 50 80 00       	mov    0x805020,%eax
  803f71:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803f77:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803f7a:	89 d0                	mov    %edx,%eax
  803f7c:	01 c0                	add    %eax,%eax
  803f7e:	01 d0                	add    %edx,%eax
  803f80:	c1 e0 03             	shl    $0x3,%eax
  803f83:	01 c8                	add    %ecx,%eax
  803f85:	8a 40 04             	mov    0x4(%eax),%al
  803f88:	3c 01                	cmp    $0x1,%al
  803f8a:	75 03                	jne    803f8f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803f8c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803f8f:	ff 45 e0             	incl   -0x20(%ebp)
  803f92:	a1 20 50 80 00       	mov    0x805020,%eax
  803f97:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fa0:	39 c2                	cmp    %eax,%edx
  803fa2:	77 c8                	ja     803f6c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803faa:	74 14                	je     803fc0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803fac:	83 ec 04             	sub    $0x4,%esp
  803faf:	68 bc 4a 80 00       	push   $0x804abc
  803fb4:	6a 44                	push   $0x44
  803fb6:	68 5c 4a 80 00       	push   $0x804a5c
  803fbb:	e8 15 fe ff ff       	call   803dd5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803fc0:	90                   	nop
  803fc1:	c9                   	leave  
  803fc2:	c3                   	ret    
  803fc3:	90                   	nop

00803fc4 <__udivdi3>:
  803fc4:	55                   	push   %ebp
  803fc5:	57                   	push   %edi
  803fc6:	56                   	push   %esi
  803fc7:	53                   	push   %ebx
  803fc8:	83 ec 1c             	sub    $0x1c,%esp
  803fcb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803fcf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803fd3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fd7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fdb:	89 ca                	mov    %ecx,%edx
  803fdd:	89 f8                	mov    %edi,%eax
  803fdf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803fe3:	85 f6                	test   %esi,%esi
  803fe5:	75 2d                	jne    804014 <__udivdi3+0x50>
  803fe7:	39 cf                	cmp    %ecx,%edi
  803fe9:	77 65                	ja     804050 <__udivdi3+0x8c>
  803feb:	89 fd                	mov    %edi,%ebp
  803fed:	85 ff                	test   %edi,%edi
  803fef:	75 0b                	jne    803ffc <__udivdi3+0x38>
  803ff1:	b8 01 00 00 00       	mov    $0x1,%eax
  803ff6:	31 d2                	xor    %edx,%edx
  803ff8:	f7 f7                	div    %edi
  803ffa:	89 c5                	mov    %eax,%ebp
  803ffc:	31 d2                	xor    %edx,%edx
  803ffe:	89 c8                	mov    %ecx,%eax
  804000:	f7 f5                	div    %ebp
  804002:	89 c1                	mov    %eax,%ecx
  804004:	89 d8                	mov    %ebx,%eax
  804006:	f7 f5                	div    %ebp
  804008:	89 cf                	mov    %ecx,%edi
  80400a:	89 fa                	mov    %edi,%edx
  80400c:	83 c4 1c             	add    $0x1c,%esp
  80400f:	5b                   	pop    %ebx
  804010:	5e                   	pop    %esi
  804011:	5f                   	pop    %edi
  804012:	5d                   	pop    %ebp
  804013:	c3                   	ret    
  804014:	39 ce                	cmp    %ecx,%esi
  804016:	77 28                	ja     804040 <__udivdi3+0x7c>
  804018:	0f bd fe             	bsr    %esi,%edi
  80401b:	83 f7 1f             	xor    $0x1f,%edi
  80401e:	75 40                	jne    804060 <__udivdi3+0x9c>
  804020:	39 ce                	cmp    %ecx,%esi
  804022:	72 0a                	jb     80402e <__udivdi3+0x6a>
  804024:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804028:	0f 87 9e 00 00 00    	ja     8040cc <__udivdi3+0x108>
  80402e:	b8 01 00 00 00       	mov    $0x1,%eax
  804033:	89 fa                	mov    %edi,%edx
  804035:	83 c4 1c             	add    $0x1c,%esp
  804038:	5b                   	pop    %ebx
  804039:	5e                   	pop    %esi
  80403a:	5f                   	pop    %edi
  80403b:	5d                   	pop    %ebp
  80403c:	c3                   	ret    
  80403d:	8d 76 00             	lea    0x0(%esi),%esi
  804040:	31 ff                	xor    %edi,%edi
  804042:	31 c0                	xor    %eax,%eax
  804044:	89 fa                	mov    %edi,%edx
  804046:	83 c4 1c             	add    $0x1c,%esp
  804049:	5b                   	pop    %ebx
  80404a:	5e                   	pop    %esi
  80404b:	5f                   	pop    %edi
  80404c:	5d                   	pop    %ebp
  80404d:	c3                   	ret    
  80404e:	66 90                	xchg   %ax,%ax
  804050:	89 d8                	mov    %ebx,%eax
  804052:	f7 f7                	div    %edi
  804054:	31 ff                	xor    %edi,%edi
  804056:	89 fa                	mov    %edi,%edx
  804058:	83 c4 1c             	add    $0x1c,%esp
  80405b:	5b                   	pop    %ebx
  80405c:	5e                   	pop    %esi
  80405d:	5f                   	pop    %edi
  80405e:	5d                   	pop    %ebp
  80405f:	c3                   	ret    
  804060:	bd 20 00 00 00       	mov    $0x20,%ebp
  804065:	89 eb                	mov    %ebp,%ebx
  804067:	29 fb                	sub    %edi,%ebx
  804069:	89 f9                	mov    %edi,%ecx
  80406b:	d3 e6                	shl    %cl,%esi
  80406d:	89 c5                	mov    %eax,%ebp
  80406f:	88 d9                	mov    %bl,%cl
  804071:	d3 ed                	shr    %cl,%ebp
  804073:	89 e9                	mov    %ebp,%ecx
  804075:	09 f1                	or     %esi,%ecx
  804077:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80407b:	89 f9                	mov    %edi,%ecx
  80407d:	d3 e0                	shl    %cl,%eax
  80407f:	89 c5                	mov    %eax,%ebp
  804081:	89 d6                	mov    %edx,%esi
  804083:	88 d9                	mov    %bl,%cl
  804085:	d3 ee                	shr    %cl,%esi
  804087:	89 f9                	mov    %edi,%ecx
  804089:	d3 e2                	shl    %cl,%edx
  80408b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80408f:	88 d9                	mov    %bl,%cl
  804091:	d3 e8                	shr    %cl,%eax
  804093:	09 c2                	or     %eax,%edx
  804095:	89 d0                	mov    %edx,%eax
  804097:	89 f2                	mov    %esi,%edx
  804099:	f7 74 24 0c          	divl   0xc(%esp)
  80409d:	89 d6                	mov    %edx,%esi
  80409f:	89 c3                	mov    %eax,%ebx
  8040a1:	f7 e5                	mul    %ebp
  8040a3:	39 d6                	cmp    %edx,%esi
  8040a5:	72 19                	jb     8040c0 <__udivdi3+0xfc>
  8040a7:	74 0b                	je     8040b4 <__udivdi3+0xf0>
  8040a9:	89 d8                	mov    %ebx,%eax
  8040ab:	31 ff                	xor    %edi,%edi
  8040ad:	e9 58 ff ff ff       	jmp    80400a <__udivdi3+0x46>
  8040b2:	66 90                	xchg   %ax,%ax
  8040b4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040b8:	89 f9                	mov    %edi,%ecx
  8040ba:	d3 e2                	shl    %cl,%edx
  8040bc:	39 c2                	cmp    %eax,%edx
  8040be:	73 e9                	jae    8040a9 <__udivdi3+0xe5>
  8040c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040c3:	31 ff                	xor    %edi,%edi
  8040c5:	e9 40 ff ff ff       	jmp    80400a <__udivdi3+0x46>
  8040ca:	66 90                	xchg   %ax,%ax
  8040cc:	31 c0                	xor    %eax,%eax
  8040ce:	e9 37 ff ff ff       	jmp    80400a <__udivdi3+0x46>
  8040d3:	90                   	nop

008040d4 <__umoddi3>:
  8040d4:	55                   	push   %ebp
  8040d5:	57                   	push   %edi
  8040d6:	56                   	push   %esi
  8040d7:	53                   	push   %ebx
  8040d8:	83 ec 1c             	sub    $0x1c,%esp
  8040db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040f3:	89 f3                	mov    %esi,%ebx
  8040f5:	89 fa                	mov    %edi,%edx
  8040f7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040fb:	89 34 24             	mov    %esi,(%esp)
  8040fe:	85 c0                	test   %eax,%eax
  804100:	75 1a                	jne    80411c <__umoddi3+0x48>
  804102:	39 f7                	cmp    %esi,%edi
  804104:	0f 86 a2 00 00 00    	jbe    8041ac <__umoddi3+0xd8>
  80410a:	89 c8                	mov    %ecx,%eax
  80410c:	89 f2                	mov    %esi,%edx
  80410e:	f7 f7                	div    %edi
  804110:	89 d0                	mov    %edx,%eax
  804112:	31 d2                	xor    %edx,%edx
  804114:	83 c4 1c             	add    $0x1c,%esp
  804117:	5b                   	pop    %ebx
  804118:	5e                   	pop    %esi
  804119:	5f                   	pop    %edi
  80411a:	5d                   	pop    %ebp
  80411b:	c3                   	ret    
  80411c:	39 f0                	cmp    %esi,%eax
  80411e:	0f 87 ac 00 00 00    	ja     8041d0 <__umoddi3+0xfc>
  804124:	0f bd e8             	bsr    %eax,%ebp
  804127:	83 f5 1f             	xor    $0x1f,%ebp
  80412a:	0f 84 ac 00 00 00    	je     8041dc <__umoddi3+0x108>
  804130:	bf 20 00 00 00       	mov    $0x20,%edi
  804135:	29 ef                	sub    %ebp,%edi
  804137:	89 fe                	mov    %edi,%esi
  804139:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80413d:	89 e9                	mov    %ebp,%ecx
  80413f:	d3 e0                	shl    %cl,%eax
  804141:	89 d7                	mov    %edx,%edi
  804143:	89 f1                	mov    %esi,%ecx
  804145:	d3 ef                	shr    %cl,%edi
  804147:	09 c7                	or     %eax,%edi
  804149:	89 e9                	mov    %ebp,%ecx
  80414b:	d3 e2                	shl    %cl,%edx
  80414d:	89 14 24             	mov    %edx,(%esp)
  804150:	89 d8                	mov    %ebx,%eax
  804152:	d3 e0                	shl    %cl,%eax
  804154:	89 c2                	mov    %eax,%edx
  804156:	8b 44 24 08          	mov    0x8(%esp),%eax
  80415a:	d3 e0                	shl    %cl,%eax
  80415c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804160:	8b 44 24 08          	mov    0x8(%esp),%eax
  804164:	89 f1                	mov    %esi,%ecx
  804166:	d3 e8                	shr    %cl,%eax
  804168:	09 d0                	or     %edx,%eax
  80416a:	d3 eb                	shr    %cl,%ebx
  80416c:	89 da                	mov    %ebx,%edx
  80416e:	f7 f7                	div    %edi
  804170:	89 d3                	mov    %edx,%ebx
  804172:	f7 24 24             	mull   (%esp)
  804175:	89 c6                	mov    %eax,%esi
  804177:	89 d1                	mov    %edx,%ecx
  804179:	39 d3                	cmp    %edx,%ebx
  80417b:	0f 82 87 00 00 00    	jb     804208 <__umoddi3+0x134>
  804181:	0f 84 91 00 00 00    	je     804218 <__umoddi3+0x144>
  804187:	8b 54 24 04          	mov    0x4(%esp),%edx
  80418b:	29 f2                	sub    %esi,%edx
  80418d:	19 cb                	sbb    %ecx,%ebx
  80418f:	89 d8                	mov    %ebx,%eax
  804191:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804195:	d3 e0                	shl    %cl,%eax
  804197:	89 e9                	mov    %ebp,%ecx
  804199:	d3 ea                	shr    %cl,%edx
  80419b:	09 d0                	or     %edx,%eax
  80419d:	89 e9                	mov    %ebp,%ecx
  80419f:	d3 eb                	shr    %cl,%ebx
  8041a1:	89 da                	mov    %ebx,%edx
  8041a3:	83 c4 1c             	add    $0x1c,%esp
  8041a6:	5b                   	pop    %ebx
  8041a7:	5e                   	pop    %esi
  8041a8:	5f                   	pop    %edi
  8041a9:	5d                   	pop    %ebp
  8041aa:	c3                   	ret    
  8041ab:	90                   	nop
  8041ac:	89 fd                	mov    %edi,%ebp
  8041ae:	85 ff                	test   %edi,%edi
  8041b0:	75 0b                	jne    8041bd <__umoddi3+0xe9>
  8041b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8041b7:	31 d2                	xor    %edx,%edx
  8041b9:	f7 f7                	div    %edi
  8041bb:	89 c5                	mov    %eax,%ebp
  8041bd:	89 f0                	mov    %esi,%eax
  8041bf:	31 d2                	xor    %edx,%edx
  8041c1:	f7 f5                	div    %ebp
  8041c3:	89 c8                	mov    %ecx,%eax
  8041c5:	f7 f5                	div    %ebp
  8041c7:	89 d0                	mov    %edx,%eax
  8041c9:	e9 44 ff ff ff       	jmp    804112 <__umoddi3+0x3e>
  8041ce:	66 90                	xchg   %ax,%ax
  8041d0:	89 c8                	mov    %ecx,%eax
  8041d2:	89 f2                	mov    %esi,%edx
  8041d4:	83 c4 1c             	add    $0x1c,%esp
  8041d7:	5b                   	pop    %ebx
  8041d8:	5e                   	pop    %esi
  8041d9:	5f                   	pop    %edi
  8041da:	5d                   	pop    %ebp
  8041db:	c3                   	ret    
  8041dc:	3b 04 24             	cmp    (%esp),%eax
  8041df:	72 06                	jb     8041e7 <__umoddi3+0x113>
  8041e1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041e5:	77 0f                	ja     8041f6 <__umoddi3+0x122>
  8041e7:	89 f2                	mov    %esi,%edx
  8041e9:	29 f9                	sub    %edi,%ecx
  8041eb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041ef:	89 14 24             	mov    %edx,(%esp)
  8041f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041f6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041fa:	8b 14 24             	mov    (%esp),%edx
  8041fd:	83 c4 1c             	add    $0x1c,%esp
  804200:	5b                   	pop    %ebx
  804201:	5e                   	pop    %esi
  804202:	5f                   	pop    %edi
  804203:	5d                   	pop    %ebp
  804204:	c3                   	ret    
  804205:	8d 76 00             	lea    0x0(%esi),%esi
  804208:	2b 04 24             	sub    (%esp),%eax
  80420b:	19 fa                	sbb    %edi,%edx
  80420d:	89 d1                	mov    %edx,%ecx
  80420f:	89 c6                	mov    %eax,%esi
  804211:	e9 71 ff ff ff       	jmp    804187 <__umoddi3+0xb3>
  804216:	66 90                	xchg   %ax,%ax
  804218:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80421c:	72 ea                	jb     804208 <__umoddi3+0x134>
  80421e:	89 d9                	mov    %ebx,%ecx
  804220:	e9 62 ff ff ff       	jmp    804187 <__umoddi3+0xb3>
