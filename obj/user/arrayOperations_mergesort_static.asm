
obj/user/arrayOperations_mergesort_static:     file format elf32-i386


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
  800031:	e8 91 04 00 00       	call   8004c7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 60 31 00 00       	call   8031a3 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;

	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	68 c0 43 80 00       	push   $0x8043c0
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	50                   	push   %eax
  800055:	e8 a1 3e 00 00       	call   803efb <get_semaphore>
  80005a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  80005d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 c6 43 80 00       	push   $0x8043c6
  800068:	ff 75 f0             	pushl  -0x10(%ebp)
  80006b:	50                   	push   %eax
  80006c:	e8 8a 3e 00 00       	call   803efb <get_semaphore>
  800071:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	ff 75 dc             	pushl  -0x24(%ebp)
  80007a:	e8 96 3e 00 00       	call   803f15 <wait_semaphore>
  80007f:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 cf 43 80 00       	push   $0x8043cf
  80008a:	ff 75 f0             	pushl  -0x10(%ebp)
  80008d:	e8 4e 21 00 00       	call   8021e0 <sget>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  800098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009b:	8b 10                	mov    (%eax),%edx
  80009d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 e2 43 80 00       	push   $0x8043e2
  8000a8:	52                   	push   %edx
  8000a9:	50                   	push   %eax
  8000aa:	e8 4c 3e 00 00       	call   803efb <get_semaphore>
  8000af:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  8000b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 f0 43 80 00       	push   $0x8043f0
  8000c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000cb:	e8 10 21 00 00       	call   8021e0 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 f4 43 80 00       	push   $0x8043f4
  8000de:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e1:	e8 fa 20 00 00       	call   8021e0 <sget>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  8000ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000ef:	8b 00                	mov    (%eax),%eax
  8000f1:	c1 e0 02             	shl    $0x2,%eax
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	6a 00                	push   $0x0
  8000f9:	50                   	push   %eax
  8000fa:	68 fc 43 80 00       	push   $0x8043fc
  8000ff:	e8 82 1d 00 00       	call   801e86 <smalloc>
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80010a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800111:	eb 25                	jmp    800138 <_main+0x100>
	{
		sortedArray[i] = sharedArray[i];
  800113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800116:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80011d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800120:	01 c2                	add    %eax,%edx
  800122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800125:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80012c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012f:	01 c8                	add    %ecx,%eax
  800131:	8b 00                	mov    (%eax),%eax
  800133:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800135:	ff 45 f4             	incl   -0xc(%ebp)
  800138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013b:	8b 00                	mov    (%eax),%eax
  80013d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800140:	7f d1                	jg     800113 <_main+0xdb>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  800142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800145:	8b 00                	mov    (%eax),%eax
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	50                   	push   %eax
  80014b:	6a 01                	push   $0x1
  80014d:	ff 75 e0             	pushl  -0x20(%ebp)
  800150:	e8 39 01 00 00       	call   80028e <MSort>
  800155:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(cons_mutex);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015e:	e8 b2 3d 00 00       	call   803f15 <wait_semaphore>
  800163:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Merge sort is Finished!!!!\n") ;
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 0b 44 80 00       	push   $0x80440b
  80016e:	e8 e4 05 00 00       	call   800757 <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	68 28 44 80 00       	push   $0x804428
  80017e:	e8 d4 05 00 00       	call   800757 <cprintf>
  800183:	83 c4 10             	add    $0x10,%esp
		cprintf("Merge sort says GOOD BYE :)\n") ;
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 47 44 80 00       	push   $0x804447
  80018e:	e8 c4 05 00 00       	call   800757 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	ff 75 d4             	pushl  -0x2c(%ebp)
  80019c:	e8 8e 3d 00 00       	call   803f2f <signal_semaphore>
  8001a1:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001aa:	e8 80 3d 00 00       	call   803f2f <signal_semaphore>
  8001af:	83 c4 10             	add    $0x10,%esp
}
  8001b2:	90                   	nop
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c8:	01 d0                	add    %edx,%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8001cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dc:	01 c2                	add    %eax,%edx
  8001de:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001eb:	01 c8                	add    %ecx,%eax
  8001ed:	8b 00                	mov    (%eax),%eax
  8001ef:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8001f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fe:	01 c2                	add    %eax,%edx
  800200:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800203:	89 02                	mov    %eax,(%edx)
}
  800205:	90                   	nop
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80020e:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800215:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021c:	eb 42                	jmp    800260 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80021e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800221:	99                   	cltd   
  800222:	f7 7d f0             	idivl  -0x10(%ebp)
  800225:	89 d0                	mov    %edx,%eax
  800227:	85 c0                	test   %eax,%eax
  800229:	75 10                	jne    80023b <PrintElements+0x33>
			cprintf("\n");
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	68 64 44 80 00       	push   $0x804464
  800233:	e8 1f 05 00 00       	call   800757 <cprintf>
  800238:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8b 00                	mov    (%eax),%eax
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	50                   	push   %eax
  800250:	68 66 44 80 00       	push   $0x804466
  800255:	e8 fd 04 00 00       	call   800757 <cprintf>
  80025a:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80025d:	ff 45 f4             	incl   -0xc(%ebp)
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	48                   	dec    %eax
  800264:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800267:	7f b5                	jg     80021e <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800273:	8b 45 08             	mov    0x8(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	50                   	push   %eax
  80027e:	68 6b 44 80 00       	push   $0x80446b
  800283:	e8 cf 04 00 00       	call   800757 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp

}
  80028b:	90                   	nop
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <MSort>:


void MSort(int* A, int p, int r)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	3b 45 10             	cmp    0x10(%ebp),%eax
  80029a:	7d 54                	jge    8002f0 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  80029c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029f:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a2:	01 d0                	add    %edx,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	c1 ea 1f             	shr    $0x1f,%edx
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	d1 f8                	sar    %eax
  8002ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b6:	ff 75 0c             	pushl  0xc(%ebp)
  8002b9:	ff 75 08             	pushl  0x8(%ebp)
  8002bc:	e8 cd ff ff ff       	call   80028e <MSort>
  8002c1:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  8002c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c7:	40                   	inc    %eax
  8002c8:	83 ec 04             	sub    $0x4,%esp
  8002cb:	ff 75 10             	pushl  0x10(%ebp)
  8002ce:	50                   	push   %eax
  8002cf:	ff 75 08             	pushl  0x8(%ebp)
  8002d2:	e8 b7 ff ff ff       	call   80028e <MSort>
  8002d7:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  8002da:	ff 75 10             	pushl  0x10(%ebp)
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	ff 75 0c             	pushl  0xc(%ebp)
  8002e3:	ff 75 08             	pushl  0x8(%ebp)
  8002e6:	e8 08 00 00 00       	call   8002f3 <Merge>
  8002eb:	83 c4 10             	add    $0x10,%esp
  8002ee:	eb 01                	jmp    8002f1 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  8002f0:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  8002f1:	c9                   	leave  
  8002f2:	c3                   	ret    

008002f3 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	83 ec 30             	sub    $0x30,%esp
	int leftCapacity = q - p + 1;
  8002f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8002ff:	40                   	inc    %eax
  800300:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int rightCapacity = r - q;
  800303:	8b 45 14             	mov    0x14(%ebp),%eax
  800306:	2b 45 10             	sub    0x10(%ebp),%eax
  800309:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int leftIndex = 0;
  80030c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int rightIndex = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	//int* Left = malloc(sizeof(int) * leftCapacity);
	int* Left = __Left ;
  80031a:	c7 45 e0 80 d0 81 00 	movl   $0x81d080,-0x20(%ebp)
	int* Right = __Right;
  800321:	c7 45 dc e0 6b 89 00 	movl   $0x896be0,-0x24(%ebp)
	//int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80032f:	eb 2f                	jmp    800360 <Merge+0x6d>
	{
		Left[i] = A[p + i - 1];
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80033e:	01 c2                	add    %eax,%edx
  800340:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80034d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800354:	8b 45 08             	mov    0x8(%ebp),%eax
  800357:	01 c8                	add    %ecx,%eax
  800359:	8b 00                	mov    (%eax),%eax
  80035b:	89 02                	mov    %eax,(%edx)
	int* Left = __Left ;
	int* Right = __Right;
	//int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80035d:	ff 45 f4             	incl   -0xc(%ebp)
  800360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800363:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800366:	7c c9                	jl     800331 <Merge+0x3e>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036f:	eb 2a                	jmp    80039b <Merge+0xa8>
	{
		Right[j] = A[q + j];
  800371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800374:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80037b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80037e:	01 c2                	add    %eax,%edx
  800380:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	8b 00                	mov    (%eax),%eax
  800396:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800398:	ff 45 f0             	incl   -0x10(%ebp)
  80039b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003a1:	7c ce                	jl     800371 <Merge+0x7e>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8003a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8003a9:	e9 0a 01 00 00       	jmp    8004b8 <Merge+0x1c5>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8003b4:	0f 8d 95 00 00 00    	jge    80044f <Merge+0x15c>
  8003ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003bd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003c0:	0f 8d 89 00 00 00    	jge    80044f <Merge+0x15c>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d3:	01 d0                	add    %edx,%eax
  8003d5:	8b 10                	mov    (%eax),%edx
  8003d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003da:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e4:	01 c8                	add    %ecx,%eax
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	39 c2                	cmp    %eax,%edx
  8003ea:	7d 33                	jge    80041f <Merge+0x12c>
			{
				A[k - 1] = Left[leftIndex++];
  8003ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ef:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800401:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800404:	8d 50 01             	lea    0x1(%eax),%edx
  800407:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80040a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800414:	01 d0                	add    %edx,%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80041a:	e9 96 00 00 00       	jmp    8004b5 <Merge+0x1c2>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800427:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800437:	8d 50 01             	lea    0x1(%eax),%edx
  80043a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80043d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800447:	01 d0                	add    %edx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80044d:	eb 66                	jmp    8004b5 <Merge+0x1c2>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  80044f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800452:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800455:	7d 30                	jge    800487 <Merge+0x194>
		{
			A[k - 1] = Left[leftIndex++];
  800457:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80045a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80045f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80046c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80046f:	8d 50 01             	lea    0x1(%eax),%edx
  800472:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800475:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047f:	01 d0                	add    %edx,%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	89 01                	mov    %eax,(%ecx)
  800485:	eb 2e                	jmp    8004b5 <Merge+0x1c2>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80049c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80049f:	8d 50 01             	lea    0x1(%eax),%edx
  8004a2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8004b5:	ff 45 ec             	incl   -0x14(%ebp)
  8004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004bb:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004be:	0f 8e ea fe ff ff    	jle    8003ae <Merge+0xbb>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8004c4:	90                   	nop
  8004c5:	c9                   	leave  
  8004c6:	c3                   	ret    

008004c7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	57                   	push   %edi
  8004cb:	56                   	push   %esi
  8004cc:	53                   	push   %ebx
  8004cd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8004d0:	e8 b5 2c 00 00       	call   80318a <sys_getenvindex>
  8004d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8004d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004db:	89 d0                	mov    %edx,%eax
  8004dd:	c1 e0 03             	shl    $0x3,%eax
  8004e0:	01 d0                	add    %edx,%eax
  8004e2:	c1 e0 02             	shl    $0x2,%eax
  8004e5:	01 d0                	add    %edx,%eax
  8004e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	c1 e0 03             	shl    $0x3,%eax
  8004f3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004f8:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800502:	8a 40 20             	mov    0x20(%eax),%al
  800505:	84 c0                	test   %al,%al
  800507:	74 0d                	je     800516 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800509:	a1 20 50 80 00       	mov    0x805020,%eax
  80050e:	83 c0 20             	add    $0x20,%eax
  800511:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800516:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80051a:	7e 0a                	jle    800526 <libmain+0x5f>
		binaryname = argv[0];
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	ff 75 0c             	pushl  0xc(%ebp)
  80052c:	ff 75 08             	pushl  0x8(%ebp)
  80052f:	e8 04 fb ff ff       	call   800038 <_main>
  800534:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800537:	a1 00 50 80 00       	mov    0x805000,%eax
  80053c:	85 c0                	test   %eax,%eax
  80053e:	0f 84 01 01 00 00    	je     800645 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800544:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80054a:	bb 68 45 80 00       	mov    $0x804568,%ebx
  80054f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800554:	89 c7                	mov    %eax,%edi
  800556:	89 de                	mov    %ebx,%esi
  800558:	89 d1                	mov    %edx,%ecx
  80055a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80055c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80055f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800564:	b0 00                	mov    $0x0,%al
  800566:	89 d7                	mov    %edx,%edi
  800568:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80056a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800571:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	50                   	push   %eax
  800578:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80057e:	50                   	push   %eax
  80057f:	e8 3c 2e 00 00       	call   8033c0 <sys_utilities>
  800584:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800587:	e8 85 29 00 00       	call   802f11 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80058c:	83 ec 0c             	sub    $0xc,%esp
  80058f:	68 88 44 80 00       	push   $0x804488
  800594:	e8 be 01 00 00       	call   800757 <cprintf>
  800599:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80059c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059f:	85 c0                	test   %eax,%eax
  8005a1:	74 18                	je     8005bb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8005a3:	e8 36 2e 00 00       	call   8033de <sys_get_optimal_num_faults>
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	50                   	push   %eax
  8005ac:	68 b0 44 80 00       	push   $0x8044b0
  8005b1:	e8 a1 01 00 00       	call   800757 <cprintf>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	eb 59                	jmp    800614 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c0:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8005c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005cb:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	68 d4 44 80 00       	push   $0x8044d4
  8005db:	e8 77 01 00 00       	call   800757 <cprintf>
  8005e0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e8:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8005ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f3:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8005f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005fe:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800604:	51                   	push   %ecx
  800605:	52                   	push   %edx
  800606:	50                   	push   %eax
  800607:	68 fc 44 80 00       	push   $0x8044fc
  80060c:	e8 46 01 00 00       	call   800757 <cprintf>
  800611:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800614:	a1 20 50 80 00       	mov    0x805020,%eax
  800619:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	50                   	push   %eax
  800623:	68 54 45 80 00       	push   $0x804554
  800628:	e8 2a 01 00 00       	call   800757 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	68 88 44 80 00       	push   $0x804488
  800638:	e8 1a 01 00 00       	call   800757 <cprintf>
  80063d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800640:	e8 e6 28 00 00       	call   802f2b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800645:	e8 1f 00 00 00       	call   800669 <exit>
}
  80064a:	90                   	nop
  80064b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80064e:	5b                   	pop    %ebx
  80064f:	5e                   	pop    %esi
  800650:	5f                   	pop    %edi
  800651:	5d                   	pop    %ebp
  800652:	c3                   	ret    

00800653 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
  800656:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800659:	83 ec 0c             	sub    $0xc,%esp
  80065c:	6a 00                	push   $0x0
  80065e:	e8 f3 2a 00 00       	call   803156 <sys_destroy_env>
  800663:	83 c4 10             	add    $0x10,%esp
}
  800666:	90                   	nop
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <exit>:

void
exit(void)
{
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80066f:	e8 48 2b 00 00       	call   8031bc <sys_exit_env>
}
  800674:	90                   	nop
  800675:	c9                   	leave  
  800676:	c3                   	ret    

00800677 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800677:	55                   	push   %ebp
  800678:	89 e5                	mov    %esp,%ebp
  80067a:	53                   	push   %ebx
  80067b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80067e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	8d 48 01             	lea    0x1(%eax),%ecx
  800686:	8b 55 0c             	mov    0xc(%ebp),%edx
  800689:	89 0a                	mov    %ecx,(%edx)
  80068b:	8b 55 08             	mov    0x8(%ebp),%edx
  80068e:	88 d1                	mov    %dl,%cl
  800690:	8b 55 0c             	mov    0xc(%ebp),%edx
  800693:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a1:	75 30                	jne    8006d3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006a3:	8b 15 64 86 8f 00    	mov    0x8f8664,%edx
  8006a9:	a0 00 eb 87 00       	mov    0x87eb00,%al
  8006ae:	0f b6 c0             	movzbl %al,%eax
  8006b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b4:	8b 09                	mov    (%ecx),%ecx
  8006b6:	89 cb                	mov    %ecx,%ebx
  8006b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006bb:	83 c1 08             	add    $0x8,%ecx
  8006be:	52                   	push   %edx
  8006bf:	50                   	push   %eax
  8006c0:	53                   	push   %ebx
  8006c1:	51                   	push   %ecx
  8006c2:	e8 06 28 00 00       	call   802ecd <sys_cputs>
  8006c7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d6:	8b 40 04             	mov    0x4(%eax),%eax
  8006d9:	8d 50 01             	lea    0x1(%eax),%edx
  8006dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006df:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e2:	90                   	nop
  8006e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e6:	c9                   	leave  
  8006e7:	c3                   	ret    

008006e8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f8:	00 00 00 
	b.cnt = 0;
  8006fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800702:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800705:	ff 75 0c             	pushl  0xc(%ebp)
  800708:	ff 75 08             	pushl  0x8(%ebp)
  80070b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800711:	50                   	push   %eax
  800712:	68 77 06 80 00       	push   $0x800677
  800717:	e8 5a 02 00 00       	call   800976 <vprintfmt>
  80071c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80071f:	8b 15 64 86 8f 00    	mov    0x8f8664,%edx
  800725:	a0 00 eb 87 00       	mov    0x87eb00,%al
  80072a:	0f b6 c0             	movzbl %al,%eax
  80072d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800733:	52                   	push   %edx
  800734:	50                   	push   %eax
  800735:	51                   	push   %ecx
  800736:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80073c:	83 c0 08             	add    $0x8,%eax
  80073f:	50                   	push   %eax
  800740:	e8 88 27 00 00       	call   802ecd <sys_cputs>
  800745:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800748:	c6 05 00 eb 87 00 00 	movb   $0x0,0x87eb00
	return b.cnt;
  80074f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075d:	c6 05 00 eb 87 00 01 	movb   $0x1,0x87eb00
	va_start(ap, fmt);
  800764:	8d 45 0c             	lea    0xc(%ebp),%eax
  800767:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 f4             	pushl  -0xc(%ebp)
  800773:	50                   	push   %eax
  800774:	e8 6f ff ff ff       	call   8006e8 <vcprintf>
  800779:	83 c4 10             	add    $0x10,%esp
  80077c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80077f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800782:	c9                   	leave  
  800783:	c3                   	ret    

00800784 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80078a:	c6 05 00 eb 87 00 01 	movb   $0x1,0x87eb00
	curTextClr = (textClr << 8) ; //set text color by the given value
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	c1 e0 08             	shl    $0x8,%eax
  800797:	a3 64 86 8f 00       	mov    %eax,0x8f8664
	va_start(ap, fmt);
  80079c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079f:	83 c0 04             	add    $0x4,%eax
  8007a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ae:	50                   	push   %eax
  8007af:	e8 34 ff ff ff       	call   8006e8 <vcprintf>
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007ba:	c7 05 64 86 8f 00 00 	movl   $0x700,0x8f8664
  8007c1:	07 00 00 

	return cnt;
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007cf:	e8 3d 27 00 00       	call   802f11 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e3:	50                   	push   %eax
  8007e4:	e8 ff fe ff ff       	call   8006e8 <vcprintf>
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007ef:	e8 37 27 00 00       	call   802f2b <sys_unlock_cons>
	return cnt;
  8007f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f7:	c9                   	leave  
  8007f8:	c3                   	ret    

008007f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 14             	sub    $0x14,%esp
  800800:	8b 45 10             	mov    0x10(%ebp),%eax
  800803:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80080c:	8b 45 18             	mov    0x18(%ebp),%eax
  80080f:	ba 00 00 00 00       	mov    $0x0,%edx
  800814:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800817:	77 55                	ja     80086e <printnum+0x75>
  800819:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081c:	72 05                	jb     800823 <printnum+0x2a>
  80081e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800821:	77 4b                	ja     80086e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800823:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800826:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800829:	8b 45 18             	mov    0x18(%ebp),%eax
  80082c:	ba 00 00 00 00       	mov    $0x0,%edx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	ff 75 f4             	pushl  -0xc(%ebp)
  800836:	ff 75 f0             	pushl  -0x10(%ebp)
  800839:	e8 06 39 00 00       	call   804144 <__udivdi3>
  80083e:	83 c4 10             	add    $0x10,%esp
  800841:	83 ec 04             	sub    $0x4,%esp
  800844:	ff 75 20             	pushl  0x20(%ebp)
  800847:	53                   	push   %ebx
  800848:	ff 75 18             	pushl  0x18(%ebp)
  80084b:	52                   	push   %edx
  80084c:	50                   	push   %eax
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	ff 75 08             	pushl  0x8(%ebp)
  800853:	e8 a1 ff ff ff       	call   8007f9 <printnum>
  800858:	83 c4 20             	add    $0x20,%esp
  80085b:	eb 1a                	jmp    800877 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	ff 75 20             	pushl  0x20(%ebp)
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086e:	ff 4d 1c             	decl   0x1c(%ebp)
  800871:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800875:	7f e6                	jg     80085d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800877:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80087a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80087f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800885:	53                   	push   %ebx
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	e8 c6 39 00 00       	call   804254 <__umoddi3>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	05 f4 47 80 00       	add    $0x8047f4,%eax
  800896:	8a 00                	mov    (%eax),%al
  800898:	0f be c0             	movsbl %al,%eax
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	ff 75 0c             	pushl  0xc(%ebp)
  8008a1:	50                   	push   %eax
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	ff d0                	call   *%eax
  8008a7:	83 c4 10             	add    $0x10,%esp
}
  8008aa:	90                   	nop
  8008ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b7:	7e 1c                	jle    8008d5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	8d 50 08             	lea    0x8(%eax),%edx
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	89 10                	mov    %edx,(%eax)
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	83 e8 08             	sub    $0x8,%eax
  8008ce:	8b 50 04             	mov    0x4(%eax),%edx
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	eb 40                	jmp    800915 <getuint+0x65>
	else if (lflag)
  8008d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d9:	74 1e                	je     8008f9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	8d 50 04             	lea    0x4(%eax),%edx
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	89 10                	mov    %edx,(%eax)
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	83 e8 04             	sub    $0x4,%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f7:	eb 1c                	jmp    800915 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	8d 50 04             	lea    0x4(%eax),%edx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	89 10                	mov    %edx,(%eax)
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	83 e8 04             	sub    $0x4,%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80091a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091e:	7e 1c                	jle    80093c <getint+0x25>
		return va_arg(*ap, long long);
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	8d 50 08             	lea    0x8(%eax),%edx
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	89 10                	mov    %edx,(%eax)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	83 e8 08             	sub    $0x8,%eax
  800935:	8b 50 04             	mov    0x4(%eax),%edx
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	eb 38                	jmp    800974 <getint+0x5d>
	else if (lflag)
  80093c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800940:	74 1a                	je     80095c <getint+0x45>
		return va_arg(*ap, long);
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	8d 50 04             	lea    0x4(%eax),%edx
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	89 10                	mov    %edx,(%eax)
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	83 e8 04             	sub    $0x4,%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	99                   	cltd   
  80095a:	eb 18                	jmp    800974 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	8d 50 04             	lea    0x4(%eax),%edx
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	89 10                	mov    %edx,(%eax)
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 00                	mov    (%eax),%eax
  80096e:	83 e8 04             	sub    $0x4,%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	99                   	cltd   
}
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	56                   	push   %esi
  80097a:	53                   	push   %ebx
  80097b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097e:	eb 17                	jmp    800997 <vprintfmt+0x21>
			if (ch == '\0')
  800980:	85 db                	test   %ebx,%ebx
  800982:	0f 84 c1 03 00 00    	je     800d49 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	53                   	push   %ebx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	ff d0                	call   *%eax
  800994:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800997:	8b 45 10             	mov    0x10(%ebp),%eax
  80099a:	8d 50 01             	lea    0x1(%eax),%edx
  80099d:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a0:	8a 00                	mov    (%eax),%al
  8009a2:	0f b6 d8             	movzbl %al,%ebx
  8009a5:	83 fb 25             	cmp    $0x25,%ebx
  8009a8:	75 d6                	jne    800980 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009aa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cd:	8d 50 01             	lea    0x1(%eax),%edx
  8009d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d3:	8a 00                	mov    (%eax),%al
  8009d5:	0f b6 d8             	movzbl %al,%ebx
  8009d8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009db:	83 f8 5b             	cmp    $0x5b,%eax
  8009de:	0f 87 3d 03 00 00    	ja     800d21 <vprintfmt+0x3ab>
  8009e4:	8b 04 85 18 48 80 00 	mov    0x804818(,%eax,4),%eax
  8009eb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ed:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f1:	eb d7                	jmp    8009ca <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f7:	eb d1                	jmp    8009ca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a03:	89 d0                	mov    %edx,%eax
  800a05:	c1 e0 02             	shl    $0x2,%eax
  800a08:	01 d0                	add    %edx,%eax
  800a0a:	01 c0                	add    %eax,%eax
  800a0c:	01 d8                	add    %ebx,%eax
  800a0e:	83 e8 30             	sub    $0x30,%eax
  800a11:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a14:	8b 45 10             	mov    0x10(%ebp),%eax
  800a17:	8a 00                	mov    (%eax),%al
  800a19:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a1c:	83 fb 2f             	cmp    $0x2f,%ebx
  800a1f:	7e 3e                	jle    800a5f <vprintfmt+0xe9>
  800a21:	83 fb 39             	cmp    $0x39,%ebx
  800a24:	7f 39                	jg     800a5f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a26:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a29:	eb d5                	jmp    800a00 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	83 c0 04             	add    $0x4,%eax
  800a31:	89 45 14             	mov    %eax,0x14(%ebp)
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	83 e8 04             	sub    $0x4,%eax
  800a3a:	8b 00                	mov    (%eax),%eax
  800a3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a3f:	eb 1f                	jmp    800a60 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a45:	79 83                	jns    8009ca <vprintfmt+0x54>
				width = 0;
  800a47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a4e:	e9 77 ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a53:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a5a:	e9 6b ff ff ff       	jmp    8009ca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a5f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a64:	0f 89 60 ff ff ff    	jns    8009ca <vprintfmt+0x54>
				width = precision, precision = -1;
  800a6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a70:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a77:	e9 4e ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a7f:	e9 46 ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a84:	8b 45 14             	mov    0x14(%ebp),%eax
  800a87:	83 c0 04             	add    $0x4,%eax
  800a8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 e8 04             	sub    $0x4,%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	50                   	push   %eax
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	e9 9b 02 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	83 c0 04             	add    $0x4,%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	83 e8 04             	sub    $0x4,%eax
  800ab8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aba:	85 db                	test   %ebx,%ebx
  800abc:	79 02                	jns    800ac0 <vprintfmt+0x14a>
				err = -err;
  800abe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac0:	83 fb 64             	cmp    $0x64,%ebx
  800ac3:	7f 0b                	jg     800ad0 <vprintfmt+0x15a>
  800ac5:	8b 34 9d 60 46 80 00 	mov    0x804660(,%ebx,4),%esi
  800acc:	85 f6                	test   %esi,%esi
  800ace:	75 19                	jne    800ae9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad0:	53                   	push   %ebx
  800ad1:	68 05 48 80 00       	push   $0x804805
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	ff 75 08             	pushl  0x8(%ebp)
  800adc:	e8 70 02 00 00       	call   800d51 <printfmt>
  800ae1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae4:	e9 5b 02 00 00       	jmp    800d44 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae9:	56                   	push   %esi
  800aea:	68 0e 48 80 00       	push   $0x80480e
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 57 02 00 00       	call   800d51 <printfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
			break;
  800afd:	e9 42 02 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	83 c0 04             	add    $0x4,%eax
  800b08:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 e8 04             	sub    $0x4,%eax
  800b11:	8b 30                	mov    (%eax),%esi
  800b13:	85 f6                	test   %esi,%esi
  800b15:	75 05                	jne    800b1c <vprintfmt+0x1a6>
				p = "(null)";
  800b17:	be 11 48 80 00       	mov    $0x804811,%esi
			if (width > 0 && padc != '-')
  800b1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b20:	7e 6d                	jle    800b8f <vprintfmt+0x219>
  800b22:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b26:	74 67                	je     800b8f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	50                   	push   %eax
  800b2f:	56                   	push   %esi
  800b30:	e8 1e 03 00 00       	call   800e53 <strnlen>
  800b35:	83 c4 10             	add    $0x10,%esp
  800b38:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b3b:	eb 16                	jmp    800b53 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b3d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	50                   	push   %eax
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b50:	ff 4d e4             	decl   -0x1c(%ebp)
  800b53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b57:	7f e4                	jg     800b3d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b59:	eb 34                	jmp    800b8f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b5f:	74 1c                	je     800b7d <vprintfmt+0x207>
  800b61:	83 fb 1f             	cmp    $0x1f,%ebx
  800b64:	7e 05                	jle    800b6b <vprintfmt+0x1f5>
  800b66:	83 fb 7e             	cmp    $0x7e,%ebx
  800b69:	7e 12                	jle    800b7d <vprintfmt+0x207>
					putch('?', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	6a 3f                	push   $0x3f
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	ff d0                	call   *%eax
  800b78:	83 c4 10             	add    $0x10,%esp
  800b7b:	eb 0f                	jmp    800b8c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	53                   	push   %ebx
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	ff d0                	call   *%eax
  800b89:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8f:	89 f0                	mov    %esi,%eax
  800b91:	8d 70 01             	lea    0x1(%eax),%esi
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	0f be d8             	movsbl %al,%ebx
  800b99:	85 db                	test   %ebx,%ebx
  800b9b:	74 24                	je     800bc1 <vprintfmt+0x24b>
  800b9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba1:	78 b8                	js     800b5b <vprintfmt+0x1e5>
  800ba3:	ff 4d e0             	decl   -0x20(%ebp)
  800ba6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800baa:	79 af                	jns    800b5b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	eb 13                	jmp    800bc1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	6a 20                	push   $0x20
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	ff d0                	call   *%eax
  800bbb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbe:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc5:	7f e7                	jg     800bae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc7:	e9 78 01 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd5:	50                   	push   %eax
  800bd6:	e8 3c fd ff ff       	call   800917 <getint>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bea:	85 d2                	test   %edx,%edx
  800bec:	79 23                	jns    800c11 <vprintfmt+0x29b>
				putch('-', putdat);
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	6a 2d                	push   $0x2d
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	ff d0                	call   *%eax
  800bfb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c04:	f7 d8                	neg    %eax
  800c06:	83 d2 00             	adc    $0x0,%edx
  800c09:	f7 da                	neg    %edx
  800c0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c11:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c18:	e9 bc 00 00 00       	jmp    800cd9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c1d:	83 ec 08             	sub    $0x8,%esp
  800c20:	ff 75 e8             	pushl  -0x18(%ebp)
  800c23:	8d 45 14             	lea    0x14(%ebp),%eax
  800c26:	50                   	push   %eax
  800c27:	e8 84 fc ff ff       	call   8008b0 <getuint>
  800c2c:	83 c4 10             	add    $0x10,%esp
  800c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3c:	e9 98 00 00 00       	jmp    800cd9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	6a 58                	push   $0x58
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	6a 58                	push   $0x58
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	ff d0                	call   *%eax
  800c5e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	ff 75 0c             	pushl  0xc(%ebp)
  800c67:	6a 58                	push   $0x58
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	ff d0                	call   *%eax
  800c6e:	83 c4 10             	add    $0x10,%esp
			break;
  800c71:	e9 ce 00 00 00       	jmp    800d44 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	6a 30                	push   $0x30
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	ff d0                	call   *%eax
  800c83:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	6a 78                	push   $0x78
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	ff d0                	call   *%eax
  800c93:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c96:	8b 45 14             	mov    0x14(%ebp),%eax
  800c99:	83 c0 04             	add    $0x4,%eax
  800c9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800caa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb8:	eb 1f                	jmp    800cd9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc3:	50                   	push   %eax
  800cc4:	e8 e7 fb ff ff       	call   8008b0 <getuint>
  800cc9:	83 c4 10             	add    $0x10,%esp
  800ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce0:	83 ec 04             	sub    $0x4,%esp
  800ce3:	52                   	push   %edx
  800ce4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce7:	50                   	push   %eax
  800ce8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ceb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	ff 75 08             	pushl  0x8(%ebp)
  800cf4:	e8 00 fb ff ff       	call   8007f9 <printnum>
  800cf9:	83 c4 20             	add    $0x20,%esp
			break;
  800cfc:	eb 46                	jmp    800d44 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cfe:	83 ec 08             	sub    $0x8,%esp
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	53                   	push   %ebx
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			break;
  800d0d:	eb 35                	jmp    800d44 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d0f:	c6 05 00 eb 87 00 00 	movb   $0x0,0x87eb00
			break;
  800d16:	eb 2c                	jmp    800d44 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d18:	c6 05 00 eb 87 00 01 	movb   $0x1,0x87eb00
			break;
  800d1f:	eb 23                	jmp    800d44 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d21:	83 ec 08             	sub    $0x8,%esp
  800d24:	ff 75 0c             	pushl  0xc(%ebp)
  800d27:	6a 25                	push   $0x25
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	ff d0                	call   *%eax
  800d2e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d31:	ff 4d 10             	decl   0x10(%ebp)
  800d34:	eb 03                	jmp    800d39 <vprintfmt+0x3c3>
  800d36:	ff 4d 10             	decl   0x10(%ebp)
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	48                   	dec    %eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	3c 25                	cmp    $0x25,%al
  800d41:	75 f3                	jne    800d36 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d43:	90                   	nop
		}
	}
  800d44:	e9 35 fc ff ff       	jmp    80097e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d49:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d57:	8d 45 10             	lea    0x10(%ebp),%eax
  800d5a:	83 c0 04             	add    $0x4,%eax
  800d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d60:	8b 45 10             	mov    0x10(%ebp),%eax
  800d63:	ff 75 f4             	pushl  -0xc(%ebp)
  800d66:	50                   	push   %eax
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	ff 75 08             	pushl  0x8(%ebp)
  800d6d:	e8 04 fc ff ff       	call   800976 <vprintfmt>
  800d72:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d75:	90                   	nop
  800d76:	c9                   	leave  
  800d77:	c3                   	ret    

