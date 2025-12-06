
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 c9 04 00 00       	call   8004ff <libmain>
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
  80003e:	e8 98 31 00 00       	call   8031db <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;

	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	68 e0 43 80 00       	push   $0x8043e0
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	50                   	push   %eax
  800055:	e8 d9 3e 00 00       	call   803f33 <get_semaphore>
  80005a:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  80005d:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 e6 43 80 00       	push   $0x8043e6
  800068:	ff 75 f0             	pushl  -0x10(%ebp)
  80006b:	50                   	push   %eax
  80006c:	e8 c2 3e 00 00       	call   803f33 <get_semaphore>
  800071:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	ff 75 dc             	pushl  -0x24(%ebp)
  80007a:	e8 ce 3e 00 00       	call   803f4d <wait_semaphore>
  80007f:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 ef 43 80 00       	push   $0x8043ef
  80008a:	ff 75 f0             	pushl  -0x10(%ebp)
  80008d:	e8 86 21 00 00       	call   802218 <sget>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  800098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009b:	8b 10                	mov    (%eax),%edx
  80009d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 02 44 80 00       	push   $0x804402
  8000a8:	52                   	push   %edx
  8000a9:	50                   	push   %eax
  8000aa:	e8 84 3e 00 00       	call   803f33 <get_semaphore>
  8000af:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  8000b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 10 44 80 00       	push   $0x804410
  8000c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000cb:	e8 48 21 00 00       	call   802218 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 14 44 80 00       	push   $0x804414
  8000de:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e1:	e8 32 21 00 00       	call   802218 <sget>
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
  8000fa:	68 1c 44 80 00       	push   $0x80441c
  8000ff:	e8 ba 1d 00 00       	call   801ebe <smalloc>
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
  80015e:	e8 ea 3d 00 00       	call   803f4d <wait_semaphore>
  800163:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Merge sort is Finished!!!!\n") ;
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	68 2b 44 80 00       	push   $0x80442b
  80016e:	e8 1c 06 00 00       	call   80078f <cprintf>
  800173:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  800176:	83 ec 0c             	sub    $0xc,%esp
  800179:	68 48 44 80 00       	push   $0x804448
  80017e:	e8 0c 06 00 00       	call   80078f <cprintf>
  800183:	83 c4 10             	add    $0x10,%esp
		cprintf("Merge sort says GOOD BYE :)\n") ;
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 67 44 80 00       	push   $0x804467
  80018e:	e8 fc 05 00 00       	call   80078f <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	ff 75 d4             	pushl  -0x2c(%ebp)
  80019c:	e8 c6 3d 00 00       	call   803f67 <signal_semaphore>
  8001a1:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001a4:	83 ec 0c             	sub    $0xc,%esp
  8001a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8001aa:	e8 b8 3d 00 00       	call   803f67 <signal_semaphore>
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
  80022e:	68 84 44 80 00       	push   $0x804484
  800233:	e8 57 05 00 00       	call   80078f <cprintf>
  800238:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800245:	8b 45 08             	mov    0x8(%ebp),%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8b 00                	mov    (%eax),%eax
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	50                   	push   %eax
  800250:	68 86 44 80 00       	push   $0x804486
  800255:	e8 35 05 00 00       	call   80078f <cprintf>
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
  80027e:	68 8b 44 80 00       	push   $0x80448b
  800283:	e8 07 05 00 00       	call   80078f <cprintf>
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
  8002f6:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  8002f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8002ff:	40                   	inc    %eax
  800300:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800303:	8b 45 14             	mov    0x14(%ebp),%eax
  800306:	2b 45 10             	sub    0x10(%ebp),%eax
  800309:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  80030c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80031a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80031d:	c1 e0 02             	shl    $0x2,%eax
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	50                   	push   %eax
  800324:	e8 28 14 00 00       	call   801751 <malloc>
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80032f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800332:	c1 e0 02             	shl    $0x2,%eax
  800335:	83 ec 0c             	sub    $0xc,%esp
  800338:	50                   	push   %eax
  800339:	e8 13 14 00 00       	call   801751 <malloc>
  80033e:	83 c4 10             	add    $0x10,%esp
  800341:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800344:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80034b:	eb 2f                	jmp    80037c <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  80034d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800350:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800357:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80035a:	01 c2                	add    %eax,%edx
  80035c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80035f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800362:	01 c8                	add    %ecx,%eax
  800364:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800369:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	01 c8                	add    %ecx,%eax
  800375:	8b 00                	mov    (%eax),%eax
  800377:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800379:	ff 45 ec             	incl   -0x14(%ebp)
  80037c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80037f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800382:	7c c9                	jl     80034d <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800384:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038b:	eb 2a                	jmp    8003b7 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  80038d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800390:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800397:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039a:	01 c2                	add    %eax,%edx
  80039c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80039f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ae:	01 c8                	add    %ecx,%eax
  8003b0:	8b 00                	mov    (%eax),%eax
  8003b2:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8003b4:	ff 45 e8             	incl   -0x18(%ebp)
  8003b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ba:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003bd:	7c ce                	jl     80038d <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8003bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c5:	e9 0a 01 00 00       	jmp    8004d4 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8003ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003cd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003d0:	0f 8d 95 00 00 00    	jge    80046b <Merge+0x178>
  8003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003dc:	0f 8d 89 00 00 00    	jge    80046b <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003ef:	01 d0                	add    %edx,%eax
  8003f1:	8b 10                	mov    (%eax),%edx
  8003f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800400:	01 c8                	add    %ecx,%eax
  800402:	8b 00                	mov    (%eax),%eax
  800404:	39 c2                	cmp    %eax,%edx
  800406:	7d 33                	jge    80043b <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80041d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800420:	8d 50 01             	lea    0x1(%eax),%edx
  800423:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800426:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800430:	01 d0                	add    %edx,%eax
  800432:	8b 00                	mov    (%eax),%eax
  800434:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800436:	e9 96 00 00 00       	jmp    8004d1 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  80043b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80043e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800443:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800453:	8d 50 01             	lea    0x1(%eax),%edx
  800456:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800459:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800460:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800463:	01 d0                	add    %edx,%eax
  800465:	8b 00                	mov    (%eax),%eax
  800467:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800469:	eb 66                	jmp    8004d1 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800471:	7d 30                	jge    8004a3 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800476:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80047b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	8d 50 01             	lea    0x1(%eax),%edx
  80048e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800491:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800498:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	89 01                	mov    %eax,(%ecx)
  8004a1:	eb 2e                	jmp    8004d1 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8004a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a6:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8004ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004bb:	8d 50 01             	lea    0x1(%eax),%edx
  8004be:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8004c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004cb:	01 d0                	add    %edx,%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8004d1:	ff 45 e4             	incl   -0x1c(%ebp)
  8004d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004da:	0f 8e ea fe ff ff    	jle    8003ca <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  8004e0:	83 ec 0c             	sub    $0xc,%esp
  8004e3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e6:	e8 c6 15 00 00       	call   801ab1 <free>
  8004eb:	83 c4 10             	add    $0x10,%esp
	free(Right);
  8004ee:	83 ec 0c             	sub    $0xc,%esp
  8004f1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8004f4:	e8 b8 15 00 00       	call   801ab1 <free>
  8004f9:	83 c4 10             	add    $0x10,%esp

}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	57                   	push   %edi
  800503:	56                   	push   %esi
  800504:	53                   	push   %ebx
  800505:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800508:	e8 b5 2c 00 00       	call   8031c2 <sys_getenvindex>
  80050d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800510:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800513:	89 d0                	mov    %edx,%eax
  800515:	c1 e0 03             	shl    $0x3,%eax
  800518:	01 d0                	add    %edx,%eax
  80051a:	c1 e0 02             	shl    $0x2,%eax
  80051d:	01 d0                	add    %edx,%eax
  80051f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800526:	01 d0                	add    %edx,%eax
  800528:	c1 e0 03             	shl    $0x3,%eax
  80052b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800530:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800535:	a1 20 50 80 00       	mov    0x805020,%eax
  80053a:	8a 40 20             	mov    0x20(%eax),%al
  80053d:	84 c0                	test   %al,%al
  80053f:	74 0d                	je     80054e <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800541:	a1 20 50 80 00       	mov    0x805020,%eax
  800546:	83 c0 20             	add    $0x20,%eax
  800549:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80054e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800552:	7e 0a                	jle    80055e <libmain+0x5f>
		binaryname = argv[0];
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	ff 75 0c             	pushl  0xc(%ebp)
  800564:	ff 75 08             	pushl  0x8(%ebp)
  800567:	e8 cc fa ff ff       	call   800038 <_main>
  80056c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80056f:	a1 00 50 80 00       	mov    0x805000,%eax
  800574:	85 c0                	test   %eax,%eax
  800576:	0f 84 01 01 00 00    	je     80067d <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80057c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800582:	bb 88 45 80 00       	mov    $0x804588,%ebx
  800587:	ba 0e 00 00 00       	mov    $0xe,%edx
  80058c:	89 c7                	mov    %eax,%edi
  80058e:	89 de                	mov    %ebx,%esi
  800590:	89 d1                	mov    %edx,%ecx
  800592:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800594:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800597:	b9 56 00 00 00       	mov    $0x56,%ecx
  80059c:	b0 00                	mov    $0x0,%al
  80059e:	89 d7                	mov    %edx,%edi
  8005a0:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8005a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8005a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	50                   	push   %eax
  8005b0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8005b6:	50                   	push   %eax
  8005b7:	e8 3c 2e 00 00       	call   8033f8 <sys_utilities>
  8005bc:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8005bf:	e8 85 29 00 00       	call   802f49 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8005c4:	83 ec 0c             	sub    $0xc,%esp
  8005c7:	68 a8 44 80 00       	push   $0x8044a8
  8005cc:	e8 be 01 00 00       	call   80078f <cprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8005d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d7:	85 c0                	test   %eax,%eax
  8005d9:	74 18                	je     8005f3 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8005db:	e8 36 2e 00 00       	call   803416 <sys_get_optimal_num_faults>
  8005e0:	83 ec 08             	sub    $0x8,%esp
  8005e3:	50                   	push   %eax
  8005e4:	68 d0 44 80 00       	push   $0x8044d0
  8005e9:	e8 a1 01 00 00       	call   80078f <cprintf>
  8005ee:	83 c4 10             	add    $0x10,%esp
  8005f1:	eb 59                	jmp    80064c <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f8:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8005fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800603:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800609:	83 ec 04             	sub    $0x4,%esp
  80060c:	52                   	push   %edx
  80060d:	50                   	push   %eax
  80060e:	68 f4 44 80 00       	push   $0x8044f4
  800613:	e8 77 01 00 00       	call   80078f <cprintf>
  800618:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80061b:	a1 20 50 80 00       	mov    0x805020,%eax
  800620:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800626:	a1 20 50 80 00       	mov    0x805020,%eax
  80062b:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800631:	a1 20 50 80 00       	mov    0x805020,%eax
  800636:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80063c:	51                   	push   %ecx
  80063d:	52                   	push   %edx
  80063e:	50                   	push   %eax
  80063f:	68 1c 45 80 00       	push   $0x80451c
  800644:	e8 46 01 00 00       	call   80078f <cprintf>
  800649:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80064c:	a1 20 50 80 00       	mov    0x805020,%eax
  800651:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	50                   	push   %eax
  80065b:	68 74 45 80 00       	push   $0x804574
  800660:	e8 2a 01 00 00       	call   80078f <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 a8 44 80 00       	push   $0x8044a8
  800670:	e8 1a 01 00 00       	call   80078f <cprintf>
  800675:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800678:	e8 e6 28 00 00       	call   802f63 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80067d:	e8 1f 00 00 00       	call   8006a1 <exit>
}
  800682:	90                   	nop
  800683:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800686:	5b                   	pop    %ebx
  800687:	5e                   	pop    %esi
  800688:	5f                   	pop    %edi
  800689:	5d                   	pop    %ebp
  80068a:	c3                   	ret    

0080068b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800691:	83 ec 0c             	sub    $0xc,%esp
  800694:	6a 00                	push   $0x0
  800696:	e8 f3 2a 00 00       	call   80318e <sys_destroy_env>
  80069b:	83 c4 10             	add    $0x10,%esp
}
  80069e:	90                   	nop
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    

008006a1 <exit>:

void
exit(void)
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006a7:	e8 48 2b 00 00       	call   8031f4 <sys_exit_env>
}
  8006ac:	90                   	nop
  8006ad:	c9                   	leave  
  8006ae:	c3                   	ret    

008006af <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006af:	55                   	push   %ebp
  8006b0:	89 e5                	mov    %esp,%ebp
  8006b2:	53                   	push   %ebx
  8006b3:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	8d 48 01             	lea    0x1(%eax),%ecx
  8006be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c1:	89 0a                	mov    %ecx,(%edx)
  8006c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c6:	88 d1                	mov    %dl,%cl
  8006c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006d9:	75 30                	jne    80070b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006db:	8b 15 38 51 83 00    	mov    0x835138,%edx
  8006e1:	a0 64 d0 81 00       	mov    0x81d064,%al
  8006e6:	0f b6 c0             	movzbl %al,%eax
  8006e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ec:	8b 09                	mov    (%ecx),%ecx
  8006ee:	89 cb                	mov    %ecx,%ebx
  8006f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006f3:	83 c1 08             	add    $0x8,%ecx
  8006f6:	52                   	push   %edx
  8006f7:	50                   	push   %eax
  8006f8:	53                   	push   %ebx
  8006f9:	51                   	push   %ecx
  8006fa:	e8 06 28 00 00       	call   802f05 <sys_cputs>
  8006ff:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800702:	8b 45 0c             	mov    0xc(%ebp),%eax
  800705:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070e:	8b 40 04             	mov    0x4(%eax),%eax
  800711:	8d 50 01             	lea    0x1(%eax),%edx
  800714:	8b 45 0c             	mov    0xc(%ebp),%eax
  800717:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071a:	90                   	nop
  80071b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80071e:	c9                   	leave  
  80071f:	c3                   	ret    

00800720 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800720:	55                   	push   %ebp
  800721:	89 e5                	mov    %esp,%ebp
  800723:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800729:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800730:	00 00 00 
	b.cnt = 0;
  800733:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80073a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073d:	ff 75 0c             	pushl  0xc(%ebp)
  800740:	ff 75 08             	pushl  0x8(%ebp)
  800743:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800749:	50                   	push   %eax
  80074a:	68 af 06 80 00       	push   $0x8006af
  80074f:	e8 5a 02 00 00       	call   8009ae <vprintfmt>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800757:	8b 15 38 51 83 00    	mov    0x835138,%edx
  80075d:	a0 64 d0 81 00       	mov    0x81d064,%al
  800762:	0f b6 c0             	movzbl %al,%eax
  800765:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80076b:	52                   	push   %edx
  80076c:	50                   	push   %eax
  80076d:	51                   	push   %ecx
  80076e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800774:	83 c0 08             	add    $0x8,%eax
  800777:	50                   	push   %eax
  800778:	e8 88 27 00 00       	call   802f05 <sys_cputs>
  80077d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800780:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  800787:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800795:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  80079c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ab:	50                   	push   %eax
  8007ac:	e8 6f ff ff ff       	call   800720 <vcprintf>
  8007b1:	83 c4 10             	add    $0x10,%esp
  8007b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007c2:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	c1 e0 08             	shl    $0x8,%eax
  8007cf:	a3 38 51 83 00       	mov    %eax,0x835138
	va_start(ap, fmt);
  8007d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d7:	83 c0 04             	add    $0x4,%eax
  8007da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e6:	50                   	push   %eax
  8007e7:	e8 34 ff ff ff       	call   800720 <vcprintf>
  8007ec:	83 c4 10             	add    $0x10,%esp
  8007ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007f2:	c7 05 38 51 83 00 00 	movl   $0x700,0x835138
  8007f9:	07 00 00 

	return cnt;
  8007fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ff:	c9                   	leave  
  800800:	c3                   	ret    

00800801 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800807:	e8 3d 27 00 00       	call   802f49 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80080c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80080f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	ff 75 f4             	pushl  -0xc(%ebp)
  80081b:	50                   	push   %eax
  80081c:	e8 ff fe ff ff       	call   800720 <vcprintf>
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800827:	e8 37 27 00 00       	call   802f63 <sys_unlock_cons>
	return cnt;
  80082c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80082f:	c9                   	leave  
  800830:	c3                   	ret    

00800831 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	53                   	push   %ebx
  800835:	83 ec 14             	sub    $0x14,%esp
  800838:	8b 45 10             	mov    0x10(%ebp),%eax
  80083b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800844:	8b 45 18             	mov    0x18(%ebp),%eax
  800847:	ba 00 00 00 00       	mov    $0x0,%edx
  80084c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80084f:	77 55                	ja     8008a6 <printnum+0x75>
  800851:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800854:	72 05                	jb     80085b <printnum+0x2a>
  800856:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800859:	77 4b                	ja     8008a6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80085b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80085e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800861:	8b 45 18             	mov    0x18(%ebp),%eax
  800864:	ba 00 00 00 00       	mov    $0x0,%edx
  800869:	52                   	push   %edx
  80086a:	50                   	push   %eax
  80086b:	ff 75 f4             	pushl  -0xc(%ebp)
  80086e:	ff 75 f0             	pushl  -0x10(%ebp)
  800871:	e8 06 39 00 00       	call   80417c <__udivdi3>
  800876:	83 c4 10             	add    $0x10,%esp
  800879:	83 ec 04             	sub    $0x4,%esp
  80087c:	ff 75 20             	pushl  0x20(%ebp)
  80087f:	53                   	push   %ebx
  800880:	ff 75 18             	pushl  0x18(%ebp)
  800883:	52                   	push   %edx
  800884:	50                   	push   %eax
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	ff 75 08             	pushl  0x8(%ebp)
  80088b:	e8 a1 ff ff ff       	call   800831 <printnum>
  800890:	83 c4 20             	add    $0x20,%esp
  800893:	eb 1a                	jmp    8008af <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	ff 75 0c             	pushl  0xc(%ebp)
  80089b:	ff 75 20             	pushl  0x20(%ebp)
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	ff d0                	call   *%eax
  8008a3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a6:	ff 4d 1c             	decl   0x1c(%ebp)
  8008a9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008ad:	7f e6                	jg     800895 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008af:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008bd:	53                   	push   %ebx
  8008be:	51                   	push   %ecx
  8008bf:	52                   	push   %edx
  8008c0:	50                   	push   %eax
  8008c1:	e8 c6 39 00 00       	call   80428c <__umoddi3>
  8008c6:	83 c4 10             	add    $0x10,%esp
  8008c9:	05 14 48 80 00       	add    $0x804814,%eax
  8008ce:	8a 00                	mov    (%eax),%al
  8008d0:	0f be c0             	movsbl %al,%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	50                   	push   %eax
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
}
  8008e2:	90                   	nop
  8008e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008eb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ef:	7e 1c                	jle    80090d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	8d 50 08             	lea    0x8(%eax),%edx
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	89 10                	mov    %edx,(%eax)
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	83 e8 08             	sub    $0x8,%eax
  800906:	8b 50 04             	mov    0x4(%eax),%edx
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	eb 40                	jmp    80094d <getuint+0x65>
	else if (lflag)
  80090d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800911:	74 1e                	je     800931 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	8d 50 04             	lea    0x4(%eax),%edx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	89 10                	mov    %edx,(%eax)
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	83 e8 04             	sub    $0x4,%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	ba 00 00 00 00       	mov    $0x0,%edx
  80092f:	eb 1c                	jmp    80094d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 00                	mov    (%eax),%eax
  800936:	8d 50 04             	lea    0x4(%eax),%edx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	89 10                	mov    %edx,(%eax)
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800952:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800956:	7e 1c                	jle    800974 <getint+0x25>
		return va_arg(*ap, long long);
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	8d 50 08             	lea    0x8(%eax),%edx
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	89 10                	mov    %edx,(%eax)
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8b 00                	mov    (%eax),%eax
  80096a:	83 e8 08             	sub    $0x8,%eax
  80096d:	8b 50 04             	mov    0x4(%eax),%edx
  800970:	8b 00                	mov    (%eax),%eax
  800972:	eb 38                	jmp    8009ac <getint+0x5d>
	else if (lflag)
  800974:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800978:	74 1a                	je     800994 <getint+0x45>
		return va_arg(*ap, long);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	8d 50 04             	lea    0x4(%eax),%edx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	89 10                	mov    %edx,(%eax)
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	83 e8 04             	sub    $0x4,%eax
  80098f:	8b 00                	mov    (%eax),%eax
  800991:	99                   	cltd   
  800992:	eb 18                	jmp    8009ac <getint+0x5d>
	else
		return va_arg(*ap, int);
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	8d 50 04             	lea    0x4(%eax),%edx
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	89 10                	mov    %edx,(%eax)
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	8b 00                	mov    (%eax),%eax
  8009a6:	83 e8 04             	sub    $0x4,%eax
  8009a9:	8b 00                	mov    (%eax),%eax
  8009ab:	99                   	cltd   
}
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	56                   	push   %esi
  8009b2:	53                   	push   %ebx
  8009b3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b6:	eb 17                	jmp    8009cf <vprintfmt+0x21>
			if (ch == '\0')
  8009b8:	85 db                	test   %ebx,%ebx
  8009ba:	0f 84 c1 03 00 00    	je     800d81 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	ff 75 0c             	pushl  0xc(%ebp)
  8009c6:	53                   	push   %ebx
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	ff d0                	call   *%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d2:	8d 50 01             	lea    0x1(%eax),%edx
  8009d5:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d8:	8a 00                	mov    (%eax),%al
  8009da:	0f b6 d8             	movzbl %al,%ebx
  8009dd:	83 fb 25             	cmp    $0x25,%ebx
  8009e0:	75 d6                	jne    8009b8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009e2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009e6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009ed:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009f4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	8d 50 01             	lea    0x1(%eax),%edx
  800a08:	89 55 10             	mov    %edx,0x10(%ebp)
  800a0b:	8a 00                	mov    (%eax),%al
  800a0d:	0f b6 d8             	movzbl %al,%ebx
  800a10:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a13:	83 f8 5b             	cmp    $0x5b,%eax
  800a16:	0f 87 3d 03 00 00    	ja     800d59 <vprintfmt+0x3ab>
  800a1c:	8b 04 85 38 48 80 00 	mov    0x804838(,%eax,4),%eax
  800a23:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a25:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a29:	eb d7                	jmp    800a02 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a2b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a2f:	eb d1                	jmp    800a02 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a31:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a3b:	89 d0                	mov    %edx,%eax
  800a3d:	c1 e0 02             	shl    $0x2,%eax
  800a40:	01 d0                	add    %edx,%eax
  800a42:	01 c0                	add    %eax,%eax
  800a44:	01 d8                	add    %ebx,%eax
  800a46:	83 e8 30             	sub    $0x30,%eax
  800a49:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4f:	8a 00                	mov    (%eax),%al
  800a51:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a54:	83 fb 2f             	cmp    $0x2f,%ebx
  800a57:	7e 3e                	jle    800a97 <vprintfmt+0xe9>
  800a59:	83 fb 39             	cmp    $0x39,%ebx
  800a5c:	7f 39                	jg     800a97 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a5e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a61:	eb d5                	jmp    800a38 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 c0 04             	add    $0x4,%eax
  800a69:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 e8 04             	sub    $0x4,%eax
  800a72:	8b 00                	mov    (%eax),%eax
  800a74:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a77:	eb 1f                	jmp    800a98 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7d:	79 83                	jns    800a02 <vprintfmt+0x54>
				width = 0;
  800a7f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a86:	e9 77 ff ff ff       	jmp    800a02 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a8b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a92:	e9 6b ff ff ff       	jmp    800a02 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a97:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a98:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9c:	0f 89 60 ff ff ff    	jns    800a02 <vprintfmt+0x54>
				width = precision, precision = -1;
  800aa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aa8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800aaf:	e9 4e ff ff ff       	jmp    800a02 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ab4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ab7:	e9 46 ff ff ff       	jmp    800a02 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 c0 04             	add    $0x4,%eax
  800ac2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	83 e8 04             	sub    $0x4,%eax
  800acb:	8b 00                	mov    (%eax),%eax
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	50                   	push   %eax
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	ff d0                	call   *%eax
  800ad9:	83 c4 10             	add    $0x10,%esp
			break;
  800adc:	e9 9b 02 00 00       	jmp    800d7c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ae1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae4:	83 c0 04             	add    $0x4,%eax
  800ae7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	83 e8 04             	sub    $0x4,%eax
  800af0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800af2:	85 db                	test   %ebx,%ebx
  800af4:	79 02                	jns    800af8 <vprintfmt+0x14a>
				err = -err;
  800af6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800af8:	83 fb 64             	cmp    $0x64,%ebx
  800afb:	7f 0b                	jg     800b08 <vprintfmt+0x15a>
  800afd:	8b 34 9d 80 46 80 00 	mov    0x804680(,%ebx,4),%esi
  800b04:	85 f6                	test   %esi,%esi
  800b06:	75 19                	jne    800b21 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b08:	53                   	push   %ebx
  800b09:	68 25 48 80 00       	push   $0x804825
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	ff 75 08             	pushl  0x8(%ebp)
  800b14:	e8 70 02 00 00       	call   800d89 <printfmt>
  800b19:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b1c:	e9 5b 02 00 00       	jmp    800d7c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b21:	56                   	push   %esi
  800b22:	68 2e 48 80 00       	push   $0x80482e
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	ff 75 08             	pushl  0x8(%ebp)
  800b2d:	e8 57 02 00 00       	call   800d89 <printfmt>
  800b32:	83 c4 10             	add    $0x10,%esp
			break;
  800b35:	e9 42 02 00 00       	jmp    800d7c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3d:	83 c0 04             	add    $0x4,%eax
  800b40:	89 45 14             	mov    %eax,0x14(%ebp)
  800b43:	8b 45 14             	mov    0x14(%ebp),%eax
  800b46:	83 e8 04             	sub    $0x4,%eax
  800b49:	8b 30                	mov    (%eax),%esi
  800b4b:	85 f6                	test   %esi,%esi
  800b4d:	75 05                	jne    800b54 <vprintfmt+0x1a6>
				p = "(null)";
  800b4f:	be 31 48 80 00       	mov    $0x804831,%esi
			if (width > 0 && padc != '-')
  800b54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b58:	7e 6d                	jle    800bc7 <vprintfmt+0x219>
  800b5a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b5e:	74 67                	je     800bc7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b63:	83 ec 08             	sub    $0x8,%esp
  800b66:	50                   	push   %eax
  800b67:	56                   	push   %esi
  800b68:	e8 1e 03 00 00       	call   800e8b <strnlen>
  800b6d:	83 c4 10             	add    $0x10,%esp
  800b70:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b73:	eb 16                	jmp    800b8b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b75:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	ff 75 0c             	pushl  0xc(%ebp)
  800b7f:	50                   	push   %eax
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	ff d0                	call   *%eax
  800b85:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b88:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8f:	7f e4                	jg     800b75 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b91:	eb 34                	jmp    800bc7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b93:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b97:	74 1c                	je     800bb5 <vprintfmt+0x207>
  800b99:	83 fb 1f             	cmp    $0x1f,%ebx
  800b9c:	7e 05                	jle    800ba3 <vprintfmt+0x1f5>
  800b9e:	83 fb 7e             	cmp    $0x7e,%ebx
  800ba1:	7e 12                	jle    800bb5 <vprintfmt+0x207>
					putch('?', putdat);
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	6a 3f                	push   $0x3f
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	ff d0                	call   *%eax
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	eb 0f                	jmp    800bc4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bb5:	83 ec 08             	sub    $0x8,%esp
  800bb8:	ff 75 0c             	pushl  0xc(%ebp)
  800bbb:	53                   	push   %ebx
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	ff d0                	call   *%eax
  800bc1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc4:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc7:	89 f0                	mov    %esi,%eax
  800bc9:	8d 70 01             	lea    0x1(%eax),%esi
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	0f be d8             	movsbl %al,%ebx
  800bd1:	85 db                	test   %ebx,%ebx
  800bd3:	74 24                	je     800bf9 <vprintfmt+0x24b>
  800bd5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bd9:	78 b8                	js     800b93 <vprintfmt+0x1e5>
  800bdb:	ff 4d e0             	decl   -0x20(%ebp)
  800bde:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800be2:	79 af                	jns    800b93 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be4:	eb 13                	jmp    800bf9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800be6:	83 ec 08             	sub    $0x8,%esp
  800be9:	ff 75 0c             	pushl  0xc(%ebp)
  800bec:	6a 20                	push   $0x20
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	ff d0                	call   *%eax
  800bf3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf6:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bfd:	7f e7                	jg     800be6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bff:	e9 78 01 00 00       	jmp    800d7c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c04:	83 ec 08             	sub    $0x8,%esp
  800c07:	ff 75 e8             	pushl  -0x18(%ebp)
  800c0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c0d:	50                   	push   %eax
  800c0e:	e8 3c fd ff ff       	call   80094f <getint>
  800c13:	83 c4 10             	add    $0x10,%esp
  800c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c22:	85 d2                	test   %edx,%edx
  800c24:	79 23                	jns    800c49 <vprintfmt+0x29b>
				putch('-', putdat);
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	6a 2d                	push   $0x2d
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	ff d0                	call   *%eax
  800c33:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3c:	f7 d8                	neg    %eax
  800c3e:	83 d2 00             	adc    $0x0,%edx
  800c41:	f7 da                	neg    %edx
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c50:	e9 bc 00 00 00       	jmp    800d11 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c55:	83 ec 08             	sub    $0x8,%esp
  800c58:	ff 75 e8             	pushl  -0x18(%ebp)
  800c5b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c5e:	50                   	push   %eax
  800c5f:	e8 84 fc ff ff       	call   8008e8 <getuint>
  800c64:	83 c4 10             	add    $0x10,%esp
  800c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c6d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c74:	e9 98 00 00 00       	jmp    800d11 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	ff 75 0c             	pushl  0xc(%ebp)
  800c7f:	6a 58                	push   $0x58
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	ff d0                	call   *%eax
  800c86:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 0c             	pushl  0xc(%ebp)
  800c8f:	6a 58                	push   $0x58
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	ff 75 0c             	pushl  0xc(%ebp)
  800c9f:	6a 58                	push   $0x58
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	ff d0                	call   *%eax
  800ca6:	83 c4 10             	add    $0x10,%esp
			break;
  800ca9:	e9 ce 00 00 00       	jmp    800d7c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cae:	83 ec 08             	sub    $0x8,%esp
  800cb1:	ff 75 0c             	pushl  0xc(%ebp)
  800cb4:	6a 30                	push   $0x30
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cbe:	83 ec 08             	sub    $0x8,%esp
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	6a 78                	push   $0x78
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cce:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd1:	83 c0 04             	add    $0x4,%eax
  800cd4:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cda:	83 e8 04             	sub    $0x4,%eax
  800cdd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ce9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cf0:	eb 1f                	jmp    800d11 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cf2:	83 ec 08             	sub    $0x8,%esp
  800cf5:	ff 75 e8             	pushl  -0x18(%ebp)
  800cf8:	8d 45 14             	lea    0x14(%ebp),%eax
  800cfb:	50                   	push   %eax
  800cfc:	e8 e7 fb ff ff       	call   8008e8 <getuint>
  800d01:	83 c4 10             	add    $0x10,%esp
  800d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d0a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d11:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d18:	83 ec 04             	sub    $0x4,%esp
  800d1b:	52                   	push   %edx
  800d1c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d1f:	50                   	push   %eax
  800d20:	ff 75 f4             	pushl  -0xc(%ebp)
  800d23:	ff 75 f0             	pushl  -0x10(%ebp)
  800d26:	ff 75 0c             	pushl  0xc(%ebp)
  800d29:	ff 75 08             	pushl  0x8(%ebp)
  800d2c:	e8 00 fb ff ff       	call   800831 <printnum>
  800d31:	83 c4 20             	add    $0x20,%esp
			break;
  800d34:	eb 46                	jmp    800d7c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	53                   	push   %ebx
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	ff d0                	call   *%eax
  800d42:	83 c4 10             	add    $0x10,%esp
			break;
  800d45:	eb 35                	jmp    800d7c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d47:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800d4e:	eb 2c                	jmp    800d7c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d50:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800d57:	eb 23                	jmp    800d7c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d59:	83 ec 08             	sub    $0x8,%esp
  800d5c:	ff 75 0c             	pushl  0xc(%ebp)
  800d5f:	6a 25                	push   $0x25
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	ff d0                	call   *%eax
  800d66:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d69:	ff 4d 10             	decl   0x10(%ebp)
  800d6c:	eb 03                	jmp    800d71 <vprintfmt+0x3c3>
  800d6e:	ff 4d 10             	decl   0x10(%ebp)
  800d71:	8b 45 10             	mov    0x10(%ebp),%eax
  800d74:	48                   	dec    %eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	3c 25                	cmp    $0x25,%al
  800d79:	75 f3                	jne    800d6e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d7b:	90                   	nop
		}
	}
  800d7c:	e9 35 fc ff ff       	jmp    8009b6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d81:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    

