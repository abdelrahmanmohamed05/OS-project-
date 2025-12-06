
obj/user/fos_alloc:     file format elf32-i386


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


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 3a 13 00 00       	call   80138a <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 c0 3f 80 00       	push   $0x803fc0
  800061:	e8 d4 03 00 00       	call   80043a <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 d3 3f 80 00       	push   $0x803fd3
  8000be:	e8 77 03 00 00       	call   80043a <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 0e 16 00 00       	call   8016ea <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 a0 12 00 00       	call   80138a <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 d3 3f 80 00       	push   $0x803fd3
  800114:	e8 21 03 00 00       	call   80043a <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 b8 15 00 00       	call   8016ea <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
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
  800141:	e8 b5 2c 00 00       	call   802dfb <sys_getenvindex>
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
  8001bb:	bb d8 40 80 00       	mov    $0x8040d8,%ebx
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
  8001f0:	e8 3c 2e 00 00       	call   803031 <sys_utilities>
  8001f5:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f8:	e8 85 29 00 00       	call   802b82 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	68 f8 3f 80 00       	push   $0x803ff8
  800205:	e8 be 01 00 00       	call   8003c8 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80020d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800210:	85 c0                	test   %eax,%eax
  800212:	74 18                	je     80022c <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800214:	e8 36 2e 00 00       	call   80304f <sys_get_optimal_num_faults>
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	50                   	push   %eax
  80021d:	68 20 40 80 00       	push   $0x804020
  800222:	e8 a1 01 00 00       	call   8003c8 <cprintf>
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
  800247:	68 44 40 80 00       	push   $0x804044
  80024c:	e8 77 01 00 00       	call   8003c8 <cprintf>
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
  800278:	68 6c 40 80 00       	push   $0x80406c
  80027d:	e8 46 01 00 00       	call   8003c8 <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800285:	a1 20 50 80 00       	mov    0x805020,%eax
  80028a:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	50                   	push   %eax
  800294:	68 c4 40 80 00       	push   $0x8040c4
  800299:	e8 2a 01 00 00       	call   8003c8 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 f8 3f 80 00       	push   $0x803ff8
  8002a9:	e8 1a 01 00 00       	call   8003c8 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002b1:	e8 e6 28 00 00       	call   802b9c <sys_unlock_cons>
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
  8002cf:	e8 f3 2a 00 00       	call   802dc7 <sys_destroy_env>
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
  8002e0:	e8 48 2b 00 00       	call   802e2d <sys_exit_env>
}
  8002e5:	90                   	nop
  8002e6:	c9                   	leave  
  8002e7:	c3                   	ret    

008002e8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	53                   	push   %ebx
  8002ec:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f2:	8b 00                	mov    (%eax),%eax
  8002f4:	8d 48 01             	lea    0x1(%eax),%ecx
  8002f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002fa:	89 0a                	mov    %ecx,(%edx)
  8002fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ff:	88 d1                	mov    %dl,%cl
  800301:	8b 55 0c             	mov    0xc(%ebp),%edx
  800304:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	8b 00                	mov    (%eax),%eax
  80030d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800312:	75 30                	jne    800344 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800314:	8b 15 38 51 83 00    	mov    0x835138,%edx
  80031a:	a0 64 d0 81 00       	mov    0x81d064,%al
  80031f:	0f b6 c0             	movzbl %al,%eax
  800322:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800325:	8b 09                	mov    (%ecx),%ecx
  800327:	89 cb                	mov    %ecx,%ebx
  800329:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032c:	83 c1 08             	add    $0x8,%ecx
  80032f:	52                   	push   %edx
  800330:	50                   	push   %eax
  800331:	53                   	push   %ebx
  800332:	51                   	push   %ecx
  800333:	e8 06 28 00 00       	call   802b3e <sys_cputs>
  800338:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80033b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800344:	8b 45 0c             	mov    0xc(%ebp),%eax
  800347:	8b 40 04             	mov    0x4(%eax),%eax
  80034a:	8d 50 01             	lea    0x1(%eax),%edx
  80034d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800350:	89 50 04             	mov    %edx,0x4(%eax)
}
  800353:	90                   	nop
  800354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800362:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800369:	00 00 00 
	b.cnt = 0;
  80036c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800373:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800376:	ff 75 0c             	pushl  0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800382:	50                   	push   %eax
  800383:	68 e8 02 80 00       	push   $0x8002e8
  800388:	e8 5a 02 00 00       	call   8005e7 <vprintfmt>
  80038d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800390:	8b 15 38 51 83 00    	mov    0x835138,%edx
  800396:	a0 64 d0 81 00       	mov    0x81d064,%al
  80039b:	0f b6 c0             	movzbl %al,%eax
  80039e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003a4:	52                   	push   %edx
  8003a5:	50                   	push   %eax
  8003a6:	51                   	push   %ecx
  8003a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ad:	83 c0 08             	add    $0x8,%eax
  8003b0:	50                   	push   %eax
  8003b1:	e8 88 27 00 00       	call   802b3e <sys_cputs>
  8003b6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003b9:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  8003c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003c6:	c9                   	leave  
  8003c7:	c3                   	ret    

008003c8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003ce:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  8003d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003db:	8b 45 08             	mov    0x8(%ebp),%eax
  8003de:	83 ec 08             	sub    $0x8,%esp
  8003e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e4:	50                   	push   %eax
  8003e5:	e8 6f ff ff ff       	call   800359 <vcprintf>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f3:	c9                   	leave  
  8003f4:	c3                   	ret    

008003f5 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
  8003f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003fb:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800402:	8b 45 08             	mov    0x8(%ebp),%eax
  800405:	c1 e0 08             	shl    $0x8,%eax
  800408:	a3 38 51 83 00       	mov    %eax,0x835138
	va_start(ap, fmt);
  80040d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800410:	83 c0 04             	add    $0x4,%eax
  800413:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800416:	8b 45 0c             	mov    0xc(%ebp),%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	ff 75 f4             	pushl  -0xc(%ebp)
  80041f:	50                   	push   %eax
  800420:	e8 34 ff ff ff       	call   800359 <vcprintf>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80042b:	c7 05 38 51 83 00 00 	movl   $0x700,0x835138
  800432:	07 00 00 

	return cnt;
  800435:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800440:	e8 3d 27 00 00       	call   802b82 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800445:	8d 45 0c             	lea    0xc(%ebp),%eax
  800448:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	83 ec 08             	sub    $0x8,%esp
  800451:	ff 75 f4             	pushl  -0xc(%ebp)
  800454:	50                   	push   %eax
  800455:	e8 ff fe ff ff       	call   800359 <vcprintf>
  80045a:	83 c4 10             	add    $0x10,%esp
  80045d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800460:	e8 37 27 00 00       	call   802b9c <sys_unlock_cons>
	return cnt;
  800465:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800468:	c9                   	leave  
  800469:	c3                   	ret    

0080046a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046a:	55                   	push   %ebp
  80046b:	89 e5                	mov    %esp,%ebp
  80046d:	53                   	push   %ebx
  80046e:	83 ec 14             	sub    $0x14,%esp
  800471:	8b 45 10             	mov    0x10(%ebp),%eax
  800474:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800477:	8b 45 14             	mov    0x14(%ebp),%eax
  80047a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80047d:	8b 45 18             	mov    0x18(%ebp),%eax
  800480:	ba 00 00 00 00       	mov    $0x0,%edx
  800485:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800488:	77 55                	ja     8004df <printnum+0x75>
  80048a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80048d:	72 05                	jb     800494 <printnum+0x2a>
  80048f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800492:	77 4b                	ja     8004df <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800494:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800497:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80049a:	8b 45 18             	mov    0x18(%ebp),%eax
  80049d:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a2:	52                   	push   %edx
  8004a3:	50                   	push   %eax
  8004a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8004aa:	e8 91 38 00 00       	call   803d40 <__udivdi3>
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	ff 75 20             	pushl  0x20(%ebp)
  8004b8:	53                   	push   %ebx
  8004b9:	ff 75 18             	pushl  0x18(%ebp)
  8004bc:	52                   	push   %edx
  8004bd:	50                   	push   %eax
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	ff 75 08             	pushl  0x8(%ebp)
  8004c4:	e8 a1 ff ff ff       	call   80046a <printnum>
  8004c9:	83 c4 20             	add    $0x20,%esp
  8004cc:	eb 1a                	jmp    8004e8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	ff 75 0c             	pushl  0xc(%ebp)
  8004d4:	ff 75 20             	pushl  0x20(%ebp)
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	ff d0                	call   *%eax
  8004dc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004df:	ff 4d 1c             	decl   0x1c(%ebp)
  8004e2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004e6:	7f e6                	jg     8004ce <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004e8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004f6:	53                   	push   %ebx
  8004f7:	51                   	push   %ecx
  8004f8:	52                   	push   %edx
  8004f9:	50                   	push   %eax
  8004fa:	e8 51 39 00 00       	call   803e50 <__umoddi3>
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	05 54 43 80 00       	add    $0x804354,%eax
  800507:	8a 00                	mov    (%eax),%al
  800509:	0f be c0             	movsbl %al,%eax
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	ff 75 0c             	pushl  0xc(%ebp)
  800512:	50                   	push   %eax
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	ff d0                	call   *%eax
  800518:	83 c4 10             	add    $0x10,%esp
}
  80051b:	90                   	nop
  80051c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80051f:	c9                   	leave  
  800520:	c3                   	ret    

00800521 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800524:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800528:	7e 1c                	jle    800546 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	8d 50 08             	lea    0x8(%eax),%edx
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	89 10                	mov    %edx,(%eax)
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	83 e8 08             	sub    $0x8,%eax
  80053f:	8b 50 04             	mov    0x4(%eax),%edx
  800542:	8b 00                	mov    (%eax),%eax
  800544:	eb 40                	jmp    800586 <getuint+0x65>
	else if (lflag)
  800546:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80054a:	74 1e                	je     80056a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	8d 50 04             	lea    0x4(%eax),%edx
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	89 10                	mov    %edx,(%eax)
  800559:	8b 45 08             	mov    0x8(%ebp),%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	83 e8 04             	sub    $0x4,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	ba 00 00 00 00       	mov    $0x0,%edx
  800568:	eb 1c                	jmp    800586 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	8d 50 04             	lea    0x4(%eax),%edx
  800572:	8b 45 08             	mov    0x8(%ebp),%eax
  800575:	89 10                	mov    %edx,(%eax)
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	83 e8 04             	sub    $0x4,%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800586:	5d                   	pop    %ebp
  800587:	c3                   	ret    

00800588 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80058b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80058f:	7e 1c                	jle    8005ad <getint+0x25>
		return va_arg(*ap, long long);
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	8b 00                	mov    (%eax),%eax
  800596:	8d 50 08             	lea    0x8(%eax),%edx
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	89 10                	mov    %edx,(%eax)
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	83 e8 08             	sub    $0x8,%eax
  8005a6:	8b 50 04             	mov    0x4(%eax),%edx
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	eb 38                	jmp    8005e5 <getint+0x5d>
	else if (lflag)
  8005ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005b1:	74 1a                	je     8005cd <getint+0x45>
		return va_arg(*ap, long);
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	8d 50 04             	lea    0x4(%eax),%edx
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	89 10                	mov    %edx,(%eax)
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	83 e8 04             	sub    $0x4,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	99                   	cltd   
  8005cb:	eb 18                	jmp    8005e5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	8d 50 04             	lea    0x4(%eax),%edx
  8005d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d8:	89 10                	mov    %edx,(%eax)
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	83 e8 04             	sub    $0x4,%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	99                   	cltd   
}
  8005e5:	5d                   	pop    %ebp
  8005e6:	c3                   	ret    

008005e7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005e7:	55                   	push   %ebp
  8005e8:	89 e5                	mov    %esp,%ebp
  8005ea:	56                   	push   %esi
  8005eb:	53                   	push   %ebx
  8005ec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005ef:	eb 17                	jmp    800608 <vprintfmt+0x21>
			if (ch == '\0')
  8005f1:	85 db                	test   %ebx,%ebx
  8005f3:	0f 84 c1 03 00 00    	je     8009ba <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 0c             	pushl  0xc(%ebp)
  8005ff:	53                   	push   %ebx
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800608:	8b 45 10             	mov    0x10(%ebp),%eax
  80060b:	8d 50 01             	lea    0x1(%eax),%edx
  80060e:	89 55 10             	mov    %edx,0x10(%ebp)
  800611:	8a 00                	mov    (%eax),%al
  800613:	0f b6 d8             	movzbl %al,%ebx
  800616:	83 fb 25             	cmp    $0x25,%ebx
  800619:	75 d6                	jne    8005f1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80061b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80061f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800626:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80062d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800634:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063b:	8b 45 10             	mov    0x10(%ebp),%eax
  80063e:	8d 50 01             	lea    0x1(%eax),%edx
  800641:	89 55 10             	mov    %edx,0x10(%ebp)
  800644:	8a 00                	mov    (%eax),%al
  800646:	0f b6 d8             	movzbl %al,%ebx
  800649:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80064c:	83 f8 5b             	cmp    $0x5b,%eax
  80064f:	0f 87 3d 03 00 00    	ja     800992 <vprintfmt+0x3ab>
  800655:	8b 04 85 78 43 80 00 	mov    0x804378(,%eax,4),%eax
  80065c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80065e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800662:	eb d7                	jmp    80063b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800664:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800668:	eb d1                	jmp    80063b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80066a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800671:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800674:	89 d0                	mov    %edx,%eax
  800676:	c1 e0 02             	shl    $0x2,%eax
  800679:	01 d0                	add    %edx,%eax
  80067b:	01 c0                	add    %eax,%eax
  80067d:	01 d8                	add    %ebx,%eax
  80067f:	83 e8 30             	sub    $0x30,%eax
  800682:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800685:	8b 45 10             	mov    0x10(%ebp),%eax
  800688:	8a 00                	mov    (%eax),%al
  80068a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80068d:	83 fb 2f             	cmp    $0x2f,%ebx
  800690:	7e 3e                	jle    8006d0 <vprintfmt+0xe9>
  800692:	83 fb 39             	cmp    $0x39,%ebx
  800695:	7f 39                	jg     8006d0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800697:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80069a:	eb d5                	jmp    800671 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	83 c0 04             	add    $0x4,%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	83 e8 04             	sub    $0x4,%eax
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006b0:	eb 1f                	jmp    8006d1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b6:	79 83                	jns    80063b <vprintfmt+0x54>
				width = 0;
  8006b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006bf:	e9 77 ff ff ff       	jmp    80063b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006c4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006cb:	e9 6b ff ff ff       	jmp    80063b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006d0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d5:	0f 89 60 ff ff ff    	jns    80063b <vprintfmt+0x54>
				width = precision, precision = -1;
  8006db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006e8:	e9 4e ff ff ff       	jmp    80063b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ed:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006f0:	e9 46 ff ff ff       	jmp    80063b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	83 c0 04             	add    $0x4,%eax
  8006fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	83 e8 04             	sub    $0x4,%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 0c             	pushl  0xc(%ebp)
  80070c:	50                   	push   %eax
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	ff d0                	call   *%eax
  800712:	83 c4 10             	add    $0x10,%esp
			break;
  800715:	e9 9b 02 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	83 c0 04             	add    $0x4,%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	83 e8 04             	sub    $0x4,%eax
  800729:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80072b:	85 db                	test   %ebx,%ebx
  80072d:	79 02                	jns    800731 <vprintfmt+0x14a>
				err = -err;
  80072f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800731:	83 fb 64             	cmp    $0x64,%ebx
  800734:	7f 0b                	jg     800741 <vprintfmt+0x15a>
  800736:	8b 34 9d c0 41 80 00 	mov    0x8041c0(,%ebx,4),%esi
  80073d:	85 f6                	test   %esi,%esi
  80073f:	75 19                	jne    80075a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800741:	53                   	push   %ebx
  800742:	68 65 43 80 00       	push   $0x804365
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 08             	pushl  0x8(%ebp)
  80074d:	e8 70 02 00 00       	call   8009c2 <printfmt>
  800752:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800755:	e9 5b 02 00 00       	jmp    8009b5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80075a:	56                   	push   %esi
  80075b:	68 6e 43 80 00       	push   $0x80436e
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	ff 75 08             	pushl  0x8(%ebp)
  800766:	e8 57 02 00 00       	call   8009c2 <printfmt>
  80076b:	83 c4 10             	add    $0x10,%esp
			break;
  80076e:	e9 42 02 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	83 c0 04             	add    $0x4,%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	83 e8 04             	sub    $0x4,%eax
  800782:	8b 30                	mov    (%eax),%esi
  800784:	85 f6                	test   %esi,%esi
  800786:	75 05                	jne    80078d <vprintfmt+0x1a6>
				p = "(null)";
  800788:	be 71 43 80 00       	mov    $0x804371,%esi
			if (width > 0 && padc != '-')
  80078d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800791:	7e 6d                	jle    800800 <vprintfmt+0x219>
  800793:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800797:	74 67                	je     800800 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	50                   	push   %eax
  8007a0:	56                   	push   %esi
  8007a1:	e8 1e 03 00 00       	call   800ac4 <strnlen>
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007ac:	eb 16                	jmp    8007c4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007ae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	50                   	push   %eax
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	ff d0                	call   *%eax
  8007be:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c8:	7f e4                	jg     8007ae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ca:	eb 34                	jmp    800800 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007d0:	74 1c                	je     8007ee <vprintfmt+0x207>
  8007d2:	83 fb 1f             	cmp    $0x1f,%ebx
  8007d5:	7e 05                	jle    8007dc <vprintfmt+0x1f5>
  8007d7:	83 fb 7e             	cmp    $0x7e,%ebx
  8007da:	7e 12                	jle    8007ee <vprintfmt+0x207>
					putch('?', putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 0c             	pushl  0xc(%ebp)
  8007e2:	6a 3f                	push   $0x3f
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	ff d0                	call   *%eax
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	eb 0f                	jmp    8007fd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	53                   	push   %ebx
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007fd:	ff 4d e4             	decl   -0x1c(%ebp)
  800800:	89 f0                	mov    %esi,%eax
  800802:	8d 70 01             	lea    0x1(%eax),%esi
  800805:	8a 00                	mov    (%eax),%al
  800807:	0f be d8             	movsbl %al,%ebx
  80080a:	85 db                	test   %ebx,%ebx
  80080c:	74 24                	je     800832 <vprintfmt+0x24b>
  80080e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800812:	78 b8                	js     8007cc <vprintfmt+0x1e5>
  800814:	ff 4d e0             	decl   -0x20(%ebp)
  800817:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80081b:	79 af                	jns    8007cc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80081d:	eb 13                	jmp    800832 <vprintfmt+0x24b>
				putch(' ', putdat);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	6a 20                	push   $0x20
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	ff d0                	call   *%eax
  80082c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80082f:	ff 4d e4             	decl   -0x1c(%ebp)
  800832:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800836:	7f e7                	jg     80081f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800838:	e9 78 01 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 e8             	pushl  -0x18(%ebp)
  800843:	8d 45 14             	lea    0x14(%ebp),%eax
  800846:	50                   	push   %eax
  800847:	e8 3c fd ff ff       	call   800588 <getint>
  80084c:	83 c4 10             	add    $0x10,%esp
  80084f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800852:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800858:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085b:	85 d2                	test   %edx,%edx
  80085d:	79 23                	jns    800882 <vprintfmt+0x29b>
				putch('-', putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	6a 2d                	push   $0x2d
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	ff d0                	call   *%eax
  80086c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80086f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800875:	f7 d8                	neg    %eax
  800877:	83 d2 00             	adc    $0x0,%edx
  80087a:	f7 da                	neg    %edx
  80087c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800882:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800889:	e9 bc 00 00 00       	jmp    80094a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80088e:	83 ec 08             	sub    $0x8,%esp
  800891:	ff 75 e8             	pushl  -0x18(%ebp)
  800894:	8d 45 14             	lea    0x14(%ebp),%eax
  800897:	50                   	push   %eax
  800898:	e8 84 fc ff ff       	call   800521 <getuint>
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ad:	e9 98 00 00 00       	jmp    80094a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	6a 58                	push   $0x58
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	6a 58                	push   $0x58
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	ff d0                	call   *%eax
  8008cf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	6a 58                	push   $0x58
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
			break;
  8008e2:	e9 ce 00 00 00       	jmp    8009b5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	6a 30                	push   $0x30
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	ff d0                	call   *%eax
  8008f4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	6a 78                	push   $0x78
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	ff d0                	call   *%eax
  800904:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	83 c0 04             	add    $0x4,%eax
  80090d:	89 45 14             	mov    %eax,0x14(%ebp)
  800910:	8b 45 14             	mov    0x14(%ebp),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800918:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80091b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800922:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800929:	eb 1f                	jmp    80094a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 e8             	pushl  -0x18(%ebp)
  800931:	8d 45 14             	lea    0x14(%ebp),%eax
  800934:	50                   	push   %eax
  800935:	e8 e7 fb ff ff       	call   800521 <getuint>
  80093a:	83 c4 10             	add    $0x10,%esp
  80093d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800940:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800943:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80094a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80094e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800951:	83 ec 04             	sub    $0x4,%esp
  800954:	52                   	push   %edx
  800955:	ff 75 e4             	pushl  -0x1c(%ebp)
  800958:	50                   	push   %eax
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	ff 75 f0             	pushl  -0x10(%ebp)
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	ff 75 08             	pushl  0x8(%ebp)
  800965:	e8 00 fb ff ff       	call   80046a <printnum>
  80096a:	83 c4 20             	add    $0x20,%esp
			break;
  80096d:	eb 46                	jmp    8009b5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	ff d0                	call   *%eax
  80097b:	83 c4 10             	add    $0x10,%esp
			break;
  80097e:	eb 35                	jmp    8009b5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800980:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800987:	eb 2c                	jmp    8009b5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800989:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800990:	eb 23                	jmp    8009b5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	6a 25                	push   $0x25
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	ff d0                	call   *%eax
  80099f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a2:	ff 4d 10             	decl   0x10(%ebp)
  8009a5:	eb 03                	jmp    8009aa <vprintfmt+0x3c3>
  8009a7:	ff 4d 10             	decl   0x10(%ebp)
  8009aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ad:	48                   	dec    %eax
  8009ae:	8a 00                	mov    (%eax),%al
  8009b0:	3c 25                	cmp    $0x25,%al
  8009b2:	75 f3                	jne    8009a7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009b4:	90                   	nop
		}
	}
  8009b5:	e9 35 fc ff ff       	jmp    8005ef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009ba:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009be:	5b                   	pop    %ebx
  8009bf:	5e                   	pop    %esi
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009c8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009cb:	83 c0 04             	add    $0x4,%eax
  8009ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d7:	50                   	push   %eax
  8009d8:	ff 75 0c             	pushl  0xc(%ebp)
  8009db:	ff 75 08             	pushl  0x8(%ebp)
  8009de:	e8 04 fc ff ff       	call   8005e7 <vprintfmt>
  8009e3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009e6:	90                   	nop
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    

008009e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ef:	8b 40 08             	mov    0x8(%eax),%eax
  8009f2:	8d 50 01             	lea    0x1(%eax),%edx
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fe:	8b 10                	mov    (%eax),%edx
  800a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a03:	8b 40 04             	mov    0x4(%eax),%eax
  800a06:	39 c2                	cmp    %eax,%edx
  800a08:	73 12                	jae    800a1c <sprintputch+0x33>
		*b->buf++ = ch;
  800a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	8d 48 01             	lea    0x1(%eax),%ecx
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a15:	89 0a                	mov    %ecx,(%edx)
  800a17:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1a:	88 10                	mov    %dl,(%eax)
}
  800a1c:	90                   	nop
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	01 d0                	add    %edx,%eax
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a44:	74 06                	je     800a4c <vsnprintf+0x2d>
  800a46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a4a:	7f 07                	jg     800a53 <vsnprintf+0x34>
		return -E_INVAL;
  800a4c:	b8 03 00 00 00       	mov    $0x3,%eax
  800a51:	eb 20                	jmp    800a73 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a53:	ff 75 14             	pushl  0x14(%ebp)
  800a56:	ff 75 10             	pushl  0x10(%ebp)
  800a59:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a5c:	50                   	push   %eax
  800a5d:	68 e9 09 80 00       	push   $0x8009e9
  800a62:	e8 80 fb ff ff       	call   8005e7 <vprintfmt>
  800a67:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a73:	c9                   	leave  
  800a74:	c3                   	ret    

00800a75 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800a7e:	83 c0 04             	add    $0x4,%eax
  800a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a84:	8b 45 10             	mov    0x10(%ebp),%eax
  800a87:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 89 ff ff ff       	call   800a1f <vsnprintf>
  800a96:	83 c4 10             	add    $0x10,%esp
  800a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9f:	c9                   	leave  
  800aa0:	c3                   	ret    

