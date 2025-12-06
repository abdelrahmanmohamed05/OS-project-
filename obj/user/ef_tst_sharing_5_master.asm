
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 d6 04 00 00       	call   80050c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800044:	a1 20 60 80 00       	mov    0x806020,%eax
  800049:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004f:	a1 20 60 80 00       	mov    0x806020,%eax
  800054:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80005a:	39 c2                	cmp    %eax,%edx
  80005c:	72 14                	jb     800072 <_main+0x3a>
			panic("Please increase the WS size");
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 40 44 80 00       	push   $0x804440
  800066:	6a 0b                	push   $0xb
  800068:	68 5c 44 80 00       	push   $0x80445c
  80006d:	e8 4a 06 00 00       	call   8006bc <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800072:	c7 45 e4 00 10 00 82 	movl   $0x82001000,-0x1c(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	cprintf("************************************************\n");
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	68 7c 44 80 00       	push   $0x80447c
  800081:	e8 04 09 00 00       	call   80098a <cprintf>
  800086:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	68 b0 44 80 00       	push   $0x8044b0
  800091:	e8 f4 08 00 00       	call   80098a <cprintf>
  800096:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 0c 45 80 00       	push   $0x80450c
  8000a1:	e8 e4 08 00 00       	call   80098a <cprintf>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000a9:	e8 f6 32 00 00       	call   8033a4 <sys_getenvid>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 40 45 80 00       	push   $0x804540
  8000b9:	e8 cc 08 00 00       	call   80098a <cprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000c1:	a1 20 60 80 00       	mov    0x806020,%eax
  8000c6:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000cc:	89 c2                	mov    %eax,%edx
  8000ce:	a1 20 60 80 00       	mov    0x806020,%eax
  8000d3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000d9:	6a 32                	push   $0x32
  8000db:	52                   	push   %edx
  8000dc:	50                   	push   %eax
  8000dd:	68 81 45 80 00       	push   $0x804581
  8000e2:	e8 68 32 00 00       	call   80334f <sys_create_env>
  8000e7:	83 c4 10             	add    $0x10,%esp
  8000ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000ed:	a1 20 60 80 00       	mov    0x806020,%eax
  8000f2:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000f8:	89 c2                	mov    %eax,%edx
  8000fa:	a1 20 60 80 00       	mov    0x806020,%eax
  8000ff:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800105:	6a 32                	push   $0x32
  800107:	52                   	push   %edx
  800108:	50                   	push   %eax
  800109:	68 81 45 80 00       	push   $0x804581
  80010e:	e8 3c 32 00 00       	call   80334f <sys_create_env>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800119:	e8 d6 30 00 00       	call   8031f4 <sys_calculate_free_frames>
  80011e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800121:	83 ec 04             	sub    $0x4,%esp
  800124:	6a 01                	push   $0x1
  800126:	68 00 10 00 00       	push   $0x1000
  80012b:	68 8f 45 80 00       	push   $0x80458f
  800130:	e8 84 1f 00 00       	call   8020b9 <smalloc>
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	89 45 d0             	mov    %eax,-0x30(%ebp)
		cprintf("Master env created x (1 page) \n");
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	68 94 45 80 00       	push   $0x804594
  800143:	e8 42 08 00 00       	call   80098a <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)pagealloc_start) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80014b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 b4 45 80 00       	push   $0x8045b4
  80015b:	6a 27                	push   $0x27
  80015d:	68 5c 44 80 00       	push   $0x80445c
  800162:	e8 55 05 00 00       	call   8006bc <_panic>
		expected = 1+1 ; /*1page +1table*/
  800167:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80016e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800171:	e8 7e 30 00 00       	call   8031f4 <sys_calculate_free_frames>
  800176:	29 c3                	sub    %eax,%ebx
  800178:	89 d8                	mov    %ebx,%eax
  80017a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/)
  80017d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800180:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800183:	7c 0b                	jl     800190 <_main+0x158>
  800185:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800188:	83 c0 02             	add    $0x2,%eax
  80018b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80018e:	7d 24                	jge    8001b4 <_main+0x17c>
			panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800190:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800193:	e8 5c 30 00 00       	call   8031f4 <sys_calculate_free_frames>
  800198:	29 c3                	sub    %eax,%ebx
  80019a:	89 d8                	mov    %ebx,%eax
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 cc             	pushl  -0x34(%ebp)
  8001a2:	50                   	push   %eax
  8001a3:	68 20 46 80 00       	push   $0x804620
  8001a8:	6a 2b                	push   $0x2b
  8001aa:	68 5c 44 80 00       	push   $0x80445c
  8001af:	e8 08 05 00 00       	call   8006bc <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001b4:	e8 e2 32 00 00       	call   80349b <rsttst>

		sys_run_env(envIdSlave1);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	ff 75 dc             	pushl  -0x24(%ebp)
  8001bf:	e8 a9 31 00 00       	call   80336d <sys_run_env>
  8001c4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cd:	e8 9b 31 00 00       	call   80336d <sys_run_env>
  8001d2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 b8 46 80 00       	push   $0x8046b8
  8001dd:	e8 a8 07 00 00       	call   80098a <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 b8 0b 00 00       	push   $0xbb8
  8001ed:	e8 22 3f 00 00       	call   804114 <env_sleep>
  8001f2:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  8001f5:	90                   	nop
  8001f6:	e8 1a 33 00 00       	call   803515 <gettst>
  8001fb:	83 f8 02             	cmp    $0x2,%eax
  8001fe:	75 f6                	jne    8001f6 <_main+0x1be>

		freeFrames = sys_calculate_free_frames() ;
  800200:	e8 ef 2f 00 00       	call   8031f4 <sys_calculate_free_frames>
  800205:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		sfree(x);
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	ff 75 d0             	pushl  -0x30(%ebp)
  80020e:	e8 73 2b 00 00       	call   802d86 <sfree>
  800213:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	68 d0 46 80 00       	push   $0x8046d0
  80021e:	e8 67 07 00 00       	call   80098a <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
		int diff2 = (sys_calculate_free_frames() - freeFrames);
  800226:	e8 c9 2f 00 00       	call   8031f4 <sys_calculate_free_frames>
  80022b:	89 c2                	mov    %eax,%edx
  80022d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800230:	29 c2                	sub    %eax,%edx
  800232:	89 d0                	mov    %edx,%eax
  800234:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		expected = 1+1; /*1page+1table*/
  800237:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
		if (diff2 != expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff2, expected);
  80023e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800241:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800244:	74 1a                	je     800260 <_main+0x228>
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	ff 75 cc             	pushl  -0x34(%ebp)
  80024c:	ff 75 c4             	pushl  -0x3c(%ebp)
  80024f:	68 f0 46 80 00       	push   $0x8046f0
  800254:	6a 3e                	push   $0x3e
  800256:	68 5c 44 80 00       	push   $0x80445c
  80025b:	e8 5c 04 00 00       	call   8006bc <_panic>
	}
	cprintf("Step A is finished!!\n\n\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 37 47 80 00       	push   $0x804737
  800268:	e8 1d 07 00 00       	call   80098a <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 50 47 80 00       	push   $0x804750
  800278:	e8 0d 07 00 00       	call   80098a <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800280:	a1 20 60 80 00       	mov    0x806020,%eax
  800285:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80028b:	89 c2                	mov    %eax,%edx
  80028d:	a1 20 60 80 00       	mov    0x806020,%eax
  800292:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800298:	6a 32                	push   $0x32
  80029a:	52                   	push   %edx
  80029b:	50                   	push   %eax
  80029c:	68 80 47 80 00       	push   $0x804780
  8002a1:	e8 a9 30 00 00       	call   80334f <sys_create_env>
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  8002ac:	a1 20 60 80 00       	mov    0x806020,%eax
  8002b1:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8002b7:	89 c2                	mov    %eax,%edx
  8002b9:	a1 20 60 80 00       	mov    0x806020,%eax
  8002be:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8002c4:	6a 32                	push   $0x32
  8002c6:	52                   	push   %edx
  8002c7:	50                   	push   %eax
  8002c8:	68 90 47 80 00       	push   $0x804790
  8002cd:	e8 7d 30 00 00       	call   80334f <sys_create_env>
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	89 45 bc             	mov    %eax,-0x44(%ebp)

		z = smalloc("z", PAGE_SIZE+1, 1);
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	6a 01                	push   $0x1
  8002dd:	68 01 10 00 00       	push   $0x1001
  8002e2:	68 a0 47 80 00       	push   $0x8047a0
  8002e7:	e8 cd 1d 00 00       	call   8020b9 <smalloc>
  8002ec:	83 c4 10             	add    $0x10,%esp
  8002ef:	89 45 b8             	mov    %eax,-0x48(%ebp)
		cprintf("Master env created z (2 pages) \n");
  8002f2:	83 ec 0c             	sub    $0xc,%esp
  8002f5:	68 a4 47 80 00       	push   $0x8047a4
  8002fa:	e8 8b 06 00 00       	call   80098a <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE+1024, 1);
  800302:	83 ec 04             	sub    $0x4,%esp
  800305:	6a 01                	push   $0x1
  800307:	68 00 14 00 00       	push   $0x1400
  80030c:	68 8f 45 80 00       	push   $0x80458f
  800311:	e8 a3 1d 00 00       	call   8020b9 <smalloc>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		cprintf("Master env created x (2 pages) \n");
  80031c:	83 ec 0c             	sub    $0xc,%esp
  80031f:	68 c8 47 80 00       	push   $0x8047c8
  800324:	e8 61 06 00 00       	call   80098a <cprintf>
  800329:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80032c:	e8 6a 31 00 00       	call   80349b <rsttst>

		sys_run_env(envIdSlaveB1);
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	ff 75 c0             	pushl  -0x40(%ebp)
  800337:	e8 31 30 00 00       	call   80336d <sys_run_env>
  80033c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 bc             	pushl  -0x44(%ebp)
  800345:	e8 23 30 00 00       	call   80336d <sys_run_env>
  80034a:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
			//			env_sleep(4000);
			while (gettst()!=2) ;
  80034d:	90                   	nop
  80034e:	e8 c2 31 00 00       	call   803515 <gettst>
  800353:	83 f8 02             	cmp    $0x2,%eax
  800356:	75 f6                	jne    80034e <_main+0x316>
		}

		int freeFrames = sys_calculate_free_frames() ;
  800358:	e8 97 2e 00 00       	call   8031f4 <sys_calculate_free_frames>
  80035d:	89 45 b0             	mov    %eax,-0x50(%ebp)

		sfree(z);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	ff 75 b8             	pushl  -0x48(%ebp)
  800366:	e8 1b 2a 00 00       	call   802d86 <sfree>
  80036b:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  80036e:	83 ec 0c             	sub    $0xc,%esp
  800371:	68 e9 47 80 00       	push   $0x8047e9
  800376:	e8 0f 06 00 00       	call   80098a <cprintf>
  80037b:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  80037e:	83 ec 0c             	sub    $0xc,%esp
  800381:	ff 75 b4             	pushl  -0x4c(%ebp)
  800384:	e8 fd 29 00 00       	call   802d86 <sfree>
  800389:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80038c:	83 ec 0c             	sub    $0xc,%esp
  80038f:	68 ff 47 80 00       	push   $0x8047ff
  800394:	e8 f1 05 00 00       	call   80098a <cprintf>
  800399:	83 c4 10             	add    $0x10,%esp

		inctst(); //finish the free's
  80039c:	e8 5a 31 00 00       	call   8034fb <inctst>

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003a1:	e8 4e 2e 00 00       	call   8031f4 <sys_calculate_free_frames>
  8003a6:	89 c2                	mov    %eax,%edx
  8003a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8003ab:	29 c2                	sub    %eax,%edx
  8003ad:	89 d0                	mov    %edx,%eax
  8003af:	89 45 ac             	mov    %eax,-0x54(%ebp)
		expected = 1 /*table*/;
  8003b2:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003b9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003bc:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8003bf:	74 14                	je     8003d5 <_main+0x39d>
  8003c1:	83 ec 04             	sub    $0x4,%esp
  8003c4:	68 18 48 80 00       	push   $0x804818
  8003c9:	6a 65                	push   $0x65
  8003cb:	68 5c 44 80 00       	push   $0x80445c
  8003d0:	e8 e7 02 00 00       	call   8006bc <_panic>

		inctst();	// finish checking
  8003d5:	e8 21 31 00 00       	call   8034fb <inctst>

		//to ensure that the other environments completed successfully
		while (gettst()!=6) ;// panic("test failed");
  8003da:	90                   	nop
  8003db:	e8 35 31 00 00       	call   803515 <gettst>
  8003e0:	83 f8 06             	cmp    $0x6,%eax
  8003e3:	75 f6                	jne    8003db <_main+0x3a3>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	6a 01                	push   $0x1
  8003ea:	6a 04                	push   $0x4
  8003ec:	68 bd 48 80 00       	push   $0x8048bd
  8003f1:	e8 c3 1c 00 00       	call   8020b9 <smalloc>
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		*finish_children = 0;
  8003fc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		//To indicate that it create the finish_children & completed successfully
		cprintf("Master is completed.\n");
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	68 cd 48 80 00       	push   $0x8048cd
  80040d:	e8 78 05 00 00       	call   80098a <cprintf>
  800412:	83 c4 10             	add    $0x10,%esp
		inctst();
  800415:	e8 e1 30 00 00       	call   8034fb <inctst>

		if (sys_getparentenvid() > 0) {
  80041a:	e8 b7 2f 00 00       	call   8033d6 <sys_getparentenvid>
  80041f:	85 c0                	test   %eax,%eax
  800421:	0f 8e dc 00 00 00    	jle    800503 <_main+0x4cb>
			while(*finish_children != 1);
  800427:	90                   	nop
  800428:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	83 f8 01             	cmp    $0x1,%eax
  800430:	75 f6                	jne    800428 <_main+0x3f0>
			cprintf("done\n");
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	68 e3 48 80 00       	push   $0x8048e3
  80043a:	e8 4b 05 00 00       	call   80098a <cprintf>
  80043f:	83 c4 10             	add    $0x10,%esp

			//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
			//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
			//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
			//	2. changing the # free frames
			char changeIntCmd[100] = "__changeInterruptStatus__";
  800442:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800448:	bb f7 48 80 00       	mov    $0x8048f7,%ebx
  80044d:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800452:	89 c7                	mov    %eax,%edi
  800454:	89 de                	mov    %ebx,%esi
  800456:	89 d1                	mov    %edx,%ecx
  800458:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80045a:	8d 95 5a ff ff ff    	lea    -0xa6(%ebp),%edx
  800460:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800465:	b0 00                	mov    $0x0,%al
  800467:	89 d7                	mov    %edx,%edi
  800469:	f3 aa                	rep stos %al,%es:(%edi)
			sys_utilities(changeIntCmd, 0);
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	6a 00                	push   $0x0
  800470:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800476:	50                   	push   %eax
  800477:	e8 77 31 00 00       	call   8035f3 <sys_utilities>
  80047c:	83 c4 10             	add    $0x10,%esp
			{
				sys_destroy_env(envIdSlave1);
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	ff 75 dc             	pushl  -0x24(%ebp)
  800485:	e8 ff 2e 00 00       	call   803389 <sys_destroy_env>
  80048a:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlave2);
  80048d:	83 ec 0c             	sub    $0xc,%esp
  800490:	ff 75 d8             	pushl  -0x28(%ebp)
  800493:	e8 f1 2e 00 00       	call   803389 <sys_destroy_env>
  800498:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlaveB1);
  80049b:	83 ec 0c             	sub    $0xc,%esp
  80049e:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a1:	e8 e3 2e 00 00       	call   803389 <sys_destroy_env>
  8004a6:	83 c4 10             	add    $0x10,%esp
				sys_destroy_env(envIdSlaveB2);
  8004a9:	83 ec 0c             	sub    $0xc,%esp
  8004ac:	ff 75 bc             	pushl  -0x44(%ebp)
  8004af:	e8 d5 2e 00 00       	call   803389 <sys_destroy_env>
  8004b4:	83 c4 10             	add    $0x10,%esp
			}
			sys_utilities(changeIntCmd, 1);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	6a 01                	push   $0x1
  8004bc:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8004c2:	50                   	push   %eax
  8004c3:	e8 2b 31 00 00       	call   8035f3 <sys_utilities>
  8004c8:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  8004cb:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  8004d2:	e8 ff 2e 00 00       	call   8033d6 <sys_getparentenvid>
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	68 e9 48 80 00       	push   $0x8048e9
  8004df:	50                   	push   %eax
  8004e0:	e8 2e 1f 00 00       	call   802413 <sget>
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	89 45 a4             	mov    %eax,-0x5c(%ebp)

			//Critical section to protect the shared variable
			sys_lock_cons();
  8004eb:	e8 54 2c 00 00       	call   803144 <sys_lock_cons>
			{
				(*finishedCount)++ ;
  8004f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004f3:	8b 00                	mov    (%eax),%eax
  8004f5:	8d 50 01             	lea    0x1(%eax),%edx
  8004f8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004fb:	89 10                	mov    %edx,(%eax)
			}
			sys_unlock_cons();
  8004fd:	e8 5c 2c 00 00       	call   80315e <sys_unlock_cons>
		}
	}


	return;
  800502:	90                   	nop
  800503:	90                   	nop
}
  800504:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800507:	5b                   	pop    %ebx
  800508:	5e                   	pop    %esi
  800509:	5f                   	pop    %edi
  80050a:	5d                   	pop    %ebp
  80050b:	c3                   	ret    

0080050c <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80050c:	55                   	push   %ebp
  80050d:	89 e5                	mov    %esp,%ebp
  80050f:	57                   	push   %edi
  800510:	56                   	push   %esi
  800511:	53                   	push   %ebx
  800512:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800515:	e8 a3 2e 00 00       	call   8033bd <sys_getenvindex>
  80051a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80051d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800520:	89 d0                	mov    %edx,%eax
  800522:	c1 e0 03             	shl    $0x3,%eax
  800525:	01 d0                	add    %edx,%eax
  800527:	c1 e0 02             	shl    $0x2,%eax
  80052a:	01 d0                	add    %edx,%eax
  80052c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800533:	01 d0                	add    %edx,%eax
  800535:	c1 e0 03             	shl    $0x3,%eax
  800538:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80053d:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800542:	a1 20 60 80 00       	mov    0x806020,%eax
  800547:	8a 40 20             	mov    0x20(%eax),%al
  80054a:	84 c0                	test   %al,%al
  80054c:	74 0d                	je     80055b <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80054e:	a1 20 60 80 00       	mov    0x806020,%eax
  800553:	83 c0 20             	add    $0x20,%eax
  800556:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80055b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80055f:	7e 0a                	jle    80056b <libmain+0x5f>
		binaryname = argv[0];
  800561:	8b 45 0c             	mov    0xc(%ebp),%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 0c             	pushl  0xc(%ebp)
  800571:	ff 75 08             	pushl  0x8(%ebp)
  800574:	e8 bf fa ff ff       	call   800038 <_main>
  800579:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80057c:	a1 00 60 80 00       	mov    0x806000,%eax
  800581:	85 c0                	test   %eax,%eax
  800583:	0f 84 01 01 00 00    	je     80068a <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800589:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80058f:	bb 54 4a 80 00       	mov    $0x804a54,%ebx
  800594:	ba 0e 00 00 00       	mov    $0xe,%edx
  800599:	89 c7                	mov    %eax,%edi
  80059b:	89 de                	mov    %ebx,%esi
  80059d:	89 d1                	mov    %edx,%ecx
  80059f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a1:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8005a4:	b9 56 00 00 00       	mov    $0x56,%ecx
  8005a9:	b0 00                	mov    $0x0,%al
  8005ab:	89 d7                	mov    %edx,%edi
  8005ad:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8005af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8005b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	50                   	push   %eax
  8005bd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8005c3:	50                   	push   %eax
  8005c4:	e8 2a 30 00 00       	call   8035f3 <sys_utilities>
  8005c9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8005cc:	e8 73 2b 00 00       	call   803144 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8005d1:	83 ec 0c             	sub    $0xc,%esp
  8005d4:	68 74 49 80 00       	push   $0x804974
  8005d9:	e8 ac 03 00 00       	call   80098a <cprintf>
  8005de:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8005e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e4:	85 c0                	test   %eax,%eax
  8005e6:	74 18                	je     800600 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8005e8:	e8 24 30 00 00       	call   803611 <sys_get_optimal_num_faults>
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	50                   	push   %eax
  8005f1:	68 9c 49 80 00       	push   $0x80499c
  8005f6:	e8 8f 03 00 00       	call   80098a <cprintf>
  8005fb:	83 c4 10             	add    $0x10,%esp
  8005fe:	eb 59                	jmp    800659 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800600:	a1 20 60 80 00       	mov    0x806020,%eax
  800605:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  80060b:	a1 20 60 80 00       	mov    0x806020,%eax
  800610:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	68 c0 49 80 00       	push   $0x8049c0
  800620:	e8 65 03 00 00       	call   80098a <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800628:	a1 20 60 80 00       	mov    0x806020,%eax
  80062d:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800633:	a1 20 60 80 00       	mov    0x806020,%eax
  800638:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  80063e:	a1 20 60 80 00       	mov    0x806020,%eax
  800643:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800649:	51                   	push   %ecx
  80064a:	52                   	push   %edx
  80064b:	50                   	push   %eax
  80064c:	68 e8 49 80 00       	push   $0x8049e8
  800651:	e8 34 03 00 00       	call   80098a <cprintf>
  800656:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800659:	a1 20 60 80 00       	mov    0x806020,%eax
  80065e:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800664:	83 ec 08             	sub    $0x8,%esp
  800667:	50                   	push   %eax
  800668:	68 40 4a 80 00       	push   $0x804a40
  80066d:	e8 18 03 00 00       	call   80098a <cprintf>
  800672:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800675:	83 ec 0c             	sub    $0xc,%esp
  800678:	68 74 49 80 00       	push   $0x804974
  80067d:	e8 08 03 00 00       	call   80098a <cprintf>
  800682:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800685:	e8 d4 2a 00 00       	call   80315e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80068a:	e8 1f 00 00 00       	call   8006ae <exit>
}
  80068f:	90                   	nop
  800690:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800693:	5b                   	pop    %ebx
  800694:	5e                   	pop    %esi
  800695:	5f                   	pop    %edi
  800696:	5d                   	pop    %ebp
  800697:	c3                   	ret    

00800698 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800698:	55                   	push   %ebp
  800699:	89 e5                	mov    %esp,%ebp
  80069b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80069e:	83 ec 0c             	sub    $0xc,%esp
  8006a1:	6a 00                	push   $0x0
  8006a3:	e8 e1 2c 00 00       	call   803389 <sys_destroy_env>
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <exit>:

void
exit(void)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006b4:	e8 36 2d 00 00       	call   8033ef <sys_exit_env>
}
  8006b9:	90                   	nop
  8006ba:	c9                   	leave  
  8006bb:	c3                   	ret    

008006bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8006c5:	83 c0 04             	add    $0x4,%eax
  8006c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006cb:	a1 38 61 83 00       	mov    0x836138,%eax
  8006d0:	85 c0                	test   %eax,%eax
  8006d2:	74 16                	je     8006ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006d4:	a1 38 61 83 00       	mov    0x836138,%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	50                   	push   %eax
  8006dd:	68 b8 4a 80 00       	push   $0x804ab8
  8006e2:	e8 a3 02 00 00       	call   80098a <cprintf>
  8006e7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8006ea:	a1 04 60 80 00       	mov    0x806004,%eax
  8006ef:	83 ec 0c             	sub    $0xc,%esp
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	ff 75 08             	pushl  0x8(%ebp)
  8006f8:	50                   	push   %eax
  8006f9:	68 c0 4a 80 00       	push   $0x804ac0
  8006fe:	6a 74                	push   $0x74
  800700:	e8 b2 02 00 00       	call   8009b7 <cprintf_colored>
  800705:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800708:	8b 45 10             	mov    0x10(%ebp),%eax
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 f4             	pushl  -0xc(%ebp)
  800711:	50                   	push   %eax
  800712:	e8 04 02 00 00       	call   80091b <vcprintf>
  800717:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	6a 00                	push   $0x0
  80071f:	68 e8 4a 80 00       	push   $0x804ae8
  800724:	e8 f2 01 00 00       	call   80091b <vcprintf>
  800729:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80072c:	e8 7d ff ff ff       	call   8006ae <exit>

	// should not return here
	while (1) ;
  800731:	eb fe                	jmp    800731 <_panic+0x75>

00800733 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800739:	a1 20 60 80 00       	mov    0x806020,%eax
  80073e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800744:	8b 45 0c             	mov    0xc(%ebp),%eax
  800747:	39 c2                	cmp    %eax,%edx
  800749:	74 14                	je     80075f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80074b:	83 ec 04             	sub    $0x4,%esp
  80074e:	68 ec 4a 80 00       	push   $0x804aec
  800753:	6a 26                	push   $0x26
  800755:	68 38 4b 80 00       	push   $0x804b38
  80075a:	e8 5d ff ff ff       	call   8006bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80075f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800766:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80076d:	e9 c5 00 00 00       	jmp    800837 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800775:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	01 d0                	add    %edx,%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	85 c0                	test   %eax,%eax
  800785:	75 08                	jne    80078f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800787:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80078a:	e9 a5 00 00 00       	jmp    800834 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80078f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800796:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80079d:	eb 69                	jmp    800808 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80079f:	a1 20 60 80 00       	mov    0x806020,%eax
  8007a4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8007aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ad:	89 d0                	mov    %edx,%eax
  8007af:	01 c0                	add    %eax,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	c1 e0 03             	shl    $0x3,%eax
  8007b6:	01 c8                	add    %ecx,%eax
  8007b8:	8a 40 04             	mov    0x4(%eax),%al
  8007bb:	84 c0                	test   %al,%al
  8007bd:	75 46                	jne    800805 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007bf:	a1 20 60 80 00       	mov    0x806020,%eax
  8007c4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8007ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007cd:	89 d0                	mov    %edx,%eax
  8007cf:	01 c0                	add    %eax,%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	c1 e0 03             	shl    $0x3,%eax
  8007d6:	01 c8                	add    %ecx,%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007e5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	01 c8                	add    %ecx,%eax
  8007f6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007f8:	39 c2                	cmp    %eax,%edx
  8007fa:	75 09                	jne    800805 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8007fc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800803:	eb 15                	jmp    80081a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800805:	ff 45 e8             	incl   -0x18(%ebp)
  800808:	a1 20 60 80 00       	mov    0x806020,%eax
  80080d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800816:	39 c2                	cmp    %eax,%edx
  800818:	77 85                	ja     80079f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80081a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80081e:	75 14                	jne    800834 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800820:	83 ec 04             	sub    $0x4,%esp
  800823:	68 44 4b 80 00       	push   $0x804b44
  800828:	6a 3a                	push   $0x3a
  80082a:	68 38 4b 80 00       	push   $0x804b38
  80082f:	e8 88 fe ff ff       	call   8006bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800834:	ff 45 f0             	incl   -0x10(%ebp)
  800837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80083d:	0f 8c 2f ff ff ff    	jl     800772 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800843:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80084a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800851:	eb 26                	jmp    800879 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800853:	a1 20 60 80 00       	mov    0x806020,%eax
  800858:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80085e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800861:	89 d0                	mov    %edx,%eax
  800863:	01 c0                	add    %eax,%eax
  800865:	01 d0                	add    %edx,%eax
  800867:	c1 e0 03             	shl    $0x3,%eax
  80086a:	01 c8                	add    %ecx,%eax
  80086c:	8a 40 04             	mov    0x4(%eax),%al
  80086f:	3c 01                	cmp    $0x1,%al
  800871:	75 03                	jne    800876 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800873:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800876:	ff 45 e0             	incl   -0x20(%ebp)
  800879:	a1 20 60 80 00       	mov    0x806020,%eax
  80087e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800884:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800887:	39 c2                	cmp    %eax,%edx
  800889:	77 c8                	ja     800853 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80088b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80088e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800891:	74 14                	je     8008a7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800893:	83 ec 04             	sub    $0x4,%esp
  800896:	68 98 4b 80 00       	push   $0x804b98
  80089b:	6a 44                	push   $0x44
  80089d:	68 38 4b 80 00       	push   $0x804b38
  8008a2:	e8 15 fe ff ff       	call   8006bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008a7:	90                   	nop
  8008a8:	c9                   	leave  
  8008a9:	c3                   	ret    

008008aa <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	53                   	push   %ebx
  8008ae:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8008b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	8d 48 01             	lea    0x1(%eax),%ecx
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bc:	89 0a                	mov    %ecx,(%edx)
  8008be:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c1:	88 d1                	mov    %dl,%cl
  8008c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008d4:	75 30                	jne    800906 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8008d6:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  8008dc:	a0 64 e0 81 00       	mov    0x81e064,%al
  8008e1:	0f b6 c0             	movzbl %al,%eax
  8008e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e7:	8b 09                	mov    (%ecx),%ecx
  8008e9:	89 cb                	mov    %ecx,%ebx
  8008eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ee:	83 c1 08             	add    $0x8,%ecx
  8008f1:	52                   	push   %edx
  8008f2:	50                   	push   %eax
  8008f3:	53                   	push   %ebx
  8008f4:	51                   	push   %ecx
  8008f5:	e8 06 28 00 00       	call   803100 <sys_cputs>
  8008fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800906:	8b 45 0c             	mov    0xc(%ebp),%eax
  800909:	8b 40 04             	mov    0x4(%eax),%eax
  80090c:	8d 50 01             	lea    0x1(%eax),%edx
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	89 50 04             	mov    %edx,0x4(%eax)
}
  800915:	90                   	nop
  800916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800919:	c9                   	leave  
  80091a:	c3                   	ret    

0080091b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800924:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80092b:	00 00 00 
	b.cnt = 0;
  80092e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800935:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	ff 75 08             	pushl  0x8(%ebp)
  80093e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800944:	50                   	push   %eax
  800945:	68 aa 08 80 00       	push   $0x8008aa
  80094a:	e8 5a 02 00 00       	call   800ba9 <vprintfmt>
  80094f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800952:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800958:	a0 64 e0 81 00       	mov    0x81e064,%al
  80095d:	0f b6 c0             	movzbl %al,%eax
  800960:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800966:	52                   	push   %edx
  800967:	50                   	push   %eax
  800968:	51                   	push   %ecx
  800969:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80096f:	83 c0 08             	add    $0x8,%eax
  800972:	50                   	push   %eax
  800973:	e8 88 27 00 00       	call   803100 <sys_cputs>
  800978:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80097b:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800982:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800988:	c9                   	leave  
  800989:	c3                   	ret    

