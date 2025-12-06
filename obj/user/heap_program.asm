
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 12 02 00 00       	call   800248 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 1d 16 00 00       	call   801688 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 0c 16 00 00       	call   801688 <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 f4 2e 00 00       	call   802f7b <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 f7 18 00 00       	call   8019e8 <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 e9 18 00 00       	call   8019e8 <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 29 2e 00 00       	call   802f30 <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 73 15 00 00       	call   801688 <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb bc 41 80 00       	mov    $0x8041bc,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	e9 81 00 00 00       	jmp    8001f1 <_main+0x1b9>
		{
			int found = 0 ;
  800170:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800177:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017e:	eb 3d                	jmp    8001bd <_main+0x185>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  800180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800183:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800187:	a1 20 50 80 00       	mov    0x805020,%eax
  80018c:	8b 98 90 05 00 00    	mov    0x590(%eax),%ebx
  800192:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800195:	89 d0                	mov    %edx,%eax
  800197:	01 c0                	add    %eax,%eax
  800199:	01 d0                	add    %edx,%eax
  80019b:	c1 e0 03             	shl    $0x3,%eax
  80019e:	01 d8                	add    %ebx,%eax
  8001a0:	8b 00                	mov    (%eax),%eax
  8001a2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ad:	39 c1                	cmp    %eax,%ecx
  8001af:	75 09                	jne    8001ba <_main+0x182>
				{
					found = 1 ;
  8001b1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001b8:	eb 15                	jmp    8001cf <_main+0x197>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001ba:	ff 45 e0             	incl   -0x20(%ebp)
  8001bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8001c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001cb:	39 c2                	cmp    %eax,%edx
  8001cd:	77 b1                	ja     800180 <_main+0x148>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d3:	75 19                	jne    8001ee <_main+0x1b6>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d8:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001dc:	50                   	push   %eax
  8001dd:	68 c0 40 80 00       	push   $0x8040c0
  8001e2:	6a 4c                	push   $0x4c
  8001e4:	68 21 41 80 00       	push   $0x804121
  8001e9:	e8 0a 02 00 00       	call   8003f8 <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001ee:	ff 45 e4             	incl   -0x1c(%ebp)
  8001f1:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001f5:	0f 8e 75 ff ff ff    	jle    800170 <_main+0x138>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  8001fb:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8001fe:	e8 2d 2d 00 00       	call   802f30 <sys_calculate_free_frames>
  800203:	29 c3                	sub    %eax,%ebx
  800205:	89 d8                	mov    %ebx,%eax
  800207:	83 f8 06             	cmp    $0x6,%eax
  80020a:	74 23                	je     80022f <_main+0x1f7>
  80020c:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  80020f:	e8 1c 2d 00 00       	call   802f30 <sys_calculate_free_frames>
  800214:	29 c3                	sub    %eax,%ebx
  800216:	89 d8                	mov    %ebx,%eax
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	6a 08                	push   $0x8
  80021d:	50                   	push   %eax
  80021e:	68 38 41 80 00       	push   $0x804138
  800223:	6a 4f                	push   $0x4f
  800225:	68 21 41 80 00       	push   $0x804121
  80022a:	e8 c9 01 00 00       	call   8003f8 <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	68 7c 41 80 00       	push   $0x80417c
  800237:	e8 8a 04 00 00       	call   8006c6 <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp


	return;
  80023f:	90                   	nop
}
  800240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800243:	5b                   	pop    %ebx
  800244:	5e                   	pop    %esi
  800245:	5f                   	pop    %edi
  800246:	5d                   	pop    %ebp
  800247:	c3                   	ret    

00800248 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	57                   	push   %edi
  80024c:	56                   	push   %esi
  80024d:	53                   	push   %ebx
  80024e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800251:	e8 a3 2e 00 00       	call   8030f9 <sys_getenvindex>
  800256:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800259:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80025c:	89 d0                	mov    %edx,%eax
  80025e:	c1 e0 03             	shl    $0x3,%eax
  800261:	01 d0                	add    %edx,%eax
  800263:	c1 e0 02             	shl    $0x2,%eax
  800266:	01 d0                	add    %edx,%eax
  800268:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026f:	01 d0                	add    %edx,%eax
  800271:	c1 e0 03             	shl    $0x3,%eax
  800274:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800279:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027e:	a1 20 50 80 00       	mov    0x805020,%eax
  800283:	8a 40 20             	mov    0x20(%eax),%al
  800286:	84 c0                	test   %al,%al
  800288:	74 0d                	je     800297 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80028a:	a1 20 50 80 00       	mov    0x805020,%eax
  80028f:	83 c0 20             	add    $0x20,%eax
  800292:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029b:	7e 0a                	jle    8002a7 <libmain+0x5f>
		binaryname = argv[0];
  80029d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a0:	8b 00                	mov    (%eax),%eax
  8002a2:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8002a7:	83 ec 08             	sub    $0x8,%esp
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	e8 83 fd ff ff       	call   800038 <_main>
  8002b5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002b8:	a1 00 50 80 00       	mov    0x805000,%eax
  8002bd:	85 c0                	test   %eax,%eax
  8002bf:	0f 84 01 01 00 00    	je     8003c6 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002c5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002cb:	bb d0 42 80 00       	mov    $0x8042d0,%ebx
  8002d0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002d5:	89 c7                	mov    %eax,%edi
  8002d7:	89 de                	mov    %ebx,%esi
  8002d9:	89 d1                	mov    %edx,%ecx
  8002db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002dd:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002e0:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002e5:	b0 00                	mov    $0x0,%al
  8002e7:	89 d7                	mov    %edx,%edi
  8002e9:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002f2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	50                   	push   %eax
  8002f9:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002ff:	50                   	push   %eax
  800300:	e8 2a 30 00 00       	call   80332f <sys_utilities>
  800305:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800308:	e8 73 2b 00 00       	call   802e80 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	68 f0 41 80 00       	push   $0x8041f0
  800315:	e8 ac 03 00 00       	call   8006c6 <cprintf>
  80031a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80031d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800320:	85 c0                	test   %eax,%eax
  800322:	74 18                	je     80033c <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800324:	e8 24 30 00 00       	call   80334d <sys_get_optimal_num_faults>
  800329:	83 ec 08             	sub    $0x8,%esp
  80032c:	50                   	push   %eax
  80032d:	68 18 42 80 00       	push   $0x804218
  800332:	e8 8f 03 00 00       	call   8006c6 <cprintf>
  800337:	83 c4 10             	add    $0x10,%esp
  80033a:	eb 59                	jmp    800395 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80033c:	a1 20 50 80 00       	mov    0x805020,%eax
  800341:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800347:	a1 20 50 80 00       	mov    0x805020,%eax
  80034c:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800352:	83 ec 04             	sub    $0x4,%esp
  800355:	52                   	push   %edx
  800356:	50                   	push   %eax
  800357:	68 3c 42 80 00       	push   $0x80423c
  80035c:	e8 65 03 00 00       	call   8006c6 <cprintf>
  800361:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800364:	a1 20 50 80 00       	mov    0x805020,%eax
  800369:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80036f:	a1 20 50 80 00       	mov    0x805020,%eax
  800374:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80037a:	a1 20 50 80 00       	mov    0x805020,%eax
  80037f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800385:	51                   	push   %ecx
  800386:	52                   	push   %edx
  800387:	50                   	push   %eax
  800388:	68 64 42 80 00       	push   $0x804264
  80038d:	e8 34 03 00 00       	call   8006c6 <cprintf>
  800392:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800395:	a1 20 50 80 00       	mov    0x805020,%eax
  80039a:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8003a0:	83 ec 08             	sub    $0x8,%esp
  8003a3:	50                   	push   %eax
  8003a4:	68 bc 42 80 00       	push   $0x8042bc
  8003a9:	e8 18 03 00 00       	call   8006c6 <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	68 f0 41 80 00       	push   $0x8041f0
  8003b9:	e8 08 03 00 00       	call   8006c6 <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003c1:	e8 d4 2a 00 00       	call   802e9a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003c6:	e8 1f 00 00 00       	call   8003ea <exit>
}
  8003cb:	90                   	nop
  8003cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003cf:	5b                   	pop    %ebx
  8003d0:	5e                   	pop    %esi
  8003d1:	5f                   	pop    %edi
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    

008003d4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003da:	83 ec 0c             	sub    $0xc,%esp
  8003dd:	6a 00                	push   $0x0
  8003df:	e8 e1 2c 00 00       	call   8030c5 <sys_destroy_env>
  8003e4:	83 c4 10             	add    $0x10,%esp
}
  8003e7:	90                   	nop
  8003e8:	c9                   	leave  
  8003e9:	c3                   	ret    

008003ea <exit>:

void
exit(void)
{
  8003ea:	55                   	push   %ebp
  8003eb:	89 e5                	mov    %esp,%ebp
  8003ed:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f0:	e8 36 2d 00 00       	call   80312b <sys_exit_env>
}
  8003f5:	90                   	nop
  8003f6:	c9                   	leave  
  8003f7:	c3                   	ret    

008003f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fe:	8d 45 10             	lea    0x10(%ebp),%eax
  800401:	83 c0 04             	add    $0x4,%eax
  800404:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800407:	a1 38 51 83 00       	mov    0x835138,%eax
  80040c:	85 c0                	test   %eax,%eax
  80040e:	74 16                	je     800426 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800410:	a1 38 51 83 00       	mov    0x835138,%eax
  800415:	83 ec 08             	sub    $0x8,%esp
  800418:	50                   	push   %eax
  800419:	68 34 43 80 00       	push   $0x804334
  80041e:	e8 a3 02 00 00       	call   8006c6 <cprintf>
  800423:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800426:	a1 04 50 80 00       	mov    0x805004,%eax
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	ff 75 0c             	pushl  0xc(%ebp)
  800431:	ff 75 08             	pushl  0x8(%ebp)
  800434:	50                   	push   %eax
  800435:	68 3c 43 80 00       	push   $0x80433c
  80043a:	6a 74                	push   $0x74
  80043c:	e8 b2 02 00 00       	call   8006f3 <cprintf_colored>
  800441:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800444:	8b 45 10             	mov    0x10(%ebp),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 f4             	pushl  -0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	e8 04 02 00 00       	call   800657 <vcprintf>
  800453:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	6a 00                	push   $0x0
  80045b:	68 64 43 80 00       	push   $0x804364
  800460:	e8 f2 01 00 00       	call   800657 <vcprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800468:	e8 7d ff ff ff       	call   8003ea <exit>

	// should not return here
	while (1) ;
  80046d:	eb fe                	jmp    80046d <_panic+0x75>

0080046f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800475:	a1 20 50 80 00       	mov    0x805020,%eax
  80047a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800480:	8b 45 0c             	mov    0xc(%ebp),%eax
  800483:	39 c2                	cmp    %eax,%edx
  800485:	74 14                	je     80049b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800487:	83 ec 04             	sub    $0x4,%esp
  80048a:	68 68 43 80 00       	push   $0x804368
  80048f:	6a 26                	push   $0x26
  800491:	68 b4 43 80 00       	push   $0x8043b4
  800496:	e8 5d ff ff ff       	call   8003f8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80049b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a9:	e9 c5 00 00 00       	jmp    800573 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bb:	01 d0                	add    %edx,%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	75 08                	jne    8004cb <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004c3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004c6:	e9 a5 00 00 00       	jmp    800570 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d9:	eb 69                	jmp    800544 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004db:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e0:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e9:	89 d0                	mov    %edx,%eax
  8004eb:	01 c0                	add    %eax,%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	c1 e0 03             	shl    $0x3,%eax
  8004f2:	01 c8                	add    %ecx,%eax
  8004f4:	8a 40 04             	mov    0x4(%eax),%al
  8004f7:	84 c0                	test   %al,%al
  8004f9:	75 46                	jne    800541 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004fb:	a1 20 50 80 00       	mov    0x805020,%eax
  800500:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800506:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800509:	89 d0                	mov    %edx,%eax
  80050b:	01 c0                	add    %eax,%eax
  80050d:	01 d0                	add    %edx,%eax
  80050f:	c1 e0 03             	shl    $0x3,%eax
  800512:	01 c8                	add    %ecx,%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800519:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80051c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800521:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800526:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	01 c8                	add    %ecx,%eax
  800532:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800534:	39 c2                	cmp    %eax,%edx
  800536:	75 09                	jne    800541 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800538:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80053f:	eb 15                	jmp    800556 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800541:	ff 45 e8             	incl   -0x18(%ebp)
  800544:	a1 20 50 80 00       	mov    0x805020,%eax
  800549:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80054f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800552:	39 c2                	cmp    %eax,%edx
  800554:	77 85                	ja     8004db <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800556:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80055a:	75 14                	jne    800570 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80055c:	83 ec 04             	sub    $0x4,%esp
  80055f:	68 c0 43 80 00       	push   $0x8043c0
  800564:	6a 3a                	push   $0x3a
  800566:	68 b4 43 80 00       	push   $0x8043b4
  80056b:	e8 88 fe ff ff       	call   8003f8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800570:	ff 45 f0             	incl   -0x10(%ebp)
  800573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800576:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800579:	0f 8c 2f ff ff ff    	jl     8004ae <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80057f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800586:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80058d:	eb 26                	jmp    8005b5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80058f:	a1 20 50 80 00       	mov    0x805020,%eax
  800594:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80059a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80059d:	89 d0                	mov    %edx,%eax
  80059f:	01 c0                	add    %eax,%eax
  8005a1:	01 d0                	add    %edx,%eax
  8005a3:	c1 e0 03             	shl    $0x3,%eax
  8005a6:	01 c8                	add    %ecx,%eax
  8005a8:	8a 40 04             	mov    0x4(%eax),%al
  8005ab:	3c 01                	cmp    $0x1,%al
  8005ad:	75 03                	jne    8005b2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005af:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b2:	ff 45 e0             	incl   -0x20(%ebp)
  8005b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ba:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c3:	39 c2                	cmp    %eax,%edx
  8005c5:	77 c8                	ja     80058f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ca:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005cd:	74 14                	je     8005e3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 14 44 80 00       	push   $0x804414
  8005d7:	6a 44                	push   $0x44
  8005d9:	68 b4 43 80 00       	push   $0x8043b4
  8005de:	e8 15 fe ff ff       	call   8003f8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005e3:	90                   	nop
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	53                   	push   %ebx
  8005ea:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	8d 48 01             	lea    0x1(%eax),%ecx
  8005f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f8:	89 0a                	mov    %ecx,(%edx)
  8005fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8005fd:	88 d1                	mov    %dl,%cl
  8005ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800602:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800610:	75 30                	jne    800642 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800612:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800618:	a0 64 d0 81 00       	mov    0x81d064,%al
  80061d:	0f b6 c0             	movzbl %al,%eax
  800620:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800623:	8b 09                	mov    (%ecx),%ecx
  800625:	89 cb                	mov    %ecx,%ebx
  800627:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80062a:	83 c1 08             	add    $0x8,%ecx
  80062d:	52                   	push   %edx
  80062e:	50                   	push   %eax
  80062f:	53                   	push   %ebx
  800630:	51                   	push   %ecx
  800631:	e8 06 28 00 00       	call   802e3c <sys_cputs>
  800636:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800642:	8b 45 0c             	mov    0xc(%ebp),%eax
  800645:	8b 40 04             	mov    0x4(%eax),%eax
  800648:	8d 50 01             	lea    0x1(%eax),%edx
  80064b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800651:	90                   	nop
  800652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800655:	c9                   	leave  
  800656:	c3                   	ret    

00800657 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800660:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800667:	00 00 00 
	b.cnt = 0;
  80066a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800671:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800674:	ff 75 0c             	pushl  0xc(%ebp)
  800677:	ff 75 08             	pushl  0x8(%ebp)
  80067a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800680:	50                   	push   %eax
  800681:	68 e6 05 80 00       	push   $0x8005e6
  800686:	e8 5a 02 00 00       	call   8008e5 <vprintfmt>
  80068b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80068e:	8b 15 3c 51 83 00    	mov    0x83513c,%edx
  800694:	a0 64 d0 81 00       	mov    0x81d064,%al
  800699:	0f b6 c0             	movzbl %al,%eax
  80069c:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006a2:	52                   	push   %edx
  8006a3:	50                   	push   %eax
  8006a4:	51                   	push   %ecx
  8006a5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ab:	83 c0 08             	add    $0x8,%eax
  8006ae:	50                   	push   %eax
  8006af:	e8 88 27 00 00       	call   802e3c <sys_cputs>
  8006b4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006b7:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  8006be:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006c4:	c9                   	leave  
  8006c5:	c3                   	ret    

008006c6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006c6:	55                   	push   %ebp
  8006c7:	89 e5                	mov    %esp,%ebp
  8006c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006cc:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  8006d3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e2:	50                   	push   %eax
  8006e3:	e8 6f ff ff ff       	call   800657 <vcprintf>
  8006e8:	83 c4 10             	add    $0x10,%esp
  8006eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006f1:	c9                   	leave  
  8006f2:	c3                   	ret    

008006f3 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006f3:	55                   	push   %ebp
  8006f4:	89 e5                	mov    %esp,%ebp
  8006f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006f9:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	c1 e0 08             	shl    $0x8,%eax
  800706:	a3 3c 51 83 00       	mov    %eax,0x83513c
	va_start(ap, fmt);
  80070b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80070e:	83 c0 04             	add    $0x4,%eax
  800711:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800714:	8b 45 0c             	mov    0xc(%ebp),%eax
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 f4             	pushl  -0xc(%ebp)
  80071d:	50                   	push   %eax
  80071e:	e8 34 ff ff ff       	call   800657 <vcprintf>
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800729:	c7 05 3c 51 83 00 00 	movl   $0x700,0x83513c
  800730:	07 00 00 

	return cnt;
  800733:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800736:	c9                   	leave  
  800737:	c3                   	ret    

00800738 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80073e:	e8 3d 27 00 00       	call   802e80 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800743:	8d 45 0c             	lea    0xc(%ebp),%eax
  800746:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	ff 75 f4             	pushl  -0xc(%ebp)
  800752:	50                   	push   %eax
  800753:	e8 ff fe ff ff       	call   800657 <vcprintf>
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80075e:	e8 37 27 00 00       	call   802e9a <sys_unlock_cons>
	return cnt;
  800763:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800766:	c9                   	leave  
  800767:	c3                   	ret    

00800768 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	53                   	push   %ebx
  80076c:	83 ec 14             	sub    $0x14,%esp
  80076f:	8b 45 10             	mov    0x10(%ebp),%eax
  800772:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80077b:	8b 45 18             	mov    0x18(%ebp),%eax
  80077e:	ba 00 00 00 00       	mov    $0x0,%edx
  800783:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800786:	77 55                	ja     8007dd <printnum+0x75>
  800788:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80078b:	72 05                	jb     800792 <printnum+0x2a>
  80078d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800790:	77 4b                	ja     8007dd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800792:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800795:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800798:	8b 45 18             	mov    0x18(%ebp),%eax
  80079b:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a0:	52                   	push   %edx
  8007a1:	50                   	push   %eax
  8007a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8007a8:	e8 a3 36 00 00       	call   803e50 <__udivdi3>
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	83 ec 04             	sub    $0x4,%esp
  8007b3:	ff 75 20             	pushl  0x20(%ebp)
  8007b6:	53                   	push   %ebx
  8007b7:	ff 75 18             	pushl  0x18(%ebp)
  8007ba:	52                   	push   %edx
  8007bb:	50                   	push   %eax
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	ff 75 08             	pushl  0x8(%ebp)
  8007c2:	e8 a1 ff ff ff       	call   800768 <printnum>
  8007c7:	83 c4 20             	add    $0x20,%esp
  8007ca:	eb 1a                	jmp    8007e6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	ff 75 0c             	pushl  0xc(%ebp)
  8007d2:	ff 75 20             	pushl  0x20(%ebp)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007dd:	ff 4d 1c             	decl   0x1c(%ebp)
  8007e0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007e4:	7f e6                	jg     8007cc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007e6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f4:	53                   	push   %ebx
  8007f5:	51                   	push   %ecx
  8007f6:	52                   	push   %edx
  8007f7:	50                   	push   %eax
  8007f8:	e8 63 37 00 00       	call   803f60 <__umoddi3>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	05 74 46 80 00       	add    $0x804674,%eax
  800805:	8a 00                	mov    (%eax),%al
  800807:	0f be c0             	movsbl %al,%eax
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	50                   	push   %eax
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
}
  800819:	90                   	nop
  80081a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80081d:	c9                   	leave  
  80081e:	c3                   	ret    

0080081f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80081f:	55                   	push   %ebp
  800820:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800822:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800826:	7e 1c                	jle    800844 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	8d 50 08             	lea    0x8(%eax),%edx
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	89 10                	mov    %edx,(%eax)
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	8b 00                	mov    (%eax),%eax
  80083a:	83 e8 08             	sub    $0x8,%eax
  80083d:	8b 50 04             	mov    0x4(%eax),%edx
  800840:	8b 00                	mov    (%eax),%eax
  800842:	eb 40                	jmp    800884 <getuint+0x65>
	else if (lflag)
  800844:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800848:	74 1e                	je     800868 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	8d 50 04             	lea    0x4(%eax),%edx
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	89 10                	mov    %edx,(%eax)
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	83 e8 04             	sub    $0x4,%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	ba 00 00 00 00       	mov    $0x0,%edx
  800866:	eb 1c                	jmp    800884 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	8d 50 04             	lea    0x4(%eax),%edx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 10                	mov    %edx,(%eax)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800889:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088d:	7e 1c                	jle    8008ab <getint+0x25>
		return va_arg(*ap, long long);
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	8d 50 08             	lea    0x8(%eax),%edx
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	89 10                	mov    %edx,(%eax)
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	83 e8 08             	sub    $0x8,%eax
  8008a4:	8b 50 04             	mov    0x4(%eax),%edx
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	eb 38                	jmp    8008e3 <getint+0x5d>
	else if (lflag)
  8008ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008af:	74 1a                	je     8008cb <getint+0x45>
		return va_arg(*ap, long);
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	8d 50 04             	lea    0x4(%eax),%edx
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	89 10                	mov    %edx,(%eax)
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	83 e8 04             	sub    $0x4,%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	99                   	cltd   
  8008c9:	eb 18                	jmp    8008e3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	8d 50 04             	lea    0x4(%eax),%edx
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	89 10                	mov    %edx,(%eax)
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	99                   	cltd   
}
  8008e3:	5d                   	pop    %ebp
  8008e4:	c3                   	ret    

