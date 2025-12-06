
obj/user/tst_protection_slave1:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 58 4e 00 00    	sub    $0x4e58,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800041:	a1 20 50 80 00       	mov    0x805020,%eax
  800046:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
  800051:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800057:	39 c2                	cmp    %eax,%edx
  800059:	72 14                	jb     80006f <_main+0x37>
			panic("Please increase the WS size");
  80005b:	83 ec 04             	sub    $0x4,%esp
  80005e:	68 c0 3f 80 00       	push   $0x803fc0
  800063:	6a 12                	push   $0x12
  800065:	68 dc 3f 80 00       	push   $0x803fdc
  80006a:	e8 79 02 00 00       	call   8002e8 <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	{
		char initname[10] = "x";
  80006f:	c7 45 e6 78 00 00 00 	movl   $0x78,-0x1a(%ebp)
  800076:	c7 45 ea 00 00 00 00 	movl   $0x0,-0x16(%ebp)
  80007d:	66 c7 45 ee 00 00    	movw   $0x0,-0x12(%ebp)
		char name[10] ;
#define NUM_OF_OBJS 5000
		uint32* vars[NUM_OF_OBJS];
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  800083:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80008a:	eb 5d                	jmp    8000e9 <_main+0xb1>
		{
			char index[10];
			ltostr(s, index);
  80008c:	83 ec 08             	sub    $0x8,%esp
  80008f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
  800092:	50                   	push   %eax
  800093:	ff 75 f4             	pushl  -0xc(%ebp)
  800096:	e8 49 11 00 00       	call   8011e4 <ltostr>
  80009b:	83 c4 10             	add    $0x10,%esp
			strcconcat(initname, index, name);
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000a4:	50                   	push   %eax
  8000a5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
  8000a8:	50                   	push   %eax
  8000a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8000ac:	50                   	push   %eax
  8000ad:	e8 0b 12 00 00       	call   8012bd <strcconcat>
  8000b2:	83 c4 10             	add    $0x10,%esp
			vars[s] = smalloc(name, PAGE_SIZE, 1);
  8000b5:	83 ec 04             	sub    $0x4,%esp
  8000b8:	6a 01                	push   $0x1
  8000ba:	68 00 10 00 00       	push   $0x1000
  8000bf:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000c2:	50                   	push   %eax
  8000c3:	e8 1d 1c 00 00       	call   801ce5 <smalloc>
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	89 c2                	mov    %eax,%edx
  8000cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d0:	89 94 85 b0 b1 ff ff 	mov    %edx,-0x4e50(%ebp,%eax,4)
			*vars[s] = s;
  8000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000da:	8b 84 85 b0 b1 ff ff 	mov    -0x4e50(%ebp,%eax,4),%eax
  8000e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000e4:	89 10                	mov    %edx,(%eax)
	{
		char initname[10] = "x";
		char name[10] ;
#define NUM_OF_OBJS 5000
		uint32* vars[NUM_OF_OBJS];
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	81 7d f4 87 13 00 00 	cmpl   $0x1387,-0xc(%ebp)
  8000f0:	7e 9a                	jle    80008c <_main+0x54>
			ltostr(s, index);
			strcconcat(initname, index, name);
			vars[s] = smalloc(name, PAGE_SIZE, 1);
			*vars[s] = s;
		}
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  8000f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000f9:	eb 2c                	jmp    800127 <_main+0xef>
		{
			assert(*vars[s] == s);
  8000fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000fe:	8b 84 85 b0 b1 ff ff 	mov    -0x4e50(%ebp,%eax,4),%eax
  800105:	8b 10                	mov    (%eax),%edx
  800107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010a:	39 c2                	cmp    %eax,%edx
  80010c:	74 16                	je     800124 <_main+0xec>
  80010e:	68 f9 3f 80 00       	push   $0x803ff9
  800113:	68 07 40 80 00       	push   $0x804007
  800118:	6a 28                	push   $0x28
  80011a:	68 dc 3f 80 00       	push   $0x803fdc
  80011f:	e8 c4 01 00 00       	call   8002e8 <_panic>
			ltostr(s, index);
			strcconcat(initname, index, name);
			vars[s] = smalloc(name, PAGE_SIZE, 1);
			*vars[s] = s;
		}
		for (int s = 0; s < NUM_OF_OBJS; ++s)
  800124:	ff 45 f0             	incl   -0x10(%ebp)
  800127:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
  80012e:	7e cb                	jle    8000fb <_main+0xc3>
		{
			assert(*vars[s] == s);
		}
	}

	inctst();
  800130:	e8 f2 2f 00 00       	call   803127 <inctst>
}
  800135:	90                   	nop
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	57                   	push   %edi
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
  80013e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800141:	e8 a3 2e 00 00       	call   802fe9 <sys_getenvindex>
  800146:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 03             	shl    $0x3,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c1 e0 02             	shl    $0x2,%eax
  800156:	01 d0                	add    %edx,%eax
  800158:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015f:	01 d0                	add    %edx,%eax
  800161:	c1 e0 03             	shl    $0x3,%eax
  800164:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800169:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016e:	a1 20 50 80 00       	mov    0x805020,%eax
  800173:	8a 40 20             	mov    0x20(%eax),%al
  800176:	84 c0                	test   %al,%al
  800178:	74 0d                	je     800187 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80017a:	a1 20 50 80 00       	mov    0x805020,%eax
  80017f:	83 c0 20             	add    $0x20,%eax
  800182:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800187:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018b:	7e 0a                	jle    800197 <libmain+0x5f>
		binaryname = argv[0];
  80018d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800190:	8b 00                	mov    (%eax),%eax
  800192:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 0c             	pushl  0xc(%ebp)
  80019d:	ff 75 08             	pushl  0x8(%ebp)
  8001a0:	e8 93 fe ff ff       	call   800038 <_main>
  8001a5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a8:	a1 00 50 80 00       	mov    0x805000,%eax
  8001ad:	85 c0                	test   %eax,%eax
  8001af:	0f 84 01 01 00 00    	je     8002b6 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001b5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001bb:	bb 14 41 80 00       	mov    $0x804114,%ebx
  8001c0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	89 de                	mov    %ebx,%esi
  8001c9:	89 d1                	mov    %edx,%ecx
  8001cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001cd:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001d0:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001d5:	b0 00                	mov    $0x0,%al
  8001d7:	89 d7                	mov    %edx,%edi
  8001d9:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001db:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	50                   	push   %eax
  8001e9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	e8 2a 30 00 00       	call   80321f <sys_utilities>
  8001f5:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f8:	e8 73 2b 00 00       	call   802d70 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	68 34 40 80 00       	push   $0x804034
  800205:	e8 ac 03 00 00       	call   8005b6 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80020d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800210:	85 c0                	test   %eax,%eax
  800212:	74 18                	je     80022c <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800214:	e8 24 30 00 00       	call   80323d <sys_get_optimal_num_faults>
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	50                   	push   %eax
  80021d:	68 5c 40 80 00       	push   $0x80405c
  800222:	e8 8f 03 00 00       	call   8005b6 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	eb 59                	jmp    800285 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80022c:	a1 20 50 80 00       	mov    0x805020,%eax
  800231:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800237:	a1 20 50 80 00       	mov    0x805020,%eax
  80023c:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	68 80 40 80 00       	push   $0x804080
  80024c:	e8 65 03 00 00       	call   8005b6 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800254:	a1 20 50 80 00       	mov    0x805020,%eax
  800259:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80025f:	a1 20 50 80 00       	mov    0x805020,%eax
  800264:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80026a:	a1 20 50 80 00       	mov    0x805020,%eax
  80026f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800275:	51                   	push   %ecx
  800276:	52                   	push   %edx
  800277:	50                   	push   %eax
  800278:	68 a8 40 80 00       	push   $0x8040a8
  80027d:	e8 34 03 00 00       	call   8005b6 <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800285:	a1 20 50 80 00       	mov    0x805020,%eax
  80028a:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	50                   	push   %eax
  800294:	68 00 41 80 00       	push   $0x804100
  800299:	e8 18 03 00 00       	call   8005b6 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 34 40 80 00       	push   $0x804034
  8002a9:	e8 08 03 00 00       	call   8005b6 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002b1:	e8 d4 2a 00 00       	call   802d8a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002b6:	e8 1f 00 00 00       	call   8002da <exit>
}
  8002bb:	90                   	nop
  8002bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    

008002c4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	e8 e1 2c 00 00       	call   802fb5 <sys_destroy_env>
  8002d4:	83 c4 10             	add    $0x10,%esp
}
  8002d7:	90                   	nop
  8002d8:	c9                   	leave  
  8002d9:	c3                   	ret    

008002da <exit>:

void
exit(void)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e0:	e8 36 2d 00 00       	call   80301b <sys_exit_env>
}
  8002e5:	90                   	nop
  8002e6:	c9                   	leave  
  8002e7:	c3                   	ret    

008002e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f1:	83 c0 04             	add    $0x4,%eax
  8002f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f7:	a1 38 51 83 00       	mov    0x835138,%eax
  8002fc:	85 c0                	test   %eax,%eax
  8002fe:	74 16                	je     800316 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800300:	a1 38 51 83 00       	mov    0x835138,%eax
  800305:	83 ec 08             	sub    $0x8,%esp
  800308:	50                   	push   %eax
  800309:	68 78 41 80 00       	push   $0x804178
  80030e:	e8 a3 02 00 00       	call   8005b6 <cprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800316:	a1 04 50 80 00       	mov    0x805004,%eax
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	50                   	push   %eax
  800325:	68 80 41 80 00       	push   $0x804180
  80032a:	6a 74                	push   $0x74
  80032c:	e8 b2 02 00 00       	call   8005e3 <cprintf_colored>
  800331:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800334:	8b 45 10             	mov    0x10(%ebp),%eax
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	ff 75 f4             	pushl  -0xc(%ebp)
  80033d:	50                   	push   %eax
  80033e:	e8 04 02 00 00       	call   800547 <vcprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	6a 00                	push   $0x0
  80034b:	68 a8 41 80 00       	push   $0x8041a8
  800350:	e8 f2 01 00 00       	call   800547 <vcprintf>
  800355:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800358:	e8 7d ff ff ff       	call   8002da <exit>

	// should not return here
	while (1) ;
  80035d:	eb fe                	jmp    80035d <_panic+0x75>

0080035f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800365:	a1 20 50 80 00       	mov    0x805020,%eax
  80036a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800370:	8b 45 0c             	mov    0xc(%ebp),%eax
  800373:	39 c2                	cmp    %eax,%edx
  800375:	74 14                	je     80038b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	68 ac 41 80 00       	push   $0x8041ac
  80037f:	6a 26                	push   $0x26
  800381:	68 f8 41 80 00       	push   $0x8041f8
  800386:	e8 5d ff ff ff       	call   8002e8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80038b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800399:	e9 c5 00 00 00       	jmp    800463 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80039e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ab:	01 d0                	add    %edx,%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	75 08                	jne    8003bb <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003b3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003b6:	e9 a5 00 00 00       	jmp    800460 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c9:	eb 69                	jmp    800434 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d0:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d9:	89 d0                	mov    %edx,%eax
  8003db:	01 c0                	add    %eax,%eax
  8003dd:	01 d0                	add    %edx,%eax
  8003df:	c1 e0 03             	shl    $0x3,%eax
  8003e2:	01 c8                	add    %ecx,%eax
  8003e4:	8a 40 04             	mov    0x4(%eax),%al
  8003e7:	84 c0                	test   %al,%al
  8003e9:	75 46                	jne    800431 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f0:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	01 c0                	add    %eax,%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	c1 e0 03             	shl    $0x3,%eax
  800402:	01 c8                	add    %ecx,%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800409:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800411:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800416:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	01 c8                	add    %ecx,%eax
  800422:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800424:	39 c2                	cmp    %eax,%edx
  800426:	75 09                	jne    800431 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800428:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80042f:	eb 15                	jmp    800446 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e8             	incl   -0x18(%ebp)
  800434:	a1 20 50 80 00       	mov    0x805020,%eax
  800439:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80043f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800442:	39 c2                	cmp    %eax,%edx
  800444:	77 85                	ja     8003cb <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800446:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80044a:	75 14                	jne    800460 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 04 42 80 00       	push   $0x804204
  800454:	6a 3a                	push   $0x3a
  800456:	68 f8 41 80 00       	push   $0x8041f8
  80045b:	e8 88 fe ff ff       	call   8002e8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800460:	ff 45 f0             	incl   -0x10(%ebp)
  800463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800466:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800469:	0f 8c 2f ff ff ff    	jl     80039e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80046f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800476:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80047d:	eb 26                	jmp    8004a5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80047f:	a1 20 50 80 00       	mov    0x805020,%eax
  800484:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80048a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80048d:	89 d0                	mov    %edx,%eax
  80048f:	01 c0                	add    %eax,%eax
  800491:	01 d0                	add    %edx,%eax
  800493:	c1 e0 03             	shl    $0x3,%eax
  800496:	01 c8                	add    %ecx,%eax
  800498:	8a 40 04             	mov    0x4(%eax),%al
  80049b:	3c 01                	cmp    $0x1,%al
  80049d:	75 03                	jne    8004a2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80049f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a2:	ff 45 e0             	incl   -0x20(%ebp)
  8004a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004aa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b3:	39 c2                	cmp    %eax,%edx
  8004b5:	77 c8                	ja     80047f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ba:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004bd:	74 14                	je     8004d3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004bf:	83 ec 04             	sub    $0x4,%esp
  8004c2:	68 58 42 80 00       	push   $0x804258
  8004c7:	6a 44                	push   $0x44
  8004c9:	68 f8 41 80 00       	push   $0x8041f8
  8004ce:	e8 15 fe ff ff       	call   8002e8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	53                   	push   %ebx
  8004da:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	8d 48 01             	lea    0x1(%eax),%ecx
  8004e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e8:	89 0a                	mov    %ecx,(%edx)
  8004ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ed:	88 d1                	mov    %dl,%cl
  8004ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800500:	75 30                	jne    800532 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800502:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800508:	a0 64 d0 81 00       	mov    0x81d064,%al
  80050d:	0f b6 c0             	movzbl %al,%eax
  800510:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800513:	8b 09                	mov    (%ecx),%ecx
  800515:	89 cb                	mov    %ecx,%ebx
  800517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051a:	83 c1 08             	add    $0x8,%ecx
  80051d:	52                   	push   %edx
  80051e:	50                   	push   %eax
  80051f:	53                   	push   %ebx
  800520:	51                   	push   %ecx
  800521:	e8 06 28 00 00       	call   802d2c <sys_cputs>
  800526:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800532:	8b 45 0c             	mov    0xc(%ebp),%eax
  800535:	8b 40 04             	mov    0x4(%eax),%eax
  800538:	8d 50 01             	lea    0x1(%eax),%edx
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800541:	90                   	nop
  800542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800550:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800557:	00 00 00 
	b.cnt = 0;
  80055a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800561:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800564:	ff 75 0c             	pushl  0xc(%ebp)
  800567:	ff 75 08             	pushl  0x8(%ebp)
  80056a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800570:	50                   	push   %eax
  800571:	68 d6 04 80 00       	push   $0x8004d6
  800576:	e8 5a 02 00 00       	call   8007d5 <vprintfmt>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80057e:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800584:	a0 64 d0 81 00       	mov    0x81d064,%al
  800589:	0f b6 c0             	movzbl %al,%eax
  80058c:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800592:	52                   	push   %edx
  800593:	50                   	push   %eax
  800594:	51                   	push   %ecx
  800595:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059b:	83 c0 08             	add    $0x8,%eax
  80059e:	50                   	push   %eax
  80059f:	e8 88 27 00 00       	call   802d2c <sys_cputs>
  8005a4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005a7:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  8005ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005b4:	c9                   	leave  
  8005b5:	c3                   	ret    

008005b6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005bc:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  8005c3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d2:	50                   	push   %eax
  8005d3:	e8 6f ff ff ff       	call   800547 <vcprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e1:	c9                   	leave  
  8005e2:	c3                   	ret    

008005e3 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
  8005e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e9:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	c1 e0 08             	shl    $0x8,%eax
  8005f6:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  8005fb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005fe:	83 c0 04             	add    $0x4,%eax
  800601:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800604:	8b 45 0c             	mov    0xc(%ebp),%eax
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	ff 75 f4             	pushl  -0xc(%ebp)
  80060d:	50                   	push   %eax
  80060e:	e8 34 ff ff ff       	call   800547 <vcprintf>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800619:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  800620:	07 00 00 

	return cnt;
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800626:	c9                   	leave  
  800627:	c3                   	ret    

00800628 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80062e:	e8 3d 27 00 00       	call   802d70 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800633:	8d 45 0c             	lea    0xc(%ebp),%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	ff 75 f4             	pushl  -0xc(%ebp)
  800642:	50                   	push   %eax
  800643:	e8 ff fe ff ff       	call   800547 <vcprintf>
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80064e:	e8 37 27 00 00       	call   802d8a <sys_unlock_cons>
	return cnt;
  800653:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
  80065b:	53                   	push   %ebx
  80065c:	83 ec 14             	sub    $0x14,%esp
  80065f:	8b 45 10             	mov    0x10(%ebp),%eax
  800662:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80066b:	8b 45 18             	mov    0x18(%ebp),%eax
  80066e:	ba 00 00 00 00       	mov    $0x0,%edx
  800673:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800676:	77 55                	ja     8006cd <printnum+0x75>
  800678:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80067b:	72 05                	jb     800682 <printnum+0x2a>
  80067d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800680:	77 4b                	ja     8006cd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800682:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800685:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800688:	8b 45 18             	mov    0x18(%ebp),%eax
  80068b:	ba 00 00 00 00       	mov    $0x0,%edx
  800690:	52                   	push   %edx
  800691:	50                   	push   %eax
  800692:	ff 75 f4             	pushl  -0xc(%ebp)
  800695:	ff 75 f0             	pushl  -0x10(%ebp)
  800698:	e8 a3 36 00 00       	call   803d40 <__udivdi3>
  80069d:	83 c4 10             	add    $0x10,%esp
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	ff 75 20             	pushl  0x20(%ebp)
  8006a6:	53                   	push   %ebx
  8006a7:	ff 75 18             	pushl  0x18(%ebp)
  8006aa:	52                   	push   %edx
  8006ab:	50                   	push   %eax
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	ff 75 08             	pushl  0x8(%ebp)
  8006b2:	e8 a1 ff ff ff       	call   800658 <printnum>
  8006b7:	83 c4 20             	add    $0x20,%esp
  8006ba:	eb 1a                	jmp    8006d6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	ff 75 20             	pushl  0x20(%ebp)
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	ff d0                	call   *%eax
  8006ca:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006cd:	ff 4d 1c             	decl   0x1c(%ebp)
  8006d0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006d4:	7f e6                	jg     8006bc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e4:	53                   	push   %ebx
  8006e5:	51                   	push   %ecx
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	e8 63 37 00 00       	call   803e50 <__umoddi3>
  8006ed:	83 c4 10             	add    $0x10,%esp
  8006f0:	05 d4 44 80 00       	add    $0x8044d4,%eax
  8006f5:	8a 00                	mov    (%eax),%al
  8006f7:	0f be c0             	movsbl %al,%eax
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	ff 75 0c             	pushl  0xc(%ebp)
  800700:	50                   	push   %eax
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	ff d0                	call   *%eax
  800706:	83 c4 10             	add    $0x10,%esp
}
  800709:	90                   	nop
  80070a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80070d:	c9                   	leave  
  80070e:	c3                   	ret    

0080070f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80070f:	55                   	push   %ebp
  800710:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800712:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800716:	7e 1c                	jle    800734 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	8b 00                	mov    (%eax),%eax
  80071d:	8d 50 08             	lea    0x8(%eax),%edx
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	89 10                	mov    %edx,(%eax)
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	83 e8 08             	sub    $0x8,%eax
  80072d:	8b 50 04             	mov    0x4(%eax),%edx
  800730:	8b 00                	mov    (%eax),%eax
  800732:	eb 40                	jmp    800774 <getuint+0x65>
	else if (lflag)
  800734:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800738:	74 1e                	je     800758 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	8d 50 04             	lea    0x4(%eax),%edx
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	89 10                	mov    %edx,(%eax)
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	83 e8 04             	sub    $0x4,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	ba 00 00 00 00       	mov    $0x0,%edx
  800756:	eb 1c                	jmp    800774 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	8d 50 04             	lea    0x4(%eax),%edx
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	89 10                	mov    %edx,(%eax)
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	83 e8 04             	sub    $0x4,%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800774:	5d                   	pop    %ebp
  800775:	c3                   	ret    

00800776 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800779:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80077d:	7e 1c                	jle    80079b <getint+0x25>
		return va_arg(*ap, long long);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 08             	lea    0x8(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 08             	sub    $0x8,%eax
  800794:	8b 50 04             	mov    0x4(%eax),%edx
  800797:	8b 00                	mov    (%eax),%eax
  800799:	eb 38                	jmp    8007d3 <getint+0x5d>
	else if (lflag)
  80079b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80079f:	74 1a                	je     8007bb <getint+0x45>
		return va_arg(*ap, long);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	99                   	cltd   
  8007b9:	eb 18                	jmp    8007d3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	8d 50 04             	lea    0x4(%eax),%edx
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	89 10                	mov    %edx,(%eax)
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	83 e8 04             	sub    $0x4,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	99                   	cltd   
}
  8007d3:	5d                   	pop    %ebp
  8007d4:	c3                   	ret    