0080098a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800990:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800997:	8d 45 0c             	lea    0xc(%ebp),%eax
  80099a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a6:	50                   	push   %eax
  8009a7:	e8 6f ff ff ff       	call   80091b <vcprintf>
  8009ac:	83 c4 10             	add    $0x10,%esp
  8009af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009bd:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	c1 e0 08             	shl    $0x8,%eax
  8009ca:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  8009cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d2:	83 c0 04             	add    $0x4,%eax
  8009d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e1:	50                   	push   %eax
  8009e2:	e8 34 ff ff ff       	call   80091b <vcprintf>
  8009e7:	83 c4 10             	add    $0x10,%esp
  8009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8009ed:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  8009f4:	07 00 00 

	return cnt;
  8009f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fa:	c9                   	leave  
  8009fb:	c3                   	ret    

008009fc <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a02:	e8 3d 27 00 00       	call   803144 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a07:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 f4             	pushl  -0xc(%ebp)
  800a16:	50                   	push   %eax
  800a17:	e8 ff fe ff ff       	call   80091b <vcprintf>
  800a1c:	83 c4 10             	add    $0x10,%esp
  800a1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a22:	e8 37 27 00 00       	call   80315e <sys_unlock_cons>
	return cnt;
  800a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	53                   	push   %ebx
  800a30:	83 ec 14             	sub    $0x14,%esp
  800a33:	8b 45 10             	mov    0x10(%ebp),%eax
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a3f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a42:	ba 00 00 00 00       	mov    $0x0,%edx
  800a47:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4a:	77 55                	ja     800aa1 <printnum+0x75>
  800a4c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4f:	72 05                	jb     800a56 <printnum+0x2a>
  800a51:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a54:	77 4b                	ja     800aa1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a56:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a59:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a5c:	8b 45 18             	mov    0x18(%ebp),%eax
  800a5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a64:	52                   	push   %edx
  800a65:	50                   	push   %eax
  800a66:	ff 75 f4             	pushl  -0xc(%ebp)
  800a69:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6c:	e8 63 37 00 00       	call   8041d4 <__udivdi3>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	83 ec 04             	sub    $0x4,%esp
  800a77:	ff 75 20             	pushl  0x20(%ebp)
  800a7a:	53                   	push   %ebx
  800a7b:	ff 75 18             	pushl  0x18(%ebp)
  800a7e:	52                   	push   %edx
  800a7f:	50                   	push   %eax
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	ff 75 08             	pushl  0x8(%ebp)
  800a86:	e8 a1 ff ff ff       	call   800a2c <printnum>
  800a8b:	83 c4 20             	add    $0x20,%esp
  800a8e:	eb 1a                	jmp    800aaa <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 0c             	pushl  0xc(%ebp)
  800a96:	ff 75 20             	pushl  0x20(%ebp)
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	ff d0                	call   *%eax
  800a9e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa1:	ff 4d 1c             	decl   0x1c(%ebp)
  800aa4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aa8:	7f e6                	jg     800a90 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aaa:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab8:	53                   	push   %ebx
  800ab9:	51                   	push   %ecx
  800aba:	52                   	push   %edx
  800abb:	50                   	push   %eax
  800abc:	e8 23 38 00 00       	call   8042e4 <__umoddi3>
  800ac1:	83 c4 10             	add    $0x10,%esp
  800ac4:	05 14 4e 80 00       	add    $0x804e14,%eax
  800ac9:	8a 00                	mov    (%eax),%al
  800acb:	0f be c0             	movsbl %al,%eax
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	50                   	push   %eax
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	ff d0                	call   *%eax
  800ada:	83 c4 10             	add    $0x10,%esp
}
  800add:	90                   	nop
  800ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae1:	c9                   	leave  
  800ae2:	c3                   	ret    

00800ae3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aea:	7e 1c                	jle    800b08 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8b 00                	mov    (%eax),%eax
  800af1:	8d 50 08             	lea    0x8(%eax),%edx
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	89 10                	mov    %edx,(%eax)
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 00                	mov    (%eax),%eax
  800afe:	83 e8 08             	sub    $0x8,%eax
  800b01:	8b 50 04             	mov    0x4(%eax),%edx
  800b04:	8b 00                	mov    (%eax),%eax
  800b06:	eb 40                	jmp    800b48 <getuint+0x65>
	else if (lflag)
  800b08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0c:	74 1e                	je     800b2c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	8d 50 04             	lea    0x4(%eax),%edx
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	89 10                	mov    %edx,(%eax)
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8b 00                	mov    (%eax),%eax
  800b20:	83 e8 04             	sub    $0x4,%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2a:	eb 1c                	jmp    800b48 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	8d 50 04             	lea    0x4(%eax),%edx
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	89 10                	mov    %edx,(%eax)
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	83 e8 04             	sub    $0x4,%eax
  800b41:	8b 00                	mov    (%eax),%eax
  800b43:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b4d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b51:	7e 1c                	jle    800b6f <getint+0x25>
		return va_arg(*ap, long long);
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8b 00                	mov    (%eax),%eax
  800b58:	8d 50 08             	lea    0x8(%eax),%edx
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	89 10                	mov    %edx,(%eax)
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8b 00                	mov    (%eax),%eax
  800b65:	83 e8 08             	sub    $0x8,%eax
  800b68:	8b 50 04             	mov    0x4(%eax),%edx
  800b6b:	8b 00                	mov    (%eax),%eax
  800b6d:	eb 38                	jmp    800ba7 <getint+0x5d>
	else if (lflag)
  800b6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b73:	74 1a                	je     800b8f <getint+0x45>
		return va_arg(*ap, long);
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	8d 50 04             	lea    0x4(%eax),%edx
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	89 10                	mov    %edx,(%eax)
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8b 00                	mov    (%eax),%eax
  800b87:	83 e8 04             	sub    $0x4,%eax
  800b8a:	8b 00                	mov    (%eax),%eax
  800b8c:	99                   	cltd   
  800b8d:	eb 18                	jmp    800ba7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 00                	mov    (%eax),%eax
  800b94:	8d 50 04             	lea    0x4(%eax),%edx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	89 10                	mov    %edx,(%eax)
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	8b 00                	mov    (%eax),%eax
  800ba1:	83 e8 04             	sub    $0x4,%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	99                   	cltd   
}
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	56                   	push   %esi
  800bad:	53                   	push   %ebx
  800bae:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb1:	eb 17                	jmp    800bca <vprintfmt+0x21>
			if (ch == '\0')
  800bb3:	85 db                	test   %ebx,%ebx
  800bb5:	0f 84 c1 03 00 00    	je     800f7c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	53                   	push   %ebx
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	ff d0                	call   *%eax
  800bc7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bca:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcd:	8d 50 01             	lea    0x1(%eax),%edx
  800bd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	0f b6 d8             	movzbl %al,%ebx
  800bd8:	83 fb 25             	cmp    $0x25,%ebx
  800bdb:	75 d6                	jne    800bb3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bdd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800be1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800be8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bf6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800c00:	8d 50 01             	lea    0x1(%eax),%edx
  800c03:	89 55 10             	mov    %edx,0x10(%ebp)
  800c06:	8a 00                	mov    (%eax),%al
  800c08:	0f b6 d8             	movzbl %al,%ebx
  800c0b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c0e:	83 f8 5b             	cmp    $0x5b,%eax
  800c11:	0f 87 3d 03 00 00    	ja     800f54 <vprintfmt+0x3ab>
  800c17:	8b 04 85 38 4e 80 00 	mov    0x804e38(,%eax,4),%eax
  800c1e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c20:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c24:	eb d7                	jmp    800bfd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c26:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c2a:	eb d1                	jmp    800bfd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c36:	89 d0                	mov    %edx,%eax
  800c38:	c1 e0 02             	shl    $0x2,%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	01 c0                	add    %eax,%eax
  800c3f:	01 d8                	add    %ebx,%eax
  800c41:	83 e8 30             	sub    $0x30,%eax
  800c44:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c47:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c4f:	83 fb 2f             	cmp    $0x2f,%ebx
  800c52:	7e 3e                	jle    800c92 <vprintfmt+0xe9>
  800c54:	83 fb 39             	cmp    $0x39,%ebx
  800c57:	7f 39                	jg     800c92 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c59:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c5c:	eb d5                	jmp    800c33 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 c0 04             	add    $0x4,%eax
  800c64:	89 45 14             	mov    %eax,0x14(%ebp)
  800c67:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6a:	83 e8 04             	sub    $0x4,%eax
  800c6d:	8b 00                	mov    (%eax),%eax
  800c6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c72:	eb 1f                	jmp    800c93 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c78:	79 83                	jns    800bfd <vprintfmt+0x54>
				width = 0;
  800c7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c81:	e9 77 ff ff ff       	jmp    800bfd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c86:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c8d:	e9 6b ff ff ff       	jmp    800bfd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c92:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c97:	0f 89 60 ff ff ff    	jns    800bfd <vprintfmt+0x54>
				width = precision, precision = -1;
  800c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ca3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800caa:	e9 4e ff ff ff       	jmp    800bfd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800caf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cb2:	e9 46 ff ff ff       	jmp    800bfd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cba:	83 c0 04             	add    $0x4,%eax
  800cbd:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	83 e8 04             	sub    $0x4,%eax
  800cc6:	8b 00                	mov    (%eax),%eax
  800cc8:	83 ec 08             	sub    $0x8,%esp
  800ccb:	ff 75 0c             	pushl  0xc(%ebp)
  800cce:	50                   	push   %eax
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	ff d0                	call   *%eax
  800cd4:	83 c4 10             	add    $0x10,%esp
			break;
  800cd7:	e9 9b 02 00 00       	jmp    800f77 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdf:	83 c0 04             	add    $0x4,%eax
  800ce2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce8:	83 e8 04             	sub    $0x4,%eax
  800ceb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ced:	85 db                	test   %ebx,%ebx
  800cef:	79 02                	jns    800cf3 <vprintfmt+0x14a>
				err = -err;
  800cf1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cf3:	83 fb 64             	cmp    $0x64,%ebx
  800cf6:	7f 0b                	jg     800d03 <vprintfmt+0x15a>
  800cf8:	8b 34 9d 80 4c 80 00 	mov    0x804c80(,%ebx,4),%esi
  800cff:	85 f6                	test   %esi,%esi
  800d01:	75 19                	jne    800d1c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d03:	53                   	push   %ebx
  800d04:	68 25 4e 80 00       	push   $0x804e25
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	ff 75 08             	pushl  0x8(%ebp)
  800d0f:	e8 70 02 00 00       	call   800f84 <printfmt>
  800d14:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d17:	e9 5b 02 00 00       	jmp    800f77 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d1c:	56                   	push   %esi
  800d1d:	68 2e 4e 80 00       	push   $0x804e2e
  800d22:	ff 75 0c             	pushl  0xc(%ebp)
  800d25:	ff 75 08             	pushl  0x8(%ebp)
  800d28:	e8 57 02 00 00       	call   800f84 <printfmt>
  800d2d:	83 c4 10             	add    $0x10,%esp
			break;
  800d30:	e9 42 02 00 00       	jmp    800f77 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d35:	8b 45 14             	mov    0x14(%ebp),%eax
  800d38:	83 c0 04             	add    $0x4,%eax
  800d3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d41:	83 e8 04             	sub    $0x4,%eax
  800d44:	8b 30                	mov    (%eax),%esi
  800d46:	85 f6                	test   %esi,%esi
  800d48:	75 05                	jne    800d4f <vprintfmt+0x1a6>
				p = "(null)";
  800d4a:	be 31 4e 80 00       	mov    $0x804e31,%esi
			if (width > 0 && padc != '-')
  800d4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d53:	7e 6d                	jle    800dc2 <vprintfmt+0x219>
  800d55:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d59:	74 67                	je     800dc2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d5e:	83 ec 08             	sub    $0x8,%esp
  800d61:	50                   	push   %eax
  800d62:	56                   	push   %esi
  800d63:	e8 1e 03 00 00       	call   801086 <strnlen>
  800d68:	83 c4 10             	add    $0x10,%esp
  800d6b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d6e:	eb 16                	jmp    800d86 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d70:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d74:	83 ec 08             	sub    $0x8,%esp
  800d77:	ff 75 0c             	pushl  0xc(%ebp)
  800d7a:	50                   	push   %eax
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	ff d0                	call   *%eax
  800d80:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d83:	ff 4d e4             	decl   -0x1c(%ebp)
  800d86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8a:	7f e4                	jg     800d70 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8c:	eb 34                	jmp    800dc2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d92:	74 1c                	je     800db0 <vprintfmt+0x207>
  800d94:	83 fb 1f             	cmp    $0x1f,%ebx
  800d97:	7e 05                	jle    800d9e <vprintfmt+0x1f5>
  800d99:	83 fb 7e             	cmp    $0x7e,%ebx
  800d9c:	7e 12                	jle    800db0 <vprintfmt+0x207>
					putch('?', putdat);
  800d9e:	83 ec 08             	sub    $0x8,%esp
  800da1:	ff 75 0c             	pushl  0xc(%ebp)
  800da4:	6a 3f                	push   $0x3f
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	ff d0                	call   *%eax
  800dab:	83 c4 10             	add    $0x10,%esp
  800dae:	eb 0f                	jmp    800dbf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800db0:	83 ec 08             	sub    $0x8,%esp
  800db3:	ff 75 0c             	pushl  0xc(%ebp)
  800db6:	53                   	push   %ebx
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	ff d0                	call   *%eax
  800dbc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dbf:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc2:	89 f0                	mov    %esi,%eax
  800dc4:	8d 70 01             	lea    0x1(%eax),%esi
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	0f be d8             	movsbl %al,%ebx
  800dcc:	85 db                	test   %ebx,%ebx
  800dce:	74 24                	je     800df4 <vprintfmt+0x24b>
  800dd0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd4:	78 b8                	js     800d8e <vprintfmt+0x1e5>
  800dd6:	ff 4d e0             	decl   -0x20(%ebp)
  800dd9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ddd:	79 af                	jns    800d8e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ddf:	eb 13                	jmp    800df4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800de1:	83 ec 08             	sub    $0x8,%esp
  800de4:	ff 75 0c             	pushl  0xc(%ebp)
  800de7:	6a 20                	push   $0x20
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	ff d0                	call   *%eax
  800dee:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df1:	ff 4d e4             	decl   -0x1c(%ebp)
  800df4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df8:	7f e7                	jg     800de1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dfa:	e9 78 01 00 00       	jmp    800f77 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	ff 75 e8             	pushl  -0x18(%ebp)
  800e05:	8d 45 14             	lea    0x14(%ebp),%eax
  800e08:	50                   	push   %eax
  800e09:	e8 3c fd ff ff       	call   800b4a <getint>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1d:	85 d2                	test   %edx,%edx
  800e1f:	79 23                	jns    800e44 <vprintfmt+0x29b>
				putch('-', putdat);
  800e21:	83 ec 08             	sub    $0x8,%esp
  800e24:	ff 75 0c             	pushl  0xc(%ebp)
  800e27:	6a 2d                	push   $0x2d
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	ff d0                	call   *%eax
  800e2e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e37:	f7 d8                	neg    %eax
  800e39:	83 d2 00             	adc    $0x0,%edx
  800e3c:	f7 da                	neg    %edx
  800e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e44:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e4b:	e9 bc 00 00 00       	jmp    800f0c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	ff 75 e8             	pushl  -0x18(%ebp)
  800e56:	8d 45 14             	lea    0x14(%ebp),%eax
  800e59:	50                   	push   %eax
  800e5a:	e8 84 fc ff ff       	call   800ae3 <getuint>
  800e5f:	83 c4 10             	add    $0x10,%esp
  800e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e68:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e6f:	e9 98 00 00 00       	jmp    800f0c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e74:	83 ec 08             	sub    $0x8,%esp
  800e77:	ff 75 0c             	pushl  0xc(%ebp)
  800e7a:	6a 58                	push   $0x58
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	ff d0                	call   *%eax
  800e81:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	6a 58                	push   $0x58
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	ff d0                	call   *%eax
  800e91:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e94:	83 ec 08             	sub    $0x8,%esp
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	6a 58                	push   $0x58
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	ff d0                	call   *%eax
  800ea1:	83 c4 10             	add    $0x10,%esp
			break;
  800ea4:	e9 ce 00 00 00       	jmp    800f77 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ea9:	83 ec 08             	sub    $0x8,%esp
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	6a 30                	push   $0x30
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	ff d0                	call   *%eax
  800eb6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 0c             	pushl  0xc(%ebp)
  800ebf:	6a 78                	push   $0x78
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	ff d0                	call   *%eax
  800ec6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ec9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecc:	83 c0 04             	add    $0x4,%eax
  800ecf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed5:	83 e8 04             	sub    $0x4,%eax
  800ed8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ee4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eeb:	eb 1f                	jmp    800f0c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eed:	83 ec 08             	sub    $0x8,%esp
  800ef0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef6:	50                   	push   %eax
  800ef7:	e8 e7 fb ff ff       	call   800ae3 <getuint>
  800efc:	83 c4 10             	add    $0x10,%esp
  800eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f02:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f05:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f0c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f13:	83 ec 04             	sub    $0x4,%esp
  800f16:	52                   	push   %edx
  800f17:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1a:	50                   	push   %eax
  800f1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1e:	ff 75 f0             	pushl  -0x10(%ebp)
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	ff 75 08             	pushl  0x8(%ebp)
  800f27:	e8 00 fb ff ff       	call   800a2c <printnum>
  800f2c:	83 c4 20             	add    $0x20,%esp
			break;
  800f2f:	eb 46                	jmp    800f77 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f31:	83 ec 08             	sub    $0x8,%esp
  800f34:	ff 75 0c             	pushl  0xc(%ebp)
  800f37:	53                   	push   %ebx
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	ff d0                	call   *%eax
  800f3d:	83 c4 10             	add    $0x10,%esp
			break;
  800f40:	eb 35                	jmp    800f77 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f42:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  800f49:	eb 2c                	jmp    800f77 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f4b:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  800f52:	eb 23                	jmp    800f77 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f54:	83 ec 08             	sub    $0x8,%esp
  800f57:	ff 75 0c             	pushl  0xc(%ebp)
  800f5a:	6a 25                	push   $0x25
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff d0                	call   *%eax
  800f61:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f64:	ff 4d 10             	decl   0x10(%ebp)
  800f67:	eb 03                	jmp    800f6c <vprintfmt+0x3c3>
  800f69:	ff 4d 10             	decl   0x10(%ebp)
  800f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6f:	48                   	dec    %eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 25                	cmp    $0x25,%al
  800f74:	75 f3                	jne    800f69 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800f76:	90                   	nop
		}
	}
  800f77:	e9 35 fc ff ff       	jmp    800bb1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f7c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5d                   	pop    %ebp
  800f83:	c3                   	ret    

00800f84 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f8a:	8d 45 10             	lea    0x10(%ebp),%eax
  800f8d:	83 c0 04             	add    $0x4,%eax
  800f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f93:	8b 45 10             	mov    0x10(%ebp),%eax
  800f96:	ff 75 f4             	pushl  -0xc(%ebp)
  800f99:	50                   	push   %eax
  800f9a:	ff 75 0c             	pushl  0xc(%ebp)
  800f9d:	ff 75 08             	pushl  0x8(%ebp)
  800fa0:	e8 04 fc ff ff       	call   800ba9 <vprintfmt>
  800fa5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fa8:	90                   	nop
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8b 40 08             	mov    0x8(%eax),%eax
  800fb4:	8d 50 01             	lea    0x1(%eax),%edx
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8b 10                	mov    (%eax),%edx
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	8b 40 04             	mov    0x4(%eax),%eax
  800fc8:	39 c2                	cmp    %eax,%edx
  800fca:	73 12                	jae    800fde <sprintputch+0x33>
		*b->buf++ = ch;
  800fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcf:	8b 00                	mov    (%eax),%eax
  800fd1:	8d 48 01             	lea    0x1(%eax),%ecx
  800fd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd7:	89 0a                	mov    %ecx,(%edx)
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	88 10                	mov    %dl,(%eax)
}
  800fde:	90                   	nop
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801002:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801006:	74 06                	je     80100e <vsnprintf+0x2d>
  801008:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100c:	7f 07                	jg     801015 <vsnprintf+0x34>
		return -E_INVAL;
  80100e:	b8 03 00 00 00       	mov    $0x3,%eax
  801013:	eb 20                	jmp    801035 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801015:	ff 75 14             	pushl  0x14(%ebp)
  801018:	ff 75 10             	pushl  0x10(%ebp)
  80101b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80101e:	50                   	push   %eax
  80101f:	68 ab 0f 80 00       	push   $0x800fab
  801024:	e8 80 fb ff ff       	call   800ba9 <vprintfmt>
  801029:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80102c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80102f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801032:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80103d:	8d 45 10             	lea    0x10(%ebp),%eax
  801040:	83 c0 04             	add    $0x4,%eax
  801043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	ff 75 f4             	pushl  -0xc(%ebp)
  80104c:	50                   	push   %eax
  80104d:	ff 75 0c             	pushl  0xc(%ebp)
  801050:	ff 75 08             	pushl  0x8(%ebp)
  801053:	e8 89 ff ff ff       	call   800fe1 <vsnprintf>
  801058:	83 c4 10             	add    $0x10,%esp
  80105b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80105e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801069:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801070:	eb 06                	jmp    801078 <strlen+0x15>
		n++;
  801072:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	84 c0                	test   %al,%al
  80107f:	75 f1                	jne    801072 <strlen+0xf>
		n++;
	return n;
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801084:	c9                   	leave  
  801085:	c3                   	ret    

00801086 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80108c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801093:	eb 09                	jmp    80109e <strnlen+0x18>
		n++;
  801095:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801098:	ff 45 08             	incl   0x8(%ebp)
  80109b:	ff 4d 0c             	decl   0xc(%ebp)
  80109e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a2:	74 09                	je     8010ad <strnlen+0x27>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 e8                	jne    801095 <strnlen+0xf>
		n++;
	return n;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010be:	90                   	nop
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8d 50 01             	lea    0x1(%eax),%edx
  8010c5:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ce:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010d1:	8a 12                	mov    (%edx),%dl
  8010d3:	88 10                	mov    %dl,(%eax)
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	84 c0                	test   %al,%al
  8010d9:	75 e4                	jne    8010bf <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010f3:	eb 1f                	jmp    801114 <strncpy+0x34>
		*dst++ = *src;
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8d 50 01             	lea    0x1(%eax),%edx
  8010fb:	89 55 08             	mov    %edx,0x8(%ebp)
  8010fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801101:	8a 12                	mov    (%edx),%dl
  801103:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801105:	8b 45 0c             	mov    0xc(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	84 c0                	test   %al,%al
  80110c:	74 03                	je     801111 <strncpy+0x31>
			src++;
  80110e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801111:	ff 45 fc             	incl   -0x4(%ebp)
  801114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801117:	3b 45 10             	cmp    0x10(%ebp),%eax
  80111a:	72 d9                	jb     8010f5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80111c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80112d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801131:	74 30                	je     801163 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801133:	eb 16                	jmp    80114b <strlcpy+0x2a>
			*dst++ = *src++;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	89 55 08             	mov    %edx,0x8(%ebp)
  80113e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801141:	8d 4a 01             	lea    0x1(%edx),%ecx
  801144:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801147:	8a 12                	mov    (%edx),%dl
  801149:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80114b:	ff 4d 10             	decl   0x10(%ebp)
  80114e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801152:	74 09                	je     80115d <strlcpy+0x3c>
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	84 c0                	test   %al,%al
  80115b:	75 d8                	jne    801135 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801163:	8b 55 08             	mov    0x8(%ebp),%edx
  801166:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801169:	29 c2                	sub    %eax,%edx
  80116b:	89 d0                	mov    %edx,%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801172:	eb 06                	jmp    80117a <strcmp+0xb>
		p++, q++;
  801174:	ff 45 08             	incl   0x8(%ebp)
  801177:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	84 c0                	test   %al,%al
  801181:	74 0e                	je     801191 <strcmp+0x22>
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 10                	mov    (%eax),%dl
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	38 c2                	cmp    %al,%dl
  80118f:	74 e3                	je     801174 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	0f b6 d0             	movzbl %al,%edx
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	8a 00                	mov    (%eax),%al
  80119e:	0f b6 c0             	movzbl %al,%eax
  8011a1:	29 c2                	sub    %eax,%edx
  8011a3:	89 d0                	mov    %edx,%eax
}
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011aa:	eb 09                	jmp    8011b5 <strncmp+0xe>
		n--, p++, q++;
  8011ac:	ff 4d 10             	decl   0x10(%ebp)
  8011af:	ff 45 08             	incl   0x8(%ebp)
  8011b2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b9:	74 17                	je     8011d2 <strncmp+0x2b>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	84 c0                	test   %al,%al
  8011c2:	74 0e                	je     8011d2 <strncmp+0x2b>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 10                	mov    (%eax),%dl
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	38 c2                	cmp    %al,%dl
  8011d0:	74 da                	je     8011ac <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d6:	75 07                	jne    8011df <strncmp+0x38>
		return 0;
  8011d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011dd:	eb 14                	jmp    8011f3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	0f b6 d0             	movzbl %al,%edx
  8011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	0f b6 c0             	movzbl %al,%eax
  8011ef:	29 c2                	sub    %eax,%edx
  8011f1:	89 d0                	mov    %edx,%eax
}
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    