008008e5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	56                   	push   %esi
  8008e9:	53                   	push   %ebx
  8008ea:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ed:	eb 17                	jmp    800906 <vprintfmt+0x21>
			if (ch == '\0')
  8008ef:	85 db                	test   %ebx,%ebx
  8008f1:	0f 84 c1 03 00 00    	je     800cb8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	53                   	push   %ebx
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	ff d0                	call   *%eax
  800903:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	8d 50 01             	lea    0x1(%eax),%edx
  80090c:	89 55 10             	mov    %edx,0x10(%ebp)
  80090f:	8a 00                	mov    (%eax),%al
  800911:	0f b6 d8             	movzbl %al,%ebx
  800914:	83 fb 25             	cmp    $0x25,%ebx
  800917:	75 d6                	jne    8008ef <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800919:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80091d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800924:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80092b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800932:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800939:	8b 45 10             	mov    0x10(%ebp),%eax
  80093c:	8d 50 01             	lea    0x1(%eax),%edx
  80093f:	89 55 10             	mov    %edx,0x10(%ebp)
  800942:	8a 00                	mov    (%eax),%al
  800944:	0f b6 d8             	movzbl %al,%ebx
  800947:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80094a:	83 f8 5b             	cmp    $0x5b,%eax
  80094d:	0f 87 3d 03 00 00    	ja     800c90 <vprintfmt+0x3ab>
  800953:	8b 04 85 98 46 80 00 	mov    0x804698(,%eax,4),%eax
  80095a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80095c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800960:	eb d7                	jmp    800939 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800962:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800966:	eb d1                	jmp    800939 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800968:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80096f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800972:	89 d0                	mov    %edx,%eax
  800974:	c1 e0 02             	shl    $0x2,%eax
  800977:	01 d0                	add    %edx,%eax
  800979:	01 c0                	add    %eax,%eax
  80097b:	01 d8                	add    %ebx,%eax
  80097d:	83 e8 30             	sub    $0x30,%eax
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800983:	8b 45 10             	mov    0x10(%ebp),%eax
  800986:	8a 00                	mov    (%eax),%al
  800988:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80098b:	83 fb 2f             	cmp    $0x2f,%ebx
  80098e:	7e 3e                	jle    8009ce <vprintfmt+0xe9>
  800990:	83 fb 39             	cmp    $0x39,%ebx
  800993:	7f 39                	jg     8009ce <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800995:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800998:	eb d5                	jmp    80096f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	83 c0 04             	add    $0x4,%eax
  8009a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a6:	83 e8 04             	sub    $0x4,%eax
  8009a9:	8b 00                	mov    (%eax),%eax
  8009ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009ae:	eb 1f                	jmp    8009cf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b4:	79 83                	jns    800939 <vprintfmt+0x54>
				width = 0;
  8009b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009bd:	e9 77 ff ff ff       	jmp    800939 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009c2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009c9:	e9 6b ff ff ff       	jmp    800939 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009ce:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d3:	0f 89 60 ff ff ff    	jns    800939 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009df:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009e6:	e9 4e ff ff ff       	jmp    800939 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009eb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009ee:	e9 46 ff ff ff       	jmp    800939 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	83 c0 04             	add    $0x4,%eax
  8009f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ff:	83 e8 04             	sub    $0x4,%eax
  800a02:	8b 00                	mov    (%eax),%eax
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	50                   	push   %eax
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	ff d0                	call   *%eax
  800a10:	83 c4 10             	add    $0x10,%esp
			break;
  800a13:	e9 9b 02 00 00       	jmp    800cb3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	83 c0 04             	add    $0x4,%eax
  800a1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	83 e8 04             	sub    $0x4,%eax
  800a27:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a29:	85 db                	test   %ebx,%ebx
  800a2b:	79 02                	jns    800a2f <vprintfmt+0x14a>
				err = -err;
  800a2d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a2f:	83 fb 64             	cmp    $0x64,%ebx
  800a32:	7f 0b                	jg     800a3f <vprintfmt+0x15a>
  800a34:	8b 34 9d e0 44 80 00 	mov    0x8044e0(,%ebx,4),%esi
  800a3b:	85 f6                	test   %esi,%esi
  800a3d:	75 19                	jne    800a58 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a3f:	53                   	push   %ebx
  800a40:	68 85 46 80 00       	push   $0x804685
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	ff 75 08             	pushl  0x8(%ebp)
  800a4b:	e8 70 02 00 00       	call   800cc0 <printfmt>
  800a50:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a53:	e9 5b 02 00 00       	jmp    800cb3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a58:	56                   	push   %esi
  800a59:	68 8e 46 80 00       	push   $0x80468e
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	ff 75 08             	pushl  0x8(%ebp)
  800a64:	e8 57 02 00 00       	call   800cc0 <printfmt>
  800a69:	83 c4 10             	add    $0x10,%esp
			break;
  800a6c:	e9 42 02 00 00       	jmp    800cb3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 c0 04             	add    $0x4,%eax
  800a77:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	83 e8 04             	sub    $0x4,%eax
  800a80:	8b 30                	mov    (%eax),%esi
  800a82:	85 f6                	test   %esi,%esi
  800a84:	75 05                	jne    800a8b <vprintfmt+0x1a6>
				p = "(null)";
  800a86:	be 91 46 80 00       	mov    $0x804691,%esi
			if (width > 0 && padc != '-')
  800a8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8f:	7e 6d                	jle    800afe <vprintfmt+0x219>
  800a91:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a95:	74 67                	je     800afe <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	50                   	push   %eax
  800a9e:	56                   	push   %esi
  800a9f:	e8 1e 03 00 00       	call   800dc2 <strnlen>
  800aa4:	83 c4 10             	add    $0x10,%esp
  800aa7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aaa:	eb 16                	jmp    800ac2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aac:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ab0:	83 ec 08             	sub    $0x8,%esp
  800ab3:	ff 75 0c             	pushl  0xc(%ebp)
  800ab6:	50                   	push   %eax
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	ff d0                	call   *%eax
  800abc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800abf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac6:	7f e4                	jg     800aac <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ac8:	eb 34                	jmp    800afe <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800aca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ace:	74 1c                	je     800aec <vprintfmt+0x207>
  800ad0:	83 fb 1f             	cmp    $0x1f,%ebx
  800ad3:	7e 05                	jle    800ada <vprintfmt+0x1f5>
  800ad5:	83 fb 7e             	cmp    $0x7e,%ebx
  800ad8:	7e 12                	jle    800aec <vprintfmt+0x207>
					putch('?', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	6a 3f                	push   $0x3f
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	eb 0f                	jmp    800afb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	53                   	push   %ebx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	ff d0                	call   *%eax
  800af8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afb:	ff 4d e4             	decl   -0x1c(%ebp)
  800afe:	89 f0                	mov    %esi,%eax
  800b00:	8d 70 01             	lea    0x1(%eax),%esi
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	0f be d8             	movsbl %al,%ebx
  800b08:	85 db                	test   %ebx,%ebx
  800b0a:	74 24                	je     800b30 <vprintfmt+0x24b>
  800b0c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b10:	78 b8                	js     800aca <vprintfmt+0x1e5>
  800b12:	ff 4d e0             	decl   -0x20(%ebp)
  800b15:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b19:	79 af                	jns    800aca <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b1b:	eb 13                	jmp    800b30 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	6a 20                	push   $0x20
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b34:	7f e7                	jg     800b1d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b36:	e9 78 01 00 00       	jmp    800cb3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b41:	8d 45 14             	lea    0x14(%ebp),%eax
  800b44:	50                   	push   %eax
  800b45:	e8 3c fd ff ff       	call   800886 <getint>
  800b4a:	83 c4 10             	add    $0x10,%esp
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b59:	85 d2                	test   %edx,%edx
  800b5b:	79 23                	jns    800b80 <vprintfmt+0x29b>
				putch('-', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 2d                	push   $0x2d
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b73:	f7 d8                	neg    %eax
  800b75:	83 d2 00             	adc    $0x0,%edx
  800b78:	f7 da                	neg    %edx
  800b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b87:	e9 bc 00 00 00       	jmp    800c48 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b92:	8d 45 14             	lea    0x14(%ebp),%eax
  800b95:	50                   	push   %eax
  800b96:	e8 84 fc ff ff       	call   80081f <getuint>
  800b9b:	83 c4 10             	add    $0x10,%esp
  800b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ba4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bab:	e9 98 00 00 00       	jmp    800c48 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bb0:	83 ec 08             	sub    $0x8,%esp
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	6a 58                	push   $0x58
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	ff d0                	call   *%eax
  800bbd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	ff 75 0c             	pushl  0xc(%ebp)
  800bc6:	6a 58                	push   $0x58
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	ff d0                	call   *%eax
  800bcd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bd0:	83 ec 08             	sub    $0x8,%esp
  800bd3:	ff 75 0c             	pushl  0xc(%ebp)
  800bd6:	6a 58                	push   $0x58
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	ff d0                	call   *%eax
  800bdd:	83 c4 10             	add    $0x10,%esp
			break;
  800be0:	e9 ce 00 00 00       	jmp    800cb3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	6a 30                	push   $0x30
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	ff d0                	call   *%eax
  800bf2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	6a 78                	push   $0x78
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	ff d0                	call   *%eax
  800c02:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c05:	8b 45 14             	mov    0x14(%ebp),%eax
  800c08:	83 c0 04             	add    $0x4,%eax
  800c0b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c11:	83 e8 04             	sub    $0x4,%eax
  800c14:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c20:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c27:	eb 1f                	jmp    800c48 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c32:	50                   	push   %eax
  800c33:	e8 e7 fb ff ff       	call   80081f <getuint>
  800c38:	83 c4 10             	add    $0x10,%esp
  800c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c41:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c48:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4f:	83 ec 04             	sub    $0x4,%esp
  800c52:	52                   	push   %edx
  800c53:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c56:	50                   	push   %eax
  800c57:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c5d:	ff 75 0c             	pushl  0xc(%ebp)
  800c60:	ff 75 08             	pushl  0x8(%ebp)
  800c63:	e8 00 fb ff ff       	call   800768 <printnum>
  800c68:	83 c4 20             	add    $0x20,%esp
			break;
  800c6b:	eb 46                	jmp    800cb3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c6d:	83 ec 08             	sub    $0x8,%esp
  800c70:	ff 75 0c             	pushl  0xc(%ebp)
  800c73:	53                   	push   %ebx
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	ff d0                	call   *%eax
  800c79:	83 c4 10             	add    $0x10,%esp
			break;
  800c7c:	eb 35                	jmp    800cb3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c7e:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800c85:	eb 2c                	jmp    800cb3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c87:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800c8e:	eb 23                	jmp    800cb3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 25                	push   $0x25
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ca0:	ff 4d 10             	decl   0x10(%ebp)
  800ca3:	eb 03                	jmp    800ca8 <vprintfmt+0x3c3>
  800ca5:	ff 4d 10             	decl   0x10(%ebp)
  800ca8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cab:	48                   	dec    %eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	3c 25                	cmp    $0x25,%al
  800cb0:	75 f3                	jne    800ca5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cb2:	90                   	nop
		}
	}
  800cb3:	e9 35 fc ff ff       	jmp    8008ed <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cb8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cc6:	8d 45 10             	lea    0x10(%ebp),%eax
  800cc9:	83 c0 04             	add    $0x4,%eax
  800ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ccf:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 04 fc ff ff       	call   8008e5 <vprintfmt>
  800ce1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ce4:	90                   	nop
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	8b 40 08             	mov    0x8(%eax),%eax
  800cf0:	8d 50 01             	lea    0x1(%eax),%edx
  800cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfc:	8b 10                	mov    (%eax),%edx
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8b 40 04             	mov    0x4(%eax),%eax
  800d04:	39 c2                	cmp    %eax,%edx
  800d06:	73 12                	jae    800d1a <sprintputch+0x33>
		*b->buf++ = ch;
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0b:	8b 00                	mov    (%eax),%eax
  800d0d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d13:	89 0a                	mov    %ecx,(%edx)
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	88 10                	mov    %dl,(%eax)
}
  800d1a:	90                   	nop
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	01 d0                	add    %edx,%eax
  800d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d42:	74 06                	je     800d4a <vsnprintf+0x2d>
  800d44:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d48:	7f 07                	jg     800d51 <vsnprintf+0x34>
		return -E_INVAL;
  800d4a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d4f:	eb 20                	jmp    800d71 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d51:	ff 75 14             	pushl  0x14(%ebp)
  800d54:	ff 75 10             	pushl  0x10(%ebp)
  800d57:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d5a:	50                   	push   %eax
  800d5b:	68 e7 0c 80 00       	push   $0x800ce7
  800d60:	e8 80 fb ff ff       	call   8008e5 <vprintfmt>
  800d65:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d6b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d79:	8d 45 10             	lea    0x10(%ebp),%eax
  800d7c:	83 c0 04             	add    $0x4,%eax
  800d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d82:	8b 45 10             	mov    0x10(%ebp),%eax
  800d85:	ff 75 f4             	pushl  -0xc(%ebp)
  800d88:	50                   	push   %eax
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	ff 75 08             	pushl  0x8(%ebp)
  800d8f:	e8 89 ff ff ff       	call   800d1d <vsnprintf>
  800d94:	83 c4 10             	add    $0x10,%esp
  800d97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800da5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dac:	eb 06                	jmp    800db4 <strlen+0x15>
		n++;
  800dae:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	75 f1                	jne    800dae <strlen+0xf>
		n++;
	return n;
  800dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc0:	c9                   	leave  
  800dc1:	c3                   	ret    

00800dc2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcf:	eb 09                	jmp    800dda <strnlen+0x18>
		n++;
  800dd1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd4:	ff 45 08             	incl   0x8(%ebp)
  800dd7:	ff 4d 0c             	decl   0xc(%ebp)
  800dda:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dde:	74 09                	je     800de9 <strnlen+0x27>
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	84 c0                	test   %al,%al
  800de7:	75 e8                	jne    800dd1 <strnlen+0xf>
		n++;
	return n;
  800de9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dec:	c9                   	leave  
  800ded:	c3                   	ret    

00800dee <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dfa:	90                   	nop
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8d 50 01             	lea    0x1(%eax),%edx
  800e01:	89 55 08             	mov    %edx,0x8(%ebp)
  800e04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e07:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0d:	8a 12                	mov    (%edx),%dl
  800e0f:	88 10                	mov    %dl,(%eax)
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 e4                	jne    800dfb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1a:	c9                   	leave  
  800e1b:	c3                   	ret    

00800e1c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2f:	eb 1f                	jmp    800e50 <strncpy+0x34>
		*dst++ = *src;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8d 50 01             	lea    0x1(%eax),%edx
  800e37:	89 55 08             	mov    %edx,0x8(%ebp)
  800e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3d:	8a 12                	mov    (%edx),%dl
  800e3f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	74 03                	je     800e4d <strncpy+0x31>
			src++;
  800e4a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e4d:	ff 45 fc             	incl   -0x4(%ebp)
  800e50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e53:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e56:	72 d9                	jb     800e31 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e58:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6d:	74 30                	je     800e9f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e6f:	eb 16                	jmp    800e87 <strlcpy+0x2a>
			*dst++ = *src++;
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8d 50 01             	lea    0x1(%eax),%edx
  800e77:	89 55 08             	mov    %edx,0x8(%ebp)
  800e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e80:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e83:	8a 12                	mov    (%edx),%dl
  800e85:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e87:	ff 4d 10             	decl   0x10(%ebp)
  800e8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8e:	74 09                	je     800e99 <strlcpy+0x3c>
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	84 c0                	test   %al,%al
  800e97:	75 d8                	jne    800e71 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	29 c2                	sub    %eax,%edx
  800ea7:	89 d0                	mov    %edx,%eax
}
  800ea9:	c9                   	leave  
  800eaa:	c3                   	ret    

00800eab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eae:	eb 06                	jmp    800eb6 <strcmp+0xb>
		p++, q++;
  800eb0:	ff 45 08             	incl   0x8(%ebp)
  800eb3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	84 c0                	test   %al,%al
  800ebd:	74 0e                	je     800ecd <strcmp+0x22>
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 10                	mov    (%eax),%dl
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	38 c2                	cmp    %al,%dl
  800ecb:	74 e3                	je     800eb0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8a 00                	mov    (%eax),%al
  800ed2:	0f b6 d0             	movzbl %al,%edx
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	0f b6 c0             	movzbl %al,%eax
  800edd:	29 c2                	sub    %eax,%edx
  800edf:	89 d0                	mov    %edx,%eax
}
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ee6:	eb 09                	jmp    800ef1 <strncmp+0xe>
		n--, p++, q++;
  800ee8:	ff 4d 10             	decl   0x10(%ebp)
  800eeb:	ff 45 08             	incl   0x8(%ebp)
  800eee:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ef1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef5:	74 17                	je     800f0e <strncmp+0x2b>
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	84 c0                	test   %al,%al
  800efe:	74 0e                	je     800f0e <strncmp+0x2b>
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 10                	mov    (%eax),%dl
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	38 c2                	cmp    %al,%dl
  800f0c:	74 da                	je     800ee8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f12:	75 07                	jne    800f1b <strncmp+0x38>
		return 0;
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
  800f19:	eb 14                	jmp    800f2f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	0f b6 d0             	movzbl %al,%edx
  800f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	0f b6 c0             	movzbl %al,%eax
  800f2b:	29 c2                	sub    %eax,%edx
  800f2d:	89 d0                	mov    %edx,%eax
}
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    

00800f31 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	83 ec 04             	sub    $0x4,%esp
  800f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f3d:	eb 12                	jmp    800f51 <strchr+0x20>
		if (*s == c)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f47:	75 05                	jne    800f4e <strchr+0x1d>
			return (char *) s;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	eb 11                	jmp    800f5f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f4e:	ff 45 08             	incl   0x8(%ebp)
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	84 c0                	test   %al,%al
  800f58:	75 e5                	jne    800f3f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f5f:	c9                   	leave  
  800f60:	c3                   	ret    

00800f61 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6d:	eb 0d                	jmp    800f7c <strfind+0x1b>
		if (*s == c)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f77:	74 0e                	je     800f87 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	84 c0                	test   %al,%al
  800f83:	75 ea                	jne    800f6f <strfind+0xe>
  800f85:	eb 01                	jmp    800f88 <strfind+0x27>
		if (*s == c)
			break;
  800f87:	90                   	nop
	return (char *) s;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8b:	c9                   	leave  
  800f8c:	c3                   	ret    