00800d89 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d92:	83 c0 04             	add    $0x4,%eax
  800d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d98:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9e:	50                   	push   %eax
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 08             	pushl  0x8(%ebp)
  800da5:	e8 04 fc ff ff       	call   8009ae <vprintfmt>
  800daa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dad:	90                   	nop
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	8b 40 08             	mov    0x8(%eax),%eax
  800db9:	8d 50 01             	lea    0x1(%eax),%edx
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8b 10                	mov    (%eax),%edx
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	8b 40 04             	mov    0x4(%eax),%eax
  800dcd:	39 c2                	cmp    %eax,%edx
  800dcf:	73 12                	jae    800de3 <sprintputch+0x33>
		*b->buf++ = ch;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8b 00                	mov    (%eax),%eax
  800dd6:	8d 48 01             	lea    0x1(%eax),%ecx
  800dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ddc:	89 0a                	mov    %ecx,(%edx)
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	88 10                	mov    %dl,(%eax)
}
  800de3:	90                   	nop
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	01 d0                	add    %edx,%eax
  800dfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e0b:	74 06                	je     800e13 <vsnprintf+0x2d>
  800e0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e11:	7f 07                	jg     800e1a <vsnprintf+0x34>
		return -E_INVAL;
  800e13:	b8 03 00 00 00       	mov    $0x3,%eax
  800e18:	eb 20                	jmp    800e3a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e1a:	ff 75 14             	pushl  0x14(%ebp)
  800e1d:	ff 75 10             	pushl  0x10(%ebp)
  800e20:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e23:	50                   	push   %eax
  800e24:	68 b0 0d 80 00       	push   $0x800db0
  800e29:	e8 80 fb ff ff       	call   8009ae <vprintfmt>
  800e2e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e34:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e42:	8d 45 10             	lea    0x10(%ebp),%eax
  800e45:	83 c0 04             	add    $0x4,%eax
  800e48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e51:	50                   	push   %eax
  800e52:	ff 75 0c             	pushl  0xc(%ebp)
  800e55:	ff 75 08             	pushl  0x8(%ebp)
  800e58:	e8 89 ff ff ff       	call   800de6 <vsnprintf>
  800e5d:	83 c4 10             	add    $0x10,%esp
  800e60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    

00800e68 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e75:	eb 06                	jmp    800e7d <strlen+0x15>
		n++;
  800e77:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	84 c0                	test   %al,%al
  800e84:	75 f1                	jne    800e77 <strlen+0xf>
		n++;
	return n;
  800e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e98:	eb 09                	jmp    800ea3 <strnlen+0x18>
		n++;
  800e9a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e9d:	ff 45 08             	incl   0x8(%ebp)
  800ea0:	ff 4d 0c             	decl   0xc(%ebp)
  800ea3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea7:	74 09                	je     800eb2 <strnlen+0x27>
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	84 c0                	test   %al,%al
  800eb0:	75 e8                	jne    800e9a <strnlen+0xf>
		n++;
	return n;
  800eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb5:	c9                   	leave  
  800eb6:	c3                   	ret    

00800eb7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ec3:	90                   	nop
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8d 50 01             	lea    0x1(%eax),%edx
  800eca:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed6:	8a 12                	mov    (%edx),%dl
  800ed8:	88 10                	mov    %dl,(%eax)
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	84 c0                	test   %al,%al
  800ede:	75 e4                	jne    800ec4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ef1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef8:	eb 1f                	jmp    800f19 <strncpy+0x34>
		*dst++ = *src;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8a 12                	mov    (%edx),%dl
  800f08:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	84 c0                	test   %al,%al
  800f11:	74 03                	je     800f16 <strncpy+0x31>
			src++;
  800f13:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f16:	ff 45 fc             	incl   -0x4(%ebp)
  800f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f1f:	72 d9                	jb     800efa <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f21:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f36:	74 30                	je     800f68 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f38:	eb 16                	jmp    800f50 <strlcpy+0x2a>
			*dst++ = *src++;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8d 50 01             	lea    0x1(%eax),%edx
  800f40:	89 55 08             	mov    %edx,0x8(%ebp)
  800f43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f46:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f49:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f4c:	8a 12                	mov    (%edx),%dl
  800f4e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f50:	ff 4d 10             	decl   0x10(%ebp)
  800f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f57:	74 09                	je     800f62 <strlcpy+0x3c>
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	84 c0                	test   %al,%al
  800f60:	75 d8                	jne    800f3a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f68:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6e:	29 c2                	sub    %eax,%edx
  800f70:	89 d0                	mov    %edx,%eax
}
  800f72:	c9                   	leave  
  800f73:	c3                   	ret    

00800f74 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f74:	55                   	push   %ebp
  800f75:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f77:	eb 06                	jmp    800f7f <strcmp+0xb>
		p++, q++;
  800f79:	ff 45 08             	incl   0x8(%ebp)
  800f7c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	84 c0                	test   %al,%al
  800f86:	74 0e                	je     800f96 <strcmp+0x22>
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 10                	mov    (%eax),%dl
  800f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	38 c2                	cmp    %al,%dl
  800f94:	74 e3                	je     800f79 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	0f b6 d0             	movzbl %al,%edx
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	0f b6 c0             	movzbl %al,%eax
  800fa6:	29 c2                	sub    %eax,%edx
  800fa8:	89 d0                	mov    %edx,%eax
}
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    

00800fac <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800faf:	eb 09                	jmp    800fba <strncmp+0xe>
		n--, p++, q++;
  800fb1:	ff 4d 10             	decl   0x10(%ebp)
  800fb4:	ff 45 08             	incl   0x8(%ebp)
  800fb7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbe:	74 17                	je     800fd7 <strncmp+0x2b>
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	84 c0                	test   %al,%al
  800fc7:	74 0e                	je     800fd7 <strncmp+0x2b>
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 10                	mov    (%eax),%dl
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	38 c2                	cmp    %al,%dl
  800fd5:	74 da                	je     800fb1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdb:	75 07                	jne    800fe4 <strncmp+0x38>
		return 0;
  800fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe2:	eb 14                	jmp    800ff8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	0f b6 d0             	movzbl %al,%edx
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f b6 c0             	movzbl %al,%eax
  800ff4:	29 c2                	sub    %eax,%edx
  800ff6:	89 d0                	mov    %edx,%eax
}
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 04             	sub    $0x4,%esp
  801000:	8b 45 0c             	mov    0xc(%ebp),%eax
  801003:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801006:	eb 12                	jmp    80101a <strchr+0x20>
		if (*s == c)
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801010:	75 05                	jne    801017 <strchr+0x1d>
			return (char *) s;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	eb 11                	jmp    801028 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801017:	ff 45 08             	incl   0x8(%ebp)
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 e5                	jne    801008 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801023:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 04             	sub    $0x4,%esp
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801036:	eb 0d                	jmp    801045 <strfind+0x1b>
		if (*s == c)
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801040:	74 0e                	je     801050 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8a 00                	mov    (%eax),%al
  80104a:	84 c0                	test   %al,%al
  80104c:	75 ea                	jne    801038 <strfind+0xe>
  80104e:	eb 01                	jmp    801051 <strfind+0x27>
		if (*s == c)
			break;
  801050:	90                   	nop
	return (char *) s;
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801054:	c9                   	leave  
  801055:	c3                   	ret    