00800aa1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aae:	eb 06                	jmp    800ab6 <strlen+0x15>
		n++;
  800ab0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab3:	ff 45 08             	incl   0x8(%ebp)
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8a 00                	mov    (%eax),%al
  800abb:	84 c0                	test   %al,%al
  800abd:	75 f1                	jne    800ab0 <strlen+0xf>
		n++;
	return n;
  800abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ad1:	eb 09                	jmp    800adc <strnlen+0x18>
		n++;
  800ad3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ad6:	ff 45 08             	incl   0x8(%ebp)
  800ad9:	ff 4d 0c             	decl   0xc(%ebp)
  800adc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae0:	74 09                	je     800aeb <strnlen+0x27>
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8a 00                	mov    (%eax),%al
  800ae7:	84 c0                	test   %al,%al
  800ae9:	75 e8                	jne    800ad3 <strnlen+0xf>
		n++;
	return n;
  800aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800afc:	90                   	nop
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8d 50 01             	lea    0x1(%eax),%edx
  800b03:	89 55 08             	mov    %edx,0x8(%ebp)
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b0c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b0f:	8a 12                	mov    (%edx),%dl
  800b11:	88 10                	mov    %dl,(%eax)
  800b13:	8a 00                	mov    (%eax),%al
  800b15:	84 c0                	test   %al,%al
  800b17:	75 e4                	jne    800afd <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b31:	eb 1f                	jmp    800b52 <strncpy+0x34>
		*dst++ = *src;
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8d 50 01             	lea    0x1(%eax),%edx
  800b39:	89 55 08             	mov    %edx,0x8(%ebp)
  800b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3f:	8a 12                	mov    (%edx),%dl
  800b41:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8a 00                	mov    (%eax),%al
  800b48:	84 c0                	test   %al,%al
  800b4a:	74 03                	je     800b4f <strncpy+0x31>
			src++;
  800b4c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b4f:	ff 45 fc             	incl   -0x4(%ebp)
  800b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b55:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b58:	72 d9                	jb     800b33 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b6f:	74 30                	je     800ba1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b71:	eb 16                	jmp    800b89 <strlcpy+0x2a>
			*dst++ = *src++;
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8d 50 01             	lea    0x1(%eax),%edx
  800b79:	89 55 08             	mov    %edx,0x8(%ebp)
  800b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b82:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b85:	8a 12                	mov    (%edx),%dl
  800b87:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b89:	ff 4d 10             	decl   0x10(%ebp)
  800b8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b90:	74 09                	je     800b9b <strlcpy+0x3c>
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	8a 00                	mov    (%eax),%al
  800b97:	84 c0                	test   %al,%al
  800b99:	75 d8                	jne    800b73 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba7:	29 c2                	sub    %eax,%edx
  800ba9:	89 d0                	mov    %edx,%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bb0:	eb 06                	jmp    800bb8 <strcmp+0xb>
		p++, q++;
  800bb2:	ff 45 08             	incl   0x8(%ebp)
  800bb5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	84 c0                	test   %al,%al
  800bbf:	74 0e                	je     800bcf <strcmp+0x22>
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8a 10                	mov    (%eax),%dl
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	8a 00                	mov    (%eax),%al
  800bcb:	38 c2                	cmp    %al,%dl
  800bcd:	74 e3                	je     800bb2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8a 00                	mov    (%eax),%al
  800bd4:	0f b6 d0             	movzbl %al,%edx
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	8a 00                	mov    (%eax),%al
  800bdc:	0f b6 c0             	movzbl %al,%eax
  800bdf:	29 c2                	sub    %eax,%edx
  800be1:	89 d0                	mov    %edx,%eax
}
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800be8:	eb 09                	jmp    800bf3 <strncmp+0xe>
		n--, p++, q++;
  800bea:	ff 4d 10             	decl   0x10(%ebp)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800bf3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bf7:	74 17                	je     800c10 <strncmp+0x2b>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	74 0e                	je     800c10 <strncmp+0x2b>
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8a 10                	mov    (%eax),%dl
  800c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	38 c2                	cmp    %al,%dl
  800c0e:	74 da                	je     800bea <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c14:	75 07                	jne    800c1d <strncmp+0x38>
		return 0;
  800c16:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1b:	eb 14                	jmp    800c31 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	8a 00                	mov    (%eax),%al
  800c22:	0f b6 d0             	movzbl %al,%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8a 00                	mov    (%eax),%al
  800c2a:	0f b6 c0             	movzbl %al,%eax
  800c2d:	29 c2                	sub    %eax,%edx
  800c2f:	89 d0                	mov    %edx,%eax
}
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	83 ec 04             	sub    $0x4,%esp
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c3f:	eb 12                	jmp    800c53 <strchr+0x20>
		if (*s == c)
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c49:	75 05                	jne    800c50 <strchr+0x1d>
			return (char *) s;
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	eb 11                	jmp    800c61 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c50:	ff 45 08             	incl   0x8(%ebp)
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	8a 00                	mov    (%eax),%al
  800c58:	84 c0                	test   %al,%al
  800c5a:	75 e5                	jne    800c41 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 04             	sub    $0x4,%esp
  800c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c6f:	eb 0d                	jmp    800c7e <strfind+0x1b>
		if (*s == c)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c79:	74 0e                	je     800c89 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c7b:	ff 45 08             	incl   0x8(%ebp)
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	84 c0                	test   %al,%al
  800c85:	75 ea                	jne    800c71 <strfind+0xe>
  800c87:	eb 01                	jmp    800c8a <strfind+0x27>
		if (*s == c)
			break;
  800c89:	90                   	nop
	return (char *) s;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c9b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c9f:	76 63                	jbe    800d04 <memset+0x75>
		uint64 data_block = c;
  800ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca4:	99                   	cltd   
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb1:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800cb5:	c1 e0 08             	shl    $0x8,%eax
  800cb8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cbb:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc4:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800cc8:	c1 e0 10             	shl    $0x10,%eax
  800ccb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cce:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd7:	89 c2                	mov    %eax,%edx
  800cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cde:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ce1:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ce4:	eb 18                	jmp    800cfe <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ce6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ce9:	8d 41 08             	lea    0x8(%ecx),%eax
  800cec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cf5:	89 01                	mov    %eax,(%ecx)
  800cf7:	89 51 04             	mov    %edx,0x4(%ecx)
  800cfa:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800cfe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d02:	77 e2                	ja     800ce6 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800d04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d08:	74 23                	je     800d2d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d10:	eb 0e                	jmp    800d20 <memset+0x91>
			*p8++ = (uint8)c;
  800d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d15:	8d 50 01             	lea    0x1(%eax),%edx
  800d18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800d20:	8b 45 10             	mov    0x10(%ebp),%eax
  800d23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d26:	89 55 10             	mov    %edx,0x10(%ebp)
  800d29:	85 c0                	test   %eax,%eax
  800d2b:	75 e5                	jne    800d12 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800d44:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d48:	76 24                	jbe    800d6e <memcpy+0x3c>
		while(n >= 8){
  800d4a:	eb 1c                	jmp    800d68 <memcpy+0x36>
			*d64 = *s64;
  800d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4f:	8b 50 04             	mov    0x4(%eax),%edx
  800d52:	8b 00                	mov    (%eax),%eax
  800d54:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800d57:	89 01                	mov    %eax,(%ecx)
  800d59:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800d5c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800d60:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800d64:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800d68:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d6c:	77 de                	ja     800d4c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 31                	je     800da5 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d80:	eb 16                	jmp    800d98 <memcpy+0x66>
			*d8++ = *s8++;
  800d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d85:	8d 50 01             	lea    0x1(%eax),%edx
  800d88:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d91:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d94:	8a 12                	mov    (%edx),%dl
  800d96:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d98:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9e:	89 55 10             	mov    %edx,0x10(%ebp)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	75 dd                	jne    800d82 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dc2:	73 50                	jae    800e14 <memmove+0x6a>
  800dc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dca:	01 d0                	add    %edx,%eax
  800dcc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dcf:	76 43                	jbe    800e14 <memmove+0x6a>
		s += n;
  800dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dda:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ddd:	eb 10                	jmp    800def <memmove+0x45>
			*--d = *--s;
  800ddf:	ff 4d f8             	decl   -0x8(%ebp)
  800de2:	ff 4d fc             	decl   -0x4(%ebp)
  800de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de8:	8a 10                	mov    (%eax),%dl
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df5:	89 55 10             	mov    %edx,0x10(%ebp)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	75 e3                	jne    800ddf <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dfc:	eb 23                	jmp    800e21 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e01:	8d 50 01             	lea    0x1(%eax),%edx
  800e04:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e10:	8a 12                	mov    (%edx),%dl
  800e12:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e14:	8b 45 10             	mov    0x10(%ebp),%eax
  800e17:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1d:	85 c0                	test   %eax,%eax
  800e1f:	75 dd                	jne    800dfe <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e38:	eb 2a                	jmp    800e64 <memcmp+0x3e>
		if (*s1 != *s2)
  800e3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3d:	8a 10                	mov    (%eax),%dl
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	38 c2                	cmp    %al,%dl
  800e46:	74 16                	je     800e5e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	0f b6 d0             	movzbl %al,%edx
  800e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	0f b6 c0             	movzbl %al,%eax
  800e58:	29 c2                	sub    %eax,%edx
  800e5a:	89 d0                	mov    %edx,%eax
  800e5c:	eb 18                	jmp    800e76 <memcmp+0x50>
		s1++, s2++;
  800e5e:	ff 45 fc             	incl   -0x4(%ebp)
  800e61:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e64:	8b 45 10             	mov    0x10(%ebp),%eax
  800e67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	75 c9                	jne    800e3a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e81:	8b 45 10             	mov    0x10(%ebp),%eax
  800e84:	01 d0                	add    %edx,%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e89:	eb 15                	jmp    800ea0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	0f b6 d0             	movzbl %al,%edx
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	39 c2                	cmp    %eax,%edx
  800e9b:	74 0d                	je     800eaa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e9d:	ff 45 08             	incl   0x8(%ebp)
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ea6:	72 e3                	jb     800e8b <memfind+0x13>
  800ea8:	eb 01                	jmp    800eab <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eaa:	90                   	nop
	return (void *) s;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eae:	c9                   	leave  
  800eaf:	c3                   	ret    

00800eb0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800eb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ebd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec4:	eb 03                	jmp    800ec9 <strtol+0x19>
		s++;
  800ec6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8a 00                	mov    (%eax),%al
  800ece:	3c 20                	cmp    $0x20,%al
  800ed0:	74 f4                	je     800ec6 <strtol+0x16>
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3c 09                	cmp    $0x9,%al
  800ed9:	74 eb                	je     800ec6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	3c 2b                	cmp    $0x2b,%al
  800ee2:	75 05                	jne    800ee9 <strtol+0x39>
		s++;
  800ee4:	ff 45 08             	incl   0x8(%ebp)
  800ee7:	eb 13                	jmp    800efc <strtol+0x4c>
	else if (*s == '-')
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	3c 2d                	cmp    $0x2d,%al
  800ef0:	75 0a                	jne    800efc <strtol+0x4c>
		s++, neg = 1;
  800ef2:	ff 45 08             	incl   0x8(%ebp)
  800ef5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800efc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f00:	74 06                	je     800f08 <strtol+0x58>
  800f02:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f06:	75 20                	jne    800f28 <strtol+0x78>
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 30                	cmp    $0x30,%al
  800f0f:	75 17                	jne    800f28 <strtol+0x78>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	40                   	inc    %eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	3c 78                	cmp    $0x78,%al
  800f19:	75 0d                	jne    800f28 <strtol+0x78>
		s += 2, base = 16;
  800f1b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f1f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f26:	eb 28                	jmp    800f50 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2c:	75 15                	jne    800f43 <strtol+0x93>
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 30                	cmp    $0x30,%al
  800f35:	75 0c                	jne    800f43 <strtol+0x93>
		s++, base = 8;
  800f37:	ff 45 08             	incl   0x8(%ebp)
  800f3a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f41:	eb 0d                	jmp    800f50 <strtol+0xa0>
	else if (base == 0)
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	75 07                	jne    800f50 <strtol+0xa0>
		base = 10;
  800f49:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 2f                	cmp    $0x2f,%al
  800f57:	7e 19                	jle    800f72 <strtol+0xc2>
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	3c 39                	cmp    $0x39,%al
  800f60:	7f 10                	jg     800f72 <strtol+0xc2>
			dig = *s - '0';
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	0f be c0             	movsbl %al,%eax
  800f6a:	83 e8 30             	sub    $0x30,%eax
  800f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f70:	eb 42                	jmp    800fb4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	3c 60                	cmp    $0x60,%al
  800f79:	7e 19                	jle    800f94 <strtol+0xe4>
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	3c 7a                	cmp    $0x7a,%al
  800f82:	7f 10                	jg     800f94 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	0f be c0             	movsbl %al,%eax
  800f8c:	83 e8 57             	sub    $0x57,%eax
  800f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f92:	eb 20                	jmp    800fb4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	3c 40                	cmp    $0x40,%al
  800f9b:	7e 39                	jle    800fd6 <strtol+0x126>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 5a                	cmp    $0x5a,%al
  800fa4:	7f 30                	jg     800fd6 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f be c0             	movsbl %al,%eax
  800fae:	83 e8 37             	sub    $0x37,%eax
  800fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fba:	7d 19                	jge    800fd5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fbc:	ff 45 08             	incl   0x8(%ebp)
  800fbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fc6:	89 c2                	mov    %eax,%edx
  800fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fd0:	e9 7b ff ff ff       	jmp    800f50 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fd5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fda:	74 08                	je     800fe4 <strtol+0x134>
		*endptr = (char *) s;
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fe4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fe8:	74 07                	je     800ff1 <strtol+0x141>
  800fea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fed:	f7 d8                	neg    %eax
  800fef:	eb 03                	jmp    800ff4 <strtol+0x144>
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <ltostr>:

void
ltostr(long value, char *str)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ffc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801003:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80100a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80100e:	79 13                	jns    801023 <ltostr+0x2d>
	{
		neg = 1;
  801010:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80101d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801020:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80102b:	99                   	cltd   
  80102c:	f7 f9                	idiv   %ecx
  80102e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801034:	8d 50 01             	lea    0x1(%eax),%edx
  801037:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80103a:	89 c2                	mov    %eax,%edx
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	01 d0                	add    %edx,%eax
  801041:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801044:	83 c2 30             	add    $0x30,%edx
  801047:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801049:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801051:	f7 e9                	imul   %ecx
  801053:	c1 fa 02             	sar    $0x2,%edx
  801056:	89 c8                	mov    %ecx,%eax
  801058:	c1 f8 1f             	sar    $0x1f,%eax
  80105b:	29 c2                	sub    %eax,%edx
  80105d:	89 d0                	mov    %edx,%eax
  80105f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801066:	75 bb                	jne    801023 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801068:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80106f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801072:	48                   	dec    %eax
  801073:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801076:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80107a:	74 3d                	je     8010b9 <ltostr+0xc3>
		start = 1 ;
  80107c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801083:	eb 34                	jmp    8010b9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	01 d0                	add    %edx,%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801092:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801095:	8b 45 0c             	mov    0xc(%ebp),%eax
  801098:	01 c2                	add    %eax,%edx
  80109a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80109d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a0:	01 c8                	add    %ecx,%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	01 c2                	add    %eax,%edx
  8010ae:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010b1:	88 02                	mov    %al,(%edx)
		start++ ;
  8010b3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010b6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010bf:	7c c4                	jl     801085 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	01 d0                	add    %edx,%eax
  8010c9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010cc:	90                   	nop
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010d5:	ff 75 08             	pushl  0x8(%ebp)
  8010d8:	e8 c4 f9 ff ff       	call   800aa1 <strlen>
  8010dd:	83 c4 04             	add    $0x4,%esp
  8010e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010e3:	ff 75 0c             	pushl  0xc(%ebp)
  8010e6:	e8 b6 f9 ff ff       	call   800aa1 <strlen>
  8010eb:	83 c4 04             	add    $0x4,%esp
  8010ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ff:	eb 17                	jmp    801118 <strcconcat+0x49>
		final[s] = str1[s] ;
  801101:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801104:	8b 45 10             	mov    0x10(%ebp),%eax
  801107:	01 c2                	add    %eax,%edx
  801109:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	01 c8                	add    %ecx,%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801115:	ff 45 fc             	incl   -0x4(%ebp)
  801118:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80111e:	7c e1                	jl     801101 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801120:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801127:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80112e:	eb 1f                	jmp    80114f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801130:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801133:	8d 50 01             	lea    0x1(%eax),%edx
  801136:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801139:	89 c2                	mov    %eax,%edx
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	01 c2                	add    %eax,%edx
  801140:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 c8                	add    %ecx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80114c:	ff 45 f8             	incl   -0x8(%ebp)
  80114f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801152:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801155:	7c d9                	jl     801130 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801157:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115a:	8b 45 10             	mov    0x10(%ebp),%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	c6 00 00             	movb   $0x0,(%eax)
}
  801162:	90                   	nop
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801168:	8b 45 14             	mov    0x14(%ebp),%eax
  80116b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801171:	8b 45 14             	mov    0x14(%ebp),%eax
  801174:	8b 00                	mov    (%eax),%eax
  801176:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117d:	8b 45 10             	mov    0x10(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801188:	eb 0c                	jmp    801196 <strsplit+0x31>
			*string++ = 0;
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8d 50 01             	lea    0x1(%eax),%edx
  801190:	89 55 08             	mov    %edx,0x8(%ebp)
  801193:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	84 c0                	test   %al,%al
  80119d:	74 18                	je     8011b7 <strsplit+0x52>
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	0f be c0             	movsbl %al,%eax
  8011a7:	50                   	push   %eax
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	e8 83 fa ff ff       	call   800c33 <strchr>
  8011b0:	83 c4 08             	add    $0x8,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	75 d3                	jne    80118a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	84 c0                	test   %al,%al
  8011be:	74 5a                	je     80121a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c3:	8b 00                	mov    (%eax),%eax
  8011c5:	83 f8 0f             	cmp    $0xf,%eax
  8011c8:	75 07                	jne    8011d1 <strsplit+0x6c>
		{
			return 0;
  8011ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cf:	eb 66                	jmp    801237 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8011d9:	8b 55 14             	mov    0x14(%ebp),%edx
  8011dc:	89 0a                	mov    %ecx,(%edx)
  8011de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e8:	01 c2                	add    %eax,%edx
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011ef:	eb 03                	jmp    8011f4 <strsplit+0x8f>
			string++;
  8011f1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	74 8b                	je     801188 <strsplit+0x23>
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	0f be c0             	movsbl %al,%eax
  801205:	50                   	push   %eax
  801206:	ff 75 0c             	pushl  0xc(%ebp)
  801209:	e8 25 fa ff ff       	call   800c33 <strchr>
  80120e:	83 c4 08             	add    $0x8,%esp
  801211:	85 c0                	test   %eax,%eax
  801213:	74 dc                	je     8011f1 <strsplit+0x8c>
			string++;
	}
  801215:	e9 6e ff ff ff       	jmp    801188 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80121a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80121b:	8b 45 14             	mov    0x14(%ebp),%eax
  80121e:	8b 00                	mov    (%eax),%eax
  801220:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801227:	8b 45 10             	mov    0x10(%ebp),%eax
  80122a:	01 d0                	add    %edx,%eax
  80122c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801232:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801237:	c9                   	leave  
  801238:	c3                   	ret    

00801239 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80124c:	eb 4a                	jmp    801298 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80124e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	01 c2                	add    %eax,%edx
  801256:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 c8                	add    %ecx,%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801262:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 d0                	add    %edx,%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 40                	cmp    $0x40,%al
  80126e:	7e 25                	jle    801295 <str2lower+0x5c>
  801270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	01 d0                	add    %edx,%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 17                	jg     801295 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80127e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801289:	8b 55 08             	mov    0x8(%ebp),%edx
  80128c:	01 ca                	add    %ecx,%edx
  80128e:	8a 12                	mov    (%edx),%dl
  801290:	83 c2 20             	add    $0x20,%edx
  801293:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801295:	ff 45 fc             	incl   -0x4(%ebp)
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	e8 01 f8 ff ff       	call   800aa1 <strlen>
  8012a0:	83 c4 04             	add    $0x4,%esp
  8012a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012a6:	7f a6                	jg     80124e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8012a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8012b3:	a1 08 50 80 00       	mov    0x805008,%eax
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	74 42                	je     8012fe <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8012bc:	83 ec 08             	sub    $0x8,%esp
  8012bf:	68 00 00 00 82       	push   $0x82000000
  8012c4:	68 00 00 00 80       	push   $0x80000000
  8012c9:	e8 b0 1e 00 00       	call   80317e <initialize_dynamic_allocator>
  8012ce:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8012d1:	e8 96 1c 00 00       	call   802f6c <sys_get_uheap_strategy>
  8012d6:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8012db:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8012e0:	05 00 10 00 00       	add    $0x1000,%eax
  8012e5:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8012ea:	a1 30 51 83 00       	mov    0x835130,%eax
  8012ef:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8012f4:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8012fb:	00 00 00 
	}
}
  8012fe:	90                   	nop
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801310:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801315:	83 ec 08             	sub    $0x8,%esp
  801318:	68 06 04 00 00       	push   $0x406
  80131d:	50                   	push   %eax
  80131e:	e8 93 18 00 00       	call   802bb6 <__sys_allocate_page>
  801323:	83 c4 10             	add    $0x10,%esp
  801326:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801329:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80132d:	79 14                	jns    801343 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80132f:	83 ec 04             	sub    $0x4,%esp
  801332:	68 e8 44 80 00       	push   $0x8044e8
  801337:	6a 1f                	push   $0x1f
  801339:	68 24 45 80 00       	push   $0x804524
  80133e:	e8 0f 28 00 00       	call   803b52 <_panic>
	return 0;
  801343:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801359:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80135e:	83 ec 0c             	sub    $0xc,%esp
  801361:	50                   	push   %eax
  801362:	e8 96 18 00 00       	call   802bfd <__sys_unmap_frame>
  801367:	83 c4 10             	add    $0x10,%esp
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80136d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801371:	79 14                	jns    801387 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801373:	83 ec 04             	sub    $0x4,%esp
  801376:	68 30 45 80 00       	push   $0x804530
  80137b:	6a 2a                	push   $0x2a
  80137d:	68 24 45 80 00       	push   $0x804524
  801382:	e8 cb 27 00 00       	call   803b52 <_panic>
}
  801387:	90                   	nop
  801388:	c9                   	leave  
  801389:	c3                   	ret    

