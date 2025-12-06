
obj/user/fib_memomize:     file format elf32-i386


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
  800031:	e8 7f 01 00 00       	call   8001b5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n, int64 *memo);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	int index=0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 80 42 80 00       	push   $0x804280
  800057:	e8 c1 0b 00 00       	call   800c1d <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 c3 10 00 00       	call   801135 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 87 15 00 00       	call   80160f <malloc>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (int i = 0; i <= index; ++i)
  80008e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800095:	eb 1f                	jmp    8000b6 <_main+0x7e>
	{
		memo[i] = 0;
  800097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80009a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	01 d0                	add    %edx,%eax
  8000a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8000ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
	index = strtol(buff1, NULL, 10);

	int64 *memo = malloc((index+1) * sizeof(int64));
	for (int i = 0; i <= index; ++i)
  8000b3:	ff 45 f4             	incl   -0xc(%ebp)
  8000b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000bc:	7e d9                	jle    800097 <_main+0x5f>
	{
		memo[i] = 0;
	}
	int64 res = fibonacci(index, memo) ;
  8000be:	83 ec 08             	sub    $0x8,%esp
  8000c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c7:	e8 35 00 00 00       	call   800101 <fibonacci>
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)

	free(memo);
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000db:	e8 8f 18 00 00       	call   80196f <free>
  8000e0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ec:	68 9e 42 80 00       	push   $0x80429e
  8000f1:	e8 c1 03 00 00       	call   8004b7 <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 c0 30 00 00       	call   8031be <inctst>
	return;
  8000fe:	90                   	nop
}
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    

00800101 <fibonacci>:


int64 fibonacci(int n, int64 *memo)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	57                   	push   %edi
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	83 ec 0c             	sub    $0xc,%esp
	if (memo[n]!=0)	return memo[n];
  80010a:	8b 45 08             	mov    0x8(%ebp),%eax
  80010d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800114:	8b 45 0c             	mov    0xc(%ebp),%eax
  800117:	01 d0                	add    %edx,%eax
  800119:	8b 50 04             	mov    0x4(%eax),%edx
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	09 d0                	or     %edx,%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	74 16                	je     80013a <fibonacci+0x39>
  800124:	8b 45 08             	mov    0x8(%ebp),%eax
  800127:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80012e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800131:	01 d0                	add    %edx,%eax
  800133:	8b 50 04             	mov    0x4(%eax),%edx
  800136:	8b 00                	mov    (%eax),%eax
  800138:	eb 73                	jmp    8001ad <fibonacci+0xac>
	if (n <= 1)
  80013a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80013e:	7f 23                	jg     800163 <fibonacci+0x62>
		return memo[n] = 1 ;
  800140:	8b 45 08             	mov    0x8(%ebp),%eax
  800143:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80014a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014d:	01 d0                	add    %edx,%eax
  80014f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  800155:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80015c:	8b 50 04             	mov    0x4(%eax),%edx
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	eb 4a                	jmp    8001ad <fibonacci+0xac>
	return (memo[n] = fibonacci(n-1, memo) + fibonacci(n-2, memo)) ;
  800163:	8b 45 08             	mov    0x8(%ebp),%eax
  800166:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80016d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800170:	8d 3c 02             	lea    (%edx,%eax,1),%edi
  800173:	8b 45 08             	mov    0x8(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	ff 75 0c             	pushl  0xc(%ebp)
  80017d:	50                   	push   %eax
  80017e:	e8 7e ff ff ff       	call   800101 <fibonacci>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	89 c3                	mov    %eax,%ebx
  800188:	89 d6                	mov    %edx,%esi
  80018a:	8b 45 08             	mov    0x8(%ebp),%eax
  80018d:	83 e8 02             	sub    $0x2,%eax
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	ff 75 0c             	pushl  0xc(%ebp)
  800196:	50                   	push   %eax
  800197:	e8 65 ff ff ff       	call   800101 <fibonacci>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	01 d8                	add    %ebx,%eax
  8001a1:	11 f2                	adc    %esi,%edx
  8001a3:	89 07                	mov    %eax,(%edi)
  8001a5:	89 57 04             	mov    %edx,0x4(%edi)
  8001a8:	8b 07                	mov    (%edi),%eax
  8001aa:	8b 57 04             	mov    0x4(%edi),%edx
}
  8001ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b0:	5b                   	pop    %ebx
  8001b1:	5e                   	pop    %esi
  8001b2:	5f                   	pop    %edi
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    

008001b5 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	57                   	push   %edi
  8001b9:	56                   	push   %esi
  8001ba:	53                   	push   %ebx
  8001bb:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001be:	e8 bd 2e 00 00       	call   803080 <sys_getenvindex>
  8001c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001c9:	89 d0                	mov    %edx,%eax
  8001cb:	c1 e0 03             	shl    $0x3,%eax
  8001ce:	01 d0                	add    %edx,%eax
  8001d0:	c1 e0 02             	shl    $0x2,%eax
  8001d3:	01 d0                	add    %edx,%eax
  8001d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001dc:	01 d0                	add    %edx,%eax
  8001de:	c1 e0 03             	shl    $0x3,%eax
  8001e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f0:	8a 40 20             	mov    0x20(%eax),%al
  8001f3:	84 c0                	test   %al,%al
  8001f5:	74 0d                	je     800204 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8001fc:	83 c0 20             	add    $0x20,%eax
  8001ff:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800208:	7e 0a                	jle    800214 <libmain+0x5f>
		binaryname = argv[0];
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	8b 00                	mov    (%eax),%eax
  80020f:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800214:	83 ec 08             	sub    $0x8,%esp
  800217:	ff 75 0c             	pushl  0xc(%ebp)
  80021a:	ff 75 08             	pushl  0x8(%ebp)
  80021d:	e8 16 fe ff ff       	call   800038 <_main>
  800222:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800225:	a1 00 50 80 00       	mov    0x805000,%eax
  80022a:	85 c0                	test   %eax,%eax
  80022c:	0f 84 01 01 00 00    	je     800333 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800232:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800238:	bb ac 43 80 00       	mov    $0x8043ac,%ebx
  80023d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800242:	89 c7                	mov    %eax,%edi
  800244:	89 de                	mov    %ebx,%esi
  800246:	89 d1                	mov    %edx,%ecx
  800248:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80024a:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80024d:	b9 56 00 00 00       	mov    $0x56,%ecx
  800252:	b0 00                	mov    $0x0,%al
  800254:	89 d7                	mov    %edx,%edi
  800256:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800258:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80025f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	50                   	push   %eax
  800266:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80026c:	50                   	push   %eax
  80026d:	e8 44 30 00 00       	call   8032b6 <sys_utilities>
  800272:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800275:	e8 8d 2b 00 00       	call   802e07 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80027a:	83 ec 0c             	sub    $0xc,%esp
  80027d:	68 cc 42 80 00       	push   $0x8042cc
  800282:	e8 be 01 00 00       	call   800445 <cprintf>
  800287:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80028a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028d:	85 c0                	test   %eax,%eax
  80028f:	74 18                	je     8002a9 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800291:	e8 3e 30 00 00       	call   8032d4 <sys_get_optimal_num_faults>
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	50                   	push   %eax
  80029a:	68 f4 42 80 00       	push   $0x8042f4
  80029f:	e8 a1 01 00 00       	call   800445 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
  8002a7:	eb 59                	jmp    800302 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ae:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8002b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8002bf:	83 ec 04             	sub    $0x4,%esp
  8002c2:	52                   	push   %edx
  8002c3:	50                   	push   %eax
  8002c4:	68 18 43 80 00       	push   $0x804318
  8002c9:	e8 77 01 00 00       	call   800445 <cprintf>
  8002ce:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d6:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8002dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e1:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8002e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ec:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002f2:	51                   	push   %ecx
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 40 43 80 00       	push   $0x804340
  8002fa:	e8 46 01 00 00       	call   800445 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800302:	a1 20 50 80 00       	mov    0x805020,%eax
  800307:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80030d:	83 ec 08             	sub    $0x8,%esp
  800310:	50                   	push   %eax
  800311:	68 98 43 80 00       	push   $0x804398
  800316:	e8 2a 01 00 00       	call   800445 <cprintf>
  80031b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80031e:	83 ec 0c             	sub    $0xc,%esp
  800321:	68 cc 42 80 00       	push   $0x8042cc
  800326:	e8 1a 01 00 00       	call   800445 <cprintf>
  80032b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80032e:	e8 ee 2a 00 00       	call   802e21 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800333:	e8 1f 00 00 00       	call   800357 <exit>
}
  800338:	90                   	nop
  800339:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033c:	5b                   	pop    %ebx
  80033d:	5e                   	pop    %esi
  80033e:	5f                   	pop    %edi
  80033f:	5d                   	pop    %ebp
  800340:	c3                   	ret    

00800341 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	6a 00                	push   $0x0
  80034c:	e8 fb 2c 00 00       	call   80304c <sys_destroy_env>
  800351:	83 c4 10             	add    $0x10,%esp
}
  800354:	90                   	nop
  800355:	c9                   	leave  
  800356:	c3                   	ret    

00800357 <exit>:

void
exit(void)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80035d:	e8 50 2d 00 00       	call   8030b2 <sys_exit_env>
}
  800362:	90                   	nop
  800363:	c9                   	leave  
  800364:	c3                   	ret    

00800365 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800365:	55                   	push   %ebp
  800366:	89 e5                	mov    %esp,%ebp
  800368:	53                   	push   %ebx
  800369:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80036c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	8d 48 01             	lea    0x1(%eax),%ecx
  800374:	8b 55 0c             	mov    0xc(%ebp),%edx
  800377:	89 0a                	mov    %ecx,(%edx)
  800379:	8b 55 08             	mov    0x8(%ebp),%edx
  80037c:	88 d1                	mov    %dl,%cl
  80037e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800381:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800385:	8b 45 0c             	mov    0xc(%ebp),%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80038f:	75 30                	jne    8003c1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800391:	8b 15 38 51 83 00    	mov    0x835138,%edx
  800397:	a0 64 d0 81 00       	mov    0x81d064,%al
  80039c:	0f b6 c0             	movzbl %al,%eax
  80039f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a2:	8b 09                	mov    (%ecx),%ecx
  8003a4:	89 cb                	mov    %ecx,%ebx
  8003a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a9:	83 c1 08             	add    $0x8,%ecx
  8003ac:	52                   	push   %edx
  8003ad:	50                   	push   %eax
  8003ae:	53                   	push   %ebx
  8003af:	51                   	push   %ecx
  8003b0:	e8 0e 2a 00 00       	call   802dc3 <sys_cputs>
  8003b5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 40 04             	mov    0x4(%eax),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003d0:	90                   	nop
  8003d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003d4:	c9                   	leave  
  8003d5:	c3                   	ret    

008003d6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e6:	00 00 00 
	b.cnt = 0;
  8003e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003f3:	ff 75 0c             	pushl  0xc(%ebp)
  8003f6:	ff 75 08             	pushl  0x8(%ebp)
  8003f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ff:	50                   	push   %eax
  800400:	68 65 03 80 00       	push   $0x800365
  800405:	e8 5a 02 00 00       	call   800664 <vprintfmt>
  80040a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80040d:	8b 15 38 51 83 00    	mov    0x835138,%edx
  800413:	a0 64 d0 81 00       	mov    0x81d064,%al
  800418:	0f b6 c0             	movzbl %al,%eax
  80041b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800421:	52                   	push   %edx
  800422:	50                   	push   %eax
  800423:	51                   	push   %ecx
  800424:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80042a:	83 c0 08             	add    $0x8,%eax
  80042d:	50                   	push   %eax
  80042e:	e8 90 29 00 00       	call   802dc3 <sys_cputs>
  800433:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800436:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  80043d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800443:	c9                   	leave  
  800444:	c3                   	ret    

00800445 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80044b:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800452:	8d 45 0c             	lea    0xc(%ebp),%eax
  800455:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	ff 75 f4             	pushl  -0xc(%ebp)
  800461:	50                   	push   %eax
  800462:	e8 6f ff ff ff       	call   8003d6 <vcprintf>
  800467:	83 c4 10             	add    $0x10,%esp
  80046a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80046d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800470:	c9                   	leave  
  800471:	c3                   	ret    

00800472 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800478:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	c1 e0 08             	shl    $0x8,%eax
  800485:	a3 38 51 83 00       	mov    %eax,0x835138
	va_start(ap, fmt);
  80048a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80048d:	83 c0 04             	add    $0x4,%eax
  800490:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800493:	8b 45 0c             	mov    0xc(%ebp),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	ff 75 f4             	pushl  -0xc(%ebp)
  80049c:	50                   	push   %eax
  80049d:	e8 34 ff ff ff       	call   8003d6 <vcprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
  8004a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8004a8:	c7 05 38 51 83 00 00 	movl   $0x700,0x835138
  8004af:	07 00 00 

	return cnt;
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8004bd:	e8 45 29 00 00       	call   802e07 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8004c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d1:	50                   	push   %eax
  8004d2:	e8 ff fe ff ff       	call   8003d6 <vcprintf>
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004dd:	e8 3f 29 00 00       	call   802e21 <sys_unlock_cons>
	return cnt;
  8004e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004e5:	c9                   	leave  
  8004e6:	c3                   	ret    

008004e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	53                   	push   %ebx
  8004eb:	83 ec 14             	sub    $0x14,%esp
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8004fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800502:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800505:	77 55                	ja     80055c <printnum+0x75>
  800507:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80050a:	72 05                	jb     800511 <printnum+0x2a>
  80050c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80050f:	77 4b                	ja     80055c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800511:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800514:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800517:	8b 45 18             	mov    0x18(%ebp),%eax
  80051a:	ba 00 00 00 00       	mov    $0x0,%edx
  80051f:	52                   	push   %edx
  800520:	50                   	push   %eax
  800521:	ff 75 f4             	pushl  -0xc(%ebp)
  800524:	ff 75 f0             	pushl  -0x10(%ebp)
  800527:	e8 d8 3a 00 00       	call   804004 <__udivdi3>
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	83 ec 04             	sub    $0x4,%esp
  800532:	ff 75 20             	pushl  0x20(%ebp)
  800535:	53                   	push   %ebx
  800536:	ff 75 18             	pushl  0x18(%ebp)
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	ff 75 0c             	pushl  0xc(%ebp)
  80053e:	ff 75 08             	pushl  0x8(%ebp)
  800541:	e8 a1 ff ff ff       	call   8004e7 <printnum>
  800546:	83 c4 20             	add    $0x20,%esp
  800549:	eb 1a                	jmp    800565 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	ff 75 0c             	pushl  0xc(%ebp)
  800551:	ff 75 20             	pushl  0x20(%ebp)
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	ff d0                	call   *%eax
  800559:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80055c:	ff 4d 1c             	decl   0x1c(%ebp)
  80055f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800563:	7f e6                	jg     80054b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800565:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800568:	bb 00 00 00 00       	mov    $0x0,%ebx
  80056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800573:	53                   	push   %ebx
  800574:	51                   	push   %ecx
  800575:	52                   	push   %edx
  800576:	50                   	push   %eax
  800577:	e8 98 3b 00 00       	call   804114 <__umoddi3>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	05 34 46 80 00       	add    $0x804634,%eax
  800584:	8a 00                	mov    (%eax),%al
  800586:	0f be c0             	movsbl %al,%eax
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	50                   	push   %eax
  800590:	8b 45 08             	mov    0x8(%ebp),%eax
  800593:	ff d0                	call   *%eax
  800595:	83 c4 10             	add    $0x10,%esp
}
  800598:	90                   	nop
  800599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005a5:	7e 1c                	jle    8005c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	8b 00                	mov    (%eax),%eax
  8005ac:	8d 50 08             	lea    0x8(%eax),%edx
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	89 10                	mov    %edx,(%eax)
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	83 e8 08             	sub    $0x8,%eax
  8005bc:	8b 50 04             	mov    0x4(%eax),%edx
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	eb 40                	jmp    800603 <getuint+0x65>
	else if (lflag)
  8005c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005c7:	74 1e                	je     8005e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	8d 50 04             	lea    0x4(%eax),%edx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	89 10                	mov    %edx,(%eax)
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	83 e8 04             	sub    $0x4,%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e5:	eb 1c                	jmp    800603 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	8d 50 04             	lea    0x4(%eax),%edx
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	89 10                	mov    %edx,(%eax)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	83 e8 04             	sub    $0x4,%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800603:	5d                   	pop    %ebp
  800604:	c3                   	ret    

00800605 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800605:	55                   	push   %ebp
  800606:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800608:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80060c:	7e 1c                	jle    80062a <getint+0x25>
		return va_arg(*ap, long long);
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	8d 50 08             	lea    0x8(%eax),%edx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	89 10                	mov    %edx,(%eax)
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	83 e8 08             	sub    $0x8,%eax
  800623:	8b 50 04             	mov    0x4(%eax),%edx
  800626:	8b 00                	mov    (%eax),%eax
  800628:	eb 38                	jmp    800662 <getint+0x5d>
	else if (lflag)
  80062a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80062e:	74 1a                	je     80064a <getint+0x45>
		return va_arg(*ap, long);
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	8d 50 04             	lea    0x4(%eax),%edx
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	89 10                	mov    %edx,(%eax)
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	83 e8 04             	sub    $0x4,%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	99                   	cltd   
  800648:	eb 18                	jmp    800662 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	8d 50 04             	lea    0x4(%eax),%edx
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	89 10                	mov    %edx,(%eax)
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	83 e8 04             	sub    $0x4,%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	99                   	cltd   
}
  800662:	5d                   	pop    %ebp
  800663:	c3                   	ret    

00800664 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	56                   	push   %esi
  800668:	53                   	push   %ebx
  800669:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066c:	eb 17                	jmp    800685 <vprintfmt+0x21>
			if (ch == '\0')
  80066e:	85 db                	test   %ebx,%ebx
  800670:	0f 84 c1 03 00 00    	je     800a37 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 0c             	pushl  0xc(%ebp)
  80067c:	53                   	push   %ebx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	ff d0                	call   *%eax
  800682:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800685:	8b 45 10             	mov    0x10(%ebp),%eax
  800688:	8d 50 01             	lea    0x1(%eax),%edx
  80068b:	89 55 10             	mov    %edx,0x10(%ebp)
  80068e:	8a 00                	mov    (%eax),%al
  800690:	0f b6 d8             	movzbl %al,%ebx
  800693:	83 fb 25             	cmp    $0x25,%ebx
  800696:	75 d6                	jne    80066e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800698:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80069c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8006a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8006aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8006b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006bb:	8d 50 01             	lea    0x1(%eax),%edx
  8006be:	89 55 10             	mov    %edx,0x10(%ebp)
  8006c1:	8a 00                	mov    (%eax),%al
  8006c3:	0f b6 d8             	movzbl %al,%ebx
  8006c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006c9:	83 f8 5b             	cmp    $0x5b,%eax
  8006cc:	0f 87 3d 03 00 00    	ja     800a0f <vprintfmt+0x3ab>
  8006d2:	8b 04 85 58 46 80 00 	mov    0x804658(,%eax,4),%eax
  8006d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006df:	eb d7                	jmp    8006b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006e5:	eb d1                	jmp    8006b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006f1:	89 d0                	mov    %edx,%eax
  8006f3:	c1 e0 02             	shl    $0x2,%eax
  8006f6:	01 d0                	add    %edx,%eax
  8006f8:	01 c0                	add    %eax,%eax
  8006fa:	01 d8                	add    %ebx,%eax
  8006fc:	83 e8 30             	sub    $0x30,%eax
  8006ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800702:	8b 45 10             	mov    0x10(%ebp),%eax
  800705:	8a 00                	mov    (%eax),%al
  800707:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80070a:	83 fb 2f             	cmp    $0x2f,%ebx
  80070d:	7e 3e                	jle    80074d <vprintfmt+0xe9>
  80070f:	83 fb 39             	cmp    $0x39,%ebx
  800712:	7f 39                	jg     80074d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800714:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800717:	eb d5                	jmp    8006ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	83 c0 04             	add    $0x4,%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	83 e8 04             	sub    $0x4,%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80072d:	eb 1f                	jmp    80074e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80072f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800733:	79 83                	jns    8006b8 <vprintfmt+0x54>
				width = 0;
  800735:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80073c:	e9 77 ff ff ff       	jmp    8006b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800741:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800748:	e9 6b ff ff ff       	jmp    8006b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80074d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80074e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800752:	0f 89 60 ff ff ff    	jns    8006b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80075b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80075e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800765:	e9 4e ff ff ff       	jmp    8006b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80076a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80076d:	e9 46 ff ff ff       	jmp    8006b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	83 c0 04             	add    $0x4,%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	83 e8 04             	sub    $0x4,%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	50                   	push   %eax
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	ff d0                	call   *%eax
  80078f:	83 c4 10             	add    $0x10,%esp
			break;
  800792:	e9 9b 02 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	83 c0 04             	add    $0x4,%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	83 e8 04             	sub    $0x4,%eax
  8007a6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8007a8:	85 db                	test   %ebx,%ebx
  8007aa:	79 02                	jns    8007ae <vprintfmt+0x14a>
				err = -err;
  8007ac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007ae:	83 fb 64             	cmp    $0x64,%ebx
  8007b1:	7f 0b                	jg     8007be <vprintfmt+0x15a>
  8007b3:	8b 34 9d a0 44 80 00 	mov    0x8044a0(,%ebx,4),%esi
  8007ba:	85 f6                	test   %esi,%esi
  8007bc:	75 19                	jne    8007d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8007be:	53                   	push   %ebx
  8007bf:	68 45 46 80 00       	push   $0x804645
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 70 02 00 00       	call   800a3f <printfmt>
  8007cf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007d2:	e9 5b 02 00 00       	jmp    800a32 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007d7:	56                   	push   %esi
  8007d8:	68 4e 46 80 00       	push   $0x80464e
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	ff 75 08             	pushl  0x8(%ebp)
  8007e3:	e8 57 02 00 00       	call   800a3f <printfmt>
  8007e8:	83 c4 10             	add    $0x10,%esp
			break;
  8007eb:	e9 42 02 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	83 c0 04             	add    $0x4,%eax
  8007f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 30                	mov    (%eax),%esi
  800801:	85 f6                	test   %esi,%esi
  800803:	75 05                	jne    80080a <vprintfmt+0x1a6>
				p = "(null)";
  800805:	be 51 46 80 00       	mov    $0x804651,%esi
			if (width > 0 && padc != '-')
  80080a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080e:	7e 6d                	jle    80087d <vprintfmt+0x219>
  800810:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800814:	74 67                	je     80087d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	50                   	push   %eax
  80081d:	56                   	push   %esi
  80081e:	e8 26 05 00 00       	call   800d49 <strnlen>
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800829:	eb 16                	jmp    800841 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80082b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	50                   	push   %eax
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80083e:	ff 4d e4             	decl   -0x1c(%ebp)
  800841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800845:	7f e4                	jg     80082b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800847:	eb 34                	jmp    80087d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800849:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80084d:	74 1c                	je     80086b <vprintfmt+0x207>
  80084f:	83 fb 1f             	cmp    $0x1f,%ebx
  800852:	7e 05                	jle    800859 <vprintfmt+0x1f5>
  800854:	83 fb 7e             	cmp    $0x7e,%ebx
  800857:	7e 12                	jle    80086b <vprintfmt+0x207>
					putch('?', putdat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	ff 75 0c             	pushl  0xc(%ebp)
  80085f:	6a 3f                	push   $0x3f
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	eb 0f                	jmp    80087a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	53                   	push   %ebx
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	ff d0                	call   *%eax
  800877:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80087a:	ff 4d e4             	decl   -0x1c(%ebp)
  80087d:	89 f0                	mov    %esi,%eax
  80087f:	8d 70 01             	lea    0x1(%eax),%esi
  800882:	8a 00                	mov    (%eax),%al
  800884:	0f be d8             	movsbl %al,%ebx
  800887:	85 db                	test   %ebx,%ebx
  800889:	74 24                	je     8008af <vprintfmt+0x24b>
  80088b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80088f:	78 b8                	js     800849 <vprintfmt+0x1e5>
  800891:	ff 4d e0             	decl   -0x20(%ebp)
  800894:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800898:	79 af                	jns    800849 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80089a:	eb 13                	jmp    8008af <vprintfmt+0x24b>
				putch(' ', putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	6a 20                	push   $0x20
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	ff d0                	call   *%eax
  8008a9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8008af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b3:	7f e7                	jg     80089c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8008b5:	e9 78 01 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8008c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c3:	50                   	push   %eax
  8008c4:	e8 3c fd ff ff       	call   800605 <getint>
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d8:	85 d2                	test   %edx,%edx
  8008da:	79 23                	jns    8008ff <vprintfmt+0x29b>
				putch('-', putdat);
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 0c             	pushl  0xc(%ebp)
  8008e2:	6a 2d                	push   $0x2d
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008f2:	f7 d8                	neg    %eax
  8008f4:	83 d2 00             	adc    $0x0,%edx
  8008f7:	f7 da                	neg    %edx
  8008f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800906:	e9 bc 00 00 00       	jmp    8009c7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 e8             	pushl  -0x18(%ebp)
  800911:	8d 45 14             	lea    0x14(%ebp),%eax
  800914:	50                   	push   %eax
  800915:	e8 84 fc ff ff       	call   80059e <getuint>
  80091a:	83 c4 10             	add    $0x10,%esp
  80091d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800920:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800923:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80092a:	e9 98 00 00 00       	jmp    8009c7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	6a 58                	push   $0x58
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	ff d0                	call   *%eax
  80093c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	6a 58                	push   $0x58
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	ff d0                	call   *%eax
  80094c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80094f:	83 ec 08             	sub    $0x8,%esp
  800952:	ff 75 0c             	pushl  0xc(%ebp)
  800955:	6a 58                	push   $0x58
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	ff d0                	call   *%eax
  80095c:	83 c4 10             	add    $0x10,%esp
			break;
  80095f:	e9 ce 00 00 00       	jmp    800a32 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 0c             	pushl  0xc(%ebp)
  80096a:	6a 30                	push   $0x30
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	ff d0                	call   *%eax
  800971:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	6a 78                	push   $0x78
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	ff d0                	call   *%eax
  800981:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800995:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80099f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8009a6:	eb 1f                	jmp    8009c7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b1:	50                   	push   %eax
  8009b2:	e8 e7 fb ff ff       	call   80059e <getuint>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8009c0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009c7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ce:	83 ec 04             	sub    $0x4,%esp
  8009d1:	52                   	push   %edx
  8009d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009d5:	50                   	push   %eax
  8009d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 00 fb ff ff       	call   8004e7 <printnum>
  8009e7:	83 c4 20             	add    $0x20,%esp
			break;
  8009ea:	eb 46                	jmp    800a32 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	53                   	push   %ebx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			break;
  8009fb:	eb 35                	jmp    800a32 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009fd:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800a04:	eb 2c                	jmp    800a32 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a06:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800a0d:	eb 23                	jmp    800a32 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 25                	push   $0x25
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a1f:	ff 4d 10             	decl   0x10(%ebp)
  800a22:	eb 03                	jmp    800a27 <vprintfmt+0x3c3>
  800a24:	ff 4d 10             	decl   0x10(%ebp)
  800a27:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2a:	48                   	dec    %eax
  800a2b:	8a 00                	mov    (%eax),%al
  800a2d:	3c 25                	cmp    $0x25,%al
  800a2f:	75 f3                	jne    800a24 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a31:	90                   	nop
		}
	}
  800a32:	e9 35 fc ff ff       	jmp    80066c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a37:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a3b:	5b                   	pop    %ebx
  800a3c:	5e                   	pop    %esi
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a45:	8d 45 10             	lea    0x10(%ebp),%eax
  800a48:	83 c0 04             	add    $0x4,%eax
  800a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	ff 75 08             	pushl  0x8(%ebp)
  800a5b:	e8 04 fc ff ff       	call   800664 <vprintfmt>
  800a60:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a63:	90                   	nop
  800a64:	c9                   	leave  
  800a65:	c3                   	ret    