00800d78 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8b 40 08             	mov    0x8(%eax),%eax
  800d81:	8d 50 01             	lea    0x1(%eax),%edx
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8b 10                	mov    (%eax),%edx
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8b 40 04             	mov    0x4(%eax),%eax
  800d95:	39 c2                	cmp    %eax,%edx
  800d97:	73 12                	jae    800dab <sprintputch+0x33>
		*b->buf++ = ch;
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8b 00                	mov    (%eax),%eax
  800d9e:	8d 48 01             	lea    0x1(%eax),%ecx
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	89 0a                	mov    %ecx,(%edx)
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	88 10                	mov    %dl,(%eax)
}
  800dab:	90                   	nop
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	01 d0                	add    %edx,%eax
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd3:	74 06                	je     800ddb <vsnprintf+0x2d>
  800dd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd9:	7f 07                	jg     800de2 <vsnprintf+0x34>
		return -E_INVAL;
  800ddb:	b8 03 00 00 00       	mov    $0x3,%eax
  800de0:	eb 20                	jmp    800e02 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de2:	ff 75 14             	pushl  0x14(%ebp)
  800de5:	ff 75 10             	pushl  0x10(%ebp)
  800de8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800deb:	50                   	push   %eax
  800dec:	68 78 0d 80 00       	push   $0x800d78
  800df1:	e8 80 fb ff ff       	call   800976 <vprintfmt>
  800df6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e0a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0d:	83 c0 04             	add    $0x4,%eax
  800e10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e13:	8b 45 10             	mov    0x10(%ebp),%eax
  800e16:	ff 75 f4             	pushl  -0xc(%ebp)
  800e19:	50                   	push   %eax
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 89 ff ff ff       	call   800dae <vsnprintf>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3d:	eb 06                	jmp    800e45 <strlen+0x15>
		n++;
  800e3f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e42:	ff 45 08             	incl   0x8(%ebp)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	84 c0                	test   %al,%al
  800e4c:	75 f1                	jne    800e3f <strlen+0xf>
		n++;
	return n;
  800e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e60:	eb 09                	jmp    800e6b <strnlen+0x18>
		n++;
  800e62:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e65:	ff 45 08             	incl   0x8(%ebp)
  800e68:	ff 4d 0c             	decl   0xc(%ebp)
  800e6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6f:	74 09                	je     800e7a <strnlen+0x27>
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	84 c0                	test   %al,%al
  800e78:	75 e8                	jne    800e62 <strnlen+0xf>
		n++;
	return n;
  800e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e8b:	90                   	nop
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8d 50 01             	lea    0x1(%eax),%edx
  800e92:	89 55 08             	mov    %edx,0x8(%ebp)
  800e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e98:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e9e:	8a 12                	mov    (%edx),%dl
  800ea0:	88 10                	mov    %dl,(%eax)
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	84 c0                	test   %al,%al
  800ea6:	75 e4                	jne    800e8c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec0:	eb 1f                	jmp    800ee1 <strncpy+0x34>
		*dst++ = *src;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8d 50 01             	lea    0x1(%eax),%edx
  800ec8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ece:	8a 12                	mov    (%edx),%dl
  800ed0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	84 c0                	test   %al,%al
  800ed9:	74 03                	je     800ede <strncpy+0x31>
			src++;
  800edb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ede:	ff 45 fc             	incl   -0x4(%ebp)
  800ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee4:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee7:	72 d9                	jb     800ec2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800efa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efe:	74 30                	je     800f30 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f00:	eb 16                	jmp    800f18 <strlcpy+0x2a>
			*dst++ = *src++;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8d 50 01             	lea    0x1(%eax),%edx
  800f08:	89 55 08             	mov    %edx,0x8(%ebp)
  800f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f11:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f14:	8a 12                	mov    (%edx),%dl
  800f16:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1f:	74 09                	je     800f2a <strlcpy+0x3c>
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	84 c0                	test   %al,%al
  800f28:	75 d8                	jne    800f02 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f30:	8b 55 08             	mov    0x8(%ebp),%edx
  800f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f36:	29 c2                	sub    %eax,%edx
  800f38:	89 d0                	mov    %edx,%eax
}
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    

00800f3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f3f:	eb 06                	jmp    800f47 <strcmp+0xb>
		p++, q++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
  800f44:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	84 c0                	test   %al,%al
  800f4e:	74 0e                	je     800f5e <strcmp+0x22>
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 10                	mov    (%eax),%dl
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	38 c2                	cmp    %al,%dl
  800f5c:	74 e3                	je     800f41 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 d0             	movzbl %al,%edx
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	0f b6 c0             	movzbl %al,%eax
  800f6e:	29 c2                	sub    %eax,%edx
  800f70:	89 d0                	mov    %edx,%eax
}
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    

00800f74 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f77:	eb 09                	jmp    800f82 <strncmp+0xe>
		n--, p++, q++;
  800f79:	ff 4d 10             	decl   0x10(%ebp)
  800f7c:	ff 45 08             	incl   0x8(%ebp)
  800f7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f86:	74 17                	je     800f9f <strncmp+0x2b>
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	84 c0                	test   %al,%al
  800f8f:	74 0e                	je     800f9f <strncmp+0x2b>
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 10                	mov    (%eax),%dl
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	38 c2                	cmp    %al,%dl
  800f9d:	74 da                	je     800f79 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	75 07                	jne    800fac <strncmp+0x38>
		return 0;
  800fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800faa:	eb 14                	jmp    800fc0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
}
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 04             	sub    $0x4,%esp
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fce:	eb 12                	jmp    800fe2 <strchr+0x20>
		if (*s == c)
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd8:	75 05                	jne    800fdf <strchr+0x1d>
			return (char *) s;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	eb 11                	jmp    800ff0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	84 c0                	test   %al,%al
  800fe9:	75 e5                	jne    800fd0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800feb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    

00800ff2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 04             	sub    $0x4,%esp
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ffe:	eb 0d                	jmp    80100d <strfind+0x1b>
		if (*s == c)
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801008:	74 0e                	je     801018 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80100a:	ff 45 08             	incl   0x8(%ebp)
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	84 c0                	test   %al,%al
  801014:	75 ea                	jne    801000 <strfind+0xe>
  801016:	eb 01                	jmp    801019 <strfind+0x27>
		if (*s == c)
			break;
  801018:	90                   	nop
	return (char *) s;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101c:	c9                   	leave  
  80101d:	c3                   	ret    