008011f5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 04             	sub    $0x4,%esp
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801201:	eb 12                	jmp    801215 <strchr+0x20>
		if (*s == c)
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80120b:	75 05                	jne    801212 <strchr+0x1d>
			return (char *) s;
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	eb 11                	jmp    801223 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801212:	ff 45 08             	incl   0x8(%ebp)
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	84 c0                	test   %al,%al
  80121c:	75 e5                	jne    801203 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80121e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	83 ec 04             	sub    $0x4,%esp
  80122b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801231:	eb 0d                	jmp    801240 <strfind+0x1b>
		if (*s == c)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80123b:	74 0e                	je     80124b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80123d:	ff 45 08             	incl   0x8(%ebp)
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	84 c0                	test   %al,%al
  801247:	75 ea                	jne    801233 <strfind+0xe>
  801249:	eb 01                	jmp    80124c <strfind+0x27>
		if (*s == c)
			break;
  80124b:	90                   	nop
	return (char *) s;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80125d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801261:	76 63                	jbe    8012c6 <memset+0x75>
		uint64 data_block = c;
  801263:	8b 45 0c             	mov    0xc(%ebp),%eax
  801266:	99                   	cltd   
  801267:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80126a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80126d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801273:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801277:	c1 e0 08             	shl    $0x8,%eax
  80127a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80127d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801286:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80128a:	c1 e0 10             	shl    $0x10,%eax
  80128d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801290:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801299:	89 c2                	mov    %eax,%edx
  80129b:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8012a3:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8012a6:	eb 18                	jmp    8012c0 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8012a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ab:	8d 41 08             	lea    0x8(%ecx),%eax
  8012ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8012b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b7:	89 01                	mov    %eax,(%ecx)
  8012b9:	89 51 04             	mov    %edx,0x4(%ecx)
  8012bc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8012c0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012c4:	77 e2                	ja     8012a8 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8012c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ca:	74 23                	je     8012ef <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8012cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012d2:	eb 0e                	jmp    8012e2 <memset+0x91>
			*p8++ = (uint8)c;
  8012d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e0:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	75 e5                	jne    8012d4 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8012fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801306:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80130a:	76 24                	jbe    801330 <memcpy+0x3c>
		while(n >= 8){
  80130c:	eb 1c                	jmp    80132a <memcpy+0x36>
			*d64 = *s64;
  80130e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801311:	8b 50 04             	mov    0x4(%eax),%edx
  801314:	8b 00                	mov    (%eax),%eax
  801316:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801319:	89 01                	mov    %eax,(%ecx)
  80131b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80131e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801322:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801326:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80132a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80132e:	77 de                	ja     80130e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801334:	74 31                	je     801367 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801336:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801339:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80133c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801342:	eb 16                	jmp    80135a <memcpy+0x66>
			*d8++ = *s8++;
  801344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801347:	8d 50 01             	lea    0x1(%eax),%edx
  80134a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80134d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801350:	8d 4a 01             	lea    0x1(%edx),%ecx
  801353:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801356:	8a 12                	mov    (%edx),%dl
  801358:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80135a:	8b 45 10             	mov    0x10(%ebp),%eax
  80135d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801360:	89 55 10             	mov    %edx,0x10(%ebp)
  801363:	85 c0                	test   %eax,%eax
  801365:	75 dd                	jne    801344 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801372:	8b 45 0c             	mov    0xc(%ebp),%eax
  801375:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801384:	73 50                	jae    8013d6 <memmove+0x6a>
  801386:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801389:	8b 45 10             	mov    0x10(%ebp),%eax
  80138c:	01 d0                	add    %edx,%eax
  80138e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801391:	76 43                	jbe    8013d6 <memmove+0x6a>
		s += n;
  801393:	8b 45 10             	mov    0x10(%ebp),%eax
  801396:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801399:	8b 45 10             	mov    0x10(%ebp),%eax
  80139c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80139f:	eb 10                	jmp    8013b1 <memmove+0x45>
			*--d = *--s;
  8013a1:	ff 4d f8             	decl   -0x8(%ebp)
  8013a4:	ff 4d fc             	decl   -0x4(%ebp)
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013aa:	8a 10                	mov    (%eax),%dl
  8013ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013af:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	75 e3                	jne    8013a1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8013be:	eb 23                	jmp    8013e3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8d 50 01             	lea    0x1(%eax),%edx
  8013c6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013cf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013d2:	8a 12                	mov    (%edx),%dl
  8013d4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	75 dd                	jne    8013c0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013fa:	eb 2a                	jmp    801426 <memcmp+0x3e>
		if (*s1 != *s2)
  8013fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ff:	8a 10                	mov    (%eax),%dl
  801401:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	38 c2                	cmp    %al,%dl
  801408:	74 16                	je     801420 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80140a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	0f b6 d0             	movzbl %al,%edx
  801412:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	29 c2                	sub    %eax,%edx
  80141c:	89 d0                	mov    %edx,%eax
  80141e:	eb 18                	jmp    801438 <memcmp+0x50>
		s1++, s2++;
  801420:	ff 45 fc             	incl   -0x4(%ebp)
  801423:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801426:	8b 45 10             	mov    0x10(%ebp),%eax
  801429:	8d 50 ff             	lea    -0x1(%eax),%edx
  80142c:	89 55 10             	mov    %edx,0x10(%ebp)
  80142f:	85 c0                	test   %eax,%eax
  801431:	75 c9                	jne    8013fc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801433:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801440:	8b 55 08             	mov    0x8(%ebp),%edx
  801443:	8b 45 10             	mov    0x10(%ebp),%eax
  801446:	01 d0                	add    %edx,%eax
  801448:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80144b:	eb 15                	jmp    801462 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	0f b6 d0             	movzbl %al,%edx
  801455:	8b 45 0c             	mov    0xc(%ebp),%eax
  801458:	0f b6 c0             	movzbl %al,%eax
  80145b:	39 c2                	cmp    %eax,%edx
  80145d:	74 0d                	je     80146c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80145f:	ff 45 08             	incl   0x8(%ebp)
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801468:	72 e3                	jb     80144d <memfind+0x13>
  80146a:	eb 01                	jmp    80146d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80146c:	90                   	nop
	return (void *) s;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801478:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80147f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801486:	eb 03                	jmp    80148b <strtol+0x19>
		s++;
  801488:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	3c 20                	cmp    $0x20,%al
  801492:	74 f4                	je     801488 <strtol+0x16>
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	3c 09                	cmp    $0x9,%al
  80149b:	74 eb                	je     801488 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3c 2b                	cmp    $0x2b,%al
  8014a4:	75 05                	jne    8014ab <strtol+0x39>
		s++;
  8014a6:	ff 45 08             	incl   0x8(%ebp)
  8014a9:	eb 13                	jmp    8014be <strtol+0x4c>
	else if (*s == '-')
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	3c 2d                	cmp    $0x2d,%al
  8014b2:	75 0a                	jne    8014be <strtol+0x4c>
		s++, neg = 1;
  8014b4:	ff 45 08             	incl   0x8(%ebp)
  8014b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c2:	74 06                	je     8014ca <strtol+0x58>
  8014c4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014c8:	75 20                	jne    8014ea <strtol+0x78>
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	3c 30                	cmp    $0x30,%al
  8014d1:	75 17                	jne    8014ea <strtol+0x78>
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	40                   	inc    %eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	3c 78                	cmp    $0x78,%al
  8014db:	75 0d                	jne    8014ea <strtol+0x78>
		s += 2, base = 16;
  8014dd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014e1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014e8:	eb 28                	jmp    801512 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ee:	75 15                	jne    801505 <strtol+0x93>
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	3c 30                	cmp    $0x30,%al
  8014f7:	75 0c                	jne    801505 <strtol+0x93>
		s++, base = 8;
  8014f9:	ff 45 08             	incl   0x8(%ebp)
  8014fc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801503:	eb 0d                	jmp    801512 <strtol+0xa0>
	else if (base == 0)
  801505:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801509:	75 07                	jne    801512 <strtol+0xa0>
		base = 10;
  80150b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	3c 2f                	cmp    $0x2f,%al
  801519:	7e 19                	jle    801534 <strtol+0xc2>
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	3c 39                	cmp    $0x39,%al
  801522:	7f 10                	jg     801534 <strtol+0xc2>
			dig = *s - '0';
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	0f be c0             	movsbl %al,%eax
  80152c:	83 e8 30             	sub    $0x30,%eax
  80152f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801532:	eb 42                	jmp    801576 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	8a 00                	mov    (%eax),%al
  801539:	3c 60                	cmp    $0x60,%al
  80153b:	7e 19                	jle    801556 <strtol+0xe4>
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	8a 00                	mov    (%eax),%al
  801542:	3c 7a                	cmp    $0x7a,%al
  801544:	7f 10                	jg     801556 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8a 00                	mov    (%eax),%al
  80154b:	0f be c0             	movsbl %al,%eax
  80154e:	83 e8 57             	sub    $0x57,%eax
  801551:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801554:	eb 20                	jmp    801576 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	8a 00                	mov    (%eax),%al
  80155b:	3c 40                	cmp    $0x40,%al
  80155d:	7e 39                	jle    801598 <strtol+0x126>
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	8a 00                	mov    (%eax),%al
  801564:	3c 5a                	cmp    $0x5a,%al
  801566:	7f 30                	jg     801598 <strtol+0x126>
			dig = *s - 'A' + 10;
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	0f be c0             	movsbl %al,%eax
  801570:	83 e8 37             	sub    $0x37,%eax
  801573:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801579:	3b 45 10             	cmp    0x10(%ebp),%eax
  80157c:	7d 19                	jge    801597 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80157e:	ff 45 08             	incl   0x8(%ebp)
  801581:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801584:	0f af 45 10          	imul   0x10(%ebp),%eax
  801588:	89 c2                	mov    %eax,%edx
  80158a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158d:	01 d0                	add    %edx,%eax
  80158f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801592:	e9 7b ff ff ff       	jmp    801512 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801597:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801598:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80159c:	74 08                	je     8015a6 <strtol+0x134>
		*endptr = (char *) s;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015aa:	74 07                	je     8015b3 <strtol+0x141>
  8015ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015af:	f7 d8                	neg    %eax
  8015b1:	eb 03                	jmp    8015b6 <strtol+0x144>
  8015b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <ltostr>:

void
ltostr(long value, char *str)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8015be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015d0:	79 13                	jns    8015e5 <ltostr+0x2d>
	{
		neg = 1;
  8015d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015df:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015e2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015ed:	99                   	cltd   
  8015ee:	f7 f9                	idiv   %ecx
  8015f0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f6:	8d 50 01             	lea    0x1(%eax),%edx
  8015f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015fc:	89 c2                	mov    %eax,%edx
  8015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801606:	83 c2 30             	add    $0x30,%edx
  801609:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80160b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80160e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801613:	f7 e9                	imul   %ecx
  801615:	c1 fa 02             	sar    $0x2,%edx
  801618:	89 c8                	mov    %ecx,%eax
  80161a:	c1 f8 1f             	sar    $0x1f,%eax
  80161d:	29 c2                	sub    %eax,%edx
  80161f:	89 d0                	mov    %edx,%eax
  801621:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801624:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801628:	75 bb                	jne    8015e5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80162a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801631:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801634:	48                   	dec    %eax
  801635:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801638:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80163c:	74 3d                	je     80167b <ltostr+0xc3>
		start = 1 ;
  80163e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801645:	eb 34                	jmp    80167b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801647:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164d:	01 d0                	add    %edx,%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	01 c2                	add    %eax,%edx
  80165c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80165f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801662:	01 c8                	add    %ecx,%eax
  801664:	8a 00                	mov    (%eax),%al
  801666:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801668:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	01 c2                	add    %eax,%edx
  801670:	8a 45 eb             	mov    -0x15(%ebp),%al
  801673:	88 02                	mov    %al,(%edx)
		start++ ;
  801675:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801678:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80167b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801681:	7c c4                	jl     801647 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801683:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801686:	8b 45 0c             	mov    0xc(%ebp),%eax
  801689:	01 d0                	add    %edx,%eax
  80168b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80168e:	90                   	nop
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 c4 f9 ff ff       	call   801063 <strlen>
  80169f:	83 c4 04             	add    $0x4,%esp
  8016a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016a5:	ff 75 0c             	pushl  0xc(%ebp)
  8016a8:	e8 b6 f9 ff ff       	call   801063 <strlen>
  8016ad:	83 c4 04             	add    $0x4,%esp
  8016b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c1:	eb 17                	jmp    8016da <strcconcat+0x49>
		final[s] = str1[s] ;
  8016c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c9:	01 c2                	add    %eax,%edx
  8016cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	01 c8                	add    %ecx,%eax
  8016d3:	8a 00                	mov    (%eax),%al
  8016d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016d7:	ff 45 fc             	incl   -0x4(%ebp)
  8016da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016e0:	7c e1                	jl     8016c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016f0:	eb 1f                	jmp    801711 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f5:	8d 50 01             	lea    0x1(%eax),%edx
  8016f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016fb:	89 c2                	mov    %eax,%edx
  8016fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801700:	01 c2                	add    %eax,%edx
  801702:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	01 c8                	add    %ecx,%eax
  80170a:	8a 00                	mov    (%eax),%al
  80170c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80170e:	ff 45 f8             	incl   -0x8(%ebp)
  801711:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801714:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801717:	7c d9                	jl     8016f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801719:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171c:	8b 45 10             	mov    0x10(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	c6 00 00             	movb   $0x0,(%eax)
}
  801724:	90                   	nop
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80172a:	8b 45 14             	mov    0x14(%ebp),%eax
  80172d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801733:	8b 45 14             	mov    0x14(%ebp),%eax
  801736:	8b 00                	mov    (%eax),%eax
  801738:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80173f:	8b 45 10             	mov    0x10(%ebp),%eax
  801742:	01 d0                	add    %edx,%eax
  801744:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80174a:	eb 0c                	jmp    801758 <strsplit+0x31>
			*string++ = 0;
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	8d 50 01             	lea    0x1(%eax),%edx
  801752:	89 55 08             	mov    %edx,0x8(%ebp)
  801755:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	8a 00                	mov    (%eax),%al
  80175d:	84 c0                	test   %al,%al
  80175f:	74 18                	je     801779 <strsplit+0x52>
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	8a 00                	mov    (%eax),%al
  801766:	0f be c0             	movsbl %al,%eax
  801769:	50                   	push   %eax
  80176a:	ff 75 0c             	pushl  0xc(%ebp)
  80176d:	e8 83 fa ff ff       	call   8011f5 <strchr>
  801772:	83 c4 08             	add    $0x8,%esp
  801775:	85 c0                	test   %eax,%eax
  801777:	75 d3                	jne    80174c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	8a 00                	mov    (%eax),%al
  80177e:	84 c0                	test   %al,%al
  801780:	74 5a                	je     8017dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801782:	8b 45 14             	mov    0x14(%ebp),%eax
  801785:	8b 00                	mov    (%eax),%eax
  801787:	83 f8 0f             	cmp    $0xf,%eax
  80178a:	75 07                	jne    801793 <strsplit+0x6c>
		{
			return 0;
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
  801791:	eb 66                	jmp    8017f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801793:	8b 45 14             	mov    0x14(%ebp),%eax
  801796:	8b 00                	mov    (%eax),%eax
  801798:	8d 48 01             	lea    0x1(%eax),%ecx
  80179b:	8b 55 14             	mov    0x14(%ebp),%edx
  80179e:	89 0a                	mov    %ecx,(%edx)
  8017a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017aa:	01 c2                	add    %eax,%edx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b1:	eb 03                	jmp    8017b6 <strsplit+0x8f>
			string++;
  8017b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	84 c0                	test   %al,%al
  8017bd:	74 8b                	je     80174a <strsplit+0x23>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	0f be c0             	movsbl %al,%eax
  8017c7:	50                   	push   %eax
  8017c8:	ff 75 0c             	pushl  0xc(%ebp)
  8017cb:	e8 25 fa ff ff       	call   8011f5 <strchr>
  8017d0:	83 c4 08             	add    $0x8,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	74 dc                	je     8017b3 <strsplit+0x8c>
			string++;
	}
  8017d7:	e9 6e ff ff ff       	jmp    80174a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e0:	8b 00                	mov    (%eax),%eax
  8017e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ec:	01 d0                	add    %edx,%eax
  8017ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801807:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80180e:	eb 4a                	jmp    80185a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801810:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	01 c2                	add    %eax,%edx
  801818:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80181b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181e:	01 c8                	add    %ecx,%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801824:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182a:	01 d0                	add    %edx,%eax
  80182c:	8a 00                	mov    (%eax),%al
  80182e:	3c 40                	cmp    $0x40,%al
  801830:	7e 25                	jle    801857 <str2lower+0x5c>
  801832:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801835:	8b 45 0c             	mov    0xc(%ebp),%eax
  801838:	01 d0                	add    %edx,%eax
  80183a:	8a 00                	mov    (%eax),%al
  80183c:	3c 5a                	cmp    $0x5a,%al
  80183e:	7f 17                	jg     801857 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801840:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	01 d0                	add    %edx,%eax
  801848:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80184b:	8b 55 08             	mov    0x8(%ebp),%edx
  80184e:	01 ca                	add    %ecx,%edx
  801850:	8a 12                	mov    (%edx),%dl
  801852:	83 c2 20             	add    $0x20,%edx
  801855:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801857:	ff 45 fc             	incl   -0x4(%ebp)
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	e8 01 f8 ff ff       	call   801063 <strlen>
  801862:	83 c4 04             	add    $0x4,%esp
  801865:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801868:	7f a6                	jg     801810 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80186a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801875:	a1 08 60 80 00       	mov    0x806008,%eax
  80187a:	85 c0                	test   %eax,%eax
  80187c:	74 42                	je     8018c0 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80187e:	83 ec 08             	sub    $0x8,%esp
  801881:	68 00 00 00 82       	push   $0x82000000
  801886:	68 00 00 00 80       	push   $0x80000000
  80188b:	e8 b0 1e 00 00       	call   803740 <initialize_dynamic_allocator>
  801890:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801893:	e8 96 1c 00 00       	call   80352e <sys_get_uheap_strategy>
  801898:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80189d:	a1 60 e0 81 00       	mov    0x81e060,%eax
  8018a2:	05 00 10 00 00       	add    $0x1000,%eax
  8018a7:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  8018ac:	a1 30 61 83 00       	mov    0x836130,%eax
  8018b1:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  8018b6:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  8018bd:	00 00 00 
	}
}
  8018c0:	90                   	nop
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018d7:	83 ec 08             	sub    $0x8,%esp
  8018da:	68 06 04 00 00       	push   $0x406
  8018df:	50                   	push   %eax
  8018e0:	e8 93 18 00 00       	call   803178 <__sys_allocate_page>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8018eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018ef:	79 14                	jns    801905 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	68 a8 4f 80 00       	push   $0x804fa8
  8018f9:	6a 1f                	push   $0x1f
  8018fb:	68 e4 4f 80 00       	push   $0x804fe4
  801900:	e8 b7 ed ff ff       	call   8006bc <_panic>
	return 0;
  801905:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801920:	83 ec 0c             	sub    $0xc,%esp
  801923:	50                   	push   %eax
  801924:	e8 96 18 00 00       	call   8031bf <__sys_unmap_frame>
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80192f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801933:	79 14                	jns    801949 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	68 f0 4f 80 00       	push   $0x804ff0
  80193d:	6a 2a                	push   $0x2a
  80193f:	68 e4 4f 80 00       	push   $0x804fe4
  801944:	e8 73 ed ff ff       	call   8006bc <_panic>
}
  801949:	90                   	nop
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801952:	e8 18 ff ff ff       	call   80186f <uheap_init>
	if (size == 0) return NULL ;
  801957:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80195b:	75 0a                	jne    801967 <malloc+0x1b>
  80195d:	b8 00 00 00 00       	mov    $0x0,%eax
  801962:	e9 43 03 00 00       	jmp    801caa <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801967:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80196e:	77 13                	ja     801983 <malloc+0x37>
    {
        return alloc_block(size);
  801970:	83 ec 0c             	sub    $0xc,%esp
  801973:	ff 75 08             	pushl  0x8(%ebp)
  801976:	e8 78 20 00 00       	call   8039f3 <alloc_block>
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	e9 27 03 00 00       	jmp    801caa <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801983:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80198a:	8b 55 08             	mov    0x8(%ebp),%edx
  80198d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801990:	01 d0                	add    %edx,%eax
  801992:	48                   	dec    %eax
  801993:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801996:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801999:	ba 00 00 00 00       	mov    $0x0,%edx
  80199e:	f7 75 dc             	divl   -0x24(%ebp)
  8019a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019a4:	29 d0                	sub    %edx,%eax
  8019a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8019a9:	a1 40 e0 81 00       	mov    0x81e040,%eax
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	75 0a                	jne    8019bc <malloc+0x70>
    {
        uhp_inited = 1;
  8019b2:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  8019b9:	00 00 00 
    }

    int exactIdx = -1;
  8019bc:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8019c3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8019ca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8019d8:	e9 85 00 00 00       	jmp    801a62 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8019dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019e0:	89 d0                	mov    %edx,%eax
  8019e2:	01 c0                	add    %eax,%eax
  8019e4:	01 d0                	add    %edx,%eax
  8019e6:	c1 e0 02             	shl    $0x2,%eax
  8019e9:	05 48 20 81 00       	add    $0x812048,%eax
  8019ee:	8a 00                	mov    (%eax),%al
  8019f0:	84 c0                	test   %al,%al
  8019f2:	74 20                	je     801a14 <malloc+0xc8>
  8019f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019f7:	89 d0                	mov    %edx,%eax
  8019f9:	01 c0                	add    %eax,%eax
  8019fb:	01 d0                	add    %edx,%eax
  8019fd:	c1 e0 02             	shl    $0x2,%eax
  801a00:	05 44 20 81 00       	add    $0x812044,%eax
  801a05:	8b 00                	mov    (%eax),%eax
  801a07:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801a0a:	75 08                	jne    801a14 <malloc+0xc8>
        {
            exactIdx = i;
  801a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801a12:	eb 5b                	jmp    801a6f <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801a14:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a17:	89 d0                	mov    %edx,%eax
  801a19:	01 c0                	add    %eax,%eax
  801a1b:	01 d0                	add    %edx,%eax
  801a1d:	c1 e0 02             	shl    $0x2,%eax
  801a20:	05 48 20 81 00       	add    $0x812048,%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	84 c0                	test   %al,%al
  801a29:	74 34                	je     801a5f <malloc+0x113>
  801a2b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a2e:	89 d0                	mov    %edx,%eax
  801a30:	01 c0                	add    %eax,%eax
  801a32:	01 d0                	add    %edx,%eax
  801a34:	c1 e0 02             	shl    $0x2,%eax
  801a37:	05 44 20 81 00       	add    $0x812044,%eax
  801a3c:	8b 00                	mov    (%eax),%eax
  801a3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801a41:	76 1c                	jbe    801a5f <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801a43:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a46:	89 d0                	mov    %edx,%eax
  801a48:	01 c0                	add    %eax,%eax
  801a4a:	01 d0                	add    %edx,%eax
  801a4c:	c1 e0 02             	shl    $0x2,%eax
  801a4f:	05 44 20 81 00       	add    $0x812044,%eax
  801a54:	8b 00                	mov    (%eax),%eax
  801a56:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801a59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801a5f:	ff 45 e8             	incl   -0x18(%ebp)
  801a62:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801a69:	0f 8e 6e ff ff ff    	jle    8019dd <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801a6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801a76:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801a7a:	74 7d                	je     801af9 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801a7c:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a86:	89 d0                	mov    %edx,%eax
  801a88:	01 c0                	add    %eax,%eax
  801a8a:	01 d0                	add    %edx,%eax
  801a8c:	c1 e0 02             	shl    $0x2,%eax
  801a8f:	05 40 20 81 00       	add    $0x812040,%eax
  801a94:	8b 10                	mov    (%eax),%edx
  801a96:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801a99:	01 d0                	add    %edx,%eax
  801a9b:	48                   	dec    %eax
  801a9c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801a9f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa7:	f7 75 bc             	divl   -0x44(%ebp)
  801aaa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801aad:	29 d0                	sub    %edx,%eax
  801aaf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801ab2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab5:	89 d0                	mov    %edx,%eax
  801ab7:	01 c0                	add    %eax,%eax
  801ab9:	01 d0                	add    %edx,%eax
  801abb:	c1 e0 02             	shl    $0x2,%eax
  801abe:	05 48 20 81 00       	add    $0x812048,%eax
  801ac3:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801ac6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac9:	89 d0                	mov    %edx,%eax
  801acb:	01 c0                	add    %eax,%eax
  801acd:	01 d0                	add    %edx,%eax
  801acf:	c1 e0 02             	shl    $0x2,%eax
  801ad2:	05 44 20 81 00       	add    $0x812044,%eax
  801ad7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801add:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae0:	89 d0                	mov    %edx,%eax
  801ae2:	01 c0                	add    %eax,%eax
  801ae4:	01 d0                	add    %edx,%eax
  801ae6:	c1 e0 02             	shl    $0x2,%eax
  801ae9:	05 40 20 81 00       	add    $0x812040,%eax
  801aee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801af4:	e9 2d 01 00 00       	jmp    801c26 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801af9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801afd:	0f 84 ce 00 00 00    	je     801bd1 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801b03:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801b0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b0d:	89 d0                	mov    %edx,%eax
  801b0f:	01 c0                	add    %eax,%eax
  801b11:	01 d0                	add    %edx,%eax
  801b13:	c1 e0 02             	shl    $0x2,%eax
  801b16:	05 40 20 81 00       	add    $0x812040,%eax
  801b1b:	8b 10                	mov    (%eax),%edx
  801b1d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801b20:	01 d0                	add    %edx,%eax
  801b22:	48                   	dec    %eax
  801b23:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801b26:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b29:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2e:	f7 75 c4             	divl   -0x3c(%ebp)
  801b31:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b34:	29 d0                	sub    %edx,%eax
  801b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801b39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b3c:	89 d0                	mov    %edx,%eax
  801b3e:	01 c0                	add    %eax,%eax
  801b40:	01 d0                	add    %edx,%eax
  801b42:	c1 e0 02             	shl    $0x2,%eax
  801b45:	05 44 20 81 00       	add    $0x812044,%eax
  801b4a:	8b 00                	mov    (%eax),%eax
  801b4c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b4f:	75 47                	jne    801b98 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801b51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b54:	89 d0                	mov    %edx,%eax
  801b56:	01 c0                	add    %eax,%eax
  801b58:	01 d0                	add    %edx,%eax
  801b5a:	c1 e0 02             	shl    $0x2,%eax
  801b5d:	05 48 20 81 00       	add    $0x812048,%eax
  801b62:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801b65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b68:	89 d0                	mov    %edx,%eax
  801b6a:	01 c0                	add    %eax,%eax
  801b6c:	01 d0                	add    %edx,%eax
  801b6e:	c1 e0 02             	shl    $0x2,%eax
  801b71:	05 44 20 81 00       	add    $0x812044,%eax
  801b76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801b7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b7f:	89 d0                	mov    %edx,%eax
  801b81:	01 c0                	add    %eax,%eax
  801b83:	01 d0                	add    %edx,%eax
  801b85:	c1 e0 02             	shl    $0x2,%eax
  801b88:	05 40 20 81 00       	add    $0x812040,%eax
  801b8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b93:	e9 8e 00 00 00       	jmp    801c26 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801b98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b9e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ba4:	89 d0                	mov    %edx,%eax
  801ba6:	01 c0                	add    %eax,%eax
  801ba8:	01 d0                	add    %edx,%eax
  801baa:	c1 e0 02             	shl    $0x2,%eax
  801bad:	05 40 20 81 00       	add    $0x812040,%eax
  801bb2:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb7:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801bba:	89 c2                	mov    %eax,%edx
  801bbc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bbf:	89 c8                	mov    %ecx,%eax
  801bc1:	01 c0                	add    %eax,%eax
  801bc3:	01 c8                	add    %ecx,%eax
  801bc5:	c1 e0 02             	shl    $0x2,%eax
  801bc8:	05 44 20 81 00       	add    $0x812044,%eax
  801bcd:	89 10                	mov    %edx,(%eax)
  801bcf:	eb 55                	jmp    801c26 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801bd1:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801bd8:	8b 15 88 60 83 00    	mov    0x836088,%edx
  801bde:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801be1:	01 d0                	add    %edx,%eax
  801be3:	48                   	dec    %eax
  801be4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801be7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801bea:	ba 00 00 00 00       	mov    $0x0,%edx
  801bef:	f7 75 d0             	divl   -0x30(%ebp)
  801bf2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801bf5:	29 d0                	sub    %edx,%eax
  801bf7:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801bfa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801bfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c00:	01 d0                	add    %edx,%eax
  801c02:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801c07:	76 0a                	jbe    801c13 <malloc+0x2c7>
            return NULL;
  801c09:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0e:	e9 97 00 00 00       	jmp    801caa <malloc+0x35e>
        va = start;
  801c13:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801c19:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801c1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c1f:	01 d0                	add    %edx,%eax
  801c21:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c26:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c2d:	eb 5e                	jmp    801c8d <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801c2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c32:	89 d0                	mov    %edx,%eax
  801c34:	01 c0                	add    %eax,%eax
  801c36:	01 d0                	add    %edx,%eax
  801c38:	c1 e0 02             	shl    $0x2,%eax
  801c3b:	05 48 60 80 00       	add    $0x806048,%eax
  801c40:	8a 00                	mov    (%eax),%al
  801c42:	84 c0                	test   %al,%al
  801c44:	75 44                	jne    801c8a <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801c46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c49:	89 d0                	mov    %edx,%eax
  801c4b:	01 c0                	add    %eax,%eax
  801c4d:	01 d0                	add    %edx,%eax
  801c4f:	c1 e0 02             	shl    $0x2,%eax
  801c52:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c5b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801c5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c60:	89 d0                	mov    %edx,%eax
  801c62:	01 c0                	add    %eax,%eax
  801c64:	01 d0                	add    %edx,%eax
  801c66:	c1 e0 02             	shl    $0x2,%eax
  801c69:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801c6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c72:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801c74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c77:	89 d0                	mov    %edx,%eax
  801c79:	01 c0                	add    %eax,%eax
  801c7b:	01 d0                	add    %edx,%eax
  801c7d:	c1 e0 02             	shl    $0x2,%eax
  801c80:	05 48 60 80 00       	add    $0x806048,%eax
  801c85:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801c88:	eb 0c                	jmp    801c96 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c8a:	ff 45 e0             	incl   -0x20(%ebp)
  801c8d:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801c94:	7e 99                	jle    801c2f <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801c96:	83 ec 08             	sub    $0x8,%esp
  801c99:	ff 75 d4             	pushl  -0x2c(%ebp)
  801c9c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c9f:	e8 a2 19 00 00       	call   803646 <sys_allocate_user_mem>
  801ca4:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801ca7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cb6:	0f 84 fa 03 00 00    	je     8020b6 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801cc2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	79 1c                	jns    801ce5 <free+0x39>
  801cc9:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801cd0:	77 13                	ja     801ce5 <free+0x39>
    {
        free_block(virtual_address);
  801cd2:	83 ec 0c             	sub    $0xc,%esp
  801cd5:	ff 75 08             	pushl  0x8(%ebp)
  801cd8:	e8 09 21 00 00       	call   803de6 <free_block>
  801cdd:	83 c4 10             	add    $0x10,%esp
        return;
  801ce0:	e9 d2 03 00 00       	jmp    8020b7 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801ce5:	a1 30 61 83 00       	mov    0x836130,%eax
  801cea:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801ced:	72 09                	jb     801cf8 <free+0x4c>
  801cef:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801cf6:	76 17                	jbe    801d0f <free+0x63>
        panic("free: invalid address");
  801cf8:	83 ec 04             	sub    $0x4,%esp
  801cfb:	68 2d 50 80 00       	push   $0x80502d
  801d00:	68 9b 00 00 00       	push   $0x9b
  801d05:	68 e4 4f 80 00       	push   $0x804fe4
  801d0a:	e8 ad e9 ff ff       	call   8006bc <_panic>

    uint32 size = 0;
  801d0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801d16:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801d1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801d24:	eb 50                	jmp    801d76 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801d26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d29:	89 d0                	mov    %edx,%eax
  801d2b:	01 c0                	add    %eax,%eax
  801d2d:	01 d0                	add    %edx,%eax
  801d2f:	c1 e0 02             	shl    $0x2,%eax
  801d32:	05 48 60 80 00       	add    $0x806048,%eax
  801d37:	8a 00                	mov    (%eax),%al
  801d39:	84 c0                	test   %al,%al
  801d3b:	74 36                	je     801d73 <free+0xc7>
  801d3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d40:	89 d0                	mov    %edx,%eax
  801d42:	01 c0                	add    %eax,%eax
  801d44:	01 d0                	add    %edx,%eax
  801d46:	c1 e0 02             	shl    $0x2,%eax
  801d49:	05 40 60 80 00       	add    $0x806040,%eax
  801d4e:	8b 00                	mov    (%eax),%eax
  801d50:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801d53:	75 1e                	jne    801d73 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801d55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d58:	89 d0                	mov    %edx,%eax
  801d5a:	01 c0                	add    %eax,%eax
  801d5c:	01 d0                	add    %edx,%eax
  801d5e:	c1 e0 02             	shl    $0x2,%eax
  801d61:	05 44 60 80 00       	add    $0x806044,%eax
  801d66:	8b 00                	mov    (%eax),%eax
  801d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801d71:	eb 0c                	jmp    801d7f <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801d73:	ff 45 ec             	incl   -0x14(%ebp)
  801d76:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801d7d:	7e a7                	jle    801d26 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801d7f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d83:	74 06                	je     801d8b <free+0xdf>
  801d85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d89:	75 17                	jne    801da2 <free+0xf6>
        panic("free: unknown block");
  801d8b:	83 ec 04             	sub    $0x4,%esp
  801d8e:	68 43 50 80 00       	push   $0x805043
  801d93:	68 a9 00 00 00       	push   $0xa9
  801d98:	68 e4 4f 80 00       	push   $0x804fe4
  801d9d:	e8 1a e9 ff ff       	call   8006bc <_panic>

    uhp_allocs[idx].used = 0;
  801da2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801da5:	89 d0                	mov    %edx,%eax
  801da7:	01 c0                	add    %eax,%eax
  801da9:	01 d0                	add    %edx,%eax
  801dab:	c1 e0 02             	shl    $0x2,%eax
  801dae:	05 48 60 80 00       	add    $0x806048,%eax
  801db3:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801db6:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801dbd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801dc4:	eb 64                	jmp    801e2a <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801dc6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801dc9:	89 d0                	mov    %edx,%eax
  801dcb:	01 c0                	add    %eax,%eax
  801dcd:	01 d0                	add    %edx,%eax
  801dcf:	c1 e0 02             	shl    $0x2,%eax
  801dd2:	05 48 20 81 00       	add    $0x812048,%eax
  801dd7:	8a 00                	mov    (%eax),%al
  801dd9:	84 c0                	test   %al,%al
  801ddb:	75 4a                	jne    801e27 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801ddd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801de0:	89 d0                	mov    %edx,%eax
  801de2:	01 c0                	add    %eax,%eax
  801de4:	01 d0                	add    %edx,%eax
  801de6:	c1 e0 02             	shl    $0x2,%eax
  801de9:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  801def:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801df2:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801df4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801df7:	89 d0                	mov    %edx,%eax
  801df9:	01 c0                	add    %eax,%eax
  801dfb:	01 d0                	add    %edx,%eax
  801dfd:	c1 e0 02             	shl    $0x2,%eax
  801e00:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  801e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e09:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801e0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e0e:	89 d0                	mov    %edx,%eax
  801e10:	01 c0                	add    %eax,%eax
  801e12:	01 d0                	add    %edx,%eax
  801e14:	c1 e0 02             	shl    $0x2,%eax
  801e17:	05 48 20 81 00       	add    $0x812048,%eax
  801e1c:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801e1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e22:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801e25:	eb 0c                	jmp    801e33 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e27:	ff 45 e4             	incl   -0x1c(%ebp)
  801e2a:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801e31:	7e 93                	jle    801dc6 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801e33:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801e37:	0f 84 f1 01 00 00    	je     80202e <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e3d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801e44:	e9 d8 01 00 00       	jmp    802021 <free+0x375>
        {
            if (i == fidx) continue;
  801e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e4f:	0f 84 c8 01 00 00    	je     80201d <free+0x371>
            if (uhp_frees[i].free)
  801e55:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e58:	89 d0                	mov    %edx,%eax
  801e5a:	01 c0                	add    %eax,%eax
  801e5c:	01 d0                	add    %edx,%eax
  801e5e:	c1 e0 02             	shl    $0x2,%eax
  801e61:	05 48 20 81 00       	add    $0x812048,%eax
  801e66:	8a 00                	mov    (%eax),%al
  801e68:	84 c0                	test   %al,%al
  801e6a:	0f 84 ae 01 00 00    	je     80201e <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801e70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e73:	89 d0                	mov    %edx,%eax
  801e75:	01 c0                	add    %eax,%eax
  801e77:	01 d0                	add    %edx,%eax
  801e79:	c1 e0 02             	shl    $0x2,%eax
  801e7c:	05 40 20 81 00       	add    $0x812040,%eax
  801e81:	8b 08                	mov    (%eax),%ecx
  801e83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e86:	89 d0                	mov    %edx,%eax
  801e88:	01 c0                	add    %eax,%eax
  801e8a:	01 d0                	add    %edx,%eax
  801e8c:	c1 e0 02             	shl    $0x2,%eax
  801e8f:	05 44 20 81 00       	add    $0x812044,%eax
  801e94:	8b 00                	mov    (%eax),%eax
  801e96:	01 c1                	add    %eax,%ecx
  801e98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e9b:	89 d0                	mov    %edx,%eax
  801e9d:	01 c0                	add    %eax,%eax
  801e9f:	01 d0                	add    %edx,%eax
  801ea1:	c1 e0 02             	shl    $0x2,%eax
  801ea4:	05 40 20 81 00       	add    $0x812040,%eax
  801ea9:	8b 00                	mov    (%eax),%eax
  801eab:	39 c1                	cmp    %eax,%ecx
  801ead:	0f 85 a8 00 00 00    	jne    801f5b <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801eb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eb6:	89 d0                	mov    %edx,%eax
  801eb8:	01 c0                	add    %eax,%eax
  801eba:	01 d0                	add    %edx,%eax
  801ebc:	c1 e0 02             	shl    $0x2,%eax
  801ebf:	05 40 20 81 00       	add    $0x812040,%eax
  801ec4:	8b 10                	mov    (%eax),%edx
  801ec6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801ec9:	89 c8                	mov    %ecx,%eax
  801ecb:	01 c0                	add    %eax,%eax
  801ecd:	01 c8                	add    %ecx,%eax
  801ecf:	c1 e0 02             	shl    $0x2,%eax
  801ed2:	05 40 20 81 00       	add    $0x812040,%eax
  801ed7:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801ed9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801edc:	89 d0                	mov    %edx,%eax
  801ede:	01 c0                	add    %eax,%eax
  801ee0:	01 d0                	add    %edx,%eax
  801ee2:	c1 e0 02             	shl    $0x2,%eax
  801ee5:	05 44 20 81 00       	add    $0x812044,%eax
  801eea:	8b 08                	mov    (%eax),%ecx
  801eec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eef:	89 d0                	mov    %edx,%eax
  801ef1:	01 c0                	add    %eax,%eax
  801ef3:	01 d0                	add    %edx,%eax
  801ef5:	c1 e0 02             	shl    $0x2,%eax
  801ef8:	05 44 20 81 00       	add    $0x812044,%eax
  801efd:	8b 00                	mov    (%eax),%eax
  801eff:	01 c1                	add    %eax,%ecx
  801f01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f04:	89 d0                	mov    %edx,%eax
  801f06:	01 c0                	add    %eax,%eax
  801f08:	01 d0                	add    %edx,%eax
  801f0a:	c1 e0 02             	shl    $0x2,%eax
  801f0d:	05 44 20 81 00       	add    $0x812044,%eax
  801f12:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801f14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f17:	89 d0                	mov    %edx,%eax
  801f19:	01 c0                	add    %eax,%eax
  801f1b:	01 d0                	add    %edx,%eax
  801f1d:	c1 e0 02             	shl    $0x2,%eax
  801f20:	05 48 20 81 00       	add    $0x812048,%eax
  801f25:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801f28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f2b:	89 d0                	mov    %edx,%eax
  801f2d:	01 c0                	add    %eax,%eax
  801f2f:	01 d0                	add    %edx,%eax
  801f31:	c1 e0 02             	shl    $0x2,%eax
  801f34:	05 40 20 81 00       	add    $0x812040,%eax
  801f39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f42:	89 d0                	mov    %edx,%eax
  801f44:	01 c0                	add    %eax,%eax
  801f46:	01 d0                	add    %edx,%eax
  801f48:	c1 e0 02             	shl    $0x2,%eax
  801f4b:	05 44 20 81 00       	add    $0x812044,%eax
  801f50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f56:	e9 c3 00 00 00       	jmp    80201e <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801f5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f5e:	89 d0                	mov    %edx,%eax
  801f60:	01 c0                	add    %eax,%eax
  801f62:	01 d0                	add    %edx,%eax
  801f64:	c1 e0 02             	shl    $0x2,%eax
  801f67:	05 40 20 81 00       	add    $0x812040,%eax
  801f6c:	8b 08                	mov    (%eax),%ecx
  801f6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f71:	89 d0                	mov    %edx,%eax
  801f73:	01 c0                	add    %eax,%eax
  801f75:	01 d0                	add    %edx,%eax
  801f77:	c1 e0 02             	shl    $0x2,%eax
  801f7a:	05 44 20 81 00       	add    $0x812044,%eax
  801f7f:	8b 00                	mov    (%eax),%eax
  801f81:	01 c1                	add    %eax,%ecx
  801f83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f86:	89 d0                	mov    %edx,%eax
  801f88:	01 c0                	add    %eax,%eax
  801f8a:	01 d0                	add    %edx,%eax
  801f8c:	c1 e0 02             	shl    $0x2,%eax
  801f8f:	05 40 20 81 00       	add    $0x812040,%eax
  801f94:	8b 00                	mov    (%eax),%eax
  801f96:	39 c1                	cmp    %eax,%ecx
  801f98:	0f 85 80 00 00 00    	jne    80201e <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801f9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fa1:	89 d0                	mov    %edx,%eax
  801fa3:	01 c0                	add    %eax,%eax
  801fa5:	01 d0                	add    %edx,%eax
  801fa7:	c1 e0 02             	shl    $0x2,%eax
  801faa:	05 44 20 81 00       	add    $0x812044,%eax
  801faf:	8b 08                	mov    (%eax),%ecx
  801fb1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fb4:	89 d0                	mov    %edx,%eax
  801fb6:	01 c0                	add    %eax,%eax
  801fb8:	01 d0                	add    %edx,%eax
  801fba:	c1 e0 02             	shl    $0x2,%eax
  801fbd:	05 44 20 81 00       	add    $0x812044,%eax
  801fc2:	8b 00                	mov    (%eax),%eax
  801fc4:	01 c1                	add    %eax,%ecx
  801fc6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fc9:	89 d0                	mov    %edx,%eax
  801fcb:	01 c0                	add    %eax,%eax
  801fcd:	01 d0                	add    %edx,%eax
  801fcf:	c1 e0 02             	shl    $0x2,%eax
  801fd2:	05 44 20 81 00       	add    $0x812044,%eax
  801fd7:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801fd9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fdc:	89 d0                	mov    %edx,%eax
  801fde:	01 c0                	add    %eax,%eax
  801fe0:	01 d0                	add    %edx,%eax
  801fe2:	c1 e0 02             	shl    $0x2,%eax
  801fe5:	05 48 20 81 00       	add    $0x812048,%eax
  801fea:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801fed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ff0:	89 d0                	mov    %edx,%eax
  801ff2:	01 c0                	add    %eax,%eax
  801ff4:	01 d0                	add    %edx,%eax
  801ff6:	c1 e0 02             	shl    $0x2,%eax
  801ff9:	05 40 20 81 00       	add    $0x812040,%eax
  801ffe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802004:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802007:	89 d0                	mov    %edx,%eax
  802009:	01 c0                	add    %eax,%eax
  80200b:	01 d0                	add    %edx,%eax
  80200d:	c1 e0 02             	shl    $0x2,%eax
  802010:	05 44 20 81 00       	add    $0x812044,%eax
  802015:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80201b:	eb 01                	jmp    80201e <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  80201d:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80201e:	ff 45 e0             	incl   -0x20(%ebp)
  802021:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802028:	0f 8e 1b fe ff ff    	jle    801e49 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  80202e:	a1 30 61 83 00       	mov    0x836130,%eax
  802033:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802036:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80203d:	eb 53                	jmp    802092 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  80203f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802042:	89 d0                	mov    %edx,%eax
  802044:	01 c0                	add    %eax,%eax
  802046:	01 d0                	add    %edx,%eax
  802048:	c1 e0 02             	shl    $0x2,%eax
  80204b:	05 48 60 80 00       	add    $0x806048,%eax
  802050:	8a 00                	mov    (%eax),%al
  802052:	84 c0                	test   %al,%al
  802054:	74 39                	je     80208f <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  802056:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802059:	89 d0                	mov    %edx,%eax
  80205b:	01 c0                	add    %eax,%eax
  80205d:	01 d0                	add    %edx,%eax
  80205f:	c1 e0 02             	shl    $0x2,%eax
  802062:	05 40 60 80 00       	add    $0x806040,%eax
  802067:	8b 08                	mov    (%eax),%ecx
  802069:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80206c:	89 d0                	mov    %edx,%eax
  80206e:	01 c0                	add    %eax,%eax
  802070:	01 d0                	add    %edx,%eax
  802072:	c1 e0 02             	shl    $0x2,%eax
  802075:	05 44 60 80 00       	add    $0x806044,%eax
  80207a:	8b 00                	mov    (%eax),%eax
  80207c:	01 c8                	add    %ecx,%eax
  80207e:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  802081:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802084:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802087:	76 06                	jbe    80208f <free+0x3e3>
  802089:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80208c:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80208f:	ff 45 d8             	incl   -0x28(%ebp)
  802092:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802099:	7e a4                	jle    80203f <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  80209b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80209e:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  8020a3:	83 ec 08             	sub    $0x8,%esp
  8020a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8020ac:	e8 79 15 00 00       	call   80362a <sys_free_user_mem>
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	eb 01                	jmp    8020b7 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  8020b6:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 68             	sub    $0x68,%esp
  8020bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c2:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8020c5:	e8 a5 f7 ff ff       	call   80186f <uheap_init>
	if (size == 0) return NULL ;
  8020ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020ce:	75 0a                	jne    8020da <smalloc+0x21>
  8020d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d5:	e9 37 03 00 00       	jmp    802411 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8020da:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8020e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020e7:	01 d0                	add    %edx,%eax
  8020e9:	48                   	dec    %eax
  8020ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8020ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f5:	f7 75 dc             	divl   -0x24(%ebp)
  8020f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020fb:	29 d0                	sub    %edx,%eax
  8020fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802100:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802107:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80210e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802115:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80211c:	e9 85 00 00 00       	jmp    8021a6 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802121:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802124:	89 d0                	mov    %edx,%eax
  802126:	01 c0                	add    %eax,%eax
  802128:	01 d0                	add    %edx,%eax
  80212a:	c1 e0 02             	shl    $0x2,%eax
  80212d:	05 48 20 81 00       	add    $0x812048,%eax
  802132:	8a 00                	mov    (%eax),%al
  802134:	84 c0                	test   %al,%al
  802136:	74 20                	je     802158 <smalloc+0x9f>
  802138:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80213b:	89 d0                	mov    %edx,%eax
  80213d:	01 c0                	add    %eax,%eax
  80213f:	01 d0                	add    %edx,%eax
  802141:	c1 e0 02             	shl    $0x2,%eax
  802144:	05 44 20 81 00       	add    $0x812044,%eax
  802149:	8b 00                	mov    (%eax),%eax
  80214b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80214e:	75 08                	jne    802158 <smalloc+0x9f>
        {
            exactIdx = i;
  802150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802153:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802156:	eb 5b                	jmp    8021b3 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802158:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80215b:	89 d0                	mov    %edx,%eax
  80215d:	01 c0                	add    %eax,%eax
  80215f:	01 d0                	add    %edx,%eax
  802161:	c1 e0 02             	shl    $0x2,%eax
  802164:	05 48 20 81 00       	add    $0x812048,%eax
  802169:	8a 00                	mov    (%eax),%al
  80216b:	84 c0                	test   %al,%al
  80216d:	74 34                	je     8021a3 <smalloc+0xea>
  80216f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802172:	89 d0                	mov    %edx,%eax
  802174:	01 c0                	add    %eax,%eax
  802176:	01 d0                	add    %edx,%eax
  802178:	c1 e0 02             	shl    $0x2,%eax
  80217b:	05 44 20 81 00       	add    $0x812044,%eax
  802180:	8b 00                	mov    (%eax),%eax
  802182:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802185:	76 1c                	jbe    8021a3 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802187:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80218a:	89 d0                	mov    %edx,%eax
  80218c:	01 c0                	add    %eax,%eax
  80218e:	01 d0                	add    %edx,%eax
  802190:	c1 e0 02             	shl    $0x2,%eax
  802193:	05 44 20 81 00       	add    $0x812044,%eax
  802198:	8b 00                	mov    (%eax),%eax
  80219a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80219d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021a0:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8021a3:	ff 45 e8             	incl   -0x18(%ebp)
  8021a6:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8021ad:	0f 8e 6e ff ff ff    	jle    802121 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8021b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8021ba:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8021be:	74 7d                	je     80223d <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8021c0:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8021c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ca:	89 d0                	mov    %edx,%eax
  8021cc:	01 c0                	add    %eax,%eax
  8021ce:	01 d0                	add    %edx,%eax
  8021d0:	c1 e0 02             	shl    $0x2,%eax
  8021d3:	05 40 20 81 00       	add    $0x812040,%eax
  8021d8:	8b 10                	mov    (%eax),%edx
  8021da:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021dd:	01 d0                	add    %edx,%eax
  8021df:	48                   	dec    %eax
  8021e0:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8021e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8021eb:	f7 75 bc             	divl   -0x44(%ebp)
  8021ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021f1:	29 d0                	sub    %edx,%eax
  8021f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8021f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f9:	89 d0                	mov    %edx,%eax
  8021fb:	01 c0                	add    %eax,%eax
  8021fd:	01 d0                	add    %edx,%eax
  8021ff:	c1 e0 02             	shl    $0x2,%eax
  802202:	05 48 20 81 00       	add    $0x812048,%eax
  802207:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80220a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220d:	89 d0                	mov    %edx,%eax
  80220f:	01 c0                	add    %eax,%eax
  802211:	01 d0                	add    %edx,%eax
  802213:	c1 e0 02             	shl    $0x2,%eax
  802216:	05 44 20 81 00       	add    $0x812044,%eax
  80221b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802224:	89 d0                	mov    %edx,%eax
  802226:	01 c0                	add    %eax,%eax
  802228:	01 d0                	add    %edx,%eax
  80222a:	c1 e0 02             	shl    $0x2,%eax
  80222d:	05 40 20 81 00       	add    $0x812040,%eax
  802232:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802238:	e9 2d 01 00 00       	jmp    80236a <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  80223d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802241:	0f 84 ce 00 00 00    	je     802315 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802247:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80224e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802251:	89 d0                	mov    %edx,%eax
  802253:	01 c0                	add    %eax,%eax
  802255:	01 d0                	add    %edx,%eax
  802257:	c1 e0 02             	shl    $0x2,%eax
  80225a:	05 40 20 81 00       	add    $0x812040,%eax
  80225f:	8b 10                	mov    (%eax),%edx
  802261:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802264:	01 d0                	add    %edx,%eax
  802266:	48                   	dec    %eax
  802267:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80226a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80226d:	ba 00 00 00 00       	mov    $0x0,%edx
  802272:	f7 75 c4             	divl   -0x3c(%ebp)
  802275:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802278:	29 d0                	sub    %edx,%eax
  80227a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80227d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802280:	89 d0                	mov    %edx,%eax
  802282:	01 c0                	add    %eax,%eax
  802284:	01 d0                	add    %edx,%eax
  802286:	c1 e0 02             	shl    $0x2,%eax
  802289:	05 44 20 81 00       	add    $0x812044,%eax
  80228e:	8b 00                	mov    (%eax),%eax
  802290:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802293:	75 47                	jne    8022dc <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802295:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802298:	89 d0                	mov    %edx,%eax
  80229a:	01 c0                	add    %eax,%eax
  80229c:	01 d0                	add    %edx,%eax
  80229e:	c1 e0 02             	shl    $0x2,%eax
  8022a1:	05 48 20 81 00       	add    $0x812048,%eax
  8022a6:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8022a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ac:	89 d0                	mov    %edx,%eax
  8022ae:	01 c0                	add    %eax,%eax
  8022b0:	01 d0                	add    %edx,%eax
  8022b2:	c1 e0 02             	shl    $0x2,%eax
  8022b5:	05 44 20 81 00       	add    $0x812044,%eax
  8022ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8022c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c3:	89 d0                	mov    %edx,%eax
  8022c5:	01 c0                	add    %eax,%eax
  8022c7:	01 d0                	add    %edx,%eax
  8022c9:	c1 e0 02             	shl    $0x2,%eax
  8022cc:	05 40 20 81 00       	add    $0x812040,%eax
  8022d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d7:	e9 8e 00 00 00       	jmp    80236a <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8022dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022e2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8022e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022e8:	89 d0                	mov    %edx,%eax
  8022ea:	01 c0                	add    %eax,%eax
  8022ec:	01 d0                	add    %edx,%eax
  8022ee:	c1 e0 02             	shl    $0x2,%eax
  8022f1:	05 40 20 81 00       	add    $0x812040,%eax
  8022f6:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8022f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022fb:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8022fe:	89 c2                	mov    %eax,%edx
  802300:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802303:	89 c8                	mov    %ecx,%eax
  802305:	01 c0                	add    %eax,%eax
  802307:	01 c8                	add    %ecx,%eax
  802309:	c1 e0 02             	shl    $0x2,%eax
  80230c:	05 44 20 81 00       	add    $0x812044,%eax
  802311:	89 10                	mov    %edx,(%eax)
  802313:	eb 55                	jmp    80236a <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802315:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80231c:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802325:	01 d0                	add    %edx,%eax
  802327:	48                   	dec    %eax
  802328:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80232b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80232e:	ba 00 00 00 00       	mov    $0x0,%edx
  802333:	f7 75 d0             	divl   -0x30(%ebp)
  802336:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802339:	29 d0                	sub    %edx,%eax
  80233b:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80233e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802341:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802344:	01 d0                	add    %edx,%eax
  802346:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80234b:	76 0a                	jbe    802357 <smalloc+0x29e>
            return NULL;
  80234d:	b8 00 00 00 00       	mov    $0x0,%eax
  802352:	e9 ba 00 00 00       	jmp    802411 <smalloc+0x358>
        va = start;
  802357:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80235a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80235d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802360:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802363:	01 d0                	add    %edx,%eax
  802365:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80236a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802371:	eb 5e                	jmp    8023d1 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802373:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802376:	89 d0                	mov    %edx,%eax
  802378:	01 c0                	add    %eax,%eax
  80237a:	01 d0                	add    %edx,%eax
  80237c:	c1 e0 02             	shl    $0x2,%eax
  80237f:	05 48 60 80 00       	add    $0x806048,%eax
  802384:	8a 00                	mov    (%eax),%al
  802386:	84 c0                	test   %al,%al
  802388:	75 44                	jne    8023ce <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80238a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80238d:	89 d0                	mov    %edx,%eax
  80238f:	01 c0                	add    %eax,%eax
  802391:	01 d0                	add    %edx,%eax
  802393:	c1 e0 02             	shl    $0x2,%eax
  802396:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  80239c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80239f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8023a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023a4:	89 d0                	mov    %edx,%eax
  8023a6:	01 c0                	add    %eax,%eax
  8023a8:	01 d0                	add    %edx,%eax
  8023aa:	c1 e0 02             	shl    $0x2,%eax
  8023ad:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8023b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b6:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8023b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023bb:	89 d0                	mov    %edx,%eax
  8023bd:	01 c0                	add    %eax,%eax
  8023bf:	01 d0                	add    %edx,%eax
  8023c1:	c1 e0 02             	shl    $0x2,%eax
  8023c4:	05 48 60 80 00       	add    $0x806048,%eax
  8023c9:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8023cc:	eb 0c                	jmp    8023da <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8023ce:	ff 45 e0             	incl   -0x20(%ebp)
  8023d1:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8023d8:	7e 99                	jle    802373 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8023da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023dd:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8023e1:	52                   	push   %edx
  8023e2:	50                   	push   %eax
  8023e3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8023e6:	ff 75 08             	pushl  0x8(%ebp)
  8023e9:	e8 de 0e 00 00       	call   8032cc <sys_create_shared_object>
  8023ee:	83 c4 10             	add    $0x10,%esp
  8023f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8023f4:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8023f8:	75 07                	jne    802401 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8023fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8023ff:	eb 10                	jmp    802411 <smalloc+0x358>
    if (r < 0)
  802401:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802405:	79 07                	jns    80240e <smalloc+0x355>
        return NULL;
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
  80240c:	eb 03                	jmp    802411 <smalloc+0x358>
    return (void*)va;
  80240e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802419:	e8 51 f4 ff ff       	call   80186f <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80241e:	83 ec 08             	sub    $0x8,%esp
  802421:	ff 75 0c             	pushl  0xc(%ebp)
  802424:	ff 75 08             	pushl  0x8(%ebp)
  802427:	e8 ca 0e 00 00       	call   8032f6 <sys_size_of_shared_object>
  80242c:	83 c4 10             	add    $0x10,%esp
  80242f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802432:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802436:	7f 0a                	jg     802442 <sget+0x2f>
        return NULL;
  802438:	b8 00 00 00 00       	mov    $0x0,%eax
  80243d:	e9 28 03 00 00       	jmp    80276a <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802442:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802449:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80244c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80244f:	01 d0                	add    %edx,%eax
  802451:	48                   	dec    %eax
  802452:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802455:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802458:	ba 00 00 00 00       	mov    $0x0,%edx
  80245d:	f7 75 d8             	divl   -0x28(%ebp)
  802460:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802463:	29 d0                	sub    %edx,%eax
  802465:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802468:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80246f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802476:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80247d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802484:	e9 85 00 00 00       	jmp    80250e <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802489:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80248c:	89 d0                	mov    %edx,%eax
  80248e:	01 c0                	add    %eax,%eax
  802490:	01 d0                	add    %edx,%eax
  802492:	c1 e0 02             	shl    $0x2,%eax
  802495:	05 48 20 81 00       	add    $0x812048,%eax
  80249a:	8a 00                	mov    (%eax),%al
  80249c:	84 c0                	test   %al,%al
  80249e:	74 20                	je     8024c0 <sget+0xad>
  8024a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024a3:	89 d0                	mov    %edx,%eax
  8024a5:	01 c0                	add    %eax,%eax
  8024a7:	01 d0                	add    %edx,%eax
  8024a9:	c1 e0 02             	shl    $0x2,%eax
  8024ac:	05 44 20 81 00       	add    $0x812044,%eax
  8024b1:	8b 00                	mov    (%eax),%eax
  8024b3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8024b6:	75 08                	jne    8024c0 <sget+0xad>
        {
            exactIdx = i;
  8024b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8024be:	eb 5b                	jmp    80251b <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8024c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024c3:	89 d0                	mov    %edx,%eax
  8024c5:	01 c0                	add    %eax,%eax
  8024c7:	01 d0                	add    %edx,%eax
  8024c9:	c1 e0 02             	shl    $0x2,%eax
  8024cc:	05 48 20 81 00       	add    $0x812048,%eax
  8024d1:	8a 00                	mov    (%eax),%al
  8024d3:	84 c0                	test   %al,%al
  8024d5:	74 34                	je     80250b <sget+0xf8>
  8024d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024da:	89 d0                	mov    %edx,%eax
  8024dc:	01 c0                	add    %eax,%eax
  8024de:	01 d0                	add    %edx,%eax
  8024e0:	c1 e0 02             	shl    $0x2,%eax
  8024e3:	05 44 20 81 00       	add    $0x812044,%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024ed:	76 1c                	jbe    80250b <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8024ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024f2:	89 d0                	mov    %edx,%eax
  8024f4:	01 c0                	add    %eax,%eax
  8024f6:	01 d0                	add    %edx,%eax
  8024f8:	c1 e0 02             	shl    $0x2,%eax
  8024fb:	05 44 20 81 00       	add    $0x812044,%eax
  802500:	8b 00                	mov    (%eax),%eax
  802502:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802508:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80250b:	ff 45 e8             	incl   -0x18(%ebp)
  80250e:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802515:	0f 8e 6e ff ff ff    	jle    802489 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  80251b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802522:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802526:	74 7d                	je     8025a5 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802528:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80252f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802532:	89 d0                	mov    %edx,%eax
  802534:	01 c0                	add    %eax,%eax
  802536:	01 d0                	add    %edx,%eax
  802538:	c1 e0 02             	shl    $0x2,%eax
  80253b:	05 40 20 81 00       	add    $0x812040,%eax
  802540:	8b 10                	mov    (%eax),%edx
  802542:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802545:	01 d0                	add    %edx,%eax
  802547:	48                   	dec    %eax
  802548:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80254b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80254e:	ba 00 00 00 00       	mov    $0x0,%edx
  802553:	f7 75 b8             	divl   -0x48(%ebp)
  802556:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802559:	29 d0                	sub    %edx,%eax
  80255b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80255e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802561:	89 d0                	mov    %edx,%eax
  802563:	01 c0                	add    %eax,%eax
  802565:	01 d0                	add    %edx,%eax
  802567:	c1 e0 02             	shl    $0x2,%eax
  80256a:	05 48 20 81 00       	add    $0x812048,%eax
  80256f:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802572:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802575:	89 d0                	mov    %edx,%eax
  802577:	01 c0                	add    %eax,%eax
  802579:	01 d0                	add    %edx,%eax
  80257b:	c1 e0 02             	shl    $0x2,%eax
  80257e:	05 44 20 81 00       	add    $0x812044,%eax
  802583:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258c:	89 d0                	mov    %edx,%eax
  80258e:	01 c0                	add    %eax,%eax
  802590:	01 d0                	add    %edx,%eax
  802592:	c1 e0 02             	shl    $0x2,%eax
  802595:	05 40 20 81 00       	add    $0x812040,%eax
  80259a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a0:	e9 2d 01 00 00       	jmp    8026d2 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8025a5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8025a9:	0f 84 ce 00 00 00    	je     80267d <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8025af:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8025b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025b9:	89 d0                	mov    %edx,%eax
  8025bb:	01 c0                	add    %eax,%eax
  8025bd:	01 d0                	add    %edx,%eax
  8025bf:	c1 e0 02             	shl    $0x2,%eax
  8025c2:	05 40 20 81 00       	add    $0x812040,%eax
  8025c7:	8b 10                	mov    (%eax),%edx
  8025c9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025cc:	01 d0                	add    %edx,%eax
  8025ce:	48                   	dec    %eax
  8025cf:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8025d2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8025da:	f7 75 c0             	divl   -0x40(%ebp)
  8025dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025e0:	29 d0                	sub    %edx,%eax
  8025e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8025e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e8:	89 d0                	mov    %edx,%eax
  8025ea:	01 c0                	add    %eax,%eax
  8025ec:	01 d0                	add    %edx,%eax
  8025ee:	c1 e0 02             	shl    $0x2,%eax
  8025f1:	05 44 20 81 00       	add    $0x812044,%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8025fb:	75 47                	jne    802644 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8025fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802600:	89 d0                	mov    %edx,%eax
  802602:	01 c0                	add    %eax,%eax
  802604:	01 d0                	add    %edx,%eax
  802606:	c1 e0 02             	shl    $0x2,%eax
  802609:	05 48 20 81 00       	add    $0x812048,%eax
  80260e:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802611:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802614:	89 d0                	mov    %edx,%eax
  802616:	01 c0                	add    %eax,%eax
  802618:	01 d0                	add    %edx,%eax
  80261a:	c1 e0 02             	shl    $0x2,%eax
  80261d:	05 44 20 81 00       	add    $0x812044,%eax
  802622:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802628:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80262b:	89 d0                	mov    %edx,%eax
  80262d:	01 c0                	add    %eax,%eax
  80262f:	01 d0                	add    %edx,%eax
  802631:	c1 e0 02             	shl    $0x2,%eax
  802634:	05 40 20 81 00       	add    $0x812040,%eax
  802639:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263f:	e9 8e 00 00 00       	jmp    8026d2 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802644:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802647:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80264a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80264d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802650:	89 d0                	mov    %edx,%eax
  802652:	01 c0                	add    %eax,%eax
  802654:	01 d0                	add    %edx,%eax
  802656:	c1 e0 02             	shl    $0x2,%eax
  802659:	05 40 20 81 00       	add    $0x812040,%eax
  80265e:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802663:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802666:	89 c2                	mov    %eax,%edx
  802668:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80266b:	89 c8                	mov    %ecx,%eax
  80266d:	01 c0                	add    %eax,%eax
  80266f:	01 c8                	add    %ecx,%eax
  802671:	c1 e0 02             	shl    $0x2,%eax
  802674:	05 44 20 81 00       	add    $0x812044,%eax
  802679:	89 10                	mov    %edx,(%eax)
  80267b:	eb 55                	jmp    8026d2 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80267d:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802684:	8b 15 88 60 83 00    	mov    0x836088,%edx
  80268a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80268d:	01 d0                	add    %edx,%eax
  80268f:	48                   	dec    %eax
  802690:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802693:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802696:	ba 00 00 00 00       	mov    $0x0,%edx
  80269b:	f7 75 cc             	divl   -0x34(%ebp)
  80269e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026a1:	29 d0                	sub    %edx,%eax
  8026a3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8026a6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8026a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026ac:	01 d0                	add    %edx,%eax
  8026ae:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8026b3:	76 0a                	jbe    8026bf <sget+0x2ac>
            return NULL;
  8026b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ba:	e9 ab 00 00 00       	jmp    80276a <sget+0x357>
        va = start;
  8026bf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8026c5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8026c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026cb:	01 d0                	add    %edx,%eax
  8026cd:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8026d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8026d9:	eb 5e                	jmp    802739 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8026db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026de:	89 d0                	mov    %edx,%eax
  8026e0:	01 c0                	add    %eax,%eax
  8026e2:	01 d0                	add    %edx,%eax
  8026e4:	c1 e0 02             	shl    $0x2,%eax
  8026e7:	05 48 60 80 00       	add    $0x806048,%eax
  8026ec:	8a 00                	mov    (%eax),%al
  8026ee:	84 c0                	test   %al,%al
  8026f0:	75 44                	jne    802736 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8026f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026f5:	89 d0                	mov    %edx,%eax
  8026f7:	01 c0                	add    %eax,%eax
  8026f9:	01 d0                	add    %edx,%eax
  8026fb:	c1 e0 02             	shl    $0x2,%eax
  8026fe:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802707:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802709:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80270c:	89 d0                	mov    %edx,%eax
  80270e:	01 c0                	add    %eax,%eax
  802710:	01 d0                	add    %edx,%eax
  802712:	c1 e0 02             	shl    $0x2,%eax
  802715:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  80271b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80271e:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802720:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802723:	89 d0                	mov    %edx,%eax
  802725:	01 c0                	add    %eax,%eax
  802727:	01 d0                	add    %edx,%eax
  802729:	c1 e0 02             	shl    $0x2,%eax
  80272c:	05 48 60 80 00       	add    $0x806048,%eax
  802731:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802734:	eb 0c                	jmp    802742 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802736:	ff 45 e0             	incl   -0x20(%ebp)
  802739:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802740:	7e 99                	jle    8026db <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802745:	83 ec 04             	sub    $0x4,%esp
  802748:	50                   	push   %eax
  802749:	ff 75 0c             	pushl  0xc(%ebp)
  80274c:	ff 75 08             	pushl  0x8(%ebp)
  80274f:	e8 bf 0b 00 00       	call   803313 <sys_get_shared_object>
  802754:	83 c4 10             	add    $0x10,%esp
  802757:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  80275a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80275e:	79 07                	jns    802767 <sget+0x354>
        return NULL;
  802760:	b8 00 00 00 00       	mov    $0x0,%eax
  802765:	eb 03                	jmp    80276a <sget+0x357>
    return (void*)va;
  802767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80276a:	c9                   	leave  
  80276b:	c3                   	ret    

0080276c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80276c:	55                   	push   %ebp
  80276d:	89 e5                	mov    %esp,%ebp
  80276f:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802772:	e8 f8 f0 ff ff       	call   80186f <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802777:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80277b:	75 13                	jne    802790 <realloc+0x24>
		return malloc(new_size);
  80277d:	83 ec 0c             	sub    $0xc,%esp
  802780:	ff 75 0c             	pushl  0xc(%ebp)
  802783:	e8 c4 f1 ff ff       	call   80194c <malloc>
  802788:	83 c4 10             	add    $0x10,%esp
  80278b:	e9 f4 05 00 00       	jmp    802d84 <realloc+0x618>
	if (new_size == 0)
  802790:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802794:	75 18                	jne    8027ae <realloc+0x42>
	{
		free(virtual_address);
  802796:	83 ec 0c             	sub    $0xc,%esp
  802799:	ff 75 08             	pushl  0x8(%ebp)
  80279c:	e8 0b f5 ff ff       	call   801cac <free>
  8027a1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8027a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a9:	e9 d6 05 00 00       	jmp    802d84 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8027ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8027b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	79 74                	jns    80282f <realloc+0xc3>
  8027bb:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8027c2:	77 6b                	ja     80282f <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  8027c4:	83 ec 0c             	sub    $0xc,%esp
  8027c7:	ff 75 0c             	pushl  0xc(%ebp)
  8027ca:	e8 7d f1 ff ff       	call   80194c <malloc>
  8027cf:	83 c4 10             	add    $0x10,%esp
  8027d2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8027d5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8027d9:	75 0a                	jne    8027e5 <realloc+0x79>
			return NULL;
  8027db:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e0:	e9 9f 05 00 00       	jmp    802d84 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8027e5:	83 ec 0c             	sub    $0xc,%esp
  8027e8:	ff 75 08             	pushl  0x8(%ebp)
  8027eb:	e8 e0 11 00 00       	call   8039d0 <get_block_size>
  8027f0:	83 c4 10             	add    $0x10,%esp
  8027f3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8027f6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8027f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027fc:	39 d0                	cmp    %edx,%eax
  8027fe:	76 02                	jbe    802802 <realloc+0x96>
  802800:	89 d0                	mov    %edx,%eax
  802802:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802805:	83 ec 04             	sub    $0x4,%esp
  802808:	ff 75 c0             	pushl  -0x40(%ebp)
  80280b:	ff 75 08             	pushl  0x8(%ebp)
  80280e:	ff 75 c8             	pushl  -0x38(%ebp)
  802811:	e8 56 eb ff ff       	call   80136c <memmove>
  802816:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802819:	83 ec 0c             	sub    $0xc,%esp
  80281c:	ff 75 08             	pushl  0x8(%ebp)
  80281f:	e8 88 f4 ff ff       	call   801cac <free>
  802824:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802827:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80282a:	e9 55 05 00 00       	jmp    802d84 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80282f:	a1 30 61 83 00       	mov    0x836130,%eax
  802834:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802837:	72 09                	jb     802842 <realloc+0xd6>
  802839:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802840:	76 0a                	jbe    80284c <realloc+0xe0>
		return NULL;
  802842:	b8 00 00 00 00       	mov    $0x0,%eax
  802847:	e9 38 05 00 00       	jmp    802d84 <realloc+0x618>
	uint32 oldsz = 0;
  80284c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802853:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80285a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802861:	eb 50                	jmp    8028b3 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802863:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802866:	89 d0                	mov    %edx,%eax
  802868:	01 c0                	add    %eax,%eax
  80286a:	01 d0                	add    %edx,%eax
  80286c:	c1 e0 02             	shl    $0x2,%eax
  80286f:	05 48 60 80 00       	add    $0x806048,%eax
  802874:	8a 00                	mov    (%eax),%al
  802876:	84 c0                	test   %al,%al
  802878:	74 36                	je     8028b0 <realloc+0x144>
  80287a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80287d:	89 d0                	mov    %edx,%eax
  80287f:	01 c0                	add    %eax,%eax
  802881:	01 d0                	add    %edx,%eax
  802883:	c1 e0 02             	shl    $0x2,%eax
  802886:	05 40 60 80 00       	add    $0x806040,%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802890:	75 1e                	jne    8028b0 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802892:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802895:	89 d0                	mov    %edx,%eax
  802897:	01 c0                	add    %eax,%eax
  802899:	01 d0                	add    %edx,%eax
  80289b:	c1 e0 02             	shl    $0x2,%eax
  80289e:	05 44 60 80 00       	add    $0x806044,%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8028a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8028ae:	eb 0c                	jmp    8028bc <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8028b0:	ff 45 ec             	incl   -0x14(%ebp)
  8028b3:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8028ba:	7e a7                	jle    802863 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8028bc:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8028c0:	75 0a                	jne    8028cc <realloc+0x160>
		return NULL;
  8028c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c7:	e9 b8 04 00 00       	jmp    802d84 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  8028cc:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8028d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028d9:	01 d0                	add    %edx,%eax
  8028db:	48                   	dec    %eax
  8028dc:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8028df:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8028e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8028e7:	f7 75 bc             	divl   -0x44(%ebp)
  8028ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8028ed:	29 d0                	sub    %edx,%eax
  8028ef:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8028f2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8028f8:	75 08                	jne    802902 <realloc+0x196>
		return virtual_address;
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	e9 82 04 00 00       	jmp    802d84 <realloc+0x618>
	if (req < oldsz)
  802902:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802905:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802908:	0f 83 cd 02 00 00    	jae    802bdb <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802914:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802917:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80291a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80291d:	01 d0                	add    %edx,%eax
  80291f:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802922:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802925:	89 d0                	mov    %edx,%eax
  802927:	01 c0                	add    %eax,%eax
  802929:	01 d0                	add    %edx,%eax
  80292b:	c1 e0 02             	shl    $0x2,%eax
  80292e:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802934:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802937:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802939:	83 ec 08             	sub    $0x8,%esp
  80293c:	ff 75 b0             	pushl  -0x50(%ebp)
  80293f:	ff 75 ac             	pushl  -0x54(%ebp)
  802942:	e8 e3 0c 00 00       	call   80362a <sys_free_user_mem>
  802947:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  80294a:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802951:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802958:	eb 64                	jmp    8029be <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  80295a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80295d:	89 d0                	mov    %edx,%eax
  80295f:	01 c0                	add    %eax,%eax
  802961:	01 d0                	add    %edx,%eax
  802963:	c1 e0 02             	shl    $0x2,%eax
  802966:	05 48 20 81 00       	add    $0x812048,%eax
  80296b:	8a 00                	mov    (%eax),%al
  80296d:	84 c0                	test   %al,%al
  80296f:	75 4a                	jne    8029bb <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802971:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802974:	89 d0                	mov    %edx,%eax
  802976:	01 c0                	add    %eax,%eax
  802978:	01 d0                	add    %edx,%eax
  80297a:	c1 e0 02             	shl    $0x2,%eax
  80297d:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802983:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802986:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802988:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80298b:	89 d0                	mov    %edx,%eax
  80298d:	01 c0                	add    %eax,%eax
  80298f:	01 d0                	add    %edx,%eax
  802991:	c1 e0 02             	shl    $0x2,%eax
  802994:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  80299a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80299d:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  80299f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029a2:	89 d0                	mov    %edx,%eax
  8029a4:	01 c0                	add    %eax,%eax
  8029a6:	01 d0                	add    %edx,%eax
  8029a8:	c1 e0 02             	shl    $0x2,%eax
  8029ab:	05 48 20 81 00       	add    $0x812048,%eax
  8029b0:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8029b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8029b9:	eb 0c                	jmp    8029c7 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029bb:	ff 45 e4             	incl   -0x1c(%ebp)
  8029be:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8029c5:	7e 93                	jle    80295a <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  8029c7:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8029cb:	0f 84 8d 01 00 00    	je     802b5e <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8029d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8029d8:	e9 74 01 00 00       	jmp    802b51 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8029dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8029e3:	0f 84 64 01 00 00    	je     802b4d <realloc+0x3e1>
				if (uhp_frees[k].free)
  8029e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029ec:	89 d0                	mov    %edx,%eax
  8029ee:	01 c0                	add    %eax,%eax
  8029f0:	01 d0                	add    %edx,%eax
  8029f2:	c1 e0 02             	shl    $0x2,%eax
  8029f5:	05 48 20 81 00       	add    $0x812048,%eax
  8029fa:	8a 00                	mov    (%eax),%al
  8029fc:	84 c0                	test   %al,%al
  8029fe:	0f 84 4a 01 00 00    	je     802b4e <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802a04:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a07:	89 d0                	mov    %edx,%eax
  802a09:	01 c0                	add    %eax,%eax
  802a0b:	01 d0                	add    %edx,%eax
  802a0d:	c1 e0 02             	shl    $0x2,%eax
  802a10:	05 40 20 81 00       	add    $0x812040,%eax
  802a15:	8b 08                	mov    (%eax),%ecx
  802a17:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a1a:	89 d0                	mov    %edx,%eax
  802a1c:	01 c0                	add    %eax,%eax
  802a1e:	01 d0                	add    %edx,%eax
  802a20:	c1 e0 02             	shl    $0x2,%eax
  802a23:	05 44 20 81 00       	add    $0x812044,%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	01 c1                	add    %eax,%ecx
  802a2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a2f:	89 d0                	mov    %edx,%eax
  802a31:	01 c0                	add    %eax,%eax
  802a33:	01 d0                	add    %edx,%eax
  802a35:	c1 e0 02             	shl    $0x2,%eax
  802a38:	05 40 20 81 00       	add    $0x812040,%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	39 c1                	cmp    %eax,%ecx
  802a41:	75 7a                	jne    802abd <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802a43:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a46:	89 d0                	mov    %edx,%eax
  802a48:	01 c0                	add    %eax,%eax
  802a4a:	01 d0                	add    %edx,%eax
  802a4c:	c1 e0 02             	shl    $0x2,%eax
  802a4f:	05 40 20 81 00       	add    $0x812040,%eax
  802a54:	8b 10                	mov    (%eax),%edx
  802a56:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802a59:	89 c8                	mov    %ecx,%eax
  802a5b:	01 c0                	add    %eax,%eax
  802a5d:	01 c8                	add    %ecx,%eax
  802a5f:	c1 e0 02             	shl    $0x2,%eax
  802a62:	05 40 20 81 00       	add    $0x812040,%eax
  802a67:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802a69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a6c:	89 d0                	mov    %edx,%eax
  802a6e:	01 c0                	add    %eax,%eax
  802a70:	01 d0                	add    %edx,%eax
  802a72:	c1 e0 02             	shl    $0x2,%eax
  802a75:	05 44 20 81 00       	add    $0x812044,%eax
  802a7a:	8b 08                	mov    (%eax),%ecx
  802a7c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a7f:	89 d0                	mov    %edx,%eax
  802a81:	01 c0                	add    %eax,%eax
  802a83:	01 d0                	add    %edx,%eax
  802a85:	c1 e0 02             	shl    $0x2,%eax
  802a88:	05 44 20 81 00       	add    $0x812044,%eax
  802a8d:	8b 00                	mov    (%eax),%eax
  802a8f:	01 c1                	add    %eax,%ecx
  802a91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a94:	89 d0                	mov    %edx,%eax
  802a96:	01 c0                	add    %eax,%eax
  802a98:	01 d0                	add    %edx,%eax
  802a9a:	c1 e0 02             	shl    $0x2,%eax
  802a9d:	05 44 20 81 00       	add    $0x812044,%eax
  802aa2:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802aa4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802aa7:	89 d0                	mov    %edx,%eax
  802aa9:	01 c0                	add    %eax,%eax
  802aab:	01 d0                	add    %edx,%eax
  802aad:	c1 e0 02             	shl    $0x2,%eax
  802ab0:	05 48 20 81 00       	add    $0x812048,%eax
  802ab5:	c6 00 00             	movb   $0x0,(%eax)
  802ab8:	e9 91 00 00 00       	jmp    802b4e <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802abd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ac0:	89 d0                	mov    %edx,%eax
  802ac2:	01 c0                	add    %eax,%eax
  802ac4:	01 d0                	add    %edx,%eax
  802ac6:	c1 e0 02             	shl    $0x2,%eax
  802ac9:	05 40 20 81 00       	add    $0x812040,%eax
  802ace:	8b 08                	mov    (%eax),%ecx
  802ad0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad3:	89 d0                	mov    %edx,%eax
  802ad5:	01 c0                	add    %eax,%eax
  802ad7:	01 d0                	add    %edx,%eax
  802ad9:	c1 e0 02             	shl    $0x2,%eax
  802adc:	05 44 20 81 00       	add    $0x812044,%eax
  802ae1:	8b 00                	mov    (%eax),%eax
  802ae3:	01 c1                	add    %eax,%ecx
  802ae5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ae8:	89 d0                	mov    %edx,%eax
  802aea:	01 c0                	add    %eax,%eax
  802aec:	01 d0                	add    %edx,%eax
  802aee:	c1 e0 02             	shl    $0x2,%eax
  802af1:	05 40 20 81 00       	add    $0x812040,%eax
  802af6:	8b 00                	mov    (%eax),%eax
  802af8:	39 c1                	cmp    %eax,%ecx
  802afa:	75 52                	jne    802b4e <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802afc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aff:	89 d0                	mov    %edx,%eax
  802b01:	01 c0                	add    %eax,%eax
  802b03:	01 d0                	add    %edx,%eax
  802b05:	c1 e0 02             	shl    $0x2,%eax
  802b08:	05 44 20 81 00       	add    $0x812044,%eax
  802b0d:	8b 08                	mov    (%eax),%ecx
  802b0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b12:	89 d0                	mov    %edx,%eax
  802b14:	01 c0                	add    %eax,%eax
  802b16:	01 d0                	add    %edx,%eax
  802b18:	c1 e0 02             	shl    $0x2,%eax
  802b1b:	05 44 20 81 00       	add    $0x812044,%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	01 c1                	add    %eax,%ecx
  802b24:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b27:	89 d0                	mov    %edx,%eax
  802b29:	01 c0                	add    %eax,%eax
  802b2b:	01 d0                	add    %edx,%eax
  802b2d:	c1 e0 02             	shl    $0x2,%eax
  802b30:	05 44 20 81 00       	add    $0x812044,%eax
  802b35:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802b37:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b3a:	89 d0                	mov    %edx,%eax
  802b3c:	01 c0                	add    %eax,%eax
  802b3e:	01 d0                	add    %edx,%eax
  802b40:	c1 e0 02             	shl    $0x2,%eax
  802b43:	05 48 20 81 00       	add    $0x812048,%eax
  802b48:	c6 00 00             	movb   $0x0,(%eax)
  802b4b:	eb 01                	jmp    802b4e <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802b4d:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802b4e:	ff 45 e0             	incl   -0x20(%ebp)
  802b51:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802b58:	0f 8e 7f fe ff ff    	jle    8029dd <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802b5e:	a1 30 61 83 00       	mov    0x836130,%eax
  802b63:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802b66:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802b6d:	eb 53                	jmp    802bc2 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802b6f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b72:	89 d0                	mov    %edx,%eax
  802b74:	01 c0                	add    %eax,%eax
  802b76:	01 d0                	add    %edx,%eax
  802b78:	c1 e0 02             	shl    $0x2,%eax
  802b7b:	05 48 60 80 00       	add    $0x806048,%eax
  802b80:	8a 00                	mov    (%eax),%al
  802b82:	84 c0                	test   %al,%al
  802b84:	74 39                	je     802bbf <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802b86:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b89:	89 d0                	mov    %edx,%eax
  802b8b:	01 c0                	add    %eax,%eax
  802b8d:	01 d0                	add    %edx,%eax
  802b8f:	c1 e0 02             	shl    $0x2,%eax
  802b92:	05 40 60 80 00       	add    $0x806040,%eax
  802b97:	8b 08                	mov    (%eax),%ecx
  802b99:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b9c:	89 d0                	mov    %edx,%eax
  802b9e:	01 c0                	add    %eax,%eax
  802ba0:	01 d0                	add    %edx,%eax
  802ba2:	c1 e0 02             	shl    $0x2,%eax
  802ba5:	05 44 60 80 00       	add    $0x806044,%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	01 c8                	add    %ecx,%eax
  802bae:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802bb1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802bb4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802bb7:	76 06                	jbe    802bbf <realloc+0x453>
  802bb9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802bbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802bbf:	ff 45 d8             	incl   -0x28(%ebp)
  802bc2:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802bc9:	7e a4                	jle    802b6f <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802bcb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bce:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd6:	e9 a9 01 00 00       	jmp    802d84 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802bdb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	01 d0                	add    %edx,%eax
  802be3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802be6:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bed:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802bf4:	eb 57                	jmp    802c4d <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802bf6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802bf9:	89 d0                	mov    %edx,%eax
  802bfb:	01 c0                	add    %eax,%eax
  802bfd:	01 d0                	add    %edx,%eax
  802bff:	c1 e0 02             	shl    $0x2,%eax
  802c02:	05 48 20 81 00       	add    $0x812048,%eax
  802c07:	8a 00                	mov    (%eax),%al
  802c09:	84 c0                	test   %al,%al
  802c0b:	74 3d                	je     802c4a <realloc+0x4de>
  802c0d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802c10:	89 d0                	mov    %edx,%eax
  802c12:	01 c0                	add    %eax,%eax
  802c14:	01 d0                	add    %edx,%eax
  802c16:	c1 e0 02             	shl    $0x2,%eax
  802c19:	05 40 20 81 00       	add    $0x812040,%eax
  802c1e:	8b 00                	mov    (%eax),%eax
  802c20:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802c23:	75 25                	jne    802c4a <realloc+0x4de>
  802c25:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802c28:	89 d0                	mov    %edx,%eax
  802c2a:	01 c0                	add    %eax,%eax
  802c2c:	01 d0                	add    %edx,%eax
  802c2e:	c1 e0 02             	shl    $0x2,%eax
  802c31:	05 44 20 81 00       	add    $0x812044,%eax
  802c36:	8b 10                	mov    (%eax),%edx
  802c38:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c3b:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802c3e:	39 c2                	cmp    %eax,%edx
  802c40:	72 08                	jb     802c4a <realloc+0x4de>
		{
			adjIdx = j; break;
  802c42:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c48:	eb 0c                	jmp    802c56 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c4a:	ff 45 d0             	incl   -0x30(%ebp)
  802c4d:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802c54:	7e a0                	jle    802bf6 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802c56:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802c5a:	0f 84 d6 00 00 00    	je     802d36 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802c60:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c63:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802c66:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802c69:	83 ec 08             	sub    $0x8,%esp
  802c6c:	ff 75 a0             	pushl  -0x60(%ebp)
  802c6f:	ff 75 a4             	pushl  -0x5c(%ebp)
  802c72:	e8 cf 09 00 00       	call   803646 <sys_allocate_user_mem>
  802c77:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802c7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7d:	89 d0                	mov    %edx,%eax
  802c7f:	01 c0                	add    %eax,%eax
  802c81:	01 d0                	add    %edx,%eax
  802c83:	c1 e0 02             	shl    $0x2,%eax
  802c86:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802c8c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c8f:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802c91:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c94:	89 d0                	mov    %edx,%eax
  802c96:	01 c0                	add    %eax,%eax
  802c98:	01 d0                	add    %edx,%eax
  802c9a:	c1 e0 02             	shl    $0x2,%eax
  802c9d:	05 40 20 81 00       	add    $0x812040,%eax
  802ca2:	8b 10                	mov    (%eax),%edx
  802ca4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802ca7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802caa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802cad:	89 d0                	mov    %edx,%eax
  802caf:	01 c0                	add    %eax,%eax
  802cb1:	01 d0                	add    %edx,%eax
  802cb3:	c1 e0 02             	shl    $0x2,%eax
  802cb6:	05 40 20 81 00       	add    $0x812040,%eax
  802cbb:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802cbd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802cc0:	89 d0                	mov    %edx,%eax
  802cc2:	01 c0                	add    %eax,%eax
  802cc4:	01 d0                	add    %edx,%eax
  802cc6:	c1 e0 02             	shl    $0x2,%eax
  802cc9:	05 44 20 81 00       	add    $0x812044,%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802cd3:	89 c2                	mov    %eax,%edx
  802cd5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802cd8:	89 c8                	mov    %ecx,%eax
  802cda:	01 c0                	add    %eax,%eax
  802cdc:	01 c8                	add    %ecx,%eax
  802cde:	c1 e0 02             	shl    $0x2,%eax
  802ce1:	05 44 20 81 00       	add    $0x812044,%eax
  802ce6:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802ce8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ceb:	89 d0                	mov    %edx,%eax
  802ced:	01 c0                	add    %eax,%eax
  802cef:	01 d0                	add    %edx,%eax
  802cf1:	c1 e0 02             	shl    $0x2,%eax
  802cf4:	05 44 20 81 00       	add    $0x812044,%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	85 c0                	test   %eax,%eax
  802cfd:	75 14                	jne    802d13 <realloc+0x5a7>
  802cff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d02:	89 d0                	mov    %edx,%eax
  802d04:	01 c0                	add    %eax,%eax
  802d06:	01 d0                	add    %edx,%eax
  802d08:	c1 e0 02             	shl    $0x2,%eax
  802d0b:	05 48 20 81 00       	add    $0x812048,%eax
  802d10:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802d13:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d16:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d19:	01 c2                	add    %eax,%edx
  802d1b:	a1 88 60 83 00       	mov    0x836088,%eax
  802d20:	39 c2                	cmp    %eax,%edx
  802d22:	76 0d                	jbe    802d31 <realloc+0x5c5>
  802d24:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d27:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d2a:	01 d0                	add    %edx,%eax
  802d2c:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	eb 4e                	jmp    802d84 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802d36:	83 ec 0c             	sub    $0xc,%esp
  802d39:	ff 75 0c             	pushl  0xc(%ebp)
  802d3c:	e8 0b ec ff ff       	call   80194c <malloc>
  802d41:	83 c4 10             	add    $0x10,%esp
  802d44:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802d47:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802d4b:	75 07                	jne    802d54 <realloc+0x5e8>
		return NULL;
  802d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d52:	eb 30                	jmp    802d84 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802d54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d57:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d5a:	39 d0                	cmp    %edx,%eax
  802d5c:	76 02                	jbe    802d60 <realloc+0x5f4>
  802d5e:	89 d0                	mov    %edx,%eax
  802d60:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	50                   	push   %eax
  802d67:	52                   	push   %edx
  802d68:	ff 75 cc             	pushl  -0x34(%ebp)
  802d6b:	e8 cf 06 00 00       	call   80343f <sys_move_user_mem>
  802d70:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802d73:	83 ec 0c             	sub    $0xc,%esp
  802d76:	ff 75 08             	pushl  0x8(%ebp)
  802d79:	e8 2e ef ff ff       	call   801cac <free>
  802d7e:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802d81:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802d84:	c9                   	leave  
  802d85:	c3                   	ret    

00802d86 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802d86:	55                   	push   %ebp
  802d87:	89 e5                	mov    %esp,%ebp
  802d89:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802d92:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d96:	0f 84 33 03 00 00    	je     8030cf <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802d9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9f:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802da4:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802da7:	83 ec 08             	sub    $0x8,%esp
  802daa:	ff 75 08             	pushl  0x8(%ebp)
  802dad:	ff 75 d8             	pushl  -0x28(%ebp)
  802db0:	e8 7d 05 00 00       	call   803332 <sys_delete_shared_object>
  802db5:	83 c4 10             	add    $0x10,%esp
  802db8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802dbb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802dbf:	0f 88 0d 03 00 00    	js     8030d2 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802dc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802dcc:	e9 ef 02 00 00       	jmp    8030c0 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802dd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd4:	89 d0                	mov    %edx,%eax
  802dd6:	01 c0                	add    %eax,%eax
  802dd8:	01 d0                	add    %edx,%eax
  802dda:	c1 e0 02             	shl    $0x2,%eax
  802ddd:	05 48 60 80 00       	add    $0x806048,%eax
  802de2:	8a 00                	mov    (%eax),%al
  802de4:	84 c0                	test   %al,%al
  802de6:	0f 84 d1 02 00 00    	je     8030bd <sfree+0x337>
  802dec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802def:	89 d0                	mov    %edx,%eax
  802df1:	01 c0                	add    %eax,%eax
  802df3:	01 d0                	add    %edx,%eax
  802df5:	c1 e0 02             	shl    $0x2,%eax
  802df8:	05 40 60 80 00       	add    $0x806040,%eax
  802dfd:	8b 00                	mov    (%eax),%eax
  802dff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802e02:	0f 85 b5 02 00 00    	jne    8030bd <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802e08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0b:	89 d0                	mov    %edx,%eax
  802e0d:	01 c0                	add    %eax,%eax
  802e0f:	01 d0                	add    %edx,%eax
  802e11:	c1 e0 02             	shl    $0x2,%eax
  802e14:	05 44 60 80 00       	add    $0x806044,%eax
  802e19:	8b 00                	mov    (%eax),%eax
  802e1b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e21:	89 d0                	mov    %edx,%eax
  802e23:	01 c0                	add    %eax,%eax
  802e25:	01 d0                	add    %edx,%eax
  802e27:	c1 e0 02             	shl    $0x2,%eax
  802e2a:	05 48 60 80 00       	add    $0x806048,%eax
  802e2f:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802e32:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802e39:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802e40:	eb 64                	jmp    802ea6 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802e42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e45:	89 d0                	mov    %edx,%eax
  802e47:	01 c0                	add    %eax,%eax
  802e49:	01 d0                	add    %edx,%eax
  802e4b:	c1 e0 02             	shl    $0x2,%eax
  802e4e:	05 48 20 81 00       	add    $0x812048,%eax
  802e53:	8a 00                	mov    (%eax),%al
  802e55:	84 c0                	test   %al,%al
  802e57:	75 4a                	jne    802ea3 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802e59:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e5c:	89 d0                	mov    %edx,%eax
  802e5e:	01 c0                	add    %eax,%eax
  802e60:	01 d0                	add    %edx,%eax
  802e62:	c1 e0 02             	shl    $0x2,%eax
  802e65:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802e6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e6e:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802e70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e73:	89 d0                	mov    %edx,%eax
  802e75:	01 c0                	add    %eax,%eax
  802e77:	01 d0                	add    %edx,%eax
  802e79:	c1 e0 02             	shl    $0x2,%eax
  802e7c:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802e82:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e85:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802e87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e8a:	89 d0                	mov    %edx,%eax
  802e8c:	01 c0                	add    %eax,%eax
  802e8e:	01 d0                	add    %edx,%eax
  802e90:	c1 e0 02             	shl    $0x2,%eax
  802e93:	05 48 20 81 00       	add    $0x812048,%eax
  802e98:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802ea1:	eb 0c                	jmp    802eaf <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ea3:	ff 45 ec             	incl   -0x14(%ebp)
  802ea6:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802ead:	7e 93                	jle    802e42 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802eaf:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802eb3:	0f 84 8d 01 00 00    	je     803046 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802eb9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802ec0:	e9 74 01 00 00       	jmp    803039 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802ec5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ecb:	0f 84 64 01 00 00    	je     803035 <sfree+0x2af>
					if (uhp_frees[k].free)
  802ed1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ed4:	89 d0                	mov    %edx,%eax
  802ed6:	01 c0                	add    %eax,%eax
  802ed8:	01 d0                	add    %edx,%eax
  802eda:	c1 e0 02             	shl    $0x2,%eax
  802edd:	05 48 20 81 00       	add    $0x812048,%eax
  802ee2:	8a 00                	mov    (%eax),%al
  802ee4:	84 c0                	test   %al,%al
  802ee6:	0f 84 4a 01 00 00    	je     803036 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802eec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eef:	89 d0                	mov    %edx,%eax
  802ef1:	01 c0                	add    %eax,%eax
  802ef3:	01 d0                	add    %edx,%eax
  802ef5:	c1 e0 02             	shl    $0x2,%eax
  802ef8:	05 40 20 81 00       	add    $0x812040,%eax
  802efd:	8b 08                	mov    (%eax),%ecx
  802eff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f02:	89 d0                	mov    %edx,%eax
  802f04:	01 c0                	add    %eax,%eax
  802f06:	01 d0                	add    %edx,%eax
  802f08:	c1 e0 02             	shl    $0x2,%eax
  802f0b:	05 44 20 81 00       	add    $0x812044,%eax
  802f10:	8b 00                	mov    (%eax),%eax
  802f12:	01 c1                	add    %eax,%ecx
  802f14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f17:	89 d0                	mov    %edx,%eax
  802f19:	01 c0                	add    %eax,%eax
  802f1b:	01 d0                	add    %edx,%eax
  802f1d:	c1 e0 02             	shl    $0x2,%eax
  802f20:	05 40 20 81 00       	add    $0x812040,%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	39 c1                	cmp    %eax,%ecx
  802f29:	75 7a                	jne    802fa5 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802f2b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f2e:	89 d0                	mov    %edx,%eax
  802f30:	01 c0                	add    %eax,%eax
  802f32:	01 d0                	add    %edx,%eax
  802f34:	c1 e0 02             	shl    $0x2,%eax
  802f37:	05 40 20 81 00       	add    $0x812040,%eax
  802f3c:	8b 10                	mov    (%eax),%edx
  802f3e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802f41:	89 c8                	mov    %ecx,%eax
  802f43:	01 c0                	add    %eax,%eax
  802f45:	01 c8                	add    %ecx,%eax
  802f47:	c1 e0 02             	shl    $0x2,%eax
  802f4a:	05 40 20 81 00       	add    $0x812040,%eax
  802f4f:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802f51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f54:	89 d0                	mov    %edx,%eax
  802f56:	01 c0                	add    %eax,%eax
  802f58:	01 d0                	add    %edx,%eax
  802f5a:	c1 e0 02             	shl    $0x2,%eax
  802f5d:	05 44 20 81 00       	add    $0x812044,%eax
  802f62:	8b 08                	mov    (%eax),%ecx
  802f64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f67:	89 d0                	mov    %edx,%eax
  802f69:	01 c0                	add    %eax,%eax
  802f6b:	01 d0                	add    %edx,%eax
  802f6d:	c1 e0 02             	shl    $0x2,%eax
  802f70:	05 44 20 81 00       	add    $0x812044,%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	01 c1                	add    %eax,%ecx
  802f79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f7c:	89 d0                	mov    %edx,%eax
  802f7e:	01 c0                	add    %eax,%eax
  802f80:	01 d0                	add    %edx,%eax
  802f82:	c1 e0 02             	shl    $0x2,%eax
  802f85:	05 44 20 81 00       	add    $0x812044,%eax
  802f8a:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802f8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8f:	89 d0                	mov    %edx,%eax
  802f91:	01 c0                	add    %eax,%eax
  802f93:	01 d0                	add    %edx,%eax
  802f95:	c1 e0 02             	shl    $0x2,%eax
  802f98:	05 48 20 81 00       	add    $0x812048,%eax
  802f9d:	c6 00 00             	movb   $0x0,(%eax)
  802fa0:	e9 91 00 00 00       	jmp    803036 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802fa5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa8:	89 d0                	mov    %edx,%eax
  802faa:	01 c0                	add    %eax,%eax
  802fac:	01 d0                	add    %edx,%eax
  802fae:	c1 e0 02             	shl    $0x2,%eax
  802fb1:	05 40 20 81 00       	add    $0x812040,%eax
  802fb6:	8b 08                	mov    (%eax),%ecx
  802fb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fbb:	89 d0                	mov    %edx,%eax
  802fbd:	01 c0                	add    %eax,%eax
  802fbf:	01 d0                	add    %edx,%eax
  802fc1:	c1 e0 02             	shl    $0x2,%eax
  802fc4:	05 44 20 81 00       	add    $0x812044,%eax
  802fc9:	8b 00                	mov    (%eax),%eax
  802fcb:	01 c1                	add    %eax,%ecx
  802fcd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd0:	89 d0                	mov    %edx,%eax
  802fd2:	01 c0                	add    %eax,%eax
  802fd4:	01 d0                	add    %edx,%eax
  802fd6:	c1 e0 02             	shl    $0x2,%eax
  802fd9:	05 40 20 81 00       	add    $0x812040,%eax
  802fde:	8b 00                	mov    (%eax),%eax
  802fe0:	39 c1                	cmp    %eax,%ecx
  802fe2:	75 52                	jne    803036 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802fe4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe7:	89 d0                	mov    %edx,%eax
  802fe9:	01 c0                	add    %eax,%eax
  802feb:	01 d0                	add    %edx,%eax
  802fed:	c1 e0 02             	shl    $0x2,%eax
  802ff0:	05 44 20 81 00       	add    $0x812044,%eax
  802ff5:	8b 08                	mov    (%eax),%ecx
  802ff7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ffa:	89 d0                	mov    %edx,%eax
  802ffc:	01 c0                	add    %eax,%eax
  802ffe:	01 d0                	add    %edx,%eax
  803000:	c1 e0 02             	shl    $0x2,%eax
  803003:	05 44 20 81 00       	add    $0x812044,%eax
  803008:	8b 00                	mov    (%eax),%eax
  80300a:	01 c1                	add    %eax,%ecx
  80300c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80300f:	89 d0                	mov    %edx,%eax
  803011:	01 c0                	add    %eax,%eax
  803013:	01 d0                	add    %edx,%eax
  803015:	c1 e0 02             	shl    $0x2,%eax
  803018:	05 44 20 81 00       	add    $0x812044,%eax
  80301d:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  80301f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803022:	89 d0                	mov    %edx,%eax
  803024:	01 c0                	add    %eax,%eax
  803026:	01 d0                	add    %edx,%eax
  803028:	c1 e0 02             	shl    $0x2,%eax
  80302b:	05 48 20 81 00       	add    $0x812048,%eax
  803030:	c6 00 00             	movb   $0x0,(%eax)
  803033:	eb 01                	jmp    803036 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  803035:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803036:	ff 45 e8             	incl   -0x18(%ebp)
  803039:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803040:	0f 8e 7f fe ff ff    	jle    802ec5 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  803046:	a1 30 61 83 00       	mov    0x836130,%eax
  80304b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80304e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803055:	eb 53                	jmp    8030aa <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  803057:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80305a:	89 d0                	mov    %edx,%eax
  80305c:	01 c0                	add    %eax,%eax
  80305e:	01 d0                	add    %edx,%eax
  803060:	c1 e0 02             	shl    $0x2,%eax
  803063:	05 48 60 80 00       	add    $0x806048,%eax
  803068:	8a 00                	mov    (%eax),%al
  80306a:	84 c0                	test   %al,%al
  80306c:	74 39                	je     8030a7 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80306e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803071:	89 d0                	mov    %edx,%eax
  803073:	01 c0                	add    %eax,%eax
  803075:	01 d0                	add    %edx,%eax
  803077:	c1 e0 02             	shl    $0x2,%eax
  80307a:	05 40 60 80 00       	add    $0x806040,%eax
  80307f:	8b 08                	mov    (%eax),%ecx
  803081:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803084:	89 d0                	mov    %edx,%eax
  803086:	01 c0                	add    %eax,%eax
  803088:	01 d0                	add    %edx,%eax
  80308a:	c1 e0 02             	shl    $0x2,%eax
  80308d:	05 44 60 80 00       	add    $0x806044,%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	01 c8                	add    %ecx,%eax
  803096:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  803099:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80309c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80309f:	76 06                	jbe    8030a7 <sfree+0x321>
  8030a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8030a7:	ff 45 e0             	incl   -0x20(%ebp)
  8030aa:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8030b1:	7e a4                	jle    803057 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  8030b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b6:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  8030bb:	eb 16                	jmp    8030d3 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8030bd:	ff 45 f4             	incl   -0xc(%ebp)
  8030c0:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  8030c7:	0f 8e 04 fd ff ff    	jle    802dd1 <sfree+0x4b>
  8030cd:	eb 04                	jmp    8030d3 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  8030cf:	90                   	nop
  8030d0:	eb 01                	jmp    8030d3 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  8030d2:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  8030d3:	c9                   	leave  
  8030d4:	c3                   	ret    

008030d5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8030d5:	55                   	push   %ebp
  8030d6:	89 e5                	mov    %esp,%ebp
  8030d8:	57                   	push   %edi
  8030d9:	56                   	push   %esi
  8030da:	53                   	push   %ebx
  8030db:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8030ea:	8b 7d 18             	mov    0x18(%ebp),%edi
  8030ed:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8030f0:	cd 30                	int    $0x30
  8030f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8030f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8030f8:	83 c4 10             	add    $0x10,%esp
  8030fb:	5b                   	pop    %ebx
  8030fc:	5e                   	pop    %esi
  8030fd:	5f                   	pop    %edi
  8030fe:	5d                   	pop    %ebp
  8030ff:	c3                   	ret    

00803100 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803100:	55                   	push   %ebp
  803101:	89 e5                	mov    %esp,%ebp
  803103:	83 ec 04             	sub    $0x4,%esp
  803106:	8b 45 10             	mov    0x10(%ebp),%eax
  803109:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80310c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80310f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	6a 00                	push   $0x0
  803118:	51                   	push   %ecx
  803119:	52                   	push   %edx
  80311a:	ff 75 0c             	pushl  0xc(%ebp)
  80311d:	50                   	push   %eax
  80311e:	6a 00                	push   $0x0
  803120:	e8 b0 ff ff ff       	call   8030d5 <syscall>
  803125:	83 c4 18             	add    $0x18,%esp
}
  803128:	90                   	nop
  803129:	c9                   	leave  
  80312a:	c3                   	ret    

0080312b <sys_cgetc>:

int
sys_cgetc(void)
{
  80312b:	55                   	push   %ebp
  80312c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80312e:	6a 00                	push   $0x0
  803130:	6a 00                	push   $0x0
  803132:	6a 00                	push   $0x0
  803134:	6a 00                	push   $0x0
  803136:	6a 00                	push   $0x0
  803138:	6a 02                	push   $0x2
  80313a:	e8 96 ff ff ff       	call   8030d5 <syscall>
  80313f:	83 c4 18             	add    $0x18,%esp
}
  803142:	c9                   	leave  
  803143:	c3                   	ret    

00803144 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803144:	55                   	push   %ebp
  803145:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803147:	6a 00                	push   $0x0
  803149:	6a 00                	push   $0x0
  80314b:	6a 00                	push   $0x0
  80314d:	6a 00                	push   $0x0
  80314f:	6a 00                	push   $0x0
  803151:	6a 03                	push   $0x3
  803153:	e8 7d ff ff ff       	call   8030d5 <syscall>
  803158:	83 c4 18             	add    $0x18,%esp
}
  80315b:	90                   	nop
  80315c:	c9                   	leave  
  80315d:	c3                   	ret    

0080315e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80315e:	55                   	push   %ebp
  80315f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803161:	6a 00                	push   $0x0
  803163:	6a 00                	push   $0x0
  803165:	6a 00                	push   $0x0
  803167:	6a 00                	push   $0x0
  803169:	6a 00                	push   $0x0
  80316b:	6a 04                	push   $0x4
  80316d:	e8 63 ff ff ff       	call   8030d5 <syscall>
  803172:	83 c4 18             	add    $0x18,%esp
}
  803175:	90                   	nop
  803176:	c9                   	leave  
  803177:	c3                   	ret    

00803178 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803178:	55                   	push   %ebp
  803179:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80317b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	6a 00                	push   $0x0
  803183:	6a 00                	push   $0x0
  803185:	6a 00                	push   $0x0
  803187:	52                   	push   %edx
  803188:	50                   	push   %eax
  803189:	6a 08                	push   $0x8
  80318b:	e8 45 ff ff ff       	call   8030d5 <syscall>
  803190:	83 c4 18             	add    $0x18,%esp
}
  803193:	c9                   	leave  
  803194:	c3                   	ret    

00803195 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803195:	55                   	push   %ebp
  803196:	89 e5                	mov    %esp,%ebp
  803198:	56                   	push   %esi
  803199:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80319a:	8b 75 18             	mov    0x18(%ebp),%esi
  80319d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8031a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a9:	56                   	push   %esi
  8031aa:	53                   	push   %ebx
  8031ab:	51                   	push   %ecx
  8031ac:	52                   	push   %edx
  8031ad:	50                   	push   %eax
  8031ae:	6a 09                	push   $0x9
  8031b0:	e8 20 ff ff ff       	call   8030d5 <syscall>
  8031b5:	83 c4 18             	add    $0x18,%esp
}
  8031b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8031bb:	5b                   	pop    %ebx
  8031bc:	5e                   	pop    %esi
  8031bd:	5d                   	pop    %ebp
  8031be:	c3                   	ret    

008031bf <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8031bf:	55                   	push   %ebp
  8031c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8031c2:	6a 00                	push   $0x0
  8031c4:	6a 00                	push   $0x0
  8031c6:	6a 00                	push   $0x0
  8031c8:	6a 00                	push   $0x0
  8031ca:	ff 75 08             	pushl  0x8(%ebp)
  8031cd:	6a 0a                	push   $0xa
  8031cf:	e8 01 ff ff ff       	call   8030d5 <syscall>
  8031d4:	83 c4 18             	add    $0x18,%esp
}
  8031d7:	c9                   	leave  
  8031d8:	c3                   	ret    

008031d9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8031d9:	55                   	push   %ebp
  8031da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8031dc:	6a 00                	push   $0x0
  8031de:	6a 00                	push   $0x0
  8031e0:	6a 00                	push   $0x0
  8031e2:	ff 75 0c             	pushl  0xc(%ebp)
  8031e5:	ff 75 08             	pushl  0x8(%ebp)
  8031e8:	6a 0b                	push   $0xb
  8031ea:	e8 e6 fe ff ff       	call   8030d5 <syscall>
  8031ef:	83 c4 18             	add    $0x18,%esp
}
  8031f2:	c9                   	leave  
  8031f3:	c3                   	ret    

008031f4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8031f4:	55                   	push   %ebp
  8031f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8031f7:	6a 00                	push   $0x0
  8031f9:	6a 00                	push   $0x0
  8031fb:	6a 00                	push   $0x0
  8031fd:	6a 00                	push   $0x0
  8031ff:	6a 00                	push   $0x0
  803201:	6a 0c                	push   $0xc
  803203:	e8 cd fe ff ff       	call   8030d5 <syscall>
  803208:	83 c4 18             	add    $0x18,%esp
}
  80320b:	c9                   	leave  
  80320c:	c3                   	ret    