00800a66 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	8b 40 08             	mov    0x8(%eax),%eax
  800a6f:	8d 50 01             	lea    0x1(%eax),%edx
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7b:	8b 10                	mov    (%eax),%edx
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	8b 40 04             	mov    0x4(%eax),%eax
  800a83:	39 c2                	cmp    %eax,%edx
  800a85:	73 12                	jae    800a99 <sprintputch+0x33>
		*b->buf++ = ch;
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a92:	89 0a                	mov    %ecx,(%edx)
  800a94:	8b 55 08             	mov    0x8(%ebp),%edx
  800a97:	88 10                	mov    %dl,(%eax)
}
  800a99:	90                   	nop
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	01 d0                	add    %edx,%eax
  800ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800abd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ac1:	74 06                	je     800ac9 <vsnprintf+0x2d>
  800ac3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac7:	7f 07                	jg     800ad0 <vsnprintf+0x34>
		return -E_INVAL;
  800ac9:	b8 03 00 00 00       	mov    $0x3,%eax
  800ace:	eb 20                	jmp    800af0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ad0:	ff 75 14             	pushl  0x14(%ebp)
  800ad3:	ff 75 10             	pushl  0x10(%ebp)
  800ad6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ad9:	50                   	push   %eax
  800ada:	68 66 0a 80 00       	push   $0x800a66
  800adf:	e8 80 fb ff ff       	call   800664 <vprintfmt>
  800ae4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    

00800af2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800af8:	8d 45 10             	lea    0x10(%ebp),%eax
  800afb:	83 c0 04             	add    $0x4,%eax
  800afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b01:	8b 45 10             	mov    0x10(%ebp),%eax
  800b04:	ff 75 f4             	pushl  -0xc(%ebp)
  800b07:	50                   	push   %eax
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	ff 75 08             	pushl  0x8(%ebp)
  800b0e:	e8 89 ff ff ff       	call   800a9c <vsnprintf>
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800b24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b28:	74 13                	je     800b3d <readline+0x1f>
		cprintf("%s", prompt);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	68 c8 47 80 00       	push   $0x8047c8
  800b35:	e8 0b f9 ff ff       	call   800445 <cprintf>
  800b3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800b3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800b44:	83 ec 0c             	sub    $0xc,%esp
  800b47:	6a 00                	push   $0x0
  800b49:	e8 bb 32 00 00       	call   803e09 <iscons>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800b54:	e8 9d 32 00 00       	call   803df6 <getchar>
  800b59:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800b5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b60:	79 22                	jns    800b84 <readline+0x66>
			if (c != -E_EOF)
  800b62:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b66:	0f 84 ad 00 00 00    	je     800c19 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 ec             	pushl  -0x14(%ebp)
  800b72:	68 cb 47 80 00       	push   $0x8047cb
  800b77:	e8 c9 f8 ff ff       	call   800445 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp
			break;
  800b7f:	e9 95 00 00 00       	jmp    800c19 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b84:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b88:	7e 34                	jle    800bbe <readline+0xa0>
  800b8a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b91:	7f 2b                	jg     800bbe <readline+0xa0>
			if (echoing)
  800b93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b97:	74 0e                	je     800ba7 <readline+0x89>
				cputchar(c);
  800b99:	83 ec 0c             	sub    $0xc,%esp
  800b9c:	ff 75 ec             	pushl  -0x14(%ebp)
  800b9f:	e8 33 32 00 00       	call   803dd7 <cputchar>
  800ba4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800baa:	8d 50 01             	lea    0x1(%eax),%edx
  800bad:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bb0:	89 c2                	mov    %eax,%edx
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	01 d0                	add    %edx,%eax
  800bb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bba:	88 10                	mov    %dl,(%eax)
  800bbc:	eb 56                	jmp    800c14 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800bbe:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bc2:	75 1f                	jne    800be3 <readline+0xc5>
  800bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bc8:	7e 19                	jle    800be3 <readline+0xc5>
			if (echoing)
  800bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bce:	74 0e                	je     800bde <readline+0xc0>
				cputchar(c);
  800bd0:	83 ec 0c             	sub    $0xc,%esp
  800bd3:	ff 75 ec             	pushl  -0x14(%ebp)
  800bd6:	e8 fc 31 00 00       	call   803dd7 <cputchar>
  800bdb:	83 c4 10             	add    $0x10,%esp

			i--;
  800bde:	ff 4d f4             	decl   -0xc(%ebp)
  800be1:	eb 31                	jmp    800c14 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800be3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800be7:	74 0a                	je     800bf3 <readline+0xd5>
  800be9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800bed:	0f 85 61 ff ff ff    	jne    800b54 <readline+0x36>
			if (echoing)
  800bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bf7:	74 0e                	je     800c07 <readline+0xe9>
				cputchar(c);
  800bf9:	83 ec 0c             	sub    $0xc,%esp
  800bfc:	ff 75 ec             	pushl  -0x14(%ebp)
  800bff:	e8 d3 31 00 00       	call   803dd7 <cputchar>
  800c04:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800c12:	eb 06                	jmp    800c1a <readline+0xfc>
		}
	}
  800c14:	e9 3b ff ff ff       	jmp    800b54 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800c19:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800c1a:	90                   	nop
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800c23:	e8 df 21 00 00       	call   802e07 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c2c:	74 13                	je     800c41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 08             	pushl  0x8(%ebp)
  800c34:	68 c8 47 80 00       	push   $0x8047c8
  800c39:	e8 07 f8 ff ff       	call   800445 <cprintf>
  800c3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	6a 00                	push   $0x0
  800c4d:	e8 b7 31 00 00       	call   803e09 <iscons>
  800c52:	83 c4 10             	add    $0x10,%esp
  800c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800c58:	e8 99 31 00 00       	call   803df6 <getchar>
  800c5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800c60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c64:	79 22                	jns    800c88 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800c66:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800c6a:	0f 84 ad 00 00 00    	je     800d1d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800c70:	83 ec 08             	sub    $0x8,%esp
  800c73:	ff 75 ec             	pushl  -0x14(%ebp)
  800c76:	68 cb 47 80 00       	push   $0x8047cb
  800c7b:	e8 c5 f7 ff ff       	call   800445 <cprintf>
  800c80:	83 c4 10             	add    $0x10,%esp
				break;
  800c83:	e9 95 00 00 00       	jmp    800d1d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800c88:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800c8c:	7e 34                	jle    800cc2 <atomic_readline+0xa5>
  800c8e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800c95:	7f 2b                	jg     800cc2 <atomic_readline+0xa5>
				if (echoing)
  800c97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c9b:	74 0e                	je     800cab <atomic_readline+0x8e>
					cputchar(c);
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	ff 75 ec             	pushl  -0x14(%ebp)
  800ca3:	e8 2f 31 00 00       	call   803dd7 <cputchar>
  800ca8:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800cb4:	89 c2                	mov    %eax,%edx
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	01 d0                	add    %edx,%eax
  800cbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800cbe:	88 10                	mov    %dl,(%eax)
  800cc0:	eb 56                	jmp    800d18 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800cc2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800cc6:	75 1f                	jne    800ce7 <atomic_readline+0xca>
  800cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ccc:	7e 19                	jle    800ce7 <atomic_readline+0xca>
				if (echoing)
  800cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cd2:	74 0e                	je     800ce2 <atomic_readline+0xc5>
					cputchar(c);
  800cd4:	83 ec 0c             	sub    $0xc,%esp
  800cd7:	ff 75 ec             	pushl  -0x14(%ebp)
  800cda:	e8 f8 30 00 00       	call   803dd7 <cputchar>
  800cdf:	83 c4 10             	add    $0x10,%esp
				i--;
  800ce2:	ff 4d f4             	decl   -0xc(%ebp)
  800ce5:	eb 31                	jmp    800d18 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800ce7:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ceb:	74 0a                	je     800cf7 <atomic_readline+0xda>
  800ced:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800cf1:	0f 85 61 ff ff ff    	jne    800c58 <atomic_readline+0x3b>
				if (echoing)
  800cf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cfb:	74 0e                	je     800d0b <atomic_readline+0xee>
					cputchar(c);
  800cfd:	83 ec 0c             	sub    $0xc,%esp
  800d00:	ff 75 ec             	pushl  -0x14(%ebp)
  800d03:	e8 cf 30 00 00       	call   803dd7 <cputchar>
  800d08:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	01 d0                	add    %edx,%eax
  800d13:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800d16:	eb 06                	jmp    800d1e <atomic_readline+0x101>
			}
		}
  800d18:	e9 3b ff ff ff       	jmp    800c58 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800d1d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800d1e:	e8 fe 20 00 00       	call   802e21 <sys_unlock_cons>
}
  800d23:	90                   	nop
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d33:	eb 06                	jmp    800d3b <strlen+0x15>
		n++;
  800d35:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8a 00                	mov    (%eax),%al
  800d40:	84 c0                	test   %al,%al
  800d42:	75 f1                	jne    800d35 <strlen+0xf>
		n++;
	return n;
  800d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 09                	jmp    800d61 <strnlen+0x18>
		n++;
  800d58:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5b:	ff 45 08             	incl   0x8(%ebp)
  800d5e:	ff 4d 0c             	decl   0xc(%ebp)
  800d61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d65:	74 09                	je     800d70 <strnlen+0x27>
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	75 e8                	jne    800d58 <strnlen+0xf>
		n++;
	return n;
  800d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d81:	90                   	nop
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8d 50 01             	lea    0x1(%eax),%edx
  800d88:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d94:	8a 12                	mov    (%edx),%dl
  800d96:	88 10                	mov    %dl,(%eax)
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 e4                	jne    800d82 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800daf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db6:	eb 1f                	jmp    800dd7 <strncpy+0x34>
		*dst++ = *src;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8d 50 01             	lea    0x1(%eax),%edx
  800dbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc4:	8a 12                	mov    (%edx),%dl
  800dc6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	84 c0                	test   %al,%al
  800dcf:	74 03                	je     800dd4 <strncpy+0x31>
			src++;
  800dd1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd4:	ff 45 fc             	incl   -0x4(%ebp)
  800dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dda:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ddd:	72 d9                	jb     800db8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	74 30                	je     800e26 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800df6:	eb 16                	jmp    800e0e <strlcpy+0x2a>
			*dst++ = *src++;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 08             	mov    %edx,0x8(%ebp)
  800e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e0e:	ff 4d 10             	decl   0x10(%ebp)
  800e11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e15:	74 09                	je     800e20 <strlcpy+0x3c>
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	84 c0                	test   %al,%al
  800e1e:	75 d8                	jne    800df8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 d0                	mov    %edx,%eax
}
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e35:	eb 06                	jmp    800e3d <strcmp+0xb>
		p++, q++;
  800e37:	ff 45 08             	incl   0x8(%ebp)
  800e3a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	74 0e                	je     800e54 <strcmp+0x22>
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 10                	mov    (%eax),%dl
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	38 c2                	cmp    %al,%dl
  800e52:	74 e3                	je     800e37 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f b6 d0             	movzbl %al,%edx
  800e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	0f b6 c0             	movzbl %al,%eax
  800e64:	29 c2                	sub    %eax,%edx
  800e66:	89 d0                	mov    %edx,%eax
}
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e6d:	eb 09                	jmp    800e78 <strncmp+0xe>
		n--, p++, q++;
  800e6f:	ff 4d 10             	decl   0x10(%ebp)
  800e72:	ff 45 08             	incl   0x8(%ebp)
  800e75:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7c:	74 17                	je     800e95 <strncmp+0x2b>
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	84 c0                	test   %al,%al
  800e85:	74 0e                	je     800e95 <strncmp+0x2b>
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	8a 10                	mov    (%eax),%dl
  800e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	38 c2                	cmp    %al,%dl
  800e93:	74 da                	je     800e6f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e99:	75 07                	jne    800ea2 <strncmp+0x38>
		return 0;
  800e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea0:	eb 14                	jmp    800eb6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	0f b6 d0             	movzbl %al,%edx
  800eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	0f b6 c0             	movzbl %al,%eax
  800eb2:	29 c2                	sub    %eax,%edx
  800eb4:	89 d0                	mov    %edx,%eax
}
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    

00800eb8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 04             	sub    $0x4,%esp
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec4:	eb 12                	jmp    800ed8 <strchr+0x20>
		if (*s == c)
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ece:	75 05                	jne    800ed5 <strchr+0x1d>
			return (char *) s;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	eb 11                	jmp    800ee6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed5:	ff 45 08             	incl   0x8(%ebp)
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	84 c0                	test   %al,%al
  800edf:	75 e5                	jne    800ec6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 04             	sub    $0x4,%esp
  800eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef4:	eb 0d                	jmp    800f03 <strfind+0x1b>
		if (*s == c)
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800efe:	74 0e                	je     800f0e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f00:	ff 45 08             	incl   0x8(%ebp)
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	84 c0                	test   %al,%al
  800f0a:	75 ea                	jne    800ef6 <strfind+0xe>
  800f0c:	eb 01                	jmp    800f0f <strfind+0x27>
		if (*s == c)
			break;
  800f0e:	90                   	nop
	return (char *) s;
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f20:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f24:	76 63                	jbe    800f89 <memset+0x75>
		uint64 data_block = c;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	99                   	cltd   
  800f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f36:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f3a:	c1 e0 08             	shl    $0x8,%eax
  800f3d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f40:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f49:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f4d:	c1 e0 10             	shl    $0x10,%eax
  800f50:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f53:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5c:	89 c2                	mov    %eax,%edx
  800f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f63:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f66:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f69:	eb 18                	jmp    800f83 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f6b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f6e:	8d 41 08             	lea    0x8(%ecx),%eax
  800f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f7a:	89 01                	mov    %eax,(%ecx)
  800f7c:	89 51 04             	mov    %edx,0x4(%ecx)
  800f7f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f83:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f87:	77 e2                	ja     800f6b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8d:	74 23                	je     800fb2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f92:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f95:	eb 0e                	jmp    800fa5 <memset+0x91>
			*p8++ = (uint8)c;
  800f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fab:	89 55 10             	mov    %edx,0x10(%ebp)
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	75 e5                	jne    800f97 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb5:	c9                   	leave  
  800fb6:	c3                   	ret    