008007d5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	56                   	push   %esi
  8007d9:	53                   	push   %ebx
  8007da:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007dd:	eb 17                	jmp    8007f6 <vprintfmt+0x21>
			if (ch == '\0')
  8007df:	85 db                	test   %ebx,%ebx
  8007e1:	0f 84 c1 03 00 00    	je     800ba8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	53                   	push   %ebx
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	ff d0                	call   *%eax
  8007f3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f9:	8d 50 01             	lea    0x1(%eax),%edx
  8007fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ff:	8a 00                	mov    (%eax),%al
  800801:	0f b6 d8             	movzbl %al,%ebx
  800804:	83 fb 25             	cmp    $0x25,%ebx
  800807:	75 d6                	jne    8007df <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800809:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80080d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800814:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80081b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800822:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800829:	8b 45 10             	mov    0x10(%ebp),%eax
  80082c:	8d 50 01             	lea    0x1(%eax),%edx
  80082f:	89 55 10             	mov    %edx,0x10(%ebp)
  800832:	8a 00                	mov    (%eax),%al
  800834:	0f b6 d8             	movzbl %al,%ebx
  800837:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80083a:	83 f8 5b             	cmp    $0x5b,%eax
  80083d:	0f 87 3d 03 00 00    	ja     800b80 <vprintfmt+0x3ab>
  800843:	8b 04 85 f8 44 80 00 	mov    0x8044f8(,%eax,4),%eax
  80084a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80084c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800850:	eb d7                	jmp    800829 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800852:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800856:	eb d1                	jmp    800829 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800858:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80085f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800862:	89 d0                	mov    %edx,%eax
  800864:	c1 e0 02             	shl    $0x2,%eax
  800867:	01 d0                	add    %edx,%eax
  800869:	01 c0                	add    %eax,%eax
  80086b:	01 d8                	add    %ebx,%eax
  80086d:	83 e8 30             	sub    $0x30,%eax
  800870:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800873:	8b 45 10             	mov    0x10(%ebp),%eax
  800876:	8a 00                	mov    (%eax),%al
  800878:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80087b:	83 fb 2f             	cmp    $0x2f,%ebx
  80087e:	7e 3e                	jle    8008be <vprintfmt+0xe9>
  800880:	83 fb 39             	cmp    $0x39,%ebx
  800883:	7f 39                	jg     8008be <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800885:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800888:	eb d5                	jmp    80085f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 c0 04             	add    $0x4,%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	83 e8 04             	sub    $0x4,%eax
  800899:	8b 00                	mov    (%eax),%eax
  80089b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80089e:	eb 1f                	jmp    8008bf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a4:	79 83                	jns    800829 <vprintfmt+0x54>
				width = 0;
  8008a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008ad:	e9 77 ff ff ff       	jmp    800829 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008b2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008b9:	e9 6b ff ff ff       	jmp    800829 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008be:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c3:	0f 89 60 ff ff ff    	jns    800829 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008cf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008d6:	e9 4e ff ff ff       	jmp    800829 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008db:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008de:	e9 46 ff ff ff       	jmp    800829 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	83 c0 04             	add    $0x4,%eax
  8008e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	83 e8 04             	sub    $0x4,%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	50                   	push   %eax
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	ff d0                	call   *%eax
  800900:	83 c4 10             	add    $0x10,%esp
			break;
  800903:	e9 9b 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800908:	8b 45 14             	mov    0x14(%ebp),%eax
  80090b:	83 c0 04             	add    $0x4,%eax
  80090e:	89 45 14             	mov    %eax,0x14(%ebp)
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	83 e8 04             	sub    $0x4,%eax
  800917:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800919:	85 db                	test   %ebx,%ebx
  80091b:	79 02                	jns    80091f <vprintfmt+0x14a>
				err = -err;
  80091d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80091f:	83 fb 64             	cmp    $0x64,%ebx
  800922:	7f 0b                	jg     80092f <vprintfmt+0x15a>
  800924:	8b 34 9d 40 43 80 00 	mov    0x804340(,%ebx,4),%esi
  80092b:	85 f6                	test   %esi,%esi
  80092d:	75 19                	jne    800948 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80092f:	53                   	push   %ebx
  800930:	68 e5 44 80 00       	push   $0x8044e5
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	e8 70 02 00 00       	call   800bb0 <printfmt>
  800940:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800943:	e9 5b 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800948:	56                   	push   %esi
  800949:	68 ee 44 80 00       	push   $0x8044ee
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 57 02 00 00       	call   800bb0 <printfmt>
  800959:	83 c4 10             	add    $0x10,%esp
			break;
  80095c:	e9 42 02 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	83 c0 04             	add    $0x4,%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 30                	mov    (%eax),%esi
  800972:	85 f6                	test   %esi,%esi
  800974:	75 05                	jne    80097b <vprintfmt+0x1a6>
				p = "(null)";
  800976:	be f1 44 80 00       	mov    $0x8044f1,%esi
			if (width > 0 && padc != '-')
  80097b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097f:	7e 6d                	jle    8009ee <vprintfmt+0x219>
  800981:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800985:	74 67                	je     8009ee <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800987:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	50                   	push   %eax
  80098e:	56                   	push   %esi
  80098f:	e8 1e 03 00 00       	call   800cb2 <strnlen>
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80099a:	eb 16                	jmp    8009b2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80099c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 0c             	pushl  0xc(%ebp)
  8009a6:	50                   	push   %eax
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	ff d0                	call   *%eax
  8009ac:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009af:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	7f e4                	jg     80099c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b8:	eb 34                	jmp    8009ee <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009be:	74 1c                	je     8009dc <vprintfmt+0x207>
  8009c0:	83 fb 1f             	cmp    $0x1f,%ebx
  8009c3:	7e 05                	jle    8009ca <vprintfmt+0x1f5>
  8009c5:	83 fb 7e             	cmp    $0x7e,%ebx
  8009c8:	7e 12                	jle    8009dc <vprintfmt+0x207>
					putch('?', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 3f                	push   $0x3f
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
  8009da:	eb 0f                	jmp    8009eb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	53                   	push   %ebx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ee:	89 f0                	mov    %esi,%eax
  8009f0:	8d 70 01             	lea    0x1(%eax),%esi
  8009f3:	8a 00                	mov    (%eax),%al
  8009f5:	0f be d8             	movsbl %al,%ebx
  8009f8:	85 db                	test   %ebx,%ebx
  8009fa:	74 24                	je     800a20 <vprintfmt+0x24b>
  8009fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a00:	78 b8                	js     8009ba <vprintfmt+0x1e5>
  800a02:	ff 4d e0             	decl   -0x20(%ebp)
  800a05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a09:	79 af                	jns    8009ba <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	eb 13                	jmp    800a20 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 20                	push   $0x20
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a24:	7f e7                	jg     800a0d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a26:	e9 78 01 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a31:	8d 45 14             	lea    0x14(%ebp),%eax
  800a34:	50                   	push   %eax
  800a35:	e8 3c fd ff ff       	call   800776 <getint>
  800a3a:	83 c4 10             	add    $0x10,%esp
  800a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a49:	85 d2                	test   %edx,%edx
  800a4b:	79 23                	jns    800a70 <vprintfmt+0x29b>
				putch('-', putdat);
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	6a 2d                	push   $0x2d
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	ff d0                	call   *%eax
  800a5a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a63:	f7 d8                	neg    %eax
  800a65:	83 d2 00             	adc    $0x0,%edx
  800a68:	f7 da                	neg    %edx
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a70:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a77:	e9 bc 00 00 00       	jmp    800b38 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a82:	8d 45 14             	lea    0x14(%ebp),%eax
  800a85:	50                   	push   %eax
  800a86:	e8 84 fc ff ff       	call   80070f <getuint>
  800a8b:	83 c4 10             	add    $0x10,%esp
  800a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a94:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9b:	e9 98 00 00 00       	jmp    800b38 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	6a 58                	push   $0x58
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	ff d0                	call   *%eax
  800aad:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	6a 58                	push   $0x58
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	ff d0                	call   *%eax
  800abd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	6a 58                	push   $0x58
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	e9 ce 00 00 00       	jmp    800ba3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 30                	push   $0x30
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ae5:	83 ec 08             	sub    $0x8,%esp
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	6a 78                	push   $0x78
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	ff d0                	call   *%eax
  800af2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800af5:	8b 45 14             	mov    0x14(%ebp),%eax
  800af8:	83 c0 04             	add    $0x4,%eax
  800afb:	89 45 14             	mov    %eax,0x14(%ebp)
  800afe:	8b 45 14             	mov    0x14(%ebp),%eax
  800b01:	83 e8 04             	sub    $0x4,%eax
  800b04:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b17:	eb 1f                	jmp    800b38 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b22:	50                   	push   %eax
  800b23:	e8 e7 fb ff ff       	call   80070f <getuint>
  800b28:	83 c4 10             	add    $0x10,%esp
  800b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b31:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b38:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b3f:	83 ec 04             	sub    $0x4,%esp
  800b42:	52                   	push   %edx
  800b43:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b46:	50                   	push   %eax
  800b47:	ff 75 f4             	pushl  -0xc(%ebp)
  800b4a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	ff 75 08             	pushl  0x8(%ebp)
  800b53:	e8 00 fb ff ff       	call   800658 <printnum>
  800b58:	83 c4 20             	add    $0x20,%esp
			break;
  800b5b:	eb 46                	jmp    800ba3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	53                   	push   %ebx
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			break;
  800b6c:	eb 35                	jmp    800ba3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b6e:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800b75:	eb 2c                	jmp    800ba3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b77:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800b7e:	eb 23                	jmp    800ba3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	6a 25                	push   $0x25
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b90:	ff 4d 10             	decl   0x10(%ebp)
  800b93:	eb 03                	jmp    800b98 <vprintfmt+0x3c3>
  800b95:	ff 4d 10             	decl   0x10(%ebp)
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	48                   	dec    %eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	3c 25                	cmp    $0x25,%al
  800ba0:	75 f3                	jne    800b95 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ba2:	90                   	nop
		}
	}
  800ba3:	e9 35 fc ff ff       	jmp    8007dd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ba8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ba9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb9:	83 c0 04             	add    $0x4,%eax
  800bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc5:	50                   	push   %eax
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	ff 75 08             	pushl  0x8(%ebp)
  800bcc:	e8 04 fc ff ff       	call   8007d5 <vprintfmt>
  800bd1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bd4:	90                   	nop
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	8b 40 08             	mov    0x8(%eax),%eax
  800be0:	8d 50 01             	lea    0x1(%eax),%edx
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bec:	8b 10                	mov    (%eax),%edx
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	8b 40 04             	mov    0x4(%eax),%eax
  800bf4:	39 c2                	cmp    %eax,%edx
  800bf6:	73 12                	jae    800c0a <sprintputch+0x33>
		*b->buf++ = ch;
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	8d 48 01             	lea    0x1(%eax),%ecx
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c03:	89 0a                	mov    %ecx,(%edx)
  800c05:	8b 55 08             	mov    0x8(%ebp),%edx
  800c08:	88 10                	mov    %dl,(%eax)
}
  800c0a:	90                   	nop
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	01 d0                	add    %edx,%eax
  800c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c32:	74 06                	je     800c3a <vsnprintf+0x2d>
  800c34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c38:	7f 07                	jg     800c41 <vsnprintf+0x34>
		return -E_INVAL;
  800c3a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c3f:	eb 20                	jmp    800c61 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c41:	ff 75 14             	pushl  0x14(%ebp)
  800c44:	ff 75 10             	pushl  0x10(%ebp)
  800c47:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c4a:	50                   	push   %eax
  800c4b:	68 d7 0b 80 00       	push   $0x800bd7
  800c50:	e8 80 fb ff ff       	call   8007d5 <vprintfmt>
  800c55:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c5b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c69:	8d 45 10             	lea    0x10(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	ff 75 f4             	pushl  -0xc(%ebp)
  800c78:	50                   	push   %eax
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 08             	pushl  0x8(%ebp)
  800c7f:	e8 89 ff ff ff       	call   800c0d <vsnprintf>
  800c84:	83 c4 10             	add    $0x10,%esp
  800c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9c:	eb 06                	jmp    800ca4 <strlen+0x15>
		n++;
  800c9e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca1:	ff 45 08             	incl   0x8(%ebp)
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	84 c0                	test   %al,%al
  800cab:	75 f1                	jne    800c9e <strlen+0xf>
		n++;
	return n;
  800cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb0:	c9                   	leave  
  800cb1:	c3                   	ret    

00800cb2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cbf:	eb 09                	jmp    800cca <strnlen+0x18>
		n++;
  800cc1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc4:	ff 45 08             	incl   0x8(%ebp)
  800cc7:	ff 4d 0c             	decl   0xc(%ebp)
  800cca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cce:	74 09                	je     800cd9 <strnlen+0x27>
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	84 c0                	test   %al,%al
  800cd7:	75 e8                	jne    800cc1 <strnlen+0xf>
		n++;
	return n;
  800cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cea:	90                   	nop
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8d 50 01             	lea    0x1(%eax),%edx
  800cf1:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cfa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cfd:	8a 12                	mov    (%edx),%dl
  800cff:	88 10                	mov    %dl,(%eax)
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	75 e4                	jne    800ceb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0a:	c9                   	leave  
  800d0b:	c3                   	ret    

00800d0c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1f:	eb 1f                	jmp    800d40 <strncpy+0x34>
		*dst++ = *src;
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8d 50 01             	lea    0x1(%eax),%edx
  800d27:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2d:	8a 12                	mov    (%edx),%dl
  800d2f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	84 c0                	test   %al,%al
  800d38:	74 03                	je     800d3d <strncpy+0x31>
			src++;
  800d3a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d3d:	ff 45 fc             	incl   -0x4(%ebp)
  800d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d46:	72 d9                	jb     800d21 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d48:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 30                	je     800d8f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d5f:	eb 16                	jmp    800d77 <strlcpy+0x2a>
			*dst++ = *src++;
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d77:	ff 4d 10             	decl   0x10(%ebp)
  800d7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7e:	74 09                	je     800d89 <strlcpy+0x3c>
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	75 d8                	jne    800d61 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d95:	29 c2                	sub    %eax,%edx
  800d97:	89 d0                	mov    %edx,%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d9e:	eb 06                	jmp    800da6 <strcmp+0xb>
		p++, q++;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	84 c0                	test   %al,%al
  800dad:	74 0e                	je     800dbd <strcmp+0x22>
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8a 10                	mov    (%eax),%dl
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	38 c2                	cmp    %al,%dl
  800dbb:	74 e3                	je     800da0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	0f b6 d0             	movzbl %al,%edx
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	0f b6 c0             	movzbl %al,%eax
  800dcd:	29 c2                	sub    %eax,%edx
  800dcf:	89 d0                	mov    %edx,%eax
}
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dd6:	eb 09                	jmp    800de1 <strncmp+0xe>
		n--, p++, q++;
  800dd8:	ff 4d 10             	decl   0x10(%ebp)
  800ddb:	ff 45 08             	incl   0x8(%ebp)
  800dde:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800de1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de5:	74 17                	je     800dfe <strncmp+0x2b>
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	84 c0                	test   %al,%al
  800dee:	74 0e                	je     800dfe <strncmp+0x2b>
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	8a 10                	mov    (%eax),%dl
  800df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	38 c2                	cmp    %al,%dl
  800dfc:	74 da                	je     800dd8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e02:	75 07                	jne    800e0b <strncmp+0x38>
		return 0;
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
  800e09:	eb 14                	jmp    800e1f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	0f b6 d0             	movzbl %al,%edx
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	0f b6 c0             	movzbl %al,%eax
  800e1b:	29 c2                	sub    %eax,%edx
  800e1d:	89 d0                	mov    %edx,%eax
}
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 04             	sub    $0x4,%esp
  800e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2d:	eb 12                	jmp    800e41 <strchr+0x20>
		if (*s == c)
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	8a 00                	mov    (%eax),%al
  800e34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e37:	75 05                	jne    800e3e <strchr+0x1d>
			return (char *) s;
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	eb 11                	jmp    800e4f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e3e:	ff 45 08             	incl   0x8(%ebp)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	75 e5                	jne    800e2f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    