00801056 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801062:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801066:	76 63                	jbe    8010cb <memset+0x75>
		uint64 data_block = c;
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	99                   	cltd   
  80106c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80106f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801078:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80107c:	c1 e0 08             	shl    $0x8,%eax
  80107f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801082:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801088:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80108f:	c1 e0 10             	shl    $0x10,%eax
  801092:	09 45 f0             	or     %eax,-0x10(%ebp)
  801095:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80109e:	89 c2                	mov    %eax,%edx
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a5:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010a8:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8010ab:	eb 18                	jmp    8010c5 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8010ad:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b0:	8d 41 08             	lea    0x8(%ecx),%eax
  8010b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010bc:	89 01                	mov    %eax,(%ecx)
  8010be:	89 51 04             	mov    %edx,0x4(%ecx)
  8010c1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010c5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010c9:	77 e2                	ja     8010ad <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cf:	74 23                	je     8010f4 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010d7:	eb 0e                	jmp    8010e7 <memset+0x91>
			*p8++ = (uint8)c;
  8010d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dc:	8d 50 01             	lea    0x1(%eax),%edx
  8010df:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e5:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	75 e5                	jne    8010d9 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801102:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80110b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80110f:	76 24                	jbe    801135 <memcpy+0x3c>
		while(n >= 8){
  801111:	eb 1c                	jmp    80112f <memcpy+0x36>
			*d64 = *s64;
  801113:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801116:	8b 50 04             	mov    0x4(%eax),%edx
  801119:	8b 00                	mov    (%eax),%eax
  80111b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80111e:	89 01                	mov    %eax,(%ecx)
  801120:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801123:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801127:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80112b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80112f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801133:	77 de                	ja     801113 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801135:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801139:	74 31                	je     80116c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80113b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801141:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801144:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801147:	eb 16                	jmp    80115f <memcpy+0x66>
			*d8++ = *s8++;
  801149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114c:	8d 50 01             	lea    0x1(%eax),%edx
  80114f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801152:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801155:	8d 4a 01             	lea    0x1(%edx),%ecx
  801158:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80115b:	8a 12                	mov    (%edx),%dl
  80115d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80115f:	8b 45 10             	mov    0x10(%ebp),%eax
  801162:	8d 50 ff             	lea    -0x1(%eax),%edx
  801165:	89 55 10             	mov    %edx,0x10(%ebp)
  801168:	85 c0                	test   %eax,%eax
  80116a:	75 dd                	jne    801149 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801183:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801186:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801189:	73 50                	jae    8011db <memmove+0x6a>
  80118b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118e:	8b 45 10             	mov    0x10(%ebp),%eax
  801191:	01 d0                	add    %edx,%eax
  801193:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801196:	76 43                	jbe    8011db <memmove+0x6a>
		s += n;
  801198:	8b 45 10             	mov    0x10(%ebp),%eax
  80119b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80119e:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011a4:	eb 10                	jmp    8011b6 <memmove+0x45>
			*--d = *--s;
  8011a6:	ff 4d f8             	decl   -0x8(%ebp)
  8011a9:	ff 4d fc             	decl   -0x4(%ebp)
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	8a 10                	mov    (%eax),%dl
  8011b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	75 e3                	jne    8011a6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011c3:	eb 23                	jmp    8011e8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	8d 50 01             	lea    0x1(%eax),%edx
  8011cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011d7:	8a 12                	mov    (%edx),%dl
  8011d9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011db:	8b 45 10             	mov    0x10(%ebp),%eax
  8011de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	75 dd                	jne    8011c5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011ff:	eb 2a                	jmp    80122b <memcmp+0x3e>
		if (*s1 != *s2)
  801201:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801204:	8a 10                	mov    (%eax),%dl
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	38 c2                	cmp    %al,%dl
  80120d:	74 16                	je     801225 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80120f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	0f b6 d0             	movzbl %al,%edx
  801217:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	0f b6 c0             	movzbl %al,%eax
  80121f:	29 c2                	sub    %eax,%edx
  801221:	89 d0                	mov    %edx,%eax
  801223:	eb 18                	jmp    80123d <memcmp+0x50>
		s1++, s2++;
  801225:	ff 45 fc             	incl   -0x4(%ebp)
  801228:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80122b:	8b 45 10             	mov    0x10(%ebp),%eax
  80122e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801231:	89 55 10             	mov    %edx,0x10(%ebp)
  801234:	85 c0                	test   %eax,%eax
  801236:	75 c9                	jne    801201 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801238:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801245:	8b 55 08             	mov    0x8(%ebp),%edx
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801250:	eb 15                	jmp    801267 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	0f b6 d0             	movzbl %al,%edx
  80125a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125d:	0f b6 c0             	movzbl %al,%eax
  801260:	39 c2                	cmp    %eax,%edx
  801262:	74 0d                	je     801271 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801264:	ff 45 08             	incl   0x8(%ebp)
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80126d:	72 e3                	jb     801252 <memfind+0x13>
  80126f:	eb 01                	jmp    801272 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801271:	90                   	nop
	return (void *) s;
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80127d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801284:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80128b:	eb 03                	jmp    801290 <strtol+0x19>
		s++;
  80128d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	3c 20                	cmp    $0x20,%al
  801297:	74 f4                	je     80128d <strtol+0x16>
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	3c 09                	cmp    $0x9,%al
  8012a0:	74 eb                	je     80128d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 2b                	cmp    $0x2b,%al
  8012a9:	75 05                	jne    8012b0 <strtol+0x39>
		s++;
  8012ab:	ff 45 08             	incl   0x8(%ebp)
  8012ae:	eb 13                	jmp    8012c3 <strtol+0x4c>
	else if (*s == '-')
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	3c 2d                	cmp    $0x2d,%al
  8012b7:	75 0a                	jne    8012c3 <strtol+0x4c>
		s++, neg = 1;
  8012b9:	ff 45 08             	incl   0x8(%ebp)
  8012bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c7:	74 06                	je     8012cf <strtol+0x58>
  8012c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012cd:	75 20                	jne    8012ef <strtol+0x78>
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	3c 30                	cmp    $0x30,%al
  8012d6:	75 17                	jne    8012ef <strtol+0x78>
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	40                   	inc    %eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	3c 78                	cmp    $0x78,%al
  8012e0:	75 0d                	jne    8012ef <strtol+0x78>
		s += 2, base = 16;
  8012e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012ed:	eb 28                	jmp    801317 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f3:	75 15                	jne    80130a <strtol+0x93>
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3c 30                	cmp    $0x30,%al
  8012fc:	75 0c                	jne    80130a <strtol+0x93>
		s++, base = 8;
  8012fe:	ff 45 08             	incl   0x8(%ebp)
  801301:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801308:	eb 0d                	jmp    801317 <strtol+0xa0>
	else if (base == 0)
  80130a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80130e:	75 07                	jne    801317 <strtol+0xa0>
		base = 10;
  801310:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	3c 2f                	cmp    $0x2f,%al
  80131e:	7e 19                	jle    801339 <strtol+0xc2>
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	3c 39                	cmp    $0x39,%al
  801327:	7f 10                	jg     801339 <strtol+0xc2>
			dig = *s - '0';
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	0f be c0             	movsbl %al,%eax
  801331:	83 e8 30             	sub    $0x30,%eax
  801334:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801337:	eb 42                	jmp    80137b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	3c 60                	cmp    $0x60,%al
  801340:	7e 19                	jle    80135b <strtol+0xe4>
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	8a 00                	mov    (%eax),%al
  801347:	3c 7a                	cmp    $0x7a,%al
  801349:	7f 10                	jg     80135b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	0f be c0             	movsbl %al,%eax
  801353:	83 e8 57             	sub    $0x57,%eax
  801356:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801359:	eb 20                	jmp    80137b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8a 00                	mov    (%eax),%al
  801360:	3c 40                	cmp    $0x40,%al
  801362:	7e 39                	jle    80139d <strtol+0x126>
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	8a 00                	mov    (%eax),%al
  801369:	3c 5a                	cmp    $0x5a,%al
  80136b:	7f 30                	jg     80139d <strtol+0x126>
			dig = *s - 'A' + 10;
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	8a 00                	mov    (%eax),%al
  801372:	0f be c0             	movsbl %al,%eax
  801375:	83 e8 37             	sub    $0x37,%eax
  801378:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80137b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801381:	7d 19                	jge    80139c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801383:	ff 45 08             	incl   0x8(%ebp)
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801389:	0f af 45 10          	imul   0x10(%ebp),%eax
  80138d:	89 c2                	mov    %eax,%edx
  80138f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801392:	01 d0                	add    %edx,%eax
  801394:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801397:	e9 7b ff ff ff       	jmp    801317 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80139c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80139d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013a1:	74 08                	je     8013ab <strtol+0x134>
		*endptr = (char *) s;
  8013a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013af:	74 07                	je     8013b8 <strtol+0x141>
  8013b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b4:	f7 d8                	neg    %eax
  8013b6:	eb 03                	jmp    8013bb <strtol+0x144>
  8013b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <ltostr>:

void
ltostr(long value, char *str)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d5:	79 13                	jns    8013ea <ltostr+0x2d>
	{
		neg = 1;
  8013d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013e4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013e7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013f2:	99                   	cltd   
  8013f3:	f7 f9                	idiv   %ecx
  8013f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fb:	8d 50 01             	lea    0x1(%eax),%edx
  8013fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801401:	89 c2                	mov    %eax,%edx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	01 d0                	add    %edx,%eax
  801408:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80140b:	83 c2 30             	add    $0x30,%edx
  80140e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801410:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801413:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801418:	f7 e9                	imul   %ecx
  80141a:	c1 fa 02             	sar    $0x2,%edx
  80141d:	89 c8                	mov    %ecx,%eax
  80141f:	c1 f8 1f             	sar    $0x1f,%eax
  801422:	29 c2                	sub    %eax,%edx
  801424:	89 d0                	mov    %edx,%eax
  801426:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801429:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80142d:	75 bb                	jne    8013ea <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80142f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801436:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801439:	48                   	dec    %eax
  80143a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80143d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801441:	74 3d                	je     801480 <ltostr+0xc3>
		start = 1 ;
  801443:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80144a:	eb 34                	jmp    801480 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80144c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801452:	01 d0                	add    %edx,%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801459:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	01 c2                	add    %eax,%edx
  801461:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	01 c8                	add    %ecx,%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80146d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 c2                	add    %eax,%edx
  801475:	8a 45 eb             	mov    -0x15(%ebp),%al
  801478:	88 02                	mov    %al,(%edx)
		start++ ;
  80147a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80147d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801483:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801486:	7c c4                	jl     80144c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801488:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80148b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801493:	90                   	nop
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80149c:	ff 75 08             	pushl  0x8(%ebp)
  80149f:	e8 c4 f9 ff ff       	call   800e68 <strlen>
  8014a4:	83 c4 04             	add    $0x4,%esp
  8014a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014aa:	ff 75 0c             	pushl  0xc(%ebp)
  8014ad:	e8 b6 f9 ff ff       	call   800e68 <strlen>
  8014b2:	83 c4 04             	add    $0x4,%esp
  8014b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c6:	eb 17                	jmp    8014df <strcconcat+0x49>
		final[s] = str1[s] ;
  8014c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ce:	01 c2                	add    %eax,%edx
  8014d0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	01 c8                	add    %ecx,%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014dc:	ff 45 fc             	incl   -0x4(%ebp)
  8014df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014e5:	7c e1                	jl     8014c8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014f5:	eb 1f                	jmp    801516 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fa:	8d 50 01             	lea    0x1(%eax),%edx
  8014fd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801500:	89 c2                	mov    %eax,%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 c2                	add    %eax,%edx
  801507:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	01 c8                	add    %ecx,%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801513:	ff 45 f8             	incl   -0x8(%ebp)
  801516:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801519:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80151c:	7c d9                	jl     8014f7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80151e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801521:	8b 45 10             	mov    0x10(%ebp),%eax
  801524:	01 d0                	add    %edx,%eax
  801526:	c6 00 00             	movb   $0x0,(%eax)
}
  801529:	90                   	nop
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80152f:	8b 45 14             	mov    0x14(%ebp),%eax
  801532:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801538:	8b 45 14             	mov    0x14(%ebp),%eax
  80153b:	8b 00                	mov    (%eax),%eax
  80153d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154f:	eb 0c                	jmp    80155d <strsplit+0x31>
			*string++ = 0;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	8d 50 01             	lea    0x1(%eax),%edx
  801557:	89 55 08             	mov    %edx,0x8(%ebp)
  80155a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	84 c0                	test   %al,%al
  801564:	74 18                	je     80157e <strsplit+0x52>
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	8a 00                	mov    (%eax),%al
  80156b:	0f be c0             	movsbl %al,%eax
  80156e:	50                   	push   %eax
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	e8 83 fa ff ff       	call   800ffa <strchr>
  801577:	83 c4 08             	add    $0x8,%esp
  80157a:	85 c0                	test   %eax,%eax
  80157c:	75 d3                	jne    801551 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	84 c0                	test   %al,%al
  801585:	74 5a                	je     8015e1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801587:	8b 45 14             	mov    0x14(%ebp),%eax
  80158a:	8b 00                	mov    (%eax),%eax
  80158c:	83 f8 0f             	cmp    $0xf,%eax
  80158f:	75 07                	jne    801598 <strsplit+0x6c>
		{
			return 0;
  801591:	b8 00 00 00 00       	mov    $0x0,%eax
  801596:	eb 66                	jmp    8015fe <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801598:	8b 45 14             	mov    0x14(%ebp),%eax
  80159b:	8b 00                	mov    (%eax),%eax
  80159d:	8d 48 01             	lea    0x1(%eax),%ecx
  8015a0:	8b 55 14             	mov    0x14(%ebp),%edx
  8015a3:	89 0a                	mov    %ecx,(%edx)
  8015a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8015af:	01 c2                	add    %eax,%edx
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015b6:	eb 03                	jmp    8015bb <strsplit+0x8f>
			string++;
  8015b8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	84 c0                	test   %al,%al
  8015c2:	74 8b                	je     80154f <strsplit+0x23>
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	0f be c0             	movsbl %al,%eax
  8015cc:	50                   	push   %eax
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	e8 25 fa ff ff       	call   800ffa <strchr>
  8015d5:	83 c4 08             	add    $0x8,%esp
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	74 dc                	je     8015b8 <strsplit+0x8c>
			string++;
	}
  8015dc:	e9 6e ff ff ff       	jmp    80154f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015e1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e5:	8b 00                	mov    (%eax),%eax
  8015e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015f9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80160c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801613:	eb 4a                	jmp    80165f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801615:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	01 c2                	add    %eax,%edx
  80161d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801620:	8b 45 0c             	mov    0xc(%ebp),%eax
  801623:	01 c8                	add    %ecx,%eax
  801625:	8a 00                	mov    (%eax),%al
  801627:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801629:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162f:	01 d0                	add    %edx,%eax
  801631:	8a 00                	mov    (%eax),%al
  801633:	3c 40                	cmp    $0x40,%al
  801635:	7e 25                	jle    80165c <str2lower+0x5c>
  801637:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	01 d0                	add    %edx,%eax
  80163f:	8a 00                	mov    (%eax),%al
  801641:	3c 5a                	cmp    $0x5a,%al
  801643:	7f 17                	jg     80165c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801645:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	01 d0                	add    %edx,%eax
  80164d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801650:	8b 55 08             	mov    0x8(%ebp),%edx
  801653:	01 ca                	add    %ecx,%edx
  801655:	8a 12                	mov    (%edx),%dl
  801657:	83 c2 20             	add    $0x20,%edx
  80165a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80165c:	ff 45 fc             	incl   -0x4(%ebp)
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	e8 01 f8 ff ff       	call   800e68 <strlen>
  801667:	83 c4 04             	add    $0x4,%esp
  80166a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80166d:	7f a6                	jg     801615 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80167a:	a1 08 50 80 00       	mov    0x805008,%eax
  80167f:	85 c0                	test   %eax,%eax
  801681:	74 42                	je     8016c5 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801683:	83 ec 08             	sub    $0x8,%esp
  801686:	68 00 00 00 82       	push   $0x82000000
  80168b:	68 00 00 00 80       	push   $0x80000000
  801690:	e8 b0 1e 00 00       	call   803545 <initialize_dynamic_allocator>
  801695:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801698:	e8 96 1c 00 00       	call   803333 <sys_get_uheap_strategy>
  80169d:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8016a2:	a1 60 d0 81 00       	mov    0x81d060,%eax
  8016a7:	05 00 10 00 00       	add    $0x1000,%eax
  8016ac:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  8016b1:	a1 30 51 83 00       	mov    0x835130,%eax
  8016b6:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8016bb:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8016c2:	00 00 00 
	}
}
  8016c5:	90                   	nop
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016dc:	83 ec 08             	sub    $0x8,%esp
  8016df:	68 06 04 00 00       	push   $0x406
  8016e4:	50                   	push   %eax
  8016e5:	e8 93 18 00 00       	call   802f7d <__sys_allocate_page>
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f4:	79 14                	jns    80170a <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	68 a8 49 80 00       	push   $0x8049a8
  8016fe:	6a 1f                	push   $0x1f
  801700:	68 e4 49 80 00       	push   $0x8049e4
  801705:	e8 82 28 00 00       	call   803f8c <_panic>
	return 0;
  80170a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801720:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801725:	83 ec 0c             	sub    $0xc,%esp
  801728:	50                   	push   %eax
  801729:	e8 96 18 00 00       	call   802fc4 <__sys_unmap_frame>
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801738:	79 14                	jns    80174e <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	68 f0 49 80 00       	push   $0x8049f0
  801742:	6a 2a                	push   $0x2a
  801744:	68 e4 49 80 00       	push   $0x8049e4
  801749:	e8 3e 28 00 00       	call   803f8c <_panic>
}
  80174e:	90                   	nop
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801757:	e8 18 ff ff ff       	call   801674 <uheap_init>
	if (size == 0) return NULL ;
  80175c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801760:	75 0a                	jne    80176c <malloc+0x1b>
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
  801767:	e9 43 03 00 00       	jmp    801aaf <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80176c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801773:	77 13                	ja     801788 <malloc+0x37>
    {
        return alloc_block(size);
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	ff 75 08             	pushl  0x8(%ebp)
  80177b:	e8 78 20 00 00       	call   8037f8 <alloc_block>
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	e9 27 03 00 00       	jmp    801aaf <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801788:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80178f:	8b 55 08             	mov    0x8(%ebp),%edx
  801792:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801795:	01 d0                	add    %edx,%eax
  801797:	48                   	dec    %eax
  801798:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80179b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80179e:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a3:	f7 75 dc             	divl   -0x24(%ebp)
  8017a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017a9:	29 d0                	sub    %edx,%eax
  8017ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  8017ae:	a1 40 d0 81 00       	mov    0x81d040,%eax
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	75 0a                	jne    8017c1 <malloc+0x70>
    {
        uhp_inited = 1;
  8017b7:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  8017be:	00 00 00 
    }

    int exactIdx = -1;
  8017c1:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8017c8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8017cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8017d6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8017dd:	e9 85 00 00 00       	jmp    801867 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8017e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017e5:	89 d0                	mov    %edx,%eax
  8017e7:	01 c0                	add    %eax,%eax
  8017e9:	01 d0                	add    %edx,%eax
  8017eb:	c1 e0 02             	shl    $0x2,%eax
  8017ee:	05 48 10 81 00       	add    $0x811048,%eax
  8017f3:	8a 00                	mov    (%eax),%al
  8017f5:	84 c0                	test   %al,%al
  8017f7:	74 20                	je     801819 <malloc+0xc8>
  8017f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017fc:	89 d0                	mov    %edx,%eax
  8017fe:	01 c0                	add    %eax,%eax
  801800:	01 d0                	add    %edx,%eax
  801802:	c1 e0 02             	shl    $0x2,%eax
  801805:	05 44 10 81 00       	add    $0x811044,%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80180f:	75 08                	jne    801819 <malloc+0xc8>
        {
            exactIdx = i;
  801811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801814:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801817:	eb 5b                	jmp    801874 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801819:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80181c:	89 d0                	mov    %edx,%eax
  80181e:	01 c0                	add    %eax,%eax
  801820:	01 d0                	add    %edx,%eax
  801822:	c1 e0 02             	shl    $0x2,%eax
  801825:	05 48 10 81 00       	add    $0x811048,%eax
  80182a:	8a 00                	mov    (%eax),%al
  80182c:	84 c0                	test   %al,%al
  80182e:	74 34                	je     801864 <malloc+0x113>
  801830:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801833:	89 d0                	mov    %edx,%eax
  801835:	01 c0                	add    %eax,%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	c1 e0 02             	shl    $0x2,%eax
  80183c:	05 44 10 81 00       	add    $0x811044,%eax
  801841:	8b 00                	mov    (%eax),%eax
  801843:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801846:	76 1c                	jbe    801864 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801848:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80184b:	89 d0                	mov    %edx,%eax
  80184d:	01 c0                	add    %eax,%eax
  80184f:	01 d0                	add    %edx,%eax
  801851:	c1 e0 02             	shl    $0x2,%eax
  801854:	05 44 10 81 00       	add    $0x811044,%eax
  801859:	8b 00                	mov    (%eax),%eax
  80185b:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80185e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801861:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801864:	ff 45 e8             	incl   -0x18(%ebp)
  801867:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80186e:	0f 8e 6e ff ff ff    	jle    8017e2 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801874:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80187b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80187f:	74 7d                	je     8018fe <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801881:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801888:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188b:	89 d0                	mov    %edx,%eax
  80188d:	01 c0                	add    %eax,%eax
  80188f:	01 d0                	add    %edx,%eax
  801891:	c1 e0 02             	shl    $0x2,%eax
  801894:	05 40 10 81 00       	add    $0x811040,%eax
  801899:	8b 10                	mov    (%eax),%edx
  80189b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80189e:	01 d0                	add    %edx,%eax
  8018a0:	48                   	dec    %eax
  8018a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8018a4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8018a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ac:	f7 75 bc             	divl   -0x44(%ebp)
  8018af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8018b2:	29 d0                	sub    %edx,%eax
  8018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8018b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ba:	89 d0                	mov    %edx,%eax
  8018bc:	01 c0                	add    %eax,%eax
  8018be:	01 d0                	add    %edx,%eax
  8018c0:	c1 e0 02             	shl    $0x2,%eax
  8018c3:	05 48 10 81 00       	add    $0x811048,%eax
  8018c8:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8018cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ce:	89 d0                	mov    %edx,%eax
  8018d0:	01 c0                	add    %eax,%eax
  8018d2:	01 d0                	add    %edx,%eax
  8018d4:	c1 e0 02             	shl    $0x2,%eax
  8018d7:	05 44 10 81 00       	add    $0x811044,%eax
  8018dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8018e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e5:	89 d0                	mov    %edx,%eax
  8018e7:	01 c0                	add    %eax,%eax
  8018e9:	01 d0                	add    %edx,%eax
  8018eb:	c1 e0 02             	shl    $0x2,%eax
  8018ee:	05 40 10 81 00       	add    $0x811040,%eax
  8018f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018f9:	e9 2d 01 00 00       	jmp    801a2b <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8018fe:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801902:	0f 84 ce 00 00 00    	je     8019d6 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801908:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80190f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801912:	89 d0                	mov    %edx,%eax
  801914:	01 c0                	add    %eax,%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	c1 e0 02             	shl    $0x2,%eax
  80191b:	05 40 10 81 00       	add    $0x811040,%eax
  801920:	8b 10                	mov    (%eax),%edx
  801922:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801925:	01 d0                	add    %edx,%eax
  801927:	48                   	dec    %eax
  801928:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80192b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80192e:	ba 00 00 00 00       	mov    $0x0,%edx
  801933:	f7 75 c4             	divl   -0x3c(%ebp)
  801936:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801939:	29 d0                	sub    %edx,%eax
  80193b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80193e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801941:	89 d0                	mov    %edx,%eax
  801943:	01 c0                	add    %eax,%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	c1 e0 02             	shl    $0x2,%eax
  80194a:	05 44 10 81 00       	add    $0x811044,%eax
  80194f:	8b 00                	mov    (%eax),%eax
  801951:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801954:	75 47                	jne    80199d <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801956:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801959:	89 d0                	mov    %edx,%eax
  80195b:	01 c0                	add    %eax,%eax
  80195d:	01 d0                	add    %edx,%eax
  80195f:	c1 e0 02             	shl    $0x2,%eax
  801962:	05 48 10 81 00       	add    $0x811048,%eax
  801967:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80196a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80196d:	89 d0                	mov    %edx,%eax
  80196f:	01 c0                	add    %eax,%eax
  801971:	01 d0                	add    %edx,%eax
  801973:	c1 e0 02             	shl    $0x2,%eax
  801976:	05 44 10 81 00       	add    $0x811044,%eax
  80197b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801981:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801984:	89 d0                	mov    %edx,%eax
  801986:	01 c0                	add    %eax,%eax
  801988:	01 d0                	add    %edx,%eax
  80198a:	c1 e0 02             	shl    $0x2,%eax
  80198d:	05 40 10 81 00       	add    $0x811040,%eax
  801992:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801998:	e9 8e 00 00 00       	jmp    801a2b <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80199d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019a3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8019a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019a9:	89 d0                	mov    %edx,%eax
  8019ab:	01 c0                	add    %eax,%eax
  8019ad:	01 d0                	add    %edx,%eax
  8019af:	c1 e0 02             	shl    $0x2,%eax
  8019b2:	05 40 10 81 00       	add    $0x811040,%eax
  8019b7:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8019b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019bc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8019bf:	89 c2                	mov    %eax,%edx
  8019c1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019c4:	89 c8                	mov    %ecx,%eax
  8019c6:	01 c0                	add    %eax,%eax
  8019c8:	01 c8                	add    %ecx,%eax
  8019ca:	c1 e0 02             	shl    $0x2,%eax
  8019cd:	05 44 10 81 00       	add    $0x811044,%eax
  8019d2:	89 10                	mov    %edx,(%eax)
  8019d4:	eb 55                	jmp    801a2b <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8019d6:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8019dd:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8019e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019e6:	01 d0                	add    %edx,%eax
  8019e8:	48                   	dec    %eax
  8019e9:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8019ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f4:	f7 75 d0             	divl   -0x30(%ebp)
  8019f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8019fa:	29 d0                	sub    %edx,%eax
  8019fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8019ff:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801a02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a05:	01 d0                	add    %edx,%eax
  801a07:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801a0c:	76 0a                	jbe    801a18 <malloc+0x2c7>
            return NULL;
  801a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a13:	e9 97 00 00 00       	jmp    801aaf <malloc+0x35e>
        va = start;
  801a18:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801a1e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801a21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a24:	01 d0                	add    %edx,%eax
  801a26:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a2b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a32:	eb 5e                	jmp    801a92 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801a34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a37:	89 d0                	mov    %edx,%eax
  801a39:	01 c0                	add    %eax,%eax
  801a3b:	01 d0                	add    %edx,%eax
  801a3d:	c1 e0 02             	shl    $0x2,%eax
  801a40:	05 48 50 80 00       	add    $0x805048,%eax
  801a45:	8a 00                	mov    (%eax),%al
  801a47:	84 c0                	test   %al,%al
  801a49:	75 44                	jne    801a8f <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801a4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a4e:	89 d0                	mov    %edx,%eax
  801a50:	01 c0                	add    %eax,%eax
  801a52:	01 d0                	add    %edx,%eax
  801a54:	c1 e0 02             	shl    $0x2,%eax
  801a57:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a60:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801a62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a65:	89 d0                	mov    %edx,%eax
  801a67:	01 c0                	add    %eax,%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	c1 e0 02             	shl    $0x2,%eax
  801a6e:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  801a74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a77:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801a79:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a7c:	89 d0                	mov    %edx,%eax
  801a7e:	01 c0                	add    %eax,%eax
  801a80:	01 d0                	add    %edx,%eax
  801a82:	c1 e0 02             	shl    $0x2,%eax
  801a85:	05 48 50 80 00       	add    $0x805048,%eax
  801a8a:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801a8d:	eb 0c                	jmp    801a9b <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a8f:	ff 45 e0             	incl   -0x20(%ebp)
  801a92:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801a99:	7e 99                	jle    801a34 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801a9b:	83 ec 08             	sub    $0x8,%esp
  801a9e:	ff 75 d4             	pushl  -0x2c(%ebp)
  801aa1:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aa4:	e8 a2 19 00 00       	call   80344b <sys_allocate_user_mem>
  801aa9:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801aac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801ab7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801abb:	0f 84 fa 03 00 00    	je     801ebb <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801ac7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801aca:	85 c0                	test   %eax,%eax
  801acc:	79 1c                	jns    801aea <free+0x39>
  801ace:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801ad5:	77 13                	ja     801aea <free+0x39>
    {
        free_block(virtual_address);
  801ad7:	83 ec 0c             	sub    $0xc,%esp
  801ada:	ff 75 08             	pushl  0x8(%ebp)
  801add:	e8 09 21 00 00       	call   803beb <free_block>
  801ae2:	83 c4 10             	add    $0x10,%esp
        return;
  801ae5:	e9 d2 03 00 00       	jmp    801ebc <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801aea:	a1 30 51 83 00       	mov    0x835130,%eax
  801aef:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801af2:	72 09                	jb     801afd <free+0x4c>
  801af4:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801afb:	76 17                	jbe    801b14 <free+0x63>
        panic("free: invalid address");
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	68 2d 4a 80 00       	push   $0x804a2d
  801b05:	68 9b 00 00 00       	push   $0x9b
  801b0a:	68 e4 49 80 00       	push   $0x8049e4
  801b0f:	e8 78 24 00 00       	call   803f8c <_panic>

    uint32 size = 0;
  801b14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801b1b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b22:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801b29:	eb 50                	jmp    801b7b <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801b2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b2e:	89 d0                	mov    %edx,%eax
  801b30:	01 c0                	add    %eax,%eax
  801b32:	01 d0                	add    %edx,%eax
  801b34:	c1 e0 02             	shl    $0x2,%eax
  801b37:	05 48 50 80 00       	add    $0x805048,%eax
  801b3c:	8a 00                	mov    (%eax),%al
  801b3e:	84 c0                	test   %al,%al
  801b40:	74 36                	je     801b78 <free+0xc7>
  801b42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b45:	89 d0                	mov    %edx,%eax
  801b47:	01 c0                	add    %eax,%eax
  801b49:	01 d0                	add    %edx,%eax
  801b4b:	c1 e0 02             	shl    $0x2,%eax
  801b4e:	05 40 50 80 00       	add    $0x805040,%eax
  801b53:	8b 00                	mov    (%eax),%eax
  801b55:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b58:	75 1e                	jne    801b78 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801b5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b5d:	89 d0                	mov    %edx,%eax
  801b5f:	01 c0                	add    %eax,%eax
  801b61:	01 d0                	add    %edx,%eax
  801b63:	c1 e0 02             	shl    $0x2,%eax
  801b66:	05 44 50 80 00       	add    $0x805044,%eax
  801b6b:	8b 00                	mov    (%eax),%eax
  801b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801b76:	eb 0c                	jmp    801b84 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b78:	ff 45 ec             	incl   -0x14(%ebp)
  801b7b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801b82:	7e a7                	jle    801b2b <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801b84:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b88:	74 06                	je     801b90 <free+0xdf>
  801b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b8e:	75 17                	jne    801ba7 <free+0xf6>
        panic("free: unknown block");
  801b90:	83 ec 04             	sub    $0x4,%esp
  801b93:	68 43 4a 80 00       	push   $0x804a43
  801b98:	68 a9 00 00 00       	push   $0xa9
  801b9d:	68 e4 49 80 00       	push   $0x8049e4
  801ba2:	e8 e5 23 00 00       	call   803f8c <_panic>

    uhp_allocs[idx].used = 0;
  801ba7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801baa:	89 d0                	mov    %edx,%eax
  801bac:	01 c0                	add    %eax,%eax
  801bae:	01 d0                	add    %edx,%eax
  801bb0:	c1 e0 02             	shl    $0x2,%eax
  801bb3:	05 48 50 80 00       	add    $0x805048,%eax
  801bb8:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801bbb:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801bc2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801bc9:	eb 64                	jmp    801c2f <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801bcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bce:	89 d0                	mov    %edx,%eax
  801bd0:	01 c0                	add    %eax,%eax
  801bd2:	01 d0                	add    %edx,%eax
  801bd4:	c1 e0 02             	shl    $0x2,%eax
  801bd7:	05 48 10 81 00       	add    $0x811048,%eax
  801bdc:	8a 00                	mov    (%eax),%al
  801bde:	84 c0                	test   %al,%al
  801be0:	75 4a                	jne    801c2c <free+0x17b>
        {
            uhp_frees[i].va = va;
  801be2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801be5:	89 d0                	mov    %edx,%eax
  801be7:	01 c0                	add    %eax,%eax
  801be9:	01 d0                	add    %edx,%eax
  801beb:	c1 e0 02             	shl    $0x2,%eax
  801bee:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801bf4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bf7:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801bf9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bfc:	89 d0                	mov    %edx,%eax
  801bfe:	01 c0                	add    %eax,%eax
  801c00:	01 d0                	add    %edx,%eax
  801c02:	c1 e0 02             	shl    $0x2,%eax
  801c05:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0e:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801c10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c13:	89 d0                	mov    %edx,%eax
  801c15:	01 c0                	add    %eax,%eax
  801c17:	01 d0                	add    %edx,%eax
  801c19:	c1 e0 02             	shl    $0x2,%eax
  801c1c:	05 48 10 81 00       	add    $0x811048,%eax
  801c21:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c27:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801c2a:	eb 0c                	jmp    801c38 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c2c:	ff 45 e4             	incl   -0x1c(%ebp)
  801c2f:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801c36:	7e 93                	jle    801bcb <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801c38:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801c3c:	0f 84 f1 01 00 00    	je     801e33 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c42:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c49:	e9 d8 01 00 00       	jmp    801e26 <free+0x375>
        {
            if (i == fidx) continue;
  801c4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c51:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c54:	0f 84 c8 01 00 00    	je     801e22 <free+0x371>
            if (uhp_frees[i].free)
  801c5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c5d:	89 d0                	mov    %edx,%eax
  801c5f:	01 c0                	add    %eax,%eax
  801c61:	01 d0                	add    %edx,%eax
  801c63:	c1 e0 02             	shl    $0x2,%eax
  801c66:	05 48 10 81 00       	add    $0x811048,%eax
  801c6b:	8a 00                	mov    (%eax),%al
  801c6d:	84 c0                	test   %al,%al
  801c6f:	0f 84 ae 01 00 00    	je     801e23 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801c75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c78:	89 d0                	mov    %edx,%eax
  801c7a:	01 c0                	add    %eax,%eax
  801c7c:	01 d0                	add    %edx,%eax
  801c7e:	c1 e0 02             	shl    $0x2,%eax
  801c81:	05 40 10 81 00       	add    $0x811040,%eax
  801c86:	8b 08                	mov    (%eax),%ecx
  801c88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c8b:	89 d0                	mov    %edx,%eax
  801c8d:	01 c0                	add    %eax,%eax
  801c8f:	01 d0                	add    %edx,%eax
  801c91:	c1 e0 02             	shl    $0x2,%eax
  801c94:	05 44 10 81 00       	add    $0x811044,%eax
  801c99:	8b 00                	mov    (%eax),%eax
  801c9b:	01 c1                	add    %eax,%ecx
  801c9d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ca0:	89 d0                	mov    %edx,%eax
  801ca2:	01 c0                	add    %eax,%eax
  801ca4:	01 d0                	add    %edx,%eax
  801ca6:	c1 e0 02             	shl    $0x2,%eax
  801ca9:	05 40 10 81 00       	add    $0x811040,%eax
  801cae:	8b 00                	mov    (%eax),%eax
  801cb0:	39 c1                	cmp    %eax,%ecx
  801cb2:	0f 85 a8 00 00 00    	jne    801d60 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801cb8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cbb:	89 d0                	mov    %edx,%eax
  801cbd:	01 c0                	add    %eax,%eax
  801cbf:	01 d0                	add    %edx,%eax
  801cc1:	c1 e0 02             	shl    $0x2,%eax
  801cc4:	05 40 10 81 00       	add    $0x811040,%eax
  801cc9:	8b 10                	mov    (%eax),%edx
  801ccb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801cce:	89 c8                	mov    %ecx,%eax
  801cd0:	01 c0                	add    %eax,%eax
  801cd2:	01 c8                	add    %ecx,%eax
  801cd4:	c1 e0 02             	shl    $0x2,%eax
  801cd7:	05 40 10 81 00       	add    $0x811040,%eax
  801cdc:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801cde:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ce1:	89 d0                	mov    %edx,%eax
  801ce3:	01 c0                	add    %eax,%eax
  801ce5:	01 d0                	add    %edx,%eax
  801ce7:	c1 e0 02             	shl    $0x2,%eax
  801cea:	05 44 10 81 00       	add    $0x811044,%eax
  801cef:	8b 08                	mov    (%eax),%ecx
  801cf1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cf4:	89 d0                	mov    %edx,%eax
  801cf6:	01 c0                	add    %eax,%eax
  801cf8:	01 d0                	add    %edx,%eax
  801cfa:	c1 e0 02             	shl    $0x2,%eax
  801cfd:	05 44 10 81 00       	add    $0x811044,%eax
  801d02:	8b 00                	mov    (%eax),%eax
  801d04:	01 c1                	add    %eax,%ecx
  801d06:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d09:	89 d0                	mov    %edx,%eax
  801d0b:	01 c0                	add    %eax,%eax
  801d0d:	01 d0                	add    %edx,%eax
  801d0f:	c1 e0 02             	shl    $0x2,%eax
  801d12:	05 44 10 81 00       	add    $0x811044,%eax
  801d17:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801d19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d1c:	89 d0                	mov    %edx,%eax
  801d1e:	01 c0                	add    %eax,%eax
  801d20:	01 d0                	add    %edx,%eax
  801d22:	c1 e0 02             	shl    $0x2,%eax
  801d25:	05 48 10 81 00       	add    $0x811048,%eax
  801d2a:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801d2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d30:	89 d0                	mov    %edx,%eax
  801d32:	01 c0                	add    %eax,%eax
  801d34:	01 d0                	add    %edx,%eax
  801d36:	c1 e0 02             	shl    $0x2,%eax
  801d39:	05 40 10 81 00       	add    $0x811040,%eax
  801d3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801d44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d47:	89 d0                	mov    %edx,%eax
  801d49:	01 c0                	add    %eax,%eax
  801d4b:	01 d0                	add    %edx,%eax
  801d4d:	c1 e0 02             	shl    $0x2,%eax
  801d50:	05 44 10 81 00       	add    $0x811044,%eax
  801d55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d5b:	e9 c3 00 00 00       	jmp    801e23 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801d60:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d63:	89 d0                	mov    %edx,%eax
  801d65:	01 c0                	add    %eax,%eax
  801d67:	01 d0                	add    %edx,%eax
  801d69:	c1 e0 02             	shl    $0x2,%eax
  801d6c:	05 40 10 81 00       	add    $0x811040,%eax
  801d71:	8b 08                	mov    (%eax),%ecx
  801d73:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d76:	89 d0                	mov    %edx,%eax
  801d78:	01 c0                	add    %eax,%eax
  801d7a:	01 d0                	add    %edx,%eax
  801d7c:	c1 e0 02             	shl    $0x2,%eax
  801d7f:	05 44 10 81 00       	add    $0x811044,%eax
  801d84:	8b 00                	mov    (%eax),%eax
  801d86:	01 c1                	add    %eax,%ecx
  801d88:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	01 c0                	add    %eax,%eax
  801d8f:	01 d0                	add    %edx,%eax
  801d91:	c1 e0 02             	shl    $0x2,%eax
  801d94:	05 40 10 81 00       	add    $0x811040,%eax
  801d99:	8b 00                	mov    (%eax),%eax
  801d9b:	39 c1                	cmp    %eax,%ecx
  801d9d:	0f 85 80 00 00 00    	jne    801e23 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801da3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801da6:	89 d0                	mov    %edx,%eax
  801da8:	01 c0                	add    %eax,%eax
  801daa:	01 d0                	add    %edx,%eax
  801dac:	c1 e0 02             	shl    $0x2,%eax
  801daf:	05 44 10 81 00       	add    $0x811044,%eax
  801db4:	8b 08                	mov    (%eax),%ecx
  801db6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801db9:	89 d0                	mov    %edx,%eax
  801dbb:	01 c0                	add    %eax,%eax
  801dbd:	01 d0                	add    %edx,%eax
  801dbf:	c1 e0 02             	shl    $0x2,%eax
  801dc2:	05 44 10 81 00       	add    $0x811044,%eax
  801dc7:	8b 00                	mov    (%eax),%eax
  801dc9:	01 c1                	add    %eax,%ecx
  801dcb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dce:	89 d0                	mov    %edx,%eax
  801dd0:	01 c0                	add    %eax,%eax
  801dd2:	01 d0                	add    %edx,%eax
  801dd4:	c1 e0 02             	shl    $0x2,%eax
  801dd7:	05 44 10 81 00       	add    $0x811044,%eax
  801ddc:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801dde:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801de1:	89 d0                	mov    %edx,%eax
  801de3:	01 c0                	add    %eax,%eax
  801de5:	01 d0                	add    %edx,%eax
  801de7:	c1 e0 02             	shl    $0x2,%eax
  801dea:	05 48 10 81 00       	add    $0x811048,%eax
  801def:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801df2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801df5:	89 d0                	mov    %edx,%eax
  801df7:	01 c0                	add    %eax,%eax
  801df9:	01 d0                	add    %edx,%eax
  801dfb:	c1 e0 02             	shl    $0x2,%eax
  801dfe:	05 40 10 81 00       	add    $0x811040,%eax
  801e03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801e09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e0c:	89 d0                	mov    %edx,%eax
  801e0e:	01 c0                	add    %eax,%eax
  801e10:	01 d0                	add    %edx,%eax
  801e12:	c1 e0 02             	shl    $0x2,%eax
  801e15:	05 44 10 81 00       	add    $0x811044,%eax
  801e1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e20:	eb 01                	jmp    801e23 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801e22:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e23:	ff 45 e0             	incl   -0x20(%ebp)
  801e26:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801e2d:	0f 8e 1b fe ff ff    	jle    801c4e <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801e33:	a1 30 51 83 00       	mov    0x835130,%eax
  801e38:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e3b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801e42:	eb 53                	jmp    801e97 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801e44:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e47:	89 d0                	mov    %edx,%eax
  801e49:	01 c0                	add    %eax,%eax
  801e4b:	01 d0                	add    %edx,%eax
  801e4d:	c1 e0 02             	shl    $0x2,%eax
  801e50:	05 48 50 80 00       	add    $0x805048,%eax
  801e55:	8a 00                	mov    (%eax),%al
  801e57:	84 c0                	test   %al,%al
  801e59:	74 39                	je     801e94 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801e5b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e5e:	89 d0                	mov    %edx,%eax
  801e60:	01 c0                	add    %eax,%eax
  801e62:	01 d0                	add    %edx,%eax
  801e64:	c1 e0 02             	shl    $0x2,%eax
  801e67:	05 40 50 80 00       	add    $0x805040,%eax
  801e6c:	8b 08                	mov    (%eax),%ecx
  801e6e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e71:	89 d0                	mov    %edx,%eax
  801e73:	01 c0                	add    %eax,%eax
  801e75:	01 d0                	add    %edx,%eax
  801e77:	c1 e0 02             	shl    $0x2,%eax
  801e7a:	05 44 50 80 00       	add    $0x805044,%eax
  801e7f:	8b 00                	mov    (%eax),%eax
  801e81:	01 c8                	add    %ecx,%eax
  801e83:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801e86:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e89:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e8c:	76 06                	jbe    801e94 <free+0x3e3>
  801e8e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e91:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801e94:	ff 45 d8             	incl   -0x28(%ebp)
  801e97:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801e9e:	7e a4                	jle    801e44 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801ea0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ea3:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801ea8:	83 ec 08             	sub    $0x8,%esp
  801eab:	ff 75 f4             	pushl  -0xc(%ebp)
  801eae:	ff 75 d4             	pushl  -0x2c(%ebp)
  801eb1:	e8 79 15 00 00       	call   80342f <sys_free_user_mem>
  801eb6:	83 c4 10             	add    $0x10,%esp
  801eb9:	eb 01                	jmp    801ebc <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801ebb:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 68             	sub    $0x68,%esp
  801ec4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec7:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801eca:	e8 a5 f7 ff ff       	call   801674 <uheap_init>
	if (size == 0) return NULL ;
  801ecf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ed3:	75 0a                	jne    801edf <smalloc+0x21>
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eda:	e9 37 03 00 00       	jmp    802216 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801edf:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eec:	01 d0                	add    %edx,%eax
  801eee:	48                   	dec    %eax
  801eef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ef2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ef5:	ba 00 00 00 00       	mov    $0x0,%edx
  801efa:	f7 75 dc             	divl   -0x24(%ebp)
  801efd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f00:	29 d0                	sub    %edx,%eax
  801f02:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801f05:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801f0c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801f13:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f1a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801f21:	e9 85 00 00 00       	jmp    801fab <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801f26:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f29:	89 d0                	mov    %edx,%eax
  801f2b:	01 c0                	add    %eax,%eax
  801f2d:	01 d0                	add    %edx,%eax
  801f2f:	c1 e0 02             	shl    $0x2,%eax
  801f32:	05 48 10 81 00       	add    $0x811048,%eax
  801f37:	8a 00                	mov    (%eax),%al
  801f39:	84 c0                	test   %al,%al
  801f3b:	74 20                	je     801f5d <smalloc+0x9f>
  801f3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f40:	89 d0                	mov    %edx,%eax
  801f42:	01 c0                	add    %eax,%eax
  801f44:	01 d0                	add    %edx,%eax
  801f46:	c1 e0 02             	shl    $0x2,%eax
  801f49:	05 44 10 81 00       	add    $0x811044,%eax
  801f4e:	8b 00                	mov    (%eax),%eax
  801f50:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f53:	75 08                	jne    801f5d <smalloc+0x9f>
        {
            exactIdx = i;
  801f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801f5b:	eb 5b                	jmp    801fb8 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801f5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f60:	89 d0                	mov    %edx,%eax
  801f62:	01 c0                	add    %eax,%eax
  801f64:	01 d0                	add    %edx,%eax
  801f66:	c1 e0 02             	shl    $0x2,%eax
  801f69:	05 48 10 81 00       	add    $0x811048,%eax
  801f6e:	8a 00                	mov    (%eax),%al
  801f70:	84 c0                	test   %al,%al
  801f72:	74 34                	je     801fa8 <smalloc+0xea>
  801f74:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f77:	89 d0                	mov    %edx,%eax
  801f79:	01 c0                	add    %eax,%eax
  801f7b:	01 d0                	add    %edx,%eax
  801f7d:	c1 e0 02             	shl    $0x2,%eax
  801f80:	05 44 10 81 00       	add    $0x811044,%eax
  801f85:	8b 00                	mov    (%eax),%eax
  801f87:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f8a:	76 1c                	jbe    801fa8 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801f8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f8f:	89 d0                	mov    %edx,%eax
  801f91:	01 c0                	add    %eax,%eax
  801f93:	01 d0                	add    %edx,%eax
  801f95:	c1 e0 02             	shl    $0x2,%eax
  801f98:	05 44 10 81 00       	add    $0x811044,%eax
  801f9d:	8b 00                	mov    (%eax),%eax
  801f9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801fa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801fa8:	ff 45 e8             	incl   -0x18(%ebp)
  801fab:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801fb2:	0f 8e 6e ff ff ff    	jle    801f26 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801fb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801fbf:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801fc3:	74 7d                	je     802042 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801fc5:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801fcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcf:	89 d0                	mov    %edx,%eax
  801fd1:	01 c0                	add    %eax,%eax
  801fd3:	01 d0                	add    %edx,%eax
  801fd5:	c1 e0 02             	shl    $0x2,%eax
  801fd8:	05 40 10 81 00       	add    $0x811040,%eax
  801fdd:	8b 10                	mov    (%eax),%edx
  801fdf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801fe2:	01 d0                	add    %edx,%eax
  801fe4:	48                   	dec    %eax
  801fe5:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801fe8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801feb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff0:	f7 75 bc             	divl   -0x44(%ebp)
  801ff3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ff6:	29 d0                	sub    %edx,%eax
  801ff8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801ffb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffe:	89 d0                	mov    %edx,%eax
  802000:	01 c0                	add    %eax,%eax
  802002:	01 d0                	add    %edx,%eax
  802004:	c1 e0 02             	shl    $0x2,%eax
  802007:	05 48 10 81 00       	add    $0x811048,%eax
  80200c:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80200f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802012:	89 d0                	mov    %edx,%eax
  802014:	01 c0                	add    %eax,%eax
  802016:	01 d0                	add    %edx,%eax
  802018:	c1 e0 02             	shl    $0x2,%eax
  80201b:	05 44 10 81 00       	add    $0x811044,%eax
  802020:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802026:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802029:	89 d0                	mov    %edx,%eax
  80202b:	01 c0                	add    %eax,%eax
  80202d:	01 d0                	add    %edx,%eax
  80202f:	c1 e0 02             	shl    $0x2,%eax
  802032:	05 40 10 81 00       	add    $0x811040,%eax
  802037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80203d:	e9 2d 01 00 00       	jmp    80216f <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802042:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802046:	0f 84 ce 00 00 00    	je     80211a <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80204c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802053:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802056:	89 d0                	mov    %edx,%eax
  802058:	01 c0                	add    %eax,%eax
  80205a:	01 d0                	add    %edx,%eax
  80205c:	c1 e0 02             	shl    $0x2,%eax
  80205f:	05 40 10 81 00       	add    $0x811040,%eax
  802064:	8b 10                	mov    (%eax),%edx
  802066:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802069:	01 d0                	add    %edx,%eax
  80206b:	48                   	dec    %eax
  80206c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80206f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802072:	ba 00 00 00 00       	mov    $0x0,%edx
  802077:	f7 75 c4             	divl   -0x3c(%ebp)
  80207a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80207d:	29 d0                	sub    %edx,%eax
  80207f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802082:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802085:	89 d0                	mov    %edx,%eax
  802087:	01 c0                	add    %eax,%eax
  802089:	01 d0                	add    %edx,%eax
  80208b:	c1 e0 02             	shl    $0x2,%eax
  80208e:	05 44 10 81 00       	add    $0x811044,%eax
  802093:	8b 00                	mov    (%eax),%eax
  802095:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802098:	75 47                	jne    8020e1 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80209a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80209d:	89 d0                	mov    %edx,%eax
  80209f:	01 c0                	add    %eax,%eax
  8020a1:	01 d0                	add    %edx,%eax
  8020a3:	c1 e0 02             	shl    $0x2,%eax
  8020a6:	05 48 10 81 00       	add    $0x811048,%eax
  8020ab:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8020ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020b1:	89 d0                	mov    %edx,%eax
  8020b3:	01 c0                	add    %eax,%eax
  8020b5:	01 d0                	add    %edx,%eax
  8020b7:	c1 e0 02             	shl    $0x2,%eax
  8020ba:	05 44 10 81 00       	add    $0x811044,%eax
  8020bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8020c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020c8:	89 d0                	mov    %edx,%eax
  8020ca:	01 c0                	add    %eax,%eax
  8020cc:	01 d0                	add    %edx,%eax
  8020ce:	c1 e0 02             	shl    $0x2,%eax
  8020d1:	05 40 10 81 00       	add    $0x811040,%eax
  8020d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020dc:	e9 8e 00 00 00       	jmp    80216f <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8020e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020e7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8020ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ed:	89 d0                	mov    %edx,%eax
  8020ef:	01 c0                	add    %eax,%eax
  8020f1:	01 d0                	add    %edx,%eax
  8020f3:	c1 e0 02             	shl    $0x2,%eax
  8020f6:	05 40 10 81 00       	add    $0x811040,%eax
  8020fb:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8020fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802100:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802103:	89 c2                	mov    %eax,%edx
  802105:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802108:	89 c8                	mov    %ecx,%eax
  80210a:	01 c0                	add    %eax,%eax
  80210c:	01 c8                	add    %ecx,%eax
  80210e:	c1 e0 02             	shl    $0x2,%eax
  802111:	05 44 10 81 00       	add    $0x811044,%eax
  802116:	89 10                	mov    %edx,(%eax)
  802118:	eb 55                	jmp    80216f <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80211a:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802121:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802127:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80212a:	01 d0                	add    %edx,%eax
  80212c:	48                   	dec    %eax
  80212d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802130:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802133:	ba 00 00 00 00       	mov    $0x0,%edx
  802138:	f7 75 d0             	divl   -0x30(%ebp)
  80213b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80213e:	29 d0                	sub    %edx,%eax
  802140:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  802143:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802146:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802149:	01 d0                	add    %edx,%eax
  80214b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802150:	76 0a                	jbe    80215c <smalloc+0x29e>
            return NULL;
  802152:	b8 00 00 00 00       	mov    $0x0,%eax
  802157:	e9 ba 00 00 00       	jmp    802216 <smalloc+0x358>
        va = start;
  80215c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80215f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802162:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802165:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802168:	01 d0                	add    %edx,%eax
  80216a:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80216f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802176:	eb 5e                	jmp    8021d6 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802178:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80217b:	89 d0                	mov    %edx,%eax
  80217d:	01 c0                	add    %eax,%eax
  80217f:	01 d0                	add    %edx,%eax
  802181:	c1 e0 02             	shl    $0x2,%eax
  802184:	05 48 50 80 00       	add    $0x805048,%eax
  802189:	8a 00                	mov    (%eax),%al
  80218b:	84 c0                	test   %al,%al
  80218d:	75 44                	jne    8021d3 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80218f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802192:	89 d0                	mov    %edx,%eax
  802194:	01 c0                	add    %eax,%eax
  802196:	01 d0                	add    %edx,%eax
  802198:	c1 e0 02             	shl    $0x2,%eax
  80219b:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8021a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021a4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8021a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021a9:	89 d0                	mov    %edx,%eax
  8021ab:	01 c0                	add    %eax,%eax
  8021ad:	01 d0                	add    %edx,%eax
  8021af:	c1 e0 02             	shl    $0x2,%eax
  8021b2:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8021b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021bb:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8021bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021c0:	89 d0                	mov    %edx,%eax
  8021c2:	01 c0                	add    %eax,%eax
  8021c4:	01 d0                	add    %edx,%eax
  8021c6:	c1 e0 02             	shl    $0x2,%eax
  8021c9:	05 48 50 80 00       	add    $0x805048,%eax
  8021ce:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8021d1:	eb 0c                	jmp    8021df <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8021d3:	ff 45 e0             	incl   -0x20(%ebp)
  8021d6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8021dd:	7e 99                	jle    802178 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8021df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021e2:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8021e6:	52                   	push   %edx
  8021e7:	50                   	push   %eax
  8021e8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8021eb:	ff 75 08             	pushl  0x8(%ebp)
  8021ee:	e8 de 0e 00 00       	call   8030d1 <sys_create_shared_object>
  8021f3:	83 c4 10             	add    $0x10,%esp
  8021f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8021f9:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8021fd:	75 07                	jne    802206 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8021ff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802204:	eb 10                	jmp    802216 <smalloc+0x358>
    if (r < 0)
  802206:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80220a:	79 07                	jns    802213 <smalloc+0x355>
        return NULL;
  80220c:	b8 00 00 00 00       	mov    $0x0,%eax
  802211:	eb 03                	jmp    802216 <smalloc+0x358>
    return (void*)va;
  802213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80221e:	e8 51 f4 ff ff       	call   801674 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802223:	83 ec 08             	sub    $0x8,%esp
  802226:	ff 75 0c             	pushl  0xc(%ebp)
  802229:	ff 75 08             	pushl  0x8(%ebp)
  80222c:	e8 ca 0e 00 00       	call   8030fb <sys_size_of_shared_object>
  802231:	83 c4 10             	add    $0x10,%esp
  802234:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  802237:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80223b:	7f 0a                	jg     802247 <sget+0x2f>
        return NULL;
  80223d:	b8 00 00 00 00       	mov    $0x0,%eax
  802242:	e9 28 03 00 00       	jmp    80256f <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  802247:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80224e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802251:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802254:	01 d0                	add    %edx,%eax
  802256:	48                   	dec    %eax
  802257:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80225a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80225d:	ba 00 00 00 00       	mov    $0x0,%edx
  802262:	f7 75 d8             	divl   -0x28(%ebp)
  802265:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802268:	29 d0                	sub    %edx,%eax
  80226a:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80226d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802274:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80227b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802282:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802289:	e9 85 00 00 00       	jmp    802313 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80228e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802291:	89 d0                	mov    %edx,%eax
  802293:	01 c0                	add    %eax,%eax
  802295:	01 d0                	add    %edx,%eax
  802297:	c1 e0 02             	shl    $0x2,%eax
  80229a:	05 48 10 81 00       	add    $0x811048,%eax
  80229f:	8a 00                	mov    (%eax),%al
  8022a1:	84 c0                	test   %al,%al
  8022a3:	74 20                	je     8022c5 <sget+0xad>
  8022a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a8:	89 d0                	mov    %edx,%eax
  8022aa:	01 c0                	add    %eax,%eax
  8022ac:	01 d0                	add    %edx,%eax
  8022ae:	c1 e0 02             	shl    $0x2,%eax
  8022b1:	05 44 10 81 00       	add    $0x811044,%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8022bb:	75 08                	jne    8022c5 <sget+0xad>
        {
            exactIdx = i;
  8022bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8022c3:	eb 5b                	jmp    802320 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8022c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022c8:	89 d0                	mov    %edx,%eax
  8022ca:	01 c0                	add    %eax,%eax
  8022cc:	01 d0                	add    %edx,%eax
  8022ce:	c1 e0 02             	shl    $0x2,%eax
  8022d1:	05 48 10 81 00       	add    $0x811048,%eax
  8022d6:	8a 00                	mov    (%eax),%al
  8022d8:	84 c0                	test   %al,%al
  8022da:	74 34                	je     802310 <sget+0xf8>
  8022dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022df:	89 d0                	mov    %edx,%eax
  8022e1:	01 c0                	add    %eax,%eax
  8022e3:	01 d0                	add    %edx,%eax
  8022e5:	c1 e0 02             	shl    $0x2,%eax
  8022e8:	05 44 10 81 00       	add    $0x811044,%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022f2:	76 1c                	jbe    802310 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8022f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022f7:	89 d0                	mov    %edx,%eax
  8022f9:	01 c0                	add    %eax,%eax
  8022fb:	01 d0                	add    %edx,%eax
  8022fd:	c1 e0 02             	shl    $0x2,%eax
  802300:	05 44 10 81 00       	add    $0x811044,%eax
  802305:	8b 00                	mov    (%eax),%eax
  802307:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80230a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80230d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802310:	ff 45 e8             	incl   -0x18(%ebp)
  802313:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80231a:	0f 8e 6e ff ff ff    	jle    80228e <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802320:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802327:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80232b:	74 7d                	je     8023aa <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80232d:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802334:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802337:	89 d0                	mov    %edx,%eax
  802339:	01 c0                	add    %eax,%eax
  80233b:	01 d0                	add    %edx,%eax
  80233d:	c1 e0 02             	shl    $0x2,%eax
  802340:	05 40 10 81 00       	add    $0x811040,%eax
  802345:	8b 10                	mov    (%eax),%edx
  802347:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80234a:	01 d0                	add    %edx,%eax
  80234c:	48                   	dec    %eax
  80234d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802350:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802353:	ba 00 00 00 00       	mov    $0x0,%edx
  802358:	f7 75 b8             	divl   -0x48(%ebp)
  80235b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80235e:	29 d0                	sub    %edx,%eax
  802360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802363:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802366:	89 d0                	mov    %edx,%eax
  802368:	01 c0                	add    %eax,%eax
  80236a:	01 d0                	add    %edx,%eax
  80236c:	c1 e0 02             	shl    $0x2,%eax
  80236f:	05 48 10 81 00       	add    $0x811048,%eax
  802374:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802377:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237a:	89 d0                	mov    %edx,%eax
  80237c:	01 c0                	add    %eax,%eax
  80237e:	01 d0                	add    %edx,%eax
  802380:	c1 e0 02             	shl    $0x2,%eax
  802383:	05 44 10 81 00       	add    $0x811044,%eax
  802388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80238e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802391:	89 d0                	mov    %edx,%eax
  802393:	01 c0                	add    %eax,%eax
  802395:	01 d0                	add    %edx,%eax
  802397:	c1 e0 02             	shl    $0x2,%eax
  80239a:	05 40 10 81 00       	add    $0x811040,%eax
  80239f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a5:	e9 2d 01 00 00       	jmp    8024d7 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  8023aa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8023ae:	0f 84 ce 00 00 00    	je     802482 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8023b4:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8023bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023be:	89 d0                	mov    %edx,%eax
  8023c0:	01 c0                	add    %eax,%eax
  8023c2:	01 d0                	add    %edx,%eax
  8023c4:	c1 e0 02             	shl    $0x2,%eax
  8023c7:	05 40 10 81 00       	add    $0x811040,%eax
  8023cc:	8b 10                	mov    (%eax),%edx
  8023ce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023d1:	01 d0                	add    %edx,%eax
  8023d3:	48                   	dec    %eax
  8023d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8023d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023da:	ba 00 00 00 00       	mov    $0x0,%edx
  8023df:	f7 75 c0             	divl   -0x40(%ebp)
  8023e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023e5:	29 d0                	sub    %edx,%eax
  8023e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8023ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ed:	89 d0                	mov    %edx,%eax
  8023ef:	01 c0                	add    %eax,%eax
  8023f1:	01 d0                	add    %edx,%eax
  8023f3:	c1 e0 02             	shl    $0x2,%eax
  8023f6:	05 44 10 81 00       	add    $0x811044,%eax
  8023fb:	8b 00                	mov    (%eax),%eax
  8023fd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802400:	75 47                	jne    802449 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802402:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802405:	89 d0                	mov    %edx,%eax
  802407:	01 c0                	add    %eax,%eax
  802409:	01 d0                	add    %edx,%eax
  80240b:	c1 e0 02             	shl    $0x2,%eax
  80240e:	05 48 10 81 00       	add    $0x811048,%eax
  802413:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802416:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802419:	89 d0                	mov    %edx,%eax
  80241b:	01 c0                	add    %eax,%eax
  80241d:	01 d0                	add    %edx,%eax
  80241f:	c1 e0 02             	shl    $0x2,%eax
  802422:	05 44 10 81 00       	add    $0x811044,%eax
  802427:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80242d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802430:	89 d0                	mov    %edx,%eax
  802432:	01 c0                	add    %eax,%eax
  802434:	01 d0                	add    %edx,%eax
  802436:	c1 e0 02             	shl    $0x2,%eax
  802439:	05 40 10 81 00       	add    $0x811040,%eax
  80243e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802444:	e9 8e 00 00 00       	jmp    8024d7 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802449:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80244c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80244f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802455:	89 d0                	mov    %edx,%eax
  802457:	01 c0                	add    %eax,%eax
  802459:	01 d0                	add    %edx,%eax
  80245b:	c1 e0 02             	shl    $0x2,%eax
  80245e:	05 40 10 81 00       	add    $0x811040,%eax
  802463:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802465:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802468:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80246b:	89 c2                	mov    %eax,%edx
  80246d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802470:	89 c8                	mov    %ecx,%eax
  802472:	01 c0                	add    %eax,%eax
  802474:	01 c8                	add    %ecx,%eax
  802476:	c1 e0 02             	shl    $0x2,%eax
  802479:	05 44 10 81 00       	add    $0x811044,%eax
  80247e:	89 10                	mov    %edx,(%eax)
  802480:	eb 55                	jmp    8024d7 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802482:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802489:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80248f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802492:	01 d0                	add    %edx,%eax
  802494:	48                   	dec    %eax
  802495:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802498:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80249b:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a0:	f7 75 cc             	divl   -0x34(%ebp)
  8024a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024a6:	29 d0                	sub    %edx,%eax
  8024a8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  8024ab:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8024ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024b1:	01 d0                	add    %edx,%eax
  8024b3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8024b8:	76 0a                	jbe    8024c4 <sget+0x2ac>
            return NULL;
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bf:	e9 ab 00 00 00       	jmp    80256f <sget+0x357>
        va = start;
  8024c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8024ca:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8024cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024d0:	01 d0                	add    %edx,%eax
  8024d2:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8024d7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8024de:	eb 5e                	jmp    80253e <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8024e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024e3:	89 d0                	mov    %edx,%eax
  8024e5:	01 c0                	add    %eax,%eax
  8024e7:	01 d0                	add    %edx,%eax
  8024e9:	c1 e0 02             	shl    $0x2,%eax
  8024ec:	05 48 50 80 00       	add    $0x805048,%eax
  8024f1:	8a 00                	mov    (%eax),%al
  8024f3:	84 c0                	test   %al,%al
  8024f5:	75 44                	jne    80253b <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8024f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024fa:	89 d0                	mov    %edx,%eax
  8024fc:	01 c0                	add    %eax,%eax
  8024fe:	01 d0                	add    %edx,%eax
  802500:	c1 e0 02             	shl    $0x2,%eax
  802503:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80250e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802511:	89 d0                	mov    %edx,%eax
  802513:	01 c0                	add    %eax,%eax
  802515:	01 d0                	add    %edx,%eax
  802517:	c1 e0 02             	shl    $0x2,%eax
  80251a:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802520:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802523:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802525:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802528:	89 d0                	mov    %edx,%eax
  80252a:	01 c0                	add    %eax,%eax
  80252c:	01 d0                	add    %edx,%eax
  80252e:	c1 e0 02             	shl    $0x2,%eax
  802531:	05 48 50 80 00       	add    $0x805048,%eax
  802536:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802539:	eb 0c                	jmp    802547 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80253b:	ff 45 e0             	incl   -0x20(%ebp)
  80253e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802545:	7e 99                	jle    8024e0 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  802547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254a:	83 ec 04             	sub    $0x4,%esp
  80254d:	50                   	push   %eax
  80254e:	ff 75 0c             	pushl  0xc(%ebp)
  802551:	ff 75 08             	pushl  0x8(%ebp)
  802554:	e8 bf 0b 00 00       	call   803118 <sys_get_shared_object>
  802559:	83 c4 10             	add    $0x10,%esp
  80255c:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  80255f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802563:	79 07                	jns    80256c <sget+0x354>
        return NULL;
  802565:	b8 00 00 00 00       	mov    $0x0,%eax
  80256a:	eb 03                	jmp    80256f <sget+0x357>
    return (void*)va;
  80256c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802577:	e8 f8 f0 ff ff       	call   801674 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  80257c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802580:	75 13                	jne    802595 <realloc+0x24>
		return malloc(new_size);
  802582:	83 ec 0c             	sub    $0xc,%esp
  802585:	ff 75 0c             	pushl  0xc(%ebp)
  802588:	e8 c4 f1 ff ff       	call   801751 <malloc>
  80258d:	83 c4 10             	add    $0x10,%esp
  802590:	e9 f4 05 00 00       	jmp    802b89 <realloc+0x618>
	if (new_size == 0)
  802595:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802599:	75 18                	jne    8025b3 <realloc+0x42>
	{
		free(virtual_address);
  80259b:	83 ec 0c             	sub    $0xc,%esp
  80259e:	ff 75 08             	pushl  0x8(%ebp)
  8025a1:	e8 0b f5 ff ff       	call   801ab1 <free>
  8025a6:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8025a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ae:	e9 d6 05 00 00       	jmp    802b89 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8025b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	79 74                	jns    802634 <realloc+0xc3>
  8025c0:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8025c7:	77 6b                	ja     802634 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  8025c9:	83 ec 0c             	sub    $0xc,%esp
  8025cc:	ff 75 0c             	pushl  0xc(%ebp)
  8025cf:	e8 7d f1 ff ff       	call   801751 <malloc>
  8025d4:	83 c4 10             	add    $0x10,%esp
  8025d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8025da:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8025de:	75 0a                	jne    8025ea <realloc+0x79>
			return NULL;
  8025e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e5:	e9 9f 05 00 00       	jmp    802b89 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8025ea:	83 ec 0c             	sub    $0xc,%esp
  8025ed:	ff 75 08             	pushl  0x8(%ebp)
  8025f0:	e8 e0 11 00 00       	call   8037d5 <get_block_size>
  8025f5:	83 c4 10             	add    $0x10,%esp
  8025f8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8025fb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802601:	39 d0                	cmp    %edx,%eax
  802603:	76 02                	jbe    802607 <realloc+0x96>
  802605:	89 d0                	mov    %edx,%eax
  802607:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  80260a:	83 ec 04             	sub    $0x4,%esp
  80260d:	ff 75 c0             	pushl  -0x40(%ebp)
  802610:	ff 75 08             	pushl  0x8(%ebp)
  802613:	ff 75 c8             	pushl  -0x38(%ebp)
  802616:	e8 56 eb ff ff       	call   801171 <memmove>
  80261b:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  80261e:	83 ec 0c             	sub    $0xc,%esp
  802621:	ff 75 08             	pushl  0x8(%ebp)
  802624:	e8 88 f4 ff ff       	call   801ab1 <free>
  802629:	83 c4 10             	add    $0x10,%esp
		return newptr;
  80262c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80262f:	e9 55 05 00 00       	jmp    802b89 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802634:	a1 30 51 83 00       	mov    0x835130,%eax
  802639:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  80263c:	72 09                	jb     802647 <realloc+0xd6>
  80263e:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802645:	76 0a                	jbe    802651 <realloc+0xe0>
		return NULL;
  802647:	b8 00 00 00 00       	mov    $0x0,%eax
  80264c:	e9 38 05 00 00       	jmp    802b89 <realloc+0x618>
	uint32 oldsz = 0;
  802651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802658:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80265f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802666:	eb 50                	jmp    8026b8 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802668:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80266b:	89 d0                	mov    %edx,%eax
  80266d:	01 c0                	add    %eax,%eax
  80266f:	01 d0                	add    %edx,%eax
  802671:	c1 e0 02             	shl    $0x2,%eax
  802674:	05 48 50 80 00       	add    $0x805048,%eax
  802679:	8a 00                	mov    (%eax),%al
  80267b:	84 c0                	test   %al,%al
  80267d:	74 36                	je     8026b5 <realloc+0x144>
  80267f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802682:	89 d0                	mov    %edx,%eax
  802684:	01 c0                	add    %eax,%eax
  802686:	01 d0                	add    %edx,%eax
  802688:	c1 e0 02             	shl    $0x2,%eax
  80268b:	05 40 50 80 00       	add    $0x805040,%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802695:	75 1e                	jne    8026b5 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802697:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80269a:	89 d0                	mov    %edx,%eax
  80269c:	01 c0                	add    %eax,%eax
  80269e:	01 d0                	add    %edx,%eax
  8026a0:	c1 e0 02             	shl    $0x2,%eax
  8026a3:	05 44 50 80 00       	add    $0x805044,%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  8026ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8026b3:	eb 0c                	jmp    8026c1 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8026b5:	ff 45 ec             	incl   -0x14(%ebp)
  8026b8:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8026bf:	7e a7                	jle    802668 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8026c1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8026c5:	75 0a                	jne    8026d1 <realloc+0x160>
		return NULL;
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cc:	e9 b8 04 00 00       	jmp    802b89 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  8026d1:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8026d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026db:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026de:	01 d0                	add    %edx,%eax
  8026e0:	48                   	dec    %eax
  8026e1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8026e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ec:	f7 75 bc             	divl   -0x44(%ebp)
  8026ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8026f2:	29 d0                	sub    %edx,%eax
  8026f4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8026f7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8026fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8026fd:	75 08                	jne    802707 <realloc+0x196>
		return virtual_address;
  8026ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802702:	e9 82 04 00 00       	jmp    802b89 <realloc+0x618>
	if (req < oldsz)
  802707:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80270a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80270d:	0f 83 cd 02 00 00    	jae    8029e0 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802719:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  80271c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80271f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802722:	01 d0                	add    %edx,%eax
  802724:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802727:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80272a:	89 d0                	mov    %edx,%eax
  80272c:	01 c0                	add    %eax,%eax
  80272e:	01 d0                	add    %edx,%eax
  802730:	c1 e0 02             	shl    $0x2,%eax
  802733:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802739:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80273c:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  80273e:	83 ec 08             	sub    $0x8,%esp
  802741:	ff 75 b0             	pushl  -0x50(%ebp)
  802744:	ff 75 ac             	pushl  -0x54(%ebp)
  802747:	e8 e3 0c 00 00       	call   80342f <sys_free_user_mem>
  80274c:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  80274f:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802756:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80275d:	eb 64                	jmp    8027c3 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  80275f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802762:	89 d0                	mov    %edx,%eax
  802764:	01 c0                	add    %eax,%eax
  802766:	01 d0                	add    %edx,%eax
  802768:	c1 e0 02             	shl    $0x2,%eax
  80276b:	05 48 10 81 00       	add    $0x811048,%eax
  802770:	8a 00                	mov    (%eax),%al
  802772:	84 c0                	test   %al,%al
  802774:	75 4a                	jne    8027c0 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802776:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802779:	89 d0                	mov    %edx,%eax
  80277b:	01 c0                	add    %eax,%eax
  80277d:	01 d0                	add    %edx,%eax
  80277f:	c1 e0 02             	shl    $0x2,%eax
  802782:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802788:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80278b:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  80278d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802790:	89 d0                	mov    %edx,%eax
  802792:	01 c0                	add    %eax,%eax
  802794:	01 d0                	add    %edx,%eax
  802796:	c1 e0 02             	shl    $0x2,%eax
  802799:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  80279f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8027a2:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  8027a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027a7:	89 d0                	mov    %edx,%eax
  8027a9:	01 c0                	add    %eax,%eax
  8027ab:	01 d0                	add    %edx,%eax
  8027ad:	c1 e0 02             	shl    $0x2,%eax
  8027b0:	05 48 10 81 00       	add    $0x811048,%eax
  8027b5:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8027b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8027be:	eb 0c                	jmp    8027cc <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8027c0:	ff 45 e4             	incl   -0x1c(%ebp)
  8027c3:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8027ca:	7e 93                	jle    80275f <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  8027cc:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8027d0:	0f 84 8d 01 00 00    	je     802963 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8027d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8027dd:	e9 74 01 00 00       	jmp    802956 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8027e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027e8:	0f 84 64 01 00 00    	je     802952 <realloc+0x3e1>
				if (uhp_frees[k].free)
  8027ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027f1:	89 d0                	mov    %edx,%eax
  8027f3:	01 c0                	add    %eax,%eax
  8027f5:	01 d0                	add    %edx,%eax
  8027f7:	c1 e0 02             	shl    $0x2,%eax
  8027fa:	05 48 10 81 00       	add    $0x811048,%eax
  8027ff:	8a 00                	mov    (%eax),%al
  802801:	84 c0                	test   %al,%al
  802803:	0f 84 4a 01 00 00    	je     802953 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802809:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80280c:	89 d0                	mov    %edx,%eax
  80280e:	01 c0                	add    %eax,%eax
  802810:	01 d0                	add    %edx,%eax
  802812:	c1 e0 02             	shl    $0x2,%eax
  802815:	05 40 10 81 00       	add    $0x811040,%eax
  80281a:	8b 08                	mov    (%eax),%ecx
  80281c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80281f:	89 d0                	mov    %edx,%eax
  802821:	01 c0                	add    %eax,%eax
  802823:	01 d0                	add    %edx,%eax
  802825:	c1 e0 02             	shl    $0x2,%eax
  802828:	05 44 10 81 00       	add    $0x811044,%eax
  80282d:	8b 00                	mov    (%eax),%eax
  80282f:	01 c1                	add    %eax,%ecx
  802831:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802834:	89 d0                	mov    %edx,%eax
  802836:	01 c0                	add    %eax,%eax
  802838:	01 d0                	add    %edx,%eax
  80283a:	c1 e0 02             	shl    $0x2,%eax
  80283d:	05 40 10 81 00       	add    $0x811040,%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	39 c1                	cmp    %eax,%ecx
  802846:	75 7a                	jne    8028c2 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802848:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80284b:	89 d0                	mov    %edx,%eax
  80284d:	01 c0                	add    %eax,%eax
  80284f:	01 d0                	add    %edx,%eax
  802851:	c1 e0 02             	shl    $0x2,%eax
  802854:	05 40 10 81 00       	add    $0x811040,%eax
  802859:	8b 10                	mov    (%eax),%edx
  80285b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80285e:	89 c8                	mov    %ecx,%eax
  802860:	01 c0                	add    %eax,%eax
  802862:	01 c8                	add    %ecx,%eax
  802864:	c1 e0 02             	shl    $0x2,%eax
  802867:	05 40 10 81 00       	add    $0x811040,%eax
  80286c:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  80286e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802871:	89 d0                	mov    %edx,%eax
  802873:	01 c0                	add    %eax,%eax
  802875:	01 d0                	add    %edx,%eax
  802877:	c1 e0 02             	shl    $0x2,%eax
  80287a:	05 44 10 81 00       	add    $0x811044,%eax
  80287f:	8b 08                	mov    (%eax),%ecx
  802881:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802884:	89 d0                	mov    %edx,%eax
  802886:	01 c0                	add    %eax,%eax
  802888:	01 d0                	add    %edx,%eax
  80288a:	c1 e0 02             	shl    $0x2,%eax
  80288d:	05 44 10 81 00       	add    $0x811044,%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	01 c1                	add    %eax,%ecx
  802896:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802899:	89 d0                	mov    %edx,%eax
  80289b:	01 c0                	add    %eax,%eax
  80289d:	01 d0                	add    %edx,%eax
  80289f:	c1 e0 02             	shl    $0x2,%eax
  8028a2:	05 44 10 81 00       	add    $0x811044,%eax
  8028a7:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8028a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028ac:	89 d0                	mov    %edx,%eax
  8028ae:	01 c0                	add    %eax,%eax
  8028b0:	01 d0                	add    %edx,%eax
  8028b2:	c1 e0 02             	shl    $0x2,%eax
  8028b5:	05 48 10 81 00       	add    $0x811048,%eax
  8028ba:	c6 00 00             	movb   $0x0,(%eax)
  8028bd:	e9 91 00 00 00       	jmp    802953 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8028c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028c5:	89 d0                	mov    %edx,%eax
  8028c7:	01 c0                	add    %eax,%eax
  8028c9:	01 d0                	add    %edx,%eax
  8028cb:	c1 e0 02             	shl    $0x2,%eax
  8028ce:	05 40 10 81 00       	add    $0x811040,%eax
  8028d3:	8b 08                	mov    (%eax),%ecx
  8028d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028d8:	89 d0                	mov    %edx,%eax
  8028da:	01 c0                	add    %eax,%eax
  8028dc:	01 d0                	add    %edx,%eax
  8028de:	c1 e0 02             	shl    $0x2,%eax
  8028e1:	05 44 10 81 00       	add    $0x811044,%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	01 c1                	add    %eax,%ecx
  8028ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028ed:	89 d0                	mov    %edx,%eax
  8028ef:	01 c0                	add    %eax,%eax
  8028f1:	01 d0                	add    %edx,%eax
  8028f3:	c1 e0 02             	shl    $0x2,%eax
  8028f6:	05 40 10 81 00       	add    $0x811040,%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	39 c1                	cmp    %eax,%ecx
  8028ff:	75 52                	jne    802953 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802901:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802904:	89 d0                	mov    %edx,%eax
  802906:	01 c0                	add    %eax,%eax
  802908:	01 d0                	add    %edx,%eax
  80290a:	c1 e0 02             	shl    $0x2,%eax
  80290d:	05 44 10 81 00       	add    $0x811044,%eax
  802912:	8b 08                	mov    (%eax),%ecx
  802914:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802917:	89 d0                	mov    %edx,%eax
  802919:	01 c0                	add    %eax,%eax
  80291b:	01 d0                	add    %edx,%eax
  80291d:	c1 e0 02             	shl    $0x2,%eax
  802920:	05 44 10 81 00       	add    $0x811044,%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	01 c1                	add    %eax,%ecx
  802929:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80292c:	89 d0                	mov    %edx,%eax
  80292e:	01 c0                	add    %eax,%eax
  802930:	01 d0                	add    %edx,%eax
  802932:	c1 e0 02             	shl    $0x2,%eax
  802935:	05 44 10 81 00       	add    $0x811044,%eax
  80293a:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  80293c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80293f:	89 d0                	mov    %edx,%eax
  802941:	01 c0                	add    %eax,%eax
  802943:	01 d0                	add    %edx,%eax
  802945:	c1 e0 02             	shl    $0x2,%eax
  802948:	05 48 10 81 00       	add    $0x811048,%eax
  80294d:	c6 00 00             	movb   $0x0,(%eax)
  802950:	eb 01                	jmp    802953 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802952:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802953:	ff 45 e0             	incl   -0x20(%ebp)
  802956:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80295d:	0f 8e 7f fe ff ff    	jle    8027e2 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802963:	a1 30 51 83 00       	mov    0x835130,%eax
  802968:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80296b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802972:	eb 53                	jmp    8029c7 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802974:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802977:	89 d0                	mov    %edx,%eax
  802979:	01 c0                	add    %eax,%eax
  80297b:	01 d0                	add    %edx,%eax
  80297d:	c1 e0 02             	shl    $0x2,%eax
  802980:	05 48 50 80 00       	add    $0x805048,%eax
  802985:	8a 00                	mov    (%eax),%al
  802987:	84 c0                	test   %al,%al
  802989:	74 39                	je     8029c4 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  80298b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80298e:	89 d0                	mov    %edx,%eax
  802990:	01 c0                	add    %eax,%eax
  802992:	01 d0                	add    %edx,%eax
  802994:	c1 e0 02             	shl    $0x2,%eax
  802997:	05 40 50 80 00       	add    $0x805040,%eax
  80299c:	8b 08                	mov    (%eax),%ecx
  80299e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029a1:	89 d0                	mov    %edx,%eax
  8029a3:	01 c0                	add    %eax,%eax
  8029a5:	01 d0                	add    %edx,%eax
  8029a7:	c1 e0 02             	shl    $0x2,%eax
  8029aa:	05 44 50 80 00       	add    $0x805044,%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	01 c8                	add    %ecx,%eax
  8029b3:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  8029b6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029b9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8029bc:	76 06                	jbe    8029c4 <realloc+0x453>
  8029be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8029c4:	ff 45 d8             	incl   -0x28(%ebp)
  8029c7:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8029ce:	7e a4                	jle    802974 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  8029d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029d3:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	e9 a9 01 00 00       	jmp    802b89 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8029e0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	01 d0                	add    %edx,%eax
  8029e8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8029eb:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8029f2:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8029f9:	eb 57                	jmp    802a52 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8029fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8029fe:	89 d0                	mov    %edx,%eax
  802a00:	01 c0                	add    %eax,%eax
  802a02:	01 d0                	add    %edx,%eax
  802a04:	c1 e0 02             	shl    $0x2,%eax
  802a07:	05 48 10 81 00       	add    $0x811048,%eax
  802a0c:	8a 00                	mov    (%eax),%al
  802a0e:	84 c0                	test   %al,%al
  802a10:	74 3d                	je     802a4f <realloc+0x4de>
  802a12:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802a15:	89 d0                	mov    %edx,%eax
  802a17:	01 c0                	add    %eax,%eax
  802a19:	01 d0                	add    %edx,%eax
  802a1b:	c1 e0 02             	shl    $0x2,%eax
  802a1e:	05 40 10 81 00       	add    $0x811040,%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a28:	75 25                	jne    802a4f <realloc+0x4de>
  802a2a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802a2d:	89 d0                	mov    %edx,%eax
  802a2f:	01 c0                	add    %eax,%eax
  802a31:	01 d0                	add    %edx,%eax
  802a33:	c1 e0 02             	shl    $0x2,%eax
  802a36:	05 44 10 81 00       	add    $0x811044,%eax
  802a3b:	8b 10                	mov    (%eax),%edx
  802a3d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a40:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a43:	39 c2                	cmp    %eax,%edx
  802a45:	72 08                	jb     802a4f <realloc+0x4de>
		{
			adjIdx = j; break;
  802a47:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a4a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802a4d:	eb 0c                	jmp    802a5b <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802a4f:	ff 45 d0             	incl   -0x30(%ebp)
  802a52:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802a59:	7e a0                	jle    8029fb <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802a5b:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802a5f:	0f 84 d6 00 00 00    	je     802b3b <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802a65:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a68:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802a6b:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802a6e:	83 ec 08             	sub    $0x8,%esp
  802a71:	ff 75 a0             	pushl  -0x60(%ebp)
  802a74:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a77:	e8 cf 09 00 00       	call   80344b <sys_allocate_user_mem>
  802a7c:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802a7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a82:	89 d0                	mov    %edx,%eax
  802a84:	01 c0                	add    %eax,%eax
  802a86:	01 d0                	add    %edx,%eax
  802a88:	c1 e0 02             	shl    $0x2,%eax
  802a8b:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802a91:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a94:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802a96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802a99:	89 d0                	mov    %edx,%eax
  802a9b:	01 c0                	add    %eax,%eax
  802a9d:	01 d0                	add    %edx,%eax
  802a9f:	c1 e0 02             	shl    $0x2,%eax
  802aa2:	05 40 10 81 00       	add    $0x811040,%eax
  802aa7:	8b 10                	mov    (%eax),%edx
  802aa9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802aac:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802aaf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ab2:	89 d0                	mov    %edx,%eax
  802ab4:	01 c0                	add    %eax,%eax
  802ab6:	01 d0                	add    %edx,%eax
  802ab8:	c1 e0 02             	shl    $0x2,%eax
  802abb:	05 40 10 81 00       	add    $0x811040,%eax
  802ac0:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802ac2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ac5:	89 d0                	mov    %edx,%eax
  802ac7:	01 c0                	add    %eax,%eax
  802ac9:	01 d0                	add    %edx,%eax
  802acb:	c1 e0 02             	shl    $0x2,%eax
  802ace:	05 44 10 81 00       	add    $0x811044,%eax
  802ad3:	8b 00                	mov    (%eax),%eax
  802ad5:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802ad8:	89 c2                	mov    %eax,%edx
  802ada:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802add:	89 c8                	mov    %ecx,%eax
  802adf:	01 c0                	add    %eax,%eax
  802ae1:	01 c8                	add    %ecx,%eax
  802ae3:	c1 e0 02             	shl    $0x2,%eax
  802ae6:	05 44 10 81 00       	add    $0x811044,%eax
  802aeb:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802aed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802af0:	89 d0                	mov    %edx,%eax
  802af2:	01 c0                	add    %eax,%eax
  802af4:	01 d0                	add    %edx,%eax
  802af6:	c1 e0 02             	shl    $0x2,%eax
  802af9:	05 44 10 81 00       	add    $0x811044,%eax
  802afe:	8b 00                	mov    (%eax),%eax
  802b00:	85 c0                	test   %eax,%eax
  802b02:	75 14                	jne    802b18 <realloc+0x5a7>
  802b04:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802b07:	89 d0                	mov    %edx,%eax
  802b09:	01 c0                	add    %eax,%eax
  802b0b:	01 d0                	add    %edx,%eax
  802b0d:	c1 e0 02             	shl    $0x2,%eax
  802b10:	05 48 10 81 00       	add    $0x811048,%eax
  802b15:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802b18:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b1b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b1e:	01 c2                	add    %eax,%edx
  802b20:	a1 88 50 83 00       	mov    0x835088,%eax
  802b25:	39 c2                	cmp    %eax,%edx
  802b27:	76 0d                	jbe    802b36 <realloc+0x5c5>
  802b29:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b2c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b2f:	01 d0                	add    %edx,%eax
  802b31:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	eb 4e                	jmp    802b89 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802b3b:	83 ec 0c             	sub    $0xc,%esp
  802b3e:	ff 75 0c             	pushl  0xc(%ebp)
  802b41:	e8 0b ec ff ff       	call   801751 <malloc>
  802b46:	83 c4 10             	add    $0x10,%esp
  802b49:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802b4c:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802b50:	75 07                	jne    802b59 <realloc+0x5e8>
		return NULL;
  802b52:	b8 00 00 00 00       	mov    $0x0,%eax
  802b57:	eb 30                	jmp    802b89 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b5f:	39 d0                	cmp    %edx,%eax
  802b61:	76 02                	jbe    802b65 <realloc+0x5f4>
  802b63:	89 d0                	mov    %edx,%eax
  802b65:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802b68:	83 ec 04             	sub    $0x4,%esp
  802b6b:	50                   	push   %eax
  802b6c:	52                   	push   %edx
  802b6d:	ff 75 cc             	pushl  -0x34(%ebp)
  802b70:	e8 cf 06 00 00       	call   803244 <sys_move_user_mem>
  802b75:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802b78:	83 ec 0c             	sub    $0xc,%esp
  802b7b:	ff 75 08             	pushl  0x8(%ebp)
  802b7e:	e8 2e ef ff ff       	call   801ab1 <free>
  802b83:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802b86:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802b89:	c9                   	leave  
  802b8a:	c3                   	ret    

00802b8b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802b8b:	55                   	push   %ebp
  802b8c:	89 e5                	mov    %esp,%ebp
  802b8e:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802b97:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b9b:	0f 84 33 03 00 00    	je     802ed4 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802ba1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ba4:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802ba9:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802bac:	83 ec 08             	sub    $0x8,%esp
  802baf:	ff 75 08             	pushl  0x8(%ebp)
  802bb2:	ff 75 d8             	pushl  -0x28(%ebp)
  802bb5:	e8 7d 05 00 00       	call   803137 <sys_delete_shared_object>
  802bba:	83 c4 10             	add    $0x10,%esp
  802bbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802bc0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802bc4:	0f 88 0d 03 00 00    	js     802ed7 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802bd1:	e9 ef 02 00 00       	jmp    802ec5 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802bd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd9:	89 d0                	mov    %edx,%eax
  802bdb:	01 c0                	add    %eax,%eax
  802bdd:	01 d0                	add    %edx,%eax
  802bdf:	c1 e0 02             	shl    $0x2,%eax
  802be2:	05 48 50 80 00       	add    $0x805048,%eax
  802be7:	8a 00                	mov    (%eax),%al
  802be9:	84 c0                	test   %al,%al
  802beb:	0f 84 d1 02 00 00    	je     802ec2 <sfree+0x337>
  802bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf4:	89 d0                	mov    %edx,%eax
  802bf6:	01 c0                	add    %eax,%eax
  802bf8:	01 d0                	add    %edx,%eax
  802bfa:	c1 e0 02             	shl    $0x2,%eax
  802bfd:	05 40 50 80 00       	add    $0x805040,%eax
  802c02:	8b 00                	mov    (%eax),%eax
  802c04:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802c07:	0f 85 b5 02 00 00    	jne    802ec2 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c10:	89 d0                	mov    %edx,%eax
  802c12:	01 c0                	add    %eax,%eax
  802c14:	01 d0                	add    %edx,%eax
  802c16:	c1 e0 02             	shl    $0x2,%eax
  802c19:	05 44 50 80 00       	add    $0x805044,%eax
  802c1e:	8b 00                	mov    (%eax),%eax
  802c20:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802c23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c26:	89 d0                	mov    %edx,%eax
  802c28:	01 c0                	add    %eax,%eax
  802c2a:	01 d0                	add    %edx,%eax
  802c2c:	c1 e0 02             	shl    $0x2,%eax
  802c2f:	05 48 50 80 00       	add    $0x805048,%eax
  802c34:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802c37:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c3e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802c45:	eb 64                	jmp    802cab <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802c47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c4a:	89 d0                	mov    %edx,%eax
  802c4c:	01 c0                	add    %eax,%eax
  802c4e:	01 d0                	add    %edx,%eax
  802c50:	c1 e0 02             	shl    $0x2,%eax
  802c53:	05 48 10 81 00       	add    $0x811048,%eax
  802c58:	8a 00                	mov    (%eax),%al
  802c5a:	84 c0                	test   %al,%al
  802c5c:	75 4a                	jne    802ca8 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802c5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c61:	89 d0                	mov    %edx,%eax
  802c63:	01 c0                	add    %eax,%eax
  802c65:	01 d0                	add    %edx,%eax
  802c67:	c1 e0 02             	shl    $0x2,%eax
  802c6a:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802c70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c73:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802c75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c78:	89 d0                	mov    %edx,%eax
  802c7a:	01 c0                	add    %eax,%eax
  802c7c:	01 d0                	add    %edx,%eax
  802c7e:	c1 e0 02             	shl    $0x2,%eax
  802c81:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802c87:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c8a:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802c8c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c8f:	89 d0                	mov    %edx,%eax
  802c91:	01 c0                	add    %eax,%eax
  802c93:	01 d0                	add    %edx,%eax
  802c95:	c1 e0 02             	shl    $0x2,%eax
  802c98:	05 48 10 81 00       	add    $0x811048,%eax
  802c9d:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802ca6:	eb 0c                	jmp    802cb4 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ca8:	ff 45 ec             	incl   -0x14(%ebp)
  802cab:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802cb2:	7e 93                	jle    802c47 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802cb4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802cb8:	0f 84 8d 01 00 00    	je     802e4b <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802cbe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802cc5:	e9 74 01 00 00       	jmp    802e3e <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802cca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ccd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cd0:	0f 84 64 01 00 00    	je     802e3a <sfree+0x2af>
					if (uhp_frees[k].free)
  802cd6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cd9:	89 d0                	mov    %edx,%eax
  802cdb:	01 c0                	add    %eax,%eax
  802cdd:	01 d0                	add    %edx,%eax
  802cdf:	c1 e0 02             	shl    $0x2,%eax
  802ce2:	05 48 10 81 00       	add    $0x811048,%eax
  802ce7:	8a 00                	mov    (%eax),%al
  802ce9:	84 c0                	test   %al,%al
  802ceb:	0f 84 4a 01 00 00    	je     802e3b <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802cf1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cf4:	89 d0                	mov    %edx,%eax
  802cf6:	01 c0                	add    %eax,%eax
  802cf8:	01 d0                	add    %edx,%eax
  802cfa:	c1 e0 02             	shl    $0x2,%eax
  802cfd:	05 40 10 81 00       	add    $0x811040,%eax
  802d02:	8b 08                	mov    (%eax),%ecx
  802d04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d07:	89 d0                	mov    %edx,%eax
  802d09:	01 c0                	add    %eax,%eax
  802d0b:	01 d0                	add    %edx,%eax
  802d0d:	c1 e0 02             	shl    $0x2,%eax
  802d10:	05 44 10 81 00       	add    $0x811044,%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	01 c1                	add    %eax,%ecx
  802d19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1c:	89 d0                	mov    %edx,%eax
  802d1e:	01 c0                	add    %eax,%eax
  802d20:	01 d0                	add    %edx,%eax
  802d22:	c1 e0 02             	shl    $0x2,%eax
  802d25:	05 40 10 81 00       	add    $0x811040,%eax
  802d2a:	8b 00                	mov    (%eax),%eax
  802d2c:	39 c1                	cmp    %eax,%ecx
  802d2e:	75 7a                	jne    802daa <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802d30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d33:	89 d0                	mov    %edx,%eax
  802d35:	01 c0                	add    %eax,%eax
  802d37:	01 d0                	add    %edx,%eax
  802d39:	c1 e0 02             	shl    $0x2,%eax
  802d3c:	05 40 10 81 00       	add    $0x811040,%eax
  802d41:	8b 10                	mov    (%eax),%edx
  802d43:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d46:	89 c8                	mov    %ecx,%eax
  802d48:	01 c0                	add    %eax,%eax
  802d4a:	01 c8                	add    %ecx,%eax
  802d4c:	c1 e0 02             	shl    $0x2,%eax
  802d4f:	05 40 10 81 00       	add    $0x811040,%eax
  802d54:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802d56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d59:	89 d0                	mov    %edx,%eax
  802d5b:	01 c0                	add    %eax,%eax
  802d5d:	01 d0                	add    %edx,%eax
  802d5f:	c1 e0 02             	shl    $0x2,%eax
  802d62:	05 44 10 81 00       	add    $0x811044,%eax
  802d67:	8b 08                	mov    (%eax),%ecx
  802d69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d6c:	89 d0                	mov    %edx,%eax
  802d6e:	01 c0                	add    %eax,%eax
  802d70:	01 d0                	add    %edx,%eax
  802d72:	c1 e0 02             	shl    $0x2,%eax
  802d75:	05 44 10 81 00       	add    $0x811044,%eax
  802d7a:	8b 00                	mov    (%eax),%eax
  802d7c:	01 c1                	add    %eax,%ecx
  802d7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d81:	89 d0                	mov    %edx,%eax
  802d83:	01 c0                	add    %eax,%eax
  802d85:	01 d0                	add    %edx,%eax
  802d87:	c1 e0 02             	shl    $0x2,%eax
  802d8a:	05 44 10 81 00       	add    $0x811044,%eax
  802d8f:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d94:	89 d0                	mov    %edx,%eax
  802d96:	01 c0                	add    %eax,%eax
  802d98:	01 d0                	add    %edx,%eax
  802d9a:	c1 e0 02             	shl    $0x2,%eax
  802d9d:	05 48 10 81 00       	add    $0x811048,%eax
  802da2:	c6 00 00             	movb   $0x0,(%eax)
  802da5:	e9 91 00 00 00       	jmp    802e3b <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802daa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dad:	89 d0                	mov    %edx,%eax
  802daf:	01 c0                	add    %eax,%eax
  802db1:	01 d0                	add    %edx,%eax
  802db3:	c1 e0 02             	shl    $0x2,%eax
  802db6:	05 40 10 81 00       	add    $0x811040,%eax
  802dbb:	8b 08                	mov    (%eax),%ecx
  802dbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc0:	89 d0                	mov    %edx,%eax
  802dc2:	01 c0                	add    %eax,%eax
  802dc4:	01 d0                	add    %edx,%eax
  802dc6:	c1 e0 02             	shl    $0x2,%eax
  802dc9:	05 44 10 81 00       	add    $0x811044,%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	01 c1                	add    %eax,%ecx
  802dd2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd5:	89 d0                	mov    %edx,%eax
  802dd7:	01 c0                	add    %eax,%eax
  802dd9:	01 d0                	add    %edx,%eax
  802ddb:	c1 e0 02             	shl    $0x2,%eax
  802dde:	05 40 10 81 00       	add    $0x811040,%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	39 c1                	cmp    %eax,%ecx
  802de7:	75 52                	jne    802e3b <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802de9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dec:	89 d0                	mov    %edx,%eax
  802dee:	01 c0                	add    %eax,%eax
  802df0:	01 d0                	add    %edx,%eax
  802df2:	c1 e0 02             	shl    $0x2,%eax
  802df5:	05 44 10 81 00       	add    $0x811044,%eax
  802dfa:	8b 08                	mov    (%eax),%ecx
  802dfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dff:	89 d0                	mov    %edx,%eax
  802e01:	01 c0                	add    %eax,%eax
  802e03:	01 d0                	add    %edx,%eax
  802e05:	c1 e0 02             	shl    $0x2,%eax
  802e08:	05 44 10 81 00       	add    $0x811044,%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	01 c1                	add    %eax,%ecx
  802e11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e14:	89 d0                	mov    %edx,%eax
  802e16:	01 c0                	add    %eax,%eax
  802e18:	01 d0                	add    %edx,%eax
  802e1a:	c1 e0 02             	shl    $0x2,%eax
  802e1d:	05 44 10 81 00       	add    $0x811044,%eax
  802e22:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802e24:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e27:	89 d0                	mov    %edx,%eax
  802e29:	01 c0                	add    %eax,%eax
  802e2b:	01 d0                	add    %edx,%eax
  802e2d:	c1 e0 02             	shl    $0x2,%eax
  802e30:	05 48 10 81 00       	add    $0x811048,%eax
  802e35:	c6 00 00             	movb   $0x0,(%eax)
  802e38:	eb 01                	jmp    802e3b <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802e3a:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e3b:	ff 45 e8             	incl   -0x18(%ebp)
  802e3e:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802e45:	0f 8e 7f fe ff ff    	jle    802cca <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802e4b:	a1 30 51 83 00       	mov    0x835130,%eax
  802e50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e53:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802e5a:	eb 53                	jmp    802eaf <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802e5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e5f:	89 d0                	mov    %edx,%eax
  802e61:	01 c0                	add    %eax,%eax
  802e63:	01 d0                	add    %edx,%eax
  802e65:	c1 e0 02             	shl    $0x2,%eax
  802e68:	05 48 50 80 00       	add    $0x805048,%eax
  802e6d:	8a 00                	mov    (%eax),%al
  802e6f:	84 c0                	test   %al,%al
  802e71:	74 39                	je     802eac <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e73:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e76:	89 d0                	mov    %edx,%eax
  802e78:	01 c0                	add    %eax,%eax
  802e7a:	01 d0                	add    %edx,%eax
  802e7c:	c1 e0 02             	shl    $0x2,%eax
  802e7f:	05 40 50 80 00       	add    $0x805040,%eax
  802e84:	8b 08                	mov    (%eax),%ecx
  802e86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e89:	89 d0                	mov    %edx,%eax
  802e8b:	01 c0                	add    %eax,%eax
  802e8d:	01 d0                	add    %edx,%eax
  802e8f:	c1 e0 02             	shl    $0x2,%eax
  802e92:	05 44 50 80 00       	add    $0x805044,%eax
  802e97:	8b 00                	mov    (%eax),%eax
  802e99:	01 c8                	add    %ecx,%eax
  802e9b:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802e9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ea4:	76 06                	jbe    802eac <sfree+0x321>
  802ea6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802eac:	ff 45 e0             	incl   -0x20(%ebp)
  802eaf:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802eb6:	7e a4                	jle    802e5c <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebb:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802ec0:	eb 16                	jmp    802ed8 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802ec2:	ff 45 f4             	incl   -0xc(%ebp)
  802ec5:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802ecc:	0f 8e 04 fd ff ff    	jle    802bd6 <sfree+0x4b>
  802ed2:	eb 04                	jmp    802ed8 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802ed4:	90                   	nop
  802ed5:	eb 01                	jmp    802ed8 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802ed7:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802ed8:	c9                   	leave  
  802ed9:	c3                   	ret    

00802eda <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802eda:	55                   	push   %ebp
  802edb:	89 e5                	mov    %esp,%ebp
  802edd:	57                   	push   %edi
  802ede:	56                   	push   %esi
  802edf:	53                   	push   %ebx
  802ee0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802eec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802eef:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ef2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ef5:	cd 30                	int    $0x30
  802ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802efd:	83 c4 10             	add    $0x10,%esp
  802f00:	5b                   	pop    %ebx
  802f01:	5e                   	pop    %esi
  802f02:	5f                   	pop    %edi
  802f03:	5d                   	pop    %ebp
  802f04:	c3                   	ret    

00802f05 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802f05:	55                   	push   %ebp
  802f06:	89 e5                	mov    %esp,%ebp
  802f08:	83 ec 04             	sub    $0x4,%esp
  802f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  802f0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802f11:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f14:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	6a 00                	push   $0x0
  802f1d:	51                   	push   %ecx
  802f1e:	52                   	push   %edx
  802f1f:	ff 75 0c             	pushl  0xc(%ebp)
  802f22:	50                   	push   %eax
  802f23:	6a 00                	push   $0x0
  802f25:	e8 b0 ff ff ff       	call   802eda <syscall>
  802f2a:	83 c4 18             	add    $0x18,%esp
}
  802f2d:	90                   	nop
  802f2e:	c9                   	leave  
  802f2f:	c3                   	ret    

00802f30 <sys_cgetc>:

int
sys_cgetc(void)
{
  802f30:	55                   	push   %ebp
  802f31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802f33:	6a 00                	push   $0x0
  802f35:	6a 00                	push   $0x0
  802f37:	6a 00                	push   $0x0
  802f39:	6a 00                	push   $0x0
  802f3b:	6a 00                	push   $0x0
  802f3d:	6a 02                	push   $0x2
  802f3f:	e8 96 ff ff ff       	call   802eda <syscall>
  802f44:	83 c4 18             	add    $0x18,%esp
}
  802f47:	c9                   	leave  
  802f48:	c3                   	ret    

00802f49 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802f49:	55                   	push   %ebp
  802f4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	6a 00                	push   $0x0
  802f52:	6a 00                	push   $0x0
  802f54:	6a 00                	push   $0x0
  802f56:	6a 03                	push   $0x3
  802f58:	e8 7d ff ff ff       	call   802eda <syscall>
  802f5d:	83 c4 18             	add    $0x18,%esp
}
  802f60:	90                   	nop
  802f61:	c9                   	leave  
  802f62:	c3                   	ret    

00802f63 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802f63:	55                   	push   %ebp
  802f64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802f66:	6a 00                	push   $0x0
  802f68:	6a 00                	push   $0x0
  802f6a:	6a 00                	push   $0x0
  802f6c:	6a 00                	push   $0x0
  802f6e:	6a 00                	push   $0x0
  802f70:	6a 04                	push   $0x4
  802f72:	e8 63 ff ff ff       	call   802eda <syscall>
  802f77:	83 c4 18             	add    $0x18,%esp
}
  802f7a:	90                   	nop
  802f7b:	c9                   	leave  
  802f7c:	c3                   	ret    

00802f7d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f7d:	55                   	push   %ebp
  802f7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	6a 00                	push   $0x0
  802f88:	6a 00                	push   $0x0
  802f8a:	6a 00                	push   $0x0
  802f8c:	52                   	push   %edx
  802f8d:	50                   	push   %eax
  802f8e:	6a 08                	push   $0x8
  802f90:	e8 45 ff ff ff       	call   802eda <syscall>
  802f95:	83 c4 18             	add    $0x18,%esp
}
  802f98:	c9                   	leave  
  802f99:	c3                   	ret    

00802f9a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f9a:	55                   	push   %ebp
  802f9b:	89 e5                	mov    %esp,%ebp
  802f9d:	56                   	push   %esi
  802f9e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f9f:	8b 75 18             	mov    0x18(%ebp),%esi
  802fa2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fa5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	56                   	push   %esi
  802faf:	53                   	push   %ebx
  802fb0:	51                   	push   %ecx
  802fb1:	52                   	push   %edx
  802fb2:	50                   	push   %eax
  802fb3:	6a 09                	push   $0x9
  802fb5:	e8 20 ff ff ff       	call   802eda <syscall>
  802fba:	83 c4 18             	add    $0x18,%esp
}
  802fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802fc0:	5b                   	pop    %ebx
  802fc1:	5e                   	pop    %esi
  802fc2:	5d                   	pop    %ebp
  802fc3:	c3                   	ret    

00802fc4 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802fc4:	55                   	push   %ebp
  802fc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	6a 00                	push   $0x0
  802fcd:	6a 00                	push   $0x0
  802fcf:	ff 75 08             	pushl  0x8(%ebp)
  802fd2:	6a 0a                	push   $0xa
  802fd4:	e8 01 ff ff ff       	call   802eda <syscall>
  802fd9:	83 c4 18             	add    $0x18,%esp
}
  802fdc:	c9                   	leave  
  802fdd:	c3                   	ret    

00802fde <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802fde:	55                   	push   %ebp
  802fdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802fe1:	6a 00                	push   $0x0
  802fe3:	6a 00                	push   $0x0
  802fe5:	6a 00                	push   $0x0
  802fe7:	ff 75 0c             	pushl  0xc(%ebp)
  802fea:	ff 75 08             	pushl  0x8(%ebp)
  802fed:	6a 0b                	push   $0xb
  802fef:	e8 e6 fe ff ff       	call   802eda <syscall>
  802ff4:	83 c4 18             	add    $0x18,%esp
}
  802ff7:	c9                   	leave  
  802ff8:	c3                   	ret    

00802ff9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802ff9:	55                   	push   %ebp
  802ffa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802ffc:	6a 00                	push   $0x0
  802ffe:	6a 00                	push   $0x0
  803000:	6a 00                	push   $0x0
  803002:	6a 00                	push   $0x0
  803004:	6a 00                	push   $0x0
  803006:	6a 0c                	push   $0xc
  803008:	e8 cd fe ff ff       	call   802eda <syscall>
  80300d:	83 c4 18             	add    $0x18,%esp
}
  803010:	c9                   	leave  
  803011:	c3                   	ret    

00803012 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803012:	55                   	push   %ebp
  803013:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803015:	6a 00                	push   $0x0
  803017:	6a 00                	push   $0x0
  803019:	6a 00                	push   $0x0
  80301b:	6a 00                	push   $0x0
  80301d:	6a 00                	push   $0x0
  80301f:	6a 0d                	push   $0xd
  803021:	e8 b4 fe ff ff       	call   802eda <syscall>
  803026:	83 c4 18             	add    $0x18,%esp
}
  803029:	c9                   	leave  
  80302a:	c3                   	ret    