00800fb7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800fc9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fcd:	76 24                	jbe    800ff3 <memcpy+0x3c>
		while(n >= 8){
  800fcf:	eb 1c                	jmp    800fed <memcpy+0x36>
			*d64 = *s64;
  800fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd4:	8b 50 04             	mov    0x4(%eax),%edx
  800fd7:	8b 00                	mov    (%eax),%eax
  800fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fdc:	89 01                	mov    %eax,(%ecx)
  800fde:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fe1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fe5:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fe9:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800fed:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff1:	77 de                	ja     800fd1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800ff3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff7:	74 31                	je     80102a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ff9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801002:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801005:	eb 16                	jmp    80101d <memcpy+0x66>
			*d8++ = *s8++;
  801007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100a:	8d 50 01             	lea    0x1(%eax),%edx
  80100d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801013:	8d 4a 01             	lea    0x1(%edx),%ecx
  801016:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801019:	8a 12                	mov    (%edx),%dl
  80101b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	8d 50 ff             	lea    -0x1(%eax),%edx
  801023:	89 55 10             	mov    %edx,0x10(%ebp)
  801026:	85 c0                	test   %eax,%eax
  801028:	75 dd                	jne    801007 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102d:	c9                   	leave  
  80102e:	c3                   	ret    

0080102f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801044:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801047:	73 50                	jae    801099 <memmove+0x6a>
  801049:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104c:	8b 45 10             	mov    0x10(%ebp),%eax
  80104f:	01 d0                	add    %edx,%eax
  801051:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801054:	76 43                	jbe    801099 <memmove+0x6a>
		s += n;
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80105c:	8b 45 10             	mov    0x10(%ebp),%eax
  80105f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801062:	eb 10                	jmp    801074 <memmove+0x45>
			*--d = *--s;
  801064:	ff 4d f8             	decl   -0x8(%ebp)
  801067:	ff 4d fc             	decl   -0x4(%ebp)
  80106a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106d:	8a 10                	mov    (%eax),%dl
  80106f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801072:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801074:	8b 45 10             	mov    0x10(%ebp),%eax
  801077:	8d 50 ff             	lea    -0x1(%eax),%edx
  80107a:	89 55 10             	mov    %edx,0x10(%ebp)
  80107d:	85 c0                	test   %eax,%eax
  80107f:	75 e3                	jne    801064 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801081:	eb 23                	jmp    8010a6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801086:	8d 50 01             	lea    0x1(%eax),%edx
  801089:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80108f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801092:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801095:	8a 12                	mov    (%edx),%dl
  801097:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109f:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	75 dd                	jne    801083 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ba:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010bd:	eb 2a                	jmp    8010e9 <memcmp+0x3e>
		if (*s1 != *s2)
  8010bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c2:	8a 10                	mov    (%eax),%dl
  8010c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	38 c2                	cmp    %al,%dl
  8010cb:	74 16                	je     8010e3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	0f b6 d0             	movzbl %al,%edx
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f b6 c0             	movzbl %al,%eax
  8010dd:	29 c2                	sub    %eax,%edx
  8010df:	89 d0                	mov    %edx,%eax
  8010e1:	eb 18                	jmp    8010fb <memcmp+0x50>
		s1++, s2++;
  8010e3:	ff 45 fc             	incl   -0x4(%ebp)
  8010e6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	75 c9                	jne    8010bf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    

008010fd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801103:	8b 55 08             	mov    0x8(%ebp),%edx
  801106:	8b 45 10             	mov    0x10(%ebp),%eax
  801109:	01 d0                	add    %edx,%eax
  80110b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80110e:	eb 15                	jmp    801125 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	0f b6 d0             	movzbl %al,%edx
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	0f b6 c0             	movzbl %al,%eax
  80111e:	39 c2                	cmp    %eax,%edx
  801120:	74 0d                	je     80112f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801122:	ff 45 08             	incl   0x8(%ebp)
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80112b:	72 e3                	jb     801110 <memfind+0x13>
  80112d:	eb 01                	jmp    801130 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80112f:	90                   	nop
	return (void *) s;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80113b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801142:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801149:	eb 03                	jmp    80114e <strtol+0x19>
		s++;
  80114b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	3c 20                	cmp    $0x20,%al
  801155:	74 f4                	je     80114b <strtol+0x16>
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	3c 09                	cmp    $0x9,%al
  80115e:	74 eb                	je     80114b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	3c 2b                	cmp    $0x2b,%al
  801167:	75 05                	jne    80116e <strtol+0x39>
		s++;
  801169:	ff 45 08             	incl   0x8(%ebp)
  80116c:	eb 13                	jmp    801181 <strtol+0x4c>
	else if (*s == '-')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 2d                	cmp    $0x2d,%al
  801175:	75 0a                	jne    801181 <strtol+0x4c>
		s++, neg = 1;
  801177:	ff 45 08             	incl   0x8(%ebp)
  80117a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801181:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801185:	74 06                	je     80118d <strtol+0x58>
  801187:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80118b:	75 20                	jne    8011ad <strtol+0x78>
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	3c 30                	cmp    $0x30,%al
  801194:	75 17                	jne    8011ad <strtol+0x78>
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	40                   	inc    %eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 78                	cmp    $0x78,%al
  80119e:	75 0d                	jne    8011ad <strtol+0x78>
		s += 2, base = 16;
  8011a0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011a4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011ab:	eb 28                	jmp    8011d5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b1:	75 15                	jne    8011c8 <strtol+0x93>
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 30                	cmp    $0x30,%al
  8011ba:	75 0c                	jne    8011c8 <strtol+0x93>
		s++, base = 8;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c6:	eb 0d                	jmp    8011d5 <strtol+0xa0>
	else if (base == 0)
  8011c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cc:	75 07                	jne    8011d5 <strtol+0xa0>
		base = 10;
  8011ce:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3c 2f                	cmp    $0x2f,%al
  8011dc:	7e 19                	jle    8011f7 <strtol+0xc2>
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	3c 39                	cmp    $0x39,%al
  8011e5:	7f 10                	jg     8011f7 <strtol+0xc2>
			dig = *s - '0';
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	0f be c0             	movsbl %al,%eax
  8011ef:	83 e8 30             	sub    $0x30,%eax
  8011f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011f5:	eb 42                	jmp    801239 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	3c 60                	cmp    $0x60,%al
  8011fe:	7e 19                	jle    801219 <strtol+0xe4>
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	3c 7a                	cmp    $0x7a,%al
  801207:	7f 10                	jg     801219 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	0f be c0             	movsbl %al,%eax
  801211:	83 e8 57             	sub    $0x57,%eax
  801214:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801217:	eb 20                	jmp    801239 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 40                	cmp    $0x40,%al
  801220:	7e 39                	jle    80125b <strtol+0x126>
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	3c 5a                	cmp    $0x5a,%al
  801229:	7f 30                	jg     80125b <strtol+0x126>
			dig = *s - 'A' + 10;
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	0f be c0             	movsbl %al,%eax
  801233:	83 e8 37             	sub    $0x37,%eax
  801236:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80123f:	7d 19                	jge    80125a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801241:	ff 45 08             	incl   0x8(%ebp)
  801244:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801247:	0f af 45 10          	imul   0x10(%ebp),%eax
  80124b:	89 c2                	mov    %eax,%edx
  80124d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801250:	01 d0                	add    %edx,%eax
  801252:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801255:	e9 7b ff ff ff       	jmp    8011d5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80125a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80125b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80125f:	74 08                	je     801269 <strtol+0x134>
		*endptr = (char *) s;
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	8b 55 08             	mov    0x8(%ebp),%edx
  801267:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801269:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80126d:	74 07                	je     801276 <strtol+0x141>
  80126f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801272:	f7 d8                	neg    %eax
  801274:	eb 03                	jmp    801279 <strtol+0x144>
  801276:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <ltostr>:

void
ltostr(long value, char *str)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801281:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801288:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80128f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801293:	79 13                	jns    8012a8 <ltostr+0x2d>
	{
		neg = 1;
  801295:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012a2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012a5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b0:	99                   	cltd   
  8012b1:	f7 f9                	idiv   %ecx
  8012b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b9:	8d 50 01             	lea    0x1(%eax),%edx
  8012bc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	01 d0                	add    %edx,%eax
  8012c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c9:	83 c2 30             	add    $0x30,%edx
  8012cc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d6:	f7 e9                	imul   %ecx
  8012d8:	c1 fa 02             	sar    $0x2,%edx
  8012db:	89 c8                	mov    %ecx,%eax
  8012dd:	c1 f8 1f             	sar    $0x1f,%eax
  8012e0:	29 c2                	sub    %eax,%edx
  8012e2:	89 d0                	mov    %edx,%eax
  8012e4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012eb:	75 bb                	jne    8012a8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	48                   	dec    %eax
  8012f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ff:	74 3d                	je     80133e <ltostr+0xc3>
		start = 1 ;
  801301:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801308:	eb 34                	jmp    80133e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80130a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	01 c2                	add    %eax,%edx
  80131f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801322:	8b 45 0c             	mov    0xc(%ebp),%eax
  801325:	01 c8                	add    %ecx,%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80132b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80132e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801331:	01 c2                	add    %eax,%edx
  801333:	8a 45 eb             	mov    -0x15(%ebp),%al
  801336:	88 02                	mov    %al,(%edx)
		start++ ;
  801338:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80133b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80133e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801341:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801344:	7c c4                	jl     80130a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801346:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801351:	90                   	nop
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 c4 f9 ff ff       	call   800d26 <strlen>
  801362:	83 c4 04             	add    $0x4,%esp
  801365:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	e8 b6 f9 ff ff       	call   800d26 <strlen>
  801370:	83 c4 04             	add    $0x4,%esp
  801373:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80137d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801384:	eb 17                	jmp    80139d <strcconcat+0x49>
		final[s] = str1[s] ;
  801386:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801389:	8b 45 10             	mov    0x10(%ebp),%eax
  80138c:	01 c2                	add    %eax,%edx
  80138e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	01 c8                	add    %ecx,%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80139a:	ff 45 fc             	incl   -0x4(%ebp)
  80139d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013a3:	7c e1                	jl     801386 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013b3:	eb 1f                	jmp    8013d4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b8:	8d 50 01             	lea    0x1(%eax),%edx
  8013bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013be:	89 c2                	mov    %eax,%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 c2                	add    %eax,%edx
  8013c5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	01 c8                	add    %ecx,%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013d1:	ff 45 f8             	incl   -0x8(%ebp)
  8013d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013da:	7c d9                	jl     8013b5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	c6 00 00             	movb   $0x0,(%eax)
}
  8013e7:	90                   	nop
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	8b 00                	mov    (%eax),%eax
  8013fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80140d:	eb 0c                	jmp    80141b <strsplit+0x31>
			*string++ = 0;
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8d 50 01             	lea    0x1(%eax),%edx
  801415:	89 55 08             	mov    %edx,0x8(%ebp)
  801418:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	84 c0                	test   %al,%al
  801422:	74 18                	je     80143c <strsplit+0x52>
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	0f be c0             	movsbl %al,%eax
  80142c:	50                   	push   %eax
  80142d:	ff 75 0c             	pushl  0xc(%ebp)
  801430:	e8 83 fa ff ff       	call   800eb8 <strchr>
  801435:	83 c4 08             	add    $0x8,%esp
  801438:	85 c0                	test   %eax,%eax
  80143a:	75 d3                	jne    80140f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	84 c0                	test   %al,%al
  801443:	74 5a                	je     80149f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801445:	8b 45 14             	mov    0x14(%ebp),%eax
  801448:	8b 00                	mov    (%eax),%eax
  80144a:	83 f8 0f             	cmp    $0xf,%eax
  80144d:	75 07                	jne    801456 <strsplit+0x6c>
		{
			return 0;
  80144f:	b8 00 00 00 00       	mov    $0x0,%eax
  801454:	eb 66                	jmp    8014bc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801456:	8b 45 14             	mov    0x14(%ebp),%eax
  801459:	8b 00                	mov    (%eax),%eax
  80145b:	8d 48 01             	lea    0x1(%eax),%ecx
  80145e:	8b 55 14             	mov    0x14(%ebp),%edx
  801461:	89 0a                	mov    %ecx,(%edx)
  801463:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146a:	8b 45 10             	mov    0x10(%ebp),%eax
  80146d:	01 c2                	add    %eax,%edx
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801474:	eb 03                	jmp    801479 <strsplit+0x8f>
			string++;
  801476:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	84 c0                	test   %al,%al
  801480:	74 8b                	je     80140d <strsplit+0x23>
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	0f be c0             	movsbl %al,%eax
  80148a:	50                   	push   %eax
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	e8 25 fa ff ff       	call   800eb8 <strchr>
  801493:	83 c4 08             	add    $0x8,%esp
  801496:	85 c0                	test   %eax,%eax
  801498:	74 dc                	je     801476 <strsplit+0x8c>
			string++;
	}
  80149a:	e9 6e ff ff ff       	jmp    80140d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80149f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a3:	8b 00                	mov    (%eax),%eax
  8014a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8014af:	01 d0                	add    %edx,%eax
  8014b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014b7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014d1:	eb 4a                	jmp    80151d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	01 c2                	add    %eax,%edx
  8014db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	01 c8                	add    %ecx,%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	01 d0                	add    %edx,%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	3c 40                	cmp    $0x40,%al
  8014f3:	7e 25                	jle    80151a <str2lower+0x5c>
  8014f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fb:	01 d0                	add    %edx,%eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	3c 5a                	cmp    $0x5a,%al
  801501:	7f 17                	jg     80151a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801503:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	01 d0                	add    %edx,%eax
  80150b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80150e:	8b 55 08             	mov    0x8(%ebp),%edx
  801511:	01 ca                	add    %ecx,%edx
  801513:	8a 12                	mov    (%edx),%dl
  801515:	83 c2 20             	add    $0x20,%edx
  801518:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80151a:	ff 45 fc             	incl   -0x4(%ebp)
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	e8 01 f8 ff ff       	call   800d26 <strlen>
  801525:	83 c4 04             	add    $0x4,%esp
  801528:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80152b:	7f a6                	jg     8014d3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80152d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801538:	a1 08 50 80 00       	mov    0x805008,%eax
  80153d:	85 c0                	test   %eax,%eax
  80153f:	74 42                	je     801583 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801541:	83 ec 08             	sub    $0x8,%esp
  801544:	68 00 00 00 82       	push   $0x82000000
  801549:	68 00 00 00 80       	push   $0x80000000
  80154e:	e8 b0 1e 00 00       	call   803403 <initialize_dynamic_allocator>
  801553:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801556:	e8 96 1c 00 00       	call   8031f1 <sys_get_uheap_strategy>
  80155b:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801560:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801565:	05 00 10 00 00       	add    $0x1000,%eax
  80156a:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  80156f:	a1 30 51 83 00       	mov    0x835130,%eax
  801574:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  801579:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  801580:	00 00 00 
	}
}
  801583:	90                   	nop
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	68 06 04 00 00       	push   $0x406
  8015a2:	50                   	push   %eax
  8015a3:	e8 93 18 00 00       	call   802e3b <__sys_allocate_page>
  8015a8:	83 c4 10             	add    $0x10,%esp
  8015ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015b2:	79 14                	jns    8015c8 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	68 dc 47 80 00       	push   $0x8047dc
  8015bc:	6a 1f                	push   $0x1f
  8015be:	68 18 48 80 00       	push   $0x804818
  8015c3:	e8 4b 28 00 00       	call   803e13 <_panic>
	return 0;
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015e3:	83 ec 0c             	sub    $0xc,%esp
  8015e6:	50                   	push   %eax
  8015e7:	e8 96 18 00 00       	call   802e82 <__sys_unmap_frame>
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015f6:	79 14                	jns    80160c <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 24 48 80 00       	push   $0x804824
  801600:	6a 2a                	push   $0x2a
  801602:	68 18 48 80 00       	push   $0x804818
  801607:	e8 07 28 00 00       	call   803e13 <_panic>
}
  80160c:	90                   	nop
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801615:	e8 18 ff ff ff       	call   801532 <uheap_init>
	if (size == 0) return NULL ;
  80161a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80161e:	75 0a                	jne    80162a <malloc+0x1b>
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
  801625:	e9 43 03 00 00       	jmp    80196d <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80162a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801631:	77 13                	ja     801646 <malloc+0x37>
    {
        return alloc_block(size);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 78 20 00 00       	call   8036b6 <alloc_block>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	e9 27 03 00 00       	jmp    80196d <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801646:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80164d:	8b 55 08             	mov    0x8(%ebp),%edx
  801650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801653:	01 d0                	add    %edx,%eax
  801655:	48                   	dec    %eax
  801656:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801659:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80165c:	ba 00 00 00 00       	mov    $0x0,%edx
  801661:	f7 75 dc             	divl   -0x24(%ebp)
  801664:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801667:	29 d0                	sub    %edx,%eax
  801669:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  80166c:	a1 40 d0 81 00       	mov    0x81d040,%eax
  801671:	85 c0                	test   %eax,%eax
  801673:	75 0a                	jne    80167f <malloc+0x70>
    {
        uhp_inited = 1;
  801675:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  80167c:	00 00 00 
    }

    int exactIdx = -1;
  80167f:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801686:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80168d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801694:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80169b:	e9 85 00 00 00       	jmp    801725 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8016a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016a3:	89 d0                	mov    %edx,%eax
  8016a5:	01 c0                	add    %eax,%eax
  8016a7:	01 d0                	add    %edx,%eax
  8016a9:	c1 e0 02             	shl    $0x2,%eax
  8016ac:	05 48 10 81 00       	add    $0x811048,%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	84 c0                	test   %al,%al
  8016b5:	74 20                	je     8016d7 <malloc+0xc8>
  8016b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016ba:	89 d0                	mov    %edx,%eax
  8016bc:	01 c0                	add    %eax,%eax
  8016be:	01 d0                	add    %edx,%eax
  8016c0:	c1 e0 02             	shl    $0x2,%eax
  8016c3:	05 44 10 81 00       	add    $0x811044,%eax
  8016c8:	8b 00                	mov    (%eax),%eax
  8016ca:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8016cd:	75 08                	jne    8016d7 <malloc+0xc8>
        {
            exactIdx = i;
  8016cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8016d5:	eb 5b                	jmp    801732 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8016d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016da:	89 d0                	mov    %edx,%eax
  8016dc:	01 c0                	add    %eax,%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	c1 e0 02             	shl    $0x2,%eax
  8016e3:	05 48 10 81 00       	add    $0x811048,%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	84 c0                	test   %al,%al
  8016ec:	74 34                	je     801722 <malloc+0x113>
  8016ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016f1:	89 d0                	mov    %edx,%eax
  8016f3:	01 c0                	add    %eax,%eax
  8016f5:	01 d0                	add    %edx,%eax
  8016f7:	c1 e0 02             	shl    $0x2,%eax
  8016fa:	05 44 10 81 00       	add    $0x811044,%eax
  8016ff:	8b 00                	mov    (%eax),%eax
  801701:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801704:	76 1c                	jbe    801722 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801706:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801709:	89 d0                	mov    %edx,%eax
  80170b:	01 c0                	add    %eax,%eax
  80170d:	01 d0                	add    %edx,%eax
  80170f:	c1 e0 02             	shl    $0x2,%eax
  801712:	05 44 10 81 00       	add    $0x811044,%eax
  801717:	8b 00                	mov    (%eax),%eax
  801719:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80171c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80171f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801722:	ff 45 e8             	incl   -0x18(%ebp)
  801725:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80172c:	0f 8e 6e ff ff ff    	jle    8016a0 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801732:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801739:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80173d:	74 7d                	je     8017bc <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80173f:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801746:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801749:	89 d0                	mov    %edx,%eax
  80174b:	01 c0                	add    %eax,%eax
  80174d:	01 d0                	add    %edx,%eax
  80174f:	c1 e0 02             	shl    $0x2,%eax
  801752:	05 40 10 81 00       	add    $0x811040,%eax
  801757:	8b 10                	mov    (%eax),%edx
  801759:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80175c:	01 d0                	add    %edx,%eax
  80175e:	48                   	dec    %eax
  80175f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801762:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801765:	ba 00 00 00 00       	mov    $0x0,%edx
  80176a:	f7 75 bc             	divl   -0x44(%ebp)
  80176d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801770:	29 d0                	sub    %edx,%eax
  801772:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801775:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801778:	89 d0                	mov    %edx,%eax
  80177a:	01 c0                	add    %eax,%eax
  80177c:	01 d0                	add    %edx,%eax
  80177e:	c1 e0 02             	shl    $0x2,%eax
  801781:	05 48 10 81 00       	add    $0x811048,%eax
  801786:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801789:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178c:	89 d0                	mov    %edx,%eax
  80178e:	01 c0                	add    %eax,%eax
  801790:	01 d0                	add    %edx,%eax
  801792:	c1 e0 02             	shl    $0x2,%eax
  801795:	05 44 10 81 00       	add    $0x811044,%eax
  80179a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8017a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a3:	89 d0                	mov    %edx,%eax
  8017a5:	01 c0                	add    %eax,%eax
  8017a7:	01 d0                	add    %edx,%eax
  8017a9:	c1 e0 02             	shl    $0x2,%eax
  8017ac:	05 40 10 81 00       	add    $0x811040,%eax
  8017b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017b7:	e9 2d 01 00 00       	jmp    8018e9 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8017bc:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8017c0:	0f 84 ce 00 00 00    	je     801894 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8017c6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8017cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d0:	89 d0                	mov    %edx,%eax
  8017d2:	01 c0                	add    %eax,%eax
  8017d4:	01 d0                	add    %edx,%eax
  8017d6:	c1 e0 02             	shl    $0x2,%eax
  8017d9:	05 40 10 81 00       	add    $0x811040,%eax
  8017de:	8b 10                	mov    (%eax),%edx
  8017e0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017e3:	01 d0                	add    %edx,%eax
  8017e5:	48                   	dec    %eax
  8017e6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8017e9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f1:	f7 75 c4             	divl   -0x3c(%ebp)
  8017f4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8017f7:	29 d0                	sub    %edx,%eax
  8017f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8017fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ff:	89 d0                	mov    %edx,%eax
  801801:	01 c0                	add    %eax,%eax
  801803:	01 d0                	add    %edx,%eax
  801805:	c1 e0 02             	shl    $0x2,%eax
  801808:	05 44 10 81 00       	add    $0x811044,%eax
  80180d:	8b 00                	mov    (%eax),%eax
  80180f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801812:	75 47                	jne    80185b <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801814:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801817:	89 d0                	mov    %edx,%eax
  801819:	01 c0                	add    %eax,%eax
  80181b:	01 d0                	add    %edx,%eax
  80181d:	c1 e0 02             	shl    $0x2,%eax
  801820:	05 48 10 81 00       	add    $0x811048,%eax
  801825:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801828:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80182b:	89 d0                	mov    %edx,%eax
  80182d:	01 c0                	add    %eax,%eax
  80182f:	01 d0                	add    %edx,%eax
  801831:	c1 e0 02             	shl    $0x2,%eax
  801834:	05 44 10 81 00       	add    $0x811044,%eax
  801839:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80183f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801842:	89 d0                	mov    %edx,%eax
  801844:	01 c0                	add    %eax,%eax
  801846:	01 d0                	add    %edx,%eax
  801848:	c1 e0 02             	shl    $0x2,%eax
  80184b:	05 40 10 81 00       	add    $0x811040,%eax
  801850:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801856:	e9 8e 00 00 00       	jmp    8018e9 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80185b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80185e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801861:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801864:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801867:	89 d0                	mov    %edx,%eax
  801869:	01 c0                	add    %eax,%eax
  80186b:	01 d0                	add    %edx,%eax
  80186d:	c1 e0 02             	shl    $0x2,%eax
  801870:	05 40 10 81 00       	add    $0x811040,%eax
  801875:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80187a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80187d:	89 c2                	mov    %eax,%edx
  80187f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801882:	89 c8                	mov    %ecx,%eax
  801884:	01 c0                	add    %eax,%eax
  801886:	01 c8                	add    %ecx,%eax
  801888:	c1 e0 02             	shl    $0x2,%eax
  80188b:	05 44 10 81 00       	add    $0x811044,%eax
  801890:	89 10                	mov    %edx,(%eax)
  801892:	eb 55                	jmp    8018e9 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801894:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80189b:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8018a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018a4:	01 d0                	add    %edx,%eax
  8018a6:	48                   	dec    %eax
  8018a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8018aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b2:	f7 75 d0             	divl   -0x30(%ebp)
  8018b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018b8:	29 d0                	sub    %edx,%eax
  8018ba:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8018bd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8018c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018c3:	01 d0                	add    %edx,%eax
  8018c5:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8018ca:	76 0a                	jbe    8018d6 <malloc+0x2c7>
            return NULL;
  8018cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d1:	e9 97 00 00 00       	jmp    80196d <malloc+0x35e>
        va = start;
  8018d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8018d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8018dc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8018df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018e2:	01 d0                	add    %edx,%eax
  8018e4:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8018e9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8018f0:	eb 5e                	jmp    801950 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8018f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018f5:	89 d0                	mov    %edx,%eax
  8018f7:	01 c0                	add    %eax,%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	c1 e0 02             	shl    $0x2,%eax
  8018fe:	05 48 50 80 00       	add    $0x805048,%eax
  801903:	8a 00                	mov    (%eax),%al
  801905:	84 c0                	test   %al,%al
  801907:	75 44                	jne    80194d <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801909:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80190c:	89 d0                	mov    %edx,%eax
  80190e:	01 c0                	add    %eax,%eax
  801910:	01 d0                	add    %edx,%eax
  801912:	c1 e0 02             	shl    $0x2,%eax
  801915:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80191b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80191e:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801920:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801923:	89 d0                	mov    %edx,%eax
  801925:	01 c0                	add    %eax,%eax
  801927:	01 d0                	add    %edx,%eax
  801929:	c1 e0 02             	shl    $0x2,%eax
  80192c:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801932:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801935:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801937:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80193a:	89 d0                	mov    %edx,%eax
  80193c:	01 c0                	add    %eax,%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	c1 e0 02             	shl    $0x2,%eax
  801943:	05 48 50 80 00       	add    $0x805048,%eax
  801948:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80194b:	eb 0c                	jmp    801959 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80194d:	ff 45 e0             	incl   -0x20(%ebp)
  801950:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801957:	7e 99                	jle    8018f2 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80195f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801962:	e8 a2 19 00 00       	call   803309 <sys_allocate_user_mem>
  801967:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  80196a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801975:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801979:	0f 84 fa 03 00 00    	je     801d79 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801985:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801988:	85 c0                	test   %eax,%eax
  80198a:	79 1c                	jns    8019a8 <free+0x39>
  80198c:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801993:	77 13                	ja     8019a8 <free+0x39>
    {
        free_block(virtual_address);
  801995:	83 ec 0c             	sub    $0xc,%esp
  801998:	ff 75 08             	pushl  0x8(%ebp)
  80199b:	e8 09 21 00 00       	call   803aa9 <free_block>
  8019a0:	83 c4 10             	add    $0x10,%esp
        return;
  8019a3:	e9 d2 03 00 00       	jmp    801d7a <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8019a8:	a1 30 51 83 00       	mov    0x835130,%eax
  8019ad:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  8019b0:	72 09                	jb     8019bb <free+0x4c>
  8019b2:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  8019b9:	76 17                	jbe    8019d2 <free+0x63>
        panic("free: invalid address");
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	68 61 48 80 00       	push   $0x804861
  8019c3:	68 9b 00 00 00       	push   $0x9b
  8019c8:	68 18 48 80 00       	push   $0x804818
  8019cd:	e8 41 24 00 00       	call   803e13 <_panic>

    uint32 size = 0;
  8019d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  8019d9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8019e7:	eb 50                	jmp    801a39 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8019e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019ec:	89 d0                	mov    %edx,%eax
  8019ee:	01 c0                	add    %eax,%eax
  8019f0:	01 d0                	add    %edx,%eax
  8019f2:	c1 e0 02             	shl    $0x2,%eax
  8019f5:	05 48 50 80 00       	add    $0x805048,%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	84 c0                	test   %al,%al
  8019fe:	74 36                	je     801a36 <free+0xc7>
  801a00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a03:	89 d0                	mov    %edx,%eax
  801a05:	01 c0                	add    %eax,%eax
  801a07:	01 d0                	add    %edx,%eax
  801a09:	c1 e0 02             	shl    $0x2,%eax
  801a0c:	05 40 50 80 00       	add    $0x805040,%eax
  801a11:	8b 00                	mov    (%eax),%eax
  801a13:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801a16:	75 1e                	jne    801a36 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801a18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a1b:	89 d0                	mov    %edx,%eax
  801a1d:	01 c0                	add    %eax,%eax
  801a1f:	01 d0                	add    %edx,%eax
  801a21:	c1 e0 02             	shl    $0x2,%eax
  801a24:	05 44 50 80 00       	add    $0x805044,%eax
  801a29:	8b 00                	mov    (%eax),%eax
  801a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801a34:	eb 0c                	jmp    801a42 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a36:	ff 45 ec             	incl   -0x14(%ebp)
  801a39:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801a40:	7e a7                	jle    8019e9 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801a42:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801a46:	74 06                	je     801a4e <free+0xdf>
  801a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a4c:	75 17                	jne    801a65 <free+0xf6>
        panic("free: unknown block");
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	68 77 48 80 00       	push   $0x804877
  801a56:	68 a9 00 00 00       	push   $0xa9
  801a5b:	68 18 48 80 00       	push   $0x804818
  801a60:	e8 ae 23 00 00       	call   803e13 <_panic>

    uhp_allocs[idx].used = 0;
  801a65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a68:	89 d0                	mov    %edx,%eax
  801a6a:	01 c0                	add    %eax,%eax
  801a6c:	01 d0                	add    %edx,%eax
  801a6e:	c1 e0 02             	shl    $0x2,%eax
  801a71:	05 48 50 80 00       	add    $0x805048,%eax
  801a76:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801a79:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801a87:	eb 64                	jmp    801aed <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801a89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a8c:	89 d0                	mov    %edx,%eax
  801a8e:	01 c0                	add    %eax,%eax
  801a90:	01 d0                	add    %edx,%eax
  801a92:	c1 e0 02             	shl    $0x2,%eax
  801a95:	05 48 10 81 00       	add    $0x811048,%eax
  801a9a:	8a 00                	mov    (%eax),%al
  801a9c:	84 c0                	test   %al,%al
  801a9e:	75 4a                	jne    801aea <free+0x17b>
        {
            uhp_frees[i].va = va;
  801aa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aa3:	89 d0                	mov    %edx,%eax
  801aa5:	01 c0                	add    %eax,%eax
  801aa7:	01 d0                	add    %edx,%eax
  801aa9:	c1 e0 02             	shl    $0x2,%eax
  801aac:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801ab2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ab5:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801ab7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aba:	89 d0                	mov    %edx,%eax
  801abc:	01 c0                	add    %eax,%eax
  801abe:	01 d0                	add    %edx,%eax
  801ac0:	c1 e0 02             	shl    $0x2,%eax
  801ac3:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acc:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801ace:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ad1:	89 d0                	mov    %edx,%eax
  801ad3:	01 c0                	add    %eax,%eax
  801ad5:	01 d0                	add    %edx,%eax
  801ad7:	c1 e0 02             	shl    $0x2,%eax
  801ada:	05 48 10 81 00       	add    $0x811048,%eax
  801adf:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ae5:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801ae8:	eb 0c                	jmp    801af6 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801aea:	ff 45 e4             	incl   -0x1c(%ebp)
  801aed:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801af4:	7e 93                	jle    801a89 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801af6:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801afa:	0f 84 f1 01 00 00    	je     801cf1 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b00:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b07:	e9 d8 01 00 00       	jmp    801ce4 <free+0x375>
        {
            if (i == fidx) continue;
  801b0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b0f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b12:	0f 84 c8 01 00 00    	je     801ce0 <free+0x371>
            if (uhp_frees[i].free)
  801b18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b1b:	89 d0                	mov    %edx,%eax
  801b1d:	01 c0                	add    %eax,%eax
  801b1f:	01 d0                	add    %edx,%eax
  801b21:	c1 e0 02             	shl    $0x2,%eax
  801b24:	05 48 10 81 00       	add    $0x811048,%eax
  801b29:	8a 00                	mov    (%eax),%al
  801b2b:	84 c0                	test   %al,%al
  801b2d:	0f 84 ae 01 00 00    	je     801ce1 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801b33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b36:	89 d0                	mov    %edx,%eax
  801b38:	01 c0                	add    %eax,%eax
  801b3a:	01 d0                	add    %edx,%eax
  801b3c:	c1 e0 02             	shl    $0x2,%eax
  801b3f:	05 40 10 81 00       	add    $0x811040,%eax
  801b44:	8b 08                	mov    (%eax),%ecx
  801b46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b49:	89 d0                	mov    %edx,%eax
  801b4b:	01 c0                	add    %eax,%eax
  801b4d:	01 d0                	add    %edx,%eax
  801b4f:	c1 e0 02             	shl    $0x2,%eax
  801b52:	05 44 10 81 00       	add    $0x811044,%eax
  801b57:	8b 00                	mov    (%eax),%eax
  801b59:	01 c1                	add    %eax,%ecx
  801b5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b5e:	89 d0                	mov    %edx,%eax
  801b60:	01 c0                	add    %eax,%eax
  801b62:	01 d0                	add    %edx,%eax
  801b64:	c1 e0 02             	shl    $0x2,%eax
  801b67:	05 40 10 81 00       	add    $0x811040,%eax
  801b6c:	8b 00                	mov    (%eax),%eax
  801b6e:	39 c1                	cmp    %eax,%ecx
  801b70:	0f 85 a8 00 00 00    	jne    801c1e <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801b76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b79:	89 d0                	mov    %edx,%eax
  801b7b:	01 c0                	add    %eax,%eax
  801b7d:	01 d0                	add    %edx,%eax
  801b7f:	c1 e0 02             	shl    $0x2,%eax
  801b82:	05 40 10 81 00       	add    $0x811040,%eax
  801b87:	8b 10                	mov    (%eax),%edx
  801b89:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801b8c:	89 c8                	mov    %ecx,%eax
  801b8e:	01 c0                	add    %eax,%eax
  801b90:	01 c8                	add    %ecx,%eax
  801b92:	c1 e0 02             	shl    $0x2,%eax
  801b95:	05 40 10 81 00       	add    $0x811040,%eax
  801b9a:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801b9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b9f:	89 d0                	mov    %edx,%eax
  801ba1:	01 c0                	add    %eax,%eax
  801ba3:	01 d0                	add    %edx,%eax
  801ba5:	c1 e0 02             	shl    $0x2,%eax
  801ba8:	05 44 10 81 00       	add    $0x811044,%eax
  801bad:	8b 08                	mov    (%eax),%ecx
  801baf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bb2:	89 d0                	mov    %edx,%eax
  801bb4:	01 c0                	add    %eax,%eax
  801bb6:	01 d0                	add    %edx,%eax
  801bb8:	c1 e0 02             	shl    $0x2,%eax
  801bbb:	05 44 10 81 00       	add    $0x811044,%eax
  801bc0:	8b 00                	mov    (%eax),%eax
  801bc2:	01 c1                	add    %eax,%ecx
  801bc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bc7:	89 d0                	mov    %edx,%eax
  801bc9:	01 c0                	add    %eax,%eax
  801bcb:	01 d0                	add    %edx,%eax
  801bcd:	c1 e0 02             	shl    $0x2,%eax
  801bd0:	05 44 10 81 00       	add    $0x811044,%eax
  801bd5:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801bd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bda:	89 d0                	mov    %edx,%eax
  801bdc:	01 c0                	add    %eax,%eax
  801bde:	01 d0                	add    %edx,%eax
  801be0:	c1 e0 02             	shl    $0x2,%eax
  801be3:	05 48 10 81 00       	add    $0x811048,%eax
  801be8:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801beb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bee:	89 d0                	mov    %edx,%eax
  801bf0:	01 c0                	add    %eax,%eax
  801bf2:	01 d0                	add    %edx,%eax
  801bf4:	c1 e0 02             	shl    $0x2,%eax
  801bf7:	05 40 10 81 00       	add    $0x811040,%eax
  801bfc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801c02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c05:	89 d0                	mov    %edx,%eax
  801c07:	01 c0                	add    %eax,%eax
  801c09:	01 d0                	add    %edx,%eax
  801c0b:	c1 e0 02             	shl    $0x2,%eax
  801c0e:	05 44 10 81 00       	add    $0x811044,%eax
  801c13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c19:	e9 c3 00 00 00       	jmp    801ce1 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801c1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c21:	89 d0                	mov    %edx,%eax
  801c23:	01 c0                	add    %eax,%eax
  801c25:	01 d0                	add    %edx,%eax
  801c27:	c1 e0 02             	shl    $0x2,%eax
  801c2a:	05 40 10 81 00       	add    $0x811040,%eax
  801c2f:	8b 08                	mov    (%eax),%ecx
  801c31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c34:	89 d0                	mov    %edx,%eax
  801c36:	01 c0                	add    %eax,%eax
  801c38:	01 d0                	add    %edx,%eax
  801c3a:	c1 e0 02             	shl    $0x2,%eax
  801c3d:	05 44 10 81 00       	add    $0x811044,%eax
  801c42:	8b 00                	mov    (%eax),%eax
  801c44:	01 c1                	add    %eax,%ecx
  801c46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c49:	89 d0                	mov    %edx,%eax
  801c4b:	01 c0                	add    %eax,%eax
  801c4d:	01 d0                	add    %edx,%eax
  801c4f:	c1 e0 02             	shl    $0x2,%eax
  801c52:	05 40 10 81 00       	add    $0x811040,%eax
  801c57:	8b 00                	mov    (%eax),%eax
  801c59:	39 c1                	cmp    %eax,%ecx
  801c5b:	0f 85 80 00 00 00    	jne    801ce1 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c64:	89 d0                	mov    %edx,%eax
  801c66:	01 c0                	add    %eax,%eax
  801c68:	01 d0                	add    %edx,%eax
  801c6a:	c1 e0 02             	shl    $0x2,%eax
  801c6d:	05 44 10 81 00       	add    $0x811044,%eax
  801c72:	8b 08                	mov    (%eax),%ecx
  801c74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c77:	89 d0                	mov    %edx,%eax
  801c79:	01 c0                	add    %eax,%eax
  801c7b:	01 d0                	add    %edx,%eax
  801c7d:	c1 e0 02             	shl    $0x2,%eax
  801c80:	05 44 10 81 00       	add    $0x811044,%eax
  801c85:	8b 00                	mov    (%eax),%eax
  801c87:	01 c1                	add    %eax,%ecx
  801c89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c8c:	89 d0                	mov    %edx,%eax
  801c8e:	01 c0                	add    %eax,%eax
  801c90:	01 d0                	add    %edx,%eax
  801c92:	c1 e0 02             	shl    $0x2,%eax
  801c95:	05 44 10 81 00       	add    $0x811044,%eax
  801c9a:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801c9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c9f:	89 d0                	mov    %edx,%eax
  801ca1:	01 c0                	add    %eax,%eax
  801ca3:	01 d0                	add    %edx,%eax
  801ca5:	c1 e0 02             	shl    $0x2,%eax
  801ca8:	05 48 10 81 00       	add    $0x811048,%eax
  801cad:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801cb0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cb3:	89 d0                	mov    %edx,%eax
  801cb5:	01 c0                	add    %eax,%eax
  801cb7:	01 d0                	add    %edx,%eax
  801cb9:	c1 e0 02             	shl    $0x2,%eax
  801cbc:	05 40 10 81 00       	add    $0x811040,%eax
  801cc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801cc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cca:	89 d0                	mov    %edx,%eax
  801ccc:	01 c0                	add    %eax,%eax
  801cce:	01 d0                	add    %edx,%eax
  801cd0:	c1 e0 02             	shl    $0x2,%eax
  801cd3:	05 44 10 81 00       	add    $0x811044,%eax
  801cd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cde:	eb 01                	jmp    801ce1 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801ce0:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ce1:	ff 45 e0             	incl   -0x20(%ebp)
  801ce4:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801ceb:	0f 8e 1b fe ff ff    	jle    801b0c <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801cf1:	a1 30 51 83 00       	mov    0x835130,%eax
  801cf6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801cf9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801d00:	eb 53                	jmp    801d55 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801d02:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d05:	89 d0                	mov    %edx,%eax
  801d07:	01 c0                	add    %eax,%eax
  801d09:	01 d0                	add    %edx,%eax
  801d0b:	c1 e0 02             	shl    $0x2,%eax
  801d0e:	05 48 50 80 00       	add    $0x805048,%eax
  801d13:	8a 00                	mov    (%eax),%al
  801d15:	84 c0                	test   %al,%al
  801d17:	74 39                	je     801d52 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801d19:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d1c:	89 d0                	mov    %edx,%eax
  801d1e:	01 c0                	add    %eax,%eax
  801d20:	01 d0                	add    %edx,%eax
  801d22:	c1 e0 02             	shl    $0x2,%eax
  801d25:	05 40 50 80 00       	add    $0x805040,%eax
  801d2a:	8b 08                	mov    (%eax),%ecx
  801d2c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d2f:	89 d0                	mov    %edx,%eax
  801d31:	01 c0                	add    %eax,%eax
  801d33:	01 d0                	add    %edx,%eax
  801d35:	c1 e0 02             	shl    $0x2,%eax
  801d38:	05 44 50 80 00       	add    $0x805044,%eax
  801d3d:	8b 00                	mov    (%eax),%eax
  801d3f:	01 c8                	add    %ecx,%eax
  801d41:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801d44:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d47:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801d4a:	76 06                	jbe    801d52 <free+0x3e3>
  801d4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d4f:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801d52:	ff 45 d8             	incl   -0x28(%ebp)
  801d55:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801d5c:	7e a4                	jle    801d02 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d61:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801d66:	83 ec 08             	sub    $0x8,%esp
  801d69:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6c:	ff 75 d4             	pushl  -0x2c(%ebp)
  801d6f:	e8 79 15 00 00       	call   8032ed <sys_free_user_mem>
  801d74:	83 c4 10             	add    $0x10,%esp
  801d77:	eb 01                	jmp    801d7a <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801d79:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 68             	sub    $0x68,%esp
  801d82:	8b 45 10             	mov    0x10(%ebp),%eax
  801d85:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801d88:	e8 a5 f7 ff ff       	call   801532 <uheap_init>
	if (size == 0) return NULL ;
  801d8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d91:	75 0a                	jne    801d9d <smalloc+0x21>
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
  801d98:	e9 37 03 00 00       	jmp    8020d4 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801d9d:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801da4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801daa:	01 d0                	add    %edx,%eax
  801dac:	48                   	dec    %eax
  801dad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801db0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801db3:	ba 00 00 00 00       	mov    $0x0,%edx
  801db8:	f7 75 dc             	divl   -0x24(%ebp)
  801dbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dbe:	29 d0                	sub    %edx,%eax
  801dc0:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801dc3:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801dca:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801dd1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801dd8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ddf:	e9 85 00 00 00       	jmp    801e69 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801de4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801de7:	89 d0                	mov    %edx,%eax
  801de9:	01 c0                	add    %eax,%eax
  801deb:	01 d0                	add    %edx,%eax
  801ded:	c1 e0 02             	shl    $0x2,%eax
  801df0:	05 48 10 81 00       	add    $0x811048,%eax
  801df5:	8a 00                	mov    (%eax),%al
  801df7:	84 c0                	test   %al,%al
  801df9:	74 20                	je     801e1b <smalloc+0x9f>
  801dfb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dfe:	89 d0                	mov    %edx,%eax
  801e00:	01 c0                	add    %eax,%eax
  801e02:	01 d0                	add    %edx,%eax
  801e04:	c1 e0 02             	shl    $0x2,%eax
  801e07:	05 44 10 81 00       	add    $0x811044,%eax
  801e0c:	8b 00                	mov    (%eax),%eax
  801e0e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e11:	75 08                	jne    801e1b <smalloc+0x9f>
        {
            exactIdx = i;
  801e13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801e19:	eb 5b                	jmp    801e76 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801e1b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e1e:	89 d0                	mov    %edx,%eax
  801e20:	01 c0                	add    %eax,%eax
  801e22:	01 d0                	add    %edx,%eax
  801e24:	c1 e0 02             	shl    $0x2,%eax
  801e27:	05 48 10 81 00       	add    $0x811048,%eax
  801e2c:	8a 00                	mov    (%eax),%al
  801e2e:	84 c0                	test   %al,%al
  801e30:	74 34                	je     801e66 <smalloc+0xea>
  801e32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e35:	89 d0                	mov    %edx,%eax
  801e37:	01 c0                	add    %eax,%eax
  801e39:	01 d0                	add    %edx,%eax
  801e3b:	c1 e0 02             	shl    $0x2,%eax
  801e3e:	05 44 10 81 00       	add    $0x811044,%eax
  801e43:	8b 00                	mov    (%eax),%eax
  801e45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e48:	76 1c                	jbe    801e66 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801e4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e4d:	89 d0                	mov    %edx,%eax
  801e4f:	01 c0                	add    %eax,%eax
  801e51:	01 d0                	add    %edx,%eax
  801e53:	c1 e0 02             	shl    $0x2,%eax
  801e56:	05 44 10 81 00       	add    $0x811044,%eax
  801e5b:	8b 00                	mov    (%eax),%eax
  801e5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e63:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e66:	ff 45 e8             	incl   -0x18(%ebp)
  801e69:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801e70:	0f 8e 6e ff ff ff    	jle    801de4 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801e76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801e7d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801e81:	74 7d                	je     801f00 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801e83:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801e8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e8d:	89 d0                	mov    %edx,%eax
  801e8f:	01 c0                	add    %eax,%eax
  801e91:	01 d0                	add    %edx,%eax
  801e93:	c1 e0 02             	shl    $0x2,%eax
  801e96:	05 40 10 81 00       	add    $0x811040,%eax
  801e9b:	8b 10                	mov    (%eax),%edx
  801e9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801ea0:	01 d0                	add    %edx,%eax
  801ea2:	48                   	dec    %eax
  801ea3:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801ea6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ea9:	ba 00 00 00 00       	mov    $0x0,%edx
  801eae:	f7 75 bc             	divl   -0x44(%ebp)
  801eb1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801eb4:	29 d0                	sub    %edx,%eax
  801eb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ebc:	89 d0                	mov    %edx,%eax
  801ebe:	01 c0                	add    %eax,%eax
  801ec0:	01 d0                	add    %edx,%eax
  801ec2:	c1 e0 02             	shl    $0x2,%eax
  801ec5:	05 48 10 81 00       	add    $0x811048,%eax
  801eca:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed0:	89 d0                	mov    %edx,%eax
  801ed2:	01 c0                	add    %eax,%eax
  801ed4:	01 d0                	add    %edx,%eax
  801ed6:	c1 e0 02             	shl    $0x2,%eax
  801ed9:	05 44 10 81 00       	add    $0x811044,%eax
  801ede:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee7:	89 d0                	mov    %edx,%eax
  801ee9:	01 c0                	add    %eax,%eax
  801eeb:	01 d0                	add    %edx,%eax
  801eed:	c1 e0 02             	shl    $0x2,%eax
  801ef0:	05 40 10 81 00       	add    $0x811040,%eax
  801ef5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801efb:	e9 2d 01 00 00       	jmp    80202d <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801f00:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f04:	0f 84 ce 00 00 00    	je     801fd8 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801f0a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801f11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f14:	89 d0                	mov    %edx,%eax
  801f16:	01 c0                	add    %eax,%eax
  801f18:	01 d0                	add    %edx,%eax
  801f1a:	c1 e0 02             	shl    $0x2,%eax
  801f1d:	05 40 10 81 00       	add    $0x811040,%eax
  801f22:	8b 10                	mov    (%eax),%edx
  801f24:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f27:	01 d0                	add    %edx,%eax
  801f29:	48                   	dec    %eax
  801f2a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801f2d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f30:	ba 00 00 00 00       	mov    $0x0,%edx
  801f35:	f7 75 c4             	divl   -0x3c(%ebp)
  801f38:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f3b:	29 d0                	sub    %edx,%eax
  801f3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801f40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f43:	89 d0                	mov    %edx,%eax
  801f45:	01 c0                	add    %eax,%eax
  801f47:	01 d0                	add    %edx,%eax
  801f49:	c1 e0 02             	shl    $0x2,%eax
  801f4c:	05 44 10 81 00       	add    $0x811044,%eax
  801f51:	8b 00                	mov    (%eax),%eax
  801f53:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f56:	75 47                	jne    801f9f <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801f58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f5b:	89 d0                	mov    %edx,%eax
  801f5d:	01 c0                	add    %eax,%eax
  801f5f:	01 d0                	add    %edx,%eax
  801f61:	c1 e0 02             	shl    $0x2,%eax
  801f64:	05 48 10 81 00       	add    $0x811048,%eax
  801f69:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801f6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f6f:	89 d0                	mov    %edx,%eax
  801f71:	01 c0                	add    %eax,%eax
  801f73:	01 d0                	add    %edx,%eax
  801f75:	c1 e0 02             	shl    $0x2,%eax
  801f78:	05 44 10 81 00       	add    $0x811044,%eax
  801f7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801f83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f86:	89 d0                	mov    %edx,%eax
  801f88:	01 c0                	add    %eax,%eax
  801f8a:	01 d0                	add    %edx,%eax
  801f8c:	c1 e0 02             	shl    $0x2,%eax
  801f8f:	05 40 10 81 00       	add    $0x811040,%eax
  801f94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f9a:	e9 8e 00 00 00       	jmp    80202d <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801f9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fa2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fa5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801fa8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fab:	89 d0                	mov    %edx,%eax
  801fad:	01 c0                	add    %eax,%eax
  801faf:	01 d0                	add    %edx,%eax
  801fb1:	c1 e0 02             	shl    $0x2,%eax
  801fb4:	05 40 10 81 00       	add    $0x811040,%eax
  801fb9:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbe:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801fc1:	89 c2                	mov    %eax,%edx
  801fc3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801fc6:	89 c8                	mov    %ecx,%eax
  801fc8:	01 c0                	add    %eax,%eax
  801fca:	01 c8                	add    %ecx,%eax
  801fcc:	c1 e0 02             	shl    $0x2,%eax
  801fcf:	05 44 10 81 00       	add    $0x811044,%eax
  801fd4:	89 10                	mov    %edx,(%eax)
  801fd6:	eb 55                	jmp    80202d <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801fd8:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801fdf:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801fe5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801fe8:	01 d0                	add    %edx,%eax
  801fea:	48                   	dec    %eax
  801feb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801fee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ff1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff6:	f7 75 d0             	divl   -0x30(%ebp)
  801ff9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ffc:	29 d0                	sub    %edx,%eax
  801ffe:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802001:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802004:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802007:	01 d0                	add    %edx,%eax
  802009:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80200e:	76 0a                	jbe    80201a <smalloc+0x29e>
            return NULL;
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
  802015:	e9 ba 00 00 00       	jmp    8020d4 <smalloc+0x358>
        va = start;
  80201a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80201d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802020:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802023:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802026:	01 d0                	add    %edx,%eax
  802028:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80202d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802034:	eb 5e                	jmp    802094 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802036:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802039:	89 d0                	mov    %edx,%eax
  80203b:	01 c0                	add    %eax,%eax
  80203d:	01 d0                	add    %edx,%eax
  80203f:	c1 e0 02             	shl    $0x2,%eax
  802042:	05 48 50 80 00       	add    $0x805048,%eax
  802047:	8a 00                	mov    (%eax),%al
  802049:	84 c0                	test   %al,%al
  80204b:	75 44                	jne    802091 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80204d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802050:	89 d0                	mov    %edx,%eax
  802052:	01 c0                	add    %eax,%eax
  802054:	01 d0                	add    %edx,%eax
  802056:	c1 e0 02             	shl    $0x2,%eax
  802059:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80205f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802062:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802064:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802067:	89 d0                	mov    %edx,%eax
  802069:	01 c0                	add    %eax,%eax
  80206b:	01 d0                	add    %edx,%eax
  80206d:	c1 e0 02             	shl    $0x2,%eax
  802070:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802076:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802079:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80207b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80207e:	89 d0                	mov    %edx,%eax
  802080:	01 c0                	add    %eax,%eax
  802082:	01 d0                	add    %edx,%eax
  802084:	c1 e0 02             	shl    $0x2,%eax
  802087:	05 48 50 80 00       	add    $0x805048,%eax
  80208c:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80208f:	eb 0c                	jmp    80209d <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802091:	ff 45 e0             	incl   -0x20(%ebp)
  802094:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80209b:	7e 99                	jle    802036 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80209d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020a0:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8020a4:	52                   	push   %edx
  8020a5:	50                   	push   %eax
  8020a6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8020a9:	ff 75 08             	pushl  0x8(%ebp)
  8020ac:	e8 de 0e 00 00       	call   802f8f <sys_create_shared_object>
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8020b7:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8020bb:	75 07                	jne    8020c4 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8020bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020c2:	eb 10                	jmp    8020d4 <smalloc+0x358>
    if (r < 0)
  8020c4:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8020c8:	79 07                	jns    8020d1 <smalloc+0x355>
        return NULL;
  8020ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cf:	eb 03                	jmp    8020d4 <smalloc+0x358>
    return (void*)va;
  8020d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8020dc:	e8 51 f4 ff ff       	call   801532 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8020e1:	83 ec 08             	sub    $0x8,%esp
  8020e4:	ff 75 0c             	pushl  0xc(%ebp)
  8020e7:	ff 75 08             	pushl  0x8(%ebp)
  8020ea:	e8 ca 0e 00 00       	call   802fb9 <sys_size_of_shared_object>
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8020f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8020f9:	7f 0a                	jg     802105 <sget+0x2f>
        return NULL;
  8020fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802100:	e9 28 03 00 00       	jmp    80242d <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802105:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80210c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80210f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802112:	01 d0                	add    %edx,%eax
  802114:	48                   	dec    %eax
  802115:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802118:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80211b:	ba 00 00 00 00       	mov    $0x0,%edx
  802120:	f7 75 d8             	divl   -0x28(%ebp)
  802123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802126:	29 d0                	sub    %edx,%eax
  802128:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80212b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802132:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802139:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802140:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802147:	e9 85 00 00 00       	jmp    8021d1 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80214c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80214f:	89 d0                	mov    %edx,%eax
  802151:	01 c0                	add    %eax,%eax
  802153:	01 d0                	add    %edx,%eax
  802155:	c1 e0 02             	shl    $0x2,%eax
  802158:	05 48 10 81 00       	add    $0x811048,%eax
  80215d:	8a 00                	mov    (%eax),%al
  80215f:	84 c0                	test   %al,%al
  802161:	74 20                	je     802183 <sget+0xad>
  802163:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802166:	89 d0                	mov    %edx,%eax
  802168:	01 c0                	add    %eax,%eax
  80216a:	01 d0                	add    %edx,%eax
  80216c:	c1 e0 02             	shl    $0x2,%eax
  80216f:	05 44 10 81 00       	add    $0x811044,%eax
  802174:	8b 00                	mov    (%eax),%eax
  802176:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802179:	75 08                	jne    802183 <sget+0xad>
        {
            exactIdx = i;
  80217b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80217e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802181:	eb 5b                	jmp    8021de <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802183:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802186:	89 d0                	mov    %edx,%eax
  802188:	01 c0                	add    %eax,%eax
  80218a:	01 d0                	add    %edx,%eax
  80218c:	c1 e0 02             	shl    $0x2,%eax
  80218f:	05 48 10 81 00       	add    $0x811048,%eax
  802194:	8a 00                	mov    (%eax),%al
  802196:	84 c0                	test   %al,%al
  802198:	74 34                	je     8021ce <sget+0xf8>
  80219a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80219d:	89 d0                	mov    %edx,%eax
  80219f:	01 c0                	add    %eax,%eax
  8021a1:	01 d0                	add    %edx,%eax
  8021a3:	c1 e0 02             	shl    $0x2,%eax
  8021a6:	05 44 10 81 00       	add    $0x811044,%eax
  8021ab:	8b 00                	mov    (%eax),%eax
  8021ad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021b0:	76 1c                	jbe    8021ce <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8021b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021b5:	89 d0                	mov    %edx,%eax
  8021b7:	01 c0                	add    %eax,%eax
  8021b9:	01 d0                	add    %edx,%eax
  8021bb:	c1 e0 02             	shl    $0x2,%eax
  8021be:	05 44 10 81 00       	add    $0x811044,%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8021c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8021ce:	ff 45 e8             	incl   -0x18(%ebp)
  8021d1:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8021d8:	0f 8e 6e ff ff ff    	jle    80214c <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8021de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8021e5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8021e9:	74 7d                	je     802268 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8021eb:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8021f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f5:	89 d0                	mov    %edx,%eax
  8021f7:	01 c0                	add    %eax,%eax
  8021f9:	01 d0                	add    %edx,%eax
  8021fb:	c1 e0 02             	shl    $0x2,%eax
  8021fe:	05 40 10 81 00       	add    $0x811040,%eax
  802203:	8b 10                	mov    (%eax),%edx
  802205:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802208:	01 d0                	add    %edx,%eax
  80220a:	48                   	dec    %eax
  80220b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80220e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802211:	ba 00 00 00 00       	mov    $0x0,%edx
  802216:	f7 75 b8             	divl   -0x48(%ebp)
  802219:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80221c:	29 d0                	sub    %edx,%eax
  80221e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802224:	89 d0                	mov    %edx,%eax
  802226:	01 c0                	add    %eax,%eax
  802228:	01 d0                	add    %edx,%eax
  80222a:	c1 e0 02             	shl    $0x2,%eax
  80222d:	05 48 10 81 00       	add    $0x811048,%eax
  802232:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802235:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802238:	89 d0                	mov    %edx,%eax
  80223a:	01 c0                	add    %eax,%eax
  80223c:	01 d0                	add    %edx,%eax
  80223e:	c1 e0 02             	shl    $0x2,%eax
  802241:	05 44 10 81 00       	add    $0x811044,%eax
  802246:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80224c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224f:	89 d0                	mov    %edx,%eax
  802251:	01 c0                	add    %eax,%eax
  802253:	01 d0                	add    %edx,%eax
  802255:	c1 e0 02             	shl    $0x2,%eax
  802258:	05 40 10 81 00       	add    $0x811040,%eax
  80225d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802263:	e9 2d 01 00 00       	jmp    802395 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802268:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80226c:	0f 84 ce 00 00 00    	je     802340 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802272:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802279:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80227c:	89 d0                	mov    %edx,%eax
  80227e:	01 c0                	add    %eax,%eax
  802280:	01 d0                	add    %edx,%eax
  802282:	c1 e0 02             	shl    $0x2,%eax
  802285:	05 40 10 81 00       	add    $0x811040,%eax
  80228a:	8b 10                	mov    (%eax),%edx
  80228c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80228f:	01 d0                	add    %edx,%eax
  802291:	48                   	dec    %eax
  802292:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802295:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802298:	ba 00 00 00 00       	mov    $0x0,%edx
  80229d:	f7 75 c0             	divl   -0x40(%ebp)
  8022a0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022a3:	29 d0                	sub    %edx,%eax
  8022a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8022a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ab:	89 d0                	mov    %edx,%eax
  8022ad:	01 c0                	add    %eax,%eax
  8022af:	01 d0                	add    %edx,%eax
  8022b1:	c1 e0 02             	shl    $0x2,%eax
  8022b4:	05 44 10 81 00       	add    $0x811044,%eax
  8022b9:	8b 00                	mov    (%eax),%eax
  8022bb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8022be:	75 47                	jne    802307 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8022c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c3:	89 d0                	mov    %edx,%eax
  8022c5:	01 c0                	add    %eax,%eax
  8022c7:	01 d0                	add    %edx,%eax
  8022c9:	c1 e0 02             	shl    $0x2,%eax
  8022cc:	05 48 10 81 00       	add    $0x811048,%eax
  8022d1:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8022d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d7:	89 d0                	mov    %edx,%eax
  8022d9:	01 c0                	add    %eax,%eax
  8022db:	01 d0                	add    %edx,%eax
  8022dd:	c1 e0 02             	shl    $0x2,%eax
  8022e0:	05 44 10 81 00       	add    $0x811044,%eax
  8022e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8022eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ee:	89 d0                	mov    %edx,%eax
  8022f0:	01 c0                	add    %eax,%eax
  8022f2:	01 d0                	add    %edx,%eax
  8022f4:	c1 e0 02             	shl    $0x2,%eax
  8022f7:	05 40 10 81 00       	add    $0x811040,%eax
  8022fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802302:	e9 8e 00 00 00       	jmp    802395 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802307:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80230a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80230d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802310:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802313:	89 d0                	mov    %edx,%eax
  802315:	01 c0                	add    %eax,%eax
  802317:	01 d0                	add    %edx,%eax
  802319:	c1 e0 02             	shl    $0x2,%eax
  80231c:	05 40 10 81 00       	add    $0x811040,%eax
  802321:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802323:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802326:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802329:	89 c2                	mov    %eax,%edx
  80232b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80232e:	89 c8                	mov    %ecx,%eax
  802330:	01 c0                	add    %eax,%eax
  802332:	01 c8                	add    %ecx,%eax
  802334:	c1 e0 02             	shl    $0x2,%eax
  802337:	05 44 10 81 00       	add    $0x811044,%eax
  80233c:	89 10                	mov    %edx,(%eax)
  80233e:	eb 55                	jmp    802395 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802340:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802347:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80234d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802350:	01 d0                	add    %edx,%eax
  802352:	48                   	dec    %eax
  802353:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802356:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802359:	ba 00 00 00 00       	mov    $0x0,%edx
  80235e:	f7 75 cc             	divl   -0x34(%ebp)
  802361:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802364:	29 d0                	sub    %edx,%eax
  802366:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802369:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80236c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80236f:	01 d0                	add    %edx,%eax
  802371:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802376:	76 0a                	jbe    802382 <sget+0x2ac>
            return NULL;
  802378:	b8 00 00 00 00       	mov    $0x0,%eax
  80237d:	e9 ab 00 00 00       	jmp    80242d <sget+0x357>
        va = start;
  802382:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802385:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802388:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80238b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80238e:	01 d0                	add    %edx,%eax
  802390:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802395:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80239c:	eb 5e                	jmp    8023fc <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  80239e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023a1:	89 d0                	mov    %edx,%eax
  8023a3:	01 c0                	add    %eax,%eax
  8023a5:	01 d0                	add    %edx,%eax
  8023a7:	c1 e0 02             	shl    $0x2,%eax
  8023aa:	05 48 50 80 00       	add    $0x805048,%eax
  8023af:	8a 00                	mov    (%eax),%al
  8023b1:	84 c0                	test   %al,%al
  8023b3:	75 44                	jne    8023f9 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8023b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023b8:	89 d0                	mov    %edx,%eax
  8023ba:	01 c0                	add    %eax,%eax
  8023bc:	01 d0                	add    %edx,%eax
  8023be:	c1 e0 02             	shl    $0x2,%eax
  8023c1:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8023c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ca:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8023cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023cf:	89 d0                	mov    %edx,%eax
  8023d1:	01 c0                	add    %eax,%eax
  8023d3:	01 d0                	add    %edx,%eax
  8023d5:	c1 e0 02             	shl    $0x2,%eax
  8023d8:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8023de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023e1:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8023e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023e6:	89 d0                	mov    %edx,%eax
  8023e8:	01 c0                	add    %eax,%eax
  8023ea:	01 d0                	add    %edx,%eax
  8023ec:	c1 e0 02             	shl    $0x2,%eax
  8023ef:	05 48 50 80 00       	add    $0x805048,%eax
  8023f4:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8023f7:	eb 0c                	jmp    802405 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8023f9:	ff 45 e0             	incl   -0x20(%ebp)
  8023fc:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802403:	7e 99                	jle    80239e <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802405:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802408:	83 ec 04             	sub    $0x4,%esp
  80240b:	50                   	push   %eax
  80240c:	ff 75 0c             	pushl  0xc(%ebp)
  80240f:	ff 75 08             	pushl  0x8(%ebp)
  802412:	e8 bf 0b 00 00       	call   802fd6 <sys_get_shared_object>
  802417:	83 c4 10             	add    $0x10,%esp
  80241a:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  80241d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802421:	79 07                	jns    80242a <sget+0x354>
        return NULL;
  802423:	b8 00 00 00 00       	mov    $0x0,%eax
  802428:	eb 03                	jmp    80242d <sget+0x357>
    return (void*)va;
  80242a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802435:	e8 f8 f0 ff ff       	call   801532 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  80243a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80243e:	75 13                	jne    802453 <realloc+0x24>
		return malloc(new_size);
  802440:	83 ec 0c             	sub    $0xc,%esp
  802443:	ff 75 0c             	pushl  0xc(%ebp)
  802446:	e8 c4 f1 ff ff       	call   80160f <malloc>
  80244b:	83 c4 10             	add    $0x10,%esp
  80244e:	e9 f4 05 00 00       	jmp    802a47 <realloc+0x618>
	if (new_size == 0)
  802453:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802457:	75 18                	jne    802471 <realloc+0x42>
	{
		free(virtual_address);
  802459:	83 ec 0c             	sub    $0xc,%esp
  80245c:	ff 75 08             	pushl  0x8(%ebp)
  80245f:	e8 0b f5 ff ff       	call   80196f <free>
  802464:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802467:	b8 00 00 00 00       	mov    $0x0,%eax
  80246c:	e9 d6 05 00 00       	jmp    802a47 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802471:	8b 45 08             	mov    0x8(%ebp),%eax
  802474:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802477:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	79 74                	jns    8024f2 <realloc+0xc3>
  80247e:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802485:	77 6b                	ja     8024f2 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802487:	83 ec 0c             	sub    $0xc,%esp
  80248a:	ff 75 0c             	pushl  0xc(%ebp)
  80248d:	e8 7d f1 ff ff       	call   80160f <malloc>
  802492:	83 c4 10             	add    $0x10,%esp
  802495:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802498:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80249c:	75 0a                	jne    8024a8 <realloc+0x79>
			return NULL;
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a3:	e9 9f 05 00 00       	jmp    802a47 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8024a8:	83 ec 0c             	sub    $0xc,%esp
  8024ab:	ff 75 08             	pushl  0x8(%ebp)
  8024ae:	e8 e0 11 00 00       	call   803693 <get_block_size>
  8024b3:	83 c4 10             	add    $0x10,%esp
  8024b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8024b9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8024bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bf:	39 d0                	cmp    %edx,%eax
  8024c1:	76 02                	jbe    8024c5 <realloc+0x96>
  8024c3:	89 d0                	mov    %edx,%eax
  8024c5:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8024c8:	83 ec 04             	sub    $0x4,%esp
  8024cb:	ff 75 c0             	pushl  -0x40(%ebp)
  8024ce:	ff 75 08             	pushl  0x8(%ebp)
  8024d1:	ff 75 c8             	pushl  -0x38(%ebp)
  8024d4:	e8 56 eb ff ff       	call   80102f <memmove>
  8024d9:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8024dc:	83 ec 0c             	sub    $0xc,%esp
  8024df:	ff 75 08             	pushl  0x8(%ebp)
  8024e2:	e8 88 f4 ff ff       	call   80196f <free>
  8024e7:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8024ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024ed:	e9 55 05 00 00       	jmp    802a47 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8024f2:	a1 30 51 83 00       	mov    0x835130,%eax
  8024f7:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8024fa:	72 09                	jb     802505 <realloc+0xd6>
  8024fc:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802503:	76 0a                	jbe    80250f <realloc+0xe0>
		return NULL;
  802505:	b8 00 00 00 00       	mov    $0x0,%eax
  80250a:	e9 38 05 00 00       	jmp    802a47 <realloc+0x618>
	uint32 oldsz = 0;
  80250f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802516:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80251d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802524:	eb 50                	jmp    802576 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802526:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802529:	89 d0                	mov    %edx,%eax
  80252b:	01 c0                	add    %eax,%eax
  80252d:	01 d0                	add    %edx,%eax
  80252f:	c1 e0 02             	shl    $0x2,%eax
  802532:	05 48 50 80 00       	add    $0x805048,%eax
  802537:	8a 00                	mov    (%eax),%al
  802539:	84 c0                	test   %al,%al
  80253b:	74 36                	je     802573 <realloc+0x144>
  80253d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802540:	89 d0                	mov    %edx,%eax
  802542:	01 c0                	add    %eax,%eax
  802544:	01 d0                	add    %edx,%eax
  802546:	c1 e0 02             	shl    $0x2,%eax
  802549:	05 40 50 80 00       	add    $0x805040,%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802553:	75 1e                	jne    802573 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802555:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802558:	89 d0                	mov    %edx,%eax
  80255a:	01 c0                	add    %eax,%eax
  80255c:	01 d0                	add    %edx,%eax
  80255e:	c1 e0 02             	shl    $0x2,%eax
  802561:	05 44 50 80 00       	add    $0x805044,%eax
  802566:	8b 00                	mov    (%eax),%eax
  802568:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  80256b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802571:	eb 0c                	jmp    80257f <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802573:	ff 45 ec             	incl   -0x14(%ebp)
  802576:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80257d:	7e a7                	jle    802526 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  80257f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802583:	75 0a                	jne    80258f <realloc+0x160>
		return NULL;
  802585:	b8 00 00 00 00       	mov    $0x0,%eax
  80258a:	e9 b8 04 00 00       	jmp    802a47 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  80258f:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802596:	8b 55 0c             	mov    0xc(%ebp),%edx
  802599:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80259c:	01 d0                	add    %edx,%eax
  80259e:	48                   	dec    %eax
  80259f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8025a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8025a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8025aa:	f7 75 bc             	divl   -0x44(%ebp)
  8025ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8025b0:	29 d0                	sub    %edx,%eax
  8025b2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8025b5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8025b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025bb:	75 08                	jne    8025c5 <realloc+0x196>
		return virtual_address;
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	e9 82 04 00 00       	jmp    802a47 <realloc+0x618>
	if (req < oldsz)
  8025c5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8025c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025cb:	0f 83 cd 02 00 00    	jae    80289e <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8025d7:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8025da:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8025dd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8025e0:	01 d0                	add    %edx,%eax
  8025e2:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8025e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e8:	89 d0                	mov    %edx,%eax
  8025ea:	01 c0                	add    %eax,%eax
  8025ec:	01 d0                	add    %edx,%eax
  8025ee:	c1 e0 02             	shl    $0x2,%eax
  8025f1:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8025f7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8025fa:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8025fc:	83 ec 08             	sub    $0x8,%esp
  8025ff:	ff 75 b0             	pushl  -0x50(%ebp)
  802602:	ff 75 ac             	pushl  -0x54(%ebp)
  802605:	e8 e3 0c 00 00       	call   8032ed <sys_free_user_mem>
  80260a:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  80260d:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802614:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80261b:	eb 64                	jmp    802681 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  80261d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802620:	89 d0                	mov    %edx,%eax
  802622:	01 c0                	add    %eax,%eax
  802624:	01 d0                	add    %edx,%eax
  802626:	c1 e0 02             	shl    $0x2,%eax
  802629:	05 48 10 81 00       	add    $0x811048,%eax
  80262e:	8a 00                	mov    (%eax),%al
  802630:	84 c0                	test   %al,%al
  802632:	75 4a                	jne    80267e <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802634:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802637:	89 d0                	mov    %edx,%eax
  802639:	01 c0                	add    %eax,%eax
  80263b:	01 d0                	add    %edx,%eax
  80263d:	c1 e0 02             	shl    $0x2,%eax
  802640:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802646:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802649:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  80264b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80264e:	89 d0                	mov    %edx,%eax
  802650:	01 c0                	add    %eax,%eax
  802652:	01 d0                	add    %edx,%eax
  802654:	c1 e0 02             	shl    $0x2,%eax
  802657:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  80265d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802660:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802662:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802665:	89 d0                	mov    %edx,%eax
  802667:	01 c0                	add    %eax,%eax
  802669:	01 d0                	add    %edx,%eax
  80266b:	c1 e0 02             	shl    $0x2,%eax
  80266e:	05 48 10 81 00       	add    $0x811048,%eax
  802673:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802679:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  80267c:	eb 0c                	jmp    80268a <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80267e:	ff 45 e4             	incl   -0x1c(%ebp)
  802681:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802688:	7e 93                	jle    80261d <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  80268a:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80268e:	0f 84 8d 01 00 00    	je     802821 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802694:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80269b:	e9 74 01 00 00       	jmp    802814 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8026a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026a6:	0f 84 64 01 00 00    	je     802810 <realloc+0x3e1>
				if (uhp_frees[k].free)
  8026ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026af:	89 d0                	mov    %edx,%eax
  8026b1:	01 c0                	add    %eax,%eax
  8026b3:	01 d0                	add    %edx,%eax
  8026b5:	c1 e0 02             	shl    $0x2,%eax
  8026b8:	05 48 10 81 00       	add    $0x811048,%eax
  8026bd:	8a 00                	mov    (%eax),%al
  8026bf:	84 c0                	test   %al,%al
  8026c1:	0f 84 4a 01 00 00    	je     802811 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8026c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ca:	89 d0                	mov    %edx,%eax
  8026cc:	01 c0                	add    %eax,%eax
  8026ce:	01 d0                	add    %edx,%eax
  8026d0:	c1 e0 02             	shl    $0x2,%eax
  8026d3:	05 40 10 81 00       	add    $0x811040,%eax
  8026d8:	8b 08                	mov    (%eax),%ecx
  8026da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026dd:	89 d0                	mov    %edx,%eax
  8026df:	01 c0                	add    %eax,%eax
  8026e1:	01 d0                	add    %edx,%eax
  8026e3:	c1 e0 02             	shl    $0x2,%eax
  8026e6:	05 44 10 81 00       	add    $0x811044,%eax
  8026eb:	8b 00                	mov    (%eax),%eax
  8026ed:	01 c1                	add    %eax,%ecx
  8026ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026f2:	89 d0                	mov    %edx,%eax
  8026f4:	01 c0                	add    %eax,%eax
  8026f6:	01 d0                	add    %edx,%eax
  8026f8:	c1 e0 02             	shl    $0x2,%eax
  8026fb:	05 40 10 81 00       	add    $0x811040,%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	39 c1                	cmp    %eax,%ecx
  802704:	75 7a                	jne    802780 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802706:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802709:	89 d0                	mov    %edx,%eax
  80270b:	01 c0                	add    %eax,%eax
  80270d:	01 d0                	add    %edx,%eax
  80270f:	c1 e0 02             	shl    $0x2,%eax
  802712:	05 40 10 81 00       	add    $0x811040,%eax
  802717:	8b 10                	mov    (%eax),%edx
  802719:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80271c:	89 c8                	mov    %ecx,%eax
  80271e:	01 c0                	add    %eax,%eax
  802720:	01 c8                	add    %ecx,%eax
  802722:	c1 e0 02             	shl    $0x2,%eax
  802725:	05 40 10 81 00       	add    $0x811040,%eax
  80272a:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  80272c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80272f:	89 d0                	mov    %edx,%eax
  802731:	01 c0                	add    %eax,%eax
  802733:	01 d0                	add    %edx,%eax
  802735:	c1 e0 02             	shl    $0x2,%eax
  802738:	05 44 10 81 00       	add    $0x811044,%eax
  80273d:	8b 08                	mov    (%eax),%ecx
  80273f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802742:	89 d0                	mov    %edx,%eax
  802744:	01 c0                	add    %eax,%eax
  802746:	01 d0                	add    %edx,%eax
  802748:	c1 e0 02             	shl    $0x2,%eax
  80274b:	05 44 10 81 00       	add    $0x811044,%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	01 c1                	add    %eax,%ecx
  802754:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802757:	89 d0                	mov    %edx,%eax
  802759:	01 c0                	add    %eax,%eax
  80275b:	01 d0                	add    %edx,%eax
  80275d:	c1 e0 02             	shl    $0x2,%eax
  802760:	05 44 10 81 00       	add    $0x811044,%eax
  802765:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802767:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80276a:	89 d0                	mov    %edx,%eax
  80276c:	01 c0                	add    %eax,%eax
  80276e:	01 d0                	add    %edx,%eax
  802770:	c1 e0 02             	shl    $0x2,%eax
  802773:	05 48 10 81 00       	add    $0x811048,%eax
  802778:	c6 00 00             	movb   $0x0,(%eax)
  80277b:	e9 91 00 00 00       	jmp    802811 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802780:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802783:	89 d0                	mov    %edx,%eax
  802785:	01 c0                	add    %eax,%eax
  802787:	01 d0                	add    %edx,%eax
  802789:	c1 e0 02             	shl    $0x2,%eax
  80278c:	05 40 10 81 00       	add    $0x811040,%eax
  802791:	8b 08                	mov    (%eax),%ecx
  802793:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802796:	89 d0                	mov    %edx,%eax
  802798:	01 c0                	add    %eax,%eax
  80279a:	01 d0                	add    %edx,%eax
  80279c:	c1 e0 02             	shl    $0x2,%eax
  80279f:	05 44 10 81 00       	add    $0x811044,%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	01 c1                	add    %eax,%ecx
  8027a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027ab:	89 d0                	mov    %edx,%eax
  8027ad:	01 c0                	add    %eax,%eax
  8027af:	01 d0                	add    %edx,%eax
  8027b1:	c1 e0 02             	shl    $0x2,%eax
  8027b4:	05 40 10 81 00       	add    $0x811040,%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	39 c1                	cmp    %eax,%ecx
  8027bd:	75 52                	jne    802811 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8027bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027c2:	89 d0                	mov    %edx,%eax
  8027c4:	01 c0                	add    %eax,%eax
  8027c6:	01 d0                	add    %edx,%eax
  8027c8:	c1 e0 02             	shl    $0x2,%eax
  8027cb:	05 44 10 81 00       	add    $0x811044,%eax
  8027d0:	8b 08                	mov    (%eax),%ecx
  8027d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027d5:	89 d0                	mov    %edx,%eax
  8027d7:	01 c0                	add    %eax,%eax
  8027d9:	01 d0                	add    %edx,%eax
  8027db:	c1 e0 02             	shl    $0x2,%eax
  8027de:	05 44 10 81 00       	add    $0x811044,%eax
  8027e3:	8b 00                	mov    (%eax),%eax
  8027e5:	01 c1                	add    %eax,%ecx
  8027e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ea:	89 d0                	mov    %edx,%eax
  8027ec:	01 c0                	add    %eax,%eax
  8027ee:	01 d0                	add    %edx,%eax
  8027f0:	c1 e0 02             	shl    $0x2,%eax
  8027f3:	05 44 10 81 00       	add    $0x811044,%eax
  8027f8:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8027fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027fd:	89 d0                	mov    %edx,%eax
  8027ff:	01 c0                	add    %eax,%eax
  802801:	01 d0                	add    %edx,%eax
  802803:	c1 e0 02             	shl    $0x2,%eax
  802806:	05 48 10 81 00       	add    $0x811048,%eax
  80280b:	c6 00 00             	movb   $0x0,(%eax)
  80280e:	eb 01                	jmp    802811 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802810:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802811:	ff 45 e0             	incl   -0x20(%ebp)
  802814:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80281b:	0f 8e 7f fe ff ff    	jle    8026a0 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802821:	a1 30 51 83 00       	mov    0x835130,%eax
  802826:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802829:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802830:	eb 53                	jmp    802885 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802832:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802835:	89 d0                	mov    %edx,%eax
  802837:	01 c0                	add    %eax,%eax
  802839:	01 d0                	add    %edx,%eax
  80283b:	c1 e0 02             	shl    $0x2,%eax
  80283e:	05 48 50 80 00       	add    $0x805048,%eax
  802843:	8a 00                	mov    (%eax),%al
  802845:	84 c0                	test   %al,%al
  802847:	74 39                	je     802882 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802849:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80284c:	89 d0                	mov    %edx,%eax
  80284e:	01 c0                	add    %eax,%eax
  802850:	01 d0                	add    %edx,%eax
  802852:	c1 e0 02             	shl    $0x2,%eax
  802855:	05 40 50 80 00       	add    $0x805040,%eax
  80285a:	8b 08                	mov    (%eax),%ecx
  80285c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80285f:	89 d0                	mov    %edx,%eax
  802861:	01 c0                	add    %eax,%eax
  802863:	01 d0                	add    %edx,%eax
  802865:	c1 e0 02             	shl    $0x2,%eax
  802868:	05 44 50 80 00       	add    $0x805044,%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	01 c8                	add    %ecx,%eax
  802871:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802874:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802877:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80287a:	76 06                	jbe    802882 <realloc+0x453>
  80287c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80287f:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802882:	ff 45 d8             	incl   -0x28(%ebp)
  802885:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80288c:	7e a4                	jle    802832 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  80288e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802891:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	e9 a9 01 00 00       	jmp    802a47 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  80289e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	01 d0                	add    %edx,%eax
  8028a6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8028a9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8028b0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8028b7:	eb 57                	jmp    802910 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8028b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028bc:	89 d0                	mov    %edx,%eax
  8028be:	01 c0                	add    %eax,%eax
  8028c0:	01 d0                	add    %edx,%eax
  8028c2:	c1 e0 02             	shl    $0x2,%eax
  8028c5:	05 48 10 81 00       	add    $0x811048,%eax
  8028ca:	8a 00                	mov    (%eax),%al
  8028cc:	84 c0                	test   %al,%al
  8028ce:	74 3d                	je     80290d <realloc+0x4de>
  8028d0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028d3:	89 d0                	mov    %edx,%eax
  8028d5:	01 c0                	add    %eax,%eax
  8028d7:	01 d0                	add    %edx,%eax
  8028d9:	c1 e0 02             	shl    $0x2,%eax
  8028dc:	05 40 10 81 00       	add    $0x811040,%eax
  8028e1:	8b 00                	mov    (%eax),%eax
  8028e3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028e6:	75 25                	jne    80290d <realloc+0x4de>
  8028e8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028eb:	89 d0                	mov    %edx,%eax
  8028ed:	01 c0                	add    %eax,%eax
  8028ef:	01 d0                	add    %edx,%eax
  8028f1:	c1 e0 02             	shl    $0x2,%eax
  8028f4:	05 44 10 81 00       	add    $0x811044,%eax
  8028f9:	8b 10                	mov    (%eax),%edx
  8028fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028fe:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802901:	39 c2                	cmp    %eax,%edx
  802903:	72 08                	jb     80290d <realloc+0x4de>
		{
			adjIdx = j; break;
  802905:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802908:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80290b:	eb 0c                	jmp    802919 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80290d:	ff 45 d0             	incl   -0x30(%ebp)
  802910:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802917:	7e a0                	jle    8028b9 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802919:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  80291d:	0f 84 d6 00 00 00    	je     8029f9 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802923:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802926:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802929:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  80292c:	83 ec 08             	sub    $0x8,%esp
  80292f:	ff 75 a0             	pushl  -0x60(%ebp)
  802932:	ff 75 a4             	pushl  -0x5c(%ebp)
  802935:	e8 cf 09 00 00       	call   803309 <sys_allocate_user_mem>
  80293a:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  80293d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802940:	89 d0                	mov    %edx,%eax
  802942:	01 c0                	add    %eax,%eax
  802944:	01 d0                	add    %edx,%eax
  802946:	c1 e0 02             	shl    $0x2,%eax
  802949:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80294f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802952:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802954:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802957:	89 d0                	mov    %edx,%eax
  802959:	01 c0                	add    %eax,%eax
  80295b:	01 d0                	add    %edx,%eax
  80295d:	c1 e0 02             	shl    $0x2,%eax
  802960:	05 40 10 81 00       	add    $0x811040,%eax
  802965:	8b 10                	mov    (%eax),%edx
  802967:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80296a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80296d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802970:	89 d0                	mov    %edx,%eax
  802972:	01 c0                	add    %eax,%eax
  802974:	01 d0                	add    %edx,%eax
  802976:	c1 e0 02             	shl    $0x2,%eax
  802979:	05 40 10 81 00       	add    $0x811040,%eax
  80297e:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802980:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802983:	89 d0                	mov    %edx,%eax
  802985:	01 c0                	add    %eax,%eax
  802987:	01 d0                	add    %edx,%eax
  802989:	c1 e0 02             	shl    $0x2,%eax
  80298c:	05 44 10 81 00       	add    $0x811044,%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802996:	89 c2                	mov    %eax,%edx
  802998:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80299b:	89 c8                	mov    %ecx,%eax
  80299d:	01 c0                	add    %eax,%eax
  80299f:	01 c8                	add    %ecx,%eax
  8029a1:	c1 e0 02             	shl    $0x2,%eax
  8029a4:	05 44 10 81 00       	add    $0x811044,%eax
  8029a9:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  8029ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029ae:	89 d0                	mov    %edx,%eax
  8029b0:	01 c0                	add    %eax,%eax
  8029b2:	01 d0                	add    %edx,%eax
  8029b4:	c1 e0 02             	shl    $0x2,%eax
  8029b7:	05 44 10 81 00       	add    $0x811044,%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	75 14                	jne    8029d6 <realloc+0x5a7>
  8029c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029c5:	89 d0                	mov    %edx,%eax
  8029c7:	01 c0                	add    %eax,%eax
  8029c9:	01 d0                	add    %edx,%eax
  8029cb:	c1 e0 02             	shl    $0x2,%eax
  8029ce:	05 48 10 81 00       	add    $0x811048,%eax
  8029d3:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  8029d6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029d9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029dc:	01 c2                	add    %eax,%edx
  8029de:	a1 88 50 83 00       	mov    0x835088,%eax
  8029e3:	39 c2                	cmp    %eax,%edx
  8029e5:	76 0d                	jbe    8029f4 <realloc+0x5c5>
  8029e7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029ea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029ed:	01 d0                	add    %edx,%eax
  8029ef:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	eb 4e                	jmp    802a47 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  8029f9:	83 ec 0c             	sub    $0xc,%esp
  8029fc:	ff 75 0c             	pushl  0xc(%ebp)
  8029ff:	e8 0b ec ff ff       	call   80160f <malloc>
  802a04:	83 c4 10             	add    $0x10,%esp
  802a07:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802a0a:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802a0e:	75 07                	jne    802a17 <realloc+0x5e8>
		return NULL;
  802a10:	b8 00 00 00 00       	mov    $0x0,%eax
  802a15:	eb 30                	jmp    802a47 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a1d:	39 d0                	cmp    %edx,%eax
  802a1f:	76 02                	jbe    802a23 <realloc+0x5f4>
  802a21:	89 d0                	mov    %edx,%eax
  802a23:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802a26:	83 ec 04             	sub    $0x4,%esp
  802a29:	50                   	push   %eax
  802a2a:	52                   	push   %edx
  802a2b:	ff 75 cc             	pushl  -0x34(%ebp)
  802a2e:	e8 cf 06 00 00       	call   803102 <sys_move_user_mem>
  802a33:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802a36:	83 ec 0c             	sub    $0xc,%esp
  802a39:	ff 75 08             	pushl  0x8(%ebp)
  802a3c:	e8 2e ef ff ff       	call   80196f <free>
  802a41:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802a44:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802a47:	c9                   	leave  
  802a48:	c3                   	ret    

00802a49 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802a49:	55                   	push   %ebp
  802a4a:	89 e5                	mov    %esp,%ebp
  802a4c:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802a55:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a59:	0f 84 33 03 00 00    	je     802d92 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802a5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a62:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802a67:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802a6a:	83 ec 08             	sub    $0x8,%esp
  802a6d:	ff 75 08             	pushl  0x8(%ebp)
  802a70:	ff 75 d8             	pushl  -0x28(%ebp)
  802a73:	e8 7d 05 00 00       	call   802ff5 <sys_delete_shared_object>
  802a78:	83 c4 10             	add    $0x10,%esp
  802a7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802a7e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802a82:	0f 88 0d 03 00 00    	js     802d95 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a8f:	e9 ef 02 00 00       	jmp    802d83 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802a94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a97:	89 d0                	mov    %edx,%eax
  802a99:	01 c0                	add    %eax,%eax
  802a9b:	01 d0                	add    %edx,%eax
  802a9d:	c1 e0 02             	shl    $0x2,%eax
  802aa0:	05 48 50 80 00       	add    $0x805048,%eax
  802aa5:	8a 00                	mov    (%eax),%al
  802aa7:	84 c0                	test   %al,%al
  802aa9:	0f 84 d1 02 00 00    	je     802d80 <sfree+0x337>
  802aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab2:	89 d0                	mov    %edx,%eax
  802ab4:	01 c0                	add    %eax,%eax
  802ab6:	01 d0                	add    %edx,%eax
  802ab8:	c1 e0 02             	shl    $0x2,%eax
  802abb:	05 40 50 80 00       	add    $0x805040,%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802ac5:	0f 85 b5 02 00 00    	jne    802d80 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ace:	89 d0                	mov    %edx,%eax
  802ad0:	01 c0                	add    %eax,%eax
  802ad2:	01 d0                	add    %edx,%eax
  802ad4:	c1 e0 02             	shl    $0x2,%eax
  802ad7:	05 44 50 80 00       	add    $0x805044,%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae4:	89 d0                	mov    %edx,%eax
  802ae6:	01 c0                	add    %eax,%eax
  802ae8:	01 d0                	add    %edx,%eax
  802aea:	c1 e0 02             	shl    $0x2,%eax
  802aed:	05 48 50 80 00       	add    $0x805048,%eax
  802af2:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802af5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802afc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802b03:	eb 64                	jmp    802b69 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802b05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b08:	89 d0                	mov    %edx,%eax
  802b0a:	01 c0                	add    %eax,%eax
  802b0c:	01 d0                	add    %edx,%eax
  802b0e:	c1 e0 02             	shl    $0x2,%eax
  802b11:	05 48 10 81 00       	add    $0x811048,%eax
  802b16:	8a 00                	mov    (%eax),%al
  802b18:	84 c0                	test   %al,%al
  802b1a:	75 4a                	jne    802b66 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802b1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1f:	89 d0                	mov    %edx,%eax
  802b21:	01 c0                	add    %eax,%eax
  802b23:	01 d0                	add    %edx,%eax
  802b25:	c1 e0 02             	shl    $0x2,%eax
  802b28:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802b2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b31:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802b33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b36:	89 d0                	mov    %edx,%eax
  802b38:	01 c0                	add    %eax,%eax
  802b3a:	01 d0                	add    %edx,%eax
  802b3c:	c1 e0 02             	shl    $0x2,%eax
  802b3f:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802b45:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b48:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802b4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b4d:	89 d0                	mov    %edx,%eax
  802b4f:	01 c0                	add    %eax,%eax
  802b51:	01 d0                	add    %edx,%eax
  802b53:	c1 e0 02             	shl    $0x2,%eax
  802b56:	05 48 10 81 00       	add    $0x811048,%eax
  802b5b:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802b64:	eb 0c                	jmp    802b72 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b66:	ff 45 ec             	incl   -0x14(%ebp)
  802b69:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802b70:	7e 93                	jle    802b05 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802b72:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b76:	0f 84 8d 01 00 00    	je     802d09 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802b7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802b83:	e9 74 01 00 00       	jmp    802cfc <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b8e:	0f 84 64 01 00 00    	je     802cf8 <sfree+0x2af>
					if (uhp_frees[k].free)
  802b94:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b97:	89 d0                	mov    %edx,%eax
  802b99:	01 c0                	add    %eax,%eax
  802b9b:	01 d0                	add    %edx,%eax
  802b9d:	c1 e0 02             	shl    $0x2,%eax
  802ba0:	05 48 10 81 00       	add    $0x811048,%eax
  802ba5:	8a 00                	mov    (%eax),%al
  802ba7:	84 c0                	test   %al,%al
  802ba9:	0f 84 4a 01 00 00    	je     802cf9 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802baf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb2:	89 d0                	mov    %edx,%eax
  802bb4:	01 c0                	add    %eax,%eax
  802bb6:	01 d0                	add    %edx,%eax
  802bb8:	c1 e0 02             	shl    $0x2,%eax
  802bbb:	05 40 10 81 00       	add    $0x811040,%eax
  802bc0:	8b 08                	mov    (%eax),%ecx
  802bc2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bc5:	89 d0                	mov    %edx,%eax
  802bc7:	01 c0                	add    %eax,%eax
  802bc9:	01 d0                	add    %edx,%eax
  802bcb:	c1 e0 02             	shl    $0x2,%eax
  802bce:	05 44 10 81 00       	add    $0x811044,%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	01 c1                	add    %eax,%ecx
  802bd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bda:	89 d0                	mov    %edx,%eax
  802bdc:	01 c0                	add    %eax,%eax
  802bde:	01 d0                	add    %edx,%eax
  802be0:	c1 e0 02             	shl    $0x2,%eax
  802be3:	05 40 10 81 00       	add    $0x811040,%eax
  802be8:	8b 00                	mov    (%eax),%eax
  802bea:	39 c1                	cmp    %eax,%ecx
  802bec:	75 7a                	jne    802c68 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802bee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bf1:	89 d0                	mov    %edx,%eax
  802bf3:	01 c0                	add    %eax,%eax
  802bf5:	01 d0                	add    %edx,%eax
  802bf7:	c1 e0 02             	shl    $0x2,%eax
  802bfa:	05 40 10 81 00       	add    $0x811040,%eax
  802bff:	8b 10                	mov    (%eax),%edx
  802c01:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c04:	89 c8                	mov    %ecx,%eax
  802c06:	01 c0                	add    %eax,%eax
  802c08:	01 c8                	add    %ecx,%eax
  802c0a:	c1 e0 02             	shl    $0x2,%eax
  802c0d:	05 40 10 81 00       	add    $0x811040,%eax
  802c12:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802c14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c17:	89 d0                	mov    %edx,%eax
  802c19:	01 c0                	add    %eax,%eax
  802c1b:	01 d0                	add    %edx,%eax
  802c1d:	c1 e0 02             	shl    $0x2,%eax
  802c20:	05 44 10 81 00       	add    $0x811044,%eax
  802c25:	8b 08                	mov    (%eax),%ecx
  802c27:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c2a:	89 d0                	mov    %edx,%eax
  802c2c:	01 c0                	add    %eax,%eax
  802c2e:	01 d0                	add    %edx,%eax
  802c30:	c1 e0 02             	shl    $0x2,%eax
  802c33:	05 44 10 81 00       	add    $0x811044,%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	01 c1                	add    %eax,%ecx
  802c3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3f:	89 d0                	mov    %edx,%eax
  802c41:	01 c0                	add    %eax,%eax
  802c43:	01 d0                	add    %edx,%eax
  802c45:	c1 e0 02             	shl    $0x2,%eax
  802c48:	05 44 10 81 00       	add    $0x811044,%eax
  802c4d:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802c4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c52:	89 d0                	mov    %edx,%eax
  802c54:	01 c0                	add    %eax,%eax
  802c56:	01 d0                	add    %edx,%eax
  802c58:	c1 e0 02             	shl    $0x2,%eax
  802c5b:	05 48 10 81 00       	add    $0x811048,%eax
  802c60:	c6 00 00             	movb   $0x0,(%eax)
  802c63:	e9 91 00 00 00       	jmp    802cf9 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802c68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c6b:	89 d0                	mov    %edx,%eax
  802c6d:	01 c0                	add    %eax,%eax
  802c6f:	01 d0                	add    %edx,%eax
  802c71:	c1 e0 02             	shl    $0x2,%eax
  802c74:	05 40 10 81 00       	add    $0x811040,%eax
  802c79:	8b 08                	mov    (%eax),%ecx
  802c7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7e:	89 d0                	mov    %edx,%eax
  802c80:	01 c0                	add    %eax,%eax
  802c82:	01 d0                	add    %edx,%eax
  802c84:	c1 e0 02             	shl    $0x2,%eax
  802c87:	05 44 10 81 00       	add    $0x811044,%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	01 c1                	add    %eax,%ecx
  802c90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c93:	89 d0                	mov    %edx,%eax
  802c95:	01 c0                	add    %eax,%eax
  802c97:	01 d0                	add    %edx,%eax
  802c99:	c1 e0 02             	shl    $0x2,%eax
  802c9c:	05 40 10 81 00       	add    $0x811040,%eax
  802ca1:	8b 00                	mov    (%eax),%eax
  802ca3:	39 c1                	cmp    %eax,%ecx
  802ca5:	75 52                	jne    802cf9 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802ca7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802caa:	89 d0                	mov    %edx,%eax
  802cac:	01 c0                	add    %eax,%eax
  802cae:	01 d0                	add    %edx,%eax
  802cb0:	c1 e0 02             	shl    $0x2,%eax
  802cb3:	05 44 10 81 00       	add    $0x811044,%eax
  802cb8:	8b 08                	mov    (%eax),%ecx
  802cba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cbd:	89 d0                	mov    %edx,%eax
  802cbf:	01 c0                	add    %eax,%eax
  802cc1:	01 d0                	add    %edx,%eax
  802cc3:	c1 e0 02             	shl    $0x2,%eax
  802cc6:	05 44 10 81 00       	add    $0x811044,%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	01 c1                	add    %eax,%ecx
  802ccf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd2:	89 d0                	mov    %edx,%eax
  802cd4:	01 c0                	add    %eax,%eax
  802cd6:	01 d0                	add    %edx,%eax
  802cd8:	c1 e0 02             	shl    $0x2,%eax
  802cdb:	05 44 10 81 00       	add    $0x811044,%eax
  802ce0:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802ce2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ce5:	89 d0                	mov    %edx,%eax
  802ce7:	01 c0                	add    %eax,%eax
  802ce9:	01 d0                	add    %edx,%eax
  802ceb:	c1 e0 02             	shl    $0x2,%eax
  802cee:	05 48 10 81 00       	add    $0x811048,%eax
  802cf3:	c6 00 00             	movb   $0x0,(%eax)
  802cf6:	eb 01                	jmp    802cf9 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802cf8:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802cf9:	ff 45 e8             	incl   -0x18(%ebp)
  802cfc:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802d03:	0f 8e 7f fe ff ff    	jle    802b88 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802d09:	a1 30 51 83 00       	mov    0x835130,%eax
  802d0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802d11:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802d18:	eb 53                	jmp    802d6d <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802d1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d1d:	89 d0                	mov    %edx,%eax
  802d1f:	01 c0                	add    %eax,%eax
  802d21:	01 d0                	add    %edx,%eax
  802d23:	c1 e0 02             	shl    $0x2,%eax
  802d26:	05 48 50 80 00       	add    $0x805048,%eax
  802d2b:	8a 00                	mov    (%eax),%al
  802d2d:	84 c0                	test   %al,%al
  802d2f:	74 39                	je     802d6a <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802d31:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d34:	89 d0                	mov    %edx,%eax
  802d36:	01 c0                	add    %eax,%eax
  802d38:	01 d0                	add    %edx,%eax
  802d3a:	c1 e0 02             	shl    $0x2,%eax
  802d3d:	05 40 50 80 00       	add    $0x805040,%eax
  802d42:	8b 08                	mov    (%eax),%ecx
  802d44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d47:	89 d0                	mov    %edx,%eax
  802d49:	01 c0                	add    %eax,%eax
  802d4b:	01 d0                	add    %edx,%eax
  802d4d:	c1 e0 02             	shl    $0x2,%eax
  802d50:	05 44 50 80 00       	add    $0x805044,%eax
  802d55:	8b 00                	mov    (%eax),%eax
  802d57:	01 c8                	add    %ecx,%eax
  802d59:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802d5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d5f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d62:	76 06                	jbe    802d6a <sfree+0x321>
  802d64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802d6a:	ff 45 e0             	incl   -0x20(%ebp)
  802d6d:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802d74:	7e a4                	jle    802d1a <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d79:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802d7e:	eb 16                	jmp    802d96 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802d80:	ff 45 f4             	incl   -0xc(%ebp)
  802d83:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802d8a:	0f 8e 04 fd ff ff    	jle    802a94 <sfree+0x4b>
  802d90:	eb 04                	jmp    802d96 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802d92:	90                   	nop
  802d93:	eb 01                	jmp    802d96 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802d95:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802d96:	c9                   	leave  
  802d97:	c3                   	ret    

00802d98 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d98:	55                   	push   %ebp
  802d99:	89 e5                	mov    %esp,%ebp
  802d9b:	57                   	push   %edi
  802d9c:	56                   	push   %esi
  802d9d:	53                   	push   %ebx
  802d9e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802daa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802dad:	8b 7d 18             	mov    0x18(%ebp),%edi
  802db0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802db3:	cd 30                	int    $0x30
  802db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802dbb:	83 c4 10             	add    $0x10,%esp
  802dbe:	5b                   	pop    %ebx
  802dbf:	5e                   	pop    %esi
  802dc0:	5f                   	pop    %edi
  802dc1:	5d                   	pop    %ebp
  802dc2:	c3                   	ret    

00802dc3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802dc3:	55                   	push   %ebp
  802dc4:	89 e5                	mov    %esp,%ebp
  802dc6:	83 ec 04             	sub    $0x4,%esp
  802dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  802dcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802dcf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802dd2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	6a 00                	push   $0x0
  802ddb:	51                   	push   %ecx
  802ddc:	52                   	push   %edx
  802ddd:	ff 75 0c             	pushl  0xc(%ebp)
  802de0:	50                   	push   %eax
  802de1:	6a 00                	push   $0x0
  802de3:	e8 b0 ff ff ff       	call   802d98 <syscall>
  802de8:	83 c4 18             	add    $0x18,%esp
}
  802deb:	90                   	nop
  802dec:	c9                   	leave  
  802ded:	c3                   	ret    

00802dee <sys_cgetc>:

int
sys_cgetc(void)
{
  802dee:	55                   	push   %ebp
  802def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802df1:	6a 00                	push   $0x0
  802df3:	6a 00                	push   $0x0
  802df5:	6a 00                	push   $0x0
  802df7:	6a 00                	push   $0x0
  802df9:	6a 00                	push   $0x0
  802dfb:	6a 02                	push   $0x2
  802dfd:	e8 96 ff ff ff       	call   802d98 <syscall>
  802e02:	83 c4 18             	add    $0x18,%esp
}
  802e05:	c9                   	leave  
  802e06:	c3                   	ret    

00802e07 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802e07:	55                   	push   %ebp
  802e08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802e0a:	6a 00                	push   $0x0
  802e0c:	6a 00                	push   $0x0
  802e0e:	6a 00                	push   $0x0
  802e10:	6a 00                	push   $0x0
  802e12:	6a 00                	push   $0x0
  802e14:	6a 03                	push   $0x3
  802e16:	e8 7d ff ff ff       	call   802d98 <syscall>
  802e1b:	83 c4 18             	add    $0x18,%esp
}
  802e1e:	90                   	nop
  802e1f:	c9                   	leave  
  802e20:	c3                   	ret    

00802e21 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802e21:	55                   	push   %ebp
  802e22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802e24:	6a 00                	push   $0x0
  802e26:	6a 00                	push   $0x0
  802e28:	6a 00                	push   $0x0
  802e2a:	6a 00                	push   $0x0
  802e2c:	6a 00                	push   $0x0
  802e2e:	6a 04                	push   $0x4
  802e30:	e8 63 ff ff ff       	call   802d98 <syscall>
  802e35:	83 c4 18             	add    $0x18,%esp
}
  802e38:	90                   	nop
  802e39:	c9                   	leave  
  802e3a:	c3                   	ret    

00802e3b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802e3b:	55                   	push   %ebp
  802e3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	6a 00                	push   $0x0
  802e46:	6a 00                	push   $0x0
  802e48:	6a 00                	push   $0x0
  802e4a:	52                   	push   %edx
  802e4b:	50                   	push   %eax
  802e4c:	6a 08                	push   $0x8
  802e4e:	e8 45 ff ff ff       	call   802d98 <syscall>
  802e53:	83 c4 18             	add    $0x18,%esp
}
  802e56:	c9                   	leave  
  802e57:	c3                   	ret    

00802e58 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802e58:	55                   	push   %ebp
  802e59:	89 e5                	mov    %esp,%ebp
  802e5b:	56                   	push   %esi
  802e5c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802e5d:	8b 75 18             	mov    0x18(%ebp),%esi
  802e60:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e66:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	56                   	push   %esi
  802e6d:	53                   	push   %ebx
  802e6e:	51                   	push   %ecx
  802e6f:	52                   	push   %edx
  802e70:	50                   	push   %eax
  802e71:	6a 09                	push   $0x9
  802e73:	e8 20 ff ff ff       	call   802d98 <syscall>
  802e78:	83 c4 18             	add    $0x18,%esp
}
  802e7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e7e:	5b                   	pop    %ebx
  802e7f:	5e                   	pop    %esi
  802e80:	5d                   	pop    %ebp
  802e81:	c3                   	ret    

00802e82 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802e82:	55                   	push   %ebp
  802e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802e85:	6a 00                	push   $0x0
  802e87:	6a 00                	push   $0x0
  802e89:	6a 00                	push   $0x0
  802e8b:	6a 00                	push   $0x0
  802e8d:	ff 75 08             	pushl  0x8(%ebp)
  802e90:	6a 0a                	push   $0xa
  802e92:	e8 01 ff ff ff       	call   802d98 <syscall>
  802e97:	83 c4 18             	add    $0x18,%esp
}
  802e9a:	c9                   	leave  
  802e9b:	c3                   	ret    

00802e9c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802e9c:	55                   	push   %ebp
  802e9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802e9f:	6a 00                	push   $0x0
  802ea1:	6a 00                	push   $0x0
  802ea3:	6a 00                	push   $0x0
  802ea5:	ff 75 0c             	pushl  0xc(%ebp)
  802ea8:	ff 75 08             	pushl  0x8(%ebp)
  802eab:	6a 0b                	push   $0xb
  802ead:	e8 e6 fe ff ff       	call   802d98 <syscall>
  802eb2:	83 c4 18             	add    $0x18,%esp
}
  802eb5:	c9                   	leave  
  802eb6:	c3                   	ret    

00802eb7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802eb7:	55                   	push   %ebp
  802eb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 00                	push   $0x0
  802ebe:	6a 00                	push   $0x0
  802ec0:	6a 00                	push   $0x0
  802ec2:	6a 00                	push   $0x0
  802ec4:	6a 0c                	push   $0xc
  802ec6:	e8 cd fe ff ff       	call   802d98 <syscall>
  802ecb:	83 c4 18             	add    $0x18,%esp
}
  802ece:	c9                   	leave  
  802ecf:	c3                   	ret    

00802ed0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802ed0:	55                   	push   %ebp
  802ed1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802ed3:	6a 00                	push   $0x0
  802ed5:	6a 00                	push   $0x0
  802ed7:	6a 00                	push   $0x0
  802ed9:	6a 00                	push   $0x0
  802edb:	6a 00                	push   $0x0
  802edd:	6a 0d                	push   $0xd
  802edf:	e8 b4 fe ff ff       	call   802d98 <syscall>
  802ee4:	83 c4 18             	add    $0x18,%esp
}
  802ee7:	c9                   	leave  
  802ee8:	c3                   	ret    