0080320d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80320d:	55                   	push   %ebp
  80320e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803210:	6a 00                	push   $0x0
  803212:	6a 00                	push   $0x0
  803214:	6a 00                	push   $0x0
  803216:	6a 00                	push   $0x0
  803218:	6a 00                	push   $0x0
  80321a:	6a 0d                	push   $0xd
  80321c:	e8 b4 fe ff ff       	call   8030d5 <syscall>
  803221:	83 c4 18             	add    $0x18,%esp
}
  803224:	c9                   	leave  
  803225:	c3                   	ret    

00803226 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803226:	55                   	push   %ebp
  803227:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803229:	6a 00                	push   $0x0
  80322b:	6a 00                	push   $0x0
  80322d:	6a 00                	push   $0x0
  80322f:	6a 00                	push   $0x0
  803231:	6a 00                	push   $0x0
  803233:	6a 0e                	push   $0xe
  803235:	e8 9b fe ff ff       	call   8030d5 <syscall>
  80323a:	83 c4 18             	add    $0x18,%esp
}
  80323d:	c9                   	leave  
  80323e:	c3                   	ret    

0080323f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80323f:	55                   	push   %ebp
  803240:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803242:	6a 00                	push   $0x0
  803244:	6a 00                	push   $0x0
  803246:	6a 00                	push   $0x0
  803248:	6a 00                	push   $0x0
  80324a:	6a 00                	push   $0x0
  80324c:	6a 0f                	push   $0xf
  80324e:	e8 82 fe ff ff       	call   8030d5 <syscall>
  803253:	83 c4 18             	add    $0x18,%esp
}
  803256:	c9                   	leave  
  803257:	c3                   	ret    