0080302b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80302b:	55                   	push   %ebp
  80302c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80302e:	6a 00                	push   $0x0
  803030:	6a 00                	push   $0x0
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	6a 00                	push   $0x0
  803038:	6a 0e                	push   $0xe
  80303a:	e8 9b fe ff ff       	call   802eda <syscall>
  80303f:	83 c4 18             	add    $0x18,%esp
}
  803042:	c9                   	leave  
  803043:	c3                   	ret    

00803044 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803044:	55                   	push   %ebp
  803045:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803047:	6a 00                	push   $0x0
  803049:	6a 00                	push   $0x0
  80304b:	6a 00                	push   $0x0
  80304d:	6a 00                	push   $0x0
  80304f:	6a 00                	push   $0x0
  803051:	6a 0f                	push   $0xf
  803053:	e8 82 fe ff ff       	call   802eda <syscall>
  803058:	83 c4 18             	add    $0x18,%esp
}
  80305b:	c9                   	leave  
  80305c:	c3                   	ret    

0080305d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80305d:	55                   	push   %ebp
  80305e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803060:	6a 00                	push   $0x0
  803062:	6a 00                	push   $0x0
  803064:	6a 00                	push   $0x0
  803066:	6a 00                	push   $0x0
  803068:	ff 75 08             	pushl  0x8(%ebp)
  80306b:	6a 10                	push   $0x10
  80306d:	e8 68 fe ff ff       	call   802eda <syscall>
  803072:	83 c4 18             	add    $0x18,%esp
}
  803075:	c9                   	leave  
  803076:	c3                   	ret    