00802ee9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ee9:	55                   	push   %ebp
  802eea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802eec:	6a 00                	push   $0x0
  802eee:	6a 00                	push   $0x0
  802ef0:	6a 00                	push   $0x0
  802ef2:	6a 00                	push   $0x0
  802ef4:	6a 00                	push   $0x0
  802ef6:	6a 0e                	push   $0xe
  802ef8:	e8 9b fe ff ff       	call   802d98 <syscall>
  802efd:	83 c4 18             	add    $0x18,%esp
}
  802f00:	c9                   	leave  
  802f01:	c3                   	ret    

00802f02 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802f02:	55                   	push   %ebp
  802f03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 00                	push   $0x0
  802f0f:	6a 0f                	push   $0xf
  802f11:	e8 82 fe ff ff       	call   802d98 <syscall>
  802f16:	83 c4 18             	add    $0x18,%esp
}
  802f19:	c9                   	leave  
  802f1a:	c3                   	ret    

00802f1b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802f1b:	55                   	push   %ebp
  802f1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802f1e:	6a 00                	push   $0x0
  802f20:	6a 00                	push   $0x0
  802f22:	6a 00                	push   $0x0
  802f24:	6a 00                	push   $0x0
  802f26:	ff 75 08             	pushl  0x8(%ebp)
  802f29:	6a 10                	push   $0x10
  802f2b:	e8 68 fe ff ff       	call   802d98 <syscall>
  802f30:	83 c4 18             	add    $0x18,%esp
}
  802f33:	c9                   	leave  
  802f34:	c3                   	ret    