0080138a <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801390:	e8 18 ff ff ff       	call   8012ad <uheap_init>
	if (size == 0) return NULL ;
  801395:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801399:	75 0a                	jne    8013a5 <malloc+0x1b>
  80139b:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a0:	e9 43 03 00 00       	jmp    8016e8 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8013a5:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8013ac:	77 13                	ja     8013c1 <malloc+0x37>
    {
        return alloc_block(size);
  8013ae:	83 ec 0c             	sub    $0xc,%esp
  8013b1:	ff 75 08             	pushl  0x8(%ebp)
  8013b4:	e8 78 20 00 00       	call   803431 <alloc_block>
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	e9 27 03 00 00       	jmp    8016e8 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8013c1:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8013c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ce:	01 d0                	add    %edx,%eax
  8013d0:	48                   	dec    %eax
  8013d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013dc:	f7 75 dc             	divl   -0x24(%ebp)
  8013df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013e2:	29 d0                	sub    %edx,%eax
  8013e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8013e7:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	75 0a                	jne    8013fa <malloc+0x70>
    {
        uhp_inited = 1;
  8013f0:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  8013f7:	00 00 00 
    }

    int exactIdx = -1;
  8013fa:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801401:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801408:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80140f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801416:	e9 85 00 00 00       	jmp    8014a0 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80141b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80141e:	89 d0                	mov    %edx,%eax
  801420:	01 c0                	add    %eax,%eax
  801422:	01 d0                	add    %edx,%eax
  801424:	c1 e0 02             	shl    $0x2,%eax
  801427:	05 48 10 81 00       	add    $0x811048,%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	84 c0                	test   %al,%al
  801430:	74 20                	je     801452 <malloc+0xc8>
  801432:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801435:	89 d0                	mov    %edx,%eax
  801437:	01 c0                	add    %eax,%eax
  801439:	01 d0                	add    %edx,%eax
  80143b:	c1 e0 02             	shl    $0x2,%eax
  80143e:	05 44 10 81 00       	add    $0x811044,%eax
  801443:	8b 00                	mov    (%eax),%eax
  801445:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801448:	75 08                	jne    801452 <malloc+0xc8>
        {
            exactIdx = i;
  80144a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80144d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801450:	eb 5b                	jmp    8014ad <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801452:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801455:	89 d0                	mov    %edx,%eax
  801457:	01 c0                	add    %eax,%eax
  801459:	01 d0                	add    %edx,%eax
  80145b:	c1 e0 02             	shl    $0x2,%eax
  80145e:	05 48 10 81 00       	add    $0x811048,%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	84 c0                	test   %al,%al
  801467:	74 34                	je     80149d <malloc+0x113>
  801469:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80146c:	89 d0                	mov    %edx,%eax
  80146e:	01 c0                	add    %eax,%eax
  801470:	01 d0                	add    %edx,%eax
  801472:	c1 e0 02             	shl    $0x2,%eax
  801475:	05 44 10 81 00       	add    $0x811044,%eax
  80147a:	8b 00                	mov    (%eax),%eax
  80147c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80147f:	76 1c                	jbe    80149d <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801481:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801484:	89 d0                	mov    %edx,%eax
  801486:	01 c0                	add    %eax,%eax
  801488:	01 d0                	add    %edx,%eax
  80148a:	c1 e0 02             	shl    $0x2,%eax
  80148d:	05 44 10 81 00       	add    $0x811044,%eax
  801492:	8b 00                	mov    (%eax),%eax
  801494:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80149a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80149d:	ff 45 e8             	incl   -0x18(%ebp)
  8014a0:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8014a7:	0f 8e 6e ff ff ff    	jle    80141b <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8014ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8014b4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8014b8:	74 7d                	je     801537 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8014ba:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8014c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c4:	89 d0                	mov    %edx,%eax
  8014c6:	01 c0                	add    %eax,%eax
  8014c8:	01 d0                	add    %edx,%eax
  8014ca:	c1 e0 02             	shl    $0x2,%eax
  8014cd:	05 40 10 81 00       	add    $0x811040,%eax
  8014d2:	8b 10                	mov    (%eax),%edx
  8014d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8014d7:	01 d0                	add    %edx,%eax
  8014d9:	48                   	dec    %eax
  8014da:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8014dd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8014e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e5:	f7 75 bc             	divl   -0x44(%ebp)
  8014e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8014eb:	29 d0                	sub    %edx,%eax
  8014ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8014f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f3:	89 d0                	mov    %edx,%eax
  8014f5:	01 c0                	add    %eax,%eax
  8014f7:	01 d0                	add    %edx,%eax
  8014f9:	c1 e0 02             	shl    $0x2,%eax
  8014fc:	05 48 10 81 00       	add    $0x811048,%eax
  801501:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801504:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801507:	89 d0                	mov    %edx,%eax
  801509:	01 c0                	add    %eax,%eax
  80150b:	01 d0                	add    %edx,%eax
  80150d:	c1 e0 02             	shl    $0x2,%eax
  801510:	05 44 10 81 00       	add    $0x811044,%eax
  801515:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80151b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151e:	89 d0                	mov    %edx,%eax
  801520:	01 c0                	add    %eax,%eax
  801522:	01 d0                	add    %edx,%eax
  801524:	c1 e0 02             	shl    $0x2,%eax
  801527:	05 40 10 81 00       	add    $0x811040,%eax
  80152c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801532:	e9 2d 01 00 00       	jmp    801664 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801537:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80153b:	0f 84 ce 00 00 00    	je     80160f <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801541:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801548:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80154b:	89 d0                	mov    %edx,%eax
  80154d:	01 c0                	add    %eax,%eax
  80154f:	01 d0                	add    %edx,%eax
  801551:	c1 e0 02             	shl    $0x2,%eax
  801554:	05 40 10 81 00       	add    $0x811040,%eax
  801559:	8b 10                	mov    (%eax),%edx
  80155b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80155e:	01 d0                	add    %edx,%eax
  801560:	48                   	dec    %eax
  801561:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801564:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801567:	ba 00 00 00 00       	mov    $0x0,%edx
  80156c:	f7 75 c4             	divl   -0x3c(%ebp)
  80156f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801572:	29 d0                	sub    %edx,%eax
  801574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801577:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157a:	89 d0                	mov    %edx,%eax
  80157c:	01 c0                	add    %eax,%eax
  80157e:	01 d0                	add    %edx,%eax
  801580:	c1 e0 02             	shl    $0x2,%eax
  801583:	05 44 10 81 00       	add    $0x811044,%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80158d:	75 47                	jne    8015d6 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  80158f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801592:	89 d0                	mov    %edx,%eax
  801594:	01 c0                	add    %eax,%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	c1 e0 02             	shl    $0x2,%eax
  80159b:	05 48 10 81 00       	add    $0x811048,%eax
  8015a0:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8015a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a6:	89 d0                	mov    %edx,%eax
  8015a8:	01 c0                	add    %eax,%eax
  8015aa:	01 d0                	add    %edx,%eax
  8015ac:	c1 e0 02             	shl    $0x2,%eax
  8015af:	05 44 10 81 00       	add    $0x811044,%eax
  8015b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8015ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015bd:	89 d0                	mov    %edx,%eax
  8015bf:	01 c0                	add    %eax,%eax
  8015c1:	01 d0                	add    %edx,%eax
  8015c3:	c1 e0 02             	shl    $0x2,%eax
  8015c6:	05 40 10 81 00       	add    $0x811040,%eax
  8015cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015d1:	e9 8e 00 00 00       	jmp    801664 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8015d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8015dc:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8015df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e2:	89 d0                	mov    %edx,%eax
  8015e4:	01 c0                	add    %eax,%eax
  8015e6:	01 d0                	add    %edx,%eax
  8015e8:	c1 e0 02             	shl    $0x2,%eax
  8015eb:	05 40 10 81 00       	add    $0x811040,%eax
  8015f0:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8015f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f5:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8015f8:	89 c2                	mov    %eax,%edx
  8015fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015fd:	89 c8                	mov    %ecx,%eax
  8015ff:	01 c0                	add    %eax,%eax
  801601:	01 c8                	add    %ecx,%eax
  801603:	c1 e0 02             	shl    $0x2,%eax
  801606:	05 44 10 81 00       	add    $0x811044,%eax
  80160b:	89 10                	mov    %edx,(%eax)
  80160d:	eb 55                	jmp    801664 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80160f:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801616:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80161c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80161f:	01 d0                	add    %edx,%eax
  801621:	48                   	dec    %eax
  801622:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801625:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801628:	ba 00 00 00 00       	mov    $0x0,%edx
  80162d:	f7 75 d0             	divl   -0x30(%ebp)
  801630:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801633:	29 d0                	sub    %edx,%eax
  801635:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801638:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80163b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80163e:	01 d0                	add    %edx,%eax
  801640:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801645:	76 0a                	jbe    801651 <malloc+0x2c7>
            return NULL;
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
  80164c:	e9 97 00 00 00       	jmp    8016e8 <malloc+0x35e>
        va = start;
  801651:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801654:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801657:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80165a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80165d:	01 d0                	add    %edx,%eax
  80165f:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801664:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80166b:	eb 5e                	jmp    8016cb <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  80166d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801670:	89 d0                	mov    %edx,%eax
  801672:	01 c0                	add    %eax,%eax
  801674:	01 d0                	add    %edx,%eax
  801676:	c1 e0 02             	shl    $0x2,%eax
  801679:	05 48 50 80 00       	add    $0x805048,%eax
  80167e:	8a 00                	mov    (%eax),%al
  801680:	84 c0                	test   %al,%al
  801682:	75 44                	jne    8016c8 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801684:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801687:	89 d0                	mov    %edx,%eax
  801689:	01 c0                	add    %eax,%eax
  80168b:	01 d0                	add    %edx,%eax
  80168d:	c1 e0 02             	shl    $0x2,%eax
  801690:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801699:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80169b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80169e:	89 d0                	mov    %edx,%eax
  8016a0:	01 c0                	add    %eax,%eax
  8016a2:	01 d0                	add    %edx,%eax
  8016a4:	c1 e0 02             	shl    $0x2,%eax
  8016a7:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8016ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016b0:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8016b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016b5:	89 d0                	mov    %edx,%eax
  8016b7:	01 c0                	add    %eax,%eax
  8016b9:	01 d0                	add    %edx,%eax
  8016bb:	c1 e0 02             	shl    $0x2,%eax
  8016be:	05 48 50 80 00       	add    $0x805048,%eax
  8016c3:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8016c6:	eb 0c                	jmp    8016d4 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8016c8:	ff 45 e0             	incl   -0x20(%ebp)
  8016cb:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8016d2:	7e 99                	jle    80166d <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  8016d4:	83 ec 08             	sub    $0x8,%esp
  8016d7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8016da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016dd:	e8 a2 19 00 00       	call   803084 <sys_allocate_user_mem>
  8016e2:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8016e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8016f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016f4:	0f 84 fa 03 00 00    	je     801af4 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801700:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801703:	85 c0                	test   %eax,%eax
  801705:	79 1c                	jns    801723 <free+0x39>
  801707:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  80170e:	77 13                	ja     801723 <free+0x39>
    {
        free_block(virtual_address);
  801710:	83 ec 0c             	sub    $0xc,%esp
  801713:	ff 75 08             	pushl  0x8(%ebp)
  801716:	e8 09 21 00 00       	call   803824 <free_block>
  80171b:	83 c4 10             	add    $0x10,%esp
        return;
  80171e:	e9 d2 03 00 00       	jmp    801af5 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801723:	a1 30 51 83 00       	mov    0x835130,%eax
  801728:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  80172b:	72 09                	jb     801736 <free+0x4c>
  80172d:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801734:	76 17                	jbe    80174d <free+0x63>
        panic("free: invalid address");
  801736:	83 ec 04             	sub    $0x4,%esp
  801739:	68 6d 45 80 00       	push   $0x80456d
  80173e:	68 9b 00 00 00       	push   $0x9b
  801743:	68 24 45 80 00       	push   $0x804524
  801748:	e8 05 24 00 00       	call   803b52 <_panic>

    uint32 size = 0;
  80174d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801754:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80175b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801762:	eb 50                	jmp    8017b4 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801764:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801767:	89 d0                	mov    %edx,%eax
  801769:	01 c0                	add    %eax,%eax
  80176b:	01 d0                	add    %edx,%eax
  80176d:	c1 e0 02             	shl    $0x2,%eax
  801770:	05 48 50 80 00       	add    $0x805048,%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	84 c0                	test   %al,%al
  801779:	74 36                	je     8017b1 <free+0xc7>
  80177b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80177e:	89 d0                	mov    %edx,%eax
  801780:	01 c0                	add    %eax,%eax
  801782:	01 d0                	add    %edx,%eax
  801784:	c1 e0 02             	shl    $0x2,%eax
  801787:	05 40 50 80 00       	add    $0x805040,%eax
  80178c:	8b 00                	mov    (%eax),%eax
  80178e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801791:	75 1e                	jne    8017b1 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801793:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801796:	89 d0                	mov    %edx,%eax
  801798:	01 c0                	add    %eax,%eax
  80179a:	01 d0                	add    %edx,%eax
  80179c:	c1 e0 02             	shl    $0x2,%eax
  80179f:	05 44 50 80 00       	add    $0x805044,%eax
  8017a4:	8b 00                	mov    (%eax),%eax
  8017a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  8017a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  8017af:	eb 0c                	jmp    8017bd <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8017b1:	ff 45 ec             	incl   -0x14(%ebp)
  8017b4:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8017bb:	7e a7                	jle    801764 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  8017bd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8017c1:	74 06                	je     8017c9 <free+0xdf>
  8017c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017c7:	75 17                	jne    8017e0 <free+0xf6>
        panic("free: unknown block");
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 83 45 80 00       	push   $0x804583
  8017d1:	68 a9 00 00 00       	push   $0xa9
  8017d6:	68 24 45 80 00       	push   $0x804524
  8017db:	e8 72 23 00 00       	call   803b52 <_panic>

    uhp_allocs[idx].used = 0;
  8017e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e3:	89 d0                	mov    %edx,%eax
  8017e5:	01 c0                	add    %eax,%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	c1 e0 02             	shl    $0x2,%eax
  8017ec:	05 48 50 80 00       	add    $0x805048,%eax
  8017f1:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  8017f4:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8017fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801802:	eb 64                	jmp    801868 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801804:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801807:	89 d0                	mov    %edx,%eax
  801809:	01 c0                	add    %eax,%eax
  80180b:	01 d0                	add    %edx,%eax
  80180d:	c1 e0 02             	shl    $0x2,%eax
  801810:	05 48 10 81 00       	add    $0x811048,%eax
  801815:	8a 00                	mov    (%eax),%al
  801817:	84 c0                	test   %al,%al
  801819:	75 4a                	jne    801865 <free+0x17b>
        {
            uhp_frees[i].va = va;
  80181b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80181e:	89 d0                	mov    %edx,%eax
  801820:	01 c0                	add    %eax,%eax
  801822:	01 d0                	add    %edx,%eax
  801824:	c1 e0 02             	shl    $0x2,%eax
  801827:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  80182d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801830:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801832:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801835:	89 d0                	mov    %edx,%eax
  801837:	01 c0                	add    %eax,%eax
  801839:	01 d0                	add    %edx,%eax
  80183b:	c1 e0 02             	shl    $0x2,%eax
  80183e:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801847:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801849:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80184c:	89 d0                	mov    %edx,%eax
  80184e:	01 c0                	add    %eax,%eax
  801850:	01 d0                	add    %edx,%eax
  801852:	c1 e0 02             	shl    $0x2,%eax
  801855:	05 48 10 81 00       	add    $0x811048,%eax
  80185a:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  80185d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801860:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801863:	eb 0c                	jmp    801871 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801865:	ff 45 e4             	incl   -0x1c(%ebp)
  801868:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80186f:	7e 93                	jle    801804 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801871:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801875:	0f 84 f1 01 00 00    	je     801a6c <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80187b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801882:	e9 d8 01 00 00       	jmp    801a5f <free+0x375>
        {
            if (i == fidx) continue;
  801887:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80188a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80188d:	0f 84 c8 01 00 00    	je     801a5b <free+0x371>
            if (uhp_frees[i].free)
  801893:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801896:	89 d0                	mov    %edx,%eax
  801898:	01 c0                	add    %eax,%eax
  80189a:	01 d0                	add    %edx,%eax
  80189c:	c1 e0 02             	shl    $0x2,%eax
  80189f:	05 48 10 81 00       	add    $0x811048,%eax
  8018a4:	8a 00                	mov    (%eax),%al
  8018a6:	84 c0                	test   %al,%al
  8018a8:	0f 84 ae 01 00 00    	je     801a5c <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  8018ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018b1:	89 d0                	mov    %edx,%eax
  8018b3:	01 c0                	add    %eax,%eax
  8018b5:	01 d0                	add    %edx,%eax
  8018b7:	c1 e0 02             	shl    $0x2,%eax
  8018ba:	05 40 10 81 00       	add    $0x811040,%eax
  8018bf:	8b 08                	mov    (%eax),%ecx
  8018c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018c4:	89 d0                	mov    %edx,%eax
  8018c6:	01 c0                	add    %eax,%eax
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	c1 e0 02             	shl    $0x2,%eax
  8018cd:	05 44 10 81 00       	add    $0x811044,%eax
  8018d2:	8b 00                	mov    (%eax),%eax
  8018d4:	01 c1                	add    %eax,%ecx
  8018d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018d9:	89 d0                	mov    %edx,%eax
  8018db:	01 c0                	add    %eax,%eax
  8018dd:	01 d0                	add    %edx,%eax
  8018df:	c1 e0 02             	shl    $0x2,%eax
  8018e2:	05 40 10 81 00       	add    $0x811040,%eax
  8018e7:	8b 00                	mov    (%eax),%eax
  8018e9:	39 c1                	cmp    %eax,%ecx
  8018eb:	0f 85 a8 00 00 00    	jne    801999 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  8018f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018f4:	89 d0                	mov    %edx,%eax
  8018f6:	01 c0                	add    %eax,%eax
  8018f8:	01 d0                	add    %edx,%eax
  8018fa:	c1 e0 02             	shl    $0x2,%eax
  8018fd:	05 40 10 81 00       	add    $0x811040,%eax
  801902:	8b 10                	mov    (%eax),%edx
  801904:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801907:	89 c8                	mov    %ecx,%eax
  801909:	01 c0                	add    %eax,%eax
  80190b:	01 c8                	add    %ecx,%eax
  80190d:	c1 e0 02             	shl    $0x2,%eax
  801910:	05 40 10 81 00       	add    $0x811040,%eax
  801915:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801917:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80191a:	89 d0                	mov    %edx,%eax
  80191c:	01 c0                	add    %eax,%eax
  80191e:	01 d0                	add    %edx,%eax
  801920:	c1 e0 02             	shl    $0x2,%eax
  801923:	05 44 10 81 00       	add    $0x811044,%eax
  801928:	8b 08                	mov    (%eax),%ecx
  80192a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80192d:	89 d0                	mov    %edx,%eax
  80192f:	01 c0                	add    %eax,%eax
  801931:	01 d0                	add    %edx,%eax
  801933:	c1 e0 02             	shl    $0x2,%eax
  801936:	05 44 10 81 00       	add    $0x811044,%eax
  80193b:	8b 00                	mov    (%eax),%eax
  80193d:	01 c1                	add    %eax,%ecx
  80193f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801942:	89 d0                	mov    %edx,%eax
  801944:	01 c0                	add    %eax,%eax
  801946:	01 d0                	add    %edx,%eax
  801948:	c1 e0 02             	shl    $0x2,%eax
  80194b:	05 44 10 81 00       	add    $0x811044,%eax
  801950:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801952:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801955:	89 d0                	mov    %edx,%eax
  801957:	01 c0                	add    %eax,%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	c1 e0 02             	shl    $0x2,%eax
  80195e:	05 48 10 81 00       	add    $0x811048,%eax
  801963:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801966:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801969:	89 d0                	mov    %edx,%eax
  80196b:	01 c0                	add    %eax,%eax
  80196d:	01 d0                	add    %edx,%eax
  80196f:	c1 e0 02             	shl    $0x2,%eax
  801972:	05 40 10 81 00       	add    $0x811040,%eax
  801977:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  80197d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801980:	89 d0                	mov    %edx,%eax
  801982:	01 c0                	add    %eax,%eax
  801984:	01 d0                	add    %edx,%eax
  801986:	c1 e0 02             	shl    $0x2,%eax
  801989:	05 44 10 81 00       	add    $0x811044,%eax
  80198e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801994:	e9 c3 00 00 00       	jmp    801a5c <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801999:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80199c:	89 d0                	mov    %edx,%eax
  80199e:	01 c0                	add    %eax,%eax
  8019a0:	01 d0                	add    %edx,%eax
  8019a2:	c1 e0 02             	shl    $0x2,%eax
  8019a5:	05 40 10 81 00       	add    $0x811040,%eax
  8019aa:	8b 08                	mov    (%eax),%ecx
  8019ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019af:	89 d0                	mov    %edx,%eax
  8019b1:	01 c0                	add    %eax,%eax
  8019b3:	01 d0                	add    %edx,%eax
  8019b5:	c1 e0 02             	shl    $0x2,%eax
  8019b8:	05 44 10 81 00       	add    $0x811044,%eax
  8019bd:	8b 00                	mov    (%eax),%eax
  8019bf:	01 c1                	add    %eax,%ecx
  8019c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019c4:	89 d0                	mov    %edx,%eax
  8019c6:	01 c0                	add    %eax,%eax
  8019c8:	01 d0                	add    %edx,%eax
  8019ca:	c1 e0 02             	shl    $0x2,%eax
  8019cd:	05 40 10 81 00       	add    $0x811040,%eax
  8019d2:	8b 00                	mov    (%eax),%eax
  8019d4:	39 c1                	cmp    %eax,%ecx
  8019d6:	0f 85 80 00 00 00    	jne    801a5c <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  8019dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019df:	89 d0                	mov    %edx,%eax
  8019e1:	01 c0                	add    %eax,%eax
  8019e3:	01 d0                	add    %edx,%eax
  8019e5:	c1 e0 02             	shl    $0x2,%eax
  8019e8:	05 44 10 81 00       	add    $0x811044,%eax
  8019ed:	8b 08                	mov    (%eax),%ecx
  8019ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019f2:	89 d0                	mov    %edx,%eax
  8019f4:	01 c0                	add    %eax,%eax
  8019f6:	01 d0                	add    %edx,%eax
  8019f8:	c1 e0 02             	shl    $0x2,%eax
  8019fb:	05 44 10 81 00       	add    $0x811044,%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	01 c1                	add    %eax,%ecx
  801a04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a07:	89 d0                	mov    %edx,%eax
  801a09:	01 c0                	add    %eax,%eax
  801a0b:	01 d0                	add    %edx,%eax
  801a0d:	c1 e0 02             	shl    $0x2,%eax
  801a10:	05 44 10 81 00       	add    $0x811044,%eax
  801a15:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801a17:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a1a:	89 d0                	mov    %edx,%eax
  801a1c:	01 c0                	add    %eax,%eax
  801a1e:	01 d0                	add    %edx,%eax
  801a20:	c1 e0 02             	shl    $0x2,%eax
  801a23:	05 48 10 81 00       	add    $0x811048,%eax
  801a28:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801a2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a2e:	89 d0                	mov    %edx,%eax
  801a30:	01 c0                	add    %eax,%eax
  801a32:	01 d0                	add    %edx,%eax
  801a34:	c1 e0 02             	shl    $0x2,%eax
  801a37:	05 40 10 81 00       	add    $0x811040,%eax
  801a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801a42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a45:	89 d0                	mov    %edx,%eax
  801a47:	01 c0                	add    %eax,%eax
  801a49:	01 d0                	add    %edx,%eax
  801a4b:	c1 e0 02             	shl    $0x2,%eax
  801a4e:	05 44 10 81 00       	add    $0x811044,%eax
  801a53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a59:	eb 01                	jmp    801a5c <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801a5b:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a5c:	ff 45 e0             	incl   -0x20(%ebp)
  801a5f:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a66:	0f 8e 1b fe ff ff    	jle    801887 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801a6c:	a1 30 51 83 00       	mov    0x835130,%eax
  801a71:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a74:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801a7b:	eb 53                	jmp    801ad0 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801a7d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a80:	89 d0                	mov    %edx,%eax
  801a82:	01 c0                	add    %eax,%eax
  801a84:	01 d0                	add    %edx,%eax
  801a86:	c1 e0 02             	shl    $0x2,%eax
  801a89:	05 48 50 80 00       	add    $0x805048,%eax
  801a8e:	8a 00                	mov    (%eax),%al
  801a90:	84 c0                	test   %al,%al
  801a92:	74 39                	je     801acd <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801a94:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a97:	89 d0                	mov    %edx,%eax
  801a99:	01 c0                	add    %eax,%eax
  801a9b:	01 d0                	add    %edx,%eax
  801a9d:	c1 e0 02             	shl    $0x2,%eax
  801aa0:	05 40 50 80 00       	add    $0x805040,%eax
  801aa5:	8b 08                	mov    (%eax),%ecx
  801aa7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801aaa:	89 d0                	mov    %edx,%eax
  801aac:	01 c0                	add    %eax,%eax
  801aae:	01 d0                	add    %edx,%eax
  801ab0:	c1 e0 02             	shl    $0x2,%eax
  801ab3:	05 44 50 80 00       	add    $0x805044,%eax
  801ab8:	8b 00                	mov    (%eax),%eax
  801aba:	01 c8                	add    %ecx,%eax
  801abc:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801abf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ac2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801ac5:	76 06                	jbe    801acd <free+0x3e3>
  801ac7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801aca:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801acd:	ff 45 d8             	incl   -0x28(%ebp)
  801ad0:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801ad7:	7e a4                	jle    801a7d <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801ad9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801adc:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801ae1:	83 ec 08             	sub    $0x8,%esp
  801ae4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae7:	ff 75 d4             	pushl  -0x2c(%ebp)
  801aea:	e8 79 15 00 00       	call   803068 <sys_free_user_mem>
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	eb 01                	jmp    801af5 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801af4:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 68             	sub    $0x68,%esp
  801afd:	8b 45 10             	mov    0x10(%ebp),%eax
  801b00:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801b03:	e8 a5 f7 ff ff       	call   8012ad <uheap_init>
	if (size == 0) return NULL ;
  801b08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b0c:	75 0a                	jne    801b18 <smalloc+0x21>
  801b0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b13:	e9 37 03 00 00       	jmp    801e4f <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801b18:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b25:	01 d0                	add    %edx,%eax
  801b27:	48                   	dec    %eax
  801b28:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b33:	f7 75 dc             	divl   -0x24(%ebp)
  801b36:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b39:	29 d0                	sub    %edx,%eax
  801b3b:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801b3e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801b45:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801b4c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b53:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b5a:	e9 85 00 00 00       	jmp    801be4 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801b5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b62:	89 d0                	mov    %edx,%eax
  801b64:	01 c0                	add    %eax,%eax
  801b66:	01 d0                	add    %edx,%eax
  801b68:	c1 e0 02             	shl    $0x2,%eax
  801b6b:	05 48 10 81 00       	add    $0x811048,%eax
  801b70:	8a 00                	mov    (%eax),%al
  801b72:	84 c0                	test   %al,%al
  801b74:	74 20                	je     801b96 <smalloc+0x9f>
  801b76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b79:	89 d0                	mov    %edx,%eax
  801b7b:	01 c0                	add    %eax,%eax
  801b7d:	01 d0                	add    %edx,%eax
  801b7f:	c1 e0 02             	shl    $0x2,%eax
  801b82:	05 44 10 81 00       	add    $0x811044,%eax
  801b87:	8b 00                	mov    (%eax),%eax
  801b89:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b8c:	75 08                	jne    801b96 <smalloc+0x9f>
        {
            exactIdx = i;
  801b8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b91:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801b94:	eb 5b                	jmp    801bf1 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801b96:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b99:	89 d0                	mov    %edx,%eax
  801b9b:	01 c0                	add    %eax,%eax
  801b9d:	01 d0                	add    %edx,%eax
  801b9f:	c1 e0 02             	shl    $0x2,%eax
  801ba2:	05 48 10 81 00       	add    $0x811048,%eax
  801ba7:	8a 00                	mov    (%eax),%al
  801ba9:	84 c0                	test   %al,%al
  801bab:	74 34                	je     801be1 <smalloc+0xea>
  801bad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bb0:	89 d0                	mov    %edx,%eax
  801bb2:	01 c0                	add    %eax,%eax
  801bb4:	01 d0                	add    %edx,%eax
  801bb6:	c1 e0 02             	shl    $0x2,%eax
  801bb9:	05 44 10 81 00       	add    $0x811044,%eax
  801bbe:	8b 00                	mov    (%eax),%eax
  801bc0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801bc3:	76 1c                	jbe    801be1 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801bc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bc8:	89 d0                	mov    %edx,%eax
  801bca:	01 c0                	add    %eax,%eax
  801bcc:	01 d0                	add    %edx,%eax
  801bce:	c1 e0 02             	shl    $0x2,%eax
  801bd1:	05 44 10 81 00       	add    $0x811044,%eax
  801bd6:	8b 00                	mov    (%eax),%eax
  801bd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801bdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bde:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801be1:	ff 45 e8             	incl   -0x18(%ebp)
  801be4:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801beb:	0f 8e 6e ff ff ff    	jle    801b5f <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801bf1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801bf8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801bfc:	74 7d                	je     801c7b <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801bfe:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c08:	89 d0                	mov    %edx,%eax
  801c0a:	01 c0                	add    %eax,%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c1 e0 02             	shl    $0x2,%eax
  801c11:	05 40 10 81 00       	add    $0x811040,%eax
  801c16:	8b 10                	mov    (%eax),%edx
  801c18:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801c1b:	01 d0                	add    %edx,%eax
  801c1d:	48                   	dec    %eax
  801c1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801c21:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c24:	ba 00 00 00 00       	mov    $0x0,%edx
  801c29:	f7 75 bc             	divl   -0x44(%ebp)
  801c2c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c2f:	29 d0                	sub    %edx,%eax
  801c31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c37:	89 d0                	mov    %edx,%eax
  801c39:	01 c0                	add    %eax,%eax
  801c3b:	01 d0                	add    %edx,%eax
  801c3d:	c1 e0 02             	shl    $0x2,%eax
  801c40:	05 48 10 81 00       	add    $0x811048,%eax
  801c45:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801c48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c4b:	89 d0                	mov    %edx,%eax
  801c4d:	01 c0                	add    %eax,%eax
  801c4f:	01 d0                	add    %edx,%eax
  801c51:	c1 e0 02             	shl    $0x2,%eax
  801c54:	05 44 10 81 00       	add    $0x811044,%eax
  801c59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c62:	89 d0                	mov    %edx,%eax
  801c64:	01 c0                	add    %eax,%eax
  801c66:	01 d0                	add    %edx,%eax
  801c68:	c1 e0 02             	shl    $0x2,%eax
  801c6b:	05 40 10 81 00       	add    $0x811040,%eax
  801c70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c76:	e9 2d 01 00 00       	jmp    801da8 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801c7b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c7f:	0f 84 ce 00 00 00    	je     801d53 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801c85:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801c8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c8f:	89 d0                	mov    %edx,%eax
  801c91:	01 c0                	add    %eax,%eax
  801c93:	01 d0                	add    %edx,%eax
  801c95:	c1 e0 02             	shl    $0x2,%eax
  801c98:	05 40 10 81 00       	add    $0x811040,%eax
  801c9d:	8b 10                	mov    (%eax),%edx
  801c9f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ca2:	01 d0                	add    %edx,%eax
  801ca4:	48                   	dec    %eax
  801ca5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801ca8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801cab:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb0:	f7 75 c4             	divl   -0x3c(%ebp)
  801cb3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801cb6:	29 d0                	sub    %edx,%eax
  801cb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801cbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cbe:	89 d0                	mov    %edx,%eax
  801cc0:	01 c0                	add    %eax,%eax
  801cc2:	01 d0                	add    %edx,%eax
  801cc4:	c1 e0 02             	shl    $0x2,%eax
  801cc7:	05 44 10 81 00       	add    $0x811044,%eax
  801ccc:	8b 00                	mov    (%eax),%eax
  801cce:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801cd1:	75 47                	jne    801d1a <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801cd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cd6:	89 d0                	mov    %edx,%eax
  801cd8:	01 c0                	add    %eax,%eax
  801cda:	01 d0                	add    %edx,%eax
  801cdc:	c1 e0 02             	shl    $0x2,%eax
  801cdf:	05 48 10 81 00       	add    $0x811048,%eax
  801ce4:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801ce7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cea:	89 d0                	mov    %edx,%eax
  801cec:	01 c0                	add    %eax,%eax
  801cee:	01 d0                	add    %edx,%eax
  801cf0:	c1 e0 02             	shl    $0x2,%eax
  801cf3:	05 44 10 81 00       	add    $0x811044,%eax
  801cf8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801cfe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d01:	89 d0                	mov    %edx,%eax
  801d03:	01 c0                	add    %eax,%eax
  801d05:	01 d0                	add    %edx,%eax
  801d07:	c1 e0 02             	shl    $0x2,%eax
  801d0a:	05 40 10 81 00       	add    $0x811040,%eax
  801d0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d15:	e9 8e 00 00 00       	jmp    801da8 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d20:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801d23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d26:	89 d0                	mov    %edx,%eax
  801d28:	01 c0                	add    %eax,%eax
  801d2a:	01 d0                	add    %edx,%eax
  801d2c:	c1 e0 02             	shl    $0x2,%eax
  801d2f:	05 40 10 81 00       	add    $0x811040,%eax
  801d34:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d39:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d3c:	89 c2                	mov    %eax,%edx
  801d3e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801d41:	89 c8                	mov    %ecx,%eax
  801d43:	01 c0                	add    %eax,%eax
  801d45:	01 c8                	add    %ecx,%eax
  801d47:	c1 e0 02             	shl    $0x2,%eax
  801d4a:	05 44 10 81 00       	add    $0x811044,%eax
  801d4f:	89 10                	mov    %edx,(%eax)
  801d51:	eb 55                	jmp    801da8 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801d53:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801d5a:	8b 15 88 50 83 00    	mov    0x835088,%edx
  801d60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d63:	01 d0                	add    %edx,%eax
  801d65:	48                   	dec    %eax
  801d66:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801d69:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d71:	f7 75 d0             	divl   -0x30(%ebp)
  801d74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d77:	29 d0                	sub    %edx,%eax
  801d79:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801d7c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801d7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d82:	01 d0                	add    %edx,%eax
  801d84:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801d89:	76 0a                	jbe    801d95 <smalloc+0x29e>
            return NULL;
  801d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d90:	e9 ba 00 00 00       	jmp    801e4f <smalloc+0x358>
        va = start;
  801d95:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801d9b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801d9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801da1:	01 d0                	add    %edx,%eax
  801da3:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801da8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801daf:	eb 5e                	jmp    801e0f <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  801db1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801db4:	89 d0                	mov    %edx,%eax
  801db6:	01 c0                	add    %eax,%eax
  801db8:	01 d0                	add    %edx,%eax
  801dba:	c1 e0 02             	shl    $0x2,%eax
  801dbd:	05 48 50 80 00       	add    $0x805048,%eax
  801dc2:	8a 00                	mov    (%eax),%al
  801dc4:	84 c0                	test   %al,%al
  801dc6:	75 44                	jne    801e0c <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  801dc8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dcb:	89 d0                	mov    %edx,%eax
  801dcd:	01 c0                	add    %eax,%eax
  801dcf:	01 d0                	add    %edx,%eax
  801dd1:	c1 e0 02             	shl    $0x2,%eax
  801dd4:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801dda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ddd:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801ddf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801de2:	89 d0                	mov    %edx,%eax
  801de4:	01 c0                	add    %eax,%eax
  801de6:	01 d0                	add    %edx,%eax
  801de8:	c1 e0 02             	shl    $0x2,%eax
  801deb:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801df1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801df4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801df6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801df9:	89 d0                	mov    %edx,%eax
  801dfb:	01 c0                	add    %eax,%eax
  801dfd:	01 d0                	add    %edx,%eax
  801dff:	c1 e0 02             	shl    $0x2,%eax
  801e02:	05 48 50 80 00       	add    $0x805048,%eax
  801e07:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801e0a:	eb 0c                	jmp    801e18 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e0c:	ff 45 e0             	incl   -0x20(%ebp)
  801e0f:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801e16:	7e 99                	jle    801db1 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  801e18:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e1b:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  801e1f:	52                   	push   %edx
  801e20:	50                   	push   %eax
  801e21:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e24:	ff 75 08             	pushl  0x8(%ebp)
  801e27:	e8 de 0e 00 00       	call   802d0a <sys_create_shared_object>
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  801e32:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  801e36:	75 07                	jne    801e3f <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  801e38:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e3d:	eb 10                	jmp    801e4f <smalloc+0x358>
    if (r < 0)
  801e3f:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  801e43:	79 07                	jns    801e4c <smalloc+0x355>
        return NULL;
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4a:	eb 03                	jmp    801e4f <smalloc+0x358>
    return (void*)va;
  801e4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e57:	e8 51 f4 ff ff       	call   8012ad <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  801e5c:	83 ec 08             	sub    $0x8,%esp
  801e5f:	ff 75 0c             	pushl  0xc(%ebp)
  801e62:	ff 75 08             	pushl  0x8(%ebp)
  801e65:	e8 ca 0e 00 00       	call   802d34 <sys_size_of_shared_object>
  801e6a:	83 c4 10             	add    $0x10,%esp
  801e6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  801e70:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e74:	7f 0a                	jg     801e80 <sget+0x2f>
        return NULL;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7b:	e9 28 03 00 00       	jmp    8021a8 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  801e80:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  801e87:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801e8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e8d:	01 d0                	add    %edx,%eax
  801e8f:	48                   	dec    %eax
  801e90:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801e93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e96:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9b:	f7 75 d8             	divl   -0x28(%ebp)
  801e9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ea1:	29 d0                	sub    %edx,%eax
  801ea3:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  801ea6:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ead:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801eb4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ebb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ec2:	e9 85 00 00 00       	jmp    801f4c <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801ec7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eca:	89 d0                	mov    %edx,%eax
  801ecc:	01 c0                	add    %eax,%eax
  801ece:	01 d0                	add    %edx,%eax
  801ed0:	c1 e0 02             	shl    $0x2,%eax
  801ed3:	05 48 10 81 00       	add    $0x811048,%eax
  801ed8:	8a 00                	mov    (%eax),%al
  801eda:	84 c0                	test   %al,%al
  801edc:	74 20                	je     801efe <sget+0xad>
  801ede:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ee1:	89 d0                	mov    %edx,%eax
  801ee3:	01 c0                	add    %eax,%eax
  801ee5:	01 d0                	add    %edx,%eax
  801ee7:	c1 e0 02             	shl    $0x2,%eax
  801eea:	05 44 10 81 00       	add    $0x811044,%eax
  801eef:	8b 00                	mov    (%eax),%eax
  801ef1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801ef4:	75 08                	jne    801efe <sget+0xad>
        {
            exactIdx = i;
  801ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801efc:	eb 5b                	jmp    801f59 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801efe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f01:	89 d0                	mov    %edx,%eax
  801f03:	01 c0                	add    %eax,%eax
  801f05:	01 d0                	add    %edx,%eax
  801f07:	c1 e0 02             	shl    $0x2,%eax
  801f0a:	05 48 10 81 00       	add    $0x811048,%eax
  801f0f:	8a 00                	mov    (%eax),%al
  801f11:	84 c0                	test   %al,%al
  801f13:	74 34                	je     801f49 <sget+0xf8>
  801f15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f18:	89 d0                	mov    %edx,%eax
  801f1a:	01 c0                	add    %eax,%eax
  801f1c:	01 d0                	add    %edx,%eax
  801f1e:	c1 e0 02             	shl    $0x2,%eax
  801f21:	05 44 10 81 00       	add    $0x811044,%eax
  801f26:	8b 00                	mov    (%eax),%eax
  801f28:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f2b:	76 1c                	jbe    801f49 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  801f2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f30:	89 d0                	mov    %edx,%eax
  801f32:	01 c0                	add    %eax,%eax
  801f34:	01 d0                	add    %edx,%eax
  801f36:	c1 e0 02             	shl    $0x2,%eax
  801f39:	05 44 10 81 00       	add    $0x811044,%eax
  801f3e:	8b 00                	mov    (%eax),%eax
  801f40:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f46:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f49:	ff 45 e8             	incl   -0x18(%ebp)
  801f4c:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f53:	0f 8e 6e ff ff ff    	jle    801ec7 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f59:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f60:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f64:	74 7d                	je     801fe3 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f66:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  801f6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f70:	89 d0                	mov    %edx,%eax
  801f72:	01 c0                	add    %eax,%eax
  801f74:	01 d0                	add    %edx,%eax
  801f76:	c1 e0 02             	shl    $0x2,%eax
  801f79:	05 40 10 81 00       	add    $0x811040,%eax
  801f7e:	8b 10                	mov    (%eax),%edx
  801f80:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f83:	01 d0                	add    %edx,%eax
  801f85:	48                   	dec    %eax
  801f86:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  801f89:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f91:	f7 75 b8             	divl   -0x48(%ebp)
  801f94:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801f97:	29 d0                	sub    %edx,%eax
  801f99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9f:	89 d0                	mov    %edx,%eax
  801fa1:	01 c0                	add    %eax,%eax
  801fa3:	01 d0                	add    %edx,%eax
  801fa5:	c1 e0 02             	shl    $0x2,%eax
  801fa8:	05 48 10 81 00       	add    $0x811048,%eax
  801fad:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb3:	89 d0                	mov    %edx,%eax
  801fb5:	01 c0                	add    %eax,%eax
  801fb7:	01 d0                	add    %edx,%eax
  801fb9:	c1 e0 02             	shl    $0x2,%eax
  801fbc:	05 44 10 81 00       	add    $0x811044,%eax
  801fc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801fc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fca:	89 d0                	mov    %edx,%eax
  801fcc:	01 c0                	add    %eax,%eax
  801fce:	01 d0                	add    %edx,%eax
  801fd0:	c1 e0 02             	shl    $0x2,%eax
  801fd3:	05 40 10 81 00       	add    $0x811040,%eax
  801fd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fde:	e9 2d 01 00 00       	jmp    802110 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  801fe3:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801fe7:	0f 84 ce 00 00 00    	je     8020bb <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801fed:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  801ff4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ff7:	89 d0                	mov    %edx,%eax
  801ff9:	01 c0                	add    %eax,%eax
  801ffb:	01 d0                	add    %edx,%eax
  801ffd:	c1 e0 02             	shl    $0x2,%eax
  802000:	05 40 10 81 00       	add    $0x811040,%eax
  802005:	8b 10                	mov    (%eax),%edx
  802007:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80200a:	01 d0                	add    %edx,%eax
  80200c:	48                   	dec    %eax
  80200d:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802010:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802013:	ba 00 00 00 00       	mov    $0x0,%edx
  802018:	f7 75 c0             	divl   -0x40(%ebp)
  80201b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80201e:	29 d0                	sub    %edx,%eax
  802020:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802023:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802026:	89 d0                	mov    %edx,%eax
  802028:	01 c0                	add    %eax,%eax
  80202a:	01 d0                	add    %edx,%eax
  80202c:	c1 e0 02             	shl    $0x2,%eax
  80202f:	05 44 10 81 00       	add    $0x811044,%eax
  802034:	8b 00                	mov    (%eax),%eax
  802036:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802039:	75 47                	jne    802082 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  80203b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80203e:	89 d0                	mov    %edx,%eax
  802040:	01 c0                	add    %eax,%eax
  802042:	01 d0                	add    %edx,%eax
  802044:	c1 e0 02             	shl    $0x2,%eax
  802047:	05 48 10 81 00       	add    $0x811048,%eax
  80204c:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80204f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802052:	89 d0                	mov    %edx,%eax
  802054:	01 c0                	add    %eax,%eax
  802056:	01 d0                	add    %edx,%eax
  802058:	c1 e0 02             	shl    $0x2,%eax
  80205b:	05 44 10 81 00       	add    $0x811044,%eax
  802060:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802066:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	01 c0                	add    %eax,%eax
  80206d:	01 d0                	add    %edx,%eax
  80206f:	c1 e0 02             	shl    $0x2,%eax
  802072:	05 40 10 81 00       	add    $0x811040,%eax
  802077:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80207d:	e9 8e 00 00 00       	jmp    802110 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802082:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802085:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802088:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80208b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80208e:	89 d0                	mov    %edx,%eax
  802090:	01 c0                	add    %eax,%eax
  802092:	01 d0                	add    %edx,%eax
  802094:	c1 e0 02             	shl    $0x2,%eax
  802097:	05 40 10 81 00       	add    $0x811040,%eax
  80209c:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80209e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a1:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8020a4:	89 c2                	mov    %eax,%edx
  8020a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020a9:	89 c8                	mov    %ecx,%eax
  8020ab:	01 c0                	add    %eax,%eax
  8020ad:	01 c8                	add    %ecx,%eax
  8020af:	c1 e0 02             	shl    $0x2,%eax
  8020b2:	05 44 10 81 00       	add    $0x811044,%eax
  8020b7:	89 10                	mov    %edx,(%eax)
  8020b9:	eb 55                	jmp    802110 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8020bb:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8020c2:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8020c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020cb:	01 d0                	add    %edx,%eax
  8020cd:	48                   	dec    %eax
  8020ce:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8020d1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d9:	f7 75 cc             	divl   -0x34(%ebp)
  8020dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020df:	29 d0                	sub    %edx,%eax
  8020e1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8020e4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8020e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020ea:	01 d0                	add    %edx,%eax
  8020ec:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8020f1:	76 0a                	jbe    8020fd <sget+0x2ac>
            return NULL;
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	e9 ab 00 00 00       	jmp    8021a8 <sget+0x357>
        va = start;
  8020fd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802100:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802103:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802106:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802109:	01 d0                	add    %edx,%eax
  80210b:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802110:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802117:	eb 5e                	jmp    802177 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802119:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80211c:	89 d0                	mov    %edx,%eax
  80211e:	01 c0                	add    %eax,%eax
  802120:	01 d0                	add    %edx,%eax
  802122:	c1 e0 02             	shl    $0x2,%eax
  802125:	05 48 50 80 00       	add    $0x805048,%eax
  80212a:	8a 00                	mov    (%eax),%al
  80212c:	84 c0                	test   %al,%al
  80212e:	75 44                	jne    802174 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802130:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802133:	89 d0                	mov    %edx,%eax
  802135:	01 c0                	add    %eax,%eax
  802137:	01 d0                	add    %edx,%eax
  802139:	c1 e0 02             	shl    $0x2,%eax
  80213c:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802142:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802145:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802147:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80214a:	89 d0                	mov    %edx,%eax
  80214c:	01 c0                	add    %eax,%eax
  80214e:	01 d0                	add    %edx,%eax
  802150:	c1 e0 02             	shl    $0x2,%eax
  802153:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802159:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80215c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80215e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802161:	89 d0                	mov    %edx,%eax
  802163:	01 c0                	add    %eax,%eax
  802165:	01 d0                	add    %edx,%eax
  802167:	c1 e0 02             	shl    $0x2,%eax
  80216a:	05 48 50 80 00       	add    $0x805048,%eax
  80216f:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802172:	eb 0c                	jmp    802180 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802174:	ff 45 e0             	incl   -0x20(%ebp)
  802177:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80217e:	7e 99                	jle    802119 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802183:	83 ec 04             	sub    $0x4,%esp
  802186:	50                   	push   %eax
  802187:	ff 75 0c             	pushl  0xc(%ebp)
  80218a:	ff 75 08             	pushl  0x8(%ebp)
  80218d:	e8 bf 0b 00 00       	call   802d51 <sys_get_shared_object>
  802192:	83 c4 10             	add    $0x10,%esp
  802195:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802198:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80219c:	79 07                	jns    8021a5 <sget+0x354>
        return NULL;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a3:	eb 03                	jmp    8021a8 <sget+0x357>
    return (void*)va;
  8021a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021b0:	e8 f8 f0 ff ff       	call   8012ad <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8021b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b9:	75 13                	jne    8021ce <realloc+0x24>
		return malloc(new_size);
  8021bb:	83 ec 0c             	sub    $0xc,%esp
  8021be:	ff 75 0c             	pushl  0xc(%ebp)
  8021c1:	e8 c4 f1 ff ff       	call   80138a <malloc>
  8021c6:	83 c4 10             	add    $0x10,%esp
  8021c9:	e9 f4 05 00 00       	jmp    8027c2 <realloc+0x618>
	if (new_size == 0)
  8021ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021d2:	75 18                	jne    8021ec <realloc+0x42>
	{
		free(virtual_address);
  8021d4:	83 ec 0c             	sub    $0xc,%esp
  8021d7:	ff 75 08             	pushl  0x8(%ebp)
  8021da:	e8 0b f5 ff ff       	call   8016ea <free>
  8021df:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8021e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e7:	e9 d6 05 00 00       	jmp    8027c2 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8021f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	79 74                	jns    80226d <realloc+0xc3>
  8021f9:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802200:	77 6b                	ja     80226d <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802202:	83 ec 0c             	sub    $0xc,%esp
  802205:	ff 75 0c             	pushl  0xc(%ebp)
  802208:	e8 7d f1 ff ff       	call   80138a <malloc>
  80220d:	83 c4 10             	add    $0x10,%esp
  802210:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802213:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802217:	75 0a                	jne    802223 <realloc+0x79>
			return NULL;
  802219:	b8 00 00 00 00       	mov    $0x0,%eax
  80221e:	e9 9f 05 00 00       	jmp    8027c2 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802223:	83 ec 0c             	sub    $0xc,%esp
  802226:	ff 75 08             	pushl  0x8(%ebp)
  802229:	e8 e0 11 00 00       	call   80340e <get_block_size>
  80222e:	83 c4 10             	add    $0x10,%esp
  802231:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802234:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223a:	39 d0                	cmp    %edx,%eax
  80223c:	76 02                	jbe    802240 <realloc+0x96>
  80223e:	89 d0                	mov    %edx,%eax
  802240:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802243:	83 ec 04             	sub    $0x4,%esp
  802246:	ff 75 c0             	pushl  -0x40(%ebp)
  802249:	ff 75 08             	pushl  0x8(%ebp)
  80224c:	ff 75 c8             	pushl  -0x38(%ebp)
  80224f:	e8 56 eb ff ff       	call   800daa <memmove>
  802254:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802257:	83 ec 0c             	sub    $0xc,%esp
  80225a:	ff 75 08             	pushl  0x8(%ebp)
  80225d:	e8 88 f4 ff ff       	call   8016ea <free>
  802262:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802265:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802268:	e9 55 05 00 00       	jmp    8027c2 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80226d:	a1 30 51 83 00       	mov    0x835130,%eax
  802272:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802275:	72 09                	jb     802280 <realloc+0xd6>
  802277:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  80227e:	76 0a                	jbe    80228a <realloc+0xe0>
		return NULL;
  802280:	b8 00 00 00 00       	mov    $0x0,%eax
  802285:	e9 38 05 00 00       	jmp    8027c2 <realloc+0x618>
	uint32 oldsz = 0;
  80228a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802291:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802298:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80229f:	eb 50                	jmp    8022f1 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8022a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022a4:	89 d0                	mov    %edx,%eax
  8022a6:	01 c0                	add    %eax,%eax
  8022a8:	01 d0                	add    %edx,%eax
  8022aa:	c1 e0 02             	shl    $0x2,%eax
  8022ad:	05 48 50 80 00       	add    $0x805048,%eax
  8022b2:	8a 00                	mov    (%eax),%al
  8022b4:	84 c0                	test   %al,%al
  8022b6:	74 36                	je     8022ee <realloc+0x144>
  8022b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022bb:	89 d0                	mov    %edx,%eax
  8022bd:	01 c0                	add    %eax,%eax
  8022bf:	01 d0                	add    %edx,%eax
  8022c1:	c1 e0 02             	shl    $0x2,%eax
  8022c4:	05 40 50 80 00       	add    $0x805040,%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8022ce:	75 1e                	jne    8022ee <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  8022d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022d3:	89 d0                	mov    %edx,%eax
  8022d5:	01 c0                	add    %eax,%eax
  8022d7:	01 d0                	add    %edx,%eax
  8022d9:	c1 e0 02             	shl    $0x2,%eax
  8022dc:	05 44 50 80 00       	add    $0x805044,%eax
  8022e1:	8b 00                	mov    (%eax),%eax
  8022e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8022e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8022ec:	eb 0c                	jmp    8022fa <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022ee:	ff 45 ec             	incl   -0x14(%ebp)
  8022f1:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8022f8:	7e a7                	jle    8022a1 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8022fa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8022fe:	75 0a                	jne    80230a <realloc+0x160>
		return NULL;
  802300:	b8 00 00 00 00       	mov    $0x0,%eax
  802305:	e9 b8 04 00 00       	jmp    8027c2 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  80230a:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802311:	8b 55 0c             	mov    0xc(%ebp),%edx
  802314:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802317:	01 d0                	add    %edx,%eax
  802319:	48                   	dec    %eax
  80231a:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80231d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802320:	ba 00 00 00 00       	mov    $0x0,%edx
  802325:	f7 75 bc             	divl   -0x44(%ebp)
  802328:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80232b:	29 d0                	sub    %edx,%eax
  80232d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802330:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802333:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802336:	75 08                	jne    802340 <realloc+0x196>
		return virtual_address;
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	e9 82 04 00 00       	jmp    8027c2 <realloc+0x618>
	if (req < oldsz)
  802340:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802343:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802346:	0f 83 cd 02 00 00    	jae    802619 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802352:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802355:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802358:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80235b:	01 d0                	add    %edx,%eax
  80235d:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802360:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802363:	89 d0                	mov    %edx,%eax
  802365:	01 c0                	add    %eax,%eax
  802367:	01 d0                	add    %edx,%eax
  802369:	c1 e0 02             	shl    $0x2,%eax
  80236c:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802372:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802375:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802377:	83 ec 08             	sub    $0x8,%esp
  80237a:	ff 75 b0             	pushl  -0x50(%ebp)
  80237d:	ff 75 ac             	pushl  -0x54(%ebp)
  802380:	e8 e3 0c 00 00       	call   803068 <sys_free_user_mem>
  802385:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802388:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80238f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802396:	eb 64                	jmp    8023fc <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802398:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80239b:	89 d0                	mov    %edx,%eax
  80239d:	01 c0                	add    %eax,%eax
  80239f:	01 d0                	add    %edx,%eax
  8023a1:	c1 e0 02             	shl    $0x2,%eax
  8023a4:	05 48 10 81 00       	add    $0x811048,%eax
  8023a9:	8a 00                	mov    (%eax),%al
  8023ab:	84 c0                	test   %al,%al
  8023ad:	75 4a                	jne    8023f9 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8023af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023b2:	89 d0                	mov    %edx,%eax
  8023b4:	01 c0                	add    %eax,%eax
  8023b6:	01 d0                	add    %edx,%eax
  8023b8:	c1 e0 02             	shl    $0x2,%eax
  8023bb:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  8023c1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8023c4:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  8023c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023c9:	89 d0                	mov    %edx,%eax
  8023cb:	01 c0                	add    %eax,%eax
  8023cd:	01 d0                	add    %edx,%eax
  8023cf:	c1 e0 02             	shl    $0x2,%eax
  8023d2:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  8023d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023db:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  8023dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023e0:	89 d0                	mov    %edx,%eax
  8023e2:	01 c0                	add    %eax,%eax
  8023e4:	01 d0                	add    %edx,%eax
  8023e6:	c1 e0 02             	shl    $0x2,%eax
  8023e9:	05 48 10 81 00       	add    $0x811048,%eax
  8023ee:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8023f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8023f7:	eb 0c                	jmp    802405 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8023f9:	ff 45 e4             	incl   -0x1c(%ebp)
  8023fc:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802403:	7e 93                	jle    802398 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802405:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802409:	0f 84 8d 01 00 00    	je     80259c <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80240f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802416:	e9 74 01 00 00       	jmp    80258f <realloc+0x3e5>
			{
				if (k == fidx) continue;
  80241b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802421:	0f 84 64 01 00 00    	je     80258b <realloc+0x3e1>
				if (uhp_frees[k].free)
  802427:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80242a:	89 d0                	mov    %edx,%eax
  80242c:	01 c0                	add    %eax,%eax
  80242e:	01 d0                	add    %edx,%eax
  802430:	c1 e0 02             	shl    $0x2,%eax
  802433:	05 48 10 81 00       	add    $0x811048,%eax
  802438:	8a 00                	mov    (%eax),%al
  80243a:	84 c0                	test   %al,%al
  80243c:	0f 84 4a 01 00 00    	je     80258c <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802442:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802445:	89 d0                	mov    %edx,%eax
  802447:	01 c0                	add    %eax,%eax
  802449:	01 d0                	add    %edx,%eax
  80244b:	c1 e0 02             	shl    $0x2,%eax
  80244e:	05 40 10 81 00       	add    $0x811040,%eax
  802453:	8b 08                	mov    (%eax),%ecx
  802455:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802458:	89 d0                	mov    %edx,%eax
  80245a:	01 c0                	add    %eax,%eax
  80245c:	01 d0                	add    %edx,%eax
  80245e:	c1 e0 02             	shl    $0x2,%eax
  802461:	05 44 10 81 00       	add    $0x811044,%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	01 c1                	add    %eax,%ecx
  80246a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80246d:	89 d0                	mov    %edx,%eax
  80246f:	01 c0                	add    %eax,%eax
  802471:	01 d0                	add    %edx,%eax
  802473:	c1 e0 02             	shl    $0x2,%eax
  802476:	05 40 10 81 00       	add    $0x811040,%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	39 c1                	cmp    %eax,%ecx
  80247f:	75 7a                	jne    8024fb <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802481:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802484:	89 d0                	mov    %edx,%eax
  802486:	01 c0                	add    %eax,%eax
  802488:	01 d0                	add    %edx,%eax
  80248a:	c1 e0 02             	shl    $0x2,%eax
  80248d:	05 40 10 81 00       	add    $0x811040,%eax
  802492:	8b 10                	mov    (%eax),%edx
  802494:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802497:	89 c8                	mov    %ecx,%eax
  802499:	01 c0                	add    %eax,%eax
  80249b:	01 c8                	add    %ecx,%eax
  80249d:	c1 e0 02             	shl    $0x2,%eax
  8024a0:	05 40 10 81 00       	add    $0x811040,%eax
  8024a5:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  8024a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024aa:	89 d0                	mov    %edx,%eax
  8024ac:	01 c0                	add    %eax,%eax
  8024ae:	01 d0                	add    %edx,%eax
  8024b0:	c1 e0 02             	shl    $0x2,%eax
  8024b3:	05 44 10 81 00       	add    $0x811044,%eax
  8024b8:	8b 08                	mov    (%eax),%ecx
  8024ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024bd:	89 d0                	mov    %edx,%eax
  8024bf:	01 c0                	add    %eax,%eax
  8024c1:	01 d0                	add    %edx,%eax
  8024c3:	c1 e0 02             	shl    $0x2,%eax
  8024c6:	05 44 10 81 00       	add    $0x811044,%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	01 c1                	add    %eax,%ecx
  8024cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	01 c0                	add    %eax,%eax
  8024d6:	01 d0                	add    %edx,%eax
  8024d8:	c1 e0 02             	shl    $0x2,%eax
  8024db:	05 44 10 81 00       	add    $0x811044,%eax
  8024e0:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8024e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024e5:	89 d0                	mov    %edx,%eax
  8024e7:	01 c0                	add    %eax,%eax
  8024e9:	01 d0                	add    %edx,%eax
  8024eb:	c1 e0 02             	shl    $0x2,%eax
  8024ee:	05 48 10 81 00       	add    $0x811048,%eax
  8024f3:	c6 00 00             	movb   $0x0,(%eax)
  8024f6:	e9 91 00 00 00       	jmp    80258c <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8024fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024fe:	89 d0                	mov    %edx,%eax
  802500:	01 c0                	add    %eax,%eax
  802502:	01 d0                	add    %edx,%eax
  802504:	c1 e0 02             	shl    $0x2,%eax
  802507:	05 40 10 81 00       	add    $0x811040,%eax
  80250c:	8b 08                	mov    (%eax),%ecx
  80250e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802511:	89 d0                	mov    %edx,%eax
  802513:	01 c0                	add    %eax,%eax
  802515:	01 d0                	add    %edx,%eax
  802517:	c1 e0 02             	shl    $0x2,%eax
  80251a:	05 44 10 81 00       	add    $0x811044,%eax
  80251f:	8b 00                	mov    (%eax),%eax
  802521:	01 c1                	add    %eax,%ecx
  802523:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802526:	89 d0                	mov    %edx,%eax
  802528:	01 c0                	add    %eax,%eax
  80252a:	01 d0                	add    %edx,%eax
  80252c:	c1 e0 02             	shl    $0x2,%eax
  80252f:	05 40 10 81 00       	add    $0x811040,%eax
  802534:	8b 00                	mov    (%eax),%eax
  802536:	39 c1                	cmp    %eax,%ecx
  802538:	75 52                	jne    80258c <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  80253a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80253d:	89 d0                	mov    %edx,%eax
  80253f:	01 c0                	add    %eax,%eax
  802541:	01 d0                	add    %edx,%eax
  802543:	c1 e0 02             	shl    $0x2,%eax
  802546:	05 44 10 81 00       	add    $0x811044,%eax
  80254b:	8b 08                	mov    (%eax),%ecx
  80254d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802550:	89 d0                	mov    %edx,%eax
  802552:	01 c0                	add    %eax,%eax
  802554:	01 d0                	add    %edx,%eax
  802556:	c1 e0 02             	shl    $0x2,%eax
  802559:	05 44 10 81 00       	add    $0x811044,%eax
  80255e:	8b 00                	mov    (%eax),%eax
  802560:	01 c1                	add    %eax,%ecx
  802562:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802565:	89 d0                	mov    %edx,%eax
  802567:	01 c0                	add    %eax,%eax
  802569:	01 d0                	add    %edx,%eax
  80256b:	c1 e0 02             	shl    $0x2,%eax
  80256e:	05 44 10 81 00       	add    $0x811044,%eax
  802573:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802575:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802578:	89 d0                	mov    %edx,%eax
  80257a:	01 c0                	add    %eax,%eax
  80257c:	01 d0                	add    %edx,%eax
  80257e:	c1 e0 02             	shl    $0x2,%eax
  802581:	05 48 10 81 00       	add    $0x811048,%eax
  802586:	c6 00 00             	movb   $0x0,(%eax)
  802589:	eb 01                	jmp    80258c <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  80258b:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80258c:	ff 45 e0             	incl   -0x20(%ebp)
  80258f:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802596:	0f 8e 7f fe ff ff    	jle    80241b <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  80259c:	a1 30 51 83 00       	mov    0x835130,%eax
  8025a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8025a4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8025ab:	eb 53                	jmp    802600 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  8025ad:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025b0:	89 d0                	mov    %edx,%eax
  8025b2:	01 c0                	add    %eax,%eax
  8025b4:	01 d0                	add    %edx,%eax
  8025b6:	c1 e0 02             	shl    $0x2,%eax
  8025b9:	05 48 50 80 00       	add    $0x805048,%eax
  8025be:	8a 00                	mov    (%eax),%al
  8025c0:	84 c0                	test   %al,%al
  8025c2:	74 39                	je     8025fd <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8025c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025c7:	89 d0                	mov    %edx,%eax
  8025c9:	01 c0                	add    %eax,%eax
  8025cb:	01 d0                	add    %edx,%eax
  8025cd:	c1 e0 02             	shl    $0x2,%eax
  8025d0:	05 40 50 80 00       	add    $0x805040,%eax
  8025d5:	8b 08                	mov    (%eax),%ecx
  8025d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025da:	89 d0                	mov    %edx,%eax
  8025dc:	01 c0                	add    %eax,%eax
  8025de:	01 d0                	add    %edx,%eax
  8025e0:	c1 e0 02             	shl    $0x2,%eax
  8025e3:	05 44 50 80 00       	add    $0x805044,%eax
  8025e8:	8b 00                	mov    (%eax),%eax
  8025ea:	01 c8                	add    %ecx,%eax
  8025ec:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8025ef:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025f2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8025f5:	76 06                	jbe    8025fd <realloc+0x453>
  8025f7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8025fd:	ff 45 d8             	incl   -0x28(%ebp)
  802600:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802607:	7e a4                	jle    8025ad <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802609:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80260c:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802611:	8b 45 08             	mov    0x8(%ebp),%eax
  802614:	e9 a9 01 00 00       	jmp    8027c2 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802619:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	01 d0                	add    %edx,%eax
  802621:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802624:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80262b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802632:	eb 57                	jmp    80268b <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802634:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802637:	89 d0                	mov    %edx,%eax
  802639:	01 c0                	add    %eax,%eax
  80263b:	01 d0                	add    %edx,%eax
  80263d:	c1 e0 02             	shl    $0x2,%eax
  802640:	05 48 10 81 00       	add    $0x811048,%eax
  802645:	8a 00                	mov    (%eax),%al
  802647:	84 c0                	test   %al,%al
  802649:	74 3d                	je     802688 <realloc+0x4de>
  80264b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80264e:	89 d0                	mov    %edx,%eax
  802650:	01 c0                	add    %eax,%eax
  802652:	01 d0                	add    %edx,%eax
  802654:	c1 e0 02             	shl    $0x2,%eax
  802657:	05 40 10 81 00       	add    $0x811040,%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802661:	75 25                	jne    802688 <realloc+0x4de>
  802663:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802666:	89 d0                	mov    %edx,%eax
  802668:	01 c0                	add    %eax,%eax
  80266a:	01 d0                	add    %edx,%eax
  80266c:	c1 e0 02             	shl    $0x2,%eax
  80266f:	05 44 10 81 00       	add    $0x811044,%eax
  802674:	8b 10                	mov    (%eax),%edx
  802676:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802679:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80267c:	39 c2                	cmp    %eax,%edx
  80267e:	72 08                	jb     802688 <realloc+0x4de>
		{
			adjIdx = j; break;
  802680:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802683:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802686:	eb 0c                	jmp    802694 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802688:	ff 45 d0             	incl   -0x30(%ebp)
  80268b:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802692:	7e a0                	jle    802634 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802694:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802698:	0f 84 d6 00 00 00    	je     802774 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  80269e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026a1:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8026a4:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  8026a7:	83 ec 08             	sub    $0x8,%esp
  8026aa:	ff 75 a0             	pushl  -0x60(%ebp)
  8026ad:	ff 75 a4             	pushl  -0x5c(%ebp)
  8026b0:	e8 cf 09 00 00       	call   803084 <sys_allocate_user_mem>
  8026b5:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  8026b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026bb:	89 d0                	mov    %edx,%eax
  8026bd:	01 c0                	add    %eax,%eax
  8026bf:	01 d0                	add    %edx,%eax
  8026c1:	c1 e0 02             	shl    $0x2,%eax
  8026c4:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8026ca:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026cd:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  8026cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026d2:	89 d0                	mov    %edx,%eax
  8026d4:	01 c0                	add    %eax,%eax
  8026d6:	01 d0                	add    %edx,%eax
  8026d8:	c1 e0 02             	shl    $0x2,%eax
  8026db:	05 40 10 81 00       	add    $0x811040,%eax
  8026e0:	8b 10                	mov    (%eax),%edx
  8026e2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8026e5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8026e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026eb:	89 d0                	mov    %edx,%eax
  8026ed:	01 c0                	add    %eax,%eax
  8026ef:	01 d0                	add    %edx,%eax
  8026f1:	c1 e0 02             	shl    $0x2,%eax
  8026f4:	05 40 10 81 00       	add    $0x811040,%eax
  8026f9:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8026fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026fe:	89 d0                	mov    %edx,%eax
  802700:	01 c0                	add    %eax,%eax
  802702:	01 d0                	add    %edx,%eax
  802704:	c1 e0 02             	shl    $0x2,%eax
  802707:	05 44 10 81 00       	add    $0x811044,%eax
  80270c:	8b 00                	mov    (%eax),%eax
  80270e:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802711:	89 c2                	mov    %eax,%edx
  802713:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802716:	89 c8                	mov    %ecx,%eax
  802718:	01 c0                	add    %eax,%eax
  80271a:	01 c8                	add    %ecx,%eax
  80271c:	c1 e0 02             	shl    $0x2,%eax
  80271f:	05 44 10 81 00       	add    $0x811044,%eax
  802724:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802726:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802729:	89 d0                	mov    %edx,%eax
  80272b:	01 c0                	add    %eax,%eax
  80272d:	01 d0                	add    %edx,%eax
  80272f:	c1 e0 02             	shl    $0x2,%eax
  802732:	05 44 10 81 00       	add    $0x811044,%eax
  802737:	8b 00                	mov    (%eax),%eax
  802739:	85 c0                	test   %eax,%eax
  80273b:	75 14                	jne    802751 <realloc+0x5a7>
  80273d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802740:	89 d0                	mov    %edx,%eax
  802742:	01 c0                	add    %eax,%eax
  802744:	01 d0                	add    %edx,%eax
  802746:	c1 e0 02             	shl    $0x2,%eax
  802749:	05 48 10 81 00       	add    $0x811048,%eax
  80274e:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802751:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802754:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802757:	01 c2                	add    %eax,%edx
  802759:	a1 88 50 83 00       	mov    0x835088,%eax
  80275e:	39 c2                	cmp    %eax,%edx
  802760:	76 0d                	jbe    80276f <realloc+0x5c5>
  802762:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802765:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802768:	01 d0                	add    %edx,%eax
  80276a:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  80276f:	8b 45 08             	mov    0x8(%ebp),%eax
  802772:	eb 4e                	jmp    8027c2 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802774:	83 ec 0c             	sub    $0xc,%esp
  802777:	ff 75 0c             	pushl  0xc(%ebp)
  80277a:	e8 0b ec ff ff       	call   80138a <malloc>
  80277f:	83 c4 10             	add    $0x10,%esp
  802782:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802785:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802789:	75 07                	jne    802792 <realloc+0x5e8>
		return NULL;
  80278b:	b8 00 00 00 00       	mov    $0x0,%eax
  802790:	eb 30                	jmp    8027c2 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802795:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802798:	39 d0                	cmp    %edx,%eax
  80279a:	76 02                	jbe    80279e <realloc+0x5f4>
  80279c:	89 d0                	mov    %edx,%eax
  80279e:	8b 55 9c             	mov    -0x64(%ebp),%edx
  8027a1:	83 ec 04             	sub    $0x4,%esp
  8027a4:	50                   	push   %eax
  8027a5:	52                   	push   %edx
  8027a6:	ff 75 cc             	pushl  -0x34(%ebp)
  8027a9:	e8 cf 06 00 00       	call   802e7d <sys_move_user_mem>
  8027ae:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  8027b1:	83 ec 0c             	sub    $0xc,%esp
  8027b4:	ff 75 08             	pushl  0x8(%ebp)
  8027b7:	e8 2e ef ff ff       	call   8016ea <free>
  8027bc:	83 c4 10             	add    $0x10,%esp
	return newptr;
  8027bf:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  8027d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8027d4:	0f 84 33 03 00 00    	je     802b0d <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  8027da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027dd:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  8027e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  8027e5:	83 ec 08             	sub    $0x8,%esp
  8027e8:	ff 75 08             	pushl  0x8(%ebp)
  8027eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8027ee:	e8 7d 05 00 00       	call   802d70 <sys_delete_shared_object>
  8027f3:	83 c4 10             	add    $0x10,%esp
  8027f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  8027f9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8027fd:	0f 88 0d 03 00 00    	js     802b10 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802803:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80280a:	e9 ef 02 00 00       	jmp    802afe <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80280f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802812:	89 d0                	mov    %edx,%eax
  802814:	01 c0                	add    %eax,%eax
  802816:	01 d0                	add    %edx,%eax
  802818:	c1 e0 02             	shl    $0x2,%eax
  80281b:	05 48 50 80 00       	add    $0x805048,%eax
  802820:	8a 00                	mov    (%eax),%al
  802822:	84 c0                	test   %al,%al
  802824:	0f 84 d1 02 00 00    	je     802afb <sfree+0x337>
  80282a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282d:	89 d0                	mov    %edx,%eax
  80282f:	01 c0                	add    %eax,%eax
  802831:	01 d0                	add    %edx,%eax
  802833:	c1 e0 02             	shl    $0x2,%eax
  802836:	05 40 50 80 00       	add    $0x805040,%eax
  80283b:	8b 00                	mov    (%eax),%eax
  80283d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802840:	0f 85 b5 02 00 00    	jne    802afb <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802846:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802849:	89 d0                	mov    %edx,%eax
  80284b:	01 c0                	add    %eax,%eax
  80284d:	01 d0                	add    %edx,%eax
  80284f:	c1 e0 02             	shl    $0x2,%eax
  802852:	05 44 50 80 00       	add    $0x805044,%eax
  802857:	8b 00                	mov    (%eax),%eax
  802859:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  80285c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285f:	89 d0                	mov    %edx,%eax
  802861:	01 c0                	add    %eax,%eax
  802863:	01 d0                	add    %edx,%eax
  802865:	c1 e0 02             	shl    $0x2,%eax
  802868:	05 48 50 80 00       	add    $0x805048,%eax
  80286d:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802870:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802877:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80287e:	eb 64                	jmp    8028e4 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802880:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802883:	89 d0                	mov    %edx,%eax
  802885:	01 c0                	add    %eax,%eax
  802887:	01 d0                	add    %edx,%eax
  802889:	c1 e0 02             	shl    $0x2,%eax
  80288c:	05 48 10 81 00       	add    $0x811048,%eax
  802891:	8a 00                	mov    (%eax),%al
  802893:	84 c0                	test   %al,%al
  802895:	75 4a                	jne    8028e1 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802897:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80289a:	89 d0                	mov    %edx,%eax
  80289c:	01 c0                	add    %eax,%eax
  80289e:	01 d0                	add    %edx,%eax
  8028a0:	c1 e0 02             	shl    $0x2,%eax
  8028a3:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  8028a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028ac:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  8028ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028b1:	89 d0                	mov    %edx,%eax
  8028b3:	01 c0                	add    %eax,%eax
  8028b5:	01 d0                	add    %edx,%eax
  8028b7:	c1 e0 02             	shl    $0x2,%eax
  8028ba:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  8028c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028c3:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  8028c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c8:	89 d0                	mov    %edx,%eax
  8028ca:	01 c0                	add    %eax,%eax
  8028cc:	01 d0                	add    %edx,%eax
  8028ce:	c1 e0 02             	shl    $0x2,%eax
  8028d1:	05 48 10 81 00       	add    $0x811048,%eax
  8028d6:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  8028d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  8028df:	eb 0c                	jmp    8028ed <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8028e1:	ff 45 ec             	incl   -0x14(%ebp)
  8028e4:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8028eb:	7e 93                	jle    802880 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  8028ed:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8028f1:	0f 84 8d 01 00 00    	je     802a84 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8028f7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8028fe:	e9 74 01 00 00       	jmp    802a77 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802903:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802906:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802909:	0f 84 64 01 00 00    	je     802a73 <sfree+0x2af>
					if (uhp_frees[k].free)
  80290f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802912:	89 d0                	mov    %edx,%eax
  802914:	01 c0                	add    %eax,%eax
  802916:	01 d0                	add    %edx,%eax
  802918:	c1 e0 02             	shl    $0x2,%eax
  80291b:	05 48 10 81 00       	add    $0x811048,%eax
  802920:	8a 00                	mov    (%eax),%al
  802922:	84 c0                	test   %al,%al
  802924:	0f 84 4a 01 00 00    	je     802a74 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80292a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80292d:	89 d0                	mov    %edx,%eax
  80292f:	01 c0                	add    %eax,%eax
  802931:	01 d0                	add    %edx,%eax
  802933:	c1 e0 02             	shl    $0x2,%eax
  802936:	05 40 10 81 00       	add    $0x811040,%eax
  80293b:	8b 08                	mov    (%eax),%ecx
  80293d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802940:	89 d0                	mov    %edx,%eax
  802942:	01 c0                	add    %eax,%eax
  802944:	01 d0                	add    %edx,%eax
  802946:	c1 e0 02             	shl    $0x2,%eax
  802949:	05 44 10 81 00       	add    $0x811044,%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	01 c1                	add    %eax,%ecx
  802952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802955:	89 d0                	mov    %edx,%eax
  802957:	01 c0                	add    %eax,%eax
  802959:	01 d0                	add    %edx,%eax
  80295b:	c1 e0 02             	shl    $0x2,%eax
  80295e:	05 40 10 81 00       	add    $0x811040,%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	39 c1                	cmp    %eax,%ecx
  802967:	75 7a                	jne    8029e3 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802969:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80296c:	89 d0                	mov    %edx,%eax
  80296e:	01 c0                	add    %eax,%eax
  802970:	01 d0                	add    %edx,%eax
  802972:	c1 e0 02             	shl    $0x2,%eax
  802975:	05 40 10 81 00       	add    $0x811040,%eax
  80297a:	8b 10                	mov    (%eax),%edx
  80297c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80297f:	89 c8                	mov    %ecx,%eax
  802981:	01 c0                	add    %eax,%eax
  802983:	01 c8                	add    %ecx,%eax
  802985:	c1 e0 02             	shl    $0x2,%eax
  802988:	05 40 10 81 00       	add    $0x811040,%eax
  80298d:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  80298f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802992:	89 d0                	mov    %edx,%eax
  802994:	01 c0                	add    %eax,%eax
  802996:	01 d0                	add    %edx,%eax
  802998:	c1 e0 02             	shl    $0x2,%eax
  80299b:	05 44 10 81 00       	add    $0x811044,%eax
  8029a0:	8b 08                	mov    (%eax),%ecx
  8029a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029a5:	89 d0                	mov    %edx,%eax
  8029a7:	01 c0                	add    %eax,%eax
  8029a9:	01 d0                	add    %edx,%eax
  8029ab:	c1 e0 02             	shl    $0x2,%eax
  8029ae:	05 44 10 81 00       	add    $0x811044,%eax
  8029b3:	8b 00                	mov    (%eax),%eax
  8029b5:	01 c1                	add    %eax,%ecx
  8029b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ba:	89 d0                	mov    %edx,%eax
  8029bc:	01 c0                	add    %eax,%eax
  8029be:	01 d0                	add    %edx,%eax
  8029c0:	c1 e0 02             	shl    $0x2,%eax
  8029c3:	05 44 10 81 00       	add    $0x811044,%eax
  8029c8:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8029ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029cd:	89 d0                	mov    %edx,%eax
  8029cf:	01 c0                	add    %eax,%eax
  8029d1:	01 d0                	add    %edx,%eax
  8029d3:	c1 e0 02             	shl    $0x2,%eax
  8029d6:	05 48 10 81 00       	add    $0x811048,%eax
  8029db:	c6 00 00             	movb   $0x0,(%eax)
  8029de:	e9 91 00 00 00       	jmp    802a74 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8029e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e6:	89 d0                	mov    %edx,%eax
  8029e8:	01 c0                	add    %eax,%eax
  8029ea:	01 d0                	add    %edx,%eax
  8029ec:	c1 e0 02             	shl    $0x2,%eax
  8029ef:	05 40 10 81 00       	add    $0x811040,%eax
  8029f4:	8b 08                	mov    (%eax),%ecx
  8029f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f9:	89 d0                	mov    %edx,%eax
  8029fb:	01 c0                	add    %eax,%eax
  8029fd:	01 d0                	add    %edx,%eax
  8029ff:	c1 e0 02             	shl    $0x2,%eax
  802a02:	05 44 10 81 00       	add    $0x811044,%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	01 c1                	add    %eax,%ecx
  802a0b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a0e:	89 d0                	mov    %edx,%eax
  802a10:	01 c0                	add    %eax,%eax
  802a12:	01 d0                	add    %edx,%eax
  802a14:	c1 e0 02             	shl    $0x2,%eax
  802a17:	05 40 10 81 00       	add    $0x811040,%eax
  802a1c:	8b 00                	mov    (%eax),%eax
  802a1e:	39 c1                	cmp    %eax,%ecx
  802a20:	75 52                	jne    802a74 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802a22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a25:	89 d0                	mov    %edx,%eax
  802a27:	01 c0                	add    %eax,%eax
  802a29:	01 d0                	add    %edx,%eax
  802a2b:	c1 e0 02             	shl    $0x2,%eax
  802a2e:	05 44 10 81 00       	add    $0x811044,%eax
  802a33:	8b 08                	mov    (%eax),%ecx
  802a35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a38:	89 d0                	mov    %edx,%eax
  802a3a:	01 c0                	add    %eax,%eax
  802a3c:	01 d0                	add    %edx,%eax
  802a3e:	c1 e0 02             	shl    $0x2,%eax
  802a41:	05 44 10 81 00       	add    $0x811044,%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	01 c1                	add    %eax,%ecx
  802a4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a4d:	89 d0                	mov    %edx,%eax
  802a4f:	01 c0                	add    %eax,%eax
  802a51:	01 d0                	add    %edx,%eax
  802a53:	c1 e0 02             	shl    $0x2,%eax
  802a56:	05 44 10 81 00       	add    $0x811044,%eax
  802a5b:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802a5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a60:	89 d0                	mov    %edx,%eax
  802a62:	01 c0                	add    %eax,%eax
  802a64:	01 d0                	add    %edx,%eax
  802a66:	c1 e0 02             	shl    $0x2,%eax
  802a69:	05 48 10 81 00       	add    $0x811048,%eax
  802a6e:	c6 00 00             	movb   $0x0,(%eax)
  802a71:	eb 01                	jmp    802a74 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802a73:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802a74:	ff 45 e8             	incl   -0x18(%ebp)
  802a77:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802a7e:	0f 8e 7f fe ff ff    	jle    802903 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802a84:	a1 30 51 83 00       	mov    0x835130,%eax
  802a89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802a8c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802a93:	eb 53                	jmp    802ae8 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802a95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a98:	89 d0                	mov    %edx,%eax
  802a9a:	01 c0                	add    %eax,%eax
  802a9c:	01 d0                	add    %edx,%eax
  802a9e:	c1 e0 02             	shl    $0x2,%eax
  802aa1:	05 48 50 80 00       	add    $0x805048,%eax
  802aa6:	8a 00                	mov    (%eax),%al
  802aa8:	84 c0                	test   %al,%al
  802aaa:	74 39                	je     802ae5 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802aac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802aaf:	89 d0                	mov    %edx,%eax
  802ab1:	01 c0                	add    %eax,%eax
  802ab3:	01 d0                	add    %edx,%eax
  802ab5:	c1 e0 02             	shl    $0x2,%eax
  802ab8:	05 40 50 80 00       	add    $0x805040,%eax
  802abd:	8b 08                	mov    (%eax),%ecx
  802abf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ac2:	89 d0                	mov    %edx,%eax
  802ac4:	01 c0                	add    %eax,%eax
  802ac6:	01 d0                	add    %edx,%eax
  802ac8:	c1 e0 02             	shl    $0x2,%eax
  802acb:	05 44 50 80 00       	add    $0x805044,%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	01 c8                	add    %ecx,%eax
  802ad4:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802ad7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ada:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802add:	76 06                	jbe    802ae5 <sfree+0x321>
  802adf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802ae5:	ff 45 e0             	incl   -0x20(%ebp)
  802ae8:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802aef:	7e a4                	jle    802a95 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802af1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af4:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802af9:	eb 16                	jmp    802b11 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802afb:	ff 45 f4             	incl   -0xc(%ebp)
  802afe:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802b05:	0f 8e 04 fd ff ff    	jle    80280f <sfree+0x4b>
  802b0b:	eb 04                	jmp    802b11 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802b0d:	90                   	nop
  802b0e:	eb 01                	jmp    802b11 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802b10:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802b11:	c9                   	leave  
  802b12:	c3                   	ret    

00802b13 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802b13:	55                   	push   %ebp
  802b14:	89 e5                	mov    %esp,%ebp
  802b16:	57                   	push   %edi
  802b17:	56                   	push   %esi
  802b18:	53                   	push   %ebx
  802b19:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b25:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b28:	8b 7d 18             	mov    0x18(%ebp),%edi
  802b2b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802b2e:	cd 30                	int    $0x30
  802b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802b36:	83 c4 10             	add    $0x10,%esp
  802b39:	5b                   	pop    %ebx
  802b3a:	5e                   	pop    %esi
  802b3b:	5f                   	pop    %edi
  802b3c:	5d                   	pop    %ebp
  802b3d:	c3                   	ret    

00802b3e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802b3e:	55                   	push   %ebp
  802b3f:	89 e5                	mov    %esp,%ebp
  802b41:	83 ec 04             	sub    $0x4,%esp
  802b44:	8b 45 10             	mov    0x10(%ebp),%eax
  802b47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802b4a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b4d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	6a 00                	push   $0x0
  802b56:	51                   	push   %ecx
  802b57:	52                   	push   %edx
  802b58:	ff 75 0c             	pushl  0xc(%ebp)
  802b5b:	50                   	push   %eax
  802b5c:	6a 00                	push   $0x0
  802b5e:	e8 b0 ff ff ff       	call   802b13 <syscall>
  802b63:	83 c4 18             	add    $0x18,%esp
}
  802b66:	90                   	nop
  802b67:	c9                   	leave  
  802b68:	c3                   	ret    

00802b69 <sys_cgetc>:

int
sys_cgetc(void)
{
  802b69:	55                   	push   %ebp
  802b6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 02                	push   $0x2
  802b78:	e8 96 ff ff ff       	call   802b13 <syscall>
  802b7d:	83 c4 18             	add    $0x18,%esp
}
  802b80:	c9                   	leave  
  802b81:	c3                   	ret    

00802b82 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802b82:	55                   	push   %ebp
  802b83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 00                	push   $0x0
  802b8d:	6a 00                	push   $0x0
  802b8f:	6a 03                	push   $0x3
  802b91:	e8 7d ff ff ff       	call   802b13 <syscall>
  802b96:	83 c4 18             	add    $0x18,%esp
}
  802b99:	90                   	nop
  802b9a:	c9                   	leave  
  802b9b:	c3                   	ret    

00802b9c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802b9c:	55                   	push   %ebp
  802b9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802b9f:	6a 00                	push   $0x0
  802ba1:	6a 00                	push   $0x0
  802ba3:	6a 00                	push   $0x0
  802ba5:	6a 00                	push   $0x0
  802ba7:	6a 00                	push   $0x0
  802ba9:	6a 04                	push   $0x4
  802bab:	e8 63 ff ff ff       	call   802b13 <syscall>
  802bb0:	83 c4 18             	add    $0x18,%esp
}
  802bb3:	90                   	nop
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 00                	push   $0x0
  802bc5:	52                   	push   %edx
  802bc6:	50                   	push   %eax
  802bc7:	6a 08                	push   $0x8
  802bc9:	e8 45 ff ff ff       	call   802b13 <syscall>
  802bce:	83 c4 18             	add    $0x18,%esp
}
  802bd1:	c9                   	leave  
  802bd2:	c3                   	ret    

00802bd3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802bd3:	55                   	push   %ebp
  802bd4:	89 e5                	mov    %esp,%ebp
  802bd6:	56                   	push   %esi
  802bd7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802bd8:	8b 75 18             	mov    0x18(%ebp),%esi
  802bdb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802bde:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	56                   	push   %esi
  802be8:	53                   	push   %ebx
  802be9:	51                   	push   %ecx
  802bea:	52                   	push   %edx
  802beb:	50                   	push   %eax
  802bec:	6a 09                	push   $0x9
  802bee:	e8 20 ff ff ff       	call   802b13 <syscall>
  802bf3:	83 c4 18             	add    $0x18,%esp
}
  802bf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802bf9:	5b                   	pop    %ebx
  802bfa:	5e                   	pop    %esi
  802bfb:	5d                   	pop    %ebp
  802bfc:	c3                   	ret    

00802bfd <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802bfd:	55                   	push   %ebp
  802bfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802c00:	6a 00                	push   $0x0
  802c02:	6a 00                	push   $0x0
  802c04:	6a 00                	push   $0x0
  802c06:	6a 00                	push   $0x0
  802c08:	ff 75 08             	pushl  0x8(%ebp)
  802c0b:	6a 0a                	push   $0xa
  802c0d:	e8 01 ff ff ff       	call   802b13 <syscall>
  802c12:	83 c4 18             	add    $0x18,%esp
}
  802c15:	c9                   	leave  
  802c16:	c3                   	ret    

00802c17 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802c17:	55                   	push   %ebp
  802c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802c1a:	6a 00                	push   $0x0
  802c1c:	6a 00                	push   $0x0
  802c1e:	6a 00                	push   $0x0
  802c20:	ff 75 0c             	pushl  0xc(%ebp)
  802c23:	ff 75 08             	pushl  0x8(%ebp)
  802c26:	6a 0b                	push   $0xb
  802c28:	e8 e6 fe ff ff       	call   802b13 <syscall>
  802c2d:	83 c4 18             	add    $0x18,%esp
}
  802c30:	c9                   	leave  
  802c31:	c3                   	ret    

00802c32 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802c32:	55                   	push   %ebp
  802c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802c35:	6a 00                	push   $0x0
  802c37:	6a 00                	push   $0x0
  802c39:	6a 00                	push   $0x0
  802c3b:	6a 00                	push   $0x0
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 0c                	push   $0xc
  802c41:	e8 cd fe ff ff       	call   802b13 <syscall>
  802c46:	83 c4 18             	add    $0x18,%esp
}
  802c49:	c9                   	leave  
  802c4a:	c3                   	ret    

00802c4b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802c4b:	55                   	push   %ebp
  802c4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802c4e:	6a 00                	push   $0x0
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	6a 00                	push   $0x0
  802c56:	6a 00                	push   $0x0
  802c58:	6a 0d                	push   $0xd
  802c5a:	e8 b4 fe ff ff       	call   802b13 <syscall>
  802c5f:	83 c4 18             	add    $0x18,%esp
}
  802c62:	c9                   	leave  
  802c63:	c3                   	ret    

00802c64 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802c64:	55                   	push   %ebp
  802c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802c67:	6a 00                	push   $0x0
  802c69:	6a 00                	push   $0x0
  802c6b:	6a 00                	push   $0x0
  802c6d:	6a 00                	push   $0x0
  802c6f:	6a 00                	push   $0x0
  802c71:	6a 0e                	push   $0xe
  802c73:	e8 9b fe ff ff       	call   802b13 <syscall>
  802c78:	83 c4 18             	add    $0x18,%esp
}
  802c7b:	c9                   	leave  
  802c7c:	c3                   	ret    

