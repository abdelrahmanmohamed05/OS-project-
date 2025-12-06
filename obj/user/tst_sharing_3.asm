
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 45 02 00 00       	call   80027b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation & get of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003e:	a1 20 50 80 00       	mov    0x805020,%eax
  800043:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800049:	a1 20 50 80 00       	mov    0x805020,%eax
  80004e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 00 41 80 00       	push   $0x804100
  800060:	6a 0c                	push   $0xc
  800062:	68 1c 41 80 00       	push   $0x80411c
  800067:	e8 bf 03 00 00       	call   80042b <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	cprintf("************************************************\n");
  80006c:	83 ec 0c             	sub    $0xc,%esp
  80006f:	68 34 41 80 00       	push   $0x804134
  800074:	e8 80 06 00 00       	call   8006f9 <cprintf>
  800079:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	68 68 41 80 00       	push   $0x804168
  800084:	e8 70 06 00 00       	call   8006f9 <cprintf>
  800089:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 c4 41 80 00       	push   $0x8041c4
  800094:	e8 60 06 00 00       	call   8006f9 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp

	int eval = 0;
  80009c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  8000aa:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... [35%] \n\n");
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 f8 41 80 00       	push   $0x8041f8
  8000b9:	e8 3b 06 00 00       	call   8006f9 <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 01                	push   $0x1
  8000c6:	68 00 10 00 00       	push   $0x1000
  8000cb:	68 46 42 80 00       	push   $0x804246
  8000d0:	e8 53 1d 00 00       	call   801e28 <smalloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000db:	e8 83 2e 00 00       	call   802f63 <sys_calculate_free_frames>
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	6a 01                	push   $0x1
  8000e8:	68 00 10 00 00       	push   $0x1000
  8000ed:	68 46 42 80 00       	push   $0x804246
  8000f2:	e8 31 1d 00 00       	call   801e28 <smalloc>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to create an already exists object and corresponding error is not returned!!");}
  8000fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800101:	74 17                	je     80011a <_main+0xe2>
  800103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	68 48 42 80 00       	push   $0x804248
  800112:	e8 e2 05 00 00       	call   8006f9 <cprintf>
  800117:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");}
  80011a:	e8 44 2e 00 00       	call   802f63 <sys_calculate_free_frames>
  80011f:	89 c2                	mov    %eax,%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	39 c2                	cmp    %eax,%edx
  800126:	74 17                	je     80013f <_main+0x107>
  800128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 9c 42 80 00       	push   $0x80429c
  800137:	e8 bd 05 00 00       	call   8006f9 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  80013f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800143:	74 04                	je     800149 <_main+0x111>
  800145:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  800149:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking getting shared object that is NOT exists... [35%]\n\n");
  800150:	83 ec 0c             	sub    $0xc,%esp
  800153:	68 f8 42 80 00       	push   $0x8042f8
  800158:	e8 9c 05 00 00       	call   8006f9 <cprintf>
  80015d:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		x = sget(myEnv->env_id, "xx");
  800160:	a1 20 50 80 00       	mov    0x805020,%eax
  800165:	8b 40 10             	mov    0x10(%eax),%eax
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	68 3d 43 80 00       	push   $0x80433d
  800170:	50                   	push   %eax
  800171:	e8 0c 20 00 00       	call   802182 <sget>
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  80017c:	e8 e2 2d 00 00       	call   802f63 <sys_calculate_free_frames>
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != NULL) {is_correct = 0; cprintf("Trying to get a NON existing object and corresponding error is not returned!!");}
  800184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800188:	74 17                	je     8001a1 <_main+0x169>
  80018a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 40 43 80 00       	push   $0x804340
  800199:	e8 5b 05 00 00       	call   8006f9 <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong get: make sure that you don't allocate any memory if the shared object not exists");}
  8001a1:	e8 bd 2d 00 00       	call   802f63 <sys_calculate_free_frames>
  8001a6:	89 c2                	mov    %eax,%edx
  8001a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ab:	39 c2                	cmp    %eax,%edx
  8001ad:	74 17                	je     8001c6 <_main+0x18e>
  8001af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 90 43 80 00       	push   $0x804390
  8001be:	e8 36 05 00 00       	call   8006f9 <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=35;
  8001c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001ca:	74 04                	je     8001d0 <_main+0x198>
  8001cc:	83 45 f4 23          	addl   $0x23,-0xc(%ebp)
	is_correct = 1;
  8001d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP C: checking the creation of shared object that exceeds the SHARED area limit... [30%]\n\n");
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 e8 43 80 00       	push   $0x8043e8
  8001df:	e8 15 05 00 00       	call   8006f9 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8001e7:	e8 77 2d 00 00       	call   802f63 <sys_calculate_free_frames>
  8001ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
		uint32 size = USER_HEAP_MAX - pagealloc_start - PAGE_SIZE + 1;
  8001ef:	b8 01 f0 ff 9f       	mov    $0x9ffff001,%eax
  8001f4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		y = smalloc("y", size, 1);
  8001fa:	83 ec 04             	sub    $0x4,%esp
  8001fd:	6a 01                	push   $0x1
  8001ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800202:	68 45 44 80 00       	push   $0x804445
  800207:	e8 1c 1c 00 00       	call   801e28 <smalloc>
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (y != NULL) {is_correct = 0; cprintf("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");}
  800212:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800216:	74 17                	je     80022f <_main+0x1f7>
  800218:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 48 44 80 00       	push   $0x804448
  800227:	e8 cd 04 00 00       	call   8006f9 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) {is_correct = 0; cprintf("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");}
  80022f:	e8 2f 2d 00 00       	call   802f63 <sys_calculate_free_frames>
  800234:	89 c2                	mov    %eax,%edx
  800236:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	74 17                	je     800254 <_main+0x21c>
  80023d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 bc 44 80 00       	push   $0x8044bc
  80024c:	e8 a8 04 00 00       	call   8006f9 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=30;
  800254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800258:	74 04                	je     80025e <_main+0x226>
  80025a:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	is_correct = 1;
  80025e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("\n%~Test of Shared Variables [Create & Get: Special Cases] completed. Eval = %d%%\n\n", eval);
  800265:	83 ec 08             	sub    $0x8,%esp
  800268:	ff 75 f4             	pushl  -0xc(%ebp)
  80026b:	68 30 45 80 00       	push   $0x804530
  800270:	e8 84 04 00 00       	call   8006f9 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp

}
  800278:	90                   	nop
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	57                   	push   %edi
  80027f:	56                   	push   %esi
  800280:	53                   	push   %ebx
  800281:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800284:	e8 a3 2e 00 00       	call   80312c <sys_getenvindex>
  800289:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80028c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80028f:	89 d0                	mov    %edx,%eax
  800291:	c1 e0 03             	shl    $0x3,%eax
  800294:	01 d0                	add    %edx,%eax
  800296:	c1 e0 02             	shl    $0x2,%eax
  800299:	01 d0                	add    %edx,%eax
  80029b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a2:	01 d0                	add    %edx,%eax
  8002a4:	c1 e0 03             	shl    $0x3,%eax
  8002a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ac:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b6:	8a 40 20             	mov    0x20(%eax),%al
  8002b9:	84 c0                	test   %al,%al
  8002bb:	74 0d                	je     8002ca <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c2:	83 c0 20             	add    $0x20,%eax
  8002c5:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002ce:	7e 0a                	jle    8002da <libmain+0x5f>
		binaryname = argv[0];
  8002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d3:	8b 00                	mov    (%eax),%eax
  8002d5:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 50 fd ff ff       	call   800038 <_main>
  8002e8:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002eb:	a1 00 50 80 00       	mov    0x805000,%eax
  8002f0:	85 c0                	test   %eax,%eax
  8002f2:	0f 84 01 01 00 00    	je     8003f9 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002f8:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002fe:	bb 7c 46 80 00       	mov    $0x80467c,%ebx
  800303:	ba 0e 00 00 00       	mov    $0xe,%edx
  800308:	89 c7                	mov    %eax,%edi
  80030a:	89 de                	mov    %ebx,%esi
  80030c:	89 d1                	mov    %edx,%ecx
  80030e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800310:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800313:	b9 56 00 00 00       	mov    $0x56,%ecx
  800318:	b0 00                	mov    $0x0,%al
  80031a:	89 d7                	mov    %edx,%edi
  80031c:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80031e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800325:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800328:	83 ec 08             	sub    $0x8,%esp
  80032b:	50                   	push   %eax
  80032c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800332:	50                   	push   %eax
  800333:	e8 2a 30 00 00       	call   803362 <sys_utilities>
  800338:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80033b:	e8 73 2b 00 00       	call   802eb3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	68 9c 45 80 00       	push   $0x80459c
  800348:	e8 ac 03 00 00       	call   8006f9 <cprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800350:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800353:	85 c0                	test   %eax,%eax
  800355:	74 18                	je     80036f <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800357:	e8 24 30 00 00       	call   803380 <sys_get_optimal_num_faults>
  80035c:	83 ec 08             	sub    $0x8,%esp
  80035f:	50                   	push   %eax
  800360:	68 c4 45 80 00       	push   $0x8045c4
  800365:	e8 8f 03 00 00       	call   8006f9 <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	eb 59                	jmp    8003c8 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80036f:	a1 20 50 80 00       	mov    0x805020,%eax
  800374:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  80037a:	a1 20 50 80 00       	mov    0x805020,%eax
  80037f:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800385:	83 ec 04             	sub    $0x4,%esp
  800388:	52                   	push   %edx
  800389:	50                   	push   %eax
  80038a:	68 e8 45 80 00       	push   $0x8045e8
  80038f:	e8 65 03 00 00       	call   8006f9 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800397:	a1 20 50 80 00       	mov    0x805020,%eax
  80039c:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8003a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a7:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8003ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b2:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8003b8:	51                   	push   %ecx
  8003b9:	52                   	push   %edx
  8003ba:	50                   	push   %eax
  8003bb:	68 10 46 80 00       	push   $0x804610
  8003c0:	e8 34 03 00 00       	call   8006f9 <cprintf>
  8003c5:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003cd:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8003d3:	83 ec 08             	sub    $0x8,%esp
  8003d6:	50                   	push   %eax
  8003d7:	68 68 46 80 00       	push   $0x804668
  8003dc:	e8 18 03 00 00       	call   8006f9 <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 9c 45 80 00       	push   $0x80459c
  8003ec:	e8 08 03 00 00       	call   8006f9 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003f4:	e8 d4 2a 00 00       	call   802ecd <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003f9:	e8 1f 00 00 00       	call   80041d <exit>
}
  8003fe:	90                   	nop
  8003ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800402:	5b                   	pop    %ebx
  800403:	5e                   	pop    %esi
  800404:	5f                   	pop    %edi
  800405:	5d                   	pop    %ebp
  800406:	c3                   	ret    

00800407 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80040d:	83 ec 0c             	sub    $0xc,%esp
  800410:	6a 00                	push   $0x0
  800412:	e8 e1 2c 00 00       	call   8030f8 <sys_destroy_env>
  800417:	83 c4 10             	add    $0x10,%esp
}
  80041a:	90                   	nop
  80041b:	c9                   	leave  
  80041c:	c3                   	ret    

0080041d <exit>:

void
exit(void)
{
  80041d:	55                   	push   %ebp
  80041e:	89 e5                	mov    %esp,%ebp
  800420:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800423:	e8 36 2d 00 00       	call   80315e <sys_exit_env>
}
  800428:	90                   	nop
  800429:	c9                   	leave  
  80042a:	c3                   	ret    

0080042b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800431:	8d 45 10             	lea    0x10(%ebp),%eax
  800434:	83 c0 04             	add    $0x4,%eax
  800437:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80043a:	a1 38 51 83 00       	mov    0x835138,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	74 16                	je     800459 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800443:	a1 38 51 83 00       	mov    0x835138,%eax
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	50                   	push   %eax
  80044c:	68 e0 46 80 00       	push   $0x8046e0
  800451:	e8 a3 02 00 00       	call   8006f9 <cprintf>
  800456:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800459:	a1 04 50 80 00       	mov    0x805004,%eax
  80045e:	83 ec 0c             	sub    $0xc,%esp
  800461:	ff 75 0c             	pushl  0xc(%ebp)
  800464:	ff 75 08             	pushl  0x8(%ebp)
  800467:	50                   	push   %eax
  800468:	68 e8 46 80 00       	push   $0x8046e8
  80046d:	6a 74                	push   $0x74
  80046f:	e8 b2 02 00 00       	call   800726 <cprintf_colored>
  800474:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800477:	8b 45 10             	mov    0x10(%ebp),%eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 f4             	pushl  -0xc(%ebp)
  800480:	50                   	push   %eax
  800481:	e8 04 02 00 00       	call   80068a <vcprintf>
  800486:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	6a 00                	push   $0x0
  80048e:	68 10 47 80 00       	push   $0x804710
  800493:	e8 f2 01 00 00       	call   80068a <vcprintf>
  800498:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80049b:	e8 7d ff ff ff       	call   80041d <exit>

	// should not return here
	while (1) ;
  8004a0:	eb fe                	jmp    8004a0 <_panic+0x75>

008004a2 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ad:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b6:	39 c2                	cmp    %eax,%edx
  8004b8:	74 14                	je     8004ce <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	68 14 47 80 00       	push   $0x804714
  8004c2:	6a 26                	push   $0x26
  8004c4:	68 60 47 80 00       	push   $0x804760
  8004c9:	e8 5d ff ff ff       	call   80042b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004dc:	e9 c5 00 00 00       	jmp    8005a6 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	8b 00                	mov    (%eax),%eax
  8004f2:	85 c0                	test   %eax,%eax
  8004f4:	75 08                	jne    8004fe <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004f6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004f9:	e9 a5 00 00 00       	jmp    8005a3 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800505:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80050c:	eb 69                	jmp    800577 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80050e:	a1 20 50 80 00       	mov    0x805020,%eax
  800513:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800519:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80051c:	89 d0                	mov    %edx,%eax
  80051e:	01 c0                	add    %eax,%eax
  800520:	01 d0                	add    %edx,%eax
  800522:	c1 e0 03             	shl    $0x3,%eax
  800525:	01 c8                	add    %ecx,%eax
  800527:	8a 40 04             	mov    0x4(%eax),%al
  80052a:	84 c0                	test   %al,%al
  80052c:	75 46                	jne    800574 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80052e:	a1 20 50 80 00       	mov    0x805020,%eax
  800533:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800539:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053c:	89 d0                	mov    %edx,%eax
  80053e:	01 c0                	add    %eax,%eax
  800540:	01 d0                	add    %edx,%eax
  800542:	c1 e0 03             	shl    $0x3,%eax
  800545:	01 c8                	add    %ecx,%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80054c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800554:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800559:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 c8                	add    %ecx,%eax
  800565:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800567:	39 c2                	cmp    %eax,%edx
  800569:	75 09                	jne    800574 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80056b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800572:	eb 15                	jmp    800589 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800574:	ff 45 e8             	incl   -0x18(%ebp)
  800577:	a1 20 50 80 00       	mov    0x805020,%eax
  80057c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800582:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800585:	39 c2                	cmp    %eax,%edx
  800587:	77 85                	ja     80050e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800589:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80058d:	75 14                	jne    8005a3 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80058f:	83 ec 04             	sub    $0x4,%esp
  800592:	68 6c 47 80 00       	push   $0x80476c
  800597:	6a 3a                	push   $0x3a
  800599:	68 60 47 80 00       	push   $0x804760
  80059e:	e8 88 fe ff ff       	call   80042b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005a3:	ff 45 f0             	incl   -0x10(%ebp)
  8005a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005ac:	0f 8c 2f ff ff ff    	jl     8004e1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005c0:	eb 26                	jmp    8005e8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c7:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005d0:	89 d0                	mov    %edx,%eax
  8005d2:	01 c0                	add    %eax,%eax
  8005d4:	01 d0                	add    %edx,%eax
  8005d6:	c1 e0 03             	shl    $0x3,%eax
  8005d9:	01 c8                	add    %ecx,%eax
  8005db:	8a 40 04             	mov    0x4(%eax),%al
  8005de:	3c 01                	cmp    $0x1,%al
  8005e0:	75 03                	jne    8005e5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005e2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e5:	ff 45 e0             	incl   -0x20(%ebp)
  8005e8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ed:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f6:	39 c2                	cmp    %eax,%edx
  8005f8:	77 c8                	ja     8005c2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800600:	74 14                	je     800616 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800602:	83 ec 04             	sub    $0x4,%esp
  800605:	68 c0 47 80 00       	push   $0x8047c0
  80060a:	6a 44                	push   $0x44
  80060c:	68 60 47 80 00       	push   $0x804760
  800611:	e8 15 fe ff ff       	call   80042b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800616:	90                   	nop
  800617:	c9                   	leave  
  800618:	c3                   	ret    

00800619 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800619:	55                   	push   %ebp
  80061a:	89 e5                	mov    %esp,%ebp
  80061c:	53                   	push   %ebx
  80061d:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800620:	8b 45 0c             	mov    0xc(%ebp),%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	8d 48 01             	lea    0x1(%eax),%ecx
  800628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062b:	89 0a                	mov    %ecx,(%edx)
  80062d:	8b 55 08             	mov    0x8(%ebp),%edx
  800630:	88 d1                	mov    %dl,%cl
  800632:	8b 55 0c             	mov    0xc(%ebp),%edx
  800635:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800643:	75 30                	jne    800675 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800645:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  80064b:	a0 64 d0 81 00       	mov    0x81d064,%al
  800650:	0f b6 c0             	movzbl %al,%eax
  800653:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800656:	8b 09                	mov    (%ecx),%ecx
  800658:	89 cb                	mov    %ecx,%ebx
  80065a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80065d:	83 c1 08             	add    $0x8,%ecx
  800660:	52                   	push   %edx
  800661:	50                   	push   %eax
  800662:	53                   	push   %ebx
  800663:	51                   	push   %ecx
  800664:	e8 06 28 00 00       	call   802e6f <sys_cputs>
  800669:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80066c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800675:	8b 45 0c             	mov    0xc(%ebp),%eax
  800678:	8b 40 04             	mov    0x4(%eax),%eax
  80067b:	8d 50 01             	lea    0x1(%eax),%edx
  80067e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800681:	89 50 04             	mov    %edx,0x4(%eax)
}
  800684:	90                   	nop
  800685:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800688:	c9                   	leave  
  800689:	c3                   	ret    

0080068a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
  80068d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800693:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80069a:	00 00 00 
	b.cnt = 0;
  80069d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006a4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	ff 75 08             	pushl  0x8(%ebp)
  8006ad:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006b3:	50                   	push   %eax
  8006b4:	68 19 06 80 00       	push   $0x800619
  8006b9:	e8 5a 02 00 00       	call   800918 <vprintfmt>
  8006be:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006c1:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  8006c7:	a0 64 d0 81 00       	mov    0x81d064,%al
  8006cc:	0f b6 c0             	movzbl %al,%eax
  8006cf:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006d5:	52                   	push   %edx
  8006d6:	50                   	push   %eax
  8006d7:	51                   	push   %ecx
  8006d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006de:	83 c0 08             	add    $0x8,%eax
  8006e1:	50                   	push   %eax
  8006e2:	e8 88 27 00 00       	call   802e6f <sys_cputs>
  8006e7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006ea:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  8006f1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006f7:	c9                   	leave  
  8006f8:	c3                   	ret    

008006f9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006f9:	55                   	push   %ebp
  8006fa:	89 e5                	mov    %esp,%ebp
  8006fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ff:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800706:	8d 45 0c             	lea    0xc(%ebp),%eax
  800709:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	ff 75 f4             	pushl  -0xc(%ebp)
  800715:	50                   	push   %eax
  800716:	e8 6f ff ff ff       	call   80068a <vcprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800721:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80072c:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	c1 e0 08             	shl    $0x8,%eax
  800739:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  80073e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800741:	83 c0 04             	add    $0x4,%eax
  800744:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 f4             	pushl  -0xc(%ebp)
  800750:	50                   	push   %eax
  800751:	e8 34 ff ff ff       	call   80068a <vcprintf>
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80075c:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  800763:	07 00 00 

	return cnt;
  800766:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800769:	c9                   	leave  
  80076a:	c3                   	ret    

0080076b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800771:	e8 3d 27 00 00       	call   802eb3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800776:	8d 45 0c             	lea    0xc(%ebp),%eax
  800779:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 f4             	pushl  -0xc(%ebp)
  800785:	50                   	push   %eax
  800786:	e8 ff fe ff ff       	call   80068a <vcprintf>
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800791:	e8 37 27 00 00       	call   802ecd <sys_unlock_cons>
	return cnt;
  800796:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800799:	c9                   	leave  
  80079a:	c3                   	ret    

0080079b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	83 ec 14             	sub    $0x14,%esp
  8007a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ae:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b9:	77 55                	ja     800810 <printnum+0x75>
  8007bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007be:	72 05                	jb     8007c5 <printnum+0x2a>
  8007c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c3:	77 4b                	ja     800810 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	52                   	push   %edx
  8007d4:	50                   	push   %eax
  8007d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8007db:	e8 a4 36 00 00       	call   803e84 <__udivdi3>
  8007e0:	83 c4 10             	add    $0x10,%esp
  8007e3:	83 ec 04             	sub    $0x4,%esp
  8007e6:	ff 75 20             	pushl  0x20(%ebp)
  8007e9:	53                   	push   %ebx
  8007ea:	ff 75 18             	pushl  0x18(%ebp)
  8007ed:	52                   	push   %edx
  8007ee:	50                   	push   %eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	e8 a1 ff ff ff       	call   80079b <printnum>
  8007fa:	83 c4 20             	add    $0x20,%esp
  8007fd:	eb 1a                	jmp    800819 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	ff 75 20             	pushl  0x20(%ebp)
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	ff d0                	call   *%eax
  80080d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800810:	ff 4d 1c             	decl   0x1c(%ebp)
  800813:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800817:	7f e6                	jg     8007ff <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800819:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800824:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800827:	53                   	push   %ebx
  800828:	51                   	push   %ecx
  800829:	52                   	push   %edx
  80082a:	50                   	push   %eax
  80082b:	e8 64 37 00 00       	call   803f94 <__umoddi3>
  800830:	83 c4 10             	add    $0x10,%esp
  800833:	05 34 4a 80 00       	add    $0x804a34,%eax
  800838:	8a 00                	mov    (%eax),%al
  80083a:	0f be c0             	movsbl %al,%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
}
  80084c:	90                   	nop
  80084d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800850:	c9                   	leave  
  800851:	c3                   	ret    