00803077 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803077:	55                   	push   %ebp
  803078:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80307a:	6a 00                	push   $0x0
  80307c:	6a 00                	push   $0x0
  80307e:	6a 00                	push   $0x0
  803080:	6a 00                	push   $0x0
  803082:	6a 00                	push   $0x0
  803084:	6a 11                	push   $0x11
  803086:	e8 4f fe ff ff       	call   802eda <syscall>
  80308b:	83 c4 18             	add    $0x18,%esp
}
  80308e:	90                   	nop
  80308f:	c9                   	leave  
  803090:	c3                   	ret    

00803091 <sys_cputc>:

void
sys_cputc(const char c)
{
  803091:	55                   	push   %ebp
  803092:	89 e5                	mov    %esp,%ebp
  803094:	83 ec 04             	sub    $0x4,%esp
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80309d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030a1:	6a 00                	push   $0x0
  8030a3:	6a 00                	push   $0x0
  8030a5:	6a 00                	push   $0x0
  8030a7:	6a 00                	push   $0x0
  8030a9:	50                   	push   %eax
  8030aa:	6a 01                	push   $0x1
  8030ac:	e8 29 fe ff ff       	call   802eda <syscall>
  8030b1:	83 c4 18             	add    $0x18,%esp
}
  8030b4:	90                   	nop
  8030b5:	c9                   	leave  
  8030b6:	c3                   	ret    