00802c7d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802c7d:	55                   	push   %ebp
  802c7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802c80:	6a 00                	push   $0x0
  802c82:	6a 00                	push   $0x0
  802c84:	6a 00                	push   $0x0
  802c86:	6a 00                	push   $0x0
  802c88:	6a 00                	push   $0x0
  802c8a:	6a 0f                	push   $0xf
  802c8c:	e8 82 fe ff ff       	call   802b13 <syscall>
  802c91:	83 c4 18             	add    $0x18,%esp
}
  802c94:	c9                   	leave  
  802c95:	c3                   	ret    

00802c96 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802c96:	55                   	push   %ebp
  802c97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802c99:	6a 00                	push   $0x0
  802c9b:	6a 00                	push   $0x0
  802c9d:	6a 00                	push   $0x0
  802c9f:	6a 00                	push   $0x0
  802ca1:	ff 75 08             	pushl  0x8(%ebp)
  802ca4:	6a 10                	push   $0x10
  802ca6:	e8 68 fe ff ff       	call   802b13 <syscall>
  802cab:	83 c4 18             	add    $0x18,%esp
}
  802cae:	c9                   	leave  
  802caf:	c3                   	ret    

00802cb0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802cb0:	55                   	push   %ebp
  802cb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802cb3:	6a 00                	push   $0x0
  802cb5:	6a 00                	push   $0x0
  802cb7:	6a 00                	push   $0x0
  802cb9:	6a 00                	push   $0x0
  802cbb:	6a 00                	push   $0x0
  802cbd:	6a 11                	push   $0x11
  802cbf:	e8 4f fe ff ff       	call   802b13 <syscall>
  802cc4:	83 c4 18             	add    $0x18,%esp
}
  802cc7:	90                   	nop
  802cc8:	c9                   	leave  
  802cc9:	c3                   	ret    