0080101e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80102a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80102e:	76 63                	jbe    801093 <memset+0x75>
		uint64 data_block = c;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	99                   	cltd   
  801034:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801037:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80103a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801044:	c1 e0 08             	shl    $0x8,%eax
  801047:	09 45 f0             	or     %eax,-0x10(%ebp)
  80104a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80104d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801050:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801053:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801057:	c1 e0 10             	shl    $0x10,%eax
  80105a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801066:	89 c2                	mov    %eax,%edx
  801068:	b8 00 00 00 00       	mov    $0x0,%eax
  80106d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801070:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801073:	eb 18                	jmp    80108d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801075:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801078:	8d 41 08             	lea    0x8(%ecx),%eax
  80107b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80107e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801084:	89 01                	mov    %eax,(%ecx)
  801086:	89 51 04             	mov    %edx,0x4(%ecx)
  801089:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80108d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801091:	77 e2                	ja     801075 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801097:	74 23                	je     8010bc <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801099:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80109f:	eb 0e                	jmp    8010af <memset+0x91>
			*p8++ = (uint8)c;
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	8d 50 01             	lea    0x1(%eax),%edx
  8010a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ad:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	75 e5                	jne    8010a1 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010d3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d7:	76 24                	jbe    8010fd <memcpy+0x3c>
		while(n >= 8){
  8010d9:	eb 1c                	jmp    8010f7 <memcpy+0x36>
			*d64 = *s64;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8b 50 04             	mov    0x4(%eax),%edx
  8010e1:	8b 00                	mov    (%eax),%eax
  8010e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e6:	89 01                	mov    %eax,(%ecx)
  8010e8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010eb:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010ef:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010f3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010f7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010fb:	77 de                	ja     8010db <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801101:	74 31                	je     801134 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801106:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801109:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80110f:	eb 16                	jmp    801127 <memcpy+0x66>
			*d8++ = *s8++;
  801111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801114:	8d 50 01             	lea    0x1(%eax),%edx
  801117:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801120:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801123:	8a 12                	mov    (%edx),%dl
  801125:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801127:	8b 45 10             	mov    0x10(%ebp),%eax
  80112a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112d:	89 55 10             	mov    %edx,0x10(%ebp)
  801130:	85 c0                	test   %eax,%eax
  801132:	75 dd                	jne    801111 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80114b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801151:	73 50                	jae    8011a3 <memmove+0x6a>
  801153:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	01 d0                	add    %edx,%eax
  80115b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115e:	76 43                	jbe    8011a3 <memmove+0x6a>
		s += n;
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80116c:	eb 10                	jmp    80117e <memmove+0x45>
			*--d = *--s;
  80116e:	ff 4d f8             	decl   -0x8(%ebp)
  801171:	ff 4d fc             	decl   -0x4(%ebp)
  801174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801177:	8a 10                	mov    (%eax),%dl
  801179:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80117e:	8b 45 10             	mov    0x10(%ebp),%eax
  801181:	8d 50 ff             	lea    -0x1(%eax),%edx
  801184:	89 55 10             	mov    %edx,0x10(%ebp)
  801187:	85 c0                	test   %eax,%eax
  801189:	75 e3                	jne    80116e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80118b:	eb 23                	jmp    8011b0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80118d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801190:	8d 50 01             	lea    0x1(%eax),%edx
  801193:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801196:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801199:	8d 4a 01             	lea    0x1(%edx),%ecx
  80119c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80119f:	8a 12                	mov    (%edx),%dl
  8011a1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	75 dd                	jne    80118d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b3:	c9                   	leave  
  8011b4:	c3                   	ret    

008011b5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011c7:	eb 2a                	jmp    8011f3 <memcmp+0x3e>
		if (*s1 != *s2)
  8011c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011cc:	8a 10                	mov    (%eax),%dl
  8011ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	38 c2                	cmp    %al,%dl
  8011d5:	74 16                	je     8011ed <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	0f b6 d0             	movzbl %al,%edx
  8011df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	0f b6 c0             	movzbl %al,%eax
  8011e7:	29 c2                	sub    %eax,%edx
  8011e9:	89 d0                	mov    %edx,%eax
  8011eb:	eb 18                	jmp    801205 <memcmp+0x50>
		s1++, s2++;
  8011ed:	ff 45 fc             	incl   -0x4(%ebp)
  8011f0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	75 c9                	jne    8011c9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801200:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80120d:	8b 55 08             	mov    0x8(%ebp),%edx
  801210:	8b 45 10             	mov    0x10(%ebp),%eax
  801213:	01 d0                	add    %edx,%eax
  801215:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801218:	eb 15                	jmp    80122f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	0f b6 d0             	movzbl %al,%edx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	0f b6 c0             	movzbl %al,%eax
  801228:	39 c2                	cmp    %eax,%edx
  80122a:	74 0d                	je     801239 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80122c:	ff 45 08             	incl   0x8(%ebp)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801235:	72 e3                	jb     80121a <memfind+0x13>
  801237:	eb 01                	jmp    80123a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801239:	90                   	nop
	return (void *) s;
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80124c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801253:	eb 03                	jmp    801258 <strtol+0x19>
		s++;
  801255:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	3c 20                	cmp    $0x20,%al
  80125f:	74 f4                	je     801255 <strtol+0x16>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 09                	cmp    $0x9,%al
  801268:	74 eb                	je     801255 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	3c 2b                	cmp    $0x2b,%al
  801271:	75 05                	jne    801278 <strtol+0x39>
		s++;
  801273:	ff 45 08             	incl   0x8(%ebp)
  801276:	eb 13                	jmp    80128b <strtol+0x4c>
	else if (*s == '-')
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	3c 2d                	cmp    $0x2d,%al
  80127f:	75 0a                	jne    80128b <strtol+0x4c>
		s++, neg = 1;
  801281:	ff 45 08             	incl   0x8(%ebp)
  801284:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80128b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128f:	74 06                	je     801297 <strtol+0x58>
  801291:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801295:	75 20                	jne    8012b7 <strtol+0x78>
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	3c 30                	cmp    $0x30,%al
  80129e:	75 17                	jne    8012b7 <strtol+0x78>
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	40                   	inc    %eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3c 78                	cmp    $0x78,%al
  8012a8:	75 0d                	jne    8012b7 <strtol+0x78>
		s += 2, base = 16;
  8012aa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012ae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012b5:	eb 28                	jmp    8012df <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012bb:	75 15                	jne    8012d2 <strtol+0x93>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	3c 30                	cmp    $0x30,%al
  8012c4:	75 0c                	jne    8012d2 <strtol+0x93>
		s++, base = 8;
  8012c6:	ff 45 08             	incl   0x8(%ebp)
  8012c9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d0:	eb 0d                	jmp    8012df <strtol+0xa0>
	else if (base == 0)
  8012d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d6:	75 07                	jne    8012df <strtol+0xa0>
		base = 10;
  8012d8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	3c 2f                	cmp    $0x2f,%al
  8012e6:	7e 19                	jle    801301 <strtol+0xc2>
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	3c 39                	cmp    $0x39,%al
  8012ef:	7f 10                	jg     801301 <strtol+0xc2>
			dig = *s - '0';
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	0f be c0             	movsbl %al,%eax
  8012f9:	83 e8 30             	sub    $0x30,%eax
  8012fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ff:	eb 42                	jmp    801343 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	3c 60                	cmp    $0x60,%al
  801308:	7e 19                	jle    801323 <strtol+0xe4>
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	3c 7a                	cmp    $0x7a,%al
  801311:	7f 10                	jg     801323 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	83 e8 57             	sub    $0x57,%eax
  80131e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801321:	eb 20                	jmp    801343 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	3c 40                	cmp    $0x40,%al
  80132a:	7e 39                	jle    801365 <strtol+0x126>
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	3c 5a                	cmp    $0x5a,%al
  801333:	7f 30                	jg     801365 <strtol+0x126>
			dig = *s - 'A' + 10;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	8a 00                	mov    (%eax),%al
  80133a:	0f be c0             	movsbl %al,%eax
  80133d:	83 e8 37             	sub    $0x37,%eax
  801340:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801346:	3b 45 10             	cmp    0x10(%ebp),%eax
  801349:	7d 19                	jge    801364 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80134b:	ff 45 08             	incl   0x8(%ebp)
  80134e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801351:	0f af 45 10          	imul   0x10(%ebp),%eax
  801355:	89 c2                	mov    %eax,%edx
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80135f:	e9 7b ff ff ff       	jmp    8012df <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801364:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801365:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801369:	74 08                	je     801373 <strtol+0x134>
		*endptr = (char *) s;
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	8b 55 08             	mov    0x8(%ebp),%edx
  801371:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801373:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801377:	74 07                	je     801380 <strtol+0x141>
  801379:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137c:	f7 d8                	neg    %eax
  80137e:	eb 03                	jmp    801383 <strtol+0x144>
  801380:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <ltostr>:

void
ltostr(long value, char *str)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80138b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801392:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139d:	79 13                	jns    8013b2 <ltostr+0x2d>
	{
		neg = 1;
  80139f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013ac:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013af:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013ba:	99                   	cltd   
  8013bb:	f7 f9                	idiv   %ecx
  8013bd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8d 50 01             	lea    0x1(%eax),%edx
  8013c6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c9:	89 c2                	mov    %eax,%edx
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	01 d0                	add    %edx,%eax
  8013d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d3:	83 c2 30             	add    $0x30,%edx
  8013d6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e0:	f7 e9                	imul   %ecx
  8013e2:	c1 fa 02             	sar    $0x2,%edx
  8013e5:	89 c8                	mov    %ecx,%eax
  8013e7:	c1 f8 1f             	sar    $0x1f,%eax
  8013ea:	29 c2                	sub    %eax,%edx
  8013ec:	89 d0                	mov    %edx,%eax
  8013ee:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f5:	75 bb                	jne    8013b2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801401:	48                   	dec    %eax
  801402:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801405:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801409:	74 3d                	je     801448 <ltostr+0xc3>
		start = 1 ;
  80140b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801412:	eb 34                	jmp    801448 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801414:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141a:	01 d0                	add    %edx,%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801421:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801424:	8b 45 0c             	mov    0xc(%ebp),%eax
  801427:	01 c2                	add    %eax,%edx
  801429:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80142c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142f:	01 c8                	add    %ecx,%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801435:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143b:	01 c2                	add    %eax,%edx
  80143d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801440:	88 02                	mov    %al,(%edx)
		start++ ;
  801442:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801445:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144e:	7c c4                	jl     801414 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801450:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80145b:	90                   	nop
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801464:	ff 75 08             	pushl  0x8(%ebp)
  801467:	e8 c4 f9 ff ff       	call   800e30 <strlen>
  80146c:	83 c4 04             	add    $0x4,%esp
  80146f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	e8 b6 f9 ff ff       	call   800e30 <strlen>
  80147a:	83 c4 04             	add    $0x4,%esp
  80147d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801480:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801487:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80148e:	eb 17                	jmp    8014a7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801490:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801493:	8b 45 10             	mov    0x10(%ebp),%eax
  801496:	01 c2                	add    %eax,%edx
  801498:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	01 c8                	add    %ecx,%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014a4:	ff 45 fc             	incl   -0x4(%ebp)
  8014a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014ad:	7c e1                	jl     801490 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014bd:	eb 1f                	jmp    8014de <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c2:	8d 50 01             	lea    0x1(%eax),%edx
  8014c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c8:	89 c2                	mov    %eax,%edx
  8014ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cd:	01 c2                	add    %eax,%edx
  8014cf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d5:	01 c8                	add    %ecx,%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014db:	ff 45 f8             	incl   -0x8(%ebp)
  8014de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e4:	7c d9                	jl     8014bf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	01 d0                	add    %edx,%eax
  8014ee:	c6 00 00             	movb   $0x0,(%eax)
}
  8014f1:	90                   	nop
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801500:	8b 45 14             	mov    0x14(%ebp),%eax
  801503:	8b 00                	mov    (%eax),%eax
  801505:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	01 d0                	add    %edx,%eax
  801511:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801517:	eb 0c                	jmp    801525 <strsplit+0x31>
			*string++ = 0;
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8d 50 01             	lea    0x1(%eax),%edx
  80151f:	89 55 08             	mov    %edx,0x8(%ebp)
  801522:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	84 c0                	test   %al,%al
  80152c:	74 18                	je     801546 <strsplit+0x52>
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	0f be c0             	movsbl %al,%eax
  801536:	50                   	push   %eax
  801537:	ff 75 0c             	pushl  0xc(%ebp)
  80153a:	e8 83 fa ff ff       	call   800fc2 <strchr>
  80153f:	83 c4 08             	add    $0x8,%esp
  801542:	85 c0                	test   %eax,%eax
  801544:	75 d3                	jne    801519 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8a 00                	mov    (%eax),%al
  80154b:	84 c0                	test   %al,%al
  80154d:	74 5a                	je     8015a9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80154f:	8b 45 14             	mov    0x14(%ebp),%eax
  801552:	8b 00                	mov    (%eax),%eax
  801554:	83 f8 0f             	cmp    $0xf,%eax
  801557:	75 07                	jne    801560 <strsplit+0x6c>
		{
			return 0;
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	eb 66                	jmp    8015c6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801560:	8b 45 14             	mov    0x14(%ebp),%eax
  801563:	8b 00                	mov    (%eax),%eax
  801565:	8d 48 01             	lea    0x1(%eax),%ecx
  801568:	8b 55 14             	mov    0x14(%ebp),%edx
  80156b:	89 0a                	mov    %ecx,(%edx)
  80156d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801574:	8b 45 10             	mov    0x10(%ebp),%eax
  801577:	01 c2                	add    %eax,%edx
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157e:	eb 03                	jmp    801583 <strsplit+0x8f>
			string++;
  801580:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8a 00                	mov    (%eax),%al
  801588:	84 c0                	test   %al,%al
  80158a:	74 8b                	je     801517 <strsplit+0x23>
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8a 00                	mov    (%eax),%al
  801591:	0f be c0             	movsbl %al,%eax
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	e8 25 fa ff ff       	call   800fc2 <strchr>
  80159d:	83 c4 08             	add    $0x8,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	74 dc                	je     801580 <strsplit+0x8c>
			string++;
	}
  8015a4:	e9 6e ff ff ff       	jmp    801517 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015a9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	8b 00                	mov    (%eax),%eax
  8015af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b9:	01 d0                	add    %edx,%eax
  8015bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015db:	eb 4a                	jmp    801627 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	01 c2                	add    %eax,%edx
  8015e5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	01 c8                	add    %ecx,%eax
  8015ed:	8a 00                	mov    (%eax),%al
  8015ef:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f7:	01 d0                	add    %edx,%eax
  8015f9:	8a 00                	mov    (%eax),%al
  8015fb:	3c 40                	cmp    $0x40,%al
  8015fd:	7e 25                	jle    801624 <str2lower+0x5c>
  8015ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801602:	8b 45 0c             	mov    0xc(%ebp),%eax
  801605:	01 d0                	add    %edx,%eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 5a                	cmp    $0x5a,%al
  80160b:	7f 17                	jg     801624 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80160d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	01 d0                	add    %edx,%eax
  801615:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801618:	8b 55 08             	mov    0x8(%ebp),%edx
  80161b:	01 ca                	add    %ecx,%edx
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	83 c2 20             	add    $0x20,%edx
  801622:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801624:	ff 45 fc             	incl   -0x4(%ebp)
  801627:	ff 75 0c             	pushl  0xc(%ebp)
  80162a:	e8 01 f8 ff ff       	call   800e30 <strlen>
  80162f:	83 c4 04             	add    $0x4,%esp
  801632:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801635:	7f a6                	jg     8015dd <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801637:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801642:	a1 08 50 80 00       	mov    0x805008,%eax
  801647:	85 c0                	test   %eax,%eax
  801649:	74 42                	je     80168d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80164b:	83 ec 08             	sub    $0x8,%esp
  80164e:	68 00 00 00 82       	push   $0x82000000
  801653:	68 00 00 00 80       	push   $0x80000000
  801658:	e8 b0 1e 00 00       	call   80350d <initialize_dynamic_allocator>
  80165d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801660:	e8 96 1c 00 00       	call   8032fb <sys_get_uheap_strategy>
  801665:	a3 20 6b 89 00       	mov    %eax,0x896b20
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80166a:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80166f:	05 00 10 00 00       	add    $0x1000,%eax
  801674:	a3 d0 6b 89 00       	mov    %eax,0x896bd0
		uheapPageAllocBreak = uheapPageAllocStart;
  801679:	a1 d0 6b 89 00       	mov    0x896bd0,%eax
  80167e:	a3 28 6b 89 00       	mov    %eax,0x896b28

		__firstTimeFlag = 0;
  801683:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80168a:	00 00 00 
	}
}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80169c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016a4:	83 ec 08             	sub    $0x8,%esp
  8016a7:	68 06 04 00 00       	push   $0x406
  8016ac:	50                   	push   %eax
  8016ad:	e8 93 18 00 00       	call   802f45 <__sys_allocate_page>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016bc:	79 14                	jns    8016d2 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016be:	83 ec 04             	sub    $0x4,%esp
  8016c1:	68 88 49 80 00       	push   $0x804988
  8016c6:	6a 1f                	push   $0x1f
  8016c8:	68 c4 49 80 00       	push   $0x8049c4
  8016cd:	e8 82 28 00 00       	call   803f54 <_panic>
	return 0;
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016ed:	83 ec 0c             	sub    $0xc,%esp
  8016f0:	50                   	push   %eax
  8016f1:	e8 96 18 00 00       	call   802f8c <__sys_unmap_frame>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801700:	79 14                	jns    801716 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801702:	83 ec 04             	sub    $0x4,%esp
  801705:	68 d0 49 80 00       	push   $0x8049d0
  80170a:	6a 2a                	push   $0x2a
  80170c:	68 c4 49 80 00       	push   $0x8049c4
  801711:	e8 3e 28 00 00       	call   803f54 <_panic>
}
  801716:	90                   	nop
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80171f:	e8 18 ff ff ff       	call   80163c <uheap_init>
	if (size == 0) return NULL ;
  801724:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801728:	75 0a                	jne    801734 <malloc+0x1b>
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
  80172f:	e9 43 03 00 00       	jmp    801a77 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801734:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80173b:	77 13                	ja     801750 <malloc+0x37>
    {
        return alloc_block(size);
  80173d:	83 ec 0c             	sub    $0xc,%esp
  801740:	ff 75 08             	pushl  0x8(%ebp)
  801743:	e8 78 20 00 00       	call   8037c0 <alloc_block>
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	e9 27 03 00 00       	jmp    801a77 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801750:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801757:	8b 55 08             	mov    0x8(%ebp),%edx
  80175a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80175d:	01 d0                	add    %edx,%eax
  80175f:	48                   	dec    %eax
  801760:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801763:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801766:	ba 00 00 00 00       	mov    $0x0,%edx
  80176b:	f7 75 dc             	divl   -0x24(%ebp)
  80176e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801771:	29 d0                	sub    %edx,%eax
  801773:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801776:	a1 40 d0 81 00       	mov    0x81d040,%eax
  80177b:	85 c0                	test   %eax,%eax
  80177d:	75 0a                	jne    801789 <malloc+0x70>
    {
        uhp_inited = 1;
  80177f:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  801786:	00 00 00 
    }

    int exactIdx = -1;
  801789:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801790:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801797:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80179e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8017a5:	e9 85 00 00 00       	jmp    80182f <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8017aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017ad:	89 d0                	mov    %edx,%eax
  8017af:	01 c0                	add    %eax,%eax
  8017b1:	01 d0                	add    %edx,%eax
  8017b3:	c1 e0 02             	shl    $0x2,%eax
  8017b6:	05 48 10 81 00       	add    $0x811048,%eax
  8017bb:	8a 00                	mov    (%eax),%al
  8017bd:	84 c0                	test   %al,%al
  8017bf:	74 20                	je     8017e1 <malloc+0xc8>
  8017c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017c4:	89 d0                	mov    %edx,%eax
  8017c6:	01 c0                	add    %eax,%eax
  8017c8:	01 d0                	add    %edx,%eax
  8017ca:	c1 e0 02             	shl    $0x2,%eax
  8017cd:	05 44 10 81 00       	add    $0x811044,%eax
  8017d2:	8b 00                	mov    (%eax),%eax
  8017d4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017d7:	75 08                	jne    8017e1 <malloc+0xc8>
        {
            exactIdx = i;
  8017d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8017df:	eb 5b                	jmp    80183c <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8017e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017e4:	89 d0                	mov    %edx,%eax
  8017e6:	01 c0                	add    %eax,%eax
  8017e8:	01 d0                	add    %edx,%eax
  8017ea:	c1 e0 02             	shl    $0x2,%eax
  8017ed:	05 48 10 81 00       	add    $0x811048,%eax
  8017f2:	8a 00                	mov    (%eax),%al
  8017f4:	84 c0                	test   %al,%al
  8017f6:	74 34                	je     80182c <malloc+0x113>
  8017f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017fb:	89 d0                	mov    %edx,%eax
  8017fd:	01 c0                	add    %eax,%eax
  8017ff:	01 d0                	add    %edx,%eax
  801801:	c1 e0 02             	shl    $0x2,%eax
  801804:	05 44 10 81 00       	add    $0x811044,%eax
  801809:	8b 00                	mov    (%eax),%eax
  80180b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80180e:	76 1c                	jbe    80182c <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801810:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801813:	89 d0                	mov    %edx,%eax
  801815:	01 c0                	add    %eax,%eax
  801817:	01 d0                	add    %edx,%eax
  801819:	c1 e0 02             	shl    $0x2,%eax
  80181c:	05 44 10 81 00       	add    $0x811044,%eax
  801821:	8b 00                	mov    (%eax),%eax
  801823:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801826:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801829:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80182c:	ff 45 e8             	incl   -0x18(%ebp)
  80182f:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801836:	0f 8e 6e ff ff ff    	jle    8017aa <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  80183c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801843:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801847:	74 7d                	je     8018c6 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801849:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801850:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801853:	89 d0                	mov    %edx,%eax
  801855:	01 c0                	add    %eax,%eax
  801857:	01 d0                	add    %edx,%eax
  801859:	c1 e0 02             	shl    $0x2,%eax
  80185c:	05 40 10 81 00       	add    $0x811040,%eax
  801861:	8b 10                	mov    (%eax),%edx
  801863:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	48                   	dec    %eax
  801869:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80186c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80186f:	ba 00 00 00 00       	mov    $0x0,%edx
  801874:	f7 75 bc             	divl   -0x44(%ebp)
  801877:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80187a:	29 d0                	sub    %edx,%eax
  80187c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80187f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801882:	89 d0                	mov    %edx,%eax
  801884:	01 c0                	add    %eax,%eax
  801886:	01 d0                	add    %edx,%eax
  801888:	c1 e0 02             	shl    $0x2,%eax
  80188b:	05 48 10 81 00       	add    $0x811048,%eax
  801890:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801896:	89 d0                	mov    %edx,%eax
  801898:	01 c0                	add    %eax,%eax
  80189a:	01 d0                	add    %edx,%eax
  80189c:	c1 e0 02             	shl    $0x2,%eax
  80189f:	05 44 10 81 00       	add    $0x811044,%eax
  8018a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8018aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ad:	89 d0                	mov    %edx,%eax
  8018af:	01 c0                	add    %eax,%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	c1 e0 02             	shl    $0x2,%eax
  8018b6:	05 40 10 81 00       	add    $0x811040,%eax
  8018bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018c1:	e9 2d 01 00 00       	jmp    8019f3 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8018c6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018ca:	0f 84 ce 00 00 00    	je     80199e <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8018d0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8018d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018da:	89 d0                	mov    %edx,%eax
  8018dc:	01 c0                	add    %eax,%eax
  8018de:	01 d0                	add    %edx,%eax
  8018e0:	c1 e0 02             	shl    $0x2,%eax
  8018e3:	05 40 10 81 00       	add    $0x811040,%eax
  8018e8:	8b 10                	mov    (%eax),%edx
  8018ea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018ed:	01 d0                	add    %edx,%eax
  8018ef:	48                   	dec    %eax
  8018f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8018f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fb:	f7 75 c4             	divl   -0x3c(%ebp)
  8018fe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801901:	29 d0                	sub    %edx,%eax
  801903:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801906:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801909:	89 d0                	mov    %edx,%eax
  80190b:	01 c0                	add    %eax,%eax
  80190d:	01 d0                	add    %edx,%eax
  80190f:	c1 e0 02             	shl    $0x2,%eax
  801912:	05 44 10 81 00       	add    $0x811044,%eax
  801917:	8b 00                	mov    (%eax),%eax
  801919:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80191c:	75 47                	jne    801965 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  80191e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801921:	89 d0                	mov    %edx,%eax
  801923:	01 c0                	add    %eax,%eax
  801925:	01 d0                	add    %edx,%eax
  801927:	c1 e0 02             	shl    $0x2,%eax
  80192a:	05 48 10 81 00       	add    $0x811048,%eax
  80192f:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801932:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801935:	89 d0                	mov    %edx,%eax
  801937:	01 c0                	add    %eax,%eax
  801939:	01 d0                	add    %edx,%eax
  80193b:	c1 e0 02             	shl    $0x2,%eax
  80193e:	05 44 10 81 00       	add    $0x811044,%eax
  801943:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801949:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80194c:	89 d0                	mov    %edx,%eax
  80194e:	01 c0                	add    %eax,%eax
  801950:	01 d0                	add    %edx,%eax
  801952:	c1 e0 02             	shl    $0x2,%eax
  801955:	05 40 10 81 00       	add    $0x811040,%eax
  80195a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801960:	e9 8e 00 00 00       	jmp    8019f3 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801965:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801968:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80196b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80196e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801971:	89 d0                	mov    %edx,%eax
  801973:	01 c0                	add    %eax,%eax
  801975:	01 d0                	add    %edx,%eax
  801977:	c1 e0 02             	shl    $0x2,%eax
  80197a:	05 40 10 81 00       	add    $0x811040,%eax
  80197f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801981:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801984:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801987:	89 c2                	mov    %eax,%edx
  801989:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80198c:	89 c8                	mov    %ecx,%eax
  80198e:	01 c0                	add    %eax,%eax
  801990:	01 c8                	add    %ecx,%eax
  801992:	c1 e0 02             	shl    $0x2,%eax
  801995:	05 44 10 81 00       	add    $0x811044,%eax
  80199a:	89 10                	mov    %edx,(%eax)
  80199c:	eb 55                	jmp    8019f3 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80199e:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8019a5:	8b 15 28 6b 89 00    	mov    0x896b28,%edx
  8019ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019ae:	01 d0                	add    %edx,%eax
  8019b0:	48                   	dec    %eax
  8019b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8019b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019bc:	f7 75 d0             	divl   -0x30(%ebp)
  8019bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019c2:	29 d0                	sub    %edx,%eax
  8019c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8019c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8019d4:	76 0a                	jbe    8019e0 <malloc+0x2c7>
            return NULL;
  8019d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019db:	e9 97 00 00 00       	jmp    801a77 <malloc+0x35e>
        va = start;
  8019e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8019e6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8019e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019ec:	01 d0                	add    %edx,%eax
  8019ee:	a3 28 6b 89 00       	mov    %eax,0x896b28
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8019f3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019fa:	eb 5e                	jmp    801a5a <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8019fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019ff:	89 d0                	mov    %edx,%eax
  801a01:	01 c0                	add    %eax,%eax
  801a03:	01 d0                	add    %edx,%eax
  801a05:	c1 e0 02             	shl    $0x2,%eax
  801a08:	05 48 50 80 00       	add    $0x805048,%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	84 c0                	test   %al,%al
  801a11:	75 44                	jne    801a57 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801a13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a16:	89 d0                	mov    %edx,%eax
  801a18:	01 c0                	add    %eax,%eax
  801a1a:	01 d0                	add    %edx,%eax
  801a1c:	c1 e0 02             	shl    $0x2,%eax
  801a1f:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a28:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801a2a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a2d:	89 d0                	mov    %edx,%eax
  801a2f:	01 c0                	add    %eax,%eax
  801a31:	01 d0                	add    %edx,%eax
  801a33:	c1 e0 02             	shl    $0x2,%eax
  801a36:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801a3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a3f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801a41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a44:	89 d0                	mov    %edx,%eax
  801a46:	01 c0                	add    %eax,%eax
  801a48:	01 d0                	add    %edx,%eax
  801a4a:	c1 e0 02             	shl    $0x2,%eax
  801a4d:	05 48 50 80 00       	add    $0x805048,%eax
  801a52:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801a55:	eb 0c                	jmp    801a63 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a57:	ff 45 e0             	incl   -0x20(%ebp)
  801a5a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a61:	7e 99                	jle    8019fc <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801a63:	83 ec 08             	sub    $0x8,%esp
  801a66:	ff 75 d4             	pushl  -0x2c(%ebp)
  801a69:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a6c:	e8 a2 19 00 00       	call   803413 <sys_allocate_user_mem>
  801a71:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801a74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a83:	0f 84 fa 03 00 00    	je     801e83 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801a8f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a92:	85 c0                	test   %eax,%eax
  801a94:	79 1c                	jns    801ab2 <free+0x39>
  801a96:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801a9d:	77 13                	ja     801ab2 <free+0x39>
    {
        free_block(virtual_address);
  801a9f:	83 ec 0c             	sub    $0xc,%esp
  801aa2:	ff 75 08             	pushl  0x8(%ebp)
  801aa5:	e8 09 21 00 00       	call   803bb3 <free_block>
  801aaa:	83 c4 10             	add    $0x10,%esp
        return;
  801aad:	e9 d2 03 00 00       	jmp    801e84 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801ab2:	a1 d0 6b 89 00       	mov    0x896bd0,%eax
  801ab7:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801aba:	72 09                	jb     801ac5 <free+0x4c>
  801abc:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801ac3:	76 17                	jbe    801adc <free+0x63>
        panic("free: invalid address");
  801ac5:	83 ec 04             	sub    $0x4,%esp
  801ac8:	68 0d 4a 80 00       	push   $0x804a0d
  801acd:	68 9b 00 00 00       	push   $0x9b
  801ad2:	68 c4 49 80 00       	push   $0x8049c4
  801ad7:	e8 78 24 00 00       	call   803f54 <_panic>

    uint32 size = 0;
  801adc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801ae3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801aea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801af1:	eb 50                	jmp    801b43 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801af3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801af6:	89 d0                	mov    %edx,%eax
  801af8:	01 c0                	add    %eax,%eax
  801afa:	01 d0                	add    %edx,%eax
  801afc:	c1 e0 02             	shl    $0x2,%eax
  801aff:	05 48 50 80 00       	add    $0x805048,%eax
  801b04:	8a 00                	mov    (%eax),%al
  801b06:	84 c0                	test   %al,%al
  801b08:	74 36                	je     801b40 <free+0xc7>
  801b0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b0d:	89 d0                	mov    %edx,%eax
  801b0f:	01 c0                	add    %eax,%eax
  801b11:	01 d0                	add    %edx,%eax
  801b13:	c1 e0 02             	shl    $0x2,%eax
  801b16:	05 40 50 80 00       	add    $0x805040,%eax
  801b1b:	8b 00                	mov    (%eax),%eax
  801b1d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b20:	75 1e                	jne    801b40 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801b22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b25:	89 d0                	mov    %edx,%eax
  801b27:	01 c0                	add    %eax,%eax
  801b29:	01 d0                	add    %edx,%eax
  801b2b:	c1 e0 02             	shl    $0x2,%eax
  801b2e:	05 44 50 80 00       	add    $0x805044,%eax
  801b33:	8b 00                	mov    (%eax),%eax
  801b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801b3e:	eb 0c                	jmp    801b4c <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b40:	ff 45 ec             	incl   -0x14(%ebp)
  801b43:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801b4a:	7e a7                	jle    801af3 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801b4c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b50:	74 06                	je     801b58 <free+0xdf>
  801b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b56:	75 17                	jne    801b6f <free+0xf6>
        panic("free: unknown block");
  801b58:	83 ec 04             	sub    $0x4,%esp
  801b5b:	68 23 4a 80 00       	push   $0x804a23
  801b60:	68 a9 00 00 00       	push   $0xa9
  801b65:	68 c4 49 80 00       	push   $0x8049c4
  801b6a:	e8 e5 23 00 00       	call   803f54 <_panic>

    uhp_allocs[idx].used = 0;
  801b6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b72:	89 d0                	mov    %edx,%eax
  801b74:	01 c0                	add    %eax,%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	c1 e0 02             	shl    $0x2,%eax
  801b7b:	05 48 50 80 00       	add    $0x805048,%eax
  801b80:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801b83:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b8a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b91:	eb 64                	jmp    801bf7 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801b93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b96:	89 d0                	mov    %edx,%eax
  801b98:	01 c0                	add    %eax,%eax
  801b9a:	01 d0                	add    %edx,%eax
  801b9c:	c1 e0 02             	shl    $0x2,%eax
  801b9f:	05 48 10 81 00       	add    $0x811048,%eax
  801ba4:	8a 00                	mov    (%eax),%al
  801ba6:	84 c0                	test   %al,%al
  801ba8:	75 4a                	jne    801bf4 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801baa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bad:	89 d0                	mov    %edx,%eax
  801baf:	01 c0                	add    %eax,%eax
  801bb1:	01 d0                	add    %edx,%eax
  801bb3:	c1 e0 02             	shl    $0x2,%eax
  801bb6:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801bbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bbf:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801bc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bc4:	89 d0                	mov    %edx,%eax
  801bc6:	01 c0                	add    %eax,%eax
  801bc8:	01 d0                	add    %edx,%eax
  801bca:	c1 e0 02             	shl    $0x2,%eax
  801bcd:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd6:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801bd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bdb:	89 d0                	mov    %edx,%eax
  801bdd:	01 c0                	add    %eax,%eax
  801bdf:	01 d0                	add    %edx,%eax
  801be1:	c1 e0 02             	shl    $0x2,%eax
  801be4:	05 48 10 81 00       	add    $0x811048,%eax
  801be9:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bef:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801bf2:	eb 0c                	jmp    801c00 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bf4:	ff 45 e4             	incl   -0x1c(%ebp)
  801bf7:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801bfe:	7e 93                	jle    801b93 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801c00:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801c04:	0f 84 f1 01 00 00    	je     801dfb <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c11:	e9 d8 01 00 00       	jmp    801dee <free+0x375>
        {
            if (i == fidx) continue;
  801c16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c19:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c1c:	0f 84 c8 01 00 00    	je     801dea <free+0x371>
            if (uhp_frees[i].free)
  801c22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c25:	89 d0                	mov    %edx,%eax
  801c27:	01 c0                	add    %eax,%eax
  801c29:	01 d0                	add    %edx,%eax
  801c2b:	c1 e0 02             	shl    $0x2,%eax
  801c2e:	05 48 10 81 00       	add    $0x811048,%eax
  801c33:	8a 00                	mov    (%eax),%al
  801c35:	84 c0                	test   %al,%al
  801c37:	0f 84 ae 01 00 00    	je     801deb <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801c3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c40:	89 d0                	mov    %edx,%eax
  801c42:	01 c0                	add    %eax,%eax
  801c44:	01 d0                	add    %edx,%eax
  801c46:	c1 e0 02             	shl    $0x2,%eax
  801c49:	05 40 10 81 00       	add    $0x811040,%eax
  801c4e:	8b 08                	mov    (%eax),%ecx
  801c50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c53:	89 d0                	mov    %edx,%eax
  801c55:	01 c0                	add    %eax,%eax
  801c57:	01 d0                	add    %edx,%eax
  801c59:	c1 e0 02             	shl    $0x2,%eax
  801c5c:	05 44 10 81 00       	add    $0x811044,%eax
  801c61:	8b 00                	mov    (%eax),%eax
  801c63:	01 c1                	add    %eax,%ecx
  801c65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c68:	89 d0                	mov    %edx,%eax
  801c6a:	01 c0                	add    %eax,%eax
  801c6c:	01 d0                	add    %edx,%eax
  801c6e:	c1 e0 02             	shl    $0x2,%eax
  801c71:	05 40 10 81 00       	add    $0x811040,%eax
  801c76:	8b 00                	mov    (%eax),%eax
  801c78:	39 c1                	cmp    %eax,%ecx
  801c7a:	0f 85 a8 00 00 00    	jne    801d28 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801c80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c83:	89 d0                	mov    %edx,%eax
  801c85:	01 c0                	add    %eax,%eax
  801c87:	01 d0                	add    %edx,%eax
  801c89:	c1 e0 02             	shl    $0x2,%eax
  801c8c:	05 40 10 81 00       	add    $0x811040,%eax
  801c91:	8b 10                	mov    (%eax),%edx
  801c93:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801c96:	89 c8                	mov    %ecx,%eax
  801c98:	01 c0                	add    %eax,%eax
  801c9a:	01 c8                	add    %ecx,%eax
  801c9c:	c1 e0 02             	shl    $0x2,%eax
  801c9f:	05 40 10 81 00       	add    $0x811040,%eax
  801ca4:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801ca6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ca9:	89 d0                	mov    %edx,%eax
  801cab:	01 c0                	add    %eax,%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c1 e0 02             	shl    $0x2,%eax
  801cb2:	05 44 10 81 00       	add    $0x811044,%eax
  801cb7:	8b 08                	mov    (%eax),%ecx
  801cb9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cbc:	89 d0                	mov    %edx,%eax
  801cbe:	01 c0                	add    %eax,%eax
  801cc0:	01 d0                	add    %edx,%eax
  801cc2:	c1 e0 02             	shl    $0x2,%eax
  801cc5:	05 44 10 81 00       	add    $0x811044,%eax
  801cca:	8b 00                	mov    (%eax),%eax
  801ccc:	01 c1                	add    %eax,%ecx
  801cce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cd1:	89 d0                	mov    %edx,%eax
  801cd3:	01 c0                	add    %eax,%eax
  801cd5:	01 d0                	add    %edx,%eax
  801cd7:	c1 e0 02             	shl    $0x2,%eax
  801cda:	05 44 10 81 00       	add    $0x811044,%eax
  801cdf:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801ce1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ce4:	89 d0                	mov    %edx,%eax
  801ce6:	01 c0                	add    %eax,%eax
  801ce8:	01 d0                	add    %edx,%eax
  801cea:	c1 e0 02             	shl    $0x2,%eax
  801ced:	05 48 10 81 00       	add    $0x811048,%eax
  801cf2:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801cf5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cf8:	89 d0                	mov    %edx,%eax
  801cfa:	01 c0                	add    %eax,%eax
  801cfc:	01 d0                	add    %edx,%eax
  801cfe:	c1 e0 02             	shl    $0x2,%eax
  801d01:	05 40 10 81 00       	add    $0x811040,%eax
  801d06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801d0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d0f:	89 d0                	mov    %edx,%eax
  801d11:	01 c0                	add    %eax,%eax
  801d13:	01 d0                	add    %edx,%eax
  801d15:	c1 e0 02             	shl    $0x2,%eax
  801d18:	05 44 10 81 00       	add    $0x811044,%eax
  801d1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d23:	e9 c3 00 00 00       	jmp    801deb <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801d28:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d2b:	89 d0                	mov    %edx,%eax
  801d2d:	01 c0                	add    %eax,%eax
  801d2f:	01 d0                	add    %edx,%eax
  801d31:	c1 e0 02             	shl    $0x2,%eax
  801d34:	05 40 10 81 00       	add    $0x811040,%eax
  801d39:	8b 08                	mov    (%eax),%ecx
  801d3b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d3e:	89 d0                	mov    %edx,%eax
  801d40:	01 c0                	add    %eax,%eax
  801d42:	01 d0                	add    %edx,%eax
  801d44:	c1 e0 02             	shl    $0x2,%eax
  801d47:	05 44 10 81 00       	add    $0x811044,%eax
  801d4c:	8b 00                	mov    (%eax),%eax
  801d4e:	01 c1                	add    %eax,%ecx
  801d50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d53:	89 d0                	mov    %edx,%eax
  801d55:	01 c0                	add    %eax,%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	c1 e0 02             	shl    $0x2,%eax
  801d5c:	05 40 10 81 00       	add    $0x811040,%eax
  801d61:	8b 00                	mov    (%eax),%eax
  801d63:	39 c1                	cmp    %eax,%ecx
  801d65:	0f 85 80 00 00 00    	jne    801deb <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801d6b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d6e:	89 d0                	mov    %edx,%eax
  801d70:	01 c0                	add    %eax,%eax
  801d72:	01 d0                	add    %edx,%eax
  801d74:	c1 e0 02             	shl    $0x2,%eax
  801d77:	05 44 10 81 00       	add    $0x811044,%eax
  801d7c:	8b 08                	mov    (%eax),%ecx
  801d7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d81:	89 d0                	mov    %edx,%eax
  801d83:	01 c0                	add    %eax,%eax
  801d85:	01 d0                	add    %edx,%eax
  801d87:	c1 e0 02             	shl    $0x2,%eax
  801d8a:	05 44 10 81 00       	add    $0x811044,%eax
  801d8f:	8b 00                	mov    (%eax),%eax
  801d91:	01 c1                	add    %eax,%ecx
  801d93:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d96:	89 d0                	mov    %edx,%eax
  801d98:	01 c0                	add    %eax,%eax
  801d9a:	01 d0                	add    %edx,%eax
  801d9c:	c1 e0 02             	shl    $0x2,%eax
  801d9f:	05 44 10 81 00       	add    $0x811044,%eax
  801da4:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801da6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801da9:	89 d0                	mov    %edx,%eax
  801dab:	01 c0                	add    %eax,%eax
  801dad:	01 d0                	add    %edx,%eax
  801daf:	c1 e0 02             	shl    $0x2,%eax
  801db2:	05 48 10 81 00       	add    $0x811048,%eax
  801db7:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801dba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dbd:	89 d0                	mov    %edx,%eax
  801dbf:	01 c0                	add    %eax,%eax
  801dc1:	01 d0                	add    %edx,%eax
  801dc3:	c1 e0 02             	shl    $0x2,%eax
  801dc6:	05 40 10 81 00       	add    $0x811040,%eax
  801dcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801dd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dd4:	89 d0                	mov    %edx,%eax
  801dd6:	01 c0                	add    %eax,%eax
  801dd8:	01 d0                	add    %edx,%eax
  801dda:	c1 e0 02             	shl    $0x2,%eax
  801ddd:	05 44 10 81 00       	add    $0x811044,%eax
  801de2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801de8:	eb 01                	jmp    801deb <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801dea:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801deb:	ff 45 e0             	incl   -0x20(%ebp)
  801dee:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801df5:	0f 8e 1b fe ff ff    	jle    801c16 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801dfb:	a1 d0 6b 89 00       	mov    0x896bd0,%eax
  801e00:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e03:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801e0a:	eb 53                	jmp    801e5f <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801e0c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e0f:	89 d0                	mov    %edx,%eax
  801e11:	01 c0                	add    %eax,%eax
  801e13:	01 d0                	add    %edx,%eax
  801e15:	c1 e0 02             	shl    $0x2,%eax
  801e18:	05 48 50 80 00       	add    $0x805048,%eax
  801e1d:	8a 00                	mov    (%eax),%al
  801e1f:	84 c0                	test   %al,%al
  801e21:	74 39                	je     801e5c <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801e23:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e26:	89 d0                	mov    %edx,%eax
  801e28:	01 c0                	add    %eax,%eax
  801e2a:	01 d0                	add    %edx,%eax
  801e2c:	c1 e0 02             	shl    $0x2,%eax
  801e2f:	05 40 50 80 00       	add    $0x805040,%eax
  801e34:	8b 08                	mov    (%eax),%ecx
  801e36:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e39:	89 d0                	mov    %edx,%eax
  801e3b:	01 c0                	add    %eax,%eax
  801e3d:	01 d0                	add    %edx,%eax
  801e3f:	c1 e0 02             	shl    $0x2,%eax
  801e42:	05 44 50 80 00       	add    $0x805044,%eax
  801e47:	8b 00                	mov    (%eax),%eax
  801e49:	01 c8                	add    %ecx,%eax
  801e4b:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801e4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e51:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e54:	76 06                	jbe    801e5c <free+0x3e3>
  801e56:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e59:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e5c:	ff 45 d8             	incl   -0x28(%ebp)
  801e5f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801e66:	7e a4                	jle    801e0c <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801e68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e6b:	a3 28 6b 89 00       	mov    %eax,0x896b28

    sys_free_user_mem(va, size);
  801e70:	83 ec 08             	sub    $0x8,%esp
  801e73:	ff 75 f4             	pushl  -0xc(%ebp)
  801e76:	ff 75 d4             	pushl  -0x2c(%ebp)
  801e79:	e8 79 15 00 00       	call   8033f7 <sys_free_user_mem>
  801e7e:	83 c4 10             	add    $0x10,%esp
  801e81:	eb 01                	jmp    801e84 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801e83:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 68             	sub    $0x68,%esp
  801e8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8f:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e92:	e8 a5 f7 ff ff       	call   80163c <uheap_init>
	if (size == 0) return NULL ;
  801e97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e9b:	75 0a                	jne    801ea7 <smalloc+0x21>
  801e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea2:	e9 37 03 00 00       	jmp    8021de <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801ea7:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb4:	01 d0                	add    %edx,%eax
  801eb6:	48                   	dec    %eax
  801eb7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801eba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ebd:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec2:	f7 75 dc             	divl   -0x24(%ebp)
  801ec5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ec8:	29 d0                	sub    %edx,%eax
  801eca:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801ecd:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801ed4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801edb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ee2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ee9:	e9 85 00 00 00       	jmp    801f73 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801eee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ef1:	89 d0                	mov    %edx,%eax
  801ef3:	01 c0                	add    %eax,%eax
  801ef5:	01 d0                	add    %edx,%eax
  801ef7:	c1 e0 02             	shl    $0x2,%eax
  801efa:	05 48 10 81 00       	add    $0x811048,%eax
  801eff:	8a 00                	mov    (%eax),%al
  801f01:	84 c0                	test   %al,%al
  801f03:	74 20                	je     801f25 <smalloc+0x9f>
  801f05:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f08:	89 d0                	mov    %edx,%eax
  801f0a:	01 c0                	add    %eax,%eax
  801f0c:	01 d0                	add    %edx,%eax
  801f0e:	c1 e0 02             	shl    $0x2,%eax
  801f11:	05 44 10 81 00       	add    $0x811044,%eax
  801f16:	8b 00                	mov    (%eax),%eax
  801f18:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f1b:	75 08                	jne    801f25 <smalloc+0x9f>
        {
            exactIdx = i;
  801f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801f23:	eb 5b                	jmp    801f80 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801f25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f28:	89 d0                	mov    %edx,%eax
  801f2a:	01 c0                	add    %eax,%eax
  801f2c:	01 d0                	add    %edx,%eax
  801f2e:	c1 e0 02             	shl    $0x2,%eax
  801f31:	05 48 10 81 00       	add    $0x811048,%eax
  801f36:	8a 00                	mov    (%eax),%al
  801f38:	84 c0                	test   %al,%al
  801f3a:	74 34                	je     801f70 <smalloc+0xea>
  801f3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f3f:	89 d0                	mov    %edx,%eax
  801f41:	01 c0                	add    %eax,%eax
  801f43:	01 d0                	add    %edx,%eax
  801f45:	c1 e0 02             	shl    $0x2,%eax
  801f48:	05 44 10 81 00       	add    $0x811044,%eax
  801f4d:	8b 00                	mov    (%eax),%eax
  801f4f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f52:	76 1c                	jbe    801f70 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801f54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f57:	89 d0                	mov    %edx,%eax
  801f59:	01 c0                	add    %eax,%eax
  801f5b:	01 d0                	add    %edx,%eax
  801f5d:	c1 e0 02             	shl    $0x2,%eax
  801f60:	05 44 10 81 00       	add    $0x811044,%eax
  801f65:	8b 00                	mov    (%eax),%eax
  801f67:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801f6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f70:	ff 45 e8             	incl   -0x18(%ebp)
  801f73:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801f7a:	0f 8e 6e ff ff ff    	jle    801eee <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801f80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801f87:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801f8b:	74 7d                	je     80200a <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801f8d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f97:	89 d0                	mov    %edx,%eax
  801f99:	01 c0                	add    %eax,%eax
  801f9b:	01 d0                	add    %edx,%eax
  801f9d:	c1 e0 02             	shl    $0x2,%eax
  801fa0:	05 40 10 81 00       	add    $0x811040,%eax
  801fa5:	8b 10                	mov    (%eax),%edx
  801fa7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801faa:	01 d0                	add    %edx,%eax
  801fac:	48                   	dec    %eax
  801fad:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801fb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fb3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb8:	f7 75 bc             	divl   -0x44(%ebp)
  801fbb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801fbe:	29 d0                	sub    %edx,%eax
  801fc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc6:	89 d0                	mov    %edx,%eax
  801fc8:	01 c0                	add    %eax,%eax
  801fca:	01 d0                	add    %edx,%eax
  801fcc:	c1 e0 02             	shl    $0x2,%eax
  801fcf:	05 48 10 81 00       	add    $0x811048,%eax
  801fd4:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801fd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fda:	89 d0                	mov    %edx,%eax
  801fdc:	01 c0                	add    %eax,%eax
  801fde:	01 d0                	add    %edx,%eax
  801fe0:	c1 e0 02             	shl    $0x2,%eax
  801fe3:	05 44 10 81 00       	add    $0x811044,%eax
  801fe8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801fee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff1:	89 d0                	mov    %edx,%eax
  801ff3:	01 c0                	add    %eax,%eax
  801ff5:	01 d0                	add    %edx,%eax
  801ff7:	c1 e0 02             	shl    $0x2,%eax
  801ffa:	05 40 10 81 00       	add    $0x811040,%eax
  801fff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802005:	e9 2d 01 00 00       	jmp    802137 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  80200a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80200e:	0f 84 ce 00 00 00    	je     8020e2 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802014:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80201b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80201e:	89 d0                	mov    %edx,%eax
  802020:	01 c0                	add    %eax,%eax
  802022:	01 d0                	add    %edx,%eax
  802024:	c1 e0 02             	shl    $0x2,%eax
  802027:	05 40 10 81 00       	add    $0x811040,%eax
  80202c:	8b 10                	mov    (%eax),%edx
  80202e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802031:	01 d0                	add    %edx,%eax
  802033:	48                   	dec    %eax
  802034:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802037:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80203a:	ba 00 00 00 00       	mov    $0x0,%edx
  80203f:	f7 75 c4             	divl   -0x3c(%ebp)
  802042:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802045:	29 d0                	sub    %edx,%eax
  802047:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80204a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80204d:	89 d0                	mov    %edx,%eax
  80204f:	01 c0                	add    %eax,%eax
  802051:	01 d0                	add    %edx,%eax
  802053:	c1 e0 02             	shl    $0x2,%eax
  802056:	05 44 10 81 00       	add    $0x811044,%eax
  80205b:	8b 00                	mov    (%eax),%eax
  80205d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802060:	75 47                	jne    8020a9 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802062:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802065:	89 d0                	mov    %edx,%eax
  802067:	01 c0                	add    %eax,%eax
  802069:	01 d0                	add    %edx,%eax
  80206b:	c1 e0 02             	shl    $0x2,%eax
  80206e:	05 48 10 81 00       	add    $0x811048,%eax
  802073:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802076:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802079:	89 d0                	mov    %edx,%eax
  80207b:	01 c0                	add    %eax,%eax
  80207d:	01 d0                	add    %edx,%eax
  80207f:	c1 e0 02             	shl    $0x2,%eax
  802082:	05 44 10 81 00       	add    $0x811044,%eax
  802087:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80208d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802090:	89 d0                	mov    %edx,%eax
  802092:	01 c0                	add    %eax,%eax
  802094:	01 d0                	add    %edx,%eax
  802096:	c1 e0 02             	shl    $0x2,%eax
  802099:	05 40 10 81 00       	add    $0x811040,%eax
  80209e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020a4:	e9 8e 00 00 00       	jmp    802137 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8020a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020af:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8020b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020b5:	89 d0                	mov    %edx,%eax
  8020b7:	01 c0                	add    %eax,%eax
  8020b9:	01 d0                	add    %edx,%eax
  8020bb:	c1 e0 02             	shl    $0x2,%eax
  8020be:	05 40 10 81 00       	add    $0x811040,%eax
  8020c3:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8020c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c8:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020cb:	89 c2                	mov    %eax,%edx
  8020cd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020d0:	89 c8                	mov    %ecx,%eax
  8020d2:	01 c0                	add    %eax,%eax
  8020d4:	01 c8                	add    %ecx,%eax
  8020d6:	c1 e0 02             	shl    $0x2,%eax
  8020d9:	05 44 10 81 00       	add    $0x811044,%eax
  8020de:	89 10                	mov    %edx,(%eax)
  8020e0:	eb 55                	jmp    802137 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8020e2:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8020e9:	8b 15 28 6b 89 00    	mov    0x896b28,%edx
  8020ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8020f2:	01 d0                	add    %edx,%eax
  8020f4:	48                   	dec    %eax
  8020f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8020f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802100:	f7 75 d0             	divl   -0x30(%ebp)
  802103:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802106:	29 d0                	sub    %edx,%eax
  802108:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80210b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80210e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802111:	01 d0                	add    %edx,%eax
  802113:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802118:	76 0a                	jbe    802124 <smalloc+0x29e>
            return NULL;
  80211a:	b8 00 00 00 00       	mov    $0x0,%eax
  80211f:	e9 ba 00 00 00       	jmp    8021de <smalloc+0x358>
        va = start;
  802124:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802127:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80212a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80212d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802130:	01 d0                	add    %edx,%eax
  802132:	a3 28 6b 89 00       	mov    %eax,0x896b28
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802137:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80213e:	eb 5e                	jmp    80219e <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802140:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802143:	89 d0                	mov    %edx,%eax
  802145:	01 c0                	add    %eax,%eax
  802147:	01 d0                	add    %edx,%eax
  802149:	c1 e0 02             	shl    $0x2,%eax
  80214c:	05 48 50 80 00       	add    $0x805048,%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	84 c0                	test   %al,%al
  802155:	75 44                	jne    80219b <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802157:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80215a:	89 d0                	mov    %edx,%eax
  80215c:	01 c0                	add    %eax,%eax
  80215e:	01 d0                	add    %edx,%eax
  802160:	c1 e0 02             	shl    $0x2,%eax
  802163:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80216c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80216e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802171:	89 d0                	mov    %edx,%eax
  802173:	01 c0                	add    %eax,%eax
  802175:	01 d0                	add    %edx,%eax
  802177:	c1 e0 02             	shl    $0x2,%eax
  80217a:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802180:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802183:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802185:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802188:	89 d0                	mov    %edx,%eax
  80218a:	01 c0                	add    %eax,%eax
  80218c:	01 d0                	add    %edx,%eax
  80218e:	c1 e0 02             	shl    $0x2,%eax
  802191:	05 48 50 80 00       	add    $0x805048,%eax
  802196:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802199:	eb 0c                	jmp    8021a7 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80219b:	ff 45 e0             	incl   -0x20(%ebp)
  80219e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8021a5:	7e 99                	jle    802140 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8021a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021aa:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8021ae:	52                   	push   %edx
  8021af:	50                   	push   %eax
  8021b0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8021b3:	ff 75 08             	pushl  0x8(%ebp)
  8021b6:	e8 de 0e 00 00       	call   803099 <sys_create_shared_object>
  8021bb:	83 c4 10             	add    $0x10,%esp
  8021be:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8021c1:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8021c5:	75 07                	jne    8021ce <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8021c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021cc:	eb 10                	jmp    8021de <smalloc+0x358>
    if (r < 0)
  8021ce:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8021d2:	79 07                	jns    8021db <smalloc+0x355>
        return NULL;
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d9:	eb 03                	jmp    8021de <smalloc+0x358>
    return (void*)va;
  8021db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8021e6:	e8 51 f4 ff ff       	call   80163c <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8021eb:	83 ec 08             	sub    $0x8,%esp
  8021ee:	ff 75 0c             	pushl  0xc(%ebp)
  8021f1:	ff 75 08             	pushl  0x8(%ebp)
  8021f4:	e8 ca 0e 00 00       	call   8030c3 <sys_size_of_shared_object>
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8021ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802203:	7f 0a                	jg     80220f <sget+0x2f>
        return NULL;
  802205:	b8 00 00 00 00       	mov    $0x0,%eax
  80220a:	e9 28 03 00 00       	jmp    802537 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80220f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802216:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802219:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80221c:	01 d0                	add    %edx,%eax
  80221e:	48                   	dec    %eax
  80221f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802222:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802225:	ba 00 00 00 00       	mov    $0x0,%edx
  80222a:	f7 75 d8             	divl   -0x28(%ebp)
  80222d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802230:	29 d0                	sub    %edx,%eax
  802232:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802235:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80223c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802243:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80224a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802251:	e9 85 00 00 00       	jmp    8022db <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802256:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802259:	89 d0                	mov    %edx,%eax
  80225b:	01 c0                	add    %eax,%eax
  80225d:	01 d0                	add    %edx,%eax
  80225f:	c1 e0 02             	shl    $0x2,%eax
  802262:	05 48 10 81 00       	add    $0x811048,%eax
  802267:	8a 00                	mov    (%eax),%al
  802269:	84 c0                	test   %al,%al
  80226b:	74 20                	je     80228d <sget+0xad>
  80226d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802270:	89 d0                	mov    %edx,%eax
  802272:	01 c0                	add    %eax,%eax
  802274:	01 d0                	add    %edx,%eax
  802276:	c1 e0 02             	shl    $0x2,%eax
  802279:	05 44 10 81 00       	add    $0x811044,%eax
  80227e:	8b 00                	mov    (%eax),%eax
  802280:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802283:	75 08                	jne    80228d <sget+0xad>
        {
            exactIdx = i;
  802285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802288:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80228b:	eb 5b                	jmp    8022e8 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80228d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802290:	89 d0                	mov    %edx,%eax
  802292:	01 c0                	add    %eax,%eax
  802294:	01 d0                	add    %edx,%eax
  802296:	c1 e0 02             	shl    $0x2,%eax
  802299:	05 48 10 81 00       	add    $0x811048,%eax
  80229e:	8a 00                	mov    (%eax),%al
  8022a0:	84 c0                	test   %al,%al
  8022a2:	74 34                	je     8022d8 <sget+0xf8>
  8022a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a7:	89 d0                	mov    %edx,%eax
  8022a9:	01 c0                	add    %eax,%eax
  8022ab:	01 d0                	add    %edx,%eax
  8022ad:	c1 e0 02             	shl    $0x2,%eax
  8022b0:	05 44 10 81 00       	add    $0x811044,%eax
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022ba:	76 1c                	jbe    8022d8 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8022bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022bf:	89 d0                	mov    %edx,%eax
  8022c1:	01 c0                	add    %eax,%eax
  8022c3:	01 d0                	add    %edx,%eax
  8022c5:	c1 e0 02             	shl    $0x2,%eax
  8022c8:	05 44 10 81 00       	add    $0x811044,%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8022d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022d8:	ff 45 e8             	incl   -0x18(%ebp)
  8022db:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8022e2:	0f 8e 6e ff ff ff    	jle    802256 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8022e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8022ef:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8022f3:	74 7d                	je     802372 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8022f5:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8022fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ff:	89 d0                	mov    %edx,%eax
  802301:	01 c0                	add    %eax,%eax
  802303:	01 d0                	add    %edx,%eax
  802305:	c1 e0 02             	shl    $0x2,%eax
  802308:	05 40 10 81 00       	add    $0x811040,%eax
  80230d:	8b 10                	mov    (%eax),%edx
  80230f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802312:	01 d0                	add    %edx,%eax
  802314:	48                   	dec    %eax
  802315:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802318:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80231b:	ba 00 00 00 00       	mov    $0x0,%edx
  802320:	f7 75 b8             	divl   -0x48(%ebp)
  802323:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802326:	29 d0                	sub    %edx,%eax
  802328:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80232b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232e:	89 d0                	mov    %edx,%eax
  802330:	01 c0                	add    %eax,%eax
  802332:	01 d0                	add    %edx,%eax
  802334:	c1 e0 02             	shl    $0x2,%eax
  802337:	05 48 10 81 00       	add    $0x811048,%eax
  80233c:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80233f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802342:	89 d0                	mov    %edx,%eax
  802344:	01 c0                	add    %eax,%eax
  802346:	01 d0                	add    %edx,%eax
  802348:	c1 e0 02             	shl    $0x2,%eax
  80234b:	05 44 10 81 00       	add    $0x811044,%eax
  802350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802359:	89 d0                	mov    %edx,%eax
  80235b:	01 c0                	add    %eax,%eax
  80235d:	01 d0                	add    %edx,%eax
  80235f:	c1 e0 02             	shl    $0x2,%eax
  802362:	05 40 10 81 00       	add    $0x811040,%eax
  802367:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80236d:	e9 2d 01 00 00       	jmp    80249f <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802372:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802376:	0f 84 ce 00 00 00    	je     80244a <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80237c:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802383:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802386:	89 d0                	mov    %edx,%eax
  802388:	01 c0                	add    %eax,%eax
  80238a:	01 d0                	add    %edx,%eax
  80238c:	c1 e0 02             	shl    $0x2,%eax
  80238f:	05 40 10 81 00       	add    $0x811040,%eax
  802394:	8b 10                	mov    (%eax),%edx
  802396:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802399:	01 d0                	add    %edx,%eax
  80239b:	48                   	dec    %eax
  80239c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80239f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a7:	f7 75 c0             	divl   -0x40(%ebp)
  8023aa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023ad:	29 d0                	sub    %edx,%eax
  8023af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8023b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023b5:	89 d0                	mov    %edx,%eax
  8023b7:	01 c0                	add    %eax,%eax
  8023b9:	01 d0                	add    %edx,%eax
  8023bb:	c1 e0 02             	shl    $0x2,%eax
  8023be:	05 44 10 81 00       	add    $0x811044,%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023c8:	75 47                	jne    802411 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8023ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023cd:	89 d0                	mov    %edx,%eax
  8023cf:	01 c0                	add    %eax,%eax
  8023d1:	01 d0                	add    %edx,%eax
  8023d3:	c1 e0 02             	shl    $0x2,%eax
  8023d6:	05 48 10 81 00       	add    $0x811048,%eax
  8023db:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8023de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e1:	89 d0                	mov    %edx,%eax
  8023e3:	01 c0                	add    %eax,%eax
  8023e5:	01 d0                	add    %edx,%eax
  8023e7:	c1 e0 02             	shl    $0x2,%eax
  8023ea:	05 44 10 81 00       	add    $0x811044,%eax
  8023ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8023f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f8:	89 d0                	mov    %edx,%eax
  8023fa:	01 c0                	add    %eax,%eax
  8023fc:	01 d0                	add    %edx,%eax
  8023fe:	c1 e0 02             	shl    $0x2,%eax
  802401:	05 40 10 81 00       	add    $0x811040,%eax
  802406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80240c:	e9 8e 00 00 00       	jmp    80249f <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802411:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802414:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802417:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80241a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80241d:	89 d0                	mov    %edx,%eax
  80241f:	01 c0                	add    %eax,%eax
  802421:	01 d0                	add    %edx,%eax
  802423:	c1 e0 02             	shl    $0x2,%eax
  802426:	05 40 10 81 00       	add    $0x811040,%eax
  80242b:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80242d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802430:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802433:	89 c2                	mov    %eax,%edx
  802435:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802438:	89 c8                	mov    %ecx,%eax
  80243a:	01 c0                	add    %eax,%eax
  80243c:	01 c8                	add    %ecx,%eax
  80243e:	c1 e0 02             	shl    $0x2,%eax
  802441:	05 44 10 81 00       	add    $0x811044,%eax
  802446:	89 10                	mov    %edx,(%eax)
  802448:	eb 55                	jmp    80249f <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80244a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802451:	8b 15 28 6b 89 00    	mov    0x896b28,%edx
  802457:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80245a:	01 d0                	add    %edx,%eax
  80245c:	48                   	dec    %eax
  80245d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802460:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802463:	ba 00 00 00 00       	mov    $0x0,%edx
  802468:	f7 75 cc             	divl   -0x34(%ebp)
  80246b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80246e:	29 d0                	sub    %edx,%eax
  802470:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802473:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802476:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802479:	01 d0                	add    %edx,%eax
  80247b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802480:	76 0a                	jbe    80248c <sget+0x2ac>
            return NULL;
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
  802487:	e9 ab 00 00 00       	jmp    802537 <sget+0x357>
        va = start;
  80248c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80248f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802492:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802495:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802498:	01 d0                	add    %edx,%eax
  80249a:	a3 28 6b 89 00       	mov    %eax,0x896b28
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80249f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8024a6:	eb 5e                	jmp    802506 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8024a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024ab:	89 d0                	mov    %edx,%eax
  8024ad:	01 c0                	add    %eax,%eax
  8024af:	01 d0                	add    %edx,%eax
  8024b1:	c1 e0 02             	shl    $0x2,%eax
  8024b4:	05 48 50 80 00       	add    $0x805048,%eax
  8024b9:	8a 00                	mov    (%eax),%al
  8024bb:	84 c0                	test   %al,%al
  8024bd:	75 44                	jne    802503 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8024bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024c2:	89 d0                	mov    %edx,%eax
  8024c4:	01 c0                	add    %eax,%eax
  8024c6:	01 d0                	add    %edx,%eax
  8024c8:	c1 e0 02             	shl    $0x2,%eax
  8024cb:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8024d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8024d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024d9:	89 d0                	mov    %edx,%eax
  8024db:	01 c0                	add    %eax,%eax
  8024dd:	01 d0                	add    %edx,%eax
  8024df:	c1 e0 02             	shl    $0x2,%eax
  8024e2:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8024e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024eb:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8024ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024f0:	89 d0                	mov    %edx,%eax
  8024f2:	01 c0                	add    %eax,%eax
  8024f4:	01 d0                	add    %edx,%eax
  8024f6:	c1 e0 02             	shl    $0x2,%eax
  8024f9:	05 48 50 80 00       	add    $0x805048,%eax
  8024fe:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802501:	eb 0c                	jmp    80250f <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802503:	ff 45 e0             	incl   -0x20(%ebp)
  802506:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80250d:	7e 99                	jle    8024a8 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  80250f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802512:	83 ec 04             	sub    $0x4,%esp
  802515:	50                   	push   %eax
  802516:	ff 75 0c             	pushl  0xc(%ebp)
  802519:	ff 75 08             	pushl  0x8(%ebp)
  80251c:	e8 bf 0b 00 00       	call   8030e0 <sys_get_shared_object>
  802521:	83 c4 10             	add    $0x10,%esp
  802524:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802527:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80252b:	79 07                	jns    802534 <sget+0x354>
        return NULL;
  80252d:	b8 00 00 00 00       	mov    $0x0,%eax
  802532:	eb 03                	jmp    802537 <sget+0x357>
    return (void*)va;
  802534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
  80253c:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80253f:	e8 f8 f0 ff ff       	call   80163c <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802544:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802548:	75 13                	jne    80255d <realloc+0x24>
		return malloc(new_size);
  80254a:	83 ec 0c             	sub    $0xc,%esp
  80254d:	ff 75 0c             	pushl  0xc(%ebp)
  802550:	e8 c4 f1 ff ff       	call   801719 <malloc>
  802555:	83 c4 10             	add    $0x10,%esp
  802558:	e9 f4 05 00 00       	jmp    802b51 <realloc+0x618>
	if (new_size == 0)
  80255d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802561:	75 18                	jne    80257b <realloc+0x42>
	{
		free(virtual_address);
  802563:	83 ec 0c             	sub    $0xc,%esp
  802566:	ff 75 08             	pushl  0x8(%ebp)
  802569:	e8 0b f5 ff ff       	call   801a79 <free>
  80256e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802571:	b8 00 00 00 00       	mov    $0x0,%eax
  802576:	e9 d6 05 00 00       	jmp    802b51 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  80257b:	8b 45 08             	mov    0x8(%ebp),%eax
  80257e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802581:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802584:	85 c0                	test   %eax,%eax
  802586:	79 74                	jns    8025fc <realloc+0xc3>
  802588:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  80258f:	77 6b                	ja     8025fc <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802591:	83 ec 0c             	sub    $0xc,%esp
  802594:	ff 75 0c             	pushl  0xc(%ebp)
  802597:	e8 7d f1 ff ff       	call   801719 <malloc>
  80259c:	83 c4 10             	add    $0x10,%esp
  80259f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8025a2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8025a6:	75 0a                	jne    8025b2 <realloc+0x79>
			return NULL;
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ad:	e9 9f 05 00 00       	jmp    802b51 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8025b2:	83 ec 0c             	sub    $0xc,%esp
  8025b5:	ff 75 08             	pushl  0x8(%ebp)
  8025b8:	e8 e0 11 00 00       	call   80379d <get_block_size>
  8025bd:	83 c4 10             	add    $0x10,%esp
  8025c0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8025c3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c9:	39 d0                	cmp    %edx,%eax
  8025cb:	76 02                	jbe    8025cf <realloc+0x96>
  8025cd:	89 d0                	mov    %edx,%eax
  8025cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8025d2:	83 ec 04             	sub    $0x4,%esp
  8025d5:	ff 75 c0             	pushl  -0x40(%ebp)
  8025d8:	ff 75 08             	pushl  0x8(%ebp)
  8025db:	ff 75 c8             	pushl  -0x38(%ebp)
  8025de:	e8 56 eb ff ff       	call   801139 <memmove>
  8025e3:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8025e6:	83 ec 0c             	sub    $0xc,%esp
  8025e9:	ff 75 08             	pushl  0x8(%ebp)
  8025ec:	e8 88 f4 ff ff       	call   801a79 <free>
  8025f1:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8025f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025f7:	e9 55 05 00 00       	jmp    802b51 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8025fc:	a1 d0 6b 89 00       	mov    0x896bd0,%eax
  802601:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802604:	72 09                	jb     80260f <realloc+0xd6>
  802606:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  80260d:	76 0a                	jbe    802619 <realloc+0xe0>
		return NULL;
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
  802614:	e9 38 05 00 00       	jmp    802b51 <realloc+0x618>
	uint32 oldsz = 0;
  802619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802620:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802627:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80262e:	eb 50                	jmp    802680 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802630:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802633:	89 d0                	mov    %edx,%eax
  802635:	01 c0                	add    %eax,%eax
  802637:	01 d0                	add    %edx,%eax
  802639:	c1 e0 02             	shl    $0x2,%eax
  80263c:	05 48 50 80 00       	add    $0x805048,%eax
  802641:	8a 00                	mov    (%eax),%al
  802643:	84 c0                	test   %al,%al
  802645:	74 36                	je     80267d <realloc+0x144>
  802647:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80264a:	89 d0                	mov    %edx,%eax
  80264c:	01 c0                	add    %eax,%eax
  80264e:	01 d0                	add    %edx,%eax
  802650:	c1 e0 02             	shl    $0x2,%eax
  802653:	05 40 50 80 00       	add    $0x805040,%eax
  802658:	8b 00                	mov    (%eax),%eax
  80265a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80265d:	75 1e                	jne    80267d <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  80265f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802662:	89 d0                	mov    %edx,%eax
  802664:	01 c0                	add    %eax,%eax
  802666:	01 d0                	add    %edx,%eax
  802668:	c1 e0 02             	shl    $0x2,%eax
  80266b:	05 44 50 80 00       	add    $0x805044,%eax
  802670:	8b 00                	mov    (%eax),%eax
  802672:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802675:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802678:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80267b:	eb 0c                	jmp    802689 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80267d:	ff 45 ec             	incl   -0x14(%ebp)
  802680:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802687:	7e a7                	jle    802630 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802689:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80268d:	75 0a                	jne    802699 <realloc+0x160>
		return NULL;
  80268f:	b8 00 00 00 00       	mov    $0x0,%eax
  802694:	e9 b8 04 00 00       	jmp    802b51 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802699:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8026a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026a6:	01 d0                	add    %edx,%eax
  8026a8:	48                   	dec    %eax
  8026a9:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8026ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026af:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b4:	f7 75 bc             	divl   -0x44(%ebp)
  8026b7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026ba:	29 d0                	sub    %edx,%eax
  8026bc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8026bf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026c5:	75 08                	jne    8026cf <realloc+0x196>
		return virtual_address;
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	e9 82 04 00 00       	jmp    802b51 <realloc+0x618>
	if (req < oldsz)
  8026cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026d5:	0f 83 cd 02 00 00    	jae    8029a8 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8026e1:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8026e4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026e7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026ea:	01 d0                	add    %edx,%eax
  8026ec:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8026ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f2:	89 d0                	mov    %edx,%eax
  8026f4:	01 c0                	add    %eax,%eax
  8026f6:	01 d0                	add    %edx,%eax
  8026f8:	c1 e0 02             	shl    $0x2,%eax
  8026fb:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802701:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802704:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802706:	83 ec 08             	sub    $0x8,%esp
  802709:	ff 75 b0             	pushl  -0x50(%ebp)
  80270c:	ff 75 ac             	pushl  -0x54(%ebp)
  80270f:	e8 e3 0c 00 00       	call   8033f7 <sys_free_user_mem>
  802714:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802717:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80271e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802725:	eb 64                	jmp    80278b <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802727:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80272a:	89 d0                	mov    %edx,%eax
  80272c:	01 c0                	add    %eax,%eax
  80272e:	01 d0                	add    %edx,%eax
  802730:	c1 e0 02             	shl    $0x2,%eax
  802733:	05 48 10 81 00       	add    $0x811048,%eax
  802738:	8a 00                	mov    (%eax),%al
  80273a:	84 c0                	test   %al,%al
  80273c:	75 4a                	jne    802788 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  80273e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802741:	89 d0                	mov    %edx,%eax
  802743:	01 c0                	add    %eax,%eax
  802745:	01 d0                	add    %edx,%eax
  802747:	c1 e0 02             	shl    $0x2,%eax
  80274a:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802750:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802753:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802758:	89 d0                	mov    %edx,%eax
  80275a:	01 c0                	add    %eax,%eax
  80275c:	01 d0                	add    %edx,%eax
  80275e:	c1 e0 02             	shl    $0x2,%eax
  802761:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802767:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80276a:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  80276c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80276f:	89 d0                	mov    %edx,%eax
  802771:	01 c0                	add    %eax,%eax
  802773:	01 d0                	add    %edx,%eax
  802775:	c1 e0 02             	shl    $0x2,%eax
  802778:	05 48 10 81 00       	add    $0x811048,%eax
  80277d:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802783:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802786:	eb 0c                	jmp    802794 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802788:	ff 45 e4             	incl   -0x1c(%ebp)
  80278b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802792:	7e 93                	jle    802727 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802794:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802798:	0f 84 8d 01 00 00    	je     80292b <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80279e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8027a5:	e9 74 01 00 00       	jmp    80291e <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8027aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ad:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027b0:	0f 84 64 01 00 00    	je     80291a <realloc+0x3e1>
				if (uhp_frees[k].free)
  8027b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027b9:	89 d0                	mov    %edx,%eax
  8027bb:	01 c0                	add    %eax,%eax
  8027bd:	01 d0                	add    %edx,%eax
  8027bf:	c1 e0 02             	shl    $0x2,%eax
  8027c2:	05 48 10 81 00       	add    $0x811048,%eax
  8027c7:	8a 00                	mov    (%eax),%al
  8027c9:	84 c0                	test   %al,%al
  8027cb:	0f 84 4a 01 00 00    	je     80291b <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8027d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027d4:	89 d0                	mov    %edx,%eax
  8027d6:	01 c0                	add    %eax,%eax
  8027d8:	01 d0                	add    %edx,%eax
  8027da:	c1 e0 02             	shl    $0x2,%eax
  8027dd:	05 40 10 81 00       	add    $0x811040,%eax
  8027e2:	8b 08                	mov    (%eax),%ecx
  8027e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027e7:	89 d0                	mov    %edx,%eax
  8027e9:	01 c0                	add    %eax,%eax
  8027eb:	01 d0                	add    %edx,%eax
  8027ed:	c1 e0 02             	shl    $0x2,%eax
  8027f0:	05 44 10 81 00       	add    $0x811044,%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	01 c1                	add    %eax,%ecx
  8027f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027fc:	89 d0                	mov    %edx,%eax
  8027fe:	01 c0                	add    %eax,%eax
  802800:	01 d0                	add    %edx,%eax
  802802:	c1 e0 02             	shl    $0x2,%eax
  802805:	05 40 10 81 00       	add    $0x811040,%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	39 c1                	cmp    %eax,%ecx
  80280e:	75 7a                	jne    80288a <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802810:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802813:	89 d0                	mov    %edx,%eax
  802815:	01 c0                	add    %eax,%eax
  802817:	01 d0                	add    %edx,%eax
  802819:	c1 e0 02             	shl    $0x2,%eax
  80281c:	05 40 10 81 00       	add    $0x811040,%eax
  802821:	8b 10                	mov    (%eax),%edx
  802823:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802826:	89 c8                	mov    %ecx,%eax
  802828:	01 c0                	add    %eax,%eax
  80282a:	01 c8                	add    %ecx,%eax
  80282c:	c1 e0 02             	shl    $0x2,%eax
  80282f:	05 40 10 81 00       	add    $0x811040,%eax
  802834:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802836:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802839:	89 d0                	mov    %edx,%eax
  80283b:	01 c0                	add    %eax,%eax
  80283d:	01 d0                	add    %edx,%eax
  80283f:	c1 e0 02             	shl    $0x2,%eax
  802842:	05 44 10 81 00       	add    $0x811044,%eax
  802847:	8b 08                	mov    (%eax),%ecx
  802849:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80284c:	89 d0                	mov    %edx,%eax
  80284e:	01 c0                	add    %eax,%eax
  802850:	01 d0                	add    %edx,%eax
  802852:	c1 e0 02             	shl    $0x2,%eax
  802855:	05 44 10 81 00       	add    $0x811044,%eax
  80285a:	8b 00                	mov    (%eax),%eax
  80285c:	01 c1                	add    %eax,%ecx
  80285e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802861:	89 d0                	mov    %edx,%eax
  802863:	01 c0                	add    %eax,%eax
  802865:	01 d0                	add    %edx,%eax
  802867:	c1 e0 02             	shl    $0x2,%eax
  80286a:	05 44 10 81 00       	add    $0x811044,%eax
  80286f:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802871:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802874:	89 d0                	mov    %edx,%eax
  802876:	01 c0                	add    %eax,%eax
  802878:	01 d0                	add    %edx,%eax
  80287a:	c1 e0 02             	shl    $0x2,%eax
  80287d:	05 48 10 81 00       	add    $0x811048,%eax
  802882:	c6 00 00             	movb   $0x0,(%eax)
  802885:	e9 91 00 00 00       	jmp    80291b <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  80288a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80288d:	89 d0                	mov    %edx,%eax
  80288f:	01 c0                	add    %eax,%eax
  802891:	01 d0                	add    %edx,%eax
  802893:	c1 e0 02             	shl    $0x2,%eax
  802896:	05 40 10 81 00       	add    $0x811040,%eax
  80289b:	8b 08                	mov    (%eax),%ecx
  80289d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028a0:	89 d0                	mov    %edx,%eax
  8028a2:	01 c0                	add    %eax,%eax
  8028a4:	01 d0                	add    %edx,%eax
  8028a6:	c1 e0 02             	shl    $0x2,%eax
  8028a9:	05 44 10 81 00       	add    $0x811044,%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	01 c1                	add    %eax,%ecx
  8028b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028b5:	89 d0                	mov    %edx,%eax
  8028b7:	01 c0                	add    %eax,%eax
  8028b9:	01 d0                	add    %edx,%eax
  8028bb:	c1 e0 02             	shl    $0x2,%eax
  8028be:	05 40 10 81 00       	add    $0x811040,%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	39 c1                	cmp    %eax,%ecx
  8028c7:	75 52                	jne    80291b <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8028c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028cc:	89 d0                	mov    %edx,%eax
  8028ce:	01 c0                	add    %eax,%eax
  8028d0:	01 d0                	add    %edx,%eax
  8028d2:	c1 e0 02             	shl    $0x2,%eax
  8028d5:	05 44 10 81 00       	add    $0x811044,%eax
  8028da:	8b 08                	mov    (%eax),%ecx
  8028dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028df:	89 d0                	mov    %edx,%eax
  8028e1:	01 c0                	add    %eax,%eax
  8028e3:	01 d0                	add    %edx,%eax
  8028e5:	c1 e0 02             	shl    $0x2,%eax
  8028e8:	05 44 10 81 00       	add    $0x811044,%eax
  8028ed:	8b 00                	mov    (%eax),%eax
  8028ef:	01 c1                	add    %eax,%ecx
  8028f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028f4:	89 d0                	mov    %edx,%eax
  8028f6:	01 c0                	add    %eax,%eax
  8028f8:	01 d0                	add    %edx,%eax
  8028fa:	c1 e0 02             	shl    $0x2,%eax
  8028fd:	05 44 10 81 00       	add    $0x811044,%eax
  802902:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802904:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802907:	89 d0                	mov    %edx,%eax
  802909:	01 c0                	add    %eax,%eax
  80290b:	01 d0                	add    %edx,%eax
  80290d:	c1 e0 02             	shl    $0x2,%eax
  802910:	05 48 10 81 00       	add    $0x811048,%eax
  802915:	c6 00 00             	movb   $0x0,(%eax)
  802918:	eb 01                	jmp    80291b <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  80291a:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80291b:	ff 45 e0             	incl   -0x20(%ebp)
  80291e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802925:	0f 8e 7f fe ff ff    	jle    8027aa <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  80292b:	a1 d0 6b 89 00       	mov    0x896bd0,%eax
  802930:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802933:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80293a:	eb 53                	jmp    80298f <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  80293c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80293f:	89 d0                	mov    %edx,%eax
  802941:	01 c0                	add    %eax,%eax
  802943:	01 d0                	add    %edx,%eax
  802945:	c1 e0 02             	shl    $0x2,%eax
  802948:	05 48 50 80 00       	add    $0x805048,%eax
  80294d:	8a 00                	mov    (%eax),%al
  80294f:	84 c0                	test   %al,%al
  802951:	74 39                	je     80298c <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802953:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802956:	89 d0                	mov    %edx,%eax
  802958:	01 c0                	add    %eax,%eax
  80295a:	01 d0                	add    %edx,%eax
  80295c:	c1 e0 02             	shl    $0x2,%eax
  80295f:	05 40 50 80 00       	add    $0x805040,%eax
  802964:	8b 08                	mov    (%eax),%ecx
  802966:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802969:	89 d0                	mov    %edx,%eax
  80296b:	01 c0                	add    %eax,%eax
  80296d:	01 d0                	add    %edx,%eax
  80296f:	c1 e0 02             	shl    $0x2,%eax
  802972:	05 44 50 80 00       	add    $0x805044,%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	01 c8                	add    %ecx,%eax
  80297b:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  80297e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802981:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802984:	76 06                	jbe    80298c <realloc+0x453>
  802986:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802989:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80298c:	ff 45 d8             	incl   -0x28(%ebp)
  80298f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802996:	7e a4                	jle    80293c <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802998:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80299b:	a3 28 6b 89 00       	mov    %eax,0x896b28
		return virtual_address;
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	e9 a9 01 00 00       	jmp    802b51 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8029a8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	01 d0                	add    %edx,%eax
  8029b0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8029b3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029ba:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8029c1:	eb 57                	jmp    802a1a <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8029c3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029c6:	89 d0                	mov    %edx,%eax
  8029c8:	01 c0                	add    %eax,%eax
  8029ca:	01 d0                	add    %edx,%eax
  8029cc:	c1 e0 02             	shl    $0x2,%eax
  8029cf:	05 48 10 81 00       	add    $0x811048,%eax
  8029d4:	8a 00                	mov    (%eax),%al
  8029d6:	84 c0                	test   %al,%al
  8029d8:	74 3d                	je     802a17 <realloc+0x4de>
  8029da:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029dd:	89 d0                	mov    %edx,%eax
  8029df:	01 c0                	add    %eax,%eax
  8029e1:	01 d0                	add    %edx,%eax
  8029e3:	c1 e0 02             	shl    $0x2,%eax
  8029e6:	05 40 10 81 00       	add    $0x811040,%eax
  8029eb:	8b 00                	mov    (%eax),%eax
  8029ed:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029f0:	75 25                	jne    802a17 <realloc+0x4de>
  8029f2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029f5:	89 d0                	mov    %edx,%eax
  8029f7:	01 c0                	add    %eax,%eax
  8029f9:	01 d0                	add    %edx,%eax
  8029fb:	c1 e0 02             	shl    $0x2,%eax
  8029fe:	05 44 10 81 00       	add    $0x811044,%eax
  802a03:	8b 10                	mov    (%eax),%edx
  802a05:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a08:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a0b:	39 c2                	cmp    %eax,%edx
  802a0d:	72 08                	jb     802a17 <realloc+0x4de>
		{
			adjIdx = j; break;
  802a0f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a12:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a15:	eb 0c                	jmp    802a23 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a17:	ff 45 d0             	incl   -0x30(%ebp)
  802a1a:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802a21:	7e a0                	jle    8029c3 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802a23:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802a27:	0f 84 d6 00 00 00    	je     802b03 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802a2d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a30:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a33:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802a36:	83 ec 08             	sub    $0x8,%esp
  802a39:	ff 75 a0             	pushl  -0x60(%ebp)
  802a3c:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a3f:	e8 cf 09 00 00       	call   803413 <sys_allocate_user_mem>
  802a44:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802a47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a4a:	89 d0                	mov    %edx,%eax
  802a4c:	01 c0                	add    %eax,%eax
  802a4e:	01 d0                	add    %edx,%eax
  802a50:	c1 e0 02             	shl    $0x2,%eax
  802a53:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802a59:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a5c:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802a5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a61:	89 d0                	mov    %edx,%eax
  802a63:	01 c0                	add    %eax,%eax
  802a65:	01 d0                	add    %edx,%eax
  802a67:	c1 e0 02             	shl    $0x2,%eax
  802a6a:	05 40 10 81 00       	add    $0x811040,%eax
  802a6f:	8b 10                	mov    (%eax),%edx
  802a71:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a74:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802a77:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a7a:	89 d0                	mov    %edx,%eax
  802a7c:	01 c0                	add    %eax,%eax
  802a7e:	01 d0                	add    %edx,%eax
  802a80:	c1 e0 02             	shl    $0x2,%eax
  802a83:	05 40 10 81 00       	add    $0x811040,%eax
  802a88:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802a8a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a8d:	89 d0                	mov    %edx,%eax
  802a8f:	01 c0                	add    %eax,%eax
  802a91:	01 d0                	add    %edx,%eax
  802a93:	c1 e0 02             	shl    $0x2,%eax
  802a96:	05 44 10 81 00       	add    $0x811044,%eax
  802a9b:	8b 00                	mov    (%eax),%eax
  802a9d:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802aa0:	89 c2                	mov    %eax,%edx
  802aa2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802aa5:	89 c8                	mov    %ecx,%eax
  802aa7:	01 c0                	add    %eax,%eax
  802aa9:	01 c8                	add    %ecx,%eax
  802aab:	c1 e0 02             	shl    $0x2,%eax
  802aae:	05 44 10 81 00       	add    $0x811044,%eax
  802ab3:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802ab5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ab8:	89 d0                	mov    %edx,%eax
  802aba:	01 c0                	add    %eax,%eax
  802abc:	01 d0                	add    %edx,%eax
  802abe:	c1 e0 02             	shl    $0x2,%eax
  802ac1:	05 44 10 81 00       	add    $0x811044,%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	75 14                	jne    802ae0 <realloc+0x5a7>
  802acc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802acf:	89 d0                	mov    %edx,%eax
  802ad1:	01 c0                	add    %eax,%eax
  802ad3:	01 d0                	add    %edx,%eax
  802ad5:	c1 e0 02             	shl    $0x2,%eax
  802ad8:	05 48 10 81 00       	add    $0x811048,%eax
  802add:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802ae0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ae3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ae6:	01 c2                	add    %eax,%edx
  802ae8:	a1 28 6b 89 00       	mov    0x896b28,%eax
  802aed:	39 c2                	cmp    %eax,%edx
  802aef:	76 0d                	jbe    802afe <realloc+0x5c5>
  802af1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802af4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802af7:	01 d0                	add    %edx,%eax
  802af9:	a3 28 6b 89 00       	mov    %eax,0x896b28
		return virtual_address;
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	eb 4e                	jmp    802b51 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802b03:	83 ec 0c             	sub    $0xc,%esp
  802b06:	ff 75 0c             	pushl  0xc(%ebp)
  802b09:	e8 0b ec ff ff       	call   801719 <malloc>
  802b0e:	83 c4 10             	add    $0x10,%esp
  802b11:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802b14:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802b18:	75 07                	jne    802b21 <realloc+0x5e8>
		return NULL;
  802b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1f:	eb 30                	jmp    802b51 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b27:	39 d0                	cmp    %edx,%eax
  802b29:	76 02                	jbe    802b2d <realloc+0x5f4>
  802b2b:	89 d0                	mov    %edx,%eax
  802b2d:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802b30:	83 ec 04             	sub    $0x4,%esp
  802b33:	50                   	push   %eax
  802b34:	52                   	push   %edx
  802b35:	ff 75 cc             	pushl  -0x34(%ebp)
  802b38:	e8 cf 06 00 00       	call   80320c <sys_move_user_mem>
  802b3d:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802b40:	83 ec 0c             	sub    $0xc,%esp
  802b43:	ff 75 08             	pushl  0x8(%ebp)
  802b46:	e8 2e ef ff ff       	call   801a79 <free>
  802b4b:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802b4e:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802b51:	c9                   	leave  
  802b52:	c3                   	ret    

00802b53 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802b53:	55                   	push   %ebp
  802b54:	89 e5                	mov    %esp,%ebp
  802b56:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802b5f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b63:	0f 84 33 03 00 00    	je     802e9c <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802b69:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b6c:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802b71:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802b74:	83 ec 08             	sub    $0x8,%esp
  802b77:	ff 75 08             	pushl  0x8(%ebp)
  802b7a:	ff 75 d8             	pushl  -0x28(%ebp)
  802b7d:	e8 7d 05 00 00       	call   8030ff <sys_delete_shared_object>
  802b82:	83 c4 10             	add    $0x10,%esp
  802b85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802b88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802b8c:	0f 88 0d 03 00 00    	js     802e9f <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b99:	e9 ef 02 00 00       	jmp    802e8d <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba1:	89 d0                	mov    %edx,%eax
  802ba3:	01 c0                	add    %eax,%eax
  802ba5:	01 d0                	add    %edx,%eax
  802ba7:	c1 e0 02             	shl    $0x2,%eax
  802baa:	05 48 50 80 00       	add    $0x805048,%eax
  802baf:	8a 00                	mov    (%eax),%al
  802bb1:	84 c0                	test   %al,%al
  802bb3:	0f 84 d1 02 00 00    	je     802e8a <sfree+0x337>
  802bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbc:	89 d0                	mov    %edx,%eax
  802bbe:	01 c0                	add    %eax,%eax
  802bc0:	01 d0                	add    %edx,%eax
  802bc2:	c1 e0 02             	shl    $0x2,%eax
  802bc5:	05 40 50 80 00       	add    $0x805040,%eax
  802bca:	8b 00                	mov    (%eax),%eax
  802bcc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802bcf:	0f 85 b5 02 00 00    	jne    802e8a <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd8:	89 d0                	mov    %edx,%eax
  802bda:	01 c0                	add    %eax,%eax
  802bdc:	01 d0                	add    %edx,%eax
  802bde:	c1 e0 02             	shl    $0x2,%eax
  802be1:	05 44 50 80 00       	add    $0x805044,%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bee:	89 d0                	mov    %edx,%eax
  802bf0:	01 c0                	add    %eax,%eax
  802bf2:	01 d0                	add    %edx,%eax
  802bf4:	c1 e0 02             	shl    $0x2,%eax
  802bf7:	05 48 50 80 00       	add    $0x805048,%eax
  802bfc:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802bff:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c06:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802c0d:	eb 64                	jmp    802c73 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802c0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c12:	89 d0                	mov    %edx,%eax
  802c14:	01 c0                	add    %eax,%eax
  802c16:	01 d0                	add    %edx,%eax
  802c18:	c1 e0 02             	shl    $0x2,%eax
  802c1b:	05 48 10 81 00       	add    $0x811048,%eax
  802c20:	8a 00                	mov    (%eax),%al
  802c22:	84 c0                	test   %al,%al
  802c24:	75 4a                	jne    802c70 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802c26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c29:	89 d0                	mov    %edx,%eax
  802c2b:	01 c0                	add    %eax,%eax
  802c2d:	01 d0                	add    %edx,%eax
  802c2f:	c1 e0 02             	shl    $0x2,%eax
  802c32:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802c38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c3b:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802c3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c40:	89 d0                	mov    %edx,%eax
  802c42:	01 c0                	add    %eax,%eax
  802c44:	01 d0                	add    %edx,%eax
  802c46:	c1 e0 02             	shl    $0x2,%eax
  802c49:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802c4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c52:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802c54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c57:	89 d0                	mov    %edx,%eax
  802c59:	01 c0                	add    %eax,%eax
  802c5b:	01 d0                	add    %edx,%eax
  802c5d:	c1 e0 02             	shl    $0x2,%eax
  802c60:	05 48 10 81 00       	add    $0x811048,%eax
  802c65:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802c6e:	eb 0c                	jmp    802c7c <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c70:	ff 45 ec             	incl   -0x14(%ebp)
  802c73:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802c7a:	7e 93                	jle    802c0f <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802c7c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c80:	0f 84 8d 01 00 00    	je     802e13 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c86:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802c8d:	e9 74 01 00 00       	jmp    802e06 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c95:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c98:	0f 84 64 01 00 00    	je     802e02 <sfree+0x2af>
					if (uhp_frees[k].free)
  802c9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ca1:	89 d0                	mov    %edx,%eax
  802ca3:	01 c0                	add    %eax,%eax
  802ca5:	01 d0                	add    %edx,%eax
  802ca7:	c1 e0 02             	shl    $0x2,%eax
  802caa:	05 48 10 81 00       	add    $0x811048,%eax
  802caf:	8a 00                	mov    (%eax),%al
  802cb1:	84 c0                	test   %al,%al
  802cb3:	0f 84 4a 01 00 00    	je     802e03 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802cb9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cbc:	89 d0                	mov    %edx,%eax
  802cbe:	01 c0                	add    %eax,%eax
  802cc0:	01 d0                	add    %edx,%eax
  802cc2:	c1 e0 02             	shl    $0x2,%eax
  802cc5:	05 40 10 81 00       	add    $0x811040,%eax
  802cca:	8b 08                	mov    (%eax),%ecx
  802ccc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ccf:	89 d0                	mov    %edx,%eax
  802cd1:	01 c0                	add    %eax,%eax
  802cd3:	01 d0                	add    %edx,%eax
  802cd5:	c1 e0 02             	shl    $0x2,%eax
  802cd8:	05 44 10 81 00       	add    $0x811044,%eax
  802cdd:	8b 00                	mov    (%eax),%eax
  802cdf:	01 c1                	add    %eax,%ecx
  802ce1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce4:	89 d0                	mov    %edx,%eax
  802ce6:	01 c0                	add    %eax,%eax
  802ce8:	01 d0                	add    %edx,%eax
  802cea:	c1 e0 02             	shl    $0x2,%eax
  802ced:	05 40 10 81 00       	add    $0x811040,%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	39 c1                	cmp    %eax,%ecx
  802cf6:	75 7a                	jne    802d72 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802cf8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cfb:	89 d0                	mov    %edx,%eax
  802cfd:	01 c0                	add    %eax,%eax
  802cff:	01 d0                	add    %edx,%eax
  802d01:	c1 e0 02             	shl    $0x2,%eax
  802d04:	05 40 10 81 00       	add    $0x811040,%eax
  802d09:	8b 10                	mov    (%eax),%edx
  802d0b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d0e:	89 c8                	mov    %ecx,%eax
  802d10:	01 c0                	add    %eax,%eax
  802d12:	01 c8                	add    %ecx,%eax
  802d14:	c1 e0 02             	shl    $0x2,%eax
  802d17:	05 40 10 81 00       	add    $0x811040,%eax
  802d1c:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d21:	89 d0                	mov    %edx,%eax
  802d23:	01 c0                	add    %eax,%eax
  802d25:	01 d0                	add    %edx,%eax
  802d27:	c1 e0 02             	shl    $0x2,%eax
  802d2a:	05 44 10 81 00       	add    $0x811044,%eax
  802d2f:	8b 08                	mov    (%eax),%ecx
  802d31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d34:	89 d0                	mov    %edx,%eax
  802d36:	01 c0                	add    %eax,%eax
  802d38:	01 d0                	add    %edx,%eax
  802d3a:	c1 e0 02             	shl    $0x2,%eax
  802d3d:	05 44 10 81 00       	add    $0x811044,%eax
  802d42:	8b 00                	mov    (%eax),%eax
  802d44:	01 c1                	add    %eax,%ecx
  802d46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d49:	89 d0                	mov    %edx,%eax
  802d4b:	01 c0                	add    %eax,%eax
  802d4d:	01 d0                	add    %edx,%eax
  802d4f:	c1 e0 02             	shl    $0x2,%eax
  802d52:	05 44 10 81 00       	add    $0x811044,%eax
  802d57:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d5c:	89 d0                	mov    %edx,%eax
  802d5e:	01 c0                	add    %eax,%eax
  802d60:	01 d0                	add    %edx,%eax
  802d62:	c1 e0 02             	shl    $0x2,%eax
  802d65:	05 48 10 81 00       	add    $0x811048,%eax
  802d6a:	c6 00 00             	movb   $0x0,(%eax)
  802d6d:	e9 91 00 00 00       	jmp    802e03 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d75:	89 d0                	mov    %edx,%eax
  802d77:	01 c0                	add    %eax,%eax
  802d79:	01 d0                	add    %edx,%eax
  802d7b:	c1 e0 02             	shl    $0x2,%eax
  802d7e:	05 40 10 81 00       	add    $0x811040,%eax
  802d83:	8b 08                	mov    (%eax),%ecx
  802d85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d88:	89 d0                	mov    %edx,%eax
  802d8a:	01 c0                	add    %eax,%eax
  802d8c:	01 d0                	add    %edx,%eax
  802d8e:	c1 e0 02             	shl    $0x2,%eax
  802d91:	05 44 10 81 00       	add    $0x811044,%eax
  802d96:	8b 00                	mov    (%eax),%eax
  802d98:	01 c1                	add    %eax,%ecx
  802d9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d9d:	89 d0                	mov    %edx,%eax
  802d9f:	01 c0                	add    %eax,%eax
  802da1:	01 d0                	add    %edx,%eax
  802da3:	c1 e0 02             	shl    $0x2,%eax
  802da6:	05 40 10 81 00       	add    $0x811040,%eax
  802dab:	8b 00                	mov    (%eax),%eax
  802dad:	39 c1                	cmp    %eax,%ecx
  802daf:	75 52                	jne    802e03 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802db1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db4:	89 d0                	mov    %edx,%eax
  802db6:	01 c0                	add    %eax,%eax
  802db8:	01 d0                	add    %edx,%eax
  802dba:	c1 e0 02             	shl    $0x2,%eax
  802dbd:	05 44 10 81 00       	add    $0x811044,%eax
  802dc2:	8b 08                	mov    (%eax),%ecx
  802dc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dc7:	89 d0                	mov    %edx,%eax
  802dc9:	01 c0                	add    %eax,%eax
  802dcb:	01 d0                	add    %edx,%eax
  802dcd:	c1 e0 02             	shl    $0x2,%eax
  802dd0:	05 44 10 81 00       	add    $0x811044,%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	01 c1                	add    %eax,%ecx
  802dd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ddc:	89 d0                	mov    %edx,%eax
  802dde:	01 c0                	add    %eax,%eax
  802de0:	01 d0                	add    %edx,%eax
  802de2:	c1 e0 02             	shl    $0x2,%eax
  802de5:	05 44 10 81 00       	add    $0x811044,%eax
  802dea:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802dec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802def:	89 d0                	mov    %edx,%eax
  802df1:	01 c0                	add    %eax,%eax
  802df3:	01 d0                	add    %edx,%eax
  802df5:	c1 e0 02             	shl    $0x2,%eax
  802df8:	05 48 10 81 00       	add    $0x811048,%eax
  802dfd:	c6 00 00             	movb   $0x0,(%eax)
  802e00:	eb 01                	jmp    802e03 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802e02:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e03:	ff 45 e8             	incl   -0x18(%ebp)
  802e06:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802e0d:	0f 8e 7f fe ff ff    	jle    802c92 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802e13:	a1 d0 6b 89 00       	mov    0x896bd0,%eax
  802e18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e1b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802e22:	eb 53                	jmp    802e77 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802e24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e27:	89 d0                	mov    %edx,%eax
  802e29:	01 c0                	add    %eax,%eax
  802e2b:	01 d0                	add    %edx,%eax
  802e2d:	c1 e0 02             	shl    $0x2,%eax
  802e30:	05 48 50 80 00       	add    $0x805048,%eax
  802e35:	8a 00                	mov    (%eax),%al
  802e37:	84 c0                	test   %al,%al
  802e39:	74 39                	je     802e74 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e3e:	89 d0                	mov    %edx,%eax
  802e40:	01 c0                	add    %eax,%eax
  802e42:	01 d0                	add    %edx,%eax
  802e44:	c1 e0 02             	shl    $0x2,%eax
  802e47:	05 40 50 80 00       	add    $0x805040,%eax
  802e4c:	8b 08                	mov    (%eax),%ecx
  802e4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e51:	89 d0                	mov    %edx,%eax
  802e53:	01 c0                	add    %eax,%eax
  802e55:	01 d0                	add    %edx,%eax
  802e57:	c1 e0 02             	shl    $0x2,%eax
  802e5a:	05 44 50 80 00       	add    $0x805044,%eax
  802e5f:	8b 00                	mov    (%eax),%eax
  802e61:	01 c8                	add    %ecx,%eax
  802e63:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802e66:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e69:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e6c:	76 06                	jbe    802e74 <sfree+0x321>
  802e6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e74:	ff 45 e0             	incl   -0x20(%ebp)
  802e77:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802e7e:	7e a4                	jle    802e24 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802e80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e83:	a3 28 6b 89 00       	mov    %eax,0x896b28
			break;
  802e88:	eb 16                	jmp    802ea0 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802e8a:	ff 45 f4             	incl   -0xc(%ebp)
  802e8d:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802e94:	0f 8e 04 fd ff ff    	jle    802b9e <sfree+0x4b>
  802e9a:	eb 04                	jmp    802ea0 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802e9c:	90                   	nop
  802e9d:	eb 01                	jmp    802ea0 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802e9f:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802ea0:	c9                   	leave  
  802ea1:	c3                   	ret    

00802ea2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802ea2:	55                   	push   %ebp
  802ea3:	89 e5                	mov    %esp,%ebp
  802ea5:	57                   	push   %edi
  802ea6:	56                   	push   %esi
  802ea7:	53                   	push   %ebx
  802ea8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802eb4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802eb7:	8b 7d 18             	mov    0x18(%ebp),%edi
  802eba:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ebd:	cd 30                	int    $0x30
  802ebf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802ec5:	83 c4 10             	add    $0x10,%esp
  802ec8:	5b                   	pop    %ebx
  802ec9:	5e                   	pop    %esi
  802eca:	5f                   	pop    %edi
  802ecb:	5d                   	pop    %ebp
  802ecc:	c3                   	ret    

00802ecd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802ecd:	55                   	push   %ebp
  802ece:	89 e5                	mov    %esp,%ebp
  802ed0:	83 ec 04             	sub    $0x4,%esp
  802ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  802ed6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802ed9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802edc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	6a 00                	push   $0x0
  802ee5:	51                   	push   %ecx
  802ee6:	52                   	push   %edx
  802ee7:	ff 75 0c             	pushl  0xc(%ebp)
  802eea:	50                   	push   %eax
  802eeb:	6a 00                	push   $0x0
  802eed:	e8 b0 ff ff ff       	call   802ea2 <syscall>
  802ef2:	83 c4 18             	add    $0x18,%esp
}
  802ef5:	90                   	nop
  802ef6:	c9                   	leave  
  802ef7:	c3                   	ret    

00802ef8 <sys_cgetc>:

int
sys_cgetc(void)
{
  802ef8:	55                   	push   %ebp
  802ef9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802efb:	6a 00                	push   $0x0
  802efd:	6a 00                	push   $0x0
  802eff:	6a 00                	push   $0x0
  802f01:	6a 00                	push   $0x0
  802f03:	6a 00                	push   $0x0
  802f05:	6a 02                	push   $0x2
  802f07:	e8 96 ff ff ff       	call   802ea2 <syscall>
  802f0c:	83 c4 18             	add    $0x18,%esp
}
  802f0f:	c9                   	leave  
  802f10:	c3                   	ret    

00802f11 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802f11:	55                   	push   %ebp
  802f12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802f14:	6a 00                	push   $0x0
  802f16:	6a 00                	push   $0x0
  802f18:	6a 00                	push   $0x0
  802f1a:	6a 00                	push   $0x0
  802f1c:	6a 00                	push   $0x0
  802f1e:	6a 03                	push   $0x3
  802f20:	e8 7d ff ff ff       	call   802ea2 <syscall>
  802f25:	83 c4 18             	add    $0x18,%esp
}
  802f28:	90                   	nop
  802f29:	c9                   	leave  
  802f2a:	c3                   	ret    

00802f2b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802f2b:	55                   	push   %ebp
  802f2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802f2e:	6a 00                	push   $0x0
  802f30:	6a 00                	push   $0x0
  802f32:	6a 00                	push   $0x0
  802f34:	6a 00                	push   $0x0
  802f36:	6a 00                	push   $0x0
  802f38:	6a 04                	push   $0x4
  802f3a:	e8 63 ff ff ff       	call   802ea2 <syscall>
  802f3f:	83 c4 18             	add    $0x18,%esp
}
  802f42:	90                   	nop
  802f43:	c9                   	leave  
  802f44:	c3                   	ret    

00802f45 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f45:	55                   	push   %ebp
  802f46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	6a 00                	push   $0x0
  802f50:	6a 00                	push   $0x0
  802f52:	6a 00                	push   $0x0
  802f54:	52                   	push   %edx
  802f55:	50                   	push   %eax
  802f56:	6a 08                	push   $0x8
  802f58:	e8 45 ff ff ff       	call   802ea2 <syscall>
  802f5d:	83 c4 18             	add    $0x18,%esp
}
  802f60:	c9                   	leave  
  802f61:	c3                   	ret    

00802f62 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f62:	55                   	push   %ebp
  802f63:	89 e5                	mov    %esp,%ebp
  802f65:	56                   	push   %esi
  802f66:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f67:	8b 75 18             	mov    0x18(%ebp),%esi
  802f6a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f70:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	56                   	push   %esi
  802f77:	53                   	push   %ebx
  802f78:	51                   	push   %ecx
  802f79:	52                   	push   %edx
  802f7a:	50                   	push   %eax
  802f7b:	6a 09                	push   $0x9
  802f7d:	e8 20 ff ff ff       	call   802ea2 <syscall>
  802f82:	83 c4 18             	add    $0x18,%esp
}
  802f85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f88:	5b                   	pop    %ebx
  802f89:	5e                   	pop    %esi
  802f8a:	5d                   	pop    %ebp
  802f8b:	c3                   	ret    

00802f8c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802f8c:	55                   	push   %ebp
  802f8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	ff 75 08             	pushl  0x8(%ebp)
  802f9a:	6a 0a                	push   $0xa
  802f9c:	e8 01 ff ff ff       	call   802ea2 <syscall>
  802fa1:	83 c4 18             	add    $0x18,%esp
}
  802fa4:	c9                   	leave  
  802fa5:	c3                   	ret    

00802fa6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802fa6:	55                   	push   %ebp
  802fa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802fa9:	6a 00                	push   $0x0
  802fab:	6a 00                	push   $0x0
  802fad:	6a 00                	push   $0x0
  802faf:	ff 75 0c             	pushl  0xc(%ebp)
  802fb2:	ff 75 08             	pushl  0x8(%ebp)
  802fb5:	6a 0b                	push   $0xb
  802fb7:	e8 e6 fe ff ff       	call   802ea2 <syscall>
  802fbc:	83 c4 18             	add    $0x18,%esp
}
  802fbf:	c9                   	leave  
  802fc0:	c3                   	ret    

00802fc1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802fc1:	55                   	push   %ebp
  802fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802fc4:	6a 00                	push   $0x0
  802fc6:	6a 00                	push   $0x0
  802fc8:	6a 00                	push   $0x0
  802fca:	6a 00                	push   $0x0
  802fcc:	6a 00                	push   $0x0
  802fce:	6a 0c                	push   $0xc
  802fd0:	e8 cd fe ff ff       	call   802ea2 <syscall>
  802fd5:	83 c4 18             	add    $0x18,%esp
}
  802fd8:	c9                   	leave  
  802fd9:	c3                   	ret    