00800f8d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f99:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f9d:	76 63                	jbe    801002 <memset+0x75>
		uint64 data_block = c;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	99                   	cltd   
  800fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800faf:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fb3:	c1 e0 08             	shl    $0x8,%eax
  800fb6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fb9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc2:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fc6:	c1 e0 10             	shl    $0x10,%eax
  800fc9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fcc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd5:	89 c2                	mov    %eax,%edx
  800fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdc:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fdf:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800fe2:	eb 18                	jmp    800ffc <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800fe4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fe7:	8d 41 08             	lea    0x8(%ecx),%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff3:	89 01                	mov    %eax,(%ecx)
  800ff5:	89 51 04             	mov    %edx,0x4(%ecx)
  800ff8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ffc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801000:	77 e2                	ja     800fe4 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801002:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801006:	74 23                	je     80102b <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801008:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80100e:	eb 0e                	jmp    80101e <memset+0x91>
			*p8++ = (uint8)c;
  801010:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801013:	8d 50 01             	lea    0x1(%eax),%edx
  801016:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801019:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101c:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80101e:	8b 45 10             	mov    0x10(%ebp),%eax
  801021:	8d 50 ff             	lea    -0x1(%eax),%edx
  801024:	89 55 10             	mov    %edx,0x10(%ebp)
  801027:	85 c0                	test   %eax,%eax
  801029:	75 e5                	jne    801010 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801042:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801046:	76 24                	jbe    80106c <memcpy+0x3c>
		while(n >= 8){
  801048:	eb 1c                	jmp    801066 <memcpy+0x36>
			*d64 = *s64;
  80104a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104d:	8b 50 04             	mov    0x4(%eax),%edx
  801050:	8b 00                	mov    (%eax),%eax
  801052:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801055:	89 01                	mov    %eax,(%ecx)
  801057:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80105a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80105e:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801062:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801066:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80106a:	77 de                	ja     80104a <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80106c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801070:	74 31                	je     8010a3 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801078:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80107e:	eb 16                	jmp    801096 <memcpy+0x66>
			*d8++ = *s8++;
  801080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801083:	8d 50 01             	lea    0x1(%eax),%edx
  801086:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801092:	8a 12                	mov    (%edx),%dl
  801094:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109c:	89 55 10             	mov    %edx,0x10(%ebp)
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	75 dd                	jne    801080 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a6:	c9                   	leave  
  8010a7:	c3                   	ret    

008010a8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010c0:	73 50                	jae    801112 <memmove+0x6a>
  8010c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c8:	01 d0                	add    %edx,%eax
  8010ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010cd:	76 43                	jbe    801112 <memmove+0x6a>
		s += n;
  8010cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010db:	eb 10                	jmp    8010ed <memmove+0x45>
			*--d = *--s;
  8010dd:	ff 4d f8             	decl   -0x8(%ebp)
  8010e0:	ff 4d fc             	decl   -0x4(%ebp)
  8010e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e6:	8a 10                	mov    (%eax),%dl
  8010e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010eb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	75 e3                	jne    8010dd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010fa:	eb 23                	jmp    80111f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ff:	8d 50 01             	lea    0x1(%eax),%edx
  801102:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801105:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801108:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80110e:	8a 12                	mov    (%edx),%dl
  801110:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801112:	8b 45 10             	mov    0x10(%ebp),%eax
  801115:	8d 50 ff             	lea    -0x1(%eax),%edx
  801118:	89 55 10             	mov    %edx,0x10(%ebp)
  80111b:	85 c0                	test   %eax,%eax
  80111d:	75 dd                	jne    8010fc <memmove+0x54>
			*d++ = *s++;

	return dst;
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801136:	eb 2a                	jmp    801162 <memcmp+0x3e>
		if (*s1 != *s2)
  801138:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113b:	8a 10                	mov    (%eax),%dl
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	38 c2                	cmp    %al,%dl
  801144:	74 16                	je     80115c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801146:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801149:	8a 00                	mov    (%eax),%al
  80114b:	0f b6 d0             	movzbl %al,%edx
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	0f b6 c0             	movzbl %al,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	eb 18                	jmp    801174 <memcmp+0x50>
		s1++, s2++;
  80115c:	ff 45 fc             	incl   -0x4(%ebp)
  80115f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801162:	8b 45 10             	mov    0x10(%ebp),%eax
  801165:	8d 50 ff             	lea    -0x1(%eax),%edx
  801168:	89 55 10             	mov    %edx,0x10(%ebp)
  80116b:	85 c0                	test   %eax,%eax
  80116d:	75 c9                	jne    801138 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80116f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80117c:	8b 55 08             	mov    0x8(%ebp),%edx
  80117f:	8b 45 10             	mov    0x10(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801187:	eb 15                	jmp    80119e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f b6 d0             	movzbl %al,%edx
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	0f b6 c0             	movzbl %al,%eax
  801197:	39 c2                	cmp    %eax,%edx
  801199:	74 0d                	je     8011a8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80119b:	ff 45 08             	incl   0x8(%ebp)
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011a4:	72 e3                	jb     801189 <memfind+0x13>
  8011a6:	eb 01                	jmp    8011a9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011a8:	90                   	nop
	return (void *) s;
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c2:	eb 03                	jmp    8011c7 <strtol+0x19>
		s++;
  8011c4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	3c 20                	cmp    $0x20,%al
  8011ce:	74 f4                	je     8011c4 <strtol+0x16>
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	3c 09                	cmp    $0x9,%al
  8011d7:	74 eb                	je     8011c4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	3c 2b                	cmp    $0x2b,%al
  8011e0:	75 05                	jne    8011e7 <strtol+0x39>
		s++;
  8011e2:	ff 45 08             	incl   0x8(%ebp)
  8011e5:	eb 13                	jmp    8011fa <strtol+0x4c>
	else if (*s == '-')
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3c 2d                	cmp    $0x2d,%al
  8011ee:	75 0a                	jne    8011fa <strtol+0x4c>
		s++, neg = 1;
  8011f0:	ff 45 08             	incl   0x8(%ebp)
  8011f3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011fe:	74 06                	je     801206 <strtol+0x58>
  801200:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801204:	75 20                	jne    801226 <strtol+0x78>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 30                	cmp    $0x30,%al
  80120d:	75 17                	jne    801226 <strtol+0x78>
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	40                   	inc    %eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	3c 78                	cmp    $0x78,%al
  801217:	75 0d                	jne    801226 <strtol+0x78>
		s += 2, base = 16;
  801219:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80121d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801224:	eb 28                	jmp    80124e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801226:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80122a:	75 15                	jne    801241 <strtol+0x93>
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	3c 30                	cmp    $0x30,%al
  801233:	75 0c                	jne    801241 <strtol+0x93>
		s++, base = 8;
  801235:	ff 45 08             	incl   0x8(%ebp)
  801238:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80123f:	eb 0d                	jmp    80124e <strtol+0xa0>
	else if (base == 0)
  801241:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801245:	75 07                	jne    80124e <strtol+0xa0>
		base = 10;
  801247:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	3c 2f                	cmp    $0x2f,%al
  801255:	7e 19                	jle    801270 <strtol+0xc2>
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	3c 39                	cmp    $0x39,%al
  80125e:	7f 10                	jg     801270 <strtol+0xc2>
			dig = *s - '0';
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8a 00                	mov    (%eax),%al
  801265:	0f be c0             	movsbl %al,%eax
  801268:	83 e8 30             	sub    $0x30,%eax
  80126b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126e:	eb 42                	jmp    8012b2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 60                	cmp    $0x60,%al
  801277:	7e 19                	jle    801292 <strtol+0xe4>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	3c 7a                	cmp    $0x7a,%al
  801280:	7f 10                	jg     801292 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	0f be c0             	movsbl %al,%eax
  80128a:	83 e8 57             	sub    $0x57,%eax
  80128d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801290:	eb 20                	jmp    8012b2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3c 40                	cmp    $0x40,%al
  801299:	7e 39                	jle    8012d4 <strtol+0x126>
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8a 00                	mov    (%eax),%al
  8012a0:	3c 5a                	cmp    $0x5a,%al
  8012a2:	7f 30                	jg     8012d4 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	0f be c0             	movsbl %al,%eax
  8012ac:	83 e8 37             	sub    $0x37,%eax
  8012af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012b8:	7d 19                	jge    8012d3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ba:	ff 45 08             	incl   0x8(%ebp)
  8012bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012c4:	89 c2                	mov    %eax,%edx
  8012c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c9:	01 d0                	add    %edx,%eax
  8012cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012ce:	e9 7b ff ff ff       	jmp    80124e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012d3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012d8:	74 08                	je     8012e2 <strtol+0x134>
		*endptr = (char *) s;
  8012da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012e6:	74 07                	je     8012ef <strtol+0x141>
  8012e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012eb:	f7 d8                	neg    %eax
  8012ed:	eb 03                	jmp    8012f2 <strtol+0x144>
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <ltostr>:

void
ltostr(long value, char *str)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801301:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80130c:	79 13                	jns    801321 <ltostr+0x2d>
	{
		neg = 1;
  80130e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801315:	8b 45 0c             	mov    0xc(%ebp),%eax
  801318:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80131b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80131e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801329:	99                   	cltd   
  80132a:	f7 f9                	idiv   %ecx
  80132c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801332:	8d 50 01             	lea    0x1(%eax),%edx
  801335:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133d:	01 d0                	add    %edx,%eax
  80133f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801342:	83 c2 30             	add    $0x30,%edx
  801345:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801347:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80134f:	f7 e9                	imul   %ecx
  801351:	c1 fa 02             	sar    $0x2,%edx
  801354:	89 c8                	mov    %ecx,%eax
  801356:	c1 f8 1f             	sar    $0x1f,%eax
  801359:	29 c2                	sub    %eax,%edx
  80135b:	89 d0                	mov    %edx,%eax
  80135d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801360:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801364:	75 bb                	jne    801321 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801366:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80136d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801370:	48                   	dec    %eax
  801371:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801374:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801378:	74 3d                	je     8013b7 <ltostr+0xc3>
		start = 1 ;
  80137a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801381:	eb 34                	jmp    8013b7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801383:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801386:	8b 45 0c             	mov    0xc(%ebp),%eax
  801389:	01 d0                	add    %edx,%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801393:	8b 45 0c             	mov    0xc(%ebp),%eax
  801396:	01 c2                	add    %eax,%edx
  801398:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80139b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139e:	01 c8                	add    %ecx,%eax
  8013a0:	8a 00                	mov    (%eax),%al
  8013a2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013aa:	01 c2                	add    %eax,%edx
  8013ac:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013af:	88 02                	mov    %al,(%edx)
		start++ ;
  8013b1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013b4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013bd:	7c c4                	jl     801383 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	01 d0                	add    %edx,%eax
  8013c7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013ca:	90                   	nop
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013d3:	ff 75 08             	pushl  0x8(%ebp)
  8013d6:	e8 c4 f9 ff ff       	call   800d9f <strlen>
  8013db:	83 c4 04             	add    $0x4,%esp
  8013de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	e8 b6 f9 ff ff       	call   800d9f <strlen>
  8013e9:	83 c4 04             	add    $0x4,%esp
  8013ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013fd:	eb 17                	jmp    801416 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 c2                	add    %eax,%edx
  801407:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	01 c8                	add    %ecx,%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801413:	ff 45 fc             	incl   -0x4(%ebp)
  801416:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801419:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80141c:	7c e1                	jl     8013ff <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801425:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80142c:	eb 1f                	jmp    80144d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80142e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801431:	8d 50 01             	lea    0x1(%eax),%edx
  801434:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801437:	89 c2                	mov    %eax,%edx
  801439:	8b 45 10             	mov    0x10(%ebp),%eax
  80143c:	01 c2                	add    %eax,%edx
  80143e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801441:	8b 45 0c             	mov    0xc(%ebp),%eax
  801444:	01 c8                	add    %ecx,%eax
  801446:	8a 00                	mov    (%eax),%al
  801448:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80144a:	ff 45 f8             	incl   -0x8(%ebp)
  80144d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801450:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801453:	7c d9                	jl     80142e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801455:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c6 00 00             	movb   $0x0,(%eax)
}
  801460:	90                   	nop
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801466:	8b 45 14             	mov    0x14(%ebp),%eax
  801469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80147b:	8b 45 10             	mov    0x10(%ebp),%eax
  80147e:	01 d0                	add    %edx,%eax
  801480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801486:	eb 0c                	jmp    801494 <strsplit+0x31>
			*string++ = 0;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8d 50 01             	lea    0x1(%eax),%edx
  80148e:	89 55 08             	mov    %edx,0x8(%ebp)
  801491:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	84 c0                	test   %al,%al
  80149b:	74 18                	je     8014b5 <strsplit+0x52>
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	0f be c0             	movsbl %al,%eax
  8014a5:	50                   	push   %eax
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	e8 83 fa ff ff       	call   800f31 <strchr>
  8014ae:	83 c4 08             	add    $0x8,%esp
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	75 d3                	jne    801488 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 5a                	je     801518 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014be:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c1:	8b 00                	mov    (%eax),%eax
  8014c3:	83 f8 0f             	cmp    $0xf,%eax
  8014c6:	75 07                	jne    8014cf <strsplit+0x6c>
		{
			return 0;
  8014c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cd:	eb 66                	jmp    801535 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d2:	8b 00                	mov    (%eax),%eax
  8014d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d7:	8b 55 14             	mov    0x14(%ebp),%edx
  8014da:	89 0a                	mov    %ecx,(%edx)
  8014dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	01 c2                	add    %eax,%edx
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ed:	eb 03                	jmp    8014f2 <strsplit+0x8f>
			string++;
  8014ef:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	84 c0                	test   %al,%al
  8014f9:	74 8b                	je     801486 <strsplit+0x23>
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	0f be c0             	movsbl %al,%eax
  801503:	50                   	push   %eax
  801504:	ff 75 0c             	pushl  0xc(%ebp)
  801507:	e8 25 fa ff ff       	call   800f31 <strchr>
  80150c:	83 c4 08             	add    $0x8,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 dc                	je     8014ef <strsplit+0x8c>
			string++;
	}
  801513:	e9 6e ff ff ff       	jmp    801486 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801518:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801519:	8b 45 14             	mov    0x14(%ebp),%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801525:	8b 45 10             	mov    0x10(%ebp),%eax
  801528:	01 d0                	add    %edx,%eax
  80152a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801530:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801543:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80154a:	eb 4a                	jmp    801596 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80154c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	01 c2                	add    %eax,%edx
  801554:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155a:	01 c8                	add    %ecx,%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801560:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801563:	8b 45 0c             	mov    0xc(%ebp),%eax
  801566:	01 d0                	add    %edx,%eax
  801568:	8a 00                	mov    (%eax),%al
  80156a:	3c 40                	cmp    $0x40,%al
  80156c:	7e 25                	jle    801593 <str2lower+0x5c>
  80156e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	01 d0                	add    %edx,%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	3c 5a                	cmp    $0x5a,%al
  80157a:	7f 17                	jg     801593 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80157c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	01 d0                	add    %edx,%eax
  801584:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801587:	8b 55 08             	mov    0x8(%ebp),%edx
  80158a:	01 ca                	add    %ecx,%edx
  80158c:	8a 12                	mov    (%edx),%dl
  80158e:	83 c2 20             	add    $0x20,%edx
  801591:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801593:	ff 45 fc             	incl   -0x4(%ebp)
  801596:	ff 75 0c             	pushl  0xc(%ebp)
  801599:	e8 01 f8 ff ff       	call   800d9f <strlen>
  80159e:	83 c4 04             	add    $0x4,%esp
  8015a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015a4:	7f a6                	jg     80154c <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8015b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	74 42                	je     8015fc <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	68 00 00 00 82       	push   $0x82000000
  8015c2:	68 00 00 00 80       	push   $0x80000000
  8015c7:	e8 b0 1e 00 00       	call   80347c <initialize_dynamic_allocator>
  8015cc:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8015cf:	e8 96 1c 00 00       	call   80326a <sys_get_uheap_strategy>
  8015d4:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8015d9:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8015de:	05 00 10 00 00       	add    $0x1000,%eax
  8015e3:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8015e8:	a1 30 51 83 00       	mov    0x835130,%eax
  8015ed:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8015f2:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8015f9:	00 00 00 
	}
}
  8015fc:	90                   	nop
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80160b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801613:	83 ec 08             	sub    $0x8,%esp
  801616:	68 06 04 00 00       	push   $0x406
  80161b:	50                   	push   %eax
  80161c:	e8 93 18 00 00       	call   802eb4 <__sys_allocate_page>
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801627:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80162b:	79 14                	jns    801641 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80162d:	83 ec 04             	sub    $0x4,%esp
  801630:	68 08 48 80 00       	push   $0x804808
  801635:	6a 1f                	push   $0x1f
  801637:	68 44 48 80 00       	push   $0x804844
  80163c:	e8 b7 ed ff ff       	call   8003f8 <_panic>
	return 0;
  801641:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801657:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80165c:	83 ec 0c             	sub    $0xc,%esp
  80165f:	50                   	push   %eax
  801660:	e8 96 18 00 00       	call   802efb <__sys_unmap_frame>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80166b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80166f:	79 14                	jns    801685 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	68 50 48 80 00       	push   $0x804850
  801679:	6a 2a                	push   $0x2a
  80167b:	68 44 48 80 00       	push   $0x804844
  801680:	e8 73 ed ff ff       	call   8003f8 <_panic>
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80168e:	e8 18 ff ff ff       	call   8015ab <uheap_init>
	if (size == 0) return NULL ;
  801693:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801697:	75 0a                	jne    8016a3 <malloc+0x1b>
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
  80169e:	e9 43 03 00 00       	jmp    8019e6 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8016a3:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8016aa:	77 13                	ja     8016bf <malloc+0x37>
    {
        return alloc_block(size);
  8016ac:	83 ec 0c             	sub    $0xc,%esp
  8016af:	ff 75 08             	pushl  0x8(%ebp)
  8016b2:	e8 78 20 00 00       	call   80372f <alloc_block>
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	e9 27 03 00 00       	jmp    8019e6 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8016bf:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8016c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016cc:	01 d0                	add    %edx,%eax
  8016ce:	48                   	dec    %eax
  8016cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016da:	f7 75 dc             	divl   -0x24(%ebp)
  8016dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016e0:	29 d0                	sub    %edx,%eax
  8016e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8016e5:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8016ea:	85 c0                	test   %eax,%eax
  8016ec:	75 0a                	jne    8016f8 <malloc+0x70>
    {
        uhp_inited = 1;
  8016ee:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  8016f5:	00 00 00 
    }

    int exactIdx = -1;
  8016f8:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8016ff:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801706:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80170d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801714:	e9 85 00 00 00       	jmp    80179e <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801719:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80171c:	89 d0                	mov    %edx,%eax
  80171e:	01 c0                	add    %eax,%eax
  801720:	01 d0                	add    %edx,%eax
  801722:	c1 e0 02             	shl    $0x2,%eax
  801725:	05 48 10 81 00       	add    $0x811048,%eax
  80172a:	8a 00                	mov    (%eax),%al
  80172c:	84 c0                	test   %al,%al
  80172e:	74 20                	je     801750 <malloc+0xc8>
  801730:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801733:	89 d0                	mov    %edx,%eax
  801735:	01 c0                	add    %eax,%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	c1 e0 02             	shl    $0x2,%eax
  80173c:	05 44 10 81 00       	add    $0x811044,%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801746:	75 08                	jne    801750 <malloc+0xc8>
        {
            exactIdx = i;
  801748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80174e:	eb 5b                	jmp    8017ab <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801750:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801753:	89 d0                	mov    %edx,%eax
  801755:	01 c0                	add    %eax,%eax
  801757:	01 d0                	add    %edx,%eax
  801759:	c1 e0 02             	shl    $0x2,%eax
  80175c:	05 48 10 81 00       	add    $0x811048,%eax
  801761:	8a 00                	mov    (%eax),%al
  801763:	84 c0                	test   %al,%al
  801765:	74 34                	je     80179b <malloc+0x113>
  801767:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80176a:	89 d0                	mov    %edx,%eax
  80176c:	01 c0                	add    %eax,%eax
  80176e:	01 d0                	add    %edx,%eax
  801770:	c1 e0 02             	shl    $0x2,%eax
  801773:	05 44 10 81 00       	add    $0x811044,%eax
  801778:	8b 00                	mov    (%eax),%eax
  80177a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80177d:	76 1c                	jbe    80179b <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  80177f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801782:	89 d0                	mov    %edx,%eax
  801784:	01 c0                	add    %eax,%eax
  801786:	01 d0                	add    %edx,%eax
  801788:	c1 e0 02             	shl    $0x2,%eax
  80178b:	05 44 10 81 00       	add    $0x811044,%eax
  801790:	8b 00                	mov    (%eax),%eax
  801792:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801795:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801798:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80179b:	ff 45 e8             	incl   -0x18(%ebp)
  80179e:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8017a5:	0f 8e 6e ff ff ff    	jle    801719 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8017ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8017b2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8017b6:	74 7d                	je     801835 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8017b8:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8017bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c2:	89 d0                	mov    %edx,%eax
  8017c4:	01 c0                	add    %eax,%eax
  8017c6:	01 d0                	add    %edx,%eax
  8017c8:	c1 e0 02             	shl    $0x2,%eax
  8017cb:	05 40 10 81 00       	add    $0x811040,%eax
  8017d0:	8b 10                	mov    (%eax),%edx
  8017d2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8017d5:	01 d0                	add    %edx,%eax
  8017d7:	48                   	dec    %eax
  8017d8:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8017db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8017de:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e3:	f7 75 bc             	divl   -0x44(%ebp)
  8017e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8017e9:	29 d0                	sub    %edx,%eax
  8017eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8017ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f1:	89 d0                	mov    %edx,%eax
  8017f3:	01 c0                	add    %eax,%eax
  8017f5:	01 d0                	add    %edx,%eax
  8017f7:	c1 e0 02             	shl    $0x2,%eax
  8017fa:	05 48 10 81 00       	add    $0x811048,%eax
  8017ff:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801805:	89 d0                	mov    %edx,%eax
  801807:	01 c0                	add    %eax,%eax
  801809:	01 d0                	add    %edx,%eax
  80180b:	c1 e0 02             	shl    $0x2,%eax
  80180e:	05 44 10 81 00       	add    $0x811044,%eax
  801813:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801819:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181c:	89 d0                	mov    %edx,%eax
  80181e:	01 c0                	add    %eax,%eax
  801820:	01 d0                	add    %edx,%eax
  801822:	c1 e0 02             	shl    $0x2,%eax
  801825:	05 40 10 81 00       	add    $0x811040,%eax
  80182a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801830:	e9 2d 01 00 00       	jmp    801962 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801835:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801839:	0f 84 ce 00 00 00    	je     80190d <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80183f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801846:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801849:	89 d0                	mov    %edx,%eax
  80184b:	01 c0                	add    %eax,%eax
  80184d:	01 d0                	add    %edx,%eax
  80184f:	c1 e0 02             	shl    $0x2,%eax
  801852:	05 40 10 81 00       	add    $0x811040,%eax
  801857:	8b 10                	mov    (%eax),%edx
  801859:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80185c:	01 d0                	add    %edx,%eax
  80185e:	48                   	dec    %eax
  80185f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801862:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801865:	ba 00 00 00 00       	mov    $0x0,%edx
  80186a:	f7 75 c4             	divl   -0x3c(%ebp)
  80186d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801870:	29 d0                	sub    %edx,%eax
  801872:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801875:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801878:	89 d0                	mov    %edx,%eax
  80187a:	01 c0                	add    %eax,%eax
  80187c:	01 d0                	add    %edx,%eax
  80187e:	c1 e0 02             	shl    $0x2,%eax
  801881:	05 44 10 81 00       	add    $0x811044,%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80188b:	75 47                	jne    8018d4 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  80188d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801890:	89 d0                	mov    %edx,%eax
  801892:	01 c0                	add    %eax,%eax
  801894:	01 d0                	add    %edx,%eax
  801896:	c1 e0 02             	shl    $0x2,%eax
  801899:	05 48 10 81 00       	add    $0x811048,%eax
  80189e:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8018a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018a4:	89 d0                	mov    %edx,%eax
  8018a6:	01 c0                	add    %eax,%eax
  8018a8:	01 d0                	add    %edx,%eax
  8018aa:	c1 e0 02             	shl    $0x2,%eax
  8018ad:	05 44 10 81 00       	add    $0x811044,%eax
  8018b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8018b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018bb:	89 d0                	mov    %edx,%eax
  8018bd:	01 c0                	add    %eax,%eax
  8018bf:	01 d0                	add    %edx,%eax
  8018c1:	c1 e0 02             	shl    $0x2,%eax
  8018c4:	05 40 10 81 00       	add    $0x811040,%eax
  8018c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018cf:	e9 8e 00 00 00       	jmp    801962 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8018d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018da:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8018dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018e0:	89 d0                	mov    %edx,%eax
  8018e2:	01 c0                	add    %eax,%eax
  8018e4:	01 d0                	add    %edx,%eax
  8018e6:	c1 e0 02             	shl    $0x2,%eax
  8018e9:	05 40 10 81 00       	add    $0x811040,%eax
  8018ee:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8018f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018f3:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8018f6:	89 c2                	mov    %eax,%edx
  8018f8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018fb:	89 c8                	mov    %ecx,%eax
  8018fd:	01 c0                	add    %eax,%eax
  8018ff:	01 c8                	add    %ecx,%eax
  801901:	c1 e0 02             	shl    $0x2,%eax
  801904:	05 44 10 81 00       	add    $0x811044,%eax
  801909:	89 10                	mov    %edx,(%eax)
  80190b:	eb 55                	jmp    801962 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80190d:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801914:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80191a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80191d:	01 d0                	add    %edx,%eax
  80191f:	48                   	dec    %eax
  801920:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801923:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801926:	ba 00 00 00 00       	mov    $0x0,%edx
  80192b:	f7 75 d0             	divl   -0x30(%ebp)
  80192e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801931:	29 d0                	sub    %edx,%eax
  801933:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801936:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801939:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80193c:	01 d0                	add    %edx,%eax
  80193e:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801943:	76 0a                	jbe    80194f <malloc+0x2c7>
            return NULL;
  801945:	b8 00 00 00 00       	mov    $0x0,%eax
  80194a:	e9 97 00 00 00       	jmp    8019e6 <malloc+0x35e>
        va = start;
  80194f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801952:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801955:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801958:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80195b:	01 d0                	add    %edx,%eax
  80195d:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801962:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801969:	eb 5e                	jmp    8019c9 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  80196b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80196e:	89 d0                	mov    %edx,%eax
  801970:	01 c0                	add    %eax,%eax
  801972:	01 d0                	add    %edx,%eax
  801974:	c1 e0 02             	shl    $0x2,%eax
  801977:	05 48 50 80 00       	add    $0x805048,%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	84 c0                	test   %al,%al
  801980:	75 44                	jne    8019c6 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801982:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801985:	89 d0                	mov    %edx,%eax
  801987:	01 c0                	add    %eax,%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c1 e0 02             	shl    $0x2,%eax
  80198e:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801994:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801997:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801999:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80199c:	89 d0                	mov    %edx,%eax
  80199e:	01 c0                	add    %eax,%eax
  8019a0:	01 d0                	add    %edx,%eax
  8019a2:	c1 e0 02             	shl    $0x2,%eax
  8019a5:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8019ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019ae:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8019b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019b3:	89 d0                	mov    %edx,%eax
  8019b5:	01 c0                	add    %eax,%eax
  8019b7:	01 d0                	add    %edx,%eax
  8019b9:	c1 e0 02             	shl    $0x2,%eax
  8019bc:	05 48 50 80 00       	add    $0x805048,%eax
  8019c1:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8019c4:	eb 0c                	jmp    8019d2 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019c6:	ff 45 e0             	incl   -0x20(%ebp)
  8019c9:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8019d0:	7e 99                	jle    80196b <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  8019d2:	83 ec 08             	sub    $0x8,%esp
  8019d5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8019d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019db:	e8 a2 19 00 00       	call   803382 <sys_allocate_user_mem>
  8019e0:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  8019e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  8019ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019f2:	0f 84 fa 03 00 00    	je     801df2 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8019fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a01:	85 c0                	test   %eax,%eax
  801a03:	79 1c                	jns    801a21 <free+0x39>
  801a05:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801a0c:	77 13                	ja     801a21 <free+0x39>
    {
        free_block(virtual_address);
  801a0e:	83 ec 0c             	sub    $0xc,%esp
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	e8 09 21 00 00       	call   803b22 <free_block>
  801a19:	83 c4 10             	add    $0x10,%esp
        return;
  801a1c:	e9 d2 03 00 00       	jmp    801df3 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801a21:	a1 30 51 83 00       	mov    0x835130,%eax
  801a26:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801a29:	72 09                	jb     801a34 <free+0x4c>
  801a2b:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801a32:	76 17                	jbe    801a4b <free+0x63>
        panic("free: invalid address");
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	68 8d 48 80 00       	push   $0x80488d
  801a3c:	68 9b 00 00 00       	push   $0x9b
  801a41:	68 44 48 80 00       	push   $0x804844
  801a46:	e8 ad e9 ff ff       	call   8003f8 <_panic>

    uint32 size = 0;
  801a4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801a52:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a59:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801a60:	eb 50                	jmp    801ab2 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801a62:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a65:	89 d0                	mov    %edx,%eax
  801a67:	01 c0                	add    %eax,%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	c1 e0 02             	shl    $0x2,%eax
  801a6e:	05 48 50 80 00       	add    $0x805048,%eax
  801a73:	8a 00                	mov    (%eax),%al
  801a75:	84 c0                	test   %al,%al
  801a77:	74 36                	je     801aaf <free+0xc7>
  801a79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a7c:	89 d0                	mov    %edx,%eax
  801a7e:	01 c0                	add    %eax,%eax
  801a80:	01 d0                	add    %edx,%eax
  801a82:	c1 e0 02             	shl    $0x2,%eax
  801a85:	05 40 50 80 00       	add    $0x805040,%eax
  801a8a:	8b 00                	mov    (%eax),%eax
  801a8c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801a8f:	75 1e                	jne    801aaf <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801a91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a94:	89 d0                	mov    %edx,%eax
  801a96:	01 c0                	add    %eax,%eax
  801a98:	01 d0                	add    %edx,%eax
  801a9a:	c1 e0 02             	shl    $0x2,%eax
  801a9d:	05 44 50 80 00       	add    $0x805044,%eax
  801aa2:	8b 00                	mov    (%eax),%eax
  801aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801aad:	eb 0c                	jmp    801abb <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801aaf:	ff 45 ec             	incl   -0x14(%ebp)
  801ab2:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801ab9:	7e a7                	jle    801a62 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801abb:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801abf:	74 06                	je     801ac7 <free+0xdf>
  801ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ac5:	75 17                	jne    801ade <free+0xf6>
        panic("free: unknown block");
  801ac7:	83 ec 04             	sub    $0x4,%esp
  801aca:	68 a3 48 80 00       	push   $0x8048a3
  801acf:	68 a9 00 00 00       	push   $0xa9
  801ad4:	68 44 48 80 00       	push   $0x804844
  801ad9:	e8 1a e9 ff ff       	call   8003f8 <_panic>

    uhp_allocs[idx].used = 0;
  801ade:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ae1:	89 d0                	mov    %edx,%eax
  801ae3:	01 c0                	add    %eax,%eax
  801ae5:	01 d0                	add    %edx,%eax
  801ae7:	c1 e0 02             	shl    $0x2,%eax
  801aea:	05 48 50 80 00       	add    $0x805048,%eax
  801aef:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801af2:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801af9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b00:	eb 64                	jmp    801b66 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801b02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b05:	89 d0                	mov    %edx,%eax
  801b07:	01 c0                	add    %eax,%eax
  801b09:	01 d0                	add    %edx,%eax
  801b0b:	c1 e0 02             	shl    $0x2,%eax
  801b0e:	05 48 10 81 00       	add    $0x811048,%eax
  801b13:	8a 00                	mov    (%eax),%al
  801b15:	84 c0                	test   %al,%al
  801b17:	75 4a                	jne    801b63 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801b19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b1c:	89 d0                	mov    %edx,%eax
  801b1e:	01 c0                	add    %eax,%eax
  801b20:	01 d0                	add    %edx,%eax
  801b22:	c1 e0 02             	shl    $0x2,%eax
  801b25:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801b2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b2e:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801b30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b33:	89 d0                	mov    %edx,%eax
  801b35:	01 c0                	add    %eax,%eax
  801b37:	01 d0                	add    %edx,%eax
  801b39:	c1 e0 02             	shl    $0x2,%eax
  801b3c:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b45:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801b47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b4a:	89 d0                	mov    %edx,%eax
  801b4c:	01 c0                	add    %eax,%eax
  801b4e:	01 d0                	add    %edx,%eax
  801b50:	c1 e0 02             	shl    $0x2,%eax
  801b53:	05 48 10 81 00       	add    $0x811048,%eax
  801b58:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801b61:	eb 0c                	jmp    801b6f <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b63:	ff 45 e4             	incl   -0x1c(%ebp)
  801b66:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801b6d:	7e 93                	jle    801b02 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801b6f:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801b73:	0f 84 f1 01 00 00    	je     801d6a <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b79:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b80:	e9 d8 01 00 00       	jmp    801d5d <free+0x375>
        {
            if (i == fidx) continue;
  801b85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b88:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b8b:	0f 84 c8 01 00 00    	je     801d59 <free+0x371>
            if (uhp_frees[i].free)
  801b91:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b94:	89 d0                	mov    %edx,%eax
  801b96:	01 c0                	add    %eax,%eax
  801b98:	01 d0                	add    %edx,%eax
  801b9a:	c1 e0 02             	shl    $0x2,%eax
  801b9d:	05 48 10 81 00       	add    $0x811048,%eax
  801ba2:	8a 00                	mov    (%eax),%al
  801ba4:	84 c0                	test   %al,%al
  801ba6:	0f 84 ae 01 00 00    	je     801d5a <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801bac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801baf:	89 d0                	mov    %edx,%eax
  801bb1:	01 c0                	add    %eax,%eax
  801bb3:	01 d0                	add    %edx,%eax
  801bb5:	c1 e0 02             	shl    $0x2,%eax
  801bb8:	05 40 10 81 00       	add    $0x811040,%eax
  801bbd:	8b 08                	mov    (%eax),%ecx
  801bbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bc2:	89 d0                	mov    %edx,%eax
  801bc4:	01 c0                	add    %eax,%eax
  801bc6:	01 d0                	add    %edx,%eax
  801bc8:	c1 e0 02             	shl    $0x2,%eax
  801bcb:	05 44 10 81 00       	add    $0x811044,%eax
  801bd0:	8b 00                	mov    (%eax),%eax
  801bd2:	01 c1                	add    %eax,%ecx
  801bd4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bd7:	89 d0                	mov    %edx,%eax
  801bd9:	01 c0                	add    %eax,%eax
  801bdb:	01 d0                	add    %edx,%eax
  801bdd:	c1 e0 02             	shl    $0x2,%eax
  801be0:	05 40 10 81 00       	add    $0x811040,%eax
  801be5:	8b 00                	mov    (%eax),%eax
  801be7:	39 c1                	cmp    %eax,%ecx
  801be9:	0f 85 a8 00 00 00    	jne    801c97 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801bef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bf2:	89 d0                	mov    %edx,%eax
  801bf4:	01 c0                	add    %eax,%eax
  801bf6:	01 d0                	add    %edx,%eax
  801bf8:	c1 e0 02             	shl    $0x2,%eax
  801bfb:	05 40 10 81 00       	add    $0x811040,%eax
  801c00:	8b 10                	mov    (%eax),%edx
  801c02:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801c05:	89 c8                	mov    %ecx,%eax
  801c07:	01 c0                	add    %eax,%eax
  801c09:	01 c8                	add    %ecx,%eax
  801c0b:	c1 e0 02             	shl    $0x2,%eax
  801c0e:	05 40 10 81 00       	add    $0x811040,%eax
  801c13:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c18:	89 d0                	mov    %edx,%eax
  801c1a:	01 c0                	add    %eax,%eax
  801c1c:	01 d0                	add    %edx,%eax
  801c1e:	c1 e0 02             	shl    $0x2,%eax
  801c21:	05 44 10 81 00       	add    $0x811044,%eax
  801c26:	8b 08                	mov    (%eax),%ecx
  801c28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c2b:	89 d0                	mov    %edx,%eax
  801c2d:	01 c0                	add    %eax,%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	c1 e0 02             	shl    $0x2,%eax
  801c34:	05 44 10 81 00       	add    $0x811044,%eax
  801c39:	8b 00                	mov    (%eax),%eax
  801c3b:	01 c1                	add    %eax,%ecx
  801c3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c40:	89 d0                	mov    %edx,%eax
  801c42:	01 c0                	add    %eax,%eax
  801c44:	01 d0                	add    %edx,%eax
  801c46:	c1 e0 02             	shl    $0x2,%eax
  801c49:	05 44 10 81 00       	add    $0x811044,%eax
  801c4e:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801c50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c53:	89 d0                	mov    %edx,%eax
  801c55:	01 c0                	add    %eax,%eax
  801c57:	01 d0                	add    %edx,%eax
  801c59:	c1 e0 02             	shl    $0x2,%eax
  801c5c:	05 48 10 81 00       	add    $0x811048,%eax
  801c61:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801c64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c67:	89 d0                	mov    %edx,%eax
  801c69:	01 c0                	add    %eax,%eax
  801c6b:	01 d0                	add    %edx,%eax
  801c6d:	c1 e0 02             	shl    $0x2,%eax
  801c70:	05 40 10 81 00       	add    $0x811040,%eax
  801c75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801c7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c7e:	89 d0                	mov    %edx,%eax
  801c80:	01 c0                	add    %eax,%eax
  801c82:	01 d0                	add    %edx,%eax
  801c84:	c1 e0 02             	shl    $0x2,%eax
  801c87:	05 44 10 81 00       	add    $0x811044,%eax
  801c8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c92:	e9 c3 00 00 00       	jmp    801d5a <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801c97:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c9a:	89 d0                	mov    %edx,%eax
  801c9c:	01 c0                	add    %eax,%eax
  801c9e:	01 d0                	add    %edx,%eax
  801ca0:	c1 e0 02             	shl    $0x2,%eax
  801ca3:	05 40 10 81 00       	add    $0x811040,%eax
  801ca8:	8b 08                	mov    (%eax),%ecx
  801caa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cad:	89 d0                	mov    %edx,%eax
  801caf:	01 c0                	add    %eax,%eax
  801cb1:	01 d0                	add    %edx,%eax
  801cb3:	c1 e0 02             	shl    $0x2,%eax
  801cb6:	05 44 10 81 00       	add    $0x811044,%eax
  801cbb:	8b 00                	mov    (%eax),%eax
  801cbd:	01 c1                	add    %eax,%ecx
  801cbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cc2:	89 d0                	mov    %edx,%eax
  801cc4:	01 c0                	add    %eax,%eax
  801cc6:	01 d0                	add    %edx,%eax
  801cc8:	c1 e0 02             	shl    $0x2,%eax
  801ccb:	05 40 10 81 00       	add    $0x811040,%eax
  801cd0:	8b 00                	mov    (%eax),%eax
  801cd2:	39 c1                	cmp    %eax,%ecx
  801cd4:	0f 85 80 00 00 00    	jne    801d5a <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801cda:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cdd:	89 d0                	mov    %edx,%eax
  801cdf:	01 c0                	add    %eax,%eax
  801ce1:	01 d0                	add    %edx,%eax
  801ce3:	c1 e0 02             	shl    $0x2,%eax
  801ce6:	05 44 10 81 00       	add    $0x811044,%eax
  801ceb:	8b 08                	mov    (%eax),%ecx
  801ced:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cf0:	89 d0                	mov    %edx,%eax
  801cf2:	01 c0                	add    %eax,%eax
  801cf4:	01 d0                	add    %edx,%eax
  801cf6:	c1 e0 02             	shl    $0x2,%eax
  801cf9:	05 44 10 81 00       	add    $0x811044,%eax
  801cfe:	8b 00                	mov    (%eax),%eax
  801d00:	01 c1                	add    %eax,%ecx
  801d02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d05:	89 d0                	mov    %edx,%eax
  801d07:	01 c0                	add    %eax,%eax
  801d09:	01 d0                	add    %edx,%eax
  801d0b:	c1 e0 02             	shl    $0x2,%eax
  801d0e:	05 44 10 81 00       	add    $0x811044,%eax
  801d13:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801d15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d18:	89 d0                	mov    %edx,%eax
  801d1a:	01 c0                	add    %eax,%eax
  801d1c:	01 d0                	add    %edx,%eax
  801d1e:	c1 e0 02             	shl    $0x2,%eax
  801d21:	05 48 10 81 00       	add    $0x811048,%eax
  801d26:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801d29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d2c:	89 d0                	mov    %edx,%eax
  801d2e:	01 c0                	add    %eax,%eax
  801d30:	01 d0                	add    %edx,%eax
  801d32:	c1 e0 02             	shl    $0x2,%eax
  801d35:	05 40 10 81 00       	add    $0x811040,%eax
  801d3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801d40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d43:	89 d0                	mov    %edx,%eax
  801d45:	01 c0                	add    %eax,%eax
  801d47:	01 d0                	add    %edx,%eax
  801d49:	c1 e0 02             	shl    $0x2,%eax
  801d4c:	05 44 10 81 00       	add    $0x811044,%eax
  801d51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d57:	eb 01                	jmp    801d5a <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801d59:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d5a:	ff 45 e0             	incl   -0x20(%ebp)
  801d5d:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801d64:	0f 8e 1b fe ff ff    	jle    801b85 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801d6a:	a1 30 51 83 00       	mov    0x835130,%eax
  801d6f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801d72:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801d79:	eb 53                	jmp    801dce <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801d7b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d7e:	89 d0                	mov    %edx,%eax
  801d80:	01 c0                	add    %eax,%eax
  801d82:	01 d0                	add    %edx,%eax
  801d84:	c1 e0 02             	shl    $0x2,%eax
  801d87:	05 48 50 80 00       	add    $0x805048,%eax
  801d8c:	8a 00                	mov    (%eax),%al
  801d8e:	84 c0                	test   %al,%al
  801d90:	74 39                	je     801dcb <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801d92:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d95:	89 d0                	mov    %edx,%eax
  801d97:	01 c0                	add    %eax,%eax
  801d99:	01 d0                	add    %edx,%eax
  801d9b:	c1 e0 02             	shl    $0x2,%eax
  801d9e:	05 40 50 80 00       	add    $0x805040,%eax
  801da3:	8b 08                	mov    (%eax),%ecx
  801da5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801da8:	89 d0                	mov    %edx,%eax
  801daa:	01 c0                	add    %eax,%eax
  801dac:	01 d0                	add    %edx,%eax
  801dae:	c1 e0 02             	shl    $0x2,%eax
  801db1:	05 44 50 80 00       	add    $0x805044,%eax
  801db6:	8b 00                	mov    (%eax),%eax
  801db8:	01 c8                	add    %ecx,%eax
  801dba:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801dbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801dc0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801dc3:	76 06                	jbe    801dcb <free+0x3e3>
  801dc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801dc8:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801dcb:	ff 45 d8             	incl   -0x28(%ebp)
  801dce:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801dd5:	7e a4                	jle    801d7b <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801dd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dda:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801ddf:	83 ec 08             	sub    $0x8,%esp
  801de2:	ff 75 f4             	pushl  -0xc(%ebp)
  801de5:	ff 75 d4             	pushl  -0x2c(%ebp)
  801de8:	e8 79 15 00 00       	call   803366 <sys_free_user_mem>
  801ded:	83 c4 10             	add    $0x10,%esp
  801df0:	eb 01                	jmp    801df3 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801df2:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 68             	sub    $0x68,%esp
  801dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfe:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e01:	e8 a5 f7 ff ff       	call   8015ab <uheap_init>
	if (size == 0) return NULL ;
  801e06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e0a:	75 0a                	jne    801e16 <smalloc+0x21>
  801e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e11:	e9 37 03 00 00       	jmp    80214d <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801e16:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801e1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e23:	01 d0                	add    %edx,%eax
  801e25:	48                   	dec    %eax
  801e26:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e29:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e31:	f7 75 dc             	divl   -0x24(%ebp)
  801e34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e37:	29 d0                	sub    %edx,%eax
  801e39:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801e3c:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801e43:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801e4a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e51:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801e58:	e9 85 00 00 00       	jmp    801ee2 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801e5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e60:	89 d0                	mov    %edx,%eax
  801e62:	01 c0                	add    %eax,%eax
  801e64:	01 d0                	add    %edx,%eax
  801e66:	c1 e0 02             	shl    $0x2,%eax
  801e69:	05 48 10 81 00       	add    $0x811048,%eax
  801e6e:	8a 00                	mov    (%eax),%al
  801e70:	84 c0                	test   %al,%al
  801e72:	74 20                	je     801e94 <smalloc+0x9f>
  801e74:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e77:	89 d0                	mov    %edx,%eax
  801e79:	01 c0                	add    %eax,%eax
  801e7b:	01 d0                	add    %edx,%eax
  801e7d:	c1 e0 02             	shl    $0x2,%eax
  801e80:	05 44 10 81 00       	add    $0x811044,%eax
  801e85:	8b 00                	mov    (%eax),%eax
  801e87:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e8a:	75 08                	jne    801e94 <smalloc+0x9f>
        {
            exactIdx = i;
  801e8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801e92:	eb 5b                	jmp    801eef <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801e94:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e97:	89 d0                	mov    %edx,%eax
  801e99:	01 c0                	add    %eax,%eax
  801e9b:	01 d0                	add    %edx,%eax
  801e9d:	c1 e0 02             	shl    $0x2,%eax
  801ea0:	05 48 10 81 00       	add    $0x811048,%eax
  801ea5:	8a 00                	mov    (%eax),%al
  801ea7:	84 c0                	test   %al,%al
  801ea9:	74 34                	je     801edf <smalloc+0xea>
  801eab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eae:	89 d0                	mov    %edx,%eax
  801eb0:	01 c0                	add    %eax,%eax
  801eb2:	01 d0                	add    %edx,%eax
  801eb4:	c1 e0 02             	shl    $0x2,%eax
  801eb7:	05 44 10 81 00       	add    $0x811044,%eax
  801ebc:	8b 00                	mov    (%eax),%eax
  801ebe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ec1:	76 1c                	jbe    801edf <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801ec3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ec6:	89 d0                	mov    %edx,%eax
  801ec8:	01 c0                	add    %eax,%eax
  801eca:	01 d0                	add    %edx,%eax
  801ecc:	c1 e0 02             	shl    $0x2,%eax
  801ecf:	05 44 10 81 00       	add    $0x811044,%eax
  801ed4:	8b 00                	mov    (%eax),%eax
  801ed6:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801ed9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801edc:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801edf:	ff 45 e8             	incl   -0x18(%ebp)
  801ee2:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801ee9:	0f 8e 6e ff ff ff    	jle    801e5d <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801eef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801ef6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801efa:	74 7d                	je     801f79 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801efc:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f06:	89 d0                	mov    %edx,%eax
  801f08:	01 c0                	add    %eax,%eax
  801f0a:	01 d0                	add    %edx,%eax
  801f0c:	c1 e0 02             	shl    $0x2,%eax
  801f0f:	05 40 10 81 00       	add    $0x811040,%eax
  801f14:	8b 10                	mov    (%eax),%edx
  801f16:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801f19:	01 d0                	add    %edx,%eax
  801f1b:	48                   	dec    %eax
  801f1c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801f1f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f22:	ba 00 00 00 00       	mov    $0x0,%edx
  801f27:	f7 75 bc             	divl   -0x44(%ebp)
  801f2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801f2d:	29 d0                	sub    %edx,%eax
  801f2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801f32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f35:	89 d0                	mov    %edx,%eax
  801f37:	01 c0                	add    %eax,%eax
  801f39:	01 d0                	add    %edx,%eax
  801f3b:	c1 e0 02             	shl    $0x2,%eax
  801f3e:	05 48 10 81 00       	add    $0x811048,%eax
  801f43:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f49:	89 d0                	mov    %edx,%eax
  801f4b:	01 c0                	add    %eax,%eax
  801f4d:	01 d0                	add    %edx,%eax
  801f4f:	c1 e0 02             	shl    $0x2,%eax
  801f52:	05 44 10 81 00       	add    $0x811044,%eax
  801f57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f60:	89 d0                	mov    %edx,%eax
  801f62:	01 c0                	add    %eax,%eax
  801f64:	01 d0                	add    %edx,%eax
  801f66:	c1 e0 02             	shl    $0x2,%eax
  801f69:	05 40 10 81 00       	add    $0x811040,%eax
  801f6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f74:	e9 2d 01 00 00       	jmp    8020a6 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801f79:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f7d:	0f 84 ce 00 00 00    	je     802051 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801f83:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801f8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f8d:	89 d0                	mov    %edx,%eax
  801f8f:	01 c0                	add    %eax,%eax
  801f91:	01 d0                	add    %edx,%eax
  801f93:	c1 e0 02             	shl    $0x2,%eax
  801f96:	05 40 10 81 00       	add    $0x811040,%eax
  801f9b:	8b 10                	mov    (%eax),%edx
  801f9d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fa0:	01 d0                	add    %edx,%eax
  801fa2:	48                   	dec    %eax
  801fa3:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801fa6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fa9:	ba 00 00 00 00       	mov    $0x0,%edx
  801fae:	f7 75 c4             	divl   -0x3c(%ebp)
  801fb1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801fb4:	29 d0                	sub    %edx,%eax
  801fb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801fb9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fbc:	89 d0                	mov    %edx,%eax
  801fbe:	01 c0                	add    %eax,%eax
  801fc0:	01 d0                	add    %edx,%eax
  801fc2:	c1 e0 02             	shl    $0x2,%eax
  801fc5:	05 44 10 81 00       	add    $0x811044,%eax
  801fca:	8b 00                	mov    (%eax),%eax
  801fcc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801fcf:	75 47                	jne    802018 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801fd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd4:	89 d0                	mov    %edx,%eax
  801fd6:	01 c0                	add    %eax,%eax
  801fd8:	01 d0                	add    %edx,%eax
  801fda:	c1 e0 02             	shl    $0x2,%eax
  801fdd:	05 48 10 81 00       	add    $0x811048,%eax
  801fe2:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801fe5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fe8:	89 d0                	mov    %edx,%eax
  801fea:	01 c0                	add    %eax,%eax
  801fec:	01 d0                	add    %edx,%eax
  801fee:	c1 e0 02             	shl    $0x2,%eax
  801ff1:	05 44 10 81 00       	add    $0x811044,%eax
  801ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801ffc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fff:	89 d0                	mov    %edx,%eax
  802001:	01 c0                	add    %eax,%eax
  802003:	01 d0                	add    %edx,%eax
  802005:	c1 e0 02             	shl    $0x2,%eax
  802008:	05 40 10 81 00       	add    $0x811040,%eax
  80200d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802013:	e9 8e 00 00 00       	jmp    8020a6 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802018:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80201b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80201e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802021:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802024:	89 d0                	mov    %edx,%eax
  802026:	01 c0                	add    %eax,%eax
  802028:	01 d0                	add    %edx,%eax
  80202a:	c1 e0 02             	shl    $0x2,%eax
  80202d:	05 40 10 81 00       	add    $0x811040,%eax
  802032:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802034:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802037:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80203a:	89 c2                	mov    %eax,%edx
  80203c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80203f:	89 c8                	mov    %ecx,%eax
  802041:	01 c0                	add    %eax,%eax
  802043:	01 c8                	add    %ecx,%eax
  802045:	c1 e0 02             	shl    $0x2,%eax
  802048:	05 44 10 81 00       	add    $0x811044,%eax
  80204d:	89 10                	mov    %edx,(%eax)
  80204f:	eb 55                	jmp    8020a6 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802051:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802058:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80205e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802061:	01 d0                	add    %edx,%eax
  802063:	48                   	dec    %eax
  802064:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802067:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80206a:	ba 00 00 00 00       	mov    $0x0,%edx
  80206f:	f7 75 d0             	divl   -0x30(%ebp)
  802072:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802075:	29 d0                	sub    %edx,%eax
  802077:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80207a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80207d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802080:	01 d0                	add    %edx,%eax
  802082:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802087:	76 0a                	jbe    802093 <smalloc+0x29e>
            return NULL;
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	e9 ba 00 00 00       	jmp    80214d <smalloc+0x358>
        va = start;
  802093:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802096:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802099:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80209c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80209f:	01 d0                	add    %edx,%eax
  8020a1:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8020a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8020ad:	eb 5e                	jmp    80210d <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8020af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020b2:	89 d0                	mov    %edx,%eax
  8020b4:	01 c0                	add    %eax,%eax
  8020b6:	01 d0                	add    %edx,%eax
  8020b8:	c1 e0 02             	shl    $0x2,%eax
  8020bb:	05 48 50 80 00       	add    $0x805048,%eax
  8020c0:	8a 00                	mov    (%eax),%al
  8020c2:	84 c0                	test   %al,%al
  8020c4:	75 44                	jne    80210a <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  8020c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020c9:	89 d0                	mov    %edx,%eax
  8020cb:	01 c0                	add    %eax,%eax
  8020cd:	01 d0                	add    %edx,%eax
  8020cf:	c1 e0 02             	shl    $0x2,%eax
  8020d2:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8020d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020db:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8020dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020e0:	89 d0                	mov    %edx,%eax
  8020e2:	01 c0                	add    %eax,%eax
  8020e4:	01 d0                	add    %edx,%eax
  8020e6:	c1 e0 02             	shl    $0x2,%eax
  8020e9:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8020ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020f2:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8020f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020f7:	89 d0                	mov    %edx,%eax
  8020f9:	01 c0                	add    %eax,%eax
  8020fb:	01 d0                	add    %edx,%eax
  8020fd:	c1 e0 02             	shl    $0x2,%eax
  802100:	05 48 50 80 00       	add    $0x805048,%eax
  802105:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802108:	eb 0c                	jmp    802116 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80210a:	ff 45 e0             	incl   -0x20(%ebp)
  80210d:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802114:	7e 99                	jle    8020af <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802116:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802119:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  80211d:	52                   	push   %edx
  80211e:	50                   	push   %eax
  80211f:	ff 75 d4             	pushl  -0x2c(%ebp)
  802122:	ff 75 08             	pushl  0x8(%ebp)
  802125:	e8 de 0e 00 00       	call   803008 <sys_create_shared_object>
  80212a:	83 c4 10             	add    $0x10,%esp
  80212d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802130:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802134:	75 07                	jne    80213d <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802136:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80213b:	eb 10                	jmp    80214d <smalloc+0x358>
    if (r < 0)
  80213d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802141:	79 07                	jns    80214a <smalloc+0x355>
        return NULL;
  802143:	b8 00 00 00 00       	mov    $0x0,%eax
  802148:	eb 03                	jmp    80214d <smalloc+0x358>
    return (void*)va;
  80214a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802155:	e8 51 f4 ff ff       	call   8015ab <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80215a:	83 ec 08             	sub    $0x8,%esp
  80215d:	ff 75 0c             	pushl  0xc(%ebp)
  802160:	ff 75 08             	pushl  0x8(%ebp)
  802163:	e8 ca 0e 00 00       	call   803032 <sys_size_of_shared_object>
  802168:	83 c4 10             	add    $0x10,%esp
  80216b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  80216e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802172:	7f 0a                	jg     80217e <sget+0x2f>
        return NULL;
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
  802179:	e9 28 03 00 00       	jmp    8024a6 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80217e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802185:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802188:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80218b:	01 d0                	add    %edx,%eax
  80218d:	48                   	dec    %eax
  80218e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802191:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802194:	ba 00 00 00 00       	mov    $0x0,%edx
  802199:	f7 75 d8             	divl   -0x28(%ebp)
  80219c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80219f:	29 d0                	sub    %edx,%eax
  8021a1:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8021a4:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8021ab:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8021b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8021b9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8021c0:	e9 85 00 00 00       	jmp    80224a <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8021c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021c8:	89 d0                	mov    %edx,%eax
  8021ca:	01 c0                	add    %eax,%eax
  8021cc:	01 d0                	add    %edx,%eax
  8021ce:	c1 e0 02             	shl    $0x2,%eax
  8021d1:	05 48 10 81 00       	add    $0x811048,%eax
  8021d6:	8a 00                	mov    (%eax),%al
  8021d8:	84 c0                	test   %al,%al
  8021da:	74 20                	je     8021fc <sget+0xad>
  8021dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021df:	89 d0                	mov    %edx,%eax
  8021e1:	01 c0                	add    %eax,%eax
  8021e3:	01 d0                	add    %edx,%eax
  8021e5:	c1 e0 02             	shl    $0x2,%eax
  8021e8:	05 44 10 81 00       	add    $0x811044,%eax
  8021ed:	8b 00                	mov    (%eax),%eax
  8021ef:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8021f2:	75 08                	jne    8021fc <sget+0xad>
        {
            exactIdx = i;
  8021f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8021fa:	eb 5b                	jmp    802257 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8021fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021ff:	89 d0                	mov    %edx,%eax
  802201:	01 c0                	add    %eax,%eax
  802203:	01 d0                	add    %edx,%eax
  802205:	c1 e0 02             	shl    $0x2,%eax
  802208:	05 48 10 81 00       	add    $0x811048,%eax
  80220d:	8a 00                	mov    (%eax),%al
  80220f:	84 c0                	test   %al,%al
  802211:	74 34                	je     802247 <sget+0xf8>
  802213:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802216:	89 d0                	mov    %edx,%eax
  802218:	01 c0                	add    %eax,%eax
  80221a:	01 d0                	add    %edx,%eax
  80221c:	c1 e0 02             	shl    $0x2,%eax
  80221f:	05 44 10 81 00       	add    $0x811044,%eax
  802224:	8b 00                	mov    (%eax),%eax
  802226:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802229:	76 1c                	jbe    802247 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  80222b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80222e:	89 d0                	mov    %edx,%eax
  802230:	01 c0                	add    %eax,%eax
  802232:	01 d0                	add    %edx,%eax
  802234:	c1 e0 02             	shl    $0x2,%eax
  802237:	05 44 10 81 00       	add    $0x811044,%eax
  80223c:	8b 00                	mov    (%eax),%eax
  80223e:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802244:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802247:	ff 45 e8             	incl   -0x18(%ebp)
  80224a:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802251:	0f 8e 6e ff ff ff    	jle    8021c5 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802257:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80225e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802262:	74 7d                	je     8022e1 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802264:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80226b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226e:	89 d0                	mov    %edx,%eax
  802270:	01 c0                	add    %eax,%eax
  802272:	01 d0                	add    %edx,%eax
  802274:	c1 e0 02             	shl    $0x2,%eax
  802277:	05 40 10 81 00       	add    $0x811040,%eax
  80227c:	8b 10                	mov    (%eax),%edx
  80227e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802281:	01 d0                	add    %edx,%eax
  802283:	48                   	dec    %eax
  802284:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802287:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80228a:	ba 00 00 00 00       	mov    $0x0,%edx
  80228f:	f7 75 b8             	divl   -0x48(%ebp)
  802292:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802295:	29 d0                	sub    %edx,%eax
  802297:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80229a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229d:	89 d0                	mov    %edx,%eax
  80229f:	01 c0                	add    %eax,%eax
  8022a1:	01 d0                	add    %edx,%eax
  8022a3:	c1 e0 02             	shl    $0x2,%eax
  8022a6:	05 48 10 81 00       	add    $0x811048,%eax
  8022ab:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8022ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b1:	89 d0                	mov    %edx,%eax
  8022b3:	01 c0                	add    %eax,%eax
  8022b5:	01 d0                	add    %edx,%eax
  8022b7:	c1 e0 02             	shl    $0x2,%eax
  8022ba:	05 44 10 81 00       	add    $0x811044,%eax
  8022bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8022c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c8:	89 d0                	mov    %edx,%eax
  8022ca:	01 c0                	add    %eax,%eax
  8022cc:	01 d0                	add    %edx,%eax
  8022ce:	c1 e0 02             	shl    $0x2,%eax
  8022d1:	05 40 10 81 00       	add    $0x811040,%eax
  8022d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022dc:	e9 2d 01 00 00       	jmp    80240e <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8022e1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8022e5:	0f 84 ce 00 00 00    	je     8023b9 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8022eb:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8022f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f5:	89 d0                	mov    %edx,%eax
  8022f7:	01 c0                	add    %eax,%eax
  8022f9:	01 d0                	add    %edx,%eax
  8022fb:	c1 e0 02             	shl    $0x2,%eax
  8022fe:	05 40 10 81 00       	add    $0x811040,%eax
  802303:	8b 10                	mov    (%eax),%edx
  802305:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802308:	01 d0                	add    %edx,%eax
  80230a:	48                   	dec    %eax
  80230b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80230e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802311:	ba 00 00 00 00       	mov    $0x0,%edx
  802316:	f7 75 c0             	divl   -0x40(%ebp)
  802319:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80231c:	29 d0                	sub    %edx,%eax
  80231e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802321:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802324:	89 d0                	mov    %edx,%eax
  802326:	01 c0                	add    %eax,%eax
  802328:	01 d0                	add    %edx,%eax
  80232a:	c1 e0 02             	shl    $0x2,%eax
  80232d:	05 44 10 81 00       	add    $0x811044,%eax
  802332:	8b 00                	mov    (%eax),%eax
  802334:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802337:	75 47                	jne    802380 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802339:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233c:	89 d0                	mov    %edx,%eax
  80233e:	01 c0                	add    %eax,%eax
  802340:	01 d0                	add    %edx,%eax
  802342:	c1 e0 02             	shl    $0x2,%eax
  802345:	05 48 10 81 00       	add    $0x811048,%eax
  80234a:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80234d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802350:	89 d0                	mov    %edx,%eax
  802352:	01 c0                	add    %eax,%eax
  802354:	01 d0                	add    %edx,%eax
  802356:	c1 e0 02             	shl    $0x2,%eax
  802359:	05 44 10 81 00       	add    $0x811044,%eax
  80235e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802364:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802367:	89 d0                	mov    %edx,%eax
  802369:	01 c0                	add    %eax,%eax
  80236b:	01 d0                	add    %edx,%eax
  80236d:	c1 e0 02             	shl    $0x2,%eax
  802370:	05 40 10 81 00       	add    $0x811040,%eax
  802375:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237b:	e9 8e 00 00 00       	jmp    80240e <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802383:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802386:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802389:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80238c:	89 d0                	mov    %edx,%eax
  80238e:	01 c0                	add    %eax,%eax
  802390:	01 d0                	add    %edx,%eax
  802392:	c1 e0 02             	shl    $0x2,%eax
  802395:	05 40 10 81 00       	add    $0x811040,%eax
  80239a:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80239c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8023a2:	89 c2                	mov    %eax,%edx
  8023a4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8023a7:	89 c8                	mov    %ecx,%eax
  8023a9:	01 c0                	add    %eax,%eax
  8023ab:	01 c8                	add    %ecx,%eax
  8023ad:	c1 e0 02             	shl    $0x2,%eax
  8023b0:	05 44 10 81 00       	add    $0x811044,%eax
  8023b5:	89 10                	mov    %edx,(%eax)
  8023b7:	eb 55                	jmp    80240e <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8023b9:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8023c0:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8023c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023c9:	01 d0                	add    %edx,%eax
  8023cb:	48                   	dec    %eax
  8023cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8023cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023d7:	f7 75 cc             	divl   -0x34(%ebp)
  8023da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023dd:	29 d0                	sub    %edx,%eax
  8023df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8023e2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8023e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023e8:	01 d0                	add    %edx,%eax
  8023ea:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8023ef:	76 0a                	jbe    8023fb <sget+0x2ac>
            return NULL;
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f6:	e9 ab 00 00 00       	jmp    8024a6 <sget+0x357>
        va = start;
  8023fb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8023fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802401:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802404:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802407:	01 d0                	add    %edx,%eax
  802409:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80240e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802415:	eb 5e                	jmp    802475 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802417:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80241a:	89 d0                	mov    %edx,%eax
  80241c:	01 c0                	add    %eax,%eax
  80241e:	01 d0                	add    %edx,%eax
  802420:	c1 e0 02             	shl    $0x2,%eax
  802423:	05 48 50 80 00       	add    $0x805048,%eax
  802428:	8a 00                	mov    (%eax),%al
  80242a:	84 c0                	test   %al,%al
  80242c:	75 44                	jne    802472 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80242e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802431:	89 d0                	mov    %edx,%eax
  802433:	01 c0                	add    %eax,%eax
  802435:	01 d0                	add    %edx,%eax
  802437:	c1 e0 02             	shl    $0x2,%eax
  80243a:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802440:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802443:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802445:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802448:	89 d0                	mov    %edx,%eax
  80244a:	01 c0                	add    %eax,%eax
  80244c:	01 d0                	add    %edx,%eax
  80244e:	c1 e0 02             	shl    $0x2,%eax
  802451:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802457:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80245a:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80245c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80245f:	89 d0                	mov    %edx,%eax
  802461:	01 c0                	add    %eax,%eax
  802463:	01 d0                	add    %edx,%eax
  802465:	c1 e0 02             	shl    $0x2,%eax
  802468:	05 48 50 80 00       	add    $0x805048,%eax
  80246d:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802470:	eb 0c                	jmp    80247e <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802472:	ff 45 e0             	incl   -0x20(%ebp)
  802475:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80247c:	7e 99                	jle    802417 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  80247e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	50                   	push   %eax
  802485:	ff 75 0c             	pushl  0xc(%ebp)
  802488:	ff 75 08             	pushl  0x8(%ebp)
  80248b:	e8 bf 0b 00 00       	call   80304f <sys_get_shared_object>
  802490:	83 c4 10             	add    $0x10,%esp
  802493:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802496:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80249a:	79 07                	jns    8024a3 <sget+0x354>
        return NULL;
  80249c:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a1:	eb 03                	jmp    8024a6 <sget+0x357>
    return (void*)va;
  8024a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8024a6:	c9                   	leave  
  8024a7:	c3                   	ret    

008024a8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8024ae:	e8 f8 f0 ff ff       	call   8015ab <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8024b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024b7:	75 13                	jne    8024cc <realloc+0x24>
		return malloc(new_size);
  8024b9:	83 ec 0c             	sub    $0xc,%esp
  8024bc:	ff 75 0c             	pushl  0xc(%ebp)
  8024bf:	e8 c4 f1 ff ff       	call   801688 <malloc>
  8024c4:	83 c4 10             	add    $0x10,%esp
  8024c7:	e9 f4 05 00 00       	jmp    802ac0 <realloc+0x618>
	if (new_size == 0)
  8024cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8024d0:	75 18                	jne    8024ea <realloc+0x42>
	{
		free(virtual_address);
  8024d2:	83 ec 0c             	sub    $0xc,%esp
  8024d5:	ff 75 08             	pushl  0x8(%ebp)
  8024d8:	e8 0b f5 ff ff       	call   8019e8 <free>
  8024dd:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8024e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e5:	e9 d6 05 00 00       	jmp    802ac0 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8024f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024f3:	85 c0                	test   %eax,%eax
  8024f5:	79 74                	jns    80256b <realloc+0xc3>
  8024f7:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8024fe:	77 6b                	ja     80256b <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802500:	83 ec 0c             	sub    $0xc,%esp
  802503:	ff 75 0c             	pushl  0xc(%ebp)
  802506:	e8 7d f1 ff ff       	call   801688 <malloc>
  80250b:	83 c4 10             	add    $0x10,%esp
  80250e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802511:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802515:	75 0a                	jne    802521 <realloc+0x79>
			return NULL;
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
  80251c:	e9 9f 05 00 00       	jmp    802ac0 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802521:	83 ec 0c             	sub    $0xc,%esp
  802524:	ff 75 08             	pushl  0x8(%ebp)
  802527:	e8 e0 11 00 00       	call   80370c <get_block_size>
  80252c:	83 c4 10             	add    $0x10,%esp
  80252f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802532:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802535:	8b 45 0c             	mov    0xc(%ebp),%eax
  802538:	39 d0                	cmp    %edx,%eax
  80253a:	76 02                	jbe    80253e <realloc+0x96>
  80253c:	89 d0                	mov    %edx,%eax
  80253e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802541:	83 ec 04             	sub    $0x4,%esp
  802544:	ff 75 c0             	pushl  -0x40(%ebp)
  802547:	ff 75 08             	pushl  0x8(%ebp)
  80254a:	ff 75 c8             	pushl  -0x38(%ebp)
  80254d:	e8 56 eb ff ff       	call   8010a8 <memmove>
  802552:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802555:	83 ec 0c             	sub    $0xc,%esp
  802558:	ff 75 08             	pushl  0x8(%ebp)
  80255b:	e8 88 f4 ff ff       	call   8019e8 <free>
  802560:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802563:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802566:	e9 55 05 00 00       	jmp    802ac0 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80256b:	a1 30 51 83 00       	mov    0x835130,%eax
  802570:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802573:	72 09                	jb     80257e <realloc+0xd6>
  802575:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  80257c:	76 0a                	jbe    802588 <realloc+0xe0>
		return NULL;
  80257e:	b8 00 00 00 00       	mov    $0x0,%eax
  802583:	e9 38 05 00 00       	jmp    802ac0 <realloc+0x618>
	uint32 oldsz = 0;
  802588:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  80258f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802596:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80259d:	eb 50                	jmp    8025ef <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  80259f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025a2:	89 d0                	mov    %edx,%eax
  8025a4:	01 c0                	add    %eax,%eax
  8025a6:	01 d0                	add    %edx,%eax
  8025a8:	c1 e0 02             	shl    $0x2,%eax
  8025ab:	05 48 50 80 00       	add    $0x805048,%eax
  8025b0:	8a 00                	mov    (%eax),%al
  8025b2:	84 c0                	test   %al,%al
  8025b4:	74 36                	je     8025ec <realloc+0x144>
  8025b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025b9:	89 d0                	mov    %edx,%eax
  8025bb:	01 c0                	add    %eax,%eax
  8025bd:	01 d0                	add    %edx,%eax
  8025bf:	c1 e0 02             	shl    $0x2,%eax
  8025c2:	05 40 50 80 00       	add    $0x805040,%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8025cc:	75 1e                	jne    8025ec <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  8025ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d1:	89 d0                	mov    %edx,%eax
  8025d3:	01 c0                	add    %eax,%eax
  8025d5:	01 d0                	add    %edx,%eax
  8025d7:	c1 e0 02             	shl    $0x2,%eax
  8025da:	05 44 50 80 00       	add    $0x805044,%eax
  8025df:	8b 00                	mov    (%eax),%eax
  8025e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8025e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8025ea:	eb 0c                	jmp    8025f8 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025ec:	ff 45 ec             	incl   -0x14(%ebp)
  8025ef:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8025f6:	7e a7                	jle    80259f <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8025f8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8025fc:	75 0a                	jne    802608 <realloc+0x160>
		return NULL;
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	e9 b8 04 00 00       	jmp    802ac0 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802608:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80260f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802612:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802615:	01 d0                	add    %edx,%eax
  802617:	48                   	dec    %eax
  802618:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80261b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80261e:	ba 00 00 00 00       	mov    $0x0,%edx
  802623:	f7 75 bc             	divl   -0x44(%ebp)
  802626:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802629:	29 d0                	sub    %edx,%eax
  80262b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  80262e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802631:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802634:	75 08                	jne    80263e <realloc+0x196>
		return virtual_address;
  802636:	8b 45 08             	mov    0x8(%ebp),%eax
  802639:	e9 82 04 00 00       	jmp    802ac0 <realloc+0x618>
	if (req < oldsz)
  80263e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802641:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802644:	0f 83 cd 02 00 00    	jae    802917 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802650:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802653:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802656:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802659:	01 d0                	add    %edx,%eax
  80265b:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  80265e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802661:	89 d0                	mov    %edx,%eax
  802663:	01 c0                	add    %eax,%eax
  802665:	01 d0                	add    %edx,%eax
  802667:	c1 e0 02             	shl    $0x2,%eax
  80266a:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802670:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802673:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802675:	83 ec 08             	sub    $0x8,%esp
  802678:	ff 75 b0             	pushl  -0x50(%ebp)
  80267b:	ff 75 ac             	pushl  -0x54(%ebp)
  80267e:	e8 e3 0c 00 00       	call   803366 <sys_free_user_mem>
  802683:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802686:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80268d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802694:	eb 64                	jmp    8026fa <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802696:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802699:	89 d0                	mov    %edx,%eax
  80269b:	01 c0                	add    %eax,%eax
  80269d:	01 d0                	add    %edx,%eax
  80269f:	c1 e0 02             	shl    $0x2,%eax
  8026a2:	05 48 10 81 00       	add    $0x811048,%eax
  8026a7:	8a 00                	mov    (%eax),%al
  8026a9:	84 c0                	test   %al,%al
  8026ab:	75 4a                	jne    8026f7 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8026ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026b0:	89 d0                	mov    %edx,%eax
  8026b2:	01 c0                	add    %eax,%eax
  8026b4:	01 d0                	add    %edx,%eax
  8026b6:	c1 e0 02             	shl    $0x2,%eax
  8026b9:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  8026bf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8026c2:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  8026c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026c7:	89 d0                	mov    %edx,%eax
  8026c9:	01 c0                	add    %eax,%eax
  8026cb:	01 d0                	add    %edx,%eax
  8026cd:	c1 e0 02             	shl    $0x2,%eax
  8026d0:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  8026d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026d9:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  8026db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026de:	89 d0                	mov    %edx,%eax
  8026e0:	01 c0                	add    %eax,%eax
  8026e2:	01 d0                	add    %edx,%eax
  8026e4:	c1 e0 02             	shl    $0x2,%eax
  8026e7:	05 48 10 81 00       	add    $0x811048,%eax
  8026ec:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8026ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8026f5:	eb 0c                	jmp    802703 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8026f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8026fa:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802701:	7e 93                	jle    802696 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802703:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802707:	0f 84 8d 01 00 00    	je     80289a <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80270d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802714:	e9 74 01 00 00       	jmp    80288d <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802719:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80271f:	0f 84 64 01 00 00    	je     802889 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802725:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802728:	89 d0                	mov    %edx,%eax
  80272a:	01 c0                	add    %eax,%eax
  80272c:	01 d0                	add    %edx,%eax
  80272e:	c1 e0 02             	shl    $0x2,%eax
  802731:	05 48 10 81 00       	add    $0x811048,%eax
  802736:	8a 00                	mov    (%eax),%al
  802738:	84 c0                	test   %al,%al
  80273a:	0f 84 4a 01 00 00    	je     80288a <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802740:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802743:	89 d0                	mov    %edx,%eax
  802745:	01 c0                	add    %eax,%eax
  802747:	01 d0                	add    %edx,%eax
  802749:	c1 e0 02             	shl    $0x2,%eax
  80274c:	05 40 10 81 00       	add    $0x811040,%eax
  802751:	8b 08                	mov    (%eax),%ecx
  802753:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802756:	89 d0                	mov    %edx,%eax
  802758:	01 c0                	add    %eax,%eax
  80275a:	01 d0                	add    %edx,%eax
  80275c:	c1 e0 02             	shl    $0x2,%eax
  80275f:	05 44 10 81 00       	add    $0x811044,%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	01 c1                	add    %eax,%ecx
  802768:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80276b:	89 d0                	mov    %edx,%eax
  80276d:	01 c0                	add    %eax,%eax
  80276f:	01 d0                	add    %edx,%eax
  802771:	c1 e0 02             	shl    $0x2,%eax
  802774:	05 40 10 81 00       	add    $0x811040,%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	39 c1                	cmp    %eax,%ecx
  80277d:	75 7a                	jne    8027f9 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  80277f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802782:	89 d0                	mov    %edx,%eax
  802784:	01 c0                	add    %eax,%eax
  802786:	01 d0                	add    %edx,%eax
  802788:	c1 e0 02             	shl    $0x2,%eax
  80278b:	05 40 10 81 00       	add    $0x811040,%eax
  802790:	8b 10                	mov    (%eax),%edx
  802792:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802795:	89 c8                	mov    %ecx,%eax
  802797:	01 c0                	add    %eax,%eax
  802799:	01 c8                	add    %ecx,%eax
  80279b:	c1 e0 02             	shl    $0x2,%eax
  80279e:	05 40 10 81 00       	add    $0x811040,%eax
  8027a3:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  8027a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027a8:	89 d0                	mov    %edx,%eax
  8027aa:	01 c0                	add    %eax,%eax
  8027ac:	01 d0                	add    %edx,%eax
  8027ae:	c1 e0 02             	shl    $0x2,%eax
  8027b1:	05 44 10 81 00       	add    $0x811044,%eax
  8027b6:	8b 08                	mov    (%eax),%ecx
  8027b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027bb:	89 d0                	mov    %edx,%eax
  8027bd:	01 c0                	add    %eax,%eax
  8027bf:	01 d0                	add    %edx,%eax
  8027c1:	c1 e0 02             	shl    $0x2,%eax
  8027c4:	05 44 10 81 00       	add    $0x811044,%eax
  8027c9:	8b 00                	mov    (%eax),%eax
  8027cb:	01 c1                	add    %eax,%ecx
  8027cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027d0:	89 d0                	mov    %edx,%eax
  8027d2:	01 c0                	add    %eax,%eax
  8027d4:	01 d0                	add    %edx,%eax
  8027d6:	c1 e0 02             	shl    $0x2,%eax
  8027d9:	05 44 10 81 00       	add    $0x811044,%eax
  8027de:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8027e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027e3:	89 d0                	mov    %edx,%eax
  8027e5:	01 c0                	add    %eax,%eax
  8027e7:	01 d0                	add    %edx,%eax
  8027e9:	c1 e0 02             	shl    $0x2,%eax
  8027ec:	05 48 10 81 00       	add    $0x811048,%eax
  8027f1:	c6 00 00             	movb   $0x0,(%eax)
  8027f4:	e9 91 00 00 00       	jmp    80288a <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8027f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027fc:	89 d0                	mov    %edx,%eax
  8027fe:	01 c0                	add    %eax,%eax
  802800:	01 d0                	add    %edx,%eax
  802802:	c1 e0 02             	shl    $0x2,%eax
  802805:	05 40 10 81 00       	add    $0x811040,%eax
  80280a:	8b 08                	mov    (%eax),%ecx
  80280c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80280f:	89 d0                	mov    %edx,%eax
  802811:	01 c0                	add    %eax,%eax
  802813:	01 d0                	add    %edx,%eax
  802815:	c1 e0 02             	shl    $0x2,%eax
  802818:	05 44 10 81 00       	add    $0x811044,%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	01 c1                	add    %eax,%ecx
  802821:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802824:	89 d0                	mov    %edx,%eax
  802826:	01 c0                	add    %eax,%eax
  802828:	01 d0                	add    %edx,%eax
  80282a:	c1 e0 02             	shl    $0x2,%eax
  80282d:	05 40 10 81 00       	add    $0x811040,%eax
  802832:	8b 00                	mov    (%eax),%eax
  802834:	39 c1                	cmp    %eax,%ecx
  802836:	75 52                	jne    80288a <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802838:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80283b:	89 d0                	mov    %edx,%eax
  80283d:	01 c0                	add    %eax,%eax
  80283f:	01 d0                	add    %edx,%eax
  802841:	c1 e0 02             	shl    $0x2,%eax
  802844:	05 44 10 81 00       	add    $0x811044,%eax
  802849:	8b 08                	mov    (%eax),%ecx
  80284b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80284e:	89 d0                	mov    %edx,%eax
  802850:	01 c0                	add    %eax,%eax
  802852:	01 d0                	add    %edx,%eax
  802854:	c1 e0 02             	shl    $0x2,%eax
  802857:	05 44 10 81 00       	add    $0x811044,%eax
  80285c:	8b 00                	mov    (%eax),%eax
  80285e:	01 c1                	add    %eax,%ecx
  802860:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802863:	89 d0                	mov    %edx,%eax
  802865:	01 c0                	add    %eax,%eax
  802867:	01 d0                	add    %edx,%eax
  802869:	c1 e0 02             	shl    $0x2,%eax
  80286c:	05 44 10 81 00       	add    $0x811044,%eax
  802871:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802873:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802876:	89 d0                	mov    %edx,%eax
  802878:	01 c0                	add    %eax,%eax
  80287a:	01 d0                	add    %edx,%eax
  80287c:	c1 e0 02             	shl    $0x2,%eax
  80287f:	05 48 10 81 00       	add    $0x811048,%eax
  802884:	c6 00 00             	movb   $0x0,(%eax)
  802887:	eb 01                	jmp    80288a <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802889:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80288a:	ff 45 e0             	incl   -0x20(%ebp)
  80288d:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802894:	0f 8e 7f fe ff ff    	jle    802719 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  80289a:	a1 30 51 83 00       	mov    0x835130,%eax
  80289f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8028a2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8028a9:	eb 53                	jmp    8028fe <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  8028ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028ae:	89 d0                	mov    %edx,%eax
  8028b0:	01 c0                	add    %eax,%eax
  8028b2:	01 d0                	add    %edx,%eax
  8028b4:	c1 e0 02             	shl    $0x2,%eax
  8028b7:	05 48 50 80 00       	add    $0x805048,%eax
  8028bc:	8a 00                	mov    (%eax),%al
  8028be:	84 c0                	test   %al,%al
  8028c0:	74 39                	je     8028fb <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8028c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028c5:	89 d0                	mov    %edx,%eax
  8028c7:	01 c0                	add    %eax,%eax
  8028c9:	01 d0                	add    %edx,%eax
  8028cb:	c1 e0 02             	shl    $0x2,%eax
  8028ce:	05 40 50 80 00       	add    $0x805040,%eax
  8028d3:	8b 08                	mov    (%eax),%ecx
  8028d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028d8:	89 d0                	mov    %edx,%eax
  8028da:	01 c0                	add    %eax,%eax
  8028dc:	01 d0                	add    %edx,%eax
  8028de:	c1 e0 02             	shl    $0x2,%eax
  8028e1:	05 44 50 80 00       	add    $0x805044,%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	01 c8                	add    %ecx,%eax
  8028ea:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8028ed:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028f0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8028f3:	76 06                	jbe    8028fb <realloc+0x453>
  8028f5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8028fb:	ff 45 d8             	incl   -0x28(%ebp)
  8028fe:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802905:	7e a4                	jle    8028ab <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802907:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80290a:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	e9 a9 01 00 00       	jmp    802ac0 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802917:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	01 d0                	add    %edx,%eax
  80291f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802922:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802929:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802930:	eb 57                	jmp    802989 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802932:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802935:	89 d0                	mov    %edx,%eax
  802937:	01 c0                	add    %eax,%eax
  802939:	01 d0                	add    %edx,%eax
  80293b:	c1 e0 02             	shl    $0x2,%eax
  80293e:	05 48 10 81 00       	add    $0x811048,%eax
  802943:	8a 00                	mov    (%eax),%al
  802945:	84 c0                	test   %al,%al
  802947:	74 3d                	je     802986 <realloc+0x4de>
  802949:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80294c:	89 d0                	mov    %edx,%eax
  80294e:	01 c0                	add    %eax,%eax
  802950:	01 d0                	add    %edx,%eax
  802952:	c1 e0 02             	shl    $0x2,%eax
  802955:	05 40 10 81 00       	add    $0x811040,%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80295f:	75 25                	jne    802986 <realloc+0x4de>
  802961:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802964:	89 d0                	mov    %edx,%eax
  802966:	01 c0                	add    %eax,%eax
  802968:	01 d0                	add    %edx,%eax
  80296a:	c1 e0 02             	shl    $0x2,%eax
  80296d:	05 44 10 81 00       	add    $0x811044,%eax
  802972:	8b 10                	mov    (%eax),%edx
  802974:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802977:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80297a:	39 c2                	cmp    %eax,%edx
  80297c:	72 08                	jb     802986 <realloc+0x4de>
		{
			adjIdx = j; break;
  80297e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802981:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802984:	eb 0c                	jmp    802992 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802986:	ff 45 d0             	incl   -0x30(%ebp)
  802989:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802990:	7e a0                	jle    802932 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802992:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802996:	0f 84 d6 00 00 00    	je     802a72 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  80299c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80299f:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8029a2:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  8029a5:	83 ec 08             	sub    $0x8,%esp
  8029a8:	ff 75 a0             	pushl  -0x60(%ebp)
  8029ab:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029ae:	e8 cf 09 00 00       	call   803382 <sys_allocate_user_mem>
  8029b3:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  8029b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b9:	89 d0                	mov    %edx,%eax
  8029bb:	01 c0                	add    %eax,%eax
  8029bd:	01 d0                	add    %edx,%eax
  8029bf:	c1 e0 02             	shl    $0x2,%eax
  8029c2:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8029c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029cb:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  8029cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029d0:	89 d0                	mov    %edx,%eax
  8029d2:	01 c0                	add    %eax,%eax
  8029d4:	01 d0                	add    %edx,%eax
  8029d6:	c1 e0 02             	shl    $0x2,%eax
  8029d9:	05 40 10 81 00       	add    $0x811040,%eax
  8029de:	8b 10                	mov    (%eax),%edx
  8029e0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8029e3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8029e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029e9:	89 d0                	mov    %edx,%eax
  8029eb:	01 c0                	add    %eax,%eax
  8029ed:	01 d0                	add    %edx,%eax
  8029ef:	c1 e0 02             	shl    $0x2,%eax
  8029f2:	05 40 10 81 00       	add    $0x811040,%eax
  8029f7:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8029f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029fc:	89 d0                	mov    %edx,%eax
  8029fe:	01 c0                	add    %eax,%eax
  802a00:	01 d0                	add    %edx,%eax
  802a02:	c1 e0 02             	shl    $0x2,%eax
  802a05:	05 44 10 81 00       	add    $0x811044,%eax
  802a0a:	8b 00                	mov    (%eax),%eax
  802a0c:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802a0f:	89 c2                	mov    %eax,%edx
  802a11:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802a14:	89 c8                	mov    %ecx,%eax
  802a16:	01 c0                	add    %eax,%eax
  802a18:	01 c8                	add    %ecx,%eax
  802a1a:	c1 e0 02             	shl    $0x2,%eax
  802a1d:	05 44 10 81 00       	add    $0x811044,%eax
  802a22:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802a24:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a27:	89 d0                	mov    %edx,%eax
  802a29:	01 c0                	add    %eax,%eax
  802a2b:	01 d0                	add    %edx,%eax
  802a2d:	c1 e0 02             	shl    $0x2,%eax
  802a30:	05 44 10 81 00       	add    $0x811044,%eax
  802a35:	8b 00                	mov    (%eax),%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	75 14                	jne    802a4f <realloc+0x5a7>
  802a3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a3e:	89 d0                	mov    %edx,%eax
  802a40:	01 c0                	add    %eax,%eax
  802a42:	01 d0                	add    %edx,%eax
  802a44:	c1 e0 02             	shl    $0x2,%eax
  802a47:	05 48 10 81 00       	add    $0x811048,%eax
  802a4c:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802a4f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a52:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a55:	01 c2                	add    %eax,%edx
  802a57:	a1 88 50 83 00       	mov    0x835088,%eax
  802a5c:	39 c2                	cmp    %eax,%edx
  802a5e:	76 0d                	jbe    802a6d <realloc+0x5c5>
  802a60:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a63:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a66:	01 d0                	add    %edx,%eax
  802a68:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	eb 4e                	jmp    802ac0 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802a72:	83 ec 0c             	sub    $0xc,%esp
  802a75:	ff 75 0c             	pushl  0xc(%ebp)
  802a78:	e8 0b ec ff ff       	call   801688 <malloc>
  802a7d:	83 c4 10             	add    $0x10,%esp
  802a80:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802a83:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802a87:	75 07                	jne    802a90 <realloc+0x5e8>
		return NULL;
  802a89:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8e:	eb 30                	jmp    802ac0 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802a90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a93:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a96:	39 d0                	cmp    %edx,%eax
  802a98:	76 02                	jbe    802a9c <realloc+0x5f4>
  802a9a:	89 d0                	mov    %edx,%eax
  802a9c:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802a9f:	83 ec 04             	sub    $0x4,%esp
  802aa2:	50                   	push   %eax
  802aa3:	52                   	push   %edx
  802aa4:	ff 75 cc             	pushl  -0x34(%ebp)
  802aa7:	e8 cf 06 00 00       	call   80317b <sys_move_user_mem>
  802aac:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802aaf:	83 ec 0c             	sub    $0xc,%esp
  802ab2:	ff 75 08             	pushl  0x8(%ebp)
  802ab5:	e8 2e ef ff ff       	call   8019e8 <free>
  802aba:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802abd:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802ac0:	c9                   	leave  
  802ac1:	c3                   	ret    

00802ac2 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802ac2:	55                   	push   %ebp
  802ac3:	89 e5                	mov    %esp,%ebp
  802ac5:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802ace:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ad2:	0f 84 33 03 00 00    	je     802e0b <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802ad8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802adb:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802ae0:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802ae3:	83 ec 08             	sub    $0x8,%esp
  802ae6:	ff 75 08             	pushl  0x8(%ebp)
  802ae9:	ff 75 d8             	pushl  -0x28(%ebp)
  802aec:	e8 7d 05 00 00       	call   80306e <sys_delete_shared_object>
  802af1:	83 c4 10             	add    $0x10,%esp
  802af4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802af7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802afb:	0f 88 0d 03 00 00    	js     802e0e <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b08:	e9 ef 02 00 00       	jmp    802dfc <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b10:	89 d0                	mov    %edx,%eax
  802b12:	01 c0                	add    %eax,%eax
  802b14:	01 d0                	add    %edx,%eax
  802b16:	c1 e0 02             	shl    $0x2,%eax
  802b19:	05 48 50 80 00       	add    $0x805048,%eax
  802b1e:	8a 00                	mov    (%eax),%al
  802b20:	84 c0                	test   %al,%al
  802b22:	0f 84 d1 02 00 00    	je     802df9 <sfree+0x337>
  802b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2b:	89 d0                	mov    %edx,%eax
  802b2d:	01 c0                	add    %eax,%eax
  802b2f:	01 d0                	add    %edx,%eax
  802b31:	c1 e0 02             	shl    $0x2,%eax
  802b34:	05 40 50 80 00       	add    $0x805040,%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802b3e:	0f 85 b5 02 00 00    	jne    802df9 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802b44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b47:	89 d0                	mov    %edx,%eax
  802b49:	01 c0                	add    %eax,%eax
  802b4b:	01 d0                	add    %edx,%eax
  802b4d:	c1 e0 02             	shl    $0x2,%eax
  802b50:	05 44 50 80 00       	add    $0x805044,%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802b5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5d:	89 d0                	mov    %edx,%eax
  802b5f:	01 c0                	add    %eax,%eax
  802b61:	01 d0                	add    %edx,%eax
  802b63:	c1 e0 02             	shl    $0x2,%eax
  802b66:	05 48 50 80 00       	add    $0x805048,%eax
  802b6b:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802b6e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802b7c:	eb 64                	jmp    802be2 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802b7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b81:	89 d0                	mov    %edx,%eax
  802b83:	01 c0                	add    %eax,%eax
  802b85:	01 d0                	add    %edx,%eax
  802b87:	c1 e0 02             	shl    $0x2,%eax
  802b8a:	05 48 10 81 00       	add    $0x811048,%eax
  802b8f:	8a 00                	mov    (%eax),%al
  802b91:	84 c0                	test   %al,%al
  802b93:	75 4a                	jne    802bdf <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802b95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b98:	89 d0                	mov    %edx,%eax
  802b9a:	01 c0                	add    %eax,%eax
  802b9c:	01 d0                	add    %edx,%eax
  802b9e:	c1 e0 02             	shl    $0x2,%eax
  802ba1:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802ba7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802baa:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802bac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802baf:	89 d0                	mov    %edx,%eax
  802bb1:	01 c0                	add    %eax,%eax
  802bb3:	01 d0                	add    %edx,%eax
  802bb5:	c1 e0 02             	shl    $0x2,%eax
  802bb8:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802bbe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bc1:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802bc3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc6:	89 d0                	mov    %edx,%eax
  802bc8:	01 c0                	add    %eax,%eax
  802bca:	01 d0                	add    %edx,%eax
  802bcc:	c1 e0 02             	shl    $0x2,%eax
  802bcf:	05 48 10 81 00       	add    $0x811048,%eax
  802bd4:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802bdd:	eb 0c                	jmp    802beb <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bdf:	ff 45 ec             	incl   -0x14(%ebp)
  802be2:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802be9:	7e 93                	jle    802b7e <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802beb:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802bef:	0f 84 8d 01 00 00    	je     802d82 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802bf5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802bfc:	e9 74 01 00 00       	jmp    802d75 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c07:	0f 84 64 01 00 00    	je     802d71 <sfree+0x2af>
					if (uhp_frees[k].free)
  802c0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c10:	89 d0                	mov    %edx,%eax
  802c12:	01 c0                	add    %eax,%eax
  802c14:	01 d0                	add    %edx,%eax
  802c16:	c1 e0 02             	shl    $0x2,%eax
  802c19:	05 48 10 81 00       	add    $0x811048,%eax
  802c1e:	8a 00                	mov    (%eax),%al
  802c20:	84 c0                	test   %al,%al
  802c22:	0f 84 4a 01 00 00    	je     802d72 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802c28:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c2b:	89 d0                	mov    %edx,%eax
  802c2d:	01 c0                	add    %eax,%eax
  802c2f:	01 d0                	add    %edx,%eax
  802c31:	c1 e0 02             	shl    $0x2,%eax
  802c34:	05 40 10 81 00       	add    $0x811040,%eax
  802c39:	8b 08                	mov    (%eax),%ecx
  802c3b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c3e:	89 d0                	mov    %edx,%eax
  802c40:	01 c0                	add    %eax,%eax
  802c42:	01 d0                	add    %edx,%eax
  802c44:	c1 e0 02             	shl    $0x2,%eax
  802c47:	05 44 10 81 00       	add    $0x811044,%eax
  802c4c:	8b 00                	mov    (%eax),%eax
  802c4e:	01 c1                	add    %eax,%ecx
  802c50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c53:	89 d0                	mov    %edx,%eax
  802c55:	01 c0                	add    %eax,%eax
  802c57:	01 d0                	add    %edx,%eax
  802c59:	c1 e0 02             	shl    $0x2,%eax
  802c5c:	05 40 10 81 00       	add    $0x811040,%eax
  802c61:	8b 00                	mov    (%eax),%eax
  802c63:	39 c1                	cmp    %eax,%ecx
  802c65:	75 7a                	jne    802ce1 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802c67:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c6a:	89 d0                	mov    %edx,%eax
  802c6c:	01 c0                	add    %eax,%eax
  802c6e:	01 d0                	add    %edx,%eax
  802c70:	c1 e0 02             	shl    $0x2,%eax
  802c73:	05 40 10 81 00       	add    $0x811040,%eax
  802c78:	8b 10                	mov    (%eax),%edx
  802c7a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c7d:	89 c8                	mov    %ecx,%eax
  802c7f:	01 c0                	add    %eax,%eax
  802c81:	01 c8                	add    %ecx,%eax
  802c83:	c1 e0 02             	shl    $0x2,%eax
  802c86:	05 40 10 81 00       	add    $0x811040,%eax
  802c8b:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802c8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c90:	89 d0                	mov    %edx,%eax
  802c92:	01 c0                	add    %eax,%eax
  802c94:	01 d0                	add    %edx,%eax
  802c96:	c1 e0 02             	shl    $0x2,%eax
  802c99:	05 44 10 81 00       	add    $0x811044,%eax
  802c9e:	8b 08                	mov    (%eax),%ecx
  802ca0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ca3:	89 d0                	mov    %edx,%eax
  802ca5:	01 c0                	add    %eax,%eax
  802ca7:	01 d0                	add    %edx,%eax
  802ca9:	c1 e0 02             	shl    $0x2,%eax
  802cac:	05 44 10 81 00       	add    $0x811044,%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	01 c1                	add    %eax,%ecx
  802cb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb8:	89 d0                	mov    %edx,%eax
  802cba:	01 c0                	add    %eax,%eax
  802cbc:	01 d0                	add    %edx,%eax
  802cbe:	c1 e0 02             	shl    $0x2,%eax
  802cc1:	05 44 10 81 00       	add    $0x811044,%eax
  802cc6:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802cc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ccb:	89 d0                	mov    %edx,%eax
  802ccd:	01 c0                	add    %eax,%eax
  802ccf:	01 d0                	add    %edx,%eax
  802cd1:	c1 e0 02             	shl    $0x2,%eax
  802cd4:	05 48 10 81 00       	add    $0x811048,%eax
  802cd9:	c6 00 00             	movb   $0x0,(%eax)
  802cdc:	e9 91 00 00 00       	jmp    802d72 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802ce1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce4:	89 d0                	mov    %edx,%eax
  802ce6:	01 c0                	add    %eax,%eax
  802ce8:	01 d0                	add    %edx,%eax
  802cea:	c1 e0 02             	shl    $0x2,%eax
  802ced:	05 40 10 81 00       	add    $0x811040,%eax
  802cf2:	8b 08                	mov    (%eax),%ecx
  802cf4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf7:	89 d0                	mov    %edx,%eax
  802cf9:	01 c0                	add    %eax,%eax
  802cfb:	01 d0                	add    %edx,%eax
  802cfd:	c1 e0 02             	shl    $0x2,%eax
  802d00:	05 44 10 81 00       	add    $0x811044,%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	01 c1                	add    %eax,%ecx
  802d09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d0c:	89 d0                	mov    %edx,%eax
  802d0e:	01 c0                	add    %eax,%eax
  802d10:	01 d0                	add    %edx,%eax
  802d12:	c1 e0 02             	shl    $0x2,%eax
  802d15:	05 40 10 81 00       	add    $0x811040,%eax
  802d1a:	8b 00                	mov    (%eax),%eax
  802d1c:	39 c1                	cmp    %eax,%ecx
  802d1e:	75 52                	jne    802d72 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d23:	89 d0                	mov    %edx,%eax
  802d25:	01 c0                	add    %eax,%eax
  802d27:	01 d0                	add    %edx,%eax
  802d29:	c1 e0 02             	shl    $0x2,%eax
  802d2c:	05 44 10 81 00       	add    $0x811044,%eax
  802d31:	8b 08                	mov    (%eax),%ecx
  802d33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d36:	89 d0                	mov    %edx,%eax
  802d38:	01 c0                	add    %eax,%eax
  802d3a:	01 d0                	add    %edx,%eax
  802d3c:	c1 e0 02             	shl    $0x2,%eax
  802d3f:	05 44 10 81 00       	add    $0x811044,%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	01 c1                	add    %eax,%ecx
  802d48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4b:	89 d0                	mov    %edx,%eax
  802d4d:	01 c0                	add    %eax,%eax
  802d4f:	01 d0                	add    %edx,%eax
  802d51:	c1 e0 02             	shl    $0x2,%eax
  802d54:	05 44 10 81 00       	add    $0x811044,%eax
  802d59:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d5e:	89 d0                	mov    %edx,%eax
  802d60:	01 c0                	add    %eax,%eax
  802d62:	01 d0                	add    %edx,%eax
  802d64:	c1 e0 02             	shl    $0x2,%eax
  802d67:	05 48 10 81 00       	add    $0x811048,%eax
  802d6c:	c6 00 00             	movb   $0x0,(%eax)
  802d6f:	eb 01                	jmp    802d72 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802d71:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802d72:	ff 45 e8             	incl   -0x18(%ebp)
  802d75:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802d7c:	0f 8e 7f fe ff ff    	jle    802c01 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802d82:	a1 30 51 83 00       	mov    0x835130,%eax
  802d87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802d8a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802d91:	eb 53                	jmp    802de6 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802d93:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d96:	89 d0                	mov    %edx,%eax
  802d98:	01 c0                	add    %eax,%eax
  802d9a:	01 d0                	add    %edx,%eax
  802d9c:	c1 e0 02             	shl    $0x2,%eax
  802d9f:	05 48 50 80 00       	add    $0x805048,%eax
  802da4:	8a 00                	mov    (%eax),%al
  802da6:	84 c0                	test   %al,%al
  802da8:	74 39                	je     802de3 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802daa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dad:	89 d0                	mov    %edx,%eax
  802daf:	01 c0                	add    %eax,%eax
  802db1:	01 d0                	add    %edx,%eax
  802db3:	c1 e0 02             	shl    $0x2,%eax
  802db6:	05 40 50 80 00       	add    $0x805040,%eax
  802dbb:	8b 08                	mov    (%eax),%ecx
  802dbd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dc0:	89 d0                	mov    %edx,%eax
  802dc2:	01 c0                	add    %eax,%eax
  802dc4:	01 d0                	add    %edx,%eax
  802dc6:	c1 e0 02             	shl    $0x2,%eax
  802dc9:	05 44 50 80 00       	add    $0x805044,%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	01 c8                	add    %ecx,%eax
  802dd2:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802dd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dd8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ddb:	76 06                	jbe    802de3 <sfree+0x321>
  802ddd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802de0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802de3:	ff 45 e0             	incl   -0x20(%ebp)
  802de6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802ded:	7e a4                	jle    802d93 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802def:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df2:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802df7:	eb 16                	jmp    802e0f <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802df9:	ff 45 f4             	incl   -0xc(%ebp)
  802dfc:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802e03:	0f 8e 04 fd ff ff    	jle    802b0d <sfree+0x4b>
  802e09:	eb 04                	jmp    802e0f <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802e0b:	90                   	nop
  802e0c:	eb 01                	jmp    802e0f <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802e0e:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802e0f:	c9                   	leave  
  802e10:	c3                   	ret    

00802e11 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e11:	55                   	push   %ebp
  802e12:	89 e5                	mov    %esp,%ebp
  802e14:	57                   	push   %edi
  802e15:	56                   	push   %esi
  802e16:	53                   	push   %ebx
  802e17:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e23:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e26:	8b 7d 18             	mov    0x18(%ebp),%edi
  802e29:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802e2c:	cd 30                	int    $0x30
  802e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e34:	83 c4 10             	add    $0x10,%esp
  802e37:	5b                   	pop    %ebx
  802e38:	5e                   	pop    %esi
  802e39:	5f                   	pop    %edi
  802e3a:	5d                   	pop    %ebp
  802e3b:	c3                   	ret    

00802e3c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802e3c:	55                   	push   %ebp
  802e3d:	89 e5                	mov    %esp,%ebp
  802e3f:	83 ec 04             	sub    $0x4,%esp
  802e42:	8b 45 10             	mov    0x10(%ebp),%eax
  802e45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802e48:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e4b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	6a 00                	push   $0x0
  802e54:	51                   	push   %ecx
  802e55:	52                   	push   %edx
  802e56:	ff 75 0c             	pushl  0xc(%ebp)
  802e59:	50                   	push   %eax
  802e5a:	6a 00                	push   $0x0
  802e5c:	e8 b0 ff ff ff       	call   802e11 <syscall>
  802e61:	83 c4 18             	add    $0x18,%esp
}
  802e64:	90                   	nop
  802e65:	c9                   	leave  
  802e66:	c3                   	ret    

00802e67 <sys_cgetc>:

int
sys_cgetc(void)
{
  802e67:	55                   	push   %ebp
  802e68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802e6a:	6a 00                	push   $0x0
  802e6c:	6a 00                	push   $0x0
  802e6e:	6a 00                	push   $0x0
  802e70:	6a 00                	push   $0x0
  802e72:	6a 00                	push   $0x0
  802e74:	6a 02                	push   $0x2
  802e76:	e8 96 ff ff ff       	call   802e11 <syscall>
  802e7b:	83 c4 18             	add    $0x18,%esp
}
  802e7e:	c9                   	leave  
  802e7f:	c3                   	ret    

00802e80 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802e80:	55                   	push   %ebp
  802e81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802e83:	6a 00                	push   $0x0
  802e85:	6a 00                	push   $0x0
  802e87:	6a 00                	push   $0x0
  802e89:	6a 00                	push   $0x0
  802e8b:	6a 00                	push   $0x0
  802e8d:	6a 03                	push   $0x3
  802e8f:	e8 7d ff ff ff       	call   802e11 <syscall>
  802e94:	83 c4 18             	add    $0x18,%esp
}
  802e97:	90                   	nop
  802e98:	c9                   	leave  
  802e99:	c3                   	ret    

00802e9a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802e9a:	55                   	push   %ebp
  802e9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802e9d:	6a 00                	push   $0x0
  802e9f:	6a 00                	push   $0x0
  802ea1:	6a 00                	push   $0x0
  802ea3:	6a 00                	push   $0x0
  802ea5:	6a 00                	push   $0x0
  802ea7:	6a 04                	push   $0x4
  802ea9:	e8 63 ff ff ff       	call   802e11 <syscall>
  802eae:	83 c4 18             	add    $0x18,%esp
}
  802eb1:	90                   	nop
  802eb2:	c9                   	leave  
  802eb3:	c3                   	ret    

00802eb4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802eb4:	55                   	push   %ebp
  802eb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	6a 00                	push   $0x0
  802ebf:	6a 00                	push   $0x0
  802ec1:	6a 00                	push   $0x0
  802ec3:	52                   	push   %edx
  802ec4:	50                   	push   %eax
  802ec5:	6a 08                	push   $0x8
  802ec7:	e8 45 ff ff ff       	call   802e11 <syscall>
  802ecc:	83 c4 18             	add    $0x18,%esp
}
  802ecf:	c9                   	leave  
  802ed0:	c3                   	ret    

00802ed1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ed1:	55                   	push   %ebp
  802ed2:	89 e5                	mov    %esp,%ebp
  802ed4:	56                   	push   %esi
  802ed5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802ed6:	8b 75 18             	mov    0x18(%ebp),%esi
  802ed9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802edc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	56                   	push   %esi
  802ee6:	53                   	push   %ebx
  802ee7:	51                   	push   %ecx
  802ee8:	52                   	push   %edx
  802ee9:	50                   	push   %eax
  802eea:	6a 09                	push   $0x9
  802eec:	e8 20 ff ff ff       	call   802e11 <syscall>
  802ef1:	83 c4 18             	add    $0x18,%esp
}
  802ef4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ef7:	5b                   	pop    %ebx
  802ef8:	5e                   	pop    %esi
  802ef9:	5d                   	pop    %ebp
  802efa:	c3                   	ret    

00802efb <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802efb:	55                   	push   %ebp
  802efc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802efe:	6a 00                	push   $0x0
  802f00:	6a 00                	push   $0x0
  802f02:	6a 00                	push   $0x0
  802f04:	6a 00                	push   $0x0
  802f06:	ff 75 08             	pushl  0x8(%ebp)
  802f09:	6a 0a                	push   $0xa
  802f0b:	e8 01 ff ff ff       	call   802e11 <syscall>
  802f10:	83 c4 18             	add    $0x18,%esp
}
  802f13:	c9                   	leave  
  802f14:	c3                   	ret    

00802f15 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f15:	55                   	push   %ebp
  802f16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f18:	6a 00                	push   $0x0
  802f1a:	6a 00                	push   $0x0
  802f1c:	6a 00                	push   $0x0
  802f1e:	ff 75 0c             	pushl  0xc(%ebp)
  802f21:	ff 75 08             	pushl  0x8(%ebp)
  802f24:	6a 0b                	push   $0xb
  802f26:	e8 e6 fe ff ff       	call   802e11 <syscall>
  802f2b:	83 c4 18             	add    $0x18,%esp
}
  802f2e:	c9                   	leave  
  802f2f:	c3                   	ret    

00802f30 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f30:	55                   	push   %ebp
  802f31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f33:	6a 00                	push   $0x0
  802f35:	6a 00                	push   $0x0
  802f37:	6a 00                	push   $0x0
  802f39:	6a 00                	push   $0x0
  802f3b:	6a 00                	push   $0x0
  802f3d:	6a 0c                	push   $0xc
  802f3f:	e8 cd fe ff ff       	call   802e11 <syscall>
  802f44:	83 c4 18             	add    $0x18,%esp
}
  802f47:	c9                   	leave  
  802f48:	c3                   	ret    