00800e51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 04             	sub    $0x4,%esp
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e5d:	eb 0d                	jmp    800e6c <strfind+0x1b>
		if (*s == c)
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e67:	74 0e                	je     800e77 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	84 c0                	test   %al,%al
  800e73:	75 ea                	jne    800e5f <strfind+0xe>
  800e75:	eb 01                	jmp    800e78 <strfind+0x27>
		if (*s == c)
			break;
  800e77:	90                   	nop
	return (char *) s;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e89:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e8d:	76 63                	jbe    800ef2 <memset+0x75>
		uint64 data_block = c;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	99                   	cltd   
  800e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e96:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9f:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ea3:	c1 e0 08             	shl    $0x8,%eax
  800ea6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb2:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eb6:	c1 e0 10             	shl    $0x10,%eax
  800eb9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ebc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec5:	89 c2                	mov    %eax,%edx
  800ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ecf:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ed2:	eb 18                	jmp    800eec <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ed4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed7:	8d 41 08             	lea    0x8(%ecx),%eax
  800eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee3:	89 01                	mov    %eax,(%ecx)
  800ee5:	89 51 04             	mov    %edx,0x4(%ecx)
  800ee8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eec:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef0:	77 e2                	ja     800ed4 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 23                	je     800f1b <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800efe:	eb 0e                	jmp    800f0e <memset+0x91>
			*p8++ = (uint8)c;
  800f00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f03:	8d 50 01             	lea    0x1(%eax),%edx
  800f06:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0c:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f14:	89 55 10             	mov    %edx,0x10(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 e5                	jne    800f00 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f32:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f36:	76 24                	jbe    800f5c <memcpy+0x3c>
		while(n >= 8){
  800f38:	eb 1c                	jmp    800f56 <memcpy+0x36>
			*d64 = *s64;
  800f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3d:	8b 50 04             	mov    0x4(%eax),%edx
  800f40:	8b 00                	mov    (%eax),%eax
  800f42:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f45:	89 01                	mov    %eax,(%ecx)
  800f47:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f4a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f4e:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f52:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f56:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f5a:	77 de                	ja     800f3a <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f60:	74 31                	je     800f93 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f6e:	eb 16                	jmp    800f86 <memcpy+0x66>
			*d8++ = *s8++;
  800f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f73:	8d 50 01             	lea    0x1(%eax),%edx
  800f76:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f7c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f82:	8a 12                	mov    (%edx),%dl
  800f84:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	75 dd                	jne    800f70 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb0:	73 50                	jae    801002 <memmove+0x6a>
  800fb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb8:	01 d0                	add    %edx,%eax
  800fba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fbd:	76 43                	jbe    801002 <memmove+0x6a>
		s += n;
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fcb:	eb 10                	jmp    800fdd <memmove+0x45>
			*--d = *--s;
  800fcd:	ff 4d f8             	decl   -0x8(%ebp)
  800fd0:	ff 4d fc             	decl   -0x4(%ebp)
  800fd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd6:	8a 10                	mov    (%eax),%dl
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe3:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	75 e3                	jne    800fcd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fea:	eb 23                	jmp    80100f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fef:	8d 50 01             	lea    0x1(%eax),%edx
  800ff2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ff5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ffb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ffe:	8a 12                	mov    (%edx),%dl
  801000:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801002:	8b 45 10             	mov    0x10(%ebp),%eax
  801005:	8d 50 ff             	lea    -0x1(%eax),%edx
  801008:	89 55 10             	mov    %edx,0x10(%ebp)
  80100b:	85 c0                	test   %eax,%eax
  80100d:	75 dd                	jne    800fec <memmove+0x54>
			*d++ = *s++;

	return dst;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801026:	eb 2a                	jmp    801052 <memcmp+0x3e>
		if (*s1 != *s2)
  801028:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102b:	8a 10                	mov    (%eax),%dl
  80102d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	38 c2                	cmp    %al,%dl
  801034:	74 16                	je     80104c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801036:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	0f b6 d0             	movzbl %al,%edx
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f b6 c0             	movzbl %al,%eax
  801046:	29 c2                	sub    %eax,%edx
  801048:	89 d0                	mov    %edx,%eax
  80104a:	eb 18                	jmp    801064 <memcmp+0x50>
		s1++, s2++;
  80104c:	ff 45 fc             	incl   -0x4(%ebp)
  80104f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801052:	8b 45 10             	mov    0x10(%ebp),%eax
  801055:	8d 50 ff             	lea    -0x1(%eax),%edx
  801058:	89 55 10             	mov    %edx,0x10(%ebp)
  80105b:	85 c0                	test   %eax,%eax
  80105d:	75 c9                	jne    801028 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80105f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80106c:	8b 55 08             	mov    0x8(%ebp),%edx
  80106f:	8b 45 10             	mov    0x10(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801077:	eb 15                	jmp    80108e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	0f b6 d0             	movzbl %al,%edx
  801081:	8b 45 0c             	mov    0xc(%ebp),%eax
  801084:	0f b6 c0             	movzbl %al,%eax
  801087:	39 c2                	cmp    %eax,%edx
  801089:	74 0d                	je     801098 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801094:	72 e3                	jb     801079 <memfind+0x13>
  801096:	eb 01                	jmp    801099 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801098:	90                   	nop
	return (void *) s;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b2:	eb 03                	jmp    8010b7 <strtol+0x19>
		s++;
  8010b4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 20                	cmp    $0x20,%al
  8010be:	74 f4                	je     8010b4 <strtol+0x16>
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 09                	cmp    $0x9,%al
  8010c7:	74 eb                	je     8010b4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 2b                	cmp    $0x2b,%al
  8010d0:	75 05                	jne    8010d7 <strtol+0x39>
		s++;
  8010d2:	ff 45 08             	incl   0x8(%ebp)
  8010d5:	eb 13                	jmp    8010ea <strtol+0x4c>
	else if (*s == '-')
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 2d                	cmp    $0x2d,%al
  8010de:	75 0a                	jne    8010ea <strtol+0x4c>
		s++, neg = 1;
  8010e0:	ff 45 08             	incl   0x8(%ebp)
  8010e3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ee:	74 06                	je     8010f6 <strtol+0x58>
  8010f0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010f4:	75 20                	jne    801116 <strtol+0x78>
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	3c 30                	cmp    $0x30,%al
  8010fd:	75 17                	jne    801116 <strtol+0x78>
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	40                   	inc    %eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 78                	cmp    $0x78,%al
  801107:	75 0d                	jne    801116 <strtol+0x78>
		s += 2, base = 16;
  801109:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80110d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801114:	eb 28                	jmp    80113e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801116:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80111a:	75 15                	jne    801131 <strtol+0x93>
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	3c 30                	cmp    $0x30,%al
  801123:	75 0c                	jne    801131 <strtol+0x93>
		s++, base = 8;
  801125:	ff 45 08             	incl   0x8(%ebp)
  801128:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80112f:	eb 0d                	jmp    80113e <strtol+0xa0>
	else if (base == 0)
  801131:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801135:	75 07                	jne    80113e <strtol+0xa0>
		base = 10;
  801137:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	3c 2f                	cmp    $0x2f,%al
  801145:	7e 19                	jle    801160 <strtol+0xc2>
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	3c 39                	cmp    $0x39,%al
  80114e:	7f 10                	jg     801160 <strtol+0xc2>
			dig = *s - '0';
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	0f be c0             	movsbl %al,%eax
  801158:	83 e8 30             	sub    $0x30,%eax
  80115b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115e:	eb 42                	jmp    8011a2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	3c 60                	cmp    $0x60,%al
  801167:	7e 19                	jle    801182 <strtol+0xe4>
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	3c 7a                	cmp    $0x7a,%al
  801170:	7f 10                	jg     801182 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	0f be c0             	movsbl %al,%eax
  80117a:	83 e8 57             	sub    $0x57,%eax
  80117d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801180:	eb 20                	jmp    8011a2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 40                	cmp    $0x40,%al
  801189:	7e 39                	jle    8011c4 <strtol+0x126>
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	3c 5a                	cmp    $0x5a,%al
  801192:	7f 30                	jg     8011c4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	0f be c0             	movsbl %al,%eax
  80119c:	83 e8 37             	sub    $0x37,%eax
  80119f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a8:	7d 19                	jge    8011c3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011aa:	ff 45 08             	incl   0x8(%ebp)
  8011ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011b4:	89 c2                	mov    %eax,%edx
  8011b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b9:	01 d0                	add    %edx,%eax
  8011bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011be:	e9 7b ff ff ff       	jmp    80113e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011c3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c8:	74 08                	je     8011d2 <strtol+0x134>
		*endptr = (char *) s;
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011d6:	74 07                	je     8011df <strtol+0x141>
  8011d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011db:	f7 d8                	neg    %eax
  8011dd:	eb 03                	jmp    8011e2 <strtol+0x144>
  8011df:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <ltostr>:

void
ltostr(long value, char *str)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011fc:	79 13                	jns    801211 <ltostr+0x2d>
	{
		neg = 1;
  8011fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80120b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801219:	99                   	cltd   
  80121a:	f7 f9                	idiv   %ecx
  80121c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80121f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801228:	89 c2                	mov    %eax,%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801232:	83 c2 30             	add    $0x30,%edx
  801235:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801237:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80123f:	f7 e9                	imul   %ecx
  801241:	c1 fa 02             	sar    $0x2,%edx
  801244:	89 c8                	mov    %ecx,%eax
  801246:	c1 f8 1f             	sar    $0x1f,%eax
  801249:	29 c2                	sub    %eax,%edx
  80124b:	89 d0                	mov    %edx,%eax
  80124d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801254:	75 bb                	jne    801211 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80125d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801260:	48                   	dec    %eax
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801264:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801268:	74 3d                	je     8012a7 <ltostr+0xc3>
		start = 1 ;
  80126a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801271:	eb 34                	jmp    8012a7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801273:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	01 d0                	add    %edx,%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801280:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 c2                	add    %eax,%edx
  801288:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	01 c8                	add    %ecx,%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801294:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 c2                	add    %eax,%edx
  80129c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80129f:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ad:	7c c4                	jl     801273 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 d0                	add    %edx,%eax
  8012b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012ba:	90                   	nop
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012c3:	ff 75 08             	pushl  0x8(%ebp)
  8012c6:	e8 c4 f9 ff ff       	call   800c8f <strlen>
  8012cb:	83 c4 04             	add    $0x4,%esp
  8012ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	e8 b6 f9 ff ff       	call   800c8f <strlen>
  8012d9:	83 c4 04             	add    $0x4,%esp
  8012dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ed:	eb 17                	jmp    801306 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f5:	01 c2                	add    %eax,%edx
  8012f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	01 c8                	add    %ecx,%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801303:	ff 45 fc             	incl   -0x4(%ebp)
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801309:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80130c:	7c e1                	jl     8012ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80130e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801315:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80131c:	eb 1f                	jmp    80133d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80131e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801321:	8d 50 01             	lea    0x1(%eax),%edx
  801324:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801327:	89 c2                	mov    %eax,%edx
  801329:	8b 45 10             	mov    0x10(%ebp),%eax
  80132c:	01 c2                	add    %eax,%edx
  80132e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	01 c8                	add    %ecx,%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80133a:	ff 45 f8             	incl   -0x8(%ebp)
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801343:	7c d9                	jl     80131e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	c6 00 00             	movb   $0x0,(%eax)
}
  801350:	90                   	nop
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801356:	8b 45 14             	mov    0x14(%ebp),%eax
  801359:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80135f:	8b 45 14             	mov    0x14(%ebp),%eax
  801362:	8b 00                	mov    (%eax),%eax
  801364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136b:	8b 45 10             	mov    0x10(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801376:	eb 0c                	jmp    801384 <strsplit+0x31>
			*string++ = 0;
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	8d 50 01             	lea    0x1(%eax),%edx
  80137e:	89 55 08             	mov    %edx,0x8(%ebp)
  801381:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	84 c0                	test   %al,%al
  80138b:	74 18                	je     8013a5 <strsplit+0x52>
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	0f be c0             	movsbl %al,%eax
  801395:	50                   	push   %eax
  801396:	ff 75 0c             	pushl  0xc(%ebp)
  801399:	e8 83 fa ff ff       	call   800e21 <strchr>
  80139e:	83 c4 08             	add    $0x8,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	75 d3                	jne    801378 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	84 c0                	test   %al,%al
  8013ac:	74 5a                	je     801408 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b1:	8b 00                	mov    (%eax),%eax
  8013b3:	83 f8 0f             	cmp    $0xf,%eax
  8013b6:	75 07                	jne    8013bf <strsplit+0x6c>
		{
			return 0;
  8013b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bd:	eb 66                	jmp    801425 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c2:	8b 00                	mov    (%eax),%eax
  8013c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ca:	89 0a                	mov    %ecx,(%edx)
  8013cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d6:	01 c2                	add    %eax,%edx
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013dd:	eb 03                	jmp    8013e2 <strsplit+0x8f>
			string++;
  8013df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	84 c0                	test   %al,%al
  8013e9:	74 8b                	je     801376 <strsplit+0x23>
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	0f be c0             	movsbl %al,%eax
  8013f3:	50                   	push   %eax
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	e8 25 fa ff ff       	call   800e21 <strchr>
  8013fc:	83 c4 08             	add    $0x8,%esp
  8013ff:	85 c0                	test   %eax,%eax
  801401:	74 dc                	je     8013df <strsplit+0x8c>
			string++;
	}
  801403:	e9 6e ff ff ff       	jmp    801376 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801408:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801409:	8b 45 14             	mov    0x14(%ebp),%eax
  80140c:	8b 00                	mov    (%eax),%eax
  80140e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801415:	8b 45 10             	mov    0x10(%ebp),%eax
  801418:	01 d0                	add    %edx,%eax
  80141a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801420:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801433:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143a:	eb 4a                	jmp    801486 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80143c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	01 c2                	add    %eax,%edx
  801444:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144a:	01 c8                	add    %ecx,%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801450:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	3c 40                	cmp    $0x40,%al
  80145c:	7e 25                	jle    801483 <str2lower+0x5c>
  80145e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801461:	8b 45 0c             	mov    0xc(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	3c 5a                	cmp    $0x5a,%al
  80146a:	7f 17                	jg     801483 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80146c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	01 d0                	add    %edx,%eax
  801474:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801477:	8b 55 08             	mov    0x8(%ebp),%edx
  80147a:	01 ca                	add    %ecx,%edx
  80147c:	8a 12                	mov    (%edx),%dl
  80147e:	83 c2 20             	add    $0x20,%edx
  801481:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801483:	ff 45 fc             	incl   -0x4(%ebp)
  801486:	ff 75 0c             	pushl  0xc(%ebp)
  801489:	e8 01 f8 ff ff       	call   800c8f <strlen>
  80148e:	83 c4 04             	add    $0x4,%esp
  801491:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801494:	7f a6                	jg     80143c <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801496:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014a1:	a1 08 50 80 00       	mov    0x805008,%eax
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	74 42                	je     8014ec <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	68 00 00 00 82       	push   $0x82000000
  8014b2:	68 00 00 00 80       	push   $0x80000000
  8014b7:	e8 b0 1e 00 00       	call   80336c <initialize_dynamic_allocator>
  8014bc:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014bf:	e8 96 1c 00 00       	call   80315a <sys_get_uheap_strategy>
  8014c4:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014c9:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8014ce:	05 00 10 00 00       	add    $0x1000,%eax
  8014d3:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8014d8:	a1 30 51 83 00       	mov    0x835130,%eax
  8014dd:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8014e2:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8014e9:	00 00 00 
	}
}
  8014ec:	90                   	nop
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	68 06 04 00 00       	push   $0x406
  80150b:	50                   	push   %eax
  80150c:	e8 93 18 00 00       	call   802da4 <__sys_allocate_page>
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801517:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80151b:	79 14                	jns    801531 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80151d:	83 ec 04             	sub    $0x4,%esp
  801520:	68 68 46 80 00       	push   $0x804668
  801525:	6a 1f                	push   $0x1f
  801527:	68 a4 46 80 00       	push   $0x8046a4
  80152c:	e8 b7 ed ff ff       	call   8002e8 <_panic>
	return 0;
  801531:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801547:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154c:	83 ec 0c             	sub    $0xc,%esp
  80154f:	50                   	push   %eax
  801550:	e8 96 18 00 00       	call   802deb <__sys_unmap_frame>
  801555:	83 c4 10             	add    $0x10,%esp
  801558:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80155b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80155f:	79 14                	jns    801575 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	68 b0 46 80 00       	push   $0x8046b0
  801569:	6a 2a                	push   $0x2a
  80156b:	68 a4 46 80 00       	push   $0x8046a4
  801570:	e8 73 ed ff ff       	call   8002e8 <_panic>
}
  801575:	90                   	nop
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80157e:	e8 18 ff ff ff       	call   80149b <uheap_init>
	if (size == 0) return NULL ;
  801583:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801587:	75 0a                	jne    801593 <malloc+0x1b>
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
  80158e:	e9 43 03 00 00       	jmp    8018d6 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801593:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80159a:	77 13                	ja     8015af <malloc+0x37>
    {
        return alloc_block(size);
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	ff 75 08             	pushl  0x8(%ebp)
  8015a2:	e8 78 20 00 00       	call   80361f <alloc_block>
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	e9 27 03 00 00       	jmp    8018d6 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8015af:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8015b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015bc:	01 d0                	add    %edx,%eax
  8015be:	48                   	dec    %eax
  8015bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ca:	f7 75 dc             	divl   -0x24(%ebp)
  8015cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015d0:	29 d0                	sub    %edx,%eax
  8015d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8015d5:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	75 0a                	jne    8015e8 <malloc+0x70>
    {
        uhp_inited = 1;
  8015de:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  8015e5:	00 00 00 
    }

    int exactIdx = -1;
  8015e8:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8015ef:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8015f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8015fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801604:	e9 85 00 00 00       	jmp    80168e <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801609:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80160c:	89 d0                	mov    %edx,%eax
  80160e:	01 c0                	add    %eax,%eax
  801610:	01 d0                	add    %edx,%eax
  801612:	c1 e0 02             	shl    $0x2,%eax
  801615:	05 48 10 81 00       	add    $0x811048,%eax
  80161a:	8a 00                	mov    (%eax),%al
  80161c:	84 c0                	test   %al,%al
  80161e:	74 20                	je     801640 <malloc+0xc8>
  801620:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801623:	89 d0                	mov    %edx,%eax
  801625:	01 c0                	add    %eax,%eax
  801627:	01 d0                	add    %edx,%eax
  801629:	c1 e0 02             	shl    $0x2,%eax
  80162c:	05 44 10 81 00       	add    $0x811044,%eax
  801631:	8b 00                	mov    (%eax),%eax
  801633:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801636:	75 08                	jne    801640 <malloc+0xc8>
        {
            exactIdx = i;
  801638:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80163b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80163e:	eb 5b                	jmp    80169b <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801640:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801643:	89 d0                	mov    %edx,%eax
  801645:	01 c0                	add    %eax,%eax
  801647:	01 d0                	add    %edx,%eax
  801649:	c1 e0 02             	shl    $0x2,%eax
  80164c:	05 48 10 81 00       	add    $0x811048,%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	84 c0                	test   %al,%al
  801655:	74 34                	je     80168b <malloc+0x113>
  801657:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80165a:	89 d0                	mov    %edx,%eax
  80165c:	01 c0                	add    %eax,%eax
  80165e:	01 d0                	add    %edx,%eax
  801660:	c1 e0 02             	shl    $0x2,%eax
  801663:	05 44 10 81 00       	add    $0x811044,%eax
  801668:	8b 00                	mov    (%eax),%eax
  80166a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80166d:	76 1c                	jbe    80168b <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  80166f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801672:	89 d0                	mov    %edx,%eax
  801674:	01 c0                	add    %eax,%eax
  801676:	01 d0                	add    %edx,%eax
  801678:	c1 e0 02             	shl    $0x2,%eax
  80167b:	05 44 10 81 00       	add    $0x811044,%eax
  801680:	8b 00                	mov    (%eax),%eax
  801682:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801685:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801688:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80168b:	ff 45 e8             	incl   -0x18(%ebp)
  80168e:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801695:	0f 8e 6e ff ff ff    	jle    801609 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  80169b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8016a2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8016a6:	74 7d                	je     801725 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8016a8:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8016af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b2:	89 d0                	mov    %edx,%eax
  8016b4:	01 c0                	add    %eax,%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	c1 e0 02             	shl    $0x2,%eax
  8016bb:	05 40 10 81 00       	add    $0x811040,%eax
  8016c0:	8b 10                	mov    (%eax),%edx
  8016c2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8016c5:	01 d0                	add    %edx,%eax
  8016c7:	48                   	dec    %eax
  8016c8:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8016cb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d3:	f7 75 bc             	divl   -0x44(%ebp)
  8016d6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8016d9:	29 d0                	sub    %edx,%eax
  8016db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8016de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e1:	89 d0                	mov    %edx,%eax
  8016e3:	01 c0                	add    %eax,%eax
  8016e5:	01 d0                	add    %edx,%eax
  8016e7:	c1 e0 02             	shl    $0x2,%eax
  8016ea:	05 48 10 81 00       	add    $0x811048,%eax
  8016ef:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8016f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f5:	89 d0                	mov    %edx,%eax
  8016f7:	01 c0                	add    %eax,%eax
  8016f9:	01 d0                	add    %edx,%eax
  8016fb:	c1 e0 02             	shl    $0x2,%eax
  8016fe:	05 44 10 81 00       	add    $0x811044,%eax
  801703:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170c:	89 d0                	mov    %edx,%eax
  80170e:	01 c0                	add    %eax,%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c1 e0 02             	shl    $0x2,%eax
  801715:	05 40 10 81 00       	add    $0x811040,%eax
  80171a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801720:	e9 2d 01 00 00       	jmp    801852 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801725:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801729:	0f 84 ce 00 00 00    	je     8017fd <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80172f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801736:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801739:	89 d0                	mov    %edx,%eax
  80173b:	01 c0                	add    %eax,%eax
  80173d:	01 d0                	add    %edx,%eax
  80173f:	c1 e0 02             	shl    $0x2,%eax
  801742:	05 40 10 81 00       	add    $0x811040,%eax
  801747:	8b 10                	mov    (%eax),%edx
  801749:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80174c:	01 d0                	add    %edx,%eax
  80174e:	48                   	dec    %eax
  80174f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801752:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801755:	ba 00 00 00 00       	mov    $0x0,%edx
  80175a:	f7 75 c4             	divl   -0x3c(%ebp)
  80175d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801760:	29 d0                	sub    %edx,%eax
  801762:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801765:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801768:	89 d0                	mov    %edx,%eax
  80176a:	01 c0                	add    %eax,%eax
  80176c:	01 d0                	add    %edx,%eax
  80176e:	c1 e0 02             	shl    $0x2,%eax
  801771:	05 44 10 81 00       	add    $0x811044,%eax
  801776:	8b 00                	mov    (%eax),%eax
  801778:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80177b:	75 47                	jne    8017c4 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  80177d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801780:	89 d0                	mov    %edx,%eax
  801782:	01 c0                	add    %eax,%eax
  801784:	01 d0                	add    %edx,%eax
  801786:	c1 e0 02             	shl    $0x2,%eax
  801789:	05 48 10 81 00       	add    $0x811048,%eax
  80178e:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801791:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801794:	89 d0                	mov    %edx,%eax
  801796:	01 c0                	add    %eax,%eax
  801798:	01 d0                	add    %edx,%eax
  80179a:	c1 e0 02             	shl    $0x2,%eax
  80179d:	05 44 10 81 00       	add    $0x811044,%eax
  8017a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8017a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ab:	89 d0                	mov    %edx,%eax
  8017ad:	01 c0                	add    %eax,%eax
  8017af:	01 d0                	add    %edx,%eax
  8017b1:	c1 e0 02             	shl    $0x2,%eax
  8017b4:	05 40 10 81 00       	add    $0x811040,%eax
  8017b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017bf:	e9 8e 00 00 00       	jmp    801852 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8017c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017ca:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8017cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d0:	89 d0                	mov    %edx,%eax
  8017d2:	01 c0                	add    %eax,%eax
  8017d4:	01 d0                	add    %edx,%eax
  8017d6:	c1 e0 02             	shl    $0x2,%eax
  8017d9:	05 40 10 81 00       	add    $0x811040,%eax
  8017de:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8017e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e3:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017e6:	89 c2                	mov    %eax,%edx
  8017e8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017eb:	89 c8                	mov    %ecx,%eax
  8017ed:	01 c0                	add    %eax,%eax
  8017ef:	01 c8                	add    %ecx,%eax
  8017f1:	c1 e0 02             	shl    $0x2,%eax
  8017f4:	05 44 10 81 00       	add    $0x811044,%eax
  8017f9:	89 10                	mov    %edx,(%eax)
  8017fb:	eb 55                	jmp    801852 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8017fd:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801804:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80180a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80180d:	01 d0                	add    %edx,%eax
  80180f:	48                   	dec    %eax
  801810:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801813:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801816:	ba 00 00 00 00       	mov    $0x0,%edx
  80181b:	f7 75 d0             	divl   -0x30(%ebp)
  80181e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801821:	29 d0                	sub    %edx,%eax
  801823:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801826:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801829:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80182c:	01 d0                	add    %edx,%eax
  80182e:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801833:	76 0a                	jbe    80183f <malloc+0x2c7>
            return NULL;
  801835:	b8 00 00 00 00       	mov    $0x0,%eax
  80183a:	e9 97 00 00 00       	jmp    8018d6 <malloc+0x35e>
        va = start;
  80183f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801845:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80184b:	01 d0                	add    %edx,%eax
  80184d:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801852:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801859:	eb 5e                	jmp    8018b9 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  80185b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80185e:	89 d0                	mov    %edx,%eax
  801860:	01 c0                	add    %eax,%eax
  801862:	01 d0                	add    %edx,%eax
  801864:	c1 e0 02             	shl    $0x2,%eax
  801867:	05 48 50 80 00       	add    $0x805048,%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	84 c0                	test   %al,%al
  801870:	75 44                	jne    8018b6 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801872:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801875:	89 d0                	mov    %edx,%eax
  801877:	01 c0                	add    %eax,%eax
  801879:	01 d0                	add    %edx,%eax
  80187b:	c1 e0 02             	shl    $0x2,%eax
  80187e:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801887:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801889:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80188c:	89 d0                	mov    %edx,%eax
  80188e:	01 c0                	add    %eax,%eax
  801890:	01 d0                	add    %edx,%eax
  801892:	c1 e0 02             	shl    $0x2,%eax
  801895:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80189b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80189e:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8018a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018a3:	89 d0                	mov    %edx,%eax
  8018a5:	01 c0                	add    %eax,%eax
  8018a7:	01 d0                	add    %edx,%eax
  8018a9:	c1 e0 02             	shl    $0x2,%eax
  8018ac:	05 48 50 80 00       	add    $0x805048,%eax
  8018b1:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8018b4:	eb 0c                	jmp    8018c2 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8018b6:	ff 45 e0             	incl   -0x20(%ebp)
  8018b9:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8018c0:	7e 99                	jle    80185b <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  8018c2:	83 ec 08             	sub    $0x8,%esp
  8018c5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8018c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018cb:	e8 a2 19 00 00       	call   803272 <sys_allocate_user_mem>
  8018d0:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8018d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8018de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018e2:	0f 84 fa 03 00 00    	je     801ce2 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8018ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	79 1c                	jns    801911 <free+0x39>
  8018f5:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  8018fc:	77 13                	ja     801911 <free+0x39>
    {
        free_block(virtual_address);
  8018fe:	83 ec 0c             	sub    $0xc,%esp
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 09 21 00 00       	call   803a12 <free_block>
  801909:	83 c4 10             	add    $0x10,%esp
        return;
  80190c:	e9 d2 03 00 00       	jmp    801ce3 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801911:	a1 30 51 83 00       	mov    0x835130,%eax
  801916:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801919:	72 09                	jb     801924 <free+0x4c>
  80191b:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801922:	76 17                	jbe    80193b <free+0x63>
        panic("free: invalid address");
  801924:	83 ec 04             	sub    $0x4,%esp
  801927:	68 ed 46 80 00       	push   $0x8046ed
  80192c:	68 9b 00 00 00       	push   $0x9b
  801931:	68 a4 46 80 00       	push   $0x8046a4
  801936:	e8 ad e9 ff ff       	call   8002e8 <_panic>

    uint32 size = 0;
  80193b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801942:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801949:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801950:	eb 50                	jmp    8019a2 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801952:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801955:	89 d0                	mov    %edx,%eax
  801957:	01 c0                	add    %eax,%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	c1 e0 02             	shl    $0x2,%eax
  80195e:	05 48 50 80 00       	add    $0x805048,%eax
  801963:	8a 00                	mov    (%eax),%al
  801965:	84 c0                	test   %al,%al
  801967:	74 36                	je     80199f <free+0xc7>
  801969:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80196c:	89 d0                	mov    %edx,%eax
  80196e:	01 c0                	add    %eax,%eax
  801970:	01 d0                	add    %edx,%eax
  801972:	c1 e0 02             	shl    $0x2,%eax
  801975:	05 40 50 80 00       	add    $0x805040,%eax
  80197a:	8b 00                	mov    (%eax),%eax
  80197c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80197f:	75 1e                	jne    80199f <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801981:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801984:	89 d0                	mov    %edx,%eax
  801986:	01 c0                	add    %eax,%eax
  801988:	01 d0                	add    %edx,%eax
  80198a:	c1 e0 02             	shl    $0x2,%eax
  80198d:	05 44 50 80 00       	add    $0x805044,%eax
  801992:	8b 00                	mov    (%eax),%eax
  801994:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199a:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  80199d:	eb 0c                	jmp    8019ab <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80199f:	ff 45 ec             	incl   -0x14(%ebp)
  8019a2:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8019a9:	7e a7                	jle    801952 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  8019ab:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019af:	74 06                	je     8019b7 <free+0xdf>
  8019b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019b5:	75 17                	jne    8019ce <free+0xf6>
        panic("free: unknown block");
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	68 03 47 80 00       	push   $0x804703
  8019bf:	68 a9 00 00 00       	push   $0xa9
  8019c4:	68 a4 46 80 00       	push   $0x8046a4
  8019c9:	e8 1a e9 ff ff       	call   8002e8 <_panic>

    uhp_allocs[idx].used = 0;
  8019ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d1:	89 d0                	mov    %edx,%eax
  8019d3:	01 c0                	add    %eax,%eax
  8019d5:	01 d0                	add    %edx,%eax
  8019d7:	c1 e0 02             	shl    $0x2,%eax
  8019da:	05 48 50 80 00       	add    $0x805048,%eax
  8019df:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8019e2:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8019f0:	eb 64                	jmp    801a56 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  8019f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019f5:	89 d0                	mov    %edx,%eax
  8019f7:	01 c0                	add    %eax,%eax
  8019f9:	01 d0                	add    %edx,%eax
  8019fb:	c1 e0 02             	shl    $0x2,%eax
  8019fe:	05 48 10 81 00       	add    $0x811048,%eax
  801a03:	8a 00                	mov    (%eax),%al
  801a05:	84 c0                	test   %al,%al
  801a07:	75 4a                	jne    801a53 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801a09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a0c:	89 d0                	mov    %edx,%eax
  801a0e:	01 c0                	add    %eax,%eax
  801a10:	01 d0                	add    %edx,%eax
  801a12:	c1 e0 02             	shl    $0x2,%eax
  801a15:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801a1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a1e:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801a20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a23:	89 d0                	mov    %edx,%eax
  801a25:	01 c0                	add    %eax,%eax
  801a27:	01 d0                	add    %edx,%eax
  801a29:	c1 e0 02             	shl    $0x2,%eax
  801a2c:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a35:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801a37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a3a:	89 d0                	mov    %edx,%eax
  801a3c:	01 c0                	add    %eax,%eax
  801a3e:	01 d0                	add    %edx,%eax
  801a40:	c1 e0 02             	shl    $0x2,%eax
  801a43:	05 48 10 81 00       	add    $0x811048,%eax
  801a48:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801a4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801a51:	eb 0c                	jmp    801a5f <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a53:	ff 45 e4             	incl   -0x1c(%ebp)
  801a56:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801a5d:	7e 93                	jle    8019f2 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801a5f:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801a63:	0f 84 f1 01 00 00    	je     801c5a <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a69:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a70:	e9 d8 01 00 00       	jmp    801c4d <free+0x375>
        {
            if (i == fidx) continue;
  801a75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a78:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a7b:	0f 84 c8 01 00 00    	je     801c49 <free+0x371>
            if (uhp_frees[i].free)
  801a81:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a84:	89 d0                	mov    %edx,%eax
  801a86:	01 c0                	add    %eax,%eax
  801a88:	01 d0                	add    %edx,%eax
  801a8a:	c1 e0 02             	shl    $0x2,%eax
  801a8d:	05 48 10 81 00       	add    $0x811048,%eax
  801a92:	8a 00                	mov    (%eax),%al
  801a94:	84 c0                	test   %al,%al
  801a96:	0f 84 ae 01 00 00    	je     801c4a <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801a9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a9f:	89 d0                	mov    %edx,%eax
  801aa1:	01 c0                	add    %eax,%eax
  801aa3:	01 d0                	add    %edx,%eax
  801aa5:	c1 e0 02             	shl    $0x2,%eax
  801aa8:	05 40 10 81 00       	add    $0x811040,%eax
  801aad:	8b 08                	mov    (%eax),%ecx
  801aaf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ab2:	89 d0                	mov    %edx,%eax
  801ab4:	01 c0                	add    %eax,%eax
  801ab6:	01 d0                	add    %edx,%eax
  801ab8:	c1 e0 02             	shl    $0x2,%eax
  801abb:	05 44 10 81 00       	add    $0x811044,%eax
  801ac0:	8b 00                	mov    (%eax),%eax
  801ac2:	01 c1                	add    %eax,%ecx
  801ac4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ac7:	89 d0                	mov    %edx,%eax
  801ac9:	01 c0                	add    %eax,%eax
  801acb:	01 d0                	add    %edx,%eax
  801acd:	c1 e0 02             	shl    $0x2,%eax
  801ad0:	05 40 10 81 00       	add    $0x811040,%eax
  801ad5:	8b 00                	mov    (%eax),%eax
  801ad7:	39 c1                	cmp    %eax,%ecx
  801ad9:	0f 85 a8 00 00 00    	jne    801b87 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801adf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae2:	89 d0                	mov    %edx,%eax
  801ae4:	01 c0                	add    %eax,%eax
  801ae6:	01 d0                	add    %edx,%eax
  801ae8:	c1 e0 02             	shl    $0x2,%eax
  801aeb:	05 40 10 81 00       	add    $0x811040,%eax
  801af0:	8b 10                	mov    (%eax),%edx
  801af2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801af5:	89 c8                	mov    %ecx,%eax
  801af7:	01 c0                	add    %eax,%eax
  801af9:	01 c8                	add    %ecx,%eax
  801afb:	c1 e0 02             	shl    $0x2,%eax
  801afe:	05 40 10 81 00       	add    $0x811040,%eax
  801b03:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801b05:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b08:	89 d0                	mov    %edx,%eax
  801b0a:	01 c0                	add    %eax,%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	c1 e0 02             	shl    $0x2,%eax
  801b11:	05 44 10 81 00       	add    $0x811044,%eax
  801b16:	8b 08                	mov    (%eax),%ecx
  801b18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b1b:	89 d0                	mov    %edx,%eax
  801b1d:	01 c0                	add    %eax,%eax
  801b1f:	01 d0                	add    %edx,%eax
  801b21:	c1 e0 02             	shl    $0x2,%eax
  801b24:	05 44 10 81 00       	add    $0x811044,%eax
  801b29:	8b 00                	mov    (%eax),%eax
  801b2b:	01 c1                	add    %eax,%ecx
  801b2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b30:	89 d0                	mov    %edx,%eax
  801b32:	01 c0                	add    %eax,%eax
  801b34:	01 d0                	add    %edx,%eax
  801b36:	c1 e0 02             	shl    $0x2,%eax
  801b39:	05 44 10 81 00       	add    $0x811044,%eax
  801b3e:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801b40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b43:	89 d0                	mov    %edx,%eax
  801b45:	01 c0                	add    %eax,%eax
  801b47:	01 d0                	add    %edx,%eax
  801b49:	c1 e0 02             	shl    $0x2,%eax
  801b4c:	05 48 10 81 00       	add    $0x811048,%eax
  801b51:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801b54:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b57:	89 d0                	mov    %edx,%eax
  801b59:	01 c0                	add    %eax,%eax
  801b5b:	01 d0                	add    %edx,%eax
  801b5d:	c1 e0 02             	shl    $0x2,%eax
  801b60:	05 40 10 81 00       	add    $0x811040,%eax
  801b65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801b6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b6e:	89 d0                	mov    %edx,%eax
  801b70:	01 c0                	add    %eax,%eax
  801b72:	01 d0                	add    %edx,%eax
  801b74:	c1 e0 02             	shl    $0x2,%eax
  801b77:	05 44 10 81 00       	add    $0x811044,%eax
  801b7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b82:	e9 c3 00 00 00       	jmp    801c4a <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801b87:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b8a:	89 d0                	mov    %edx,%eax
  801b8c:	01 c0                	add    %eax,%eax
  801b8e:	01 d0                	add    %edx,%eax
  801b90:	c1 e0 02             	shl    $0x2,%eax
  801b93:	05 40 10 81 00       	add    $0x811040,%eax
  801b98:	8b 08                	mov    (%eax),%ecx
  801b9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b9d:	89 d0                	mov    %edx,%eax
  801b9f:	01 c0                	add    %eax,%eax
  801ba1:	01 d0                	add    %edx,%eax
  801ba3:	c1 e0 02             	shl    $0x2,%eax
  801ba6:	05 44 10 81 00       	add    $0x811044,%eax
  801bab:	8b 00                	mov    (%eax),%eax
  801bad:	01 c1                	add    %eax,%ecx
  801baf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bb2:	89 d0                	mov    %edx,%eax
  801bb4:	01 c0                	add    %eax,%eax
  801bb6:	01 d0                	add    %edx,%eax
  801bb8:	c1 e0 02             	shl    $0x2,%eax
  801bbb:	05 40 10 81 00       	add    $0x811040,%eax
  801bc0:	8b 00                	mov    (%eax),%eax
  801bc2:	39 c1                	cmp    %eax,%ecx
  801bc4:	0f 85 80 00 00 00    	jne    801c4a <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801bca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bcd:	89 d0                	mov    %edx,%eax
  801bcf:	01 c0                	add    %eax,%eax
  801bd1:	01 d0                	add    %edx,%eax
  801bd3:	c1 e0 02             	shl    $0x2,%eax
  801bd6:	05 44 10 81 00       	add    $0x811044,%eax
  801bdb:	8b 08                	mov    (%eax),%ecx
  801bdd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801be0:	89 d0                	mov    %edx,%eax
  801be2:	01 c0                	add    %eax,%eax
  801be4:	01 d0                	add    %edx,%eax
  801be6:	c1 e0 02             	shl    $0x2,%eax
  801be9:	05 44 10 81 00       	add    $0x811044,%eax
  801bee:	8b 00                	mov    (%eax),%eax
  801bf0:	01 c1                	add    %eax,%ecx
  801bf2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bf5:	89 d0                	mov    %edx,%eax
  801bf7:	01 c0                	add    %eax,%eax
  801bf9:	01 d0                	add    %edx,%eax
  801bfb:	c1 e0 02             	shl    $0x2,%eax
  801bfe:	05 44 10 81 00       	add    $0x811044,%eax
  801c03:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801c05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c08:	89 d0                	mov    %edx,%eax
  801c0a:	01 c0                	add    %eax,%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c1 e0 02             	shl    $0x2,%eax
  801c11:	05 48 10 81 00       	add    $0x811048,%eax
  801c16:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801c19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c1c:	89 d0                	mov    %edx,%eax
  801c1e:	01 c0                	add    %eax,%eax
  801c20:	01 d0                	add    %edx,%eax
  801c22:	c1 e0 02             	shl    $0x2,%eax
  801c25:	05 40 10 81 00       	add    $0x811040,%eax
  801c2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801c30:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c33:	89 d0                	mov    %edx,%eax
  801c35:	01 c0                	add    %eax,%eax
  801c37:	01 d0                	add    %edx,%eax
  801c39:	c1 e0 02             	shl    $0x2,%eax
  801c3c:	05 44 10 81 00       	add    $0x811044,%eax
  801c41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c47:	eb 01                	jmp    801c4a <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801c49:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c4a:	ff 45 e0             	incl   -0x20(%ebp)
  801c4d:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801c54:	0f 8e 1b fe ff ff    	jle    801a75 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801c5a:	a1 30 51 83 00       	mov    0x835130,%eax
  801c5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c62:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801c69:	eb 53                	jmp    801cbe <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801c6b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c6e:	89 d0                	mov    %edx,%eax
  801c70:	01 c0                	add    %eax,%eax
  801c72:	01 d0                	add    %edx,%eax
  801c74:	c1 e0 02             	shl    $0x2,%eax
  801c77:	05 48 50 80 00       	add    $0x805048,%eax
  801c7c:	8a 00                	mov    (%eax),%al
  801c7e:	84 c0                	test   %al,%al
  801c80:	74 39                	je     801cbb <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801c82:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c85:	89 d0                	mov    %edx,%eax
  801c87:	01 c0                	add    %eax,%eax
  801c89:	01 d0                	add    %edx,%eax
  801c8b:	c1 e0 02             	shl    $0x2,%eax
  801c8e:	05 40 50 80 00       	add    $0x805040,%eax
  801c93:	8b 08                	mov    (%eax),%ecx
  801c95:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c98:	89 d0                	mov    %edx,%eax
  801c9a:	01 c0                	add    %eax,%eax
  801c9c:	01 d0                	add    %edx,%eax
  801c9e:	c1 e0 02             	shl    $0x2,%eax
  801ca1:	05 44 50 80 00       	add    $0x805044,%eax
  801ca6:	8b 00                	mov    (%eax),%eax
  801ca8:	01 c8                	add    %ecx,%eax
  801caa:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801cad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cb0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801cb3:	76 06                	jbe    801cbb <free+0x3e3>
  801cb5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801cb8:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801cbb:	ff 45 d8             	incl   -0x28(%ebp)
  801cbe:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801cc5:	7e a4                	jle    801c6b <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801cc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cca:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801ccf:	83 ec 08             	sub    $0x8,%esp
  801cd2:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd5:	ff 75 d4             	pushl  -0x2c(%ebp)
  801cd8:	e8 79 15 00 00       	call   803256 <sys_free_user_mem>
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	eb 01                	jmp    801ce3 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801ce2:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 68             	sub    $0x68,%esp
  801ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cee:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801cf1:	e8 a5 f7 ff ff       	call   80149b <uheap_init>
	if (size == 0) return NULL ;
  801cf6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cfa:	75 0a                	jne    801d06 <smalloc+0x21>
  801cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801d01:	e9 37 03 00 00       	jmp    80203d <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801d06:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d13:	01 d0                	add    %edx,%eax
  801d15:	48                   	dec    %eax
  801d16:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d19:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d21:	f7 75 dc             	divl   -0x24(%ebp)
  801d24:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d27:	29 d0                	sub    %edx,%eax
  801d29:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801d2c:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801d33:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801d3a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d41:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801d48:	e9 85 00 00 00       	jmp    801dd2 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801d4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d50:	89 d0                	mov    %edx,%eax
  801d52:	01 c0                	add    %eax,%eax
  801d54:	01 d0                	add    %edx,%eax
  801d56:	c1 e0 02             	shl    $0x2,%eax
  801d59:	05 48 10 81 00       	add    $0x811048,%eax
  801d5e:	8a 00                	mov    (%eax),%al
  801d60:	84 c0                	test   %al,%al
  801d62:	74 20                	je     801d84 <smalloc+0x9f>
  801d64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d67:	89 d0                	mov    %edx,%eax
  801d69:	01 c0                	add    %eax,%eax
  801d6b:	01 d0                	add    %edx,%eax
  801d6d:	c1 e0 02             	shl    $0x2,%eax
  801d70:	05 44 10 81 00       	add    $0x811044,%eax
  801d75:	8b 00                	mov    (%eax),%eax
  801d77:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d7a:	75 08                	jne    801d84 <smalloc+0x9f>
        {
            exactIdx = i;
  801d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801d82:	eb 5b                	jmp    801ddf <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801d84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d87:	89 d0                	mov    %edx,%eax
  801d89:	01 c0                	add    %eax,%eax
  801d8b:	01 d0                	add    %edx,%eax
  801d8d:	c1 e0 02             	shl    $0x2,%eax
  801d90:	05 48 10 81 00       	add    $0x811048,%eax
  801d95:	8a 00                	mov    (%eax),%al
  801d97:	84 c0                	test   %al,%al
  801d99:	74 34                	je     801dcf <smalloc+0xea>
  801d9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d9e:	89 d0                	mov    %edx,%eax
  801da0:	01 c0                	add    %eax,%eax
  801da2:	01 d0                	add    %edx,%eax
  801da4:	c1 e0 02             	shl    $0x2,%eax
  801da7:	05 44 10 81 00       	add    $0x811044,%eax
  801dac:	8b 00                	mov    (%eax),%eax
  801dae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801db1:	76 1c                	jbe    801dcf <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801db3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801db6:	89 d0                	mov    %edx,%eax
  801db8:	01 c0                	add    %eax,%eax
  801dba:	01 d0                	add    %edx,%eax
  801dbc:	c1 e0 02             	shl    $0x2,%eax
  801dbf:	05 44 10 81 00       	add    $0x811044,%eax
  801dc4:	8b 00                	mov    (%eax),%eax
  801dc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801dc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801dcf:	ff 45 e8             	incl   -0x18(%ebp)
  801dd2:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801dd9:	0f 8e 6e ff ff ff    	jle    801d4d <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801ddf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801de6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801dea:	74 7d                	je     801e69 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801dec:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801df3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df6:	89 d0                	mov    %edx,%eax
  801df8:	01 c0                	add    %eax,%eax
  801dfa:	01 d0                	add    %edx,%eax
  801dfc:	c1 e0 02             	shl    $0x2,%eax
  801dff:	05 40 10 81 00       	add    $0x811040,%eax
  801e04:	8b 10                	mov    (%eax),%edx
  801e06:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801e09:	01 d0                	add    %edx,%eax
  801e0b:	48                   	dec    %eax
  801e0c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801e0f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e12:	ba 00 00 00 00       	mov    $0x0,%edx
  801e17:	f7 75 bc             	divl   -0x44(%ebp)
  801e1a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801e1d:	29 d0                	sub    %edx,%eax
  801e1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801e22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e25:	89 d0                	mov    %edx,%eax
  801e27:	01 c0                	add    %eax,%eax
  801e29:	01 d0                	add    %edx,%eax
  801e2b:	c1 e0 02             	shl    $0x2,%eax
  801e2e:	05 48 10 81 00       	add    $0x811048,%eax
  801e33:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e39:	89 d0                	mov    %edx,%eax
  801e3b:	01 c0                	add    %eax,%eax
  801e3d:	01 d0                	add    %edx,%eax
  801e3f:	c1 e0 02             	shl    $0x2,%eax
  801e42:	05 44 10 81 00       	add    $0x811044,%eax
  801e47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e50:	89 d0                	mov    %edx,%eax
  801e52:	01 c0                	add    %eax,%eax
  801e54:	01 d0                	add    %edx,%eax
  801e56:	c1 e0 02             	shl    $0x2,%eax
  801e59:	05 40 10 81 00       	add    $0x811040,%eax
  801e5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e64:	e9 2d 01 00 00       	jmp    801f96 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801e69:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e6d:	0f 84 ce 00 00 00    	je     801f41 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801e73:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801e7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e7d:	89 d0                	mov    %edx,%eax
  801e7f:	01 c0                	add    %eax,%eax
  801e81:	01 d0                	add    %edx,%eax
  801e83:	c1 e0 02             	shl    $0x2,%eax
  801e86:	05 40 10 81 00       	add    $0x811040,%eax
  801e8b:	8b 10                	mov    (%eax),%edx
  801e8d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801e90:	01 d0                	add    %edx,%eax
  801e92:	48                   	dec    %eax
  801e93:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801e96:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801e99:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9e:	f7 75 c4             	divl   -0x3c(%ebp)
  801ea1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ea4:	29 d0                	sub    %edx,%eax
  801ea6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801ea9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eac:	89 d0                	mov    %edx,%eax
  801eae:	01 c0                	add    %eax,%eax
  801eb0:	01 d0                	add    %edx,%eax
  801eb2:	c1 e0 02             	shl    $0x2,%eax
  801eb5:	05 44 10 81 00       	add    $0x811044,%eax
  801eba:	8b 00                	mov    (%eax),%eax
  801ebc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ebf:	75 47                	jne    801f08 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801ec1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ec4:	89 d0                	mov    %edx,%eax
  801ec6:	01 c0                	add    %eax,%eax
  801ec8:	01 d0                	add    %edx,%eax
  801eca:	c1 e0 02             	shl    $0x2,%eax
  801ecd:	05 48 10 81 00       	add    $0x811048,%eax
  801ed2:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801ed5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed8:	89 d0                	mov    %edx,%eax
  801eda:	01 c0                	add    %eax,%eax
  801edc:	01 d0                	add    %edx,%eax
  801ede:	c1 e0 02             	shl    $0x2,%eax
  801ee1:	05 44 10 81 00       	add    $0x811044,%eax
  801ee6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801eec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eef:	89 d0                	mov    %edx,%eax
  801ef1:	01 c0                	add    %eax,%eax
  801ef3:	01 d0                	add    %edx,%eax
  801ef5:	c1 e0 02             	shl    $0x2,%eax
  801ef8:	05 40 10 81 00       	add    $0x811040,%eax
  801efd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f03:	e9 8e 00 00 00       	jmp    801f96 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801f08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f0e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801f11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f14:	89 d0                	mov    %edx,%eax
  801f16:	01 c0                	add    %eax,%eax
  801f18:	01 d0                	add    %edx,%eax
  801f1a:	c1 e0 02             	shl    $0x2,%eax
  801f1d:	05 40 10 81 00       	add    $0x811040,%eax
  801f22:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801f24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f27:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f2a:	89 c2                	mov    %eax,%edx
  801f2c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f2f:	89 c8                	mov    %ecx,%eax
  801f31:	01 c0                	add    %eax,%eax
  801f33:	01 c8                	add    %ecx,%eax
  801f35:	c1 e0 02             	shl    $0x2,%eax
  801f38:	05 44 10 81 00       	add    $0x811044,%eax
  801f3d:	89 10                	mov    %edx,(%eax)
  801f3f:	eb 55                	jmp    801f96 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801f41:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801f48:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801f4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f51:	01 d0                	add    %edx,%eax
  801f53:	48                   	dec    %eax
  801f54:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801f57:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5f:	f7 75 d0             	divl   -0x30(%ebp)
  801f62:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f65:	29 d0                	sub    %edx,%eax
  801f67:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801f6a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f70:	01 d0                	add    %edx,%eax
  801f72:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801f77:	76 0a                	jbe    801f83 <smalloc+0x29e>
            return NULL;
  801f79:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7e:	e9 ba 00 00 00       	jmp    80203d <smalloc+0x358>
        va = start;
  801f83:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801f89:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801f8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f8f:	01 d0                	add    %edx,%eax
  801f91:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f96:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f9d:	eb 5e                	jmp    801ffd <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  801f9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fa2:	89 d0                	mov    %edx,%eax
  801fa4:	01 c0                	add    %eax,%eax
  801fa6:	01 d0                	add    %edx,%eax
  801fa8:	c1 e0 02             	shl    $0x2,%eax
  801fab:	05 48 50 80 00       	add    $0x805048,%eax
  801fb0:	8a 00                	mov    (%eax),%al
  801fb2:	84 c0                	test   %al,%al
  801fb4:	75 44                	jne    801ffa <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  801fb6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fb9:	89 d0                	mov    %edx,%eax
  801fbb:	01 c0                	add    %eax,%eax
  801fbd:	01 d0                	add    %edx,%eax
  801fbf:	c1 e0 02             	shl    $0x2,%eax
  801fc2:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801fc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fcb:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801fcd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fd0:	89 d0                	mov    %edx,%eax
  801fd2:	01 c0                	add    %eax,%eax
  801fd4:	01 d0                	add    %edx,%eax
  801fd6:	c1 e0 02             	shl    $0x2,%eax
  801fd9:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801fdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fe2:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801fe4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fe7:	89 d0                	mov    %edx,%eax
  801fe9:	01 c0                	add    %eax,%eax
  801feb:	01 d0                	add    %edx,%eax
  801fed:	c1 e0 02             	shl    $0x2,%eax
  801ff0:	05 48 50 80 00       	add    $0x805048,%eax
  801ff5:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801ff8:	eb 0c                	jmp    802006 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ffa:	ff 45 e0             	incl   -0x20(%ebp)
  801ffd:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802004:	7e 99                	jle    801f9f <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802006:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802009:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  80200d:	52                   	push   %edx
  80200e:	50                   	push   %eax
  80200f:	ff 75 d4             	pushl  -0x2c(%ebp)
  802012:	ff 75 08             	pushl  0x8(%ebp)
  802015:	e8 de 0e 00 00       	call   802ef8 <sys_create_shared_object>
  80201a:	83 c4 10             	add    $0x10,%esp
  80201d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802020:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802024:	75 07                	jne    80202d <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802026:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80202b:	eb 10                	jmp    80203d <smalloc+0x358>
    if (r < 0)
  80202d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802031:	79 07                	jns    80203a <smalloc+0x355>
        return NULL;
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
  802038:	eb 03                	jmp    80203d <smalloc+0x358>
    return (void*)va;
  80203a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802045:	e8 51 f4 ff ff       	call   80149b <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80204a:	83 ec 08             	sub    $0x8,%esp
  80204d:	ff 75 0c             	pushl  0xc(%ebp)
  802050:	ff 75 08             	pushl  0x8(%ebp)
  802053:	e8 ca 0e 00 00       	call   802f22 <sys_size_of_shared_object>
  802058:	83 c4 10             	add    $0x10,%esp
  80205b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  80205e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802062:	7f 0a                	jg     80206e <sget+0x2f>
        return NULL;
  802064:	b8 00 00 00 00       	mov    $0x0,%eax
  802069:	e9 28 03 00 00       	jmp    802396 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80206e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802075:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802078:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80207b:	01 d0                	add    %edx,%eax
  80207d:	48                   	dec    %eax
  80207e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802081:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802084:	ba 00 00 00 00       	mov    $0x0,%edx
  802089:	f7 75 d8             	divl   -0x28(%ebp)
  80208c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80208f:	29 d0                	sub    %edx,%eax
  802091:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802094:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80209b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8020a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8020b0:	e9 85 00 00 00       	jmp    80213a <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8020b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020b8:	89 d0                	mov    %edx,%eax
  8020ba:	01 c0                	add    %eax,%eax
  8020bc:	01 d0                	add    %edx,%eax
  8020be:	c1 e0 02             	shl    $0x2,%eax
  8020c1:	05 48 10 81 00       	add    $0x811048,%eax
  8020c6:	8a 00                	mov    (%eax),%al
  8020c8:	84 c0                	test   %al,%al
  8020ca:	74 20                	je     8020ec <sget+0xad>
  8020cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020cf:	89 d0                	mov    %edx,%eax
  8020d1:	01 c0                	add    %eax,%eax
  8020d3:	01 d0                	add    %edx,%eax
  8020d5:	c1 e0 02             	shl    $0x2,%eax
  8020d8:	05 44 10 81 00       	add    $0x811044,%eax
  8020dd:	8b 00                	mov    (%eax),%eax
  8020df:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020e2:	75 08                	jne    8020ec <sget+0xad>
        {
            exactIdx = i;
  8020e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8020ea:	eb 5b                	jmp    802147 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8020ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020ef:	89 d0                	mov    %edx,%eax
  8020f1:	01 c0                	add    %eax,%eax
  8020f3:	01 d0                	add    %edx,%eax
  8020f5:	c1 e0 02             	shl    $0x2,%eax
  8020f8:	05 48 10 81 00       	add    $0x811048,%eax
  8020fd:	8a 00                	mov    (%eax),%al
  8020ff:	84 c0                	test   %al,%al
  802101:	74 34                	je     802137 <sget+0xf8>
  802103:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802106:	89 d0                	mov    %edx,%eax
  802108:	01 c0                	add    %eax,%eax
  80210a:	01 d0                	add    %edx,%eax
  80210c:	c1 e0 02             	shl    $0x2,%eax
  80210f:	05 44 10 81 00       	add    $0x811044,%eax
  802114:	8b 00                	mov    (%eax),%eax
  802116:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802119:	76 1c                	jbe    802137 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  80211b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80211e:	89 d0                	mov    %edx,%eax
  802120:	01 c0                	add    %eax,%eax
  802122:	01 d0                	add    %edx,%eax
  802124:	c1 e0 02             	shl    $0x2,%eax
  802127:	05 44 10 81 00       	add    $0x811044,%eax
  80212c:	8b 00                	mov    (%eax),%eax
  80212e:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802131:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802134:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802137:	ff 45 e8             	incl   -0x18(%ebp)
  80213a:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802141:	0f 8e 6e ff ff ff    	jle    8020b5 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802147:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80214e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802152:	74 7d                	je     8021d1 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802154:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80215b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215e:	89 d0                	mov    %edx,%eax
  802160:	01 c0                	add    %eax,%eax
  802162:	01 d0                	add    %edx,%eax
  802164:	c1 e0 02             	shl    $0x2,%eax
  802167:	05 40 10 81 00       	add    $0x811040,%eax
  80216c:	8b 10                	mov    (%eax),%edx
  80216e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802171:	01 d0                	add    %edx,%eax
  802173:	48                   	dec    %eax
  802174:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802177:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80217a:	ba 00 00 00 00       	mov    $0x0,%edx
  80217f:	f7 75 b8             	divl   -0x48(%ebp)
  802182:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802185:	29 d0                	sub    %edx,%eax
  802187:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80218a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218d:	89 d0                	mov    %edx,%eax
  80218f:	01 c0                	add    %eax,%eax
  802191:	01 d0                	add    %edx,%eax
  802193:	c1 e0 02             	shl    $0x2,%eax
  802196:	05 48 10 81 00       	add    $0x811048,%eax
  80219b:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80219e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a1:	89 d0                	mov    %edx,%eax
  8021a3:	01 c0                	add    %eax,%eax
  8021a5:	01 d0                	add    %edx,%eax
  8021a7:	c1 e0 02             	shl    $0x2,%eax
  8021aa:	05 44 10 81 00       	add    $0x811044,%eax
  8021af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8021b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b8:	89 d0                	mov    %edx,%eax
  8021ba:	01 c0                	add    %eax,%eax
  8021bc:	01 d0                	add    %edx,%eax
  8021be:	c1 e0 02             	shl    $0x2,%eax
  8021c1:	05 40 10 81 00       	add    $0x811040,%eax
  8021c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021cc:	e9 2d 01 00 00       	jmp    8022fe <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8021d1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021d5:	0f 84 ce 00 00 00    	je     8022a9 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8021db:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8021e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e5:	89 d0                	mov    %edx,%eax
  8021e7:	01 c0                	add    %eax,%eax
  8021e9:	01 d0                	add    %edx,%eax
  8021eb:	c1 e0 02             	shl    $0x2,%eax
  8021ee:	05 40 10 81 00       	add    $0x811040,%eax
  8021f3:	8b 10                	mov    (%eax),%edx
  8021f5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021f8:	01 d0                	add    %edx,%eax
  8021fa:	48                   	dec    %eax
  8021fb:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8021fe:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802201:	ba 00 00 00 00       	mov    $0x0,%edx
  802206:	f7 75 c0             	divl   -0x40(%ebp)
  802209:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80220c:	29 d0                	sub    %edx,%eax
  80220e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802211:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802214:	89 d0                	mov    %edx,%eax
  802216:	01 c0                	add    %eax,%eax
  802218:	01 d0                	add    %edx,%eax
  80221a:	c1 e0 02             	shl    $0x2,%eax
  80221d:	05 44 10 81 00       	add    $0x811044,%eax
  802222:	8b 00                	mov    (%eax),%eax
  802224:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802227:	75 47                	jne    802270 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802229:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80222c:	89 d0                	mov    %edx,%eax
  80222e:	01 c0                	add    %eax,%eax
  802230:	01 d0                	add    %edx,%eax
  802232:	c1 e0 02             	shl    $0x2,%eax
  802235:	05 48 10 81 00       	add    $0x811048,%eax
  80223a:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80223d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802240:	89 d0                	mov    %edx,%eax
  802242:	01 c0                	add    %eax,%eax
  802244:	01 d0                	add    %edx,%eax
  802246:	c1 e0 02             	shl    $0x2,%eax
  802249:	05 44 10 81 00       	add    $0x811044,%eax
  80224e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802254:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802257:	89 d0                	mov    %edx,%eax
  802259:	01 c0                	add    %eax,%eax
  80225b:	01 d0                	add    %edx,%eax
  80225d:	c1 e0 02             	shl    $0x2,%eax
  802260:	05 40 10 81 00       	add    $0x811040,%eax
  802265:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80226b:	e9 8e 00 00 00       	jmp    8022fe <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802270:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802273:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802276:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802279:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80227c:	89 d0                	mov    %edx,%eax
  80227e:	01 c0                	add    %eax,%eax
  802280:	01 d0                	add    %edx,%eax
  802282:	c1 e0 02             	shl    $0x2,%eax
  802285:	05 40 10 81 00       	add    $0x811040,%eax
  80228a:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80228c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802292:	89 c2                	mov    %eax,%edx
  802294:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802297:	89 c8                	mov    %ecx,%eax
  802299:	01 c0                	add    %eax,%eax
  80229b:	01 c8                	add    %ecx,%eax
  80229d:	c1 e0 02             	shl    $0x2,%eax
  8022a0:	05 44 10 81 00       	add    $0x811044,%eax
  8022a5:	89 10                	mov    %edx,(%eax)
  8022a7:	eb 55                	jmp    8022fe <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8022a9:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8022b0:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8022b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	48                   	dec    %eax
  8022bc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8022bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c7:	f7 75 cc             	divl   -0x34(%ebp)
  8022ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022cd:	29 d0                	sub    %edx,%eax
  8022cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8022d2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8022d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022d8:	01 d0                	add    %edx,%eax
  8022da:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8022df:	76 0a                	jbe    8022eb <sget+0x2ac>
            return NULL;
  8022e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e6:	e9 ab 00 00 00       	jmp    802396 <sget+0x357>
        va = start;
  8022eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8022ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8022f1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8022f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8022f7:	01 d0                	add    %edx,%eax
  8022f9:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022fe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802305:	eb 5e                	jmp    802365 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802307:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80230a:	89 d0                	mov    %edx,%eax
  80230c:	01 c0                	add    %eax,%eax
  80230e:	01 d0                	add    %edx,%eax
  802310:	c1 e0 02             	shl    $0x2,%eax
  802313:	05 48 50 80 00       	add    $0x805048,%eax
  802318:	8a 00                	mov    (%eax),%al
  80231a:	84 c0                	test   %al,%al
  80231c:	75 44                	jne    802362 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80231e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802321:	89 d0                	mov    %edx,%eax
  802323:	01 c0                	add    %eax,%eax
  802325:	01 d0                	add    %edx,%eax
  802327:	c1 e0 02             	shl    $0x2,%eax
  80232a:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802330:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802333:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802335:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802338:	89 d0                	mov    %edx,%eax
  80233a:	01 c0                	add    %eax,%eax
  80233c:	01 d0                	add    %edx,%eax
  80233e:	c1 e0 02             	shl    $0x2,%eax
  802341:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802347:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80234a:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80234c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80234f:	89 d0                	mov    %edx,%eax
  802351:	01 c0                	add    %eax,%eax
  802353:	01 d0                	add    %edx,%eax
  802355:	c1 e0 02             	shl    $0x2,%eax
  802358:	05 48 50 80 00       	add    $0x805048,%eax
  80235d:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802360:	eb 0c                	jmp    80236e <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802362:	ff 45 e0             	incl   -0x20(%ebp)
  802365:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80236c:	7e 99                	jle    802307 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  80236e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	50                   	push   %eax
  802375:	ff 75 0c             	pushl  0xc(%ebp)
  802378:	ff 75 08             	pushl  0x8(%ebp)
  80237b:	e8 bf 0b 00 00       	call   802f3f <sys_get_shared_object>
  802380:	83 c4 10             	add    $0x10,%esp
  802383:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802386:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80238a:	79 07                	jns    802393 <sget+0x354>
        return NULL;
  80238c:	b8 00 00 00 00       	mov    $0x0,%eax
  802391:	eb 03                	jmp    802396 <sget+0x357>
    return (void*)va;
  802393:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
  80239b:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80239e:	e8 f8 f0 ff ff       	call   80149b <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8023a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a7:	75 13                	jne    8023bc <realloc+0x24>
		return malloc(new_size);
  8023a9:	83 ec 0c             	sub    $0xc,%esp
  8023ac:	ff 75 0c             	pushl  0xc(%ebp)
  8023af:	e8 c4 f1 ff ff       	call   801578 <malloc>
  8023b4:	83 c4 10             	add    $0x10,%esp
  8023b7:	e9 f4 05 00 00       	jmp    8029b0 <realloc+0x618>
	if (new_size == 0)
  8023bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023c0:	75 18                	jne    8023da <realloc+0x42>
	{
		free(virtual_address);
  8023c2:	83 ec 0c             	sub    $0xc,%esp
  8023c5:	ff 75 08             	pushl  0x8(%ebp)
  8023c8:	e8 0b f5 ff ff       	call   8018d8 <free>
  8023cd:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d5:	e9 d6 05 00 00       	jmp    8029b0 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8023e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023e3:	85 c0                	test   %eax,%eax
  8023e5:	79 74                	jns    80245b <realloc+0xc3>
  8023e7:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8023ee:	77 6b                	ja     80245b <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  8023f0:	83 ec 0c             	sub    $0xc,%esp
  8023f3:	ff 75 0c             	pushl  0xc(%ebp)
  8023f6:	e8 7d f1 ff ff       	call   801578 <malloc>
  8023fb:	83 c4 10             	add    $0x10,%esp
  8023fe:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802401:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802405:	75 0a                	jne    802411 <realloc+0x79>
			return NULL;
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
  80240c:	e9 9f 05 00 00       	jmp    8029b0 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802411:	83 ec 0c             	sub    $0xc,%esp
  802414:	ff 75 08             	pushl  0x8(%ebp)
  802417:	e8 e0 11 00 00       	call   8035fc <get_block_size>
  80241c:	83 c4 10             	add    $0x10,%esp
  80241f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802422:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802425:	8b 45 0c             	mov    0xc(%ebp),%eax
  802428:	39 d0                	cmp    %edx,%eax
  80242a:	76 02                	jbe    80242e <realloc+0x96>
  80242c:	89 d0                	mov    %edx,%eax
  80242e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802431:	83 ec 04             	sub    $0x4,%esp
  802434:	ff 75 c0             	pushl  -0x40(%ebp)
  802437:	ff 75 08             	pushl  0x8(%ebp)
  80243a:	ff 75 c8             	pushl  -0x38(%ebp)
  80243d:	e8 56 eb ff ff       	call   800f98 <memmove>
  802442:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802445:	83 ec 0c             	sub    $0xc,%esp
  802448:	ff 75 08             	pushl  0x8(%ebp)
  80244b:	e8 88 f4 ff ff       	call   8018d8 <free>
  802450:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802453:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802456:	e9 55 05 00 00       	jmp    8029b0 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80245b:	a1 30 51 83 00       	mov    0x835130,%eax
  802460:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802463:	72 09                	jb     80246e <realloc+0xd6>
  802465:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  80246c:	76 0a                	jbe    802478 <realloc+0xe0>
		return NULL;
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
  802473:	e9 38 05 00 00       	jmp    8029b0 <realloc+0x618>
	uint32 oldsz = 0;
  802478:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  80247f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802486:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80248d:	eb 50                	jmp    8024df <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80248f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802492:	89 d0                	mov    %edx,%eax
  802494:	01 c0                	add    %eax,%eax
  802496:	01 d0                	add    %edx,%eax
  802498:	c1 e0 02             	shl    $0x2,%eax
  80249b:	05 48 50 80 00       	add    $0x805048,%eax
  8024a0:	8a 00                	mov    (%eax),%al
  8024a2:	84 c0                	test   %al,%al
  8024a4:	74 36                	je     8024dc <realloc+0x144>
  8024a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024a9:	89 d0                	mov    %edx,%eax
  8024ab:	01 c0                	add    %eax,%eax
  8024ad:	01 d0                	add    %edx,%eax
  8024af:	c1 e0 02             	shl    $0x2,%eax
  8024b2:	05 40 50 80 00       	add    $0x805040,%eax
  8024b7:	8b 00                	mov    (%eax),%eax
  8024b9:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8024bc:	75 1e                	jne    8024dc <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  8024be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024c1:	89 d0                	mov    %edx,%eax
  8024c3:	01 c0                	add    %eax,%eax
  8024c5:	01 d0                	add    %edx,%eax
  8024c7:	c1 e0 02             	shl    $0x2,%eax
  8024ca:	05 44 50 80 00       	add    $0x805044,%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8024d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8024da:	eb 0c                	jmp    8024e8 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024dc:	ff 45 ec             	incl   -0x14(%ebp)
  8024df:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8024e6:	7e a7                	jle    80248f <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8024e8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8024ec:	75 0a                	jne    8024f8 <realloc+0x160>
		return NULL;
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f3:	e9 b8 04 00 00       	jmp    8029b0 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  8024f8:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8024ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802502:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802505:	01 d0                	add    %edx,%eax
  802507:	48                   	dec    %eax
  802508:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80250b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80250e:	ba 00 00 00 00       	mov    $0x0,%edx
  802513:	f7 75 bc             	divl   -0x44(%ebp)
  802516:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802519:	29 d0                	sub    %edx,%eax
  80251b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  80251e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802521:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802524:	75 08                	jne    80252e <realloc+0x196>
		return virtual_address;
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	e9 82 04 00 00       	jmp    8029b0 <realloc+0x618>
	if (req < oldsz)
  80252e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802531:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802534:	0f 83 cd 02 00 00    	jae    802807 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802540:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802543:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802546:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802549:	01 d0                	add    %edx,%eax
  80254b:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  80254e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802551:	89 d0                	mov    %edx,%eax
  802553:	01 c0                	add    %eax,%eax
  802555:	01 d0                	add    %edx,%eax
  802557:	c1 e0 02             	shl    $0x2,%eax
  80255a:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802560:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802563:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802565:	83 ec 08             	sub    $0x8,%esp
  802568:	ff 75 b0             	pushl  -0x50(%ebp)
  80256b:	ff 75 ac             	pushl  -0x54(%ebp)
  80256e:	e8 e3 0c 00 00       	call   803256 <sys_free_user_mem>
  802573:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802576:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80257d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802584:	eb 64                	jmp    8025ea <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802586:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802589:	89 d0                	mov    %edx,%eax
  80258b:	01 c0                	add    %eax,%eax
  80258d:	01 d0                	add    %edx,%eax
  80258f:	c1 e0 02             	shl    $0x2,%eax
  802592:	05 48 10 81 00       	add    $0x811048,%eax
  802597:	8a 00                	mov    (%eax),%al
  802599:	84 c0                	test   %al,%al
  80259b:	75 4a                	jne    8025e7 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  80259d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a0:	89 d0                	mov    %edx,%eax
  8025a2:	01 c0                	add    %eax,%eax
  8025a4:	01 d0                	add    %edx,%eax
  8025a6:	c1 e0 02             	shl    $0x2,%eax
  8025a9:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  8025af:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8025b2:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  8025b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b7:	89 d0                	mov    %edx,%eax
  8025b9:	01 c0                	add    %eax,%eax
  8025bb:	01 d0                	add    %edx,%eax
  8025bd:	c1 e0 02             	shl    $0x2,%eax
  8025c0:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  8025c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c9:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  8025cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025ce:	89 d0                	mov    %edx,%eax
  8025d0:	01 c0                	add    %eax,%eax
  8025d2:	01 d0                	add    %edx,%eax
  8025d4:	c1 e0 02             	shl    $0x2,%eax
  8025d7:	05 48 10 81 00       	add    $0x811048,%eax
  8025dc:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8025df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8025e5:	eb 0c                	jmp    8025f3 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8025e7:	ff 45 e4             	incl   -0x1c(%ebp)
  8025ea:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8025f1:	7e 93                	jle    802586 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  8025f3:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8025f7:	0f 84 8d 01 00 00    	je     80278a <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8025fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802604:	e9 74 01 00 00       	jmp    80277d <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802609:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80260c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80260f:	0f 84 64 01 00 00    	je     802779 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802615:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802618:	89 d0                	mov    %edx,%eax
  80261a:	01 c0                	add    %eax,%eax
  80261c:	01 d0                	add    %edx,%eax
  80261e:	c1 e0 02             	shl    $0x2,%eax
  802621:	05 48 10 81 00       	add    $0x811048,%eax
  802626:	8a 00                	mov    (%eax),%al
  802628:	84 c0                	test   %al,%al
  80262a:	0f 84 4a 01 00 00    	je     80277a <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802630:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802633:	89 d0                	mov    %edx,%eax
  802635:	01 c0                	add    %eax,%eax
  802637:	01 d0                	add    %edx,%eax
  802639:	c1 e0 02             	shl    $0x2,%eax
  80263c:	05 40 10 81 00       	add    $0x811040,%eax
  802641:	8b 08                	mov    (%eax),%ecx
  802643:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802646:	89 d0                	mov    %edx,%eax
  802648:	01 c0                	add    %eax,%eax
  80264a:	01 d0                	add    %edx,%eax
  80264c:	c1 e0 02             	shl    $0x2,%eax
  80264f:	05 44 10 81 00       	add    $0x811044,%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	01 c1                	add    %eax,%ecx
  802658:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80265b:	89 d0                	mov    %edx,%eax
  80265d:	01 c0                	add    %eax,%eax
  80265f:	01 d0                	add    %edx,%eax
  802661:	c1 e0 02             	shl    $0x2,%eax
  802664:	05 40 10 81 00       	add    $0x811040,%eax
  802669:	8b 00                	mov    (%eax),%eax
  80266b:	39 c1                	cmp    %eax,%ecx
  80266d:	75 7a                	jne    8026e9 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  80266f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802672:	89 d0                	mov    %edx,%eax
  802674:	01 c0                	add    %eax,%eax
  802676:	01 d0                	add    %edx,%eax
  802678:	c1 e0 02             	shl    $0x2,%eax
  80267b:	05 40 10 81 00       	add    $0x811040,%eax
  802680:	8b 10                	mov    (%eax),%edx
  802682:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802685:	89 c8                	mov    %ecx,%eax
  802687:	01 c0                	add    %eax,%eax
  802689:	01 c8                	add    %ecx,%eax
  80268b:	c1 e0 02             	shl    $0x2,%eax
  80268e:	05 40 10 81 00       	add    $0x811040,%eax
  802693:	89 10                	mov    %edx,(%eax)
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
  8026e4:	e9 91 00 00 00       	jmp    80277a <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8026e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ec:	89 d0                	mov    %edx,%eax
  8026ee:	01 c0                	add    %eax,%eax
  8026f0:	01 d0                	add    %edx,%eax
  8026f2:	c1 e0 02             	shl    $0x2,%eax
  8026f5:	05 40 10 81 00       	add    $0x811040,%eax
  8026fa:	8b 08                	mov    (%eax),%ecx
  8026fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ff:	89 d0                	mov    %edx,%eax
  802701:	01 c0                	add    %eax,%eax
  802703:	01 d0                	add    %edx,%eax
  802705:	c1 e0 02             	shl    $0x2,%eax
  802708:	05 44 10 81 00       	add    $0x811044,%eax
  80270d:	8b 00                	mov    (%eax),%eax
  80270f:	01 c1                	add    %eax,%ecx
  802711:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802714:	89 d0                	mov    %edx,%eax
  802716:	01 c0                	add    %eax,%eax
  802718:	01 d0                	add    %edx,%eax
  80271a:	c1 e0 02             	shl    $0x2,%eax
  80271d:	05 40 10 81 00       	add    $0x811040,%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	39 c1                	cmp    %eax,%ecx
  802726:	75 52                	jne    80277a <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802728:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80272b:	89 d0                	mov    %edx,%eax
  80272d:	01 c0                	add    %eax,%eax
  80272f:	01 d0                	add    %edx,%eax
  802731:	c1 e0 02             	shl    $0x2,%eax
  802734:	05 44 10 81 00       	add    $0x811044,%eax
  802739:	8b 08                	mov    (%eax),%ecx
  80273b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80273e:	89 d0                	mov    %edx,%eax
  802740:	01 c0                	add    %eax,%eax
  802742:	01 d0                	add    %edx,%eax
  802744:	c1 e0 02             	shl    $0x2,%eax
  802747:	05 44 10 81 00       	add    $0x811044,%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	01 c1                	add    %eax,%ecx
  802750:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802753:	89 d0                	mov    %edx,%eax
  802755:	01 c0                	add    %eax,%eax
  802757:	01 d0                	add    %edx,%eax
  802759:	c1 e0 02             	shl    $0x2,%eax
  80275c:	05 44 10 81 00       	add    $0x811044,%eax
  802761:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802763:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802766:	89 d0                	mov    %edx,%eax
  802768:	01 c0                	add    %eax,%eax
  80276a:	01 d0                	add    %edx,%eax
  80276c:	c1 e0 02             	shl    $0x2,%eax
  80276f:	05 48 10 81 00       	add    $0x811048,%eax
  802774:	c6 00 00             	movb   $0x0,(%eax)
  802777:	eb 01                	jmp    80277a <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802779:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80277a:	ff 45 e0             	incl   -0x20(%ebp)
  80277d:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802784:	0f 8e 7f fe ff ff    	jle    802609 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  80278a:	a1 30 51 83 00       	mov    0x835130,%eax
  80278f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802792:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802799:	eb 53                	jmp    8027ee <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  80279b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80279e:	89 d0                	mov    %edx,%eax
  8027a0:	01 c0                	add    %eax,%eax
  8027a2:	01 d0                	add    %edx,%eax
  8027a4:	c1 e0 02             	shl    $0x2,%eax
  8027a7:	05 48 50 80 00       	add    $0x805048,%eax
  8027ac:	8a 00                	mov    (%eax),%al
  8027ae:	84 c0                	test   %al,%al
  8027b0:	74 39                	je     8027eb <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8027b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027b5:	89 d0                	mov    %edx,%eax
  8027b7:	01 c0                	add    %eax,%eax
  8027b9:	01 d0                	add    %edx,%eax
  8027bb:	c1 e0 02             	shl    $0x2,%eax
  8027be:	05 40 50 80 00       	add    $0x805040,%eax
  8027c3:	8b 08                	mov    (%eax),%ecx
  8027c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027c8:	89 d0                	mov    %edx,%eax
  8027ca:	01 c0                	add    %eax,%eax
  8027cc:	01 d0                	add    %edx,%eax
  8027ce:	c1 e0 02             	shl    $0x2,%eax
  8027d1:	05 44 50 80 00       	add    $0x805044,%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	01 c8                	add    %ecx,%eax
  8027da:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8027dd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8027e3:	76 06                	jbe    8027eb <realloc+0x453>
  8027e5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8027eb:	ff 45 d8             	incl   -0x28(%ebp)
  8027ee:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8027f5:	7e a4                	jle    80279b <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  8027f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027fa:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8027ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802802:	e9 a9 01 00 00       	jmp    8029b0 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802807:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	01 d0                	add    %edx,%eax
  80280f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802812:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802819:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802820:	eb 57                	jmp    802879 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802822:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802825:	89 d0                	mov    %edx,%eax
  802827:	01 c0                	add    %eax,%eax
  802829:	01 d0                	add    %edx,%eax
  80282b:	c1 e0 02             	shl    $0x2,%eax
  80282e:	05 48 10 81 00       	add    $0x811048,%eax
  802833:	8a 00                	mov    (%eax),%al
  802835:	84 c0                	test   %al,%al
  802837:	74 3d                	je     802876 <realloc+0x4de>
  802839:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80283c:	89 d0                	mov    %edx,%eax
  80283e:	01 c0                	add    %eax,%eax
  802840:	01 d0                	add    %edx,%eax
  802842:	c1 e0 02             	shl    $0x2,%eax
  802845:	05 40 10 81 00       	add    $0x811040,%eax
  80284a:	8b 00                	mov    (%eax),%eax
  80284c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80284f:	75 25                	jne    802876 <realloc+0x4de>
  802851:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802854:	89 d0                	mov    %edx,%eax
  802856:	01 c0                	add    %eax,%eax
  802858:	01 d0                	add    %edx,%eax
  80285a:	c1 e0 02             	shl    $0x2,%eax
  80285d:	05 44 10 81 00       	add    $0x811044,%eax
  802862:	8b 10                	mov    (%eax),%edx
  802864:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802867:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80286a:	39 c2                	cmp    %eax,%edx
  80286c:	72 08                	jb     802876 <realloc+0x4de>
		{
			adjIdx = j; break;
  80286e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802871:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802874:	eb 0c                	jmp    802882 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802876:	ff 45 d0             	incl   -0x30(%ebp)
  802879:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802880:	7e a0                	jle    802822 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802882:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802886:	0f 84 d6 00 00 00    	je     802962 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  80288c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80288f:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802892:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802895:	83 ec 08             	sub    $0x8,%esp
  802898:	ff 75 a0             	pushl  -0x60(%ebp)
  80289b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80289e:	e8 cf 09 00 00       	call   803272 <sys_allocate_user_mem>
  8028a3:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  8028a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a9:	89 d0                	mov    %edx,%eax
  8028ab:	01 c0                	add    %eax,%eax
  8028ad:	01 d0                	add    %edx,%eax
  8028af:	c1 e0 02             	shl    $0x2,%eax
  8028b2:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8028b8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028bb:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  8028bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028c0:	89 d0                	mov    %edx,%eax
  8028c2:	01 c0                	add    %eax,%eax
  8028c4:	01 d0                	add    %edx,%eax
  8028c6:	c1 e0 02             	shl    $0x2,%eax
  8028c9:	05 40 10 81 00       	add    $0x811040,%eax
  8028ce:	8b 10                	mov    (%eax),%edx
  8028d0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8028d3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8028d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028d9:	89 d0                	mov    %edx,%eax
  8028db:	01 c0                	add    %eax,%eax
  8028dd:	01 d0                	add    %edx,%eax
  8028df:	c1 e0 02             	shl    $0x2,%eax
  8028e2:	05 40 10 81 00       	add    $0x811040,%eax
  8028e7:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8028e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028ec:	89 d0                	mov    %edx,%eax
  8028ee:	01 c0                	add    %eax,%eax
  8028f0:	01 d0                	add    %edx,%eax
  8028f2:	c1 e0 02             	shl    $0x2,%eax
  8028f5:	05 44 10 81 00       	add    $0x811044,%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	2b 45 a0             	sub    -0x60(%ebp),%eax
  8028ff:	89 c2                	mov    %eax,%edx
  802901:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802904:	89 c8                	mov    %ecx,%eax
  802906:	01 c0                	add    %eax,%eax
  802908:	01 c8                	add    %ecx,%eax
  80290a:	c1 e0 02             	shl    $0x2,%eax
  80290d:	05 44 10 81 00       	add    $0x811044,%eax
  802912:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802914:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802917:	89 d0                	mov    %edx,%eax
  802919:	01 c0                	add    %eax,%eax
  80291b:	01 d0                	add    %edx,%eax
  80291d:	c1 e0 02             	shl    $0x2,%eax
  802920:	05 44 10 81 00       	add    $0x811044,%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	85 c0                	test   %eax,%eax
  802929:	75 14                	jne    80293f <realloc+0x5a7>
  80292b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80292e:	89 d0                	mov    %edx,%eax
  802930:	01 c0                	add    %eax,%eax
  802932:	01 d0                	add    %edx,%eax
  802934:	c1 e0 02             	shl    $0x2,%eax
  802937:	05 48 10 81 00       	add    $0x811048,%eax
  80293c:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  80293f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802942:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802945:	01 c2                	add    %eax,%edx
  802947:	a1 88 50 83 00       	mov    0x835088,%eax
  80294c:	39 c2                	cmp    %eax,%edx
  80294e:	76 0d                	jbe    80295d <realloc+0x5c5>
  802950:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802953:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802956:	01 d0                	add    %edx,%eax
  802958:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	eb 4e                	jmp    8029b0 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802962:	83 ec 0c             	sub    $0xc,%esp
  802965:	ff 75 0c             	pushl  0xc(%ebp)
  802968:	e8 0b ec ff ff       	call   801578 <malloc>
  80296d:	83 c4 10             	add    $0x10,%esp
  802970:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802973:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802977:	75 07                	jne    802980 <realloc+0x5e8>
		return NULL;
  802979:	b8 00 00 00 00       	mov    $0x0,%eax
  80297e:	eb 30                	jmp    8029b0 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802980:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802983:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802986:	39 d0                	cmp    %edx,%eax
  802988:	76 02                	jbe    80298c <realloc+0x5f4>
  80298a:	89 d0                	mov    %edx,%eax
  80298c:	8b 55 9c             	mov    -0x64(%ebp),%edx
  80298f:	83 ec 04             	sub    $0x4,%esp
  802992:	50                   	push   %eax
  802993:	52                   	push   %edx
  802994:	ff 75 cc             	pushl  -0x34(%ebp)
  802997:	e8 cf 06 00 00       	call   80306b <sys_move_user_mem>
  80299c:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  80299f:	83 ec 0c             	sub    $0xc,%esp
  8029a2:	ff 75 08             	pushl  0x8(%ebp)
  8029a5:	e8 2e ef ff ff       	call   8018d8 <free>
  8029aa:	83 c4 10             	add    $0x10,%esp
	return newptr;
  8029ad:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  8029b0:	c9                   	leave  
  8029b1:	c3                   	ret    

008029b2 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
  8029b5:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  8029be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8029c2:	0f 84 33 03 00 00    	je     802cfb <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  8029c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029cb:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  8029d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8029d3:	83 ec 08             	sub    $0x8,%esp
  8029d6:	ff 75 08             	pushl  0x8(%ebp)
  8029d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8029dc:	e8 7d 05 00 00       	call   802f5e <sys_delete_shared_object>
  8029e1:	83 c4 10             	add    $0x10,%esp
  8029e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8029e7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8029eb:	0f 88 0d 03 00 00    	js     802cfe <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029f8:	e9 ef 02 00 00       	jmp    802cec <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8029fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a00:	89 d0                	mov    %edx,%eax
  802a02:	01 c0                	add    %eax,%eax
  802a04:	01 d0                	add    %edx,%eax
  802a06:	c1 e0 02             	shl    $0x2,%eax
  802a09:	05 48 50 80 00       	add    $0x805048,%eax
  802a0e:	8a 00                	mov    (%eax),%al
  802a10:	84 c0                	test   %al,%al
  802a12:	0f 84 d1 02 00 00    	je     802ce9 <sfree+0x337>
  802a18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1b:	89 d0                	mov    %edx,%eax
  802a1d:	01 c0                	add    %eax,%eax
  802a1f:	01 d0                	add    %edx,%eax
  802a21:	c1 e0 02             	shl    $0x2,%eax
  802a24:	05 40 50 80 00       	add    $0x805040,%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802a2e:	0f 85 b5 02 00 00    	jne    802ce9 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a37:	89 d0                	mov    %edx,%eax
  802a39:	01 c0                	add    %eax,%eax
  802a3b:	01 d0                	add    %edx,%eax
  802a3d:	c1 e0 02             	shl    $0x2,%eax
  802a40:	05 44 50 80 00       	add    $0x805044,%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4d:	89 d0                	mov    %edx,%eax
  802a4f:	01 c0                	add    %eax,%eax
  802a51:	01 d0                	add    %edx,%eax
  802a53:	c1 e0 02             	shl    $0x2,%eax
  802a56:	05 48 50 80 00       	add    $0x805048,%eax
  802a5b:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802a5e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a65:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802a6c:	eb 64                	jmp    802ad2 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802a6e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a71:	89 d0                	mov    %edx,%eax
  802a73:	01 c0                	add    %eax,%eax
  802a75:	01 d0                	add    %edx,%eax
  802a77:	c1 e0 02             	shl    $0x2,%eax
  802a7a:	05 48 10 81 00       	add    $0x811048,%eax
  802a7f:	8a 00                	mov    (%eax),%al
  802a81:	84 c0                	test   %al,%al
  802a83:	75 4a                	jne    802acf <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802a85:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a88:	89 d0                	mov    %edx,%eax
  802a8a:	01 c0                	add    %eax,%eax
  802a8c:	01 d0                	add    %edx,%eax
  802a8e:	c1 e0 02             	shl    $0x2,%eax
  802a91:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802a97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a9a:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802a9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a9f:	89 d0                	mov    %edx,%eax
  802aa1:	01 c0                	add    %eax,%eax
  802aa3:	01 d0                	add    %edx,%eax
  802aa5:	c1 e0 02             	shl    $0x2,%eax
  802aa8:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802aae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ab1:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802ab3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ab6:	89 d0                	mov    %edx,%eax
  802ab8:	01 c0                	add    %eax,%eax
  802aba:	01 d0                	add    %edx,%eax
  802abc:	c1 e0 02             	shl    $0x2,%eax
  802abf:	05 48 10 81 00       	add    $0x811048,%eax
  802ac4:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aca:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802acd:	eb 0c                	jmp    802adb <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802acf:	ff 45 ec             	incl   -0x14(%ebp)
  802ad2:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802ad9:	7e 93                	jle    802a6e <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802adb:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802adf:	0f 84 8d 01 00 00    	je     802c72 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ae5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802aec:	e9 74 01 00 00       	jmp    802c65 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802af1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802af7:	0f 84 64 01 00 00    	je     802c61 <sfree+0x2af>
					if (uhp_frees[k].free)
  802afd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b00:	89 d0                	mov    %edx,%eax
  802b02:	01 c0                	add    %eax,%eax
  802b04:	01 d0                	add    %edx,%eax
  802b06:	c1 e0 02             	shl    $0x2,%eax
  802b09:	05 48 10 81 00       	add    $0x811048,%eax
  802b0e:	8a 00                	mov    (%eax),%al
  802b10:	84 c0                	test   %al,%al
  802b12:	0f 84 4a 01 00 00    	je     802c62 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802b18:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b1b:	89 d0                	mov    %edx,%eax
  802b1d:	01 c0                	add    %eax,%eax
  802b1f:	01 d0                	add    %edx,%eax
  802b21:	c1 e0 02             	shl    $0x2,%eax
  802b24:	05 40 10 81 00       	add    $0x811040,%eax
  802b29:	8b 08                	mov    (%eax),%ecx
  802b2b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b2e:	89 d0                	mov    %edx,%eax
  802b30:	01 c0                	add    %eax,%eax
  802b32:	01 d0                	add    %edx,%eax
  802b34:	c1 e0 02             	shl    $0x2,%eax
  802b37:	05 44 10 81 00       	add    $0x811044,%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	01 c1                	add    %eax,%ecx
  802b40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b43:	89 d0                	mov    %edx,%eax
  802b45:	01 c0                	add    %eax,%eax
  802b47:	01 d0                	add    %edx,%eax
  802b49:	c1 e0 02             	shl    $0x2,%eax
  802b4c:	05 40 10 81 00       	add    $0x811040,%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	39 c1                	cmp    %eax,%ecx
  802b55:	75 7a                	jne    802bd1 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802b57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b5a:	89 d0                	mov    %edx,%eax
  802b5c:	01 c0                	add    %eax,%eax
  802b5e:	01 d0                	add    %edx,%eax
  802b60:	c1 e0 02             	shl    $0x2,%eax
  802b63:	05 40 10 81 00       	add    $0x811040,%eax
  802b68:	8b 10                	mov    (%eax),%edx
  802b6a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b6d:	89 c8                	mov    %ecx,%eax
  802b6f:	01 c0                	add    %eax,%eax
  802b71:	01 c8                	add    %ecx,%eax
  802b73:	c1 e0 02             	shl    $0x2,%eax
  802b76:	05 40 10 81 00       	add    $0x811040,%eax
  802b7b:	89 10                	mov    %edx,(%eax)
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
  802bcc:	e9 91 00 00 00       	jmp    802c62 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802bd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd4:	89 d0                	mov    %edx,%eax
  802bd6:	01 c0                	add    %eax,%eax
  802bd8:	01 d0                	add    %edx,%eax
  802bda:	c1 e0 02             	shl    $0x2,%eax
  802bdd:	05 40 10 81 00       	add    $0x811040,%eax
  802be2:	8b 08                	mov    (%eax),%ecx
  802be4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be7:	89 d0                	mov    %edx,%eax
  802be9:	01 c0                	add    %eax,%eax
  802beb:	01 d0                	add    %edx,%eax
  802bed:	c1 e0 02             	shl    $0x2,%eax
  802bf0:	05 44 10 81 00       	add    $0x811044,%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	01 c1                	add    %eax,%ecx
  802bf9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bfc:	89 d0                	mov    %edx,%eax
  802bfe:	01 c0                	add    %eax,%eax
  802c00:	01 d0                	add    %edx,%eax
  802c02:	c1 e0 02             	shl    $0x2,%eax
  802c05:	05 40 10 81 00       	add    $0x811040,%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	39 c1                	cmp    %eax,%ecx
  802c0e:	75 52                	jne    802c62 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802c10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c13:	89 d0                	mov    %edx,%eax
  802c15:	01 c0                	add    %eax,%eax
  802c17:	01 d0                	add    %edx,%eax
  802c19:	c1 e0 02             	shl    $0x2,%eax
  802c1c:	05 44 10 81 00       	add    $0x811044,%eax
  802c21:	8b 08                	mov    (%eax),%ecx
  802c23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c26:	89 d0                	mov    %edx,%eax
  802c28:	01 c0                	add    %eax,%eax
  802c2a:	01 d0                	add    %edx,%eax
  802c2c:	c1 e0 02             	shl    $0x2,%eax
  802c2f:	05 44 10 81 00       	add    $0x811044,%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	01 c1                	add    %eax,%ecx
  802c38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3b:	89 d0                	mov    %edx,%eax
  802c3d:	01 c0                	add    %eax,%eax
  802c3f:	01 d0                	add    %edx,%eax
  802c41:	c1 e0 02             	shl    $0x2,%eax
  802c44:	05 44 10 81 00       	add    $0x811044,%eax
  802c49:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802c4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c4e:	89 d0                	mov    %edx,%eax
  802c50:	01 c0                	add    %eax,%eax
  802c52:	01 d0                	add    %edx,%eax
  802c54:	c1 e0 02             	shl    $0x2,%eax
  802c57:	05 48 10 81 00       	add    $0x811048,%eax
  802c5c:	c6 00 00             	movb   $0x0,(%eax)
  802c5f:	eb 01                	jmp    802c62 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802c61:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c62:	ff 45 e8             	incl   -0x18(%ebp)
  802c65:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802c6c:	0f 8e 7f fe ff ff    	jle    802af1 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802c72:	a1 30 51 83 00       	mov    0x835130,%eax
  802c77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802c7a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802c81:	eb 53                	jmp    802cd6 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802c83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c86:	89 d0                	mov    %edx,%eax
  802c88:	01 c0                	add    %eax,%eax
  802c8a:	01 d0                	add    %edx,%eax
  802c8c:	c1 e0 02             	shl    $0x2,%eax
  802c8f:	05 48 50 80 00       	add    $0x805048,%eax
  802c94:	8a 00                	mov    (%eax),%al
  802c96:	84 c0                	test   %al,%al
  802c98:	74 39                	je     802cd3 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802c9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c9d:	89 d0                	mov    %edx,%eax
  802c9f:	01 c0                	add    %eax,%eax
  802ca1:	01 d0                	add    %edx,%eax
  802ca3:	c1 e0 02             	shl    $0x2,%eax
  802ca6:	05 40 50 80 00       	add    $0x805040,%eax
  802cab:	8b 08                	mov    (%eax),%ecx
  802cad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cb0:	89 d0                	mov    %edx,%eax
  802cb2:	01 c0                	add    %eax,%eax
  802cb4:	01 d0                	add    %edx,%eax
  802cb6:	c1 e0 02             	shl    $0x2,%eax
  802cb9:	05 44 50 80 00       	add    $0x805044,%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	01 c8                	add    %ecx,%eax
  802cc2:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802cc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ccb:	76 06                	jbe    802cd3 <sfree+0x321>
  802ccd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802cd3:	ff 45 e0             	incl   -0x20(%ebp)
  802cd6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802cdd:	7e a4                	jle    802c83 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802cdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce2:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802ce7:	eb 16                	jmp    802cff <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802ce9:	ff 45 f4             	incl   -0xc(%ebp)
  802cec:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802cf3:	0f 8e 04 fd ff ff    	jle    8029fd <sfree+0x4b>
  802cf9:	eb 04                	jmp    802cff <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802cfb:	90                   	nop
  802cfc:	eb 01                	jmp    802cff <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802cfe:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802cff:	c9                   	leave  
  802d00:	c3                   	ret    

00802d01 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d01:	55                   	push   %ebp
  802d02:	89 e5                	mov    %esp,%ebp
  802d04:	57                   	push   %edi
  802d05:	56                   	push   %esi
  802d06:	53                   	push   %ebx
  802d07:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d13:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d16:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d19:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d1c:	cd 30                	int    $0x30
  802d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d24:	83 c4 10             	add    $0x10,%esp
  802d27:	5b                   	pop    %ebx
  802d28:	5e                   	pop    %esi
  802d29:	5f                   	pop    %edi
  802d2a:	5d                   	pop    %ebp
  802d2b:	c3                   	ret    

00802d2c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802d2c:	55                   	push   %ebp
  802d2d:	89 e5                	mov    %esp,%ebp
  802d2f:	83 ec 04             	sub    $0x4,%esp
  802d32:	8b 45 10             	mov    0x10(%ebp),%eax
  802d35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802d38:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d3b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	6a 00                	push   $0x0
  802d44:	51                   	push   %ecx
  802d45:	52                   	push   %edx
  802d46:	ff 75 0c             	pushl  0xc(%ebp)
  802d49:	50                   	push   %eax
  802d4a:	6a 00                	push   $0x0
  802d4c:	e8 b0 ff ff ff       	call   802d01 <syscall>
  802d51:	83 c4 18             	add    $0x18,%esp
}
  802d54:	90                   	nop
  802d55:	c9                   	leave  
  802d56:	c3                   	ret    

00802d57 <sys_cgetc>:

int
sys_cgetc(void)
{
  802d57:	55                   	push   %ebp
  802d58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802d5a:	6a 00                	push   $0x0
  802d5c:	6a 00                	push   $0x0
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 00                	push   $0x0
  802d62:	6a 00                	push   $0x0
  802d64:	6a 02                	push   $0x2
  802d66:	e8 96 ff ff ff       	call   802d01 <syscall>
  802d6b:	83 c4 18             	add    $0x18,%esp
}
  802d6e:	c9                   	leave  
  802d6f:	c3                   	ret    

00802d70 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802d70:	55                   	push   %ebp
  802d71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802d73:	6a 00                	push   $0x0
  802d75:	6a 00                	push   $0x0
  802d77:	6a 00                	push   $0x0
  802d79:	6a 00                	push   $0x0
  802d7b:	6a 00                	push   $0x0
  802d7d:	6a 03                	push   $0x3
  802d7f:	e8 7d ff ff ff       	call   802d01 <syscall>
  802d84:	83 c4 18             	add    $0x18,%esp
}
  802d87:	90                   	nop
  802d88:	c9                   	leave  
  802d89:	c3                   	ret    

00802d8a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802d8a:	55                   	push   %ebp
  802d8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802d8d:	6a 00                	push   $0x0
  802d8f:	6a 00                	push   $0x0
  802d91:	6a 00                	push   $0x0
  802d93:	6a 00                	push   $0x0
  802d95:	6a 00                	push   $0x0
  802d97:	6a 04                	push   $0x4
  802d99:	e8 63 ff ff ff       	call   802d01 <syscall>
  802d9e:	83 c4 18             	add    $0x18,%esp
}
  802da1:	90                   	nop
  802da2:	c9                   	leave  
  802da3:	c3                   	ret    

00802da4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802da4:	55                   	push   %ebp
  802da5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802da7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	6a 00                	push   $0x0
  802daf:	6a 00                	push   $0x0
  802db1:	6a 00                	push   $0x0
  802db3:	52                   	push   %edx
  802db4:	50                   	push   %eax
  802db5:	6a 08                	push   $0x8
  802db7:	e8 45 ff ff ff       	call   802d01 <syscall>
  802dbc:	83 c4 18             	add    $0x18,%esp
}
  802dbf:	c9                   	leave  
  802dc0:	c3                   	ret    

00802dc1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802dc1:	55                   	push   %ebp
  802dc2:	89 e5                	mov    %esp,%ebp
  802dc4:	56                   	push   %esi
  802dc5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802dc6:	8b 75 18             	mov    0x18(%ebp),%esi
  802dc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802dcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	56                   	push   %esi
  802dd6:	53                   	push   %ebx
  802dd7:	51                   	push   %ecx
  802dd8:	52                   	push   %edx
  802dd9:	50                   	push   %eax
  802dda:	6a 09                	push   $0x9
  802ddc:	e8 20 ff ff ff       	call   802d01 <syscall>
  802de1:	83 c4 18             	add    $0x18,%esp
}
  802de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802de7:	5b                   	pop    %ebx
  802de8:	5e                   	pop    %esi
  802de9:	5d                   	pop    %ebp
  802dea:	c3                   	ret    

00802deb <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802deb:	55                   	push   %ebp
  802dec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802dee:	6a 00                	push   $0x0
  802df0:	6a 00                	push   $0x0
  802df2:	6a 00                	push   $0x0
  802df4:	6a 00                	push   $0x0
  802df6:	ff 75 08             	pushl  0x8(%ebp)
  802df9:	6a 0a                	push   $0xa
  802dfb:	e8 01 ff ff ff       	call   802d01 <syscall>
  802e00:	83 c4 18             	add    $0x18,%esp
}
  802e03:	c9                   	leave  
  802e04:	c3                   	ret    

00802e05 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802e05:	55                   	push   %ebp
  802e06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802e08:	6a 00                	push   $0x0
  802e0a:	6a 00                	push   $0x0
  802e0c:	6a 00                	push   $0x0
  802e0e:	ff 75 0c             	pushl  0xc(%ebp)
  802e11:	ff 75 08             	pushl  0x8(%ebp)
  802e14:	6a 0b                	push   $0xb
  802e16:	e8 e6 fe ff ff       	call   802d01 <syscall>
  802e1b:	83 c4 18             	add    $0x18,%esp
}
  802e1e:	c9                   	leave  
  802e1f:	c3                   	ret    

00802e20 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802e20:	55                   	push   %ebp
  802e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802e23:	6a 00                	push   $0x0
  802e25:	6a 00                	push   $0x0
  802e27:	6a 00                	push   $0x0
  802e29:	6a 00                	push   $0x0
  802e2b:	6a 00                	push   $0x0
  802e2d:	6a 0c                	push   $0xc
  802e2f:	e8 cd fe ff ff       	call   802d01 <syscall>
  802e34:	83 c4 18             	add    $0x18,%esp
}
  802e37:	c9                   	leave  
  802e38:	c3                   	ret    

00802e39 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e39:	55                   	push   %ebp
  802e3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e3c:	6a 00                	push   $0x0
  802e3e:	6a 00                	push   $0x0
  802e40:	6a 00                	push   $0x0
  802e42:	6a 00                	push   $0x0
  802e44:	6a 00                	push   $0x0
  802e46:	6a 0d                	push   $0xd
  802e48:	e8 b4 fe ff ff       	call   802d01 <syscall>
  802e4d:	83 c4 18             	add    $0x18,%esp
}
  802e50:	c9                   	leave  
  802e51:	c3                   	ret    

00802e52 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802e52:	55                   	push   %ebp
  802e53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e55:	6a 00                	push   $0x0
  802e57:	6a 00                	push   $0x0
  802e59:	6a 00                	push   $0x0
  802e5b:	6a 00                	push   $0x0
  802e5d:	6a 00                	push   $0x0
  802e5f:	6a 0e                	push   $0xe
  802e61:	e8 9b fe ff ff       	call   802d01 <syscall>
  802e66:	83 c4 18             	add    $0x18,%esp
}
  802e69:	c9                   	leave  
  802e6a:	c3                   	ret    