00802fda <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802fda:	55                   	push   %ebp
  802fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 00                	push   $0x0
  802fe3:	6a 00                	push   $0x0
  802fe5:	6a 00                	push   $0x0
  802fe7:	6a 0d                	push   $0xd
  802fe9:	e8 b4 fe ff ff       	call   802ea2 <syscall>
  802fee:	83 c4 18             	add    $0x18,%esp
}
  802ff1:	c9                   	leave  
  802ff2:	c3                   	ret    

00802ff3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ff3:	55                   	push   %ebp
  802ff4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ff6:	6a 00                	push   $0x0
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	6a 00                	push   $0x0
  802ffe:	6a 00                	push   $0x0
  803000:	6a 0e                	push   $0xe
  803002:	e8 9b fe ff ff       	call   802ea2 <syscall>
  803007:	83 c4 18             	add    $0x18,%esp
}
  80300a:	c9                   	leave  
  80300b:	c3                   	ret    

0080300c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80300c:	55                   	push   %ebp
  80300d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80300f:	6a 00                	push   $0x0
  803011:	6a 00                	push   $0x0
  803013:	6a 00                	push   $0x0
  803015:	6a 00                	push   $0x0
  803017:	6a 00                	push   $0x0
  803019:	6a 0f                	push   $0xf
  80301b:	e8 82 fe ff ff       	call   802ea2 <syscall>
  803020:	83 c4 18             	add    $0x18,%esp
}
  803023:	c9                   	leave  
  803024:	c3                   	ret    