008030b7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8030b7:	55                   	push   %ebp
  8030b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8030ba:	6a 00                	push   $0x0
  8030bc:	6a 00                	push   $0x0
  8030be:	6a 00                	push   $0x0
  8030c0:	6a 00                	push   $0x0
  8030c2:	6a 00                	push   $0x0
  8030c4:	6a 14                	push   $0x14
  8030c6:	e8 0f fe ff ff       	call   802eda <syscall>
  8030cb:	83 c4 18             	add    $0x18,%esp
}
  8030ce:	90                   	nop
  8030cf:	c9                   	leave  
  8030d0:	c3                   	ret    

008030d1 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8030d1:	55                   	push   %ebp
  8030d2:	89 e5                	mov    %esp,%ebp
  8030d4:	83 ec 04             	sub    $0x4,%esp
  8030d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8030da:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8030dd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8030e0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	6a 00                	push   $0x0
  8030e9:	51                   	push   %ecx
  8030ea:	52                   	push   %edx
  8030eb:	ff 75 0c             	pushl  0xc(%ebp)
  8030ee:	50                   	push   %eax
  8030ef:	6a 15                	push   $0x15
  8030f1:	e8 e4 fd ff ff       	call   802eda <syscall>
  8030f6:	83 c4 18             	add    $0x18,%esp
}
  8030f9:	c9                   	leave  
  8030fa:	c3                   	ret    

008030fb <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8030fb:	55                   	push   %ebp
  8030fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8030fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	6a 00                	push   $0x0
  803106:	6a 00                	push   $0x0
  803108:	6a 00                	push   $0x0
  80310a:	52                   	push   %edx
  80310b:	50                   	push   %eax
  80310c:	6a 16                	push   $0x16
  80310e:	e8 c7 fd ff ff       	call   802eda <syscall>
  803113:	83 c4 18             	add    $0x18,%esp
}
  803116:	c9                   	leave  
  803117:	c3                   	ret    

00803118 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803118:	55                   	push   %ebp
  803119:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80311b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80311e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	6a 00                	push   $0x0
  803126:	6a 00                	push   $0x0
  803128:	51                   	push   %ecx
  803129:	52                   	push   %edx
  80312a:	50                   	push   %eax
  80312b:	6a 17                	push   $0x17
  80312d:	e8 a8 fd ff ff       	call   802eda <syscall>
  803132:	83 c4 18             	add    $0x18,%esp
}
  803135:	c9                   	leave  
  803136:	c3                   	ret    

00803137 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803137:	55                   	push   %ebp
  803138:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80313a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	6a 00                	push   $0x0
  803142:	6a 00                	push   $0x0
  803144:	6a 00                	push   $0x0
  803146:	52                   	push   %edx
  803147:	50                   	push   %eax
  803148:	6a 18                	push   $0x18
  80314a:	e8 8b fd ff ff       	call   802eda <syscall>
  80314f:	83 c4 18             	add    $0x18,%esp
}
  803152:	c9                   	leave  
  803153:	c3                   	ret    

00803154 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803154:	55                   	push   %ebp
  803155:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803157:	8b 45 08             	mov    0x8(%ebp),%eax
  80315a:	6a 00                	push   $0x0
  80315c:	ff 75 14             	pushl  0x14(%ebp)
  80315f:	ff 75 10             	pushl  0x10(%ebp)
  803162:	ff 75 0c             	pushl  0xc(%ebp)
  803165:	50                   	push   %eax
  803166:	6a 19                	push   $0x19
  803168:	e8 6d fd ff ff       	call   802eda <syscall>
  80316d:	83 c4 18             	add    $0x18,%esp
}
  803170:	c9                   	leave  
  803171:	c3                   	ret    

00803172 <sys_run_env>:

void sys_run_env(int32 envId)
{
  803172:	55                   	push   %ebp
  803173:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	6a 00                	push   $0x0
  80317e:	6a 00                	push   $0x0
  803180:	50                   	push   %eax
  803181:	6a 1a                	push   $0x1a
  803183:	e8 52 fd ff ff       	call   802eda <syscall>
  803188:	83 c4 18             	add    $0x18,%esp
}
  80318b:	90                   	nop
  80318c:	c9                   	leave  
  80318d:	c3                   	ret    

0080318e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80318e:	55                   	push   %ebp
  80318f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	6a 00                	push   $0x0
  803196:	6a 00                	push   $0x0
  803198:	6a 00                	push   $0x0
  80319a:	6a 00                	push   $0x0
  80319c:	50                   	push   %eax
  80319d:	6a 1b                	push   $0x1b
  80319f:	e8 36 fd ff ff       	call   802eda <syscall>
  8031a4:	83 c4 18             	add    $0x18,%esp
}
  8031a7:	c9                   	leave  
  8031a8:	c3                   	ret    

008031a9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8031a9:	55                   	push   %ebp
  8031aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8031ac:	6a 00                	push   $0x0
  8031ae:	6a 00                	push   $0x0
  8031b0:	6a 00                	push   $0x0
  8031b2:	6a 00                	push   $0x0
  8031b4:	6a 00                	push   $0x0
  8031b6:	6a 05                	push   $0x5
  8031b8:	e8 1d fd ff ff       	call   802eda <syscall>
  8031bd:	83 c4 18             	add    $0x18,%esp
}
  8031c0:	c9                   	leave  
  8031c1:	c3                   	ret    

008031c2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8031c2:	55                   	push   %ebp
  8031c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8031c5:	6a 00                	push   $0x0
  8031c7:	6a 00                	push   $0x0
  8031c9:	6a 00                	push   $0x0
  8031cb:	6a 00                	push   $0x0
  8031cd:	6a 00                	push   $0x0
  8031cf:	6a 06                	push   $0x6
  8031d1:	e8 04 fd ff ff       	call   802eda <syscall>
  8031d6:	83 c4 18             	add    $0x18,%esp
}
  8031d9:	c9                   	leave  
  8031da:	c3                   	ret    

008031db <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8031db:	55                   	push   %ebp
  8031dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8031de:	6a 00                	push   $0x0
  8031e0:	6a 00                	push   $0x0
  8031e2:	6a 00                	push   $0x0
  8031e4:	6a 00                	push   $0x0
  8031e6:	6a 00                	push   $0x0
  8031e8:	6a 07                	push   $0x7
  8031ea:	e8 eb fc ff ff       	call   802eda <syscall>
  8031ef:	83 c4 18             	add    $0x18,%esp
}
  8031f2:	c9                   	leave  
  8031f3:	c3                   	ret    

008031f4 <sys_exit_env>:


void sys_exit_env(void)
{
  8031f4:	55                   	push   %ebp
  8031f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8031f7:	6a 00                	push   $0x0
  8031f9:	6a 00                	push   $0x0
  8031fb:	6a 00                	push   $0x0
  8031fd:	6a 00                	push   $0x0
  8031ff:	6a 00                	push   $0x0
  803201:	6a 1c                	push   $0x1c
  803203:	e8 d2 fc ff ff       	call   802eda <syscall>
  803208:	83 c4 18             	add    $0x18,%esp
}
  80320b:	90                   	nop
  80320c:	c9                   	leave  
  80320d:	c3                   	ret    

0080320e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80320e:	55                   	push   %ebp
  80320f:	89 e5                	mov    %esp,%ebp
  803211:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803214:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803217:	8d 50 04             	lea    0x4(%eax),%edx
  80321a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80321d:	6a 00                	push   $0x0
  80321f:	6a 00                	push   $0x0
  803221:	6a 00                	push   $0x0
  803223:	52                   	push   %edx
  803224:	50                   	push   %eax
  803225:	6a 1d                	push   $0x1d
  803227:	e8 ae fc ff ff       	call   802eda <syscall>
  80322c:	83 c4 18             	add    $0x18,%esp
	return result;
  80322f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803232:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803235:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803238:	89 01                	mov    %eax,(%ecx)
  80323a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	c9                   	leave  
  803241:	c2 04 00             	ret    $0x4

00803244 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803244:	55                   	push   %ebp
  803245:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803247:	6a 00                	push   $0x0
  803249:	6a 00                	push   $0x0
  80324b:	ff 75 10             	pushl  0x10(%ebp)
  80324e:	ff 75 0c             	pushl  0xc(%ebp)
  803251:	ff 75 08             	pushl  0x8(%ebp)
  803254:	6a 13                	push   $0x13
  803256:	e8 7f fc ff ff       	call   802eda <syscall>
  80325b:	83 c4 18             	add    $0x18,%esp
	return ;
  80325e:	90                   	nop
}
  80325f:	c9                   	leave  
  803260:	c3                   	ret    

00803261 <sys_rcr2>:
uint32 sys_rcr2()
{
  803261:	55                   	push   %ebp
  803262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803264:	6a 00                	push   $0x0
  803266:	6a 00                	push   $0x0
  803268:	6a 00                	push   $0x0
  80326a:	6a 00                	push   $0x0
  80326c:	6a 00                	push   $0x0
  80326e:	6a 1e                	push   $0x1e
  803270:	e8 65 fc ff ff       	call   802eda <syscall>
  803275:	83 c4 18             	add    $0x18,%esp
}
  803278:	c9                   	leave  
  803279:	c3                   	ret    

0080327a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80327a:	55                   	push   %ebp
  80327b:	89 e5                	mov    %esp,%ebp
  80327d:	83 ec 04             	sub    $0x4,%esp
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803286:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80328a:	6a 00                	push   $0x0
  80328c:	6a 00                	push   $0x0
  80328e:	6a 00                	push   $0x0
  803290:	6a 00                	push   $0x0
  803292:	50                   	push   %eax
  803293:	6a 1f                	push   $0x1f
  803295:	e8 40 fc ff ff       	call   802eda <syscall>
  80329a:	83 c4 18             	add    $0x18,%esp
	return ;
  80329d:	90                   	nop
}
  80329e:	c9                   	leave  
  80329f:	c3                   	ret    

008032a0 <rsttst>:
void rsttst()
{
  8032a0:	55                   	push   %ebp
  8032a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8032a3:	6a 00                	push   $0x0
  8032a5:	6a 00                	push   $0x0
  8032a7:	6a 00                	push   $0x0
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 00                	push   $0x0
  8032ad:	6a 21                	push   $0x21
  8032af:	e8 26 fc ff ff       	call   802eda <syscall>
  8032b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8032b7:	90                   	nop
}
  8032b8:	c9                   	leave  
  8032b9:	c3                   	ret    

008032ba <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8032ba:	55                   	push   %ebp
  8032bb:	89 e5                	mov    %esp,%ebp
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8032c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8032c6:	8b 55 18             	mov    0x18(%ebp),%edx
  8032c9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8032cd:	52                   	push   %edx
  8032ce:	50                   	push   %eax
  8032cf:	ff 75 10             	pushl  0x10(%ebp)
  8032d2:	ff 75 0c             	pushl  0xc(%ebp)
  8032d5:	ff 75 08             	pushl  0x8(%ebp)
  8032d8:	6a 20                	push   $0x20
  8032da:	e8 fb fb ff ff       	call   802eda <syscall>
  8032df:	83 c4 18             	add    $0x18,%esp
	return ;
  8032e2:	90                   	nop
}
  8032e3:	c9                   	leave  
  8032e4:	c3                   	ret    

008032e5 <chktst>:
void chktst(uint32 n)
{
  8032e5:	55                   	push   %ebp
  8032e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8032e8:	6a 00                	push   $0x0
  8032ea:	6a 00                	push   $0x0
  8032ec:	6a 00                	push   $0x0
  8032ee:	6a 00                	push   $0x0
  8032f0:	ff 75 08             	pushl  0x8(%ebp)
  8032f3:	6a 22                	push   $0x22
  8032f5:	e8 e0 fb ff ff       	call   802eda <syscall>
  8032fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8032fd:	90                   	nop
}
  8032fe:	c9                   	leave  
  8032ff:	c3                   	ret    

00803300 <inctst>:

void inctst()
{
  803300:	55                   	push   %ebp
  803301:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803303:	6a 00                	push   $0x0
  803305:	6a 00                	push   $0x0
  803307:	6a 00                	push   $0x0
  803309:	6a 00                	push   $0x0
  80330b:	6a 00                	push   $0x0
  80330d:	6a 23                	push   $0x23
  80330f:	e8 c6 fb ff ff       	call   802eda <syscall>
  803314:	83 c4 18             	add    $0x18,%esp
	return ;
  803317:	90                   	nop
}
  803318:	c9                   	leave  
  803319:	c3                   	ret    

0080331a <gettst>:
uint32 gettst()
{
  80331a:	55                   	push   %ebp
  80331b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80331d:	6a 00                	push   $0x0
  80331f:	6a 00                	push   $0x0
  803321:	6a 00                	push   $0x0
  803323:	6a 00                	push   $0x0
  803325:	6a 00                	push   $0x0
  803327:	6a 24                	push   $0x24
  803329:	e8 ac fb ff ff       	call   802eda <syscall>
  80332e:	83 c4 18             	add    $0x18,%esp
}
  803331:	c9                   	leave  
  803332:	c3                   	ret    

00803333 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  803333:	55                   	push   %ebp
  803334:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803336:	6a 00                	push   $0x0
  803338:	6a 00                	push   $0x0
  80333a:	6a 00                	push   $0x0
  80333c:	6a 00                	push   $0x0
  80333e:	6a 00                	push   $0x0
  803340:	6a 25                	push   $0x25
  803342:	e8 93 fb ff ff       	call   802eda <syscall>
  803347:	83 c4 18             	add    $0x18,%esp
  80334a:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  80334f:	a1 80 50 83 00       	mov    0x835080,%eax
}
  803354:	c9                   	leave  
  803355:	c3                   	ret    

00803356 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803356:	55                   	push   %ebp
  803357:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803361:	6a 00                	push   $0x0
  803363:	6a 00                	push   $0x0
  803365:	6a 00                	push   $0x0
  803367:	6a 00                	push   $0x0
  803369:	ff 75 08             	pushl  0x8(%ebp)
  80336c:	6a 26                	push   $0x26
  80336e:	e8 67 fb ff ff       	call   802eda <syscall>
  803373:	83 c4 18             	add    $0x18,%esp
	return ;
  803376:	90                   	nop
}
  803377:	c9                   	leave  
  803378:	c3                   	ret    

00803379 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803379:	55                   	push   %ebp
  80337a:	89 e5                	mov    %esp,%ebp
  80337c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80337d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803380:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803383:	8b 55 0c             	mov    0xc(%ebp),%edx
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	6a 00                	push   $0x0
  80338b:	53                   	push   %ebx
  80338c:	51                   	push   %ecx
  80338d:	52                   	push   %edx
  80338e:	50                   	push   %eax
  80338f:	6a 27                	push   $0x27
  803391:	e8 44 fb ff ff       	call   802eda <syscall>
  803396:	83 c4 18             	add    $0x18,%esp
}
  803399:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80339c:	c9                   	leave  
  80339d:	c3                   	ret    

0080339e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80339e:	55                   	push   %ebp
  80339f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8033a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	6a 00                	push   $0x0
  8033a9:	6a 00                	push   $0x0
  8033ab:	6a 00                	push   $0x0
  8033ad:	52                   	push   %edx
  8033ae:	50                   	push   %eax
  8033af:	6a 28                	push   $0x28
  8033b1:	e8 24 fb ff ff       	call   802eda <syscall>
  8033b6:	83 c4 18             	add    $0x18,%esp
}
  8033b9:	c9                   	leave  
  8033ba:	c3                   	ret    

008033bb <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8033bb:	55                   	push   %ebp
  8033bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8033be:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8033c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	6a 00                	push   $0x0
  8033c9:	51                   	push   %ecx
  8033ca:	ff 75 10             	pushl  0x10(%ebp)
  8033cd:	52                   	push   %edx
  8033ce:	50                   	push   %eax
  8033cf:	6a 29                	push   $0x29
  8033d1:	e8 04 fb ff ff       	call   802eda <syscall>
  8033d6:	83 c4 18             	add    $0x18,%esp
}
  8033d9:	c9                   	leave  
  8033da:	c3                   	ret    

008033db <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8033db:	55                   	push   %ebp
  8033dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8033de:	6a 00                	push   $0x0
  8033e0:	6a 00                	push   $0x0
  8033e2:	ff 75 10             	pushl  0x10(%ebp)
  8033e5:	ff 75 0c             	pushl  0xc(%ebp)
  8033e8:	ff 75 08             	pushl  0x8(%ebp)
  8033eb:	6a 12                	push   $0x12
  8033ed:	e8 e8 fa ff ff       	call   802eda <syscall>
  8033f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8033f5:	90                   	nop
}
  8033f6:	c9                   	leave  
  8033f7:	c3                   	ret    

008033f8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8033f8:	55                   	push   %ebp
  8033f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8033fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	6a 00                	push   $0x0
  803403:	6a 00                	push   $0x0
  803405:	6a 00                	push   $0x0
  803407:	52                   	push   %edx
  803408:	50                   	push   %eax
  803409:	6a 2a                	push   $0x2a
  80340b:	e8 ca fa ff ff       	call   802eda <syscall>
  803410:	83 c4 18             	add    $0x18,%esp
	return;
  803413:	90                   	nop
}
  803414:	c9                   	leave  
  803415:	c3                   	ret    

00803416 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803416:	55                   	push   %ebp
  803417:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803419:	6a 00                	push   $0x0
  80341b:	6a 00                	push   $0x0
  80341d:	6a 00                	push   $0x0
  80341f:	6a 00                	push   $0x0
  803421:	6a 00                	push   $0x0
  803423:	6a 2b                	push   $0x2b
  803425:	e8 b0 fa ff ff       	call   802eda <syscall>
  80342a:	83 c4 18             	add    $0x18,%esp
}
  80342d:	c9                   	leave  
  80342e:	c3                   	ret    

0080342f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80342f:	55                   	push   %ebp
  803430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  803432:	6a 00                	push   $0x0
  803434:	6a 00                	push   $0x0
  803436:	6a 00                	push   $0x0
  803438:	ff 75 0c             	pushl  0xc(%ebp)
  80343b:	ff 75 08             	pushl  0x8(%ebp)
  80343e:	6a 2d                	push   $0x2d
  803440:	e8 95 fa ff ff       	call   802eda <syscall>
  803445:	83 c4 18             	add    $0x18,%esp
	return;
  803448:	90                   	nop
}
  803449:	c9                   	leave  
  80344a:	c3                   	ret    

0080344b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80344b:	55                   	push   %ebp
  80344c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80344e:	6a 00                	push   $0x0
  803450:	6a 00                	push   $0x0
  803452:	6a 00                	push   $0x0
  803454:	ff 75 0c             	pushl  0xc(%ebp)
  803457:	ff 75 08             	pushl  0x8(%ebp)
  80345a:	6a 2c                	push   $0x2c
  80345c:	e8 79 fa ff ff       	call   802eda <syscall>
  803461:	83 c4 18             	add    $0x18,%esp
	return ;
  803464:	90                   	nop
}
  803465:	c9                   	leave  
  803466:	c3                   	ret    

00803467 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803467:	55                   	push   %ebp
  803468:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80346a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	6a 00                	push   $0x0
  803472:	6a 00                	push   $0x0
  803474:	6a 00                	push   $0x0
  803476:	52                   	push   %edx
  803477:	50                   	push   %eax
  803478:	6a 2e                	push   $0x2e
  80347a:	e8 5b fa ff ff       	call   802eda <syscall>
  80347f:	83 c4 18             	add    $0x18,%esp
}
  803482:	90                   	nop
  803483:	c9                   	leave  
  803484:	c3                   	ret    