00802cca <sys_cputc>:

void
sys_cputc(const char c)
{
  802cca:	55                   	push   %ebp
  802ccb:	89 e5                	mov    %esp,%ebp
  802ccd:	83 ec 04             	sub    $0x4,%esp
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802cd6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802cda:	6a 00                	push   $0x0
  802cdc:	6a 00                	push   $0x0
  802cde:	6a 00                	push   $0x0
  802ce0:	6a 00                	push   $0x0
  802ce2:	50                   	push   %eax
  802ce3:	6a 01                	push   $0x1
  802ce5:	e8 29 fe ff ff       	call   802b13 <syscall>
  802cea:	83 c4 18             	add    $0x18,%esp
}
  802ced:	90                   	nop
  802cee:	c9                   	leave  
  802cef:	c3                   	ret    

00802cf0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802cf0:	55                   	push   %ebp
  802cf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 00                	push   $0x0
  802cf9:	6a 00                	push   $0x0
  802cfb:	6a 00                	push   $0x0
  802cfd:	6a 14                	push   $0x14
  802cff:	e8 0f fe ff ff       	call   802b13 <syscall>
  802d04:	83 c4 18             	add    $0x18,%esp
}
  802d07:	90                   	nop
  802d08:	c9                   	leave  
  802d09:	c3                   	ret    