00802f35 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802f35:	55                   	push   %ebp
  802f36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 00                	push   $0x0
  802f3e:	6a 00                	push   $0x0
  802f40:	6a 00                	push   $0x0
  802f42:	6a 11                	push   $0x11
  802f44:	e8 4f fe ff ff       	call   802d98 <syscall>
  802f49:	83 c4 18             	add    $0x18,%esp
}
  802f4c:	90                   	nop
  802f4d:	c9                   	leave  
  802f4e:	c3                   	ret    

00802f4f <sys_cputc>:

void
sys_cputc(const char c)
{
  802f4f:	55                   	push   %ebp
  802f50:	89 e5                	mov    %esp,%ebp
  802f52:	83 ec 04             	sub    $0x4,%esp
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802f5b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f5f:	6a 00                	push   $0x0
  802f61:	6a 00                	push   $0x0
  802f63:	6a 00                	push   $0x0
  802f65:	6a 00                	push   $0x0
  802f67:	50                   	push   %eax
  802f68:	6a 01                	push   $0x1
  802f6a:	e8 29 fe ff ff       	call   802d98 <syscall>
  802f6f:	83 c4 18             	add    $0x18,%esp
}
  802f72:	90                   	nop
  802f73:	c9                   	leave  
  802f74:	c3                   	ret    