00803025 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803025:	55                   	push   %ebp
  803026:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803028:	6a 00                	push   $0x0
  80302a:	6a 00                	push   $0x0
  80302c:	6a 00                	push   $0x0
  80302e:	6a 00                	push   $0x0
  803030:	ff 75 08             	pushl  0x8(%ebp)
  803033:	6a 10                	push   $0x10
  803035:	e8 68 fe ff ff       	call   802ea2 <syscall>
  80303a:	83 c4 18             	add    $0x18,%esp
}
  80303d:	c9                   	leave  
  80303e:	c3                   	ret    

0080303f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80303f:	55                   	push   %ebp
  803040:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803042:	6a 00                	push   $0x0
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	6a 00                	push   $0x0
  80304c:	6a 11                	push   $0x11
  80304e:	e8 4f fe ff ff       	call   802ea2 <syscall>
  803053:	83 c4 18             	add    $0x18,%esp
}
  803056:	90                   	nop
  803057:	c9                   	leave  
  803058:	c3                   	ret    

00803059 <sys_cputc>:

void
sys_cputc(const char c)
{
  803059:	55                   	push   %ebp
  80305a:	89 e5                	mov    %esp,%ebp
  80305c:	83 ec 04             	sub    $0x4,%esp
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803065:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803069:	6a 00                	push   $0x0
  80306b:	6a 00                	push   $0x0
  80306d:	6a 00                	push   $0x0
  80306f:	6a 00                	push   $0x0
  803071:	50                   	push   %eax
  803072:	6a 01                	push   $0x1
  803074:	e8 29 fe ff ff       	call   802ea2 <syscall>
  803079:	83 c4 18             	add    $0x18,%esp
}
  80307c:	90                   	nop
  80307d:	c9                   	leave  
  80307e:	c3                   	ret    