00802d0a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802d0a:	55                   	push   %ebp
  802d0b:	89 e5                	mov    %esp,%ebp
  802d0d:	83 ec 04             	sub    $0x4,%esp
  802d10:	8b 45 10             	mov    0x10(%ebp),%eax
  802d13:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802d16:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d19:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	6a 00                	push   $0x0
  802d22:	51                   	push   %ecx
  802d23:	52                   	push   %edx
  802d24:	ff 75 0c             	pushl  0xc(%ebp)
  802d27:	50                   	push   %eax
  802d28:	6a 15                	push   $0x15
  802d2a:	e8 e4 fd ff ff       	call   802b13 <syscall>
  802d2f:	83 c4 18             	add    $0x18,%esp
}
  802d32:	c9                   	leave  
  802d33:	c3                   	ret    

00802d34 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802d34:	55                   	push   %ebp
  802d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	6a 00                	push   $0x0
  802d3f:	6a 00                	push   $0x0
  802d41:	6a 00                	push   $0x0
  802d43:	52                   	push   %edx
  802d44:	50                   	push   %eax
  802d45:	6a 16                	push   $0x16
  802d47:	e8 c7 fd ff ff       	call   802b13 <syscall>
  802d4c:	83 c4 18             	add    $0x18,%esp
}
  802d4f:	c9                   	leave  
  802d50:	c3                   	ret    

00802d51 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  802d51:	55                   	push   %ebp
  802d52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802d54:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	6a 00                	push   $0x0
  802d5f:	6a 00                	push   $0x0
  802d61:	51                   	push   %ecx
  802d62:	52                   	push   %edx
  802d63:	50                   	push   %eax
  802d64:	6a 17                	push   $0x17
  802d66:	e8 a8 fd ff ff       	call   802b13 <syscall>
  802d6b:	83 c4 18             	add    $0x18,%esp
}
  802d6e:	c9                   	leave  
  802d6f:	c3                   	ret    

00802d70 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  802d70:	55                   	push   %ebp
  802d71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	6a 00                	push   $0x0
  802d7b:	6a 00                	push   $0x0
  802d7d:	6a 00                	push   $0x0
  802d7f:	52                   	push   %edx
  802d80:	50                   	push   %eax
  802d81:	6a 18                	push   $0x18
  802d83:	e8 8b fd ff ff       	call   802b13 <syscall>
  802d88:	83 c4 18             	add    $0x18,%esp
}
  802d8b:	c9                   	leave  
  802d8c:	c3                   	ret    

00802d8d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802d8d:	55                   	push   %ebp
  802d8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	6a 00                	push   $0x0
  802d95:	ff 75 14             	pushl  0x14(%ebp)
  802d98:	ff 75 10             	pushl  0x10(%ebp)
  802d9b:	ff 75 0c             	pushl  0xc(%ebp)
  802d9e:	50                   	push   %eax
  802d9f:	6a 19                	push   $0x19
  802da1:	e8 6d fd ff ff       	call   802b13 <syscall>
  802da6:	83 c4 18             	add    $0x18,%esp
}
  802da9:	c9                   	leave  
  802daa:	c3                   	ret    

00802dab <sys_run_env>:

void sys_run_env(int32 envId)
{
  802dab:	55                   	push   %ebp
  802dac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	6a 00                	push   $0x0
  802db3:	6a 00                	push   $0x0
  802db5:	6a 00                	push   $0x0
  802db7:	6a 00                	push   $0x0
  802db9:	50                   	push   %eax
  802dba:	6a 1a                	push   $0x1a
  802dbc:	e8 52 fd ff ff       	call   802b13 <syscall>
  802dc1:	83 c4 18             	add    $0x18,%esp
}
  802dc4:	90                   	nop
  802dc5:	c9                   	leave  
  802dc6:	c3                   	ret    

00802dc7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802dc7:	55                   	push   %ebp
  802dc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	6a 00                	push   $0x0
  802dcf:	6a 00                	push   $0x0
  802dd1:	6a 00                	push   $0x0
  802dd3:	6a 00                	push   $0x0
  802dd5:	50                   	push   %eax
  802dd6:	6a 1b                	push   $0x1b
  802dd8:	e8 36 fd ff ff       	call   802b13 <syscall>
  802ddd:	83 c4 18             	add    $0x18,%esp
}
  802de0:	c9                   	leave  
  802de1:	c3                   	ret    

00802de2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802de2:	55                   	push   %ebp
  802de3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802de5:	6a 00                	push   $0x0
  802de7:	6a 00                	push   $0x0
  802de9:	6a 00                	push   $0x0
  802deb:	6a 00                	push   $0x0
  802ded:	6a 00                	push   $0x0
  802def:	6a 05                	push   $0x5
  802df1:	e8 1d fd ff ff       	call   802b13 <syscall>
  802df6:	83 c4 18             	add    $0x18,%esp
}
  802df9:	c9                   	leave  
  802dfa:	c3                   	ret    

00802dfb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802dfb:	55                   	push   %ebp
  802dfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802dfe:	6a 00                	push   $0x0
  802e00:	6a 00                	push   $0x0
  802e02:	6a 00                	push   $0x0
  802e04:	6a 00                	push   $0x0
  802e06:	6a 00                	push   $0x0
  802e08:	6a 06                	push   $0x6
  802e0a:	e8 04 fd ff ff       	call   802b13 <syscall>
  802e0f:	83 c4 18             	add    $0x18,%esp
}
  802e12:	c9                   	leave  
  802e13:	c3                   	ret    

00802e14 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802e14:	55                   	push   %ebp
  802e15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802e17:	6a 00                	push   $0x0
  802e19:	6a 00                	push   $0x0
  802e1b:	6a 00                	push   $0x0
  802e1d:	6a 00                	push   $0x0
  802e1f:	6a 00                	push   $0x0
  802e21:	6a 07                	push   $0x7
  802e23:	e8 eb fc ff ff       	call   802b13 <syscall>
  802e28:	83 c4 18             	add    $0x18,%esp
}
  802e2b:	c9                   	leave  
  802e2c:	c3                   	ret    

00802e2d <sys_exit_env>:


void sys_exit_env(void)
{
  802e2d:	55                   	push   %ebp
  802e2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802e30:	6a 00                	push   $0x0
  802e32:	6a 00                	push   $0x0
  802e34:	6a 00                	push   $0x0
  802e36:	6a 00                	push   $0x0
  802e38:	6a 00                	push   $0x0
  802e3a:	6a 1c                	push   $0x1c
  802e3c:	e8 d2 fc ff ff       	call   802b13 <syscall>
  802e41:	83 c4 18             	add    $0x18,%esp
}
  802e44:	90                   	nop
  802e45:	c9                   	leave  
  802e46:	c3                   	ret    

00802e47 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802e47:	55                   	push   %ebp
  802e48:	89 e5                	mov    %esp,%ebp
  802e4a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802e4d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e50:	8d 50 04             	lea    0x4(%eax),%edx
  802e53:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e56:	6a 00                	push   $0x0
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 00                	push   $0x0
  802e5c:	52                   	push   %edx
  802e5d:	50                   	push   %eax
  802e5e:	6a 1d                	push   $0x1d
  802e60:	e8 ae fc ff ff       	call   802b13 <syscall>
  802e65:	83 c4 18             	add    $0x18,%esp
	return result;
  802e68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802e71:	89 01                	mov    %eax,(%ecx)
  802e73:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	c9                   	leave  
  802e7a:	c2 04 00             	ret    $0x4

00802e7d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802e7d:	55                   	push   %ebp
  802e7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802e80:	6a 00                	push   $0x0
  802e82:	6a 00                	push   $0x0
  802e84:	ff 75 10             	pushl  0x10(%ebp)
  802e87:	ff 75 0c             	pushl  0xc(%ebp)
  802e8a:	ff 75 08             	pushl  0x8(%ebp)
  802e8d:	6a 13                	push   $0x13
  802e8f:	e8 7f fc ff ff       	call   802b13 <syscall>
  802e94:	83 c4 18             	add    $0x18,%esp
	return ;
  802e97:	90                   	nop
}
  802e98:	c9                   	leave  
  802e99:	c3                   	ret    

00802e9a <sys_rcr2>:
uint32 sys_rcr2()
{
  802e9a:	55                   	push   %ebp
  802e9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e9d:	6a 00                	push   $0x0
  802e9f:	6a 00                	push   $0x0
  802ea1:	6a 00                	push   $0x0
  802ea3:	6a 00                	push   $0x0
  802ea5:	6a 00                	push   $0x0
  802ea7:	6a 1e                	push   $0x1e
  802ea9:	e8 65 fc ff ff       	call   802b13 <syscall>
  802eae:	83 c4 18             	add    $0x18,%esp
}
  802eb1:	c9                   	leave  
  802eb2:	c3                   	ret    

00802eb3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802eb3:	55                   	push   %ebp
  802eb4:	89 e5                	mov    %esp,%ebp
  802eb6:	83 ec 04             	sub    $0x4,%esp
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ebf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ec3:	6a 00                	push   $0x0
  802ec5:	6a 00                	push   $0x0
  802ec7:	6a 00                	push   $0x0
  802ec9:	6a 00                	push   $0x0
  802ecb:	50                   	push   %eax
  802ecc:	6a 1f                	push   $0x1f
  802ece:	e8 40 fc ff ff       	call   802b13 <syscall>
  802ed3:	83 c4 18             	add    $0x18,%esp
	return ;
  802ed6:	90                   	nop
}
  802ed7:	c9                   	leave  
  802ed8:	c3                   	ret    