00802f49 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f49:	55                   	push   %ebp
  802f4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	6a 00                	push   $0x0
  802f52:	6a 00                	push   $0x0
  802f54:	6a 00                	push   $0x0
  802f56:	6a 0d                	push   $0xd
  802f58:	e8 b4 fe ff ff       	call   802e11 <syscall>
  802f5d:	83 c4 18             	add    $0x18,%esp
}
  802f60:	c9                   	leave  
  802f61:	c3                   	ret    

00802f62 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802f62:	55                   	push   %ebp
  802f63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802f65:	6a 00                	push   $0x0
  802f67:	6a 00                	push   $0x0
  802f69:	6a 00                	push   $0x0
  802f6b:	6a 00                	push   $0x0
  802f6d:	6a 00                	push   $0x0
  802f6f:	6a 0e                	push   $0xe
  802f71:	e8 9b fe ff ff       	call   802e11 <syscall>
  802f76:	83 c4 18             	add    $0x18,%esp
}
  802f79:	c9                   	leave  
  802f7a:	c3                   	ret    

00802f7b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802f7b:	55                   	push   %ebp
  802f7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	6a 00                	push   $0x0
  802f84:	6a 00                	push   $0x0
  802f86:	6a 00                	push   $0x0
  802f88:	6a 0f                	push   $0xf
  802f8a:	e8 82 fe ff ff       	call   802e11 <syscall>
  802f8f:	83 c4 18             	add    $0x18,%esp
}
  802f92:	c9                   	leave  
  802f93:	c3                   	ret    