00800852 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800855:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800859:	7e 1c                	jle    800877 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	8d 50 08             	lea    0x8(%eax),%edx
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	89 10                	mov    %edx,(%eax)
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	83 e8 08             	sub    $0x8,%eax
  800870:	8b 50 04             	mov    0x4(%eax),%edx
  800873:	8b 00                	mov    (%eax),%eax
  800875:	eb 40                	jmp    8008b7 <getuint+0x65>
	else if (lflag)
  800877:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087b:	74 1e                	je     80089b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	8d 50 04             	lea    0x4(%eax),%edx
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	89 10                	mov    %edx,(%eax)
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	8b 00                	mov    (%eax),%eax
  80088f:	83 e8 04             	sub    $0x4,%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	ba 00 00 00 00       	mov    $0x0,%edx
  800899:	eb 1c                	jmp    8008b7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	8d 50 04             	lea    0x4(%eax),%edx
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	89 10                	mov    %edx,(%eax)
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	8b 00                	mov    (%eax),%eax
  8008ad:	83 e8 04             	sub    $0x4,%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c0:	7e 1c                	jle    8008de <getint+0x25>
		return va_arg(*ap, long long);
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	8d 50 08             	lea    0x8(%eax),%edx
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	89 10                	mov    %edx,(%eax)
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	83 e8 08             	sub    $0x8,%eax
  8008d7:	8b 50 04             	mov    0x4(%eax),%edx
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	eb 38                	jmp    800916 <getint+0x5d>
	else if (lflag)
  8008de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e2:	74 1a                	je     8008fe <getint+0x45>
		return va_arg(*ap, long);
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	8d 50 04             	lea    0x4(%eax),%edx
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	89 10                	mov    %edx,(%eax)
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	83 e8 04             	sub    $0x4,%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	99                   	cltd   
  8008fc:	eb 18                	jmp    800916 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	8d 50 04             	lea    0x4(%eax),%edx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	89 10                	mov    %edx,(%eax)
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	83 e8 04             	sub    $0x4,%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	99                   	cltd   
}
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	56                   	push   %esi
  80091c:	53                   	push   %ebx
  80091d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800920:	eb 17                	jmp    800939 <vprintfmt+0x21>
			if (ch == '\0')
  800922:	85 db                	test   %ebx,%ebx
  800924:	0f 84 c1 03 00 00    	je     800ceb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800939:	8b 45 10             	mov    0x10(%ebp),%eax
  80093c:	8d 50 01             	lea    0x1(%eax),%edx
  80093f:	89 55 10             	mov    %edx,0x10(%ebp)
  800942:	8a 00                	mov    (%eax),%al
  800944:	0f b6 d8             	movzbl %al,%ebx
  800947:	83 fb 25             	cmp    $0x25,%ebx
  80094a:	75 d6                	jne    800922 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800950:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800957:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800965:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096c:	8b 45 10             	mov    0x10(%ebp),%eax
  80096f:	8d 50 01             	lea    0x1(%eax),%edx
  800972:	89 55 10             	mov    %edx,0x10(%ebp)
  800975:	8a 00                	mov    (%eax),%al
  800977:	0f b6 d8             	movzbl %al,%ebx
  80097a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097d:	83 f8 5b             	cmp    $0x5b,%eax
  800980:	0f 87 3d 03 00 00    	ja     800cc3 <vprintfmt+0x3ab>
  800986:	8b 04 85 58 4a 80 00 	mov    0x804a58(,%eax,4),%eax
  80098d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80098f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800993:	eb d7                	jmp    80096c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800995:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800999:	eb d1                	jmp    80096c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a5:	89 d0                	mov    %edx,%eax
  8009a7:	c1 e0 02             	shl    $0x2,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	01 d8                	add    %ebx,%eax
  8009b0:	83 e8 30             	sub    $0x30,%eax
  8009b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b9:	8a 00                	mov    (%eax),%al
  8009bb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009be:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c1:	7e 3e                	jle    800a01 <vprintfmt+0xe9>
  8009c3:	83 fb 39             	cmp    $0x39,%ebx
  8009c6:	7f 39                	jg     800a01 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009cb:	eb d5                	jmp    8009a2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d0:	83 c0 04             	add    $0x4,%eax
  8009d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d9:	83 e8 04             	sub    $0x4,%eax
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e1:	eb 1f                	jmp    800a02 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e7:	79 83                	jns    80096c <vprintfmt+0x54>
				width = 0;
  8009e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009f0:	e9 77 ff ff ff       	jmp    80096c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fc:	e9 6b ff ff ff       	jmp    80096c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a01:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a06:	0f 89 60 ff ff ff    	jns    80096c <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a12:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a19:	e9 4e ff ff ff       	jmp    80096c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a21:	e9 46 ff ff ff       	jmp    80096c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a26:	8b 45 14             	mov    0x14(%ebp),%eax
  800a29:	83 c0 04             	add    $0x4,%eax
  800a2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a32:	83 e8 04             	sub    $0x4,%eax
  800a35:	8b 00                	mov    (%eax),%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	50                   	push   %eax
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
			break;
  800a46:	e9 9b 02 00 00       	jmp    800ce6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4e:	83 c0 04             	add    $0x4,%eax
  800a51:	89 45 14             	mov    %eax,0x14(%ebp)
  800a54:	8b 45 14             	mov    0x14(%ebp),%eax
  800a57:	83 e8 04             	sub    $0x4,%eax
  800a5a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5c:	85 db                	test   %ebx,%ebx
  800a5e:	79 02                	jns    800a62 <vprintfmt+0x14a>
				err = -err;
  800a60:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a62:	83 fb 64             	cmp    $0x64,%ebx
  800a65:	7f 0b                	jg     800a72 <vprintfmt+0x15a>
  800a67:	8b 34 9d a0 48 80 00 	mov    0x8048a0(,%ebx,4),%esi
  800a6e:	85 f6                	test   %esi,%esi
  800a70:	75 19                	jne    800a8b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a72:	53                   	push   %ebx
  800a73:	68 45 4a 80 00       	push   $0x804a45
  800a78:	ff 75 0c             	pushl  0xc(%ebp)
  800a7b:	ff 75 08             	pushl  0x8(%ebp)
  800a7e:	e8 70 02 00 00       	call   800cf3 <printfmt>
  800a83:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a86:	e9 5b 02 00 00       	jmp    800ce6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8b:	56                   	push   %esi
  800a8c:	68 4e 4a 80 00       	push   $0x804a4e
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	ff 75 08             	pushl  0x8(%ebp)
  800a97:	e8 57 02 00 00       	call   800cf3 <printfmt>
  800a9c:	83 c4 10             	add    $0x10,%esp
			break;
  800a9f:	e9 42 02 00 00       	jmp    800ce6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa4:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa7:	83 c0 04             	add    $0x4,%eax
  800aaa:	89 45 14             	mov    %eax,0x14(%ebp)
  800aad:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab0:	83 e8 04             	sub    $0x4,%eax
  800ab3:	8b 30                	mov    (%eax),%esi
  800ab5:	85 f6                	test   %esi,%esi
  800ab7:	75 05                	jne    800abe <vprintfmt+0x1a6>
				p = "(null)";
  800ab9:	be 51 4a 80 00       	mov    $0x804a51,%esi
			if (width > 0 && padc != '-')
  800abe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac2:	7e 6d                	jle    800b31 <vprintfmt+0x219>
  800ac4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac8:	74 67                	je     800b31 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	50                   	push   %eax
  800ad1:	56                   	push   %esi
  800ad2:	e8 1e 03 00 00       	call   800df5 <strnlen>
  800ad7:	83 c4 10             	add    $0x10,%esp
  800ada:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800add:	eb 16                	jmp    800af5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800adf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	50                   	push   %eax
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	ff d0                	call   *%eax
  800aef:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af2:	ff 4d e4             	decl   -0x1c(%ebp)
  800af5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af9:	7f e4                	jg     800adf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afb:	eb 34                	jmp    800b31 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b01:	74 1c                	je     800b1f <vprintfmt+0x207>
  800b03:	83 fb 1f             	cmp    $0x1f,%ebx
  800b06:	7e 05                	jle    800b0d <vprintfmt+0x1f5>
  800b08:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0b:	7e 12                	jle    800b1f <vprintfmt+0x207>
					putch('?', putdat);
  800b0d:	83 ec 08             	sub    $0x8,%esp
  800b10:	ff 75 0c             	pushl  0xc(%ebp)
  800b13:	6a 3f                	push   $0x3f
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	ff d0                	call   *%eax
  800b1a:	83 c4 10             	add    $0x10,%esp
  800b1d:	eb 0f                	jmp    800b2e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b1f:	83 ec 08             	sub    $0x8,%esp
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	53                   	push   %ebx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b31:	89 f0                	mov    %esi,%eax
  800b33:	8d 70 01             	lea    0x1(%eax),%esi
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	0f be d8             	movsbl %al,%ebx
  800b3b:	85 db                	test   %ebx,%ebx
  800b3d:	74 24                	je     800b63 <vprintfmt+0x24b>
  800b3f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b43:	78 b8                	js     800afd <vprintfmt+0x1e5>
  800b45:	ff 4d e0             	decl   -0x20(%ebp)
  800b48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4c:	79 af                	jns    800afd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4e:	eb 13                	jmp    800b63 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	6a 20                	push   $0x20
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	ff d0                	call   *%eax
  800b5d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b60:	ff 4d e4             	decl   -0x1c(%ebp)
  800b63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b67:	7f e7                	jg     800b50 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b69:	e9 78 01 00 00       	jmp    800ce6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	ff 75 e8             	pushl  -0x18(%ebp)
  800b74:	8d 45 14             	lea    0x14(%ebp),%eax
  800b77:	50                   	push   %eax
  800b78:	e8 3c fd ff ff       	call   8008b9 <getint>
  800b7d:	83 c4 10             	add    $0x10,%esp
  800b80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b83:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8c:	85 d2                	test   %edx,%edx
  800b8e:	79 23                	jns    800bb3 <vprintfmt+0x29b>
				putch('-', putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	6a 2d                	push   $0x2d
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba6:	f7 d8                	neg    %eax
  800ba8:	83 d2 00             	adc    $0x0,%edx
  800bab:	f7 da                	neg    %edx
  800bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bba:	e9 bc 00 00 00       	jmp    800c7b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bbf:	83 ec 08             	sub    $0x8,%esp
  800bc2:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc5:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc8:	50                   	push   %eax
  800bc9:	e8 84 fc ff ff       	call   800852 <getuint>
  800bce:	83 c4 10             	add    $0x10,%esp
  800bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bde:	e9 98 00 00 00       	jmp    800c7b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be3:	83 ec 08             	sub    $0x8,%esp
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	6a 58                	push   $0x58
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	ff d0                	call   *%eax
  800bf0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf3:	83 ec 08             	sub    $0x8,%esp
  800bf6:	ff 75 0c             	pushl  0xc(%ebp)
  800bf9:	6a 58                	push   $0x58
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	ff d0                	call   *%eax
  800c00:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	6a 58                	push   $0x58
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	ff d0                	call   *%eax
  800c10:	83 c4 10             	add    $0x10,%esp
			break;
  800c13:	e9 ce 00 00 00       	jmp    800ce6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c18:	83 ec 08             	sub    $0x8,%esp
  800c1b:	ff 75 0c             	pushl  0xc(%ebp)
  800c1e:	6a 30                	push   $0x30
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	ff d0                	call   *%eax
  800c25:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c28:	83 ec 08             	sub    $0x8,%esp
  800c2b:	ff 75 0c             	pushl  0xc(%ebp)
  800c2e:	6a 78                	push   $0x78
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	ff d0                	call   *%eax
  800c35:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c38:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3b:	83 c0 04             	add    $0x4,%eax
  800c3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800c41:	8b 45 14             	mov    0x14(%ebp),%eax
  800c44:	83 e8 04             	sub    $0x4,%eax
  800c47:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c53:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c5a:	eb 1f                	jmp    800c7b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 e8             	pushl  -0x18(%ebp)
  800c62:	8d 45 14             	lea    0x14(%ebp),%eax
  800c65:	50                   	push   %eax
  800c66:	e8 e7 fb ff ff       	call   800852 <getuint>
  800c6b:	83 c4 10             	add    $0x10,%esp
  800c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c71:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c74:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c82:	83 ec 04             	sub    $0x4,%esp
  800c85:	52                   	push   %edx
  800c86:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	ff 75 f0             	pushl  -0x10(%ebp)
  800c90:	ff 75 0c             	pushl  0xc(%ebp)
  800c93:	ff 75 08             	pushl  0x8(%ebp)
  800c96:	e8 00 fb ff ff       	call   80079b <printnum>
  800c9b:	83 c4 20             	add    $0x20,%esp
			break;
  800c9e:	eb 46                	jmp    800ce6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ca0:	83 ec 08             	sub    $0x8,%esp
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	53                   	push   %ebx
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	ff d0                	call   *%eax
  800cac:	83 c4 10             	add    $0x10,%esp
			break;
  800caf:	eb 35                	jmp    800ce6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cb1:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800cb8:	eb 2c                	jmp    800ce6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cba:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800cc1:	eb 23                	jmp    800ce6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	6a 25                	push   $0x25
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	ff d0                	call   *%eax
  800cd0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd3:	ff 4d 10             	decl   0x10(%ebp)
  800cd6:	eb 03                	jmp    800cdb <vprintfmt+0x3c3>
  800cd8:	ff 4d 10             	decl   0x10(%ebp)
  800cdb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cde:	48                   	dec    %eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	3c 25                	cmp    $0x25,%al
  800ce3:	75 f3                	jne    800cd8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ce5:	90                   	nop
		}
	}
  800ce6:	e9 35 fc ff ff       	jmp    800920 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ceb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf9:	8d 45 10             	lea    0x10(%ebp),%eax
  800cfc:	83 c0 04             	add    $0x4,%eax
  800cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d02:	8b 45 10             	mov    0x10(%ebp),%eax
  800d05:	ff 75 f4             	pushl  -0xc(%ebp)
  800d08:	50                   	push   %eax
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	ff 75 08             	pushl  0x8(%ebp)
  800d0f:	e8 04 fc ff ff       	call   800918 <vprintfmt>
  800d14:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d17:	90                   	nop
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	8b 40 08             	mov    0x8(%eax),%eax
  800d23:	8d 50 01             	lea    0x1(%eax),%edx
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8b 10                	mov    (%eax),%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8b 40 04             	mov    0x4(%eax),%eax
  800d37:	39 c2                	cmp    %eax,%edx
  800d39:	73 12                	jae    800d4d <sprintputch+0x33>
		*b->buf++ = ch;
  800d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3e:	8b 00                	mov    (%eax),%eax
  800d40:	8d 48 01             	lea    0x1(%eax),%ecx
  800d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d46:	89 0a                	mov    %ecx,(%edx)
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	88 10                	mov    %dl,(%eax)
}
  800d4d:	90                   	nop
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d75:	74 06                	je     800d7d <vsnprintf+0x2d>
  800d77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7b:	7f 07                	jg     800d84 <vsnprintf+0x34>
		return -E_INVAL;
  800d7d:	b8 03 00 00 00       	mov    $0x3,%eax
  800d82:	eb 20                	jmp    800da4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d84:	ff 75 14             	pushl  0x14(%ebp)
  800d87:	ff 75 10             	pushl  0x10(%ebp)
  800d8a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8d:	50                   	push   %eax
  800d8e:	68 1a 0d 80 00       	push   $0x800d1a
  800d93:	e8 80 fb ff ff       	call   800918 <vprintfmt>
  800d98:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dac:	8d 45 10             	lea    0x10(%ebp),%eax
  800daf:	83 c0 04             	add    $0x4,%eax
  800db2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db5:	8b 45 10             	mov    0x10(%ebp),%eax
  800db8:	ff 75 f4             	pushl  -0xc(%ebp)
  800dbb:	50                   	push   %eax
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	ff 75 08             	pushl  0x8(%ebp)
  800dc2:	e8 89 ff ff ff       	call   800d50 <vsnprintf>
  800dc7:	83 c4 10             	add    $0x10,%esp
  800dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddf:	eb 06                	jmp    800de7 <strlen+0x15>
		n++;
  800de1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	84 c0                	test   %al,%al
  800dee:	75 f1                	jne    800de1 <strlen+0xf>
		n++;
	return n;
  800df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e02:	eb 09                	jmp    800e0d <strnlen+0x18>
		n++;
  800e04:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e07:	ff 45 08             	incl   0x8(%ebp)
  800e0a:	ff 4d 0c             	decl   0xc(%ebp)
  800e0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e11:	74 09                	je     800e1c <strnlen+0x27>
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	84 c0                	test   %al,%al
  800e1a:	75 e8                	jne    800e04 <strnlen+0xf>
		n++;
	return n;
  800e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1f:	c9                   	leave  
  800e20:	c3                   	ret    

00800e21 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2d:	90                   	nop
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8d 50 01             	lea    0x1(%eax),%edx
  800e34:	89 55 08             	mov    %edx,0x8(%ebp)
  800e37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e40:	8a 12                	mov    (%edx),%dl
  800e42:	88 10                	mov    %dl,(%eax)
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	75 e4                	jne    800e2e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e62:	eb 1f                	jmp    800e83 <strncpy+0x34>
		*dst++ = *src;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8d 50 01             	lea    0x1(%eax),%edx
  800e6a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e70:	8a 12                	mov    (%edx),%dl
  800e72:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	84 c0                	test   %al,%al
  800e7b:	74 03                	je     800e80 <strncpy+0x31>
			src++;
  800e7d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e80:	ff 45 fc             	incl   -0x4(%ebp)
  800e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e86:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e89:	72 d9                	jb     800e64 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8e:	c9                   	leave  
  800e8f:	c3                   	ret    

00800e90 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea0:	74 30                	je     800ed2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ea2:	eb 16                	jmp    800eba <strlcpy+0x2a>
			*dst++ = *src++;
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	8d 50 01             	lea    0x1(%eax),%edx
  800eaa:	89 55 08             	mov    %edx,0x8(%ebp)
  800ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb6:	8a 12                	mov    (%edx),%dl
  800eb8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eba:	ff 4d 10             	decl   0x10(%ebp)
  800ebd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec1:	74 09                	je     800ecc <strlcpy+0x3c>
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	84 c0                	test   %al,%al
  800eca:	75 d8                	jne    800ea4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	29 c2                	sub    %eax,%edx
  800eda:	89 d0                	mov    %edx,%eax
}
  800edc:	c9                   	leave  
  800edd:	c3                   	ret    

00800ede <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ee1:	eb 06                	jmp    800ee9 <strcmp+0xb>
		p++, q++;
  800ee3:	ff 45 08             	incl   0x8(%ebp)
  800ee6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	84 c0                	test   %al,%al
  800ef0:	74 0e                	je     800f00 <strcmp+0x22>
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 10                	mov    (%eax),%dl
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	38 c2                	cmp    %al,%dl
  800efe:	74 e3                	je     800ee3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	0f b6 d0             	movzbl %al,%edx
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	0f b6 c0             	movzbl %al,%eax
  800f10:	29 c2                	sub    %eax,%edx
  800f12:	89 d0                	mov    %edx,%eax
}
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    

00800f16 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f19:	eb 09                	jmp    800f24 <strncmp+0xe>
		n--, p++, q++;
  800f1b:	ff 4d 10             	decl   0x10(%ebp)
  800f1e:	ff 45 08             	incl   0x8(%ebp)
  800f21:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f28:	74 17                	je     800f41 <strncmp+0x2b>
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	84 c0                	test   %al,%al
  800f31:	74 0e                	je     800f41 <strncmp+0x2b>
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 10                	mov    (%eax),%dl
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	38 c2                	cmp    %al,%dl
  800f3f:	74 da                	je     800f1b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f45:	75 07                	jne    800f4e <strncmp+0x38>
		return 0;
  800f47:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4c:	eb 14                	jmp    800f62 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	0f b6 d0             	movzbl %al,%edx
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 c0             	movzbl %al,%eax
  800f5e:	29 c2                	sub    %eax,%edx
  800f60:	89 d0                	mov    %edx,%eax
}
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 04             	sub    $0x4,%esp
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f70:	eb 12                	jmp    800f84 <strchr+0x20>
		if (*s == c)
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f7a:	75 05                	jne    800f81 <strchr+0x1d>
			return (char *) s;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	eb 11                	jmp    800f92 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f81:	ff 45 08             	incl   0x8(%ebp)
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	84 c0                	test   %al,%al
  800f8b:	75 e5                	jne    800f72 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    

00800f94 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 04             	sub    $0x4,%esp
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa0:	eb 0d                	jmp    800faf <strfind+0x1b>
		if (*s == c)
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800faa:	74 0e                	je     800fba <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fac:	ff 45 08             	incl   0x8(%ebp)
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	84 c0                	test   %al,%al
  800fb6:	75 ea                	jne    800fa2 <strfind+0xe>
  800fb8:	eb 01                	jmp    800fbb <strfind+0x27>
		if (*s == c)
			break;
  800fba:	90                   	nop
	return (char *) s;
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbe:	c9                   	leave  
  800fbf:	c3                   	ret    