0080307f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80307f:	55                   	push   %ebp
  803080:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803082:	6a 00                	push   $0x0
  803084:	6a 00                	push   $0x0
  803086:	6a 00                	push   $0x0
  803088:	6a 00                	push   $0x0
  80308a:	6a 00                	push   $0x0
  80308c:	6a 14                	push   $0x14
  80308e:	e8 0f fe ff ff       	call   802ea2 <syscall>
  803093:	83 c4 18             	add    $0x18,%esp
}
  803096:	90                   	nop
  803097:	c9                   	leave  
  803098:	c3                   	ret    

00803099 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803099:	55                   	push   %ebp
  80309a:	89 e5                	mov    %esp,%ebp
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	8b 45 10             	mov    0x10(%ebp),%eax
  8030a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8030a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8030a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	6a 00                	push   $0x0
  8030b1:	51                   	push   %ecx
  8030b2:	52                   	push   %edx
  8030b3:	ff 75 0c             	pushl  0xc(%ebp)
  8030b6:	50                   	push   %eax
  8030b7:	6a 15                	push   $0x15
  8030b9:	e8 e4 fd ff ff       	call   802ea2 <syscall>
  8030be:	83 c4 18             	add    $0x18,%esp
}
  8030c1:	c9                   	leave  
  8030c2:	c3                   	ret    

008030c3 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8030c3:	55                   	push   %ebp
  8030c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8030c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	6a 00                	push   $0x0
  8030ce:	6a 00                	push   $0x0
  8030d0:	6a 00                	push   $0x0
  8030d2:	52                   	push   %edx
  8030d3:	50                   	push   %eax
  8030d4:	6a 16                	push   $0x16
  8030d6:	e8 c7 fd ff ff       	call   802ea2 <syscall>
  8030db:	83 c4 18             	add    $0x18,%esp
}
  8030de:	c9                   	leave  
  8030df:	c3                   	ret    

008030e0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8030e0:	55                   	push   %ebp
  8030e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8030e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8030e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	6a 00                	push   $0x0
  8030ee:	6a 00                	push   $0x0
  8030f0:	51                   	push   %ecx
  8030f1:	52                   	push   %edx
  8030f2:	50                   	push   %eax
  8030f3:	6a 17                	push   $0x17
  8030f5:	e8 a8 fd ff ff       	call   802ea2 <syscall>
  8030fa:	83 c4 18             	add    $0x18,%esp
}
  8030fd:	c9                   	leave  
  8030fe:	c3                   	ret    

008030ff <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8030ff:	55                   	push   %ebp
  803100:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803102:	8b 55 0c             	mov    0xc(%ebp),%edx
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	6a 00                	push   $0x0
  80310a:	6a 00                	push   $0x0
  80310c:	6a 00                	push   $0x0
  80310e:	52                   	push   %edx
  80310f:	50                   	push   %eax
  803110:	6a 18                	push   $0x18
  803112:	e8 8b fd ff ff       	call   802ea2 <syscall>
  803117:	83 c4 18             	add    $0x18,%esp
}
  80311a:	c9                   	leave  
  80311b:	c3                   	ret    

0080311c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80311c:	55                   	push   %ebp
  80311d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80311f:	8b 45 08             	mov    0x8(%ebp),%eax
  803122:	6a 00                	push   $0x0
  803124:	ff 75 14             	pushl  0x14(%ebp)
  803127:	ff 75 10             	pushl  0x10(%ebp)
  80312a:	ff 75 0c             	pushl  0xc(%ebp)
  80312d:	50                   	push   %eax
  80312e:	6a 19                	push   $0x19
  803130:	e8 6d fd ff ff       	call   802ea2 <syscall>
  803135:	83 c4 18             	add    $0x18,%esp
}
  803138:	c9                   	leave  
  803139:	c3                   	ret    

0080313a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80313a:	55                   	push   %ebp
  80313b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	6a 00                	push   $0x0
  803142:	6a 00                	push   $0x0
  803144:	6a 00                	push   $0x0
  803146:	6a 00                	push   $0x0
  803148:	50                   	push   %eax
  803149:	6a 1a                	push   $0x1a
  80314b:	e8 52 fd ff ff       	call   802ea2 <syscall>
  803150:	83 c4 18             	add    $0x18,%esp
}
  803153:	90                   	nop
  803154:	c9                   	leave  
  803155:	c3                   	ret    

00803156 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803156:	55                   	push   %ebp
  803157:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	6a 00                	push   $0x0
  80315e:	6a 00                	push   $0x0
  803160:	6a 00                	push   $0x0
  803162:	6a 00                	push   $0x0
  803164:	50                   	push   %eax
  803165:	6a 1b                	push   $0x1b
  803167:	e8 36 fd ff ff       	call   802ea2 <syscall>
  80316c:	83 c4 18             	add    $0x18,%esp
}
  80316f:	c9                   	leave  
  803170:	c3                   	ret    

00803171 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803171:	55                   	push   %ebp
  803172:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	6a 00                	push   $0x0
  80317e:	6a 05                	push   $0x5
  803180:	e8 1d fd ff ff       	call   802ea2 <syscall>
  803185:	83 c4 18             	add    $0x18,%esp
}
  803188:	c9                   	leave  
  803189:	c3                   	ret    

0080318a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80318a:	55                   	push   %ebp
  80318b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80318d:	6a 00                	push   $0x0
  80318f:	6a 00                	push   $0x0
  803191:	6a 00                	push   $0x0
  803193:	6a 00                	push   $0x0
  803195:	6a 00                	push   $0x0
  803197:	6a 06                	push   $0x6
  803199:	e8 04 fd ff ff       	call   802ea2 <syscall>
  80319e:	83 c4 18             	add    $0x18,%esp
}
  8031a1:	c9                   	leave  
  8031a2:	c3                   	ret    

008031a3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8031a3:	55                   	push   %ebp
  8031a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8031a6:	6a 00                	push   $0x0
  8031a8:	6a 00                	push   $0x0
  8031aa:	6a 00                	push   $0x0
  8031ac:	6a 00                	push   $0x0
  8031ae:	6a 00                	push   $0x0
  8031b0:	6a 07                	push   $0x7
  8031b2:	e8 eb fc ff ff       	call   802ea2 <syscall>
  8031b7:	83 c4 18             	add    $0x18,%esp
}
  8031ba:	c9                   	leave  
  8031bb:	c3                   	ret    

008031bc <sys_exit_env>:


void sys_exit_env(void)
{
  8031bc:	55                   	push   %ebp
  8031bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8031bf:	6a 00                	push   $0x0
  8031c1:	6a 00                	push   $0x0
  8031c3:	6a 00                	push   $0x0
  8031c5:	6a 00                	push   $0x0
  8031c7:	6a 00                	push   $0x0
  8031c9:	6a 1c                	push   $0x1c
  8031cb:	e8 d2 fc ff ff       	call   802ea2 <syscall>
  8031d0:	83 c4 18             	add    $0x18,%esp
}
  8031d3:	90                   	nop
  8031d4:	c9                   	leave  
  8031d5:	c3                   	ret    

008031d6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8031d6:	55                   	push   %ebp
  8031d7:	89 e5                	mov    %esp,%ebp
  8031d9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8031dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031df:	8d 50 04             	lea    0x4(%eax),%edx
  8031e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8031e5:	6a 00                	push   $0x0
  8031e7:	6a 00                	push   $0x0
  8031e9:	6a 00                	push   $0x0
  8031eb:	52                   	push   %edx
  8031ec:	50                   	push   %eax
  8031ed:	6a 1d                	push   $0x1d
  8031ef:	e8 ae fc ff ff       	call   802ea2 <syscall>
  8031f4:	83 c4 18             	add    $0x18,%esp
	return result;
  8031f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8031fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8031fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803200:	89 01                	mov    %eax,(%ecx)
  803202:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	c9                   	leave  
  803209:	c2 04 00             	ret    $0x4

0080320c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80320c:	55                   	push   %ebp
  80320d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80320f:	6a 00                	push   $0x0
  803211:	6a 00                	push   $0x0
  803213:	ff 75 10             	pushl  0x10(%ebp)
  803216:	ff 75 0c             	pushl  0xc(%ebp)
  803219:	ff 75 08             	pushl  0x8(%ebp)
  80321c:	6a 13                	push   $0x13
  80321e:	e8 7f fc ff ff       	call   802ea2 <syscall>
  803223:	83 c4 18             	add    $0x18,%esp
	return ;
  803226:	90                   	nop
}
  803227:	c9                   	leave  
  803228:	c3                   	ret    

00803229 <sys_rcr2>:
uint32 sys_rcr2()
{
  803229:	55                   	push   %ebp
  80322a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80322c:	6a 00                	push   $0x0
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	6a 00                	push   $0x0
  803234:	6a 00                	push   $0x0
  803236:	6a 1e                	push   $0x1e
  803238:	e8 65 fc ff ff       	call   802ea2 <syscall>
  80323d:	83 c4 18             	add    $0x18,%esp
}
  803240:	c9                   	leave  
  803241:	c3                   	ret    

00803242 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803242:	55                   	push   %ebp
  803243:	89 e5                	mov    %esp,%ebp
  803245:	83 ec 04             	sub    $0x4,%esp
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80324e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803252:	6a 00                	push   $0x0
  803254:	6a 00                	push   $0x0
  803256:	6a 00                	push   $0x0
  803258:	6a 00                	push   $0x0
  80325a:	50                   	push   %eax
  80325b:	6a 1f                	push   $0x1f
  80325d:	e8 40 fc ff ff       	call   802ea2 <syscall>
  803262:	83 c4 18             	add    $0x18,%esp
	return ;
  803265:	90                   	nop
}
  803266:	c9                   	leave  
  803267:	c3                   	ret    

00803268 <rsttst>:
void rsttst()
{
  803268:	55                   	push   %ebp
  803269:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80326b:	6a 00                	push   $0x0
  80326d:	6a 00                	push   $0x0
  80326f:	6a 00                	push   $0x0
  803271:	6a 00                	push   $0x0
  803273:	6a 00                	push   $0x0
  803275:	6a 21                	push   $0x21
  803277:	e8 26 fc ff ff       	call   802ea2 <syscall>
  80327c:	83 c4 18             	add    $0x18,%esp
	return ;
  80327f:	90                   	nop
}
  803280:	c9                   	leave  
  803281:	c3                   	ret    

00803282 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803282:	55                   	push   %ebp
  803283:	89 e5                	mov    %esp,%ebp
  803285:	83 ec 04             	sub    $0x4,%esp
  803288:	8b 45 14             	mov    0x14(%ebp),%eax
  80328b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80328e:	8b 55 18             	mov    0x18(%ebp),%edx
  803291:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803295:	52                   	push   %edx
  803296:	50                   	push   %eax
  803297:	ff 75 10             	pushl  0x10(%ebp)
  80329a:	ff 75 0c             	pushl  0xc(%ebp)
  80329d:	ff 75 08             	pushl  0x8(%ebp)
  8032a0:	6a 20                	push   $0x20
  8032a2:	e8 fb fb ff ff       	call   802ea2 <syscall>
  8032a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8032aa:	90                   	nop
}
  8032ab:	c9                   	leave  
  8032ac:	c3                   	ret    

008032ad <chktst>:
void chktst(uint32 n)
{
  8032ad:	55                   	push   %ebp
  8032ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8032b0:	6a 00                	push   $0x0
  8032b2:	6a 00                	push   $0x0
  8032b4:	6a 00                	push   $0x0
  8032b6:	6a 00                	push   $0x0
  8032b8:	ff 75 08             	pushl  0x8(%ebp)
  8032bb:	6a 22                	push   $0x22
  8032bd:	e8 e0 fb ff ff       	call   802ea2 <syscall>
  8032c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8032c5:	90                   	nop
}
  8032c6:	c9                   	leave  
  8032c7:	c3                   	ret    

008032c8 <inctst>:

void inctst()
{
  8032c8:	55                   	push   %ebp
  8032c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8032cb:	6a 00                	push   $0x0
  8032cd:	6a 00                	push   $0x0
  8032cf:	6a 00                	push   $0x0
  8032d1:	6a 00                	push   $0x0
  8032d3:	6a 00                	push   $0x0
  8032d5:	6a 23                	push   $0x23
  8032d7:	e8 c6 fb ff ff       	call   802ea2 <syscall>
  8032dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8032df:	90                   	nop
}
  8032e0:	c9                   	leave  
  8032e1:	c3                   	ret    

008032e2 <gettst>:
uint32 gettst()
{
  8032e2:	55                   	push   %ebp
  8032e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8032e5:	6a 00                	push   $0x0
  8032e7:	6a 00                	push   $0x0
  8032e9:	6a 00                	push   $0x0
  8032eb:	6a 00                	push   $0x0
  8032ed:	6a 00                	push   $0x0
  8032ef:	6a 24                	push   $0x24
  8032f1:	e8 ac fb ff ff       	call   802ea2 <syscall>
  8032f6:	83 c4 18             	add    $0x18,%esp
}
  8032f9:	c9                   	leave  
  8032fa:	c3                   	ret    

008032fb <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8032fb:	55                   	push   %ebp
  8032fc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032fe:	6a 00                	push   $0x0
  803300:	6a 00                	push   $0x0
  803302:	6a 00                	push   $0x0
  803304:	6a 00                	push   $0x0
  803306:	6a 00                	push   $0x0
  803308:	6a 25                	push   $0x25
  80330a:	e8 93 fb ff ff       	call   802ea2 <syscall>
  80330f:	83 c4 18             	add    $0x18,%esp
  803312:	a3 20 6b 89 00       	mov    %eax,0x896b20
	return uheapPlaceStrategy ;
  803317:	a1 20 6b 89 00       	mov    0x896b20,%eax
}
  80331c:	c9                   	leave  
  80331d:	c3                   	ret    

0080331e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80331e:	55                   	push   %ebp
  80331f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803321:	8b 45 08             	mov    0x8(%ebp),%eax
  803324:	a3 20 6b 89 00       	mov    %eax,0x896b20
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803329:	6a 00                	push   $0x0
  80332b:	6a 00                	push   $0x0
  80332d:	6a 00                	push   $0x0
  80332f:	6a 00                	push   $0x0
  803331:	ff 75 08             	pushl  0x8(%ebp)
  803334:	6a 26                	push   $0x26
  803336:	e8 67 fb ff ff       	call   802ea2 <syscall>
  80333b:	83 c4 18             	add    $0x18,%esp
	return ;
  80333e:	90                   	nop
}
  80333f:	c9                   	leave  
  803340:	c3                   	ret    

00803341 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803341:	55                   	push   %ebp
  803342:	89 e5                	mov    %esp,%ebp
  803344:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803345:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803348:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80334b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80334e:	8b 45 08             	mov    0x8(%ebp),%eax
  803351:	6a 00                	push   $0x0
  803353:	53                   	push   %ebx
  803354:	51                   	push   %ecx
  803355:	52                   	push   %edx
  803356:	50                   	push   %eax
  803357:	6a 27                	push   $0x27
  803359:	e8 44 fb ff ff       	call   802ea2 <syscall>
  80335e:	83 c4 18             	add    $0x18,%esp
}
  803361:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803364:	c9                   	leave  
  803365:	c3                   	ret    

00803366 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803366:	55                   	push   %ebp
  803367:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	6a 00                	push   $0x0
  803371:	6a 00                	push   $0x0
  803373:	6a 00                	push   $0x0
  803375:	52                   	push   %edx
  803376:	50                   	push   %eax
  803377:	6a 28                	push   $0x28
  803379:	e8 24 fb ff ff       	call   802ea2 <syscall>
  80337e:	83 c4 18             	add    $0x18,%esp
}
  803381:	c9                   	leave  
  803382:	c3                   	ret    

00803383 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803383:	55                   	push   %ebp
  803384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803386:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	6a 00                	push   $0x0
  803391:	51                   	push   %ecx
  803392:	ff 75 10             	pushl  0x10(%ebp)
  803395:	52                   	push   %edx
  803396:	50                   	push   %eax
  803397:	6a 29                	push   $0x29
  803399:	e8 04 fb ff ff       	call   802ea2 <syscall>
  80339e:	83 c4 18             	add    $0x18,%esp
}
  8033a1:	c9                   	leave  
  8033a2:	c3                   	ret    

008033a3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8033a3:	55                   	push   %ebp
  8033a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8033a6:	6a 00                	push   $0x0
  8033a8:	6a 00                	push   $0x0
  8033aa:	ff 75 10             	pushl  0x10(%ebp)
  8033ad:	ff 75 0c             	pushl  0xc(%ebp)
  8033b0:	ff 75 08             	pushl  0x8(%ebp)
  8033b3:	6a 12                	push   $0x12
  8033b5:	e8 e8 fa ff ff       	call   802ea2 <syscall>
  8033ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8033bd:	90                   	nop
}
  8033be:	c9                   	leave  
  8033bf:	c3                   	ret    

008033c0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8033c0:	55                   	push   %ebp
  8033c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8033c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	6a 00                	push   $0x0
  8033cb:	6a 00                	push   $0x0
  8033cd:	6a 00                	push   $0x0
  8033cf:	52                   	push   %edx
  8033d0:	50                   	push   %eax
  8033d1:	6a 2a                	push   $0x2a
  8033d3:	e8 ca fa ff ff       	call   802ea2 <syscall>
  8033d8:	83 c4 18             	add    $0x18,%esp
	return;
  8033db:	90                   	nop
}
  8033dc:	c9                   	leave  
  8033dd:	c3                   	ret    

008033de <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8033de:	55                   	push   %ebp
  8033df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8033e1:	6a 00                	push   $0x0
  8033e3:	6a 00                	push   $0x0
  8033e5:	6a 00                	push   $0x0
  8033e7:	6a 00                	push   $0x0
  8033e9:	6a 00                	push   $0x0
  8033eb:	6a 2b                	push   $0x2b
  8033ed:	e8 b0 fa ff ff       	call   802ea2 <syscall>
  8033f2:	83 c4 18             	add    $0x18,%esp
}
  8033f5:	c9                   	leave  
  8033f6:	c3                   	ret    

008033f7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8033f7:	55                   	push   %ebp
  8033f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8033fa:	6a 00                	push   $0x0
  8033fc:	6a 00                	push   $0x0
  8033fe:	6a 00                	push   $0x0
  803400:	ff 75 0c             	pushl  0xc(%ebp)
  803403:	ff 75 08             	pushl  0x8(%ebp)
  803406:	6a 2d                	push   $0x2d
  803408:	e8 95 fa ff ff       	call   802ea2 <syscall>
  80340d:	83 c4 18             	add    $0x18,%esp
	return;
  803410:	90                   	nop
}
  803411:	c9                   	leave  
  803412:	c3                   	ret    

00803413 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803413:	55                   	push   %ebp
  803414:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803416:	6a 00                	push   $0x0
  803418:	6a 00                	push   $0x0
  80341a:	6a 00                	push   $0x0
  80341c:	ff 75 0c             	pushl  0xc(%ebp)
  80341f:	ff 75 08             	pushl  0x8(%ebp)
  803422:	6a 2c                	push   $0x2c
  803424:	e8 79 fa ff ff       	call   802ea2 <syscall>
  803429:	83 c4 18             	add    $0x18,%esp
	return ;
  80342c:	90                   	nop
}
  80342d:	c9                   	leave  
  80342e:	c3                   	ret    

0080342f <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80342f:	55                   	push   %ebp
  803430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803432:	8b 55 0c             	mov    0xc(%ebp),%edx
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	6a 00                	push   $0x0
  80343a:	6a 00                	push   $0x0
  80343c:	6a 00                	push   $0x0
  80343e:	52                   	push   %edx
  80343f:	50                   	push   %eax
  803440:	6a 2e                	push   $0x2e
  803442:	e8 5b fa ff ff       	call   802ea2 <syscall>
  803447:	83 c4 18             	add    $0x18,%esp
}
  80344a:	90                   	nop
  80344b:	c9                   	leave  
  80344c:	c3                   	ret    

0080344d <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80344d:	55                   	push   %ebp
  80344e:	89 e5                	mov    %esp,%ebp
  803450:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803453:	81 7d 08 20 eb 87 00 	cmpl   $0x87eb20,0x8(%ebp)
  80345a:	72 09                	jb     803465 <to_page_va+0x18>
  80345c:	81 7d 08 20 6b 89 00 	cmpl   $0x896b20,0x8(%ebp)
  803463:	72 14                	jb     803479 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803465:	83 ec 04             	sub    $0x4,%esp
  803468:	68 38 4a 80 00       	push   $0x804a38
  80346d:	6a 15                	push   $0x15
  80346f:	68 63 4a 80 00       	push   $0x804a63
  803474:	e8 db 0a 00 00       	call   803f54 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	ba 20 eb 87 00       	mov    $0x87eb20,%edx
  803481:	29 d0                	sub    %edx,%eax
  803483:	c1 f8 02             	sar    $0x2,%eax
  803486:	89 c2                	mov    %eax,%edx
  803488:	89 d0                	mov    %edx,%eax
  80348a:	c1 e0 02             	shl    $0x2,%eax
  80348d:	01 d0                	add    %edx,%eax
  80348f:	c1 e0 02             	shl    $0x2,%eax
  803492:	01 d0                	add    %edx,%eax
  803494:	c1 e0 02             	shl    $0x2,%eax
  803497:	01 d0                	add    %edx,%eax
  803499:	89 c1                	mov    %eax,%ecx
  80349b:	c1 e1 08             	shl    $0x8,%ecx
  80349e:	01 c8                	add    %ecx,%eax
  8034a0:	89 c1                	mov    %eax,%ecx
  8034a2:	c1 e1 10             	shl    $0x10,%ecx
  8034a5:	01 c8                	add    %ecx,%eax
  8034a7:	01 c0                	add    %eax,%eax
  8034a9:	01 d0                	add    %edx,%eax
  8034ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8034ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b1:	c1 e0 0c             	shl    $0xc,%eax
  8034b4:	89 c2                	mov    %eax,%edx
  8034b6:	a1 24 6b 89 00       	mov    0x896b24,%eax
  8034bb:	01 d0                	add    %edx,%eax
}
  8034bd:	c9                   	leave  
  8034be:	c3                   	ret    

008034bf <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8034bf:	55                   	push   %ebp
  8034c0:	89 e5                	mov    %esp,%ebp
  8034c2:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8034c5:	a1 24 6b 89 00       	mov    0x896b24,%eax
  8034ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cd:	29 c2                	sub    %eax,%edx
  8034cf:	89 d0                	mov    %edx,%eax
  8034d1:	c1 e8 0c             	shr    $0xc,%eax
  8034d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8034d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034db:	78 09                	js     8034e6 <to_page_info+0x27>
  8034dd:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8034e4:	7e 14                	jle    8034fa <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8034e6:	83 ec 04             	sub    $0x4,%esp
  8034e9:	68 7c 4a 80 00       	push   $0x804a7c
  8034ee:	6a 21                	push   $0x21
  8034f0:	68 63 4a 80 00       	push   $0x804a63
  8034f5:	e8 5a 0a 00 00       	call   803f54 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8034fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034fd:	89 d0                	mov    %edx,%eax
  8034ff:	01 c0                	add    %eax,%eax
  803501:	01 d0                	add    %edx,%eax
  803503:	c1 e0 02             	shl    $0x2,%eax
  803506:	05 20 eb 87 00       	add    $0x87eb20,%eax
}
  80350b:	c9                   	leave  
  80350c:	c3                   	ret    