00802f94 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802f94:	55                   	push   %ebp
  802f95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802f97:	6a 00                	push   $0x0
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	6a 00                	push   $0x0
  802f9f:	ff 75 08             	pushl  0x8(%ebp)
  802fa2:	6a 10                	push   $0x10
  802fa4:	e8 68 fe ff ff       	call   802e11 <syscall>
  802fa9:	83 c4 18             	add    $0x18,%esp
}
  802fac:	c9                   	leave  
  802fad:	c3                   	ret    

00802fae <sys_scarce_memory>:

void sys_scarce_memory()
{
  802fae:	55                   	push   %ebp
  802faf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	6a 00                	push   $0x0
  802fb9:	6a 00                	push   $0x0
  802fbb:	6a 11                	push   $0x11
  802fbd:	e8 4f fe ff ff       	call   802e11 <syscall>
  802fc2:	83 c4 18             	add    $0x18,%esp
}
  802fc5:	90                   	nop
  802fc6:	c9                   	leave  
  802fc7:	c3                   	ret    

00802fc8 <sys_cputc>:

void
sys_cputc(const char c)
{
  802fc8:	55                   	push   %ebp
  802fc9:	89 e5                	mov    %esp,%ebp
  802fcb:	83 ec 04             	sub    $0x4,%esp
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802fd4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802fd8:	6a 00                	push   $0x0
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	50                   	push   %eax
  802fe1:	6a 01                	push   $0x1
  802fe3:	e8 29 fe ff ff       	call   802e11 <syscall>
  802fe8:	83 c4 18             	add    $0x18,%esp
}
  802feb:	90                   	nop
  802fec:	c9                   	leave  
  802fed:	c3                   	ret    