00803258 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803258:	55                   	push   %ebp
  803259:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80325b:	6a 00                	push   $0x0
  80325d:	6a 00                	push   $0x0
  80325f:	6a 00                	push   $0x0
  803261:	6a 00                	push   $0x0
  803263:	ff 75 08             	pushl  0x8(%ebp)
  803266:	6a 10                	push   $0x10
  803268:	e8 68 fe ff ff       	call   8030d5 <syscall>
  80326d:	83 c4 18             	add    $0x18,%esp
}
  803270:	c9                   	leave  
  803271:	c3                   	ret    

00803272 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803272:	55                   	push   %ebp
  803273:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803275:	6a 00                	push   $0x0
  803277:	6a 00                	push   $0x0
  803279:	6a 00                	push   $0x0
  80327b:	6a 00                	push   $0x0
  80327d:	6a 00                	push   $0x0
  80327f:	6a 11                	push   $0x11
  803281:	e8 4f fe ff ff       	call   8030d5 <syscall>
  803286:	83 c4 18             	add    $0x18,%esp
}
  803289:	90                   	nop
  80328a:	c9                   	leave  
  80328b:	c3                   	ret    

0080328c <sys_cputc>:

void
sys_cputc(const char c)
{
  80328c:	55                   	push   %ebp
  80328d:	89 e5                	mov    %esp,%ebp
  80328f:	83 ec 04             	sub    $0x4,%esp
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803298:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80329c:	6a 00                	push   $0x0
  80329e:	6a 00                	push   $0x0
  8032a0:	6a 00                	push   $0x0
  8032a2:	6a 00                	push   $0x0
  8032a4:	50                   	push   %eax
  8032a5:	6a 01                	push   $0x1
  8032a7:	e8 29 fe ff ff       	call   8030d5 <syscall>
  8032ac:	83 c4 18             	add    $0x18,%esp
}
  8032af:	90                   	nop
  8032b0:	c9                   	leave  
  8032b1:	c3                   	ret    