00800fc0 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fcc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fd0:	76 63                	jbe    801035 <memset+0x75>
		uint64 data_block = c;
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	99                   	cltd   
  800fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe2:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fe6:	c1 e0 08             	shl    $0x8,%eax
  800fe9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fec:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ff9:	c1 e0 10             	shl    $0x10,%eax
  800ffc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fff:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801005:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801008:	89 c2                	mov    %eax,%edx
  80100a:	b8 00 00 00 00       	mov    $0x0,%eax
  80100f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801012:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801015:	eb 18                	jmp    80102f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801017:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80101a:	8d 41 08             	lea    0x8(%ecx),%eax
  80101d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801026:	89 01                	mov    %eax,(%ecx)
  801028:	89 51 04             	mov    %edx,0x4(%ecx)
  80102b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80102f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801033:	77 e2                	ja     801017 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801035:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801039:	74 23                	je     80105e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80103b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801041:	eb 0e                	jmp    801051 <memset+0x91>
			*p8++ = (uint8)c;
  801043:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801046:	8d 50 01             	lea    0x1(%eax),%edx
  801049:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801051:	8b 45 10             	mov    0x10(%ebp),%eax
  801054:	8d 50 ff             	lea    -0x1(%eax),%edx
  801057:	89 55 10             	mov    %edx,0x10(%ebp)
  80105a:	85 c0                	test   %eax,%eax
  80105c:	75 e5                	jne    801043 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801075:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801079:	76 24                	jbe    80109f <memcpy+0x3c>
		while(n >= 8){
  80107b:	eb 1c                	jmp    801099 <memcpy+0x36>
			*d64 = *s64;
  80107d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801080:	8b 50 04             	mov    0x4(%eax),%edx
  801083:	8b 00                	mov    (%eax),%eax
  801085:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801088:	89 01                	mov    %eax,(%ecx)
  80108a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80108d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801091:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801095:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801099:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80109d:	77 de                	ja     80107d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80109f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a3:	74 31                	je     8010d6 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010b1:	eb 16                	jmp    8010c9 <memcpy+0x66>
			*d8++ = *s8++;
  8010b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b6:	8d 50 01             	lea    0x1(%eax),%edx
  8010b9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c2:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010c5:	8a 12                	mov    (%edx),%dl
  8010c7:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	75 dd                	jne    8010b3 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f3:	73 50                	jae    801145 <memmove+0x6a>
  8010f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fb:	01 d0                	add    %edx,%eax
  8010fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801100:	76 43                	jbe    801145 <memmove+0x6a>
		s += n;
  801102:	8b 45 10             	mov    0x10(%ebp),%eax
  801105:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801108:	8b 45 10             	mov    0x10(%ebp),%eax
  80110b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110e:	eb 10                	jmp    801120 <memmove+0x45>
			*--d = *--s;
  801110:	ff 4d f8             	decl   -0x8(%ebp)
  801113:	ff 4d fc             	decl   -0x4(%ebp)
  801116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801119:	8a 10                	mov    (%eax),%dl
  80111b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 e3                	jne    801110 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80112d:	eb 23                	jmp    801152 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80112f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801132:	8d 50 01             	lea    0x1(%eax),%edx
  801135:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801138:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801141:	8a 12                	mov    (%edx),%dl
  801143:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
  801148:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114b:	89 55 10             	mov    %edx,0x10(%ebp)
  80114e:	85 c0                	test   %eax,%eax
  801150:	75 dd                	jne    80112f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801163:	8b 45 0c             	mov    0xc(%ebp),%eax
  801166:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801169:	eb 2a                	jmp    801195 <memcmp+0x3e>
		if (*s1 != *s2)
  80116b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116e:	8a 10                	mov    (%eax),%dl
  801170:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	38 c2                	cmp    %al,%dl
  801177:	74 16                	je     80118f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801179:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	0f b6 d0             	movzbl %al,%edx
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	0f b6 c0             	movzbl %al,%eax
  801189:	29 c2                	sub    %eax,%edx
  80118b:	89 d0                	mov    %edx,%eax
  80118d:	eb 18                	jmp    8011a7 <memcmp+0x50>
		s1++, s2++;
  80118f:	ff 45 fc             	incl   -0x4(%ebp)
  801192:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801195:	8b 45 10             	mov    0x10(%ebp),%eax
  801198:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119b:	89 55 10             	mov    %edx,0x10(%ebp)
  80119e:	85 c0                	test   %eax,%eax
  8011a0:	75 c9                	jne    80116b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a7:	c9                   	leave  
  8011a8:	c3                   	ret    

008011a9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011af:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011ba:	eb 15                	jmp    8011d1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	0f b6 d0             	movzbl %al,%edx
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	0f b6 c0             	movzbl %al,%eax
  8011ca:	39 c2                	cmp    %eax,%edx
  8011cc:	74 0d                	je     8011db <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011ce:	ff 45 08             	incl   0x8(%ebp)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d7:	72 e3                	jb     8011bc <memfind+0x13>
  8011d9:	eb 01                	jmp    8011dc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011db:	90                   	nop
	return (void *) s;
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f5:	eb 03                	jmp    8011fa <strtol+0x19>
		s++;
  8011f7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 20                	cmp    $0x20,%al
  801201:	74 f4                	je     8011f7 <strtol+0x16>
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 09                	cmp    $0x9,%al
  80120a:	74 eb                	je     8011f7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 2b                	cmp    $0x2b,%al
  801213:	75 05                	jne    80121a <strtol+0x39>
		s++;
  801215:	ff 45 08             	incl   0x8(%ebp)
  801218:	eb 13                	jmp    80122d <strtol+0x4c>
	else if (*s == '-')
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	3c 2d                	cmp    $0x2d,%al
  801221:	75 0a                	jne    80122d <strtol+0x4c>
		s++, neg = 1;
  801223:	ff 45 08             	incl   0x8(%ebp)
  801226:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80122d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801231:	74 06                	je     801239 <strtol+0x58>
  801233:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801237:	75 20                	jne    801259 <strtol+0x78>
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	3c 30                	cmp    $0x30,%al
  801240:	75 17                	jne    801259 <strtol+0x78>
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	40                   	inc    %eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	3c 78                	cmp    $0x78,%al
  80124a:	75 0d                	jne    801259 <strtol+0x78>
		s += 2, base = 16;
  80124c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801250:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801257:	eb 28                	jmp    801281 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801259:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125d:	75 15                	jne    801274 <strtol+0x93>
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3c 30                	cmp    $0x30,%al
  801266:	75 0c                	jne    801274 <strtol+0x93>
		s++, base = 8;
  801268:	ff 45 08             	incl   0x8(%ebp)
  80126b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801272:	eb 0d                	jmp    801281 <strtol+0xa0>
	else if (base == 0)
  801274:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801278:	75 07                	jne    801281 <strtol+0xa0>
		base = 10;
  80127a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	3c 2f                	cmp    $0x2f,%al
  801288:	7e 19                	jle    8012a3 <strtol+0xc2>
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	3c 39                	cmp    $0x39,%al
  801291:	7f 10                	jg     8012a3 <strtol+0xc2>
			dig = *s - '0';
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	0f be c0             	movsbl %al,%eax
  80129b:	83 e8 30             	sub    $0x30,%eax
  80129e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a1:	eb 42                	jmp    8012e5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	3c 60                	cmp    $0x60,%al
  8012aa:	7e 19                	jle    8012c5 <strtol+0xe4>
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	3c 7a                	cmp    $0x7a,%al
  8012b3:	7f 10                	jg     8012c5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f be c0             	movsbl %al,%eax
  8012bd:	83 e8 57             	sub    $0x57,%eax
  8012c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c3:	eb 20                	jmp    8012e5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	8a 00                	mov    (%eax),%al
  8012ca:	3c 40                	cmp    $0x40,%al
  8012cc:	7e 39                	jle    801307 <strtol+0x126>
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	8a 00                	mov    (%eax),%al
  8012d3:	3c 5a                	cmp    $0x5a,%al
  8012d5:	7f 30                	jg     801307 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	8a 00                	mov    (%eax),%al
  8012dc:	0f be c0             	movsbl %al,%eax
  8012df:	83 e8 37             	sub    $0x37,%eax
  8012e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012eb:	7d 19                	jge    801306 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ed:	ff 45 08             	incl   0x8(%ebp)
  8012f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f7:	89 c2                	mov    %eax,%edx
  8012f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801301:	e9 7b ff ff ff       	jmp    801281 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801306:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801307:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130b:	74 08                	je     801315 <strtol+0x134>
		*endptr = (char *) s;
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	8b 55 08             	mov    0x8(%ebp),%edx
  801313:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801315:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801319:	74 07                	je     801322 <strtol+0x141>
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131e:	f7 d8                	neg    %eax
  801320:	eb 03                	jmp    801325 <strtol+0x144>
  801322:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <ltostr>:

void
ltostr(long value, char *str)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80132d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801334:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80133b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133f:	79 13                	jns    801354 <ltostr+0x2d>
	{
		neg = 1;
  801341:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801351:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80135c:	99                   	cltd   
  80135d:	f7 f9                	idiv   %ecx
  80135f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801362:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801365:	8d 50 01             	lea    0x1(%eax),%edx
  801368:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136b:	89 c2                	mov    %eax,%edx
  80136d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801370:	01 d0                	add    %edx,%eax
  801372:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801375:	83 c2 30             	add    $0x30,%edx
  801378:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80137a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801382:	f7 e9                	imul   %ecx
  801384:	c1 fa 02             	sar    $0x2,%edx
  801387:	89 c8                	mov    %ecx,%eax
  801389:	c1 f8 1f             	sar    $0x1f,%eax
  80138c:	29 c2                	sub    %eax,%edx
  80138e:	89 d0                	mov    %edx,%eax
  801390:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801393:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801397:	75 bb                	jne    801354 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801399:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a3:	48                   	dec    %eax
  8013a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013ab:	74 3d                	je     8013ea <ltostr+0xc3>
		start = 1 ;
  8013ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013b4:	eb 34                	jmp    8013ea <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bc:	01 d0                	add    %edx,%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	01 c2                	add    %eax,%edx
  8013cb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	01 c8                	add    %ecx,%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	01 c2                	add    %eax,%edx
  8013df:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013e2:	88 02                	mov    %al,(%edx)
		start++ ;
  8013e4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013e7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f0:	7c c4                	jl     8013b6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	01 d0                	add    %edx,%eax
  8013fa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013fd:	90                   	nop
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    

00801400 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801406:	ff 75 08             	pushl  0x8(%ebp)
  801409:	e8 c4 f9 ff ff       	call   800dd2 <strlen>
  80140e:	83 c4 04             	add    $0x4,%esp
  801411:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	e8 b6 f9 ff ff       	call   800dd2 <strlen>
  80141c:	83 c4 04             	add    $0x4,%esp
  80141f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801422:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801429:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801430:	eb 17                	jmp    801449 <strcconcat+0x49>
		final[s] = str1[s] ;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 c2                	add    %eax,%edx
  80143a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	01 c8                	add    %ecx,%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801446:	ff 45 fc             	incl   -0x4(%ebp)
  801449:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80144c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80144f:	7c e1                	jl     801432 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801451:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801458:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80145f:	eb 1f                	jmp    801480 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801461:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801464:	8d 50 01             	lea    0x1(%eax),%edx
  801467:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146a:	89 c2                	mov    %eax,%edx
  80146c:	8b 45 10             	mov    0x10(%ebp),%eax
  80146f:	01 c2                	add    %eax,%edx
  801471:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801474:	8b 45 0c             	mov    0xc(%ebp),%eax
  801477:	01 c8                	add    %ecx,%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80147d:	ff 45 f8             	incl   -0x8(%ebp)
  801480:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801483:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801486:	7c d9                	jl     801461 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801488:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148b:	8b 45 10             	mov    0x10(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	c6 00 00             	movb   $0x0,(%eax)
}
  801493:	90                   	nop
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801499:	8b 45 14             	mov    0x14(%ebp),%eax
  80149c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a5:	8b 00                	mov    (%eax),%eax
  8014a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b1:	01 d0                	add    %edx,%eax
  8014b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b9:	eb 0c                	jmp    8014c7 <strsplit+0x31>
			*string++ = 0;
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	8d 50 01             	lea    0x1(%eax),%edx
  8014c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	84 c0                	test   %al,%al
  8014ce:	74 18                	je     8014e8 <strsplit+0x52>
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	0f be c0             	movsbl %al,%eax
  8014d8:	50                   	push   %eax
  8014d9:	ff 75 0c             	pushl  0xc(%ebp)
  8014dc:	e8 83 fa ff ff       	call   800f64 <strchr>
  8014e1:	83 c4 08             	add    $0x8,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	75 d3                	jne    8014bb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	8a 00                	mov    (%eax),%al
  8014ed:	84 c0                	test   %al,%al
  8014ef:	74 5a                	je     80154b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f4:	8b 00                	mov    (%eax),%eax
  8014f6:	83 f8 0f             	cmp    $0xf,%eax
  8014f9:	75 07                	jne    801502 <strsplit+0x6c>
		{
			return 0;
  8014fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801500:	eb 66                	jmp    801568 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801502:	8b 45 14             	mov    0x14(%ebp),%eax
  801505:	8b 00                	mov    (%eax),%eax
  801507:	8d 48 01             	lea    0x1(%eax),%ecx
  80150a:	8b 55 14             	mov    0x14(%ebp),%edx
  80150d:	89 0a                	mov    %ecx,(%edx)
  80150f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801516:	8b 45 10             	mov    0x10(%ebp),%eax
  801519:	01 c2                	add    %eax,%edx
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801520:	eb 03                	jmp    801525 <strsplit+0x8f>
			string++;
  801522:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	84 c0                	test   %al,%al
  80152c:	74 8b                	je     8014b9 <strsplit+0x23>
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	0f be c0             	movsbl %al,%eax
  801536:	50                   	push   %eax
  801537:	ff 75 0c             	pushl  0xc(%ebp)
  80153a:	e8 25 fa ff ff       	call   800f64 <strchr>
  80153f:	83 c4 08             	add    $0x8,%esp
  801542:	85 c0                	test   %eax,%eax
  801544:	74 dc                	je     801522 <strsplit+0x8c>
			string++;
	}
  801546:	e9 6e ff ff ff       	jmp    8014b9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80154b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80154c:	8b 45 14             	mov    0x14(%ebp),%eax
  80154f:	8b 00                	mov    (%eax),%eax
  801551:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801558:	8b 45 10             	mov    0x10(%ebp),%eax
  80155b:	01 d0                	add    %edx,%eax
  80155d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801563:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801576:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80157d:	eb 4a                	jmp    8015c9 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80157f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	01 c2                	add    %eax,%edx
  801587:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80158a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158d:	01 c8                	add    %ecx,%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801593:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801596:	8b 45 0c             	mov    0xc(%ebp),%eax
  801599:	01 d0                	add    %edx,%eax
  80159b:	8a 00                	mov    (%eax),%al
  80159d:	3c 40                	cmp    $0x40,%al
  80159f:	7e 25                	jle    8015c6 <str2lower+0x5c>
  8015a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a7:	01 d0                	add    %edx,%eax
  8015a9:	8a 00                	mov    (%eax),%al
  8015ab:	3c 5a                	cmp    $0x5a,%al
  8015ad:	7f 17                	jg     8015c6 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	01 d0                	add    %edx,%eax
  8015b7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bd:	01 ca                	add    %ecx,%edx
  8015bf:	8a 12                	mov    (%edx),%dl
  8015c1:	83 c2 20             	add    $0x20,%edx
  8015c4:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015c6:	ff 45 fc             	incl   -0x4(%ebp)
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	e8 01 f8 ff ff       	call   800dd2 <strlen>
  8015d1:	83 c4 04             	add    $0x4,%esp
  8015d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015d7:	7f a6                	jg     80157f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8015e4:	a1 08 50 80 00       	mov    0x805008,%eax
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	74 42                	je     80162f <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8015ed:	83 ec 08             	sub    $0x8,%esp
  8015f0:	68 00 00 00 82       	push   $0x82000000
  8015f5:	68 00 00 00 80       	push   $0x80000000
  8015fa:	e8 b0 1e 00 00       	call   8034af <initialize_dynamic_allocator>
  8015ff:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801602:	e8 96 1c 00 00       	call   80329d <sys_get_uheap_strategy>
  801607:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80160c:	a1 60 d0 81 00       	mov    0x81d060,%eax
  801611:	05 00 10 00 00       	add    $0x1000,%eax
  801616:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  80161b:	a1 30 51 83 00       	mov    0x835130,%eax
  801620:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  801625:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80162c:	00 00 00 
	}
}
  80162f:	90                   	nop
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801641:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801646:	83 ec 08             	sub    $0x8,%esp
  801649:	68 06 04 00 00       	push   $0x406
  80164e:	50                   	push   %eax
  80164f:	e8 93 18 00 00       	call   802ee7 <__sys_allocate_page>
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80165a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80165e:	79 14                	jns    801674 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	68 c8 4b 80 00       	push   $0x804bc8
  801668:	6a 1f                	push   $0x1f
  80166a:	68 04 4c 80 00       	push   $0x804c04
  80166f:	e8 b7 ed ff ff       	call   80042b <_panic>
	return 0;
  801674:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80168f:	83 ec 0c             	sub    $0xc,%esp
  801692:	50                   	push   %eax
  801693:	e8 96 18 00 00       	call   802f2e <__sys_unmap_frame>
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80169e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016a2:	79 14                	jns    8016b8 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016a4:	83 ec 04             	sub    $0x4,%esp
  8016a7:	68 10 4c 80 00       	push   $0x804c10
  8016ac:	6a 2a                	push   $0x2a
  8016ae:	68 04 4c 80 00       	push   $0x804c04
  8016b3:	e8 73 ed ff ff       	call   80042b <_panic>
}
  8016b8:	90                   	nop
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016c1:	e8 18 ff ff ff       	call   8015de <uheap_init>
	if (size == 0) return NULL ;
  8016c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016ca:	75 0a                	jne    8016d6 <malloc+0x1b>
  8016cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d1:	e9 43 03 00 00       	jmp    801a19 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8016d6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8016dd:	77 13                	ja     8016f2 <malloc+0x37>
    {
        return alloc_block(size);
  8016df:	83 ec 0c             	sub    $0xc,%esp
  8016e2:	ff 75 08             	pushl  0x8(%ebp)
  8016e5:	e8 78 20 00 00       	call   803762 <alloc_block>
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	e9 27 03 00 00       	jmp    801a19 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8016f2:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8016f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ff:	01 d0                	add    %edx,%eax
  801701:	48                   	dec    %eax
  801702:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801705:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801708:	ba 00 00 00 00       	mov    $0x0,%edx
  80170d:	f7 75 dc             	divl   -0x24(%ebp)
  801710:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801713:	29 d0                	sub    %edx,%eax
  801715:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801718:	a1 40 d0 81 00       	mov    0x81d040,%eax
  80171d:	85 c0                	test   %eax,%eax
  80171f:	75 0a                	jne    80172b <malloc+0x70>
    {
        uhp_inited = 1;
  801721:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  801728:	00 00 00 
    }

    int exactIdx = -1;
  80172b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801732:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801739:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801740:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801747:	e9 85 00 00 00       	jmp    8017d1 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80174c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	01 c0                	add    %eax,%eax
  801753:	01 d0                	add    %edx,%eax
  801755:	c1 e0 02             	shl    $0x2,%eax
  801758:	05 48 10 81 00       	add    $0x811048,%eax
  80175d:	8a 00                	mov    (%eax),%al
  80175f:	84 c0                	test   %al,%al
  801761:	74 20                	je     801783 <malloc+0xc8>
  801763:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801766:	89 d0                	mov    %edx,%eax
  801768:	01 c0                	add    %eax,%eax
  80176a:	01 d0                	add    %edx,%eax
  80176c:	c1 e0 02             	shl    $0x2,%eax
  80176f:	05 44 10 81 00       	add    $0x811044,%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801779:	75 08                	jne    801783 <malloc+0xc8>
        {
            exactIdx = i;
  80177b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80177e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801781:	eb 5b                	jmp    8017de <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801783:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801786:	89 d0                	mov    %edx,%eax
  801788:	01 c0                	add    %eax,%eax
  80178a:	01 d0                	add    %edx,%eax
  80178c:	c1 e0 02             	shl    $0x2,%eax
  80178f:	05 48 10 81 00       	add    $0x811048,%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	84 c0                	test   %al,%al
  801798:	74 34                	je     8017ce <malloc+0x113>
  80179a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80179d:	89 d0                	mov    %edx,%eax
  80179f:	01 c0                	add    %eax,%eax
  8017a1:	01 d0                	add    %edx,%eax
  8017a3:	c1 e0 02             	shl    $0x2,%eax
  8017a6:	05 44 10 81 00       	add    $0x811044,%eax
  8017ab:	8b 00                	mov    (%eax),%eax
  8017ad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8017b0:	76 1c                	jbe    8017ce <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8017b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017b5:	89 d0                	mov    %edx,%eax
  8017b7:	01 c0                	add    %eax,%eax
  8017b9:	01 d0                	add    %edx,%eax
  8017bb:	c1 e0 02             	shl    $0x2,%eax
  8017be:	05 44 10 81 00       	add    $0x811044,%eax
  8017c3:	8b 00                	mov    (%eax),%eax
  8017c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8017c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8017ce:	ff 45 e8             	incl   -0x18(%ebp)
  8017d1:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8017d8:	0f 8e 6e ff ff ff    	jle    80174c <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8017de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8017e5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8017e9:	74 7d                	je     801868 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8017eb:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8017f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f5:	89 d0                	mov    %edx,%eax
  8017f7:	01 c0                	add    %eax,%eax
  8017f9:	01 d0                	add    %edx,%eax
  8017fb:	c1 e0 02             	shl    $0x2,%eax
  8017fe:	05 40 10 81 00       	add    $0x811040,%eax
  801803:	8b 10                	mov    (%eax),%edx
  801805:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	48                   	dec    %eax
  80180b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80180e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801811:	ba 00 00 00 00       	mov    $0x0,%edx
  801816:	f7 75 bc             	divl   -0x44(%ebp)
  801819:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80181c:	29 d0                	sub    %edx,%eax
  80181e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801824:	89 d0                	mov    %edx,%eax
  801826:	01 c0                	add    %eax,%eax
  801828:	01 d0                	add    %edx,%eax
  80182a:	c1 e0 02             	shl    $0x2,%eax
  80182d:	05 48 10 81 00       	add    $0x811048,%eax
  801832:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801835:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801838:	89 d0                	mov    %edx,%eax
  80183a:	01 c0                	add    %eax,%eax
  80183c:	01 d0                	add    %edx,%eax
  80183e:	c1 e0 02             	shl    $0x2,%eax
  801841:	05 44 10 81 00       	add    $0x811044,%eax
  801846:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80184c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184f:	89 d0                	mov    %edx,%eax
  801851:	01 c0                	add    %eax,%eax
  801853:	01 d0                	add    %edx,%eax
  801855:	c1 e0 02             	shl    $0x2,%eax
  801858:	05 40 10 81 00       	add    $0x811040,%eax
  80185d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801863:	e9 2d 01 00 00       	jmp    801995 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801868:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80186c:	0f 84 ce 00 00 00    	je     801940 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801872:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801879:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80187c:	89 d0                	mov    %edx,%eax
  80187e:	01 c0                	add    %eax,%eax
  801880:	01 d0                	add    %edx,%eax
  801882:	c1 e0 02             	shl    $0x2,%eax
  801885:	05 40 10 81 00       	add    $0x811040,%eax
  80188a:	8b 10                	mov    (%eax),%edx
  80188c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80188f:	01 d0                	add    %edx,%eax
  801891:	48                   	dec    %eax
  801892:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801895:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801898:	ba 00 00 00 00       	mov    $0x0,%edx
  80189d:	f7 75 c4             	divl   -0x3c(%ebp)
  8018a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018a3:	29 d0                	sub    %edx,%eax
  8018a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8018a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ab:	89 d0                	mov    %edx,%eax
  8018ad:	01 c0                	add    %eax,%eax
  8018af:	01 d0                	add    %edx,%eax
  8018b1:	c1 e0 02             	shl    $0x2,%eax
  8018b4:	05 44 10 81 00       	add    $0x811044,%eax
  8018b9:	8b 00                	mov    (%eax),%eax
  8018bb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8018be:	75 47                	jne    801907 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  8018c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c3:	89 d0                	mov    %edx,%eax
  8018c5:	01 c0                	add    %eax,%eax
  8018c7:	01 d0                	add    %edx,%eax
  8018c9:	c1 e0 02             	shl    $0x2,%eax
  8018cc:	05 48 10 81 00       	add    $0x811048,%eax
  8018d1:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8018d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d7:	89 d0                	mov    %edx,%eax
  8018d9:	01 c0                	add    %eax,%eax
  8018db:	01 d0                	add    %edx,%eax
  8018dd:	c1 e0 02             	shl    $0x2,%eax
  8018e0:	05 44 10 81 00       	add    $0x811044,%eax
  8018e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8018eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ee:	89 d0                	mov    %edx,%eax
  8018f0:	01 c0                	add    %eax,%eax
  8018f2:	01 d0                	add    %edx,%eax
  8018f4:	c1 e0 02             	shl    $0x2,%eax
  8018f7:	05 40 10 81 00       	add    $0x811040,%eax
  8018fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801902:	e9 8e 00 00 00       	jmp    801995 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801907:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80190a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80190d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801910:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801913:	89 d0                	mov    %edx,%eax
  801915:	01 c0                	add    %eax,%eax
  801917:	01 d0                	add    %edx,%eax
  801919:	c1 e0 02             	shl    $0x2,%eax
  80191c:	05 40 10 81 00       	add    $0x811040,%eax
  801921:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801926:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801929:	89 c2                	mov    %eax,%edx
  80192b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80192e:	89 c8                	mov    %ecx,%eax
  801930:	01 c0                	add    %eax,%eax
  801932:	01 c8                	add    %ecx,%eax
  801934:	c1 e0 02             	shl    $0x2,%eax
  801937:	05 44 10 81 00       	add    $0x811044,%eax
  80193c:	89 10                	mov    %edx,(%eax)
  80193e:	eb 55                	jmp    801995 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801940:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801947:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80194d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801950:	01 d0                	add    %edx,%eax
  801952:	48                   	dec    %eax
  801953:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801956:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801959:	ba 00 00 00 00       	mov    $0x0,%edx
  80195e:	f7 75 d0             	divl   -0x30(%ebp)
  801961:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801964:	29 d0                	sub    %edx,%eax
  801966:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801969:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80196c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80196f:	01 d0                	add    %edx,%eax
  801971:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801976:	76 0a                	jbe    801982 <malloc+0x2c7>
            return NULL;
  801978:	b8 00 00 00 00       	mov    $0x0,%eax
  80197d:	e9 97 00 00 00       	jmp    801a19 <malloc+0x35e>
        va = start;
  801982:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801985:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801988:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80198b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80198e:	01 d0                	add    %edx,%eax
  801990:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801995:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80199c:	eb 5e                	jmp    8019fc <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  80199e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019a1:	89 d0                	mov    %edx,%eax
  8019a3:	01 c0                	add    %eax,%eax
  8019a5:	01 d0                	add    %edx,%eax
  8019a7:	c1 e0 02             	shl    $0x2,%eax
  8019aa:	05 48 50 80 00       	add    $0x805048,%eax
  8019af:	8a 00                	mov    (%eax),%al
  8019b1:	84 c0                	test   %al,%al
  8019b3:	75 44                	jne    8019f9 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  8019b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019b8:	89 d0                	mov    %edx,%eax
  8019ba:	01 c0                	add    %eax,%eax
  8019bc:	01 d0                	add    %edx,%eax
  8019be:	c1 e0 02             	shl    $0x2,%eax
  8019c1:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8019c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019ca:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8019cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019cf:	89 d0                	mov    %edx,%eax
  8019d1:	01 c0                	add    %eax,%eax
  8019d3:	01 d0                	add    %edx,%eax
  8019d5:	c1 e0 02             	shl    $0x2,%eax
  8019d8:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8019de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019e1:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8019e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019e6:	89 d0                	mov    %edx,%eax
  8019e8:	01 c0                	add    %eax,%eax
  8019ea:	01 d0                	add    %edx,%eax
  8019ec:	c1 e0 02             	shl    $0x2,%eax
  8019ef:	05 48 50 80 00       	add    $0x805048,%eax
  8019f4:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8019f7:	eb 0c                	jmp    801a05 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019f9:	ff 45 e0             	incl   -0x20(%ebp)
  8019fc:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a03:	7e 99                	jle    80199e <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801a05:	83 ec 08             	sub    $0x8,%esp
  801a08:	ff 75 d4             	pushl  -0x2c(%ebp)
  801a0b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a0e:	e8 a2 19 00 00       	call   8033b5 <sys_allocate_user_mem>
  801a13:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801a21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a25:	0f 84 fa 03 00 00    	je     801e25 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801a31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a34:	85 c0                	test   %eax,%eax
  801a36:	79 1c                	jns    801a54 <free+0x39>
  801a38:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801a3f:	77 13                	ja     801a54 <free+0x39>
    {
        free_block(virtual_address);
  801a41:	83 ec 0c             	sub    $0xc,%esp
  801a44:	ff 75 08             	pushl  0x8(%ebp)
  801a47:	e8 09 21 00 00       	call   803b55 <free_block>
  801a4c:	83 c4 10             	add    $0x10,%esp
        return;
  801a4f:	e9 d2 03 00 00       	jmp    801e26 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801a54:	a1 30 51 83 00       	mov    0x835130,%eax
  801a59:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801a5c:	72 09                	jb     801a67 <free+0x4c>
  801a5e:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801a65:	76 17                	jbe    801a7e <free+0x63>
        panic("free: invalid address");
  801a67:	83 ec 04             	sub    $0x4,%esp
  801a6a:	68 4d 4c 80 00       	push   $0x804c4d
  801a6f:	68 9b 00 00 00       	push   $0x9b
  801a74:	68 04 4c 80 00       	push   $0x804c04
  801a79:	e8 ad e9 ff ff       	call   80042b <_panic>

    uint32 size = 0;
  801a7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801a85:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a8c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801a93:	eb 50                	jmp    801ae5 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801a95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a98:	89 d0                	mov    %edx,%eax
  801a9a:	01 c0                	add    %eax,%eax
  801a9c:	01 d0                	add    %edx,%eax
  801a9e:	c1 e0 02             	shl    $0x2,%eax
  801aa1:	05 48 50 80 00       	add    $0x805048,%eax
  801aa6:	8a 00                	mov    (%eax),%al
  801aa8:	84 c0                	test   %al,%al
  801aaa:	74 36                	je     801ae2 <free+0xc7>
  801aac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801aaf:	89 d0                	mov    %edx,%eax
  801ab1:	01 c0                	add    %eax,%eax
  801ab3:	01 d0                	add    %edx,%eax
  801ab5:	c1 e0 02             	shl    $0x2,%eax
  801ab8:	05 40 50 80 00       	add    $0x805040,%eax
  801abd:	8b 00                	mov    (%eax),%eax
  801abf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ac2:	75 1e                	jne    801ae2 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801ac4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ac7:	89 d0                	mov    %edx,%eax
  801ac9:	01 c0                	add    %eax,%eax
  801acb:	01 d0                	add    %edx,%eax
  801acd:	c1 e0 02             	shl    $0x2,%eax
  801ad0:	05 44 50 80 00       	add    $0x805044,%eax
  801ad5:	8b 00                	mov    (%eax),%eax
  801ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801add:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801ae0:	eb 0c                	jmp    801aee <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ae2:	ff 45 ec             	incl   -0x14(%ebp)
  801ae5:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801aec:	7e a7                	jle    801a95 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801aee:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801af2:	74 06                	je     801afa <free+0xdf>
  801af4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801af8:	75 17                	jne    801b11 <free+0xf6>
        panic("free: unknown block");
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	68 63 4c 80 00       	push   $0x804c63
  801b02:	68 a9 00 00 00       	push   $0xa9
  801b07:	68 04 4c 80 00       	push   $0x804c04
  801b0c:	e8 1a e9 ff ff       	call   80042b <_panic>

    uhp_allocs[idx].used = 0;
  801b11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b14:	89 d0                	mov    %edx,%eax
  801b16:	01 c0                	add    %eax,%eax
  801b18:	01 d0                	add    %edx,%eax
  801b1a:	c1 e0 02             	shl    $0x2,%eax
  801b1d:	05 48 50 80 00       	add    $0x805048,%eax
  801b22:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801b25:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b2c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b33:	eb 64                	jmp    801b99 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801b35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b38:	89 d0                	mov    %edx,%eax
  801b3a:	01 c0                	add    %eax,%eax
  801b3c:	01 d0                	add    %edx,%eax
  801b3e:	c1 e0 02             	shl    $0x2,%eax
  801b41:	05 48 10 81 00       	add    $0x811048,%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	84 c0                	test   %al,%al
  801b4a:	75 4a                	jne    801b96 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801b4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b4f:	89 d0                	mov    %edx,%eax
  801b51:	01 c0                	add    %eax,%eax
  801b53:	01 d0                	add    %edx,%eax
  801b55:	c1 e0 02             	shl    $0x2,%eax
  801b58:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801b5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b61:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801b63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b66:	89 d0                	mov    %edx,%eax
  801b68:	01 c0                	add    %eax,%eax
  801b6a:	01 d0                	add    %edx,%eax
  801b6c:	c1 e0 02             	shl    $0x2,%eax
  801b6f:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b78:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801b7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b7d:	89 d0                	mov    %edx,%eax
  801b7f:	01 c0                	add    %eax,%eax
  801b81:	01 d0                	add    %edx,%eax
  801b83:	c1 e0 02             	shl    $0x2,%eax
  801b86:	05 48 10 81 00       	add    $0x811048,%eax
  801b8b:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801b8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b91:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801b94:	eb 0c                	jmp    801ba2 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b96:	ff 45 e4             	incl   -0x1c(%ebp)
  801b99:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801ba0:	7e 93                	jle    801b35 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801ba2:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801ba6:	0f 84 f1 01 00 00    	je     801d9d <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bb3:	e9 d8 01 00 00       	jmp    801d90 <free+0x375>
        {
            if (i == fidx) continue;
  801bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bbb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801bbe:	0f 84 c8 01 00 00    	je     801d8c <free+0x371>
            if (uhp_frees[i].free)
  801bc4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bc7:	89 d0                	mov    %edx,%eax
  801bc9:	01 c0                	add    %eax,%eax
  801bcb:	01 d0                	add    %edx,%eax
  801bcd:	c1 e0 02             	shl    $0x2,%eax
  801bd0:	05 48 10 81 00       	add    $0x811048,%eax
  801bd5:	8a 00                	mov    (%eax),%al
  801bd7:	84 c0                	test   %al,%al
  801bd9:	0f 84 ae 01 00 00    	je     801d8d <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801bdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801be2:	89 d0                	mov    %edx,%eax
  801be4:	01 c0                	add    %eax,%eax
  801be6:	01 d0                	add    %edx,%eax
  801be8:	c1 e0 02             	shl    $0x2,%eax
  801beb:	05 40 10 81 00       	add    $0x811040,%eax
  801bf0:	8b 08                	mov    (%eax),%ecx
  801bf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bf5:	89 d0                	mov    %edx,%eax
  801bf7:	01 c0                	add    %eax,%eax
  801bf9:	01 d0                	add    %edx,%eax
  801bfb:	c1 e0 02             	shl    $0x2,%eax
  801bfe:	05 44 10 81 00       	add    $0x811044,%eax
  801c03:	8b 00                	mov    (%eax),%eax
  801c05:	01 c1                	add    %eax,%ecx
  801c07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c0a:	89 d0                	mov    %edx,%eax
  801c0c:	01 c0                	add    %eax,%eax
  801c0e:	01 d0                	add    %edx,%eax
  801c10:	c1 e0 02             	shl    $0x2,%eax
  801c13:	05 40 10 81 00       	add    $0x811040,%eax
  801c18:	8b 00                	mov    (%eax),%eax
  801c1a:	39 c1                	cmp    %eax,%ecx
  801c1c:	0f 85 a8 00 00 00    	jne    801cca <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801c22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c25:	89 d0                	mov    %edx,%eax
  801c27:	01 c0                	add    %eax,%eax
  801c29:	01 d0                	add    %edx,%eax
  801c2b:	c1 e0 02             	shl    $0x2,%eax
  801c2e:	05 40 10 81 00       	add    $0x811040,%eax
  801c33:	8b 10                	mov    (%eax),%edx
  801c35:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801c38:	89 c8                	mov    %ecx,%eax
  801c3a:	01 c0                	add    %eax,%eax
  801c3c:	01 c8                	add    %ecx,%eax
  801c3e:	c1 e0 02             	shl    $0x2,%eax
  801c41:	05 40 10 81 00       	add    $0x811040,%eax
  801c46:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c4b:	89 d0                	mov    %edx,%eax
  801c4d:	01 c0                	add    %eax,%eax
  801c4f:	01 d0                	add    %edx,%eax
  801c51:	c1 e0 02             	shl    $0x2,%eax
  801c54:	05 44 10 81 00       	add    $0x811044,%eax
  801c59:	8b 08                	mov    (%eax),%ecx
  801c5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c5e:	89 d0                	mov    %edx,%eax
  801c60:	01 c0                	add    %eax,%eax
  801c62:	01 d0                	add    %edx,%eax
  801c64:	c1 e0 02             	shl    $0x2,%eax
  801c67:	05 44 10 81 00       	add    $0x811044,%eax
  801c6c:	8b 00                	mov    (%eax),%eax
  801c6e:	01 c1                	add    %eax,%ecx
  801c70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c73:	89 d0                	mov    %edx,%eax
  801c75:	01 c0                	add    %eax,%eax
  801c77:	01 d0                	add    %edx,%eax
  801c79:	c1 e0 02             	shl    $0x2,%eax
  801c7c:	05 44 10 81 00       	add    $0x811044,%eax
  801c81:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801c83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c86:	89 d0                	mov    %edx,%eax
  801c88:	01 c0                	add    %eax,%eax
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	c1 e0 02             	shl    $0x2,%eax
  801c8f:	05 48 10 81 00       	add    $0x811048,%eax
  801c94:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801c97:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c9a:	89 d0                	mov    %edx,%eax
  801c9c:	01 c0                	add    %eax,%eax
  801c9e:	01 d0                	add    %edx,%eax
  801ca0:	c1 e0 02             	shl    $0x2,%eax
  801ca3:	05 40 10 81 00       	add    $0x811040,%eax
  801ca8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801cae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cb1:	89 d0                	mov    %edx,%eax
  801cb3:	01 c0                	add    %eax,%eax
  801cb5:	01 d0                	add    %edx,%eax
  801cb7:	c1 e0 02             	shl    $0x2,%eax
  801cba:	05 44 10 81 00       	add    $0x811044,%eax
  801cbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cc5:	e9 c3 00 00 00       	jmp    801d8d <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801cca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ccd:	89 d0                	mov    %edx,%eax
  801ccf:	01 c0                	add    %eax,%eax
  801cd1:	01 d0                	add    %edx,%eax
  801cd3:	c1 e0 02             	shl    $0x2,%eax
  801cd6:	05 40 10 81 00       	add    $0x811040,%eax
  801cdb:	8b 08                	mov    (%eax),%ecx
  801cdd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ce0:	89 d0                	mov    %edx,%eax
  801ce2:	01 c0                	add    %eax,%eax
  801ce4:	01 d0                	add    %edx,%eax
  801ce6:	c1 e0 02             	shl    $0x2,%eax
  801ce9:	05 44 10 81 00       	add    $0x811044,%eax
  801cee:	8b 00                	mov    (%eax),%eax
  801cf0:	01 c1                	add    %eax,%ecx
  801cf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cf5:	89 d0                	mov    %edx,%eax
  801cf7:	01 c0                	add    %eax,%eax
  801cf9:	01 d0                	add    %edx,%eax
  801cfb:	c1 e0 02             	shl    $0x2,%eax
  801cfe:	05 40 10 81 00       	add    $0x811040,%eax
  801d03:	8b 00                	mov    (%eax),%eax
  801d05:	39 c1                	cmp    %eax,%ecx
  801d07:	0f 85 80 00 00 00    	jne    801d8d <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801d0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d10:	89 d0                	mov    %edx,%eax
  801d12:	01 c0                	add    %eax,%eax
  801d14:	01 d0                	add    %edx,%eax
  801d16:	c1 e0 02             	shl    $0x2,%eax
  801d19:	05 44 10 81 00       	add    $0x811044,%eax
  801d1e:	8b 08                	mov    (%eax),%ecx
  801d20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d23:	89 d0                	mov    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	01 d0                	add    %edx,%eax
  801d29:	c1 e0 02             	shl    $0x2,%eax
  801d2c:	05 44 10 81 00       	add    $0x811044,%eax
  801d31:	8b 00                	mov    (%eax),%eax
  801d33:	01 c1                	add    %eax,%ecx
  801d35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d38:	89 d0                	mov    %edx,%eax
  801d3a:	01 c0                	add    %eax,%eax
  801d3c:	01 d0                	add    %edx,%eax
  801d3e:	c1 e0 02             	shl    $0x2,%eax
  801d41:	05 44 10 81 00       	add    $0x811044,%eax
  801d46:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801d48:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d4b:	89 d0                	mov    %edx,%eax
  801d4d:	01 c0                	add    %eax,%eax
  801d4f:	01 d0                	add    %edx,%eax
  801d51:	c1 e0 02             	shl    $0x2,%eax
  801d54:	05 48 10 81 00       	add    $0x811048,%eax
  801d59:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801d5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d5f:	89 d0                	mov    %edx,%eax
  801d61:	01 c0                	add    %eax,%eax
  801d63:	01 d0                	add    %edx,%eax
  801d65:	c1 e0 02             	shl    $0x2,%eax
  801d68:	05 40 10 81 00       	add    $0x811040,%eax
  801d6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801d73:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d76:	89 d0                	mov    %edx,%eax
  801d78:	01 c0                	add    %eax,%eax
  801d7a:	01 d0                	add    %edx,%eax
  801d7c:	c1 e0 02             	shl    $0x2,%eax
  801d7f:	05 44 10 81 00       	add    $0x811044,%eax
  801d84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d8a:	eb 01                	jmp    801d8d <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801d8c:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d8d:	ff 45 e0             	incl   -0x20(%ebp)
  801d90:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801d97:	0f 8e 1b fe ff ff    	jle    801bb8 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801d9d:	a1 30 51 83 00       	mov    0x835130,%eax
  801da2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801da5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801dac:	eb 53                	jmp    801e01 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801dae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801db1:	89 d0                	mov    %edx,%eax
  801db3:	01 c0                	add    %eax,%eax
  801db5:	01 d0                	add    %edx,%eax
  801db7:	c1 e0 02             	shl    $0x2,%eax
  801dba:	05 48 50 80 00       	add    $0x805048,%eax
  801dbf:	8a 00                	mov    (%eax),%al
  801dc1:	84 c0                	test   %al,%al
  801dc3:	74 39                	je     801dfe <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801dc5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801dc8:	89 d0                	mov    %edx,%eax
  801dca:	01 c0                	add    %eax,%eax
  801dcc:	01 d0                	add    %edx,%eax
  801dce:	c1 e0 02             	shl    $0x2,%eax
  801dd1:	05 40 50 80 00       	add    $0x805040,%eax
  801dd6:	8b 08                	mov    (%eax),%ecx
  801dd8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ddb:	89 d0                	mov    %edx,%eax
  801ddd:	01 c0                	add    %eax,%eax
  801ddf:	01 d0                	add    %edx,%eax
  801de1:	c1 e0 02             	shl    $0x2,%eax
  801de4:	05 44 50 80 00       	add    $0x805044,%eax
  801de9:	8b 00                	mov    (%eax),%eax
  801deb:	01 c8                	add    %ecx,%eax
  801ded:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801df0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801df3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801df6:	76 06                	jbe    801dfe <free+0x3e3>
  801df8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801dfb:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801dfe:	ff 45 d8             	incl   -0x28(%ebp)
  801e01:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801e08:	7e a4                	jle    801dae <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801e0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e0d:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801e12:	83 ec 08             	sub    $0x8,%esp
  801e15:	ff 75 f4             	pushl  -0xc(%ebp)
  801e18:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e1b:	e8 79 15 00 00       	call   803399 <sys_free_user_mem>
  801e20:	83 c4 10             	add    $0x10,%esp
  801e23:	eb 01                	jmp    801e26 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801e25:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	83 ec 68             	sub    $0x68,%esp
  801e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e31:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e34:	e8 a5 f7 ff ff       	call   8015de <uheap_init>
	if (size == 0) return NULL ;
  801e39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e3d:	75 0a                	jne    801e49 <smalloc+0x21>
  801e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e44:	e9 37 03 00 00       	jmp    802180 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801e49:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801e50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e56:	01 d0                	add    %edx,%eax
  801e58:	48                   	dec    %eax
  801e59:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e5c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e64:	f7 75 dc             	divl   -0x24(%ebp)
  801e67:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e6a:	29 d0                	sub    %edx,%eax
  801e6c:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801e6f:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801e76:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801e7d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e84:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801e8b:	e9 85 00 00 00       	jmp    801f15 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801e90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e93:	89 d0                	mov    %edx,%eax
  801e95:	01 c0                	add    %eax,%eax
  801e97:	01 d0                	add    %edx,%eax
  801e99:	c1 e0 02             	shl    $0x2,%eax
  801e9c:	05 48 10 81 00       	add    $0x811048,%eax
  801ea1:	8a 00                	mov    (%eax),%al
  801ea3:	84 c0                	test   %al,%al
  801ea5:	74 20                	je     801ec7 <smalloc+0x9f>
  801ea7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eaa:	89 d0                	mov    %edx,%eax
  801eac:	01 c0                	add    %eax,%eax
  801eae:	01 d0                	add    %edx,%eax
  801eb0:	c1 e0 02             	shl    $0x2,%eax
  801eb3:	05 44 10 81 00       	add    $0x811044,%eax
  801eb8:	8b 00                	mov    (%eax),%eax
  801eba:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ebd:	75 08                	jne    801ec7 <smalloc+0x9f>
        {
            exactIdx = i;
  801ebf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ec2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801ec5:	eb 5b                	jmp    801f22 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801ec7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eca:	89 d0                	mov    %edx,%eax
  801ecc:	01 c0                	add    %eax,%eax
  801ece:	01 d0                	add    %edx,%eax
  801ed0:	c1 e0 02             	shl    $0x2,%eax
  801ed3:	05 48 10 81 00       	add    $0x811048,%eax
  801ed8:	8a 00                	mov    (%eax),%al
  801eda:	84 c0                	test   %al,%al
  801edc:	74 34                	je     801f12 <smalloc+0xea>
  801ede:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ee1:	89 d0                	mov    %edx,%eax
  801ee3:	01 c0                	add    %eax,%eax
  801ee5:	01 d0                	add    %edx,%eax
  801ee7:	c1 e0 02             	shl    $0x2,%eax
  801eea:	05 44 10 81 00       	add    $0x811044,%eax
  801eef:	8b 00                	mov    (%eax),%eax
  801ef1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ef4:	76 1c                	jbe    801f12 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801ef6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ef9:	89 d0                	mov    %edx,%eax
  801efb:	01 c0                	add    %eax,%eax
  801efd:	01 d0                	add    %edx,%eax
  801eff:	c1 e0 02             	shl    $0x2,%eax
  801f02:	05 44 10 81 00       	add    $0x811044,%eax
  801f07:	8b 00                	mov    (%eax),%eax
  801f09:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f12:	ff 45 e8             	incl   -0x18(%ebp)
  801f15:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f1c:	0f 8e 6e ff ff ff    	jle    801e90 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f22:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f29:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f2d:	74 7d                	je     801fac <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f2f:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f39:	89 d0                	mov    %edx,%eax
  801f3b:	01 c0                	add    %eax,%eax
  801f3d:	01 d0                	add    %edx,%eax
  801f3f:	c1 e0 02             	shl    $0x2,%eax
  801f42:	05 40 10 81 00       	add    $0x811040,%eax
  801f47:	8b 10                	mov    (%eax),%edx
  801f49:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801f4c:	01 d0                	add    %edx,%eax
  801f4e:	48                   	dec    %eax
  801f4f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801f52:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f55:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5a:	f7 75 bc             	divl   -0x44(%ebp)
  801f5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f60:	29 d0                	sub    %edx,%eax
  801f62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f68:	89 d0                	mov    %edx,%eax
  801f6a:	01 c0                	add    %eax,%eax
  801f6c:	01 d0                	add    %edx,%eax
  801f6e:	c1 e0 02             	shl    $0x2,%eax
  801f71:	05 48 10 81 00       	add    $0x811048,%eax
  801f76:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7c:	89 d0                	mov    %edx,%eax
  801f7e:	01 c0                	add    %eax,%eax
  801f80:	01 d0                	add    %edx,%eax
  801f82:	c1 e0 02             	shl    $0x2,%eax
  801f85:	05 44 10 81 00       	add    $0x811044,%eax
  801f8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f93:	89 d0                	mov    %edx,%eax
  801f95:	01 c0                	add    %eax,%eax
  801f97:	01 d0                	add    %edx,%eax
  801f99:	c1 e0 02             	shl    $0x2,%eax
  801f9c:	05 40 10 81 00       	add    $0x811040,%eax
  801fa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fa7:	e9 2d 01 00 00       	jmp    8020d9 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801fac:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801fb0:	0f 84 ce 00 00 00    	je     802084 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801fb6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801fbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fc0:	89 d0                	mov    %edx,%eax
  801fc2:	01 c0                	add    %eax,%eax
  801fc4:	01 d0                	add    %edx,%eax
  801fc6:	c1 e0 02             	shl    $0x2,%eax
  801fc9:	05 40 10 81 00       	add    $0x811040,%eax
  801fce:	8b 10                	mov    (%eax),%edx
  801fd0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fd3:	01 d0                	add    %edx,%eax
  801fd5:	48                   	dec    %eax
  801fd6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801fd9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fdc:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe1:	f7 75 c4             	divl   -0x3c(%ebp)
  801fe4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fe7:	29 d0                	sub    %edx,%eax
  801fe9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801fec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fef:	89 d0                	mov    %edx,%eax
  801ff1:	01 c0                	add    %eax,%eax
  801ff3:	01 d0                	add    %edx,%eax
  801ff5:	c1 e0 02             	shl    $0x2,%eax
  801ff8:	05 44 10 81 00       	add    $0x811044,%eax
  801ffd:	8b 00                	mov    (%eax),%eax
  801fff:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802002:	75 47                	jne    80204b <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802004:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802007:	89 d0                	mov    %edx,%eax
  802009:	01 c0                	add    %eax,%eax
  80200b:	01 d0                	add    %edx,%eax
  80200d:	c1 e0 02             	shl    $0x2,%eax
  802010:	05 48 10 81 00       	add    $0x811048,%eax
  802015:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802018:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80201b:	89 d0                	mov    %edx,%eax
  80201d:	01 c0                	add    %eax,%eax
  80201f:	01 d0                	add    %edx,%eax
  802021:	c1 e0 02             	shl    $0x2,%eax
  802024:	05 44 10 81 00       	add    $0x811044,%eax
  802029:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80202f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802032:	89 d0                	mov    %edx,%eax
  802034:	01 c0                	add    %eax,%eax
  802036:	01 d0                	add    %edx,%eax
  802038:	c1 e0 02             	shl    $0x2,%eax
  80203b:	05 40 10 81 00       	add    $0x811040,%eax
  802040:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802046:	e9 8e 00 00 00       	jmp    8020d9 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80204b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80204e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802051:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802054:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802057:	89 d0                	mov    %edx,%eax
  802059:	01 c0                	add    %eax,%eax
  80205b:	01 d0                	add    %edx,%eax
  80205d:	c1 e0 02             	shl    $0x2,%eax
  802060:	05 40 10 81 00       	add    $0x811040,%eax
  802065:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802067:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80206d:	89 c2                	mov    %eax,%edx
  80206f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802072:	89 c8                	mov    %ecx,%eax
  802074:	01 c0                	add    %eax,%eax
  802076:	01 c8                	add    %ecx,%eax
  802078:	c1 e0 02             	shl    $0x2,%eax
  80207b:	05 44 10 81 00       	add    $0x811044,%eax
  802080:	89 10                	mov    %edx,(%eax)
  802082:	eb 55                	jmp    8020d9 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802084:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80208b:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802091:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802094:	01 d0                	add    %edx,%eax
  802096:	48                   	dec    %eax
  802097:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80209a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80209d:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a2:	f7 75 d0             	divl   -0x30(%ebp)
  8020a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020a8:	29 d0                	sub    %edx,%eax
  8020aa:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8020ad:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8020b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020b3:	01 d0                	add    %edx,%eax
  8020b5:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8020ba:	76 0a                	jbe    8020c6 <smalloc+0x29e>
            return NULL;
  8020bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c1:	e9 ba 00 00 00       	jmp    802180 <smalloc+0x358>
        va = start;
  8020c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8020cc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8020cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020d2:	01 d0                	add    %edx,%eax
  8020d4:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8020d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8020e0:	eb 5e                	jmp    802140 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8020e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020e5:	89 d0                	mov    %edx,%eax
  8020e7:	01 c0                	add    %eax,%eax
  8020e9:	01 d0                	add    %edx,%eax
  8020eb:	c1 e0 02             	shl    $0x2,%eax
  8020ee:	05 48 50 80 00       	add    $0x805048,%eax
  8020f3:	8a 00                	mov    (%eax),%al
  8020f5:	84 c0                	test   %al,%al
  8020f7:	75 44                	jne    80213d <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  8020f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020fc:	89 d0                	mov    %edx,%eax
  8020fe:	01 c0                	add    %eax,%eax
  802100:	01 d0                	add    %edx,%eax
  802102:	c1 e0 02             	shl    $0x2,%eax
  802105:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  80210b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80210e:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802110:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802113:	89 d0                	mov    %edx,%eax
  802115:	01 c0                	add    %eax,%eax
  802117:	01 d0                	add    %edx,%eax
  802119:	c1 e0 02             	shl    $0x2,%eax
  80211c:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802122:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802125:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802127:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80212a:	89 d0                	mov    %edx,%eax
  80212c:	01 c0                	add    %eax,%eax
  80212e:	01 d0                	add    %edx,%eax
  802130:	c1 e0 02             	shl    $0x2,%eax
  802133:	05 48 50 80 00       	add    $0x805048,%eax
  802138:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80213b:	eb 0c                	jmp    802149 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80213d:	ff 45 e0             	incl   -0x20(%ebp)
  802140:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802147:	7e 99                	jle    8020e2 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80214c:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802150:	52                   	push   %edx
  802151:	50                   	push   %eax
  802152:	ff 75 d4             	pushl  -0x2c(%ebp)
  802155:	ff 75 08             	pushl  0x8(%ebp)
  802158:	e8 de 0e 00 00       	call   80303b <sys_create_shared_object>
  80215d:	83 c4 10             	add    $0x10,%esp
  802160:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802163:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802167:	75 07                	jne    802170 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802169:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80216e:	eb 10                	jmp    802180 <smalloc+0x358>
    if (r < 0)
  802170:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802174:	79 07                	jns    80217d <smalloc+0x355>
        return NULL;
  802176:	b8 00 00 00 00       	mov    $0x0,%eax
  80217b:	eb 03                	jmp    802180 <smalloc+0x358>
    return (void*)va;
  80217d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802188:	e8 51 f4 ff ff       	call   8015de <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80218d:	83 ec 08             	sub    $0x8,%esp
  802190:	ff 75 0c             	pushl  0xc(%ebp)
  802193:	ff 75 08             	pushl  0x8(%ebp)
  802196:	e8 ca 0e 00 00       	call   803065 <sys_size_of_shared_object>
  80219b:	83 c4 10             	add    $0x10,%esp
  80219e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8021a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8021a5:	7f 0a                	jg     8021b1 <sget+0x2f>
        return NULL;
  8021a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ac:	e9 28 03 00 00       	jmp    8024d9 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8021b1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8021b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8021bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021be:	01 d0                	add    %edx,%eax
  8021c0:	48                   	dec    %eax
  8021c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8021c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021cc:	f7 75 d8             	divl   -0x28(%ebp)
  8021cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021d2:	29 d0                	sub    %edx,%eax
  8021d4:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8021d7:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8021de:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8021e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8021ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8021f3:	e9 85 00 00 00       	jmp    80227d <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8021f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021fb:	89 d0                	mov    %edx,%eax
  8021fd:	01 c0                	add    %eax,%eax
  8021ff:	01 d0                	add    %edx,%eax
  802201:	c1 e0 02             	shl    $0x2,%eax
  802204:	05 48 10 81 00       	add    $0x811048,%eax
  802209:	8a 00                	mov    (%eax),%al
  80220b:	84 c0                	test   %al,%al
  80220d:	74 20                	je     80222f <sget+0xad>
  80220f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802212:	89 d0                	mov    %edx,%eax
  802214:	01 c0                	add    %eax,%eax
  802216:	01 d0                	add    %edx,%eax
  802218:	c1 e0 02             	shl    $0x2,%eax
  80221b:	05 44 10 81 00       	add    $0x811044,%eax
  802220:	8b 00                	mov    (%eax),%eax
  802222:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802225:	75 08                	jne    80222f <sget+0xad>
        {
            exactIdx = i;
  802227:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80222a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80222d:	eb 5b                	jmp    80228a <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80222f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802232:	89 d0                	mov    %edx,%eax
  802234:	01 c0                	add    %eax,%eax
  802236:	01 d0                	add    %edx,%eax
  802238:	c1 e0 02             	shl    $0x2,%eax
  80223b:	05 48 10 81 00       	add    $0x811048,%eax
  802240:	8a 00                	mov    (%eax),%al
  802242:	84 c0                	test   %al,%al
  802244:	74 34                	je     80227a <sget+0xf8>
  802246:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802249:	89 d0                	mov    %edx,%eax
  80224b:	01 c0                	add    %eax,%eax
  80224d:	01 d0                	add    %edx,%eax
  80224f:	c1 e0 02             	shl    $0x2,%eax
  802252:	05 44 10 81 00       	add    $0x811044,%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80225c:	76 1c                	jbe    80227a <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  80225e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802261:	89 d0                	mov    %edx,%eax
  802263:	01 c0                	add    %eax,%eax
  802265:	01 d0                	add    %edx,%eax
  802267:	c1 e0 02             	shl    $0x2,%eax
  80226a:	05 44 10 81 00       	add    $0x811044,%eax
  80226f:	8b 00                	mov    (%eax),%eax
  802271:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802274:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802277:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80227a:	ff 45 e8             	incl   -0x18(%ebp)
  80227d:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802284:	0f 8e 6e ff ff ff    	jle    8021f8 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80228a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802291:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802295:	74 7d                	je     802314 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802297:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80229e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a1:	89 d0                	mov    %edx,%eax
  8022a3:	01 c0                	add    %eax,%eax
  8022a5:	01 d0                	add    %edx,%eax
  8022a7:	c1 e0 02             	shl    $0x2,%eax
  8022aa:	05 40 10 81 00       	add    $0x811040,%eax
  8022af:	8b 10                	mov    (%eax),%edx
  8022b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022b4:	01 d0                	add    %edx,%eax
  8022b6:	48                   	dec    %eax
  8022b7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8022ba:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8022bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c2:	f7 75 b8             	divl   -0x48(%ebp)
  8022c5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8022c8:	29 d0                	sub    %edx,%eax
  8022ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8022cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d0:	89 d0                	mov    %edx,%eax
  8022d2:	01 c0                	add    %eax,%eax
  8022d4:	01 d0                	add    %edx,%eax
  8022d6:	c1 e0 02             	shl    $0x2,%eax
  8022d9:	05 48 10 81 00       	add    $0x811048,%eax
  8022de:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8022e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e4:	89 d0                	mov    %edx,%eax
  8022e6:	01 c0                	add    %eax,%eax
  8022e8:	01 d0                	add    %edx,%eax
  8022ea:	c1 e0 02             	shl    $0x2,%eax
  8022ed:	05 44 10 81 00       	add    $0x811044,%eax
  8022f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8022f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fb:	89 d0                	mov    %edx,%eax
  8022fd:	01 c0                	add    %eax,%eax
  8022ff:	01 d0                	add    %edx,%eax
  802301:	c1 e0 02             	shl    $0x2,%eax
  802304:	05 40 10 81 00       	add    $0x811040,%eax
  802309:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80230f:	e9 2d 01 00 00       	jmp    802441 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802314:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802318:	0f 84 ce 00 00 00    	je     8023ec <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80231e:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802325:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802328:	89 d0                	mov    %edx,%eax
  80232a:	01 c0                	add    %eax,%eax
  80232c:	01 d0                	add    %edx,%eax
  80232e:	c1 e0 02             	shl    $0x2,%eax
  802331:	05 40 10 81 00       	add    $0x811040,%eax
  802336:	8b 10                	mov    (%eax),%edx
  802338:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80233b:	01 d0                	add    %edx,%eax
  80233d:	48                   	dec    %eax
  80233e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802341:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802344:	ba 00 00 00 00       	mov    $0x0,%edx
  802349:	f7 75 c0             	divl   -0x40(%ebp)
  80234c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80234f:	29 d0                	sub    %edx,%eax
  802351:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802354:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802357:	89 d0                	mov    %edx,%eax
  802359:	01 c0                	add    %eax,%eax
  80235b:	01 d0                	add    %edx,%eax
  80235d:	c1 e0 02             	shl    $0x2,%eax
  802360:	05 44 10 81 00       	add    $0x811044,%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80236a:	75 47                	jne    8023b3 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  80236c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80236f:	89 d0                	mov    %edx,%eax
  802371:	01 c0                	add    %eax,%eax
  802373:	01 d0                	add    %edx,%eax
  802375:	c1 e0 02             	shl    $0x2,%eax
  802378:	05 48 10 81 00       	add    $0x811048,%eax
  80237d:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802380:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802383:	89 d0                	mov    %edx,%eax
  802385:	01 c0                	add    %eax,%eax
  802387:	01 d0                	add    %edx,%eax
  802389:	c1 e0 02             	shl    $0x2,%eax
  80238c:	05 44 10 81 00       	add    $0x811044,%eax
  802391:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802397:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80239a:	89 d0                	mov    %edx,%eax
  80239c:	01 c0                	add    %eax,%eax
  80239e:	01 d0                	add    %edx,%eax
  8023a0:	c1 e0 02             	shl    $0x2,%eax
  8023a3:	05 40 10 81 00       	add    $0x811040,%eax
  8023a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ae:	e9 8e 00 00 00       	jmp    802441 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8023b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023b9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8023bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023bf:	89 d0                	mov    %edx,%eax
  8023c1:	01 c0                	add    %eax,%eax
  8023c3:	01 d0                	add    %edx,%eax
  8023c5:	c1 e0 02             	shl    $0x2,%eax
  8023c8:	05 40 10 81 00       	add    $0x811040,%eax
  8023cd:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8023cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d2:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8023d5:	89 c2                	mov    %eax,%edx
  8023d7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8023da:	89 c8                	mov    %ecx,%eax
  8023dc:	01 c0                	add    %eax,%eax
  8023de:	01 c8                	add    %ecx,%eax
  8023e0:	c1 e0 02             	shl    $0x2,%eax
  8023e3:	05 44 10 81 00       	add    $0x811044,%eax
  8023e8:	89 10                	mov    %edx,(%eax)
  8023ea:	eb 55                	jmp    802441 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8023ec:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8023f3:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8023f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023fc:	01 d0                	add    %edx,%eax
  8023fe:	48                   	dec    %eax
  8023ff:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802402:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802405:	ba 00 00 00 00       	mov    $0x0,%edx
  80240a:	f7 75 cc             	divl   -0x34(%ebp)
  80240d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802410:	29 d0                	sub    %edx,%eax
  802412:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802415:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802418:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80241b:	01 d0                	add    %edx,%eax
  80241d:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802422:	76 0a                	jbe    80242e <sget+0x2ac>
            return NULL;
  802424:	b8 00 00 00 00       	mov    $0x0,%eax
  802429:	e9 ab 00 00 00       	jmp    8024d9 <sget+0x357>
        va = start;
  80242e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802434:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802437:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80243a:	01 d0                	add    %edx,%eax
  80243c:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802441:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802448:	eb 5e                	jmp    8024a8 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  80244a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80244d:	89 d0                	mov    %edx,%eax
  80244f:	01 c0                	add    %eax,%eax
  802451:	01 d0                	add    %edx,%eax
  802453:	c1 e0 02             	shl    $0x2,%eax
  802456:	05 48 50 80 00       	add    $0x805048,%eax
  80245b:	8a 00                	mov    (%eax),%al
  80245d:	84 c0                	test   %al,%al
  80245f:	75 44                	jne    8024a5 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802461:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802464:	89 d0                	mov    %edx,%eax
  802466:	01 c0                	add    %eax,%eax
  802468:	01 d0                	add    %edx,%eax
  80246a:	c1 e0 02             	shl    $0x2,%eax
  80246d:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802476:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802478:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80247b:	89 d0                	mov    %edx,%eax
  80247d:	01 c0                	add    %eax,%eax
  80247f:	01 d0                	add    %edx,%eax
  802481:	c1 e0 02             	shl    $0x2,%eax
  802484:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80248a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80248d:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80248f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802492:	89 d0                	mov    %edx,%eax
  802494:	01 c0                	add    %eax,%eax
  802496:	01 d0                	add    %edx,%eax
  802498:	c1 e0 02             	shl    $0x2,%eax
  80249b:	05 48 50 80 00       	add    $0x805048,%eax
  8024a0:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8024a3:	eb 0c                	jmp    8024b1 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024a5:	ff 45 e0             	incl   -0x20(%ebp)
  8024a8:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8024af:	7e 99                	jle    80244a <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8024b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b4:	83 ec 04             	sub    $0x4,%esp
  8024b7:	50                   	push   %eax
  8024b8:	ff 75 0c             	pushl  0xc(%ebp)
  8024bb:	ff 75 08             	pushl  0x8(%ebp)
  8024be:	e8 bf 0b 00 00       	call   803082 <sys_get_shared_object>
  8024c3:	83 c4 10             	add    $0x10,%esp
  8024c6:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8024c9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024cd:	79 07                	jns    8024d6 <sget+0x354>
        return NULL;
  8024cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d4:	eb 03                	jmp    8024d9 <sget+0x357>
    return (void*)va;
  8024d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024e1:	e8 f8 f0 ff ff       	call   8015de <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8024e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024ea:	75 13                	jne    8024ff <realloc+0x24>
		return malloc(new_size);
  8024ec:	83 ec 0c             	sub    $0xc,%esp
  8024ef:	ff 75 0c             	pushl  0xc(%ebp)
  8024f2:	e8 c4 f1 ff ff       	call   8016bb <malloc>
  8024f7:	83 c4 10             	add    $0x10,%esp
  8024fa:	e9 f4 05 00 00       	jmp    802af3 <realloc+0x618>
	if (new_size == 0)
  8024ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802503:	75 18                	jne    80251d <realloc+0x42>
	{
		free(virtual_address);
  802505:	83 ec 0c             	sub    $0xc,%esp
  802508:	ff 75 08             	pushl  0x8(%ebp)
  80250b:	e8 0b f5 ff ff       	call   801a1b <free>
  802510:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802513:	b8 00 00 00 00       	mov    $0x0,%eax
  802518:	e9 d6 05 00 00       	jmp    802af3 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  80251d:	8b 45 08             	mov    0x8(%ebp),%eax
  802520:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802523:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	79 74                	jns    80259e <realloc+0xc3>
  80252a:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802531:	77 6b                	ja     80259e <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802533:	83 ec 0c             	sub    $0xc,%esp
  802536:	ff 75 0c             	pushl  0xc(%ebp)
  802539:	e8 7d f1 ff ff       	call   8016bb <malloc>
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802544:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802548:	75 0a                	jne    802554 <realloc+0x79>
			return NULL;
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
  80254f:	e9 9f 05 00 00       	jmp    802af3 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802554:	83 ec 0c             	sub    $0xc,%esp
  802557:	ff 75 08             	pushl  0x8(%ebp)
  80255a:	e8 e0 11 00 00       	call   80373f <get_block_size>
  80255f:	83 c4 10             	add    $0x10,%esp
  802562:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802565:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256b:	39 d0                	cmp    %edx,%eax
  80256d:	76 02                	jbe    802571 <realloc+0x96>
  80256f:	89 d0                	mov    %edx,%eax
  802571:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	ff 75 c0             	pushl  -0x40(%ebp)
  80257a:	ff 75 08             	pushl  0x8(%ebp)
  80257d:	ff 75 c8             	pushl  -0x38(%ebp)
  802580:	e8 56 eb ff ff       	call   8010db <memmove>
  802585:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802588:	83 ec 0c             	sub    $0xc,%esp
  80258b:	ff 75 08             	pushl  0x8(%ebp)
  80258e:	e8 88 f4 ff ff       	call   801a1b <free>
  802593:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802596:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802599:	e9 55 05 00 00       	jmp    802af3 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80259e:	a1 30 51 83 00       	mov    0x835130,%eax
  8025a3:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8025a6:	72 09                	jb     8025b1 <realloc+0xd6>
  8025a8:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8025af:	76 0a                	jbe    8025bb <realloc+0xe0>
		return NULL;
  8025b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b6:	e9 38 05 00 00       	jmp    802af3 <realloc+0x618>
	uint32 oldsz = 0;
  8025bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8025c2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8025d0:	eb 50                	jmp    802622 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8025d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d5:	89 d0                	mov    %edx,%eax
  8025d7:	01 c0                	add    %eax,%eax
  8025d9:	01 d0                	add    %edx,%eax
  8025db:	c1 e0 02             	shl    $0x2,%eax
  8025de:	05 48 50 80 00       	add    $0x805048,%eax
  8025e3:	8a 00                	mov    (%eax),%al
  8025e5:	84 c0                	test   %al,%al
  8025e7:	74 36                	je     80261f <realloc+0x144>
  8025e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ec:	89 d0                	mov    %edx,%eax
  8025ee:	01 c0                	add    %eax,%eax
  8025f0:	01 d0                	add    %edx,%eax
  8025f2:	c1 e0 02             	shl    $0x2,%eax
  8025f5:	05 40 50 80 00       	add    $0x805040,%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8025ff:	75 1e                	jne    80261f <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802601:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802604:	89 d0                	mov    %edx,%eax
  802606:	01 c0                	add    %eax,%eax
  802608:	01 d0                	add    %edx,%eax
  80260a:	c1 e0 02             	shl    $0x2,%eax
  80260d:	05 44 50 80 00       	add    $0x805044,%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80261d:	eb 0c                	jmp    80262b <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80261f:	ff 45 ec             	incl   -0x14(%ebp)
  802622:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802629:	7e a7                	jle    8025d2 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  80262b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80262f:	75 0a                	jne    80263b <realloc+0x160>
		return NULL;
  802631:	b8 00 00 00 00       	mov    $0x0,%eax
  802636:	e9 b8 04 00 00       	jmp    802af3 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  80263b:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802642:	8b 55 0c             	mov    0xc(%ebp),%edx
  802645:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802648:	01 d0                	add    %edx,%eax
  80264a:	48                   	dec    %eax
  80264b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80264e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802651:	ba 00 00 00 00       	mov    $0x0,%edx
  802656:	f7 75 bc             	divl   -0x44(%ebp)
  802659:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80265c:	29 d0                	sub    %edx,%eax
  80265e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802661:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802664:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802667:	75 08                	jne    802671 <realloc+0x196>
		return virtual_address;
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	e9 82 04 00 00       	jmp    802af3 <realloc+0x618>
	if (req < oldsz)
  802671:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802674:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802677:	0f 83 cd 02 00 00    	jae    80294a <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802683:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802686:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802689:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80268c:	01 d0                	add    %edx,%eax
  80268e:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802691:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802694:	89 d0                	mov    %edx,%eax
  802696:	01 c0                	add    %eax,%eax
  802698:	01 d0                	add    %edx,%eax
  80269a:	c1 e0 02             	shl    $0x2,%eax
  80269d:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8026a3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026a6:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8026a8:	83 ec 08             	sub    $0x8,%esp
  8026ab:	ff 75 b0             	pushl  -0x50(%ebp)
  8026ae:	ff 75 ac             	pushl  -0x54(%ebp)
  8026b1:	e8 e3 0c 00 00       	call   803399 <sys_free_user_mem>
  8026b6:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8026b9:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8026c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8026c7:	eb 64                	jmp    80272d <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8026c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026cc:	89 d0                	mov    %edx,%eax
  8026ce:	01 c0                	add    %eax,%eax
  8026d0:	01 d0                	add    %edx,%eax
  8026d2:	c1 e0 02             	shl    $0x2,%eax
  8026d5:	05 48 10 81 00       	add    $0x811048,%eax
  8026da:	8a 00                	mov    (%eax),%al
  8026dc:	84 c0                	test   %al,%al
  8026de:	75 4a                	jne    80272a <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8026e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026e3:	89 d0                	mov    %edx,%eax
  8026e5:	01 c0                	add    %eax,%eax
  8026e7:	01 d0                	add    %edx,%eax
  8026e9:	c1 e0 02             	shl    $0x2,%eax
  8026ec:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  8026f2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8026f5:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  8026f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026fa:	89 d0                	mov    %edx,%eax
  8026fc:	01 c0                	add    %eax,%eax
  8026fe:	01 d0                	add    %edx,%eax
  802700:	c1 e0 02             	shl    $0x2,%eax
  802703:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802709:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80270c:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  80270e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802711:	89 d0                	mov    %edx,%eax
  802713:	01 c0                	add    %eax,%eax
  802715:	01 d0                	add    %edx,%eax
  802717:	c1 e0 02             	shl    $0x2,%eax
  80271a:	05 48 10 81 00       	add    $0x811048,%eax
  80271f:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802725:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802728:	eb 0c                	jmp    802736 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80272a:	ff 45 e4             	incl   -0x1c(%ebp)
  80272d:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802734:	7e 93                	jle    8026c9 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802736:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80273a:	0f 84 8d 01 00 00    	je     8028cd <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802740:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802747:	e9 74 01 00 00       	jmp    8028c0 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  80274c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802752:	0f 84 64 01 00 00    	je     8028bc <realloc+0x3e1>
				if (uhp_frees[k].free)
  802758:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80275b:	89 d0                	mov    %edx,%eax
  80275d:	01 c0                	add    %eax,%eax
  80275f:	01 d0                	add    %edx,%eax
  802761:	c1 e0 02             	shl    $0x2,%eax
  802764:	05 48 10 81 00       	add    $0x811048,%eax
  802769:	8a 00                	mov    (%eax),%al
  80276b:	84 c0                	test   %al,%al
  80276d:	0f 84 4a 01 00 00    	je     8028bd <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802773:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802776:	89 d0                	mov    %edx,%eax
  802778:	01 c0                	add    %eax,%eax
  80277a:	01 d0                	add    %edx,%eax
  80277c:	c1 e0 02             	shl    $0x2,%eax
  80277f:	05 40 10 81 00       	add    $0x811040,%eax
  802784:	8b 08                	mov    (%eax),%ecx
  802786:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802789:	89 d0                	mov    %edx,%eax
  80278b:	01 c0                	add    %eax,%eax
  80278d:	01 d0                	add    %edx,%eax
  80278f:	c1 e0 02             	shl    $0x2,%eax
  802792:	05 44 10 81 00       	add    $0x811044,%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	01 c1                	add    %eax,%ecx
  80279b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80279e:	89 d0                	mov    %edx,%eax
  8027a0:	01 c0                	add    %eax,%eax
  8027a2:	01 d0                	add    %edx,%eax
  8027a4:	c1 e0 02             	shl    $0x2,%eax
  8027a7:	05 40 10 81 00       	add    $0x811040,%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	39 c1                	cmp    %eax,%ecx
  8027b0:	75 7a                	jne    80282c <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8027b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027b5:	89 d0                	mov    %edx,%eax
  8027b7:	01 c0                	add    %eax,%eax
  8027b9:	01 d0                	add    %edx,%eax
  8027bb:	c1 e0 02             	shl    $0x2,%eax
  8027be:	05 40 10 81 00       	add    $0x811040,%eax
  8027c3:	8b 10                	mov    (%eax),%edx
  8027c5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8027c8:	89 c8                	mov    %ecx,%eax
  8027ca:	01 c0                	add    %eax,%eax
  8027cc:	01 c8                	add    %ecx,%eax
  8027ce:	c1 e0 02             	shl    $0x2,%eax
  8027d1:	05 40 10 81 00       	add    $0x811040,%eax
  8027d6:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  8027d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027db:	89 d0                	mov    %edx,%eax
  8027dd:	01 c0                	add    %eax,%eax
  8027df:	01 d0                	add    %edx,%eax
  8027e1:	c1 e0 02             	shl    $0x2,%eax
  8027e4:	05 44 10 81 00       	add    $0x811044,%eax
  8027e9:	8b 08                	mov    (%eax),%ecx
  8027eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027ee:	89 d0                	mov    %edx,%eax
  8027f0:	01 c0                	add    %eax,%eax
  8027f2:	01 d0                	add    %edx,%eax
  8027f4:	c1 e0 02             	shl    $0x2,%eax
  8027f7:	05 44 10 81 00       	add    $0x811044,%eax
  8027fc:	8b 00                	mov    (%eax),%eax
  8027fe:	01 c1                	add    %eax,%ecx
  802800:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802803:	89 d0                	mov    %edx,%eax
  802805:	01 c0                	add    %eax,%eax
  802807:	01 d0                	add    %edx,%eax
  802809:	c1 e0 02             	shl    $0x2,%eax
  80280c:	05 44 10 81 00       	add    $0x811044,%eax
  802811:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802813:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802816:	89 d0                	mov    %edx,%eax
  802818:	01 c0                	add    %eax,%eax
  80281a:	01 d0                	add    %edx,%eax
  80281c:	c1 e0 02             	shl    $0x2,%eax
  80281f:	05 48 10 81 00       	add    $0x811048,%eax
  802824:	c6 00 00             	movb   $0x0,(%eax)
  802827:	e9 91 00 00 00       	jmp    8028bd <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  80282c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80282f:	89 d0                	mov    %edx,%eax
  802831:	01 c0                	add    %eax,%eax
  802833:	01 d0                	add    %edx,%eax
  802835:	c1 e0 02             	shl    $0x2,%eax
  802838:	05 40 10 81 00       	add    $0x811040,%eax
  80283d:	8b 08                	mov    (%eax),%ecx
  80283f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802842:	89 d0                	mov    %edx,%eax
  802844:	01 c0                	add    %eax,%eax
  802846:	01 d0                	add    %edx,%eax
  802848:	c1 e0 02             	shl    $0x2,%eax
  80284b:	05 44 10 81 00       	add    $0x811044,%eax
  802850:	8b 00                	mov    (%eax),%eax
  802852:	01 c1                	add    %eax,%ecx
  802854:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802857:	89 d0                	mov    %edx,%eax
  802859:	01 c0                	add    %eax,%eax
  80285b:	01 d0                	add    %edx,%eax
  80285d:	c1 e0 02             	shl    $0x2,%eax
  802860:	05 40 10 81 00       	add    $0x811040,%eax
  802865:	8b 00                	mov    (%eax),%eax
  802867:	39 c1                	cmp    %eax,%ecx
  802869:	75 52                	jne    8028bd <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  80286b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80286e:	89 d0                	mov    %edx,%eax
  802870:	01 c0                	add    %eax,%eax
  802872:	01 d0                	add    %edx,%eax
  802874:	c1 e0 02             	shl    $0x2,%eax
  802877:	05 44 10 81 00       	add    $0x811044,%eax
  80287c:	8b 08                	mov    (%eax),%ecx
  80287e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802881:	89 d0                	mov    %edx,%eax
  802883:	01 c0                	add    %eax,%eax
  802885:	01 d0                	add    %edx,%eax
  802887:	c1 e0 02             	shl    $0x2,%eax
  80288a:	05 44 10 81 00       	add    $0x811044,%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	01 c1                	add    %eax,%ecx
  802893:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802896:	89 d0                	mov    %edx,%eax
  802898:	01 c0                	add    %eax,%eax
  80289a:	01 d0                	add    %edx,%eax
  80289c:	c1 e0 02             	shl    $0x2,%eax
  80289f:	05 44 10 81 00       	add    $0x811044,%eax
  8028a4:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8028a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028a9:	89 d0                	mov    %edx,%eax
  8028ab:	01 c0                	add    %eax,%eax
  8028ad:	01 d0                	add    %edx,%eax
  8028af:	c1 e0 02             	shl    $0x2,%eax
  8028b2:	05 48 10 81 00       	add    $0x811048,%eax
  8028b7:	c6 00 00             	movb   $0x0,(%eax)
  8028ba:	eb 01                	jmp    8028bd <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  8028bc:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8028bd:	ff 45 e0             	incl   -0x20(%ebp)
  8028c0:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8028c7:	0f 8e 7f fe ff ff    	jle    80274c <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  8028cd:	a1 30 51 83 00       	mov    0x835130,%eax
  8028d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8028d5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8028dc:	eb 53                	jmp    802931 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  8028de:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028e1:	89 d0                	mov    %edx,%eax
  8028e3:	01 c0                	add    %eax,%eax
  8028e5:	01 d0                	add    %edx,%eax
  8028e7:	c1 e0 02             	shl    $0x2,%eax
  8028ea:	05 48 50 80 00       	add    $0x805048,%eax
  8028ef:	8a 00                	mov    (%eax),%al
  8028f1:	84 c0                	test   %al,%al
  8028f3:	74 39                	je     80292e <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8028f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028f8:	89 d0                	mov    %edx,%eax
  8028fa:	01 c0                	add    %eax,%eax
  8028fc:	01 d0                	add    %edx,%eax
  8028fe:	c1 e0 02             	shl    $0x2,%eax
  802901:	05 40 50 80 00       	add    $0x805040,%eax
  802906:	8b 08                	mov    (%eax),%ecx
  802908:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80290b:	89 d0                	mov    %edx,%eax
  80290d:	01 c0                	add    %eax,%eax
  80290f:	01 d0                	add    %edx,%eax
  802911:	c1 e0 02             	shl    $0x2,%eax
  802914:	05 44 50 80 00       	add    $0x805044,%eax
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	01 c8                	add    %ecx,%eax
  80291d:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802920:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802923:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802926:	76 06                	jbe    80292e <realloc+0x453>
  802928:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80292b:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80292e:	ff 45 d8             	incl   -0x28(%ebp)
  802931:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802938:	7e a4                	jle    8028de <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  80293a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80293d:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	e9 a9 01 00 00       	jmp    802af3 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  80294a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	01 d0                	add    %edx,%eax
  802952:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802955:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80295c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802963:	eb 57                	jmp    8029bc <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802965:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802968:	89 d0                	mov    %edx,%eax
  80296a:	01 c0                	add    %eax,%eax
  80296c:	01 d0                	add    %edx,%eax
  80296e:	c1 e0 02             	shl    $0x2,%eax
  802971:	05 48 10 81 00       	add    $0x811048,%eax
  802976:	8a 00                	mov    (%eax),%al
  802978:	84 c0                	test   %al,%al
  80297a:	74 3d                	je     8029b9 <realloc+0x4de>
  80297c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80297f:	89 d0                	mov    %edx,%eax
  802981:	01 c0                	add    %eax,%eax
  802983:	01 d0                	add    %edx,%eax
  802985:	c1 e0 02             	shl    $0x2,%eax
  802988:	05 40 10 81 00       	add    $0x811040,%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802992:	75 25                	jne    8029b9 <realloc+0x4de>
  802994:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802997:	89 d0                	mov    %edx,%eax
  802999:	01 c0                	add    %eax,%eax
  80299b:	01 d0                	add    %edx,%eax
  80299d:	c1 e0 02             	shl    $0x2,%eax
  8029a0:	05 44 10 81 00       	add    $0x811044,%eax
  8029a5:	8b 10                	mov    (%eax),%edx
  8029a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029aa:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8029ad:	39 c2                	cmp    %eax,%edx
  8029af:	72 08                	jb     8029b9 <realloc+0x4de>
		{
			adjIdx = j; break;
  8029b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8029b7:	eb 0c                	jmp    8029c5 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029b9:	ff 45 d0             	incl   -0x30(%ebp)
  8029bc:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  8029c3:	7e a0                	jle    802965 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  8029c5:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  8029c9:	0f 84 d6 00 00 00    	je     802aa5 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  8029cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029d2:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8029d5:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  8029d8:	83 ec 08             	sub    $0x8,%esp
  8029db:	ff 75 a0             	pushl  -0x60(%ebp)
  8029de:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029e1:	e8 cf 09 00 00       	call   8033b5 <sys_allocate_user_mem>
  8029e6:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  8029e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ec:	89 d0                	mov    %edx,%eax
  8029ee:	01 c0                	add    %eax,%eax
  8029f0:	01 d0                	add    %edx,%eax
  8029f2:	c1 e0 02             	shl    $0x2,%eax
  8029f5:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8029fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029fe:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802a00:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a03:	89 d0                	mov    %edx,%eax
  802a05:	01 c0                	add    %eax,%eax
  802a07:	01 d0                	add    %edx,%eax
  802a09:	c1 e0 02             	shl    $0x2,%eax
  802a0c:	05 40 10 81 00       	add    $0x811040,%eax
  802a11:	8b 10                	mov    (%eax),%edx
  802a13:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a16:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802a19:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a1c:	89 d0                	mov    %edx,%eax
  802a1e:	01 c0                	add    %eax,%eax
  802a20:	01 d0                	add    %edx,%eax
  802a22:	c1 e0 02             	shl    $0x2,%eax
  802a25:	05 40 10 81 00       	add    $0x811040,%eax
  802a2a:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802a2c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a2f:	89 d0                	mov    %edx,%eax
  802a31:	01 c0                	add    %eax,%eax
  802a33:	01 d0                	add    %edx,%eax
  802a35:	c1 e0 02             	shl    $0x2,%eax
  802a38:	05 44 10 81 00       	add    $0x811044,%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802a42:	89 c2                	mov    %eax,%edx
  802a44:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802a47:	89 c8                	mov    %ecx,%eax
  802a49:	01 c0                	add    %eax,%eax
  802a4b:	01 c8                	add    %ecx,%eax
  802a4d:	c1 e0 02             	shl    $0x2,%eax
  802a50:	05 44 10 81 00       	add    $0x811044,%eax
  802a55:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802a57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a5a:	89 d0                	mov    %edx,%eax
  802a5c:	01 c0                	add    %eax,%eax
  802a5e:	01 d0                	add    %edx,%eax
  802a60:	c1 e0 02             	shl    $0x2,%eax
  802a63:	05 44 10 81 00       	add    $0x811044,%eax
  802a68:	8b 00                	mov    (%eax),%eax
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	75 14                	jne    802a82 <realloc+0x5a7>
  802a6e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a71:	89 d0                	mov    %edx,%eax
  802a73:	01 c0                	add    %eax,%eax
  802a75:	01 d0                	add    %edx,%eax
  802a77:	c1 e0 02             	shl    $0x2,%eax
  802a7a:	05 48 10 81 00       	add    $0x811048,%eax
  802a7f:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802a82:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a85:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a88:	01 c2                	add    %eax,%edx
  802a8a:	a1 88 50 83 00       	mov    0x835088,%eax
  802a8f:	39 c2                	cmp    %eax,%edx
  802a91:	76 0d                	jbe    802aa0 <realloc+0x5c5>
  802a93:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a96:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a99:	01 d0                	add    %edx,%eax
  802a9b:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	eb 4e                	jmp    802af3 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802aa5:	83 ec 0c             	sub    $0xc,%esp
  802aa8:	ff 75 0c             	pushl  0xc(%ebp)
  802aab:	e8 0b ec ff ff       	call   8016bb <malloc>
  802ab0:	83 c4 10             	add    $0x10,%esp
  802ab3:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802ab6:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802aba:	75 07                	jne    802ac3 <realloc+0x5e8>
		return NULL;
  802abc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac1:	eb 30                	jmp    802af3 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802ac3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ac9:	39 d0                	cmp    %edx,%eax
  802acb:	76 02                	jbe    802acf <realloc+0x5f4>
  802acd:	89 d0                	mov    %edx,%eax
  802acf:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802ad2:	83 ec 04             	sub    $0x4,%esp
  802ad5:	50                   	push   %eax
  802ad6:	52                   	push   %edx
  802ad7:	ff 75 cc             	pushl  -0x34(%ebp)
  802ada:	e8 cf 06 00 00       	call   8031ae <sys_move_user_mem>
  802adf:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802ae2:	83 ec 0c             	sub    $0xc,%esp
  802ae5:	ff 75 08             	pushl  0x8(%ebp)
  802ae8:	e8 2e ef ff ff       	call   801a1b <free>
  802aed:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802af0:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802af3:	c9                   	leave  
  802af4:	c3                   	ret    

00802af5 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802af5:	55                   	push   %ebp
  802af6:	89 e5                	mov    %esp,%ebp
  802af8:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802b01:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b05:	0f 84 33 03 00 00    	je     802e3e <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802b0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b0e:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802b13:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802b16:	83 ec 08             	sub    $0x8,%esp
  802b19:	ff 75 08             	pushl  0x8(%ebp)
  802b1c:	ff 75 d8             	pushl  -0x28(%ebp)
  802b1f:	e8 7d 05 00 00       	call   8030a1 <sys_delete_shared_object>
  802b24:	83 c4 10             	add    $0x10,%esp
  802b27:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802b2a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b2e:	0f 88 0d 03 00 00    	js     802e41 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b3b:	e9 ef 02 00 00       	jmp    802e2f <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b43:	89 d0                	mov    %edx,%eax
  802b45:	01 c0                	add    %eax,%eax
  802b47:	01 d0                	add    %edx,%eax
  802b49:	c1 e0 02             	shl    $0x2,%eax
  802b4c:	05 48 50 80 00       	add    $0x805048,%eax
  802b51:	8a 00                	mov    (%eax),%al
  802b53:	84 c0                	test   %al,%al
  802b55:	0f 84 d1 02 00 00    	je     802e2c <sfree+0x337>
  802b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5e:	89 d0                	mov    %edx,%eax
  802b60:	01 c0                	add    %eax,%eax
  802b62:	01 d0                	add    %edx,%eax
  802b64:	c1 e0 02             	shl    $0x2,%eax
  802b67:	05 40 50 80 00       	add    $0x805040,%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802b71:	0f 85 b5 02 00 00    	jne    802e2c <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7a:	89 d0                	mov    %edx,%eax
  802b7c:	01 c0                	add    %eax,%eax
  802b7e:	01 d0                	add    %edx,%eax
  802b80:	c1 e0 02             	shl    $0x2,%eax
  802b83:	05 44 50 80 00       	add    $0x805044,%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b90:	89 d0                	mov    %edx,%eax
  802b92:	01 c0                	add    %eax,%eax
  802b94:	01 d0                	add    %edx,%eax
  802b96:	c1 e0 02             	shl    $0x2,%eax
  802b99:	05 48 50 80 00       	add    $0x805048,%eax
  802b9e:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802ba1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ba8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802baf:	eb 64                	jmp    802c15 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802bb1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb4:	89 d0                	mov    %edx,%eax
  802bb6:	01 c0                	add    %eax,%eax
  802bb8:	01 d0                	add    %edx,%eax
  802bba:	c1 e0 02             	shl    $0x2,%eax
  802bbd:	05 48 10 81 00       	add    $0x811048,%eax
  802bc2:	8a 00                	mov    (%eax),%al
  802bc4:	84 c0                	test   %al,%al
  802bc6:	75 4a                	jne    802c12 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802bc8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bcb:	89 d0                	mov    %edx,%eax
  802bcd:	01 c0                	add    %eax,%eax
  802bcf:	01 d0                	add    %edx,%eax
  802bd1:	c1 e0 02             	shl    $0x2,%eax
  802bd4:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802bda:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bdd:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802bdf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802be2:	89 d0                	mov    %edx,%eax
  802be4:	01 c0                	add    %eax,%eax
  802be6:	01 d0                	add    %edx,%eax
  802be8:	c1 e0 02             	shl    $0x2,%eax
  802beb:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802bf1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bf4:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802bf6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bf9:	89 d0                	mov    %edx,%eax
  802bfb:	01 c0                	add    %eax,%eax
  802bfd:	01 d0                	add    %edx,%eax
  802bff:	c1 e0 02             	shl    $0x2,%eax
  802c02:	05 48 10 81 00       	add    $0x811048,%eax
  802c07:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802c0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802c10:	eb 0c                	jmp    802c1e <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c12:	ff 45 ec             	incl   -0x14(%ebp)
  802c15:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c1c:	7e 93                	jle    802bb1 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802c1e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c22:	0f 84 8d 01 00 00    	je     802db5 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802c2f:	e9 74 01 00 00       	jmp    802da8 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802c34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c3a:	0f 84 64 01 00 00    	je     802da4 <sfree+0x2af>
					if (uhp_frees[k].free)
  802c40:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c43:	89 d0                	mov    %edx,%eax
  802c45:	01 c0                	add    %eax,%eax
  802c47:	01 d0                	add    %edx,%eax
  802c49:	c1 e0 02             	shl    $0x2,%eax
  802c4c:	05 48 10 81 00       	add    $0x811048,%eax
  802c51:	8a 00                	mov    (%eax),%al
  802c53:	84 c0                	test   %al,%al
  802c55:	0f 84 4a 01 00 00    	je     802da5 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802c5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c5e:	89 d0                	mov    %edx,%eax
  802c60:	01 c0                	add    %eax,%eax
  802c62:	01 d0                	add    %edx,%eax
  802c64:	c1 e0 02             	shl    $0x2,%eax
  802c67:	05 40 10 81 00       	add    $0x811040,%eax
  802c6c:	8b 08                	mov    (%eax),%ecx
  802c6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c71:	89 d0                	mov    %edx,%eax
  802c73:	01 c0                	add    %eax,%eax
  802c75:	01 d0                	add    %edx,%eax
  802c77:	c1 e0 02             	shl    $0x2,%eax
  802c7a:	05 44 10 81 00       	add    $0x811044,%eax
  802c7f:	8b 00                	mov    (%eax),%eax
  802c81:	01 c1                	add    %eax,%ecx
  802c83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c86:	89 d0                	mov    %edx,%eax
  802c88:	01 c0                	add    %eax,%eax
  802c8a:	01 d0                	add    %edx,%eax
  802c8c:	c1 e0 02             	shl    $0x2,%eax
  802c8f:	05 40 10 81 00       	add    $0x811040,%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	39 c1                	cmp    %eax,%ecx
  802c98:	75 7a                	jne    802d14 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802c9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c9d:	89 d0                	mov    %edx,%eax
  802c9f:	01 c0                	add    %eax,%eax
  802ca1:	01 d0                	add    %edx,%eax
  802ca3:	c1 e0 02             	shl    $0x2,%eax
  802ca6:	05 40 10 81 00       	add    $0x811040,%eax
  802cab:	8b 10                	mov    (%eax),%edx
  802cad:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802cb0:	89 c8                	mov    %ecx,%eax
  802cb2:	01 c0                	add    %eax,%eax
  802cb4:	01 c8                	add    %ecx,%eax
  802cb6:	c1 e0 02             	shl    $0x2,%eax
  802cb9:	05 40 10 81 00       	add    $0x811040,%eax
  802cbe:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802cc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc3:	89 d0                	mov    %edx,%eax
  802cc5:	01 c0                	add    %eax,%eax
  802cc7:	01 d0                	add    %edx,%eax
  802cc9:	c1 e0 02             	shl    $0x2,%eax
  802ccc:	05 44 10 81 00       	add    $0x811044,%eax
  802cd1:	8b 08                	mov    (%eax),%ecx
  802cd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cd6:	89 d0                	mov    %edx,%eax
  802cd8:	01 c0                	add    %eax,%eax
  802cda:	01 d0                	add    %edx,%eax
  802cdc:	c1 e0 02             	shl    $0x2,%eax
  802cdf:	05 44 10 81 00       	add    $0x811044,%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	01 c1                	add    %eax,%ecx
  802ce8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ceb:	89 d0                	mov    %edx,%eax
  802ced:	01 c0                	add    %eax,%eax
  802cef:	01 d0                	add    %edx,%eax
  802cf1:	c1 e0 02             	shl    $0x2,%eax
  802cf4:	05 44 10 81 00       	add    $0x811044,%eax
  802cf9:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802cfb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cfe:	89 d0                	mov    %edx,%eax
  802d00:	01 c0                	add    %eax,%eax
  802d02:	01 d0                	add    %edx,%eax
  802d04:	c1 e0 02             	shl    $0x2,%eax
  802d07:	05 48 10 81 00       	add    $0x811048,%eax
  802d0c:	c6 00 00             	movb   $0x0,(%eax)
  802d0f:	e9 91 00 00 00       	jmp    802da5 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d17:	89 d0                	mov    %edx,%eax
  802d19:	01 c0                	add    %eax,%eax
  802d1b:	01 d0                	add    %edx,%eax
  802d1d:	c1 e0 02             	shl    $0x2,%eax
  802d20:	05 40 10 81 00       	add    $0x811040,%eax
  802d25:	8b 08                	mov    (%eax),%ecx
  802d27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2a:	89 d0                	mov    %edx,%eax
  802d2c:	01 c0                	add    %eax,%eax
  802d2e:	01 d0                	add    %edx,%eax
  802d30:	c1 e0 02             	shl    $0x2,%eax
  802d33:	05 44 10 81 00       	add    $0x811044,%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	01 c1                	add    %eax,%ecx
  802d3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d3f:	89 d0                	mov    %edx,%eax
  802d41:	01 c0                	add    %eax,%eax
  802d43:	01 d0                	add    %edx,%eax
  802d45:	c1 e0 02             	shl    $0x2,%eax
  802d48:	05 40 10 81 00       	add    $0x811040,%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	39 c1                	cmp    %eax,%ecx
  802d51:	75 52                	jne    802da5 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d56:	89 d0                	mov    %edx,%eax
  802d58:	01 c0                	add    %eax,%eax
  802d5a:	01 d0                	add    %edx,%eax
  802d5c:	c1 e0 02             	shl    $0x2,%eax
  802d5f:	05 44 10 81 00       	add    $0x811044,%eax
  802d64:	8b 08                	mov    (%eax),%ecx
  802d66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d69:	89 d0                	mov    %edx,%eax
  802d6b:	01 c0                	add    %eax,%eax
  802d6d:	01 d0                	add    %edx,%eax
  802d6f:	c1 e0 02             	shl    $0x2,%eax
  802d72:	05 44 10 81 00       	add    $0x811044,%eax
  802d77:	8b 00                	mov    (%eax),%eax
  802d79:	01 c1                	add    %eax,%ecx
  802d7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d7e:	89 d0                	mov    %edx,%eax
  802d80:	01 c0                	add    %eax,%eax
  802d82:	01 d0                	add    %edx,%eax
  802d84:	c1 e0 02             	shl    $0x2,%eax
  802d87:	05 44 10 81 00       	add    $0x811044,%eax
  802d8c:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d91:	89 d0                	mov    %edx,%eax
  802d93:	01 c0                	add    %eax,%eax
  802d95:	01 d0                	add    %edx,%eax
  802d97:	c1 e0 02             	shl    $0x2,%eax
  802d9a:	05 48 10 81 00       	add    $0x811048,%eax
  802d9f:	c6 00 00             	movb   $0x0,(%eax)
  802da2:	eb 01                	jmp    802da5 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802da4:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802da5:	ff 45 e8             	incl   -0x18(%ebp)
  802da8:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802daf:	0f 8e 7f fe ff ff    	jle    802c34 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802db5:	a1 30 51 83 00       	mov    0x835130,%eax
  802dba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802dbd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802dc4:	eb 53                	jmp    802e19 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802dc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dc9:	89 d0                	mov    %edx,%eax
  802dcb:	01 c0                	add    %eax,%eax
  802dcd:	01 d0                	add    %edx,%eax
  802dcf:	c1 e0 02             	shl    $0x2,%eax
  802dd2:	05 48 50 80 00       	add    $0x805048,%eax
  802dd7:	8a 00                	mov    (%eax),%al
  802dd9:	84 c0                	test   %al,%al
  802ddb:	74 39                	je     802e16 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802ddd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802de0:	89 d0                	mov    %edx,%eax
  802de2:	01 c0                	add    %eax,%eax
  802de4:	01 d0                	add    %edx,%eax
  802de6:	c1 e0 02             	shl    $0x2,%eax
  802de9:	05 40 50 80 00       	add    $0x805040,%eax
  802dee:	8b 08                	mov    (%eax),%ecx
  802df0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802df3:	89 d0                	mov    %edx,%eax
  802df5:	01 c0                	add    %eax,%eax
  802df7:	01 d0                	add    %edx,%eax
  802df9:	c1 e0 02             	shl    $0x2,%eax
  802dfc:	05 44 50 80 00       	add    $0x805044,%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	01 c8                	add    %ecx,%eax
  802e05:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802e08:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e0b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e0e:	76 06                	jbe    802e16 <sfree+0x321>
  802e10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e16:	ff 45 e0             	incl   -0x20(%ebp)
  802e19:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e20:	7e a4                	jle    802dc6 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e25:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802e2a:	eb 16                	jmp    802e42 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e2c:	ff 45 f4             	incl   -0xc(%ebp)
  802e2f:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802e36:	0f 8e 04 fd ff ff    	jle    802b40 <sfree+0x4b>
  802e3c:	eb 04                	jmp    802e42 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802e3e:	90                   	nop
  802e3f:	eb 01                	jmp    802e42 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802e41:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802e42:	c9                   	leave  
  802e43:	c3                   	ret    

00802e44 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e44:	55                   	push   %ebp
  802e45:	89 e5                	mov    %esp,%ebp
  802e47:	57                   	push   %edi
  802e48:	56                   	push   %esi
  802e49:	53                   	push   %ebx
  802e4a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e56:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e59:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e5c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e5f:	cd 30                	int    $0x30
  802e61:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e67:	83 c4 10             	add    $0x10,%esp
  802e6a:	5b                   	pop    %ebx
  802e6b:	5e                   	pop    %esi
  802e6c:	5f                   	pop    %edi
  802e6d:	5d                   	pop    %ebp
  802e6e:	c3                   	ret    

00802e6f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802e6f:	55                   	push   %ebp
  802e70:	89 e5                	mov    %esp,%ebp
  802e72:	83 ec 04             	sub    $0x4,%esp
  802e75:	8b 45 10             	mov    0x10(%ebp),%eax
  802e78:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802e7b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e7e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	6a 00                	push   $0x0
  802e87:	51                   	push   %ecx
  802e88:	52                   	push   %edx
  802e89:	ff 75 0c             	pushl  0xc(%ebp)
  802e8c:	50                   	push   %eax
  802e8d:	6a 00                	push   $0x0
  802e8f:	e8 b0 ff ff ff       	call   802e44 <syscall>
  802e94:	83 c4 18             	add    $0x18,%esp
}
  802e97:	90                   	nop
  802e98:	c9                   	leave  
  802e99:	c3                   	ret    

00802e9a <sys_cgetc>:

int
sys_cgetc(void)
{
  802e9a:	55                   	push   %ebp
  802e9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802e9d:	6a 00                	push   $0x0
  802e9f:	6a 00                	push   $0x0
  802ea1:	6a 00                	push   $0x0
  802ea3:	6a 00                	push   $0x0
  802ea5:	6a 00                	push   $0x0
  802ea7:	6a 02                	push   $0x2
  802ea9:	e8 96 ff ff ff       	call   802e44 <syscall>
  802eae:	83 c4 18             	add    $0x18,%esp
}
  802eb1:	c9                   	leave  
  802eb2:	c3                   	ret    

00802eb3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802eb3:	55                   	push   %ebp
  802eb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 00                	push   $0x0
  802ebe:	6a 00                	push   $0x0
  802ec0:	6a 03                	push   $0x3
  802ec2:	e8 7d ff ff ff       	call   802e44 <syscall>
  802ec7:	83 c4 18             	add    $0x18,%esp
}
  802eca:	90                   	nop
  802ecb:	c9                   	leave  
  802ecc:	c3                   	ret    

00802ecd <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802ecd:	55                   	push   %ebp
  802ece:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 00                	push   $0x0
  802ed8:	6a 00                	push   $0x0
  802eda:	6a 04                	push   $0x4
  802edc:	e8 63 ff ff ff       	call   802e44 <syscall>
  802ee1:	83 c4 18             	add    $0x18,%esp
}
  802ee4:	90                   	nop
  802ee5:	c9                   	leave  
  802ee6:	c3                   	ret    

00802ee7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802ee7:	55                   	push   %ebp
  802ee8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802eea:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	6a 00                	push   $0x0
  802ef2:	6a 00                	push   $0x0
  802ef4:	6a 00                	push   $0x0
  802ef6:	52                   	push   %edx
  802ef7:	50                   	push   %eax
  802ef8:	6a 08                	push   $0x8
  802efa:	e8 45 ff ff ff       	call   802e44 <syscall>
  802eff:	83 c4 18             	add    $0x18,%esp
}
  802f02:	c9                   	leave  
  802f03:	c3                   	ret    

00802f04 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f04:	55                   	push   %ebp
  802f05:	89 e5                	mov    %esp,%ebp
  802f07:	56                   	push   %esi
  802f08:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f09:	8b 75 18             	mov    0x18(%ebp),%esi
  802f0c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	56                   	push   %esi
  802f19:	53                   	push   %ebx
  802f1a:	51                   	push   %ecx
  802f1b:	52                   	push   %edx
  802f1c:	50                   	push   %eax
  802f1d:	6a 09                	push   $0x9
  802f1f:	e8 20 ff ff ff       	call   802e44 <syscall>
  802f24:	83 c4 18             	add    $0x18,%esp
}
  802f27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f2a:	5b                   	pop    %ebx
  802f2b:	5e                   	pop    %esi
  802f2c:	5d                   	pop    %ebp
  802f2d:	c3                   	ret    

00802f2e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802f2e:	55                   	push   %ebp
  802f2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802f31:	6a 00                	push   $0x0
  802f33:	6a 00                	push   $0x0
  802f35:	6a 00                	push   $0x0
  802f37:	6a 00                	push   $0x0
  802f39:	ff 75 08             	pushl  0x8(%ebp)
  802f3c:	6a 0a                	push   $0xa
  802f3e:	e8 01 ff ff ff       	call   802e44 <syscall>
  802f43:	83 c4 18             	add    $0x18,%esp
}
  802f46:	c9                   	leave  
  802f47:	c3                   	ret    

00802f48 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f48:	55                   	push   %ebp
  802f49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f4b:	6a 00                	push   $0x0
  802f4d:	6a 00                	push   $0x0
  802f4f:	6a 00                	push   $0x0
  802f51:	ff 75 0c             	pushl  0xc(%ebp)
  802f54:	ff 75 08             	pushl  0x8(%ebp)
  802f57:	6a 0b                	push   $0xb
  802f59:	e8 e6 fe ff ff       	call   802e44 <syscall>
  802f5e:	83 c4 18             	add    $0x18,%esp
}
  802f61:	c9                   	leave  
  802f62:	c3                   	ret    

00802f63 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f63:	55                   	push   %ebp
  802f64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f66:	6a 00                	push   $0x0
  802f68:	6a 00                	push   $0x0
  802f6a:	6a 00                	push   $0x0
  802f6c:	6a 00                	push   $0x0
  802f6e:	6a 00                	push   $0x0
  802f70:	6a 0c                	push   $0xc
  802f72:	e8 cd fe ff ff       	call   802e44 <syscall>
  802f77:	83 c4 18             	add    $0x18,%esp
}
  802f7a:	c9                   	leave  
  802f7b:	c3                   	ret    