00802f75 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802f75:	55                   	push   %ebp
  802f76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802f78:	6a 00                	push   $0x0
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	6a 14                	push   $0x14
  802f84:	e8 0f fe ff ff       	call   802d98 <syscall>
  802f89:	83 c4 18             	add    $0x18,%esp
}
  802f8c:	90                   	nop
  802f8d:	c9                   	leave  
  802f8e:	c3                   	ret    

00802f8f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802f8f:	55                   	push   %ebp
  802f90:	89 e5                	mov    %esp,%ebp
  802f92:	83 ec 04             	sub    $0x4,%esp
  802f95:	8b 45 10             	mov    0x10(%ebp),%eax
  802f98:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802f9b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f9e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	6a 00                	push   $0x0
  802fa7:	51                   	push   %ecx
  802fa8:	52                   	push   %edx
  802fa9:	ff 75 0c             	pushl  0xc(%ebp)
  802fac:	50                   	push   %eax
  802fad:	6a 15                	push   $0x15
  802faf:	e8 e4 fd ff ff       	call   802d98 <syscall>
  802fb4:	83 c4 18             	add    $0x18,%esp
}
  802fb7:	c9                   	leave  
  802fb8:	c3                   	ret    

00802fb9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802fb9:	55                   	push   %ebp
  802fba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	6a 00                	push   $0x0
  802fc4:	6a 00                	push   $0x0
  802fc6:	6a 00                	push   $0x0
  802fc8:	52                   	push   %edx
  802fc9:	50                   	push   %eax
  802fca:	6a 16                	push   $0x16
  802fcc:	e8 c7 fd ff ff       	call   802d98 <syscall>
  802fd1:	83 c4 18             	add    $0x18,%esp
}
  802fd4:	c9                   	leave  
  802fd5:	c3                   	ret    

00802fd6 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802fd6:	55                   	push   %ebp
  802fd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802fd9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	6a 00                	push   $0x0
  802fe4:	6a 00                	push   $0x0
  802fe6:	51                   	push   %ecx
  802fe7:	52                   	push   %edx
  802fe8:	50                   	push   %eax
  802fe9:	6a 17                	push   $0x17
  802feb:	e8 a8 fd ff ff       	call   802d98 <syscall>
  802ff0:	83 c4 18             	add    $0x18,%esp
}
  802ff3:	c9                   	leave  
  802ff4:	c3                   	ret    

00802ff5 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802ff5:	55                   	push   %ebp
  802ff6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	6a 00                	push   $0x0
  803000:	6a 00                	push   $0x0
  803002:	6a 00                	push   $0x0
  803004:	52                   	push   %edx
  803005:	50                   	push   %eax
  803006:	6a 18                	push   $0x18
  803008:	e8 8b fd ff ff       	call   802d98 <syscall>
  80300d:	83 c4 18             	add    $0x18,%esp
}
  803010:	c9                   	leave  
  803011:	c3                   	ret    

00803012 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803012:	55                   	push   %ebp
  803013:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	6a 00                	push   $0x0
  80301a:	ff 75 14             	pushl  0x14(%ebp)
  80301d:	ff 75 10             	pushl  0x10(%ebp)
  803020:	ff 75 0c             	pushl  0xc(%ebp)
  803023:	50                   	push   %eax
  803024:	6a 19                	push   $0x19
  803026:	e8 6d fd ff ff       	call   802d98 <syscall>
  80302b:	83 c4 18             	add    $0x18,%esp
}
  80302e:	c9                   	leave  
  80302f:	c3                   	ret    

00803030 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803030:	55                   	push   %ebp
  803031:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	6a 00                	push   $0x0
  80303c:	6a 00                	push   $0x0
  80303e:	50                   	push   %eax
  80303f:	6a 1a                	push   $0x1a
  803041:	e8 52 fd ff ff       	call   802d98 <syscall>
  803046:	83 c4 18             	add    $0x18,%esp
}
  803049:	90                   	nop
  80304a:	c9                   	leave  
  80304b:	c3                   	ret    

0080304c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80304c:	55                   	push   %ebp
  80304d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	6a 00                	push   $0x0
  803054:	6a 00                	push   $0x0
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	50                   	push   %eax
  80305b:	6a 1b                	push   $0x1b
  80305d:	e8 36 fd ff ff       	call   802d98 <syscall>
  803062:	83 c4 18             	add    $0x18,%esp
}
  803065:	c9                   	leave  
  803066:	c3                   	ret    

00803067 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803067:	55                   	push   %ebp
  803068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80306a:	6a 00                	push   $0x0
  80306c:	6a 00                	push   $0x0
  80306e:	6a 00                	push   $0x0
  803070:	6a 00                	push   $0x0
  803072:	6a 00                	push   $0x0
  803074:	6a 05                	push   $0x5
  803076:	e8 1d fd ff ff       	call   802d98 <syscall>
  80307b:	83 c4 18             	add    $0x18,%esp
}
  80307e:	c9                   	leave  
  80307f:	c3                   	ret    

00803080 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803080:	55                   	push   %ebp
  803081:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803083:	6a 00                	push   $0x0
  803085:	6a 00                	push   $0x0
  803087:	6a 00                	push   $0x0
  803089:	6a 00                	push   $0x0
  80308b:	6a 00                	push   $0x0
  80308d:	6a 06                	push   $0x6
  80308f:	e8 04 fd ff ff       	call   802d98 <syscall>
  803094:	83 c4 18             	add    $0x18,%esp
}
  803097:	c9                   	leave  
  803098:	c3                   	ret    

00803099 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803099:	55                   	push   %ebp
  80309a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80309c:	6a 00                	push   $0x0
  80309e:	6a 00                	push   $0x0
  8030a0:	6a 00                	push   $0x0
  8030a2:	6a 00                	push   $0x0
  8030a4:	6a 00                	push   $0x0
  8030a6:	6a 07                	push   $0x7
  8030a8:	e8 eb fc ff ff       	call   802d98 <syscall>
  8030ad:	83 c4 18             	add    $0x18,%esp
}
  8030b0:	c9                   	leave  
  8030b1:	c3                   	ret    

008030b2 <sys_exit_env>:


void sys_exit_env(void)
{
  8030b2:	55                   	push   %ebp
  8030b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 00                	push   $0x0
  8030b9:	6a 00                	push   $0x0
  8030bb:	6a 00                	push   $0x0
  8030bd:	6a 00                	push   $0x0
  8030bf:	6a 1c                	push   $0x1c
  8030c1:	e8 d2 fc ff ff       	call   802d98 <syscall>
  8030c6:	83 c4 18             	add    $0x18,%esp
}
  8030c9:	90                   	nop
  8030ca:	c9                   	leave  
  8030cb:	c3                   	ret    

008030cc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8030cc:	55                   	push   %ebp
  8030cd:	89 e5                	mov    %esp,%ebp
  8030cf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8030d2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8030d5:	8d 50 04             	lea    0x4(%eax),%edx
  8030d8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8030db:	6a 00                	push   $0x0
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 00                	push   $0x0
  8030e1:	52                   	push   %edx
  8030e2:	50                   	push   %eax
  8030e3:	6a 1d                	push   $0x1d
  8030e5:	e8 ae fc ff ff       	call   802d98 <syscall>
  8030ea:	83 c4 18             	add    $0x18,%esp
	return result;
  8030ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8030f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8030f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030f6:	89 01                	mov    %eax,(%ecx)
  8030f8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	c9                   	leave  
  8030ff:	c2 04 00             	ret    $0x4

00803102 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803102:	55                   	push   %ebp
  803103:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803105:	6a 00                	push   $0x0
  803107:	6a 00                	push   $0x0
  803109:	ff 75 10             	pushl  0x10(%ebp)
  80310c:	ff 75 0c             	pushl  0xc(%ebp)
  80310f:	ff 75 08             	pushl  0x8(%ebp)
  803112:	6a 13                	push   $0x13
  803114:	e8 7f fc ff ff       	call   802d98 <syscall>
  803119:	83 c4 18             	add    $0x18,%esp
	return ;
  80311c:	90                   	nop
}
  80311d:	c9                   	leave  
  80311e:	c3                   	ret    

0080311f <sys_rcr2>:
uint32 sys_rcr2()
{
  80311f:	55                   	push   %ebp
  803120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803122:	6a 00                	push   $0x0
  803124:	6a 00                	push   $0x0
  803126:	6a 00                	push   $0x0
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	6a 1e                	push   $0x1e
  80312e:	e8 65 fc ff ff       	call   802d98 <syscall>
  803133:	83 c4 18             	add    $0x18,%esp
}
  803136:	c9                   	leave  
  803137:	c3                   	ret    

00803138 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803138:	55                   	push   %ebp
  803139:	89 e5                	mov    %esp,%ebp
  80313b:	83 ec 04             	sub    $0x4,%esp
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803144:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803148:	6a 00                	push   $0x0
  80314a:	6a 00                	push   $0x0
  80314c:	6a 00                	push   $0x0
  80314e:	6a 00                	push   $0x0
  803150:	50                   	push   %eax
  803151:	6a 1f                	push   $0x1f
  803153:	e8 40 fc ff ff       	call   802d98 <syscall>
  803158:	83 c4 18             	add    $0x18,%esp
	return ;
  80315b:	90                   	nop
}
  80315c:	c9                   	leave  
  80315d:	c3                   	ret    

0080315e <rsttst>:
void rsttst()
{
  80315e:	55                   	push   %ebp
  80315f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803161:	6a 00                	push   $0x0
  803163:	6a 00                	push   $0x0
  803165:	6a 00                	push   $0x0
  803167:	6a 00                	push   $0x0
  803169:	6a 00                	push   $0x0
  80316b:	6a 21                	push   $0x21
  80316d:	e8 26 fc ff ff       	call   802d98 <syscall>
  803172:	83 c4 18             	add    $0x18,%esp
	return ;
  803175:	90                   	nop
}
  803176:	c9                   	leave  
  803177:	c3                   	ret    

00803178 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803178:	55                   	push   %ebp
  803179:	89 e5                	mov    %esp,%ebp
  80317b:	83 ec 04             	sub    $0x4,%esp
  80317e:	8b 45 14             	mov    0x14(%ebp),%eax
  803181:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803184:	8b 55 18             	mov    0x18(%ebp),%edx
  803187:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80318b:	52                   	push   %edx
  80318c:	50                   	push   %eax
  80318d:	ff 75 10             	pushl  0x10(%ebp)
  803190:	ff 75 0c             	pushl  0xc(%ebp)
  803193:	ff 75 08             	pushl  0x8(%ebp)
  803196:	6a 20                	push   $0x20
  803198:	e8 fb fb ff ff       	call   802d98 <syscall>
  80319d:	83 c4 18             	add    $0x18,%esp
	return ;
  8031a0:	90                   	nop
}
  8031a1:	c9                   	leave  
  8031a2:	c3                   	ret    

008031a3 <chktst>:
void chktst(uint32 n)
{
  8031a3:	55                   	push   %ebp
  8031a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8031a6:	6a 00                	push   $0x0
  8031a8:	6a 00                	push   $0x0
  8031aa:	6a 00                	push   $0x0
  8031ac:	6a 00                	push   $0x0
  8031ae:	ff 75 08             	pushl  0x8(%ebp)
  8031b1:	6a 22                	push   $0x22
  8031b3:	e8 e0 fb ff ff       	call   802d98 <syscall>
  8031b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8031bb:	90                   	nop
}
  8031bc:	c9                   	leave  
  8031bd:	c3                   	ret    

008031be <inctst>:

void inctst()
{
  8031be:	55                   	push   %ebp
  8031bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8031c1:	6a 00                	push   $0x0
  8031c3:	6a 00                	push   $0x0
  8031c5:	6a 00                	push   $0x0
  8031c7:	6a 00                	push   $0x0
  8031c9:	6a 00                	push   $0x0
  8031cb:	6a 23                	push   $0x23
  8031cd:	e8 c6 fb ff ff       	call   802d98 <syscall>
  8031d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8031d5:	90                   	nop
}
  8031d6:	c9                   	leave  
  8031d7:	c3                   	ret    

008031d8 <gettst>:
uint32 gettst()
{
  8031d8:	55                   	push   %ebp
  8031d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8031db:	6a 00                	push   $0x0
  8031dd:	6a 00                	push   $0x0
  8031df:	6a 00                	push   $0x0
  8031e1:	6a 00                	push   $0x0
  8031e3:	6a 00                	push   $0x0
  8031e5:	6a 24                	push   $0x24
  8031e7:	e8 ac fb ff ff       	call   802d98 <syscall>
  8031ec:	83 c4 18             	add    $0x18,%esp
}
  8031ef:	c9                   	leave  
  8031f0:	c3                   	ret    

008031f1 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8031f1:	55                   	push   %ebp
  8031f2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031f4:	6a 00                	push   $0x0
  8031f6:	6a 00                	push   $0x0
  8031f8:	6a 00                	push   $0x0
  8031fa:	6a 00                	push   $0x0
  8031fc:	6a 00                	push   $0x0
  8031fe:	6a 25                	push   $0x25
  803200:	e8 93 fb ff ff       	call   802d98 <syscall>
  803205:	83 c4 18             	add    $0x18,%esp
  803208:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  80320d:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803212:	c9                   	leave  
  803213:	c3                   	ret    

00803214 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803214:	55                   	push   %ebp
  803215:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80321f:	6a 00                	push   $0x0
  803221:	6a 00                	push   $0x0
  803223:	6a 00                	push   $0x0
  803225:	6a 00                	push   $0x0
  803227:	ff 75 08             	pushl  0x8(%ebp)
  80322a:	6a 26                	push   $0x26
  80322c:	e8 67 fb ff ff       	call   802d98 <syscall>
  803231:	83 c4 18             	add    $0x18,%esp
	return ;
  803234:	90                   	nop
}
  803235:	c9                   	leave  
  803236:	c3                   	ret    

00803237 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803237:	55                   	push   %ebp
  803238:	89 e5                	mov    %esp,%ebp
  80323a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80323b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80323e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803241:	8b 55 0c             	mov    0xc(%ebp),%edx
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	6a 00                	push   $0x0
  803249:	53                   	push   %ebx
  80324a:	51                   	push   %ecx
  80324b:	52                   	push   %edx
  80324c:	50                   	push   %eax
  80324d:	6a 27                	push   $0x27
  80324f:	e8 44 fb ff ff       	call   802d98 <syscall>
  803254:	83 c4 18             	add    $0x18,%esp
}
  803257:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80325a:	c9                   	leave  
  80325b:	c3                   	ret    

0080325c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80325c:	55                   	push   %ebp
  80325d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80325f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	6a 00                	push   $0x0
  803267:	6a 00                	push   $0x0
  803269:	6a 00                	push   $0x0
  80326b:	52                   	push   %edx
  80326c:	50                   	push   %eax
  80326d:	6a 28                	push   $0x28
  80326f:	e8 24 fb ff ff       	call   802d98 <syscall>
  803274:	83 c4 18             	add    $0x18,%esp
}
  803277:	c9                   	leave  
  803278:	c3                   	ret    

00803279 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803279:	55                   	push   %ebp
  80327a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80327c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80327f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	6a 00                	push   $0x0
  803287:	51                   	push   %ecx
  803288:	ff 75 10             	pushl  0x10(%ebp)
  80328b:	52                   	push   %edx
  80328c:	50                   	push   %eax
  80328d:	6a 29                	push   $0x29
  80328f:	e8 04 fb ff ff       	call   802d98 <syscall>
  803294:	83 c4 18             	add    $0x18,%esp
}
  803297:	c9                   	leave  
  803298:	c3                   	ret    

00803299 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803299:	55                   	push   %ebp
  80329a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80329c:	6a 00                	push   $0x0
  80329e:	6a 00                	push   $0x0
  8032a0:	ff 75 10             	pushl  0x10(%ebp)
  8032a3:	ff 75 0c             	pushl  0xc(%ebp)
  8032a6:	ff 75 08             	pushl  0x8(%ebp)
  8032a9:	6a 12                	push   $0x12
  8032ab:	e8 e8 fa ff ff       	call   802d98 <syscall>
  8032b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8032b3:	90                   	nop
}
  8032b4:	c9                   	leave  
  8032b5:	c3                   	ret    

008032b6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8032b6:	55                   	push   %ebp
  8032b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8032b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	6a 00                	push   $0x0
  8032c1:	6a 00                	push   $0x0
  8032c3:	6a 00                	push   $0x0
  8032c5:	52                   	push   %edx
  8032c6:	50                   	push   %eax
  8032c7:	6a 2a                	push   $0x2a
  8032c9:	e8 ca fa ff ff       	call   802d98 <syscall>
  8032ce:	83 c4 18             	add    $0x18,%esp
	return;
  8032d1:	90                   	nop
}
  8032d2:	c9                   	leave  
  8032d3:	c3                   	ret    

008032d4 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8032d4:	55                   	push   %ebp
  8032d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8032d7:	6a 00                	push   $0x0
  8032d9:	6a 00                	push   $0x0
  8032db:	6a 00                	push   $0x0
  8032dd:	6a 00                	push   $0x0
  8032df:	6a 00                	push   $0x0
  8032e1:	6a 2b                	push   $0x2b
  8032e3:	e8 b0 fa ff ff       	call   802d98 <syscall>
  8032e8:	83 c4 18             	add    $0x18,%esp
}
  8032eb:	c9                   	leave  
  8032ec:	c3                   	ret    

008032ed <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8032ed:	55                   	push   %ebp
  8032ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8032f0:	6a 00                	push   $0x0
  8032f2:	6a 00                	push   $0x0
  8032f4:	6a 00                	push   $0x0
  8032f6:	ff 75 0c             	pushl  0xc(%ebp)
  8032f9:	ff 75 08             	pushl  0x8(%ebp)
  8032fc:	6a 2d                	push   $0x2d
  8032fe:	e8 95 fa ff ff       	call   802d98 <syscall>
  803303:	83 c4 18             	add    $0x18,%esp
	return;
  803306:	90                   	nop
}
  803307:	c9                   	leave  
  803308:	c3                   	ret    