00802e6b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802e6b:	55                   	push   %ebp
  802e6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802e6e:	6a 00                	push   $0x0
  802e70:	6a 00                	push   $0x0
  802e72:	6a 00                	push   $0x0
  802e74:	6a 00                	push   $0x0
  802e76:	6a 00                	push   $0x0
  802e78:	6a 0f                	push   $0xf
  802e7a:	e8 82 fe ff ff       	call   802d01 <syscall>
  802e7f:	83 c4 18             	add    $0x18,%esp
}
  802e82:	c9                   	leave  
  802e83:	c3                   	ret    

00802e84 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802e84:	55                   	push   %ebp
  802e85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802e87:	6a 00                	push   $0x0
  802e89:	6a 00                	push   $0x0
  802e8b:	6a 00                	push   $0x0
  802e8d:	6a 00                	push   $0x0
  802e8f:	ff 75 08             	pushl  0x8(%ebp)
  802e92:	6a 10                	push   $0x10
  802e94:	e8 68 fe ff ff       	call   802d01 <syscall>
  802e99:	83 c4 18             	add    $0x18,%esp
}
  802e9c:	c9                   	leave  
  802e9d:	c3                   	ret    

00802e9e <sys_scarce_memory>:

void sys_scarce_memory()
{
  802e9e:	55                   	push   %ebp
  802e9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802ea1:	6a 00                	push   $0x0
  802ea3:	6a 00                	push   $0x0
  802ea5:	6a 00                	push   $0x0
  802ea7:	6a 00                	push   $0x0
  802ea9:	6a 00                	push   $0x0
  802eab:	6a 11                	push   $0x11
  802ead:	e8 4f fe ff ff       	call   802d01 <syscall>
  802eb2:	83 c4 18             	add    $0x18,%esp
}
  802eb5:	90                   	nop
  802eb6:	c9                   	leave  
  802eb7:	c3                   	ret    