00802f7c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f7c:	55                   	push   %ebp
  802f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f7f:	6a 00                	push   $0x0
  802f81:	6a 00                	push   $0x0
  802f83:	6a 00                	push   $0x0
  802f85:	6a 00                	push   $0x0
  802f87:	6a 00                	push   $0x0
  802f89:	6a 0d                	push   $0xd
  802f8b:	e8 b4 fe ff ff       	call   802e44 <syscall>
  802f90:	83 c4 18             	add    $0x18,%esp
}
  802f93:	c9                   	leave  
  802f94:	c3                   	ret    

00802f95 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802f95:	55                   	push   %ebp
  802f96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802f98:	6a 00                	push   $0x0
  802f9a:	6a 00                	push   $0x0
  802f9c:	6a 00                	push   $0x0
  802f9e:	6a 00                	push   $0x0
  802fa0:	6a 00                	push   $0x0
  802fa2:	6a 0e                	push   $0xe
  802fa4:	e8 9b fe ff ff       	call   802e44 <syscall>
  802fa9:	83 c4 18             	add    $0x18,%esp
}
  802fac:	c9                   	leave  
  802fad:	c3                   	ret    

00802fae <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802fae:	55                   	push   %ebp
  802faf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	6a 00                	push   $0x0
  802fb9:	6a 00                	push   $0x0
  802fbb:	6a 0f                	push   $0xf
  802fbd:	e8 82 fe ff ff       	call   802e44 <syscall>
  802fc2:	83 c4 18             	add    $0x18,%esp
}
  802fc5:	c9                   	leave  
  802fc6:	c3                   	ret    