00803309 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803309:	55                   	push   %ebp
  80330a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80330c:	6a 00                	push   $0x0
  80330e:	6a 00                	push   $0x0
  803310:	6a 00                	push   $0x0
  803312:	ff 75 0c             	pushl  0xc(%ebp)
  803315:	ff 75 08             	pushl  0x8(%ebp)
  803318:	6a 2c                	push   $0x2c
  80331a:	e8 79 fa ff ff       	call   802d98 <syscall>
  80331f:	83 c4 18             	add    $0x18,%esp
	return ;
  803322:	90                   	nop
}
  803323:	c9                   	leave  
  803324:	c3                   	ret    

00803325 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803325:	55                   	push   %ebp
  803326:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803328:	8b 55 0c             	mov    0xc(%ebp),%edx
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	6a 00                	push   $0x0
  803330:	6a 00                	push   $0x0
  803332:	6a 00                	push   $0x0
  803334:	52                   	push   %edx
  803335:	50                   	push   %eax
  803336:	6a 2e                	push   $0x2e
  803338:	e8 5b fa ff ff       	call   802d98 <syscall>
  80333d:	83 c4 18             	add    $0x18,%esp
}
  803340:	90                   	nop
  803341:	c9                   	leave  
  803342:	c3                   	ret    

00803343 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803343:	55                   	push   %ebp
  803344:	89 e5                	mov    %esp,%ebp
  803346:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803349:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803350:	72 09                	jb     80335b <to_page_va+0x18>
  803352:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  803359:	72 14                	jb     80336f <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80335b:	83 ec 04             	sub    $0x4,%esp
  80335e:	68 8c 48 80 00       	push   $0x80488c
  803363:	6a 15                	push   $0x15
  803365:	68 b7 48 80 00       	push   $0x8048b7
  80336a:	e8 a4 0a 00 00       	call   803e13 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  803377:	29 d0                	sub    %edx,%eax
  803379:	c1 f8 02             	sar    $0x2,%eax
  80337c:	89 c2                	mov    %eax,%edx
  80337e:	89 d0                	mov    %edx,%eax
  803380:	c1 e0 02             	shl    $0x2,%eax
  803383:	01 d0                	add    %edx,%eax
  803385:	c1 e0 02             	shl    $0x2,%eax
  803388:	01 d0                	add    %edx,%eax
  80338a:	c1 e0 02             	shl    $0x2,%eax
  80338d:	01 d0                	add    %edx,%eax
  80338f:	89 c1                	mov    %eax,%ecx
  803391:	c1 e1 08             	shl    $0x8,%ecx
  803394:	01 c8                	add    %ecx,%eax
  803396:	89 c1                	mov    %eax,%ecx
  803398:	c1 e1 10             	shl    $0x10,%ecx
  80339b:	01 c8                	add    %ecx,%eax
  80339d:	01 c0                	add    %eax,%eax
  80339f:	01 d0                	add    %edx,%eax
  8033a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8033a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a7:	c1 e0 0c             	shl    $0xc,%eax
  8033aa:	89 c2                	mov    %eax,%edx
  8033ac:	a1 84 50 83 00       	mov    0x835084,%eax
  8033b1:	01 d0                	add    %edx,%eax
}
  8033b3:	c9                   	leave  
  8033b4:	c3                   	ret    

008033b5 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8033b5:	55                   	push   %ebp
  8033b6:	89 e5                	mov    %esp,%ebp
  8033b8:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8033bb:	a1 84 50 83 00       	mov    0x835084,%eax
  8033c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c3:	29 c2                	sub    %eax,%edx
  8033c5:	89 d0                	mov    %edx,%eax
  8033c7:	c1 e8 0c             	shr    $0xc,%eax
  8033ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8033cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d1:	78 09                	js     8033dc <to_page_info+0x27>
  8033d3:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8033da:	7e 14                	jle    8033f0 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8033dc:	83 ec 04             	sub    $0x4,%esp
  8033df:	68 d0 48 80 00       	push   $0x8048d0
  8033e4:	6a 21                	push   $0x21
  8033e6:	68 b7 48 80 00       	push   $0x8048b7
  8033eb:	e8 23 0a 00 00       	call   803e13 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8033f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033f3:	89 d0                	mov    %edx,%eax
  8033f5:	01 c0                	add    %eax,%eax
  8033f7:	01 d0                	add    %edx,%eax
  8033f9:	c1 e0 02             	shl    $0x2,%eax
  8033fc:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  803401:	c9                   	leave  
  803402:	c3                   	ret    

00803403 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803403:	55                   	push   %ebp
  803404:	89 e5                	mov    %esp,%ebp
  803406:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803409:	8b 45 08             	mov    0x8(%ebp),%eax
  80340c:	05 00 00 00 02       	add    $0x2000000,%eax
  803411:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803414:	73 16                	jae    80342c <initialize_dynamic_allocator+0x29>
  803416:	68 f4 48 80 00       	push   $0x8048f4
  80341b:	68 1a 49 80 00       	push   $0x80491a
  803420:	6a 2f                	push   $0x2f
  803422:	68 b7 48 80 00       	push   $0x8048b7
  803427:	e8 e7 09 00 00       	call   803e13 <_panic>
	dynAllocStart = daStart;
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803434:	8b 45 0c             	mov    0xc(%ebp),%eax
  803437:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80343c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803443:	eb 36                	jmp    80347b <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	c1 e0 04             	shl    $0x4,%eax
  80344b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803459:	c1 e0 04             	shl    $0x4,%eax
  80345c:	05 a4 50 83 00       	add    $0x8350a4,%eax
  803461:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346a:	c1 e0 04             	shl    $0x4,%eax
  80346d:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803472:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803478:	ff 45 f4             	incl   -0xc(%ebp)
  80347b:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80347f:	7e c4                	jle    803445 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803481:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  803488:	00 00 00 
  80348b:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  803492:	00 00 00 
  803495:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  80349c:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80349f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8034a6:	e9 1b 01 00 00       	jmp    8035c6 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8034ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ae:	89 d0                	mov    %edx,%eax
  8034b0:	01 c0                	add    %eax,%eax
  8034b2:	01 d0                	add    %edx,%eax
  8034b4:	c1 e0 02             	shl    $0x2,%eax
  8034b7:	05 88 d0 81 00       	add    $0x81d088,%eax
  8034bc:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8034c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034c4:	89 d0                	mov    %edx,%eax
  8034c6:	01 c0                	add    %eax,%eax
  8034c8:	01 d0                	add    %edx,%eax
  8034ca:	c1 e0 02             	shl    $0x2,%eax
  8034cd:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8034d2:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8034d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034da:	89 d0                	mov    %edx,%eax
  8034dc:	01 c0                	add    %eax,%eax
  8034de:	01 d0                	add    %edx,%eax
  8034e0:	c1 e0 02             	shl    $0x2,%eax
  8034e3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	74 2b                	je     803519 <initialize_dynamic_allocator+0x116>
  8034ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f1:	89 d0                	mov    %edx,%eax
  8034f3:	01 c0                	add    %eax,%eax
  8034f5:	01 d0                	add    %edx,%eax
  8034f7:	c1 e0 02             	shl    $0x2,%eax
  8034fa:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034ff:	8b 10                	mov    (%eax),%edx
  803501:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803504:	89 c8                	mov    %ecx,%eax
  803506:	01 c0                	add    %eax,%eax
  803508:	01 c8                	add    %ecx,%eax
  80350a:	c1 e0 02             	shl    $0x2,%eax
  80350d:	05 84 d0 81 00       	add    $0x81d084,%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	89 42 04             	mov    %eax,0x4(%edx)
  803517:	eb 18                	jmp    803531 <initialize_dynamic_allocator+0x12e>
  803519:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80351c:	89 d0                	mov    %edx,%eax
  80351e:	01 c0                	add    %eax,%eax
  803520:	01 d0                	add    %edx,%eax
  803522:	c1 e0 02             	shl    $0x2,%eax
  803525:	05 84 d0 81 00       	add    $0x81d084,%eax
  80352a:	8b 00                	mov    (%eax),%eax
  80352c:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803531:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803534:	89 d0                	mov    %edx,%eax
  803536:	01 c0                	add    %eax,%eax
  803538:	01 d0                	add    %edx,%eax
  80353a:	c1 e0 02             	shl    $0x2,%eax
  80353d:	05 84 d0 81 00       	add    $0x81d084,%eax
  803542:	8b 00                	mov    (%eax),%eax
  803544:	85 c0                	test   %eax,%eax
  803546:	74 2a                	je     803572 <initialize_dynamic_allocator+0x16f>
  803548:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80354b:	89 d0                	mov    %edx,%eax
  80354d:	01 c0                	add    %eax,%eax
  80354f:	01 d0                	add    %edx,%eax
  803551:	c1 e0 02             	shl    $0x2,%eax
  803554:	05 84 d0 81 00       	add    $0x81d084,%eax
  803559:	8b 10                	mov    (%eax),%edx
  80355b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80355e:	89 c8                	mov    %ecx,%eax
  803560:	01 c0                	add    %eax,%eax
  803562:	01 c8                	add    %ecx,%eax
  803564:	c1 e0 02             	shl    $0x2,%eax
  803567:	05 80 d0 81 00       	add    $0x81d080,%eax
  80356c:	8b 00                	mov    (%eax),%eax
  80356e:	89 02                	mov    %eax,(%edx)
  803570:	eb 18                	jmp    80358a <initialize_dynamic_allocator+0x187>
  803572:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803575:	89 d0                	mov    %edx,%eax
  803577:	01 c0                	add    %eax,%eax
  803579:	01 d0                	add    %edx,%eax
  80357b:	c1 e0 02             	shl    $0x2,%eax
  80357e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803583:	8b 00                	mov    (%eax),%eax
  803585:	a3 68 d0 81 00       	mov    %eax,0x81d068
  80358a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80358d:	89 d0                	mov    %edx,%eax
  80358f:	01 c0                	add    %eax,%eax
  803591:	01 d0                	add    %edx,%eax
  803593:	c1 e0 02             	shl    $0x2,%eax
  803596:	05 80 d0 81 00       	add    $0x81d080,%eax
  80359b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035a4:	89 d0                	mov    %edx,%eax
  8035a6:	01 c0                	add    %eax,%eax
  8035a8:	01 d0                	add    %edx,%eax
  8035aa:	c1 e0 02             	shl    $0x2,%eax
  8035ad:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b8:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8035bd:	48                   	dec    %eax
  8035be:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8035c3:	ff 45 f0             	incl   -0x10(%ebp)
  8035c6:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8035cd:	0f 8e d8 fe ff ff    	jle    8034ab <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8035d3:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8035da:	e9 9d 00 00 00       	jmp    80367c <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8035df:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8035e5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8035e8:	89 c8                	mov    %ecx,%eax
  8035ea:	01 c0                	add    %eax,%eax
  8035ec:	01 c8                	add    %ecx,%eax
  8035ee:	c1 e0 02             	shl    $0x2,%eax
  8035f1:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035f6:	89 10                	mov    %edx,(%eax)
  8035f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035fb:	89 d0                	mov    %edx,%eax
  8035fd:	01 c0                	add    %eax,%eax
  8035ff:	01 d0                	add    %edx,%eax
  803601:	c1 e0 02             	shl    $0x2,%eax
  803604:	05 80 d0 81 00       	add    $0x81d080,%eax
  803609:	8b 00                	mov    (%eax),%eax
  80360b:	85 c0                	test   %eax,%eax
  80360d:	74 1c                	je     80362b <initialize_dynamic_allocator+0x228>
  80360f:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803615:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803618:	89 c8                	mov    %ecx,%eax
  80361a:	01 c0                	add    %eax,%eax
  80361c:	01 c8                	add    %ecx,%eax
  80361e:	c1 e0 02             	shl    $0x2,%eax
  803621:	05 80 d0 81 00       	add    $0x81d080,%eax
  803626:	89 42 04             	mov    %eax,0x4(%edx)
  803629:	eb 16                	jmp    803641 <initialize_dynamic_allocator+0x23e>
  80362b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80362e:	89 d0                	mov    %edx,%eax
  803630:	01 c0                	add    %eax,%eax
  803632:	01 d0                	add    %edx,%eax
  803634:	c1 e0 02             	shl    $0x2,%eax
  803637:	05 80 d0 81 00       	add    $0x81d080,%eax
  80363c:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803641:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803644:	89 d0                	mov    %edx,%eax
  803646:	01 c0                	add    %eax,%eax
  803648:	01 d0                	add    %edx,%eax
  80364a:	c1 e0 02             	shl    $0x2,%eax
  80364d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803652:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803657:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80365a:	89 d0                	mov    %edx,%eax
  80365c:	01 c0                	add    %eax,%eax
  80365e:	01 d0                	add    %edx,%eax
  803660:	c1 e0 02             	shl    $0x2,%eax
  803663:	05 84 d0 81 00       	add    $0x81d084,%eax
  803668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80366e:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803673:	40                   	inc    %eax
  803674:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803679:	ff 4d ec             	decl   -0x14(%ebp)
  80367c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803680:	0f 89 59 ff ff ff    	jns    8035df <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803686:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  80368d:	00 00 00 
}
  803690:	90                   	nop
  803691:	c9                   	leave  
  803692:	c3                   	ret    

00803693 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803693:	55                   	push   %ebp
  803694:	89 e5                	mov    %esp,%ebp
  803696:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803699:	8b 45 08             	mov    0x8(%ebp),%eax
  80369c:	83 ec 0c             	sub    $0xc,%esp
  80369f:	50                   	push   %eax
  8036a0:	e8 10 fd ff ff       	call   8033b5 <to_page_info>
  8036a5:	83 c4 10             	add    $0x10,%esp
  8036a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8036ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ae:	8b 40 08             	mov    0x8(%eax),%eax
  8036b1:	0f b7 c0             	movzwl %ax,%eax
}
  8036b4:	c9                   	leave  
  8036b5:	c3                   	ret    

008036b6 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8036b6:	55                   	push   %ebp
  8036b7:	89 e5                	mov    %esp,%ebp
  8036b9:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8036bc:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8036c3:	76 16                	jbe    8036db <alloc_block+0x25>
  8036c5:	68 30 49 80 00       	push   $0x804930
  8036ca:	68 1a 49 80 00       	push   $0x80491a
  8036cf:	6a 59                	push   $0x59
  8036d1:	68 b7 48 80 00       	push   $0x8048b7
  8036d6:	e8 38 07 00 00       	call   803e13 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8036db:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8036e2:	eb 08                	jmp    8036ec <alloc_block+0x36>
		allocSize <<= 1;
  8036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e7:	01 c0                	add    %eax,%eax
  8036e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036f2:	73 09                	jae    8036fd <alloc_block+0x47>
  8036f4:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8036fb:	76 e7                	jbe    8036e4 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8036fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803704:	eb 03                	jmp    803709 <alloc_block+0x53>
		listIndex++;
  803706:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370c:	ba 08 00 00 00       	mov    $0x8,%edx
  803711:	88 c1                	mov    %al,%cl
  803713:	d3 e2                	shl    %cl,%edx
  803715:	89 d0                	mov    %edx,%eax
  803717:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80371a:	72 ea                	jb     803706 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80371c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80371f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803722:	e9 f4 00 00 00       	jmp    80381b <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372a:	c1 e0 04             	shl    $0x4,%eax
  80372d:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803732:	8b 00                	mov    (%eax),%eax
  803734:	85 c0                	test   %eax,%eax
  803736:	0f 84 dc 00 00 00    	je     803818 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  80373c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80373f:	c1 e0 04             	shl    $0x4,%eax
  803742:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803747:	8b 00                	mov    (%eax),%eax
  803749:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80374c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803750:	75 14                	jne    803766 <alloc_block+0xb0>
  803752:	83 ec 04             	sub    $0x4,%esp
  803755:	68 51 49 80 00       	push   $0x804951
  80375a:	6a 6b                	push   $0x6b
  80375c:	68 b7 48 80 00       	push   $0x8048b7
  803761:	e8 ad 06 00 00       	call   803e13 <_panic>
  803766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803769:	8b 00                	mov    (%eax),%eax
  80376b:	85 c0                	test   %eax,%eax
  80376d:	74 10                	je     80377f <alloc_block+0xc9>
  80376f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803772:	8b 00                	mov    (%eax),%eax
  803774:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803777:	8b 52 04             	mov    0x4(%edx),%edx
  80377a:	89 50 04             	mov    %edx,0x4(%eax)
  80377d:	eb 14                	jmp    803793 <alloc_block+0xdd>
  80377f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803782:	8b 40 04             	mov    0x4(%eax),%eax
  803785:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803788:	c1 e2 04             	shl    $0x4,%edx
  80378b:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803791:	89 02                	mov    %eax,(%edx)
  803793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803796:	8b 40 04             	mov    0x4(%eax),%eax
  803799:	85 c0                	test   %eax,%eax
  80379b:	74 0f                	je     8037ac <alloc_block+0xf6>
  80379d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a0:	8b 40 04             	mov    0x4(%eax),%eax
  8037a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a6:	8b 12                	mov    (%edx),%edx
  8037a8:	89 10                	mov    %edx,(%eax)
  8037aa:	eb 13                	jmp    8037bf <alloc_block+0x109>
  8037ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037af:	8b 00                	mov    (%eax),%eax
  8037b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037b4:	c1 e2 04             	shl    $0x4,%edx
  8037b7:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8037bd:	89 02                	mov    %eax,(%edx)
  8037bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d5:	c1 e0 04             	shl    $0x4,%eax
  8037d8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8037dd:	8b 00                	mov    (%eax),%eax
  8037df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8037e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e5:	c1 e0 04             	shl    $0x4,%eax
  8037e8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8037ed:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8037ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f2:	83 ec 0c             	sub    $0xc,%esp
  8037f5:	50                   	push   %eax
  8037f6:	e8 ba fb ff ff       	call   8033b5 <to_page_info>
  8037fb:	83 c4 10             	add    $0x10,%esp
  8037fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803804:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803808:	48                   	dec    %eax
  803809:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80380c:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803813:	e9 8f 02 00 00       	jmp    803aa7 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803818:	ff 45 ec             	incl   -0x14(%ebp)
  80381b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80381f:	0f 8e 02 ff ff ff    	jle    803727 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803825:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80382a:	85 c0                	test   %eax,%eax
  80382c:	75 14                	jne    803842 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  80382e:	83 ec 04             	sub    $0x4,%esp
  803831:	68 70 49 80 00       	push   $0x804970
  803836:	6a 77                	push   $0x77
  803838:	68 b7 48 80 00       	push   $0x8048b7
  80383d:	e8 d1 05 00 00       	call   803e13 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803842:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803847:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  80384a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80384e:	75 14                	jne    803864 <alloc_block+0x1ae>
  803850:	83 ec 04             	sub    $0x4,%esp
  803853:	68 51 49 80 00       	push   $0x804951
  803858:	6a 7a                	push   $0x7a
  80385a:	68 b7 48 80 00       	push   $0x8048b7
  80385f:	e8 af 05 00 00       	call   803e13 <_panic>
  803864:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	85 c0                	test   %eax,%eax
  80386b:	74 10                	je     80387d <alloc_block+0x1c7>
  80386d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803870:	8b 00                	mov    (%eax),%eax
  803872:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803875:	8b 52 04             	mov    0x4(%edx),%edx
  803878:	89 50 04             	mov    %edx,0x4(%eax)
  80387b:	eb 0b                	jmp    803888 <alloc_block+0x1d2>
  80387d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803880:	8b 40 04             	mov    0x4(%eax),%eax
  803883:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803888:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80388b:	8b 40 04             	mov    0x4(%eax),%eax
  80388e:	85 c0                	test   %eax,%eax
  803890:	74 0f                	je     8038a1 <alloc_block+0x1eb>
  803892:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803895:	8b 40 04             	mov    0x4(%eax),%eax
  803898:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80389b:	8b 12                	mov    (%edx),%edx
  80389d:	89 10                	mov    %edx,(%eax)
  80389f:	eb 0a                	jmp    8038ab <alloc_block+0x1f5>
  8038a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038a4:	8b 00                	mov    (%eax),%eax
  8038a6:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8038ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038be:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8038c3:	48                   	dec    %eax
  8038c4:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8038c9:	83 ec 0c             	sub    $0xc,%esp
  8038cc:	ff 75 dc             	pushl  -0x24(%ebp)
  8038cf:	e8 6f fa ff ff       	call   803343 <to_page_va>
  8038d4:	83 c4 10             	add    $0x10,%esp
  8038d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8038da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038dd:	83 ec 0c             	sub    $0xc,%esp
  8038e0:	50                   	push   %eax
  8038e1:	e8 a0 dc ff ff       	call   801586 <get_page>
  8038e6:	83 c4 10             	add    $0x10,%esp
  8038e9:	85 c0                	test   %eax,%eax
  8038eb:	74 14                	je     803901 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8038ed:	83 ec 04             	sub    $0x4,%esp
  8038f0:	68 98 49 80 00       	push   $0x804998
  8038f5:	6a 7f                	push   $0x7f
  8038f7:	68 b7 48 80 00       	push   $0x8048b7
  8038fc:	e8 12 05 00 00       	call   803e13 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803904:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803907:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  80390b:	b8 00 10 00 00       	mov    $0x1000,%eax
  803910:	ba 00 00 00 00       	mov    $0x0,%edx
  803915:	f7 75 f4             	divl   -0xc(%ebp)
  803918:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80391b:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80391f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803926:	e9 a7 00 00 00       	jmp    8039d2 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  80392b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80392e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803931:	01 d0                	add    %edx,%eax
  803933:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803936:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80393a:	75 17                	jne    803953 <alloc_block+0x29d>
  80393c:	83 ec 04             	sub    $0x4,%esp
  80393f:	68 c0 49 80 00       	push   $0x8049c0
  803944:	68 88 00 00 00       	push   $0x88
  803949:	68 b7 48 80 00       	push   $0x8048b7
  80394e:	e8 c0 04 00 00       	call   803e13 <_panic>
  803953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803956:	c1 e0 04             	shl    $0x4,%eax
  803959:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80395e:	8b 10                	mov    (%eax),%edx
  803960:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803963:	89 10                	mov    %edx,(%eax)
  803965:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803968:	8b 00                	mov    (%eax),%eax
  80396a:	85 c0                	test   %eax,%eax
  80396c:	74 15                	je     803983 <alloc_block+0x2cd>
  80396e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803971:	c1 e0 04             	shl    $0x4,%eax
  803974:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803979:	8b 00                	mov    (%eax),%eax
  80397b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80397e:	89 50 04             	mov    %edx,0x4(%eax)
  803981:	eb 11                	jmp    803994 <alloc_block+0x2de>
  803983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803986:	c1 e0 04             	shl    $0x4,%eax
  803989:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  80398f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803992:	89 02                	mov    %eax,(%edx)
  803994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803997:	c1 e0 04             	shl    $0x4,%eax
  80399a:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  8039a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a3:	89 02                	mov    %eax,(%edx)
  8039a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b2:	c1 e0 04             	shl    $0x4,%eax
  8039b5:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039ba:	8b 00                	mov    (%eax),%eax
  8039bc:	8d 50 01             	lea    0x1(%eax),%edx
  8039bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c2:	c1 e0 04             	shl    $0x4,%eax
  8039c5:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039ca:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8039cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cf:	01 45 e8             	add    %eax,-0x18(%ebp)
  8039d2:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8039d9:	0f 86 4c ff ff ff    	jbe    80392b <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  8039df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e2:	c1 e0 04             	shl    $0x4,%eax
  8039e5:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8039ea:	8b 00                	mov    (%eax),%eax
  8039ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  8039ef:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8039f3:	75 17                	jne    803a0c <alloc_block+0x356>
  8039f5:	83 ec 04             	sub    $0x4,%esp
  8039f8:	68 51 49 80 00       	push   $0x804951
  8039fd:	68 8d 00 00 00       	push   $0x8d
  803a02:	68 b7 48 80 00       	push   $0x8048b7
  803a07:	e8 07 04 00 00       	call   803e13 <_panic>
  803a0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a0f:	8b 00                	mov    (%eax),%eax
  803a11:	85 c0                	test   %eax,%eax
  803a13:	74 10                	je     803a25 <alloc_block+0x36f>
  803a15:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a18:	8b 00                	mov    (%eax),%eax
  803a1a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803a1d:	8b 52 04             	mov    0x4(%edx),%edx
  803a20:	89 50 04             	mov    %edx,0x4(%eax)
  803a23:	eb 14                	jmp    803a39 <alloc_block+0x383>
  803a25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a28:	8b 40 04             	mov    0x4(%eax),%eax
  803a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a2e:	c1 e2 04             	shl    $0x4,%edx
  803a31:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803a37:	89 02                	mov    %eax,(%edx)
  803a39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a3c:	8b 40 04             	mov    0x4(%eax),%eax
  803a3f:	85 c0                	test   %eax,%eax
  803a41:	74 0f                	je     803a52 <alloc_block+0x39c>
  803a43:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a46:	8b 40 04             	mov    0x4(%eax),%eax
  803a49:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803a4c:	8b 12                	mov    (%edx),%edx
  803a4e:	89 10                	mov    %edx,(%eax)
  803a50:	eb 13                	jmp    803a65 <alloc_block+0x3af>
  803a52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a55:	8b 00                	mov    (%eax),%eax
  803a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a5a:	c1 e2 04             	shl    $0x4,%edx
  803a5d:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803a63:	89 02                	mov    %eax,(%edx)
  803a65:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a7b:	c1 e0 04             	shl    $0x4,%eax
  803a7e:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a83:	8b 00                	mov    (%eax),%eax
  803a85:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8b:	c1 e0 04             	shl    $0x4,%eax
  803a8e:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a93:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803a95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a98:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a9c:	48                   	dec    %eax
  803a9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803aa0:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803aa4:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803aa7:	c9                   	leave  
  803aa8:	c3                   	ret    