00802eb8 <sys_cputc>:

void
sys_cputc(const char c)
{
  802eb8:	55                   	push   %ebp
  802eb9:	89 e5                	mov    %esp,%ebp
  802ebb:	83 ec 04             	sub    $0x4,%esp
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802ec4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ec8:	6a 00                	push   $0x0
  802eca:	6a 00                	push   $0x0
  802ecc:	6a 00                	push   $0x0
  802ece:	6a 00                	push   $0x0
  802ed0:	50                   	push   %eax
  802ed1:	6a 01                	push   $0x1
  802ed3:	e8 29 fe ff ff       	call   802d01 <syscall>
  802ed8:	83 c4 18             	add    $0x18,%esp
}
  802edb:	90                   	nop
  802edc:	c9                   	leave  
  802edd:	c3                   	ret    

00802ede <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ede:	55                   	push   %ebp
  802edf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ee1:	6a 00                	push   $0x0
  802ee3:	6a 00                	push   $0x0
  802ee5:	6a 00                	push   $0x0
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 00                	push   $0x0
  802eeb:	6a 14                	push   $0x14
  802eed:	e8 0f fe ff ff       	call   802d01 <syscall>
  802ef2:	83 c4 18             	add    $0x18,%esp
}
  802ef5:	90                   	nop
  802ef6:	c9                   	leave  
  802ef7:	c3                   	ret    