008032b2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8032b2:	55                   	push   %ebp
  8032b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8032b5:	6a 00                	push   $0x0
  8032b7:	6a 00                	push   $0x0
  8032b9:	6a 00                	push   $0x0
  8032bb:	6a 00                	push   $0x0
  8032bd:	6a 00                	push   $0x0
  8032bf:	6a 14                	push   $0x14
  8032c1:	e8 0f fe ff ff       	call   8030d5 <syscall>
  8032c6:	83 c4 18             	add    $0x18,%esp
}
  8032c9:	90                   	nop
  8032ca:	c9                   	leave  
  8032cb:	c3                   	ret    

008032cc <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8032cc:	55                   	push   %ebp
  8032cd:	89 e5                	mov    %esp,%ebp
  8032cf:	83 ec 04             	sub    $0x4,%esp
  8032d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8032d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8032d8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8032db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	6a 00                	push   $0x0
  8032e4:	51                   	push   %ecx
  8032e5:	52                   	push   %edx
  8032e6:	ff 75 0c             	pushl  0xc(%ebp)
  8032e9:	50                   	push   %eax
  8032ea:	6a 15                	push   $0x15
  8032ec:	e8 e4 fd ff ff       	call   8030d5 <syscall>
  8032f1:	83 c4 18             	add    $0x18,%esp
}
  8032f4:	c9                   	leave  
  8032f5:	c3                   	ret    

008032f6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8032f6:	55                   	push   %ebp
  8032f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8032f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	6a 00                	push   $0x0
  803301:	6a 00                	push   $0x0
  803303:	6a 00                	push   $0x0
  803305:	52                   	push   %edx
  803306:	50                   	push   %eax
  803307:	6a 16                	push   $0x16
  803309:	e8 c7 fd ff ff       	call   8030d5 <syscall>
  80330e:	83 c4 18             	add    $0x18,%esp
}
  803311:	c9                   	leave  
  803312:	c3                   	ret    

00803313 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803313:	55                   	push   %ebp
  803314:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803316:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	6a 00                	push   $0x0
  803321:	6a 00                	push   $0x0
  803323:	51                   	push   %ecx
  803324:	52                   	push   %edx
  803325:	50                   	push   %eax
  803326:	6a 17                	push   $0x17
  803328:	e8 a8 fd ff ff       	call   8030d5 <syscall>
  80332d:	83 c4 18             	add    $0x18,%esp
}
  803330:	c9                   	leave  
  803331:	c3                   	ret    

00803332 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803332:	55                   	push   %ebp
  803333:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803335:	8b 55 0c             	mov    0xc(%ebp),%edx
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	6a 00                	push   $0x0
  80333d:	6a 00                	push   $0x0
  80333f:	6a 00                	push   $0x0
  803341:	52                   	push   %edx
  803342:	50                   	push   %eax
  803343:	6a 18                	push   $0x18
  803345:	e8 8b fd ff ff       	call   8030d5 <syscall>
  80334a:	83 c4 18             	add    $0x18,%esp
}
  80334d:	c9                   	leave  
  80334e:	c3                   	ret    

0080334f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80334f:	55                   	push   %ebp
  803350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	6a 00                	push   $0x0
  803357:	ff 75 14             	pushl  0x14(%ebp)
  80335a:	ff 75 10             	pushl  0x10(%ebp)
  80335d:	ff 75 0c             	pushl  0xc(%ebp)
  803360:	50                   	push   %eax
  803361:	6a 19                	push   $0x19
  803363:	e8 6d fd ff ff       	call   8030d5 <syscall>
  803368:	83 c4 18             	add    $0x18,%esp
}
  80336b:	c9                   	leave  
  80336c:	c3                   	ret    

0080336d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80336d:	55                   	push   %ebp
  80336e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803370:	8b 45 08             	mov    0x8(%ebp),%eax
  803373:	6a 00                	push   $0x0
  803375:	6a 00                	push   $0x0
  803377:	6a 00                	push   $0x0
  803379:	6a 00                	push   $0x0
  80337b:	50                   	push   %eax
  80337c:	6a 1a                	push   $0x1a
  80337e:	e8 52 fd ff ff       	call   8030d5 <syscall>
  803383:	83 c4 18             	add    $0x18,%esp
}
  803386:	90                   	nop
  803387:	c9                   	leave  
  803388:	c3                   	ret    

00803389 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803389:	55                   	push   %ebp
  80338a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	6a 00                	push   $0x0
  803391:	6a 00                	push   $0x0
  803393:	6a 00                	push   $0x0
  803395:	6a 00                	push   $0x0
  803397:	50                   	push   %eax
  803398:	6a 1b                	push   $0x1b
  80339a:	e8 36 fd ff ff       	call   8030d5 <syscall>
  80339f:	83 c4 18             	add    $0x18,%esp
}
  8033a2:	c9                   	leave  
  8033a3:	c3                   	ret    

008033a4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8033a4:	55                   	push   %ebp
  8033a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8033a7:	6a 00                	push   $0x0
  8033a9:	6a 00                	push   $0x0
  8033ab:	6a 00                	push   $0x0
  8033ad:	6a 00                	push   $0x0
  8033af:	6a 00                	push   $0x0
  8033b1:	6a 05                	push   $0x5
  8033b3:	e8 1d fd ff ff       	call   8030d5 <syscall>
  8033b8:	83 c4 18             	add    $0x18,%esp
}
  8033bb:	c9                   	leave  
  8033bc:	c3                   	ret    

008033bd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8033bd:	55                   	push   %ebp
  8033be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8033c0:	6a 00                	push   $0x0
  8033c2:	6a 00                	push   $0x0
  8033c4:	6a 00                	push   $0x0
  8033c6:	6a 00                	push   $0x0
  8033c8:	6a 00                	push   $0x0
  8033ca:	6a 06                	push   $0x6
  8033cc:	e8 04 fd ff ff       	call   8030d5 <syscall>
  8033d1:	83 c4 18             	add    $0x18,%esp
}
  8033d4:	c9                   	leave  
  8033d5:	c3                   	ret    

008033d6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8033d6:	55                   	push   %ebp
  8033d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8033d9:	6a 00                	push   $0x0
  8033db:	6a 00                	push   $0x0
  8033dd:	6a 00                	push   $0x0
  8033df:	6a 00                	push   $0x0
  8033e1:	6a 00                	push   $0x0
  8033e3:	6a 07                	push   $0x7
  8033e5:	e8 eb fc ff ff       	call   8030d5 <syscall>
  8033ea:	83 c4 18             	add    $0x18,%esp
}
  8033ed:	c9                   	leave  
  8033ee:	c3                   	ret    

008033ef <sys_exit_env>:


void sys_exit_env(void)
{
  8033ef:	55                   	push   %ebp
  8033f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8033f2:	6a 00                	push   $0x0
  8033f4:	6a 00                	push   $0x0
  8033f6:	6a 00                	push   $0x0
  8033f8:	6a 00                	push   $0x0
  8033fa:	6a 00                	push   $0x0
  8033fc:	6a 1c                	push   $0x1c
  8033fe:	e8 d2 fc ff ff       	call   8030d5 <syscall>
  803403:	83 c4 18             	add    $0x18,%esp
}
  803406:	90                   	nop
  803407:	c9                   	leave  
  803408:	c3                   	ret    

00803409 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803409:	55                   	push   %ebp
  80340a:	89 e5                	mov    %esp,%ebp
  80340c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80340f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803412:	8d 50 04             	lea    0x4(%eax),%edx
  803415:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803418:	6a 00                	push   $0x0
  80341a:	6a 00                	push   $0x0
  80341c:	6a 00                	push   $0x0
  80341e:	52                   	push   %edx
  80341f:	50                   	push   %eax
  803420:	6a 1d                	push   $0x1d
  803422:	e8 ae fc ff ff       	call   8030d5 <syscall>
  803427:	83 c4 18             	add    $0x18,%esp
	return result;
  80342a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80342d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803430:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803433:	89 01                	mov    %eax,(%ecx)
  803435:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	c9                   	leave  
  80343c:	c2 04 00             	ret    $0x4

0080343f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80343f:	55                   	push   %ebp
  803440:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803442:	6a 00                	push   $0x0
  803444:	6a 00                	push   $0x0
  803446:	ff 75 10             	pushl  0x10(%ebp)
  803449:	ff 75 0c             	pushl  0xc(%ebp)
  80344c:	ff 75 08             	pushl  0x8(%ebp)
  80344f:	6a 13                	push   $0x13
  803451:	e8 7f fc ff ff       	call   8030d5 <syscall>
  803456:	83 c4 18             	add    $0x18,%esp
	return ;
  803459:	90                   	nop
}
  80345a:	c9                   	leave  
  80345b:	c3                   	ret    

0080345c <sys_rcr2>:
uint32 sys_rcr2()
{
  80345c:	55                   	push   %ebp
  80345d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80345f:	6a 00                	push   $0x0
  803461:	6a 00                	push   $0x0
  803463:	6a 00                	push   $0x0
  803465:	6a 00                	push   $0x0
  803467:	6a 00                	push   $0x0
  803469:	6a 1e                	push   $0x1e
  80346b:	e8 65 fc ff ff       	call   8030d5 <syscall>
  803470:	83 c4 18             	add    $0x18,%esp
}
  803473:	c9                   	leave  
  803474:	c3                   	ret    

00803475 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803475:	55                   	push   %ebp
  803476:	89 e5                	mov    %esp,%ebp
  803478:	83 ec 04             	sub    $0x4,%esp
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803481:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803485:	6a 00                	push   $0x0
  803487:	6a 00                	push   $0x0
  803489:	6a 00                	push   $0x0
  80348b:	6a 00                	push   $0x0
  80348d:	50                   	push   %eax
  80348e:	6a 1f                	push   $0x1f
  803490:	e8 40 fc ff ff       	call   8030d5 <syscall>
  803495:	83 c4 18             	add    $0x18,%esp
	return ;
  803498:	90                   	nop
}
  803499:	c9                   	leave  
  80349a:	c3                   	ret    

0080349b <rsttst>:
void rsttst()
{
  80349b:	55                   	push   %ebp
  80349c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80349e:	6a 00                	push   $0x0
  8034a0:	6a 00                	push   $0x0
  8034a2:	6a 00                	push   $0x0
  8034a4:	6a 00                	push   $0x0
  8034a6:	6a 00                	push   $0x0
  8034a8:	6a 21                	push   $0x21
  8034aa:	e8 26 fc ff ff       	call   8030d5 <syscall>
  8034af:	83 c4 18             	add    $0x18,%esp
	return ;
  8034b2:	90                   	nop
}
  8034b3:	c9                   	leave  
  8034b4:	c3                   	ret    

008034b5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8034b5:	55                   	push   %ebp
  8034b6:	89 e5                	mov    %esp,%ebp
  8034b8:	83 ec 04             	sub    $0x4,%esp
  8034bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8034be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8034c1:	8b 55 18             	mov    0x18(%ebp),%edx
  8034c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8034c8:	52                   	push   %edx
  8034c9:	50                   	push   %eax
  8034ca:	ff 75 10             	pushl  0x10(%ebp)
  8034cd:	ff 75 0c             	pushl  0xc(%ebp)
  8034d0:	ff 75 08             	pushl  0x8(%ebp)
  8034d3:	6a 20                	push   $0x20
  8034d5:	e8 fb fb ff ff       	call   8030d5 <syscall>
  8034da:	83 c4 18             	add    $0x18,%esp
	return ;
  8034dd:	90                   	nop
}
  8034de:	c9                   	leave  
  8034df:	c3                   	ret    