00803aa9 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803aa9:	55                   	push   %ebp
  803aaa:	89 e5                	mov    %esp,%ebp
  803aac:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803aaf:	8b 55 08             	mov    0x8(%ebp),%edx
  803ab2:	a1 84 50 83 00       	mov    0x835084,%eax
  803ab7:	39 c2                	cmp    %eax,%edx
  803ab9:	72 0c                	jb     803ac7 <free_block+0x1e>
  803abb:	8b 55 08             	mov    0x8(%ebp),%edx
  803abe:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803ac3:	39 c2                	cmp    %eax,%edx
  803ac5:	72 19                	jb     803ae0 <free_block+0x37>
  803ac7:	68 e4 49 80 00       	push   $0x8049e4
  803acc:	68 1a 49 80 00       	push   $0x80491a
  803ad1:	68 98 00 00 00       	push   $0x98
  803ad6:	68 b7 48 80 00       	push   $0x8048b7
  803adb:	e8 33 03 00 00       	call   803e13 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae3:	83 ec 0c             	sub    $0xc,%esp
  803ae6:	50                   	push   %eax
  803ae7:	e8 c9 f8 ff ff       	call   8033b5 <to_page_info>
  803aec:	83 c4 10             	add    $0x10,%esp
  803aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af5:	8b 40 08             	mov    0x8(%eax),%eax
  803af8:	0f b7 c0             	movzwl %ax,%eax
  803afb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803b05:	eb 03                	jmp    803b0a <free_block+0x61>
		listIndex++;
  803b07:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0d:	ba 08 00 00 00       	mov    $0x8,%edx
  803b12:	88 c1                	mov    %al,%cl
  803b14:	d3 e2                	shl    %cl,%edx
  803b16:	89 d0                	mov    %edx,%eax
  803b18:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b1b:	72 ea                	jb     803b07 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803b23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b27:	75 17                	jne    803b40 <free_block+0x97>
  803b29:	83 ec 04             	sub    $0x4,%esp
  803b2c:	68 c0 49 80 00       	push   $0x8049c0
  803b31:	68 a2 00 00 00       	push   $0xa2
  803b36:	68 b7 48 80 00       	push   $0x8048b7
  803b3b:	e8 d3 02 00 00       	call   803e13 <_panic>
  803b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b43:	c1 e0 04             	shl    $0x4,%eax
  803b46:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b4b:	8b 10                	mov    (%eax),%edx
  803b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b50:	89 10                	mov    %edx,(%eax)
  803b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b55:	8b 00                	mov    (%eax),%eax
  803b57:	85 c0                	test   %eax,%eax
  803b59:	74 15                	je     803b70 <free_block+0xc7>
  803b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5e:	c1 e0 04             	shl    $0x4,%eax
  803b61:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b66:	8b 00                	mov    (%eax),%eax
  803b68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b6b:	89 50 04             	mov    %edx,0x4(%eax)
  803b6e:	eb 11                	jmp    803b81 <free_block+0xd8>
  803b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b73:	c1 e0 04             	shl    $0x4,%eax
  803b76:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7f:	89 02                	mov    %eax,(%edx)
  803b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b84:	c1 e0 04             	shl    $0x4,%eax
  803b87:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803b8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b90:	89 02                	mov    %eax,(%edx)
  803b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9f:	c1 e0 04             	shl    $0x4,%eax
  803ba2:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ba7:	8b 00                	mov    (%eax),%eax
  803ba9:	8d 50 01             	lea    0x1(%eax),%edx
  803bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803baf:	c1 e0 04             	shl    $0x4,%eax
  803bb2:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803bb7:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bbc:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803bc0:	40                   	inc    %eax
  803bc1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bc4:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bcb:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803bcf:	0f b7 c8             	movzwl %ax,%ecx
  803bd2:	b8 00 10 00 00       	mov    $0x1000,%eax
  803bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  803bdc:	f7 75 e8             	divl   -0x18(%ebp)
  803bdf:	39 c1                	cmp    %eax,%ecx
  803be1:	0f 85 ed 01 00 00    	jne    803dd4 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bea:	c1 e0 04             	shl    $0x4,%eax
  803bed:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bf2:	8b 00                	mov    (%eax),%eax
  803bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803bf7:	eb 2a                	jmp    803c23 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bfc:	83 ec 0c             	sub    $0xc,%esp
  803bff:	50                   	push   %eax
  803c00:	e8 b0 f7 ff ff       	call   8033b5 <to_page_info>
  803c05:	83 c4 10             	add    $0x10,%esp
  803c08:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803c0b:	75 06                	jne    803c13 <free_block+0x16a>
				tmp = b;
  803c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c10:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c16:	c1 e0 04             	shl    $0x4,%eax
  803c19:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803c1e:	8b 00                	mov    (%eax),%eax
  803c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803c23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c27:	74 07                	je     803c30 <free_block+0x187>
  803c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c2c:	8b 00                	mov    (%eax),%eax
  803c2e:	eb 05                	jmp    803c35 <free_block+0x18c>
  803c30:	b8 00 00 00 00       	mov    $0x0,%eax
  803c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c38:	c1 e2 04             	shl    $0x4,%edx
  803c3b:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803c41:	89 02                	mov    %eax,(%edx)
  803c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c46:	c1 e0 04             	shl    $0x4,%eax
  803c49:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803c4e:	8b 00                	mov    (%eax),%eax
  803c50:	85 c0                	test   %eax,%eax
  803c52:	75 a5                	jne    803bf9 <free_block+0x150>
  803c54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c58:	75 9f                	jne    803bf9 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5d:	c1 e0 04             	shl    $0x4,%eax
  803c60:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c65:	8b 00                	mov    (%eax),%eax
  803c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803c6a:	e9 cc 00 00 00       	jmp    803d3b <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c72:	8b 00                	mov    (%eax),%eax
  803c74:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c7a:	83 ec 0c             	sub    $0xc,%esp
  803c7d:	50                   	push   %eax
  803c7e:	e8 32 f7 ff ff       	call   8033b5 <to_page_info>
  803c83:	83 c4 10             	add    $0x10,%esp
  803c86:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803c89:	0f 85 a6 00 00 00    	jne    803d35 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803c8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c93:	75 17                	jne    803cac <free_block+0x203>
  803c95:	83 ec 04             	sub    $0x4,%esp
  803c98:	68 51 49 80 00       	push   $0x804951
  803c9d:	68 b5 00 00 00       	push   $0xb5
  803ca2:	68 b7 48 80 00       	push   $0x8048b7
  803ca7:	e8 67 01 00 00       	call   803e13 <_panic>
  803cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803caf:	8b 00                	mov    (%eax),%eax
  803cb1:	85 c0                	test   %eax,%eax
  803cb3:	74 10                	je     803cc5 <free_block+0x21c>
  803cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb8:	8b 00                	mov    (%eax),%eax
  803cba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cbd:	8b 52 04             	mov    0x4(%edx),%edx
  803cc0:	89 50 04             	mov    %edx,0x4(%eax)
  803cc3:	eb 14                	jmp    803cd9 <free_block+0x230>
  803cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cc8:	8b 40 04             	mov    0x4(%eax),%eax
  803ccb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cce:	c1 e2 04             	shl    $0x4,%edx
  803cd1:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803cd7:	89 02                	mov    %eax,(%edx)
  803cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cdc:	8b 40 04             	mov    0x4(%eax),%eax
  803cdf:	85 c0                	test   %eax,%eax
  803ce1:	74 0f                	je     803cf2 <free_block+0x249>
  803ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ce6:	8b 40 04             	mov    0x4(%eax),%eax
  803ce9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cec:	8b 12                	mov    (%edx),%edx
  803cee:	89 10                	mov    %edx,(%eax)
  803cf0:	eb 13                	jmp    803d05 <free_block+0x25c>
  803cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cf5:	8b 00                	mov    (%eax),%eax
  803cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cfa:	c1 e2 04             	shl    $0x4,%edx
  803cfd:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803d03:	89 02                	mov    %eax,(%edx)
  803d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1b:	c1 e0 04             	shl    $0x4,%eax
  803d1e:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803d23:	8b 00                	mov    (%eax),%eax
  803d25:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2b:	c1 e0 04             	shl    $0x4,%eax
  803d2e:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803d33:	89 10                	mov    %edx,(%eax)
			b = next;
  803d35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803d3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d3f:	0f 85 2a ff ff ff    	jne    803c6f <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d48:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803d4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d51:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803d57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803d5b:	75 17                	jne    803d74 <free_block+0x2cb>
  803d5d:	83 ec 04             	sub    $0x4,%esp
  803d60:	68 c0 49 80 00       	push   $0x8049c0
  803d65:	68 bc 00 00 00       	push   $0xbc
  803d6a:	68 b7 48 80 00       	push   $0x8048b7
  803d6f:	e8 9f 00 00 00       	call   803e13 <_panic>
  803d74:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d7d:	89 10                	mov    %edx,(%eax)
  803d7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d82:	8b 00                	mov    (%eax),%eax
  803d84:	85 c0                	test   %eax,%eax
  803d86:	74 0d                	je     803d95 <free_block+0x2ec>
  803d88:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803d8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d90:	89 50 04             	mov    %edx,0x4(%eax)
  803d93:	eb 08                	jmp    803d9d <free_block+0x2f4>
  803d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d98:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803da0:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803da5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803da8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803daf:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803db4:	40                   	inc    %eax
  803db5:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803dba:	83 ec 0c             	sub    $0xc,%esp
  803dbd:	ff 75 ec             	pushl  -0x14(%ebp)
  803dc0:	e8 7e f5 ff ff       	call   803343 <to_page_va>
  803dc5:	83 c4 10             	add    $0x10,%esp
  803dc8:	83 ec 0c             	sub    $0xc,%esp
  803dcb:	50                   	push   %eax
  803dcc:	e8 fe d7 ff ff       	call   8015cf <return_page>
  803dd1:	83 c4 10             	add    $0x10,%esp
	}
}
  803dd4:	90                   	nop
  803dd5:	c9                   	leave  
  803dd6:	c3                   	ret    

00803dd7 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  803dd7:	55                   	push   %ebp
  803dd8:	89 e5                	mov    %esp,%ebp
  803dda:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  803ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  803de0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  803de3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803de7:	83 ec 0c             	sub    $0xc,%esp
  803dea:	50                   	push   %eax
  803deb:	e8 5f f1 ff ff       	call   802f4f <sys_cputc>
  803df0:	83 c4 10             	add    $0x10,%esp
}
  803df3:	90                   	nop
  803df4:	c9                   	leave  
  803df5:	c3                   	ret    

00803df6 <getchar>:


int
getchar(void)
{
  803df6:	55                   	push   %ebp
  803df7:	89 e5                	mov    %esp,%ebp
  803df9:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803dfc:	e8 ed ef ff ff       	call   802dee <sys_cgetc>
  803e01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  803e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803e07:	c9                   	leave  
  803e08:	c3                   	ret    

00803e09 <iscons>:

int iscons(int fdnum)
{
  803e09:	55                   	push   %ebp
  803e0a:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803e0c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e11:	5d                   	pop    %ebp
  803e12:	c3                   	ret    

00803e13 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803e13:	55                   	push   %ebp
  803e14:	89 e5                	mov    %esp,%ebp
  803e16:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803e19:	8d 45 10             	lea    0x10(%ebp),%eax
  803e1c:	83 c0 04             	add    $0x4,%eax
  803e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803e22:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803e27:	85 c0                	test   %eax,%eax
  803e29:	74 16                	je     803e41 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803e2b:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803e30:	83 ec 08             	sub    $0x8,%esp
  803e33:	50                   	push   %eax
  803e34:	68 1c 4a 80 00       	push   $0x804a1c
  803e39:	e8 07 c6 ff ff       	call   800445 <cprintf>
  803e3e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803e41:	a1 04 50 80 00       	mov    0x805004,%eax
  803e46:	83 ec 0c             	sub    $0xc,%esp
  803e49:	ff 75 0c             	pushl  0xc(%ebp)
  803e4c:	ff 75 08             	pushl  0x8(%ebp)
  803e4f:	50                   	push   %eax
  803e50:	68 24 4a 80 00       	push   $0x804a24
  803e55:	6a 74                	push   $0x74
  803e57:	e8 16 c6 ff ff       	call   800472 <cprintf_colored>
  803e5c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  803e62:	83 ec 08             	sub    $0x8,%esp
  803e65:	ff 75 f4             	pushl  -0xc(%ebp)
  803e68:	50                   	push   %eax
  803e69:	e8 68 c5 ff ff       	call   8003d6 <vcprintf>
  803e6e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803e71:	83 ec 08             	sub    $0x8,%esp
  803e74:	6a 00                	push   $0x0
  803e76:	68 4c 4a 80 00       	push   $0x804a4c
  803e7b:	e8 56 c5 ff ff       	call   8003d6 <vcprintf>
  803e80:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803e83:	e8 cf c4 ff ff       	call   800357 <exit>

	// should not return here
	while (1) ;
  803e88:	eb fe                	jmp    803e88 <_panic+0x75>

00803e8a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803e8a:	55                   	push   %ebp
  803e8b:	89 e5                	mov    %esp,%ebp
  803e8d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803e90:	a1 20 50 80 00       	mov    0x805020,%eax
  803e95:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e9e:	39 c2                	cmp    %eax,%edx
  803ea0:	74 14                	je     803eb6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803ea2:	83 ec 04             	sub    $0x4,%esp
  803ea5:	68 50 4a 80 00       	push   $0x804a50
  803eaa:	6a 26                	push   $0x26
  803eac:	68 9c 4a 80 00       	push   $0x804a9c
  803eb1:	e8 5d ff ff ff       	call   803e13 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803eb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803ebd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803ec4:	e9 c5 00 00 00       	jmp    803f8e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ecc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed6:	01 d0                	add    %edx,%eax
  803ed8:	8b 00                	mov    (%eax),%eax
  803eda:	85 c0                	test   %eax,%eax
  803edc:	75 08                	jne    803ee6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803ede:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803ee1:	e9 a5 00 00 00       	jmp    803f8b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803ee6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803eed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ef4:	eb 69                	jmp    803f5f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803ef6:	a1 20 50 80 00       	mov    0x805020,%eax
  803efb:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803f01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f04:	89 d0                	mov    %edx,%eax
  803f06:	01 c0                	add    %eax,%eax
  803f08:	01 d0                	add    %edx,%eax
  803f0a:	c1 e0 03             	shl    $0x3,%eax
  803f0d:	01 c8                	add    %ecx,%eax
  803f0f:	8a 40 04             	mov    0x4(%eax),%al
  803f12:	84 c0                	test   %al,%al
  803f14:	75 46                	jne    803f5c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803f16:	a1 20 50 80 00       	mov    0x805020,%eax
  803f1b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803f21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f24:	89 d0                	mov    %edx,%eax
  803f26:	01 c0                	add    %eax,%eax
  803f28:	01 d0                	add    %edx,%eax
  803f2a:	c1 e0 03             	shl    $0x3,%eax
  803f2d:	01 c8                	add    %ecx,%eax
  803f2f:	8b 00                	mov    (%eax),%eax
  803f31:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803f34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803f3c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f41:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803f48:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4b:	01 c8                	add    %ecx,%eax
  803f4d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803f4f:	39 c2                	cmp    %eax,%edx
  803f51:	75 09                	jne    803f5c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803f53:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803f5a:	eb 15                	jmp    803f71 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803f5c:	ff 45 e8             	incl   -0x18(%ebp)
  803f5f:	a1 20 50 80 00       	mov    0x805020,%eax
  803f64:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803f6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f6d:	39 c2                	cmp    %eax,%edx
  803f6f:	77 85                	ja     803ef6 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803f71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803f75:	75 14                	jne    803f8b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803f77:	83 ec 04             	sub    $0x4,%esp
  803f7a:	68 a8 4a 80 00       	push   $0x804aa8
  803f7f:	6a 3a                	push   $0x3a
  803f81:	68 9c 4a 80 00       	push   $0x804a9c
  803f86:	e8 88 fe ff ff       	call   803e13 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803f8b:	ff 45 f0             	incl   -0x10(%ebp)
  803f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f91:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803f94:	0f 8c 2f ff ff ff    	jl     803ec9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803f9a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803fa1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803fa8:	eb 26                	jmp    803fd0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803faa:	a1 20 50 80 00       	mov    0x805020,%eax
  803faf:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803fb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803fb8:	89 d0                	mov    %edx,%eax
  803fba:	01 c0                	add    %eax,%eax
  803fbc:	01 d0                	add    %edx,%eax
  803fbe:	c1 e0 03             	shl    $0x3,%eax
  803fc1:	01 c8                	add    %ecx,%eax
  803fc3:	8a 40 04             	mov    0x4(%eax),%al
  803fc6:	3c 01                	cmp    $0x1,%al
  803fc8:	75 03                	jne    803fcd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803fca:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803fcd:	ff 45 e0             	incl   -0x20(%ebp)
  803fd0:	a1 20 50 80 00       	mov    0x805020,%eax
  803fd5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803fdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fde:	39 c2                	cmp    %eax,%edx
  803fe0:	77 c8                	ja     803faa <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803fe8:	74 14                	je     803ffe <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803fea:	83 ec 04             	sub    $0x4,%esp
  803fed:	68 fc 4a 80 00       	push   $0x804afc
  803ff2:	6a 44                	push   $0x44
  803ff4:	68 9c 4a 80 00       	push   $0x804a9c
  803ff9:	e8 15 fe ff ff       	call   803e13 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803ffe:	90                   	nop
  803fff:	c9                   	leave  
  804000:	c3                   	ret    
  804001:	66 90                	xchg   %ax,%ax
  804003:	90                   	nop

00804004 <__udivdi3>:
  804004:	55                   	push   %ebp
  804005:	57                   	push   %edi
  804006:	56                   	push   %esi
  804007:	53                   	push   %ebx
  804008:	83 ec 1c             	sub    $0x1c,%esp
  80400b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80400f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804013:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804017:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80401b:	89 ca                	mov    %ecx,%edx
  80401d:	89 f8                	mov    %edi,%eax
  80401f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804023:	85 f6                	test   %esi,%esi
  804025:	75 2d                	jne    804054 <__udivdi3+0x50>
  804027:	39 cf                	cmp    %ecx,%edi
  804029:	77 65                	ja     804090 <__udivdi3+0x8c>
  80402b:	89 fd                	mov    %edi,%ebp
  80402d:	85 ff                	test   %edi,%edi
  80402f:	75 0b                	jne    80403c <__udivdi3+0x38>
  804031:	b8 01 00 00 00       	mov    $0x1,%eax
  804036:	31 d2                	xor    %edx,%edx
  804038:	f7 f7                	div    %edi
  80403a:	89 c5                	mov    %eax,%ebp
  80403c:	31 d2                	xor    %edx,%edx
  80403e:	89 c8                	mov    %ecx,%eax
  804040:	f7 f5                	div    %ebp
  804042:	89 c1                	mov    %eax,%ecx
  804044:	89 d8                	mov    %ebx,%eax
  804046:	f7 f5                	div    %ebp
  804048:	89 cf                	mov    %ecx,%edi
  80404a:	89 fa                	mov    %edi,%edx
  80404c:	83 c4 1c             	add    $0x1c,%esp
  80404f:	5b                   	pop    %ebx
  804050:	5e                   	pop    %esi
  804051:	5f                   	pop    %edi
  804052:	5d                   	pop    %ebp
  804053:	c3                   	ret    
  804054:	39 ce                	cmp    %ecx,%esi
  804056:	77 28                	ja     804080 <__udivdi3+0x7c>
  804058:	0f bd fe             	bsr    %esi,%edi
  80405b:	83 f7 1f             	xor    $0x1f,%edi
  80405e:	75 40                	jne    8040a0 <__udivdi3+0x9c>
  804060:	39 ce                	cmp    %ecx,%esi
  804062:	72 0a                	jb     80406e <__udivdi3+0x6a>
  804064:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804068:	0f 87 9e 00 00 00    	ja     80410c <__udivdi3+0x108>
  80406e:	b8 01 00 00 00       	mov    $0x1,%eax
  804073:	89 fa                	mov    %edi,%edx
  804075:	83 c4 1c             	add    $0x1c,%esp
  804078:	5b                   	pop    %ebx
  804079:	5e                   	pop    %esi
  80407a:	5f                   	pop    %edi
  80407b:	5d                   	pop    %ebp
  80407c:	c3                   	ret    
  80407d:	8d 76 00             	lea    0x0(%esi),%esi
  804080:	31 ff                	xor    %edi,%edi
  804082:	31 c0                	xor    %eax,%eax
  804084:	89 fa                	mov    %edi,%edx
  804086:	83 c4 1c             	add    $0x1c,%esp
  804089:	5b                   	pop    %ebx
  80408a:	5e                   	pop    %esi
  80408b:	5f                   	pop    %edi
  80408c:	5d                   	pop    %ebp
  80408d:	c3                   	ret    
  80408e:	66 90                	xchg   %ax,%ax
  804090:	89 d8                	mov    %ebx,%eax
  804092:	f7 f7                	div    %edi
  804094:	31 ff                	xor    %edi,%edi
  804096:	89 fa                	mov    %edi,%edx
  804098:	83 c4 1c             	add    $0x1c,%esp
  80409b:	5b                   	pop    %ebx
  80409c:	5e                   	pop    %esi
  80409d:	5f                   	pop    %edi
  80409e:	5d                   	pop    %ebp
  80409f:	c3                   	ret    
  8040a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040a5:	89 eb                	mov    %ebp,%ebx
  8040a7:	29 fb                	sub    %edi,%ebx
  8040a9:	89 f9                	mov    %edi,%ecx
  8040ab:	d3 e6                	shl    %cl,%esi
  8040ad:	89 c5                	mov    %eax,%ebp
  8040af:	88 d9                	mov    %bl,%cl
  8040b1:	d3 ed                	shr    %cl,%ebp
  8040b3:	89 e9                	mov    %ebp,%ecx
  8040b5:	09 f1                	or     %esi,%ecx
  8040b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040bb:	89 f9                	mov    %edi,%ecx
  8040bd:	d3 e0                	shl    %cl,%eax
  8040bf:	89 c5                	mov    %eax,%ebp
  8040c1:	89 d6                	mov    %edx,%esi
  8040c3:	88 d9                	mov    %bl,%cl
  8040c5:	d3 ee                	shr    %cl,%esi
  8040c7:	89 f9                	mov    %edi,%ecx
  8040c9:	d3 e2                	shl    %cl,%edx
  8040cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040cf:	88 d9                	mov    %bl,%cl
  8040d1:	d3 e8                	shr    %cl,%eax
  8040d3:	09 c2                	or     %eax,%edx
  8040d5:	89 d0                	mov    %edx,%eax
  8040d7:	89 f2                	mov    %esi,%edx
  8040d9:	f7 74 24 0c          	divl   0xc(%esp)
  8040dd:	89 d6                	mov    %edx,%esi
  8040df:	89 c3                	mov    %eax,%ebx
  8040e1:	f7 e5                	mul    %ebp
  8040e3:	39 d6                	cmp    %edx,%esi
  8040e5:	72 19                	jb     804100 <__udivdi3+0xfc>
  8040e7:	74 0b                	je     8040f4 <__udivdi3+0xf0>
  8040e9:	89 d8                	mov    %ebx,%eax
  8040eb:	31 ff                	xor    %edi,%edi
  8040ed:	e9 58 ff ff ff       	jmp    80404a <__udivdi3+0x46>
  8040f2:	66 90                	xchg   %ax,%ax
  8040f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040f8:	89 f9                	mov    %edi,%ecx
  8040fa:	d3 e2                	shl    %cl,%edx
  8040fc:	39 c2                	cmp    %eax,%edx
  8040fe:	73 e9                	jae    8040e9 <__udivdi3+0xe5>
  804100:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804103:	31 ff                	xor    %edi,%edi
  804105:	e9 40 ff ff ff       	jmp    80404a <__udivdi3+0x46>
  80410a:	66 90                	xchg   %ax,%ax
  80410c:	31 c0                	xor    %eax,%eax
  80410e:	e9 37 ff ff ff       	jmp    80404a <__udivdi3+0x46>
  804113:	90                   	nop

00804114 <__umoddi3>:
  804114:	55                   	push   %ebp
  804115:	57                   	push   %edi
  804116:	56                   	push   %esi
  804117:	53                   	push   %ebx
  804118:	83 ec 1c             	sub    $0x1c,%esp
  80411b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80411f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804123:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804127:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80412b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80412f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804133:	89 f3                	mov    %esi,%ebx
  804135:	89 fa                	mov    %edi,%edx
  804137:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80413b:	89 34 24             	mov    %esi,(%esp)
  80413e:	85 c0                	test   %eax,%eax
  804140:	75 1a                	jne    80415c <__umoddi3+0x48>
  804142:	39 f7                	cmp    %esi,%edi
  804144:	0f 86 a2 00 00 00    	jbe    8041ec <__umoddi3+0xd8>
  80414a:	89 c8                	mov    %ecx,%eax
  80414c:	89 f2                	mov    %esi,%edx
  80414e:	f7 f7                	div    %edi
  804150:	89 d0                	mov    %edx,%eax
  804152:	31 d2                	xor    %edx,%edx
  804154:	83 c4 1c             	add    $0x1c,%esp
  804157:	5b                   	pop    %ebx
  804158:	5e                   	pop    %esi
  804159:	5f                   	pop    %edi
  80415a:	5d                   	pop    %ebp
  80415b:	c3                   	ret    
  80415c:	39 f0                	cmp    %esi,%eax
  80415e:	0f 87 ac 00 00 00    	ja     804210 <__umoddi3+0xfc>
  804164:	0f bd e8             	bsr    %eax,%ebp
  804167:	83 f5 1f             	xor    $0x1f,%ebp
  80416a:	0f 84 ac 00 00 00    	je     80421c <__umoddi3+0x108>
  804170:	bf 20 00 00 00       	mov    $0x20,%edi
  804175:	29 ef                	sub    %ebp,%edi
  804177:	89 fe                	mov    %edi,%esi
  804179:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80417d:	89 e9                	mov    %ebp,%ecx
  80417f:	d3 e0                	shl    %cl,%eax
  804181:	89 d7                	mov    %edx,%edi
  804183:	89 f1                	mov    %esi,%ecx
  804185:	d3 ef                	shr    %cl,%edi
  804187:	09 c7                	or     %eax,%edi
  804189:	89 e9                	mov    %ebp,%ecx
  80418b:	d3 e2                	shl    %cl,%edx
  80418d:	89 14 24             	mov    %edx,(%esp)
  804190:	89 d8                	mov    %ebx,%eax
  804192:	d3 e0                	shl    %cl,%eax
  804194:	89 c2                	mov    %eax,%edx
  804196:	8b 44 24 08          	mov    0x8(%esp),%eax
  80419a:	d3 e0                	shl    %cl,%eax
  80419c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041a4:	89 f1                	mov    %esi,%ecx
  8041a6:	d3 e8                	shr    %cl,%eax
  8041a8:	09 d0                	or     %edx,%eax
  8041aa:	d3 eb                	shr    %cl,%ebx
  8041ac:	89 da                	mov    %ebx,%edx
  8041ae:	f7 f7                	div    %edi
  8041b0:	89 d3                	mov    %edx,%ebx
  8041b2:	f7 24 24             	mull   (%esp)
  8041b5:	89 c6                	mov    %eax,%esi
  8041b7:	89 d1                	mov    %edx,%ecx
  8041b9:	39 d3                	cmp    %edx,%ebx
  8041bb:	0f 82 87 00 00 00    	jb     804248 <__umoddi3+0x134>
  8041c1:	0f 84 91 00 00 00    	je     804258 <__umoddi3+0x144>
  8041c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041cb:	29 f2                	sub    %esi,%edx
  8041cd:	19 cb                	sbb    %ecx,%ebx
  8041cf:	89 d8                	mov    %ebx,%eax
  8041d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041d5:	d3 e0                	shl    %cl,%eax
  8041d7:	89 e9                	mov    %ebp,%ecx
  8041d9:	d3 ea                	shr    %cl,%edx
  8041db:	09 d0                	or     %edx,%eax
  8041dd:	89 e9                	mov    %ebp,%ecx
  8041df:	d3 eb                	shr    %cl,%ebx
  8041e1:	89 da                	mov    %ebx,%edx
  8041e3:	83 c4 1c             	add    $0x1c,%esp
  8041e6:	5b                   	pop    %ebx
  8041e7:	5e                   	pop    %esi
  8041e8:	5f                   	pop    %edi
  8041e9:	5d                   	pop    %ebp
  8041ea:	c3                   	ret    
  8041eb:	90                   	nop
  8041ec:	89 fd                	mov    %edi,%ebp
  8041ee:	85 ff                	test   %edi,%edi
  8041f0:	75 0b                	jne    8041fd <__umoddi3+0xe9>
  8041f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8041f7:	31 d2                	xor    %edx,%edx
  8041f9:	f7 f7                	div    %edi
  8041fb:	89 c5                	mov    %eax,%ebp
  8041fd:	89 f0                	mov    %esi,%eax
  8041ff:	31 d2                	xor    %edx,%edx
  804201:	f7 f5                	div    %ebp
  804203:	89 c8                	mov    %ecx,%eax
  804205:	f7 f5                	div    %ebp
  804207:	89 d0                	mov    %edx,%eax
  804209:	e9 44 ff ff ff       	jmp    804152 <__umoddi3+0x3e>
  80420e:	66 90                	xchg   %ax,%ax
  804210:	89 c8                	mov    %ecx,%eax
  804212:	89 f2                	mov    %esi,%edx
  804214:	83 c4 1c             	add    $0x1c,%esp
  804217:	5b                   	pop    %ebx
  804218:	5e                   	pop    %esi
  804219:	5f                   	pop    %edi
  80421a:	5d                   	pop    %ebp
  80421b:	c3                   	ret    
  80421c:	3b 04 24             	cmp    (%esp),%eax
  80421f:	72 06                	jb     804227 <__umoddi3+0x113>
  804221:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804225:	77 0f                	ja     804236 <__umoddi3+0x122>
  804227:	89 f2                	mov    %esi,%edx
  804229:	29 f9                	sub    %edi,%ecx
  80422b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80422f:	89 14 24             	mov    %edx,(%esp)
  804232:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804236:	8b 44 24 04          	mov    0x4(%esp),%eax
  80423a:	8b 14 24             	mov    (%esp),%edx
  80423d:	83 c4 1c             	add    $0x1c,%esp
  804240:	5b                   	pop    %ebx
  804241:	5e                   	pop    %esi
  804242:	5f                   	pop    %edi
  804243:	5d                   	pop    %ebp
  804244:	c3                   	ret    
  804245:	8d 76 00             	lea    0x0(%esi),%esi
  804248:	2b 04 24             	sub    (%esp),%eax
  80424b:	19 fa                	sbb    %edi,%edx
  80424d:	89 d1                	mov    %edx,%ecx
  80424f:	89 c6                	mov    %eax,%esi
  804251:	e9 71 ff ff ff       	jmp    8041c7 <__umoddi3+0xb3>
  804256:	66 90                	xchg   %ax,%ax
  804258:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80425c:	72 ea                	jb     804248 <__umoddi3+0x134>
  80425e:	89 d9                	mov    %ebx,%ecx
  804260:	e9 62 ff ff ff       	jmp    8041c7 <__umoddi3+0xb3>