00802ed9 <rsttst>:
void rsttst()
{
  802ed9:	55                   	push   %ebp
  802eda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802edc:	6a 00                	push   $0x0
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	6a 00                	push   $0x0
  802ee4:	6a 00                	push   $0x0
  802ee6:	6a 21                	push   $0x21
  802ee8:	e8 26 fc ff ff       	call   802b13 <syscall>
  802eed:	83 c4 18             	add    $0x18,%esp
	return ;
  802ef0:	90                   	nop
}
  802ef1:	c9                   	leave  
  802ef2:	c3                   	ret    

00802ef3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ef3:	55                   	push   %ebp
  802ef4:	89 e5                	mov    %esp,%ebp
  802ef6:	83 ec 04             	sub    $0x4,%esp
  802ef9:	8b 45 14             	mov    0x14(%ebp),%eax
  802efc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802eff:	8b 55 18             	mov    0x18(%ebp),%edx
  802f02:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f06:	52                   	push   %edx
  802f07:	50                   	push   %eax
  802f08:	ff 75 10             	pushl  0x10(%ebp)
  802f0b:	ff 75 0c             	pushl  0xc(%ebp)
  802f0e:	ff 75 08             	pushl  0x8(%ebp)
  802f11:	6a 20                	push   $0x20
  802f13:	e8 fb fb ff ff       	call   802b13 <syscall>
  802f18:	83 c4 18             	add    $0x18,%esp
	return ;
  802f1b:	90                   	nop
}
  802f1c:	c9                   	leave  
  802f1d:	c3                   	ret    

00802f1e <chktst>:
void chktst(uint32 n)
{
  802f1e:	55                   	push   %ebp
  802f1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802f21:	6a 00                	push   $0x0
  802f23:	6a 00                	push   $0x0
  802f25:	6a 00                	push   $0x0
  802f27:	6a 00                	push   $0x0
  802f29:	ff 75 08             	pushl  0x8(%ebp)
  802f2c:	6a 22                	push   $0x22
  802f2e:	e8 e0 fb ff ff       	call   802b13 <syscall>
  802f33:	83 c4 18             	add    $0x18,%esp
	return ;
  802f36:	90                   	nop
}
  802f37:	c9                   	leave  
  802f38:	c3                   	ret    

00802f39 <inctst>:

void inctst()
{
  802f39:	55                   	push   %ebp
  802f3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802f3c:	6a 00                	push   $0x0
  802f3e:	6a 00                	push   $0x0
  802f40:	6a 00                	push   $0x0
  802f42:	6a 00                	push   $0x0
  802f44:	6a 00                	push   $0x0
  802f46:	6a 23                	push   $0x23
  802f48:	e8 c6 fb ff ff       	call   802b13 <syscall>
  802f4d:	83 c4 18             	add    $0x18,%esp
	return ;
  802f50:	90                   	nop
}
  802f51:	c9                   	leave  
  802f52:	c3                   	ret    

00802f53 <gettst>:
uint32 gettst()
{
  802f53:	55                   	push   %ebp
  802f54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802f56:	6a 00                	push   $0x0
  802f58:	6a 00                	push   $0x0
  802f5a:	6a 00                	push   $0x0
  802f5c:	6a 00                	push   $0x0
  802f5e:	6a 00                	push   $0x0
  802f60:	6a 24                	push   $0x24
  802f62:	e8 ac fb ff ff       	call   802b13 <syscall>
  802f67:	83 c4 18             	add    $0x18,%esp
}
  802f6a:	c9                   	leave  
  802f6b:	c3                   	ret    

00802f6c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802f6c:	55                   	push   %ebp
  802f6d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f6f:	6a 00                	push   $0x0
  802f71:	6a 00                	push   $0x0
  802f73:	6a 00                	push   $0x0
  802f75:	6a 00                	push   $0x0
  802f77:	6a 00                	push   $0x0
  802f79:	6a 25                	push   $0x25
  802f7b:	e8 93 fb ff ff       	call   802b13 <syscall>
  802f80:	83 c4 18             	add    $0x18,%esp
  802f83:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  802f88:	a1 80 50 83 00       	mov    0x835080,%eax
}
  802f8d:	c9                   	leave  
  802f8e:	c3                   	ret    

00802f8f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f8f:	55                   	push   %ebp
  802f90:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f9a:	6a 00                	push   $0x0
  802f9c:	6a 00                	push   $0x0
  802f9e:	6a 00                	push   $0x0
  802fa0:	6a 00                	push   $0x0
  802fa2:	ff 75 08             	pushl  0x8(%ebp)
  802fa5:	6a 26                	push   $0x26
  802fa7:	e8 67 fb ff ff       	call   802b13 <syscall>
  802fac:	83 c4 18             	add    $0x18,%esp
	return ;
  802faf:	90                   	nop
}
  802fb0:	c9                   	leave  
  802fb1:	c3                   	ret    

00802fb2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802fb2:	55                   	push   %ebp
  802fb3:	89 e5                	mov    %esp,%ebp
  802fb5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802fb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	6a 00                	push   $0x0
  802fc4:	53                   	push   %ebx
  802fc5:	51                   	push   %ecx
  802fc6:	52                   	push   %edx
  802fc7:	50                   	push   %eax
  802fc8:	6a 27                	push   $0x27
  802fca:	e8 44 fb ff ff       	call   802b13 <syscall>
  802fcf:	83 c4 18             	add    $0x18,%esp
}
  802fd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fd5:	c9                   	leave  
  802fd6:	c3                   	ret    

00802fd7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802fd7:	55                   	push   %ebp
  802fd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 00                	push   $0x0
  802fe4:	6a 00                	push   $0x0
  802fe6:	52                   	push   %edx
  802fe7:	50                   	push   %eax
  802fe8:	6a 28                	push   $0x28
  802fea:	e8 24 fb ff ff       	call   802b13 <syscall>
  802fef:	83 c4 18             	add    $0x18,%esp
}
  802ff2:	c9                   	leave  
  802ff3:	c3                   	ret    

00802ff4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802ff4:	55                   	push   %ebp
  802ff5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802ff7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  803000:	6a 00                	push   $0x0
  803002:	51                   	push   %ecx
  803003:	ff 75 10             	pushl  0x10(%ebp)
  803006:	52                   	push   %edx
  803007:	50                   	push   %eax
  803008:	6a 29                	push   $0x29
  80300a:	e8 04 fb ff ff       	call   802b13 <syscall>
  80300f:	83 c4 18             	add    $0x18,%esp
}
  803012:	c9                   	leave  
  803013:	c3                   	ret    

00803014 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803014:	55                   	push   %ebp
  803015:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803017:	6a 00                	push   $0x0
  803019:	6a 00                	push   $0x0
  80301b:	ff 75 10             	pushl  0x10(%ebp)
  80301e:	ff 75 0c             	pushl  0xc(%ebp)
  803021:	ff 75 08             	pushl  0x8(%ebp)
  803024:	6a 12                	push   $0x12
  803026:	e8 e8 fa ff ff       	call   802b13 <syscall>
  80302b:	83 c4 18             	add    $0x18,%esp
	return ;
  80302e:	90                   	nop
}
  80302f:	c9                   	leave  
  803030:	c3                   	ret    

00803031 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803031:	55                   	push   %ebp
  803032:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803034:	8b 55 0c             	mov    0xc(%ebp),%edx
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	6a 00                	push   $0x0
  80303c:	6a 00                	push   $0x0
  80303e:	6a 00                	push   $0x0
  803040:	52                   	push   %edx
  803041:	50                   	push   %eax
  803042:	6a 2a                	push   $0x2a
  803044:	e8 ca fa ff ff       	call   802b13 <syscall>
  803049:	83 c4 18             	add    $0x18,%esp
	return;
  80304c:	90                   	nop
}
  80304d:	c9                   	leave  
  80304e:	c3                   	ret    

0080304f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80304f:	55                   	push   %ebp
  803050:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803052:	6a 00                	push   $0x0
  803054:	6a 00                	push   $0x0
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	6a 2b                	push   $0x2b
  80305e:	e8 b0 fa ff ff       	call   802b13 <syscall>
  803063:	83 c4 18             	add    $0x18,%esp
}
  803066:	c9                   	leave  
  803067:	c3                   	ret    

00803068 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803068:	55                   	push   %ebp
  803069:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80306b:	6a 00                	push   $0x0
  80306d:	6a 00                	push   $0x0
  80306f:	6a 00                	push   $0x0
  803071:	ff 75 0c             	pushl  0xc(%ebp)
  803074:	ff 75 08             	pushl  0x8(%ebp)
  803077:	6a 2d                	push   $0x2d
  803079:	e8 95 fa ff ff       	call   802b13 <syscall>
  80307e:	83 c4 18             	add    $0x18,%esp
	return;
  803081:	90                   	nop
}
  803082:	c9                   	leave  
  803083:	c3                   	ret    

00803084 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803084:	55                   	push   %ebp
  803085:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803087:	6a 00                	push   $0x0
  803089:	6a 00                	push   $0x0
  80308b:	6a 00                	push   $0x0
  80308d:	ff 75 0c             	pushl  0xc(%ebp)
  803090:	ff 75 08             	pushl  0x8(%ebp)
  803093:	6a 2c                	push   $0x2c
  803095:	e8 79 fa ff ff       	call   802b13 <syscall>
  80309a:	83 c4 18             	add    $0x18,%esp
	return ;
  80309d:	90                   	nop
}
  80309e:	c9                   	leave  
  80309f:	c3                   	ret    

008030a0 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8030a0:	55                   	push   %ebp
  8030a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8030a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	6a 00                	push   $0x0
  8030ab:	6a 00                	push   $0x0
  8030ad:	6a 00                	push   $0x0
  8030af:	52                   	push   %edx
  8030b0:	50                   	push   %eax
  8030b1:	6a 2e                	push   $0x2e
  8030b3:	e8 5b fa ff ff       	call   802b13 <syscall>
  8030b8:	83 c4 18             	add    $0x18,%esp
}
  8030bb:	90                   	nop
  8030bc:	c9                   	leave  
  8030bd:	c3                   	ret    

008030be <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8030be:	55                   	push   %ebp
  8030bf:	89 e5                	mov    %esp,%ebp
  8030c1:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8030c4:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  8030cb:	72 09                	jb     8030d6 <to_page_va+0x18>
  8030cd:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  8030d4:	72 14                	jb     8030ea <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8030d6:	83 ec 04             	sub    $0x4,%esp
  8030d9:	68 98 45 80 00       	push   $0x804598
  8030de:	6a 15                	push   $0x15
  8030e0:	68 c3 45 80 00       	push   $0x8045c3
  8030e5:	e8 68 0a 00 00       	call   803b52 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8030f2:	29 d0                	sub    %edx,%eax
  8030f4:	c1 f8 02             	sar    $0x2,%eax
  8030f7:	89 c2                	mov    %eax,%edx
  8030f9:	89 d0                	mov    %edx,%eax
  8030fb:	c1 e0 02             	shl    $0x2,%eax
  8030fe:	01 d0                	add    %edx,%eax
  803100:	c1 e0 02             	shl    $0x2,%eax
  803103:	01 d0                	add    %edx,%eax
  803105:	c1 e0 02             	shl    $0x2,%eax
  803108:	01 d0                	add    %edx,%eax
  80310a:	89 c1                	mov    %eax,%ecx
  80310c:	c1 e1 08             	shl    $0x8,%ecx
  80310f:	01 c8                	add    %ecx,%eax
  803111:	89 c1                	mov    %eax,%ecx
  803113:	c1 e1 10             	shl    $0x10,%ecx
  803116:	01 c8                	add    %ecx,%eax
  803118:	01 c0                	add    %eax,%eax
  80311a:	01 d0                	add    %edx,%eax
  80311c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803122:	c1 e0 0c             	shl    $0xc,%eax
  803125:	89 c2                	mov    %eax,%edx
  803127:	a1 84 50 83 00       	mov    0x835084,%eax
  80312c:	01 d0                	add    %edx,%eax
}
  80312e:	c9                   	leave  
  80312f:	c3                   	ret    

00803130 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803130:	55                   	push   %ebp
  803131:	89 e5                	mov    %esp,%ebp
  803133:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803136:	a1 84 50 83 00       	mov    0x835084,%eax
  80313b:	8b 55 08             	mov    0x8(%ebp),%edx
  80313e:	29 c2                	sub    %eax,%edx
  803140:	89 d0                	mov    %edx,%eax
  803142:	c1 e8 0c             	shr    $0xc,%eax
  803145:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803148:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314c:	78 09                	js     803157 <to_page_info+0x27>
  80314e:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803155:	7e 14                	jle    80316b <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803157:	83 ec 04             	sub    $0x4,%esp
  80315a:	68 dc 45 80 00       	push   $0x8045dc
  80315f:	6a 21                	push   $0x21
  803161:	68 c3 45 80 00       	push   $0x8045c3
  803166:	e8 e7 09 00 00       	call   803b52 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80316b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80316e:	89 d0                	mov    %edx,%eax
  803170:	01 c0                	add    %eax,%eax
  803172:	01 d0                	add    %edx,%eax
  803174:	c1 e0 02             	shl    $0x2,%eax
  803177:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  80317c:	c9                   	leave  
  80317d:	c3                   	ret    

0080317e <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80317e:	55                   	push   %ebp
  80317f:	89 e5                	mov    %esp,%ebp
  803181:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	05 00 00 00 02       	add    $0x2000000,%eax
  80318c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80318f:	73 16                	jae    8031a7 <initialize_dynamic_allocator+0x29>
  803191:	68 00 46 80 00       	push   $0x804600
  803196:	68 26 46 80 00       	push   $0x804626
  80319b:	6a 2f                	push   $0x2f
  80319d:	68 c3 45 80 00       	push   $0x8045c3
  8031a2:	e8 ab 09 00 00       	call   803b52 <_panic>
	dynAllocStart = daStart;
  8031a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031aa:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  8031af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b2:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8031b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031be:	eb 36                	jmp    8031f6 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c3:	c1 e0 04             	shl    $0x4,%eax
  8031c6:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8031cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d4:	c1 e0 04             	shl    $0x4,%eax
  8031d7:	05 a4 50 83 00       	add    $0x8350a4,%eax
  8031dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e5:	c1 e0 04             	shl    $0x4,%eax
  8031e8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8031ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8031f3:	ff 45 f4             	incl   -0xc(%ebp)
  8031f6:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8031fa:	7e c4                	jle    8031c0 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8031fc:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  803203:	00 00 00 
  803206:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  80320d:	00 00 00 
  803210:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  803217:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80321a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803221:	e9 1b 01 00 00       	jmp    803341 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803226:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803229:	89 d0                	mov    %edx,%eax
  80322b:	01 c0                	add    %eax,%eax
  80322d:	01 d0                	add    %edx,%eax
  80322f:	c1 e0 02             	shl    $0x2,%eax
  803232:	05 88 d0 81 00       	add    $0x81d088,%eax
  803237:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  80323c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80323f:	89 d0                	mov    %edx,%eax
  803241:	01 c0                	add    %eax,%eax
  803243:	01 d0                	add    %edx,%eax
  803245:	c1 e0 02             	shl    $0x2,%eax
  803248:	05 8a d0 81 00       	add    $0x81d08a,%eax
  80324d:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803252:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803255:	89 d0                	mov    %edx,%eax
  803257:	01 c0                	add    %eax,%eax
  803259:	01 d0                	add    %edx,%eax
  80325b:	c1 e0 02             	shl    $0x2,%eax
  80325e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803263:	8b 00                	mov    (%eax),%eax
  803265:	85 c0                	test   %eax,%eax
  803267:	74 2b                	je     803294 <initialize_dynamic_allocator+0x116>
  803269:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80326c:	89 d0                	mov    %edx,%eax
  80326e:	01 c0                	add    %eax,%eax
  803270:	01 d0                	add    %edx,%eax
  803272:	c1 e0 02             	shl    $0x2,%eax
  803275:	05 80 d0 81 00       	add    $0x81d080,%eax
  80327a:	8b 10                	mov    (%eax),%edx
  80327c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80327f:	89 c8                	mov    %ecx,%eax
  803281:	01 c0                	add    %eax,%eax
  803283:	01 c8                	add    %ecx,%eax
  803285:	c1 e0 02             	shl    $0x2,%eax
  803288:	05 84 d0 81 00       	add    $0x81d084,%eax
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	89 42 04             	mov    %eax,0x4(%edx)
  803292:	eb 18                	jmp    8032ac <initialize_dynamic_allocator+0x12e>
  803294:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803297:	89 d0                	mov    %edx,%eax
  803299:	01 c0                	add    %eax,%eax
  80329b:	01 d0                	add    %edx,%eax
  80329d:	c1 e0 02             	shl    $0x2,%eax
  8032a0:	05 84 d0 81 00       	add    $0x81d084,%eax
  8032a5:	8b 00                	mov    (%eax),%eax
  8032a7:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8032ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032af:	89 d0                	mov    %edx,%eax
  8032b1:	01 c0                	add    %eax,%eax
  8032b3:	01 d0                	add    %edx,%eax
  8032b5:	c1 e0 02             	shl    $0x2,%eax
  8032b8:	05 84 d0 81 00       	add    $0x81d084,%eax
  8032bd:	8b 00                	mov    (%eax),%eax
  8032bf:	85 c0                	test   %eax,%eax
  8032c1:	74 2a                	je     8032ed <initialize_dynamic_allocator+0x16f>
  8032c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c6:	89 d0                	mov    %edx,%eax
  8032c8:	01 c0                	add    %eax,%eax
  8032ca:	01 d0                	add    %edx,%eax
  8032cc:	c1 e0 02             	shl    $0x2,%eax
  8032cf:	05 84 d0 81 00       	add    $0x81d084,%eax
  8032d4:	8b 10                	mov    (%eax),%edx
  8032d6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8032d9:	89 c8                	mov    %ecx,%eax
  8032db:	01 c0                	add    %eax,%eax
  8032dd:	01 c8                	add    %ecx,%eax
  8032df:	c1 e0 02             	shl    $0x2,%eax
  8032e2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	89 02                	mov    %eax,(%edx)
  8032eb:	eb 18                	jmp    803305 <initialize_dynamic_allocator+0x187>
  8032ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032f0:	89 d0                	mov    %edx,%eax
  8032f2:	01 c0                	add    %eax,%eax
  8032f4:	01 d0                	add    %edx,%eax
  8032f6:	c1 e0 02             	shl    $0x2,%eax
  8032f9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803305:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803308:	89 d0                	mov    %edx,%eax
  80330a:	01 c0                	add    %eax,%eax
  80330c:	01 d0                	add    %edx,%eax
  80330e:	c1 e0 02             	shl    $0x2,%eax
  803311:	05 80 d0 81 00       	add    $0x81d080,%eax
  803316:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80331c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80331f:	89 d0                	mov    %edx,%eax
  803321:	01 c0                	add    %eax,%eax
  803323:	01 d0                	add    %edx,%eax
  803325:	c1 e0 02             	shl    $0x2,%eax
  803328:	05 84 d0 81 00       	add    $0x81d084,%eax
  80332d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803333:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803338:	48                   	dec    %eax
  803339:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80333e:	ff 45 f0             	incl   -0x10(%ebp)
  803341:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803348:	0f 8e d8 fe ff ff    	jle    803226 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80334e:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803355:	e9 9d 00 00 00       	jmp    8033f7 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  80335a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803360:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803363:	89 c8                	mov    %ecx,%eax
  803365:	01 c0                	add    %eax,%eax
  803367:	01 c8                	add    %ecx,%eax
  803369:	c1 e0 02             	shl    $0x2,%eax
  80336c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803371:	89 10                	mov    %edx,(%eax)
  803373:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803376:	89 d0                	mov    %edx,%eax
  803378:	01 c0                	add    %eax,%eax
  80337a:	01 d0                	add    %edx,%eax
  80337c:	c1 e0 02             	shl    $0x2,%eax
  80337f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	85 c0                	test   %eax,%eax
  803388:	74 1c                	je     8033a6 <initialize_dynamic_allocator+0x228>
  80338a:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803390:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803393:	89 c8                	mov    %ecx,%eax
  803395:	01 c0                	add    %eax,%eax
  803397:	01 c8                	add    %ecx,%eax
  803399:	c1 e0 02             	shl    $0x2,%eax
  80339c:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033a1:	89 42 04             	mov    %eax,0x4(%edx)
  8033a4:	eb 16                	jmp    8033bc <initialize_dynamic_allocator+0x23e>
  8033a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033a9:	89 d0                	mov    %edx,%eax
  8033ab:	01 c0                	add    %eax,%eax
  8033ad:	01 d0                	add    %edx,%eax
  8033af:	c1 e0 02             	shl    $0x2,%eax
  8033b2:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033b7:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8033bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033bf:	89 d0                	mov    %edx,%eax
  8033c1:	01 c0                	add    %eax,%eax
  8033c3:	01 d0                	add    %edx,%eax
  8033c5:	c1 e0 02             	shl    $0x2,%eax
  8033c8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8033cd:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8033d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033d5:	89 d0                	mov    %edx,%eax
  8033d7:	01 c0                	add    %eax,%eax
  8033d9:	01 d0                	add    %edx,%eax
  8033db:	c1 e0 02             	shl    $0x2,%eax
  8033de:	05 84 d0 81 00       	add    $0x81d084,%eax
  8033e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e9:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8033ee:	40                   	inc    %eax
  8033ef:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8033f4:	ff 4d ec             	decl   -0x14(%ebp)
  8033f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033fb:	0f 89 59 ff ff ff    	jns    80335a <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803401:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803408:	00 00 00 
}
  80340b:	90                   	nop
  80340c:	c9                   	leave  
  80340d:	c3                   	ret    

0080340e <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80340e:	55                   	push   %ebp
  80340f:	89 e5                	mov    %esp,%ebp
  803411:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	83 ec 0c             	sub    $0xc,%esp
  80341a:	50                   	push   %eax
  80341b:	e8 10 fd ff ff       	call   803130 <to_page_info>
  803420:	83 c4 10             	add    $0x10,%esp
  803423:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803429:	8b 40 08             	mov    0x8(%eax),%eax
  80342c:	0f b7 c0             	movzwl %ax,%eax
}
  80342f:	c9                   	leave  
  803430:	c3                   	ret    