00802fc7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802fc7:	55                   	push   %ebp
  802fc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802fca:	6a 00                	push   $0x0
  802fcc:	6a 00                	push   $0x0
  802fce:	6a 00                	push   $0x0
  802fd0:	6a 00                	push   $0x0
  802fd2:	ff 75 08             	pushl  0x8(%ebp)
  802fd5:	6a 10                	push   $0x10
  802fd7:	e8 68 fe ff ff       	call   802e44 <syscall>
  802fdc:	83 c4 18             	add    $0x18,%esp
}
  802fdf:	c9                   	leave  
  802fe0:	c3                   	ret    

00802fe1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802fe1:	55                   	push   %ebp
  802fe2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802fe4:	6a 00                	push   $0x0
  802fe6:	6a 00                	push   $0x0
  802fe8:	6a 00                	push   $0x0
  802fea:	6a 00                	push   $0x0
  802fec:	6a 00                	push   $0x0
  802fee:	6a 11                	push   $0x11
  802ff0:	e8 4f fe ff ff       	call   802e44 <syscall>
  802ff5:	83 c4 18             	add    $0x18,%esp
}
  802ff8:	90                   	nop
  802ff9:	c9                   	leave  
  802ffa:	c3                   	ret    

00802ffb <sys_cputc>:

void
sys_cputc(const char c)
{
  802ffb:	55                   	push   %ebp
  802ffc:	89 e5                	mov    %esp,%ebp
  802ffe:	83 ec 04             	sub    $0x4,%esp
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803007:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80300b:	6a 00                	push   $0x0
  80300d:	6a 00                	push   $0x0
  80300f:	6a 00                	push   $0x0
  803011:	6a 00                	push   $0x0
  803013:	50                   	push   %eax
  803014:	6a 01                	push   $0x1
  803016:	e8 29 fe ff ff       	call   802e44 <syscall>
  80301b:	83 c4 18             	add    $0x18,%esp
}
  80301e:	90                   	nop
  80301f:	c9                   	leave  
  803020:	c3                   	ret    

00803021 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803021:	55                   	push   %ebp
  803022:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803024:	6a 00                	push   $0x0
  803026:	6a 00                	push   $0x0
  803028:	6a 00                	push   $0x0
  80302a:	6a 00                	push   $0x0
  80302c:	6a 00                	push   $0x0
  80302e:	6a 14                	push   $0x14
  803030:	e8 0f fe ff ff       	call   802e44 <syscall>
  803035:	83 c4 18             	add    $0x18,%esp
}
  803038:	90                   	nop
  803039:	c9                   	leave  
  80303a:	c3                   	ret    

0080303b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80303b:	55                   	push   %ebp
  80303c:	89 e5                	mov    %esp,%ebp
  80303e:	83 ec 04             	sub    $0x4,%esp
  803041:	8b 45 10             	mov    0x10(%ebp),%eax
  803044:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803047:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80304a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	6a 00                	push   $0x0
  803053:	51                   	push   %ecx
  803054:	52                   	push   %edx
  803055:	ff 75 0c             	pushl  0xc(%ebp)
  803058:	50                   	push   %eax
  803059:	6a 15                	push   $0x15
  80305b:	e8 e4 fd ff ff       	call   802e44 <syscall>
  803060:	83 c4 18             	add    $0x18,%esp
}
  803063:	c9                   	leave  
  803064:	c3                   	ret    

00803065 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803065:	55                   	push   %ebp
  803066:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803068:	8b 55 0c             	mov    0xc(%ebp),%edx
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	6a 00                	push   $0x0
  803070:	6a 00                	push   $0x0
  803072:	6a 00                	push   $0x0
  803074:	52                   	push   %edx
  803075:	50                   	push   %eax
  803076:	6a 16                	push   $0x16
  803078:	e8 c7 fd ff ff       	call   802e44 <syscall>
  80307d:	83 c4 18             	add    $0x18,%esp
}
  803080:	c9                   	leave  
  803081:	c3                   	ret    

00803082 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803082:	55                   	push   %ebp
  803083:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803085:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803088:	8b 55 0c             	mov    0xc(%ebp),%edx
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	6a 00                	push   $0x0
  803090:	6a 00                	push   $0x0
  803092:	51                   	push   %ecx
  803093:	52                   	push   %edx
  803094:	50                   	push   %eax
  803095:	6a 17                	push   $0x17
  803097:	e8 a8 fd ff ff       	call   802e44 <syscall>
  80309c:	83 c4 18             	add    $0x18,%esp
}
  80309f:	c9                   	leave  
  8030a0:	c3                   	ret    

008030a1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8030a1:	55                   	push   %ebp
  8030a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8030a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	6a 00                	push   $0x0
  8030ac:	6a 00                	push   $0x0
  8030ae:	6a 00                	push   $0x0
  8030b0:	52                   	push   %edx
  8030b1:	50                   	push   %eax
  8030b2:	6a 18                	push   $0x18
  8030b4:	e8 8b fd ff ff       	call   802e44 <syscall>
  8030b9:	83 c4 18             	add    $0x18,%esp
}
  8030bc:	c9                   	leave  
  8030bd:	c3                   	ret    

008030be <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8030be:	55                   	push   %ebp
  8030bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	6a 00                	push   $0x0
  8030c6:	ff 75 14             	pushl  0x14(%ebp)
  8030c9:	ff 75 10             	pushl  0x10(%ebp)
  8030cc:	ff 75 0c             	pushl  0xc(%ebp)
  8030cf:	50                   	push   %eax
  8030d0:	6a 19                	push   $0x19
  8030d2:	e8 6d fd ff ff       	call   802e44 <syscall>
  8030d7:	83 c4 18             	add    $0x18,%esp
}
  8030da:	c9                   	leave  
  8030db:	c3                   	ret    

008030dc <sys_run_env>:

void sys_run_env(int32 envId)
{
  8030dc:	55                   	push   %ebp
  8030dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	6a 00                	push   $0x0
  8030e4:	6a 00                	push   $0x0
  8030e6:	6a 00                	push   $0x0
  8030e8:	6a 00                	push   $0x0
  8030ea:	50                   	push   %eax
  8030eb:	6a 1a                	push   $0x1a
  8030ed:	e8 52 fd ff ff       	call   802e44 <syscall>
  8030f2:	83 c4 18             	add    $0x18,%esp
}
  8030f5:	90                   	nop
  8030f6:	c9                   	leave  
  8030f7:	c3                   	ret    

008030f8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8030f8:	55                   	push   %ebp
  8030f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	6a 00                	push   $0x0
  803100:	6a 00                	push   $0x0
  803102:	6a 00                	push   $0x0
  803104:	6a 00                	push   $0x0
  803106:	50                   	push   %eax
  803107:	6a 1b                	push   $0x1b
  803109:	e8 36 fd ff ff       	call   802e44 <syscall>
  80310e:	83 c4 18             	add    $0x18,%esp
}
  803111:	c9                   	leave  
  803112:	c3                   	ret    

00803113 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803113:	55                   	push   %ebp
  803114:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803116:	6a 00                	push   $0x0
  803118:	6a 00                	push   $0x0
  80311a:	6a 00                	push   $0x0
  80311c:	6a 00                	push   $0x0
  80311e:	6a 00                	push   $0x0
  803120:	6a 05                	push   $0x5
  803122:	e8 1d fd ff ff       	call   802e44 <syscall>
  803127:	83 c4 18             	add    $0x18,%esp
}
  80312a:	c9                   	leave  
  80312b:	c3                   	ret    

0080312c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80312c:	55                   	push   %ebp
  80312d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80312f:	6a 00                	push   $0x0
  803131:	6a 00                	push   $0x0
  803133:	6a 00                	push   $0x0
  803135:	6a 00                	push   $0x0
  803137:	6a 00                	push   $0x0
  803139:	6a 06                	push   $0x6
  80313b:	e8 04 fd ff ff       	call   802e44 <syscall>
  803140:	83 c4 18             	add    $0x18,%esp
}
  803143:	c9                   	leave  
  803144:	c3                   	ret    

00803145 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803145:	55                   	push   %ebp
  803146:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803148:	6a 00                	push   $0x0
  80314a:	6a 00                	push   $0x0
  80314c:	6a 00                	push   $0x0
  80314e:	6a 00                	push   $0x0
  803150:	6a 00                	push   $0x0
  803152:	6a 07                	push   $0x7
  803154:	e8 eb fc ff ff       	call   802e44 <syscall>
  803159:	83 c4 18             	add    $0x18,%esp
}
  80315c:	c9                   	leave  
  80315d:	c3                   	ret    

0080315e <sys_exit_env>:


void sys_exit_env(void)
{
  80315e:	55                   	push   %ebp
  80315f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803161:	6a 00                	push   $0x0
  803163:	6a 00                	push   $0x0
  803165:	6a 00                	push   $0x0
  803167:	6a 00                	push   $0x0
  803169:	6a 00                	push   $0x0
  80316b:	6a 1c                	push   $0x1c
  80316d:	e8 d2 fc ff ff       	call   802e44 <syscall>
  803172:	83 c4 18             	add    $0x18,%esp
}
  803175:	90                   	nop
  803176:	c9                   	leave  
  803177:	c3                   	ret    

00803178 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803178:	55                   	push   %ebp
  803179:	89 e5                	mov    %esp,%ebp
  80317b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80317e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803181:	8d 50 04             	lea    0x4(%eax),%edx
  803184:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803187:	6a 00                	push   $0x0
  803189:	6a 00                	push   $0x0
  80318b:	6a 00                	push   $0x0
  80318d:	52                   	push   %edx
  80318e:	50                   	push   %eax
  80318f:	6a 1d                	push   $0x1d
  803191:	e8 ae fc ff ff       	call   802e44 <syscall>
  803196:	83 c4 18             	add    $0x18,%esp
	return result;
  803199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80319c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80319f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031a2:	89 01                	mov    %eax,(%ecx)
  8031a4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8031a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031aa:	c9                   	leave  
  8031ab:	c2 04 00             	ret    $0x4

008031ae <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8031ae:	55                   	push   %ebp
  8031af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8031b1:	6a 00                	push   $0x0
  8031b3:	6a 00                	push   $0x0
  8031b5:	ff 75 10             	pushl  0x10(%ebp)
  8031b8:	ff 75 0c             	pushl  0xc(%ebp)
  8031bb:	ff 75 08             	pushl  0x8(%ebp)
  8031be:	6a 13                	push   $0x13
  8031c0:	e8 7f fc ff ff       	call   802e44 <syscall>
  8031c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8031c8:	90                   	nop
}
  8031c9:	c9                   	leave  
  8031ca:	c3                   	ret    

008031cb <sys_rcr2>:
uint32 sys_rcr2()
{
  8031cb:	55                   	push   %ebp
  8031cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8031ce:	6a 00                	push   $0x0
  8031d0:	6a 00                	push   $0x0
  8031d2:	6a 00                	push   $0x0
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 1e                	push   $0x1e
  8031da:	e8 65 fc ff ff       	call   802e44 <syscall>
  8031df:	83 c4 18             	add    $0x18,%esp
}
  8031e2:	c9                   	leave  
  8031e3:	c3                   	ret    

008031e4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8031e4:	55                   	push   %ebp
  8031e5:	89 e5                	mov    %esp,%ebp
  8031e7:	83 ec 04             	sub    $0x4,%esp
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8031f0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8031f4:	6a 00                	push   $0x0
  8031f6:	6a 00                	push   $0x0
  8031f8:	6a 00                	push   $0x0
  8031fa:	6a 00                	push   $0x0
  8031fc:	50                   	push   %eax
  8031fd:	6a 1f                	push   $0x1f
  8031ff:	e8 40 fc ff ff       	call   802e44 <syscall>
  803204:	83 c4 18             	add    $0x18,%esp
	return ;
  803207:	90                   	nop
}
  803208:	c9                   	leave  
  803209:	c3                   	ret    

0080320a <rsttst>:
void rsttst()
{
  80320a:	55                   	push   %ebp
  80320b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80320d:	6a 00                	push   $0x0
  80320f:	6a 00                	push   $0x0
  803211:	6a 00                	push   $0x0
  803213:	6a 00                	push   $0x0
  803215:	6a 00                	push   $0x0
  803217:	6a 21                	push   $0x21
  803219:	e8 26 fc ff ff       	call   802e44 <syscall>
  80321e:	83 c4 18             	add    $0x18,%esp
	return ;
  803221:	90                   	nop
}
  803222:	c9                   	leave  
  803223:	c3                   	ret    

00803224 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803224:	55                   	push   %ebp
  803225:	89 e5                	mov    %esp,%ebp
  803227:	83 ec 04             	sub    $0x4,%esp
  80322a:	8b 45 14             	mov    0x14(%ebp),%eax
  80322d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803230:	8b 55 18             	mov    0x18(%ebp),%edx
  803233:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803237:	52                   	push   %edx
  803238:	50                   	push   %eax
  803239:	ff 75 10             	pushl  0x10(%ebp)
  80323c:	ff 75 0c             	pushl  0xc(%ebp)
  80323f:	ff 75 08             	pushl  0x8(%ebp)
  803242:	6a 20                	push   $0x20
  803244:	e8 fb fb ff ff       	call   802e44 <syscall>
  803249:	83 c4 18             	add    $0x18,%esp
	return ;
  80324c:	90                   	nop
}
  80324d:	c9                   	leave  
  80324e:	c3                   	ret    

0080324f <chktst>:
void chktst(uint32 n)
{
  80324f:	55                   	push   %ebp
  803250:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803252:	6a 00                	push   $0x0
  803254:	6a 00                	push   $0x0
  803256:	6a 00                	push   $0x0
  803258:	6a 00                	push   $0x0
  80325a:	ff 75 08             	pushl  0x8(%ebp)
  80325d:	6a 22                	push   $0x22
  80325f:	e8 e0 fb ff ff       	call   802e44 <syscall>
  803264:	83 c4 18             	add    $0x18,%esp
	return ;
  803267:	90                   	nop
}
  803268:	c9                   	leave  
  803269:	c3                   	ret    

0080326a <inctst>:

void inctst()
{
  80326a:	55                   	push   %ebp
  80326b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80326d:	6a 00                	push   $0x0
  80326f:	6a 00                	push   $0x0
  803271:	6a 00                	push   $0x0
  803273:	6a 00                	push   $0x0
  803275:	6a 00                	push   $0x0
  803277:	6a 23                	push   $0x23
  803279:	e8 c6 fb ff ff       	call   802e44 <syscall>
  80327e:	83 c4 18             	add    $0x18,%esp
	return ;
  803281:	90                   	nop
}
  803282:	c9                   	leave  
  803283:	c3                   	ret    