00802ef8 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802ef8:	55                   	push   %ebp
  802ef9:	89 e5                	mov    %esp,%ebp
  802efb:	83 ec 04             	sub    $0x4,%esp
  802efe:	8b 45 10             	mov    0x10(%ebp),%eax
  802f01:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802f04:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f07:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	6a 00                	push   $0x0
  802f10:	51                   	push   %ecx
  802f11:	52                   	push   %edx
  802f12:	ff 75 0c             	pushl  0xc(%ebp)
  802f15:	50                   	push   %eax
  802f16:	6a 15                	push   $0x15
  802f18:	e8 e4 fd ff ff       	call   802d01 <syscall>
  802f1d:	83 c4 18             	add    $0x18,%esp
}
  802f20:	c9                   	leave  
  802f21:	c3                   	ret    

00802f22 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802f22:	55                   	push   %ebp
  802f23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	6a 00                	push   $0x0
  802f31:	52                   	push   %edx
  802f32:	50                   	push   %eax
  802f33:	6a 16                	push   $0x16
  802f35:	e8 c7 fd ff ff       	call   802d01 <syscall>
  802f3a:	83 c4 18             	add    $0x18,%esp
}
  802f3d:	c9                   	leave  
  802f3e:	c3                   	ret    

00802f3f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802f3f:	55                   	push   %ebp
  802f40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802f42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	6a 00                	push   $0x0
  802f4d:	6a 00                	push   $0x0
  802f4f:	51                   	push   %ecx
  802f50:	52                   	push   %edx
  802f51:	50                   	push   %eax
  802f52:	6a 17                	push   $0x17
  802f54:	e8 a8 fd ff ff       	call   802d01 <syscall>
  802f59:	83 c4 18             	add    $0x18,%esp
}
  802f5c:	c9                   	leave  
  802f5d:	c3                   	ret    

00802f5e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802f5e:	55                   	push   %ebp
  802f5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802f61:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	6a 00                	push   $0x0
  802f69:	6a 00                	push   $0x0
  802f6b:	6a 00                	push   $0x0
  802f6d:	52                   	push   %edx
  802f6e:	50                   	push   %eax
  802f6f:	6a 18                	push   $0x18
  802f71:	e8 8b fd ff ff       	call   802d01 <syscall>
  802f76:	83 c4 18             	add    $0x18,%esp
}
  802f79:	c9                   	leave  
  802f7a:	c3                   	ret    

00802f7b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802f7b:	55                   	push   %ebp
  802f7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	6a 00                	push   $0x0
  802f83:	ff 75 14             	pushl  0x14(%ebp)
  802f86:	ff 75 10             	pushl  0x10(%ebp)
  802f89:	ff 75 0c             	pushl  0xc(%ebp)
  802f8c:	50                   	push   %eax
  802f8d:	6a 19                	push   $0x19
  802f8f:	e8 6d fd ff ff       	call   802d01 <syscall>
  802f94:	83 c4 18             	add    $0x18,%esp
}
  802f97:	c9                   	leave  
  802f98:	c3                   	ret    

00802f99 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802f99:	55                   	push   %ebp
  802f9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	6a 00                	push   $0x0
  802fa1:	6a 00                	push   $0x0
  802fa3:	6a 00                	push   $0x0
  802fa5:	6a 00                	push   $0x0
  802fa7:	50                   	push   %eax
  802fa8:	6a 1a                	push   $0x1a
  802faa:	e8 52 fd ff ff       	call   802d01 <syscall>
  802faf:	83 c4 18             	add    $0x18,%esp
}
  802fb2:	90                   	nop
  802fb3:	c9                   	leave  
  802fb4:	c3                   	ret    

00802fb5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802fb5:	55                   	push   %ebp
  802fb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbb:	6a 00                	push   $0x0
  802fbd:	6a 00                	push   $0x0
  802fbf:	6a 00                	push   $0x0
  802fc1:	6a 00                	push   $0x0
  802fc3:	50                   	push   %eax
  802fc4:	6a 1b                	push   $0x1b
  802fc6:	e8 36 fd ff ff       	call   802d01 <syscall>
  802fcb:	83 c4 18             	add    $0x18,%esp
}
  802fce:	c9                   	leave  
  802fcf:	c3                   	ret    

00802fd0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802fd0:	55                   	push   %ebp
  802fd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802fd3:	6a 00                	push   $0x0
  802fd5:	6a 00                	push   $0x0
  802fd7:	6a 00                	push   $0x0
  802fd9:	6a 00                	push   $0x0
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 05                	push   $0x5
  802fdf:	e8 1d fd ff ff       	call   802d01 <syscall>
  802fe4:	83 c4 18             	add    $0x18,%esp
}
  802fe7:	c9                   	leave  
  802fe8:	c3                   	ret    

00802fe9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802fe9:	55                   	push   %ebp
  802fea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802fec:	6a 00                	push   $0x0
  802fee:	6a 00                	push   $0x0
  802ff0:	6a 00                	push   $0x0
  802ff2:	6a 00                	push   $0x0
  802ff4:	6a 00                	push   $0x0
  802ff6:	6a 06                	push   $0x6
  802ff8:	e8 04 fd ff ff       	call   802d01 <syscall>
  802ffd:	83 c4 18             	add    $0x18,%esp
}
  803000:	c9                   	leave  
  803001:	c3                   	ret    

00803002 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803002:	55                   	push   %ebp
  803003:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803005:	6a 00                	push   $0x0
  803007:	6a 00                	push   $0x0
  803009:	6a 00                	push   $0x0
  80300b:	6a 00                	push   $0x0
  80300d:	6a 00                	push   $0x0
  80300f:	6a 07                	push   $0x7
  803011:	e8 eb fc ff ff       	call   802d01 <syscall>
  803016:	83 c4 18             	add    $0x18,%esp
}
  803019:	c9                   	leave  
  80301a:	c3                   	ret    

0080301b <sys_exit_env>:


void sys_exit_env(void)
{
  80301b:	55                   	push   %ebp
  80301c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	6a 00                	push   $0x0
  803026:	6a 00                	push   $0x0
  803028:	6a 1c                	push   $0x1c
  80302a:	e8 d2 fc ff ff       	call   802d01 <syscall>
  80302f:	83 c4 18             	add    $0x18,%esp
}
  803032:	90                   	nop
  803033:	c9                   	leave  
  803034:	c3                   	ret    

00803035 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803035:	55                   	push   %ebp
  803036:	89 e5                	mov    %esp,%ebp
  803038:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80303b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80303e:	8d 50 04             	lea    0x4(%eax),%edx
  803041:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	52                   	push   %edx
  80304b:	50                   	push   %eax
  80304c:	6a 1d                	push   $0x1d
  80304e:	e8 ae fc ff ff       	call   802d01 <syscall>
  803053:	83 c4 18             	add    $0x18,%esp
	return result;
  803056:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80305c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80305f:	89 01                	mov    %eax,(%ecx)
  803061:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	c9                   	leave  
  803068:	c2 04 00             	ret    $0x4

0080306b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80306b:	55                   	push   %ebp
  80306c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80306e:	6a 00                	push   $0x0
  803070:	6a 00                	push   $0x0
  803072:	ff 75 10             	pushl  0x10(%ebp)
  803075:	ff 75 0c             	pushl  0xc(%ebp)
  803078:	ff 75 08             	pushl  0x8(%ebp)
  80307b:	6a 13                	push   $0x13
  80307d:	e8 7f fc ff ff       	call   802d01 <syscall>
  803082:	83 c4 18             	add    $0x18,%esp
	return ;
  803085:	90                   	nop
}
  803086:	c9                   	leave  
  803087:	c3                   	ret    

00803088 <sys_rcr2>:
uint32 sys_rcr2()
{
  803088:	55                   	push   %ebp
  803089:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80308b:	6a 00                	push   $0x0
  80308d:	6a 00                	push   $0x0
  80308f:	6a 00                	push   $0x0
  803091:	6a 00                	push   $0x0
  803093:	6a 00                	push   $0x0
  803095:	6a 1e                	push   $0x1e
  803097:	e8 65 fc ff ff       	call   802d01 <syscall>
  80309c:	83 c4 18             	add    $0x18,%esp
}
  80309f:	c9                   	leave  
  8030a0:	c3                   	ret    

008030a1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8030a1:	55                   	push   %ebp
  8030a2:	89 e5                	mov    %esp,%ebp
  8030a4:	83 ec 04             	sub    $0x4,%esp
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8030ad:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 00                	push   $0x0
  8030b9:	50                   	push   %eax
  8030ba:	6a 1f                	push   $0x1f
  8030bc:	e8 40 fc ff ff       	call   802d01 <syscall>
  8030c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8030c4:	90                   	nop
}
  8030c5:	c9                   	leave  
  8030c6:	c3                   	ret    

008030c7 <rsttst>:
void rsttst()
{
  8030c7:	55                   	push   %ebp
  8030c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8030ca:	6a 00                	push   $0x0
  8030cc:	6a 00                	push   $0x0
  8030ce:	6a 00                	push   $0x0
  8030d0:	6a 00                	push   $0x0
  8030d2:	6a 00                	push   $0x0
  8030d4:	6a 21                	push   $0x21
  8030d6:	e8 26 fc ff ff       	call   802d01 <syscall>
  8030db:	83 c4 18             	add    $0x18,%esp
	return ;
  8030de:	90                   	nop
}
  8030df:	c9                   	leave  
  8030e0:	c3                   	ret    

008030e1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8030e1:	55                   	push   %ebp
  8030e2:	89 e5                	mov    %esp,%ebp
  8030e4:	83 ec 04             	sub    $0x4,%esp
  8030e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8030ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8030ed:	8b 55 18             	mov    0x18(%ebp),%edx
  8030f0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030f4:	52                   	push   %edx
  8030f5:	50                   	push   %eax
  8030f6:	ff 75 10             	pushl  0x10(%ebp)
  8030f9:	ff 75 0c             	pushl  0xc(%ebp)
  8030fc:	ff 75 08             	pushl  0x8(%ebp)
  8030ff:	6a 20                	push   $0x20
  803101:	e8 fb fb ff ff       	call   802d01 <syscall>
  803106:	83 c4 18             	add    $0x18,%esp
	return ;
  803109:	90                   	nop
}
  80310a:	c9                   	leave  
  80310b:	c3                   	ret    

0080310c <chktst>:
void chktst(uint32 n)
{
  80310c:	55                   	push   %ebp
  80310d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80310f:	6a 00                	push   $0x0
  803111:	6a 00                	push   $0x0
  803113:	6a 00                	push   $0x0
  803115:	6a 00                	push   $0x0
  803117:	ff 75 08             	pushl  0x8(%ebp)
  80311a:	6a 22                	push   $0x22
  80311c:	e8 e0 fb ff ff       	call   802d01 <syscall>
  803121:	83 c4 18             	add    $0x18,%esp
	return ;
  803124:	90                   	nop
}
  803125:	c9                   	leave  
  803126:	c3                   	ret    

00803127 <inctst>:

void inctst()
{
  803127:	55                   	push   %ebp
  803128:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80312a:	6a 00                	push   $0x0
  80312c:	6a 00                	push   $0x0
  80312e:	6a 00                	push   $0x0
  803130:	6a 00                	push   $0x0
  803132:	6a 00                	push   $0x0
  803134:	6a 23                	push   $0x23
  803136:	e8 c6 fb ff ff       	call   802d01 <syscall>
  80313b:	83 c4 18             	add    $0x18,%esp
	return ;
  80313e:	90                   	nop
}
  80313f:	c9                   	leave  
  803140:	c3                   	ret    

00803141 <gettst>:
uint32 gettst()
{
  803141:	55                   	push   %ebp
  803142:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803144:	6a 00                	push   $0x0
  803146:	6a 00                	push   $0x0
  803148:	6a 00                	push   $0x0
  80314a:	6a 00                	push   $0x0
  80314c:	6a 00                	push   $0x0
  80314e:	6a 24                	push   $0x24
  803150:	e8 ac fb ff ff       	call   802d01 <syscall>
  803155:	83 c4 18             	add    $0x18,%esp
}
  803158:	c9                   	leave  
  803159:	c3                   	ret    

0080315a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80315a:	55                   	push   %ebp
  80315b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80315d:	6a 00                	push   $0x0
  80315f:	6a 00                	push   $0x0
  803161:	6a 00                	push   $0x0
  803163:	6a 00                	push   $0x0
  803165:	6a 00                	push   $0x0
  803167:	6a 25                	push   $0x25
  803169:	e8 93 fb ff ff       	call   802d01 <syscall>
  80316e:	83 c4 18             	add    $0x18,%esp
  803171:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803176:	a1 80 50 83 00       	mov    0x835080,%eax
}
  80317b:	c9                   	leave  
  80317c:	c3                   	ret    

0080317d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80317d:	55                   	push   %ebp
  80317e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803188:	6a 00                	push   $0x0
  80318a:	6a 00                	push   $0x0
  80318c:	6a 00                	push   $0x0
  80318e:	6a 00                	push   $0x0
  803190:	ff 75 08             	pushl  0x8(%ebp)
  803193:	6a 26                	push   $0x26
  803195:	e8 67 fb ff ff       	call   802d01 <syscall>
  80319a:	83 c4 18             	add    $0x18,%esp
	return ;
  80319d:	90                   	nop
}
  80319e:	c9                   	leave  
  80319f:	c3                   	ret    

008031a0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8031a0:	55                   	push   %ebp
  8031a1:	89 e5                	mov    %esp,%ebp
  8031a3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8031a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8031a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	6a 00                	push   $0x0
  8031b2:	53                   	push   %ebx
  8031b3:	51                   	push   %ecx
  8031b4:	52                   	push   %edx
  8031b5:	50                   	push   %eax
  8031b6:	6a 27                	push   $0x27
  8031b8:	e8 44 fb ff ff       	call   802d01 <syscall>
  8031bd:	83 c4 18             	add    $0x18,%esp
}
  8031c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031c3:	c9                   	leave  
  8031c4:	c3                   	ret    