008034e0 <chktst>:
void chktst(uint32 n)
{
  8034e0:	55                   	push   %ebp
  8034e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8034e3:	6a 00                	push   $0x0
  8034e5:	6a 00                	push   $0x0
  8034e7:	6a 00                	push   $0x0
  8034e9:	6a 00                	push   $0x0
  8034eb:	ff 75 08             	pushl  0x8(%ebp)
  8034ee:	6a 22                	push   $0x22
  8034f0:	e8 e0 fb ff ff       	call   8030d5 <syscall>
  8034f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8034f8:	90                   	nop
}
  8034f9:	c9                   	leave  
  8034fa:	c3                   	ret    

008034fb <inctst>:

void inctst()
{
  8034fb:	55                   	push   %ebp
  8034fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8034fe:	6a 00                	push   $0x0
  803500:	6a 00                	push   $0x0
  803502:	6a 00                	push   $0x0
  803504:	6a 00                	push   $0x0
  803506:	6a 00                	push   $0x0
  803508:	6a 23                	push   $0x23
  80350a:	e8 c6 fb ff ff       	call   8030d5 <syscall>
  80350f:	83 c4 18             	add    $0x18,%esp
	return ;
  803512:	90                   	nop
}
  803513:	c9                   	leave  
  803514:	c3                   	ret    

00803515 <gettst>:
uint32 gettst()
{
  803515:	55                   	push   %ebp
  803516:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803518:	6a 00                	push   $0x0
  80351a:	6a 00                	push   $0x0
  80351c:	6a 00                	push   $0x0
  80351e:	6a 00                	push   $0x0
  803520:	6a 00                	push   $0x0
  803522:	6a 24                	push   $0x24
  803524:	e8 ac fb ff ff       	call   8030d5 <syscall>
  803529:	83 c4 18             	add    $0x18,%esp
}
  80352c:	c9                   	leave  
  80352d:	c3                   	ret    

0080352e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80352e:	55                   	push   %ebp
  80352f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803531:	6a 00                	push   $0x0
  803533:	6a 00                	push   $0x0
  803535:	6a 00                	push   $0x0
  803537:	6a 00                	push   $0x0
  803539:	6a 00                	push   $0x0
  80353b:	6a 25                	push   $0x25
  80353d:	e8 93 fb ff ff       	call   8030d5 <syscall>
  803542:	83 c4 18             	add    $0x18,%esp
  803545:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  80354a:	a1 80 60 83 00       	mov    0x836080,%eax
}
  80354f:	c9                   	leave  
  803550:	c3                   	ret    

00803551 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803551:	55                   	push   %ebp
  803552:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803554:	8b 45 08             	mov    0x8(%ebp),%eax
  803557:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80355c:	6a 00                	push   $0x0
  80355e:	6a 00                	push   $0x0
  803560:	6a 00                	push   $0x0
  803562:	6a 00                	push   $0x0
  803564:	ff 75 08             	pushl  0x8(%ebp)
  803567:	6a 26                	push   $0x26
  803569:	e8 67 fb ff ff       	call   8030d5 <syscall>
  80356e:	83 c4 18             	add    $0x18,%esp
	return ;
  803571:	90                   	nop
}
  803572:	c9                   	leave  
  803573:	c3                   	ret    

00803574 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803574:	55                   	push   %ebp
  803575:	89 e5                	mov    %esp,%ebp
  803577:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803578:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80357b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80357e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803581:	8b 45 08             	mov    0x8(%ebp),%eax
  803584:	6a 00                	push   $0x0
  803586:	53                   	push   %ebx
  803587:	51                   	push   %ecx
  803588:	52                   	push   %edx
  803589:	50                   	push   %eax
  80358a:	6a 27                	push   $0x27
  80358c:	e8 44 fb ff ff       	call   8030d5 <syscall>
  803591:	83 c4 18             	add    $0x18,%esp
}
  803594:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803597:	c9                   	leave  
  803598:	c3                   	ret    

00803599 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803599:	55                   	push   %ebp
  80359a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80359c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80359f:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a2:	6a 00                	push   $0x0
  8035a4:	6a 00                	push   $0x0
  8035a6:	6a 00                	push   $0x0
  8035a8:	52                   	push   %edx
  8035a9:	50                   	push   %eax
  8035aa:	6a 28                	push   $0x28
  8035ac:	e8 24 fb ff ff       	call   8030d5 <syscall>
  8035b1:	83 c4 18             	add    $0x18,%esp
}
  8035b4:	c9                   	leave  
  8035b5:	c3                   	ret    

008035b6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8035b6:	55                   	push   %ebp
  8035b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8035b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8035bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c2:	6a 00                	push   $0x0
  8035c4:	51                   	push   %ecx
  8035c5:	ff 75 10             	pushl  0x10(%ebp)
  8035c8:	52                   	push   %edx
  8035c9:	50                   	push   %eax
  8035ca:	6a 29                	push   $0x29
  8035cc:	e8 04 fb ff ff       	call   8030d5 <syscall>
  8035d1:	83 c4 18             	add    $0x18,%esp
}
  8035d4:	c9                   	leave  
  8035d5:	c3                   	ret    

008035d6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8035d6:	55                   	push   %ebp
  8035d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8035d9:	6a 00                	push   $0x0
  8035db:	6a 00                	push   $0x0
  8035dd:	ff 75 10             	pushl  0x10(%ebp)
  8035e0:	ff 75 0c             	pushl  0xc(%ebp)
  8035e3:	ff 75 08             	pushl  0x8(%ebp)
  8035e6:	6a 12                	push   $0x12
  8035e8:	e8 e8 fa ff ff       	call   8030d5 <syscall>
  8035ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8035f0:	90                   	nop
}
  8035f1:	c9                   	leave  
  8035f2:	c3                   	ret    

008035f3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8035f3:	55                   	push   %ebp
  8035f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8035f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	6a 00                	push   $0x0
  8035fe:	6a 00                	push   $0x0
  803600:	6a 00                	push   $0x0
  803602:	52                   	push   %edx
  803603:	50                   	push   %eax
  803604:	6a 2a                	push   $0x2a
  803606:	e8 ca fa ff ff       	call   8030d5 <syscall>
  80360b:	83 c4 18             	add    $0x18,%esp
	return;
  80360e:	90                   	nop
}
  80360f:	c9                   	leave  
  803610:	c3                   	ret    

00803611 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803611:	55                   	push   %ebp
  803612:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803614:	6a 00                	push   $0x0
  803616:	6a 00                	push   $0x0
  803618:	6a 00                	push   $0x0
  80361a:	6a 00                	push   $0x0
  80361c:	6a 00                	push   $0x0
  80361e:	6a 2b                	push   $0x2b
  803620:	e8 b0 fa ff ff       	call   8030d5 <syscall>
  803625:	83 c4 18             	add    $0x18,%esp
}
  803628:	c9                   	leave  
  803629:	c3                   	ret    

0080362a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80362a:	55                   	push   %ebp
  80362b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80362d:	6a 00                	push   $0x0
  80362f:	6a 00                	push   $0x0
  803631:	6a 00                	push   $0x0
  803633:	ff 75 0c             	pushl  0xc(%ebp)
  803636:	ff 75 08             	pushl  0x8(%ebp)
  803639:	6a 2d                	push   $0x2d
  80363b:	e8 95 fa ff ff       	call   8030d5 <syscall>
  803640:	83 c4 18             	add    $0x18,%esp
	return;
  803643:	90                   	nop
}
  803644:	c9                   	leave  
  803645:	c3                   	ret    

00803646 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803646:	55                   	push   %ebp
  803647:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803649:	6a 00                	push   $0x0
  80364b:	6a 00                	push   $0x0
  80364d:	6a 00                	push   $0x0
  80364f:	ff 75 0c             	pushl  0xc(%ebp)
  803652:	ff 75 08             	pushl  0x8(%ebp)
  803655:	6a 2c                	push   $0x2c
  803657:	e8 79 fa ff ff       	call   8030d5 <syscall>
  80365c:	83 c4 18             	add    $0x18,%esp
	return ;
  80365f:	90                   	nop
}
  803660:	c9                   	leave  
  803661:	c3                   	ret    

00803662 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803662:	55                   	push   %ebp
  803663:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803665:	8b 55 0c             	mov    0xc(%ebp),%edx
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	6a 00                	push   $0x0
  80366d:	6a 00                	push   $0x0
  80366f:	6a 00                	push   $0x0
  803671:	52                   	push   %edx
  803672:	50                   	push   %eax
  803673:	6a 2e                	push   $0x2e
  803675:	e8 5b fa ff ff       	call   8030d5 <syscall>
  80367a:	83 c4 18             	add    $0x18,%esp
}
  80367d:	90                   	nop
  80367e:	c9                   	leave  
  80367f:	c3                   	ret    

00803680 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803680:	55                   	push   %ebp
  803681:	89 e5                	mov    %esp,%ebp
  803683:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803686:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  80368d:	72 09                	jb     803698 <to_page_va+0x18>
  80368f:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803696:	72 14                	jb     8036ac <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803698:	83 ec 04             	sub    $0x4,%esp
  80369b:	68 58 50 80 00       	push   $0x805058
  8036a0:	6a 15                	push   $0x15
  8036a2:	68 83 50 80 00       	push   $0x805083
  8036a7:	e8 10 d0 ff ff       	call   8006bc <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  8036b4:	29 d0                	sub    %edx,%eax
  8036b6:	c1 f8 02             	sar    $0x2,%eax
  8036b9:	89 c2                	mov    %eax,%edx
  8036bb:	89 d0                	mov    %edx,%eax
  8036bd:	c1 e0 02             	shl    $0x2,%eax
  8036c0:	01 d0                	add    %edx,%eax
  8036c2:	c1 e0 02             	shl    $0x2,%eax
  8036c5:	01 d0                	add    %edx,%eax
  8036c7:	c1 e0 02             	shl    $0x2,%eax
  8036ca:	01 d0                	add    %edx,%eax
  8036cc:	89 c1                	mov    %eax,%ecx
  8036ce:	c1 e1 08             	shl    $0x8,%ecx
  8036d1:	01 c8                	add    %ecx,%eax
  8036d3:	89 c1                	mov    %eax,%ecx
  8036d5:	c1 e1 10             	shl    $0x10,%ecx
  8036d8:	01 c8                	add    %ecx,%eax
  8036da:	01 c0                	add    %eax,%eax
  8036dc:	01 d0                	add    %edx,%eax
  8036de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8036e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e4:	c1 e0 0c             	shl    $0xc,%eax
  8036e7:	89 c2                	mov    %eax,%edx
  8036e9:	a1 84 60 83 00       	mov    0x836084,%eax
  8036ee:	01 d0                	add    %edx,%eax
}
  8036f0:	c9                   	leave  
  8036f1:	c3                   	ret    

008036f2 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8036f2:	55                   	push   %ebp
  8036f3:	89 e5                	mov    %esp,%ebp
  8036f5:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8036f8:	a1 84 60 83 00       	mov    0x836084,%eax
  8036fd:	8b 55 08             	mov    0x8(%ebp),%edx
  803700:	29 c2                	sub    %eax,%edx
  803702:	89 d0                	mov    %edx,%eax
  803704:	c1 e8 0c             	shr    $0xc,%eax
  803707:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80370a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80370e:	78 09                	js     803719 <to_page_info+0x27>
  803710:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803717:	7e 14                	jle    80372d <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803719:	83 ec 04             	sub    $0x4,%esp
  80371c:	68 9c 50 80 00       	push   $0x80509c
  803721:	6a 21                	push   $0x21
  803723:	68 83 50 80 00       	push   $0x805083
  803728:	e8 8f cf ff ff       	call   8006bc <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80372d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803730:	89 d0                	mov    %edx,%eax
  803732:	01 c0                	add    %eax,%eax
  803734:	01 d0                	add    %edx,%eax
  803736:	c1 e0 02             	shl    $0x2,%eax
  803739:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  80373e:	c9                   	leave  
  80373f:	c3                   	ret    

00803740 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803740:	55                   	push   %ebp
  803741:	89 e5                	mov    %esp,%ebp
  803743:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803746:	8b 45 08             	mov    0x8(%ebp),%eax
  803749:	05 00 00 00 02       	add    $0x2000000,%eax
  80374e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803751:	73 16                	jae    803769 <initialize_dynamic_allocator+0x29>
  803753:	68 c0 50 80 00       	push   $0x8050c0
  803758:	68 e6 50 80 00       	push   $0x8050e6
  80375d:	6a 2f                	push   $0x2f
  80375f:	68 83 50 80 00       	push   $0x805083
  803764:	e8 53 cf ff ff       	call   8006bc <_panic>
	dynAllocStart = daStart;
  803769:	8b 45 08             	mov    0x8(%ebp),%eax
  80376c:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  803771:	8b 45 0c             	mov    0xc(%ebp),%eax
  803774:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803780:	eb 36                	jmp    8037b8 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803785:	c1 e0 04             	shl    $0x4,%eax
  803788:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80378d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803796:	c1 e0 04             	shl    $0x4,%eax
  803799:	05 a4 60 83 00       	add    $0x8360a4,%eax
  80379e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a7:	c1 e0 04             	shl    $0x4,%eax
  8037aa:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8037af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8037b5:	ff 45 f4             	incl   -0xc(%ebp)
  8037b8:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8037bc:	7e c4                	jle    803782 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8037be:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  8037c5:	00 00 00 
  8037c8:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  8037cf:	00 00 00 
  8037d2:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  8037d9:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8037dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8037e3:	e9 1b 01 00 00       	jmp    803903 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8037e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037eb:	89 d0                	mov    %edx,%eax
  8037ed:	01 c0                	add    %eax,%eax
  8037ef:	01 d0                	add    %edx,%eax
  8037f1:	c1 e0 02             	shl    $0x2,%eax
  8037f4:	05 88 e0 81 00       	add    $0x81e088,%eax
  8037f9:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8037fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803801:	89 d0                	mov    %edx,%eax
  803803:	01 c0                	add    %eax,%eax
  803805:	01 d0                	add    %edx,%eax
  803807:	c1 e0 02             	shl    $0x2,%eax
  80380a:	05 8a e0 81 00       	add    $0x81e08a,%eax
  80380f:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803814:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803817:	89 d0                	mov    %edx,%eax
  803819:	01 c0                	add    %eax,%eax
  80381b:	01 d0                	add    %edx,%eax
  80381d:	c1 e0 02             	shl    $0x2,%eax
  803820:	05 80 e0 81 00       	add    $0x81e080,%eax
  803825:	8b 00                	mov    (%eax),%eax
  803827:	85 c0                	test   %eax,%eax
  803829:	74 2b                	je     803856 <initialize_dynamic_allocator+0x116>
  80382b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80382e:	89 d0                	mov    %edx,%eax
  803830:	01 c0                	add    %eax,%eax
  803832:	01 d0                	add    %edx,%eax
  803834:	c1 e0 02             	shl    $0x2,%eax
  803837:	05 80 e0 81 00       	add    $0x81e080,%eax
  80383c:	8b 10                	mov    (%eax),%edx
  80383e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803841:	89 c8                	mov    %ecx,%eax
  803843:	01 c0                	add    %eax,%eax
  803845:	01 c8                	add    %ecx,%eax
  803847:	c1 e0 02             	shl    $0x2,%eax
  80384a:	05 84 e0 81 00       	add    $0x81e084,%eax
  80384f:	8b 00                	mov    (%eax),%eax
  803851:	89 42 04             	mov    %eax,0x4(%edx)
  803854:	eb 18                	jmp    80386e <initialize_dynamic_allocator+0x12e>
  803856:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803859:	89 d0                	mov    %edx,%eax
  80385b:	01 c0                	add    %eax,%eax
  80385d:	01 d0                	add    %edx,%eax
  80385f:	c1 e0 02             	shl    $0x2,%eax
  803862:	05 84 e0 81 00       	add    $0x81e084,%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  80386e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803871:	89 d0                	mov    %edx,%eax
  803873:	01 c0                	add    %eax,%eax
  803875:	01 d0                	add    %edx,%eax
  803877:	c1 e0 02             	shl    $0x2,%eax
  80387a:	05 84 e0 81 00       	add    $0x81e084,%eax
  80387f:	8b 00                	mov    (%eax),%eax
  803881:	85 c0                	test   %eax,%eax
  803883:	74 2a                	je     8038af <initialize_dynamic_allocator+0x16f>
  803885:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803888:	89 d0                	mov    %edx,%eax
  80388a:	01 c0                	add    %eax,%eax
  80388c:	01 d0                	add    %edx,%eax
  80388e:	c1 e0 02             	shl    $0x2,%eax
  803891:	05 84 e0 81 00       	add    $0x81e084,%eax
  803896:	8b 10                	mov    (%eax),%edx
  803898:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80389b:	89 c8                	mov    %ecx,%eax
  80389d:	01 c0                	add    %eax,%eax
  80389f:	01 c8                	add    %ecx,%eax
  8038a1:	c1 e0 02             	shl    $0x2,%eax
  8038a4:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038a9:	8b 00                	mov    (%eax),%eax
  8038ab:	89 02                	mov    %eax,(%edx)
  8038ad:	eb 18                	jmp    8038c7 <initialize_dynamic_allocator+0x187>
  8038af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038b2:	89 d0                	mov    %edx,%eax
  8038b4:	01 c0                	add    %eax,%eax
  8038b6:	01 d0                	add    %edx,%eax
  8038b8:	c1 e0 02             	shl    $0x2,%eax
  8038bb:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038c0:	8b 00                	mov    (%eax),%eax
  8038c2:	a3 68 e0 81 00       	mov    %eax,0x81e068
  8038c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038ca:	89 d0                	mov    %edx,%eax
  8038cc:	01 c0                	add    %eax,%eax
  8038ce:	01 d0                	add    %edx,%eax
  8038d0:	c1 e0 02             	shl    $0x2,%eax
  8038d3:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038e1:	89 d0                	mov    %edx,%eax
  8038e3:	01 c0                	add    %eax,%eax
  8038e5:	01 d0                	add    %edx,%eax
  8038e7:	c1 e0 02             	shl    $0x2,%eax
  8038ea:	05 84 e0 81 00       	add    $0x81e084,%eax
  8038ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038f5:	a1 74 e0 81 00       	mov    0x81e074,%eax
  8038fa:	48                   	dec    %eax
  8038fb:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803900:	ff 45 f0             	incl   -0x10(%ebp)
  803903:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  80390a:	0f 8e d8 fe ff ff    	jle    8037e8 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803910:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803917:	e9 9d 00 00 00       	jmp    8039b9 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  80391c:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803922:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803925:	89 c8                	mov    %ecx,%eax
  803927:	01 c0                	add    %eax,%eax
  803929:	01 c8                	add    %ecx,%eax
  80392b:	c1 e0 02             	shl    $0x2,%eax
  80392e:	05 80 e0 81 00       	add    $0x81e080,%eax
  803933:	89 10                	mov    %edx,(%eax)
  803935:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803938:	89 d0                	mov    %edx,%eax
  80393a:	01 c0                	add    %eax,%eax
  80393c:	01 d0                	add    %edx,%eax
  80393e:	c1 e0 02             	shl    $0x2,%eax
  803941:	05 80 e0 81 00       	add    $0x81e080,%eax
  803946:	8b 00                	mov    (%eax),%eax
  803948:	85 c0                	test   %eax,%eax
  80394a:	74 1c                	je     803968 <initialize_dynamic_allocator+0x228>
  80394c:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803952:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803955:	89 c8                	mov    %ecx,%eax
  803957:	01 c0                	add    %eax,%eax
  803959:	01 c8                	add    %ecx,%eax
  80395b:	c1 e0 02             	shl    $0x2,%eax
  80395e:	05 80 e0 81 00       	add    $0x81e080,%eax
  803963:	89 42 04             	mov    %eax,0x4(%edx)
  803966:	eb 16                	jmp    80397e <initialize_dynamic_allocator+0x23e>
  803968:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80396b:	89 d0                	mov    %edx,%eax
  80396d:	01 c0                	add    %eax,%eax
  80396f:	01 d0                	add    %edx,%eax
  803971:	c1 e0 02             	shl    $0x2,%eax
  803974:	05 80 e0 81 00       	add    $0x81e080,%eax
  803979:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  80397e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803981:	89 d0                	mov    %edx,%eax
  803983:	01 c0                	add    %eax,%eax
  803985:	01 d0                	add    %edx,%eax
  803987:	c1 e0 02             	shl    $0x2,%eax
  80398a:	05 80 e0 81 00       	add    $0x81e080,%eax
  80398f:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803994:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803997:	89 d0                	mov    %edx,%eax
  803999:	01 c0                	add    %eax,%eax
  80399b:	01 d0                	add    %edx,%eax
  80399d:	c1 e0 02             	shl    $0x2,%eax
  8039a0:	05 84 e0 81 00       	add    $0x81e084,%eax
  8039a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ab:	a1 74 e0 81 00       	mov    0x81e074,%eax
  8039b0:	40                   	inc    %eax
  8039b1:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8039b6:	ff 4d ec             	decl   -0x14(%ebp)
  8039b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039bd:	0f 89 59 ff ff ff    	jns    80391c <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8039c3:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  8039ca:	00 00 00 
}
  8039cd:	90                   	nop
  8039ce:	c9                   	leave  
  8039cf:	c3                   	ret    

008039d0 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8039d0:	55                   	push   %ebp
  8039d1:	89 e5                	mov    %esp,%ebp
  8039d3:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8039d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d9:	83 ec 0c             	sub    $0xc,%esp
  8039dc:	50                   	push   %eax
  8039dd:	e8 10 fd ff ff       	call   8036f2 <to_page_info>
  8039e2:	83 c4 10             	add    $0x10,%esp
  8039e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8039e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039eb:	8b 40 08             	mov    0x8(%eax),%eax
  8039ee:	0f b7 c0             	movzwl %ax,%eax
}
  8039f1:	c9                   	leave  
  8039f2:	c3                   	ret    

008039f3 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8039f3:	55                   	push   %ebp
  8039f4:	89 e5                	mov    %esp,%ebp
  8039f6:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8039f9:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803a00:	76 16                	jbe    803a18 <alloc_block+0x25>
  803a02:	68 fc 50 80 00       	push   $0x8050fc
  803a07:	68 e6 50 80 00       	push   $0x8050e6
  803a0c:	6a 59                	push   $0x59
  803a0e:	68 83 50 80 00       	push   $0x805083
  803a13:	e8 a4 cc ff ff       	call   8006bc <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803a18:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803a1f:	eb 08                	jmp    803a29 <alloc_block+0x36>
		allocSize <<= 1;
  803a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a24:	01 c0                	add    %eax,%eax
  803a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a2f:	73 09                	jae    803a3a <alloc_block+0x47>
  803a31:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803a38:	76 e7                	jbe    803a21 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803a3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803a41:	eb 03                	jmp    803a46 <alloc_block+0x53>
		listIndex++;
  803a43:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a49:	ba 08 00 00 00       	mov    $0x8,%edx
  803a4e:	88 c1                	mov    %al,%cl
  803a50:	d3 e2                	shl    %cl,%edx
  803a52:	89 d0                	mov    %edx,%eax
  803a54:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803a57:	72 ea                	jb     803a43 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803a5f:	e9 f4 00 00 00       	jmp    803b58 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a67:	c1 e0 04             	shl    $0x4,%eax
  803a6a:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803a6f:	8b 00                	mov    (%eax),%eax
  803a71:	85 c0                	test   %eax,%eax
  803a73:	0f 84 dc 00 00 00    	je     803b55 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a7c:	c1 e0 04             	shl    $0x4,%eax
  803a7f:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803a84:	8b 00                	mov    (%eax),%eax
  803a86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803a89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a8d:	75 14                	jne    803aa3 <alloc_block+0xb0>
  803a8f:	83 ec 04             	sub    $0x4,%esp
  803a92:	68 1d 51 80 00       	push   $0x80511d
  803a97:	6a 6b                	push   $0x6b
  803a99:	68 83 50 80 00       	push   $0x805083
  803a9e:	e8 19 cc ff ff       	call   8006bc <_panic>
  803aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa6:	8b 00                	mov    (%eax),%eax
  803aa8:	85 c0                	test   %eax,%eax
  803aaa:	74 10                	je     803abc <alloc_block+0xc9>
  803aac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aaf:	8b 00                	mov    (%eax),%eax
  803ab1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ab4:	8b 52 04             	mov    0x4(%edx),%edx
  803ab7:	89 50 04             	mov    %edx,0x4(%eax)
  803aba:	eb 14                	jmp    803ad0 <alloc_block+0xdd>
  803abc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abf:	8b 40 04             	mov    0x4(%eax),%eax
  803ac2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ac5:	c1 e2 04             	shl    $0x4,%edx
  803ac8:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803ace:	89 02                	mov    %eax,(%edx)
  803ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad3:	8b 40 04             	mov    0x4(%eax),%eax
  803ad6:	85 c0                	test   %eax,%eax
  803ad8:	74 0f                	je     803ae9 <alloc_block+0xf6>
  803ada:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803add:	8b 40 04             	mov    0x4(%eax),%eax
  803ae0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ae3:	8b 12                	mov    (%edx),%edx
  803ae5:	89 10                	mov    %edx,(%eax)
  803ae7:	eb 13                	jmp    803afc <alloc_block+0x109>
  803ae9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aec:	8b 00                	mov    (%eax),%eax
  803aee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803af1:	c1 e2 04             	shl    $0x4,%edx
  803af4:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803afa:	89 02                	mov    %eax,(%edx)
  803afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b12:	c1 e0 04             	shl    $0x4,%eax
  803b15:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803b1a:	8b 00                	mov    (%eax),%eax
  803b1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b22:	c1 e0 04             	shl    $0x4,%eax
  803b25:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803b2a:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b2f:	83 ec 0c             	sub    $0xc,%esp
  803b32:	50                   	push   %eax
  803b33:	e8 ba fb ff ff       	call   8036f2 <to_page_info>
  803b38:	83 c4 10             	add    $0x10,%esp
  803b3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b41:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b45:	48                   	dec    %eax
  803b46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b49:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b50:	e9 8f 02 00 00       	jmp    803de4 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803b55:	ff 45 ec             	incl   -0x14(%ebp)
  803b58:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803b5c:	0f 8e 02 ff ff ff    	jle    803a64 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803b62:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803b67:	85 c0                	test   %eax,%eax
  803b69:	75 14                	jne    803b7f <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803b6b:	83 ec 04             	sub    $0x4,%esp
  803b6e:	68 3c 51 80 00       	push   $0x80513c
  803b73:	6a 77                	push   $0x77
  803b75:	68 83 50 80 00       	push   $0x805083
  803b7a:	e8 3d cb ff ff       	call   8006bc <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803b7f:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803b84:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803b87:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803b8b:	75 14                	jne    803ba1 <alloc_block+0x1ae>
  803b8d:	83 ec 04             	sub    $0x4,%esp
  803b90:	68 1d 51 80 00       	push   $0x80511d
  803b95:	6a 7a                	push   $0x7a
  803b97:	68 83 50 80 00       	push   $0x805083
  803b9c:	e8 1b cb ff ff       	call   8006bc <_panic>
  803ba1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ba4:	8b 00                	mov    (%eax),%eax
  803ba6:	85 c0                	test   %eax,%eax
  803ba8:	74 10                	je     803bba <alloc_block+0x1c7>
  803baa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bad:	8b 00                	mov    (%eax),%eax
  803baf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bb2:	8b 52 04             	mov    0x4(%edx),%edx
  803bb5:	89 50 04             	mov    %edx,0x4(%eax)
  803bb8:	eb 0b                	jmp    803bc5 <alloc_block+0x1d2>
  803bba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bbd:	8b 40 04             	mov    0x4(%eax),%eax
  803bc0:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803bc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bc8:	8b 40 04             	mov    0x4(%eax),%eax
  803bcb:	85 c0                	test   %eax,%eax
  803bcd:	74 0f                	je     803bde <alloc_block+0x1eb>
  803bcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bd2:	8b 40 04             	mov    0x4(%eax),%eax
  803bd5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bd8:	8b 12                	mov    (%edx),%edx
  803bda:	89 10                	mov    %edx,(%eax)
  803bdc:	eb 0a                	jmp    803be8 <alloc_block+0x1f5>
  803bde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803be1:	8b 00                	mov    (%eax),%eax
  803be3:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803be8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803beb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bf1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bfb:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803c00:	48                   	dec    %eax
  803c01:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803c06:	83 ec 0c             	sub    $0xc,%esp
  803c09:	ff 75 dc             	pushl  -0x24(%ebp)
  803c0c:	e8 6f fa ff ff       	call   803680 <to_page_va>
  803c11:	83 c4 10             	add    $0x10,%esp
  803c14:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803c17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803c1a:	83 ec 0c             	sub    $0xc,%esp
  803c1d:	50                   	push   %eax
  803c1e:	e8 a0 dc ff ff       	call   8018c3 <get_page>
  803c23:	83 c4 10             	add    $0x10,%esp
  803c26:	85 c0                	test   %eax,%eax
  803c28:	74 14                	je     803c3e <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803c2a:	83 ec 04             	sub    $0x4,%esp
  803c2d:	68 64 51 80 00       	push   $0x805164
  803c32:	6a 7f                	push   $0x7f
  803c34:	68 83 50 80 00       	push   $0x805083
  803c39:	e8 7e ca ff ff       	call   8006bc <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c41:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c44:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803c48:	b8 00 10 00 00       	mov    $0x1000,%eax
  803c4d:	ba 00 00 00 00       	mov    $0x0,%edx
  803c52:	f7 75 f4             	divl   -0xc(%ebp)
  803c55:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c58:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803c5c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803c63:	e9 a7 00 00 00       	jmp    803d0f <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803c68:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803c6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6e:	01 d0                	add    %edx,%eax
  803c70:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803c73:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c77:	75 17                	jne    803c90 <alloc_block+0x29d>
  803c79:	83 ec 04             	sub    $0x4,%esp
  803c7c:	68 8c 51 80 00       	push   $0x80518c
  803c81:	68 88 00 00 00       	push   $0x88
  803c86:	68 83 50 80 00       	push   $0x805083
  803c8b:	e8 2c ca ff ff       	call   8006bc <_panic>
  803c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c93:	c1 e0 04             	shl    $0x4,%eax
  803c96:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803c9b:	8b 10                	mov    (%eax),%edx
  803c9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca0:	89 10                	mov    %edx,(%eax)
  803ca2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca5:	8b 00                	mov    (%eax),%eax
  803ca7:	85 c0                	test   %eax,%eax
  803ca9:	74 15                	je     803cc0 <alloc_block+0x2cd>
  803cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cae:	c1 e0 04             	shl    $0x4,%eax
  803cb1:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803cb6:	8b 00                	mov    (%eax),%eax
  803cb8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cbb:	89 50 04             	mov    %edx,0x4(%eax)
  803cbe:	eb 11                	jmp    803cd1 <alloc_block+0x2de>
  803cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cc3:	c1 e0 04             	shl    $0x4,%eax
  803cc6:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803ccc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ccf:	89 02                	mov    %eax,(%edx)
  803cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd4:	c1 e0 04             	shl    $0x4,%eax
  803cd7:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803cdd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce0:	89 02                	mov    %eax,(%edx)
  803ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cef:	c1 e0 04             	shl    $0x4,%eax
  803cf2:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803cf7:	8b 00                	mov    (%eax),%eax
  803cf9:	8d 50 01             	lea    0x1(%eax),%edx
  803cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cff:	c1 e0 04             	shl    $0x4,%eax
  803d02:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803d07:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0c:	01 45 e8             	add    %eax,-0x18(%ebp)
  803d0f:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803d16:	0f 86 4c ff ff ff    	jbe    803c68 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d1f:	c1 e0 04             	shl    $0x4,%eax
  803d22:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803d27:	8b 00                	mov    (%eax),%eax
  803d29:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803d2c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803d30:	75 17                	jne    803d49 <alloc_block+0x356>
  803d32:	83 ec 04             	sub    $0x4,%esp
  803d35:	68 1d 51 80 00       	push   $0x80511d
  803d3a:	68 8d 00 00 00       	push   $0x8d
  803d3f:	68 83 50 80 00       	push   $0x805083
  803d44:	e8 73 c9 ff ff       	call   8006bc <_panic>
  803d49:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d4c:	8b 00                	mov    (%eax),%eax
  803d4e:	85 c0                	test   %eax,%eax
  803d50:	74 10                	je     803d62 <alloc_block+0x36f>
  803d52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d55:	8b 00                	mov    (%eax),%eax
  803d57:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803d5a:	8b 52 04             	mov    0x4(%edx),%edx
  803d5d:	89 50 04             	mov    %edx,0x4(%eax)
  803d60:	eb 14                	jmp    803d76 <alloc_block+0x383>
  803d62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d65:	8b 40 04             	mov    0x4(%eax),%eax
  803d68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d6b:	c1 e2 04             	shl    $0x4,%edx
  803d6e:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803d74:	89 02                	mov    %eax,(%edx)
  803d76:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d79:	8b 40 04             	mov    0x4(%eax),%eax
  803d7c:	85 c0                	test   %eax,%eax
  803d7e:	74 0f                	je     803d8f <alloc_block+0x39c>
  803d80:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d83:	8b 40 04             	mov    0x4(%eax),%eax
  803d86:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803d89:	8b 12                	mov    (%edx),%edx
  803d8b:	89 10                	mov    %edx,(%eax)
  803d8d:	eb 13                	jmp    803da2 <alloc_block+0x3af>
  803d8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d92:	8b 00                	mov    (%eax),%eax
  803d94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d97:	c1 e2 04             	shl    $0x4,%edx
  803d9a:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803da0:	89 02                	mov    %eax,(%edx)
  803da2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803da5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803dae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db8:	c1 e0 04             	shl    $0x4,%eax
  803dbb:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803dc0:	8b 00                	mov    (%eax),%eax
  803dc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  803dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc8:	c1 e0 04             	shl    $0x4,%eax
  803dcb:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803dd0:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803dd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803dd5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803dd9:	48                   	dec    %eax
  803dda:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ddd:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803de1:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803de4:	c9                   	leave  
  803de5:	c3                   	ret    