00802fee <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802fee:	55                   	push   %ebp
  802fef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ff1:	6a 00                	push   $0x0
  802ff3:	6a 00                	push   $0x0
  802ff5:	6a 00                	push   $0x0
  802ff7:	6a 00                	push   $0x0
  802ff9:	6a 00                	push   $0x0
  802ffb:	6a 14                	push   $0x14
  802ffd:	e8 0f fe ff ff       	call   802e11 <syscall>
  803002:	83 c4 18             	add    $0x18,%esp
}
  803005:	90                   	nop
  803006:	c9                   	leave  
  803007:	c3                   	ret    

00803008 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803008:	55                   	push   %ebp
  803009:	89 e5                	mov    %esp,%ebp
  80300b:	83 ec 04             	sub    $0x4,%esp
  80300e:	8b 45 10             	mov    0x10(%ebp),%eax
  803011:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803014:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803017:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	6a 00                	push   $0x0
  803020:	51                   	push   %ecx
  803021:	52                   	push   %edx
  803022:	ff 75 0c             	pushl  0xc(%ebp)
  803025:	50                   	push   %eax
  803026:	6a 15                	push   $0x15
  803028:	e8 e4 fd ff ff       	call   802e11 <syscall>
  80302d:	83 c4 18             	add    $0x18,%esp
}
  803030:	c9                   	leave  
  803031:	c3                   	ret    

00803032 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803032:	55                   	push   %ebp
  803033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803035:	8b 55 0c             	mov    0xc(%ebp),%edx
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	6a 00                	push   $0x0
  80303d:	6a 00                	push   $0x0
  80303f:	6a 00                	push   $0x0
  803041:	52                   	push   %edx
  803042:	50                   	push   %eax
  803043:	6a 16                	push   $0x16
  803045:	e8 c7 fd ff ff       	call   802e11 <syscall>
  80304a:	83 c4 18             	add    $0x18,%esp
}
  80304d:	c9                   	leave  
  80304e:	c3                   	ret    

0080304f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80304f:	55                   	push   %ebp
  803050:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803052:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803055:	8b 55 0c             	mov    0xc(%ebp),%edx
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	6a 00                	push   $0x0
  80305d:	6a 00                	push   $0x0
  80305f:	51                   	push   %ecx
  803060:	52                   	push   %edx
  803061:	50                   	push   %eax
  803062:	6a 17                	push   $0x17
  803064:	e8 a8 fd ff ff       	call   802e11 <syscall>
  803069:	83 c4 18             	add    $0x18,%esp
}
  80306c:	c9                   	leave  
  80306d:	c3                   	ret    

0080306e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80306e:	55                   	push   %ebp
  80306f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803071:	8b 55 0c             	mov    0xc(%ebp),%edx
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	6a 00                	push   $0x0
  803079:	6a 00                	push   $0x0
  80307b:	6a 00                	push   $0x0
  80307d:	52                   	push   %edx
  80307e:	50                   	push   %eax
  80307f:	6a 18                	push   $0x18
  803081:	e8 8b fd ff ff       	call   802e11 <syscall>
  803086:	83 c4 18             	add    $0x18,%esp
}
  803089:	c9                   	leave  
  80308a:	c3                   	ret    

0080308b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80308b:	55                   	push   %ebp
  80308c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	6a 00                	push   $0x0
  803093:	ff 75 14             	pushl  0x14(%ebp)
  803096:	ff 75 10             	pushl  0x10(%ebp)
  803099:	ff 75 0c             	pushl  0xc(%ebp)
  80309c:	50                   	push   %eax
  80309d:	6a 19                	push   $0x19
  80309f:	e8 6d fd ff ff       	call   802e11 <syscall>
  8030a4:	83 c4 18             	add    $0x18,%esp
}
  8030a7:	c9                   	leave  
  8030a8:	c3                   	ret    

008030a9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8030a9:	55                   	push   %ebp
  8030aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	6a 00                	push   $0x0
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	50                   	push   %eax
  8030b8:	6a 1a                	push   $0x1a
  8030ba:	e8 52 fd ff ff       	call   802e11 <syscall>
  8030bf:	83 c4 18             	add    $0x18,%esp
}
  8030c2:	90                   	nop
  8030c3:	c9                   	leave  
  8030c4:	c3                   	ret    

008030c5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8030c5:	55                   	push   %ebp
  8030c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	6a 00                	push   $0x0
  8030cd:	6a 00                	push   $0x0
  8030cf:	6a 00                	push   $0x0
  8030d1:	6a 00                	push   $0x0
  8030d3:	50                   	push   %eax
  8030d4:	6a 1b                	push   $0x1b
  8030d6:	e8 36 fd ff ff       	call   802e11 <syscall>
  8030db:	83 c4 18             	add    $0x18,%esp
}
  8030de:	c9                   	leave  
  8030df:	c3                   	ret    

008030e0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8030e0:	55                   	push   %ebp
  8030e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 00                	push   $0x0
  8030e9:	6a 00                	push   $0x0
  8030eb:	6a 00                	push   $0x0
  8030ed:	6a 05                	push   $0x5
  8030ef:	e8 1d fd ff ff       	call   802e11 <syscall>
  8030f4:	83 c4 18             	add    $0x18,%esp
}
  8030f7:	c9                   	leave  
  8030f8:	c3                   	ret    

008030f9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8030f9:	55                   	push   %ebp
  8030fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8030fc:	6a 00                	push   $0x0
  8030fe:	6a 00                	push   $0x0
  803100:	6a 00                	push   $0x0
  803102:	6a 00                	push   $0x0
  803104:	6a 00                	push   $0x0
  803106:	6a 06                	push   $0x6
  803108:	e8 04 fd ff ff       	call   802e11 <syscall>
  80310d:	83 c4 18             	add    $0x18,%esp
}
  803110:	c9                   	leave  
  803111:	c3                   	ret    

00803112 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803112:	55                   	push   %ebp
  803113:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803115:	6a 00                	push   $0x0
  803117:	6a 00                	push   $0x0
  803119:	6a 00                	push   $0x0
  80311b:	6a 00                	push   $0x0
  80311d:	6a 00                	push   $0x0
  80311f:	6a 07                	push   $0x7
  803121:	e8 eb fc ff ff       	call   802e11 <syscall>
  803126:	83 c4 18             	add    $0x18,%esp
}
  803129:	c9                   	leave  
  80312a:	c3                   	ret    

0080312b <sys_exit_env>:


void sys_exit_env(void)
{
  80312b:	55                   	push   %ebp
  80312c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80312e:	6a 00                	push   $0x0
  803130:	6a 00                	push   $0x0
  803132:	6a 00                	push   $0x0
  803134:	6a 00                	push   $0x0
  803136:	6a 00                	push   $0x0
  803138:	6a 1c                	push   $0x1c
  80313a:	e8 d2 fc ff ff       	call   802e11 <syscall>
  80313f:	83 c4 18             	add    $0x18,%esp
}
  803142:	90                   	nop
  803143:	c9                   	leave  
  803144:	c3                   	ret    

00803145 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803145:	55                   	push   %ebp
  803146:	89 e5                	mov    %esp,%ebp
  803148:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80314b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80314e:	8d 50 04             	lea    0x4(%eax),%edx
  803151:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803154:	6a 00                	push   $0x0
  803156:	6a 00                	push   $0x0
  803158:	6a 00                	push   $0x0
  80315a:	52                   	push   %edx
  80315b:	50                   	push   %eax
  80315c:	6a 1d                	push   $0x1d
  80315e:	e8 ae fc ff ff       	call   802e11 <syscall>
  803163:	83 c4 18             	add    $0x18,%esp
	return result;
  803166:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803169:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80316c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80316f:	89 01                	mov    %eax,(%ecx)
  803171:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	c9                   	leave  
  803178:	c2 04 00             	ret    $0x4

0080317b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80317b:	55                   	push   %ebp
  80317c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80317e:	6a 00                	push   $0x0
  803180:	6a 00                	push   $0x0
  803182:	ff 75 10             	pushl  0x10(%ebp)
  803185:	ff 75 0c             	pushl  0xc(%ebp)
  803188:	ff 75 08             	pushl  0x8(%ebp)
  80318b:	6a 13                	push   $0x13
  80318d:	e8 7f fc ff ff       	call   802e11 <syscall>
  803192:	83 c4 18             	add    $0x18,%esp
	return ;
  803195:	90                   	nop
}
  803196:	c9                   	leave  
  803197:	c3                   	ret    

00803198 <sys_rcr2>:
uint32 sys_rcr2()
{
  803198:	55                   	push   %ebp
  803199:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80319b:	6a 00                	push   $0x0
  80319d:	6a 00                	push   $0x0
  80319f:	6a 00                	push   $0x0
  8031a1:	6a 00                	push   $0x0
  8031a3:	6a 00                	push   $0x0
  8031a5:	6a 1e                	push   $0x1e
  8031a7:	e8 65 fc ff ff       	call   802e11 <syscall>
  8031ac:	83 c4 18             	add    $0x18,%esp
}
  8031af:	c9                   	leave  
  8031b0:	c3                   	ret    

008031b1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8031b1:	55                   	push   %ebp
  8031b2:	89 e5                	mov    %esp,%ebp
  8031b4:	83 ec 04             	sub    $0x4,%esp
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8031bd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8031c1:	6a 00                	push   $0x0
  8031c3:	6a 00                	push   $0x0
  8031c5:	6a 00                	push   $0x0
  8031c7:	6a 00                	push   $0x0
  8031c9:	50                   	push   %eax
  8031ca:	6a 1f                	push   $0x1f
  8031cc:	e8 40 fc ff ff       	call   802e11 <syscall>
  8031d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8031d4:	90                   	nop
}
  8031d5:	c9                   	leave  
  8031d6:	c3                   	ret    

008031d7 <rsttst>:
void rsttst()
{
  8031d7:	55                   	push   %ebp
  8031d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8031da:	6a 00                	push   $0x0
  8031dc:	6a 00                	push   $0x0
  8031de:	6a 00                	push   $0x0
  8031e0:	6a 00                	push   $0x0
  8031e2:	6a 00                	push   $0x0
  8031e4:	6a 21                	push   $0x21
  8031e6:	e8 26 fc ff ff       	call   802e11 <syscall>
  8031eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ee:	90                   	nop
}
  8031ef:	c9                   	leave  
  8031f0:	c3                   	ret    

008031f1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8031f1:	55                   	push   %ebp
  8031f2:	89 e5                	mov    %esp,%ebp
  8031f4:	83 ec 04             	sub    $0x4,%esp
  8031f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8031fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8031fd:	8b 55 18             	mov    0x18(%ebp),%edx
  803200:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803204:	52                   	push   %edx
  803205:	50                   	push   %eax
  803206:	ff 75 10             	pushl  0x10(%ebp)
  803209:	ff 75 0c             	pushl  0xc(%ebp)
  80320c:	ff 75 08             	pushl  0x8(%ebp)
  80320f:	6a 20                	push   $0x20
  803211:	e8 fb fb ff ff       	call   802e11 <syscall>
  803216:	83 c4 18             	add    $0x18,%esp
	return ;
  803219:	90                   	nop
}
  80321a:	c9                   	leave  
  80321b:	c3                   	ret    

0080321c <chktst>:
void chktst(uint32 n)
{
  80321c:	55                   	push   %ebp
  80321d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80321f:	6a 00                	push   $0x0
  803221:	6a 00                	push   $0x0
  803223:	6a 00                	push   $0x0
  803225:	6a 00                	push   $0x0
  803227:	ff 75 08             	pushl  0x8(%ebp)
  80322a:	6a 22                	push   $0x22
  80322c:	e8 e0 fb ff ff       	call   802e11 <syscall>
  803231:	83 c4 18             	add    $0x18,%esp
	return ;
  803234:	90                   	nop
}
  803235:	c9                   	leave  
  803236:	c3                   	ret    

00803237 <inctst>:

void inctst()
{
  803237:	55                   	push   %ebp
  803238:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 00                	push   $0x0
  803240:	6a 00                	push   $0x0
  803242:	6a 00                	push   $0x0
  803244:	6a 23                	push   $0x23
  803246:	e8 c6 fb ff ff       	call   802e11 <syscall>
  80324b:	83 c4 18             	add    $0x18,%esp
	return ;
  80324e:	90                   	nop
}
  80324f:	c9                   	leave  
  803250:	c3                   	ret    

00803251 <gettst>:
uint32 gettst()
{
  803251:	55                   	push   %ebp
  803252:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803254:	6a 00                	push   $0x0
  803256:	6a 00                	push   $0x0
  803258:	6a 00                	push   $0x0
  80325a:	6a 00                	push   $0x0
  80325c:	6a 00                	push   $0x0
  80325e:	6a 24                	push   $0x24
  803260:	e8 ac fb ff ff       	call   802e11 <syscall>
  803265:	83 c4 18             	add    $0x18,%esp
}
  803268:	c9                   	leave  
  803269:	c3                   	ret    