00803431 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803431:	55                   	push   %ebp
  803432:	89 e5                	mov    %esp,%ebp
  803434:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803437:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80343e:	76 16                	jbe    803456 <alloc_block+0x25>
  803440:	68 3c 46 80 00       	push   $0x80463c
  803445:	68 26 46 80 00       	push   $0x804626
  80344a:	6a 59                	push   $0x59
  80344c:	68 c3 45 80 00       	push   $0x8045c3
  803451:	e8 fc 06 00 00       	call   803b52 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803456:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80345d:	eb 08                	jmp    803467 <alloc_block+0x36>
		allocSize <<= 1;
  80345f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803462:	01 c0                	add    %eax,%eax
  803464:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80346d:	73 09                	jae    803478 <alloc_block+0x47>
  80346f:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803476:	76 e7                	jbe    80345f <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803478:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80347f:	eb 03                	jmp    803484 <alloc_block+0x53>
		listIndex++;
  803481:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803487:	ba 08 00 00 00       	mov    $0x8,%edx
  80348c:	88 c1                	mov    %al,%cl
  80348e:	d3 e2                	shl    %cl,%edx
  803490:	89 d0                	mov    %edx,%eax
  803492:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803495:	72 ea                	jb     803481 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80349d:	e9 f4 00 00 00       	jmp    803596 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8034a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a5:	c1 e0 04             	shl    $0x4,%eax
  8034a8:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	85 c0                	test   %eax,%eax
  8034b1:	0f 84 dc 00 00 00    	je     803593 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8034b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ba:	c1 e0 04             	shl    $0x4,%eax
  8034bd:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8034c2:	8b 00                	mov    (%eax),%eax
  8034c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  8034c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034cb:	75 14                	jne    8034e1 <alloc_block+0xb0>
  8034cd:	83 ec 04             	sub    $0x4,%esp
  8034d0:	68 5d 46 80 00       	push   $0x80465d
  8034d5:	6a 6b                	push   $0x6b
  8034d7:	68 c3 45 80 00       	push   $0x8045c3
  8034dc:	e8 71 06 00 00       	call   803b52 <_panic>
  8034e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	85 c0                	test   %eax,%eax
  8034e8:	74 10                	je     8034fa <alloc_block+0xc9>
  8034ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ed:	8b 00                	mov    (%eax),%eax
  8034ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034f2:	8b 52 04             	mov    0x4(%edx),%edx
  8034f5:	89 50 04             	mov    %edx,0x4(%eax)
  8034f8:	eb 14                	jmp    80350e <alloc_block+0xdd>
  8034fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fd:	8b 40 04             	mov    0x4(%eax),%eax
  803500:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803503:	c1 e2 04             	shl    $0x4,%edx
  803506:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  80350c:	89 02                	mov    %eax,(%edx)
  80350e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803511:	8b 40 04             	mov    0x4(%eax),%eax
  803514:	85 c0                	test   %eax,%eax
  803516:	74 0f                	je     803527 <alloc_block+0xf6>
  803518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351b:	8b 40 04             	mov    0x4(%eax),%eax
  80351e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803521:	8b 12                	mov    (%edx),%edx
  803523:	89 10                	mov    %edx,(%eax)
  803525:	eb 13                	jmp    80353a <alloc_block+0x109>
  803527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352a:	8b 00                	mov    (%eax),%eax
  80352c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80352f:	c1 e2 04             	shl    $0x4,%edx
  803532:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803538:	89 02                	mov    %eax,(%edx)
  80353a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803546:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803550:	c1 e0 04             	shl    $0x4,%eax
  803553:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803558:	8b 00                	mov    (%eax),%eax
  80355a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80355d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803560:	c1 e0 04             	shl    $0x4,%eax
  803563:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803568:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  80356a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356d:	83 ec 0c             	sub    $0xc,%esp
  803570:	50                   	push   %eax
  803571:	e8 ba fb ff ff       	call   803130 <to_page_info>
  803576:	83 c4 10             	add    $0x10,%esp
  803579:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  80357c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80357f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803583:	48                   	dec    %eax
  803584:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803587:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  80358b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358e:	e9 8f 02 00 00       	jmp    803822 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803593:	ff 45 ec             	incl   -0x14(%ebp)
  803596:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80359a:	0f 8e 02 ff ff ff    	jle    8034a2 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  8035a0:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8035a5:	85 c0                	test   %eax,%eax
  8035a7:	75 14                	jne    8035bd <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  8035a9:	83 ec 04             	sub    $0x4,%esp
  8035ac:	68 7c 46 80 00       	push   $0x80467c
  8035b1:	6a 77                	push   $0x77
  8035b3:	68 c3 45 80 00       	push   $0x8045c3
  8035b8:	e8 95 05 00 00       	call   803b52 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  8035bd:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8035c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  8035c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035c9:	75 14                	jne    8035df <alloc_block+0x1ae>
  8035cb:	83 ec 04             	sub    $0x4,%esp
  8035ce:	68 5d 46 80 00       	push   $0x80465d
  8035d3:	6a 7a                	push   $0x7a
  8035d5:	68 c3 45 80 00       	push   $0x8045c3
  8035da:	e8 73 05 00 00       	call   803b52 <_panic>
  8035df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	85 c0                	test   %eax,%eax
  8035e6:	74 10                	je     8035f8 <alloc_block+0x1c7>
  8035e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035eb:	8b 00                	mov    (%eax),%eax
  8035ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035f0:	8b 52 04             	mov    0x4(%edx),%edx
  8035f3:	89 50 04             	mov    %edx,0x4(%eax)
  8035f6:	eb 0b                	jmp    803603 <alloc_block+0x1d2>
  8035f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035fb:	8b 40 04             	mov    0x4(%eax),%eax
  8035fe:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803603:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803606:	8b 40 04             	mov    0x4(%eax),%eax
  803609:	85 c0                	test   %eax,%eax
  80360b:	74 0f                	je     80361c <alloc_block+0x1eb>
  80360d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803610:	8b 40 04             	mov    0x4(%eax),%eax
  803613:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803616:	8b 12                	mov    (%edx),%edx
  803618:	89 10                	mov    %edx,(%eax)
  80361a:	eb 0a                	jmp    803626 <alloc_block+0x1f5>
  80361c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80361f:	8b 00                	mov    (%eax),%eax
  803621:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803626:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803639:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80363e:	48                   	dec    %eax
  80363f:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803644:	83 ec 0c             	sub    $0xc,%esp
  803647:	ff 75 dc             	pushl  -0x24(%ebp)
  80364a:	e8 6f fa ff ff       	call   8030be <to_page_va>
  80364f:	83 c4 10             	add    $0x10,%esp
  803652:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803655:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803658:	83 ec 0c             	sub    $0xc,%esp
  80365b:	50                   	push   %eax
  80365c:	e8 a0 dc ff ff       	call   801301 <get_page>
  803661:	83 c4 10             	add    $0x10,%esp
  803664:	85 c0                	test   %eax,%eax
  803666:	74 14                	je     80367c <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803668:	83 ec 04             	sub    $0x4,%esp
  80366b:	68 a4 46 80 00       	push   $0x8046a4
  803670:	6a 7f                	push   $0x7f
  803672:	68 c3 45 80 00       	push   $0x8045c3
  803677:	e8 d6 04 00 00       	call   803b52 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  80367c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803682:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803686:	b8 00 10 00 00       	mov    $0x1000,%eax
  80368b:	ba 00 00 00 00       	mov    $0x0,%edx
  803690:	f7 75 f4             	divl   -0xc(%ebp)
  803693:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803696:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80369a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8036a1:	e9 a7 00 00 00       	jmp    80374d <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  8036a6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8036a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ac:	01 d0                	add    %edx,%eax
  8036ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  8036b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036b5:	75 17                	jne    8036ce <alloc_block+0x29d>
  8036b7:	83 ec 04             	sub    $0x4,%esp
  8036ba:	68 cc 46 80 00       	push   $0x8046cc
  8036bf:	68 88 00 00 00       	push   $0x88
  8036c4:	68 c3 45 80 00       	push   $0x8045c3
  8036c9:	e8 84 04 00 00       	call   803b52 <_panic>
  8036ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d1:	c1 e0 04             	shl    $0x4,%eax
  8036d4:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8036d9:	8b 10                	mov    (%eax),%edx
  8036db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036de:	89 10                	mov    %edx,(%eax)
  8036e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e3:	8b 00                	mov    (%eax),%eax
  8036e5:	85 c0                	test   %eax,%eax
  8036e7:	74 15                	je     8036fe <alloc_block+0x2cd>
  8036e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ec:	c1 e0 04             	shl    $0x4,%eax
  8036ef:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8036f4:	8b 00                	mov    (%eax),%eax
  8036f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036f9:	89 50 04             	mov    %edx,0x4(%eax)
  8036fc:	eb 11                	jmp    80370f <alloc_block+0x2de>
  8036fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803701:	c1 e0 04             	shl    $0x4,%eax
  803704:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  80370a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80370d:	89 02                	mov    %eax,(%edx)
  80370f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803712:	c1 e0 04             	shl    $0x4,%eax
  803715:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  80371b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371e:	89 02                	mov    %eax,(%edx)
  803720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803723:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372d:	c1 e0 04             	shl    $0x4,%eax
  803730:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803735:	8b 00                	mov    (%eax),%eax
  803737:	8d 50 01             	lea    0x1(%eax),%edx
  80373a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373d:	c1 e0 04             	shl    $0x4,%eax
  803740:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803745:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374a:	01 45 e8             	add    %eax,-0x18(%ebp)
  80374d:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803754:	0f 86 4c ff ff ff    	jbe    8036a6 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  80375a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375d:	c1 e0 04             	shl    $0x4,%eax
  803760:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803765:	8b 00                	mov    (%eax),%eax
  803767:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  80376a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80376e:	75 17                	jne    803787 <alloc_block+0x356>
  803770:	83 ec 04             	sub    $0x4,%esp
  803773:	68 5d 46 80 00       	push   $0x80465d
  803778:	68 8d 00 00 00       	push   $0x8d
  80377d:	68 c3 45 80 00       	push   $0x8045c3
  803782:	e8 cb 03 00 00       	call   803b52 <_panic>
  803787:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80378a:	8b 00                	mov    (%eax),%eax
  80378c:	85 c0                	test   %eax,%eax
  80378e:	74 10                	je     8037a0 <alloc_block+0x36f>
  803790:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803793:	8b 00                	mov    (%eax),%eax
  803795:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803798:	8b 52 04             	mov    0x4(%edx),%edx
  80379b:	89 50 04             	mov    %edx,0x4(%eax)
  80379e:	eb 14                	jmp    8037b4 <alloc_block+0x383>
  8037a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037a3:	8b 40 04             	mov    0x4(%eax),%eax
  8037a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037a9:	c1 e2 04             	shl    $0x4,%edx
  8037ac:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8037b2:	89 02                	mov    %eax,(%edx)
  8037b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037b7:	8b 40 04             	mov    0x4(%eax),%eax
  8037ba:	85 c0                	test   %eax,%eax
  8037bc:	74 0f                	je     8037cd <alloc_block+0x39c>
  8037be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037c1:	8b 40 04             	mov    0x4(%eax),%eax
  8037c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8037c7:	8b 12                	mov    (%edx),%edx
  8037c9:	89 10                	mov    %edx,(%eax)
  8037cb:	eb 13                	jmp    8037e0 <alloc_block+0x3af>
  8037cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037d5:	c1 e2 04             	shl    $0x4,%edx
  8037d8:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8037de:	89 02                	mov    %eax,(%edx)
  8037e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f6:	c1 e0 04             	shl    $0x4,%eax
  8037f9:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8037fe:	8b 00                	mov    (%eax),%eax
  803800:	8d 50 ff             	lea    -0x1(%eax),%edx
  803803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803806:	c1 e0 04             	shl    $0x4,%eax
  803809:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80380e:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803810:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803813:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803817:	48                   	dec    %eax
  803818:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80381b:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  80381f:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803822:	c9                   	leave  
  803823:	c3                   	ret    

00803824 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803824:	55                   	push   %ebp
  803825:	89 e5                	mov    %esp,%ebp
  803827:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80382a:	8b 55 08             	mov    0x8(%ebp),%edx
  80382d:	a1 84 50 83 00       	mov    0x835084,%eax
  803832:	39 c2                	cmp    %eax,%edx
  803834:	72 0c                	jb     803842 <free_block+0x1e>
  803836:	8b 55 08             	mov    0x8(%ebp),%edx
  803839:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80383e:	39 c2                	cmp    %eax,%edx
  803840:	72 19                	jb     80385b <free_block+0x37>
  803842:	68 f0 46 80 00       	push   $0x8046f0
  803847:	68 26 46 80 00       	push   $0x804626
  80384c:	68 98 00 00 00       	push   $0x98
  803851:	68 c3 45 80 00       	push   $0x8045c3
  803856:	e8 f7 02 00 00       	call   803b52 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80385b:	8b 45 08             	mov    0x8(%ebp),%eax
  80385e:	83 ec 0c             	sub    $0xc,%esp
  803861:	50                   	push   %eax
  803862:	e8 c9 f8 ff ff       	call   803130 <to_page_info>
  803867:	83 c4 10             	add    $0x10,%esp
  80386a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  80386d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803870:	8b 40 08             	mov    0x8(%eax),%eax
  803873:	0f b7 c0             	movzwl %ax,%eax
  803876:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803879:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803880:	eb 03                	jmp    803885 <free_block+0x61>
		listIndex++;
  803882:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803888:	ba 08 00 00 00       	mov    $0x8,%edx
  80388d:	88 c1                	mov    %al,%cl
  80388f:	d3 e2                	shl    %cl,%edx
  803891:	89 d0                	mov    %edx,%eax
  803893:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803896:	72 ea                	jb     803882 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803898:	8b 45 08             	mov    0x8(%ebp),%eax
  80389b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  80389e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038a2:	75 17                	jne    8038bb <free_block+0x97>
  8038a4:	83 ec 04             	sub    $0x4,%esp
  8038a7:	68 cc 46 80 00       	push   $0x8046cc
  8038ac:	68 a2 00 00 00       	push   $0xa2
  8038b1:	68 c3 45 80 00       	push   $0x8045c3
  8038b6:	e8 97 02 00 00       	call   803b52 <_panic>
  8038bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038be:	c1 e0 04             	shl    $0x4,%eax
  8038c1:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038c6:	8b 10                	mov    (%eax),%edx
  8038c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cb:	89 10                	mov    %edx,(%eax)
  8038cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d0:	8b 00                	mov    (%eax),%eax
  8038d2:	85 c0                	test   %eax,%eax
  8038d4:	74 15                	je     8038eb <free_block+0xc7>
  8038d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d9:	c1 e0 04             	shl    $0x4,%eax
  8038dc:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8038e1:	8b 00                	mov    (%eax),%eax
  8038e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e6:	89 50 04             	mov    %edx,0x4(%eax)
  8038e9:	eb 11                	jmp    8038fc <free_block+0xd8>
  8038eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ee:	c1 e0 04             	shl    $0x4,%eax
  8038f1:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  8038f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fa:	89 02                	mov    %eax,(%edx)
  8038fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ff:	c1 e0 04             	shl    $0x4,%eax
  803902:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803908:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390b:	89 02                	mov    %eax,(%edx)
  80390d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803910:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391a:	c1 e0 04             	shl    $0x4,%eax
  80391d:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803922:	8b 00                	mov    (%eax),%eax
  803924:	8d 50 01             	lea    0x1(%eax),%edx
  803927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392a:	c1 e0 04             	shl    $0x4,%eax
  80392d:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803932:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803937:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80393b:	40                   	inc    %eax
  80393c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80393f:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803946:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80394a:	0f b7 c8             	movzwl %ax,%ecx
  80394d:	b8 00 10 00 00       	mov    $0x1000,%eax
  803952:	ba 00 00 00 00       	mov    $0x0,%edx
  803957:	f7 75 e8             	divl   -0x18(%ebp)
  80395a:	39 c1                	cmp    %eax,%ecx
  80395c:	0f 85 ed 01 00 00    	jne    803b4f <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803965:	c1 e0 04             	shl    $0x4,%eax
  803968:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80396d:	8b 00                	mov    (%eax),%eax
  80396f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803972:	eb 2a                	jmp    80399e <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803977:	83 ec 0c             	sub    $0xc,%esp
  80397a:	50                   	push   %eax
  80397b:	e8 b0 f7 ff ff       	call   803130 <to_page_info>
  803980:	83 c4 10             	add    $0x10,%esp
  803983:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803986:	75 06                	jne    80398e <free_block+0x16a>
				tmp = b;
  803988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80398b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  80398e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803991:	c1 e0 04             	shl    $0x4,%eax
  803994:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803999:	8b 00                	mov    (%eax),%eax
  80399b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80399e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039a2:	74 07                	je     8039ab <free_block+0x187>
  8039a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a7:	8b 00                	mov    (%eax),%eax
  8039a9:	eb 05                	jmp    8039b0 <free_block+0x18c>
  8039ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039b3:	c1 e2 04             	shl    $0x4,%edx
  8039b6:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  8039bc:	89 02                	mov    %eax,(%edx)
  8039be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c1:	c1 e0 04             	shl    $0x4,%eax
  8039c4:	05 a8 50 83 00       	add    $0x8350a8,%eax
  8039c9:	8b 00                	mov    (%eax),%eax
  8039cb:	85 c0                	test   %eax,%eax
  8039cd:	75 a5                	jne    803974 <free_block+0x150>
  8039cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039d3:	75 9f                	jne    803974 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  8039d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d8:	c1 e0 04             	shl    $0x4,%eax
  8039db:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8039e0:	8b 00                	mov    (%eax),%eax
  8039e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  8039e5:	e9 cc 00 00 00       	jmp    803ab6 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  8039ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ed:	8b 00                	mov    (%eax),%eax
  8039ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  8039f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f5:	83 ec 0c             	sub    $0xc,%esp
  8039f8:	50                   	push   %eax
  8039f9:	e8 32 f7 ff ff       	call   803130 <to_page_info>
  8039fe:	83 c4 10             	add    $0x10,%esp
  803a01:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803a04:	0f 85 a6 00 00 00    	jne    803ab0 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803a0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a0e:	75 17                	jne    803a27 <free_block+0x203>
  803a10:	83 ec 04             	sub    $0x4,%esp
  803a13:	68 5d 46 80 00       	push   $0x80465d
  803a18:	68 b5 00 00 00       	push   $0xb5
  803a1d:	68 c3 45 80 00       	push   $0x8045c3
  803a22:	e8 2b 01 00 00       	call   803b52 <_panic>
  803a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a2a:	8b 00                	mov    (%eax),%eax
  803a2c:	85 c0                	test   %eax,%eax
  803a2e:	74 10                	je     803a40 <free_block+0x21c>
  803a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a33:	8b 00                	mov    (%eax),%eax
  803a35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a38:	8b 52 04             	mov    0x4(%edx),%edx
  803a3b:	89 50 04             	mov    %edx,0x4(%eax)
  803a3e:	eb 14                	jmp    803a54 <free_block+0x230>
  803a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a43:	8b 40 04             	mov    0x4(%eax),%eax
  803a46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a49:	c1 e2 04             	shl    $0x4,%edx
  803a4c:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803a52:	89 02                	mov    %eax,(%edx)
  803a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a57:	8b 40 04             	mov    0x4(%eax),%eax
  803a5a:	85 c0                	test   %eax,%eax
  803a5c:	74 0f                	je     803a6d <free_block+0x249>
  803a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a61:	8b 40 04             	mov    0x4(%eax),%eax
  803a64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a67:	8b 12                	mov    (%edx),%edx
  803a69:	89 10                	mov    %edx,(%eax)
  803a6b:	eb 13                	jmp    803a80 <free_block+0x25c>
  803a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a70:	8b 00                	mov    (%eax),%eax
  803a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a75:	c1 e2 04             	shl    $0x4,%edx
  803a78:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803a7e:	89 02                	mov    %eax,(%edx)
  803a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a96:	c1 e0 04             	shl    $0x4,%eax
  803a99:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a9e:	8b 00                	mov    (%eax),%eax
  803aa0:	8d 50 ff             	lea    -0x1(%eax),%edx
  803aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa6:	c1 e0 04             	shl    $0x4,%eax
  803aa9:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803aae:	89 10                	mov    %edx,(%eax)
			b = next;
  803ab0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803ab6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803aba:	0f 85 2a ff ff ff    	jne    8039ea <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac3:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803acc:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803ad2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ad6:	75 17                	jne    803aef <free_block+0x2cb>
  803ad8:	83 ec 04             	sub    $0x4,%esp
  803adb:	68 cc 46 80 00       	push   $0x8046cc
  803ae0:	68 bc 00 00 00       	push   $0xbc
  803ae5:	68 c3 45 80 00       	push   $0x8045c3
  803aea:	e8 63 00 00 00       	call   803b52 <_panic>
  803aef:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af8:	89 10                	mov    %edx,(%eax)
  803afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803afd:	8b 00                	mov    (%eax),%eax
  803aff:	85 c0                	test   %eax,%eax
  803b01:	74 0d                	je     803b10 <free_block+0x2ec>
  803b03:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803b08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b0b:	89 50 04             	mov    %edx,0x4(%eax)
  803b0e:	eb 08                	jmp    803b18 <free_block+0x2f4>
  803b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b13:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b1b:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b2a:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803b2f:	40                   	inc    %eax
  803b30:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803b35:	83 ec 0c             	sub    $0xc,%esp
  803b38:	ff 75 ec             	pushl  -0x14(%ebp)
  803b3b:	e8 7e f5 ff ff       	call   8030be <to_page_va>
  803b40:	83 c4 10             	add    $0x10,%esp
  803b43:	83 ec 0c             	sub    $0xc,%esp
  803b46:	50                   	push   %eax
  803b47:	e8 fe d7 ff ff       	call   80134a <return_page>
  803b4c:	83 c4 10             	add    $0x10,%esp
	}
}
  803b4f:	90                   	nop
  803b50:	c9                   	leave  
  803b51:	c3                   	ret    

00803b52 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803b52:	55                   	push   %ebp
  803b53:	89 e5                	mov    %esp,%ebp
  803b55:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803b58:	8d 45 10             	lea    0x10(%ebp),%eax
  803b5b:	83 c0 04             	add    $0x4,%eax
  803b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803b61:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803b66:	85 c0                	test   %eax,%eax
  803b68:	74 16                	je     803b80 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803b6a:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803b6f:	83 ec 08             	sub    $0x8,%esp
  803b72:	50                   	push   %eax
  803b73:	68 28 47 80 00       	push   $0x804728
  803b78:	e8 4b c8 ff ff       	call   8003c8 <cprintf>
  803b7d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803b80:	a1 04 50 80 00       	mov    0x805004,%eax
  803b85:	83 ec 0c             	sub    $0xc,%esp
  803b88:	ff 75 0c             	pushl  0xc(%ebp)
  803b8b:	ff 75 08             	pushl  0x8(%ebp)
  803b8e:	50                   	push   %eax
  803b8f:	68 30 47 80 00       	push   $0x804730
  803b94:	6a 74                	push   $0x74
  803b96:	e8 5a c8 ff ff       	call   8003f5 <cprintf_colored>
  803b9b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803b9e:	8b 45 10             	mov    0x10(%ebp),%eax
  803ba1:	83 ec 08             	sub    $0x8,%esp
  803ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  803ba7:	50                   	push   %eax
  803ba8:	e8 ac c7 ff ff       	call   800359 <vcprintf>
  803bad:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803bb0:	83 ec 08             	sub    $0x8,%esp
  803bb3:	6a 00                	push   $0x0
  803bb5:	68 58 47 80 00       	push   $0x804758
  803bba:	e8 9a c7 ff ff       	call   800359 <vcprintf>
  803bbf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803bc2:	e8 13 c7 ff ff       	call   8002da <exit>

	// should not return here
	while (1) ;
  803bc7:	eb fe                	jmp    803bc7 <_panic+0x75>

00803bc9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803bc9:	55                   	push   %ebp
  803bca:	89 e5                	mov    %esp,%ebp
  803bcc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803bcf:	a1 20 50 80 00       	mov    0x805020,%eax
  803bd4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bdd:	39 c2                	cmp    %eax,%edx
  803bdf:	74 14                	je     803bf5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803be1:	83 ec 04             	sub    $0x4,%esp
  803be4:	68 5c 47 80 00       	push   $0x80475c
  803be9:	6a 26                	push   $0x26
  803beb:	68 a8 47 80 00       	push   $0x8047a8
  803bf0:	e8 5d ff ff ff       	call   803b52 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803bf5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803bfc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803c03:	e9 c5 00 00 00       	jmp    803ccd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803c12:	8b 45 08             	mov    0x8(%ebp),%eax
  803c15:	01 d0                	add    %edx,%eax
  803c17:	8b 00                	mov    (%eax),%eax
  803c19:	85 c0                	test   %eax,%eax
  803c1b:	75 08                	jne    803c25 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803c1d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803c20:	e9 a5 00 00 00       	jmp    803cca <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803c25:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c2c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803c33:	eb 69                	jmp    803c9e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803c35:	a1 20 50 80 00       	mov    0x805020,%eax
  803c3a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803c40:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c43:	89 d0                	mov    %edx,%eax
  803c45:	01 c0                	add    %eax,%eax
  803c47:	01 d0                	add    %edx,%eax
  803c49:	c1 e0 03             	shl    $0x3,%eax
  803c4c:	01 c8                	add    %ecx,%eax
  803c4e:	8a 40 04             	mov    0x4(%eax),%al
  803c51:	84 c0                	test   %al,%al
  803c53:	75 46                	jne    803c9b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803c55:	a1 20 50 80 00       	mov    0x805020,%eax
  803c5a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803c60:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c63:	89 d0                	mov    %edx,%eax
  803c65:	01 c0                	add    %eax,%eax
  803c67:	01 d0                	add    %edx,%eax
  803c69:	c1 e0 03             	shl    $0x3,%eax
  803c6c:	01 c8                	add    %ecx,%eax
  803c6e:	8b 00                	mov    (%eax),%eax
  803c70:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803c73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803c7b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c80:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803c87:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8a:	01 c8                	add    %ecx,%eax
  803c8c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803c8e:	39 c2                	cmp    %eax,%edx
  803c90:	75 09                	jne    803c9b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803c92:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803c99:	eb 15                	jmp    803cb0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c9b:	ff 45 e8             	incl   -0x18(%ebp)
  803c9e:	a1 20 50 80 00       	mov    0x805020,%eax
  803ca3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803ca9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cac:	39 c2                	cmp    %eax,%edx
  803cae:	77 85                	ja     803c35 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803cb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cb4:	75 14                	jne    803cca <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803cb6:	83 ec 04             	sub    $0x4,%esp
  803cb9:	68 b4 47 80 00       	push   $0x8047b4
  803cbe:	6a 3a                	push   $0x3a
  803cc0:	68 a8 47 80 00       	push   $0x8047a8
  803cc5:	e8 88 fe ff ff       	call   803b52 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803cca:	ff 45 f0             	incl   -0x10(%ebp)
  803ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803cd3:	0f 8c 2f ff ff ff    	jl     803c08 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803cd9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ce0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803ce7:	eb 26                	jmp    803d0f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803ce9:	a1 20 50 80 00       	mov    0x805020,%eax
  803cee:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803cf4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803cf7:	89 d0                	mov    %edx,%eax
  803cf9:	01 c0                	add    %eax,%eax
  803cfb:	01 d0                	add    %edx,%eax
  803cfd:	c1 e0 03             	shl    $0x3,%eax
  803d00:	01 c8                	add    %ecx,%eax
  803d02:	8a 40 04             	mov    0x4(%eax),%al
  803d05:	3c 01                	cmp    $0x1,%al
  803d07:	75 03                	jne    803d0c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803d09:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803d0c:	ff 45 e0             	incl   -0x20(%ebp)
  803d0f:	a1 20 50 80 00       	mov    0x805020,%eax
  803d14:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803d1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d1d:	39 c2                	cmp    %eax,%edx
  803d1f:	77 c8                	ja     803ce9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d24:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803d27:	74 14                	je     803d3d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803d29:	83 ec 04             	sub    $0x4,%esp
  803d2c:	68 08 48 80 00       	push   $0x804808
  803d31:	6a 44                	push   $0x44
  803d33:	68 a8 47 80 00       	push   $0x8047a8
  803d38:	e8 15 fe ff ff       	call   803b52 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
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