00803de6 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803de6:	55                   	push   %ebp
  803de7:	89 e5                	mov    %esp,%ebp
  803de9:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803dec:	8b 55 08             	mov    0x8(%ebp),%edx
  803def:	a1 84 60 83 00       	mov    0x836084,%eax
  803df4:	39 c2                	cmp    %eax,%edx
  803df6:	72 0c                	jb     803e04 <free_block+0x1e>
  803df8:	8b 55 08             	mov    0x8(%ebp),%edx
  803dfb:	a1 60 e0 81 00       	mov    0x81e060,%eax
  803e00:	39 c2                	cmp    %eax,%edx
  803e02:	72 19                	jb     803e1d <free_block+0x37>
  803e04:	68 b0 51 80 00       	push   $0x8051b0
  803e09:	68 e6 50 80 00       	push   $0x8050e6
  803e0e:	68 98 00 00 00       	push   $0x98
  803e13:	68 83 50 80 00       	push   $0x805083
  803e18:	e8 9f c8 ff ff       	call   8006bc <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e20:	83 ec 0c             	sub    $0xc,%esp
  803e23:	50                   	push   %eax
  803e24:	e8 c9 f8 ff ff       	call   8036f2 <to_page_info>
  803e29:	83 c4 10             	add    $0x10,%esp
  803e2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e32:	8b 40 08             	mov    0x8(%eax),%eax
  803e35:	0f b7 c0             	movzwl %ax,%eax
  803e38:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803e3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803e42:	eb 03                	jmp    803e47 <free_block+0x61>
		listIndex++;
  803e44:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4a:	ba 08 00 00 00       	mov    $0x8,%edx
  803e4f:	88 c1                	mov    %al,%cl
  803e51:	d3 e2                	shl    %cl,%edx
  803e53:	89 d0                	mov    %edx,%eax
  803e55:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e58:	72 ea                	jb     803e44 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803e60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e64:	75 17                	jne    803e7d <free_block+0x97>
  803e66:	83 ec 04             	sub    $0x4,%esp
  803e69:	68 8c 51 80 00       	push   $0x80518c
  803e6e:	68 a2 00 00 00       	push   $0xa2
  803e73:	68 83 50 80 00       	push   $0x805083
  803e78:	e8 3f c8 ff ff       	call   8006bc <_panic>
  803e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e80:	c1 e0 04             	shl    $0x4,%eax
  803e83:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803e88:	8b 10                	mov    (%eax),%edx
  803e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8d:	89 10                	mov    %edx,(%eax)
  803e8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e92:	8b 00                	mov    (%eax),%eax
  803e94:	85 c0                	test   %eax,%eax
  803e96:	74 15                	je     803ead <free_block+0xc7>
  803e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9b:	c1 e0 04             	shl    $0x4,%eax
  803e9e:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803ea3:	8b 00                	mov    (%eax),%eax
  803ea5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ea8:	89 50 04             	mov    %edx,0x4(%eax)
  803eab:	eb 11                	jmp    803ebe <free_block+0xd8>
  803ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb0:	c1 e0 04             	shl    $0x4,%eax
  803eb3:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ebc:	89 02                	mov    %eax,(%edx)
  803ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec1:	c1 e0 04             	shl    $0x4,%eax
  803ec4:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803eca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ecd:	89 02                	mov    %eax,(%edx)
  803ecf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803edc:	c1 e0 04             	shl    $0x4,%eax
  803edf:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803ee4:	8b 00                	mov    (%eax),%eax
  803ee6:	8d 50 01             	lea    0x1(%eax),%edx
  803ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eec:	c1 e0 04             	shl    $0x4,%eax
  803eef:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803ef4:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ef9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803efd:	40                   	inc    %eax
  803efe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f01:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f08:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803f0c:	0f b7 c8             	movzwl %ax,%ecx
  803f0f:	b8 00 10 00 00       	mov    $0x1000,%eax
  803f14:	ba 00 00 00 00       	mov    $0x0,%edx
  803f19:	f7 75 e8             	divl   -0x18(%ebp)
  803f1c:	39 c1                	cmp    %eax,%ecx
  803f1e:	0f 85 ed 01 00 00    	jne    804111 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f27:	c1 e0 04             	shl    $0x4,%eax
  803f2a:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f2f:	8b 00                	mov    (%eax),%eax
  803f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803f34:	eb 2a                	jmp    803f60 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f39:	83 ec 0c             	sub    $0xc,%esp
  803f3c:	50                   	push   %eax
  803f3d:	e8 b0 f7 ff ff       	call   8036f2 <to_page_info>
  803f42:	83 c4 10             	add    $0x10,%esp
  803f45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803f48:	75 06                	jne    803f50 <free_block+0x16a>
				tmp = b;
  803f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f53:	c1 e0 04             	shl    $0x4,%eax
  803f56:	05 a8 60 83 00       	add    $0x8360a8,%eax
  803f5b:	8b 00                	mov    (%eax),%eax
  803f5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803f60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f64:	74 07                	je     803f6d <free_block+0x187>
  803f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f69:	8b 00                	mov    (%eax),%eax
  803f6b:	eb 05                	jmp    803f72 <free_block+0x18c>
  803f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  803f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f75:	c1 e2 04             	shl    $0x4,%edx
  803f78:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  803f7e:	89 02                	mov    %eax,(%edx)
  803f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f83:	c1 e0 04             	shl    $0x4,%eax
  803f86:	05 a8 60 83 00       	add    $0x8360a8,%eax
  803f8b:	8b 00                	mov    (%eax),%eax
  803f8d:	85 c0                	test   %eax,%eax
  803f8f:	75 a5                	jne    803f36 <free_block+0x150>
  803f91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f95:	75 9f                	jne    803f36 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9a:	c1 e0 04             	shl    $0x4,%eax
  803f9d:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803fa2:	8b 00                	mov    (%eax),%eax
  803fa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803fa7:	e9 cc 00 00 00       	jmp    804078 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803faf:	8b 00                	mov    (%eax),%eax
  803fb1:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb7:	83 ec 0c             	sub    $0xc,%esp
  803fba:	50                   	push   %eax
  803fbb:	e8 32 f7 ff ff       	call   8036f2 <to_page_info>
  803fc0:	83 c4 10             	add    $0x10,%esp
  803fc3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803fc6:	0f 85 a6 00 00 00    	jne    804072 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803fcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803fd0:	75 17                	jne    803fe9 <free_block+0x203>
  803fd2:	83 ec 04             	sub    $0x4,%esp
  803fd5:	68 1d 51 80 00       	push   $0x80511d
  803fda:	68 b5 00 00 00       	push   $0xb5
  803fdf:	68 83 50 80 00       	push   $0x805083
  803fe4:	e8 d3 c6 ff ff       	call   8006bc <_panic>
  803fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fec:	8b 00                	mov    (%eax),%eax
  803fee:	85 c0                	test   %eax,%eax
  803ff0:	74 10                	je     804002 <free_block+0x21c>
  803ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff5:	8b 00                	mov    (%eax),%eax
  803ff7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ffa:	8b 52 04             	mov    0x4(%edx),%edx
  803ffd:	89 50 04             	mov    %edx,0x4(%eax)
  804000:	eb 14                	jmp    804016 <free_block+0x230>
  804002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804005:	8b 40 04             	mov    0x4(%eax),%eax
  804008:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80400b:	c1 e2 04             	shl    $0x4,%edx
  80400e:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804014:	89 02                	mov    %eax,(%edx)
  804016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804019:	8b 40 04             	mov    0x4(%eax),%eax
  80401c:	85 c0                	test   %eax,%eax
  80401e:	74 0f                	je     80402f <free_block+0x249>
  804020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804023:	8b 40 04             	mov    0x4(%eax),%eax
  804026:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804029:	8b 12                	mov    (%edx),%edx
  80402b:	89 10                	mov    %edx,(%eax)
  80402d:	eb 13                	jmp    804042 <free_block+0x25c>
  80402f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804032:	8b 00                	mov    (%eax),%eax
  804034:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804037:	c1 e2 04             	shl    $0x4,%edx
  80403a:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804040:	89 02                	mov    %eax,(%edx)
  804042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804045:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80404b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80404e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804058:	c1 e0 04             	shl    $0x4,%eax
  80405b:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804060:	8b 00                	mov    (%eax),%eax
  804062:	8d 50 ff             	lea    -0x1(%eax),%edx
  804065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804068:	c1 e0 04             	shl    $0x4,%eax
  80406b:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804070:	89 10                	mov    %edx,(%eax)
			b = next;
  804072:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804075:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  804078:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80407c:	0f 85 2a ff ff ff    	jne    803fac <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  804082:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804085:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80408b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80408e:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804094:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804098:	75 17                	jne    8040b1 <free_block+0x2cb>
  80409a:	83 ec 04             	sub    $0x4,%esp
  80409d:	68 8c 51 80 00       	push   $0x80518c
  8040a2:	68 bc 00 00 00       	push   $0xbc
  8040a7:	68 83 50 80 00       	push   $0x805083
  8040ac:	e8 0b c6 ff ff       	call   8006bc <_panic>
  8040b1:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8040b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040ba:	89 10                	mov    %edx,(%eax)
  8040bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040bf:	8b 00                	mov    (%eax),%eax
  8040c1:	85 c0                	test   %eax,%eax
  8040c3:	74 0d                	je     8040d2 <free_block+0x2ec>
  8040c5:	a1 68 e0 81 00       	mov    0x81e068,%eax
  8040ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040cd:	89 50 04             	mov    %edx,0x4(%eax)
  8040d0:	eb 08                	jmp    8040da <free_block+0x2f4>
  8040d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040d5:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8040da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040dd:	a3 68 e0 81 00       	mov    %eax,0x81e068
  8040e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040ec:	a1 74 e0 81 00       	mov    0x81e074,%eax
  8040f1:	40                   	inc    %eax
  8040f2:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  8040f7:	83 ec 0c             	sub    $0xc,%esp
  8040fa:	ff 75 ec             	pushl  -0x14(%ebp)
  8040fd:	e8 7e f5 ff ff       	call   803680 <to_page_va>
  804102:	83 c4 10             	add    $0x10,%esp
  804105:	83 ec 0c             	sub    $0xc,%esp
  804108:	50                   	push   %eax
  804109:	e8 fe d7 ff ff       	call   80190c <return_page>
  80410e:	83 c4 10             	add    $0x10,%esp
	}
}
  804111:	90                   	nop
  804112:	c9                   	leave  
  804113:	c3                   	ret    

00804114 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804114:	55                   	push   %ebp
  804115:	89 e5                	mov    %esp,%ebp
  804117:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80411a:	8b 55 08             	mov    0x8(%ebp),%edx
  80411d:	89 d0                	mov    %edx,%eax
  80411f:	c1 e0 02             	shl    $0x2,%eax
  804122:	01 d0                	add    %edx,%eax
  804124:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80412b:	01 d0                	add    %edx,%eax
  80412d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804134:	01 d0                	add    %edx,%eax
  804136:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80413d:	01 d0                	add    %edx,%eax
  80413f:	c1 e0 04             	shl    $0x4,%eax
  804142:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  804145:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80414c:	0f 31                	rdtsc  
  80414e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804151:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804157:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80415a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80415d:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  804160:	eb 46                	jmp    8041a8 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  804162:	0f 31                	rdtsc  
  804164:	89 45 d0             	mov    %eax,-0x30(%ebp)
  804167:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80416a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80416d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804170:	89 45 e0             	mov    %eax,-0x20(%ebp)
  804173:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804176:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80417c:	29 c2                	sub    %eax,%edx
  80417e:	89 d0                	mov    %edx,%eax
  804180:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804183:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804189:	89 d1                	mov    %edx,%ecx
  80418b:	29 c1                	sub    %eax,%ecx
  80418d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804190:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804193:	39 c2                	cmp    %eax,%edx
  804195:	0f 97 c0             	seta   %al
  804198:	0f b6 c0             	movzbl %al,%eax
  80419b:	29 c1                	sub    %eax,%ecx
  80419d:	89 c8                	mov    %ecx,%eax
  80419f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8041a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8041a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8041a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8041ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8041ae:	72 b2                	jb     804162 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8041b0:	90                   	nop
  8041b1:	c9                   	leave  
  8041b2:	c3                   	ret    

008041b3 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8041b3:	55                   	push   %ebp
  8041b4:	89 e5                	mov    %esp,%ebp
  8041b6:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8041b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8041c0:	eb 03                	jmp    8041c5 <busy_wait+0x12>
  8041c2:	ff 45 fc             	incl   -0x4(%ebp)
  8041c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8041c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8041cb:	72 f5                	jb     8041c2 <busy_wait+0xf>
	return i;
  8041cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8041d0:	c9                   	leave  
  8041d1:	c3                   	ret    
  8041d2:	66 90                	xchg   %ax,%ax

008041d4 <__udivdi3>:
  8041d4:	55                   	push   %ebp
  8041d5:	57                   	push   %edi
  8041d6:	56                   	push   %esi
  8041d7:	53                   	push   %ebx
  8041d8:	83 ec 1c             	sub    $0x1c,%esp
  8041db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8041df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8041e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8041eb:	89 ca                	mov    %ecx,%edx
  8041ed:	89 f8                	mov    %edi,%eax
  8041ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8041f3:	85 f6                	test   %esi,%esi
  8041f5:	75 2d                	jne    804224 <__udivdi3+0x50>
  8041f7:	39 cf                	cmp    %ecx,%edi
  8041f9:	77 65                	ja     804260 <__udivdi3+0x8c>
  8041fb:	89 fd                	mov    %edi,%ebp
  8041fd:	85 ff                	test   %edi,%edi
  8041ff:	75 0b                	jne    80420c <__udivdi3+0x38>
  804201:	b8 01 00 00 00       	mov    $0x1,%eax
  804206:	31 d2                	xor    %edx,%edx
  804208:	f7 f7                	div    %edi
  80420a:	89 c5                	mov    %eax,%ebp
  80420c:	31 d2                	xor    %edx,%edx
  80420e:	89 c8                	mov    %ecx,%eax
  804210:	f7 f5                	div    %ebp
  804212:	89 c1                	mov    %eax,%ecx
  804214:	89 d8                	mov    %ebx,%eax
  804216:	f7 f5                	div    %ebp
  804218:	89 cf                	mov    %ecx,%edi
  80421a:	89 fa                	mov    %edi,%edx
  80421c:	83 c4 1c             	add    $0x1c,%esp
  80421f:	5b                   	pop    %ebx
  804220:	5e                   	pop    %esi
  804221:	5f                   	pop    %edi
  804222:	5d                   	pop    %ebp
  804223:	c3                   	ret    
  804224:	39 ce                	cmp    %ecx,%esi
  804226:	77 28                	ja     804250 <__udivdi3+0x7c>
  804228:	0f bd fe             	bsr    %esi,%edi
  80422b:	83 f7 1f             	xor    $0x1f,%edi
  80422e:	75 40                	jne    804270 <__udivdi3+0x9c>
  804230:	39 ce                	cmp    %ecx,%esi
  804232:	72 0a                	jb     80423e <__udivdi3+0x6a>
  804234:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804238:	0f 87 9e 00 00 00    	ja     8042dc <__udivdi3+0x108>
  80423e:	b8 01 00 00 00       	mov    $0x1,%eax
  804243:	89 fa                	mov    %edi,%edx
  804245:	83 c4 1c             	add    $0x1c,%esp
  804248:	5b                   	pop    %ebx
  804249:	5e                   	pop    %esi
  80424a:	5f                   	pop    %edi
  80424b:	5d                   	pop    %ebp
  80424c:	c3                   	ret    
  80424d:	8d 76 00             	lea    0x0(%esi),%esi
  804250:	31 ff                	xor    %edi,%edi
  804252:	31 c0                	xor    %eax,%eax
  804254:	89 fa                	mov    %edi,%edx
  804256:	83 c4 1c             	add    $0x1c,%esp
  804259:	5b                   	pop    %ebx
  80425a:	5e                   	pop    %esi
  80425b:	5f                   	pop    %edi
  80425c:	5d                   	pop    %ebp
  80425d:	c3                   	ret    
  80425e:	66 90                	xchg   %ax,%ax
  804260:	89 d8                	mov    %ebx,%eax
  804262:	f7 f7                	div    %edi
  804264:	31 ff                	xor    %edi,%edi
  804266:	89 fa                	mov    %edi,%edx
  804268:	83 c4 1c             	add    $0x1c,%esp
  80426b:	5b                   	pop    %ebx
  80426c:	5e                   	pop    %esi
  80426d:	5f                   	pop    %edi
  80426e:	5d                   	pop    %ebp
  80426f:	c3                   	ret    
  804270:	bd 20 00 00 00       	mov    $0x20,%ebp
  804275:	89 eb                	mov    %ebp,%ebx
  804277:	29 fb                	sub    %edi,%ebx
  804279:	89 f9                	mov    %edi,%ecx
  80427b:	d3 e6                	shl    %cl,%esi
  80427d:	89 c5                	mov    %eax,%ebp
  80427f:	88 d9                	mov    %bl,%cl
  804281:	d3 ed                	shr    %cl,%ebp
  804283:	89 e9                	mov    %ebp,%ecx
  804285:	09 f1                	or     %esi,%ecx
  804287:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80428b:	89 f9                	mov    %edi,%ecx
  80428d:	d3 e0                	shl    %cl,%eax
  80428f:	89 c5                	mov    %eax,%ebp
  804291:	89 d6                	mov    %edx,%esi
  804293:	88 d9                	mov    %bl,%cl
  804295:	d3 ee                	shr    %cl,%esi
  804297:	89 f9                	mov    %edi,%ecx
  804299:	d3 e2                	shl    %cl,%edx
  80429b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80429f:	88 d9                	mov    %bl,%cl
  8042a1:	d3 e8                	shr    %cl,%eax
  8042a3:	09 c2                	or     %eax,%edx
  8042a5:	89 d0                	mov    %edx,%eax
  8042a7:	89 f2                	mov    %esi,%edx
  8042a9:	f7 74 24 0c          	divl   0xc(%esp)
  8042ad:	89 d6                	mov    %edx,%esi
  8042af:	89 c3                	mov    %eax,%ebx
  8042b1:	f7 e5                	mul    %ebp
  8042b3:	39 d6                	cmp    %edx,%esi
  8042b5:	72 19                	jb     8042d0 <__udivdi3+0xfc>
  8042b7:	74 0b                	je     8042c4 <__udivdi3+0xf0>
  8042b9:	89 d8                	mov    %ebx,%eax
  8042bb:	31 ff                	xor    %edi,%edi
  8042bd:	e9 58 ff ff ff       	jmp    80421a <__udivdi3+0x46>
  8042c2:	66 90                	xchg   %ax,%ax
  8042c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8042c8:	89 f9                	mov    %edi,%ecx
  8042ca:	d3 e2                	shl    %cl,%edx
  8042cc:	39 c2                	cmp    %eax,%edx
  8042ce:	73 e9                	jae    8042b9 <__udivdi3+0xe5>
  8042d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8042d3:	31 ff                	xor    %edi,%edi
  8042d5:	e9 40 ff ff ff       	jmp    80421a <__udivdi3+0x46>
  8042da:	66 90                	xchg   %ax,%ax
  8042dc:	31 c0                	xor    %eax,%eax
  8042de:	e9 37 ff ff ff       	jmp    80421a <__udivdi3+0x46>
  8042e3:	90                   	nop

008042e4 <__umoddi3>:
  8042e4:	55                   	push   %ebp
  8042e5:	57                   	push   %edi
  8042e6:	56                   	push   %esi
  8042e7:	53                   	push   %ebx
  8042e8:	83 ec 1c             	sub    $0x1c,%esp
  8042eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8042ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8042f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8042fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804303:	89 f3                	mov    %esi,%ebx
  804305:	89 fa                	mov    %edi,%edx
  804307:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80430b:	89 34 24             	mov    %esi,(%esp)
  80430e:	85 c0                	test   %eax,%eax
  804310:	75 1a                	jne    80432c <__umoddi3+0x48>
  804312:	39 f7                	cmp    %esi,%edi
  804314:	0f 86 a2 00 00 00    	jbe    8043bc <__umoddi3+0xd8>
  80431a:	89 c8                	mov    %ecx,%eax
  80431c:	89 f2                	mov    %esi,%edx
  80431e:	f7 f7                	div    %edi
  804320:	89 d0                	mov    %edx,%eax
  804322:	31 d2                	xor    %edx,%edx
  804324:	83 c4 1c             	add    $0x1c,%esp
  804327:	5b                   	pop    %ebx
  804328:	5e                   	pop    %esi
  804329:	5f                   	pop    %edi
  80432a:	5d                   	pop    %ebp
  80432b:	c3                   	ret    
  80432c:	39 f0                	cmp    %esi,%eax
  80432e:	0f 87 ac 00 00 00    	ja     8043e0 <__umoddi3+0xfc>
  804334:	0f bd e8             	bsr    %eax,%ebp
  804337:	83 f5 1f             	xor    $0x1f,%ebp
  80433a:	0f 84 ac 00 00 00    	je     8043ec <__umoddi3+0x108>
  804340:	bf 20 00 00 00       	mov    $0x20,%edi
  804345:	29 ef                	sub    %ebp,%edi
  804347:	89 fe                	mov    %edi,%esi
  804349:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80434d:	89 e9                	mov    %ebp,%ecx
  80434f:	d3 e0                	shl    %cl,%eax
  804351:	89 d7                	mov    %edx,%edi
  804353:	89 f1                	mov    %esi,%ecx
  804355:	d3 ef                	shr    %cl,%edi
  804357:	09 c7                	or     %eax,%edi
  804359:	89 e9                	mov    %ebp,%ecx
  80435b:	d3 e2                	shl    %cl,%edx
  80435d:	89 14 24             	mov    %edx,(%esp)
  804360:	89 d8                	mov    %ebx,%eax
  804362:	d3 e0                	shl    %cl,%eax
  804364:	89 c2                	mov    %eax,%edx
  804366:	8b 44 24 08          	mov    0x8(%esp),%eax
  80436a:	d3 e0                	shl    %cl,%eax
  80436c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804370:	8b 44 24 08          	mov    0x8(%esp),%eax
  804374:	89 f1                	mov    %esi,%ecx
  804376:	d3 e8                	shr    %cl,%eax
  804378:	09 d0                	or     %edx,%eax
  80437a:	d3 eb                	shr    %cl,%ebx
  80437c:	89 da                	mov    %ebx,%edx
  80437e:	f7 f7                	div    %edi
  804380:	89 d3                	mov    %edx,%ebx
  804382:	f7 24 24             	mull   (%esp)
  804385:	89 c6                	mov    %eax,%esi
  804387:	89 d1                	mov    %edx,%ecx
  804389:	39 d3                	cmp    %edx,%ebx
  80438b:	0f 82 87 00 00 00    	jb     804418 <__umoddi3+0x134>
  804391:	0f 84 91 00 00 00    	je     804428 <__umoddi3+0x144>
  804397:	8b 54 24 04          	mov    0x4(%esp),%edx
  80439b:	29 f2                	sub    %esi,%edx
  80439d:	19 cb                	sbb    %ecx,%ebx
  80439f:	89 d8                	mov    %ebx,%eax
  8043a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8043a5:	d3 e0                	shl    %cl,%eax
  8043a7:	89 e9                	mov    %ebp,%ecx
  8043a9:	d3 ea                	shr    %cl,%edx
  8043ab:	09 d0                	or     %edx,%eax
  8043ad:	89 e9                	mov    %ebp,%ecx
  8043af:	d3 eb                	shr    %cl,%ebx
  8043b1:	89 da                	mov    %ebx,%edx
  8043b3:	83 c4 1c             	add    $0x1c,%esp
  8043b6:	5b                   	pop    %ebx
  8043b7:	5e                   	pop    %esi
  8043b8:	5f                   	pop    %edi
  8043b9:	5d                   	pop    %ebp
  8043ba:	c3                   	ret    
  8043bb:	90                   	nop
  8043bc:	89 fd                	mov    %edi,%ebp
  8043be:	85 ff                	test   %edi,%edi
  8043c0:	75 0b                	jne    8043cd <__umoddi3+0xe9>
  8043c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8043c7:	31 d2                	xor    %edx,%edx
  8043c9:	f7 f7                	div    %edi
  8043cb:	89 c5                	mov    %eax,%ebp
  8043cd:	89 f0                	mov    %esi,%eax
  8043cf:	31 d2                	xor    %edx,%edx
  8043d1:	f7 f5                	div    %ebp
  8043d3:	89 c8                	mov    %ecx,%eax
  8043d5:	f7 f5                	div    %ebp
  8043d7:	89 d0                	mov    %edx,%eax
  8043d9:	e9 44 ff ff ff       	jmp    804322 <__umoddi3+0x3e>
  8043de:	66 90                	xchg   %ax,%ax
  8043e0:	89 c8                	mov    %ecx,%eax
  8043e2:	89 f2                	mov    %esi,%edx
  8043e4:	83 c4 1c             	add    $0x1c,%esp
  8043e7:	5b                   	pop    %ebx
  8043e8:	5e                   	pop    %esi
  8043e9:	5f                   	pop    %edi
  8043ea:	5d                   	pop    %ebp
  8043eb:	c3                   	ret    
  8043ec:	3b 04 24             	cmp    (%esp),%eax
  8043ef:	72 06                	jb     8043f7 <__umoddi3+0x113>
  8043f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8043f5:	77 0f                	ja     804406 <__umoddi3+0x122>
  8043f7:	89 f2                	mov    %esi,%edx
  8043f9:	29 f9                	sub    %edi,%ecx
  8043fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8043ff:	89 14 24             	mov    %edx,(%esp)
  804402:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804406:	8b 44 24 04          	mov    0x4(%esp),%eax
  80440a:	8b 14 24             	mov    (%esp),%edx
  80440d:	83 c4 1c             	add    $0x1c,%esp
  804410:	5b                   	pop    %ebx
  804411:	5e                   	pop    %esi
  804412:	5f                   	pop    %edi
  804413:	5d                   	pop    %ebp
  804414:	c3                   	ret    
  804415:	8d 76 00             	lea    0x0(%esi),%esi
  804418:	2b 04 24             	sub    (%esp),%eax
  80441b:	19 fa                	sbb    %edi,%edx
  80441d:	89 d1                	mov    %edx,%ecx
  80441f:	89 c6                	mov    %eax,%esi
  804421:	e9 71 ff ff ff       	jmp    804397 <__umoddi3+0xb3>
  804426:	66 90                	xchg   %ax,%ax
  804428:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80442c:	72 ea                	jb     804418 <__umoddi3+0x134>
  80442e:	89 d9                	mov    %ebx,%ecx
  804430:	e9 62 ff ff ff       	jmp    804397 <__umoddi3+0xb3>