0080326a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80326a:	55                   	push   %ebp
  80326b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80326d:	6a 00                	push   $0x0
  80326f:	6a 00                	push   $0x0
  803271:	6a 00                	push   $0x0
  803273:	6a 00                	push   $0x0
  803275:	6a 00                	push   $0x0
  803277:	6a 25                	push   $0x25
  803279:	e8 93 fb ff ff       	call   802e11 <syscall>
  80327e:	83 c4 18             	add    $0x18,%esp
  803281:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803286:	a1 80 50 83 00       	mov    0x835080,%eax
}
  80328b:	c9                   	leave  
  80328c:	c3                   	ret    

0080328d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80328d:	55                   	push   %ebp
  80328e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803298:	6a 00                	push   $0x0
  80329a:	6a 00                	push   $0x0
  80329c:	6a 00                	push   $0x0
  80329e:	6a 00                	push   $0x0
  8032a0:	ff 75 08             	pushl  0x8(%ebp)
  8032a3:	6a 26                	push   $0x26
  8032a5:	e8 67 fb ff ff       	call   802e11 <syscall>
  8032aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8032ad:	90                   	nop
}
  8032ae:	c9                   	leave  
  8032af:	c3                   	ret    

008032b0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8032b0:	55                   	push   %ebp
  8032b1:	89 e5                	mov    %esp,%ebp
  8032b3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8032b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c0:	6a 00                	push   $0x0
  8032c2:	53                   	push   %ebx
  8032c3:	51                   	push   %ecx
  8032c4:	52                   	push   %edx
  8032c5:	50                   	push   %eax
  8032c6:	6a 27                	push   $0x27
  8032c8:	e8 44 fb ff ff       	call   802e11 <syscall>
  8032cd:	83 c4 18             	add    $0x18,%esp
}
  8032d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032d3:	c9                   	leave  
  8032d4:	c3                   	ret    

008032d5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8032d5:	55                   	push   %ebp
  8032d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8032d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	6a 00                	push   $0x0
  8032e0:	6a 00                	push   $0x0
  8032e2:	6a 00                	push   $0x0
  8032e4:	52                   	push   %edx
  8032e5:	50                   	push   %eax
  8032e6:	6a 28                	push   $0x28
  8032e8:	e8 24 fb ff ff       	call   802e11 <syscall>
  8032ed:	83 c4 18             	add    $0x18,%esp
}
  8032f0:	c9                   	leave  
  8032f1:	c3                   	ret    

008032f2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8032f2:	55                   	push   %ebp
  8032f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8032f5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8032f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	6a 00                	push   $0x0
  803300:	51                   	push   %ecx
  803301:	ff 75 10             	pushl  0x10(%ebp)
  803304:	52                   	push   %edx
  803305:	50                   	push   %eax
  803306:	6a 29                	push   $0x29
  803308:	e8 04 fb ff ff       	call   802e11 <syscall>
  80330d:	83 c4 18             	add    $0x18,%esp
}
  803310:	c9                   	leave  
  803311:	c3                   	ret    

00803312 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803312:	55                   	push   %ebp
  803313:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803315:	6a 00                	push   $0x0
  803317:	6a 00                	push   $0x0
  803319:	ff 75 10             	pushl  0x10(%ebp)
  80331c:	ff 75 0c             	pushl  0xc(%ebp)
  80331f:	ff 75 08             	pushl  0x8(%ebp)
  803322:	6a 12                	push   $0x12
  803324:	e8 e8 fa ff ff       	call   802e11 <syscall>
  803329:	83 c4 18             	add    $0x18,%esp
	return ;
  80332c:	90                   	nop
}
  80332d:	c9                   	leave  
  80332e:	c3                   	ret    

0080332f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80332f:	55                   	push   %ebp
  803330:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803332:	8b 55 0c             	mov    0xc(%ebp),%edx
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	6a 00                	push   $0x0
  80333a:	6a 00                	push   $0x0
  80333c:	6a 00                	push   $0x0
  80333e:	52                   	push   %edx
  80333f:	50                   	push   %eax
  803340:	6a 2a                	push   $0x2a
  803342:	e8 ca fa ff ff       	call   802e11 <syscall>
  803347:	83 c4 18             	add    $0x18,%esp
	return;
  80334a:	90                   	nop
}
  80334b:	c9                   	leave  
  80334c:	c3                   	ret    

0080334d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80334d:	55                   	push   %ebp
  80334e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803350:	6a 00                	push   $0x0
  803352:	6a 00                	push   $0x0
  803354:	6a 00                	push   $0x0
  803356:	6a 00                	push   $0x0
  803358:	6a 00                	push   $0x0
  80335a:	6a 2b                	push   $0x2b
  80335c:	e8 b0 fa ff ff       	call   802e11 <syscall>
  803361:	83 c4 18             	add    $0x18,%esp
}
  803364:	c9                   	leave  
  803365:	c3                   	ret    

00803366 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803366:	55                   	push   %ebp
  803367:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803369:	6a 00                	push   $0x0
  80336b:	6a 00                	push   $0x0
  80336d:	6a 00                	push   $0x0
  80336f:	ff 75 0c             	pushl  0xc(%ebp)
  803372:	ff 75 08             	pushl  0x8(%ebp)
  803375:	6a 2d                	push   $0x2d
  803377:	e8 95 fa ff ff       	call   802e11 <syscall>
  80337c:	83 c4 18             	add    $0x18,%esp
	return;
  80337f:	90                   	nop
}
  803380:	c9                   	leave  
  803381:	c3                   	ret    

00803382 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803382:	55                   	push   %ebp
  803383:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803385:	6a 00                	push   $0x0
  803387:	6a 00                	push   $0x0
  803389:	6a 00                	push   $0x0
  80338b:	ff 75 0c             	pushl  0xc(%ebp)
  80338e:	ff 75 08             	pushl  0x8(%ebp)
  803391:	6a 2c                	push   $0x2c
  803393:	e8 79 fa ff ff       	call   802e11 <syscall>
  803398:	83 c4 18             	add    $0x18,%esp
	return ;
  80339b:	90                   	nop
}
  80339c:	c9                   	leave  
  80339d:	c3                   	ret    

0080339e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80339e:	55                   	push   %ebp
  80339f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8033a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	6a 00                	push   $0x0
  8033a9:	6a 00                	push   $0x0
  8033ab:	6a 00                	push   $0x0
  8033ad:	52                   	push   %edx
  8033ae:	50                   	push   %eax
  8033af:	6a 2e                	push   $0x2e
  8033b1:	e8 5b fa ff ff       	call   802e11 <syscall>
  8033b6:	83 c4 18             	add    $0x18,%esp
}
  8033b9:	90                   	nop
  8033ba:	c9                   	leave  
  8033bb:	c3                   	ret    

008033bc <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8033bc:	55                   	push   %ebp
  8033bd:	89 e5                	mov    %esp,%ebp
  8033bf:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8033c2:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  8033c9:	72 09                	jb     8033d4 <to_page_va+0x18>
  8033cb:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  8033d2:	72 14                	jb     8033e8 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8033d4:	83 ec 04             	sub    $0x4,%esp
  8033d7:	68 b8 48 80 00       	push   $0x8048b8
  8033dc:	6a 15                	push   $0x15
  8033de:	68 e3 48 80 00       	push   $0x8048e3
  8033e3:	e8 10 d0 ff ff       	call   8003f8 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8033f0:	29 d0                	sub    %edx,%eax
  8033f2:	c1 f8 02             	sar    $0x2,%eax
  8033f5:	89 c2                	mov    %eax,%edx
  8033f7:	89 d0                	mov    %edx,%eax
  8033f9:	c1 e0 02             	shl    $0x2,%eax
  8033fc:	01 d0                	add    %edx,%eax
  8033fe:	c1 e0 02             	shl    $0x2,%eax
  803401:	01 d0                	add    %edx,%eax
  803403:	c1 e0 02             	shl    $0x2,%eax
  803406:	01 d0                	add    %edx,%eax
  803408:	89 c1                	mov    %eax,%ecx
  80340a:	c1 e1 08             	shl    $0x8,%ecx
  80340d:	01 c8                	add    %ecx,%eax
  80340f:	89 c1                	mov    %eax,%ecx
  803411:	c1 e1 10             	shl    $0x10,%ecx
  803414:	01 c8                	add    %ecx,%eax
  803416:	01 c0                	add    %eax,%eax
  803418:	01 d0                	add    %edx,%eax
  80341a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80341d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803420:	c1 e0 0c             	shl    $0xc,%eax
  803423:	89 c2                	mov    %eax,%edx
  803425:	a1 84 50 83 00       	mov    0x835084,%eax
  80342a:	01 d0                	add    %edx,%eax
}
  80342c:	c9                   	leave  
  80342d:	c3                   	ret    

0080342e <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80342e:	55                   	push   %ebp
  80342f:	89 e5                	mov    %esp,%ebp
  803431:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803434:	a1 84 50 83 00       	mov    0x835084,%eax
  803439:	8b 55 08             	mov    0x8(%ebp),%edx
  80343c:	29 c2                	sub    %eax,%edx
  80343e:	89 d0                	mov    %edx,%eax
  803440:	c1 e8 0c             	shr    $0xc,%eax
  803443:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803446:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344a:	78 09                	js     803455 <to_page_info+0x27>
  80344c:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803453:	7e 14                	jle    803469 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803455:	83 ec 04             	sub    $0x4,%esp
  803458:	68 fc 48 80 00       	push   $0x8048fc
  80345d:	6a 21                	push   $0x21
  80345f:	68 e3 48 80 00       	push   $0x8048e3
  803464:	e8 8f cf ff ff       	call   8003f8 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803469:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80346c:	89 d0                	mov    %edx,%eax
  80346e:	01 c0                	add    %eax,%eax
  803470:	01 d0                	add    %edx,%eax
  803472:	c1 e0 02             	shl    $0x2,%eax
  803475:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  80347a:	c9                   	leave  
  80347b:	c3                   	ret    

0080347c <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80347c:	55                   	push   %ebp
  80347d:	89 e5                	mov    %esp,%ebp
  80347f:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803482:	8b 45 08             	mov    0x8(%ebp),%eax
  803485:	05 00 00 00 02       	add    $0x2000000,%eax
  80348a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80348d:	73 16                	jae    8034a5 <initialize_dynamic_allocator+0x29>
  80348f:	68 20 49 80 00       	push   $0x804920
  803494:	68 46 49 80 00       	push   $0x804946
  803499:	6a 2f                	push   $0x2f
  80349b:	68 e3 48 80 00       	push   $0x8048e3
  8034a0:	e8 53 cf ff ff       	call   8003f8 <_panic>
	dynAllocStart = daStart;
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  8034ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b0:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8034b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034bc:	eb 36                	jmp    8034f4 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8034be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c1:	c1 e0 04             	shl    $0x4,%eax
  8034c4:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8034c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d2:	c1 e0 04             	shl    $0x4,%eax
  8034d5:	05 a4 50 83 00       	add    $0x8350a4,%eax
  8034da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e3:	c1 e0 04             	shl    $0x4,%eax
  8034e6:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8034eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8034f1:	ff 45 f4             	incl   -0xc(%ebp)
  8034f4:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8034f8:	7e c4                	jle    8034be <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8034fa:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  803501:	00 00 00 
  803504:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  80350b:	00 00 00 
  80350e:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  803515:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803518:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80351f:	e9 1b 01 00 00       	jmp    80363f <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803524:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803527:	89 d0                	mov    %edx,%eax
  803529:	01 c0                	add    %eax,%eax
  80352b:	01 d0                	add    %edx,%eax
  80352d:	c1 e0 02             	shl    $0x2,%eax
  803530:	05 88 d0 81 00       	add    $0x81d088,%eax
  803535:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  80353a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353d:	89 d0                	mov    %edx,%eax
  80353f:	01 c0                	add    %eax,%eax
  803541:	01 d0                	add    %edx,%eax
  803543:	c1 e0 02             	shl    $0x2,%eax
  803546:	05 8a d0 81 00       	add    $0x81d08a,%eax
  80354b:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803550:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803553:	89 d0                	mov    %edx,%eax
  803555:	01 c0                	add    %eax,%eax
  803557:	01 d0                	add    %edx,%eax
  803559:	c1 e0 02             	shl    $0x2,%eax
  80355c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803561:	8b 00                	mov    (%eax),%eax
  803563:	85 c0                	test   %eax,%eax
  803565:	74 2b                	je     803592 <initialize_dynamic_allocator+0x116>
  803567:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80356a:	89 d0                	mov    %edx,%eax
  80356c:	01 c0                	add    %eax,%eax
  80356e:	01 d0                	add    %edx,%eax
  803570:	c1 e0 02             	shl    $0x2,%eax
  803573:	05 80 d0 81 00       	add    $0x81d080,%eax
  803578:	8b 10                	mov    (%eax),%edx
  80357a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80357d:	89 c8                	mov    %ecx,%eax
  80357f:	01 c0                	add    %eax,%eax
  803581:	01 c8                	add    %ecx,%eax
  803583:	c1 e0 02             	shl    $0x2,%eax
  803586:	05 84 d0 81 00       	add    $0x81d084,%eax
  80358b:	8b 00                	mov    (%eax),%eax
  80358d:	89 42 04             	mov    %eax,0x4(%edx)
  803590:	eb 18                	jmp    8035aa <initialize_dynamic_allocator+0x12e>
  803592:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803595:	89 d0                	mov    %edx,%eax
  803597:	01 c0                	add    %eax,%eax
  803599:	01 d0                	add    %edx,%eax
  80359b:	c1 e0 02             	shl    $0x2,%eax
  80359e:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035a3:	8b 00                	mov    (%eax),%eax
  8035a5:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8035aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ad:	89 d0                	mov    %edx,%eax
  8035af:	01 c0                	add    %eax,%eax
  8035b1:	01 d0                	add    %edx,%eax
  8035b3:	c1 e0 02             	shl    $0x2,%eax
  8035b6:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035bb:	8b 00                	mov    (%eax),%eax
  8035bd:	85 c0                	test   %eax,%eax
  8035bf:	74 2a                	je     8035eb <initialize_dynamic_allocator+0x16f>
  8035c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035c4:	89 d0                	mov    %edx,%eax
  8035c6:	01 c0                	add    %eax,%eax
  8035c8:	01 d0                	add    %edx,%eax
  8035ca:	c1 e0 02             	shl    $0x2,%eax
  8035cd:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035d2:	8b 10                	mov    (%eax),%edx
  8035d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8035d7:	89 c8                	mov    %ecx,%eax
  8035d9:	01 c0                	add    %eax,%eax
  8035db:	01 c8                	add    %ecx,%eax
  8035dd:	c1 e0 02             	shl    $0x2,%eax
  8035e0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035e5:	8b 00                	mov    (%eax),%eax
  8035e7:	89 02                	mov    %eax,(%edx)
  8035e9:	eb 18                	jmp    803603 <initialize_dynamic_allocator+0x187>
  8035eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ee:	89 d0                	mov    %edx,%eax
  8035f0:	01 c0                	add    %eax,%eax
  8035f2:	01 d0                	add    %edx,%eax
  8035f4:	c1 e0 02             	shl    $0x2,%eax
  8035f7:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035fc:	8b 00                	mov    (%eax),%eax
  8035fe:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803603:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803606:	89 d0                	mov    %edx,%eax
  803608:	01 c0                	add    %eax,%eax
  80360a:	01 d0                	add    %edx,%eax
  80360c:	c1 e0 02             	shl    $0x2,%eax
  80360f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803614:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80361a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80361d:	89 d0                	mov    %edx,%eax
  80361f:	01 c0                	add    %eax,%eax
  803621:	01 d0                	add    %edx,%eax
  803623:	c1 e0 02             	shl    $0x2,%eax
  803626:	05 84 d0 81 00       	add    $0x81d084,%eax
  80362b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803631:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803636:	48                   	dec    %eax
  803637:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80363c:	ff 45 f0             	incl   -0x10(%ebp)
  80363f:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803646:	0f 8e d8 fe ff ff    	jle    803524 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80364c:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803653:	e9 9d 00 00 00       	jmp    8036f5 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803658:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80365e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803661:	89 c8                	mov    %ecx,%eax
  803663:	01 c0                	add    %eax,%eax
  803665:	01 c8                	add    %ecx,%eax
  803667:	c1 e0 02             	shl    $0x2,%eax
  80366a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80366f:	89 10                	mov    %edx,(%eax)
  803671:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803674:	89 d0                	mov    %edx,%eax
  803676:	01 c0                	add    %eax,%eax
  803678:	01 d0                	add    %edx,%eax
  80367a:	c1 e0 02             	shl    $0x2,%eax
  80367d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803682:	8b 00                	mov    (%eax),%eax
  803684:	85 c0                	test   %eax,%eax
  803686:	74 1c                	je     8036a4 <initialize_dynamic_allocator+0x228>
  803688:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80368e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803691:	89 c8                	mov    %ecx,%eax
  803693:	01 c0                	add    %eax,%eax
  803695:	01 c8                	add    %ecx,%eax
  803697:	c1 e0 02             	shl    $0x2,%eax
  80369a:	05 80 d0 81 00       	add    $0x81d080,%eax
  80369f:	89 42 04             	mov    %eax,0x4(%edx)
  8036a2:	eb 16                	jmp    8036ba <initialize_dynamic_allocator+0x23e>
  8036a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036a7:	89 d0                	mov    %edx,%eax
  8036a9:	01 c0                	add    %eax,%eax
  8036ab:	01 d0                	add    %edx,%eax
  8036ad:	c1 e0 02             	shl    $0x2,%eax
  8036b0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036b5:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8036ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036bd:	89 d0                	mov    %edx,%eax
  8036bf:	01 c0                	add    %eax,%eax
  8036c1:	01 d0                	add    %edx,%eax
  8036c3:	c1 e0 02             	shl    $0x2,%eax
  8036c6:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036cb:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8036d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036d3:	89 d0                	mov    %edx,%eax
  8036d5:	01 c0                	add    %eax,%eax
  8036d7:	01 d0                	add    %edx,%eax
  8036d9:	c1 e0 02             	shl    $0x2,%eax
  8036dc:	05 84 d0 81 00       	add    $0x81d084,%eax
  8036e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e7:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8036ec:	40                   	inc    %eax
  8036ed:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8036f2:	ff 4d ec             	decl   -0x14(%ebp)
  8036f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036f9:	0f 89 59 ff ff ff    	jns    803658 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8036ff:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803706:	00 00 00 
}
  803709:	90                   	nop
  80370a:	c9                   	leave  
  80370b:	c3                   	ret    

0080370c <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80370c:	55                   	push   %ebp
  80370d:	89 e5                	mov    %esp,%ebp
  80370f:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803712:	8b 45 08             	mov    0x8(%ebp),%eax
  803715:	83 ec 0c             	sub    $0xc,%esp
  803718:	50                   	push   %eax
  803719:	e8 10 fd ff ff       	call   80342e <to_page_info>
  80371e:	83 c4 10             	add    $0x10,%esp
  803721:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803727:	8b 40 08             	mov    0x8(%eax),%eax
  80372a:	0f b7 c0             	movzwl %ax,%eax
}
  80372d:	c9                   	leave  
  80372e:	c3                   	ret    

0080372f <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80372f:	55                   	push   %ebp
  803730:	89 e5                	mov    %esp,%ebp
  803732:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803735:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80373c:	76 16                	jbe    803754 <alloc_block+0x25>
  80373e:	68 5c 49 80 00       	push   $0x80495c
  803743:	68 46 49 80 00       	push   $0x804946
  803748:	6a 59                	push   $0x59
  80374a:	68 e3 48 80 00       	push   $0x8048e3
  80374f:	e8 a4 cc ff ff       	call   8003f8 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803754:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80375b:	eb 08                	jmp    803765 <alloc_block+0x36>
		allocSize <<= 1;
  80375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803760:	01 c0                	add    %eax,%eax
  803762:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803768:	3b 45 08             	cmp    0x8(%ebp),%eax
  80376b:	73 09                	jae    803776 <alloc_block+0x47>
  80376d:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803774:	76 e7                	jbe    80375d <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803776:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80377d:	eb 03                	jmp    803782 <alloc_block+0x53>
		listIndex++;
  80377f:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803785:	ba 08 00 00 00       	mov    $0x8,%edx
  80378a:	88 c1                	mov    %al,%cl
  80378c:	d3 e2                	shl    %cl,%edx
  80378e:	89 d0                	mov    %edx,%eax
  803790:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803793:	72 ea                	jb     80377f <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803798:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80379b:	e9 f4 00 00 00       	jmp    803894 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8037a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a3:	c1 e0 04             	shl    $0x4,%eax
  8037a6:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8037ab:	8b 00                	mov    (%eax),%eax
  8037ad:	85 c0                	test   %eax,%eax
  8037af:	0f 84 dc 00 00 00    	je     803891 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8037b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b8:	c1 e0 04             	shl    $0x4,%eax
  8037bb:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8037c0:	8b 00                	mov    (%eax),%eax
  8037c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  8037c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037c9:	75 14                	jne    8037df <alloc_block+0xb0>
  8037cb:	83 ec 04             	sub    $0x4,%esp
  8037ce:	68 7d 49 80 00       	push   $0x80497d
  8037d3:	6a 6b                	push   $0x6b
  8037d5:	68 e3 48 80 00       	push   $0x8048e3
  8037da:	e8 19 cc ff ff       	call   8003f8 <_panic>
  8037df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	85 c0                	test   %eax,%eax
  8037e6:	74 10                	je     8037f8 <alloc_block+0xc9>
  8037e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037eb:	8b 00                	mov    (%eax),%eax
  8037ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037f0:	8b 52 04             	mov    0x4(%edx),%edx
  8037f3:	89 50 04             	mov    %edx,0x4(%eax)
  8037f6:	eb 14                	jmp    80380c <alloc_block+0xdd>
  8037f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fb:	8b 40 04             	mov    0x4(%eax),%eax
  8037fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803801:	c1 e2 04             	shl    $0x4,%edx
  803804:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  80380a:	89 02                	mov    %eax,(%edx)
  80380c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380f:	8b 40 04             	mov    0x4(%eax),%eax
  803812:	85 c0                	test   %eax,%eax
  803814:	74 0f                	je     803825 <alloc_block+0xf6>
  803816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803819:	8b 40 04             	mov    0x4(%eax),%eax
  80381c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80381f:	8b 12                	mov    (%edx),%edx
  803821:	89 10                	mov    %edx,(%eax)
  803823:	eb 13                	jmp    803838 <alloc_block+0x109>
  803825:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803828:	8b 00                	mov    (%eax),%eax
  80382a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80382d:	c1 e2 04             	shl    $0x4,%edx
  803830:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803836:	89 02                	mov    %eax,(%edx)
  803838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803844:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80384b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80384e:	c1 e0 04             	shl    $0x4,%eax
  803851:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	8d 50 ff             	lea    -0x1(%eax),%edx
  80385b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385e:	c1 e0 04             	shl    $0x4,%eax
  803861:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803866:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386b:	83 ec 0c             	sub    $0xc,%esp
  80386e:	50                   	push   %eax
  80386f:	e8 ba fb ff ff       	call   80342e <to_page_info>
  803874:	83 c4 10             	add    $0x10,%esp
  803877:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  80387a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80387d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803881:	48                   	dec    %eax
  803882:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803885:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388c:	e9 8f 02 00 00       	jmp    803b20 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803891:	ff 45 ec             	incl   -0x14(%ebp)
  803894:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803898:	0f 8e 02 ff ff ff    	jle    8037a0 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  80389e:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8038a3:	85 c0                	test   %eax,%eax
  8038a5:	75 14                	jne    8038bb <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  8038a7:	83 ec 04             	sub    $0x4,%esp
  8038aa:	68 9c 49 80 00       	push   $0x80499c
  8038af:	6a 77                	push   $0x77
  8038b1:	68 e3 48 80 00       	push   $0x8048e3
  8038b6:	e8 3d cb ff ff       	call   8003f8 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  8038bb:	a1 68 d0 81 00       	mov    0x81d068,%eax
  8038c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  8038c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038c7:	75 14                	jne    8038dd <alloc_block+0x1ae>
  8038c9:	83 ec 04             	sub    $0x4,%esp
  8038cc:	68 7d 49 80 00       	push   $0x80497d
  8038d1:	6a 7a                	push   $0x7a
  8038d3:	68 e3 48 80 00       	push   $0x8048e3
  8038d8:	e8 1b cb ff ff       	call   8003f8 <_panic>
  8038dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038e0:	8b 00                	mov    (%eax),%eax
  8038e2:	85 c0                	test   %eax,%eax
  8038e4:	74 10                	je     8038f6 <alloc_block+0x1c7>
  8038e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038e9:	8b 00                	mov    (%eax),%eax
  8038eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038ee:	8b 52 04             	mov    0x4(%edx),%edx
  8038f1:	89 50 04             	mov    %edx,0x4(%eax)
  8038f4:	eb 0b                	jmp    803901 <alloc_block+0x1d2>
  8038f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038f9:	8b 40 04             	mov    0x4(%eax),%eax
  8038fc:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803901:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803904:	8b 40 04             	mov    0x4(%eax),%eax
  803907:	85 c0                	test   %eax,%eax
  803909:	74 0f                	je     80391a <alloc_block+0x1eb>
  80390b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80390e:	8b 40 04             	mov    0x4(%eax),%eax
  803911:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803914:	8b 12                	mov    (%edx),%edx
  803916:	89 10                	mov    %edx,(%eax)
  803918:	eb 0a                	jmp    803924 <alloc_block+0x1f5>
  80391a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803924:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803927:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80392d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803930:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803937:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80393c:	48                   	dec    %eax
  80393d:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803942:	83 ec 0c             	sub    $0xc,%esp
  803945:	ff 75 dc             	pushl  -0x24(%ebp)
  803948:	e8 6f fa ff ff       	call   8033bc <to_page_va>
  80394d:	83 c4 10             	add    $0x10,%esp
  803950:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803953:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803956:	83 ec 0c             	sub    $0xc,%esp
  803959:	50                   	push   %eax
  80395a:	e8 a0 dc ff ff       	call   8015ff <get_page>
  80395f:	83 c4 10             	add    $0x10,%esp
  803962:	85 c0                	test   %eax,%eax
  803964:	74 14                	je     80397a <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803966:	83 ec 04             	sub    $0x4,%esp
  803969:	68 c4 49 80 00       	push   $0x8049c4
  80396e:	6a 7f                	push   $0x7f
  803970:	68 e3 48 80 00       	push   $0x8048e3
  803975:	e8 7e ca ff ff       	call   8003f8 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  80397a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803980:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803984:	b8 00 10 00 00       	mov    $0x1000,%eax
  803989:	ba 00 00 00 00       	mov    $0x0,%edx
  80398e:	f7 75 f4             	divl   -0xc(%ebp)
  803991:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803994:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803998:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80399f:	e9 a7 00 00 00       	jmp    803a4b <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  8039a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039aa:	01 d0                	add    %edx,%eax
  8039ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  8039af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039b3:	75 17                	jne    8039cc <alloc_block+0x29d>
  8039b5:	83 ec 04             	sub    $0x4,%esp
  8039b8:	68 ec 49 80 00       	push   $0x8049ec
  8039bd:	68 88 00 00 00       	push   $0x88
  8039c2:	68 e3 48 80 00       	push   $0x8048e3
  8039c7:	e8 2c ca ff ff       	call   8003f8 <_panic>
  8039cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039cf:	c1 e0 04             	shl    $0x4,%eax
  8039d2:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8039d7:	8b 10                	mov    (%eax),%edx
  8039d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039dc:	89 10                	mov    %edx,(%eax)
  8039de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039e1:	8b 00                	mov    (%eax),%eax
  8039e3:	85 c0                	test   %eax,%eax
  8039e5:	74 15                	je     8039fc <alloc_block+0x2cd>
  8039e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ea:	c1 e0 04             	shl    $0x4,%eax
  8039ed:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8039f2:	8b 00                	mov    (%eax),%eax
  8039f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039f7:	89 50 04             	mov    %edx,0x4(%eax)
  8039fa:	eb 11                	jmp    803a0d <alloc_block+0x2de>
  8039fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ff:	c1 e0 04             	shl    $0x4,%eax
  803a02:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803a08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a0b:	89 02                	mov    %eax,(%edx)
  803a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a10:	c1 e0 04             	shl    $0x4,%eax
  803a13:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803a19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a1c:	89 02                	mov    %eax,(%edx)
  803a1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a2b:	c1 e0 04             	shl    $0x4,%eax
  803a2e:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a33:	8b 00                	mov    (%eax),%eax
  803a35:	8d 50 01             	lea    0x1(%eax),%edx
  803a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3b:	c1 e0 04             	shl    $0x4,%eax
  803a3e:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803a43:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a48:	01 45 e8             	add    %eax,-0x18(%ebp)
  803a4b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803a52:	0f 86 4c ff ff ff    	jbe    8039a4 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5b:	c1 e0 04             	shl    $0x4,%eax
  803a5e:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a63:	8b 00                	mov    (%eax),%eax
  803a65:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803a68:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a6c:	75 17                	jne    803a85 <alloc_block+0x356>
  803a6e:	83 ec 04             	sub    $0x4,%esp
  803a71:	68 7d 49 80 00       	push   $0x80497d
  803a76:	68 8d 00 00 00       	push   $0x8d
  803a7b:	68 e3 48 80 00       	push   $0x8048e3
  803a80:	e8 73 c9 ff ff       	call   8003f8 <_panic>
  803a85:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a88:	8b 00                	mov    (%eax),%eax
  803a8a:	85 c0                	test   %eax,%eax
  803a8c:	74 10                	je     803a9e <alloc_block+0x36f>
  803a8e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a91:	8b 00                	mov    (%eax),%eax
  803a93:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803a96:	8b 52 04             	mov    0x4(%edx),%edx
  803a99:	89 50 04             	mov    %edx,0x4(%eax)
  803a9c:	eb 14                	jmp    803ab2 <alloc_block+0x383>
  803a9e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803aa1:	8b 40 04             	mov    0x4(%eax),%eax
  803aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803aa7:	c1 e2 04             	shl    $0x4,%edx
  803aaa:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803ab0:	89 02                	mov    %eax,(%edx)
  803ab2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ab5:	8b 40 04             	mov    0x4(%eax),%eax
  803ab8:	85 c0                	test   %eax,%eax
  803aba:	74 0f                	je     803acb <alloc_block+0x39c>
  803abc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803abf:	8b 40 04             	mov    0x4(%eax),%eax
  803ac2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803ac5:	8b 12                	mov    (%edx),%edx
  803ac7:	89 10                	mov    %edx,(%eax)
  803ac9:	eb 13                	jmp    803ade <alloc_block+0x3af>
  803acb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ace:	8b 00                	mov    (%eax),%eax
  803ad0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ad3:	c1 e2 04             	shl    $0x4,%edx
  803ad6:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803adc:	89 02                	mov    %eax,(%edx)
  803ade:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ae1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803aea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af4:	c1 e0 04             	shl    $0x4,%eax
  803af7:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803afc:	8b 00                	mov    (%eax),%eax
  803afe:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b04:	c1 e0 04             	shl    $0x4,%eax
  803b07:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b0c:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803b0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b11:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b15:	48                   	dec    %eax
  803b16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b19:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803b1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803b20:	c9                   	leave  
  803b21:	c3                   	ret    