00803485 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803485:	55                   	push   %ebp
  803486:	89 e5                	mov    %esp,%ebp
  803488:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80348b:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  803492:	72 09                	jb     80349d <to_page_va+0x18>
  803494:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  80349b:	72 14                	jb     8034b1 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80349d:	83 ec 04             	sub    $0x4,%esp
  8034a0:	68 58 4a 80 00       	push   $0x804a58
  8034a5:	6a 15                	push   $0x15
  8034a7:	68 83 4a 80 00       	push   $0x804a83
  8034ac:	e8 db 0a 00 00       	call   803f8c <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8034b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b4:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8034b9:	29 d0                	sub    %edx,%eax
  8034bb:	c1 f8 02             	sar    $0x2,%eax
  8034be:	89 c2                	mov    %eax,%edx
  8034c0:	89 d0                	mov    %edx,%eax
  8034c2:	c1 e0 02             	shl    $0x2,%eax
  8034c5:	01 d0                	add    %edx,%eax
  8034c7:	c1 e0 02             	shl    $0x2,%eax
  8034ca:	01 d0                	add    %edx,%eax
  8034cc:	c1 e0 02             	shl    $0x2,%eax
  8034cf:	01 d0                	add    %edx,%eax
  8034d1:	89 c1                	mov    %eax,%ecx
  8034d3:	c1 e1 08             	shl    $0x8,%ecx
  8034d6:	01 c8                	add    %ecx,%eax
  8034d8:	89 c1                	mov    %eax,%ecx
  8034da:	c1 e1 10             	shl    $0x10,%ecx
  8034dd:	01 c8                	add    %ecx,%eax
  8034df:	01 c0                	add    %eax,%eax
  8034e1:	01 d0                	add    %edx,%eax
  8034e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8034e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e9:	c1 e0 0c             	shl    $0xc,%eax
  8034ec:	89 c2                	mov    %eax,%edx
  8034ee:	a1 84 50 83 00       	mov    0x835084,%eax
  8034f3:	01 d0                	add    %edx,%eax
}
  8034f5:	c9                   	leave  
  8034f6:	c3                   	ret    

008034f7 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8034f7:	55                   	push   %ebp
  8034f8:	89 e5                	mov    %esp,%ebp
  8034fa:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8034fd:	a1 84 50 83 00       	mov    0x835084,%eax
  803502:	8b 55 08             	mov    0x8(%ebp),%edx
  803505:	29 c2                	sub    %eax,%edx
  803507:	89 d0                	mov    %edx,%eax
  803509:	c1 e8 0c             	shr    $0xc,%eax
  80350c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80350f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803513:	78 09                	js     80351e <to_page_info+0x27>
  803515:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80351c:	7e 14                	jle    803532 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  80351e:	83 ec 04             	sub    $0x4,%esp
  803521:	68 9c 4a 80 00       	push   $0x804a9c
  803526:	6a 21                	push   $0x21
  803528:	68 83 4a 80 00       	push   $0x804a83
  80352d:	e8 5a 0a 00 00       	call   803f8c <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  803532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803535:	89 d0                	mov    %edx,%eax
  803537:	01 c0                	add    %eax,%eax
  803539:	01 d0                	add    %edx,%eax
  80353b:	c1 e0 02             	shl    $0x2,%eax
  80353e:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  803543:	c9                   	leave  
  803544:	c3                   	ret    

00803545 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803545:	55                   	push   %ebp
  803546:	89 e5                	mov    %esp,%ebp
  803548:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  80354b:	8b 45 08             	mov    0x8(%ebp),%eax
  80354e:	05 00 00 00 02       	add    $0x2000000,%eax
  803553:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803556:	73 16                	jae    80356e <initialize_dynamic_allocator+0x29>
  803558:	68 c0 4a 80 00       	push   $0x804ac0
  80355d:	68 e6 4a 80 00       	push   $0x804ae6
  803562:	6a 2f                	push   $0x2f
  803564:	68 83 4a 80 00       	push   $0x804a83
  803569:	e8 1e 0a 00 00       	call   803f8c <_panic>
	dynAllocStart = daStart;
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  803576:	8b 45 0c             	mov    0xc(%ebp),%eax
  803579:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80357e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803585:	eb 36                	jmp    8035bd <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358a:	c1 e0 04             	shl    $0x4,%eax
  80358d:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803592:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359b:	c1 e0 04             	shl    $0x4,%eax
  80359e:	05 a4 50 83 00       	add    $0x8350a4,%eax
  8035a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ac:	c1 e0 04             	shl    $0x4,%eax
  8035af:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8035b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8035ba:	ff 45 f4             	incl   -0xc(%ebp)
  8035bd:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8035c1:	7e c4                	jle    803587 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8035c3:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  8035ca:	00 00 00 
  8035cd:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  8035d4:	00 00 00 
  8035d7:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  8035de:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8035e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035e8:	e9 1b 01 00 00       	jmp    803708 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8035ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f0:	89 d0                	mov    %edx,%eax
  8035f2:	01 c0                	add    %eax,%eax
  8035f4:	01 d0                	add    %edx,%eax
  8035f6:	c1 e0 02             	shl    $0x2,%eax
  8035f9:	05 88 d0 81 00       	add    $0x81d088,%eax
  8035fe:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803603:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803606:	89 d0                	mov    %edx,%eax
  803608:	01 c0                	add    %eax,%eax
  80360a:	01 d0                	add    %edx,%eax
  80360c:	c1 e0 02             	shl    $0x2,%eax
  80360f:	05 8a d0 81 00       	add    $0x81d08a,%eax
  803614:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803619:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80361c:	89 d0                	mov    %edx,%eax
  80361e:	01 c0                	add    %eax,%eax
  803620:	01 d0                	add    %edx,%eax
  803622:	c1 e0 02             	shl    $0x2,%eax
  803625:	05 80 d0 81 00       	add    $0x81d080,%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 2b                	je     80365b <initialize_dynamic_allocator+0x116>
  803630:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803633:	89 d0                	mov    %edx,%eax
  803635:	01 c0                	add    %eax,%eax
  803637:	01 d0                	add    %edx,%eax
  803639:	c1 e0 02             	shl    $0x2,%eax
  80363c:	05 80 d0 81 00       	add    $0x81d080,%eax
  803641:	8b 10                	mov    (%eax),%edx
  803643:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803646:	89 c8                	mov    %ecx,%eax
  803648:	01 c0                	add    %eax,%eax
  80364a:	01 c8                	add    %ecx,%eax
  80364c:	c1 e0 02             	shl    $0x2,%eax
  80364f:	05 84 d0 81 00       	add    $0x81d084,%eax
  803654:	8b 00                	mov    (%eax),%eax
  803656:	89 42 04             	mov    %eax,0x4(%edx)
  803659:	eb 18                	jmp    803673 <initialize_dynamic_allocator+0x12e>
  80365b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80365e:	89 d0                	mov    %edx,%eax
  803660:	01 c0                	add    %eax,%eax
  803662:	01 d0                	add    %edx,%eax
  803664:	c1 e0 02             	shl    $0x2,%eax
  803667:	05 84 d0 81 00       	add    $0x81d084,%eax
  80366c:	8b 00                	mov    (%eax),%eax
  80366e:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803673:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803676:	89 d0                	mov    %edx,%eax
  803678:	01 c0                	add    %eax,%eax
  80367a:	01 d0                	add    %edx,%eax
  80367c:	c1 e0 02             	shl    $0x2,%eax
  80367f:	05 84 d0 81 00       	add    $0x81d084,%eax
  803684:	8b 00                	mov    (%eax),%eax
  803686:	85 c0                	test   %eax,%eax
  803688:	74 2a                	je     8036b4 <initialize_dynamic_allocator+0x16f>
  80368a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80368d:	89 d0                	mov    %edx,%eax
  80368f:	01 c0                	add    %eax,%eax
  803691:	01 d0                	add    %edx,%eax
  803693:	c1 e0 02             	shl    $0x2,%eax
  803696:	05 84 d0 81 00       	add    $0x81d084,%eax
  80369b:	8b 10                	mov    (%eax),%edx
  80369d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8036a0:	89 c8                	mov    %ecx,%eax
  8036a2:	01 c0                	add    %eax,%eax
  8036a4:	01 c8                	add    %ecx,%eax
  8036a6:	c1 e0 02             	shl    $0x2,%eax
  8036a9:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036ae:	8b 00                	mov    (%eax),%eax
  8036b0:	89 02                	mov    %eax,(%edx)
  8036b2:	eb 18                	jmp    8036cc <initialize_dynamic_allocator+0x187>
  8036b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036b7:	89 d0                	mov    %edx,%eax
  8036b9:	01 c0                	add    %eax,%eax
  8036bb:	01 d0                	add    %edx,%eax
  8036bd:	c1 e0 02             	shl    $0x2,%eax
  8036c0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036c5:	8b 00                	mov    (%eax),%eax
  8036c7:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8036cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036cf:	89 d0                	mov    %edx,%eax
  8036d1:	01 c0                	add    %eax,%eax
  8036d3:	01 d0                	add    %edx,%eax
  8036d5:	c1 e0 02             	shl    $0x2,%eax
  8036d8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8036dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e6:	89 d0                	mov    %edx,%eax
  8036e8:	01 c0                	add    %eax,%eax
  8036ea:	01 d0                	add    %edx,%eax
  8036ec:	c1 e0 02             	shl    $0x2,%eax
  8036ef:	05 84 d0 81 00       	add    $0x81d084,%eax
  8036f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036fa:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8036ff:	48                   	dec    %eax
  803700:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803705:	ff 45 f0             	incl   -0x10(%ebp)
  803708:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  80370f:	0f 8e d8 fe ff ff    	jle    8035ed <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803715:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  80371c:	e9 9d 00 00 00       	jmp    8037be <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803721:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803727:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80372a:	89 c8                	mov    %ecx,%eax
  80372c:	01 c0                	add    %eax,%eax
  80372e:	01 c8                	add    %ecx,%eax
  803730:	c1 e0 02             	shl    $0x2,%eax
  803733:	05 80 d0 81 00       	add    $0x81d080,%eax
  803738:	89 10                	mov    %edx,(%eax)
  80373a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80373d:	89 d0                	mov    %edx,%eax
  80373f:	01 c0                	add    %eax,%eax
  803741:	01 d0                	add    %edx,%eax
  803743:	c1 e0 02             	shl    $0x2,%eax
  803746:	05 80 d0 81 00       	add    $0x81d080,%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	85 c0                	test   %eax,%eax
  80374f:	74 1c                	je     80376d <initialize_dynamic_allocator+0x228>
  803751:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803757:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80375a:	89 c8                	mov    %ecx,%eax
  80375c:	01 c0                	add    %eax,%eax
  80375e:	01 c8                	add    %ecx,%eax
  803760:	c1 e0 02             	shl    $0x2,%eax
  803763:	05 80 d0 81 00       	add    $0x81d080,%eax
  803768:	89 42 04             	mov    %eax,0x4(%edx)
  80376b:	eb 16                	jmp    803783 <initialize_dynamic_allocator+0x23e>
  80376d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803770:	89 d0                	mov    %edx,%eax
  803772:	01 c0                	add    %eax,%eax
  803774:	01 d0                	add    %edx,%eax
  803776:	c1 e0 02             	shl    $0x2,%eax
  803779:	05 80 d0 81 00       	add    $0x81d080,%eax
  80377e:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803783:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803786:	89 d0                	mov    %edx,%eax
  803788:	01 c0                	add    %eax,%eax
  80378a:	01 d0                	add    %edx,%eax
  80378c:	c1 e0 02             	shl    $0x2,%eax
  80378f:	05 80 d0 81 00       	add    $0x81d080,%eax
  803794:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803799:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80379c:	89 d0                	mov    %edx,%eax
  80379e:	01 c0                	add    %eax,%eax
  8037a0:	01 d0                	add    %edx,%eax
  8037a2:	c1 e0 02             	shl    $0x2,%eax
  8037a5:	05 84 d0 81 00       	add    $0x81d084,%eax
  8037aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037b0:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8037b5:	40                   	inc    %eax
  8037b6:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8037bb:	ff 4d ec             	decl   -0x14(%ebp)
  8037be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037c2:	0f 89 59 ff ff ff    	jns    803721 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8037c8:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  8037cf:	00 00 00 
}
  8037d2:	90                   	nop
  8037d3:	c9                   	leave  
  8037d4:	c3                   	ret    

008037d5 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8037d5:	55                   	push   %ebp
  8037d6:	89 e5                	mov    %esp,%ebp
  8037d8:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8037db:	8b 45 08             	mov    0x8(%ebp),%eax
  8037de:	83 ec 0c             	sub    $0xc,%esp
  8037e1:	50                   	push   %eax
  8037e2:	e8 10 fd ff ff       	call   8034f7 <to_page_info>
  8037e7:	83 c4 10             	add    $0x10,%esp
  8037ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8037ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f0:	8b 40 08             	mov    0x8(%eax),%eax
  8037f3:	0f b7 c0             	movzwl %ax,%eax
}
  8037f6:	c9                   	leave  
  8037f7:	c3                   	ret    

008037f8 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8037f8:	55                   	push   %ebp
  8037f9:	89 e5                	mov    %esp,%ebp
  8037fb:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8037fe:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803805:	76 16                	jbe    80381d <alloc_block+0x25>
  803807:	68 fc 4a 80 00       	push   $0x804afc
  80380c:	68 e6 4a 80 00       	push   $0x804ae6
  803811:	6a 59                	push   $0x59
  803813:	68 83 4a 80 00       	push   $0x804a83
  803818:	e8 6f 07 00 00       	call   803f8c <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  80381d:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803824:	eb 08                	jmp    80382e <alloc_block+0x36>
		allocSize <<= 1;
  803826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803829:	01 c0                	add    %eax,%eax
  80382b:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	3b 45 08             	cmp    0x8(%ebp),%eax
  803834:	73 09                	jae    80383f <alloc_block+0x47>
  803836:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  80383d:	76 e7                	jbe    803826 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  80383f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803846:	eb 03                	jmp    80384b <alloc_block+0x53>
		listIndex++;
  803848:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80384b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384e:	ba 08 00 00 00       	mov    $0x8,%edx
  803853:	88 c1                	mov    %al,%cl
  803855:	d3 e2                	shl    %cl,%edx
  803857:	89 d0                	mov    %edx,%eax
  803859:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80385c:	72 ea                	jb     803848 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80385e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803861:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803864:	e9 f4 00 00 00       	jmp    80395d <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80386c:	c1 e0 04             	shl    $0x4,%eax
  80386f:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803874:	8b 00                	mov    (%eax),%eax
  803876:	85 c0                	test   %eax,%eax
  803878:	0f 84 dc 00 00 00    	je     80395a <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  80387e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803881:	c1 e0 04             	shl    $0x4,%eax
  803884:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803889:	8b 00                	mov    (%eax),%eax
  80388b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80388e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803892:	75 14                	jne    8038a8 <alloc_block+0xb0>
  803894:	83 ec 04             	sub    $0x4,%esp
  803897:	68 1d 4b 80 00       	push   $0x804b1d
  80389c:	6a 6b                	push   $0x6b
  80389e:	68 83 4a 80 00       	push   $0x804a83
  8038a3:	e8 e4 06 00 00       	call   803f8c <_panic>
  8038a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ab:	8b 00                	mov    (%eax),%eax
  8038ad:	85 c0                	test   %eax,%eax
  8038af:	74 10                	je     8038c1 <alloc_block+0xc9>
  8038b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b4:	8b 00                	mov    (%eax),%eax
  8038b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b9:	8b 52 04             	mov    0x4(%edx),%edx
  8038bc:	89 50 04             	mov    %edx,0x4(%eax)
  8038bf:	eb 14                	jmp    8038d5 <alloc_block+0xdd>
  8038c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c4:	8b 40 04             	mov    0x4(%eax),%eax
  8038c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038ca:	c1 e2 04             	shl    $0x4,%edx
  8038cd:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8038d3:	89 02                	mov    %eax,(%edx)
  8038d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d8:	8b 40 04             	mov    0x4(%eax),%eax
  8038db:	85 c0                	test   %eax,%eax
  8038dd:	74 0f                	je     8038ee <alloc_block+0xf6>
  8038df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e2:	8b 40 04             	mov    0x4(%eax),%eax
  8038e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e8:	8b 12                	mov    (%edx),%edx
  8038ea:	89 10                	mov    %edx,(%eax)
  8038ec:	eb 13                	jmp    803901 <alloc_block+0x109>
  8038ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f1:	8b 00                	mov    (%eax),%eax
  8038f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038f6:	c1 e2 04             	shl    $0x4,%edx
  8038f9:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8038ff:	89 02                	mov    %eax,(%edx)
  803901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803904:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80390a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803914:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803917:	c1 e0 04             	shl    $0x4,%eax
  80391a:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80391f:	8b 00                	mov    (%eax),%eax
  803921:	8d 50 ff             	lea    -0x1(%eax),%edx
  803924:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803927:	c1 e0 04             	shl    $0x4,%eax
  80392a:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80392f:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803934:	83 ec 0c             	sub    $0xc,%esp
  803937:	50                   	push   %eax
  803938:	e8 ba fb ff ff       	call   8034f7 <to_page_info>
  80393d:	83 c4 10             	add    $0x10,%esp
  803940:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803943:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803946:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80394a:	48                   	dec    %eax
  80394b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80394e:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803955:	e9 8f 02 00 00       	jmp    803be9 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80395a:	ff 45 ec             	incl   -0x14(%ebp)
  80395d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803961:	0f 8e 02 ff ff ff    	jle    803869 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803967:	a1 68 d0 81 00       	mov    0x81d068,%eax
  80396c:	85 c0                	test   %eax,%eax
  80396e:	75 14                	jne    803984 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803970:	83 ec 04             	sub    $0x4,%esp
  803973:	68 3c 4b 80 00       	push   $0x804b3c
  803978:	6a 77                	push   $0x77
  80397a:	68 83 4a 80 00       	push   $0x804a83
  80397f:	e8 08 06 00 00       	call   803f8c <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803984:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803989:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  80398c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803990:	75 14                	jne    8039a6 <alloc_block+0x1ae>
  803992:	83 ec 04             	sub    $0x4,%esp
  803995:	68 1d 4b 80 00       	push   $0x804b1d
  80399a:	6a 7a                	push   $0x7a
  80399c:	68 83 4a 80 00       	push   $0x804a83
  8039a1:	e8 e6 05 00 00       	call   803f8c <_panic>
  8039a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039a9:	8b 00                	mov    (%eax),%eax
  8039ab:	85 c0                	test   %eax,%eax
  8039ad:	74 10                	je     8039bf <alloc_block+0x1c7>
  8039af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039b7:	8b 52 04             	mov    0x4(%edx),%edx
  8039ba:	89 50 04             	mov    %edx,0x4(%eax)
  8039bd:	eb 0b                	jmp    8039ca <alloc_block+0x1d2>
  8039bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039c2:	8b 40 04             	mov    0x4(%eax),%eax
  8039c5:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8039ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039cd:	8b 40 04             	mov    0x4(%eax),%eax
  8039d0:	85 c0                	test   %eax,%eax
  8039d2:	74 0f                	je     8039e3 <alloc_block+0x1eb>
  8039d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039d7:	8b 40 04             	mov    0x4(%eax),%eax
  8039da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039dd:	8b 12                	mov    (%edx),%edx
  8039df:	89 10                	mov    %edx,(%eax)
  8039e1:	eb 0a                	jmp    8039ed <alloc_block+0x1f5>
  8039e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039e6:	8b 00                	mov    (%eax),%eax
  8039e8:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8039ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a00:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803a05:	48                   	dec    %eax
  803a06:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803a0b:	83 ec 0c             	sub    $0xc,%esp
  803a0e:	ff 75 dc             	pushl  -0x24(%ebp)
  803a11:	e8 6f fa ff ff       	call   803485 <to_page_va>
  803a16:	83 c4 10             	add    $0x10,%esp
  803a19:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803a1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a1f:	83 ec 0c             	sub    $0xc,%esp
  803a22:	50                   	push   %eax
  803a23:	e8 a0 dc ff ff       	call   8016c8 <get_page>
  803a28:	83 c4 10             	add    $0x10,%esp
  803a2b:	85 c0                	test   %eax,%eax
  803a2d:	74 14                	je     803a43 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803a2f:	83 ec 04             	sub    $0x4,%esp
  803a32:	68 64 4b 80 00       	push   $0x804b64
  803a37:	6a 7f                	push   $0x7f
  803a39:	68 83 4a 80 00       	push   $0x804a83
  803a3e:	e8 49 05 00 00       	call   803f8c <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a46:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a49:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803a4d:	b8 00 10 00 00       	mov    $0x1000,%eax
  803a52:	ba 00 00 00 00       	mov    $0x0,%edx
  803a57:	f7 75 f4             	divl   -0xc(%ebp)
  803a5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a5d:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803a61:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a68:	e9 a7 00 00 00       	jmp    803b14 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803a6d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a73:	01 d0                	add    %edx,%eax
  803a75:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803a78:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a7c:	75 17                	jne    803a95 <alloc_block+0x29d>
  803a7e:	83 ec 04             	sub    $0x4,%esp
  803a81:	68 8c 4b 80 00       	push   $0x804b8c
  803a86:	68 88 00 00 00       	push   $0x88
  803a8b:	68 83 4a 80 00       	push   $0x804a83
  803a90:	e8 f7 04 00 00       	call   803f8c <_panic>
  803a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a98:	c1 e0 04             	shl    $0x4,%eax
  803a9b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803aa0:	8b 10                	mov    (%eax),%edx
  803aa2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aa5:	89 10                	mov    %edx,(%eax)
  803aa7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aaa:	8b 00                	mov    (%eax),%eax
  803aac:	85 c0                	test   %eax,%eax
  803aae:	74 15                	je     803ac5 <alloc_block+0x2cd>
  803ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab3:	c1 e0 04             	shl    $0x4,%eax
  803ab6:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803abb:	8b 00                	mov    (%eax),%eax
  803abd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ac0:	89 50 04             	mov    %edx,0x4(%eax)
  803ac3:	eb 11                	jmp    803ad6 <alloc_block+0x2de>
  803ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ac8:	c1 e0 04             	shl    $0x4,%eax
  803acb:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803ad1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad4:	89 02                	mov    %eax,(%edx)
  803ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad9:	c1 e0 04             	shl    $0x4,%eax
  803adc:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803ae2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae5:	89 02                	mov    %eax,(%edx)
  803ae7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af4:	c1 e0 04             	shl    $0x4,%eax
  803af7:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803afc:	8b 00                	mov    (%eax),%eax
  803afe:	8d 50 01             	lea    0x1(%eax),%edx
  803b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b04:	c1 e0 04             	shl    $0x4,%eax
  803b07:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803b0c:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b11:	01 45 e8             	add    %eax,-0x18(%ebp)
  803b14:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803b1b:	0f 86 4c ff ff ff    	jbe    803a6d <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b24:	c1 e0 04             	shl    $0x4,%eax
  803b27:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b2c:	8b 00                	mov    (%eax),%eax
  803b2e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803b31:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b35:	75 17                	jne    803b4e <alloc_block+0x356>
  803b37:	83 ec 04             	sub    $0x4,%esp
  803b3a:	68 1d 4b 80 00       	push   $0x804b1d
  803b3f:	68 8d 00 00 00       	push   $0x8d
  803b44:	68 83 4a 80 00       	push   $0x804a83
  803b49:	e8 3e 04 00 00       	call   803f8c <_panic>
  803b4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b51:	8b 00                	mov    (%eax),%eax
  803b53:	85 c0                	test   %eax,%eax
  803b55:	74 10                	je     803b67 <alloc_block+0x36f>
  803b57:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b5a:	8b 00                	mov    (%eax),%eax
  803b5c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b5f:	8b 52 04             	mov    0x4(%edx),%edx
  803b62:	89 50 04             	mov    %edx,0x4(%eax)
  803b65:	eb 14                	jmp    803b7b <alloc_block+0x383>
  803b67:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b6a:	8b 40 04             	mov    0x4(%eax),%eax
  803b6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b70:	c1 e2 04             	shl    $0x4,%edx
  803b73:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803b79:	89 02                	mov    %eax,(%edx)
  803b7b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b7e:	8b 40 04             	mov    0x4(%eax),%eax
  803b81:	85 c0                	test   %eax,%eax
  803b83:	74 0f                	je     803b94 <alloc_block+0x39c>
  803b85:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b88:	8b 40 04             	mov    0x4(%eax),%eax
  803b8b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803b8e:	8b 12                	mov    (%edx),%edx
  803b90:	89 10                	mov    %edx,(%eax)
  803b92:	eb 13                	jmp    803ba7 <alloc_block+0x3af>
  803b94:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b97:	8b 00                	mov    (%eax),%eax
  803b99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b9c:	c1 e2 04             	shl    $0x4,%edx
  803b9f:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803ba5:	89 02                	mov    %eax,(%edx)
  803ba7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803baa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bb0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803bb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bbd:	c1 e0 04             	shl    $0x4,%eax
  803bc0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803bc5:	8b 00                	mov    (%eax),%eax
  803bc7:	8d 50 ff             	lea    -0x1(%eax),%edx
  803bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bcd:	c1 e0 04             	shl    $0x4,%eax
  803bd0:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803bd5:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803bd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bda:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803bde:	48                   	dec    %eax
  803bdf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803be2:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803be6:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803be9:	c9                   	leave  
  803bea:	c3                   	ret    