008031c5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8031c5:	55                   	push   %ebp
  8031c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8031c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	6a 00                	push   $0x0
  8031d0:	6a 00                	push   $0x0
  8031d2:	6a 00                	push   $0x0
  8031d4:	52                   	push   %edx
  8031d5:	50                   	push   %eax
  8031d6:	6a 28                	push   $0x28
  8031d8:	e8 24 fb ff ff       	call   802d01 <syscall>
  8031dd:	83 c4 18             	add    $0x18,%esp
}
  8031e0:	c9                   	leave  
  8031e1:	c3                   	ret    

008031e2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8031e2:	55                   	push   %ebp
  8031e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8031e5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	6a 00                	push   $0x0
  8031f0:	51                   	push   %ecx
  8031f1:	ff 75 10             	pushl  0x10(%ebp)
  8031f4:	52                   	push   %edx
  8031f5:	50                   	push   %eax
  8031f6:	6a 29                	push   $0x29
  8031f8:	e8 04 fb ff ff       	call   802d01 <syscall>
  8031fd:	83 c4 18             	add    $0x18,%esp
}
  803200:	c9                   	leave  
  803201:	c3                   	ret    

00803202 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803205:	6a 00                	push   $0x0
  803207:	6a 00                	push   $0x0
  803209:	ff 75 10             	pushl  0x10(%ebp)
  80320c:	ff 75 0c             	pushl  0xc(%ebp)
  80320f:	ff 75 08             	pushl  0x8(%ebp)
  803212:	6a 12                	push   $0x12
  803214:	e8 e8 fa ff ff       	call   802d01 <syscall>
  803219:	83 c4 18             	add    $0x18,%esp
	return ;
  80321c:	90                   	nop
}
  80321d:	c9                   	leave  
  80321e:	c3                   	ret    

0080321f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80321f:	55                   	push   %ebp
  803220:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803222:	8b 55 0c             	mov    0xc(%ebp),%edx
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	6a 00                	push   $0x0
  80322a:	6a 00                	push   $0x0
  80322c:	6a 00                	push   $0x0
  80322e:	52                   	push   %edx
  80322f:	50                   	push   %eax
  803230:	6a 2a                	push   $0x2a
  803232:	e8 ca fa ff ff       	call   802d01 <syscall>
  803237:	83 c4 18             	add    $0x18,%esp
	return;
  80323a:	90                   	nop
}
  80323b:	c9                   	leave  
  80323c:	c3                   	ret    

0080323d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80323d:	55                   	push   %ebp
  80323e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803240:	6a 00                	push   $0x0
  803242:	6a 00                	push   $0x0
  803244:	6a 00                	push   $0x0
  803246:	6a 00                	push   $0x0
  803248:	6a 00                	push   $0x0
  80324a:	6a 2b                	push   $0x2b
  80324c:	e8 b0 fa ff ff       	call   802d01 <syscall>
  803251:	83 c4 18             	add    $0x18,%esp
}
  803254:	c9                   	leave  
  803255:	c3                   	ret    

00803256 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803256:	55                   	push   %ebp
  803257:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803259:	6a 00                	push   $0x0
  80325b:	6a 00                	push   $0x0
  80325d:	6a 00                	push   $0x0
  80325f:	ff 75 0c             	pushl  0xc(%ebp)
  803262:	ff 75 08             	pushl  0x8(%ebp)
  803265:	6a 2d                	push   $0x2d
  803267:	e8 95 fa ff ff       	call   802d01 <syscall>
  80326c:	83 c4 18             	add    $0x18,%esp
	return;
  80326f:	90                   	nop
}
  803270:	c9                   	leave  
  803271:	c3                   	ret    

00803272 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803272:	55                   	push   %ebp
  803273:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803275:	6a 00                	push   $0x0
  803277:	6a 00                	push   $0x0
  803279:	6a 00                	push   $0x0
  80327b:	ff 75 0c             	pushl  0xc(%ebp)
  80327e:	ff 75 08             	pushl  0x8(%ebp)
  803281:	6a 2c                	push   $0x2c
  803283:	e8 79 fa ff ff       	call   802d01 <syscall>
  803288:	83 c4 18             	add    $0x18,%esp
	return ;
  80328b:	90                   	nop
}
  80328c:	c9                   	leave  
  80328d:	c3                   	ret    

0080328e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80328e:	55                   	push   %ebp
  80328f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803291:	8b 55 0c             	mov    0xc(%ebp),%edx
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	6a 00                	push   $0x0
  803299:	6a 00                	push   $0x0
  80329b:	6a 00                	push   $0x0
  80329d:	52                   	push   %edx
  80329e:	50                   	push   %eax
  80329f:	6a 2e                	push   $0x2e
  8032a1:	e8 5b fa ff ff       	call   802d01 <syscall>
  8032a6:	83 c4 18             	add    $0x18,%esp
}
  8032a9:	90                   	nop
  8032aa:	c9                   	leave  
  8032ab:	c3                   	ret    

008032ac <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8032ac:	55                   	push   %ebp
  8032ad:	89 e5                	mov    %esp,%ebp
  8032af:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8032b2:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  8032b9:	72 09                	jb     8032c4 <to_page_va+0x18>
  8032bb:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  8032c2:	72 14                	jb     8032d8 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	68 18 47 80 00       	push   $0x804718
  8032cc:	6a 15                	push   $0x15
  8032ce:	68 43 47 80 00       	push   $0x804743
  8032d3:	e8 10 d0 ff ff       	call   8002e8 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8032e0:	29 d0                	sub    %edx,%eax
  8032e2:	c1 f8 02             	sar    $0x2,%eax
  8032e5:	89 c2                	mov    %eax,%edx
  8032e7:	89 d0                	mov    %edx,%eax
  8032e9:	c1 e0 02             	shl    $0x2,%eax
  8032ec:	01 d0                	add    %edx,%eax
  8032ee:	c1 e0 02             	shl    $0x2,%eax
  8032f1:	01 d0                	add    %edx,%eax
  8032f3:	c1 e0 02             	shl    $0x2,%eax
  8032f6:	01 d0                	add    %edx,%eax
  8032f8:	89 c1                	mov    %eax,%ecx
  8032fa:	c1 e1 08             	shl    $0x8,%ecx
  8032fd:	01 c8                	add    %ecx,%eax
  8032ff:	89 c1                	mov    %eax,%ecx
  803301:	c1 e1 10             	shl    $0x10,%ecx
  803304:	01 c8                	add    %ecx,%eax
  803306:	01 c0                	add    %eax,%eax
  803308:	01 d0                	add    %edx,%eax
  80330a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803310:	c1 e0 0c             	shl    $0xc,%eax
  803313:	89 c2                	mov    %eax,%edx
  803315:	a1 84 50 83 00       	mov    0x835084,%eax
  80331a:	01 d0                	add    %edx,%eax
}
  80331c:	c9                   	leave  
  80331d:	c3                   	ret    

0080331e <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80331e:	55                   	push   %ebp
  80331f:	89 e5                	mov    %esp,%ebp
  803321:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803324:	a1 84 50 83 00       	mov    0x835084,%eax
  803329:	8b 55 08             	mov    0x8(%ebp),%edx
  80332c:	29 c2                	sub    %eax,%edx
  80332e:	89 d0                	mov    %edx,%eax
  803330:	c1 e8 0c             	shr    $0xc,%eax
  803333:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803336:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80333a:	78 09                	js     803345 <to_page_info+0x27>
  80333c:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803343:	7e 14                	jle    803359 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	68 5c 47 80 00       	push   $0x80475c
  80334d:	6a 21                	push   $0x21
  80334f:	68 43 47 80 00       	push   $0x804743
  803354:	e8 8f cf ff ff       	call   8002e8 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803359:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335c:	89 d0                	mov    %edx,%eax
  80335e:	01 c0                	add    %eax,%eax
  803360:	01 d0                	add    %edx,%eax
  803362:	c1 e0 02             	shl    $0x2,%eax
  803365:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  80336a:	c9                   	leave  
  80336b:	c3                   	ret    

0080336c <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80336c:	55                   	push   %ebp
  80336d:	89 e5                	mov    %esp,%ebp
  80336f:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	05 00 00 00 02       	add    $0x2000000,%eax
  80337a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80337d:	73 16                	jae    803395 <initialize_dynamic_allocator+0x29>
  80337f:	68 80 47 80 00       	push   $0x804780
  803384:	68 a6 47 80 00       	push   $0x8047a6
  803389:	6a 2f                	push   $0x2f
  80338b:	68 43 47 80 00       	push   $0x804743
  803390:	e8 53 cf ff ff       	call   8002e8 <_panic>
	dynAllocStart = daStart;
  803395:	8b 45 08             	mov    0x8(%ebp),%eax
  803398:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  80339d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a0:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8033a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033ac:	eb 36                	jmp    8033e4 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	c1 e0 04             	shl    $0x4,%eax
  8033b4:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8033b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c2:	c1 e0 04             	shl    $0x4,%eax
  8033c5:	05 a4 50 83 00       	add    $0x8350a4,%eax
  8033ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d3:	c1 e0 04             	shl    $0x4,%eax
  8033d6:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8033db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8033e1:	ff 45 f4             	incl   -0xc(%ebp)
  8033e4:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8033e8:	7e c4                	jle    8033ae <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8033ea:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  8033f1:	00 00 00 
  8033f4:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  8033fb:	00 00 00 
  8033fe:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  803405:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803408:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80340f:	e9 1b 01 00 00       	jmp    80352f <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803414:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803417:	89 d0                	mov    %edx,%eax
  803419:	01 c0                	add    %eax,%eax
  80341b:	01 d0                	add    %edx,%eax
  80341d:	c1 e0 02             	shl    $0x2,%eax
  803420:	05 88 d0 81 00       	add    $0x81d088,%eax
  803425:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  80342a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80342d:	89 d0                	mov    %edx,%eax
  80342f:	01 c0                	add    %eax,%eax
  803431:	01 d0                	add    %edx,%eax
  803433:	c1 e0 02             	shl    $0x2,%eax
  803436:	05 8a d0 81 00       	add    $0x81d08a,%eax
  80343b:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803440:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803443:	89 d0                	mov    %edx,%eax
  803445:	01 c0                	add    %eax,%eax
  803447:	01 d0                	add    %edx,%eax
  803449:	c1 e0 02             	shl    $0x2,%eax
  80344c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803451:	8b 00                	mov    (%eax),%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	74 2b                	je     803482 <initialize_dynamic_allocator+0x116>
  803457:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80345a:	89 d0                	mov    %edx,%eax
  80345c:	01 c0                	add    %eax,%eax
  80345e:	01 d0                	add    %edx,%eax
  803460:	c1 e0 02             	shl    $0x2,%eax
  803463:	05 80 d0 81 00       	add    $0x81d080,%eax
  803468:	8b 10                	mov    (%eax),%edx
  80346a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80346d:	89 c8                	mov    %ecx,%eax
  80346f:	01 c0                	add    %eax,%eax
  803471:	01 c8                	add    %ecx,%eax
  803473:	c1 e0 02             	shl    $0x2,%eax
  803476:	05 84 d0 81 00       	add    $0x81d084,%eax
  80347b:	8b 00                	mov    (%eax),%eax
  80347d:	89 42 04             	mov    %eax,0x4(%edx)
  803480:	eb 18                	jmp    80349a <initialize_dynamic_allocator+0x12e>
  803482:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803485:	89 d0                	mov    %edx,%eax
  803487:	01 c0                	add    %eax,%eax
  803489:	01 d0                	add    %edx,%eax
  80348b:	c1 e0 02             	shl    $0x2,%eax
  80348e:	05 84 d0 81 00       	add    $0x81d084,%eax
  803493:	8b 00                	mov    (%eax),%eax
  803495:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80349a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80349d:	89 d0                	mov    %edx,%eax
  80349f:	01 c0                	add    %eax,%eax
  8034a1:	01 d0                	add    %edx,%eax
  8034a3:	c1 e0 02             	shl    $0x2,%eax
  8034a6:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034ab:	8b 00                	mov    (%eax),%eax
  8034ad:	85 c0                	test   %eax,%eax
  8034af:	74 2a                	je     8034db <initialize_dynamic_allocator+0x16f>
  8034b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b4:	89 d0                	mov    %edx,%eax
  8034b6:	01 c0                	add    %eax,%eax
  8034b8:	01 d0                	add    %edx,%eax
  8034ba:	c1 e0 02             	shl    $0x2,%eax
  8034bd:	05 84 d0 81 00       	add    $0x81d084,%eax
  8034c2:	8b 10                	mov    (%eax),%edx
  8034c4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8034c7:	89 c8                	mov    %ecx,%eax
  8034c9:	01 c0                	add    %eax,%eax
  8034cb:	01 c8                	add    %ecx,%eax
  8034cd:	c1 e0 02             	shl    $0x2,%eax
  8034d0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034d5:	8b 00                	mov    (%eax),%eax
  8034d7:	89 02                	mov    %eax,(%edx)
  8034d9:	eb 18                	jmp    8034f3 <initialize_dynamic_allocator+0x187>
  8034db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034de:	89 d0                	mov    %edx,%eax
  8034e0:	01 c0                	add    %eax,%eax
  8034e2:	01 d0                	add    %edx,%eax
  8034e4:	c1 e0 02             	shl    $0x2,%eax
  8034e7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8034f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f6:	89 d0                	mov    %edx,%eax
  8034f8:	01 c0                	add    %eax,%eax
  8034fa:	01 d0                	add    %edx,%eax
  8034fc:	c1 e0 02             	shl    $0x2,%eax
  8034ff:	05 80 d0 81 00       	add    $0x81d080,%eax
  803504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80350a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80350d:	89 d0                	mov    %edx,%eax
  80350f:	01 c0                	add    %eax,%eax
  803511:	01 d0                	add    %edx,%eax
  803513:	c1 e0 02             	shl    $0x2,%eax
  803516:	05 84 d0 81 00       	add    $0x81d084,%eax
  80351b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803521:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803526:	48                   	dec    %eax
  803527:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80352c:	ff 45 f0             	incl   -0x10(%ebp)
  80352f:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803536:	0f 8e d8 fe ff ff    	jle    803414 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80353c:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803543:	e9 9d 00 00 00       	jmp    8035e5 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803548:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80354e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803551:	89 c8                	mov    %ecx,%eax
  803553:	01 c0                	add    %eax,%eax
  803555:	01 c8                	add    %ecx,%eax
  803557:	c1 e0 02             	shl    $0x2,%eax
  80355a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80355f:	89 10                	mov    %edx,(%eax)
  803561:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803564:	89 d0                	mov    %edx,%eax
  803566:	01 c0                	add    %eax,%eax
  803568:	01 d0                	add    %edx,%eax
  80356a:	c1 e0 02             	shl    $0x2,%eax
  80356d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803572:	8b 00                	mov    (%eax),%eax
  803574:	85 c0                	test   %eax,%eax
  803576:	74 1c                	je     803594 <initialize_dynamic_allocator+0x228>
  803578:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80357e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803581:	89 c8                	mov    %ecx,%eax
  803583:	01 c0                	add    %eax,%eax
  803585:	01 c8                	add    %ecx,%eax
  803587:	c1 e0 02             	shl    $0x2,%eax
  80358a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80358f:	89 42 04             	mov    %eax,0x4(%edx)
  803592:	eb 16                	jmp    8035aa <initialize_dynamic_allocator+0x23e>
  803594:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803597:	89 d0                	mov    %edx,%eax
  803599:	01 c0                	add    %eax,%eax
  80359b:	01 d0                	add    %edx,%eax
  80359d:	c1 e0 02             	shl    $0x2,%eax
  8035a0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035a5:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8035aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035ad:	89 d0                	mov    %edx,%eax
  8035af:	01 c0                	add    %eax,%eax
  8035b1:	01 d0                	add    %edx,%eax
  8035b3:	c1 e0 02             	shl    $0x2,%eax
  8035b6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035bb:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8035c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035c3:	89 d0                	mov    %edx,%eax
  8035c5:	01 c0                	add    %eax,%eax
  8035c7:	01 d0                	add    %edx,%eax
  8035c9:	c1 e0 02             	shl    $0x2,%eax
  8035cc:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d7:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8035dc:	40                   	inc    %eax
  8035dd:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8035e2:	ff 4d ec             	decl   -0x14(%ebp)
  8035e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035e9:	0f 89 59 ff ff ff    	jns    803548 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8035ef:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  8035f6:	00 00 00 
}
  8035f9:	90                   	nop
  8035fa:	c9                   	leave  
  8035fb:	c3                   	ret    

008035fc <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8035fc:	55                   	push   %ebp
  8035fd:	89 e5                	mov    %esp,%ebp
  8035ff:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803602:	8b 45 08             	mov    0x8(%ebp),%eax
  803605:	83 ec 0c             	sub    $0xc,%esp
  803608:	50                   	push   %eax
  803609:	e8 10 fd ff ff       	call   80331e <to_page_info>
  80360e:	83 c4 10             	add    $0x10,%esp
  803611:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803617:	8b 40 08             	mov    0x8(%eax),%eax
  80361a:	0f b7 c0             	movzwl %ax,%eax
}
  80361d:	c9                   	leave  
  80361e:	c3                   	ret    

0080361f <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80361f:	55                   	push   %ebp
  803620:	89 e5                	mov    %esp,%ebp
  803622:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803625:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80362c:	76 16                	jbe    803644 <alloc_block+0x25>
  80362e:	68 bc 47 80 00       	push   $0x8047bc
  803633:	68 a6 47 80 00       	push   $0x8047a6
  803638:	6a 59                	push   $0x59
  80363a:	68 43 47 80 00       	push   $0x804743
  80363f:	e8 a4 cc ff ff       	call   8002e8 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803644:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80364b:	eb 08                	jmp    803655 <alloc_block+0x36>
		allocSize <<= 1;
  80364d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803650:	01 c0                	add    %eax,%eax
  803652:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803658:	3b 45 08             	cmp    0x8(%ebp),%eax
  80365b:	73 09                	jae    803666 <alloc_block+0x47>
  80365d:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803664:	76 e7                	jbe    80364d <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803666:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80366d:	eb 03                	jmp    803672 <alloc_block+0x53>
		listIndex++;
  80366f:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803675:	ba 08 00 00 00       	mov    $0x8,%edx
  80367a:	88 c1                	mov    %al,%cl
  80367c:	d3 e2                	shl    %cl,%edx
  80367e:	89 d0                	mov    %edx,%eax
  803680:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803683:	72 ea                	jb     80366f <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803688:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80368b:	e9 f4 00 00 00       	jmp    803784 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803690:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803693:	c1 e0 04             	shl    $0x4,%eax
  803696:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80369b:	8b 00                	mov    (%eax),%eax
  80369d:	85 c0                	test   %eax,%eax
  80369f:	0f 84 dc 00 00 00    	je     803781 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8036a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a8:	c1 e0 04             	shl    $0x4,%eax
  8036ab:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8036b0:	8b 00                	mov    (%eax),%eax
  8036b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  8036b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036b9:	75 14                	jne    8036cf <alloc_block+0xb0>
  8036bb:	83 ec 04             	sub    $0x4,%esp
  8036be:	68 dd 47 80 00       	push   $0x8047dd
  8036c3:	6a 6b                	push   $0x6b
  8036c5:	68 43 47 80 00       	push   $0x804743
  8036ca:	e8 19 cc ff ff       	call   8002e8 <_panic>
  8036cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d2:	8b 00                	mov    (%eax),%eax
  8036d4:	85 c0                	test   %eax,%eax
  8036d6:	74 10                	je     8036e8 <alloc_block+0xc9>
  8036d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036db:	8b 00                	mov    (%eax),%eax
  8036dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036e0:	8b 52 04             	mov    0x4(%edx),%edx
  8036e3:	89 50 04             	mov    %edx,0x4(%eax)
  8036e6:	eb 14                	jmp    8036fc <alloc_block+0xdd>
  8036e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036eb:	8b 40 04             	mov    0x4(%eax),%eax
  8036ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036f1:	c1 e2 04             	shl    $0x4,%edx
  8036f4:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8036fa:	89 02                	mov    %eax,(%edx)
  8036fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ff:	8b 40 04             	mov    0x4(%eax),%eax
  803702:	85 c0                	test   %eax,%eax
  803704:	74 0f                	je     803715 <alloc_block+0xf6>
  803706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803709:	8b 40 04             	mov    0x4(%eax),%eax
  80370c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80370f:	8b 12                	mov    (%edx),%edx
  803711:	89 10                	mov    %edx,(%eax)
  803713:	eb 13                	jmp    803728 <alloc_block+0x109>
  803715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803718:	8b 00                	mov    (%eax),%eax
  80371a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80371d:	c1 e2 04             	shl    $0x4,%edx
  803720:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803726:	89 02                	mov    %eax,(%edx)
  803728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803734:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80373e:	c1 e0 04             	shl    $0x4,%eax
  803741:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803746:	8b 00                	mov    (%eax),%eax
  803748:	8d 50 ff             	lea    -0x1(%eax),%edx
  80374b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80374e:	c1 e0 04             	shl    $0x4,%eax
  803751:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803756:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375b:	83 ec 0c             	sub    $0xc,%esp
  80375e:	50                   	push   %eax
  80375f:	e8 ba fb ff ff       	call   80331e <to_page_info>
  803764:	83 c4 10             	add    $0x10,%esp
  803767:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  80376a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80376d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803771:	48                   	dec    %eax
  803772:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803775:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377c:	e9 8f 02 00 00       	jmp    803a10 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803781:	ff 45 ec             	incl   -0x14(%ebp)
  803784:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803788:	0f 8e 02 ff ff ff    	jle    803690 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  80378e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803793:	85 c0                	test   %eax,%eax
  803795:	75 14                	jne    8037ab <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803797:	83 ec 04             	sub    $0x4,%esp
  80379a:	68 fc 47 80 00       	push   $0x8047fc
  80379f:	6a 77                	push   $0x77
  8037a1:	68 43 47 80 00       	push   $0x804743
  8037a6:	e8 3d cb ff ff       	call   8002e8 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  8037ab:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8037b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  8037b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037b7:	75 14                	jne    8037cd <alloc_block+0x1ae>
  8037b9:	83 ec 04             	sub    $0x4,%esp
  8037bc:	68 dd 47 80 00       	push   $0x8047dd
  8037c1:	6a 7a                	push   $0x7a
  8037c3:	68 43 47 80 00       	push   $0x804743
  8037c8:	e8 1b cb ff ff       	call   8002e8 <_panic>
  8037cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	85 c0                	test   %eax,%eax
  8037d4:	74 10                	je     8037e6 <alloc_block+0x1c7>
  8037d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037de:	8b 52 04             	mov    0x4(%edx),%edx
  8037e1:	89 50 04             	mov    %edx,0x4(%eax)
  8037e4:	eb 0b                	jmp    8037f1 <alloc_block+0x1d2>
  8037e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ec:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8037f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f4:	8b 40 04             	mov    0x4(%eax),%eax
  8037f7:	85 c0                	test   %eax,%eax
  8037f9:	74 0f                	je     80380a <alloc_block+0x1eb>
  8037fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fe:	8b 40 04             	mov    0x4(%eax),%eax
  803801:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803804:	8b 12                	mov    (%edx),%edx
  803806:	89 10                	mov    %edx,(%eax)
  803808:	eb 0a                	jmp    803814 <alloc_block+0x1f5>
  80380a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80380d:	8b 00                	mov    (%eax),%eax
  80380f:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803814:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803817:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80381d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803820:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803827:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80382c:	48                   	dec    %eax
  80382d:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803832:	83 ec 0c             	sub    $0xc,%esp
  803835:	ff 75 dc             	pushl  -0x24(%ebp)
  803838:	e8 6f fa ff ff       	call   8032ac <to_page_va>
  80383d:	83 c4 10             	add    $0x10,%esp
  803840:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803843:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803846:	83 ec 0c             	sub    $0xc,%esp
  803849:	50                   	push   %eax
  80384a:	e8 a0 dc ff ff       	call   8014ef <get_page>
  80384f:	83 c4 10             	add    $0x10,%esp
  803852:	85 c0                	test   %eax,%eax
  803854:	74 14                	je     80386a <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803856:	83 ec 04             	sub    $0x4,%esp
  803859:	68 24 48 80 00       	push   $0x804824
  80385e:	6a 7f                	push   $0x7f
  803860:	68 43 47 80 00       	push   $0x804743
  803865:	e8 7e ca ff ff       	call   8002e8 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  80386a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803870:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803874:	b8 00 10 00 00       	mov    $0x1000,%eax
  803879:	ba 00 00 00 00       	mov    $0x0,%edx
  80387e:	f7 75 f4             	divl   -0xc(%ebp)
  803881:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803884:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803888:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80388f:	e9 a7 00 00 00       	jmp    80393b <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803894:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803897:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389a:	01 d0                	add    %edx,%eax
  80389c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  80389f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038a3:	75 17                	jne    8038bc <alloc_block+0x29d>
  8038a5:	83 ec 04             	sub    $0x4,%esp
  8038a8:	68 4c 48 80 00       	push   $0x80484c
  8038ad:	68 88 00 00 00       	push   $0x88
  8038b2:	68 43 47 80 00       	push   $0x804743
  8038b7:	e8 2c ca ff ff       	call   8002e8 <_panic>
  8038bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038bf:	c1 e0 04             	shl    $0x4,%eax
  8038c2:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038c7:	8b 10                	mov    (%eax),%edx
  8038c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038cc:	89 10                	mov    %edx,(%eax)
  8038ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038d1:	8b 00                	mov    (%eax),%eax
  8038d3:	85 c0                	test   %eax,%eax
  8038d5:	74 15                	je     8038ec <alloc_block+0x2cd>
  8038d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038da:	c1 e0 04             	shl    $0x4,%eax
  8038dd:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038e2:	8b 00                	mov    (%eax),%eax
  8038e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038e7:	89 50 04             	mov    %edx,0x4(%eax)
  8038ea:	eb 11                	jmp    8038fd <alloc_block+0x2de>
  8038ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ef:	c1 e0 04             	shl    $0x4,%eax
  8038f2:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  8038f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038fb:	89 02                	mov    %eax,(%edx)
  8038fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803900:	c1 e0 04             	shl    $0x4,%eax
  803903:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803909:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80390c:	89 02                	mov    %eax,(%edx)
  80390e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803911:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391b:	c1 e0 04             	shl    $0x4,%eax
  80391e:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803923:	8b 00                	mov    (%eax),%eax
  803925:	8d 50 01             	lea    0x1(%eax),%edx
  803928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392b:	c1 e0 04             	shl    $0x4,%eax
  80392e:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803933:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803938:	01 45 e8             	add    %eax,-0x18(%ebp)
  80393b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803942:	0f 86 4c ff ff ff    	jbe    803894 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803948:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394b:	c1 e0 04             	shl    $0x4,%eax
  80394e:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803953:	8b 00                	mov    (%eax),%eax
  803955:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803958:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80395c:	75 17                	jne    803975 <alloc_block+0x356>
  80395e:	83 ec 04             	sub    $0x4,%esp
  803961:	68 dd 47 80 00       	push   $0x8047dd
  803966:	68 8d 00 00 00       	push   $0x8d
  80396b:	68 43 47 80 00       	push   $0x804743
  803970:	e8 73 c9 ff ff       	call   8002e8 <_panic>
  803975:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803978:	8b 00                	mov    (%eax),%eax
  80397a:	85 c0                	test   %eax,%eax
  80397c:	74 10                	je     80398e <alloc_block+0x36f>
  80397e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803981:	8b 00                	mov    (%eax),%eax
  803983:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803986:	8b 52 04             	mov    0x4(%edx),%edx
  803989:	89 50 04             	mov    %edx,0x4(%eax)
  80398c:	eb 14                	jmp    8039a2 <alloc_block+0x383>
  80398e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803991:	8b 40 04             	mov    0x4(%eax),%eax
  803994:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803997:	c1 e2 04             	shl    $0x4,%edx
  80399a:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8039a0:	89 02                	mov    %eax,(%edx)
  8039a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039a5:	8b 40 04             	mov    0x4(%eax),%eax
  8039a8:	85 c0                	test   %eax,%eax
  8039aa:	74 0f                	je     8039bb <alloc_block+0x39c>
  8039ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039af:	8b 40 04             	mov    0x4(%eax),%eax
  8039b2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8039b5:	8b 12                	mov    (%edx),%edx
  8039b7:	89 10                	mov    %edx,(%eax)
  8039b9:	eb 13                	jmp    8039ce <alloc_block+0x3af>
  8039bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039be:	8b 00                	mov    (%eax),%eax
  8039c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039c3:	c1 e2 04             	shl    $0x4,%edx
  8039c6:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8039cc:	89 02                	mov    %eax,(%edx)
  8039ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e4:	c1 e0 04             	shl    $0x4,%eax
  8039e7:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039ec:	8b 00                	mov    (%eax),%eax
  8039ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f4:	c1 e0 04             	shl    $0x4,%eax
  8039f7:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039fc:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  8039fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a01:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a05:	48                   	dec    %eax
  803a06:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a09:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803a0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803a10:	c9                   	leave  
  803a11:	c3                   	ret    