00803284 <gettst>:
uint32 gettst()
{
  803284:	55                   	push   %ebp
  803285:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803287:	6a 00                	push   $0x0
  803289:	6a 00                	push   $0x0
  80328b:	6a 00                	push   $0x0
  80328d:	6a 00                	push   $0x0
  80328f:	6a 00                	push   $0x0
  803291:	6a 24                	push   $0x24
  803293:	e8 ac fb ff ff       	call   802e44 <syscall>
  803298:	83 c4 18             	add    $0x18,%esp
}
  80329b:	c9                   	leave  
  80329c:	c3                   	ret    

0080329d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80329d:	55                   	push   %ebp
  80329e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032a0:	6a 00                	push   $0x0
  8032a2:	6a 00                	push   $0x0
  8032a4:	6a 00                	push   $0x0
  8032a6:	6a 00                	push   $0x0
  8032a8:	6a 00                	push   $0x0
  8032aa:	6a 25                	push   $0x25
  8032ac:	e8 93 fb ff ff       	call   802e44 <syscall>
  8032b1:	83 c4 18             	add    $0x18,%esp
  8032b4:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  8032b9:	a1 80 50 83 00       	mov    0x835080,%eax
}
  8032be:	c9                   	leave  
  8032bf:	c3                   	ret    

008032c0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8032c0:	55                   	push   %ebp
  8032c1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8032cb:	6a 00                	push   $0x0
  8032cd:	6a 00                	push   $0x0
  8032cf:	6a 00                	push   $0x0
  8032d1:	6a 00                	push   $0x0
  8032d3:	ff 75 08             	pushl  0x8(%ebp)
  8032d6:	6a 26                	push   $0x26
  8032d8:	e8 67 fb ff ff       	call   802e44 <syscall>
  8032dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8032e0:	90                   	nop
}
  8032e1:	c9                   	leave  
  8032e2:	c3                   	ret    

008032e3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
  8032e6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8032e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	6a 00                	push   $0x0
  8032f5:	53                   	push   %ebx
  8032f6:	51                   	push   %ecx
  8032f7:	52                   	push   %edx
  8032f8:	50                   	push   %eax
  8032f9:	6a 27                	push   $0x27
  8032fb:	e8 44 fb ff ff       	call   802e44 <syscall>
  803300:	83 c4 18             	add    $0x18,%esp
}
  803303:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803306:	c9                   	leave  
  803307:	c3                   	ret    

00803308 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803308:	55                   	push   %ebp
  803309:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80330b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	6a 00                	push   $0x0
  803313:	6a 00                	push   $0x0
  803315:	6a 00                	push   $0x0
  803317:	52                   	push   %edx
  803318:	50                   	push   %eax
  803319:	6a 28                	push   $0x28
  80331b:	e8 24 fb ff ff       	call   802e44 <syscall>
  803320:	83 c4 18             	add    $0x18,%esp
}
  803323:	c9                   	leave  
  803324:	c3                   	ret    

00803325 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803325:	55                   	push   %ebp
  803326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803328:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80332b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	6a 00                	push   $0x0
  803333:	51                   	push   %ecx
  803334:	ff 75 10             	pushl  0x10(%ebp)
  803337:	52                   	push   %edx
  803338:	50                   	push   %eax
  803339:	6a 29                	push   $0x29
  80333b:	e8 04 fb ff ff       	call   802e44 <syscall>
  803340:	83 c4 18             	add    $0x18,%esp
}
  803343:	c9                   	leave  
  803344:	c3                   	ret    

00803345 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803345:	55                   	push   %ebp
  803346:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803348:	6a 00                	push   $0x0
  80334a:	6a 00                	push   $0x0
  80334c:	ff 75 10             	pushl  0x10(%ebp)
  80334f:	ff 75 0c             	pushl  0xc(%ebp)
  803352:	ff 75 08             	pushl  0x8(%ebp)
  803355:	6a 12                	push   $0x12
  803357:	e8 e8 fa ff ff       	call   802e44 <syscall>
  80335c:	83 c4 18             	add    $0x18,%esp
	return ;
  80335f:	90                   	nop
}
  803360:	c9                   	leave  
  803361:	c3                   	ret    

00803362 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803362:	55                   	push   %ebp
  803363:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803365:	8b 55 0c             	mov    0xc(%ebp),%edx
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	6a 00                	push   $0x0
  80336d:	6a 00                	push   $0x0
  80336f:	6a 00                	push   $0x0
  803371:	52                   	push   %edx
  803372:	50                   	push   %eax
  803373:	6a 2a                	push   $0x2a
  803375:	e8 ca fa ff ff       	call   802e44 <syscall>
  80337a:	83 c4 18             	add    $0x18,%esp
	return;
  80337d:	90                   	nop
}
  80337e:	c9                   	leave  
  80337f:	c3                   	ret    

00803380 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803380:	55                   	push   %ebp
  803381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803383:	6a 00                	push   $0x0
  803385:	6a 00                	push   $0x0
  803387:	6a 00                	push   $0x0
  803389:	6a 00                	push   $0x0
  80338b:	6a 00                	push   $0x0
  80338d:	6a 2b                	push   $0x2b
  80338f:	e8 b0 fa ff ff       	call   802e44 <syscall>
  803394:	83 c4 18             	add    $0x18,%esp
}
  803397:	c9                   	leave  
  803398:	c3                   	ret    

00803399 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803399:	55                   	push   %ebp
  80339a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80339c:	6a 00                	push   $0x0
  80339e:	6a 00                	push   $0x0
  8033a0:	6a 00                	push   $0x0
  8033a2:	ff 75 0c             	pushl  0xc(%ebp)
  8033a5:	ff 75 08             	pushl  0x8(%ebp)
  8033a8:	6a 2d                	push   $0x2d
  8033aa:	e8 95 fa ff ff       	call   802e44 <syscall>
  8033af:	83 c4 18             	add    $0x18,%esp
	return;
  8033b2:	90                   	nop
}
  8033b3:	c9                   	leave  
  8033b4:	c3                   	ret    

008033b5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8033b5:	55                   	push   %ebp
  8033b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8033b8:	6a 00                	push   $0x0
  8033ba:	6a 00                	push   $0x0
  8033bc:	6a 00                	push   $0x0
  8033be:	ff 75 0c             	pushl  0xc(%ebp)
  8033c1:	ff 75 08             	pushl  0x8(%ebp)
  8033c4:	6a 2c                	push   $0x2c
  8033c6:	e8 79 fa ff ff       	call   802e44 <syscall>
  8033cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8033ce:	90                   	nop
}
  8033cf:	c9                   	leave  
  8033d0:	c3                   	ret    

008033d1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8033d1:	55                   	push   %ebp
  8033d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8033d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	6a 00                	push   $0x0
  8033dc:	6a 00                	push   $0x0
  8033de:	6a 00                	push   $0x0
  8033e0:	52                   	push   %edx
  8033e1:	50                   	push   %eax
  8033e2:	6a 2e                	push   $0x2e
  8033e4:	e8 5b fa ff ff       	call   802e44 <syscall>
  8033e9:	83 c4 18             	add    $0x18,%esp
}
  8033ec:	90                   	nop
  8033ed:	c9                   	leave  
  8033ee:	c3                   	ret    

008033ef <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8033ef:	55                   	push   %ebp
  8033f0:	89 e5                	mov    %esp,%ebp
  8033f2:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8033f5:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  8033fc:	72 09                	jb     803407 <to_page_va+0x18>
  8033fe:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  803405:	72 14                	jb     80341b <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803407:	83 ec 04             	sub    $0x4,%esp
  80340a:	68 78 4c 80 00       	push   $0x804c78
  80340f:	6a 15                	push   $0x15
  803411:	68 a3 4c 80 00       	push   $0x804ca3
  803416:	e8 10 d0 ff ff       	call   80042b <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  803423:	29 d0                	sub    %edx,%eax
  803425:	c1 f8 02             	sar    $0x2,%eax
  803428:	89 c2                	mov    %eax,%edx
  80342a:	89 d0                	mov    %edx,%eax
  80342c:	c1 e0 02             	shl    $0x2,%eax
  80342f:	01 d0                	add    %edx,%eax
  803431:	c1 e0 02             	shl    $0x2,%eax
  803434:	01 d0                	add    %edx,%eax
  803436:	c1 e0 02             	shl    $0x2,%eax
  803439:	01 d0                	add    %edx,%eax
  80343b:	89 c1                	mov    %eax,%ecx
  80343d:	c1 e1 08             	shl    $0x8,%ecx
  803440:	01 c8                	add    %ecx,%eax
  803442:	89 c1                	mov    %eax,%ecx
  803444:	c1 e1 10             	shl    $0x10,%ecx
  803447:	01 c8                	add    %ecx,%eax
  803449:	01 c0                	add    %eax,%eax
  80344b:	01 d0                	add    %edx,%eax
  80344d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803453:	c1 e0 0c             	shl    $0xc,%eax
  803456:	89 c2                	mov    %eax,%edx
  803458:	a1 84 50 83 00       	mov    0x835084,%eax
  80345d:	01 d0                	add    %edx,%eax
}
  80345f:	c9                   	leave  
  803460:	c3                   	ret    

00803461 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803461:	55                   	push   %ebp
  803462:	89 e5                	mov    %esp,%ebp
  803464:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803467:	a1 84 50 83 00       	mov    0x835084,%eax
  80346c:	8b 55 08             	mov    0x8(%ebp),%edx
  80346f:	29 c2                	sub    %eax,%edx
  803471:	89 d0                	mov    %edx,%eax
  803473:	c1 e8 0c             	shr    $0xc,%eax
  803476:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803479:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347d:	78 09                	js     803488 <to_page_info+0x27>
  80347f:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803486:	7e 14                	jle    80349c <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803488:	83 ec 04             	sub    $0x4,%esp
  80348b:	68 bc 4c 80 00       	push   $0x804cbc
  803490:	6a 21                	push   $0x21
  803492:	68 a3 4c 80 00       	push   $0x804ca3
  803497:	e8 8f cf ff ff       	call   80042b <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80349c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349f:	89 d0                	mov    %edx,%eax
  8034a1:	01 c0                	add    %eax,%eax
  8034a3:	01 d0                	add    %edx,%eax
  8034a5:	c1 e0 02             	shl    $0x2,%eax
  8034a8:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  8034ad:	c9                   	leave  
  8034ae:	c3                   	ret    

008034af <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8034af:	55                   	push   %ebp
  8034b0:	89 e5                	mov    %esp,%ebp
  8034b2:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	05 00 00 00 02       	add    $0x2000000,%eax
  8034bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034c0:	73 16                	jae    8034d8 <initialize_dynamic_allocator+0x29>
  8034c2:	68 e0 4c 80 00       	push   $0x804ce0
  8034c7:	68 06 4d 80 00       	push   $0x804d06
  8034cc:	6a 2f                	push   $0x2f
  8034ce:	68 a3 4c 80 00       	push   $0x804ca3
  8034d3:	e8 53 cf ff ff       	call   80042b <_panic>
	dynAllocStart = daStart;
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  8034e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e3:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8034e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034ef:	eb 36                	jmp    803527 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	c1 e0 04             	shl    $0x4,%eax
  8034f7:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8034fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803505:	c1 e0 04             	shl    $0x4,%eax
  803508:	05 a4 50 83 00       	add    $0x8350a4,%eax
  80350d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803516:	c1 e0 04             	shl    $0x4,%eax
  803519:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80351e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803524:	ff 45 f4             	incl   -0xc(%ebp)
  803527:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80352b:	7e c4                	jle    8034f1 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  80352d:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  803534:	00 00 00 
  803537:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  80353e:	00 00 00 
  803541:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  803548:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80354b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803552:	e9 1b 01 00 00       	jmp    803672 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803557:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80355a:	89 d0                	mov    %edx,%eax
  80355c:	01 c0                	add    %eax,%eax
  80355e:	01 d0                	add    %edx,%eax
  803560:	c1 e0 02             	shl    $0x2,%eax
  803563:	05 88 d0 81 00       	add    $0x81d088,%eax
  803568:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  80356d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803570:	89 d0                	mov    %edx,%eax
  803572:	01 c0                	add    %eax,%eax
  803574:	01 d0                	add    %edx,%eax
  803576:	c1 e0 02             	shl    $0x2,%eax
  803579:	05 8a d0 81 00       	add    $0x81d08a,%eax
  80357e:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803583:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803586:	89 d0                	mov    %edx,%eax
  803588:	01 c0                	add    %eax,%eax
  80358a:	01 d0                	add    %edx,%eax
  80358c:	c1 e0 02             	shl    $0x2,%eax
  80358f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803594:	8b 00                	mov    (%eax),%eax
  803596:	85 c0                	test   %eax,%eax
  803598:	74 2b                	je     8035c5 <initialize_dynamic_allocator+0x116>
  80359a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80359d:	89 d0                	mov    %edx,%eax
  80359f:	01 c0                	add    %eax,%eax
  8035a1:	01 d0                	add    %edx,%eax
  8035a3:	c1 e0 02             	shl    $0x2,%eax
  8035a6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035ab:	8b 10                	mov    (%eax),%edx
  8035ad:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8035b0:	89 c8                	mov    %ecx,%eax
  8035b2:	01 c0                	add    %eax,%eax
  8035b4:	01 c8                	add    %ecx,%eax
  8035b6:	c1 e0 02             	shl    $0x2,%eax
  8035b9:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035be:	8b 00                	mov    (%eax),%eax
  8035c0:	89 42 04             	mov    %eax,0x4(%edx)
  8035c3:	eb 18                	jmp    8035dd <initialize_dynamic_allocator+0x12e>
  8035c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035c8:	89 d0                	mov    %edx,%eax
  8035ca:	01 c0                	add    %eax,%eax
  8035cc:	01 d0                	add    %edx,%eax
  8035ce:	c1 e0 02             	shl    $0x2,%eax
  8035d1:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035d6:	8b 00                	mov    (%eax),%eax
  8035d8:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8035dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035e0:	89 d0                	mov    %edx,%eax
  8035e2:	01 c0                	add    %eax,%eax
  8035e4:	01 d0                	add    %edx,%eax
  8035e6:	c1 e0 02             	shl    $0x2,%eax
  8035e9:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035ee:	8b 00                	mov    (%eax),%eax
  8035f0:	85 c0                	test   %eax,%eax
  8035f2:	74 2a                	je     80361e <initialize_dynamic_allocator+0x16f>
  8035f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f7:	89 d0                	mov    %edx,%eax
  8035f9:	01 c0                	add    %eax,%eax
  8035fb:	01 d0                	add    %edx,%eax
  8035fd:	c1 e0 02             	shl    $0x2,%eax
  803600:	05 84 d0 81 00       	add    $0x81d084,%eax
  803605:	8b 10                	mov    (%eax),%edx
  803607:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80360a:	89 c8                	mov    %ecx,%eax
  80360c:	01 c0                	add    %eax,%eax
  80360e:	01 c8                	add    %ecx,%eax
  803610:	c1 e0 02             	shl    $0x2,%eax
  803613:	05 80 d0 81 00       	add    $0x81d080,%eax
  803618:	8b 00                	mov    (%eax),%eax
  80361a:	89 02                	mov    %eax,(%edx)
  80361c:	eb 18                	jmp    803636 <initialize_dynamic_allocator+0x187>
  80361e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803621:	89 d0                	mov    %edx,%eax
  803623:	01 c0                	add    %eax,%eax
  803625:	01 d0                	add    %edx,%eax
  803627:	c1 e0 02             	shl    $0x2,%eax
  80362a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80362f:	8b 00                	mov    (%eax),%eax
  803631:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803636:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803639:	89 d0                	mov    %edx,%eax
  80363b:	01 c0                	add    %eax,%eax
  80363d:	01 d0                	add    %edx,%eax
  80363f:	c1 e0 02             	shl    $0x2,%eax
  803642:	05 80 d0 81 00       	add    $0x81d080,%eax
  803647:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80364d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803650:	89 d0                	mov    %edx,%eax
  803652:	01 c0                	add    %eax,%eax
  803654:	01 d0                	add    %edx,%eax
  803656:	c1 e0 02             	shl    $0x2,%eax
  803659:	05 84 d0 81 00       	add    $0x81d084,%eax
  80365e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803664:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803669:	48                   	dec    %eax
  80366a:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80366f:	ff 45 f0             	incl   -0x10(%ebp)
  803672:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803679:	0f 8e d8 fe ff ff    	jle    803557 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80367f:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803686:	e9 9d 00 00 00       	jmp    803728 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  80368b:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803691:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803694:	89 c8                	mov    %ecx,%eax
  803696:	01 c0                	add    %eax,%eax
  803698:	01 c8                	add    %ecx,%eax
  80369a:	c1 e0 02             	shl    $0x2,%eax
  80369d:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036a2:	89 10                	mov    %edx,(%eax)
  8036a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036a7:	89 d0                	mov    %edx,%eax
  8036a9:	01 c0                	add    %eax,%eax
  8036ab:	01 d0                	add    %edx,%eax
  8036ad:	c1 e0 02             	shl    $0x2,%eax
  8036b0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	85 c0                	test   %eax,%eax
  8036b9:	74 1c                	je     8036d7 <initialize_dynamic_allocator+0x228>
  8036bb:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  8036c1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036c4:	89 c8                	mov    %ecx,%eax
  8036c6:	01 c0                	add    %eax,%eax
  8036c8:	01 c8                	add    %ecx,%eax
  8036ca:	c1 e0 02             	shl    $0x2,%eax
  8036cd:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036d2:	89 42 04             	mov    %eax,0x4(%edx)
  8036d5:	eb 16                	jmp    8036ed <initialize_dynamic_allocator+0x23e>
  8036d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036da:	89 d0                	mov    %edx,%eax
  8036dc:	01 c0                	add    %eax,%eax
  8036de:	01 d0                	add    %edx,%eax
  8036e0:	c1 e0 02             	shl    $0x2,%eax
  8036e3:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036e8:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8036ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036f0:	89 d0                	mov    %edx,%eax
  8036f2:	01 c0                	add    %eax,%eax
  8036f4:	01 d0                	add    %edx,%eax
  8036f6:	c1 e0 02             	shl    $0x2,%eax
  8036f9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036fe:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803703:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803706:	89 d0                	mov    %edx,%eax
  803708:	01 c0                	add    %eax,%eax
  80370a:	01 d0                	add    %edx,%eax
  80370c:	c1 e0 02             	shl    $0x2,%eax
  80370f:	05 84 d0 81 00       	add    $0x81d084,%eax
  803714:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80371a:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80371f:	40                   	inc    %eax
  803720:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803725:	ff 4d ec             	decl   -0x14(%ebp)
  803728:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80372c:	0f 89 59 ff ff ff    	jns    80368b <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803732:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803739:	00 00 00 
}
  80373c:	90                   	nop
  80373d:	c9                   	leave  
  80373e:	c3                   	ret    

0080373f <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80373f:	55                   	push   %ebp
  803740:	89 e5                	mov    %esp,%ebp
  803742:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803745:	8b 45 08             	mov    0x8(%ebp),%eax
  803748:	83 ec 0c             	sub    $0xc,%esp
  80374b:	50                   	push   %eax
  80374c:	e8 10 fd ff ff       	call   803461 <to_page_info>
  803751:	83 c4 10             	add    $0x10,%esp
  803754:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375a:	8b 40 08             	mov    0x8(%eax),%eax
  80375d:	0f b7 c0             	movzwl %ax,%eax
}
  803760:	c9                   	leave  
  803761:	c3                   	ret    

00803762 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803762:	55                   	push   %ebp
  803763:	89 e5                	mov    %esp,%ebp
  803765:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803768:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80376f:	76 16                	jbe    803787 <alloc_block+0x25>
  803771:	68 1c 4d 80 00       	push   $0x804d1c
  803776:	68 06 4d 80 00       	push   $0x804d06
  80377b:	6a 59                	push   $0x59
  80377d:	68 a3 4c 80 00       	push   $0x804ca3
  803782:	e8 a4 cc ff ff       	call   80042b <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803787:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80378e:	eb 08                	jmp    803798 <alloc_block+0x36>
		allocSize <<= 1;
  803790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803793:	01 c0                	add    %eax,%eax
  803795:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80379e:	73 09                	jae    8037a9 <alloc_block+0x47>
  8037a0:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8037a7:	76 e7                	jbe    803790 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8037a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8037b0:	eb 03                	jmp    8037b5 <alloc_block+0x53>
		listIndex++;
  8037b2:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8037b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b8:	ba 08 00 00 00       	mov    $0x8,%edx
  8037bd:	88 c1                	mov    %al,%cl
  8037bf:	d3 e2                	shl    %cl,%edx
  8037c1:	89 d0                	mov    %edx,%eax
  8037c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8037c6:	72 ea                	jb     8037b2 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8037c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8037ce:	e9 f4 00 00 00       	jmp    8038c7 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8037d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d6:	c1 e0 04             	shl    $0x4,%eax
  8037d9:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8037de:	8b 00                	mov    (%eax),%eax
  8037e0:	85 c0                	test   %eax,%eax
  8037e2:	0f 84 dc 00 00 00    	je     8038c4 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8037e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037eb:	c1 e0 04             	shl    $0x4,%eax
  8037ee:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8037f3:	8b 00                	mov    (%eax),%eax
  8037f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  8037f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037fc:	75 14                	jne    803812 <alloc_block+0xb0>
  8037fe:	83 ec 04             	sub    $0x4,%esp
  803801:	68 3d 4d 80 00       	push   $0x804d3d
  803806:	6a 6b                	push   $0x6b
  803808:	68 a3 4c 80 00       	push   $0x804ca3
  80380d:	e8 19 cc ff ff       	call   80042b <_panic>
  803812:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803815:	8b 00                	mov    (%eax),%eax
  803817:	85 c0                	test   %eax,%eax
  803819:	74 10                	je     80382b <alloc_block+0xc9>
  80381b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381e:	8b 00                	mov    (%eax),%eax
  803820:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803823:	8b 52 04             	mov    0x4(%edx),%edx
  803826:	89 50 04             	mov    %edx,0x4(%eax)
  803829:	eb 14                	jmp    80383f <alloc_block+0xdd>
  80382b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382e:	8b 40 04             	mov    0x4(%eax),%eax
  803831:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803834:	c1 e2 04             	shl    $0x4,%edx
  803837:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  80383d:	89 02                	mov    %eax,(%edx)
  80383f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803842:	8b 40 04             	mov    0x4(%eax),%eax
  803845:	85 c0                	test   %eax,%eax
  803847:	74 0f                	je     803858 <alloc_block+0xf6>
  803849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384c:	8b 40 04             	mov    0x4(%eax),%eax
  80384f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803852:	8b 12                	mov    (%edx),%edx
  803854:	89 10                	mov    %edx,(%eax)
  803856:	eb 13                	jmp    80386b <alloc_block+0x109>
  803858:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385b:	8b 00                	mov    (%eax),%eax
  80385d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803860:	c1 e2 04             	shl    $0x4,%edx
  803863:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803869:	89 02                	mov    %eax,(%edx)
  80386b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803877:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80387e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803881:	c1 e0 04             	shl    $0x4,%eax
  803884:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803889:	8b 00                	mov    (%eax),%eax
  80388b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80388e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803891:	c1 e0 04             	shl    $0x4,%eax
  803894:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803899:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  80389b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389e:	83 ec 0c             	sub    $0xc,%esp
  8038a1:	50                   	push   %eax
  8038a2:	e8 ba fb ff ff       	call   803461 <to_page_info>
  8038a7:	83 c4 10             	add    $0x10,%esp
  8038aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  8038ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8038b4:	48                   	dec    %eax
  8038b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038b8:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  8038bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bf:	e9 8f 02 00 00       	jmp    803b53 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8038c4:	ff 45 ec             	incl   -0x14(%ebp)
  8038c7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8038cb:	0f 8e 02 ff ff ff    	jle    8037d3 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  8038d1:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8038d6:	85 c0                	test   %eax,%eax
  8038d8:	75 14                	jne    8038ee <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  8038da:	83 ec 04             	sub    $0x4,%esp
  8038dd:	68 5c 4d 80 00       	push   $0x804d5c
  8038e2:	6a 77                	push   $0x77
  8038e4:	68 a3 4c 80 00       	push   $0x804ca3
  8038e9:	e8 3d cb ff ff       	call   80042b <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  8038ee:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8038f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  8038f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038fa:	75 14                	jne    803910 <alloc_block+0x1ae>
  8038fc:	83 ec 04             	sub    $0x4,%esp
  8038ff:	68 3d 4d 80 00       	push   $0x804d3d
  803904:	6a 7a                	push   $0x7a
  803906:	68 a3 4c 80 00       	push   $0x804ca3
  80390b:	e8 1b cb ff ff       	call   80042b <_panic>
  803910:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803913:	8b 00                	mov    (%eax),%eax
  803915:	85 c0                	test   %eax,%eax
  803917:	74 10                	je     803929 <alloc_block+0x1c7>
  803919:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80391c:	8b 00                	mov    (%eax),%eax
  80391e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803921:	8b 52 04             	mov    0x4(%edx),%edx
  803924:	89 50 04             	mov    %edx,0x4(%eax)
  803927:	eb 0b                	jmp    803934 <alloc_block+0x1d2>
  803929:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80392c:	8b 40 04             	mov    0x4(%eax),%eax
  80392f:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803934:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803937:	8b 40 04             	mov    0x4(%eax),%eax
  80393a:	85 c0                	test   %eax,%eax
  80393c:	74 0f                	je     80394d <alloc_block+0x1eb>
  80393e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803941:	8b 40 04             	mov    0x4(%eax),%eax
  803944:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803947:	8b 12                	mov    (%edx),%edx
  803949:	89 10                	mov    %edx,(%eax)
  80394b:	eb 0a                	jmp    803957 <alloc_block+0x1f5>
  80394d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803950:	8b 00                	mov    (%eax),%eax
  803952:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803957:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80395a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803960:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803963:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80396a:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80396f:	48                   	dec    %eax
  803970:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803975:	83 ec 0c             	sub    $0xc,%esp
  803978:	ff 75 dc             	pushl  -0x24(%ebp)
  80397b:	e8 6f fa ff ff       	call   8033ef <to_page_va>
  803980:	83 c4 10             	add    $0x10,%esp
  803983:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803986:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803989:	83 ec 0c             	sub    $0xc,%esp
  80398c:	50                   	push   %eax
  80398d:	e8 a0 dc ff ff       	call   801632 <get_page>
  803992:	83 c4 10             	add    $0x10,%esp
  803995:	85 c0                	test   %eax,%eax
  803997:	74 14                	je     8039ad <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803999:	83 ec 04             	sub    $0x4,%esp
  80399c:	68 84 4d 80 00       	push   $0x804d84
  8039a1:	6a 7f                	push   $0x7f
  8039a3:	68 a3 4c 80 00       	push   $0x804ca3
  8039a8:	e8 7e ca ff ff       	call   80042b <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  8039ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039b3:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  8039b7:	b8 00 10 00 00       	mov    $0x1000,%eax
  8039bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8039c1:	f7 75 f4             	divl   -0xc(%ebp)
  8039c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039c7:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8039cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8039d2:	e9 a7 00 00 00       	jmp    803a7e <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  8039d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039dd:	01 d0                	add    %edx,%eax
  8039df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  8039e2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039e6:	75 17                	jne    8039ff <alloc_block+0x29d>
  8039e8:	83 ec 04             	sub    $0x4,%esp
  8039eb:	68 ac 4d 80 00       	push   $0x804dac
  8039f0:	68 88 00 00 00       	push   $0x88
  8039f5:	68 a3 4c 80 00       	push   $0x804ca3
  8039fa:	e8 2c ca ff ff       	call   80042b <_panic>
  8039ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a02:	c1 e0 04             	shl    $0x4,%eax
  803a05:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a0a:	8b 10                	mov    (%eax),%edx
  803a0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a0f:	89 10                	mov    %edx,(%eax)
  803a11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a14:	8b 00                	mov    (%eax),%eax
  803a16:	85 c0                	test   %eax,%eax
  803a18:	74 15                	je     803a2f <alloc_block+0x2cd>
  803a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1d:	c1 e0 04             	shl    $0x4,%eax
  803a20:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a25:	8b 00                	mov    (%eax),%eax
  803a27:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a2a:	89 50 04             	mov    %edx,0x4(%eax)
  803a2d:	eb 11                	jmp    803a40 <alloc_block+0x2de>
  803a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a32:	c1 e0 04             	shl    $0x4,%eax
  803a35:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803a3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a3e:	89 02                	mov    %eax,(%edx)
  803a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a43:	c1 e0 04             	shl    $0x4,%eax
  803a46:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803a4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a4f:	89 02                	mov    %eax,(%edx)
  803a51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5e:	c1 e0 04             	shl    $0x4,%eax
  803a61:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a66:	8b 00                	mov    (%eax),%eax
  803a68:	8d 50 01             	lea    0x1(%eax),%edx
  803a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6e:	c1 e0 04             	shl    $0x4,%eax
  803a71:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a76:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7b:	01 45 e8             	add    %eax,-0x18(%ebp)
  803a7e:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803a85:	0f 86 4c ff ff ff    	jbe    8039d7 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8e:	c1 e0 04             	shl    $0x4,%eax
  803a91:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a96:	8b 00                	mov    (%eax),%eax
  803a98:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803a9b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a9f:	75 17                	jne    803ab8 <alloc_block+0x356>
  803aa1:	83 ec 04             	sub    $0x4,%esp
  803aa4:	68 3d 4d 80 00       	push   $0x804d3d
  803aa9:	68 8d 00 00 00       	push   $0x8d
  803aae:	68 a3 4c 80 00       	push   $0x804ca3
  803ab3:	e8 73 c9 ff ff       	call   80042b <_panic>
  803ab8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803abb:	8b 00                	mov    (%eax),%eax
  803abd:	85 c0                	test   %eax,%eax
  803abf:	74 10                	je     803ad1 <alloc_block+0x36f>
  803ac1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ac4:	8b 00                	mov    (%eax),%eax
  803ac6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803ac9:	8b 52 04             	mov    0x4(%edx),%edx
  803acc:	89 50 04             	mov    %edx,0x4(%eax)
  803acf:	eb 14                	jmp    803ae5 <alloc_block+0x383>
  803ad1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ad4:	8b 40 04             	mov    0x4(%eax),%eax
  803ad7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ada:	c1 e2 04             	shl    $0x4,%edx
  803add:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803ae3:	89 02                	mov    %eax,(%edx)
  803ae5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ae8:	8b 40 04             	mov    0x4(%eax),%eax
  803aeb:	85 c0                	test   %eax,%eax
  803aed:	74 0f                	je     803afe <alloc_block+0x39c>
  803aef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803af2:	8b 40 04             	mov    0x4(%eax),%eax
  803af5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803af8:	8b 12                	mov    (%edx),%edx
  803afa:	89 10                	mov    %edx,(%eax)
  803afc:	eb 13                	jmp    803b11 <alloc_block+0x3af>
  803afe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b01:	8b 00                	mov    (%eax),%eax
  803b03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b06:	c1 e2 04             	shl    $0x4,%edx
  803b09:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803b0f:	89 02                	mov    %eax,(%edx)
  803b11:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b27:	c1 e0 04             	shl    $0x4,%eax
  803b2a:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b2f:	8b 00                	mov    (%eax),%eax
  803b31:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b37:	c1 e0 04             	shl    $0x4,%eax
  803b3a:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b3f:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803b41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b44:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b48:	48                   	dec    %eax
  803b49:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b4c:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803b50:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803b53:	c9                   	leave  
  803b54:	c3                   	ret    