00803beb <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803beb:	55                   	push   %ebp
  803bec:	89 e5                	mov    %esp,%ebp
  803bee:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  803bf4:	a1 84 50 83 00       	mov    0x835084,%eax
  803bf9:	39 c2                	cmp    %eax,%edx
  803bfb:	72 0c                	jb     803c09 <free_block+0x1e>
  803bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  803c00:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803c05:	39 c2                	cmp    %eax,%edx
  803c07:	72 19                	jb     803c22 <free_block+0x37>
  803c09:	68 b0 4b 80 00       	push   $0x804bb0
  803c0e:	68 e6 4a 80 00       	push   $0x804ae6
  803c13:	68 98 00 00 00       	push   $0x98
  803c18:	68 83 4a 80 00       	push   $0x804a83
  803c1d:	e8 6a 03 00 00       	call   803f8c <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803c22:	8b 45 08             	mov    0x8(%ebp),%eax
  803c25:	83 ec 0c             	sub    $0xc,%esp
  803c28:	50                   	push   %eax
  803c29:	e8 c9 f8 ff ff       	call   8034f7 <to_page_info>
  803c2e:	83 c4 10             	add    $0x10,%esp
  803c31:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c37:	8b 40 08             	mov    0x8(%eax),%eax
  803c3a:	0f b7 c0             	movzwl %ax,%eax
  803c3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803c40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c47:	eb 03                	jmp    803c4c <free_block+0x61>
		listIndex++;
  803c49:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4f:	ba 08 00 00 00       	mov    $0x8,%edx
  803c54:	88 c1                	mov    %al,%cl
  803c56:	d3 e2                	shl    %cl,%edx
  803c58:	89 d0                	mov    %edx,%eax
  803c5a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c5d:	72 ea                	jb     803c49 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803c65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c69:	75 17                	jne    803c82 <free_block+0x97>
  803c6b:	83 ec 04             	sub    $0x4,%esp
  803c6e:	68 8c 4b 80 00       	push   $0x804b8c
  803c73:	68 a2 00 00 00       	push   $0xa2
  803c78:	68 83 4a 80 00       	push   $0x804a83
  803c7d:	e8 0a 03 00 00       	call   803f8c <_panic>
  803c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c85:	c1 e0 04             	shl    $0x4,%eax
  803c88:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c8d:	8b 10                	mov    (%eax),%edx
  803c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c92:	89 10                	mov    %edx,(%eax)
  803c94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c97:	8b 00                	mov    (%eax),%eax
  803c99:	85 c0                	test   %eax,%eax
  803c9b:	74 15                	je     803cb2 <free_block+0xc7>
  803c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca0:	c1 e0 04             	shl    $0x4,%eax
  803ca3:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803ca8:	8b 00                	mov    (%eax),%eax
  803caa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cad:	89 50 04             	mov    %edx,0x4(%eax)
  803cb0:	eb 11                	jmp    803cc3 <free_block+0xd8>
  803cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb5:	c1 e0 04             	shl    $0x4,%eax
  803cb8:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803cbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cc1:	89 02                	mov    %eax,(%edx)
  803cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc6:	c1 e0 04             	shl    $0x4,%eax
  803cc9:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803ccf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd2:	89 02                	mov    %eax,(%edx)
  803cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce1:	c1 e0 04             	shl    $0x4,%eax
  803ce4:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803ce9:	8b 00                	mov    (%eax),%eax
  803ceb:	8d 50 01             	lea    0x1(%eax),%edx
  803cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf1:	c1 e0 04             	shl    $0x4,%eax
  803cf4:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803cf9:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cfe:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803d02:	40                   	inc    %eax
  803d03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d06:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d0d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803d11:	0f b7 c8             	movzwl %ax,%ecx
  803d14:	b8 00 10 00 00       	mov    $0x1000,%eax
  803d19:	ba 00 00 00 00       	mov    $0x0,%edx
  803d1e:	f7 75 e8             	divl   -0x18(%ebp)
  803d21:	39 c1                	cmp    %eax,%ecx
  803d23:	0f 85 ed 01 00 00    	jne    803f16 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2c:	c1 e0 04             	shl    $0x4,%eax
  803d2f:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803d34:	8b 00                	mov    (%eax),%eax
  803d36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d39:	eb 2a                	jmp    803d65 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d3e:	83 ec 0c             	sub    $0xc,%esp
  803d41:	50                   	push   %eax
  803d42:	e8 b0 f7 ff ff       	call   8034f7 <to_page_info>
  803d47:	83 c4 10             	add    $0x10,%esp
  803d4a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d4d:	75 06                	jne    803d55 <free_block+0x16a>
				tmp = b;
  803d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d52:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d58:	c1 e0 04             	shl    $0x4,%eax
  803d5b:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d60:	8b 00                	mov    (%eax),%eax
  803d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803d65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d69:	74 07                	je     803d72 <free_block+0x187>
  803d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d6e:	8b 00                	mov    (%eax),%eax
  803d70:	eb 05                	jmp    803d77 <free_block+0x18c>
  803d72:	b8 00 00 00 00       	mov    $0x0,%eax
  803d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d7a:	c1 e2 04             	shl    $0x4,%edx
  803d7d:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803d83:	89 02                	mov    %eax,(%edx)
  803d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d88:	c1 e0 04             	shl    $0x4,%eax
  803d8b:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803d90:	8b 00                	mov    (%eax),%eax
  803d92:	85 c0                	test   %eax,%eax
  803d94:	75 a5                	jne    803d3b <free_block+0x150>
  803d96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d9a:	75 9f                	jne    803d3b <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9f:	c1 e0 04             	shl    $0x4,%eax
  803da2:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803da7:	8b 00                	mov    (%eax),%eax
  803da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803dac:	e9 cc 00 00 00       	jmp    803e7d <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db4:	8b 00                	mov    (%eax),%eax
  803db6:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbc:	83 ec 0c             	sub    $0xc,%esp
  803dbf:	50                   	push   %eax
  803dc0:	e8 32 f7 ff ff       	call   8034f7 <to_page_info>
  803dc5:	83 c4 10             	add    $0x10,%esp
  803dc8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803dcb:	0f 85 a6 00 00 00    	jne    803e77 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803dd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803dd5:	75 17                	jne    803dee <free_block+0x203>
  803dd7:	83 ec 04             	sub    $0x4,%esp
  803dda:	68 1d 4b 80 00       	push   $0x804b1d
  803ddf:	68 b5 00 00 00       	push   $0xb5
  803de4:	68 83 4a 80 00       	push   $0x804a83
  803de9:	e8 9e 01 00 00       	call   803f8c <_panic>
  803dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df1:	8b 00                	mov    (%eax),%eax
  803df3:	85 c0                	test   %eax,%eax
  803df5:	74 10                	je     803e07 <free_block+0x21c>
  803df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfa:	8b 00                	mov    (%eax),%eax
  803dfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dff:	8b 52 04             	mov    0x4(%edx),%edx
  803e02:	89 50 04             	mov    %edx,0x4(%eax)
  803e05:	eb 14                	jmp    803e1b <free_block+0x230>
  803e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e0a:	8b 40 04             	mov    0x4(%eax),%eax
  803e0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e10:	c1 e2 04             	shl    $0x4,%edx
  803e13:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803e19:	89 02                	mov    %eax,(%edx)
  803e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1e:	8b 40 04             	mov    0x4(%eax),%eax
  803e21:	85 c0                	test   %eax,%eax
  803e23:	74 0f                	je     803e34 <free_block+0x249>
  803e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e28:	8b 40 04             	mov    0x4(%eax),%eax
  803e2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e2e:	8b 12                	mov    (%edx),%edx
  803e30:	89 10                	mov    %edx,(%eax)
  803e32:	eb 13                	jmp    803e47 <free_block+0x25c>
  803e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e37:	8b 00                	mov    (%eax),%eax
  803e39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e3c:	c1 e2 04             	shl    $0x4,%edx
  803e3f:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803e45:	89 02                	mov    %eax,(%edx)
  803e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5d:	c1 e0 04             	shl    $0x4,%eax
  803e60:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e65:	8b 00                	mov    (%eax),%eax
  803e67:	8d 50 ff             	lea    -0x1(%eax),%edx
  803e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e6d:	c1 e0 04             	shl    $0x4,%eax
  803e70:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803e75:	89 10                	mov    %edx,(%eax)
			b = next;
  803e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803e7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e81:	0f 85 2a ff ff ff    	jne    803db1 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e8a:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e93:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803e99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e9d:	75 17                	jne    803eb6 <free_block+0x2cb>
  803e9f:	83 ec 04             	sub    $0x4,%esp
  803ea2:	68 8c 4b 80 00       	push   $0x804b8c
  803ea7:	68 bc 00 00 00       	push   $0xbc
  803eac:	68 83 4a 80 00       	push   $0x804a83
  803eb1:	e8 d6 00 00 00       	call   803f8c <_panic>
  803eb6:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803ebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ebf:	89 10                	mov    %edx,(%eax)
  803ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ec4:	8b 00                	mov    (%eax),%eax
  803ec6:	85 c0                	test   %eax,%eax
  803ec8:	74 0d                	je     803ed7 <free_block+0x2ec>
  803eca:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803ecf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ed2:	89 50 04             	mov    %edx,0x4(%eax)
  803ed5:	eb 08                	jmp    803edf <free_block+0x2f4>
  803ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eda:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ee2:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ef1:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803ef6:	40                   	inc    %eax
  803ef7:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803efc:	83 ec 0c             	sub    $0xc,%esp
  803eff:	ff 75 ec             	pushl  -0x14(%ebp)
  803f02:	e8 7e f5 ff ff       	call   803485 <to_page_va>
  803f07:	83 c4 10             	add    $0x10,%esp
  803f0a:	83 ec 0c             	sub    $0xc,%esp
  803f0d:	50                   	push   %eax
  803f0e:	e8 fe d7 ff ff       	call   801711 <return_page>
  803f13:	83 c4 10             	add    $0x10,%esp
	}
}
  803f16:	90                   	nop
  803f17:	c9                   	leave  
  803f18:	c3                   	ret    

00803f19 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803f19:	55                   	push   %ebp
  803f1a:	89 e5                	mov    %esp,%ebp
  803f1c:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803f1f:	83 ec 04             	sub    $0x4,%esp
  803f22:	68 e8 4b 80 00       	push   $0x804be8
  803f27:	6a 07                	push   $0x7
  803f29:	68 17 4c 80 00       	push   $0x804c17
  803f2e:	e8 59 00 00 00       	call   803f8c <_panic>

00803f33 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803f33:	55                   	push   %ebp
  803f34:	89 e5                	mov    %esp,%ebp
  803f36:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803f39:	83 ec 04             	sub    $0x4,%esp
  803f3c:	68 28 4c 80 00       	push   $0x804c28
  803f41:	6a 0b                	push   $0xb
  803f43:	68 17 4c 80 00       	push   $0x804c17
  803f48:	e8 3f 00 00 00       	call   803f8c <_panic>

00803f4d <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803f4d:	55                   	push   %ebp
  803f4e:	89 e5                	mov    %esp,%ebp
  803f50:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803f53:	83 ec 04             	sub    $0x4,%esp
  803f56:	68 54 4c 80 00       	push   $0x804c54
  803f5b:	6a 10                	push   $0x10
  803f5d:	68 17 4c 80 00       	push   $0x804c17
  803f62:	e8 25 00 00 00       	call   803f8c <_panic>

00803f67 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803f67:	55                   	push   %ebp
  803f68:	89 e5                	mov    %esp,%ebp
  803f6a:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803f6d:	83 ec 04             	sub    $0x4,%esp
  803f70:	68 84 4c 80 00       	push   $0x804c84
  803f75:	6a 15                	push   $0x15
  803f77:	68 17 4c 80 00       	push   $0x804c17
  803f7c:	e8 0b 00 00 00       	call   803f8c <_panic>

00803f81 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803f81:	55                   	push   %ebp
  803f82:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803f84:	8b 45 08             	mov    0x8(%ebp),%eax
  803f87:	8b 40 10             	mov    0x10(%eax),%eax
}
  803f8a:	5d                   	pop    %ebp
  803f8b:	c3                   	ret    

00803f8c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803f8c:	55                   	push   %ebp
  803f8d:	89 e5                	mov    %esp,%ebp
  803f8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803f92:	8d 45 10             	lea    0x10(%ebp),%eax
  803f95:	83 c0 04             	add    $0x4,%eax
  803f98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803f9b:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803fa0:	85 c0                	test   %eax,%eax
  803fa2:	74 16                	je     803fba <_panic+0x2e>
		cprintf("%s: ", argv0);
  803fa4:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803fa9:	83 ec 08             	sub    $0x8,%esp
  803fac:	50                   	push   %eax
  803fad:	68 b4 4c 80 00       	push   $0x804cb4
  803fb2:	e8 d8 c7 ff ff       	call   80078f <cprintf>
  803fb7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803fba:	a1 04 50 80 00       	mov    0x805004,%eax
  803fbf:	83 ec 0c             	sub    $0xc,%esp
  803fc2:	ff 75 0c             	pushl  0xc(%ebp)
  803fc5:	ff 75 08             	pushl  0x8(%ebp)
  803fc8:	50                   	push   %eax
  803fc9:	68 bc 4c 80 00       	push   $0x804cbc
  803fce:	6a 74                	push   $0x74
  803fd0:	e8 e7 c7 ff ff       	call   8007bc <cprintf_colored>
  803fd5:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803fd8:	8b 45 10             	mov    0x10(%ebp),%eax
  803fdb:	83 ec 08             	sub    $0x8,%esp
  803fde:	ff 75 f4             	pushl  -0xc(%ebp)
  803fe1:	50                   	push   %eax
  803fe2:	e8 39 c7 ff ff       	call   800720 <vcprintf>
  803fe7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803fea:	83 ec 08             	sub    $0x8,%esp
  803fed:	6a 00                	push   $0x0
  803fef:	68 e4 4c 80 00       	push   $0x804ce4
  803ff4:	e8 27 c7 ff ff       	call   800720 <vcprintf>
  803ff9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803ffc:	e8 a0 c6 ff ff       	call   8006a1 <exit>

	// should not return here
	while (1) ;
  804001:	eb fe                	jmp    804001 <_panic+0x75>

00804003 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  804003:	55                   	push   %ebp
  804004:	89 e5                	mov    %esp,%ebp
  804006:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  804009:	a1 20 50 80 00       	mov    0x805020,%eax
  80400e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  804014:	8b 45 0c             	mov    0xc(%ebp),%eax
  804017:	39 c2                	cmp    %eax,%edx
  804019:	74 14                	je     80402f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80401b:	83 ec 04             	sub    $0x4,%esp
  80401e:	68 e8 4c 80 00       	push   $0x804ce8
  804023:	6a 26                	push   $0x26
  804025:	68 34 4d 80 00       	push   $0x804d34
  80402a:	e8 5d ff ff ff       	call   803f8c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80402f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  804036:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80403d:	e9 c5 00 00 00       	jmp    804107 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  804042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804045:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80404c:	8b 45 08             	mov    0x8(%ebp),%eax
  80404f:	01 d0                	add    %edx,%eax
  804051:	8b 00                	mov    (%eax),%eax
  804053:	85 c0                	test   %eax,%eax
  804055:	75 08                	jne    80405f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  804057:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80405a:	e9 a5 00 00 00       	jmp    804104 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80405f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804066:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80406d:	eb 69                	jmp    8040d8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80406f:	a1 20 50 80 00       	mov    0x805020,%eax
  804074:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80407a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80407d:	89 d0                	mov    %edx,%eax
  80407f:	01 c0                	add    %eax,%eax
  804081:	01 d0                	add    %edx,%eax
  804083:	c1 e0 03             	shl    $0x3,%eax
  804086:	01 c8                	add    %ecx,%eax
  804088:	8a 40 04             	mov    0x4(%eax),%al
  80408b:	84 c0                	test   %al,%al
  80408d:	75 46                	jne    8040d5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80408f:	a1 20 50 80 00       	mov    0x805020,%eax
  804094:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80409a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80409d:	89 d0                	mov    %edx,%eax
  80409f:	01 c0                	add    %eax,%eax
  8040a1:	01 d0                	add    %edx,%eax
  8040a3:	c1 e0 03             	shl    $0x3,%eax
  8040a6:	01 c8                	add    %ecx,%eax
  8040a8:	8b 00                	mov    (%eax),%eax
  8040aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8040ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8040b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8040b5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8040b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8040c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8040c4:	01 c8                	add    %ecx,%eax
  8040c6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8040c8:	39 c2                	cmp    %eax,%edx
  8040ca:	75 09                	jne    8040d5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8040cc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8040d3:	eb 15                	jmp    8040ea <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8040d5:	ff 45 e8             	incl   -0x18(%ebp)
  8040d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8040dd:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8040e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8040e6:	39 c2                	cmp    %eax,%edx
  8040e8:	77 85                	ja     80406f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8040ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8040ee:	75 14                	jne    804104 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8040f0:	83 ec 04             	sub    $0x4,%esp
  8040f3:	68 40 4d 80 00       	push   $0x804d40
  8040f8:	6a 3a                	push   $0x3a
  8040fa:	68 34 4d 80 00       	push   $0x804d34
  8040ff:	e8 88 fe ff ff       	call   803f8c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  804104:	ff 45 f0             	incl   -0x10(%ebp)
  804107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80410a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80410d:	0f 8c 2f ff ff ff    	jl     804042 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  804113:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80411a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  804121:	eb 26                	jmp    804149 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  804123:	a1 20 50 80 00       	mov    0x805020,%eax
  804128:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80412e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804131:	89 d0                	mov    %edx,%eax
  804133:	01 c0                	add    %eax,%eax
  804135:	01 d0                	add    %edx,%eax
  804137:	c1 e0 03             	shl    $0x3,%eax
  80413a:	01 c8                	add    %ecx,%eax
  80413c:	8a 40 04             	mov    0x4(%eax),%al
  80413f:	3c 01                	cmp    $0x1,%al
  804141:	75 03                	jne    804146 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  804143:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804146:	ff 45 e0             	incl   -0x20(%ebp)
  804149:	a1 20 50 80 00       	mov    0x805020,%eax
  80414e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  804154:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804157:	39 c2                	cmp    %eax,%edx
  804159:	77 c8                	ja     804123 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80415b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80415e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  804161:	74 14                	je     804177 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  804163:	83 ec 04             	sub    $0x4,%esp
  804166:	68 94 4d 80 00       	push   $0x804d94
  80416b:	6a 44                	push   $0x44
  80416d:	68 34 4d 80 00       	push   $0x804d34
  804172:	e8 15 fe ff ff       	call   803f8c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  804177:	90                   	nop
  804178:	c9                   	leave  
  804179:	c3                   	ret    
  80417a:	66 90                	xchg   %ax,%ax

0080417c <__udivdi3>:
  80417c:	55                   	push   %ebp
  80417d:	57                   	push   %edi
  80417e:	56                   	push   %esi
  80417f:	53                   	push   %ebx
  804180:	83 ec 1c             	sub    $0x1c,%esp
  804183:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804187:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80418b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80418f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804193:	89 ca                	mov    %ecx,%edx
  804195:	89 f8                	mov    %edi,%eax
  804197:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80419b:	85 f6                	test   %esi,%esi
  80419d:	75 2d                	jne    8041cc <__udivdi3+0x50>
  80419f:	39 cf                	cmp    %ecx,%edi
  8041a1:	77 65                	ja     804208 <__udivdi3+0x8c>
  8041a3:	89 fd                	mov    %edi,%ebp
  8041a5:	85 ff                	test   %edi,%edi
  8041a7:	75 0b                	jne    8041b4 <__udivdi3+0x38>
  8041a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8041ae:	31 d2                	xor    %edx,%edx
  8041b0:	f7 f7                	div    %edi
  8041b2:	89 c5                	mov    %eax,%ebp
  8041b4:	31 d2                	xor    %edx,%edx
  8041b6:	89 c8                	mov    %ecx,%eax
  8041b8:	f7 f5                	div    %ebp
  8041ba:	89 c1                	mov    %eax,%ecx
  8041bc:	89 d8                	mov    %ebx,%eax
  8041be:	f7 f5                	div    %ebp
  8041c0:	89 cf                	mov    %ecx,%edi
  8041c2:	89 fa                	mov    %edi,%edx
  8041c4:	83 c4 1c             	add    $0x1c,%esp
  8041c7:	5b                   	pop    %ebx
  8041c8:	5e                   	pop    %esi
  8041c9:	5f                   	pop    %edi
  8041ca:	5d                   	pop    %ebp
  8041cb:	c3                   	ret    
  8041cc:	39 ce                	cmp    %ecx,%esi
  8041ce:	77 28                	ja     8041f8 <__udivdi3+0x7c>
  8041d0:	0f bd fe             	bsr    %esi,%edi
  8041d3:	83 f7 1f             	xor    $0x1f,%edi
  8041d6:	75 40                	jne    804218 <__udivdi3+0x9c>
  8041d8:	39 ce                	cmp    %ecx,%esi
  8041da:	72 0a                	jb     8041e6 <__udivdi3+0x6a>
  8041dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8041e0:	0f 87 9e 00 00 00    	ja     804284 <__udivdi3+0x108>
  8041e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8041eb:	89 fa                	mov    %edi,%edx
  8041ed:	83 c4 1c             	add    $0x1c,%esp
  8041f0:	5b                   	pop    %ebx
  8041f1:	5e                   	pop    %esi
  8041f2:	5f                   	pop    %edi
  8041f3:	5d                   	pop    %ebp
  8041f4:	c3                   	ret    
  8041f5:	8d 76 00             	lea    0x0(%esi),%esi
  8041f8:	31 ff                	xor    %edi,%edi
  8041fa:	31 c0                	xor    %eax,%eax
  8041fc:	89 fa                	mov    %edi,%edx
  8041fe:	83 c4 1c             	add    $0x1c,%esp
  804201:	5b                   	pop    %ebx
  804202:	5e                   	pop    %esi
  804203:	5f                   	pop    %edi
  804204:	5d                   	pop    %ebp
  804205:	c3                   	ret    
  804206:	66 90                	xchg   %ax,%ax
  804208:	89 d8                	mov    %ebx,%eax
  80420a:	f7 f7                	div    %edi
  80420c:	31 ff                	xor    %edi,%edi
  80420e:	89 fa                	mov    %edi,%edx
  804210:	83 c4 1c             	add    $0x1c,%esp
  804213:	5b                   	pop    %ebx
  804214:	5e                   	pop    %esi
  804215:	5f                   	pop    %edi
  804216:	5d                   	pop    %ebp
  804217:	c3                   	ret    
  804218:	bd 20 00 00 00       	mov    $0x20,%ebp
  80421d:	89 eb                	mov    %ebp,%ebx
  80421f:	29 fb                	sub    %edi,%ebx
  804221:	89 f9                	mov    %edi,%ecx
  804223:	d3 e6                	shl    %cl,%esi
  804225:	89 c5                	mov    %eax,%ebp
  804227:	88 d9                	mov    %bl,%cl
  804229:	d3 ed                	shr    %cl,%ebp
  80422b:	89 e9                	mov    %ebp,%ecx
  80422d:	09 f1                	or     %esi,%ecx
  80422f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804233:	89 f9                	mov    %edi,%ecx
  804235:	d3 e0                	shl    %cl,%eax
  804237:	89 c5                	mov    %eax,%ebp
  804239:	89 d6                	mov    %edx,%esi
  80423b:	88 d9                	mov    %bl,%cl
  80423d:	d3 ee                	shr    %cl,%esi
  80423f:	89 f9                	mov    %edi,%ecx
  804241:	d3 e2                	shl    %cl,%edx
  804243:	8b 44 24 08          	mov    0x8(%esp),%eax
  804247:	88 d9                	mov    %bl,%cl
  804249:	d3 e8                	shr    %cl,%eax
  80424b:	09 c2                	or     %eax,%edx
  80424d:	89 d0                	mov    %edx,%eax
  80424f:	89 f2                	mov    %esi,%edx
  804251:	f7 74 24 0c          	divl   0xc(%esp)
  804255:	89 d6                	mov    %edx,%esi
  804257:	89 c3                	mov    %eax,%ebx
  804259:	f7 e5                	mul    %ebp
  80425b:	39 d6                	cmp    %edx,%esi
  80425d:	72 19                	jb     804278 <__udivdi3+0xfc>
  80425f:	74 0b                	je     80426c <__udivdi3+0xf0>
  804261:	89 d8                	mov    %ebx,%eax
  804263:	31 ff                	xor    %edi,%edi
  804265:	e9 58 ff ff ff       	jmp    8041c2 <__udivdi3+0x46>
  80426a:	66 90                	xchg   %ax,%ax
  80426c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804270:	89 f9                	mov    %edi,%ecx
  804272:	d3 e2                	shl    %cl,%edx
  804274:	39 c2                	cmp    %eax,%edx
  804276:	73 e9                	jae    804261 <__udivdi3+0xe5>
  804278:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80427b:	31 ff                	xor    %edi,%edi
  80427d:	e9 40 ff ff ff       	jmp    8041c2 <__udivdi3+0x46>
  804282:	66 90                	xchg   %ax,%ax
  804284:	31 c0                	xor    %eax,%eax
  804286:	e9 37 ff ff ff       	jmp    8041c2 <__udivdi3+0x46>
  80428b:	90                   	nop

0080428c <__umoddi3>:
  80428c:	55                   	push   %ebp
  80428d:	57                   	push   %edi
  80428e:	56                   	push   %esi
  80428f:	53                   	push   %ebx
  804290:	83 ec 1c             	sub    $0x1c,%esp
  804293:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804297:	8b 74 24 34          	mov    0x34(%esp),%esi
  80429b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80429f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8042a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8042a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8042ab:	89 f3                	mov    %esi,%ebx
  8042ad:	89 fa                	mov    %edi,%edx
  8042af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042b3:	89 34 24             	mov    %esi,(%esp)
  8042b6:	85 c0                	test   %eax,%eax
  8042b8:	75 1a                	jne    8042d4 <__umoddi3+0x48>
  8042ba:	39 f7                	cmp    %esi,%edi
  8042bc:	0f 86 a2 00 00 00    	jbe    804364 <__umoddi3+0xd8>
  8042c2:	89 c8                	mov    %ecx,%eax
  8042c4:	89 f2                	mov    %esi,%edx
  8042c6:	f7 f7                	div    %edi
  8042c8:	89 d0                	mov    %edx,%eax
  8042ca:	31 d2                	xor    %edx,%edx
  8042cc:	83 c4 1c             	add    $0x1c,%esp
  8042cf:	5b                   	pop    %ebx
  8042d0:	5e                   	pop    %esi
  8042d1:	5f                   	pop    %edi
  8042d2:	5d                   	pop    %ebp
  8042d3:	c3                   	ret    
  8042d4:	39 f0                	cmp    %esi,%eax
  8042d6:	0f 87 ac 00 00 00    	ja     804388 <__umoddi3+0xfc>
  8042dc:	0f bd e8             	bsr    %eax,%ebp
  8042df:	83 f5 1f             	xor    $0x1f,%ebp
  8042e2:	0f 84 ac 00 00 00    	je     804394 <__umoddi3+0x108>
  8042e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8042ed:	29 ef                	sub    %ebp,%edi
  8042ef:	89 fe                	mov    %edi,%esi
  8042f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042f5:	89 e9                	mov    %ebp,%ecx
  8042f7:	d3 e0                	shl    %cl,%eax
  8042f9:	89 d7                	mov    %edx,%edi
  8042fb:	89 f1                	mov    %esi,%ecx
  8042fd:	d3 ef                	shr    %cl,%edi
  8042ff:	09 c7                	or     %eax,%edi
  804301:	89 e9                	mov    %ebp,%ecx
  804303:	d3 e2                	shl    %cl,%edx
  804305:	89 14 24             	mov    %edx,(%esp)
  804308:	89 d8                	mov    %ebx,%eax
  80430a:	d3 e0                	shl    %cl,%eax
  80430c:	89 c2                	mov    %eax,%edx
  80430e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804312:	d3 e0                	shl    %cl,%eax
  804314:	89 44 24 04          	mov    %eax,0x4(%esp)
  804318:	8b 44 24 08          	mov    0x8(%esp),%eax
  80431c:	89 f1                	mov    %esi,%ecx
  80431e:	d3 e8                	shr    %cl,%eax
  804320:	09 d0                	or     %edx,%eax
  804322:	d3 eb                	shr    %cl,%ebx
  804324:	89 da                	mov    %ebx,%edx
  804326:	f7 f7                	div    %edi
  804328:	89 d3                	mov    %edx,%ebx
  80432a:	f7 24 24             	mull   (%esp)
  80432d:	89 c6                	mov    %eax,%esi
  80432f:	89 d1                	mov    %edx,%ecx
  804331:	39 d3                	cmp    %edx,%ebx
  804333:	0f 82 87 00 00 00    	jb     8043c0 <__umoddi3+0x134>
  804339:	0f 84 91 00 00 00    	je     8043d0 <__umoddi3+0x144>
  80433f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804343:	29 f2                	sub    %esi,%edx
  804345:	19 cb                	sbb    %ecx,%ebx
  804347:	89 d8                	mov    %ebx,%eax
  804349:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80434d:	d3 e0                	shl    %cl,%eax
  80434f:	89 e9                	mov    %ebp,%ecx
  804351:	d3 ea                	shr    %cl,%edx
  804353:	09 d0                	or     %edx,%eax
  804355:	89 e9                	mov    %ebp,%ecx
  804357:	d3 eb                	shr    %cl,%ebx
  804359:	89 da                	mov    %ebx,%edx
  80435b:	83 c4 1c             	add    $0x1c,%esp
  80435e:	5b                   	pop    %ebx
  80435f:	5e                   	pop    %esi
  804360:	5f                   	pop    %edi
  804361:	5d                   	pop    %ebp
  804362:	c3                   	ret    
  804363:	90                   	nop
  804364:	89 fd                	mov    %edi,%ebp
  804366:	85 ff                	test   %edi,%edi
  804368:	75 0b                	jne    804375 <__umoddi3+0xe9>
  80436a:	b8 01 00 00 00       	mov    $0x1,%eax
  80436f:	31 d2                	xor    %edx,%edx
  804371:	f7 f7                	div    %edi
  804373:	89 c5                	mov    %eax,%ebp
  804375:	89 f0                	mov    %esi,%eax
  804377:	31 d2                	xor    %edx,%edx
  804379:	f7 f5                	div    %ebp
  80437b:	89 c8                	mov    %ecx,%eax
  80437d:	f7 f5                	div    %ebp
  80437f:	89 d0                	mov    %edx,%eax
  804381:	e9 44 ff ff ff       	jmp    8042ca <__umoddi3+0x3e>
  804386:	66 90                	xchg   %ax,%ax
  804388:	89 c8                	mov    %ecx,%eax
  80438a:	89 f2                	mov    %esi,%edx
  80438c:	83 c4 1c             	add    $0x1c,%esp
  80438f:	5b                   	pop    %ebx
  804390:	5e                   	pop    %esi
  804391:	5f                   	pop    %edi
  804392:	5d                   	pop    %ebp
  804393:	c3                   	ret    
  804394:	3b 04 24             	cmp    (%esp),%eax
  804397:	72 06                	jb     80439f <__umoddi3+0x113>
  804399:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80439d:	77 0f                	ja     8043ae <__umoddi3+0x122>
  80439f:	89 f2                	mov    %esi,%edx
  8043a1:	29 f9                	sub    %edi,%ecx
  8043a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8043a7:	89 14 24             	mov    %edx,(%esp)
  8043aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8043b2:	8b 14 24             	mov    (%esp),%edx
  8043b5:	83 c4 1c             	add    $0x1c,%esp
  8043b8:	5b                   	pop    %ebx
  8043b9:	5e                   	pop    %esi
  8043ba:	5f                   	pop    %edi
  8043bb:	5d                   	pop    %ebp
  8043bc:	c3                   	ret    
  8043bd:	8d 76 00             	lea    0x0(%esi),%esi
  8043c0:	2b 04 24             	sub    (%esp),%eax
  8043c3:	19 fa                	sbb    %edi,%edx
  8043c5:	89 d1                	mov    %edx,%ecx
  8043c7:	89 c6                	mov    %eax,%esi
  8043c9:	e9 71 ff ff ff       	jmp    80433f <__umoddi3+0xb3>
  8043ce:	66 90                	xchg   %ax,%ax
  8043d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8043d4:	72 ea                	jb     8043c0 <__umoddi3+0x134>
  8043d6:	89 d9                	mov    %ebx,%ecx
  8043d8:	e9 62 ff ff ff       	jmp    80433f <__umoddi3+0xb3>