00803b22 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803b22:	55                   	push   %ebp
  803b23:	89 e5                	mov    %esp,%ebp
  803b25:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803b28:	8b 55 08             	mov    0x8(%ebp),%edx
  803b2b:	a1 84 50 83 00       	mov    0x835084,%eax
  803b30:	39 c2                	cmp    %eax,%edx
  803b32:	72 0c                	jb     803b40 <free_block+0x1e>
  803b34:	8b 55 08             	mov    0x8(%ebp),%edx
  803b37:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803b3c:	39 c2                	cmp    %eax,%edx
  803b3e:	72 19                	jb     803b59 <free_block+0x37>
  803b40:	68 10 4a 80 00       	push   $0x804a10
  803b45:	68 46 49 80 00       	push   $0x804946
  803b4a:	68 98 00 00 00       	push   $0x98
  803b4f:	68 e3 48 80 00       	push   $0x8048e3
  803b54:	e8 9f c8 ff ff       	call   8003f8 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803b59:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5c:	83 ec 0c             	sub    $0xc,%esp
  803b5f:	50                   	push   %eax
  803b60:	e8 c9 f8 ff ff       	call   80342e <to_page_info>
  803b65:	83 c4 10             	add    $0x10,%esp
  803b68:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b6e:	8b 40 08             	mov    0x8(%eax),%eax
  803b71:	0f b7 c0             	movzwl %ax,%eax
  803b74:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803b77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803b7e:	eb 03                	jmp    803b83 <free_block+0x61>
		listIndex++;
  803b80:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b86:	ba 08 00 00 00       	mov    $0x8,%edx
  803b8b:	88 c1                	mov    %al,%cl
  803b8d:	d3 e2                	shl    %cl,%edx
  803b8f:	89 d0                	mov    %edx,%eax
  803b91:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b94:	72 ea                	jb     803b80 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803b96:	8b 45 08             	mov    0x8(%ebp),%eax
  803b99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803b9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ba0:	75 17                	jne    803bb9 <free_block+0x97>
  803ba2:	83 ec 04             	sub    $0x4,%esp
  803ba5:	68 ec 49 80 00       	push   $0x8049ec
  803baa:	68 a2 00 00 00       	push   $0xa2
  803baf:	68 e3 48 80 00       	push   $0x8048e3
  803bb4:	e8 3f c8 ff ff       	call   8003f8 <_panic>
  803bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbc:	c1 e0 04             	shl    $0x4,%eax
  803bbf:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bc4:	8b 10                	mov    (%eax),%edx
  803bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc9:	89 10                	mov    %edx,(%eax)
  803bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bce:	8b 00                	mov    (%eax),%eax
  803bd0:	85 c0                	test   %eax,%eax
  803bd2:	74 15                	je     803be9 <free_block+0xc7>
  803bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd7:	c1 e0 04             	shl    $0x4,%eax
  803bda:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803bdf:	8b 00                	mov    (%eax),%eax
  803be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803be4:	89 50 04             	mov    %edx,0x4(%eax)
  803be7:	eb 11                	jmp    803bfa <free_block+0xd8>
  803be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bec:	c1 e0 04             	shl    $0x4,%eax
  803bef:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803bf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf8:	89 02                	mov    %eax,(%edx)
  803bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfd:	c1 e0 04             	shl    $0x4,%eax
  803c00:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803c06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c09:	89 02                	mov    %eax,(%edx)
  803c0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c18:	c1 e0 04             	shl    $0x4,%eax
  803c1b:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c20:	8b 00                	mov    (%eax),%eax
  803c22:	8d 50 01             	lea    0x1(%eax),%edx
  803c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c28:	c1 e0 04             	shl    $0x4,%eax
  803c2b:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803c30:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c35:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c39:	40                   	inc    %eax
  803c3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c3d:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c44:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c48:	0f b7 c8             	movzwl %ax,%ecx
  803c4b:	b8 00 10 00 00       	mov    $0x1000,%eax
  803c50:	ba 00 00 00 00       	mov    $0x0,%edx
  803c55:	f7 75 e8             	divl   -0x18(%ebp)
  803c58:	39 c1                	cmp    %eax,%ecx
  803c5a:	0f 85 ed 01 00 00    	jne    803e4d <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c63:	c1 e0 04             	shl    $0x4,%eax
  803c66:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c6b:	8b 00                	mov    (%eax),%eax
  803c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803c70:	eb 2a                	jmp    803c9c <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c75:	83 ec 0c             	sub    $0xc,%esp
  803c78:	50                   	push   %eax
  803c79:	e8 b0 f7 ff ff       	call   80342e <to_page_info>
  803c7e:	83 c4 10             	add    $0x10,%esp
  803c81:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803c84:	75 06                	jne    803c8c <free_block+0x16a>
				tmp = b;
  803c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c89:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8f:	c1 e0 04             	shl    $0x4,%eax
  803c92:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803c97:	8b 00                	mov    (%eax),%eax
  803c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803c9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ca0:	74 07                	je     803ca9 <free_block+0x187>
  803ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca5:	8b 00                	mov    (%eax),%eax
  803ca7:	eb 05                	jmp    803cae <free_block+0x18c>
  803ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cb1:	c1 e2 04             	shl    $0x4,%edx
  803cb4:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803cba:	89 02                	mov    %eax,(%edx)
  803cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbf:	c1 e0 04             	shl    $0x4,%eax
  803cc2:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803cc7:	8b 00                	mov    (%eax),%eax
  803cc9:	85 c0                	test   %eax,%eax
  803ccb:	75 a5                	jne    803c72 <free_block+0x150>
  803ccd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cd1:	75 9f                	jne    803c72 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd6:	c1 e0 04             	shl    $0x4,%eax
  803cd9:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803cde:	8b 00                	mov    (%eax),%eax
  803ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803ce3:	e9 cc 00 00 00       	jmp    803db4 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ceb:	8b 00                	mov    (%eax),%eax
  803ced:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cf3:	83 ec 0c             	sub    $0xc,%esp
  803cf6:	50                   	push   %eax
  803cf7:	e8 32 f7 ff ff       	call   80342e <to_page_info>
  803cfc:	83 c4 10             	add    $0x10,%esp
  803cff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d02:	0f 85 a6 00 00 00    	jne    803dae <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803d08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d0c:	75 17                	jne    803d25 <free_block+0x203>
  803d0e:	83 ec 04             	sub    $0x4,%esp
  803d11:	68 7d 49 80 00       	push   $0x80497d
  803d16:	68 b5 00 00 00       	push   $0xb5
  803d1b:	68 e3 48 80 00       	push   $0x8048e3
  803d20:	e8 d3 c6 ff ff       	call   8003f8 <_panic>
  803d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d28:	8b 00                	mov    (%eax),%eax
  803d2a:	85 c0                	test   %eax,%eax
  803d2c:	74 10                	je     803d3e <free_block+0x21c>
  803d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d31:	8b 00                	mov    (%eax),%eax
  803d33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d36:	8b 52 04             	mov    0x4(%edx),%edx
  803d39:	89 50 04             	mov    %edx,0x4(%eax)
  803d3c:	eb 14                	jmp    803d52 <free_block+0x230>
  803d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d41:	8b 40 04             	mov    0x4(%eax),%eax
  803d44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d47:	c1 e2 04             	shl    $0x4,%edx
  803d4a:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803d50:	89 02                	mov    %eax,(%edx)
  803d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d55:	8b 40 04             	mov    0x4(%eax),%eax
  803d58:	85 c0                	test   %eax,%eax
  803d5a:	74 0f                	je     803d6b <free_block+0x249>
  803d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d5f:	8b 40 04             	mov    0x4(%eax),%eax
  803d62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d65:	8b 12                	mov    (%edx),%edx
  803d67:	89 10                	mov    %edx,(%eax)
  803d69:	eb 13                	jmp    803d7e <free_block+0x25c>
  803d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d6e:	8b 00                	mov    (%eax),%eax
  803d70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d73:	c1 e2 04             	shl    $0x4,%edx
  803d76:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803d7c:	89 02                	mov    %eax,(%edx)
  803d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d94:	c1 e0 04             	shl    $0x4,%eax
  803d97:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803d9c:	8b 00                	mov    (%eax),%eax
  803d9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  803da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da4:	c1 e0 04             	shl    $0x4,%eax
  803da7:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803dac:	89 10                	mov    %edx,(%eax)
			b = next;
  803dae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803db4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803db8:	0f 85 2a ff ff ff    	jne    803ce8 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803dbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dc1:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dca:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803dd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803dd4:	75 17                	jne    803ded <free_block+0x2cb>
  803dd6:	83 ec 04             	sub    $0x4,%esp
  803dd9:	68 ec 49 80 00       	push   $0x8049ec
  803dde:	68 bc 00 00 00       	push   $0xbc
  803de3:	68 e3 48 80 00       	push   $0x8048e3
  803de8:	e8 0b c6 ff ff       	call   8003f8 <_panic>
  803ded:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803df6:	89 10                	mov    %edx,(%eax)
  803df8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dfb:	8b 00                	mov    (%eax),%eax
  803dfd:	85 c0                	test   %eax,%eax
  803dff:	74 0d                	je     803e0e <free_block+0x2ec>
  803e01:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803e06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e09:	89 50 04             	mov    %edx,0x4(%eax)
  803e0c:	eb 08                	jmp    803e16 <free_block+0x2f4>
  803e0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e11:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e19:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e28:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803e2d:	40                   	inc    %eax
  803e2e:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803e33:	83 ec 0c             	sub    $0xc,%esp
  803e36:	ff 75 ec             	pushl  -0x14(%ebp)
  803e39:	e8 7e f5 ff ff       	call   8033bc <to_page_va>
  803e3e:	83 c4 10             	add    $0x10,%esp
  803e41:	83 ec 0c             	sub    $0xc,%esp
  803e44:	50                   	push   %eax
  803e45:	e8 fe d7 ff ff       	call   801648 <return_page>
  803e4a:	83 c4 10             	add    $0x10,%esp
	}
}
  803e4d:	90                   	nop
  803e4e:	c9                   	leave  
  803e4f:	c3                   	ret    

00803e50 <__udivdi3>:
  803e50:	55                   	push   %ebp
  803e51:	57                   	push   %edi
  803e52:	56                   	push   %esi
  803e53:	53                   	push   %ebx
  803e54:	83 ec 1c             	sub    $0x1c,%esp
  803e57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e67:	89 ca                	mov    %ecx,%edx
  803e69:	89 f8                	mov    %edi,%eax
  803e6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e6f:	85 f6                	test   %esi,%esi
  803e71:	75 2d                	jne    803ea0 <__udivdi3+0x50>
  803e73:	39 cf                	cmp    %ecx,%edi
  803e75:	77 65                	ja     803edc <__udivdi3+0x8c>
  803e77:	89 fd                	mov    %edi,%ebp
  803e79:	85 ff                	test   %edi,%edi
  803e7b:	75 0b                	jne    803e88 <__udivdi3+0x38>
  803e7d:	b8 01 00 00 00       	mov    $0x1,%eax
  803e82:	31 d2                	xor    %edx,%edx
  803e84:	f7 f7                	div    %edi
  803e86:	89 c5                	mov    %eax,%ebp
  803e88:	31 d2                	xor    %edx,%edx
  803e8a:	89 c8                	mov    %ecx,%eax
  803e8c:	f7 f5                	div    %ebp
  803e8e:	89 c1                	mov    %eax,%ecx
  803e90:	89 d8                	mov    %ebx,%eax
  803e92:	f7 f5                	div    %ebp
  803e94:	89 cf                	mov    %ecx,%edi
  803e96:	89 fa                	mov    %edi,%edx
  803e98:	83 c4 1c             	add    $0x1c,%esp
  803e9b:	5b                   	pop    %ebx
  803e9c:	5e                   	pop    %esi
  803e9d:	5f                   	pop    %edi
  803e9e:	5d                   	pop    %ebp
  803e9f:	c3                   	ret    
  803ea0:	39 ce                	cmp    %ecx,%esi
  803ea2:	77 28                	ja     803ecc <__udivdi3+0x7c>
  803ea4:	0f bd fe             	bsr    %esi,%edi
  803ea7:	83 f7 1f             	xor    $0x1f,%edi
  803eaa:	75 40                	jne    803eec <__udivdi3+0x9c>
  803eac:	39 ce                	cmp    %ecx,%esi
  803eae:	72 0a                	jb     803eba <__udivdi3+0x6a>
  803eb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803eb4:	0f 87 9e 00 00 00    	ja     803f58 <__udivdi3+0x108>
  803eba:	b8 01 00 00 00       	mov    $0x1,%eax
  803ebf:	89 fa                	mov    %edi,%edx
  803ec1:	83 c4 1c             	add    $0x1c,%esp
  803ec4:	5b                   	pop    %ebx
  803ec5:	5e                   	pop    %esi
  803ec6:	5f                   	pop    %edi
  803ec7:	5d                   	pop    %ebp
  803ec8:	c3                   	ret    
  803ec9:	8d 76 00             	lea    0x0(%esi),%esi
  803ecc:	31 ff                	xor    %edi,%edi
  803ece:	31 c0                	xor    %eax,%eax
  803ed0:	89 fa                	mov    %edi,%edx
  803ed2:	83 c4 1c             	add    $0x1c,%esp
  803ed5:	5b                   	pop    %ebx
  803ed6:	5e                   	pop    %esi
  803ed7:	5f                   	pop    %edi
  803ed8:	5d                   	pop    %ebp
  803ed9:	c3                   	ret    
  803eda:	66 90                	xchg   %ax,%ax
  803edc:	89 d8                	mov    %ebx,%eax
  803ede:	f7 f7                	div    %edi
  803ee0:	31 ff                	xor    %edi,%edi
  803ee2:	89 fa                	mov    %edi,%edx
  803ee4:	83 c4 1c             	add    $0x1c,%esp
  803ee7:	5b                   	pop    %ebx
  803ee8:	5e                   	pop    %esi
  803ee9:	5f                   	pop    %edi
  803eea:	5d                   	pop    %ebp
  803eeb:	c3                   	ret    
  803eec:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ef1:	89 eb                	mov    %ebp,%ebx
  803ef3:	29 fb                	sub    %edi,%ebx
  803ef5:	89 f9                	mov    %edi,%ecx
  803ef7:	d3 e6                	shl    %cl,%esi
  803ef9:	89 c5                	mov    %eax,%ebp
  803efb:	88 d9                	mov    %bl,%cl
  803efd:	d3 ed                	shr    %cl,%ebp
  803eff:	89 e9                	mov    %ebp,%ecx
  803f01:	09 f1                	or     %esi,%ecx
  803f03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f07:	89 f9                	mov    %edi,%ecx
  803f09:	d3 e0                	shl    %cl,%eax
  803f0b:	89 c5                	mov    %eax,%ebp
  803f0d:	89 d6                	mov    %edx,%esi
  803f0f:	88 d9                	mov    %bl,%cl
  803f11:	d3 ee                	shr    %cl,%esi
  803f13:	89 f9                	mov    %edi,%ecx
  803f15:	d3 e2                	shl    %cl,%edx
  803f17:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f1b:	88 d9                	mov    %bl,%cl
  803f1d:	d3 e8                	shr    %cl,%eax
  803f1f:	09 c2                	or     %eax,%edx
  803f21:	89 d0                	mov    %edx,%eax
  803f23:	89 f2                	mov    %esi,%edx
  803f25:	f7 74 24 0c          	divl   0xc(%esp)
  803f29:	89 d6                	mov    %edx,%esi
  803f2b:	89 c3                	mov    %eax,%ebx
  803f2d:	f7 e5                	mul    %ebp
  803f2f:	39 d6                	cmp    %edx,%esi
  803f31:	72 19                	jb     803f4c <__udivdi3+0xfc>
  803f33:	74 0b                	je     803f40 <__udivdi3+0xf0>
  803f35:	89 d8                	mov    %ebx,%eax
  803f37:	31 ff                	xor    %edi,%edi
  803f39:	e9 58 ff ff ff       	jmp    803e96 <__udivdi3+0x46>
  803f3e:	66 90                	xchg   %ax,%ax
  803f40:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f44:	89 f9                	mov    %edi,%ecx
  803f46:	d3 e2                	shl    %cl,%edx
  803f48:	39 c2                	cmp    %eax,%edx
  803f4a:	73 e9                	jae    803f35 <__udivdi3+0xe5>
  803f4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f4f:	31 ff                	xor    %edi,%edi
  803f51:	e9 40 ff ff ff       	jmp    803e96 <__udivdi3+0x46>
  803f56:	66 90                	xchg   %ax,%ax
  803f58:	31 c0                	xor    %eax,%eax
  803f5a:	e9 37 ff ff ff       	jmp    803e96 <__udivdi3+0x46>
  803f5f:	90                   	nop

00803f60 <__umoddi3>:
  803f60:	55                   	push   %ebp
  803f61:	57                   	push   %edi
  803f62:	56                   	push   %esi
  803f63:	53                   	push   %ebx
  803f64:	83 ec 1c             	sub    $0x1c,%esp
  803f67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f7f:	89 f3                	mov    %esi,%ebx
  803f81:	89 fa                	mov    %edi,%edx
  803f83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f87:	89 34 24             	mov    %esi,(%esp)
  803f8a:	85 c0                	test   %eax,%eax
  803f8c:	75 1a                	jne    803fa8 <__umoddi3+0x48>
  803f8e:	39 f7                	cmp    %esi,%edi
  803f90:	0f 86 a2 00 00 00    	jbe    804038 <__umoddi3+0xd8>
  803f96:	89 c8                	mov    %ecx,%eax
  803f98:	89 f2                	mov    %esi,%edx
  803f9a:	f7 f7                	div    %edi
  803f9c:	89 d0                	mov    %edx,%eax
  803f9e:	31 d2                	xor    %edx,%edx
  803fa0:	83 c4 1c             	add    $0x1c,%esp
  803fa3:	5b                   	pop    %ebx
  803fa4:	5e                   	pop    %esi
  803fa5:	5f                   	pop    %edi
  803fa6:	5d                   	pop    %ebp
  803fa7:	c3                   	ret    
  803fa8:	39 f0                	cmp    %esi,%eax
  803faa:	0f 87 ac 00 00 00    	ja     80405c <__umoddi3+0xfc>
  803fb0:	0f bd e8             	bsr    %eax,%ebp
  803fb3:	83 f5 1f             	xor    $0x1f,%ebp
  803fb6:	0f 84 ac 00 00 00    	je     804068 <__umoddi3+0x108>
  803fbc:	bf 20 00 00 00       	mov    $0x20,%edi
  803fc1:	29 ef                	sub    %ebp,%edi
  803fc3:	89 fe                	mov    %edi,%esi
  803fc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fc9:	89 e9                	mov    %ebp,%ecx
  803fcb:	d3 e0                	shl    %cl,%eax
  803fcd:	89 d7                	mov    %edx,%edi
  803fcf:	89 f1                	mov    %esi,%ecx
  803fd1:	d3 ef                	shr    %cl,%edi
  803fd3:	09 c7                	or     %eax,%edi
  803fd5:	89 e9                	mov    %ebp,%ecx
  803fd7:	d3 e2                	shl    %cl,%edx
  803fd9:	89 14 24             	mov    %edx,(%esp)
  803fdc:	89 d8                	mov    %ebx,%eax
  803fde:	d3 e0                	shl    %cl,%eax
  803fe0:	89 c2                	mov    %eax,%edx
  803fe2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fe6:	d3 e0                	shl    %cl,%eax
  803fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fec:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ff0:	89 f1                	mov    %esi,%ecx
  803ff2:	d3 e8                	shr    %cl,%eax
  803ff4:	09 d0                	or     %edx,%eax
  803ff6:	d3 eb                	shr    %cl,%ebx
  803ff8:	89 da                	mov    %ebx,%edx
  803ffa:	f7 f7                	div    %edi
  803ffc:	89 d3                	mov    %edx,%ebx
  803ffe:	f7 24 24             	mull   (%esp)
  804001:	89 c6                	mov    %eax,%esi
  804003:	89 d1                	mov    %edx,%ecx
  804005:	39 d3                	cmp    %edx,%ebx
  804007:	0f 82 87 00 00 00    	jb     804094 <__umoddi3+0x134>
  80400d:	0f 84 91 00 00 00    	je     8040a4 <__umoddi3+0x144>
  804013:	8b 54 24 04          	mov    0x4(%esp),%edx
  804017:	29 f2                	sub    %esi,%edx
  804019:	19 cb                	sbb    %ecx,%ebx
  80401b:	89 d8                	mov    %ebx,%eax
  80401d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804021:	d3 e0                	shl    %cl,%eax
  804023:	89 e9                	mov    %ebp,%ecx
  804025:	d3 ea                	shr    %cl,%edx
  804027:	09 d0                	or     %edx,%eax
  804029:	89 e9                	mov    %ebp,%ecx
  80402b:	d3 eb                	shr    %cl,%ebx
  80402d:	89 da                	mov    %ebx,%edx
  80402f:	83 c4 1c             	add    $0x1c,%esp
  804032:	5b                   	pop    %ebx
  804033:	5e                   	pop    %esi
  804034:	5f                   	pop    %edi
  804035:	5d                   	pop    %ebp
  804036:	c3                   	ret    
  804037:	90                   	nop
  804038:	89 fd                	mov    %edi,%ebp
  80403a:	85 ff                	test   %edi,%edi
  80403c:	75 0b                	jne    804049 <__umoddi3+0xe9>
  80403e:	b8 01 00 00 00       	mov    $0x1,%eax
  804043:	31 d2                	xor    %edx,%edx
  804045:	f7 f7                	div    %edi
  804047:	89 c5                	mov    %eax,%ebp
  804049:	89 f0                	mov    %esi,%eax
  80404b:	31 d2                	xor    %edx,%edx
  80404d:	f7 f5                	div    %ebp
  80404f:	89 c8                	mov    %ecx,%eax
  804051:	f7 f5                	div    %ebp
  804053:	89 d0                	mov    %edx,%eax
  804055:	e9 44 ff ff ff       	jmp    803f9e <__umoddi3+0x3e>
  80405a:	66 90                	xchg   %ax,%ax
  80405c:	89 c8                	mov    %ecx,%eax
  80405e:	89 f2                	mov    %esi,%edx
  804060:	83 c4 1c             	add    $0x1c,%esp
  804063:	5b                   	pop    %ebx
  804064:	5e                   	pop    %esi
  804065:	5f                   	pop    %edi
  804066:	5d                   	pop    %ebp
  804067:	c3                   	ret    
  804068:	3b 04 24             	cmp    (%esp),%eax
  80406b:	72 06                	jb     804073 <__umoddi3+0x113>
  80406d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804071:	77 0f                	ja     804082 <__umoddi3+0x122>
  804073:	89 f2                	mov    %esi,%edx
  804075:	29 f9                	sub    %edi,%ecx
  804077:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80407b:	89 14 24             	mov    %edx,(%esp)
  80407e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804082:	8b 44 24 04          	mov    0x4(%esp),%eax
  804086:	8b 14 24             	mov    (%esp),%edx
  804089:	83 c4 1c             	add    $0x1c,%esp
  80408c:	5b                   	pop    %ebx
  80408d:	5e                   	pop    %esi
  80408e:	5f                   	pop    %edi
  80408f:	5d                   	pop    %ebp
  804090:	c3                   	ret    
  804091:	8d 76 00             	lea    0x0(%esi),%esi
  804094:	2b 04 24             	sub    (%esp),%eax
  804097:	19 fa                	sbb    %edi,%edx
  804099:	89 d1                	mov    %edx,%ecx
  80409b:	89 c6                	mov    %eax,%esi
  80409d:	e9 71 ff ff ff       	jmp    804013 <__umoddi3+0xb3>
  8040a2:	66 90                	xchg   %ax,%ax
  8040a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040a8:	72 ea                	jb     804094 <__umoddi3+0x134>
  8040aa:	89 d9                	mov    %ebx,%ecx
  8040ac:	e9 62 ff ff ff       	jmp    804013 <__umoddi3+0xb3>