0080350d <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80350d:	55                   	push   %ebp
  80350e:	89 e5                	mov    %esp,%ebp
  803510:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	05 00 00 00 02       	add    $0x2000000,%eax
  80351b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80351e:	73 16                	jae    803536 <initialize_dynamic_allocator+0x29>
  803520:	68 a0 4a 80 00       	push   $0x804aa0
  803525:	68 c6 4a 80 00       	push   $0x804ac6
  80352a:	6a 2f                	push   $0x2f
  80352c:	68 63 4a 80 00       	push   $0x804a63
  803531:	e8 1e 0a 00 00       	call   803f54 <_panic>
	dynAllocStart = daStart;
  803536:	8b 45 08             	mov    0x8(%ebp),%eax
  803539:	a3 24 6b 89 00       	mov    %eax,0x896b24
	dynAllocEnd = daEnd;
  80353e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803541:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803546:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80354d:	eb 36                	jmp    803585 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  80354f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803552:	c1 e0 04             	shl    $0x4,%eax
  803555:	05 40 6b 89 00       	add    $0x896b40,%eax
  80355a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	c1 e0 04             	shl    $0x4,%eax
  803566:	05 44 6b 89 00       	add    $0x896b44,%eax
  80356b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803574:	c1 e0 04             	shl    $0x4,%eax
  803577:	05 4c 6b 89 00       	add    $0x896b4c,%eax
  80357c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803582:	ff 45 f4             	incl   -0xc(%ebp)
  803585:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803589:	7e c4                	jle    80354f <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  80358b:	c7 05 04 eb 87 00 00 	movl   $0x0,0x87eb04
  803592:	00 00 00 
  803595:	c7 05 08 eb 87 00 00 	movl   $0x0,0x87eb08
  80359c:	00 00 00 
  80359f:	c7 05 10 eb 87 00 00 	movl   $0x0,0x87eb10
  8035a6:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8035a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035b0:	e9 1b 01 00 00       	jmp    8036d0 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8035b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b8:	89 d0                	mov    %edx,%eax
  8035ba:	01 c0                	add    %eax,%eax
  8035bc:	01 d0                	add    %edx,%eax
  8035be:	c1 e0 02             	shl    $0x2,%eax
  8035c1:	05 28 eb 87 00       	add    $0x87eb28,%eax
  8035c6:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8035cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ce:	89 d0                	mov    %edx,%eax
  8035d0:	01 c0                	add    %eax,%eax
  8035d2:	01 d0                	add    %edx,%eax
  8035d4:	c1 e0 02             	shl    $0x2,%eax
  8035d7:	05 2a eb 87 00       	add    $0x87eb2a,%eax
  8035dc:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8035e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035e4:	89 d0                	mov    %edx,%eax
  8035e6:	01 c0                	add    %eax,%eax
  8035e8:	01 d0                	add    %edx,%eax
  8035ea:	c1 e0 02             	shl    $0x2,%eax
  8035ed:	05 20 eb 87 00       	add    $0x87eb20,%eax
  8035f2:	8b 00                	mov    (%eax),%eax
  8035f4:	85 c0                	test   %eax,%eax
  8035f6:	74 2b                	je     803623 <initialize_dynamic_allocator+0x116>
  8035f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035fb:	89 d0                	mov    %edx,%eax
  8035fd:	01 c0                	add    %eax,%eax
  8035ff:	01 d0                	add    %edx,%eax
  803601:	c1 e0 02             	shl    $0x2,%eax
  803604:	05 20 eb 87 00       	add    $0x87eb20,%eax
  803609:	8b 10                	mov    (%eax),%edx
  80360b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80360e:	89 c8                	mov    %ecx,%eax
  803610:	01 c0                	add    %eax,%eax
  803612:	01 c8                	add    %ecx,%eax
  803614:	c1 e0 02             	shl    $0x2,%eax
  803617:	05 24 eb 87 00       	add    $0x87eb24,%eax
  80361c:	8b 00                	mov    (%eax),%eax
  80361e:	89 42 04             	mov    %eax,0x4(%edx)
  803621:	eb 18                	jmp    80363b <initialize_dynamic_allocator+0x12e>
  803623:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803626:	89 d0                	mov    %edx,%eax
  803628:	01 c0                	add    %eax,%eax
  80362a:	01 d0                	add    %edx,%eax
  80362c:	c1 e0 02             	shl    $0x2,%eax
  80362f:	05 24 eb 87 00       	add    $0x87eb24,%eax
  803634:	8b 00                	mov    (%eax),%eax
  803636:	a3 08 eb 87 00       	mov    %eax,0x87eb08
  80363b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80363e:	89 d0                	mov    %edx,%eax
  803640:	01 c0                	add    %eax,%eax
  803642:	01 d0                	add    %edx,%eax
  803644:	c1 e0 02             	shl    $0x2,%eax
  803647:	05 24 eb 87 00       	add    $0x87eb24,%eax
  80364c:	8b 00                	mov    (%eax),%eax
  80364e:	85 c0                	test   %eax,%eax
  803650:	74 2a                	je     80367c <initialize_dynamic_allocator+0x16f>
  803652:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803655:	89 d0                	mov    %edx,%eax
  803657:	01 c0                	add    %eax,%eax
  803659:	01 d0                	add    %edx,%eax
  80365b:	c1 e0 02             	shl    $0x2,%eax
  80365e:	05 24 eb 87 00       	add    $0x87eb24,%eax
  803663:	8b 10                	mov    (%eax),%edx
  803665:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803668:	89 c8                	mov    %ecx,%eax
  80366a:	01 c0                	add    %eax,%eax
  80366c:	01 c8                	add    %ecx,%eax
  80366e:	c1 e0 02             	shl    $0x2,%eax
  803671:	05 20 eb 87 00       	add    $0x87eb20,%eax
  803676:	8b 00                	mov    (%eax),%eax
  803678:	89 02                	mov    %eax,(%edx)
  80367a:	eb 18                	jmp    803694 <initialize_dynamic_allocator+0x187>
  80367c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80367f:	89 d0                	mov    %edx,%eax
  803681:	01 c0                	add    %eax,%eax
  803683:	01 d0                	add    %edx,%eax
  803685:	c1 e0 02             	shl    $0x2,%eax
  803688:	05 20 eb 87 00       	add    $0x87eb20,%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	a3 04 eb 87 00       	mov    %eax,0x87eb04
  803694:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803697:	89 d0                	mov    %edx,%eax
  803699:	01 c0                	add    %eax,%eax
  80369b:	01 d0                	add    %edx,%eax
  80369d:	c1 e0 02             	shl    $0x2,%eax
  8036a0:	05 20 eb 87 00       	add    $0x87eb20,%eax
  8036a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ae:	89 d0                	mov    %edx,%eax
  8036b0:	01 c0                	add    %eax,%eax
  8036b2:	01 d0                	add    %edx,%eax
  8036b4:	c1 e0 02             	shl    $0x2,%eax
  8036b7:	05 24 eb 87 00       	add    $0x87eb24,%eax
  8036bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c2:	a1 10 eb 87 00       	mov    0x87eb10,%eax
  8036c7:	48                   	dec    %eax
  8036c8:	a3 10 eb 87 00       	mov    %eax,0x87eb10

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8036cd:	ff 45 f0             	incl   -0x10(%ebp)
  8036d0:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8036d7:	0f 8e d8 fe ff ff    	jle    8035b5 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8036dd:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8036e4:	e9 9d 00 00 00       	jmp    803786 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8036e9:	8b 15 04 eb 87 00    	mov    0x87eb04,%edx
  8036ef:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8036f2:	89 c8                	mov    %ecx,%eax
  8036f4:	01 c0                	add    %eax,%eax
  8036f6:	01 c8                	add    %ecx,%eax
  8036f8:	c1 e0 02             	shl    $0x2,%eax
  8036fb:	05 20 eb 87 00       	add    $0x87eb20,%eax
  803700:	89 10                	mov    %edx,(%eax)
  803702:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803705:	89 d0                	mov    %edx,%eax
  803707:	01 c0                	add    %eax,%eax
  803709:	01 d0                	add    %edx,%eax
  80370b:	c1 e0 02             	shl    $0x2,%eax
  80370e:	05 20 eb 87 00       	add    $0x87eb20,%eax
  803713:	8b 00                	mov    (%eax),%eax
  803715:	85 c0                	test   %eax,%eax
  803717:	74 1c                	je     803735 <initialize_dynamic_allocator+0x228>
  803719:	8b 15 04 eb 87 00    	mov    0x87eb04,%edx
  80371f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803722:	89 c8                	mov    %ecx,%eax
  803724:	01 c0                	add    %eax,%eax
  803726:	01 c8                	add    %ecx,%eax
  803728:	c1 e0 02             	shl    $0x2,%eax
  80372b:	05 20 eb 87 00       	add    $0x87eb20,%eax
  803730:	89 42 04             	mov    %eax,0x4(%edx)
  803733:	eb 16                	jmp    80374b <initialize_dynamic_allocator+0x23e>
  803735:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803738:	89 d0                	mov    %edx,%eax
  80373a:	01 c0                	add    %eax,%eax
  80373c:	01 d0                	add    %edx,%eax
  80373e:	c1 e0 02             	shl    $0x2,%eax
  803741:	05 20 eb 87 00       	add    $0x87eb20,%eax
  803746:	a3 08 eb 87 00       	mov    %eax,0x87eb08
  80374b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80374e:	89 d0                	mov    %edx,%eax
  803750:	01 c0                	add    %eax,%eax
  803752:	01 d0                	add    %edx,%eax
  803754:	c1 e0 02             	shl    $0x2,%eax
  803757:	05 20 eb 87 00       	add    $0x87eb20,%eax
  80375c:	a3 04 eb 87 00       	mov    %eax,0x87eb04
  803761:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803764:	89 d0                	mov    %edx,%eax
  803766:	01 c0                	add    %eax,%eax
  803768:	01 d0                	add    %edx,%eax
  80376a:	c1 e0 02             	shl    $0x2,%eax
  80376d:	05 24 eb 87 00       	add    $0x87eb24,%eax
  803772:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803778:	a1 10 eb 87 00       	mov    0x87eb10,%eax
  80377d:	40                   	inc    %eax
  80377e:	a3 10 eb 87 00       	mov    %eax,0x87eb10
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803783:	ff 4d ec             	decl   -0x14(%ebp)
  803786:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80378a:	0f 89 59 ff ff ff    	jns    8036e9 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803790:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  803797:	00 00 00 
}
  80379a:	90                   	nop
  80379b:	c9                   	leave  
  80379c:	c3                   	ret    

0080379d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80379d:	55                   	push   %ebp
  80379e:	89 e5                	mov    %esp,%ebp
  8037a0:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8037a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a6:	83 ec 0c             	sub    $0xc,%esp
  8037a9:	50                   	push   %eax
  8037aa:	e8 10 fd ff ff       	call   8034bf <to_page_info>
  8037af:	83 c4 10             	add    $0x10,%esp
  8037b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8037b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b8:	8b 40 08             	mov    0x8(%eax),%eax
  8037bb:	0f b7 c0             	movzwl %ax,%eax
}
  8037be:	c9                   	leave  
  8037bf:	c3                   	ret    

008037c0 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8037c0:	55                   	push   %ebp
  8037c1:	89 e5                	mov    %esp,%ebp
  8037c3:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037c6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8037cd:	76 16                	jbe    8037e5 <alloc_block+0x25>
  8037cf:	68 dc 4a 80 00       	push   $0x804adc
  8037d4:	68 c6 4a 80 00       	push   $0x804ac6
  8037d9:	6a 59                	push   $0x59
  8037db:	68 63 4a 80 00       	push   $0x804a63
  8037e0:	e8 6f 07 00 00       	call   803f54 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8037e5:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037ec:	eb 08                	jmp    8037f6 <alloc_block+0x36>
		allocSize <<= 1;
  8037ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f1:	01 c0                	add    %eax,%eax
  8037f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8037f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037fc:	73 09                	jae    803807 <alloc_block+0x47>
  8037fe:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803805:	76 e7                	jbe    8037ee <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803807:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80380e:	eb 03                	jmp    803813 <alloc_block+0x53>
		listIndex++;
  803810:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803816:	ba 08 00 00 00       	mov    $0x8,%edx
  80381b:	88 c1                	mov    %al,%cl
  80381d:	d3 e2                	shl    %cl,%edx
  80381f:	89 d0                	mov    %edx,%eax
  803821:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803824:	72 ea                	jb     803810 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803829:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80382c:	e9 f4 00 00 00       	jmp    803925 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803834:	c1 e0 04             	shl    $0x4,%eax
  803837:	05 40 6b 89 00       	add    $0x896b40,%eax
  80383c:	8b 00                	mov    (%eax),%eax
  80383e:	85 c0                	test   %eax,%eax
  803840:	0f 84 dc 00 00 00    	je     803922 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803846:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803849:	c1 e0 04             	shl    $0x4,%eax
  80384c:	05 40 6b 89 00       	add    $0x896b40,%eax
  803851:	8b 00                	mov    (%eax),%eax
  803853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803856:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80385a:	75 14                	jne    803870 <alloc_block+0xb0>
  80385c:	83 ec 04             	sub    $0x4,%esp
  80385f:	68 fd 4a 80 00       	push   $0x804afd
  803864:	6a 6b                	push   $0x6b
  803866:	68 63 4a 80 00       	push   $0x804a63
  80386b:	e8 e4 06 00 00       	call   803f54 <_panic>
  803870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803873:	8b 00                	mov    (%eax),%eax
  803875:	85 c0                	test   %eax,%eax
  803877:	74 10                	je     803889 <alloc_block+0xc9>
  803879:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387c:	8b 00                	mov    (%eax),%eax
  80387e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803881:	8b 52 04             	mov    0x4(%edx),%edx
  803884:	89 50 04             	mov    %edx,0x4(%eax)
  803887:	eb 14                	jmp    80389d <alloc_block+0xdd>
  803889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388c:	8b 40 04             	mov    0x4(%eax),%eax
  80388f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803892:	c1 e2 04             	shl    $0x4,%edx
  803895:	81 c2 44 6b 89 00    	add    $0x896b44,%edx
  80389b:	89 02                	mov    %eax,(%edx)
  80389d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a0:	8b 40 04             	mov    0x4(%eax),%eax
  8038a3:	85 c0                	test   %eax,%eax
  8038a5:	74 0f                	je     8038b6 <alloc_block+0xf6>
  8038a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038aa:	8b 40 04             	mov    0x4(%eax),%eax
  8038ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b0:	8b 12                	mov    (%edx),%edx
  8038b2:	89 10                	mov    %edx,(%eax)
  8038b4:	eb 13                	jmp    8038c9 <alloc_block+0x109>
  8038b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b9:	8b 00                	mov    (%eax),%eax
  8038bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038be:	c1 e2 04             	shl    $0x4,%edx
  8038c1:	81 c2 40 6b 89 00    	add    $0x896b40,%edx
  8038c7:	89 02                	mov    %eax,(%edx)
  8038c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038df:	c1 e0 04             	shl    $0x4,%eax
  8038e2:	05 4c 6b 89 00       	add    $0x896b4c,%eax
  8038e7:	8b 00                	mov    (%eax),%eax
  8038e9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8038ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ef:	c1 e0 04             	shl    $0x4,%eax
  8038f2:	05 4c 6b 89 00       	add    $0x896b4c,%eax
  8038f7:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8038f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fc:	83 ec 0c             	sub    $0xc,%esp
  8038ff:	50                   	push   %eax
  803900:	e8 ba fb ff ff       	call   8034bf <to_page_info>
  803905:	83 c4 10             	add    $0x10,%esp
  803908:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  80390b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80390e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803912:	48                   	dec    %eax
  803913:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803916:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  80391a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391d:	e9 8f 02 00 00       	jmp    803bb1 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803922:	ff 45 ec             	incl   -0x14(%ebp)
  803925:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803929:	0f 8e 02 ff ff ff    	jle    803831 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  80392f:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  803934:	85 c0                	test   %eax,%eax
  803936:	75 14                	jne    80394c <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803938:	83 ec 04             	sub    $0x4,%esp
  80393b:	68 1c 4b 80 00       	push   $0x804b1c
  803940:	6a 77                	push   $0x77
  803942:	68 63 4a 80 00       	push   $0x804a63
  803947:	e8 08 06 00 00       	call   803f54 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  80394c:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  803951:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803954:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803958:	75 14                	jne    80396e <alloc_block+0x1ae>
  80395a:	83 ec 04             	sub    $0x4,%esp
  80395d:	68 fd 4a 80 00       	push   $0x804afd
  803962:	6a 7a                	push   $0x7a
  803964:	68 63 4a 80 00       	push   $0x804a63
  803969:	e8 e6 05 00 00       	call   803f54 <_panic>
  80396e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803971:	8b 00                	mov    (%eax),%eax
  803973:	85 c0                	test   %eax,%eax
  803975:	74 10                	je     803987 <alloc_block+0x1c7>
  803977:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397a:	8b 00                	mov    (%eax),%eax
  80397c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80397f:	8b 52 04             	mov    0x4(%edx),%edx
  803982:	89 50 04             	mov    %edx,0x4(%eax)
  803985:	eb 0b                	jmp    803992 <alloc_block+0x1d2>
  803987:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398a:	8b 40 04             	mov    0x4(%eax),%eax
  80398d:	a3 08 eb 87 00       	mov    %eax,0x87eb08
  803992:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803995:	8b 40 04             	mov    0x4(%eax),%eax
  803998:	85 c0                	test   %eax,%eax
  80399a:	74 0f                	je     8039ab <alloc_block+0x1eb>
  80399c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399f:	8b 40 04             	mov    0x4(%eax),%eax
  8039a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039a5:	8b 12                	mov    (%edx),%edx
  8039a7:	89 10                	mov    %edx,(%eax)
  8039a9:	eb 0a                	jmp    8039b5 <alloc_block+0x1f5>
  8039ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039ae:	8b 00                	mov    (%eax),%eax
  8039b0:	a3 04 eb 87 00       	mov    %eax,0x87eb04
  8039b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c8:	a1 10 eb 87 00       	mov    0x87eb10,%eax
  8039cd:	48                   	dec    %eax
  8039ce:	a3 10 eb 87 00       	mov    %eax,0x87eb10

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8039d3:	83 ec 0c             	sub    $0xc,%esp
  8039d6:	ff 75 dc             	pushl  -0x24(%ebp)
  8039d9:	e8 6f fa ff ff       	call   80344d <to_page_va>
  8039de:	83 c4 10             	add    $0x10,%esp
  8039e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8039e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039e7:	83 ec 0c             	sub    $0xc,%esp
  8039ea:	50                   	push   %eax
  8039eb:	e8 a0 dc ff ff       	call   801690 <get_page>
  8039f0:	83 c4 10             	add    $0x10,%esp
  8039f3:	85 c0                	test   %eax,%eax
  8039f5:	74 14                	je     803a0b <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8039f7:	83 ec 04             	sub    $0x4,%esp
  8039fa:	68 44 4b 80 00       	push   $0x804b44
  8039ff:	6a 7f                	push   $0x7f
  803a01:	68 63 4a 80 00       	push   $0x804a63
  803a06:	e8 49 05 00 00       	call   803f54 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a11:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803a15:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a1a:	ba 00 00 00 00       	mov    $0x0,%edx
  803a1f:	f7 75 f4             	divl   -0xc(%ebp)
  803a22:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a25:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a29:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a30:	e9 a7 00 00 00       	jmp    803adc <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803a35:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3b:	01 d0                	add    %edx,%eax
  803a3d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803a40:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a44:	75 17                	jne    803a5d <alloc_block+0x29d>
  803a46:	83 ec 04             	sub    $0x4,%esp
  803a49:	68 6c 4b 80 00       	push   $0x804b6c
  803a4e:	68 88 00 00 00       	push   $0x88
  803a53:	68 63 4a 80 00       	push   $0x804a63
  803a58:	e8 f7 04 00 00       	call   803f54 <_panic>
  803a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a60:	c1 e0 04             	shl    $0x4,%eax
  803a63:	05 40 6b 89 00       	add    $0x896b40,%eax
  803a68:	8b 10                	mov    (%eax),%edx
  803a6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a6d:	89 10                	mov    %edx,(%eax)
  803a6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a72:	8b 00                	mov    (%eax),%eax
  803a74:	85 c0                	test   %eax,%eax
  803a76:	74 15                	je     803a8d <alloc_block+0x2cd>
  803a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a7b:	c1 e0 04             	shl    $0x4,%eax
  803a7e:	05 40 6b 89 00       	add    $0x896b40,%eax
  803a83:	8b 00                	mov    (%eax),%eax
  803a85:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a88:	89 50 04             	mov    %edx,0x4(%eax)
  803a8b:	eb 11                	jmp    803a9e <alloc_block+0x2de>
  803a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a90:	c1 e0 04             	shl    $0x4,%eax
  803a93:	8d 90 44 6b 89 00    	lea    0x896b44(%eax),%edx
  803a99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a9c:	89 02                	mov    %eax,(%edx)
  803a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa1:	c1 e0 04             	shl    $0x4,%eax
  803aa4:	8d 90 40 6b 89 00    	lea    0x896b40(%eax),%edx
  803aaa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aad:	89 02                	mov    %eax,(%edx)
  803aaf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803abc:	c1 e0 04             	shl    $0x4,%eax
  803abf:	05 4c 6b 89 00       	add    $0x896b4c,%eax
  803ac4:	8b 00                	mov    (%eax),%eax
  803ac6:	8d 50 01             	lea    0x1(%eax),%edx
  803ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803acc:	c1 e0 04             	shl    $0x4,%eax
  803acf:	05 4c 6b 89 00       	add    $0x896b4c,%eax
  803ad4:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad9:	01 45 e8             	add    %eax,-0x18(%ebp)
  803adc:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803ae3:	0f 86 4c ff ff ff    	jbe    803a35 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aec:	c1 e0 04             	shl    $0x4,%eax
  803aef:	05 40 6b 89 00       	add    $0x896b40,%eax
  803af4:	8b 00                	mov    (%eax),%eax
  803af6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803af9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803afd:	75 17                	jne    803b16 <alloc_block+0x356>
  803aff:	83 ec 04             	sub    $0x4,%esp
  803b02:	68 fd 4a 80 00       	push   $0x804afd
  803b07:	68 8d 00 00 00       	push   $0x8d
  803b0c:	68 63 4a 80 00       	push   $0x804a63
  803b11:	e8 3e 04 00 00       	call   803f54 <_panic>
  803b16:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b19:	8b 00                	mov    (%eax),%eax
  803b1b:	85 c0                	test   %eax,%eax
  803b1d:	74 10                	je     803b2f <alloc_block+0x36f>
  803b1f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b22:	8b 00                	mov    (%eax),%eax
  803b24:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b27:	8b 52 04             	mov    0x4(%edx),%edx
  803b2a:	89 50 04             	mov    %edx,0x4(%eax)
  803b2d:	eb 14                	jmp    803b43 <alloc_block+0x383>
  803b2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b32:	8b 40 04             	mov    0x4(%eax),%eax
  803b35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b38:	c1 e2 04             	shl    $0x4,%edx
  803b3b:	81 c2 44 6b 89 00    	add    $0x896b44,%edx
  803b41:	89 02                	mov    %eax,(%edx)
  803b43:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b46:	8b 40 04             	mov    0x4(%eax),%eax
  803b49:	85 c0                	test   %eax,%eax
  803b4b:	74 0f                	je     803b5c <alloc_block+0x39c>
  803b4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b50:	8b 40 04             	mov    0x4(%eax),%eax
  803b53:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b56:	8b 12                	mov    (%edx),%edx
  803b58:	89 10                	mov    %edx,(%eax)
  803b5a:	eb 13                	jmp    803b6f <alloc_block+0x3af>
  803b5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b5f:	8b 00                	mov    (%eax),%eax
  803b61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b64:	c1 e2 04             	shl    $0x4,%edx
  803b67:	81 c2 40 6b 89 00    	add    $0x896b40,%edx
  803b6d:	89 02                	mov    %eax,(%edx)
  803b6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b78:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b85:	c1 e0 04             	shl    $0x4,%eax
  803b88:	05 4c 6b 89 00       	add    $0x896b4c,%eax
  803b8d:	8b 00                	mov    (%eax),%eax
  803b8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b95:	c1 e0 04             	shl    $0x4,%eax
  803b98:	05 4c 6b 89 00       	add    $0x896b4c,%eax
  803b9d:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803b9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ba2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803ba6:	48                   	dec    %eax
  803ba7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803baa:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803bae:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803bb1:	c9                   	leave  
  803bb2:	c3                   	ret    