00803a12 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803a12:	55                   	push   %ebp
  803a13:	89 e5                	mov    %esp,%ebp
  803a15:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803a18:	8b 55 08             	mov    0x8(%ebp),%edx
  803a1b:	a1 84 50 83 00       	mov    0x835084,%eax
  803a20:	39 c2                	cmp    %eax,%edx
  803a22:	72 0c                	jb     803a30 <free_block+0x1e>
  803a24:	8b 55 08             	mov    0x8(%ebp),%edx
  803a27:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803a2c:	39 c2                	cmp    %eax,%edx
  803a2e:	72 19                	jb     803a49 <free_block+0x37>
  803a30:	68 70 48 80 00       	push   $0x804870
  803a35:	68 a6 47 80 00       	push   $0x8047a6
  803a3a:	68 98 00 00 00       	push   $0x98
  803a3f:	68 43 47 80 00       	push   $0x804743
  803a44:	e8 9f c8 ff ff       	call   8002e8 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803a49:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4c:	83 ec 0c             	sub    $0xc,%esp
  803a4f:	50                   	push   %eax
  803a50:	e8 c9 f8 ff ff       	call   80331e <to_page_info>
  803a55:	83 c4 10             	add    $0x10,%esp
  803a58:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a5e:	8b 40 08             	mov    0x8(%eax),%eax
  803a61:	0f b7 c0             	movzwl %ax,%eax
  803a64:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803a67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803a6e:	eb 03                	jmp    803a73 <free_block+0x61>
		listIndex++;
  803a70:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a76:	ba 08 00 00 00       	mov    $0x8,%edx
  803a7b:	88 c1                	mov    %al,%cl
  803a7d:	d3 e2                	shl    %cl,%edx
  803a7f:	89 d0                	mov    %edx,%eax
  803a81:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a84:	72 ea                	jb     803a70 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803a86:	8b 45 08             	mov    0x8(%ebp),%eax
  803a89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803a8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a90:	75 17                	jne    803aa9 <free_block+0x97>
  803a92:	83 ec 04             	sub    $0x4,%esp
  803a95:	68 4c 48 80 00       	push   $0x80484c
  803a9a:	68 a2 00 00 00       	push   $0xa2
  803a9f:	68 43 47 80 00       	push   $0x804743
  803aa4:	e8 3f c8 ff ff       	call   8002e8 <_panic>
  803aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aac:	c1 e0 04             	shl    $0x4,%eax
  803aaf:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ab4:	8b 10                	mov    (%eax),%edx
  803ab6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab9:	89 10                	mov    %edx,(%eax)
  803abb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abe:	8b 00                	mov    (%eax),%eax
  803ac0:	85 c0                	test   %eax,%eax
  803ac2:	74 15                	je     803ad9 <free_block+0xc7>
  803ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac7:	c1 e0 04             	shl    $0x4,%eax
  803aca:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803acf:	8b 00                	mov    (%eax),%eax
  803ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad4:	89 50 04             	mov    %edx,0x4(%eax)
  803ad7:	eb 11                	jmp    803aea <free_block+0xd8>
  803ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adc:	c1 e0 04             	shl    $0x4,%eax
  803adf:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae8:	89 02                	mov    %eax,(%edx)
  803aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aed:	c1 e0 04             	shl    $0x4,%eax
  803af0:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803af6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af9:	89 02                	mov    %eax,(%edx)
  803afb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b08:	c1 e0 04             	shl    $0x4,%eax
  803b0b:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b10:	8b 00                	mov    (%eax),%eax
  803b12:	8d 50 01             	lea    0x1(%eax),%edx
  803b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b18:	c1 e0 04             	shl    $0x4,%eax
  803b1b:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b20:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b25:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b29:	40                   	inc    %eax
  803b2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b2d:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b34:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b38:	0f b7 c8             	movzwl %ax,%ecx
  803b3b:	b8 00 10 00 00       	mov    $0x1000,%eax
  803b40:	ba 00 00 00 00       	mov    $0x0,%edx
  803b45:	f7 75 e8             	divl   -0x18(%ebp)
  803b48:	39 c1                	cmp    %eax,%ecx
  803b4a:	0f 85 ed 01 00 00    	jne    803d3d <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b53:	c1 e0 04             	shl    $0x4,%eax
  803b56:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b5b:	8b 00                	mov    (%eax),%eax
  803b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803b60:	eb 2a                	jmp    803b8c <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b65:	83 ec 0c             	sub    $0xc,%esp
  803b68:	50                   	push   %eax
  803b69:	e8 b0 f7 ff ff       	call   80331e <to_page_info>
  803b6e:	83 c4 10             	add    $0x10,%esp
  803b71:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803b74:	75 06                	jne    803b7c <free_block+0x16a>
				tmp = b;
  803b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b79:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7f:	c1 e0 04             	shl    $0x4,%eax
  803b82:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803b87:	8b 00                	mov    (%eax),%eax
  803b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803b8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b90:	74 07                	je     803b99 <free_block+0x187>
  803b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b95:	8b 00                	mov    (%eax),%eax
  803b97:	eb 05                	jmp    803b9e <free_block+0x18c>
  803b99:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ba1:	c1 e2 04             	shl    $0x4,%edx
  803ba4:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803baa:	89 02                	mov    %eax,(%edx)
  803bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803baf:	c1 e0 04             	shl    $0x4,%eax
  803bb2:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803bb7:	8b 00                	mov    (%eax),%eax
  803bb9:	85 c0                	test   %eax,%eax
  803bbb:	75 a5                	jne    803b62 <free_block+0x150>
  803bbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bc1:	75 9f                	jne    803b62 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc6:	c1 e0 04             	shl    $0x4,%eax
  803bc9:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bce:	8b 00                	mov    (%eax),%eax
  803bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803bd3:	e9 cc 00 00 00       	jmp    803ca4 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bdb:	8b 00                	mov    (%eax),%eax
  803bdd:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803be3:	83 ec 0c             	sub    $0xc,%esp
  803be6:	50                   	push   %eax
  803be7:	e8 32 f7 ff ff       	call   80331e <to_page_info>
  803bec:	83 c4 10             	add    $0x10,%esp
  803bef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803bf2:	0f 85 a6 00 00 00    	jne    803c9e <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803bf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bfc:	75 17                	jne    803c15 <free_block+0x203>
  803bfe:	83 ec 04             	sub    $0x4,%esp
  803c01:	68 dd 47 80 00       	push   $0x8047dd
  803c06:	68 b5 00 00 00       	push   $0xb5
  803c0b:	68 43 47 80 00       	push   $0x804743
  803c10:	e8 d3 c6 ff ff       	call   8002e8 <_panic>
  803c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c18:	8b 00                	mov    (%eax),%eax
  803c1a:	85 c0                	test   %eax,%eax
  803c1c:	74 10                	je     803c2e <free_block+0x21c>
  803c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c21:	8b 00                	mov    (%eax),%eax
  803c23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c26:	8b 52 04             	mov    0x4(%edx),%edx
  803c29:	89 50 04             	mov    %edx,0x4(%eax)
  803c2c:	eb 14                	jmp    803c42 <free_block+0x230>
  803c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c31:	8b 40 04             	mov    0x4(%eax),%eax
  803c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c37:	c1 e2 04             	shl    $0x4,%edx
  803c3a:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803c40:	89 02                	mov    %eax,(%edx)
  803c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c45:	8b 40 04             	mov    0x4(%eax),%eax
  803c48:	85 c0                	test   %eax,%eax
  803c4a:	74 0f                	je     803c5b <free_block+0x249>
  803c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c4f:	8b 40 04             	mov    0x4(%eax),%eax
  803c52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c55:	8b 12                	mov    (%edx),%edx
  803c57:	89 10                	mov    %edx,(%eax)
  803c59:	eb 13                	jmp    803c6e <free_block+0x25c>
  803c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c5e:	8b 00                	mov    (%eax),%eax
  803c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c63:	c1 e2 04             	shl    $0x4,%edx
  803c66:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803c6c:	89 02                	mov    %eax,(%edx)
  803c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c84:	c1 e0 04             	shl    $0x4,%eax
  803c87:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c8c:	8b 00                	mov    (%eax),%eax
  803c8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c94:	c1 e0 04             	shl    $0x4,%eax
  803c97:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c9c:	89 10                	mov    %edx,(%eax)
			b = next;
  803c9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803ca4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ca8:	0f 85 2a ff ff ff    	jne    803bd8 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cb1:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cba:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803cc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cc4:	75 17                	jne    803cdd <free_block+0x2cb>
  803cc6:	83 ec 04             	sub    $0x4,%esp
  803cc9:	68 4c 48 80 00       	push   $0x80484c
  803cce:	68 bc 00 00 00       	push   $0xbc
  803cd3:	68 43 47 80 00       	push   $0x804743
  803cd8:	e8 0b c6 ff ff       	call   8002e8 <_panic>
  803cdd:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ce6:	89 10                	mov    %edx,(%eax)
  803ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ceb:	8b 00                	mov    (%eax),%eax
  803ced:	85 c0                	test   %eax,%eax
  803cef:	74 0d                	je     803cfe <free_block+0x2ec>
  803cf1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803cf6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cf9:	89 50 04             	mov    %edx,0x4(%eax)
  803cfc:	eb 08                	jmp    803d06 <free_block+0x2f4>
  803cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d01:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d09:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d18:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803d1d:	40                   	inc    %eax
  803d1e:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803d23:	83 ec 0c             	sub    $0xc,%esp
  803d26:	ff 75 ec             	pushl  -0x14(%ebp)
  803d29:	e8 7e f5 ff ff       	call   8032ac <to_page_va>
  803d2e:	83 c4 10             	add    $0x10,%esp
  803d31:	83 ec 0c             	sub    $0xc,%esp
  803d34:	50                   	push   %eax
  803d35:	e8 fe d7 ff ff       	call   801538 <return_page>
  803d3a:	83 c4 10             	add    $0x10,%esp
	}
}
  803d3d:	90                   	nop
  803d3e:	c9                   	leave  
  803d3f:	c3                   	ret    

00803d40 <__udivdi3>:
  803d40:	55                   	push   %ebp
  803d41:	57                   	push   %edi
  803d42:	56                   	push   %esi
  803d43:	53                   	push   %ebx
  803d44:	83 ec 1c             	sub    $0x1c,%esp
  803d47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d57:	89 ca                	mov    %ecx,%edx
  803d59:	89 f8                	mov    %edi,%eax
  803d5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d5f:	85 f6                	test   %esi,%esi
  803d61:	75 2d                	jne    803d90 <__udivdi3+0x50>
  803d63:	39 cf                	cmp    %ecx,%edi
  803d65:	77 65                	ja     803dcc <__udivdi3+0x8c>
  803d67:	89 fd                	mov    %edi,%ebp
  803d69:	85 ff                	test   %edi,%edi
  803d6b:	75 0b                	jne    803d78 <__udivdi3+0x38>
  803d6d:	b8 01 00 00 00       	mov    $0x1,%eax
  803d72:	31 d2                	xor    %edx,%edx
  803d74:	f7 f7                	div    %edi
  803d76:	89 c5                	mov    %eax,%ebp
  803d78:	31 d2                	xor    %edx,%edx
  803d7a:	89 c8                	mov    %ecx,%eax
  803d7c:	f7 f5                	div    %ebp
  803d7e:	89 c1                	mov    %eax,%ecx
  803d80:	89 d8                	mov    %ebx,%eax
  803d82:	f7 f5                	div    %ebp
  803d84:	89 cf                	mov    %ecx,%edi
  803d86:	89 fa                	mov    %edi,%edx
  803d88:	83 c4 1c             	add    $0x1c,%esp
  803d8b:	5b                   	pop    %ebx
  803d8c:	5e                   	pop    %esi
  803d8d:	5f                   	pop    %edi
  803d8e:	5d                   	pop    %ebp
  803d8f:	c3                   	ret    
  803d90:	39 ce                	cmp    %ecx,%esi
  803d92:	77 28                	ja     803dbc <__udivdi3+0x7c>
  803d94:	0f bd fe             	bsr    %esi,%edi
  803d97:	83 f7 1f             	xor    $0x1f,%edi
  803d9a:	75 40                	jne    803ddc <__udivdi3+0x9c>
  803d9c:	39 ce                	cmp    %ecx,%esi
  803d9e:	72 0a                	jb     803daa <__udivdi3+0x6a>
  803da0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803da4:	0f 87 9e 00 00 00    	ja     803e48 <__udivdi3+0x108>
  803daa:	b8 01 00 00 00       	mov    $0x1,%eax
  803daf:	89 fa                	mov    %edi,%edx
  803db1:	83 c4 1c             	add    $0x1c,%esp
  803db4:	5b                   	pop    %ebx
  803db5:	5e                   	pop    %esi
  803db6:	5f                   	pop    %edi
  803db7:	5d                   	pop    %ebp
  803db8:	c3                   	ret    
  803db9:	8d 76 00             	lea    0x0(%esi),%esi
  803dbc:	31 ff                	xor    %edi,%edi
  803dbe:	31 c0                	xor    %eax,%eax
  803dc0:	89 fa                	mov    %edi,%edx
  803dc2:	83 c4 1c             	add    $0x1c,%esp
  803dc5:	5b                   	pop    %ebx
  803dc6:	5e                   	pop    %esi
  803dc7:	5f                   	pop    %edi
  803dc8:	5d                   	pop    %ebp
  803dc9:	c3                   	ret    
  803dca:	66 90                	xchg   %ax,%ax
  803dcc:	89 d8                	mov    %ebx,%eax
  803dce:	f7 f7                	div    %edi
  803dd0:	31 ff                	xor    %edi,%edi
  803dd2:	89 fa                	mov    %edi,%edx
  803dd4:	83 c4 1c             	add    $0x1c,%esp
  803dd7:	5b                   	pop    %ebx
  803dd8:	5e                   	pop    %esi
  803dd9:	5f                   	pop    %edi
  803dda:	5d                   	pop    %ebp
  803ddb:	c3                   	ret    
  803ddc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803de1:	89 eb                	mov    %ebp,%ebx
  803de3:	29 fb                	sub    %edi,%ebx
  803de5:	89 f9                	mov    %edi,%ecx
  803de7:	d3 e6                	shl    %cl,%esi
  803de9:	89 c5                	mov    %eax,%ebp
  803deb:	88 d9                	mov    %bl,%cl
  803ded:	d3 ed                	shr    %cl,%ebp
  803def:	89 e9                	mov    %ebp,%ecx
  803df1:	09 f1                	or     %esi,%ecx
  803df3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803df7:	89 f9                	mov    %edi,%ecx
  803df9:	d3 e0                	shl    %cl,%eax
  803dfb:	89 c5                	mov    %eax,%ebp
  803dfd:	89 d6                	mov    %edx,%esi
  803dff:	88 d9                	mov    %bl,%cl
  803e01:	d3 ee                	shr    %cl,%esi
  803e03:	89 f9                	mov    %edi,%ecx
  803e05:	d3 e2                	shl    %cl,%edx
  803e07:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e0b:	88 d9                	mov    %bl,%cl
  803e0d:	d3 e8                	shr    %cl,%eax
  803e0f:	09 c2                	or     %eax,%edx
  803e11:	89 d0                	mov    %edx,%eax
  803e13:	89 f2                	mov    %esi,%edx
  803e15:	f7 74 24 0c          	divl   0xc(%esp)
  803e19:	89 d6                	mov    %edx,%esi
  803e1b:	89 c3                	mov    %eax,%ebx
  803e1d:	f7 e5                	mul    %ebp
  803e1f:	39 d6                	cmp    %edx,%esi
  803e21:	72 19                	jb     803e3c <__udivdi3+0xfc>
  803e23:	74 0b                	je     803e30 <__udivdi3+0xf0>
  803e25:	89 d8                	mov    %ebx,%eax
  803e27:	31 ff                	xor    %edi,%edi
  803e29:	e9 58 ff ff ff       	jmp    803d86 <__udivdi3+0x46>
  803e2e:	66 90                	xchg   %ax,%ax
  803e30:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e34:	89 f9                	mov    %edi,%ecx
  803e36:	d3 e2                	shl    %cl,%edx
  803e38:	39 c2                	cmp    %eax,%edx
  803e3a:	73 e9                	jae    803e25 <__udivdi3+0xe5>
  803e3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e3f:	31 ff                	xor    %edi,%edi
  803e41:	e9 40 ff ff ff       	jmp    803d86 <__udivdi3+0x46>
  803e46:	66 90                	xchg   %ax,%ax
  803e48:	31 c0                	xor    %eax,%eax
  803e4a:	e9 37 ff ff ff       	jmp    803d86 <__udivdi3+0x46>
  803e4f:	90                   	nop

00803e50 <__umoddi3>:
  803e50:	55                   	push   %ebp
  803e51:	57                   	push   %edi
  803e52:	56                   	push   %esi
  803e53:	53                   	push   %ebx
  803e54:	83 ec 1c             	sub    $0x1c,%esp
  803e57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e6f:	89 f3                	mov    %esi,%ebx
  803e71:	89 fa                	mov    %edi,%edx
  803e73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e77:	89 34 24             	mov    %esi,(%esp)
  803e7a:	85 c0                	test   %eax,%eax
  803e7c:	75 1a                	jne    803e98 <__umoddi3+0x48>
  803e7e:	39 f7                	cmp    %esi,%edi
  803e80:	0f 86 a2 00 00 00    	jbe    803f28 <__umoddi3+0xd8>
  803e86:	89 c8                	mov    %ecx,%eax
  803e88:	89 f2                	mov    %esi,%edx
  803e8a:	f7 f7                	div    %edi
  803e8c:	89 d0                	mov    %edx,%eax
  803e8e:	31 d2                	xor    %edx,%edx
  803e90:	83 c4 1c             	add    $0x1c,%esp
  803e93:	5b                   	pop    %ebx
  803e94:	5e                   	pop    %esi
  803e95:	5f                   	pop    %edi
  803e96:	5d                   	pop    %ebp
  803e97:	c3                   	ret    
  803e98:	39 f0                	cmp    %esi,%eax
  803e9a:	0f 87 ac 00 00 00    	ja     803f4c <__umoddi3+0xfc>
  803ea0:	0f bd e8             	bsr    %eax,%ebp
  803ea3:	83 f5 1f             	xor    $0x1f,%ebp
  803ea6:	0f 84 ac 00 00 00    	je     803f58 <__umoddi3+0x108>
  803eac:	bf 20 00 00 00       	mov    $0x20,%edi
  803eb1:	29 ef                	sub    %ebp,%edi
  803eb3:	89 fe                	mov    %edi,%esi
  803eb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803eb9:	89 e9                	mov    %ebp,%ecx
  803ebb:	d3 e0                	shl    %cl,%eax
  803ebd:	89 d7                	mov    %edx,%edi
  803ebf:	89 f1                	mov    %esi,%ecx
  803ec1:	d3 ef                	shr    %cl,%edi
  803ec3:	09 c7                	or     %eax,%edi
  803ec5:	89 e9                	mov    %ebp,%ecx
  803ec7:	d3 e2                	shl    %cl,%edx
  803ec9:	89 14 24             	mov    %edx,(%esp)
  803ecc:	89 d8                	mov    %ebx,%eax
  803ece:	d3 e0                	shl    %cl,%eax
  803ed0:	89 c2                	mov    %eax,%edx
  803ed2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ed6:	d3 e0                	shl    %cl,%eax
  803ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803edc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ee0:	89 f1                	mov    %esi,%ecx
  803ee2:	d3 e8                	shr    %cl,%eax
  803ee4:	09 d0                	or     %edx,%eax
  803ee6:	d3 eb                	shr    %cl,%ebx
  803ee8:	89 da                	mov    %ebx,%edx
  803eea:	f7 f7                	div    %edi
  803eec:	89 d3                	mov    %edx,%ebx
  803eee:	f7 24 24             	mull   (%esp)
  803ef1:	89 c6                	mov    %eax,%esi
  803ef3:	89 d1                	mov    %edx,%ecx
  803ef5:	39 d3                	cmp    %edx,%ebx
  803ef7:	0f 82 87 00 00 00    	jb     803f84 <__umoddi3+0x134>
  803efd:	0f 84 91 00 00 00    	je     803f94 <__umoddi3+0x144>
  803f03:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f07:	29 f2                	sub    %esi,%edx
  803f09:	19 cb                	sbb    %ecx,%ebx
  803f0b:	89 d8                	mov    %ebx,%eax
  803f0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f11:	d3 e0                	shl    %cl,%eax
  803f13:	89 e9                	mov    %ebp,%ecx
  803f15:	d3 ea                	shr    %cl,%edx
  803f17:	09 d0                	or     %edx,%eax
  803f19:	89 e9                	mov    %ebp,%ecx
  803f1b:	d3 eb                	shr    %cl,%ebx
  803f1d:	89 da                	mov    %ebx,%edx
  803f1f:	83 c4 1c             	add    $0x1c,%esp
  803f22:	5b                   	pop    %ebx
  803f23:	5e                   	pop    %esi
  803f24:	5f                   	pop    %edi
  803f25:	5d                   	pop    %ebp
  803f26:	c3                   	ret    
  803f27:	90                   	nop
  803f28:	89 fd                	mov    %edi,%ebp
  803f2a:	85 ff                	test   %edi,%edi
  803f2c:	75 0b                	jne    803f39 <__umoddi3+0xe9>
  803f2e:	b8 01 00 00 00       	mov    $0x1,%eax
  803f33:	31 d2                	xor    %edx,%edx
  803f35:	f7 f7                	div    %edi
  803f37:	89 c5                	mov    %eax,%ebp
  803f39:	89 f0                	mov    %esi,%eax
  803f3b:	31 d2                	xor    %edx,%edx
  803f3d:	f7 f5                	div    %ebp
  803f3f:	89 c8                	mov    %ecx,%eax
  803f41:	f7 f5                	div    %ebp
  803f43:	89 d0                	mov    %edx,%eax
  803f45:	e9 44 ff ff ff       	jmp    803e8e <__umoddi3+0x3e>
  803f4a:	66 90                	xchg   %ax,%ax
  803f4c:	89 c8                	mov    %ecx,%eax
  803f4e:	89 f2                	mov    %esi,%edx
  803f50:	83 c4 1c             	add    $0x1c,%esp
  803f53:	5b                   	pop    %ebx
  803f54:	5e                   	pop    %esi
  803f55:	5f                   	pop    %edi
  803f56:	5d                   	pop    %ebp
  803f57:	c3                   	ret    
  803f58:	3b 04 24             	cmp    (%esp),%eax
  803f5b:	72 06                	jb     803f63 <__umoddi3+0x113>
  803f5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f61:	77 0f                	ja     803f72 <__umoddi3+0x122>
  803f63:	89 f2                	mov    %esi,%edx
  803f65:	29 f9                	sub    %edi,%ecx
  803f67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f6b:	89 14 24             	mov    %edx,(%esp)
  803f6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f72:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f76:	8b 14 24             	mov    (%esp),%edx
  803f79:	83 c4 1c             	add    $0x1c,%esp
  803f7c:	5b                   	pop    %ebx
  803f7d:	5e                   	pop    %esi
  803f7e:	5f                   	pop    %edi
  803f7f:	5d                   	pop    %ebp
  803f80:	c3                   	ret    
  803f81:	8d 76 00             	lea    0x0(%esi),%esi
  803f84:	2b 04 24             	sub    (%esp),%eax
  803f87:	19 fa                	sbb    %edi,%edx
  803f89:	89 d1                	mov    %edx,%ecx
  803f8b:	89 c6                	mov    %eax,%esi
  803f8d:	e9 71 ff ff ff       	jmp    803f03 <__umoddi3+0xb3>
  803f92:	66 90                	xchg   %ax,%ax
  803f94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f98:	72 ea                	jb     803f84 <__umoddi3+0x134>
  803f9a:	89 d9                	mov    %ebx,%ecx
  803f9c:	e9 62 ff ff ff       	jmp    803f03 <__umoddi3+0xb3>