00803b55 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803b55:	55                   	push   %ebp
  803b56:	89 e5                	mov    %esp,%ebp
  803b58:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803b5b:	8b 55 08             	mov    0x8(%ebp),%edx
  803b5e:	a1 84 50 83 00       	mov    0x835084,%eax
  803b63:	39 c2                	cmp    %eax,%edx
  803b65:	72 0c                	jb     803b73 <free_block+0x1e>
  803b67:	8b 55 08             	mov    0x8(%ebp),%edx
  803b6a:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803b6f:	39 c2                	cmp    %eax,%edx
  803b71:	72 19                	jb     803b8c <free_block+0x37>
  803b73:	68 d0 4d 80 00       	push   $0x804dd0
  803b78:	68 06 4d 80 00       	push   $0x804d06
  803b7d:	68 98 00 00 00       	push   $0x98
  803b82:	68 a3 4c 80 00       	push   $0x804ca3
  803b87:	e8 9f c8 ff ff       	call   80042b <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8f:	83 ec 0c             	sub    $0xc,%esp
  803b92:	50                   	push   %eax
  803b93:	e8 c9 f8 ff ff       	call   803461 <to_page_info>
  803b98:	83 c4 10             	add    $0x10,%esp
  803b9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ba1:	8b 40 08             	mov    0x8(%eax),%eax
  803ba4:	0f b7 c0             	movzwl %ax,%eax
  803ba7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803baa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803bb1:	eb 03                	jmp    803bb6 <free_block+0x61>
		listIndex++;
  803bb3:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb9:	ba 08 00 00 00       	mov    $0x8,%edx
  803bbe:	88 c1                	mov    %al,%cl
  803bc0:	d3 e2                	shl    %cl,%edx
  803bc2:	89 d0                	mov    %edx,%eax
  803bc4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bc7:	72 ea                	jb     803bb3 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803bcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bd3:	75 17                	jne    803bec <free_block+0x97>
  803bd5:	83 ec 04             	sub    $0x4,%esp
  803bd8:	68 ac 4d 80 00       	push   $0x804dac
  803bdd:	68 a2 00 00 00       	push   $0xa2
  803be2:	68 a3 4c 80 00       	push   $0x804ca3
  803be7:	e8 3f c8 ff ff       	call   80042b <_panic>
  803bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bef:	c1 e0 04             	shl    $0x4,%eax
  803bf2:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bf7:	8b 10                	mov    (%eax),%edx
  803bf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfc:	89 10                	mov    %edx,(%eax)
  803bfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c01:	8b 00                	mov    (%eax),%eax
  803c03:	85 c0                	test   %eax,%eax
  803c05:	74 15                	je     803c1c <free_block+0xc7>
  803c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0a:	c1 e0 04             	shl    $0x4,%eax
  803c0d:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c12:	8b 00                	mov    (%eax),%eax
  803c14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c17:	89 50 04             	mov    %edx,0x4(%eax)
  803c1a:	eb 11                	jmp    803c2d <free_block+0xd8>
  803c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c1f:	c1 e0 04             	shl    $0x4,%eax
  803c22:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803c28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2b:	89 02                	mov    %eax,(%edx)
  803c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c30:	c1 e0 04             	shl    $0x4,%eax
  803c33:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3c:	89 02                	mov    %eax,(%edx)
  803c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4b:	c1 e0 04             	shl    $0x4,%eax
  803c4e:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c53:	8b 00                	mov    (%eax),%eax
  803c55:	8d 50 01             	lea    0x1(%eax),%edx
  803c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5b:	c1 e0 04             	shl    $0x4,%eax
  803c5e:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c63:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c68:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c6c:	40                   	inc    %eax
  803c6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c70:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c77:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c7b:	0f b7 c8             	movzwl %ax,%ecx
  803c7e:	b8 00 10 00 00       	mov    $0x1000,%eax
  803c83:	ba 00 00 00 00       	mov    $0x0,%edx
  803c88:	f7 75 e8             	divl   -0x18(%ebp)
  803c8b:	39 c1                	cmp    %eax,%ecx
  803c8d:	0f 85 ed 01 00 00    	jne    803e80 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c96:	c1 e0 04             	shl    $0x4,%eax
  803c99:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c9e:	8b 00                	mov    (%eax),%eax
  803ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ca3:	eb 2a                	jmp    803ccf <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca8:	83 ec 0c             	sub    $0xc,%esp
  803cab:	50                   	push   %eax
  803cac:	e8 b0 f7 ff ff       	call   803461 <to_page_info>
  803cb1:	83 c4 10             	add    $0x10,%esp
  803cb4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803cb7:	75 06                	jne    803cbf <free_block+0x16a>
				tmp = b;
  803cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cbc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc2:	c1 e0 04             	shl    $0x4,%eax
  803cc5:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803cca:	8b 00                	mov    (%eax),%eax
  803ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ccf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cd3:	74 07                	je     803cdc <free_block+0x187>
  803cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd8:	8b 00                	mov    (%eax),%eax
  803cda:	eb 05                	jmp    803ce1 <free_block+0x18c>
  803cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  803ce1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ce4:	c1 e2 04             	shl    $0x4,%edx
  803ce7:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803ced:	89 02                	mov    %eax,(%edx)
  803cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf2:	c1 e0 04             	shl    $0x4,%eax
  803cf5:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803cfa:	8b 00                	mov    (%eax),%eax
  803cfc:	85 c0                	test   %eax,%eax
  803cfe:	75 a5                	jne    803ca5 <free_block+0x150>
  803d00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d04:	75 9f                	jne    803ca5 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d09:	c1 e0 04             	shl    $0x4,%eax
  803d0c:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d11:	8b 00                	mov    (%eax),%eax
  803d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803d16:	e9 cc 00 00 00       	jmp    803de7 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d1e:	8b 00                	mov    (%eax),%eax
  803d20:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d26:	83 ec 0c             	sub    $0xc,%esp
  803d29:	50                   	push   %eax
  803d2a:	e8 32 f7 ff ff       	call   803461 <to_page_info>
  803d2f:	83 c4 10             	add    $0x10,%esp
  803d32:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d35:	0f 85 a6 00 00 00    	jne    803de1 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803d3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d3f:	75 17                	jne    803d58 <free_block+0x203>
  803d41:	83 ec 04             	sub    $0x4,%esp
  803d44:	68 3d 4d 80 00       	push   $0x804d3d
  803d49:	68 b5 00 00 00       	push   $0xb5
  803d4e:	68 a3 4c 80 00       	push   $0x804ca3
  803d53:	e8 d3 c6 ff ff       	call   80042b <_panic>
  803d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d5b:	8b 00                	mov    (%eax),%eax
  803d5d:	85 c0                	test   %eax,%eax
  803d5f:	74 10                	je     803d71 <free_block+0x21c>
  803d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d64:	8b 00                	mov    (%eax),%eax
  803d66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d69:	8b 52 04             	mov    0x4(%edx),%edx
  803d6c:	89 50 04             	mov    %edx,0x4(%eax)
  803d6f:	eb 14                	jmp    803d85 <free_block+0x230>
  803d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d74:	8b 40 04             	mov    0x4(%eax),%eax
  803d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d7a:	c1 e2 04             	shl    $0x4,%edx
  803d7d:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803d83:	89 02                	mov    %eax,(%edx)
  803d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d88:	8b 40 04             	mov    0x4(%eax),%eax
  803d8b:	85 c0                	test   %eax,%eax
  803d8d:	74 0f                	je     803d9e <free_block+0x249>
  803d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d92:	8b 40 04             	mov    0x4(%eax),%eax
  803d95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d98:	8b 12                	mov    (%edx),%edx
  803d9a:	89 10                	mov    %edx,(%eax)
  803d9c:	eb 13                	jmp    803db1 <free_block+0x25c>
  803d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803da1:	8b 00                	mov    (%eax),%eax
  803da3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803da6:	c1 e2 04             	shl    $0x4,%edx
  803da9:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803daf:	89 02                	mov    %eax,(%edx)
  803db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc7:	c1 e0 04             	shl    $0x4,%eax
  803dca:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803dcf:	8b 00                	mov    (%eax),%eax
  803dd1:	8d 50 ff             	lea    -0x1(%eax),%edx
  803dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd7:	c1 e0 04             	shl    $0x4,%eax
  803dda:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ddf:	89 10                	mov    %edx,(%eax)
			b = next;
  803de1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803de7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803deb:	0f 85 2a ff ff ff    	jne    803d1b <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803df4:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dfd:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803e03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e07:	75 17                	jne    803e20 <free_block+0x2cb>
  803e09:	83 ec 04             	sub    $0x4,%esp
  803e0c:	68 ac 4d 80 00       	push   $0x804dac
  803e11:	68 bc 00 00 00       	push   $0xbc
  803e16:	68 a3 4c 80 00       	push   $0x804ca3
  803e1b:	e8 0b c6 ff ff       	call   80042b <_panic>
  803e20:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e29:	89 10                	mov    %edx,(%eax)
  803e2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e2e:	8b 00                	mov    (%eax),%eax
  803e30:	85 c0                	test   %eax,%eax
  803e32:	74 0d                	je     803e41 <free_block+0x2ec>
  803e34:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803e39:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e3c:	89 50 04             	mov    %edx,0x4(%eax)
  803e3f:	eb 08                	jmp    803e49 <free_block+0x2f4>
  803e41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e44:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e4c:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e5b:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803e60:	40                   	inc    %eax
  803e61:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803e66:	83 ec 0c             	sub    $0xc,%esp
  803e69:	ff 75 ec             	pushl  -0x14(%ebp)
  803e6c:	e8 7e f5 ff ff       	call   8033ef <to_page_va>
  803e71:	83 c4 10             	add    $0x10,%esp
  803e74:	83 ec 0c             	sub    $0xc,%esp
  803e77:	50                   	push   %eax
  803e78:	e8 fe d7 ff ff       	call   80167b <return_page>
  803e7d:	83 c4 10             	add    $0x10,%esp
	}
}
  803e80:	90                   	nop
  803e81:	c9                   	leave  
  803e82:	c3                   	ret    
  803e83:	90                   	nop

00803e84 <__udivdi3>:
  803e84:	55                   	push   %ebp
  803e85:	57                   	push   %edi
  803e86:	56                   	push   %esi
  803e87:	53                   	push   %ebx
  803e88:	83 ec 1c             	sub    $0x1c,%esp
  803e8b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e9b:	89 ca                	mov    %ecx,%edx
  803e9d:	89 f8                	mov    %edi,%eax
  803e9f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ea3:	85 f6                	test   %esi,%esi
  803ea5:	75 2d                	jne    803ed4 <__udivdi3+0x50>
  803ea7:	39 cf                	cmp    %ecx,%edi
  803ea9:	77 65                	ja     803f10 <__udivdi3+0x8c>
  803eab:	89 fd                	mov    %edi,%ebp
  803ead:	85 ff                	test   %edi,%edi
  803eaf:	75 0b                	jne    803ebc <__udivdi3+0x38>
  803eb1:	b8 01 00 00 00       	mov    $0x1,%eax
  803eb6:	31 d2                	xor    %edx,%edx
  803eb8:	f7 f7                	div    %edi
  803eba:	89 c5                	mov    %eax,%ebp
  803ebc:	31 d2                	xor    %edx,%edx
  803ebe:	89 c8                	mov    %ecx,%eax
  803ec0:	f7 f5                	div    %ebp
  803ec2:	89 c1                	mov    %eax,%ecx
  803ec4:	89 d8                	mov    %ebx,%eax
  803ec6:	f7 f5                	div    %ebp
  803ec8:	89 cf                	mov    %ecx,%edi
  803eca:	89 fa                	mov    %edi,%edx
  803ecc:	83 c4 1c             	add    $0x1c,%esp
  803ecf:	5b                   	pop    %ebx
  803ed0:	5e                   	pop    %esi
  803ed1:	5f                   	pop    %edi
  803ed2:	5d                   	pop    %ebp
  803ed3:	c3                   	ret    
  803ed4:	39 ce                	cmp    %ecx,%esi
  803ed6:	77 28                	ja     803f00 <__udivdi3+0x7c>
  803ed8:	0f bd fe             	bsr    %esi,%edi
  803edb:	83 f7 1f             	xor    $0x1f,%edi
  803ede:	75 40                	jne    803f20 <__udivdi3+0x9c>
  803ee0:	39 ce                	cmp    %ecx,%esi
  803ee2:	72 0a                	jb     803eee <__udivdi3+0x6a>
  803ee4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ee8:	0f 87 9e 00 00 00    	ja     803f8c <__udivdi3+0x108>
  803eee:	b8 01 00 00 00       	mov    $0x1,%eax
  803ef3:	89 fa                	mov    %edi,%edx
  803ef5:	83 c4 1c             	add    $0x1c,%esp
  803ef8:	5b                   	pop    %ebx
  803ef9:	5e                   	pop    %esi
  803efa:	5f                   	pop    %edi
  803efb:	5d                   	pop    %ebp
  803efc:	c3                   	ret    
  803efd:	8d 76 00             	lea    0x0(%esi),%esi
  803f00:	31 ff                	xor    %edi,%edi
  803f02:	31 c0                	xor    %eax,%eax
  803f04:	89 fa                	mov    %edi,%edx
  803f06:	83 c4 1c             	add    $0x1c,%esp
  803f09:	5b                   	pop    %ebx
  803f0a:	5e                   	pop    %esi
  803f0b:	5f                   	pop    %edi
  803f0c:	5d                   	pop    %ebp
  803f0d:	c3                   	ret    
  803f0e:	66 90                	xchg   %ax,%ax
  803f10:	89 d8                	mov    %ebx,%eax
  803f12:	f7 f7                	div    %edi
  803f14:	31 ff                	xor    %edi,%edi
  803f16:	89 fa                	mov    %edi,%edx
  803f18:	83 c4 1c             	add    $0x1c,%esp
  803f1b:	5b                   	pop    %ebx
  803f1c:	5e                   	pop    %esi
  803f1d:	5f                   	pop    %edi
  803f1e:	5d                   	pop    %ebp
  803f1f:	c3                   	ret    
  803f20:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f25:	89 eb                	mov    %ebp,%ebx
  803f27:	29 fb                	sub    %edi,%ebx
  803f29:	89 f9                	mov    %edi,%ecx
  803f2b:	d3 e6                	shl    %cl,%esi
  803f2d:	89 c5                	mov    %eax,%ebp
  803f2f:	88 d9                	mov    %bl,%cl
  803f31:	d3 ed                	shr    %cl,%ebp
  803f33:	89 e9                	mov    %ebp,%ecx
  803f35:	09 f1                	or     %esi,%ecx
  803f37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f3b:	89 f9                	mov    %edi,%ecx
  803f3d:	d3 e0                	shl    %cl,%eax
  803f3f:	89 c5                	mov    %eax,%ebp
  803f41:	89 d6                	mov    %edx,%esi
  803f43:	88 d9                	mov    %bl,%cl
  803f45:	d3 ee                	shr    %cl,%esi
  803f47:	89 f9                	mov    %edi,%ecx
  803f49:	d3 e2                	shl    %cl,%edx
  803f4b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f4f:	88 d9                	mov    %bl,%cl
  803f51:	d3 e8                	shr    %cl,%eax
  803f53:	09 c2                	or     %eax,%edx
  803f55:	89 d0                	mov    %edx,%eax
  803f57:	89 f2                	mov    %esi,%edx
  803f59:	f7 74 24 0c          	divl   0xc(%esp)
  803f5d:	89 d6                	mov    %edx,%esi
  803f5f:	89 c3                	mov    %eax,%ebx
  803f61:	f7 e5                	mul    %ebp
  803f63:	39 d6                	cmp    %edx,%esi
  803f65:	72 19                	jb     803f80 <__udivdi3+0xfc>
  803f67:	74 0b                	je     803f74 <__udivdi3+0xf0>
  803f69:	89 d8                	mov    %ebx,%eax
  803f6b:	31 ff                	xor    %edi,%edi
  803f6d:	e9 58 ff ff ff       	jmp    803eca <__udivdi3+0x46>
  803f72:	66 90                	xchg   %ax,%ax
  803f74:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f78:	89 f9                	mov    %edi,%ecx
  803f7a:	d3 e2                	shl    %cl,%edx
  803f7c:	39 c2                	cmp    %eax,%edx
  803f7e:	73 e9                	jae    803f69 <__udivdi3+0xe5>
  803f80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f83:	31 ff                	xor    %edi,%edi
  803f85:	e9 40 ff ff ff       	jmp    803eca <__udivdi3+0x46>
  803f8a:	66 90                	xchg   %ax,%ax
  803f8c:	31 c0                	xor    %eax,%eax
  803f8e:	e9 37 ff ff ff       	jmp    803eca <__udivdi3+0x46>
  803f93:	90                   	nop

00803f94 <__umoddi3>:
  803f94:	55                   	push   %ebp
  803f95:	57                   	push   %edi
  803f96:	56                   	push   %esi
  803f97:	53                   	push   %ebx
  803f98:	83 ec 1c             	sub    $0x1c,%esp
  803f9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803fa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fa7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803fab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803faf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fb3:	89 f3                	mov    %esi,%ebx
  803fb5:	89 fa                	mov    %edi,%edx
  803fb7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fbb:	89 34 24             	mov    %esi,(%esp)
  803fbe:	85 c0                	test   %eax,%eax
  803fc0:	75 1a                	jne    803fdc <__umoddi3+0x48>
  803fc2:	39 f7                	cmp    %esi,%edi
  803fc4:	0f 86 a2 00 00 00    	jbe    80406c <__umoddi3+0xd8>
  803fca:	89 c8                	mov    %ecx,%eax
  803fcc:	89 f2                	mov    %esi,%edx
  803fce:	f7 f7                	div    %edi
  803fd0:	89 d0                	mov    %edx,%eax
  803fd2:	31 d2                	xor    %edx,%edx
  803fd4:	83 c4 1c             	add    $0x1c,%esp
  803fd7:	5b                   	pop    %ebx
  803fd8:	5e                   	pop    %esi
  803fd9:	5f                   	pop    %edi
  803fda:	5d                   	pop    %ebp
  803fdb:	c3                   	ret    
  803fdc:	39 f0                	cmp    %esi,%eax
  803fde:	0f 87 ac 00 00 00    	ja     804090 <__umoddi3+0xfc>
  803fe4:	0f bd e8             	bsr    %eax,%ebp
  803fe7:	83 f5 1f             	xor    $0x1f,%ebp
  803fea:	0f 84 ac 00 00 00    	je     80409c <__umoddi3+0x108>
  803ff0:	bf 20 00 00 00       	mov    $0x20,%edi
  803ff5:	29 ef                	sub    %ebp,%edi
  803ff7:	89 fe                	mov    %edi,%esi
  803ff9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ffd:	89 e9                	mov    %ebp,%ecx
  803fff:	d3 e0                	shl    %cl,%eax
  804001:	89 d7                	mov    %edx,%edi
  804003:	89 f1                	mov    %esi,%ecx
  804005:	d3 ef                	shr    %cl,%edi
  804007:	09 c7                	or     %eax,%edi
  804009:	89 e9                	mov    %ebp,%ecx
  80400b:	d3 e2                	shl    %cl,%edx
  80400d:	89 14 24             	mov    %edx,(%esp)
  804010:	89 d8                	mov    %ebx,%eax
  804012:	d3 e0                	shl    %cl,%eax
  804014:	89 c2                	mov    %eax,%edx
  804016:	8b 44 24 08          	mov    0x8(%esp),%eax
  80401a:	d3 e0                	shl    %cl,%eax
  80401c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804020:	8b 44 24 08          	mov    0x8(%esp),%eax
  804024:	89 f1                	mov    %esi,%ecx
  804026:	d3 e8                	shr    %cl,%eax
  804028:	09 d0                	or     %edx,%eax
  80402a:	d3 eb                	shr    %cl,%ebx
  80402c:	89 da                	mov    %ebx,%edx
  80402e:	f7 f7                	div    %edi
  804030:	89 d3                	mov    %edx,%ebx
  804032:	f7 24 24             	mull   (%esp)
  804035:	89 c6                	mov    %eax,%esi
  804037:	89 d1                	mov    %edx,%ecx
  804039:	39 d3                	cmp    %edx,%ebx
  80403b:	0f 82 87 00 00 00    	jb     8040c8 <__umoddi3+0x134>
  804041:	0f 84 91 00 00 00    	je     8040d8 <__umoddi3+0x144>
  804047:	8b 54 24 04          	mov    0x4(%esp),%edx
  80404b:	29 f2                	sub    %esi,%edx
  80404d:	19 cb                	sbb    %ecx,%ebx
  80404f:	89 d8                	mov    %ebx,%eax
  804051:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804055:	d3 e0                	shl    %cl,%eax
  804057:	89 e9                	mov    %ebp,%ecx
  804059:	d3 ea                	shr    %cl,%edx
  80405b:	09 d0                	or     %edx,%eax
  80405d:	89 e9                	mov    %ebp,%ecx
  80405f:	d3 eb                	shr    %cl,%ebx
  804061:	89 da                	mov    %ebx,%edx
  804063:	83 c4 1c             	add    $0x1c,%esp
  804066:	5b                   	pop    %ebx
  804067:	5e                   	pop    %esi
  804068:	5f                   	pop    %edi
  804069:	5d                   	pop    %ebp
  80406a:	c3                   	ret    
  80406b:	90                   	nop
  80406c:	89 fd                	mov    %edi,%ebp
  80406e:	85 ff                	test   %edi,%edi
  804070:	75 0b                	jne    80407d <__umoddi3+0xe9>
  804072:	b8 01 00 00 00       	mov    $0x1,%eax
  804077:	31 d2                	xor    %edx,%edx
  804079:	f7 f7                	div    %edi
  80407b:	89 c5                	mov    %eax,%ebp
  80407d:	89 f0                	mov    %esi,%eax
  80407f:	31 d2                	xor    %edx,%edx
  804081:	f7 f5                	div    %ebp
  804083:	89 c8                	mov    %ecx,%eax
  804085:	f7 f5                	div    %ebp
  804087:	89 d0                	mov    %edx,%eax
  804089:	e9 44 ff ff ff       	jmp    803fd2 <__umoddi3+0x3e>
  80408e:	66 90                	xchg   %ax,%ax
  804090:	89 c8                	mov    %ecx,%eax
  804092:	89 f2                	mov    %esi,%edx
  804094:	83 c4 1c             	add    $0x1c,%esp
  804097:	5b                   	pop    %ebx
  804098:	5e                   	pop    %esi
  804099:	5f                   	pop    %edi
  80409a:	5d                   	pop    %ebp
  80409b:	c3                   	ret    
  80409c:	3b 04 24             	cmp    (%esp),%eax
  80409f:	72 06                	jb     8040a7 <__umoddi3+0x113>
  8040a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040a5:	77 0f                	ja     8040b6 <__umoddi3+0x122>
  8040a7:	89 f2                	mov    %esi,%edx
  8040a9:	29 f9                	sub    %edi,%ecx
  8040ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040af:	89 14 24             	mov    %edx,(%esp)
  8040b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040ba:	8b 14 24             	mov    (%esp),%edx
  8040bd:	83 c4 1c             	add    $0x1c,%esp
  8040c0:	5b                   	pop    %ebx
  8040c1:	5e                   	pop    %esi
  8040c2:	5f                   	pop    %edi
  8040c3:	5d                   	pop    %ebp
  8040c4:	c3                   	ret    
  8040c5:	8d 76 00             	lea    0x0(%esi),%esi
  8040c8:	2b 04 24             	sub    (%esp),%eax
  8040cb:	19 fa                	sbb    %edi,%edx
  8040cd:	89 d1                	mov    %edx,%ecx
  8040cf:	89 c6                	mov    %eax,%esi
  8040d1:	e9 71 ff ff ff       	jmp    804047 <__umoddi3+0xb3>
  8040d6:	66 90                	xchg   %ax,%ax
  8040d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040dc:	72 ea                	jb     8040c8 <__umoddi3+0x134>
  8040de:	89 d9                	mov    %ebx,%ecx
  8040e0:	e9 62 ff ff ff       	jmp    804047 <__umoddi3+0xb3>