00803bb3 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803bb3:	55                   	push   %ebp
  803bb4:	89 e5                	mov    %esp,%ebp
  803bb6:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  803bbc:	a1 24 6b 89 00       	mov    0x896b24,%eax
  803bc1:	39 c2                	cmp    %eax,%edx
  803bc3:	72 0c                	jb     803bd1 <free_block+0x1e>
  803bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  803bc8:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803bcd:	39 c2                	cmp    %eax,%edx
  803bcf:	72 19                	jb     803bea <free_block+0x37>
  803bd1:	68 90 4b 80 00       	push   $0x804b90
  803bd6:	68 c6 4a 80 00       	push   $0x804ac6
  803bdb:	68 98 00 00 00       	push   $0x98
  803be0:	68 63 4a 80 00       	push   $0x804a63
  803be5:	e8 6a 03 00 00       	call   803f54 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803bea:	8b 45 08             	mov    0x8(%ebp),%eax
  803bed:	83 ec 0c             	sub    $0xc,%esp
  803bf0:	50                   	push   %eax
  803bf1:	e8 c9 f8 ff ff       	call   8034bf <to_page_info>
  803bf6:	83 c4 10             	add    $0x10,%esp
  803bf9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803bfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bff:	8b 40 08             	mov    0x8(%eax),%eax
  803c02:	0f b7 c0             	movzwl %ax,%eax
  803c05:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803c08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c0f:	eb 03                	jmp    803c14 <free_block+0x61>
		listIndex++;
  803c11:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c17:	ba 08 00 00 00       	mov    $0x8,%edx
  803c1c:	88 c1                	mov    %al,%cl
  803c1e:	d3 e2                	shl    %cl,%edx
  803c20:	89 d0                	mov    %edx,%eax
  803c22:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c25:	72 ea                	jb     803c11 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803c27:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803c2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c31:	75 17                	jne    803c4a <free_block+0x97>
  803c33:	83 ec 04             	sub    $0x4,%esp
  803c36:	68 6c 4b 80 00       	push   $0x804b6c
  803c3b:	68 a2 00 00 00       	push   $0xa2
  803c40:	68 63 4a 80 00       	push   $0x804a63
  803c45:	e8 0a 03 00 00       	call   803f54 <_panic>
  803c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4d:	c1 e0 04             	shl    $0x4,%eax
  803c50:	05 40 6b 89 00       	add    $0x896b40,%eax
  803c55:	8b 10                	mov    (%eax),%edx
  803c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5a:	89 10                	mov    %edx,(%eax)
  803c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5f:	8b 00                	mov    (%eax),%eax
  803c61:	85 c0                	test   %eax,%eax
  803c63:	74 15                	je     803c7a <free_block+0xc7>
  803c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c68:	c1 e0 04             	shl    $0x4,%eax
  803c6b:	05 40 6b 89 00       	add    $0x896b40,%eax
  803c70:	8b 00                	mov    (%eax),%eax
  803c72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c75:	89 50 04             	mov    %edx,0x4(%eax)
  803c78:	eb 11                	jmp    803c8b <free_block+0xd8>
  803c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7d:	c1 e0 04             	shl    $0x4,%eax
  803c80:	8d 90 44 6b 89 00    	lea    0x896b44(%eax),%edx
  803c86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c89:	89 02                	mov    %eax,(%edx)
  803c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8e:	c1 e0 04             	shl    $0x4,%eax
  803c91:	8d 90 40 6b 89 00    	lea    0x896b40(%eax),%edx
  803c97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c9a:	89 02                	mov    %eax,(%edx)
  803c9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca9:	c1 e0 04             	shl    $0x4,%eax
  803cac:	05 4c 6b 89 00       	add    $0x896b4c,%eax
  803cb1:	8b 00                	mov    (%eax),%eax
  803cb3:	8d 50 01             	lea    0x1(%eax),%edx
  803cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb9:	c1 e0 04             	shl    $0x4,%eax
  803cbc:	05 4c 6b 89 00       	add    $0x896b4c,%eax
  803cc1:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cc6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cca:	40                   	inc    %eax
  803ccb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cce:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cd5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803cd9:	0f b7 c8             	movzwl %ax,%ecx
  803cdc:	b8 00 10 00 00       	mov    $0x1000,%eax
  803ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  803ce6:	f7 75 e8             	divl   -0x18(%ebp)
  803ce9:	39 c1                	cmp    %eax,%ecx
  803ceb:	0f 85 ed 01 00 00    	jne    803ede <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf4:	c1 e0 04             	shl    $0x4,%eax
  803cf7:	05 40 6b 89 00       	add    $0x896b40,%eax
  803cfc:	8b 00                	mov    (%eax),%eax
  803cfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d01:	eb 2a                	jmp    803d2d <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d06:	83 ec 0c             	sub    $0xc,%esp
  803d09:	50                   	push   %eax
  803d0a:	e8 b0 f7 ff ff       	call   8034bf <to_page_info>
  803d0f:	83 c4 10             	add    $0x10,%esp
  803d12:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d15:	75 06                	jne    803d1d <free_block+0x16a>
				tmp = b;
  803d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d20:	c1 e0 04             	shl    $0x4,%eax
  803d23:	05 48 6b 89 00       	add    $0x896b48,%eax
  803d28:	8b 00                	mov    (%eax),%eax
  803d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d31:	74 07                	je     803d3a <free_block+0x187>
  803d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d36:	8b 00                	mov    (%eax),%eax
  803d38:	eb 05                	jmp    803d3f <free_block+0x18c>
  803d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d42:	c1 e2 04             	shl    $0x4,%edx
  803d45:	81 c2 48 6b 89 00    	add    $0x896b48,%edx
  803d4b:	89 02                	mov    %eax,(%edx)
  803d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d50:	c1 e0 04             	shl    $0x4,%eax
  803d53:	05 48 6b 89 00       	add    $0x896b48,%eax
  803d58:	8b 00                	mov    (%eax),%eax
  803d5a:	85 c0                	test   %eax,%eax
  803d5c:	75 a5                	jne    803d03 <free_block+0x150>
  803d5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d62:	75 9f                	jne    803d03 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d67:	c1 e0 04             	shl    $0x4,%eax
  803d6a:	05 40 6b 89 00       	add    $0x896b40,%eax
  803d6f:	8b 00                	mov    (%eax),%eax
  803d71:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803d74:	e9 cc 00 00 00       	jmp    803e45 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d7c:	8b 00                	mov    (%eax),%eax
  803d7e:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d84:	83 ec 0c             	sub    $0xc,%esp
  803d87:	50                   	push   %eax
  803d88:	e8 32 f7 ff ff       	call   8034bf <to_page_info>
  803d8d:	83 c4 10             	add    $0x10,%esp
  803d90:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d93:	0f 85 a6 00 00 00    	jne    803e3f <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803d99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d9d:	75 17                	jne    803db6 <free_block+0x203>
  803d9f:	83 ec 04             	sub    $0x4,%esp
  803da2:	68 fd 4a 80 00       	push   $0x804afd
  803da7:	68 b5 00 00 00       	push   $0xb5
  803dac:	68 63 4a 80 00       	push   $0x804a63
  803db1:	e8 9e 01 00 00       	call   803f54 <_panic>
  803db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db9:	8b 00                	mov    (%eax),%eax
  803dbb:	85 c0                	test   %eax,%eax
  803dbd:	74 10                	je     803dcf <free_block+0x21c>
  803dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc2:	8b 00                	mov    (%eax),%eax
  803dc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dc7:	8b 52 04             	mov    0x4(%edx),%edx
  803dca:	89 50 04             	mov    %edx,0x4(%eax)
  803dcd:	eb 14                	jmp    803de3 <free_block+0x230>
  803dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd2:	8b 40 04             	mov    0x4(%eax),%eax
  803dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dd8:	c1 e2 04             	shl    $0x4,%edx
  803ddb:	81 c2 44 6b 89 00    	add    $0x896b44,%edx
  803de1:	89 02                	mov    %eax,(%edx)
  803de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de6:	8b 40 04             	mov    0x4(%eax),%eax
  803de9:	85 c0                	test   %eax,%eax
  803deb:	74 0f                	je     803dfc <free_block+0x249>
  803ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df0:	8b 40 04             	mov    0x4(%eax),%eax
  803df3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803df6:	8b 12                	mov    (%edx),%edx
  803df8:	89 10                	mov    %edx,(%eax)
  803dfa:	eb 13                	jmp    803e0f <free_block+0x25c>
  803dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dff:	8b 00                	mov    (%eax),%eax
  803e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e04:	c1 e2 04             	shl    $0x4,%edx
  803e07:	81 c2 40 6b 89 00    	add    $0x896b40,%edx
  803e0d:	89 02                	mov    %eax,(%edx)
  803e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e25:	c1 e0 04             	shl    $0x4,%eax
  803e28:	05 4c 6b 89 00       	add    $0x896b4c,%eax
  803e2d:	8b 00                	mov    (%eax),%eax
  803e2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e35:	c1 e0 04             	shl    $0x4,%eax
  803e38:	05 4c 6b 89 00       	add    $0x896b4c,%eax
  803e3d:	89 10                	mov    %edx,(%eax)
			b = next;
  803e3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803e45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e49:	0f 85 2a ff ff ff    	jne    803d79 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803e4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e52:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e5b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803e61:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e65:	75 17                	jne    803e7e <free_block+0x2cb>
  803e67:	83 ec 04             	sub    $0x4,%esp
  803e6a:	68 6c 4b 80 00       	push   $0x804b6c
  803e6f:	68 bc 00 00 00       	push   $0xbc
  803e74:	68 63 4a 80 00       	push   $0x804a63
  803e79:	e8 d6 00 00 00       	call   803f54 <_panic>
  803e7e:	8b 15 04 eb 87 00    	mov    0x87eb04,%edx
  803e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e87:	89 10                	mov    %edx,(%eax)
  803e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e8c:	8b 00                	mov    (%eax),%eax
  803e8e:	85 c0                	test   %eax,%eax
  803e90:	74 0d                	je     803e9f <free_block+0x2ec>
  803e92:	a1 04 eb 87 00       	mov    0x87eb04,%eax
  803e97:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e9a:	89 50 04             	mov    %edx,0x4(%eax)
  803e9d:	eb 08                	jmp    803ea7 <free_block+0x2f4>
  803e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ea2:	a3 08 eb 87 00       	mov    %eax,0x87eb08
  803ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eaa:	a3 04 eb 87 00       	mov    %eax,0x87eb04
  803eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eb9:	a1 10 eb 87 00       	mov    0x87eb10,%eax
  803ebe:	40                   	inc    %eax
  803ebf:	a3 10 eb 87 00       	mov    %eax,0x87eb10

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803ec4:	83 ec 0c             	sub    $0xc,%esp
  803ec7:	ff 75 ec             	pushl  -0x14(%ebp)
  803eca:	e8 7e f5 ff ff       	call   80344d <to_page_va>
  803ecf:	83 c4 10             	add    $0x10,%esp
  803ed2:	83 ec 0c             	sub    $0xc,%esp
  803ed5:	50                   	push   %eax
  803ed6:	e8 fe d7 ff ff       	call   8016d9 <return_page>
  803edb:	83 c4 10             	add    $0x10,%esp
	}
}
  803ede:	90                   	nop
  803edf:	c9                   	leave  
  803ee0:	c3                   	ret    

00803ee1 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803ee1:	55                   	push   %ebp
  803ee2:	89 e5                	mov    %esp,%ebp
  803ee4:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803ee7:	83 ec 04             	sub    $0x4,%esp
  803eea:	68 c8 4b 80 00       	push   $0x804bc8
  803eef:	6a 07                	push   $0x7
  803ef1:	68 f7 4b 80 00       	push   $0x804bf7
  803ef6:	e8 59 00 00 00       	call   803f54 <_panic>

00803efb <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803efb:	55                   	push   %ebp
  803efc:	89 e5                	mov    %esp,%ebp
  803efe:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803f01:	83 ec 04             	sub    $0x4,%esp
  803f04:	68 08 4c 80 00       	push   $0x804c08
  803f09:	6a 0b                	push   $0xb
  803f0b:	68 f7 4b 80 00       	push   $0x804bf7
  803f10:	e8 3f 00 00 00       	call   803f54 <_panic>

00803f15 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803f15:	55                   	push   %ebp
  803f16:	89 e5                	mov    %esp,%ebp
  803f18:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803f1b:	83 ec 04             	sub    $0x4,%esp
  803f1e:	68 34 4c 80 00       	push   $0x804c34
  803f23:	6a 10                	push   $0x10
  803f25:	68 f7 4b 80 00       	push   $0x804bf7
  803f2a:	e8 25 00 00 00       	call   803f54 <_panic>

00803f2f <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803f2f:	55                   	push   %ebp
  803f30:	89 e5                	mov    %esp,%ebp
  803f32:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803f35:	83 ec 04             	sub    $0x4,%esp
  803f38:	68 64 4c 80 00       	push   $0x804c64
  803f3d:	6a 15                	push   $0x15
  803f3f:	68 f7 4b 80 00       	push   $0x804bf7
  803f44:	e8 0b 00 00 00       	call   803f54 <_panic>

00803f49 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803f49:	55                   	push   %ebp
  803f4a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4f:	8b 40 10             	mov    0x10(%eax),%eax
}
  803f52:	5d                   	pop    %ebp
  803f53:	c3                   	ret    

00803f54 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803f54:	55                   	push   %ebp
  803f55:	89 e5                	mov    %esp,%ebp
  803f57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803f5a:	8d 45 10             	lea    0x10(%ebp),%eax
  803f5d:	83 c0 04             	add    $0x4,%eax
  803f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803f63:	a1 68 86 8f 00       	mov    0x8f8668,%eax
  803f68:	85 c0                	test   %eax,%eax
  803f6a:	74 16                	je     803f82 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803f6c:	a1 68 86 8f 00       	mov    0x8f8668,%eax
  803f71:	83 ec 08             	sub    $0x8,%esp
  803f74:	50                   	push   %eax
  803f75:	68 94 4c 80 00       	push   $0x804c94
  803f7a:	e8 d8 c7 ff ff       	call   800757 <cprintf>
  803f7f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803f82:	a1 04 50 80 00       	mov    0x805004,%eax
  803f87:	83 ec 0c             	sub    $0xc,%esp
  803f8a:	ff 75 0c             	pushl  0xc(%ebp)
  803f8d:	ff 75 08             	pushl  0x8(%ebp)
  803f90:	50                   	push   %eax
  803f91:	68 9c 4c 80 00       	push   $0x804c9c
  803f96:	6a 74                	push   $0x74
  803f98:	e8 e7 c7 ff ff       	call   800784 <cprintf_colored>
  803f9d:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803fa0:	8b 45 10             	mov    0x10(%ebp),%eax
  803fa3:	83 ec 08             	sub    $0x8,%esp
  803fa6:	ff 75 f4             	pushl  -0xc(%ebp)
  803fa9:	50                   	push   %eax
  803faa:	e8 39 c7 ff ff       	call   8006e8 <vcprintf>
  803faf:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803fb2:	83 ec 08             	sub    $0x8,%esp
  803fb5:	6a 00                	push   $0x0
  803fb7:	68 c4 4c 80 00       	push   $0x804cc4
  803fbc:	e8 27 c7 ff ff       	call   8006e8 <vcprintf>
  803fc1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803fc4:	e8 a0 c6 ff ff       	call   800669 <exit>

	// should not return here
	while (1) ;
  803fc9:	eb fe                	jmp    803fc9 <_panic+0x75>

00803fcb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803fcb:	55                   	push   %ebp
  803fcc:	89 e5                	mov    %esp,%ebp
  803fce:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803fd1:	a1 20 50 80 00       	mov    0x805020,%eax
  803fd6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fdf:	39 c2                	cmp    %eax,%edx
  803fe1:	74 14                	je     803ff7 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803fe3:	83 ec 04             	sub    $0x4,%esp
  803fe6:	68 c8 4c 80 00       	push   $0x804cc8
  803feb:	6a 26                	push   $0x26
  803fed:	68 14 4d 80 00       	push   $0x804d14
  803ff2:	e8 5d ff ff ff       	call   803f54 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803ff7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803ffe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804005:	e9 c5 00 00 00       	jmp    8040cf <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80400a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80400d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804014:	8b 45 08             	mov    0x8(%ebp),%eax
  804017:	01 d0                	add    %edx,%eax
  804019:	8b 00                	mov    (%eax),%eax
  80401b:	85 c0                	test   %eax,%eax
  80401d:	75 08                	jne    804027 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80401f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  804022:	e9 a5 00 00 00       	jmp    8040cc <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  804027:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80402e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804035:	eb 69                	jmp    8040a0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  804037:	a1 20 50 80 00       	mov    0x805020,%eax
  80403c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  804042:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804045:	89 d0                	mov    %edx,%eax
  804047:	01 c0                	add    %eax,%eax
  804049:	01 d0                	add    %edx,%eax
  80404b:	c1 e0 03             	shl    $0x3,%eax
  80404e:	01 c8                	add    %ecx,%eax
  804050:	8a 40 04             	mov    0x4(%eax),%al
  804053:	84 c0                	test   %al,%al
  804055:	75 46                	jne    80409d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804057:	a1 20 50 80 00       	mov    0x805020,%eax
  80405c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  804062:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804065:	89 d0                	mov    %edx,%eax
  804067:	01 c0                	add    %eax,%eax
  804069:	01 d0                	add    %edx,%eax
  80406b:	c1 e0 03             	shl    $0x3,%eax
  80406e:	01 c8                	add    %ecx,%eax
  804070:	8b 00                	mov    (%eax),%eax
  804072:	89 45 dc             	mov    %eax,-0x24(%ebp)
  804075:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804078:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80407d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80407f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804082:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  804089:	8b 45 08             	mov    0x8(%ebp),%eax
  80408c:	01 c8                	add    %ecx,%eax
  80408e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804090:	39 c2                	cmp    %eax,%edx
  804092:	75 09                	jne    80409d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804094:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80409b:	eb 15                	jmp    8040b2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80409d:	ff 45 e8             	incl   -0x18(%ebp)
  8040a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8040a5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8040ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040ae:	39 c2                	cmp    %eax,%edx
  8040b0:	77 85                	ja     804037 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8040b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8040b6:	75 14                	jne    8040cc <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8040b8:	83 ec 04             	sub    $0x4,%esp
  8040bb:	68 20 4d 80 00       	push   $0x804d20
  8040c0:	6a 3a                	push   $0x3a
  8040c2:	68 14 4d 80 00       	push   $0x804d14
  8040c7:	e8 88 fe ff ff       	call   803f54 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8040cc:	ff 45 f0             	incl   -0x10(%ebp)
  8040cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8040d5:	0f 8c 2f ff ff ff    	jl     80400a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8040db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8040e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8040e9:	eb 26                	jmp    804111 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8040eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8040f0:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8040f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8040f9:	89 d0                	mov    %edx,%eax
  8040fb:	01 c0                	add    %eax,%eax
  8040fd:	01 d0                	add    %edx,%eax
  8040ff:	c1 e0 03             	shl    $0x3,%eax
  804102:	01 c8                	add    %ecx,%eax
  804104:	8a 40 04             	mov    0x4(%eax),%al
  804107:	3c 01                	cmp    $0x1,%al
  804109:	75 03                	jne    80410e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80410b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80410e:	ff 45 e0             	incl   -0x20(%ebp)
  804111:	a1 20 50 80 00       	mov    0x805020,%eax
  804116:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80411c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80411f:	39 c2                	cmp    %eax,%edx
  804121:	77 c8                	ja     8040eb <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  804123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804126:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  804129:	74 14                	je     80413f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80412b:	83 ec 04             	sub    $0x4,%esp
  80412e:	68 74 4d 80 00       	push   $0x804d74
  804133:	6a 44                	push   $0x44
  804135:	68 14 4d 80 00       	push   $0x804d14
  80413a:	e8 15 fe ff ff       	call   803f54 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80413f:	90                   	nop
  804140:	c9                   	leave  
  804141:	c3                   	ret    
  804142:	66 90                	xchg   %ax,%ax

00804144 <__udivdi3>:
  804144:	55                   	push   %ebp
  804145:	57                   	push   %edi
  804146:	56                   	push   %esi
  804147:	53                   	push   %ebx
  804148:	83 ec 1c             	sub    $0x1c,%esp
  80414b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80414f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804153:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804157:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80415b:	89 ca                	mov    %ecx,%edx
  80415d:	89 f8                	mov    %edi,%eax
  80415f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804163:	85 f6                	test   %esi,%esi
  804165:	75 2d                	jne    804194 <__udivdi3+0x50>
  804167:	39 cf                	cmp    %ecx,%edi
  804169:	77 65                	ja     8041d0 <__udivdi3+0x8c>
  80416b:	89 fd                	mov    %edi,%ebp
  80416d:	85 ff                	test   %edi,%edi
  80416f:	75 0b                	jne    80417c <__udivdi3+0x38>
  804171:	b8 01 00 00 00       	mov    $0x1,%eax
  804176:	31 d2                	xor    %edx,%edx
  804178:	f7 f7                	div    %edi
  80417a:	89 c5                	mov    %eax,%ebp
  80417c:	31 d2                	xor    %edx,%edx
  80417e:	89 c8                	mov    %ecx,%eax
  804180:	f7 f5                	div    %ebp
  804182:	89 c1                	mov    %eax,%ecx
  804184:	89 d8                	mov    %ebx,%eax
  804186:	f7 f5                	div    %ebp
  804188:	89 cf                	mov    %ecx,%edi
  80418a:	89 fa                	mov    %edi,%edx
  80418c:	83 c4 1c             	add    $0x1c,%esp
  80418f:	5b                   	pop    %ebx
  804190:	5e                   	pop    %esi
  804191:	5f                   	pop    %edi
  804192:	5d                   	pop    %ebp
  804193:	c3                   	ret    
  804194:	39 ce                	cmp    %ecx,%esi
  804196:	77 28                	ja     8041c0 <__udivdi3+0x7c>
  804198:	0f bd fe             	bsr    %esi,%edi
  80419b:	83 f7 1f             	xor    $0x1f,%edi
  80419e:	75 40                	jne    8041e0 <__udivdi3+0x9c>
  8041a0:	39 ce                	cmp    %ecx,%esi
  8041a2:	72 0a                	jb     8041ae <__udivdi3+0x6a>
  8041a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8041a8:	0f 87 9e 00 00 00    	ja     80424c <__udivdi3+0x108>
  8041ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8041b3:	89 fa                	mov    %edi,%edx
  8041b5:	83 c4 1c             	add    $0x1c,%esp
  8041b8:	5b                   	pop    %ebx
  8041b9:	5e                   	pop    %esi
  8041ba:	5f                   	pop    %edi
  8041bb:	5d                   	pop    %ebp
  8041bc:	c3                   	ret    
  8041bd:	8d 76 00             	lea    0x0(%esi),%esi
  8041c0:	31 ff                	xor    %edi,%edi
  8041c2:	31 c0                	xor    %eax,%eax
  8041c4:	89 fa                	mov    %edi,%edx
  8041c6:	83 c4 1c             	add    $0x1c,%esp
  8041c9:	5b                   	pop    %ebx
  8041ca:	5e                   	pop    %esi
  8041cb:	5f                   	pop    %edi
  8041cc:	5d                   	pop    %ebp
  8041cd:	c3                   	ret    
  8041ce:	66 90                	xchg   %ax,%ax
  8041d0:	89 d8                	mov    %ebx,%eax
  8041d2:	f7 f7                	div    %edi
  8041d4:	31 ff                	xor    %edi,%edi
  8041d6:	89 fa                	mov    %edi,%edx
  8041d8:	83 c4 1c             	add    $0x1c,%esp
  8041db:	5b                   	pop    %ebx
  8041dc:	5e                   	pop    %esi
  8041dd:	5f                   	pop    %edi
  8041de:	5d                   	pop    %ebp
  8041df:	c3                   	ret    
  8041e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8041e5:	89 eb                	mov    %ebp,%ebx
  8041e7:	29 fb                	sub    %edi,%ebx
  8041e9:	89 f9                	mov    %edi,%ecx
  8041eb:	d3 e6                	shl    %cl,%esi
  8041ed:	89 c5                	mov    %eax,%ebp
  8041ef:	88 d9                	mov    %bl,%cl
  8041f1:	d3 ed                	shr    %cl,%ebp
  8041f3:	89 e9                	mov    %ebp,%ecx
  8041f5:	09 f1                	or     %esi,%ecx
  8041f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8041fb:	89 f9                	mov    %edi,%ecx
  8041fd:	d3 e0                	shl    %cl,%eax
  8041ff:	89 c5                	mov    %eax,%ebp
  804201:	89 d6                	mov    %edx,%esi
  804203:	88 d9                	mov    %bl,%cl
  804205:	d3 ee                	shr    %cl,%esi
  804207:	89 f9                	mov    %edi,%ecx
  804209:	d3 e2                	shl    %cl,%edx
  80420b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80420f:	88 d9                	mov    %bl,%cl
  804211:	d3 e8                	shr    %cl,%eax
  804213:	09 c2                	or     %eax,%edx
  804215:	89 d0                	mov    %edx,%eax
  804217:	89 f2                	mov    %esi,%edx
  804219:	f7 74 24 0c          	divl   0xc(%esp)
  80421d:	89 d6                	mov    %edx,%esi
  80421f:	89 c3                	mov    %eax,%ebx
  804221:	f7 e5                	mul    %ebp
  804223:	39 d6                	cmp    %edx,%esi
  804225:	72 19                	jb     804240 <__udivdi3+0xfc>
  804227:	74 0b                	je     804234 <__udivdi3+0xf0>
  804229:	89 d8                	mov    %ebx,%eax
  80422b:	31 ff                	xor    %edi,%edi
  80422d:	e9 58 ff ff ff       	jmp    80418a <__udivdi3+0x46>
  804232:	66 90                	xchg   %ax,%ax
  804234:	8b 54 24 08          	mov    0x8(%esp),%edx
  804238:	89 f9                	mov    %edi,%ecx
  80423a:	d3 e2                	shl    %cl,%edx
  80423c:	39 c2                	cmp    %eax,%edx
  80423e:	73 e9                	jae    804229 <__udivdi3+0xe5>
  804240:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804243:	31 ff                	xor    %edi,%edi
  804245:	e9 40 ff ff ff       	jmp    80418a <__udivdi3+0x46>
  80424a:	66 90                	xchg   %ax,%ax
  80424c:	31 c0                	xor    %eax,%eax
  80424e:	e9 37 ff ff ff       	jmp    80418a <__udivdi3+0x46>
  804253:	90                   	nop

00804254 <__umoddi3>:
  804254:	55                   	push   %ebp
  804255:	57                   	push   %edi
  804256:	56                   	push   %esi
  804257:	53                   	push   %ebx
  804258:	83 ec 1c             	sub    $0x1c,%esp
  80425b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80425f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804263:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804267:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80426b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80426f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804273:	89 f3                	mov    %esi,%ebx
  804275:	89 fa                	mov    %edi,%edx
  804277:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80427b:	89 34 24             	mov    %esi,(%esp)
  80427e:	85 c0                	test   %eax,%eax
  804280:	75 1a                	jne    80429c <__umoddi3+0x48>
  804282:	39 f7                	cmp    %esi,%edi
  804284:	0f 86 a2 00 00 00    	jbe    80432c <__umoddi3+0xd8>
  80428a:	89 c8                	mov    %ecx,%eax
  80428c:	89 f2                	mov    %esi,%edx
  80428e:	f7 f7                	div    %edi
  804290:	89 d0                	mov    %edx,%eax
  804292:	31 d2                	xor    %edx,%edx
  804294:	83 c4 1c             	add    $0x1c,%esp
  804297:	5b                   	pop    %ebx
  804298:	5e                   	pop    %esi
  804299:	5f                   	pop    %edi
  80429a:	5d                   	pop    %ebp
  80429b:	c3                   	ret    
  80429c:	39 f0                	cmp    %esi,%eax
  80429e:	0f 87 ac 00 00 00    	ja     804350 <__umoddi3+0xfc>
  8042a4:	0f bd e8             	bsr    %eax,%ebp
  8042a7:	83 f5 1f             	xor    $0x1f,%ebp
  8042aa:	0f 84 ac 00 00 00    	je     80435c <__umoddi3+0x108>
  8042b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8042b5:	29 ef                	sub    %ebp,%edi
  8042b7:	89 fe                	mov    %edi,%esi
  8042b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042bd:	89 e9                	mov    %ebp,%ecx
  8042bf:	d3 e0                	shl    %cl,%eax
  8042c1:	89 d7                	mov    %edx,%edi
  8042c3:	89 f1                	mov    %esi,%ecx
  8042c5:	d3 ef                	shr    %cl,%edi
  8042c7:	09 c7                	or     %eax,%edi
  8042c9:	89 e9                	mov    %ebp,%ecx
  8042cb:	d3 e2                	shl    %cl,%edx
  8042cd:	89 14 24             	mov    %edx,(%esp)
  8042d0:	89 d8                	mov    %ebx,%eax
  8042d2:	d3 e0                	shl    %cl,%eax
  8042d4:	89 c2                	mov    %eax,%edx
  8042d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042da:	d3 e0                	shl    %cl,%eax
  8042dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042e4:	89 f1                	mov    %esi,%ecx
  8042e6:	d3 e8                	shr    %cl,%eax
  8042e8:	09 d0                	or     %edx,%eax
  8042ea:	d3 eb                	shr    %cl,%ebx
  8042ec:	89 da                	mov    %ebx,%edx
  8042ee:	f7 f7                	div    %edi
  8042f0:	89 d3                	mov    %edx,%ebx
  8042f2:	f7 24 24             	mull   (%esp)
  8042f5:	89 c6                	mov    %eax,%esi
  8042f7:	89 d1                	mov    %edx,%ecx
  8042f9:	39 d3                	cmp    %edx,%ebx
  8042fb:	0f 82 87 00 00 00    	jb     804388 <__umoddi3+0x134>
  804301:	0f 84 91 00 00 00    	je     804398 <__umoddi3+0x144>
  804307:	8b 54 24 04          	mov    0x4(%esp),%edx
  80430b:	29 f2                	sub    %esi,%edx
  80430d:	19 cb                	sbb    %ecx,%ebx
  80430f:	89 d8                	mov    %ebx,%eax
  804311:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804315:	d3 e0                	shl    %cl,%eax
  804317:	89 e9                	mov    %ebp,%ecx
  804319:	d3 ea                	shr    %cl,%edx
  80431b:	09 d0                	or     %edx,%eax
  80431d:	89 e9                	mov    %ebp,%ecx
  80431f:	d3 eb                	shr    %cl,%ebx
  804321:	89 da                	mov    %ebx,%edx
  804323:	83 c4 1c             	add    $0x1c,%esp
  804326:	5b                   	pop    %ebx
  804327:	5e                   	pop    %esi
  804328:	5f                   	pop    %edi
  804329:	5d                   	pop    %ebp
  80432a:	c3                   	ret    
  80432b:	90                   	nop
  80432c:	89 fd                	mov    %edi,%ebp
  80432e:	85 ff                	test   %edi,%edi
  804330:	75 0b                	jne    80433d <__umoddi3+0xe9>
  804332:	b8 01 00 00 00       	mov    $0x1,%eax
  804337:	31 d2                	xor    %edx,%edx
  804339:	f7 f7                	div    %edi
  80433b:	89 c5                	mov    %eax,%ebp
  80433d:	89 f0                	mov    %esi,%eax
  80433f:	31 d2                	xor    %edx,%edx
  804341:	f7 f5                	div    %ebp
  804343:	89 c8                	mov    %ecx,%eax
  804345:	f7 f5                	div    %ebp
  804347:	89 d0                	mov    %edx,%eax
  804349:	e9 44 ff ff ff       	jmp    804292 <__umoddi3+0x3e>
  80434e:	66 90                	xchg   %ax,%ax
  804350:	89 c8                	mov    %ecx,%eax
  804352:	89 f2                	mov    %esi,%edx
  804354:	83 c4 1c             	add    $0x1c,%esp
  804357:	5b                   	pop    %ebx
  804358:	5e                   	pop    %esi
  804359:	5f                   	pop    %edi
  80435a:	5d                   	pop    %ebp
  80435b:	c3                   	ret    
  80435c:	3b 04 24             	cmp    (%esp),%eax
  80435f:	72 06                	jb     804367 <__umoddi3+0x113>
  804361:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804365:	77 0f                	ja     804376 <__umoddi3+0x122>
  804367:	89 f2                	mov    %esi,%edx
  804369:	29 f9                	sub    %edi,%ecx
  80436b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80436f:	89 14 24             	mov    %edx,(%esp)
  804372:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804376:	8b 44 24 04          	mov    0x4(%esp),%eax
  80437a:	8b 14 24             	mov    (%esp),%edx
  80437d:	83 c4 1c             	add    $0x1c,%esp
  804380:	5b                   	pop    %ebx
  804381:	5e                   	pop    %esi
  804382:	5f                   	pop    %edi
  804383:	5d                   	pop    %ebp
  804384:	c3                   	ret    
  804385:	8d 76 00             	lea    0x0(%esi),%esi
  804388:	2b 04 24             	sub    (%esp),%eax
  80438b:	19 fa                	sbb    %edi,%edx
  80438d:	89 d1                	mov    %edx,%ecx
  80438f:	89 c6                	mov    %eax,%esi
  804391:	e9 71 ff ff ff       	jmp    804307 <__umoddi3+0xb3>
  804396:	66 90                	xchg   %ax,%ax
  804398:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80439c:	72 ea                	jb     804388 <__umoddi3+0x134>
  80439e:	89 d9                	mov    %ebx,%ecx
  8043a0:	e9 62 ff ff ff       	jmp    804307 <__umoddi3+0xb3>
