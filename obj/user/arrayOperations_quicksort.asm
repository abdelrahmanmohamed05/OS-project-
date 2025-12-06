
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 b1 03 00 00       	call   8003e7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 4e 30 00 00       	call   803091 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 78 30 00 00       	call   8030c3 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  80004e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 e0 42 80 00       	push   $0x8042e0
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 b9 3d 00 00       	call   803e1b <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 e6 42 80 00       	push   $0x8042e6
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 a2 3d 00 00       	call   803e1b <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 d8             	pushl  -0x28(%ebp)
  800082:	e8 ae 3d 00 00       	call   803e35 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	68 ef 42 80 00       	push   $0x8042ef
  800092:	ff 75 ec             	pushl  -0x14(%ebp)
  800095:	e8 66 20 00 00       	call   802100 <sget>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  8000a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a3:	8b 10                	mov    (%eax),%edx
  8000a5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 02 43 80 00       	push   $0x804302
  8000b0:	52                   	push   %edx
  8000b1:	50                   	push   %eax
  8000b2:	e8 64 3d 00 00       	call   803e1b <get_semaphore>
  8000b7:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int *sharedArray = NULL;
  8000c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 10 43 80 00       	push   $0x804310
  8000d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d3:	e8 28 20 00 00       	call   802100 <sget>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 e0             	mov    %eax,-0x20(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 14 43 80 00       	push   $0x804314
  8000e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e9:	e8 12 20 00 00       	call   802100 <sget>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	c1 e0 02             	shl    $0x2,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 00                	push   $0x0
  800101:	50                   	push   %eax
  800102:	68 1c 43 80 00       	push   $0x80431c
  800107:	e8 9a 1c 00 00       	call   801da6 <smalloc>
  80010c:	83 c4 10             	add    $0x10,%esp
  80010f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800119:	eb 25                	jmp    800140 <_main+0x108>
	{
		sortedArray[i] = sharedArray[i];
  80011b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80011e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800125:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800128:	01 c2                	add    %eax,%edx
  80012a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80012d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800137:	01 c8                	add    %ecx,%eax
  800139:	8b 00                	mov    (%eax),%eax
  80013b:	89 02                	mov    %eax,(%edx)
	/*[4] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80013d:	ff 45 f4             	incl   -0xc(%ebp)
  800140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800143:	8b 00                	mov    (%eax),%eax
  800145:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800148:	7f d1                	jg     80011b <_main+0xe3>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  80014a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014d:	8b 00                	mov    (%eax),%eax
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	50                   	push   %eax
  800153:	ff 75 dc             	pushl  -0x24(%ebp)
  800156:	e8 60 00 00 00       	call   8001bb <QuickSort>
  80015b:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(cons_mutex);
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	ff 75 d0             	pushl  -0x30(%ebp)
  800164:	e8 cc 3c 00 00       	call   803e35 <wait_semaphore>
  800169:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Quick sort is Finished!!!!\n") ;
  80016c:	83 ec 0c             	sub    $0xc,%esp
  80016f:	68 2b 43 80 00       	push   $0x80432b
  800174:	e8 fe 04 00 00       	call   800677 <cprintf>
  800179:	83 c4 10             	add    $0x10,%esp
		cprintf("will notify the master now...\n");
  80017c:	83 ec 0c             	sub    $0xc,%esp
  80017f:	68 48 43 80 00       	push   $0x804348
  800184:	e8 ee 04 00 00       	call   800677 <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp
		cprintf("Quick sort says GOOD BYE :)\n") ;
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	68 67 43 80 00       	push   $0x804367
  800194:	e8 de 04 00 00       	call   800677 <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 d0             	pushl  -0x30(%ebp)
  8001a2:	e8 a8 3c 00 00       	call   803e4f <signal_semaphore>
  8001a7:	83 c4 10             	add    $0x10,%esp

	/*[5] DECLARE FINISHING*/
	signal_semaphore(finished);
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001b0:	e8 9a 3c 00 00       	call   803e4f <signal_semaphore>
  8001b5:	83 c4 10             	add    $0x10,%esp
}
  8001b8:	90                   	nop
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	48                   	dec    %eax
  8001c5:	50                   	push   %eax
  8001c6:	6a 00                	push   $0x0
  8001c8:	ff 75 0c             	pushl  0xc(%ebp)
  8001cb:	ff 75 08             	pushl  0x8(%ebp)
  8001ce:	e8 06 00 00 00       	call   8001d9 <QSort>
  8001d3:	83 c4 10             	add    $0x10,%esp
}
  8001d6:	90                   	nop
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  8001df:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e2:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001e5:	0f 8d 20 01 00 00    	jge    80030b <QSort+0x132>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8001eb:	0f 31                	rdtsc  
  8001ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8001f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001fc:	89 55 e8             	mov    %edx,-0x18(%ebp)
	int pvtIndex = RANDU(startIndex, finalIndex) ;
  8001ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800202:	8b 55 14             	mov    0x14(%ebp),%edx
  800205:	2b 55 10             	sub    0x10(%ebp),%edx
  800208:	89 d1                	mov    %edx,%ecx
  80020a:	ba 00 00 00 00       	mov    $0x0,%edx
  80020f:	f7 f1                	div    %ecx
  800211:	8b 45 10             	mov    0x10(%ebp),%eax
  800214:	01 d0                	add    %edx,%eax
  800216:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800219:	83 ec 04             	sub    $0x4,%esp
  80021c:	ff 75 ec             	pushl  -0x14(%ebp)
  80021f:	ff 75 10             	pushl  0x10(%ebp)
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	e8 e4 00 00 00       	call   80030e <Swap>
  80022a:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80022d:	8b 45 10             	mov    0x10(%ebp),%eax
  800230:	40                   	inc    %eax
  800231:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800234:	8b 45 14             	mov    0x14(%ebp),%eax
  800237:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80023a:	e9 80 00 00 00       	jmp    8002bf <QSort+0xe6>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80023f:	ff 45 f4             	incl   -0xc(%ebp)
  800242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800245:	3b 45 14             	cmp    0x14(%ebp),%eax
  800248:	7f 2b                	jg     800275 <QSort+0x9c>
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800254:	8b 45 08             	mov    0x8(%ebp),%eax
  800257:	01 d0                	add    %edx,%eax
  800259:	8b 10                	mov    (%eax),%edx
  80025b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800265:	8b 45 08             	mov    0x8(%ebp),%eax
  800268:	01 c8                	add    %ecx,%eax
  80026a:	8b 00                	mov    (%eax),%eax
  80026c:	39 c2                	cmp    %eax,%edx
  80026e:	7d cf                	jge    80023f <QSort+0x66>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800270:	eb 03                	jmp    800275 <QSort+0x9c>
  800272:	ff 4d f0             	decl   -0x10(%ebp)
  800275:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800278:	3b 45 10             	cmp    0x10(%ebp),%eax
  80027b:	7e 26                	jle    8002a3 <QSort+0xca>
  80027d:	8b 45 10             	mov    0x10(%ebp),%eax
  800280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800287:	8b 45 08             	mov    0x8(%ebp),%eax
  80028a:	01 d0                	add    %edx,%eax
  80028c:	8b 10                	mov    (%eax),%edx
  80028e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800291:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800298:	8b 45 08             	mov    0x8(%ebp),%eax
  80029b:	01 c8                	add    %ecx,%eax
  80029d:	8b 00                	mov    (%eax),%eax
  80029f:	39 c2                	cmp    %eax,%edx
  8002a1:	7e cf                	jle    800272 <QSort+0x99>

		if (i <= j)
  8002a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002a9:	7f 14                	jg     8002bf <QSort+0xe6>
		{
			Swap(Elements, i, j);
  8002ab:	83 ec 04             	sub    $0x4,%esp
  8002ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8002b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b4:	ff 75 08             	pushl  0x8(%ebp)
  8002b7:	e8 52 00 00 00       	call   80030e <Swap>
  8002bc:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RANDU(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002c5:	0f 8e 77 ff ff ff    	jle    800242 <QSort+0x69>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8002cb:	83 ec 04             	sub    $0x4,%esp
  8002ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8002d1:	ff 75 10             	pushl  0x10(%ebp)
  8002d4:	ff 75 08             	pushl  0x8(%ebp)
  8002d7:	e8 32 00 00 00       	call   80030e <Swap>
  8002dc:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8002df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002e2:	48                   	dec    %eax
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 10             	pushl  0x10(%ebp)
  8002e7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ea:	ff 75 08             	pushl  0x8(%ebp)
  8002ed:	e8 e7 fe ff ff       	call   8001d9 <QSort>
  8002f2:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8002f5:	ff 75 14             	pushl  0x14(%ebp)
  8002f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002fb:	ff 75 0c             	pushl  0xc(%ebp)
  8002fe:	ff 75 08             	pushl  0x8(%ebp)
  800301:	e8 d3 fe ff ff       	call   8001d9 <QSort>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	eb 01                	jmp    80030c <QSort+0x133>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80030b:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  80030c:	c9                   	leave  
  80030d:	c3                   	ret    

0080030e <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800314:	8b 45 0c             	mov    0xc(%ebp),%eax
  800317:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	01 d0                	add    %edx,%eax
  800323:	8b 00                	mov    (%eax),%eax
  800325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800332:	8b 45 08             	mov    0x8(%ebp),%eax
  800335:	01 c2                	add    %eax,%edx
  800337:	8b 45 10             	mov    0x10(%ebp),%eax
  80033a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800341:	8b 45 08             	mov    0x8(%ebp),%eax
  800344:	01 c8                	add    %ecx,%eax
  800346:	8b 00                	mov    (%eax),%eax
  800348:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80034a:	8b 45 10             	mov    0x10(%ebp),%eax
  80034d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800354:	8b 45 08             	mov    0x8(%ebp),%eax
  800357:	01 c2                	add    %eax,%edx
  800359:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80035c:	89 02                	mov    %eax,(%edx)
}
  80035e:	90                   	nop
  80035f:	c9                   	leave  
  800360:	c3                   	ret    

00800361 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800367:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80036e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800375:	eb 42                	jmp    8003b9 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037a:	99                   	cltd   
  80037b:	f7 7d f0             	idivl  -0x10(%ebp)
  80037e:	89 d0                	mov    %edx,%eax
  800380:	85 c0                	test   %eax,%eax
  800382:	75 10                	jne    800394 <PrintElements+0x33>
			cprintf("\n");
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	68 84 43 80 00       	push   $0x804384
  80038c:	e8 e6 02 00 00       	call   800677 <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800397:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	01 d0                	add    %edx,%eax
  8003a3:	8b 00                	mov    (%eax),%eax
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	50                   	push   %eax
  8003a9:	68 86 43 80 00       	push   $0x804386
  8003ae:	e8 c4 02 00 00       	call   800677 <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8003b6:	ff 45 f4             	incl   -0xc(%ebp)
  8003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bc:	48                   	dec    %eax
  8003bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8003c0:	7f b5                	jg     800377 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8003c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cf:	01 d0                	add    %edx,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	83 ec 08             	sub    $0x8,%esp
  8003d6:	50                   	push   %eax
  8003d7:	68 8b 43 80 00       	push   $0x80438b
  8003dc:	e8 96 02 00 00       	call   800677 <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp

}
  8003e4:	90                   	nop
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	57                   	push   %edi
  8003eb:	56                   	push   %esi
  8003ec:	53                   	push   %ebx
  8003ed:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8003f0:	e8 b5 2c 00 00       	call   8030aa <sys_getenvindex>
  8003f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8003f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003fb:	89 d0                	mov    %edx,%eax
  8003fd:	c1 e0 03             	shl    $0x3,%eax
  800400:	01 d0                	add    %edx,%eax
  800402:	c1 e0 02             	shl    $0x2,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040e:	01 d0                	add    %edx,%eax
  800410:	c1 e0 03             	shl    $0x3,%eax
  800413:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800418:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80041d:	a1 20 50 80 00       	mov    0x805020,%eax
  800422:	8a 40 20             	mov    0x20(%eax),%al
  800425:	84 c0                	test   %al,%al
  800427:	74 0d                	je     800436 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800429:	a1 20 50 80 00       	mov    0x805020,%eax
  80042e:	83 c0 20             	add    $0x20,%eax
  800431:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800436:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80043a:	7e 0a                	jle    800446 <libmain+0x5f>
		binaryname = argv[0];
  80043c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	ff 75 0c             	pushl  0xc(%ebp)
  80044c:	ff 75 08             	pushl  0x8(%ebp)
  80044f:	e8 e4 fb ff ff       	call   800038 <_main>
  800454:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800457:	a1 00 50 80 00       	mov    0x805000,%eax
  80045c:	85 c0                	test   %eax,%eax
  80045e:	0f 84 01 01 00 00    	je     800565 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800464:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80046a:	bb 88 44 80 00       	mov    $0x804488,%ebx
  80046f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800474:	89 c7                	mov    %eax,%edi
  800476:	89 de                	mov    %ebx,%esi
  800478:	89 d1                	mov    %edx,%ecx
  80047a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80047c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80047f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800484:	b0 00                	mov    $0x0,%al
  800486:	89 d7                	mov    %edx,%edi
  800488:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80048a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800491:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	50                   	push   %eax
  800498:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80049e:	50                   	push   %eax
  80049f:	e8 3c 2e 00 00       	call   8032e0 <sys_utilities>
  8004a4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8004a7:	e8 85 29 00 00       	call   802e31 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004ac:	83 ec 0c             	sub    $0xc,%esp
  8004af:	68 a8 43 80 00       	push   $0x8043a8
  8004b4:	e8 be 01 00 00       	call   800677 <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8004bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	74 18                	je     8004db <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8004c3:	e8 36 2e 00 00       	call   8032fe <sys_get_optimal_num_faults>
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	50                   	push   %eax
  8004cc:	68 d0 43 80 00       	push   $0x8043d0
  8004d1:	e8 a1 01 00 00       	call   800677 <cprintf>
  8004d6:	83 c4 10             	add    $0x10,%esp
  8004d9:	eb 59                	jmp    800534 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004db:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e0:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8004e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8004eb:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	52                   	push   %edx
  8004f5:	50                   	push   %eax
  8004f6:	68 f4 43 80 00       	push   $0x8043f4
  8004fb:	e8 77 01 00 00       	call   800677 <cprintf>
  800500:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800503:	a1 20 50 80 00       	mov    0x805020,%eax
  800508:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80050e:	a1 20 50 80 00       	mov    0x805020,%eax
  800513:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800519:	a1 20 50 80 00       	mov    0x805020,%eax
  80051e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800524:	51                   	push   %ecx
  800525:	52                   	push   %edx
  800526:	50                   	push   %eax
  800527:	68 1c 44 80 00       	push   $0x80441c
  80052c:	e8 46 01 00 00       	call   800677 <cprintf>
  800531:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800534:	a1 20 50 80 00       	mov    0x805020,%eax
  800539:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	50                   	push   %eax
  800543:	68 74 44 80 00       	push   $0x804474
  800548:	e8 2a 01 00 00       	call   800677 <cprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	68 a8 43 80 00       	push   $0x8043a8
  800558:	e8 1a 01 00 00       	call   800677 <cprintf>
  80055d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800560:	e8 e6 28 00 00       	call   802e4b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800565:	e8 1f 00 00 00       	call   800589 <exit>
}
  80056a:	90                   	nop
  80056b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80056e:	5b                   	pop    %ebx
  80056f:	5e                   	pop    %esi
  800570:	5f                   	pop    %edi
  800571:	5d                   	pop    %ebp
  800572:	c3                   	ret    

00800573 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800573:	55                   	push   %ebp
  800574:	89 e5                	mov    %esp,%ebp
  800576:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800579:	83 ec 0c             	sub    $0xc,%esp
  80057c:	6a 00                	push   $0x0
  80057e:	e8 f3 2a 00 00       	call   803076 <sys_destroy_env>
  800583:	83 c4 10             	add    $0x10,%esp
}
  800586:	90                   	nop
  800587:	c9                   	leave  
  800588:	c3                   	ret    

00800589 <exit>:

void
exit(void)
{
  800589:	55                   	push   %ebp
  80058a:	89 e5                	mov    %esp,%ebp
  80058c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80058f:	e8 48 2b 00 00       	call   8030dc <sys_exit_env>
}
  800594:	90                   	nop
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	53                   	push   %ebx
  80059b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80059e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8005a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a9:	89 0a                	mov    %ecx,(%edx)
  8005ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ae:	88 d1                	mov    %dl,%cl
  8005b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005c1:	75 30                	jne    8005f3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005c3:	8b 15 38 51 83 00    	mov    0x835138,%edx
  8005c9:	a0 64 d0 81 00       	mov    0x81d064,%al
  8005ce:	0f b6 c0             	movzbl %al,%eax
  8005d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d4:	8b 09                	mov    (%ecx),%ecx
  8005d6:	89 cb                	mov    %ecx,%ebx
  8005d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005db:	83 c1 08             	add    $0x8,%ecx
  8005de:	52                   	push   %edx
  8005df:	50                   	push   %eax
  8005e0:	53                   	push   %ebx
  8005e1:	51                   	push   %ecx
  8005e2:	e8 06 28 00 00       	call   802ded <sys_cputs>
  8005e7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f6:	8b 40 04             	mov    0x4(%eax),%eax
  8005f9:	8d 50 01             	lea    0x1(%eax),%edx
  8005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  800602:	90                   	nop
  800603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800606:	c9                   	leave  
  800607:	c3                   	ret    

00800608 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800608:	55                   	push   %ebp
  800609:	89 e5                	mov    %esp,%ebp
  80060b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800611:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800618:	00 00 00 
	b.cnt = 0;
  80061b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800622:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800625:	ff 75 0c             	pushl  0xc(%ebp)
  800628:	ff 75 08             	pushl  0x8(%ebp)
  80062b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800631:	50                   	push   %eax
  800632:	68 97 05 80 00       	push   $0x800597
  800637:	e8 5a 02 00 00       	call   800896 <vprintfmt>
  80063c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80063f:	8b 15 38 51 83 00    	mov    0x835138,%edx
  800645:	a0 64 d0 81 00       	mov    0x81d064,%al
  80064a:	0f b6 c0             	movzbl %al,%eax
  80064d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800653:	52                   	push   %edx
  800654:	50                   	push   %eax
  800655:	51                   	push   %ecx
  800656:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80065c:	83 c0 08             	add    $0x8,%eax
  80065f:	50                   	push   %eax
  800660:	e8 88 27 00 00       	call   802ded <sys_cputs>
  800665:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800668:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
	return b.cnt;
  80066f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800675:	c9                   	leave  
  800676:	c3                   	ret    

00800677 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800677:	55                   	push   %ebp
  800678:	89 e5                	mov    %esp,%ebp
  80067a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80067d:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	va_start(ap, fmt);
  800684:	8d 45 0c             	lea    0xc(%ebp),%eax
  800687:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	ff 75 f4             	pushl  -0xc(%ebp)
  800693:	50                   	push   %eax
  800694:	e8 6f ff ff ff       	call   800608 <vcprintf>
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80069f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006a2:	c9                   	leave  
  8006a3:	c3                   	ret    

008006a4 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006a4:	55                   	push   %ebp
  8006a5:	89 e5                	mov    %esp,%ebp
  8006a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006aa:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	c1 e0 08             	shl    $0x8,%eax
  8006b7:	a3 38 51 83 00       	mov    %eax,0x835138
	va_start(ap, fmt);
  8006bc:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006bf:	83 c0 04             	add    $0x4,%eax
  8006c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ce:	50                   	push   %eax
  8006cf:	e8 34 ff ff ff       	call   800608 <vcprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8006da:	c7 05 38 51 83 00 00 	movl   $0x700,0x835138
  8006e1:	07 00 00 

	return cnt;
  8006e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006ef:	e8 3d 27 00 00       	call   802e31 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006f4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 f4             	pushl  -0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	e8 ff fe ff ff       	call   800608 <vcprintf>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80070f:	e8 37 27 00 00       	call   802e4b <sys_unlock_cons>
	return cnt;
  800714:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800717:	c9                   	leave  
  800718:	c3                   	ret    

00800719 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	53                   	push   %ebx
  80071d:	83 ec 14             	sub    $0x14,%esp
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80072c:	8b 45 18             	mov    0x18(%ebp),%eax
  80072f:	ba 00 00 00 00       	mov    $0x0,%edx
  800734:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800737:	77 55                	ja     80078e <printnum+0x75>
  800739:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80073c:	72 05                	jb     800743 <printnum+0x2a>
  80073e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800741:	77 4b                	ja     80078e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800743:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800746:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800749:	8b 45 18             	mov    0x18(%ebp),%eax
  80074c:	ba 00 00 00 00       	mov    $0x0,%edx
  800751:	52                   	push   %edx
  800752:	50                   	push   %eax
  800753:	ff 75 f4             	pushl  -0xc(%ebp)
  800756:	ff 75 f0             	pushl  -0x10(%ebp)
  800759:	e8 06 39 00 00       	call   804064 <__udivdi3>
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	83 ec 04             	sub    $0x4,%esp
  800764:	ff 75 20             	pushl  0x20(%ebp)
  800767:	53                   	push   %ebx
  800768:	ff 75 18             	pushl  0x18(%ebp)
  80076b:	52                   	push   %edx
  80076c:	50                   	push   %eax
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	ff 75 08             	pushl  0x8(%ebp)
  800773:	e8 a1 ff ff ff       	call   800719 <printnum>
  800778:	83 c4 20             	add    $0x20,%esp
  80077b:	eb 1a                	jmp    800797 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 0c             	pushl  0xc(%ebp)
  800783:	ff 75 20             	pushl  0x20(%ebp)
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	ff d0                	call   *%eax
  80078b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80078e:	ff 4d 1c             	decl   0x1c(%ebp)
  800791:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800795:	7f e6                	jg     80077d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800797:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80079a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80079f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a5:	53                   	push   %ebx
  8007a6:	51                   	push   %ecx
  8007a7:	52                   	push   %edx
  8007a8:	50                   	push   %eax
  8007a9:	e8 c6 39 00 00       	call   804174 <__umoddi3>
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	05 14 47 80 00       	add    $0x804714,%eax
  8007b6:	8a 00                	mov    (%eax),%al
  8007b8:	0f be c0             	movsbl %al,%eax
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	50                   	push   %eax
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	ff d0                	call   *%eax
  8007c7:	83 c4 10             	add    $0x10,%esp
}
  8007ca:	90                   	nop
  8007cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    

008007d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d7:	7e 1c                	jle    8007f5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	8d 50 08             	lea    0x8(%eax),%edx
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	89 10                	mov    %edx,(%eax)
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	83 e8 08             	sub    $0x8,%eax
  8007ee:	8b 50 04             	mov    0x4(%eax),%edx
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	eb 40                	jmp    800835 <getuint+0x65>
	else if (lflag)
  8007f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f9:	74 1e                	je     800819 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	8d 50 04             	lea    0x4(%eax),%edx
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	89 10                	mov    %edx,(%eax)
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	83 e8 04             	sub    $0x4,%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	ba 00 00 00 00       	mov    $0x0,%edx
  800817:	eb 1c                	jmp    800835 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	8d 50 04             	lea    0x4(%eax),%edx
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	89 10                	mov    %edx,(%eax)
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	83 e8 04             	sub    $0x4,%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800835:	5d                   	pop    %ebp
  800836:	c3                   	ret    

00800837 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80083a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80083e:	7e 1c                	jle    80085c <getint+0x25>
		return va_arg(*ap, long long);
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	8d 50 08             	lea    0x8(%eax),%edx
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	89 10                	mov    %edx,(%eax)
  80084d:	8b 45 08             	mov    0x8(%ebp),%eax
  800850:	8b 00                	mov    (%eax),%eax
  800852:	83 e8 08             	sub    $0x8,%eax
  800855:	8b 50 04             	mov    0x4(%eax),%edx
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	eb 38                	jmp    800894 <getint+0x5d>
	else if (lflag)
  80085c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800860:	74 1a                	je     80087c <getint+0x45>
		return va_arg(*ap, long);
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	8b 00                	mov    (%eax),%eax
  800867:	8d 50 04             	lea    0x4(%eax),%edx
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	89 10                	mov    %edx,(%eax)
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	83 e8 04             	sub    $0x4,%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	99                   	cltd   
  80087a:	eb 18                	jmp    800894 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	99                   	cltd   
}
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	56                   	push   %esi
  80089a:	53                   	push   %ebx
  80089b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80089e:	eb 17                	jmp    8008b7 <vprintfmt+0x21>
			if (ch == '\0')
  8008a0:	85 db                	test   %ebx,%ebx
  8008a2:	0f 84 c1 03 00 00    	je     800c69 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	53                   	push   %ebx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	ff d0                	call   *%eax
  8008b4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ba:	8d 50 01             	lea    0x1(%eax),%edx
  8008bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8008c0:	8a 00                	mov    (%eax),%al
  8008c2:	0f b6 d8             	movzbl %al,%ebx
  8008c5:	83 fb 25             	cmp    $0x25,%ebx
  8008c8:	75 d6                	jne    8008a0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ca:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ce:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008d5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ed:	8d 50 01             	lea    0x1(%eax),%edx
  8008f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8008f3:	8a 00                	mov    (%eax),%al
  8008f5:	0f b6 d8             	movzbl %al,%ebx
  8008f8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008fb:	83 f8 5b             	cmp    $0x5b,%eax
  8008fe:	0f 87 3d 03 00 00    	ja     800c41 <vprintfmt+0x3ab>
  800904:	8b 04 85 38 47 80 00 	mov    0x804738(,%eax,4),%eax
  80090b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80090d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800911:	eb d7                	jmp    8008ea <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800913:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800917:	eb d1                	jmp    8008ea <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800919:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800920:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800923:	89 d0                	mov    %edx,%eax
  800925:	c1 e0 02             	shl    $0x2,%eax
  800928:	01 d0                	add    %edx,%eax
  80092a:	01 c0                	add    %eax,%eax
  80092c:	01 d8                	add    %ebx,%eax
  80092e:	83 e8 30             	sub    $0x30,%eax
  800931:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800934:	8b 45 10             	mov    0x10(%ebp),%eax
  800937:	8a 00                	mov    (%eax),%al
  800939:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80093c:	83 fb 2f             	cmp    $0x2f,%ebx
  80093f:	7e 3e                	jle    80097f <vprintfmt+0xe9>
  800941:	83 fb 39             	cmp    $0x39,%ebx
  800944:	7f 39                	jg     80097f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800946:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800949:	eb d5                	jmp    800920 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	83 c0 04             	add    $0x4,%eax
  800951:	89 45 14             	mov    %eax,0x14(%ebp)
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 e8 04             	sub    $0x4,%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80095f:	eb 1f                	jmp    800980 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800961:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800965:	79 83                	jns    8008ea <vprintfmt+0x54>
				width = 0;
  800967:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80096e:	e9 77 ff ff ff       	jmp    8008ea <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800973:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80097a:	e9 6b ff ff ff       	jmp    8008ea <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80097f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800980:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800984:	0f 89 60 ff ff ff    	jns    8008ea <vprintfmt+0x54>
				width = precision, precision = -1;
  80098a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80098d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800990:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800997:	e9 4e ff ff ff       	jmp    8008ea <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80099c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80099f:	e9 46 ff ff ff       	jmp    8008ea <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b0:	83 e8 04             	sub    $0x4,%eax
  8009b3:	8b 00                	mov    (%eax),%eax
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	50                   	push   %eax
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
			break;
  8009c4:	e9 9b 02 00 00       	jmp    800c64 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cc:	83 c0 04             	add    $0x4,%eax
  8009cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d5:	83 e8 04             	sub    $0x4,%eax
  8009d8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009da:	85 db                	test   %ebx,%ebx
  8009dc:	79 02                	jns    8009e0 <vprintfmt+0x14a>
				err = -err;
  8009de:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009e0:	83 fb 64             	cmp    $0x64,%ebx
  8009e3:	7f 0b                	jg     8009f0 <vprintfmt+0x15a>
  8009e5:	8b 34 9d 80 45 80 00 	mov    0x804580(,%ebx,4),%esi
  8009ec:	85 f6                	test   %esi,%esi
  8009ee:	75 19                	jne    800a09 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009f0:	53                   	push   %ebx
  8009f1:	68 25 47 80 00       	push   $0x804725
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	ff 75 08             	pushl  0x8(%ebp)
  8009fc:	e8 70 02 00 00       	call   800c71 <printfmt>
  800a01:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a04:	e9 5b 02 00 00       	jmp    800c64 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a09:	56                   	push   %esi
  800a0a:	68 2e 47 80 00       	push   $0x80472e
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	ff 75 08             	pushl  0x8(%ebp)
  800a15:	e8 57 02 00 00       	call   800c71 <printfmt>
  800a1a:	83 c4 10             	add    $0x10,%esp
			break;
  800a1d:	e9 42 02 00 00       	jmp    800c64 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 c0 04             	add    $0x4,%eax
  800a28:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	83 e8 04             	sub    $0x4,%eax
  800a31:	8b 30                	mov    (%eax),%esi
  800a33:	85 f6                	test   %esi,%esi
  800a35:	75 05                	jne    800a3c <vprintfmt+0x1a6>
				p = "(null)";
  800a37:	be 31 47 80 00       	mov    $0x804731,%esi
			if (width > 0 && padc != '-')
  800a3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a40:	7e 6d                	jle    800aaf <vprintfmt+0x219>
  800a42:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a46:	74 67                	je     800aaf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	50                   	push   %eax
  800a4f:	56                   	push   %esi
  800a50:	e8 1e 03 00 00       	call   800d73 <strnlen>
  800a55:	83 c4 10             	add    $0x10,%esp
  800a58:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a5b:	eb 16                	jmp    800a73 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a5d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a61:	83 ec 08             	sub    $0x8,%esp
  800a64:	ff 75 0c             	pushl  0xc(%ebp)
  800a67:	50                   	push   %eax
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	ff d0                	call   *%eax
  800a6d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a70:	ff 4d e4             	decl   -0x1c(%ebp)
  800a73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a77:	7f e4                	jg     800a5d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a79:	eb 34                	jmp    800aaf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a7f:	74 1c                	je     800a9d <vprintfmt+0x207>
  800a81:	83 fb 1f             	cmp    $0x1f,%ebx
  800a84:	7e 05                	jle    800a8b <vprintfmt+0x1f5>
  800a86:	83 fb 7e             	cmp    $0x7e,%ebx
  800a89:	7e 12                	jle    800a9d <vprintfmt+0x207>
					putch('?', putdat);
  800a8b:	83 ec 08             	sub    $0x8,%esp
  800a8e:	ff 75 0c             	pushl  0xc(%ebp)
  800a91:	6a 3f                	push   $0x3f
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	ff d0                	call   *%eax
  800a98:	83 c4 10             	add    $0x10,%esp
  800a9b:	eb 0f                	jmp    800aac <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	53                   	push   %ebx
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aac:	ff 4d e4             	decl   -0x1c(%ebp)
  800aaf:	89 f0                	mov    %esi,%eax
  800ab1:	8d 70 01             	lea    0x1(%eax),%esi
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	0f be d8             	movsbl %al,%ebx
  800ab9:	85 db                	test   %ebx,%ebx
  800abb:	74 24                	je     800ae1 <vprintfmt+0x24b>
  800abd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac1:	78 b8                	js     800a7b <vprintfmt+0x1e5>
  800ac3:	ff 4d e0             	decl   -0x20(%ebp)
  800ac6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aca:	79 af                	jns    800a7b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800acc:	eb 13                	jmp    800ae1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	6a 20                	push   $0x20
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	ff d0                	call   *%eax
  800adb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ade:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae5:	7f e7                	jg     800ace <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ae7:	e9 78 01 00 00       	jmp    800c64 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 e8             	pushl  -0x18(%ebp)
  800af2:	8d 45 14             	lea    0x14(%ebp),%eax
  800af5:	50                   	push   %eax
  800af6:	e8 3c fd ff ff       	call   800837 <getint>
  800afb:	83 c4 10             	add    $0x10,%esp
  800afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b01:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b0a:	85 d2                	test   %edx,%edx
  800b0c:	79 23                	jns    800b31 <vprintfmt+0x29b>
				putch('-', putdat);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	6a 2d                	push   $0x2d
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	ff d0                	call   *%eax
  800b1b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b24:	f7 d8                	neg    %eax
  800b26:	83 d2 00             	adc    $0x0,%edx
  800b29:	f7 da                	neg    %edx
  800b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b31:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b38:	e9 bc 00 00 00       	jmp    800bf9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b3d:	83 ec 08             	sub    $0x8,%esp
  800b40:	ff 75 e8             	pushl  -0x18(%ebp)
  800b43:	8d 45 14             	lea    0x14(%ebp),%eax
  800b46:	50                   	push   %eax
  800b47:	e8 84 fc ff ff       	call   8007d0 <getuint>
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b55:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b5c:	e9 98 00 00 00       	jmp    800bf9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	ff 75 0c             	pushl  0xc(%ebp)
  800b67:	6a 58                	push   $0x58
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	ff d0                	call   *%eax
  800b6e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b71:	83 ec 08             	sub    $0x8,%esp
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	6a 58                	push   $0x58
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	ff d0                	call   *%eax
  800b7e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 58                	push   $0x58
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			break;
  800b91:	e9 ce 00 00 00       	jmp    800c64 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 0c             	pushl  0xc(%ebp)
  800b9c:	6a 30                	push   $0x30
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	6a 78                	push   $0x78
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	ff d0                	call   *%eax
  800bb3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	83 c0 04             	add    $0x4,%eax
  800bbc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc2:	83 e8 04             	sub    $0x4,%eax
  800bc5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bd1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bd8:	eb 1f                	jmp    800bf9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 e8             	pushl  -0x18(%ebp)
  800be0:	8d 45 14             	lea    0x14(%ebp),%eax
  800be3:	50                   	push   %eax
  800be4:	e8 e7 fb ff ff       	call   8007d0 <getuint>
  800be9:	83 c4 10             	add    $0x10,%esp
  800bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c00:	83 ec 04             	sub    $0x4,%esp
  800c03:	52                   	push   %edx
  800c04:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c07:	50                   	push   %eax
  800c08:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0b:	ff 75 f0             	pushl  -0x10(%ebp)
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	ff 75 08             	pushl  0x8(%ebp)
  800c14:	e8 00 fb ff ff       	call   800719 <printnum>
  800c19:	83 c4 20             	add    $0x20,%esp
			break;
  800c1c:	eb 46                	jmp    800c64 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c1e:	83 ec 08             	sub    $0x8,%esp
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	53                   	push   %ebx
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	ff d0                	call   *%eax
  800c2a:	83 c4 10             	add    $0x10,%esp
			break;
  800c2d:	eb 35                	jmp    800c64 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c2f:	c6 05 64 d0 81 00 00 	movb   $0x0,0x81d064
			break;
  800c36:	eb 2c                	jmp    800c64 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c38:	c6 05 64 d0 81 00 01 	movb   $0x1,0x81d064
			break;
  800c3f:	eb 23                	jmp    800c64 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	6a 25                	push   $0x25
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c51:	ff 4d 10             	decl   0x10(%ebp)
  800c54:	eb 03                	jmp    800c59 <vprintfmt+0x3c3>
  800c56:	ff 4d 10             	decl   0x10(%ebp)
  800c59:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5c:	48                   	dec    %eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	3c 25                	cmp    $0x25,%al
  800c61:	75 f3                	jne    800c56 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c63:	90                   	nop
		}
	}
  800c64:	e9 35 fc ff ff       	jmp    80089e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c69:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c77:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7a:	83 c0 04             	add    $0x4,%eax
  800c7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c80:	8b 45 10             	mov    0x10(%ebp),%eax
  800c83:	ff 75 f4             	pushl  -0xc(%ebp)
  800c86:	50                   	push   %eax
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	ff 75 08             	pushl  0x8(%ebp)
  800c8d:	e8 04 fc ff ff       	call   800896 <vprintfmt>
  800c92:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c95:	90                   	nop
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 40 08             	mov    0x8(%eax),%eax
  800ca1:	8d 50 01             	lea    0x1(%eax),%edx
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	8b 10                	mov    (%eax),%edx
  800caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb2:	8b 40 04             	mov    0x4(%eax),%eax
  800cb5:	39 c2                	cmp    %eax,%edx
  800cb7:	73 12                	jae    800ccb <sprintputch+0x33>
		*b->buf++ = ch;
  800cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbc:	8b 00                	mov    (%eax),%eax
  800cbe:	8d 48 01             	lea    0x1(%eax),%ecx
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	89 0a                	mov    %ecx,(%edx)
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	88 10                	mov    %dl,(%eax)
}
  800ccb:	90                   	nop
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	01 d0                	add    %edx,%eax
  800ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cf3:	74 06                	je     800cfb <vsnprintf+0x2d>
  800cf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf9:	7f 07                	jg     800d02 <vsnprintf+0x34>
		return -E_INVAL;
  800cfb:	b8 03 00 00 00       	mov    $0x3,%eax
  800d00:	eb 20                	jmp    800d22 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d02:	ff 75 14             	pushl  0x14(%ebp)
  800d05:	ff 75 10             	pushl  0x10(%ebp)
  800d08:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d0b:	50                   	push   %eax
  800d0c:	68 98 0c 80 00       	push   $0x800c98
  800d11:	e8 80 fb ff ff       	call   800896 <vprintfmt>
  800d16:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d1c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d22:	c9                   	leave  
  800d23:	c3                   	ret    

00800d24 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d2a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d2d:	83 c0 04             	add    $0x4,%eax
  800d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d33:	8b 45 10             	mov    0x10(%ebp),%eax
  800d36:	ff 75 f4             	pushl  -0xc(%ebp)
  800d39:	50                   	push   %eax
  800d3a:	ff 75 0c             	pushl  0xc(%ebp)
  800d3d:	ff 75 08             	pushl  0x8(%ebp)
  800d40:	e8 89 ff ff ff       	call   800cce <vsnprintf>
  800d45:	83 c4 10             	add    $0x10,%esp
  800d48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5d:	eb 06                	jmp    800d65 <strlen+0x15>
		n++;
  800d5f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d62:	ff 45 08             	incl   0x8(%ebp)
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	84 c0                	test   %al,%al
  800d6c:	75 f1                	jne    800d5f <strlen+0xf>
		n++;
	return n;
  800d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d80:	eb 09                	jmp    800d8b <strnlen+0x18>
		n++;
  800d82:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d85:	ff 45 08             	incl   0x8(%ebp)
  800d88:	ff 4d 0c             	decl   0xc(%ebp)
  800d8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8f:	74 09                	je     800d9a <strnlen+0x27>
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	75 e8                	jne    800d82 <strnlen+0xf>
		n++;
	return n;
  800d9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dab:	90                   	nop
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8d 50 01             	lea    0x1(%eax),%edx
  800db2:	89 55 08             	mov    %edx,0x8(%ebp)
  800db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dbb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dbe:	8a 12                	mov    (%edx),%dl
  800dc0:	88 10                	mov    %dl,(%eax)
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	84 c0                	test   %al,%al
  800dc6:	75 e4                	jne    800dac <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dcb:	c9                   	leave  
  800dcc:	c3                   	ret    

00800dcd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800de0:	eb 1f                	jmp    800e01 <strncpy+0x34>
		*dst++ = *src;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8d 50 01             	lea    0x1(%eax),%edx
  800de8:	89 55 08             	mov    %edx,0x8(%ebp)
  800deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dee:	8a 12                	mov    (%edx),%dl
  800df0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	74 03                	je     800dfe <strncpy+0x31>
			src++;
  800dfb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dfe:	ff 45 fc             	incl   -0x4(%ebp)
  800e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e04:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e07:	72 d9                	jb     800de2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e09:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1e:	74 30                	je     800e50 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e20:	eb 16                	jmp    800e38 <strlcpy+0x2a>
			*dst++ = *src++;
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	8d 50 01             	lea    0x1(%eax),%edx
  800e28:	89 55 08             	mov    %edx,0x8(%ebp)
  800e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e34:	8a 12                	mov    (%edx),%dl
  800e36:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e38:	ff 4d 10             	decl   0x10(%ebp)
  800e3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3f:	74 09                	je     800e4a <strlcpy+0x3c>
  800e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	75 d8                	jne    800e22 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e56:	29 c2                	sub    %eax,%edx
  800e58:	89 d0                	mov    %edx,%eax
}
  800e5a:	c9                   	leave  
  800e5b:	c3                   	ret    

00800e5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e5f:	eb 06                	jmp    800e67 <strcmp+0xb>
		p++, q++;
  800e61:	ff 45 08             	incl   0x8(%ebp)
  800e64:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	84 c0                	test   %al,%al
  800e6e:	74 0e                	je     800e7e <strcmp+0x22>
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 10                	mov    (%eax),%dl
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	38 c2                	cmp    %al,%dl
  800e7c:	74 e3                	je     800e61 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	0f b6 d0             	movzbl %al,%edx
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8a 00                	mov    (%eax),%al
  800e8b:	0f b6 c0             	movzbl %al,%eax
  800e8e:	29 c2                	sub    %eax,%edx
  800e90:	89 d0                	mov    %edx,%eax
}
  800e92:	5d                   	pop    %ebp
  800e93:	c3                   	ret    

00800e94 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e97:	eb 09                	jmp    800ea2 <strncmp+0xe>
		n--, p++, q++;
  800e99:	ff 4d 10             	decl   0x10(%ebp)
  800e9c:	ff 45 08             	incl   0x8(%ebp)
  800e9f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ea2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea6:	74 17                	je     800ebf <strncmp+0x2b>
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	84 c0                	test   %al,%al
  800eaf:	74 0e                	je     800ebf <strncmp+0x2b>
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8a 10                	mov    (%eax),%dl
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	38 c2                	cmp    %al,%dl
  800ebd:	74 da                	je     800e99 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ebf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec3:	75 07                	jne    800ecc <strncmp+0x38>
		return 0;
  800ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eca:	eb 14                	jmp    800ee0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 d0             	movzbl %al,%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	8a 00                	mov    (%eax),%al
  800ed9:	0f b6 c0             	movzbl %al,%eax
  800edc:	29 c2                	sub    %eax,%edx
  800ede:	89 d0                	mov    %edx,%eax
}
  800ee0:	5d                   	pop    %ebp
  800ee1:	c3                   	ret    

00800ee2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	83 ec 04             	sub    $0x4,%esp
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eee:	eb 12                	jmp    800f02 <strchr+0x20>
		if (*s == c)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef8:	75 05                	jne    800eff <strchr+0x1d>
			return (char *) s;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	eb 11                	jmp    800f10 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eff:	ff 45 08             	incl   0x8(%ebp)
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	84 c0                	test   %al,%al
  800f09:	75 e5                	jne    800ef0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	83 ec 04             	sub    $0x4,%esp
  800f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f1e:	eb 0d                	jmp    800f2d <strfind+0x1b>
		if (*s == c)
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f28:	74 0e                	je     800f38 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f2a:	ff 45 08             	incl   0x8(%ebp)
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	84 c0                	test   %al,%al
  800f34:	75 ea                	jne    800f20 <strfind+0xe>
  800f36:	eb 01                	jmp    800f39 <strfind+0x27>
		if (*s == c)
			break;
  800f38:	90                   	nop
	return (char *) s;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f4a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f4e:	76 63                	jbe    800fb3 <memset+0x75>
		uint64 data_block = c;
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	99                   	cltd   
  800f54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f57:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f60:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f64:	c1 e0 08             	shl    $0x8,%eax
  800f67:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f6a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f73:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f77:	c1 e0 10             	shl    $0x10,%eax
  800f7a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f7d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f86:	89 c2                	mov    %eax,%edx
  800f88:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f90:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f93:	eb 18                	jmp    800fad <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f95:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f98:	8d 41 08             	lea    0x8(%ecx),%eax
  800f9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa4:	89 01                	mov    %eax,(%ecx)
  800fa6:	89 51 04             	mov    %edx,0x4(%ecx)
  800fa9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800fad:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fb1:	77 e2                	ja     800f95 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	74 23                	je     800fdc <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fbf:	eb 0e                	jmp    800fcf <memset+0x91>
			*p8++ = (uint8)c;
  800fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc4:	8d 50 01             	lea    0x1(%eax),%edx
  800fc7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	75 e5                	jne    800fc1 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdf:	c9                   	leave  
  800fe0:	c3                   	ret    

00800fe1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ff3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff7:	76 24                	jbe    80101d <memcpy+0x3c>
		while(n >= 8){
  800ff9:	eb 1c                	jmp    801017 <memcpy+0x36>
			*d64 = *s64;
  800ffb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffe:	8b 50 04             	mov    0x4(%eax),%edx
  801001:	8b 00                	mov    (%eax),%eax
  801003:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801006:	89 01                	mov    %eax,(%ecx)
  801008:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80100b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80100f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801013:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801017:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80101b:	77 de                	ja     800ffb <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80101d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801021:	74 31                	je     801054 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801026:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801029:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80102f:	eb 16                	jmp    801047 <memcpy+0x66>
			*d8++ = *s8++;
  801031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801034:	8d 50 01             	lea    0x1(%eax),%edx
  801037:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80103a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801040:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801043:	8a 12                	mov    (%edx),%dl
  801045:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104d:	89 55 10             	mov    %edx,0x10(%ebp)
  801050:	85 c0                	test   %eax,%eax
  801052:	75 dd                	jne    801031 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80106b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801071:	73 50                	jae    8010c3 <memmove+0x6a>
  801073:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801076:	8b 45 10             	mov    0x10(%ebp),%eax
  801079:	01 d0                	add    %edx,%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	76 43                	jbe    8010c3 <memmove+0x6a>
		s += n;
  801080:	8b 45 10             	mov    0x10(%ebp),%eax
  801083:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801086:	8b 45 10             	mov    0x10(%ebp),%eax
  801089:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80108c:	eb 10                	jmp    80109e <memmove+0x45>
			*--d = *--s;
  80108e:	ff 4d f8             	decl   -0x8(%ebp)
  801091:	ff 4d fc             	decl   -0x4(%ebp)
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	8a 10                	mov    (%eax),%dl
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80109e:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	75 e3                	jne    80108e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010ab:	eb 23                	jmp    8010d0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b0:	8d 50 01             	lea    0x1(%eax),%edx
  8010b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010bf:	8a 12                	mov    (%edx),%dl
  8010c1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	75 dd                	jne    8010ad <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010e7:	eb 2a                	jmp    801113 <memcmp+0x3e>
		if (*s1 != *s2)
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8a 10                	mov    (%eax),%dl
  8010ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	38 c2                	cmp    %al,%dl
  8010f5:	74 16                	je     80110d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	0f b6 d0             	movzbl %al,%edx
  8010ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	0f b6 c0             	movzbl %al,%eax
  801107:	29 c2                	sub    %eax,%edx
  801109:	89 d0                	mov    %edx,%eax
  80110b:	eb 18                	jmp    801125 <memcmp+0x50>
		s1++, s2++;
  80110d:	ff 45 fc             	incl   -0x4(%ebp)
  801110:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	8d 50 ff             	lea    -0x1(%eax),%edx
  801119:	89 55 10             	mov    %edx,0x10(%ebp)
  80111c:	85 c0                	test   %eax,%eax
  80111e:	75 c9                	jne    8010e9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801120:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801125:	c9                   	leave  
  801126:	c3                   	ret    

00801127 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80112d:	8b 55 08             	mov    0x8(%ebp),%edx
  801130:	8b 45 10             	mov    0x10(%ebp),%eax
  801133:	01 d0                	add    %edx,%eax
  801135:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801138:	eb 15                	jmp    80114f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	0f b6 d0             	movzbl %al,%edx
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	0f b6 c0             	movzbl %al,%eax
  801148:	39 c2                	cmp    %eax,%edx
  80114a:	74 0d                	je     801159 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80114c:	ff 45 08             	incl   0x8(%ebp)
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801155:	72 e3                	jb     80113a <memfind+0x13>
  801157:	eb 01                	jmp    80115a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801159:	90                   	nop
	return (void *) s;
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80115d:	c9                   	leave  
  80115e:	c3                   	ret    

0080115f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801165:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80116c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801173:	eb 03                	jmp    801178 <strtol+0x19>
		s++;
  801175:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	3c 20                	cmp    $0x20,%al
  80117f:	74 f4                	je     801175 <strtol+0x16>
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 09                	cmp    $0x9,%al
  801188:	74 eb                	je     801175 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 2b                	cmp    $0x2b,%al
  801191:	75 05                	jne    801198 <strtol+0x39>
		s++;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	eb 13                	jmp    8011ab <strtol+0x4c>
	else if (*s == '-')
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	3c 2d                	cmp    $0x2d,%al
  80119f:	75 0a                	jne    8011ab <strtol+0x4c>
		s++, neg = 1;
  8011a1:	ff 45 08             	incl   0x8(%ebp)
  8011a4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011af:	74 06                	je     8011b7 <strtol+0x58>
  8011b1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011b5:	75 20                	jne    8011d7 <strtol+0x78>
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3c 30                	cmp    $0x30,%al
  8011be:	75 17                	jne    8011d7 <strtol+0x78>
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	40                   	inc    %eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 78                	cmp    $0x78,%al
  8011c8:	75 0d                	jne    8011d7 <strtol+0x78>
		s += 2, base = 16;
  8011ca:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ce:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011d5:	eb 28                	jmp    8011ff <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011db:	75 15                	jne    8011f2 <strtol+0x93>
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 30                	cmp    $0x30,%al
  8011e4:	75 0c                	jne    8011f2 <strtol+0x93>
		s++, base = 8;
  8011e6:	ff 45 08             	incl   0x8(%ebp)
  8011e9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011f0:	eb 0d                	jmp    8011ff <strtol+0xa0>
	else if (base == 0)
  8011f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f6:	75 07                	jne    8011ff <strtol+0xa0>
		base = 10;
  8011f8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 2f                	cmp    $0x2f,%al
  801206:	7e 19                	jle    801221 <strtol+0xc2>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 39                	cmp    $0x39,%al
  80120f:	7f 10                	jg     801221 <strtol+0xc2>
			dig = *s - '0';
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	83 e8 30             	sub    $0x30,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121f:	eb 42                	jmp    801263 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 60                	cmp    $0x60,%al
  801228:	7e 19                	jle    801243 <strtol+0xe4>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 7a                	cmp    $0x7a,%al
  801231:	7f 10                	jg     801243 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	83 e8 57             	sub    $0x57,%eax
  80123e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801241:	eb 20                	jmp    801263 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	3c 40                	cmp    $0x40,%al
  80124a:	7e 39                	jle    801285 <strtol+0x126>
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	3c 5a                	cmp    $0x5a,%al
  801253:	7f 30                	jg     801285 <strtol+0x126>
			dig = *s - 'A' + 10;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f be c0             	movsbl %al,%eax
  80125d:	83 e8 37             	sub    $0x37,%eax
  801260:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801266:	3b 45 10             	cmp    0x10(%ebp),%eax
  801269:	7d 19                	jge    801284 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80126b:	ff 45 08             	incl   0x8(%ebp)
  80126e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801271:	0f af 45 10          	imul   0x10(%ebp),%eax
  801275:	89 c2                	mov    %eax,%edx
  801277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127a:	01 d0                	add    %edx,%eax
  80127c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80127f:	e9 7b ff ff ff       	jmp    8011ff <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801284:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801285:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801289:	74 08                	je     801293 <strtol+0x134>
		*endptr = (char *) s;
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	8b 55 08             	mov    0x8(%ebp),%edx
  801291:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801293:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801297:	74 07                	je     8012a0 <strtol+0x141>
  801299:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129c:	f7 d8                	neg    %eax
  80129e:	eb 03                	jmp    8012a3 <strtol+0x144>
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <ltostr>:

void
ltostr(long value, char *str)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012bd:	79 13                	jns    8012d2 <ltostr+0x2d>
	{
		neg = 1;
  8012bf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012cc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012cf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012da:	99                   	cltd   
  8012db:	f7 f9                	idiv   %ecx
  8012dd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e3:	8d 50 01             	lea    0x1(%eax),%edx
  8012e6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e9:	89 c2                	mov    %eax,%edx
  8012eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ee:	01 d0                	add    %edx,%eax
  8012f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012f3:	83 c2 30             	add    $0x30,%edx
  8012f6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012fb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801300:	f7 e9                	imul   %ecx
  801302:	c1 fa 02             	sar    $0x2,%edx
  801305:	89 c8                	mov    %ecx,%eax
  801307:	c1 f8 1f             	sar    $0x1f,%eax
  80130a:	29 c2                	sub    %eax,%edx
  80130c:	89 d0                	mov    %edx,%eax
  80130e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801315:	75 bb                	jne    8012d2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801317:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80131e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801321:	48                   	dec    %eax
  801322:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801325:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801329:	74 3d                	je     801368 <ltostr+0xc3>
		start = 1 ;
  80132b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801332:	eb 34                	jmp    801368 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801334:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 d0                	add    %edx,%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801341:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	01 c2                	add    %eax,%edx
  801349:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80134c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134f:	01 c8                	add    %ecx,%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801355:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801358:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135b:	01 c2                	add    %eax,%edx
  80135d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801360:	88 02                	mov    %al,(%edx)
		start++ ;
  801362:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801365:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136e:	7c c4                	jl     801334 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801370:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801373:	8b 45 0c             	mov    0xc(%ebp),%eax
  801376:	01 d0                	add    %edx,%eax
  801378:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80137b:	90                   	nop
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801384:	ff 75 08             	pushl  0x8(%ebp)
  801387:	e8 c4 f9 ff ff       	call   800d50 <strlen>
  80138c:	83 c4 04             	add    $0x4,%esp
  80138f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801392:	ff 75 0c             	pushl  0xc(%ebp)
  801395:	e8 b6 f9 ff ff       	call   800d50 <strlen>
  80139a:	83 c4 04             	add    $0x4,%esp
  80139d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ae:	eb 17                	jmp    8013c7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b6:	01 c2                	add    %eax,%edx
  8013b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	01 c8                	add    %ecx,%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c4:	ff 45 fc             	incl   -0x4(%ebp)
  8013c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013cd:	7c e1                	jl     8013b0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013dd:	eb 1f                	jmp    8013fe <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e2:	8d 50 01             	lea    0x1(%eax),%edx
  8013e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e8:	89 c2                	mov    %eax,%edx
  8013ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ed:	01 c2                	add    %eax,%edx
  8013ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	01 c8                	add    %ecx,%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013fb:	ff 45 f8             	incl   -0x8(%ebp)
  8013fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801401:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801404:	7c d9                	jl     8013df <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801406:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801409:	8b 45 10             	mov    0x10(%ebp),%eax
  80140c:	01 d0                	add    %edx,%eax
  80140e:	c6 00 00             	movb   $0x0,(%eax)
}
  801411:	90                   	nop
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801417:	8b 45 14             	mov    0x14(%ebp),%eax
  80141a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801420:	8b 45 14             	mov    0x14(%ebp),%eax
  801423:	8b 00                	mov    (%eax),%eax
  801425:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142c:	8b 45 10             	mov    0x10(%ebp),%eax
  80142f:	01 d0                	add    %edx,%eax
  801431:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801437:	eb 0c                	jmp    801445 <strsplit+0x31>
			*string++ = 0;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8d 50 01             	lea    0x1(%eax),%edx
  80143f:	89 55 08             	mov    %edx,0x8(%ebp)
  801442:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	84 c0                	test   %al,%al
  80144c:	74 18                	je     801466 <strsplit+0x52>
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	0f be c0             	movsbl %al,%eax
  801456:	50                   	push   %eax
  801457:	ff 75 0c             	pushl  0xc(%ebp)
  80145a:	e8 83 fa ff ff       	call   800ee2 <strchr>
  80145f:	83 c4 08             	add    $0x8,%esp
  801462:	85 c0                	test   %eax,%eax
  801464:	75 d3                	jne    801439 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	84 c0                	test   %al,%al
  80146d:	74 5a                	je     8014c9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	83 f8 0f             	cmp    $0xf,%eax
  801477:	75 07                	jne    801480 <strsplit+0x6c>
		{
			return 0;
  801479:	b8 00 00 00 00       	mov    $0x0,%eax
  80147e:	eb 66                	jmp    8014e6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801480:	8b 45 14             	mov    0x14(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	8d 48 01             	lea    0x1(%eax),%ecx
  801488:	8b 55 14             	mov    0x14(%ebp),%edx
  80148b:	89 0a                	mov    %ecx,(%edx)
  80148d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	01 c2                	add    %eax,%edx
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149e:	eb 03                	jmp    8014a3 <strsplit+0x8f>
			string++;
  8014a0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	84 c0                	test   %al,%al
  8014aa:	74 8b                	je     801437 <strsplit+0x23>
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	0f be c0             	movsbl %al,%eax
  8014b4:	50                   	push   %eax
  8014b5:	ff 75 0c             	pushl  0xc(%ebp)
  8014b8:	e8 25 fa ff ff       	call   800ee2 <strchr>
  8014bd:	83 c4 08             	add    $0x8,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	74 dc                	je     8014a0 <strsplit+0x8c>
			string++;
	}
  8014c4:	e9 6e ff ff ff       	jmp    801437 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cd:	8b 00                	mov    (%eax),%eax
  8014cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d9:	01 d0                	add    %edx,%eax
  8014db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8014f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014fb:	eb 4a                	jmp    801547 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8014fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	01 c2                	add    %eax,%edx
  801505:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	01 c8                	add    %ecx,%eax
  80150d:	8a 00                	mov    (%eax),%al
  80150f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801511:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	01 d0                	add    %edx,%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	3c 40                	cmp    $0x40,%al
  80151d:	7e 25                	jle    801544 <str2lower+0x5c>
  80151f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801522:	8b 45 0c             	mov    0xc(%ebp),%eax
  801525:	01 d0                	add    %edx,%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	3c 5a                	cmp    $0x5a,%al
  80152b:	7f 17                	jg     801544 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80152d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	01 d0                	add    %edx,%eax
  801535:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801538:	8b 55 08             	mov    0x8(%ebp),%edx
  80153b:	01 ca                	add    %ecx,%edx
  80153d:	8a 12                	mov    (%edx),%dl
  80153f:	83 c2 20             	add    $0x20,%edx
  801542:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801544:	ff 45 fc             	incl   -0x4(%ebp)
  801547:	ff 75 0c             	pushl  0xc(%ebp)
  80154a:	e8 01 f8 ff ff       	call   800d50 <strlen>
  80154f:	83 c4 04             	add    $0x4,%esp
  801552:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801555:	7f a6                	jg     8014fd <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801557:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801562:	a1 08 50 80 00       	mov    0x805008,%eax
  801567:	85 c0                	test   %eax,%eax
  801569:	74 42                	je     8015ad <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80156b:	83 ec 08             	sub    $0x8,%esp
  80156e:	68 00 00 00 82       	push   $0x82000000
  801573:	68 00 00 00 80       	push   $0x80000000
  801578:	e8 b0 1e 00 00       	call   80342d <initialize_dynamic_allocator>
  80157d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801580:	e8 96 1c 00 00       	call   80321b <sys_get_uheap_strategy>
  801585:	a3 80 50 83 00       	mov    %eax,0x835080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80158a:	a1 60 d0 81 00       	mov    0x81d060,%eax
  80158f:	05 00 10 00 00       	add    $0x1000,%eax
  801594:	a3 30 51 83 00       	mov    %eax,0x835130
		uheapPageAllocBreak = uheapPageAllocStart;
  801599:	a1 30 51 83 00       	mov    0x835130,%eax
  80159e:	a3 88 50 83 00       	mov    %eax,0x835088

		__firstTimeFlag = 0;
  8015a3:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8015aa:	00 00 00 
	}
}
  8015ad:	90                   	nop
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	68 06 04 00 00       	push   $0x406
  8015cc:	50                   	push   %eax
  8015cd:	e8 93 18 00 00       	call   802e65 <__sys_allocate_page>
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015dc:	79 14                	jns    8015f2 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	68 a8 48 80 00       	push   $0x8048a8
  8015e6:	6a 1f                	push   $0x1f
  8015e8:	68 e4 48 80 00       	push   $0x8048e4
  8015ed:	e8 82 28 00 00       	call   803e74 <_panic>
	return 0;
  8015f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801608:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80160d:	83 ec 0c             	sub    $0xc,%esp
  801610:	50                   	push   %eax
  801611:	e8 96 18 00 00       	call   802eac <__sys_unmap_frame>
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80161c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801620:	79 14                	jns    801636 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801622:	83 ec 04             	sub    $0x4,%esp
  801625:	68 f0 48 80 00       	push   $0x8048f0
  80162a:	6a 2a                	push   $0x2a
  80162c:	68 e4 48 80 00       	push   $0x8048e4
  801631:	e8 3e 28 00 00       	call   803e74 <_panic>
}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80163f:	e8 18 ff ff ff       	call   80155c <uheap_init>
	if (size == 0) return NULL ;
  801644:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801648:	75 0a                	jne    801654 <malloc+0x1b>
  80164a:	b8 00 00 00 00       	mov    $0x0,%eax
  80164f:	e9 43 03 00 00       	jmp    801997 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801654:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80165b:	77 13                	ja     801670 <malloc+0x37>
    {
        return alloc_block(size);
  80165d:	83 ec 0c             	sub    $0xc,%esp
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	e8 78 20 00 00       	call   8036e0 <alloc_block>
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	e9 27 03 00 00       	jmp    801997 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801670:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801677:	8b 55 08             	mov    0x8(%ebp),%edx
  80167a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80167d:	01 d0                	add    %edx,%eax
  80167f:	48                   	dec    %eax
  801680:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801683:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801686:	ba 00 00 00 00       	mov    $0x0,%edx
  80168b:	f7 75 dc             	divl   -0x24(%ebp)
  80168e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801691:	29 d0                	sub    %edx,%eax
  801693:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801696:	a1 40 d0 81 00       	mov    0x81d040,%eax
  80169b:	85 c0                	test   %eax,%eax
  80169d:	75 0a                	jne    8016a9 <malloc+0x70>
    {
        uhp_inited = 1;
  80169f:	c7 05 40 d0 81 00 01 	movl   $0x1,0x81d040
  8016a6:	00 00 00 
    }

    int exactIdx = -1;
  8016a9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8016b0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8016b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8016be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8016c5:	e9 85 00 00 00       	jmp    80174f <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8016ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016cd:	89 d0                	mov    %edx,%eax
  8016cf:	01 c0                	add    %eax,%eax
  8016d1:	01 d0                	add    %edx,%eax
  8016d3:	c1 e0 02             	shl    $0x2,%eax
  8016d6:	05 48 10 81 00       	add    $0x811048,%eax
  8016db:	8a 00                	mov    (%eax),%al
  8016dd:	84 c0                	test   %al,%al
  8016df:	74 20                	je     801701 <malloc+0xc8>
  8016e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016e4:	89 d0                	mov    %edx,%eax
  8016e6:	01 c0                	add    %eax,%eax
  8016e8:	01 d0                	add    %edx,%eax
  8016ea:	c1 e0 02             	shl    $0x2,%eax
  8016ed:	05 44 10 81 00       	add    $0x811044,%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8016f7:	75 08                	jne    801701 <malloc+0xc8>
        {
            exactIdx = i;
  8016f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8016ff:	eb 5b                	jmp    80175c <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801701:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801704:	89 d0                	mov    %edx,%eax
  801706:	01 c0                	add    %eax,%eax
  801708:	01 d0                	add    %edx,%eax
  80170a:	c1 e0 02             	shl    $0x2,%eax
  80170d:	05 48 10 81 00       	add    $0x811048,%eax
  801712:	8a 00                	mov    (%eax),%al
  801714:	84 c0                	test   %al,%al
  801716:	74 34                	je     80174c <malloc+0x113>
  801718:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80171b:	89 d0                	mov    %edx,%eax
  80171d:	01 c0                	add    %eax,%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	c1 e0 02             	shl    $0x2,%eax
  801724:	05 44 10 81 00       	add    $0x811044,%eax
  801729:	8b 00                	mov    (%eax),%eax
  80172b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80172e:	76 1c                	jbe    80174c <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801730:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801733:	89 d0                	mov    %edx,%eax
  801735:	01 c0                	add    %eax,%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	c1 e0 02             	shl    $0x2,%eax
  80173c:	05 44 10 81 00       	add    $0x811044,%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801749:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80174c:	ff 45 e8             	incl   -0x18(%ebp)
  80174f:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801756:	0f 8e 6e ff ff ff    	jle    8016ca <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  80175c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801763:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801767:	74 7d                	je     8017e6 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801769:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801770:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801773:	89 d0                	mov    %edx,%eax
  801775:	01 c0                	add    %eax,%eax
  801777:	01 d0                	add    %edx,%eax
  801779:	c1 e0 02             	shl    $0x2,%eax
  80177c:	05 40 10 81 00       	add    $0x811040,%eax
  801781:	8b 10                	mov    (%eax),%edx
  801783:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801786:	01 d0                	add    %edx,%eax
  801788:	48                   	dec    %eax
  801789:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80178c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80178f:	ba 00 00 00 00       	mov    $0x0,%edx
  801794:	f7 75 bc             	divl   -0x44(%ebp)
  801797:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80179a:	29 d0                	sub    %edx,%eax
  80179c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80179f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a2:	89 d0                	mov    %edx,%eax
  8017a4:	01 c0                	add    %eax,%eax
  8017a6:	01 d0                	add    %edx,%eax
  8017a8:	c1 e0 02             	shl    $0x2,%eax
  8017ab:	05 48 10 81 00       	add    $0x811048,%eax
  8017b0:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8017b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b6:	89 d0                	mov    %edx,%eax
  8017b8:	01 c0                	add    %eax,%eax
  8017ba:	01 d0                	add    %edx,%eax
  8017bc:	c1 e0 02             	shl    $0x2,%eax
  8017bf:	05 44 10 81 00       	add    $0x811044,%eax
  8017c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8017ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017cd:	89 d0                	mov    %edx,%eax
  8017cf:	01 c0                	add    %eax,%eax
  8017d1:	01 d0                	add    %edx,%eax
  8017d3:	c1 e0 02             	shl    $0x2,%eax
  8017d6:	05 40 10 81 00       	add    $0x811040,%eax
  8017db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017e1:	e9 2d 01 00 00       	jmp    801913 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8017e6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8017ea:	0f 84 ce 00 00 00    	je     8018be <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8017f0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8017f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017fa:	89 d0                	mov    %edx,%eax
  8017fc:	01 c0                	add    %eax,%eax
  8017fe:	01 d0                	add    %edx,%eax
  801800:	c1 e0 02             	shl    $0x2,%eax
  801803:	05 40 10 81 00       	add    $0x811040,%eax
  801808:	8b 10                	mov    (%eax),%edx
  80180a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80180d:	01 d0                	add    %edx,%eax
  80180f:	48                   	dec    %eax
  801810:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801813:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801816:	ba 00 00 00 00       	mov    $0x0,%edx
  80181b:	f7 75 c4             	divl   -0x3c(%ebp)
  80181e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801821:	29 d0                	sub    %edx,%eax
  801823:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801826:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801829:	89 d0                	mov    %edx,%eax
  80182b:	01 c0                	add    %eax,%eax
  80182d:	01 d0                	add    %edx,%eax
  80182f:	c1 e0 02             	shl    $0x2,%eax
  801832:	05 44 10 81 00       	add    $0x811044,%eax
  801837:	8b 00                	mov    (%eax),%eax
  801839:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80183c:	75 47                	jne    801885 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  80183e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801841:	89 d0                	mov    %edx,%eax
  801843:	01 c0                	add    %eax,%eax
  801845:	01 d0                	add    %edx,%eax
  801847:	c1 e0 02             	shl    $0x2,%eax
  80184a:	05 48 10 81 00       	add    $0x811048,%eax
  80184f:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801852:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801855:	89 d0                	mov    %edx,%eax
  801857:	01 c0                	add    %eax,%eax
  801859:	01 d0                	add    %edx,%eax
  80185b:	c1 e0 02             	shl    $0x2,%eax
  80185e:	05 44 10 81 00       	add    $0x811044,%eax
  801863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801869:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80186c:	89 d0                	mov    %edx,%eax
  80186e:	01 c0                	add    %eax,%eax
  801870:	01 d0                	add    %edx,%eax
  801872:	c1 e0 02             	shl    $0x2,%eax
  801875:	05 40 10 81 00       	add    $0x811040,%eax
  80187a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801880:	e9 8e 00 00 00       	jmp    801913 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801885:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801888:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80188b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80188e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801891:	89 d0                	mov    %edx,%eax
  801893:	01 c0                	add    %eax,%eax
  801895:	01 d0                	add    %edx,%eax
  801897:	c1 e0 02             	shl    $0x2,%eax
  80189a:	05 40 10 81 00       	add    $0x811040,%eax
  80189f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8018a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8018a7:	89 c2                	mov    %eax,%edx
  8018a9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018ac:	89 c8                	mov    %ecx,%eax
  8018ae:	01 c0                	add    %eax,%eax
  8018b0:	01 c8                	add    %ecx,%eax
  8018b2:	c1 e0 02             	shl    $0x2,%eax
  8018b5:	05 44 10 81 00       	add    $0x811044,%eax
  8018ba:	89 10                	mov    %edx,(%eax)
  8018bc:	eb 55                	jmp    801913 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8018be:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8018c5:	8b 15 88 50 83 00    	mov    0x835088,%edx
  8018cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8018ce:	01 d0                	add    %edx,%eax
  8018d0:	48                   	dec    %eax
  8018d1:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8018d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018dc:	f7 75 d0             	divl   -0x30(%ebp)
  8018df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8018e2:	29 d0                	sub    %edx,%eax
  8018e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8018e7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8018ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018ed:	01 d0                	add    %edx,%eax
  8018ef:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8018f4:	76 0a                	jbe    801900 <malloc+0x2c7>
            return NULL;
  8018f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fb:	e9 97 00 00 00       	jmp    801997 <malloc+0x35e>
        va = start;
  801900:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801903:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801906:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801909:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80190c:	01 d0                	add    %edx,%eax
  80190e:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801913:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80191a:	eb 5e                	jmp    80197a <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  80191c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80191f:	89 d0                	mov    %edx,%eax
  801921:	01 c0                	add    %eax,%eax
  801923:	01 d0                	add    %edx,%eax
  801925:	c1 e0 02             	shl    $0x2,%eax
  801928:	05 48 50 80 00       	add    $0x805048,%eax
  80192d:	8a 00                	mov    (%eax),%al
  80192f:	84 c0                	test   %al,%al
  801931:	75 44                	jne    801977 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801933:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801936:	89 d0                	mov    %edx,%eax
  801938:	01 c0                	add    %eax,%eax
  80193a:	01 d0                	add    %edx,%eax
  80193c:	c1 e0 02             	shl    $0x2,%eax
  80193f:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  801945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801948:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80194a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80194d:	89 d0                	mov    %edx,%eax
  80194f:	01 c0                	add    %eax,%eax
  801951:	01 d0                	add    %edx,%eax
  801953:	c1 e0 02             	shl    $0x2,%eax
  801956:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  80195c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80195f:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801961:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801964:	89 d0                	mov    %edx,%eax
  801966:	01 c0                	add    %eax,%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	c1 e0 02             	shl    $0x2,%eax
  80196d:	05 48 50 80 00       	add    $0x805048,%eax
  801972:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801975:	eb 0c                	jmp    801983 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801977:	ff 45 e0             	incl   -0x20(%ebp)
  80197a:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801981:	7e 99                	jle    80191c <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	ff 75 d4             	pushl  -0x2c(%ebp)
  801989:	ff 75 e4             	pushl  -0x1c(%ebp)
  80198c:	e8 a2 19 00 00       	call   803333 <sys_allocate_user_mem>
  801991:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801994:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  80199f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019a3:	0f 84 fa 03 00 00    	je     801da3 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8019af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	79 1c                	jns    8019d2 <free+0x39>
  8019b6:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  8019bd:	77 13                	ja     8019d2 <free+0x39>
    {
        free_block(virtual_address);
  8019bf:	83 ec 0c             	sub    $0xc,%esp
  8019c2:	ff 75 08             	pushl  0x8(%ebp)
  8019c5:	e8 09 21 00 00       	call   803ad3 <free_block>
  8019ca:	83 c4 10             	add    $0x10,%esp
        return;
  8019cd:	e9 d2 03 00 00       	jmp    801da4 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8019d2:	a1 30 51 83 00       	mov    0x835130,%eax
  8019d7:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  8019da:	72 09                	jb     8019e5 <free+0x4c>
  8019dc:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  8019e3:	76 17                	jbe    8019fc <free+0x63>
        panic("free: invalid address");
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	68 2d 49 80 00       	push   $0x80492d
  8019ed:	68 9b 00 00 00       	push   $0x9b
  8019f2:	68 e4 48 80 00       	push   $0x8048e4
  8019f7:	e8 78 24 00 00       	call   803e74 <_panic>

    uint32 size = 0;
  8019fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801a03:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a0a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801a11:	eb 50                	jmp    801a63 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801a13:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a16:	89 d0                	mov    %edx,%eax
  801a18:	01 c0                	add    %eax,%eax
  801a1a:	01 d0                	add    %edx,%eax
  801a1c:	c1 e0 02             	shl    $0x2,%eax
  801a1f:	05 48 50 80 00       	add    $0x805048,%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	84 c0                	test   %al,%al
  801a28:	74 36                	je     801a60 <free+0xc7>
  801a2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a2d:	89 d0                	mov    %edx,%eax
  801a2f:	01 c0                	add    %eax,%eax
  801a31:	01 d0                	add    %edx,%eax
  801a33:	c1 e0 02             	shl    $0x2,%eax
  801a36:	05 40 50 80 00       	add    $0x805040,%eax
  801a3b:	8b 00                	mov    (%eax),%eax
  801a3d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801a40:	75 1e                	jne    801a60 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801a42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a45:	89 d0                	mov    %edx,%eax
  801a47:	01 c0                	add    %eax,%eax
  801a49:	01 d0                	add    %edx,%eax
  801a4b:	c1 e0 02             	shl    $0x2,%eax
  801a4e:	05 44 50 80 00       	add    $0x805044,%eax
  801a53:	8b 00                	mov    (%eax),%eax
  801a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801a5e:	eb 0c                	jmp    801a6c <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801a60:	ff 45 ec             	incl   -0x14(%ebp)
  801a63:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801a6a:	7e a7                	jle    801a13 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801a6c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801a70:	74 06                	je     801a78 <free+0xdf>
  801a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a76:	75 17                	jne    801a8f <free+0xf6>
        panic("free: unknown block");
  801a78:	83 ec 04             	sub    $0x4,%esp
  801a7b:	68 43 49 80 00       	push   $0x804943
  801a80:	68 a9 00 00 00       	push   $0xa9
  801a85:	68 e4 48 80 00       	push   $0x8048e4
  801a8a:	e8 e5 23 00 00       	call   803e74 <_panic>

    uhp_allocs[idx].used = 0;
  801a8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a92:	89 d0                	mov    %edx,%eax
  801a94:	01 c0                	add    %eax,%eax
  801a96:	01 d0                	add    %edx,%eax
  801a98:	c1 e0 02             	shl    $0x2,%eax
  801a9b:	05 48 50 80 00       	add    $0x805048,%eax
  801aa0:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801aa3:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801aaa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801ab1:	eb 64                	jmp    801b17 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801ab3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ab6:	89 d0                	mov    %edx,%eax
  801ab8:	01 c0                	add    %eax,%eax
  801aba:	01 d0                	add    %edx,%eax
  801abc:	c1 e0 02             	shl    $0x2,%eax
  801abf:	05 48 10 81 00       	add    $0x811048,%eax
  801ac4:	8a 00                	mov    (%eax),%al
  801ac6:	84 c0                	test   %al,%al
  801ac8:	75 4a                	jne    801b14 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801aca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801acd:	89 d0                	mov    %edx,%eax
  801acf:	01 c0                	add    %eax,%eax
  801ad1:	01 d0                	add    %edx,%eax
  801ad3:	c1 e0 02             	shl    $0x2,%eax
  801ad6:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  801adc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801adf:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801ae1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ae4:	89 d0                	mov    %edx,%eax
  801ae6:	01 c0                	add    %eax,%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	c1 e0 02             	shl    $0x2,%eax
  801aed:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  801af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af6:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801af8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801afb:	89 d0                	mov    %edx,%eax
  801afd:	01 c0                	add    %eax,%eax
  801aff:	01 d0                	add    %edx,%eax
  801b01:	c1 e0 02             	shl    $0x2,%eax
  801b04:	05 48 10 81 00       	add    $0x811048,%eax
  801b09:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801b12:	eb 0c                	jmp    801b20 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b14:	ff 45 e4             	incl   -0x1c(%ebp)
  801b17:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801b1e:	7e 93                	jle    801ab3 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801b20:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801b24:	0f 84 f1 01 00 00    	je     801d1b <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801b2a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b31:	e9 d8 01 00 00       	jmp    801d0e <free+0x375>
        {
            if (i == fidx) continue;
  801b36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b39:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b3c:	0f 84 c8 01 00 00    	je     801d0a <free+0x371>
            if (uhp_frees[i].free)
  801b42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b45:	89 d0                	mov    %edx,%eax
  801b47:	01 c0                	add    %eax,%eax
  801b49:	01 d0                	add    %edx,%eax
  801b4b:	c1 e0 02             	shl    $0x2,%eax
  801b4e:	05 48 10 81 00       	add    $0x811048,%eax
  801b53:	8a 00                	mov    (%eax),%al
  801b55:	84 c0                	test   %al,%al
  801b57:	0f 84 ae 01 00 00    	je     801d0b <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801b5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b60:	89 d0                	mov    %edx,%eax
  801b62:	01 c0                	add    %eax,%eax
  801b64:	01 d0                	add    %edx,%eax
  801b66:	c1 e0 02             	shl    $0x2,%eax
  801b69:	05 40 10 81 00       	add    $0x811040,%eax
  801b6e:	8b 08                	mov    (%eax),%ecx
  801b70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b73:	89 d0                	mov    %edx,%eax
  801b75:	01 c0                	add    %eax,%eax
  801b77:	01 d0                	add    %edx,%eax
  801b79:	c1 e0 02             	shl    $0x2,%eax
  801b7c:	05 44 10 81 00       	add    $0x811044,%eax
  801b81:	8b 00                	mov    (%eax),%eax
  801b83:	01 c1                	add    %eax,%ecx
  801b85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b88:	89 d0                	mov    %edx,%eax
  801b8a:	01 c0                	add    %eax,%eax
  801b8c:	01 d0                	add    %edx,%eax
  801b8e:	c1 e0 02             	shl    $0x2,%eax
  801b91:	05 40 10 81 00       	add    $0x811040,%eax
  801b96:	8b 00                	mov    (%eax),%eax
  801b98:	39 c1                	cmp    %eax,%ecx
  801b9a:	0f 85 a8 00 00 00    	jne    801c48 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801ba0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ba3:	89 d0                	mov    %edx,%eax
  801ba5:	01 c0                	add    %eax,%eax
  801ba7:	01 d0                	add    %edx,%eax
  801ba9:	c1 e0 02             	shl    $0x2,%eax
  801bac:	05 40 10 81 00       	add    $0x811040,%eax
  801bb1:	8b 10                	mov    (%eax),%edx
  801bb3:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801bb6:	89 c8                	mov    %ecx,%eax
  801bb8:	01 c0                	add    %eax,%eax
  801bba:	01 c8                	add    %ecx,%eax
  801bbc:	c1 e0 02             	shl    $0x2,%eax
  801bbf:	05 40 10 81 00       	add    $0x811040,%eax
  801bc4:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801bc6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bc9:	89 d0                	mov    %edx,%eax
  801bcb:	01 c0                	add    %eax,%eax
  801bcd:	01 d0                	add    %edx,%eax
  801bcf:	c1 e0 02             	shl    $0x2,%eax
  801bd2:	05 44 10 81 00       	add    $0x811044,%eax
  801bd7:	8b 08                	mov    (%eax),%ecx
  801bd9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bdc:	89 d0                	mov    %edx,%eax
  801bde:	01 c0                	add    %eax,%eax
  801be0:	01 d0                	add    %edx,%eax
  801be2:	c1 e0 02             	shl    $0x2,%eax
  801be5:	05 44 10 81 00       	add    $0x811044,%eax
  801bea:	8b 00                	mov    (%eax),%eax
  801bec:	01 c1                	add    %eax,%ecx
  801bee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bf1:	89 d0                	mov    %edx,%eax
  801bf3:	01 c0                	add    %eax,%eax
  801bf5:	01 d0                	add    %edx,%eax
  801bf7:	c1 e0 02             	shl    $0x2,%eax
  801bfa:	05 44 10 81 00       	add    $0x811044,%eax
  801bff:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801c01:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c04:	89 d0                	mov    %edx,%eax
  801c06:	01 c0                	add    %eax,%eax
  801c08:	01 d0                	add    %edx,%eax
  801c0a:	c1 e0 02             	shl    $0x2,%eax
  801c0d:	05 48 10 81 00       	add    $0x811048,%eax
  801c12:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801c15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c18:	89 d0                	mov    %edx,%eax
  801c1a:	01 c0                	add    %eax,%eax
  801c1c:	01 d0                	add    %edx,%eax
  801c1e:	c1 e0 02             	shl    $0x2,%eax
  801c21:	05 40 10 81 00       	add    $0x811040,%eax
  801c26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801c2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c2f:	89 d0                	mov    %edx,%eax
  801c31:	01 c0                	add    %eax,%eax
  801c33:	01 d0                	add    %edx,%eax
  801c35:	c1 e0 02             	shl    $0x2,%eax
  801c38:	05 44 10 81 00       	add    $0x811044,%eax
  801c3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c43:	e9 c3 00 00 00       	jmp    801d0b <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801c48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c4b:	89 d0                	mov    %edx,%eax
  801c4d:	01 c0                	add    %eax,%eax
  801c4f:	01 d0                	add    %edx,%eax
  801c51:	c1 e0 02             	shl    $0x2,%eax
  801c54:	05 40 10 81 00       	add    $0x811040,%eax
  801c59:	8b 08                	mov    (%eax),%ecx
  801c5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c5e:	89 d0                	mov    %edx,%eax
  801c60:	01 c0                	add    %eax,%eax
  801c62:	01 d0                	add    %edx,%eax
  801c64:	c1 e0 02             	shl    $0x2,%eax
  801c67:	05 44 10 81 00       	add    $0x811044,%eax
  801c6c:	8b 00                	mov    (%eax),%eax
  801c6e:	01 c1                	add    %eax,%ecx
  801c70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c73:	89 d0                	mov    %edx,%eax
  801c75:	01 c0                	add    %eax,%eax
  801c77:	01 d0                	add    %edx,%eax
  801c79:	c1 e0 02             	shl    $0x2,%eax
  801c7c:	05 40 10 81 00       	add    $0x811040,%eax
  801c81:	8b 00                	mov    (%eax),%eax
  801c83:	39 c1                	cmp    %eax,%ecx
  801c85:	0f 85 80 00 00 00    	jne    801d0b <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801c8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c8e:	89 d0                	mov    %edx,%eax
  801c90:	01 c0                	add    %eax,%eax
  801c92:	01 d0                	add    %edx,%eax
  801c94:	c1 e0 02             	shl    $0x2,%eax
  801c97:	05 44 10 81 00       	add    $0x811044,%eax
  801c9c:	8b 08                	mov    (%eax),%ecx
  801c9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ca1:	89 d0                	mov    %edx,%eax
  801ca3:	01 c0                	add    %eax,%eax
  801ca5:	01 d0                	add    %edx,%eax
  801ca7:	c1 e0 02             	shl    $0x2,%eax
  801caa:	05 44 10 81 00       	add    $0x811044,%eax
  801caf:	8b 00                	mov    (%eax),%eax
  801cb1:	01 c1                	add    %eax,%ecx
  801cb3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cb6:	89 d0                	mov    %edx,%eax
  801cb8:	01 c0                	add    %eax,%eax
  801cba:	01 d0                	add    %edx,%eax
  801cbc:	c1 e0 02             	shl    $0x2,%eax
  801cbf:	05 44 10 81 00       	add    $0x811044,%eax
  801cc4:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801cc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cc9:	89 d0                	mov    %edx,%eax
  801ccb:	01 c0                	add    %eax,%eax
  801ccd:	01 d0                	add    %edx,%eax
  801ccf:	c1 e0 02             	shl    $0x2,%eax
  801cd2:	05 48 10 81 00       	add    $0x811048,%eax
  801cd7:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801cda:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cdd:	89 d0                	mov    %edx,%eax
  801cdf:	01 c0                	add    %eax,%eax
  801ce1:	01 d0                	add    %edx,%eax
  801ce3:	c1 e0 02             	shl    $0x2,%eax
  801ce6:	05 40 10 81 00       	add    $0x811040,%eax
  801ceb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801cf1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cf4:	89 d0                	mov    %edx,%eax
  801cf6:	01 c0                	add    %eax,%eax
  801cf8:	01 d0                	add    %edx,%eax
  801cfa:	c1 e0 02             	shl    $0x2,%eax
  801cfd:	05 44 10 81 00       	add    $0x811044,%eax
  801d02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d08:	eb 01                	jmp    801d0b <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801d0a:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d0b:	ff 45 e0             	incl   -0x20(%ebp)
  801d0e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801d15:	0f 8e 1b fe ff ff    	jle    801b36 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801d1b:	a1 30 51 83 00       	mov    0x835130,%eax
  801d20:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801d23:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801d2a:	eb 53                	jmp    801d7f <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801d2c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d2f:	89 d0                	mov    %edx,%eax
  801d31:	01 c0                	add    %eax,%eax
  801d33:	01 d0                	add    %edx,%eax
  801d35:	c1 e0 02             	shl    $0x2,%eax
  801d38:	05 48 50 80 00       	add    $0x805048,%eax
  801d3d:	8a 00                	mov    (%eax),%al
  801d3f:	84 c0                	test   %al,%al
  801d41:	74 39                	je     801d7c <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801d43:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d46:	89 d0                	mov    %edx,%eax
  801d48:	01 c0                	add    %eax,%eax
  801d4a:	01 d0                	add    %edx,%eax
  801d4c:	c1 e0 02             	shl    $0x2,%eax
  801d4f:	05 40 50 80 00       	add    $0x805040,%eax
  801d54:	8b 08                	mov    (%eax),%ecx
  801d56:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d59:	89 d0                	mov    %edx,%eax
  801d5b:	01 c0                	add    %eax,%eax
  801d5d:	01 d0                	add    %edx,%eax
  801d5f:	c1 e0 02             	shl    $0x2,%eax
  801d62:	05 44 50 80 00       	add    $0x805044,%eax
  801d67:	8b 00                	mov    (%eax),%eax
  801d69:	01 c8                	add    %ecx,%eax
  801d6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801d6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d71:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801d74:	76 06                	jbe    801d7c <free+0x3e3>
  801d76:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801d79:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801d7c:	ff 45 d8             	incl   -0x28(%ebp)
  801d7f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  801d86:	7e a4                	jle    801d2c <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  801d88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d8b:	a3 88 50 83 00       	mov    %eax,0x835088

    sys_free_user_mem(va, size);
  801d90:	83 ec 08             	sub    $0x8,%esp
  801d93:	ff 75 f4             	pushl  -0xc(%ebp)
  801d96:	ff 75 d4             	pushl  -0x2c(%ebp)
  801d99:	e8 79 15 00 00       	call   803317 <sys_free_user_mem>
  801d9e:	83 c4 10             	add    $0x10,%esp
  801da1:	eb 01                	jmp    801da4 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  801da3:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 68             	sub    $0x68,%esp
  801dac:	8b 45 10             	mov    0x10(%ebp),%eax
  801daf:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801db2:	e8 a5 f7 ff ff       	call   80155c <uheap_init>
	if (size == 0) return NULL ;
  801db7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dbb:	75 0a                	jne    801dc7 <smalloc+0x21>
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc2:	e9 37 03 00 00       	jmp    8020fe <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801dc7:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801dce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dd4:	01 d0                	add    %edx,%eax
  801dd6:	48                   	dec    %eax
  801dd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801dda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ddd:	ba 00 00 00 00       	mov    $0x0,%edx
  801de2:	f7 75 dc             	divl   -0x24(%ebp)
  801de5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801de8:	29 d0                	sub    %edx,%eax
  801dea:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  801ded:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801df4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801dfb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801e09:	e9 85 00 00 00       	jmp    801e93 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801e0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e11:	89 d0                	mov    %edx,%eax
  801e13:	01 c0                	add    %eax,%eax
  801e15:	01 d0                	add    %edx,%eax
  801e17:	c1 e0 02             	shl    $0x2,%eax
  801e1a:	05 48 10 81 00       	add    $0x811048,%eax
  801e1f:	8a 00                	mov    (%eax),%al
  801e21:	84 c0                	test   %al,%al
  801e23:	74 20                	je     801e45 <smalloc+0x9f>
  801e25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e28:	89 d0                	mov    %edx,%eax
  801e2a:	01 c0                	add    %eax,%eax
  801e2c:	01 d0                	add    %edx,%eax
  801e2e:	c1 e0 02             	shl    $0x2,%eax
  801e31:	05 44 10 81 00       	add    $0x811044,%eax
  801e36:	8b 00                	mov    (%eax),%eax
  801e38:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e3b:	75 08                	jne    801e45 <smalloc+0x9f>
        {
            exactIdx = i;
  801e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801e43:	eb 5b                	jmp    801ea0 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801e45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e48:	89 d0                	mov    %edx,%eax
  801e4a:	01 c0                	add    %eax,%eax
  801e4c:	01 d0                	add    %edx,%eax
  801e4e:	c1 e0 02             	shl    $0x2,%eax
  801e51:	05 48 10 81 00       	add    $0x811048,%eax
  801e56:	8a 00                	mov    (%eax),%al
  801e58:	84 c0                	test   %al,%al
  801e5a:	74 34                	je     801e90 <smalloc+0xea>
  801e5c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e5f:	89 d0                	mov    %edx,%eax
  801e61:	01 c0                	add    %eax,%eax
  801e63:	01 d0                	add    %edx,%eax
  801e65:	c1 e0 02             	shl    $0x2,%eax
  801e68:	05 44 10 81 00       	add    $0x811044,%eax
  801e6d:	8b 00                	mov    (%eax),%eax
  801e6f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e72:	76 1c                	jbe    801e90 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  801e74:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e77:	89 d0                	mov    %edx,%eax
  801e79:	01 c0                	add    %eax,%eax
  801e7b:	01 d0                	add    %edx,%eax
  801e7d:	c1 e0 02             	shl    $0x2,%eax
  801e80:	05 44 10 81 00       	add    $0x811044,%eax
  801e85:	8b 00                	mov    (%eax),%eax
  801e87:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801e90:	ff 45 e8             	incl   -0x18(%ebp)
  801e93:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801e9a:	0f 8e 6e ff ff ff    	jle    801e0e <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  801ea0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801ea7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801eab:	74 7d                	je     801f2a <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801ead:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb7:	89 d0                	mov    %edx,%eax
  801eb9:	01 c0                	add    %eax,%eax
  801ebb:	01 d0                	add    %edx,%eax
  801ebd:	c1 e0 02             	shl    $0x2,%eax
  801ec0:	05 40 10 81 00       	add    $0x811040,%eax
  801ec5:	8b 10                	mov    (%eax),%edx
  801ec7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801eca:	01 d0                	add    %edx,%eax
  801ecc:	48                   	dec    %eax
  801ecd:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801ed0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ed3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed8:	f7 75 bc             	divl   -0x44(%ebp)
  801edb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ede:	29 d0                	sub    %edx,%eax
  801ee0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee6:	89 d0                	mov    %edx,%eax
  801ee8:	01 c0                	add    %eax,%eax
  801eea:	01 d0                	add    %edx,%eax
  801eec:	c1 e0 02             	shl    $0x2,%eax
  801eef:	05 48 10 81 00       	add    $0x811048,%eax
  801ef4:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efa:	89 d0                	mov    %edx,%eax
  801efc:	01 c0                	add    %eax,%eax
  801efe:	01 d0                	add    %edx,%eax
  801f00:	c1 e0 02             	shl    $0x2,%eax
  801f03:	05 44 10 81 00       	add    $0x811044,%eax
  801f08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f11:	89 d0                	mov    %edx,%eax
  801f13:	01 c0                	add    %eax,%eax
  801f15:	01 d0                	add    %edx,%eax
  801f17:	c1 e0 02             	shl    $0x2,%eax
  801f1a:	05 40 10 81 00       	add    $0x811040,%eax
  801f1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f25:	e9 2d 01 00 00       	jmp    802057 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  801f2a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f2e:	0f 84 ce 00 00 00    	je     802002 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801f34:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801f3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f3e:	89 d0                	mov    %edx,%eax
  801f40:	01 c0                	add    %eax,%eax
  801f42:	01 d0                	add    %edx,%eax
  801f44:	c1 e0 02             	shl    $0x2,%eax
  801f47:	05 40 10 81 00       	add    $0x811040,%eax
  801f4c:	8b 10                	mov    (%eax),%edx
  801f4e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f51:	01 d0                	add    %edx,%eax
  801f53:	48                   	dec    %eax
  801f54:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801f57:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5f:	f7 75 c4             	divl   -0x3c(%ebp)
  801f62:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801f65:	29 d0                	sub    %edx,%eax
  801f67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801f6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f6d:	89 d0                	mov    %edx,%eax
  801f6f:	01 c0                	add    %eax,%eax
  801f71:	01 d0                	add    %edx,%eax
  801f73:	c1 e0 02             	shl    $0x2,%eax
  801f76:	05 44 10 81 00       	add    $0x811044,%eax
  801f7b:	8b 00                	mov    (%eax),%eax
  801f7d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f80:	75 47                	jne    801fc9 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  801f82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f85:	89 d0                	mov    %edx,%eax
  801f87:	01 c0                	add    %eax,%eax
  801f89:	01 d0                	add    %edx,%eax
  801f8b:	c1 e0 02             	shl    $0x2,%eax
  801f8e:	05 48 10 81 00       	add    $0x811048,%eax
  801f93:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801f96:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f99:	89 d0                	mov    %edx,%eax
  801f9b:	01 c0                	add    %eax,%eax
  801f9d:	01 d0                	add    %edx,%eax
  801f9f:	c1 e0 02             	shl    $0x2,%eax
  801fa2:	05 44 10 81 00       	add    $0x811044,%eax
  801fa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801fad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fb0:	89 d0                	mov    %edx,%eax
  801fb2:	01 c0                	add    %eax,%eax
  801fb4:	01 d0                	add    %edx,%eax
  801fb6:	c1 e0 02             	shl    $0x2,%eax
  801fb9:	05 40 10 81 00       	add    $0x811040,%eax
  801fbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fc4:	e9 8e 00 00 00       	jmp    802057 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801fc9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fcf:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801fd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd5:	89 d0                	mov    %edx,%eax
  801fd7:	01 c0                	add    %eax,%eax
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	c1 e0 02             	shl    $0x2,%eax
  801fde:	05 40 10 81 00       	add    $0x811040,%eax
  801fe3:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801fe5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe8:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801feb:	89 c2                	mov    %eax,%edx
  801fed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ff0:	89 c8                	mov    %ecx,%eax
  801ff2:	01 c0                	add    %eax,%eax
  801ff4:	01 c8                	add    %ecx,%eax
  801ff6:	c1 e0 02             	shl    $0x2,%eax
  801ff9:	05 44 10 81 00       	add    $0x811044,%eax
  801ffe:	89 10                	mov    %edx,(%eax)
  802000:	eb 55                	jmp    802057 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802002:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802009:	8b 15 88 50 83 00    	mov    0x835088,%edx
  80200f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802012:	01 d0                	add    %edx,%eax
  802014:	48                   	dec    %eax
  802015:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802018:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80201b:	ba 00 00 00 00       	mov    $0x0,%edx
  802020:	f7 75 d0             	divl   -0x30(%ebp)
  802023:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802026:	29 d0                	sub    %edx,%eax
  802028:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  80202b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80202e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802031:	01 d0                	add    %edx,%eax
  802033:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802038:	76 0a                	jbe    802044 <smalloc+0x29e>
            return NULL;
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	e9 ba 00 00 00       	jmp    8020fe <smalloc+0x358>
        va = start;
  802044:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802047:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80204a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80204d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802050:	01 d0                	add    %edx,%eax
  802052:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802057:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80205e:	eb 5e                	jmp    8020be <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  802060:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802063:	89 d0                	mov    %edx,%eax
  802065:	01 c0                	add    %eax,%eax
  802067:	01 d0                	add    %edx,%eax
  802069:	c1 e0 02             	shl    $0x2,%eax
  80206c:	05 48 50 80 00       	add    $0x805048,%eax
  802071:	8a 00                	mov    (%eax),%al
  802073:	84 c0                	test   %al,%al
  802075:	75 44                	jne    8020bb <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802077:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80207a:	89 d0                	mov    %edx,%eax
  80207c:	01 c0                	add    %eax,%eax
  80207e:	01 d0                	add    %edx,%eax
  802080:	c1 e0 02             	shl    $0x2,%eax
  802083:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  802089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80208c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80208e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802091:	89 d0                	mov    %edx,%eax
  802093:	01 c0                	add    %eax,%eax
  802095:	01 d0                	add    %edx,%eax
  802097:	c1 e0 02             	shl    $0x2,%eax
  80209a:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  8020a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020a3:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8020a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020a8:	89 d0                	mov    %edx,%eax
  8020aa:	01 c0                	add    %eax,%eax
  8020ac:	01 d0                	add    %edx,%eax
  8020ae:	c1 e0 02             	shl    $0x2,%eax
  8020b1:	05 48 50 80 00       	add    $0x805048,%eax
  8020b6:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8020b9:	eb 0c                	jmp    8020c7 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8020bb:	ff 45 e0             	incl   -0x20(%ebp)
  8020be:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8020c5:	7e 99                	jle    802060 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  8020c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8020ca:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8020ce:	52                   	push   %edx
  8020cf:	50                   	push   %eax
  8020d0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8020d3:	ff 75 08             	pushl  0x8(%ebp)
  8020d6:	e8 de 0e 00 00       	call   802fb9 <sys_create_shared_object>
  8020db:	83 c4 10             	add    $0x10,%esp
  8020de:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8020e1:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8020e5:	75 07                	jne    8020ee <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8020e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020ec:	eb 10                	jmp    8020fe <smalloc+0x358>
    if (r < 0)
  8020ee:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8020f2:	79 07                	jns    8020fb <smalloc+0x355>
        return NULL;
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f9:	eb 03                	jmp    8020fe <smalloc+0x358>
    return (void*)va;
  8020fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802106:	e8 51 f4 ff ff       	call   80155c <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80210b:	83 ec 08             	sub    $0x8,%esp
  80210e:	ff 75 0c             	pushl  0xc(%ebp)
  802111:	ff 75 08             	pushl  0x8(%ebp)
  802114:	e8 ca 0e 00 00       	call   802fe3 <sys_size_of_shared_object>
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  80211f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802123:	7f 0a                	jg     80212f <sget+0x2f>
        return NULL;
  802125:	b8 00 00 00 00       	mov    $0x0,%eax
  80212a:	e9 28 03 00 00       	jmp    802457 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  80212f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802136:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802139:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80213c:	01 d0                	add    %edx,%eax
  80213e:	48                   	dec    %eax
  80213f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802142:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802145:	ba 00 00 00 00       	mov    $0x0,%edx
  80214a:	f7 75 d8             	divl   -0x28(%ebp)
  80214d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802150:	29 d0                	sub    %edx,%eax
  802152:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  802155:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80215c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802163:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80216a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802171:	e9 85 00 00 00       	jmp    8021fb <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802176:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802179:	89 d0                	mov    %edx,%eax
  80217b:	01 c0                	add    %eax,%eax
  80217d:	01 d0                	add    %edx,%eax
  80217f:	c1 e0 02             	shl    $0x2,%eax
  802182:	05 48 10 81 00       	add    $0x811048,%eax
  802187:	8a 00                	mov    (%eax),%al
  802189:	84 c0                	test   %al,%al
  80218b:	74 20                	je     8021ad <sget+0xad>
  80218d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802190:	89 d0                	mov    %edx,%eax
  802192:	01 c0                	add    %eax,%eax
  802194:	01 d0                	add    %edx,%eax
  802196:	c1 e0 02             	shl    $0x2,%eax
  802199:	05 44 10 81 00       	add    $0x811044,%eax
  80219e:	8b 00                	mov    (%eax),%eax
  8021a0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8021a3:	75 08                	jne    8021ad <sget+0xad>
        {
            exactIdx = i;
  8021a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8021ab:	eb 5b                	jmp    802208 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8021ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021b0:	89 d0                	mov    %edx,%eax
  8021b2:	01 c0                	add    %eax,%eax
  8021b4:	01 d0                	add    %edx,%eax
  8021b6:	c1 e0 02             	shl    $0x2,%eax
  8021b9:	05 48 10 81 00       	add    $0x811048,%eax
  8021be:	8a 00                	mov    (%eax),%al
  8021c0:	84 c0                	test   %al,%al
  8021c2:	74 34                	je     8021f8 <sget+0xf8>
  8021c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021c7:	89 d0                	mov    %edx,%eax
  8021c9:	01 c0                	add    %eax,%eax
  8021cb:	01 d0                	add    %edx,%eax
  8021cd:	c1 e0 02             	shl    $0x2,%eax
  8021d0:	05 44 10 81 00       	add    $0x811044,%eax
  8021d5:	8b 00                	mov    (%eax),%eax
  8021d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021da:	76 1c                	jbe    8021f8 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8021dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021df:	89 d0                	mov    %edx,%eax
  8021e1:	01 c0                	add    %eax,%eax
  8021e3:	01 d0                	add    %edx,%eax
  8021e5:	c1 e0 02             	shl    $0x2,%eax
  8021e8:	05 44 10 81 00       	add    $0x811044,%eax
  8021ed:	8b 00                	mov    (%eax),%eax
  8021ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8021f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8021f8:	ff 45 e8             	incl   -0x18(%ebp)
  8021fb:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802202:	0f 8e 6e ff ff ff    	jle    802176 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802208:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80220f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802213:	74 7d                	je     802292 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802215:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80221c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221f:	89 d0                	mov    %edx,%eax
  802221:	01 c0                	add    %eax,%eax
  802223:	01 d0                	add    %edx,%eax
  802225:	c1 e0 02             	shl    $0x2,%eax
  802228:	05 40 10 81 00       	add    $0x811040,%eax
  80222d:	8b 10                	mov    (%eax),%edx
  80222f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802232:	01 d0                	add    %edx,%eax
  802234:	48                   	dec    %eax
  802235:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802238:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80223b:	ba 00 00 00 00       	mov    $0x0,%edx
  802240:	f7 75 b8             	divl   -0x48(%ebp)
  802243:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802246:	29 d0                	sub    %edx,%eax
  802248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80224b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224e:	89 d0                	mov    %edx,%eax
  802250:	01 c0                	add    %eax,%eax
  802252:	01 d0                	add    %edx,%eax
  802254:	c1 e0 02             	shl    $0x2,%eax
  802257:	05 48 10 81 00       	add    $0x811048,%eax
  80225c:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80225f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802262:	89 d0                	mov    %edx,%eax
  802264:	01 c0                	add    %eax,%eax
  802266:	01 d0                	add    %edx,%eax
  802268:	c1 e0 02             	shl    $0x2,%eax
  80226b:	05 44 10 81 00       	add    $0x811044,%eax
  802270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802276:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802279:	89 d0                	mov    %edx,%eax
  80227b:	01 c0                	add    %eax,%eax
  80227d:	01 d0                	add    %edx,%eax
  80227f:	c1 e0 02             	shl    $0x2,%eax
  802282:	05 40 10 81 00       	add    $0x811040,%eax
  802287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80228d:	e9 2d 01 00 00       	jmp    8023bf <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802292:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802296:	0f 84 ce 00 00 00    	je     80236a <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80229c:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  8022a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022a6:	89 d0                	mov    %edx,%eax
  8022a8:	01 c0                	add    %eax,%eax
  8022aa:	01 d0                	add    %edx,%eax
  8022ac:	c1 e0 02             	shl    $0x2,%eax
  8022af:	05 40 10 81 00       	add    $0x811040,%eax
  8022b4:	8b 10                	mov    (%eax),%edx
  8022b6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	48                   	dec    %eax
  8022bc:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8022bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c7:	f7 75 c0             	divl   -0x40(%ebp)
  8022ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022cd:	29 d0                	sub    %edx,%eax
  8022cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8022d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d5:	89 d0                	mov    %edx,%eax
  8022d7:	01 c0                	add    %eax,%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	c1 e0 02             	shl    $0x2,%eax
  8022de:	05 44 10 81 00       	add    $0x811044,%eax
  8022e3:	8b 00                	mov    (%eax),%eax
  8022e5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8022e8:	75 47                	jne    802331 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8022ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ed:	89 d0                	mov    %edx,%eax
  8022ef:	01 c0                	add    %eax,%eax
  8022f1:	01 d0                	add    %edx,%eax
  8022f3:	c1 e0 02             	shl    $0x2,%eax
  8022f6:	05 48 10 81 00       	add    $0x811048,%eax
  8022fb:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8022fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802301:	89 d0                	mov    %edx,%eax
  802303:	01 c0                	add    %eax,%eax
  802305:	01 d0                	add    %edx,%eax
  802307:	c1 e0 02             	shl    $0x2,%eax
  80230a:	05 44 10 81 00       	add    $0x811044,%eax
  80230f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802315:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802318:	89 d0                	mov    %edx,%eax
  80231a:	01 c0                	add    %eax,%eax
  80231c:	01 d0                	add    %edx,%eax
  80231e:	c1 e0 02             	shl    $0x2,%eax
  802321:	05 40 10 81 00       	add    $0x811040,%eax
  802326:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80232c:	e9 8e 00 00 00       	jmp    8023bf <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802331:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802334:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802337:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80233a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233d:	89 d0                	mov    %edx,%eax
  80233f:	01 c0                	add    %eax,%eax
  802341:	01 d0                	add    %edx,%eax
  802343:	c1 e0 02             	shl    $0x2,%eax
  802346:	05 40 10 81 00       	add    $0x811040,%eax
  80234b:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80234d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802350:	2b 45 d0             	sub    -0x30(%ebp),%eax
  802353:	89 c2                	mov    %eax,%edx
  802355:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802358:	89 c8                	mov    %ecx,%eax
  80235a:	01 c0                	add    %eax,%eax
  80235c:	01 c8                	add    %ecx,%eax
  80235e:	c1 e0 02             	shl    $0x2,%eax
  802361:	05 44 10 81 00       	add    $0x811044,%eax
  802366:	89 10                	mov    %edx,(%eax)
  802368:	eb 55                	jmp    8023bf <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80236a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802371:	8b 15 88 50 83 00    	mov    0x835088,%edx
  802377:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80237a:	01 d0                	add    %edx,%eax
  80237c:	48                   	dec    %eax
  80237d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802380:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802383:	ba 00 00 00 00       	mov    $0x0,%edx
  802388:	f7 75 cc             	divl   -0x34(%ebp)
  80238b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80238e:	29 d0                	sub    %edx,%eax
  802390:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802393:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802396:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802399:	01 d0                	add    %edx,%eax
  80239b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8023a0:	76 0a                	jbe    8023ac <sget+0x2ac>
            return NULL;
  8023a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a7:	e9 ab 00 00 00       	jmp    802457 <sget+0x357>
        va = start;
  8023ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8023af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8023b2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8023b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023b8:	01 d0                	add    %edx,%eax
  8023ba:	a3 88 50 83 00       	mov    %eax,0x835088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8023bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8023c6:	eb 5e                	jmp    802426 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  8023c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023cb:	89 d0                	mov    %edx,%eax
  8023cd:	01 c0                	add    %eax,%eax
  8023cf:	01 d0                	add    %edx,%eax
  8023d1:	c1 e0 02             	shl    $0x2,%eax
  8023d4:	05 48 50 80 00       	add    $0x805048,%eax
  8023d9:	8a 00                	mov    (%eax),%al
  8023db:	84 c0                	test   %al,%al
  8023dd:	75 44                	jne    802423 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8023df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023e2:	89 d0                	mov    %edx,%eax
  8023e4:	01 c0                	add    %eax,%eax
  8023e6:	01 d0                	add    %edx,%eax
  8023e8:	c1 e0 02             	shl    $0x2,%eax
  8023eb:	8d 90 40 50 80 00    	lea    0x805040(%eax),%edx
  8023f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f4:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8023f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023f9:	89 d0                	mov    %edx,%eax
  8023fb:	01 c0                	add    %eax,%eax
  8023fd:	01 d0                	add    %edx,%eax
  8023ff:	c1 e0 02             	shl    $0x2,%eax
  802402:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802408:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80240b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80240d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802410:	89 d0                	mov    %edx,%eax
  802412:	01 c0                	add    %eax,%eax
  802414:	01 d0                	add    %edx,%eax
  802416:	c1 e0 02             	shl    $0x2,%eax
  802419:	05 48 50 80 00       	add    $0x805048,%eax
  80241e:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802421:	eb 0c                	jmp    80242f <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802423:	ff 45 e0             	incl   -0x20(%ebp)
  802426:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80242d:	7e 99                	jle    8023c8 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  80242f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802432:	83 ec 04             	sub    $0x4,%esp
  802435:	50                   	push   %eax
  802436:	ff 75 0c             	pushl  0xc(%ebp)
  802439:	ff 75 08             	pushl  0x8(%ebp)
  80243c:	e8 bf 0b 00 00       	call   803000 <sys_get_shared_object>
  802441:	83 c4 10             	add    $0x10,%esp
  802444:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  802447:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80244b:	79 07                	jns    802454 <sget+0x354>
        return NULL;
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
  802452:	eb 03                	jmp    802457 <sget+0x357>
    return (void*)va;
  802454:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80245f:	e8 f8 f0 ff ff       	call   80155c <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  802464:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802468:	75 13                	jne    80247d <realloc+0x24>
		return malloc(new_size);
  80246a:	83 ec 0c             	sub    $0xc,%esp
  80246d:	ff 75 0c             	pushl  0xc(%ebp)
  802470:	e8 c4 f1 ff ff       	call   801639 <malloc>
  802475:	83 c4 10             	add    $0x10,%esp
  802478:	e9 f4 05 00 00       	jmp    802a71 <realloc+0x618>
	if (new_size == 0)
  80247d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802481:	75 18                	jne    80249b <realloc+0x42>
	{
		free(virtual_address);
  802483:	83 ec 0c             	sub    $0xc,%esp
  802486:	ff 75 08             	pushl  0x8(%ebp)
  802489:	e8 0b f5 ff ff       	call   801999 <free>
  80248e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802491:	b8 00 00 00 00       	mov    $0x0,%eax
  802496:	e9 d6 05 00 00       	jmp    802a71 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  8024a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024a4:	85 c0                	test   %eax,%eax
  8024a6:	79 74                	jns    80251c <realloc+0xc3>
  8024a8:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  8024af:	77 6b                	ja     80251c <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  8024b1:	83 ec 0c             	sub    $0xc,%esp
  8024b4:	ff 75 0c             	pushl  0xc(%ebp)
  8024b7:	e8 7d f1 ff ff       	call   801639 <malloc>
  8024bc:	83 c4 10             	add    $0x10,%esp
  8024bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  8024c2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8024c6:	75 0a                	jne    8024d2 <realloc+0x79>
			return NULL;
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	e9 9f 05 00 00       	jmp    802a71 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8024d2:	83 ec 0c             	sub    $0xc,%esp
  8024d5:	ff 75 08             	pushl  0x8(%ebp)
  8024d8:	e8 e0 11 00 00       	call   8036bd <get_block_size>
  8024dd:	83 c4 10             	add    $0x10,%esp
  8024e0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8024e3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8024e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e9:	39 d0                	cmp    %edx,%eax
  8024eb:	76 02                	jbe    8024ef <realloc+0x96>
  8024ed:	89 d0                	mov    %edx,%eax
  8024ef:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8024f2:	83 ec 04             	sub    $0x4,%esp
  8024f5:	ff 75 c0             	pushl  -0x40(%ebp)
  8024f8:	ff 75 08             	pushl  0x8(%ebp)
  8024fb:	ff 75 c8             	pushl  -0x38(%ebp)
  8024fe:	e8 56 eb ff ff       	call   801059 <memmove>
  802503:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802506:	83 ec 0c             	sub    $0xc,%esp
  802509:	ff 75 08             	pushl  0x8(%ebp)
  80250c:	e8 88 f4 ff ff       	call   801999 <free>
  802511:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802514:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802517:	e9 55 05 00 00       	jmp    802a71 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80251c:	a1 30 51 83 00       	mov    0x835130,%eax
  802521:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802524:	72 09                	jb     80252f <realloc+0xd6>
  802526:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  80252d:	76 0a                	jbe    802539 <realloc+0xe0>
		return NULL;
  80252f:	b8 00 00 00 00       	mov    $0x0,%eax
  802534:	e9 38 05 00 00       	jmp    802a71 <realloc+0x618>
	uint32 oldsz = 0;
  802539:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802540:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802547:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80254e:	eb 50                	jmp    8025a0 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802550:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802553:	89 d0                	mov    %edx,%eax
  802555:	01 c0                	add    %eax,%eax
  802557:	01 d0                	add    %edx,%eax
  802559:	c1 e0 02             	shl    $0x2,%eax
  80255c:	05 48 50 80 00       	add    $0x805048,%eax
  802561:	8a 00                	mov    (%eax),%al
  802563:	84 c0                	test   %al,%al
  802565:	74 36                	je     80259d <realloc+0x144>
  802567:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80256a:	89 d0                	mov    %edx,%eax
  80256c:	01 c0                	add    %eax,%eax
  80256e:	01 d0                	add    %edx,%eax
  802570:	c1 e0 02             	shl    $0x2,%eax
  802573:	05 40 50 80 00       	add    $0x805040,%eax
  802578:	8b 00                	mov    (%eax),%eax
  80257a:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80257d:	75 1e                	jne    80259d <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  80257f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802582:	89 d0                	mov    %edx,%eax
  802584:	01 c0                	add    %eax,%eax
  802586:	01 d0                	add    %edx,%eax
  802588:	c1 e0 02             	shl    $0x2,%eax
  80258b:	05 44 50 80 00       	add    $0x805044,%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802598:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80259b:	eb 0c                	jmp    8025a9 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80259d:	ff 45 ec             	incl   -0x14(%ebp)
  8025a0:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8025a7:	7e a7                	jle    802550 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  8025a9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8025ad:	75 0a                	jne    8025b9 <realloc+0x160>
		return NULL;
  8025af:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b4:	e9 b8 04 00 00       	jmp    802a71 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  8025b9:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8025c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025c6:	01 d0                	add    %edx,%eax
  8025c8:	48                   	dec    %eax
  8025c9:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8025cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8025cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d4:	f7 75 bc             	divl   -0x44(%ebp)
  8025d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8025da:	29 d0                	sub    %edx,%eax
  8025dc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8025df:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8025e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025e5:	75 08                	jne    8025ef <realloc+0x196>
		return virtual_address;
  8025e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ea:	e9 82 04 00 00       	jmp    802a71 <realloc+0x618>
	if (req < oldsz)
  8025ef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8025f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025f5:	0f 83 cd 02 00 00    	jae    8028c8 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802601:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802604:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802607:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80260a:	01 d0                	add    %edx,%eax
  80260c:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  80260f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802612:	89 d0                	mov    %edx,%eax
  802614:	01 c0                	add    %eax,%eax
  802616:	01 d0                	add    %edx,%eax
  802618:	c1 e0 02             	shl    $0x2,%eax
  80261b:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802621:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802624:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802626:	83 ec 08             	sub    $0x8,%esp
  802629:	ff 75 b0             	pushl  -0x50(%ebp)
  80262c:	ff 75 ac             	pushl  -0x54(%ebp)
  80262f:	e8 e3 0c 00 00       	call   803317 <sys_free_user_mem>
  802634:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802637:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80263e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802645:	eb 64                	jmp    8026ab <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802647:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80264a:	89 d0                	mov    %edx,%eax
  80264c:	01 c0                	add    %eax,%eax
  80264e:	01 d0                	add    %edx,%eax
  802650:	c1 e0 02             	shl    $0x2,%eax
  802653:	05 48 10 81 00       	add    $0x811048,%eax
  802658:	8a 00                	mov    (%eax),%al
  80265a:	84 c0                	test   %al,%al
  80265c:	75 4a                	jne    8026a8 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  80265e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802661:	89 d0                	mov    %edx,%eax
  802663:	01 c0                	add    %eax,%eax
  802665:	01 d0                	add    %edx,%eax
  802667:	c1 e0 02             	shl    $0x2,%eax
  80266a:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802670:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802673:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802675:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802678:	89 d0                	mov    %edx,%eax
  80267a:	01 c0                	add    %eax,%eax
  80267c:	01 d0                	add    %edx,%eax
  80267e:	c1 e0 02             	shl    $0x2,%eax
  802681:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802687:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80268a:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  80268c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80268f:	89 d0                	mov    %edx,%eax
  802691:	01 c0                	add    %eax,%eax
  802693:	01 d0                	add    %edx,%eax
  802695:	c1 e0 02             	shl    $0x2,%eax
  802698:	05 48 10 81 00       	add    $0x811048,%eax
  80269d:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  8026a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  8026a6:	eb 0c                	jmp    8026b4 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8026a8:	ff 45 e4             	incl   -0x1c(%ebp)
  8026ab:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8026b2:	7e 93                	jle    802647 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  8026b4:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8026b8:	0f 84 8d 01 00 00    	je     80284b <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8026be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8026c5:	e9 74 01 00 00       	jmp    80283e <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8026ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026cd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026d0:	0f 84 64 01 00 00    	je     80283a <realloc+0x3e1>
				if (uhp_frees[k].free)
  8026d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026d9:	89 d0                	mov    %edx,%eax
  8026db:	01 c0                	add    %eax,%eax
  8026dd:	01 d0                	add    %edx,%eax
  8026df:	c1 e0 02             	shl    $0x2,%eax
  8026e2:	05 48 10 81 00       	add    $0x811048,%eax
  8026e7:	8a 00                	mov    (%eax),%al
  8026e9:	84 c0                	test   %al,%al
  8026eb:	0f 84 4a 01 00 00    	je     80283b <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8026f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026f4:	89 d0                	mov    %edx,%eax
  8026f6:	01 c0                	add    %eax,%eax
  8026f8:	01 d0                	add    %edx,%eax
  8026fa:	c1 e0 02             	shl    $0x2,%eax
  8026fd:	05 40 10 81 00       	add    $0x811040,%eax
  802702:	8b 08                	mov    (%eax),%ecx
  802704:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802707:	89 d0                	mov    %edx,%eax
  802709:	01 c0                	add    %eax,%eax
  80270b:	01 d0                	add    %edx,%eax
  80270d:	c1 e0 02             	shl    $0x2,%eax
  802710:	05 44 10 81 00       	add    $0x811044,%eax
  802715:	8b 00                	mov    (%eax),%eax
  802717:	01 c1                	add    %eax,%ecx
  802719:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80271c:	89 d0                	mov    %edx,%eax
  80271e:	01 c0                	add    %eax,%eax
  802720:	01 d0                	add    %edx,%eax
  802722:	c1 e0 02             	shl    $0x2,%eax
  802725:	05 40 10 81 00       	add    $0x811040,%eax
  80272a:	8b 00                	mov    (%eax),%eax
  80272c:	39 c1                	cmp    %eax,%ecx
  80272e:	75 7a                	jne    8027aa <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802730:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802733:	89 d0                	mov    %edx,%eax
  802735:	01 c0                	add    %eax,%eax
  802737:	01 d0                	add    %edx,%eax
  802739:	c1 e0 02             	shl    $0x2,%eax
  80273c:	05 40 10 81 00       	add    $0x811040,%eax
  802741:	8b 10                	mov    (%eax),%edx
  802743:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802746:	89 c8                	mov    %ecx,%eax
  802748:	01 c0                	add    %eax,%eax
  80274a:	01 c8                	add    %ecx,%eax
  80274c:	c1 e0 02             	shl    $0x2,%eax
  80274f:	05 40 10 81 00       	add    $0x811040,%eax
  802754:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802756:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802759:	89 d0                	mov    %edx,%eax
  80275b:	01 c0                	add    %eax,%eax
  80275d:	01 d0                	add    %edx,%eax
  80275f:	c1 e0 02             	shl    $0x2,%eax
  802762:	05 44 10 81 00       	add    $0x811044,%eax
  802767:	8b 08                	mov    (%eax),%ecx
  802769:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80276c:	89 d0                	mov    %edx,%eax
  80276e:	01 c0                	add    %eax,%eax
  802770:	01 d0                	add    %edx,%eax
  802772:	c1 e0 02             	shl    $0x2,%eax
  802775:	05 44 10 81 00       	add    $0x811044,%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	01 c1                	add    %eax,%ecx
  80277e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802781:	89 d0                	mov    %edx,%eax
  802783:	01 c0                	add    %eax,%eax
  802785:	01 d0                	add    %edx,%eax
  802787:	c1 e0 02             	shl    $0x2,%eax
  80278a:	05 44 10 81 00       	add    $0x811044,%eax
  80278f:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802791:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802794:	89 d0                	mov    %edx,%eax
  802796:	01 c0                	add    %eax,%eax
  802798:	01 d0                	add    %edx,%eax
  80279a:	c1 e0 02             	shl    $0x2,%eax
  80279d:	05 48 10 81 00       	add    $0x811048,%eax
  8027a2:	c6 00 00             	movb   $0x0,(%eax)
  8027a5:	e9 91 00 00 00       	jmp    80283b <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  8027aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ad:	89 d0                	mov    %edx,%eax
  8027af:	01 c0                	add    %eax,%eax
  8027b1:	01 d0                	add    %edx,%eax
  8027b3:	c1 e0 02             	shl    $0x2,%eax
  8027b6:	05 40 10 81 00       	add    $0x811040,%eax
  8027bb:	8b 08                	mov    (%eax),%ecx
  8027bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027c0:	89 d0                	mov    %edx,%eax
  8027c2:	01 c0                	add    %eax,%eax
  8027c4:	01 d0                	add    %edx,%eax
  8027c6:	c1 e0 02             	shl    $0x2,%eax
  8027c9:	05 44 10 81 00       	add    $0x811044,%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	01 c1                	add    %eax,%ecx
  8027d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027d5:	89 d0                	mov    %edx,%eax
  8027d7:	01 c0                	add    %eax,%eax
  8027d9:	01 d0                	add    %edx,%eax
  8027db:	c1 e0 02             	shl    $0x2,%eax
  8027de:	05 40 10 81 00       	add    $0x811040,%eax
  8027e3:	8b 00                	mov    (%eax),%eax
  8027e5:	39 c1                	cmp    %eax,%ecx
  8027e7:	75 52                	jne    80283b <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8027e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ec:	89 d0                	mov    %edx,%eax
  8027ee:	01 c0                	add    %eax,%eax
  8027f0:	01 d0                	add    %edx,%eax
  8027f2:	c1 e0 02             	shl    $0x2,%eax
  8027f5:	05 44 10 81 00       	add    $0x811044,%eax
  8027fa:	8b 08                	mov    (%eax),%ecx
  8027fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027ff:	89 d0                	mov    %edx,%eax
  802801:	01 c0                	add    %eax,%eax
  802803:	01 d0                	add    %edx,%eax
  802805:	c1 e0 02             	shl    $0x2,%eax
  802808:	05 44 10 81 00       	add    $0x811044,%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	01 c1                	add    %eax,%ecx
  802811:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802814:	89 d0                	mov    %edx,%eax
  802816:	01 c0                	add    %eax,%eax
  802818:	01 d0                	add    %edx,%eax
  80281a:	c1 e0 02             	shl    $0x2,%eax
  80281d:	05 44 10 81 00       	add    $0x811044,%eax
  802822:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802824:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802827:	89 d0                	mov    %edx,%eax
  802829:	01 c0                	add    %eax,%eax
  80282b:	01 d0                	add    %edx,%eax
  80282d:	c1 e0 02             	shl    $0x2,%eax
  802830:	05 48 10 81 00       	add    $0x811048,%eax
  802835:	c6 00 00             	movb   $0x0,(%eax)
  802838:	eb 01                	jmp    80283b <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  80283a:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80283b:	ff 45 e0             	incl   -0x20(%ebp)
  80283e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802845:	0f 8e 7f fe ff ff    	jle    8026ca <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  80284b:	a1 30 51 83 00       	mov    0x835130,%eax
  802850:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802853:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80285a:	eb 53                	jmp    8028af <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  80285c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80285f:	89 d0                	mov    %edx,%eax
  802861:	01 c0                	add    %eax,%eax
  802863:	01 d0                	add    %edx,%eax
  802865:	c1 e0 02             	shl    $0x2,%eax
  802868:	05 48 50 80 00       	add    $0x805048,%eax
  80286d:	8a 00                	mov    (%eax),%al
  80286f:	84 c0                	test   %al,%al
  802871:	74 39                	je     8028ac <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802873:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802876:	89 d0                	mov    %edx,%eax
  802878:	01 c0                	add    %eax,%eax
  80287a:	01 d0                	add    %edx,%eax
  80287c:	c1 e0 02             	shl    $0x2,%eax
  80287f:	05 40 50 80 00       	add    $0x805040,%eax
  802884:	8b 08                	mov    (%eax),%ecx
  802886:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802889:	89 d0                	mov    %edx,%eax
  80288b:	01 c0                	add    %eax,%eax
  80288d:	01 d0                	add    %edx,%eax
  80288f:	c1 e0 02             	shl    $0x2,%eax
  802892:	05 44 50 80 00       	add    $0x805044,%eax
  802897:	8b 00                	mov    (%eax),%eax
  802899:	01 c8                	add    %ecx,%eax
  80289b:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  80289e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028a1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8028a4:	76 06                	jbe    8028ac <realloc+0x453>
  8028a6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8028ac:	ff 45 d8             	incl   -0x28(%ebp)
  8028af:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  8028b6:	7e a4                	jle    80285c <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  8028b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028bb:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  8028c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c3:	e9 a9 01 00 00       	jmp    802a71 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  8028c8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	01 d0                	add    %edx,%eax
  8028d0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8028d3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8028da:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8028e1:	eb 57                	jmp    80293a <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8028e3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028e6:	89 d0                	mov    %edx,%eax
  8028e8:	01 c0                	add    %eax,%eax
  8028ea:	01 d0                	add    %edx,%eax
  8028ec:	c1 e0 02             	shl    $0x2,%eax
  8028ef:	05 48 10 81 00       	add    $0x811048,%eax
  8028f4:	8a 00                	mov    (%eax),%al
  8028f6:	84 c0                	test   %al,%al
  8028f8:	74 3d                	je     802937 <realloc+0x4de>
  8028fa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8028fd:	89 d0                	mov    %edx,%eax
  8028ff:	01 c0                	add    %eax,%eax
  802901:	01 d0                	add    %edx,%eax
  802903:	c1 e0 02             	shl    $0x2,%eax
  802906:	05 40 10 81 00       	add    $0x811040,%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802910:	75 25                	jne    802937 <realloc+0x4de>
  802912:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802915:	89 d0                	mov    %edx,%eax
  802917:	01 c0                	add    %eax,%eax
  802919:	01 d0                	add    %edx,%eax
  80291b:	c1 e0 02             	shl    $0x2,%eax
  80291e:	05 44 10 81 00       	add    $0x811044,%eax
  802923:	8b 10                	mov    (%eax),%edx
  802925:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802928:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80292b:	39 c2                	cmp    %eax,%edx
  80292d:	72 08                	jb     802937 <realloc+0x4de>
		{
			adjIdx = j; break;
  80292f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802932:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802935:	eb 0c                	jmp    802943 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802937:	ff 45 d0             	incl   -0x30(%ebp)
  80293a:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802941:	7e a0                	jle    8028e3 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802943:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802947:	0f 84 d6 00 00 00    	je     802a23 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  80294d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802950:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802953:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802956:	83 ec 08             	sub    $0x8,%esp
  802959:	ff 75 a0             	pushl  -0x60(%ebp)
  80295c:	ff 75 a4             	pushl  -0x5c(%ebp)
  80295f:	e8 cf 09 00 00       	call   803333 <sys_allocate_user_mem>
  802964:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802967:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80296a:	89 d0                	mov    %edx,%eax
  80296c:	01 c0                	add    %eax,%eax
  80296e:	01 d0                	add    %edx,%eax
  802970:	c1 e0 02             	shl    $0x2,%eax
  802973:	8d 90 44 50 80 00    	lea    0x805044(%eax),%edx
  802979:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80297c:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  80297e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802981:	89 d0                	mov    %edx,%eax
  802983:	01 c0                	add    %eax,%eax
  802985:	01 d0                	add    %edx,%eax
  802987:	c1 e0 02             	shl    $0x2,%eax
  80298a:	05 40 10 81 00       	add    $0x811040,%eax
  80298f:	8b 10                	mov    (%eax),%edx
  802991:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802994:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802997:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80299a:	89 d0                	mov    %edx,%eax
  80299c:	01 c0                	add    %eax,%eax
  80299e:	01 d0                	add    %edx,%eax
  8029a0:	c1 e0 02             	shl    $0x2,%eax
  8029a3:	05 40 10 81 00       	add    $0x811040,%eax
  8029a8:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  8029aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029ad:	89 d0                	mov    %edx,%eax
  8029af:	01 c0                	add    %eax,%eax
  8029b1:	01 d0                	add    %edx,%eax
  8029b3:	c1 e0 02             	shl    $0x2,%eax
  8029b6:	05 44 10 81 00       	add    $0x811044,%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	2b 45 a0             	sub    -0x60(%ebp),%eax
  8029c0:	89 c2                	mov    %eax,%edx
  8029c2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8029c5:	89 c8                	mov    %ecx,%eax
  8029c7:	01 c0                	add    %eax,%eax
  8029c9:	01 c8                	add    %ecx,%eax
  8029cb:	c1 e0 02             	shl    $0x2,%eax
  8029ce:	05 44 10 81 00       	add    $0x811044,%eax
  8029d3:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  8029d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029d8:	89 d0                	mov    %edx,%eax
  8029da:	01 c0                	add    %eax,%eax
  8029dc:	01 d0                	add    %edx,%eax
  8029de:	c1 e0 02             	shl    $0x2,%eax
  8029e1:	05 44 10 81 00       	add    $0x811044,%eax
  8029e6:	8b 00                	mov    (%eax),%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	75 14                	jne    802a00 <realloc+0x5a7>
  8029ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029ef:	89 d0                	mov    %edx,%eax
  8029f1:	01 c0                	add    %eax,%eax
  8029f3:	01 d0                	add    %edx,%eax
  8029f5:	c1 e0 02             	shl    $0x2,%eax
  8029f8:	05 48 10 81 00       	add    $0x811048,%eax
  8029fd:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802a00:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a06:	01 c2                	add    %eax,%edx
  802a08:	a1 88 50 83 00       	mov    0x835088,%eax
  802a0d:	39 c2                	cmp    %eax,%edx
  802a0f:	76 0d                	jbe    802a1e <realloc+0x5c5>
  802a11:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a14:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a17:	01 d0                	add    %edx,%eax
  802a19:	a3 88 50 83 00       	mov    %eax,0x835088
		return virtual_address;
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	eb 4e                	jmp    802a71 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802a23:	83 ec 0c             	sub    $0xc,%esp
  802a26:	ff 75 0c             	pushl  0xc(%ebp)
  802a29:	e8 0b ec ff ff       	call   801639 <malloc>
  802a2e:	83 c4 10             	add    $0x10,%esp
  802a31:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802a34:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802a38:	75 07                	jne    802a41 <realloc+0x5e8>
		return NULL;
  802a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3f:	eb 30                	jmp    802a71 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a44:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a47:	39 d0                	cmp    %edx,%eax
  802a49:	76 02                	jbe    802a4d <realloc+0x5f4>
  802a4b:	89 d0                	mov    %edx,%eax
  802a4d:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802a50:	83 ec 04             	sub    $0x4,%esp
  802a53:	50                   	push   %eax
  802a54:	52                   	push   %edx
  802a55:	ff 75 cc             	pushl  -0x34(%ebp)
  802a58:	e8 cf 06 00 00       	call   80312c <sys_move_user_mem>
  802a5d:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802a60:	83 ec 0c             	sub    $0xc,%esp
  802a63:	ff 75 08             	pushl  0x8(%ebp)
  802a66:	e8 2e ef ff ff       	call   801999 <free>
  802a6b:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802a6e:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802a71:	c9                   	leave  
  802a72:	c3                   	ret    

00802a73 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
  802a76:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802a79:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802a7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a83:	0f 84 33 03 00 00    	je     802dbc <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802a89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a8c:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802a94:	83 ec 08             	sub    $0x8,%esp
  802a97:	ff 75 08             	pushl  0x8(%ebp)
  802a9a:	ff 75 d8             	pushl  -0x28(%ebp)
  802a9d:	e8 7d 05 00 00       	call   80301f <sys_delete_shared_object>
  802aa2:	83 c4 10             	add    $0x10,%esp
  802aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802aa8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802aac:	0f 88 0d 03 00 00    	js     802dbf <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802ab2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ab9:	e9 ef 02 00 00       	jmp    802dad <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac1:	89 d0                	mov    %edx,%eax
  802ac3:	01 c0                	add    %eax,%eax
  802ac5:	01 d0                	add    %edx,%eax
  802ac7:	c1 e0 02             	shl    $0x2,%eax
  802aca:	05 48 50 80 00       	add    $0x805048,%eax
  802acf:	8a 00                	mov    (%eax),%al
  802ad1:	84 c0                	test   %al,%al
  802ad3:	0f 84 d1 02 00 00    	je     802daa <sfree+0x337>
  802ad9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adc:	89 d0                	mov    %edx,%eax
  802ade:	01 c0                	add    %eax,%eax
  802ae0:	01 d0                	add    %edx,%eax
  802ae2:	c1 e0 02             	shl    $0x2,%eax
  802ae5:	05 40 50 80 00       	add    $0x805040,%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802aef:	0f 85 b5 02 00 00    	jne    802daa <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802af5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af8:	89 d0                	mov    %edx,%eax
  802afa:	01 c0                	add    %eax,%eax
  802afc:	01 d0                	add    %edx,%eax
  802afe:	c1 e0 02             	shl    $0x2,%eax
  802b01:	05 44 50 80 00       	add    $0x805044,%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802b0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b0e:	89 d0                	mov    %edx,%eax
  802b10:	01 c0                	add    %eax,%eax
  802b12:	01 d0                	add    %edx,%eax
  802b14:	c1 e0 02             	shl    $0x2,%eax
  802b17:	05 48 50 80 00       	add    $0x805048,%eax
  802b1c:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802b1f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b26:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802b2d:	eb 64                	jmp    802b93 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802b2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b32:	89 d0                	mov    %edx,%eax
  802b34:	01 c0                	add    %eax,%eax
  802b36:	01 d0                	add    %edx,%eax
  802b38:	c1 e0 02             	shl    $0x2,%eax
  802b3b:	05 48 10 81 00       	add    $0x811048,%eax
  802b40:	8a 00                	mov    (%eax),%al
  802b42:	84 c0                	test   %al,%al
  802b44:	75 4a                	jne    802b90 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802b46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b49:	89 d0                	mov    %edx,%eax
  802b4b:	01 c0                	add    %eax,%eax
  802b4d:	01 d0                	add    %edx,%eax
  802b4f:	c1 e0 02             	shl    $0x2,%eax
  802b52:	8d 90 40 10 81 00    	lea    0x811040(%eax),%edx
  802b58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b5b:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802b5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b60:	89 d0                	mov    %edx,%eax
  802b62:	01 c0                	add    %eax,%eax
  802b64:	01 d0                	add    %edx,%eax
  802b66:	c1 e0 02             	shl    $0x2,%eax
  802b69:	8d 90 44 10 81 00    	lea    0x811044(%eax),%edx
  802b6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b72:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802b74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b77:	89 d0                	mov    %edx,%eax
  802b79:	01 c0                	add    %eax,%eax
  802b7b:	01 d0                	add    %edx,%eax
  802b7d:	c1 e0 02             	shl    $0x2,%eax
  802b80:	05 48 10 81 00       	add    $0x811048,%eax
  802b85:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802b8e:	eb 0c                	jmp    802b9c <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b90:	ff 45 ec             	incl   -0x14(%ebp)
  802b93:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802b9a:	7e 93                	jle    802b2f <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802b9c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802ba0:	0f 84 8d 01 00 00    	je     802d33 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ba6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802bad:	e9 74 01 00 00       	jmp    802d26 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bb8:	0f 84 64 01 00 00    	je     802d22 <sfree+0x2af>
					if (uhp_frees[k].free)
  802bbe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bc1:	89 d0                	mov    %edx,%eax
  802bc3:	01 c0                	add    %eax,%eax
  802bc5:	01 d0                	add    %edx,%eax
  802bc7:	c1 e0 02             	shl    $0x2,%eax
  802bca:	05 48 10 81 00       	add    $0x811048,%eax
  802bcf:	8a 00                	mov    (%eax),%al
  802bd1:	84 c0                	test   %al,%al
  802bd3:	0f 84 4a 01 00 00    	je     802d23 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802bd9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bdc:	89 d0                	mov    %edx,%eax
  802bde:	01 c0                	add    %eax,%eax
  802be0:	01 d0                	add    %edx,%eax
  802be2:	c1 e0 02             	shl    $0x2,%eax
  802be5:	05 40 10 81 00       	add    $0x811040,%eax
  802bea:	8b 08                	mov    (%eax),%ecx
  802bec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bef:	89 d0                	mov    %edx,%eax
  802bf1:	01 c0                	add    %eax,%eax
  802bf3:	01 d0                	add    %edx,%eax
  802bf5:	c1 e0 02             	shl    $0x2,%eax
  802bf8:	05 44 10 81 00       	add    $0x811044,%eax
  802bfd:	8b 00                	mov    (%eax),%eax
  802bff:	01 c1                	add    %eax,%ecx
  802c01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c04:	89 d0                	mov    %edx,%eax
  802c06:	01 c0                	add    %eax,%eax
  802c08:	01 d0                	add    %edx,%eax
  802c0a:	c1 e0 02             	shl    $0x2,%eax
  802c0d:	05 40 10 81 00       	add    $0x811040,%eax
  802c12:	8b 00                	mov    (%eax),%eax
  802c14:	39 c1                	cmp    %eax,%ecx
  802c16:	75 7a                	jne    802c92 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802c18:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c1b:	89 d0                	mov    %edx,%eax
  802c1d:	01 c0                	add    %eax,%eax
  802c1f:	01 d0                	add    %edx,%eax
  802c21:	c1 e0 02             	shl    $0x2,%eax
  802c24:	05 40 10 81 00       	add    $0x811040,%eax
  802c29:	8b 10                	mov    (%eax),%edx
  802c2b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c2e:	89 c8                	mov    %ecx,%eax
  802c30:	01 c0                	add    %eax,%eax
  802c32:	01 c8                	add    %ecx,%eax
  802c34:	c1 e0 02             	shl    $0x2,%eax
  802c37:	05 40 10 81 00       	add    $0x811040,%eax
  802c3c:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802c3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c41:	89 d0                	mov    %edx,%eax
  802c43:	01 c0                	add    %eax,%eax
  802c45:	01 d0                	add    %edx,%eax
  802c47:	c1 e0 02             	shl    $0x2,%eax
  802c4a:	05 44 10 81 00       	add    $0x811044,%eax
  802c4f:	8b 08                	mov    (%eax),%ecx
  802c51:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c54:	89 d0                	mov    %edx,%eax
  802c56:	01 c0                	add    %eax,%eax
  802c58:	01 d0                	add    %edx,%eax
  802c5a:	c1 e0 02             	shl    $0x2,%eax
  802c5d:	05 44 10 81 00       	add    $0x811044,%eax
  802c62:	8b 00                	mov    (%eax),%eax
  802c64:	01 c1                	add    %eax,%ecx
  802c66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c69:	89 d0                	mov    %edx,%eax
  802c6b:	01 c0                	add    %eax,%eax
  802c6d:	01 d0                	add    %edx,%eax
  802c6f:	c1 e0 02             	shl    $0x2,%eax
  802c72:	05 44 10 81 00       	add    $0x811044,%eax
  802c77:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802c79:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c7c:	89 d0                	mov    %edx,%eax
  802c7e:	01 c0                	add    %eax,%eax
  802c80:	01 d0                	add    %edx,%eax
  802c82:	c1 e0 02             	shl    $0x2,%eax
  802c85:	05 48 10 81 00       	add    $0x811048,%eax
  802c8a:	c6 00 00             	movb   $0x0,(%eax)
  802c8d:	e9 91 00 00 00       	jmp    802d23 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802c92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c95:	89 d0                	mov    %edx,%eax
  802c97:	01 c0                	add    %eax,%eax
  802c99:	01 d0                	add    %edx,%eax
  802c9b:	c1 e0 02             	shl    $0x2,%eax
  802c9e:	05 40 10 81 00       	add    $0x811040,%eax
  802ca3:	8b 08                	mov    (%eax),%ecx
  802ca5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca8:	89 d0                	mov    %edx,%eax
  802caa:	01 c0                	add    %eax,%eax
  802cac:	01 d0                	add    %edx,%eax
  802cae:	c1 e0 02             	shl    $0x2,%eax
  802cb1:	05 44 10 81 00       	add    $0x811044,%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	01 c1                	add    %eax,%ecx
  802cba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cbd:	89 d0                	mov    %edx,%eax
  802cbf:	01 c0                	add    %eax,%eax
  802cc1:	01 d0                	add    %edx,%eax
  802cc3:	c1 e0 02             	shl    $0x2,%eax
  802cc6:	05 40 10 81 00       	add    $0x811040,%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	39 c1                	cmp    %eax,%ecx
  802ccf:	75 52                	jne    802d23 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802cd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd4:	89 d0                	mov    %edx,%eax
  802cd6:	01 c0                	add    %eax,%eax
  802cd8:	01 d0                	add    %edx,%eax
  802cda:	c1 e0 02             	shl    $0x2,%eax
  802cdd:	05 44 10 81 00       	add    $0x811044,%eax
  802ce2:	8b 08                	mov    (%eax),%ecx
  802ce4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ce7:	89 d0                	mov    %edx,%eax
  802ce9:	01 c0                	add    %eax,%eax
  802ceb:	01 d0                	add    %edx,%eax
  802ced:	c1 e0 02             	shl    $0x2,%eax
  802cf0:	05 44 10 81 00       	add    $0x811044,%eax
  802cf5:	8b 00                	mov    (%eax),%eax
  802cf7:	01 c1                	add    %eax,%ecx
  802cf9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cfc:	89 d0                	mov    %edx,%eax
  802cfe:	01 c0                	add    %eax,%eax
  802d00:	01 d0                	add    %edx,%eax
  802d02:	c1 e0 02             	shl    $0x2,%eax
  802d05:	05 44 10 81 00       	add    $0x811044,%eax
  802d0a:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802d0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d0f:	89 d0                	mov    %edx,%eax
  802d11:	01 c0                	add    %eax,%eax
  802d13:	01 d0                	add    %edx,%eax
  802d15:	c1 e0 02             	shl    $0x2,%eax
  802d18:	05 48 10 81 00       	add    $0x811048,%eax
  802d1d:	c6 00 00             	movb   $0x0,(%eax)
  802d20:	eb 01                	jmp    802d23 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802d22:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802d23:	ff 45 e8             	incl   -0x18(%ebp)
  802d26:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802d2d:	0f 8e 7f fe ff ff    	jle    802bb2 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802d33:	a1 30 51 83 00       	mov    0x835130,%eax
  802d38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802d3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802d42:	eb 53                	jmp    802d97 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802d44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d47:	89 d0                	mov    %edx,%eax
  802d49:	01 c0                	add    %eax,%eax
  802d4b:	01 d0                	add    %edx,%eax
  802d4d:	c1 e0 02             	shl    $0x2,%eax
  802d50:	05 48 50 80 00       	add    $0x805048,%eax
  802d55:	8a 00                	mov    (%eax),%al
  802d57:	84 c0                	test   %al,%al
  802d59:	74 39                	je     802d94 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802d5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d5e:	89 d0                	mov    %edx,%eax
  802d60:	01 c0                	add    %eax,%eax
  802d62:	01 d0                	add    %edx,%eax
  802d64:	c1 e0 02             	shl    $0x2,%eax
  802d67:	05 40 50 80 00       	add    $0x805040,%eax
  802d6c:	8b 08                	mov    (%eax),%ecx
  802d6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d71:	89 d0                	mov    %edx,%eax
  802d73:	01 c0                	add    %eax,%eax
  802d75:	01 d0                	add    %edx,%eax
  802d77:	c1 e0 02             	shl    $0x2,%eax
  802d7a:	05 44 50 80 00       	add    $0x805044,%eax
  802d7f:	8b 00                	mov    (%eax),%eax
  802d81:	01 c8                	add    %ecx,%eax
  802d83:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  802d86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d89:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d8c:	76 06                	jbe    802d94 <sfree+0x321>
  802d8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802d94:	ff 45 e0             	incl   -0x20(%ebp)
  802d97:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802d9e:	7e a4                	jle    802d44 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  802da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da3:	a3 88 50 83 00       	mov    %eax,0x835088
			break;
  802da8:	eb 16                	jmp    802dc0 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802daa:	ff 45 f4             	incl   -0xc(%ebp)
  802dad:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  802db4:	0f 8e 04 fd ff ff    	jle    802abe <sfree+0x4b>
  802dba:	eb 04                	jmp    802dc0 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  802dbc:	90                   	nop
  802dbd:	eb 01                	jmp    802dc0 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  802dbf:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  802dc0:	c9                   	leave  
  802dc1:	c3                   	ret    

00802dc2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802dc2:	55                   	push   %ebp
  802dc3:	89 e5                	mov    %esp,%ebp
  802dc5:	57                   	push   %edi
  802dc6:	56                   	push   %esi
  802dc7:	53                   	push   %ebx
  802dc8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dd1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802dd4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802dd7:	8b 7d 18             	mov    0x18(%ebp),%edi
  802dda:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ddd:	cd 30                	int    $0x30
  802ddf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802de5:	83 c4 10             	add    $0x10,%esp
  802de8:	5b                   	pop    %ebx
  802de9:	5e                   	pop    %esi
  802dea:	5f                   	pop    %edi
  802deb:	5d                   	pop    %ebp
  802dec:	c3                   	ret    

00802ded <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802ded:	55                   	push   %ebp
  802dee:	89 e5                	mov    %esp,%ebp
  802df0:	83 ec 04             	sub    $0x4,%esp
  802df3:	8b 45 10             	mov    0x10(%ebp),%eax
  802df6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802df9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802dfc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	6a 00                	push   $0x0
  802e05:	51                   	push   %ecx
  802e06:	52                   	push   %edx
  802e07:	ff 75 0c             	pushl  0xc(%ebp)
  802e0a:	50                   	push   %eax
  802e0b:	6a 00                	push   $0x0
  802e0d:	e8 b0 ff ff ff       	call   802dc2 <syscall>
  802e12:	83 c4 18             	add    $0x18,%esp
}
  802e15:	90                   	nop
  802e16:	c9                   	leave  
  802e17:	c3                   	ret    

00802e18 <sys_cgetc>:

int
sys_cgetc(void)
{
  802e18:	55                   	push   %ebp
  802e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802e1b:	6a 00                	push   $0x0
  802e1d:	6a 00                	push   $0x0
  802e1f:	6a 00                	push   $0x0
  802e21:	6a 00                	push   $0x0
  802e23:	6a 00                	push   $0x0
  802e25:	6a 02                	push   $0x2
  802e27:	e8 96 ff ff ff       	call   802dc2 <syscall>
  802e2c:	83 c4 18             	add    $0x18,%esp
}
  802e2f:	c9                   	leave  
  802e30:	c3                   	ret    

00802e31 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802e31:	55                   	push   %ebp
  802e32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802e34:	6a 00                	push   $0x0
  802e36:	6a 00                	push   $0x0
  802e38:	6a 00                	push   $0x0
  802e3a:	6a 00                	push   $0x0
  802e3c:	6a 00                	push   $0x0
  802e3e:	6a 03                	push   $0x3
  802e40:	e8 7d ff ff ff       	call   802dc2 <syscall>
  802e45:	83 c4 18             	add    $0x18,%esp
}
  802e48:	90                   	nop
  802e49:	c9                   	leave  
  802e4a:	c3                   	ret    

00802e4b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802e4b:	55                   	push   %ebp
  802e4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802e4e:	6a 00                	push   $0x0
  802e50:	6a 00                	push   $0x0
  802e52:	6a 00                	push   $0x0
  802e54:	6a 00                	push   $0x0
  802e56:	6a 00                	push   $0x0
  802e58:	6a 04                	push   $0x4
  802e5a:	e8 63 ff ff ff       	call   802dc2 <syscall>
  802e5f:	83 c4 18             	add    $0x18,%esp
}
  802e62:	90                   	nop
  802e63:	c9                   	leave  
  802e64:	c3                   	ret    

00802e65 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802e65:	55                   	push   %ebp
  802e66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802e68:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	6a 00                	push   $0x0
  802e70:	6a 00                	push   $0x0
  802e72:	6a 00                	push   $0x0
  802e74:	52                   	push   %edx
  802e75:	50                   	push   %eax
  802e76:	6a 08                	push   $0x8
  802e78:	e8 45 ff ff ff       	call   802dc2 <syscall>
  802e7d:	83 c4 18             	add    $0x18,%esp
}
  802e80:	c9                   	leave  
  802e81:	c3                   	ret    

00802e82 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802e82:	55                   	push   %ebp
  802e83:	89 e5                	mov    %esp,%ebp
  802e85:	56                   	push   %esi
  802e86:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802e87:	8b 75 18             	mov    0x18(%ebp),%esi
  802e8a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e90:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	56                   	push   %esi
  802e97:	53                   	push   %ebx
  802e98:	51                   	push   %ecx
  802e99:	52                   	push   %edx
  802e9a:	50                   	push   %eax
  802e9b:	6a 09                	push   $0x9
  802e9d:	e8 20 ff ff ff       	call   802dc2 <syscall>
  802ea2:	83 c4 18             	add    $0x18,%esp
}
  802ea5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ea8:	5b                   	pop    %ebx
  802ea9:	5e                   	pop    %esi
  802eaa:	5d                   	pop    %ebp
  802eab:	c3                   	ret    

00802eac <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802eac:	55                   	push   %ebp
  802ead:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802eaf:	6a 00                	push   $0x0
  802eb1:	6a 00                	push   $0x0
  802eb3:	6a 00                	push   $0x0
  802eb5:	6a 00                	push   $0x0
  802eb7:	ff 75 08             	pushl  0x8(%ebp)
  802eba:	6a 0a                	push   $0xa
  802ebc:	e8 01 ff ff ff       	call   802dc2 <syscall>
  802ec1:	83 c4 18             	add    $0x18,%esp
}
  802ec4:	c9                   	leave  
  802ec5:	c3                   	ret    

00802ec6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802ec6:	55                   	push   %ebp
  802ec7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802ec9:	6a 00                	push   $0x0
  802ecb:	6a 00                	push   $0x0
  802ecd:	6a 00                	push   $0x0
  802ecf:	ff 75 0c             	pushl  0xc(%ebp)
  802ed2:	ff 75 08             	pushl  0x8(%ebp)
  802ed5:	6a 0b                	push   $0xb
  802ed7:	e8 e6 fe ff ff       	call   802dc2 <syscall>
  802edc:	83 c4 18             	add    $0x18,%esp
}
  802edf:	c9                   	leave  
  802ee0:	c3                   	ret    

00802ee1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802ee1:	55                   	push   %ebp
  802ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802ee4:	6a 00                	push   $0x0
  802ee6:	6a 00                	push   $0x0
  802ee8:	6a 00                	push   $0x0
  802eea:	6a 00                	push   $0x0
  802eec:	6a 00                	push   $0x0
  802eee:	6a 0c                	push   $0xc
  802ef0:	e8 cd fe ff ff       	call   802dc2 <syscall>
  802ef5:	83 c4 18             	add    $0x18,%esp
}
  802ef8:	c9                   	leave  
  802ef9:	c3                   	ret    

00802efa <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802efa:	55                   	push   %ebp
  802efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802efd:	6a 00                	push   $0x0
  802eff:	6a 00                	push   $0x0
  802f01:	6a 00                	push   $0x0
  802f03:	6a 00                	push   $0x0
  802f05:	6a 00                	push   $0x0
  802f07:	6a 0d                	push   $0xd
  802f09:	e8 b4 fe ff ff       	call   802dc2 <syscall>
  802f0e:	83 c4 18             	add    $0x18,%esp
}
  802f11:	c9                   	leave  
  802f12:	c3                   	ret    

00802f13 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802f13:	55                   	push   %ebp
  802f14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802f16:	6a 00                	push   $0x0
  802f18:	6a 00                	push   $0x0
  802f1a:	6a 00                	push   $0x0
  802f1c:	6a 00                	push   $0x0
  802f1e:	6a 00                	push   $0x0
  802f20:	6a 0e                	push   $0xe
  802f22:	e8 9b fe ff ff       	call   802dc2 <syscall>
  802f27:	83 c4 18             	add    $0x18,%esp
}
  802f2a:	c9                   	leave  
  802f2b:	c3                   	ret    

00802f2c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802f2c:	55                   	push   %ebp
  802f2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802f2f:	6a 00                	push   $0x0
  802f31:	6a 00                	push   $0x0
  802f33:	6a 00                	push   $0x0
  802f35:	6a 00                	push   $0x0
  802f37:	6a 00                	push   $0x0
  802f39:	6a 0f                	push   $0xf
  802f3b:	e8 82 fe ff ff       	call   802dc2 <syscall>
  802f40:	83 c4 18             	add    $0x18,%esp
}
  802f43:	c9                   	leave  
  802f44:	c3                   	ret    

00802f45 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802f45:	55                   	push   %ebp
  802f46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	ff 75 08             	pushl  0x8(%ebp)
  802f53:	6a 10                	push   $0x10
  802f55:	e8 68 fe ff ff       	call   802dc2 <syscall>
  802f5a:	83 c4 18             	add    $0x18,%esp
}
  802f5d:	c9                   	leave  
  802f5e:	c3                   	ret    

00802f5f <sys_scarce_memory>:

void sys_scarce_memory()
{
  802f5f:	55                   	push   %ebp
  802f60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802f62:	6a 00                	push   $0x0
  802f64:	6a 00                	push   $0x0
  802f66:	6a 00                	push   $0x0
  802f68:	6a 00                	push   $0x0
  802f6a:	6a 00                	push   $0x0
  802f6c:	6a 11                	push   $0x11
  802f6e:	e8 4f fe ff ff       	call   802dc2 <syscall>
  802f73:	83 c4 18             	add    $0x18,%esp
}
  802f76:	90                   	nop
  802f77:	c9                   	leave  
  802f78:	c3                   	ret    

00802f79 <sys_cputc>:

void
sys_cputc(const char c)
{
  802f79:	55                   	push   %ebp
  802f7a:	89 e5                	mov    %esp,%ebp
  802f7c:	83 ec 04             	sub    $0x4,%esp
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802f85:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f89:	6a 00                	push   $0x0
  802f8b:	6a 00                	push   $0x0
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	50                   	push   %eax
  802f92:	6a 01                	push   $0x1
  802f94:	e8 29 fe ff ff       	call   802dc2 <syscall>
  802f99:	83 c4 18             	add    $0x18,%esp
}
  802f9c:	90                   	nop
  802f9d:	c9                   	leave  
  802f9e:	c3                   	ret    

00802f9f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802f9f:	55                   	push   %ebp
  802fa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802fa2:	6a 00                	push   $0x0
  802fa4:	6a 00                	push   $0x0
  802fa6:	6a 00                	push   $0x0
  802fa8:	6a 00                	push   $0x0
  802faa:	6a 00                	push   $0x0
  802fac:	6a 14                	push   $0x14
  802fae:	e8 0f fe ff ff       	call   802dc2 <syscall>
  802fb3:	83 c4 18             	add    $0x18,%esp
}
  802fb6:	90                   	nop
  802fb7:	c9                   	leave  
  802fb8:	c3                   	ret    

00802fb9 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802fb9:	55                   	push   %ebp
  802fba:	89 e5                	mov    %esp,%ebp
  802fbc:	83 ec 04             	sub    $0x4,%esp
  802fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  802fc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802fc5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802fc8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	6a 00                	push   $0x0
  802fd1:	51                   	push   %ecx
  802fd2:	52                   	push   %edx
  802fd3:	ff 75 0c             	pushl  0xc(%ebp)
  802fd6:	50                   	push   %eax
  802fd7:	6a 15                	push   $0x15
  802fd9:	e8 e4 fd ff ff       	call   802dc2 <syscall>
  802fde:	83 c4 18             	add    $0x18,%esp
}
  802fe1:	c9                   	leave  
  802fe2:	c3                   	ret    

00802fe3 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  802fe3:	55                   	push   %ebp
  802fe4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802fe6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	6a 00                	push   $0x0
  802fee:	6a 00                	push   $0x0
  802ff0:	6a 00                	push   $0x0
  802ff2:	52                   	push   %edx
  802ff3:	50                   	push   %eax
  802ff4:	6a 16                	push   $0x16
  802ff6:	e8 c7 fd ff ff       	call   802dc2 <syscall>
  802ffb:	83 c4 18             	add    $0x18,%esp
}
  802ffe:	c9                   	leave  
  802fff:	c3                   	ret    

00803000 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803000:	55                   	push   %ebp
  803001:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803003:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803006:	8b 55 0c             	mov    0xc(%ebp),%edx
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	6a 00                	push   $0x0
  80300e:	6a 00                	push   $0x0
  803010:	51                   	push   %ecx
  803011:	52                   	push   %edx
  803012:	50                   	push   %eax
  803013:	6a 17                	push   $0x17
  803015:	e8 a8 fd ff ff       	call   802dc2 <syscall>
  80301a:	83 c4 18             	add    $0x18,%esp
}
  80301d:	c9                   	leave  
  80301e:	c3                   	ret    

0080301f <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80301f:	55                   	push   %ebp
  803020:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803022:	8b 55 0c             	mov    0xc(%ebp),%edx
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	6a 00                	push   $0x0
  80302a:	6a 00                	push   $0x0
  80302c:	6a 00                	push   $0x0
  80302e:	52                   	push   %edx
  80302f:	50                   	push   %eax
  803030:	6a 18                	push   $0x18
  803032:	e8 8b fd ff ff       	call   802dc2 <syscall>
  803037:	83 c4 18             	add    $0x18,%esp
}
  80303a:	c9                   	leave  
  80303b:	c3                   	ret    

0080303c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80303c:	55                   	push   %ebp
  80303d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	6a 00                	push   $0x0
  803044:	ff 75 14             	pushl  0x14(%ebp)
  803047:	ff 75 10             	pushl  0x10(%ebp)
  80304a:	ff 75 0c             	pushl  0xc(%ebp)
  80304d:	50                   	push   %eax
  80304e:	6a 19                	push   $0x19
  803050:	e8 6d fd ff ff       	call   802dc2 <syscall>
  803055:	83 c4 18             	add    $0x18,%esp
}
  803058:	c9                   	leave  
  803059:	c3                   	ret    

0080305a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80305a:	55                   	push   %ebp
  80305b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	6a 00                	push   $0x0
  803062:	6a 00                	push   $0x0
  803064:	6a 00                	push   $0x0
  803066:	6a 00                	push   $0x0
  803068:	50                   	push   %eax
  803069:	6a 1a                	push   $0x1a
  80306b:	e8 52 fd ff ff       	call   802dc2 <syscall>
  803070:	83 c4 18             	add    $0x18,%esp
}
  803073:	90                   	nop
  803074:	c9                   	leave  
  803075:	c3                   	ret    

00803076 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803076:	55                   	push   %ebp
  803077:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	6a 00                	push   $0x0
  80307e:	6a 00                	push   $0x0
  803080:	6a 00                	push   $0x0
  803082:	6a 00                	push   $0x0
  803084:	50                   	push   %eax
  803085:	6a 1b                	push   $0x1b
  803087:	e8 36 fd ff ff       	call   802dc2 <syscall>
  80308c:	83 c4 18             	add    $0x18,%esp
}
  80308f:	c9                   	leave  
  803090:	c3                   	ret    

00803091 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803091:	55                   	push   %ebp
  803092:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803094:	6a 00                	push   $0x0
  803096:	6a 00                	push   $0x0
  803098:	6a 00                	push   $0x0
  80309a:	6a 00                	push   $0x0
  80309c:	6a 00                	push   $0x0
  80309e:	6a 05                	push   $0x5
  8030a0:	e8 1d fd ff ff       	call   802dc2 <syscall>
  8030a5:	83 c4 18             	add    $0x18,%esp
}
  8030a8:	c9                   	leave  
  8030a9:	c3                   	ret    

008030aa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8030aa:	55                   	push   %ebp
  8030ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 00                	push   $0x0
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 06                	push   $0x6
  8030b9:	e8 04 fd ff ff       	call   802dc2 <syscall>
  8030be:	83 c4 18             	add    $0x18,%esp
}
  8030c1:	c9                   	leave  
  8030c2:	c3                   	ret    

008030c3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8030c3:	55                   	push   %ebp
  8030c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8030c6:	6a 00                	push   $0x0
  8030c8:	6a 00                	push   $0x0
  8030ca:	6a 00                	push   $0x0
  8030cc:	6a 00                	push   $0x0
  8030ce:	6a 00                	push   $0x0
  8030d0:	6a 07                	push   $0x7
  8030d2:	e8 eb fc ff ff       	call   802dc2 <syscall>
  8030d7:	83 c4 18             	add    $0x18,%esp
}
  8030da:	c9                   	leave  
  8030db:	c3                   	ret    

008030dc <sys_exit_env>:


void sys_exit_env(void)
{
  8030dc:	55                   	push   %ebp
  8030dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8030df:	6a 00                	push   $0x0
  8030e1:	6a 00                	push   $0x0
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 00                	push   $0x0
  8030e9:	6a 1c                	push   $0x1c
  8030eb:	e8 d2 fc ff ff       	call   802dc2 <syscall>
  8030f0:	83 c4 18             	add    $0x18,%esp
}
  8030f3:	90                   	nop
  8030f4:	c9                   	leave  
  8030f5:	c3                   	ret    

008030f6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8030f6:	55                   	push   %ebp
  8030f7:	89 e5                	mov    %esp,%ebp
  8030f9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8030fc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8030ff:	8d 50 04             	lea    0x4(%eax),%edx
  803102:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803105:	6a 00                	push   $0x0
  803107:	6a 00                	push   $0x0
  803109:	6a 00                	push   $0x0
  80310b:	52                   	push   %edx
  80310c:	50                   	push   %eax
  80310d:	6a 1d                	push   $0x1d
  80310f:	e8 ae fc ff ff       	call   802dc2 <syscall>
  803114:	83 c4 18             	add    $0x18,%esp
	return result;
  803117:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80311a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80311d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803120:	89 01                	mov    %eax,(%ecx)
  803122:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	c9                   	leave  
  803129:	c2 04 00             	ret    $0x4

0080312c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80312c:	55                   	push   %ebp
  80312d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80312f:	6a 00                	push   $0x0
  803131:	6a 00                	push   $0x0
  803133:	ff 75 10             	pushl  0x10(%ebp)
  803136:	ff 75 0c             	pushl  0xc(%ebp)
  803139:	ff 75 08             	pushl  0x8(%ebp)
  80313c:	6a 13                	push   $0x13
  80313e:	e8 7f fc ff ff       	call   802dc2 <syscall>
  803143:	83 c4 18             	add    $0x18,%esp
	return ;
  803146:	90                   	nop
}
  803147:	c9                   	leave  
  803148:	c3                   	ret    

00803149 <sys_rcr2>:
uint32 sys_rcr2()
{
  803149:	55                   	push   %ebp
  80314a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80314c:	6a 00                	push   $0x0
  80314e:	6a 00                	push   $0x0
  803150:	6a 00                	push   $0x0
  803152:	6a 00                	push   $0x0
  803154:	6a 00                	push   $0x0
  803156:	6a 1e                	push   $0x1e
  803158:	e8 65 fc ff ff       	call   802dc2 <syscall>
  80315d:	83 c4 18             	add    $0x18,%esp
}
  803160:	c9                   	leave  
  803161:	c3                   	ret    

00803162 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803162:	55                   	push   %ebp
  803163:	89 e5                	mov    %esp,%ebp
  803165:	83 ec 04             	sub    $0x4,%esp
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80316e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803172:	6a 00                	push   $0x0
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	50                   	push   %eax
  80317b:	6a 1f                	push   $0x1f
  80317d:	e8 40 fc ff ff       	call   802dc2 <syscall>
  803182:	83 c4 18             	add    $0x18,%esp
	return ;
  803185:	90                   	nop
}
  803186:	c9                   	leave  
  803187:	c3                   	ret    

00803188 <rsttst>:
void rsttst()
{
  803188:	55                   	push   %ebp
  803189:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80318b:	6a 00                	push   $0x0
  80318d:	6a 00                	push   $0x0
  80318f:	6a 00                	push   $0x0
  803191:	6a 00                	push   $0x0
  803193:	6a 00                	push   $0x0
  803195:	6a 21                	push   $0x21
  803197:	e8 26 fc ff ff       	call   802dc2 <syscall>
  80319c:	83 c4 18             	add    $0x18,%esp
	return ;
  80319f:	90                   	nop
}
  8031a0:	c9                   	leave  
  8031a1:	c3                   	ret    

008031a2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8031a2:	55                   	push   %ebp
  8031a3:	89 e5                	mov    %esp,%ebp
  8031a5:	83 ec 04             	sub    $0x4,%esp
  8031a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8031ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8031ae:	8b 55 18             	mov    0x18(%ebp),%edx
  8031b1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8031b5:	52                   	push   %edx
  8031b6:	50                   	push   %eax
  8031b7:	ff 75 10             	pushl  0x10(%ebp)
  8031ba:	ff 75 0c             	pushl  0xc(%ebp)
  8031bd:	ff 75 08             	pushl  0x8(%ebp)
  8031c0:	6a 20                	push   $0x20
  8031c2:	e8 fb fb ff ff       	call   802dc2 <syscall>
  8031c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ca:	90                   	nop
}
  8031cb:	c9                   	leave  
  8031cc:	c3                   	ret    

008031cd <chktst>:
void chktst(uint32 n)
{
  8031cd:	55                   	push   %ebp
  8031ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8031d0:	6a 00                	push   $0x0
  8031d2:	6a 00                	push   $0x0
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 00                	push   $0x0
  8031d8:	ff 75 08             	pushl  0x8(%ebp)
  8031db:	6a 22                	push   $0x22
  8031dd:	e8 e0 fb ff ff       	call   802dc2 <syscall>
  8031e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8031e5:	90                   	nop
}
  8031e6:	c9                   	leave  
  8031e7:	c3                   	ret    

008031e8 <inctst>:

void inctst()
{
  8031e8:	55                   	push   %ebp
  8031e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8031eb:	6a 00                	push   $0x0
  8031ed:	6a 00                	push   $0x0
  8031ef:	6a 00                	push   $0x0
  8031f1:	6a 00                	push   $0x0
  8031f3:	6a 00                	push   $0x0
  8031f5:	6a 23                	push   $0x23
  8031f7:	e8 c6 fb ff ff       	call   802dc2 <syscall>
  8031fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ff:	90                   	nop
}
  803200:	c9                   	leave  
  803201:	c3                   	ret    

00803202 <gettst>:
uint32 gettst()
{
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803205:	6a 00                	push   $0x0
  803207:	6a 00                	push   $0x0
  803209:	6a 00                	push   $0x0
  80320b:	6a 00                	push   $0x0
  80320d:	6a 00                	push   $0x0
  80320f:	6a 24                	push   $0x24
  803211:	e8 ac fb ff ff       	call   802dc2 <syscall>
  803216:	83 c4 18             	add    $0x18,%esp
}
  803219:	c9                   	leave  
  80321a:	c3                   	ret    

0080321b <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80321b:	55                   	push   %ebp
  80321c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80321e:	6a 00                	push   $0x0
  803220:	6a 00                	push   $0x0
  803222:	6a 00                	push   $0x0
  803224:	6a 00                	push   $0x0
  803226:	6a 00                	push   $0x0
  803228:	6a 25                	push   $0x25
  80322a:	e8 93 fb ff ff       	call   802dc2 <syscall>
  80322f:	83 c4 18             	add    $0x18,%esp
  803232:	a3 80 50 83 00       	mov    %eax,0x835080
	return uheapPlaceStrategy ;
  803237:	a1 80 50 83 00       	mov    0x835080,%eax
}
  80323c:	c9                   	leave  
  80323d:	c3                   	ret    

0080323e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80323e:	55                   	push   %ebp
  80323f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	a3 80 50 83 00       	mov    %eax,0x835080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803249:	6a 00                	push   $0x0
  80324b:	6a 00                	push   $0x0
  80324d:	6a 00                	push   $0x0
  80324f:	6a 00                	push   $0x0
  803251:	ff 75 08             	pushl  0x8(%ebp)
  803254:	6a 26                	push   $0x26
  803256:	e8 67 fb ff ff       	call   802dc2 <syscall>
  80325b:	83 c4 18             	add    $0x18,%esp
	return ;
  80325e:	90                   	nop
}
  80325f:	c9                   	leave  
  803260:	c3                   	ret    

00803261 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803261:	55                   	push   %ebp
  803262:	89 e5                	mov    %esp,%ebp
  803264:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803265:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803268:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80326b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	6a 00                	push   $0x0
  803273:	53                   	push   %ebx
  803274:	51                   	push   %ecx
  803275:	52                   	push   %edx
  803276:	50                   	push   %eax
  803277:	6a 27                	push   $0x27
  803279:	e8 44 fb ff ff       	call   802dc2 <syscall>
  80327e:	83 c4 18             	add    $0x18,%esp
}
  803281:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803284:	c9                   	leave  
  803285:	c3                   	ret    

00803286 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803286:	55                   	push   %ebp
  803287:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803289:	8b 55 0c             	mov    0xc(%ebp),%edx
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	6a 00                	push   $0x0
  803291:	6a 00                	push   $0x0
  803293:	6a 00                	push   $0x0
  803295:	52                   	push   %edx
  803296:	50                   	push   %eax
  803297:	6a 28                	push   $0x28
  803299:	e8 24 fb ff ff       	call   802dc2 <syscall>
  80329e:	83 c4 18             	add    $0x18,%esp
}
  8032a1:	c9                   	leave  
  8032a2:	c3                   	ret    

008032a3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8032a3:	55                   	push   %ebp
  8032a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8032a6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8032a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	6a 00                	push   $0x0
  8032b1:	51                   	push   %ecx
  8032b2:	ff 75 10             	pushl  0x10(%ebp)
  8032b5:	52                   	push   %edx
  8032b6:	50                   	push   %eax
  8032b7:	6a 29                	push   $0x29
  8032b9:	e8 04 fb ff ff       	call   802dc2 <syscall>
  8032be:	83 c4 18             	add    $0x18,%esp
}
  8032c1:	c9                   	leave  
  8032c2:	c3                   	ret    

008032c3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8032c3:	55                   	push   %ebp
  8032c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8032c6:	6a 00                	push   $0x0
  8032c8:	6a 00                	push   $0x0
  8032ca:	ff 75 10             	pushl  0x10(%ebp)
  8032cd:	ff 75 0c             	pushl  0xc(%ebp)
  8032d0:	ff 75 08             	pushl  0x8(%ebp)
  8032d3:	6a 12                	push   $0x12
  8032d5:	e8 e8 fa ff ff       	call   802dc2 <syscall>
  8032da:	83 c4 18             	add    $0x18,%esp
	return ;
  8032dd:	90                   	nop
}
  8032de:	c9                   	leave  
  8032df:	c3                   	ret    

008032e0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8032e0:	55                   	push   %ebp
  8032e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8032e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	6a 00                	push   $0x0
  8032eb:	6a 00                	push   $0x0
  8032ed:	6a 00                	push   $0x0
  8032ef:	52                   	push   %edx
  8032f0:	50                   	push   %eax
  8032f1:	6a 2a                	push   $0x2a
  8032f3:	e8 ca fa ff ff       	call   802dc2 <syscall>
  8032f8:	83 c4 18             	add    $0x18,%esp
	return;
  8032fb:	90                   	nop
}
  8032fc:	c9                   	leave  
  8032fd:	c3                   	ret    

008032fe <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8032fe:	55                   	push   %ebp
  8032ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803301:	6a 00                	push   $0x0
  803303:	6a 00                	push   $0x0
  803305:	6a 00                	push   $0x0
  803307:	6a 00                	push   $0x0
  803309:	6a 00                	push   $0x0
  80330b:	6a 2b                	push   $0x2b
  80330d:	e8 b0 fa ff ff       	call   802dc2 <syscall>
  803312:	83 c4 18             	add    $0x18,%esp
}
  803315:	c9                   	leave  
  803316:	c3                   	ret    

00803317 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803317:	55                   	push   %ebp
  803318:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80331a:	6a 00                	push   $0x0
  80331c:	6a 00                	push   $0x0
  80331e:	6a 00                	push   $0x0
  803320:	ff 75 0c             	pushl  0xc(%ebp)
  803323:	ff 75 08             	pushl  0x8(%ebp)
  803326:	6a 2d                	push   $0x2d
  803328:	e8 95 fa ff ff       	call   802dc2 <syscall>
  80332d:	83 c4 18             	add    $0x18,%esp
	return;
  803330:	90                   	nop
}
  803331:	c9                   	leave  
  803332:	c3                   	ret    

00803333 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803333:	55                   	push   %ebp
  803334:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803336:	6a 00                	push   $0x0
  803338:	6a 00                	push   $0x0
  80333a:	6a 00                	push   $0x0
  80333c:	ff 75 0c             	pushl  0xc(%ebp)
  80333f:	ff 75 08             	pushl  0x8(%ebp)
  803342:	6a 2c                	push   $0x2c
  803344:	e8 79 fa ff ff       	call   802dc2 <syscall>
  803349:	83 c4 18             	add    $0x18,%esp
	return ;
  80334c:	90                   	nop
}
  80334d:	c9                   	leave  
  80334e:	c3                   	ret    

0080334f <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80334f:	55                   	push   %ebp
  803350:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  803352:	8b 55 0c             	mov    0xc(%ebp),%edx
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	6a 00                	push   $0x0
  80335a:	6a 00                	push   $0x0
  80335c:	6a 00                	push   $0x0
  80335e:	52                   	push   %edx
  80335f:	50                   	push   %eax
  803360:	6a 2e                	push   $0x2e
  803362:	e8 5b fa ff ff       	call   802dc2 <syscall>
  803367:	83 c4 18             	add    $0x18,%esp
}
  80336a:	90                   	nop
  80336b:	c9                   	leave  
  80336c:	c3                   	ret    

0080336d <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80336d:	55                   	push   %ebp
  80336e:	89 e5                	mov    %esp,%ebp
  803370:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803373:	81 7d 08 80 d0 81 00 	cmpl   $0x81d080,0x8(%ebp)
  80337a:	72 09                	jb     803385 <to_page_va+0x18>
  80337c:	81 7d 08 80 50 83 00 	cmpl   $0x835080,0x8(%ebp)
  803383:	72 14                	jb     803399 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803385:	83 ec 04             	sub    $0x4,%esp
  803388:	68 58 49 80 00       	push   $0x804958
  80338d:	6a 15                	push   $0x15
  80338f:	68 83 49 80 00       	push   $0x804983
  803394:	e8 db 0a 00 00       	call   803e74 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	ba 80 d0 81 00       	mov    $0x81d080,%edx
  8033a1:	29 d0                	sub    %edx,%eax
  8033a3:	c1 f8 02             	sar    $0x2,%eax
  8033a6:	89 c2                	mov    %eax,%edx
  8033a8:	89 d0                	mov    %edx,%eax
  8033aa:	c1 e0 02             	shl    $0x2,%eax
  8033ad:	01 d0                	add    %edx,%eax
  8033af:	c1 e0 02             	shl    $0x2,%eax
  8033b2:	01 d0                	add    %edx,%eax
  8033b4:	c1 e0 02             	shl    $0x2,%eax
  8033b7:	01 d0                	add    %edx,%eax
  8033b9:	89 c1                	mov    %eax,%ecx
  8033bb:	c1 e1 08             	shl    $0x8,%ecx
  8033be:	01 c8                	add    %ecx,%eax
  8033c0:	89 c1                	mov    %eax,%ecx
  8033c2:	c1 e1 10             	shl    $0x10,%ecx
  8033c5:	01 c8                	add    %ecx,%eax
  8033c7:	01 c0                	add    %eax,%eax
  8033c9:	01 d0                	add    %edx,%eax
  8033cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8033ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d1:	c1 e0 0c             	shl    $0xc,%eax
  8033d4:	89 c2                	mov    %eax,%edx
  8033d6:	a1 84 50 83 00       	mov    0x835084,%eax
  8033db:	01 d0                	add    %edx,%eax
}
  8033dd:	c9                   	leave  
  8033de:	c3                   	ret    

008033df <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8033df:	55                   	push   %ebp
  8033e0:	89 e5                	mov    %esp,%ebp
  8033e2:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8033e5:	a1 84 50 83 00       	mov    0x835084,%eax
  8033ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ed:	29 c2                	sub    %eax,%edx
  8033ef:	89 d0                	mov    %edx,%eax
  8033f1:	c1 e8 0c             	shr    $0xc,%eax
  8033f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8033f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033fb:	78 09                	js     803406 <to_page_info+0x27>
  8033fd:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803404:	7e 14                	jle    80341a <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803406:	83 ec 04             	sub    $0x4,%esp
  803409:	68 9c 49 80 00       	push   $0x80499c
  80340e:	6a 21                	push   $0x21
  803410:	68 83 49 80 00       	push   $0x804983
  803415:	e8 5a 0a 00 00       	call   803e74 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80341a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80341d:	89 d0                	mov    %edx,%eax
  80341f:	01 c0                	add    %eax,%eax
  803421:	01 d0                	add    %edx,%eax
  803423:	c1 e0 02             	shl    $0x2,%eax
  803426:	05 80 d0 81 00       	add    $0x81d080,%eax
}
  80342b:	c9                   	leave  
  80342c:	c3                   	ret    

0080342d <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80342d:	55                   	push   %ebp
  80342e:	89 e5                	mov    %esp,%ebp
  803430:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803433:	8b 45 08             	mov    0x8(%ebp),%eax
  803436:	05 00 00 00 02       	add    $0x2000000,%eax
  80343b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80343e:	73 16                	jae    803456 <initialize_dynamic_allocator+0x29>
  803440:	68 c0 49 80 00       	push   $0x8049c0
  803445:	68 e6 49 80 00       	push   $0x8049e6
  80344a:	6a 2f                	push   $0x2f
  80344c:	68 83 49 80 00       	push   $0x804983
  803451:	e8 1e 0a 00 00       	call   803e74 <_panic>
	dynAllocStart = daStart;
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	a3 84 50 83 00       	mov    %eax,0x835084
	dynAllocEnd = daEnd;
  80345e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803461:	a3 60 d0 81 00       	mov    %eax,0x81d060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803466:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80346d:	eb 36                	jmp    8034a5 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  80346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803472:	c1 e0 04             	shl    $0x4,%eax
  803475:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80347a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803483:	c1 e0 04             	shl    $0x4,%eax
  803486:	05 a4 50 83 00       	add    $0x8350a4,%eax
  80348b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	c1 e0 04             	shl    $0x4,%eax
  803497:	05 ac 50 83 00       	add    $0x8350ac,%eax
  80349c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8034a2:	ff 45 f4             	incl   -0xc(%ebp)
  8034a5:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8034a9:	7e c4                	jle    80346f <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  8034ab:	c7 05 68 d0 81 00 00 	movl   $0x0,0x81d068
  8034b2:	00 00 00 
  8034b5:	c7 05 6c d0 81 00 00 	movl   $0x0,0x81d06c
  8034bc:	00 00 00 
  8034bf:	c7 05 74 d0 81 00 00 	movl   $0x0,0x81d074
  8034c6:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8034c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8034d0:	e9 1b 01 00 00       	jmp    8035f0 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8034d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d8:	89 d0                	mov    %edx,%eax
  8034da:	01 c0                	add    %eax,%eax
  8034dc:	01 d0                	add    %edx,%eax
  8034de:	c1 e0 02             	shl    $0x2,%eax
  8034e1:	05 88 d0 81 00       	add    $0x81d088,%eax
  8034e6:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8034eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ee:	89 d0                	mov    %edx,%eax
  8034f0:	01 c0                	add    %eax,%eax
  8034f2:	01 d0                	add    %edx,%eax
  8034f4:	c1 e0 02             	shl    $0x2,%eax
  8034f7:	05 8a d0 81 00       	add    $0x81d08a,%eax
  8034fc:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803501:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803504:	89 d0                	mov    %edx,%eax
  803506:	01 c0                	add    %eax,%eax
  803508:	01 d0                	add    %edx,%eax
  80350a:	c1 e0 02             	shl    $0x2,%eax
  80350d:	05 80 d0 81 00       	add    $0x81d080,%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	85 c0                	test   %eax,%eax
  803516:	74 2b                	je     803543 <initialize_dynamic_allocator+0x116>
  803518:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80351b:	89 d0                	mov    %edx,%eax
  80351d:	01 c0                	add    %eax,%eax
  80351f:	01 d0                	add    %edx,%eax
  803521:	c1 e0 02             	shl    $0x2,%eax
  803524:	05 80 d0 81 00       	add    $0x81d080,%eax
  803529:	8b 10                	mov    (%eax),%edx
  80352b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80352e:	89 c8                	mov    %ecx,%eax
  803530:	01 c0                	add    %eax,%eax
  803532:	01 c8                	add    %ecx,%eax
  803534:	c1 e0 02             	shl    $0x2,%eax
  803537:	05 84 d0 81 00       	add    $0x81d084,%eax
  80353c:	8b 00                	mov    (%eax),%eax
  80353e:	89 42 04             	mov    %eax,0x4(%edx)
  803541:	eb 18                	jmp    80355b <initialize_dynamic_allocator+0x12e>
  803543:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803546:	89 d0                	mov    %edx,%eax
  803548:	01 c0                	add    %eax,%eax
  80354a:	01 d0                	add    %edx,%eax
  80354c:	c1 e0 02             	shl    $0x2,%eax
  80354f:	05 84 d0 81 00       	add    $0x81d084,%eax
  803554:	8b 00                	mov    (%eax),%eax
  803556:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80355b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80355e:	89 d0                	mov    %edx,%eax
  803560:	01 c0                	add    %eax,%eax
  803562:	01 d0                	add    %edx,%eax
  803564:	c1 e0 02             	shl    $0x2,%eax
  803567:	05 84 d0 81 00       	add    $0x81d084,%eax
  80356c:	8b 00                	mov    (%eax),%eax
  80356e:	85 c0                	test   %eax,%eax
  803570:	74 2a                	je     80359c <initialize_dynamic_allocator+0x16f>
  803572:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803575:	89 d0                	mov    %edx,%eax
  803577:	01 c0                	add    %eax,%eax
  803579:	01 d0                	add    %edx,%eax
  80357b:	c1 e0 02             	shl    $0x2,%eax
  80357e:	05 84 d0 81 00       	add    $0x81d084,%eax
  803583:	8b 10                	mov    (%eax),%edx
  803585:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803588:	89 c8                	mov    %ecx,%eax
  80358a:	01 c0                	add    %eax,%eax
  80358c:	01 c8                	add    %ecx,%eax
  80358e:	c1 e0 02             	shl    $0x2,%eax
  803591:	05 80 d0 81 00       	add    $0x81d080,%eax
  803596:	8b 00                	mov    (%eax),%eax
  803598:	89 02                	mov    %eax,(%edx)
  80359a:	eb 18                	jmp    8035b4 <initialize_dynamic_allocator+0x187>
  80359c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80359f:	89 d0                	mov    %edx,%eax
  8035a1:	01 c0                	add    %eax,%eax
  8035a3:	01 d0                	add    %edx,%eax
  8035a5:	c1 e0 02             	shl    $0x2,%eax
  8035a8:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035ad:	8b 00                	mov    (%eax),%eax
  8035af:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8035b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b7:	89 d0                	mov    %edx,%eax
  8035b9:	01 c0                	add    %eax,%eax
  8035bb:	01 d0                	add    %edx,%eax
  8035bd:	c1 e0 02             	shl    $0x2,%eax
  8035c0:	05 80 d0 81 00       	add    $0x81d080,%eax
  8035c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ce:	89 d0                	mov    %edx,%eax
  8035d0:	01 c0                	add    %eax,%eax
  8035d2:	01 d0                	add    %edx,%eax
  8035d4:	c1 e0 02             	shl    $0x2,%eax
  8035d7:	05 84 d0 81 00       	add    $0x81d084,%eax
  8035dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e2:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8035e7:	48                   	dec    %eax
  8035e8:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8035ed:	ff 45 f0             	incl   -0x10(%ebp)
  8035f0:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8035f7:	0f 8e d8 fe ff ff    	jle    8034d5 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8035fd:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803604:	e9 9d 00 00 00       	jmp    8036a6 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803609:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80360f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803612:	89 c8                	mov    %ecx,%eax
  803614:	01 c0                	add    %eax,%eax
  803616:	01 c8                	add    %ecx,%eax
  803618:	c1 e0 02             	shl    $0x2,%eax
  80361b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803620:	89 10                	mov    %edx,(%eax)
  803622:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803625:	89 d0                	mov    %edx,%eax
  803627:	01 c0                	add    %eax,%eax
  803629:	01 d0                	add    %edx,%eax
  80362b:	c1 e0 02             	shl    $0x2,%eax
  80362e:	05 80 d0 81 00       	add    $0x81d080,%eax
  803633:	8b 00                	mov    (%eax),%eax
  803635:	85 c0                	test   %eax,%eax
  803637:	74 1c                	je     803655 <initialize_dynamic_allocator+0x228>
  803639:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  80363f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803642:	89 c8                	mov    %ecx,%eax
  803644:	01 c0                	add    %eax,%eax
  803646:	01 c8                	add    %ecx,%eax
  803648:	c1 e0 02             	shl    $0x2,%eax
  80364b:	05 80 d0 81 00       	add    $0x81d080,%eax
  803650:	89 42 04             	mov    %eax,0x4(%edx)
  803653:	eb 16                	jmp    80366b <initialize_dynamic_allocator+0x23e>
  803655:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803658:	89 d0                	mov    %edx,%eax
  80365a:	01 c0                	add    %eax,%eax
  80365c:	01 d0                	add    %edx,%eax
  80365e:	c1 e0 02             	shl    $0x2,%eax
  803661:	05 80 d0 81 00       	add    $0x81d080,%eax
  803666:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  80366b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80366e:	89 d0                	mov    %edx,%eax
  803670:	01 c0                	add    %eax,%eax
  803672:	01 d0                	add    %edx,%eax
  803674:	c1 e0 02             	shl    $0x2,%eax
  803677:	05 80 d0 81 00       	add    $0x81d080,%eax
  80367c:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803681:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803684:	89 d0                	mov    %edx,%eax
  803686:	01 c0                	add    %eax,%eax
  803688:	01 d0                	add    %edx,%eax
  80368a:	c1 e0 02             	shl    $0x2,%eax
  80368d:	05 84 d0 81 00       	add    $0x81d084,%eax
  803692:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803698:	a1 74 d0 81 00       	mov    0x81d074,%eax
  80369d:	40                   	inc    %eax
  80369e:	a3 74 d0 81 00       	mov    %eax,0x81d074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8036a3:	ff 4d ec             	decl   -0x14(%ebp)
  8036a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036aa:	0f 89 59 ff ff ff    	jns    803609 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  8036b0:	c7 05 44 d0 81 00 01 	movl   $0x1,0x81d044
  8036b7:	00 00 00 
}
  8036ba:	90                   	nop
  8036bb:	c9                   	leave  
  8036bc:	c3                   	ret    

008036bd <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8036bd:	55                   	push   %ebp
  8036be:	89 e5                	mov    %esp,%ebp
  8036c0:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8036c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c6:	83 ec 0c             	sub    $0xc,%esp
  8036c9:	50                   	push   %eax
  8036ca:	e8 10 fd ff ff       	call   8033df <to_page_info>
  8036cf:	83 c4 10             	add    $0x10,%esp
  8036d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d8:	8b 40 08             	mov    0x8(%eax),%eax
  8036db:	0f b7 c0             	movzwl %ax,%eax
}
  8036de:	c9                   	leave  
  8036df:	c3                   	ret    

008036e0 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8036e0:	55                   	push   %ebp
  8036e1:	89 e5                	mov    %esp,%ebp
  8036e3:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8036e6:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8036ed:	76 16                	jbe    803705 <alloc_block+0x25>
  8036ef:	68 fc 49 80 00       	push   $0x8049fc
  8036f4:	68 e6 49 80 00       	push   $0x8049e6
  8036f9:	6a 59                	push   $0x59
  8036fb:	68 83 49 80 00       	push   $0x804983
  803700:	e8 6f 07 00 00       	call   803e74 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803705:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80370c:	eb 08                	jmp    803716 <alloc_block+0x36>
		allocSize <<= 1;
  80370e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803711:	01 c0                	add    %eax,%eax
  803713:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803719:	3b 45 08             	cmp    0x8(%ebp),%eax
  80371c:	73 09                	jae    803727 <alloc_block+0x47>
  80371e:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803725:	76 e7                	jbe    80370e <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803727:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  80372e:	eb 03                	jmp    803733 <alloc_block+0x53>
		listIndex++;
  803730:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803736:	ba 08 00 00 00       	mov    $0x8,%edx
  80373b:	88 c1                	mov    %al,%cl
  80373d:	d3 e2                	shl    %cl,%edx
  80373f:	89 d0                	mov    %edx,%eax
  803741:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803744:	72 ea                	jb     803730 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803749:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80374c:	e9 f4 00 00 00       	jmp    803845 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803754:	c1 e0 04             	shl    $0x4,%eax
  803757:	05 a0 50 83 00       	add    $0x8350a0,%eax
  80375c:	8b 00                	mov    (%eax),%eax
  80375e:	85 c0                	test   %eax,%eax
  803760:	0f 84 dc 00 00 00    	je     803842 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803769:	c1 e0 04             	shl    $0x4,%eax
  80376c:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803771:	8b 00                	mov    (%eax),%eax
  803773:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803776:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80377a:	75 14                	jne    803790 <alloc_block+0xb0>
  80377c:	83 ec 04             	sub    $0x4,%esp
  80377f:	68 1d 4a 80 00       	push   $0x804a1d
  803784:	6a 6b                	push   $0x6b
  803786:	68 83 49 80 00       	push   $0x804983
  80378b:	e8 e4 06 00 00       	call   803e74 <_panic>
  803790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803793:	8b 00                	mov    (%eax),%eax
  803795:	85 c0                	test   %eax,%eax
  803797:	74 10                	je     8037a9 <alloc_block+0xc9>
  803799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379c:	8b 00                	mov    (%eax),%eax
  80379e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a1:	8b 52 04             	mov    0x4(%edx),%edx
  8037a4:	89 50 04             	mov    %edx,0x4(%eax)
  8037a7:	eb 14                	jmp    8037bd <alloc_block+0xdd>
  8037a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ac:	8b 40 04             	mov    0x4(%eax),%eax
  8037af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037b2:	c1 e2 04             	shl    $0x4,%edx
  8037b5:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  8037bb:	89 02                	mov    %eax,(%edx)
  8037bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c0:	8b 40 04             	mov    0x4(%eax),%eax
  8037c3:	85 c0                	test   %eax,%eax
  8037c5:	74 0f                	je     8037d6 <alloc_block+0xf6>
  8037c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ca:	8b 40 04             	mov    0x4(%eax),%eax
  8037cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037d0:	8b 12                	mov    (%edx),%edx
  8037d2:	89 10                	mov    %edx,(%eax)
  8037d4:	eb 13                	jmp    8037e9 <alloc_block+0x109>
  8037d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037de:	c1 e2 04             	shl    $0x4,%edx
  8037e1:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  8037e7:	89 02                	mov    %eax,(%edx)
  8037e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ff:	c1 e0 04             	shl    $0x4,%eax
  803802:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803807:	8b 00                	mov    (%eax),%eax
  803809:	8d 50 ff             	lea    -0x1(%eax),%edx
  80380c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380f:	c1 e0 04             	shl    $0x4,%eax
  803812:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803817:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381c:	83 ec 0c             	sub    $0xc,%esp
  80381f:	50                   	push   %eax
  803820:	e8 ba fb ff ff       	call   8033df <to_page_info>
  803825:	83 c4 10             	add    $0x10,%esp
  803828:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  80382b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80382e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803832:	48                   	dec    %eax
  803833:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803836:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  80383a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383d:	e9 8f 02 00 00       	jmp    803ad1 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803842:	ff 45 ec             	incl   -0x14(%ebp)
  803845:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803849:	0f 8e 02 ff ff ff    	jle    803751 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  80384f:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803854:	85 c0                	test   %eax,%eax
  803856:	75 14                	jne    80386c <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803858:	83 ec 04             	sub    $0x4,%esp
  80385b:	68 3c 4a 80 00       	push   $0x804a3c
  803860:	6a 77                	push   $0x77
  803862:	68 83 49 80 00       	push   $0x804983
  803867:	e8 08 06 00 00       	call   803e74 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  80386c:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803871:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803874:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803878:	75 14                	jne    80388e <alloc_block+0x1ae>
  80387a:	83 ec 04             	sub    $0x4,%esp
  80387d:	68 1d 4a 80 00       	push   $0x804a1d
  803882:	6a 7a                	push   $0x7a
  803884:	68 83 49 80 00       	push   $0x804983
  803889:	e8 e6 05 00 00       	call   803e74 <_panic>
  80388e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803891:	8b 00                	mov    (%eax),%eax
  803893:	85 c0                	test   %eax,%eax
  803895:	74 10                	je     8038a7 <alloc_block+0x1c7>
  803897:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80389a:	8b 00                	mov    (%eax),%eax
  80389c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80389f:	8b 52 04             	mov    0x4(%edx),%edx
  8038a2:	89 50 04             	mov    %edx,0x4(%eax)
  8038a5:	eb 0b                	jmp    8038b2 <alloc_block+0x1d2>
  8038a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038aa:	8b 40 04             	mov    0x4(%eax),%eax
  8038ad:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  8038b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b5:	8b 40 04             	mov    0x4(%eax),%eax
  8038b8:	85 c0                	test   %eax,%eax
  8038ba:	74 0f                	je     8038cb <alloc_block+0x1eb>
  8038bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038bf:	8b 40 04             	mov    0x4(%eax),%eax
  8038c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038c5:	8b 12                	mov    (%edx),%edx
  8038c7:	89 10                	mov    %edx,(%eax)
  8038c9:	eb 0a                	jmp    8038d5 <alloc_block+0x1f5>
  8038cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038ce:	8b 00                	mov    (%eax),%eax
  8038d0:	a3 68 d0 81 00       	mov    %eax,0x81d068
  8038d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e8:	a1 74 d0 81 00       	mov    0x81d074,%eax
  8038ed:	48                   	dec    %eax
  8038ee:	a3 74 d0 81 00       	mov    %eax,0x81d074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8038f3:	83 ec 0c             	sub    $0xc,%esp
  8038f6:	ff 75 dc             	pushl  -0x24(%ebp)
  8038f9:	e8 6f fa ff ff       	call   80336d <to_page_va>
  8038fe:	83 c4 10             	add    $0x10,%esp
  803901:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803904:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803907:	83 ec 0c             	sub    $0xc,%esp
  80390a:	50                   	push   %eax
  80390b:	e8 a0 dc ff ff       	call   8015b0 <get_page>
  803910:	83 c4 10             	add    $0x10,%esp
  803913:	85 c0                	test   %eax,%eax
  803915:	74 14                	je     80392b <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803917:	83 ec 04             	sub    $0x4,%esp
  80391a:	68 64 4a 80 00       	push   $0x804a64
  80391f:	6a 7f                	push   $0x7f
  803921:	68 83 49 80 00       	push   $0x804983
  803926:	e8 49 05 00 00       	call   803e74 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  80392b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803931:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803935:	b8 00 10 00 00       	mov    $0x1000,%eax
  80393a:	ba 00 00 00 00       	mov    $0x0,%edx
  80393f:	f7 75 f4             	divl   -0xc(%ebp)
  803942:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803945:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803949:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803950:	e9 a7 00 00 00       	jmp    8039fc <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803955:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803958:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395b:	01 d0                	add    %edx,%eax
  80395d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803960:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803964:	75 17                	jne    80397d <alloc_block+0x29d>
  803966:	83 ec 04             	sub    $0x4,%esp
  803969:	68 8c 4a 80 00       	push   $0x804a8c
  80396e:	68 88 00 00 00       	push   $0x88
  803973:	68 83 49 80 00       	push   $0x804983
  803978:	e8 f7 04 00 00       	call   803e74 <_panic>
  80397d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803980:	c1 e0 04             	shl    $0x4,%eax
  803983:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803988:	8b 10                	mov    (%eax),%edx
  80398a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80398d:	89 10                	mov    %edx,(%eax)
  80398f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803992:	8b 00                	mov    (%eax),%eax
  803994:	85 c0                	test   %eax,%eax
  803996:	74 15                	je     8039ad <alloc_block+0x2cd>
  803998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80399b:	c1 e0 04             	shl    $0x4,%eax
  80399e:	05 a0 50 83 00       	add    $0x8350a0,%eax
  8039a3:	8b 00                	mov    (%eax),%eax
  8039a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039a8:	89 50 04             	mov    %edx,0x4(%eax)
  8039ab:	eb 11                	jmp    8039be <alloc_block+0x2de>
  8039ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b0:	c1 e0 04             	shl    $0x4,%eax
  8039b3:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  8039b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039bc:	89 02                	mov    %eax,(%edx)
  8039be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c1:	c1 e0 04             	shl    $0x4,%eax
  8039c4:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  8039ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039cd:	89 02                	mov    %eax,(%edx)
  8039cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039dc:	c1 e0 04             	shl    $0x4,%eax
  8039df:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039e4:	8b 00                	mov    (%eax),%eax
  8039e6:	8d 50 01             	lea    0x1(%eax),%edx
  8039e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ec:	c1 e0 04             	shl    $0x4,%eax
  8039ef:	05 ac 50 83 00       	add    $0x8350ac,%eax
  8039f4:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8039f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f9:	01 45 e8             	add    %eax,-0x18(%ebp)
  8039fc:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803a03:	0f 86 4c ff ff ff    	jbe    803955 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a0c:	c1 e0 04             	shl    $0x4,%eax
  803a0f:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803a14:	8b 00                	mov    (%eax),%eax
  803a16:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803a19:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a1d:	75 17                	jne    803a36 <alloc_block+0x356>
  803a1f:	83 ec 04             	sub    $0x4,%esp
  803a22:	68 1d 4a 80 00       	push   $0x804a1d
  803a27:	68 8d 00 00 00       	push   $0x8d
  803a2c:	68 83 49 80 00       	push   $0x804983
  803a31:	e8 3e 04 00 00       	call   803e74 <_panic>
  803a36:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a39:	8b 00                	mov    (%eax),%eax
  803a3b:	85 c0                	test   %eax,%eax
  803a3d:	74 10                	je     803a4f <alloc_block+0x36f>
  803a3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a42:	8b 00                	mov    (%eax),%eax
  803a44:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803a47:	8b 52 04             	mov    0x4(%edx),%edx
  803a4a:	89 50 04             	mov    %edx,0x4(%eax)
  803a4d:	eb 14                	jmp    803a63 <alloc_block+0x383>
  803a4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a52:	8b 40 04             	mov    0x4(%eax),%eax
  803a55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a58:	c1 e2 04             	shl    $0x4,%edx
  803a5b:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803a61:	89 02                	mov    %eax,(%edx)
  803a63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a66:	8b 40 04             	mov    0x4(%eax),%eax
  803a69:	85 c0                	test   %eax,%eax
  803a6b:	74 0f                	je     803a7c <alloc_block+0x39c>
  803a6d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a70:	8b 40 04             	mov    0x4(%eax),%eax
  803a73:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803a76:	8b 12                	mov    (%edx),%edx
  803a78:	89 10                	mov    %edx,(%eax)
  803a7a:	eb 13                	jmp    803a8f <alloc_block+0x3af>
  803a7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a7f:	8b 00                	mov    (%eax),%eax
  803a81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a84:	c1 e2 04             	shl    $0x4,%edx
  803a87:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803a8d:	89 02                	mov    %eax,(%edx)
  803a8f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a98:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa5:	c1 e0 04             	shl    $0x4,%eax
  803aa8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803aad:	8b 00                	mov    (%eax),%eax
  803aaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab5:	c1 e0 04             	shl    $0x4,%eax
  803ab8:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803abd:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803abf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ac2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803ac6:	48                   	dec    %eax
  803ac7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803aca:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803ace:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803ad1:	c9                   	leave  
  803ad2:	c3                   	ret    

00803ad3 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803ad3:	55                   	push   %ebp
  803ad4:	89 e5                	mov    %esp,%ebp
  803ad6:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803ad9:	8b 55 08             	mov    0x8(%ebp),%edx
  803adc:	a1 84 50 83 00       	mov    0x835084,%eax
  803ae1:	39 c2                	cmp    %eax,%edx
  803ae3:	72 0c                	jb     803af1 <free_block+0x1e>
  803ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  803ae8:	a1 60 d0 81 00       	mov    0x81d060,%eax
  803aed:	39 c2                	cmp    %eax,%edx
  803aef:	72 19                	jb     803b0a <free_block+0x37>
  803af1:	68 b0 4a 80 00       	push   $0x804ab0
  803af6:	68 e6 49 80 00       	push   $0x8049e6
  803afb:	68 98 00 00 00       	push   $0x98
  803b00:	68 83 49 80 00       	push   $0x804983
  803b05:	e8 6a 03 00 00       	call   803e74 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0d:	83 ec 0c             	sub    $0xc,%esp
  803b10:	50                   	push   %eax
  803b11:	e8 c9 f8 ff ff       	call   8033df <to_page_info>
  803b16:	83 c4 10             	add    $0x10,%esp
  803b19:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b1f:	8b 40 08             	mov    0x8(%eax),%eax
  803b22:	0f b7 c0             	movzwl %ax,%eax
  803b25:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803b28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803b2f:	eb 03                	jmp    803b34 <free_block+0x61>
		listIndex++;
  803b31:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b37:	ba 08 00 00 00       	mov    $0x8,%edx
  803b3c:	88 c1                	mov    %al,%cl
  803b3e:	d3 e2                	shl    %cl,%edx
  803b40:	89 d0                	mov    %edx,%eax
  803b42:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b45:	72 ea                	jb     803b31 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803b47:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803b4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b51:	75 17                	jne    803b6a <free_block+0x97>
  803b53:	83 ec 04             	sub    $0x4,%esp
  803b56:	68 8c 4a 80 00       	push   $0x804a8c
  803b5b:	68 a2 00 00 00       	push   $0xa2
  803b60:	68 83 49 80 00       	push   $0x804983
  803b65:	e8 0a 03 00 00       	call   803e74 <_panic>
  803b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6d:	c1 e0 04             	shl    $0x4,%eax
  803b70:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b75:	8b 10                	mov    (%eax),%edx
  803b77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7a:	89 10                	mov    %edx,(%eax)
  803b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7f:	8b 00                	mov    (%eax),%eax
  803b81:	85 c0                	test   %eax,%eax
  803b83:	74 15                	je     803b9a <free_block+0xc7>
  803b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b88:	c1 e0 04             	shl    $0x4,%eax
  803b8b:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803b90:	8b 00                	mov    (%eax),%eax
  803b92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b95:	89 50 04             	mov    %edx,0x4(%eax)
  803b98:	eb 11                	jmp    803bab <free_block+0xd8>
  803b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9d:	c1 e0 04             	shl    $0x4,%eax
  803ba0:	8d 90 a4 50 83 00    	lea    0x8350a4(%eax),%edx
  803ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba9:	89 02                	mov    %eax,(%edx)
  803bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bae:	c1 e0 04             	shl    $0x4,%eax
  803bb1:	8d 90 a0 50 83 00    	lea    0x8350a0(%eax),%edx
  803bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bba:	89 02                	mov    %eax,(%edx)
  803bbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc9:	c1 e0 04             	shl    $0x4,%eax
  803bcc:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803bd1:	8b 00                	mov    (%eax),%eax
  803bd3:	8d 50 01             	lea    0x1(%eax),%edx
  803bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd9:	c1 e0 04             	shl    $0x4,%eax
  803bdc:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803be1:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803be6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803bea:	40                   	inc    %eax
  803beb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bee:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803bf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bf5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803bf9:	0f b7 c8             	movzwl %ax,%ecx
  803bfc:	b8 00 10 00 00       	mov    $0x1000,%eax
  803c01:	ba 00 00 00 00       	mov    $0x0,%edx
  803c06:	f7 75 e8             	divl   -0x18(%ebp)
  803c09:	39 c1                	cmp    %eax,%ecx
  803c0b:	0f 85 ed 01 00 00    	jne    803dfe <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c14:	c1 e0 04             	shl    $0x4,%eax
  803c17:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c1c:	8b 00                	mov    (%eax),%eax
  803c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803c21:	eb 2a                	jmp    803c4d <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c26:	83 ec 0c             	sub    $0xc,%esp
  803c29:	50                   	push   %eax
  803c2a:	e8 b0 f7 ff ff       	call   8033df <to_page_info>
  803c2f:	83 c4 10             	add    $0x10,%esp
  803c32:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803c35:	75 06                	jne    803c3d <free_block+0x16a>
				tmp = b;
  803c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c40:	c1 e0 04             	shl    $0x4,%eax
  803c43:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803c48:	8b 00                	mov    (%eax),%eax
  803c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803c4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c51:	74 07                	je     803c5a <free_block+0x187>
  803c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c56:	8b 00                	mov    (%eax),%eax
  803c58:	eb 05                	jmp    803c5f <free_block+0x18c>
  803c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c62:	c1 e2 04             	shl    $0x4,%edx
  803c65:	81 c2 a8 50 83 00    	add    $0x8350a8,%edx
  803c6b:	89 02                	mov    %eax,(%edx)
  803c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c70:	c1 e0 04             	shl    $0x4,%eax
  803c73:	05 a8 50 83 00       	add    $0x8350a8,%eax
  803c78:	8b 00                	mov    (%eax),%eax
  803c7a:	85 c0                	test   %eax,%eax
  803c7c:	75 a5                	jne    803c23 <free_block+0x150>
  803c7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c82:	75 9f                	jne    803c23 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c87:	c1 e0 04             	shl    $0x4,%eax
  803c8a:	05 a0 50 83 00       	add    $0x8350a0,%eax
  803c8f:	8b 00                	mov    (%eax),%eax
  803c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803c94:	e9 cc 00 00 00       	jmp    803d65 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c9c:	8b 00                	mov    (%eax),%eax
  803c9e:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca4:	83 ec 0c             	sub    $0xc,%esp
  803ca7:	50                   	push   %eax
  803ca8:	e8 32 f7 ff ff       	call   8033df <to_page_info>
  803cad:	83 c4 10             	add    $0x10,%esp
  803cb0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803cb3:	0f 85 a6 00 00 00    	jne    803d5f <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803cb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cbd:	75 17                	jne    803cd6 <free_block+0x203>
  803cbf:	83 ec 04             	sub    $0x4,%esp
  803cc2:	68 1d 4a 80 00       	push   $0x804a1d
  803cc7:	68 b5 00 00 00       	push   $0xb5
  803ccc:	68 83 49 80 00       	push   $0x804983
  803cd1:	e8 9e 01 00 00       	call   803e74 <_panic>
  803cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd9:	8b 00                	mov    (%eax),%eax
  803cdb:	85 c0                	test   %eax,%eax
  803cdd:	74 10                	je     803cef <free_block+0x21c>
  803cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ce2:	8b 00                	mov    (%eax),%eax
  803ce4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ce7:	8b 52 04             	mov    0x4(%edx),%edx
  803cea:	89 50 04             	mov    %edx,0x4(%eax)
  803ced:	eb 14                	jmp    803d03 <free_block+0x230>
  803cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cf2:	8b 40 04             	mov    0x4(%eax),%eax
  803cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cf8:	c1 e2 04             	shl    $0x4,%edx
  803cfb:	81 c2 a4 50 83 00    	add    $0x8350a4,%edx
  803d01:	89 02                	mov    %eax,(%edx)
  803d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d06:	8b 40 04             	mov    0x4(%eax),%eax
  803d09:	85 c0                	test   %eax,%eax
  803d0b:	74 0f                	je     803d1c <free_block+0x249>
  803d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d10:	8b 40 04             	mov    0x4(%eax),%eax
  803d13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d16:	8b 12                	mov    (%edx),%edx
  803d18:	89 10                	mov    %edx,(%eax)
  803d1a:	eb 13                	jmp    803d2f <free_block+0x25c>
  803d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d1f:	8b 00                	mov    (%eax),%eax
  803d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d24:	c1 e2 04             	shl    $0x4,%edx
  803d27:	81 c2 a0 50 83 00    	add    $0x8350a0,%edx
  803d2d:	89 02                	mov    %eax,(%edx)
  803d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d45:	c1 e0 04             	shl    $0x4,%eax
  803d48:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803d4d:	8b 00                	mov    (%eax),%eax
  803d4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d55:	c1 e0 04             	shl    $0x4,%eax
  803d58:	05 ac 50 83 00       	add    $0x8350ac,%eax
  803d5d:	89 10                	mov    %edx,(%eax)
			b = next;
  803d5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803d65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d69:	0f 85 2a ff ff ff    	jne    803c99 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d72:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d7b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  803d81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803d85:	75 17                	jne    803d9e <free_block+0x2cb>
  803d87:	83 ec 04             	sub    $0x4,%esp
  803d8a:	68 8c 4a 80 00       	push   $0x804a8c
  803d8f:	68 bc 00 00 00       	push   $0xbc
  803d94:	68 83 49 80 00       	push   $0x804983
  803d99:	e8 d6 00 00 00       	call   803e74 <_panic>
  803d9e:	8b 15 68 d0 81 00    	mov    0x81d068,%edx
  803da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803da7:	89 10                	mov    %edx,(%eax)
  803da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dac:	8b 00                	mov    (%eax),%eax
  803dae:	85 c0                	test   %eax,%eax
  803db0:	74 0d                	je     803dbf <free_block+0x2ec>
  803db2:	a1 68 d0 81 00       	mov    0x81d068,%eax
  803db7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dba:	89 50 04             	mov    %edx,0x4(%eax)
  803dbd:	eb 08                	jmp    803dc7 <free_block+0x2f4>
  803dbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dc2:	a3 6c d0 81 00       	mov    %eax,0x81d06c
  803dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dca:	a3 68 d0 81 00       	mov    %eax,0x81d068
  803dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd9:	a1 74 d0 81 00       	mov    0x81d074,%eax
  803dde:	40                   	inc    %eax
  803ddf:	a3 74 d0 81 00       	mov    %eax,0x81d074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  803de4:	83 ec 0c             	sub    $0xc,%esp
  803de7:	ff 75 ec             	pushl  -0x14(%ebp)
  803dea:	e8 7e f5 ff ff       	call   80336d <to_page_va>
  803def:	83 c4 10             	add    $0x10,%esp
  803df2:	83 ec 0c             	sub    $0xc,%esp
  803df5:	50                   	push   %eax
  803df6:	e8 fe d7 ff ff       	call   8015f9 <return_page>
  803dfb:	83 c4 10             	add    $0x10,%esp
	}
}
  803dfe:	90                   	nop
  803dff:	c9                   	leave  
  803e00:	c3                   	ret    

00803e01 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803e01:	55                   	push   %ebp
  803e02:	89 e5                	mov    %esp,%ebp
  803e04:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  803e07:	83 ec 04             	sub    $0x4,%esp
  803e0a:	68 e8 4a 80 00       	push   $0x804ae8
  803e0f:	6a 07                	push   $0x7
  803e11:	68 17 4b 80 00       	push   $0x804b17
  803e16:	e8 59 00 00 00       	call   803e74 <_panic>

00803e1b <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803e1b:	55                   	push   %ebp
  803e1c:	89 e5                	mov    %esp,%ebp
  803e1e:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  803e21:	83 ec 04             	sub    $0x4,%esp
  803e24:	68 28 4b 80 00       	push   $0x804b28
  803e29:	6a 0b                	push   $0xb
  803e2b:	68 17 4b 80 00       	push   $0x804b17
  803e30:	e8 3f 00 00 00       	call   803e74 <_panic>

00803e35 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  803e35:	55                   	push   %ebp
  803e36:	89 e5                	mov    %esp,%ebp
  803e38:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  803e3b:	83 ec 04             	sub    $0x4,%esp
  803e3e:	68 54 4b 80 00       	push   $0x804b54
  803e43:	6a 10                	push   $0x10
  803e45:	68 17 4b 80 00       	push   $0x804b17
  803e4a:	e8 25 00 00 00       	call   803e74 <_panic>

00803e4f <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  803e4f:	55                   	push   %ebp
  803e50:	89 e5                	mov    %esp,%ebp
  803e52:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  803e55:	83 ec 04             	sub    $0x4,%esp
  803e58:	68 84 4b 80 00       	push   $0x804b84
  803e5d:	6a 15                	push   $0x15
  803e5f:	68 17 4b 80 00       	push   $0x804b17
  803e64:	e8 0b 00 00 00       	call   803e74 <_panic>

00803e69 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  803e69:	55                   	push   %ebp
  803e6a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e6f:	8b 40 10             	mov    0x10(%eax),%eax
}
  803e72:	5d                   	pop    %ebp
  803e73:	c3                   	ret    

00803e74 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803e74:	55                   	push   %ebp
  803e75:	89 e5                	mov    %esp,%ebp
  803e77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803e7a:	8d 45 10             	lea    0x10(%ebp),%eax
  803e7d:	83 c0 04             	add    $0x4,%eax
  803e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803e83:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803e88:	85 c0                	test   %eax,%eax
  803e8a:	74 16                	je     803ea2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803e8c:	a1 3c 51 83 00       	mov    0x83513c,%eax
  803e91:	83 ec 08             	sub    $0x8,%esp
  803e94:	50                   	push   %eax
  803e95:	68 b4 4b 80 00       	push   $0x804bb4
  803e9a:	e8 d8 c7 ff ff       	call   800677 <cprintf>
  803e9f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  803ea2:	a1 04 50 80 00       	mov    0x805004,%eax
  803ea7:	83 ec 0c             	sub    $0xc,%esp
  803eaa:	ff 75 0c             	pushl  0xc(%ebp)
  803ead:	ff 75 08             	pushl  0x8(%ebp)
  803eb0:	50                   	push   %eax
  803eb1:	68 bc 4b 80 00       	push   $0x804bbc
  803eb6:	6a 74                	push   $0x74
  803eb8:	e8 e7 c7 ff ff       	call   8006a4 <cprintf_colored>
  803ebd:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  803ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  803ec3:	83 ec 08             	sub    $0x8,%esp
  803ec6:	ff 75 f4             	pushl  -0xc(%ebp)
  803ec9:	50                   	push   %eax
  803eca:	e8 39 c7 ff ff       	call   800608 <vcprintf>
  803ecf:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803ed2:	83 ec 08             	sub    $0x8,%esp
  803ed5:	6a 00                	push   $0x0
  803ed7:	68 e4 4b 80 00       	push   $0x804be4
  803edc:	e8 27 c7 ff ff       	call   800608 <vcprintf>
  803ee1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803ee4:	e8 a0 c6 ff ff       	call   800589 <exit>

	// should not return here
	while (1) ;
  803ee9:	eb fe                	jmp    803ee9 <_panic+0x75>

00803eeb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803eeb:	55                   	push   %ebp
  803eec:	89 e5                	mov    %esp,%ebp
  803eee:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803ef1:	a1 20 50 80 00       	mov    0x805020,%eax
  803ef6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803eff:	39 c2                	cmp    %eax,%edx
  803f01:	74 14                	je     803f17 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803f03:	83 ec 04             	sub    $0x4,%esp
  803f06:	68 e8 4b 80 00       	push   $0x804be8
  803f0b:	6a 26                	push   $0x26
  803f0d:	68 34 4c 80 00       	push   $0x804c34
  803f12:	e8 5d ff ff ff       	call   803e74 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803f17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803f1e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803f25:	e9 c5 00 00 00       	jmp    803fef <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803f34:	8b 45 08             	mov    0x8(%ebp),%eax
  803f37:	01 d0                	add    %edx,%eax
  803f39:	8b 00                	mov    (%eax),%eax
  803f3b:	85 c0                	test   %eax,%eax
  803f3d:	75 08                	jne    803f47 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803f3f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803f42:	e9 a5 00 00 00       	jmp    803fec <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803f47:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803f4e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803f55:	eb 69                	jmp    803fc0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803f57:	a1 20 50 80 00       	mov    0x805020,%eax
  803f5c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803f62:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f65:	89 d0                	mov    %edx,%eax
  803f67:	01 c0                	add    %eax,%eax
  803f69:	01 d0                	add    %edx,%eax
  803f6b:	c1 e0 03             	shl    $0x3,%eax
  803f6e:	01 c8                	add    %ecx,%eax
  803f70:	8a 40 04             	mov    0x4(%eax),%al
  803f73:	84 c0                	test   %al,%al
  803f75:	75 46                	jne    803fbd <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803f77:	a1 20 50 80 00       	mov    0x805020,%eax
  803f7c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  803f82:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f85:	89 d0                	mov    %edx,%eax
  803f87:	01 c0                	add    %eax,%eax
  803f89:	01 d0                	add    %edx,%eax
  803f8b:	c1 e0 03             	shl    $0x3,%eax
  803f8e:	01 c8                	add    %ecx,%eax
  803f90:	8b 00                	mov    (%eax),%eax
  803f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803f95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803f9d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  803fac:	01 c8                	add    %ecx,%eax
  803fae:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803fb0:	39 c2                	cmp    %eax,%edx
  803fb2:	75 09                	jne    803fbd <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803fb4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803fbb:	eb 15                	jmp    803fd2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803fbd:	ff 45 e8             	incl   -0x18(%ebp)
  803fc0:	a1 20 50 80 00       	mov    0x805020,%eax
  803fc5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fce:	39 c2                	cmp    %eax,%edx
  803fd0:	77 85                	ja     803f57 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803fd2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803fd6:	75 14                	jne    803fec <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803fd8:	83 ec 04             	sub    $0x4,%esp
  803fdb:	68 40 4c 80 00       	push   $0x804c40
  803fe0:	6a 3a                	push   $0x3a
  803fe2:	68 34 4c 80 00       	push   $0x804c34
  803fe7:	e8 88 fe ff ff       	call   803e74 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803fec:	ff 45 f0             	incl   -0x10(%ebp)
  803fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ff5:	0f 8c 2f ff ff ff    	jl     803f2a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803ffb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804002:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  804009:	eb 26                	jmp    804031 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80400b:	a1 20 50 80 00       	mov    0x805020,%eax
  804010:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  804016:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804019:	89 d0                	mov    %edx,%eax
  80401b:	01 c0                	add    %eax,%eax
  80401d:	01 d0                	add    %edx,%eax
  80401f:	c1 e0 03             	shl    $0x3,%eax
  804022:	01 c8                	add    %ecx,%eax
  804024:	8a 40 04             	mov    0x4(%eax),%al
  804027:	3c 01                	cmp    $0x1,%al
  804029:	75 03                	jne    80402e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80402b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80402e:	ff 45 e0             	incl   -0x20(%ebp)
  804031:	a1 20 50 80 00       	mov    0x805020,%eax
  804036:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80403c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80403f:	39 c2                	cmp    %eax,%edx
  804041:	77 c8                	ja     80400b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  804043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804046:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  804049:	74 14                	je     80405f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80404b:	83 ec 04             	sub    $0x4,%esp
  80404e:	68 94 4c 80 00       	push   $0x804c94
  804053:	6a 44                	push   $0x44
  804055:	68 34 4c 80 00       	push   $0x804c34
  80405a:	e8 15 fe ff ff       	call   803e74 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80405f:	90                   	nop
  804060:	c9                   	leave  
  804061:	c3                   	ret    
  804062:	66 90                	xchg   %ax,%ax

00804064 <__udivdi3>:
  804064:	55                   	push   %ebp
  804065:	57                   	push   %edi
  804066:	56                   	push   %esi
  804067:	53                   	push   %ebx
  804068:	83 ec 1c             	sub    $0x1c,%esp
  80406b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80406f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804073:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804077:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80407b:	89 ca                	mov    %ecx,%edx
  80407d:	89 f8                	mov    %edi,%eax
  80407f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804083:	85 f6                	test   %esi,%esi
  804085:	75 2d                	jne    8040b4 <__udivdi3+0x50>
  804087:	39 cf                	cmp    %ecx,%edi
  804089:	77 65                	ja     8040f0 <__udivdi3+0x8c>
  80408b:	89 fd                	mov    %edi,%ebp
  80408d:	85 ff                	test   %edi,%edi
  80408f:	75 0b                	jne    80409c <__udivdi3+0x38>
  804091:	b8 01 00 00 00       	mov    $0x1,%eax
  804096:	31 d2                	xor    %edx,%edx
  804098:	f7 f7                	div    %edi
  80409a:	89 c5                	mov    %eax,%ebp
  80409c:	31 d2                	xor    %edx,%edx
  80409e:	89 c8                	mov    %ecx,%eax
  8040a0:	f7 f5                	div    %ebp
  8040a2:	89 c1                	mov    %eax,%ecx
  8040a4:	89 d8                	mov    %ebx,%eax
  8040a6:	f7 f5                	div    %ebp
  8040a8:	89 cf                	mov    %ecx,%edi
  8040aa:	89 fa                	mov    %edi,%edx
  8040ac:	83 c4 1c             	add    $0x1c,%esp
  8040af:	5b                   	pop    %ebx
  8040b0:	5e                   	pop    %esi
  8040b1:	5f                   	pop    %edi
  8040b2:	5d                   	pop    %ebp
  8040b3:	c3                   	ret    
  8040b4:	39 ce                	cmp    %ecx,%esi
  8040b6:	77 28                	ja     8040e0 <__udivdi3+0x7c>
  8040b8:	0f bd fe             	bsr    %esi,%edi
  8040bb:	83 f7 1f             	xor    $0x1f,%edi
  8040be:	75 40                	jne    804100 <__udivdi3+0x9c>
  8040c0:	39 ce                	cmp    %ecx,%esi
  8040c2:	72 0a                	jb     8040ce <__udivdi3+0x6a>
  8040c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040c8:	0f 87 9e 00 00 00    	ja     80416c <__udivdi3+0x108>
  8040ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8040d3:	89 fa                	mov    %edi,%edx
  8040d5:	83 c4 1c             	add    $0x1c,%esp
  8040d8:	5b                   	pop    %ebx
  8040d9:	5e                   	pop    %esi
  8040da:	5f                   	pop    %edi
  8040db:	5d                   	pop    %ebp
  8040dc:	c3                   	ret    
  8040dd:	8d 76 00             	lea    0x0(%esi),%esi
  8040e0:	31 ff                	xor    %edi,%edi
  8040e2:	31 c0                	xor    %eax,%eax
  8040e4:	89 fa                	mov    %edi,%edx
  8040e6:	83 c4 1c             	add    $0x1c,%esp
  8040e9:	5b                   	pop    %ebx
  8040ea:	5e                   	pop    %esi
  8040eb:	5f                   	pop    %edi
  8040ec:	5d                   	pop    %ebp
  8040ed:	c3                   	ret    
  8040ee:	66 90                	xchg   %ax,%ax
  8040f0:	89 d8                	mov    %ebx,%eax
  8040f2:	f7 f7                	div    %edi
  8040f4:	31 ff                	xor    %edi,%edi
  8040f6:	89 fa                	mov    %edi,%edx
  8040f8:	83 c4 1c             	add    $0x1c,%esp
  8040fb:	5b                   	pop    %ebx
  8040fc:	5e                   	pop    %esi
  8040fd:	5f                   	pop    %edi
  8040fe:	5d                   	pop    %ebp
  8040ff:	c3                   	ret    
  804100:	bd 20 00 00 00       	mov    $0x20,%ebp
  804105:	89 eb                	mov    %ebp,%ebx
  804107:	29 fb                	sub    %edi,%ebx
  804109:	89 f9                	mov    %edi,%ecx
  80410b:	d3 e6                	shl    %cl,%esi
  80410d:	89 c5                	mov    %eax,%ebp
  80410f:	88 d9                	mov    %bl,%cl
  804111:	d3 ed                	shr    %cl,%ebp
  804113:	89 e9                	mov    %ebp,%ecx
  804115:	09 f1                	or     %esi,%ecx
  804117:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80411b:	89 f9                	mov    %edi,%ecx
  80411d:	d3 e0                	shl    %cl,%eax
  80411f:	89 c5                	mov    %eax,%ebp
  804121:	89 d6                	mov    %edx,%esi
  804123:	88 d9                	mov    %bl,%cl
  804125:	d3 ee                	shr    %cl,%esi
  804127:	89 f9                	mov    %edi,%ecx
  804129:	d3 e2                	shl    %cl,%edx
  80412b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80412f:	88 d9                	mov    %bl,%cl
  804131:	d3 e8                	shr    %cl,%eax
  804133:	09 c2                	or     %eax,%edx
  804135:	89 d0                	mov    %edx,%eax
  804137:	89 f2                	mov    %esi,%edx
  804139:	f7 74 24 0c          	divl   0xc(%esp)
  80413d:	89 d6                	mov    %edx,%esi
  80413f:	89 c3                	mov    %eax,%ebx
  804141:	f7 e5                	mul    %ebp
  804143:	39 d6                	cmp    %edx,%esi
  804145:	72 19                	jb     804160 <__udivdi3+0xfc>
  804147:	74 0b                	je     804154 <__udivdi3+0xf0>
  804149:	89 d8                	mov    %ebx,%eax
  80414b:	31 ff                	xor    %edi,%edi
  80414d:	e9 58 ff ff ff       	jmp    8040aa <__udivdi3+0x46>
  804152:	66 90                	xchg   %ax,%ax
  804154:	8b 54 24 08          	mov    0x8(%esp),%edx
  804158:	89 f9                	mov    %edi,%ecx
  80415a:	d3 e2                	shl    %cl,%edx
  80415c:	39 c2                	cmp    %eax,%edx
  80415e:	73 e9                	jae    804149 <__udivdi3+0xe5>
  804160:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804163:	31 ff                	xor    %edi,%edi
  804165:	e9 40 ff ff ff       	jmp    8040aa <__udivdi3+0x46>
  80416a:	66 90                	xchg   %ax,%ax
  80416c:	31 c0                	xor    %eax,%eax
  80416e:	e9 37 ff ff ff       	jmp    8040aa <__udivdi3+0x46>
  804173:	90                   	nop

00804174 <__umoddi3>:
  804174:	55                   	push   %ebp
  804175:	57                   	push   %edi
  804176:	56                   	push   %esi
  804177:	53                   	push   %ebx
  804178:	83 ec 1c             	sub    $0x1c,%esp
  80417b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80417f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804183:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804187:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80418b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80418f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804193:	89 f3                	mov    %esi,%ebx
  804195:	89 fa                	mov    %edi,%edx
  804197:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80419b:	89 34 24             	mov    %esi,(%esp)
  80419e:	85 c0                	test   %eax,%eax
  8041a0:	75 1a                	jne    8041bc <__umoddi3+0x48>
  8041a2:	39 f7                	cmp    %esi,%edi
  8041a4:	0f 86 a2 00 00 00    	jbe    80424c <__umoddi3+0xd8>
  8041aa:	89 c8                	mov    %ecx,%eax
  8041ac:	89 f2                	mov    %esi,%edx
  8041ae:	f7 f7                	div    %edi
  8041b0:	89 d0                	mov    %edx,%eax
  8041b2:	31 d2                	xor    %edx,%edx
  8041b4:	83 c4 1c             	add    $0x1c,%esp
  8041b7:	5b                   	pop    %ebx
  8041b8:	5e                   	pop    %esi
  8041b9:	5f                   	pop    %edi
  8041ba:	5d                   	pop    %ebp
  8041bb:	c3                   	ret    
  8041bc:	39 f0                	cmp    %esi,%eax
  8041be:	0f 87 ac 00 00 00    	ja     804270 <__umoddi3+0xfc>
  8041c4:	0f bd e8             	bsr    %eax,%ebp
  8041c7:	83 f5 1f             	xor    $0x1f,%ebp
  8041ca:	0f 84 ac 00 00 00    	je     80427c <__umoddi3+0x108>
  8041d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8041d5:	29 ef                	sub    %ebp,%edi
  8041d7:	89 fe                	mov    %edi,%esi
  8041d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041dd:	89 e9                	mov    %ebp,%ecx
  8041df:	d3 e0                	shl    %cl,%eax
  8041e1:	89 d7                	mov    %edx,%edi
  8041e3:	89 f1                	mov    %esi,%ecx
  8041e5:	d3 ef                	shr    %cl,%edi
  8041e7:	09 c7                	or     %eax,%edi
  8041e9:	89 e9                	mov    %ebp,%ecx
  8041eb:	d3 e2                	shl    %cl,%edx
  8041ed:	89 14 24             	mov    %edx,(%esp)
  8041f0:	89 d8                	mov    %ebx,%eax
  8041f2:	d3 e0                	shl    %cl,%eax
  8041f4:	89 c2                	mov    %eax,%edx
  8041f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041fa:	d3 e0                	shl    %cl,%eax
  8041fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  804200:	8b 44 24 08          	mov    0x8(%esp),%eax
  804204:	89 f1                	mov    %esi,%ecx
  804206:	d3 e8                	shr    %cl,%eax
  804208:	09 d0                	or     %edx,%eax
  80420a:	d3 eb                	shr    %cl,%ebx
  80420c:	89 da                	mov    %ebx,%edx
  80420e:	f7 f7                	div    %edi
  804210:	89 d3                	mov    %edx,%ebx
  804212:	f7 24 24             	mull   (%esp)
  804215:	89 c6                	mov    %eax,%esi
  804217:	89 d1                	mov    %edx,%ecx
  804219:	39 d3                	cmp    %edx,%ebx
  80421b:	0f 82 87 00 00 00    	jb     8042a8 <__umoddi3+0x134>
  804221:	0f 84 91 00 00 00    	je     8042b8 <__umoddi3+0x144>
  804227:	8b 54 24 04          	mov    0x4(%esp),%edx
  80422b:	29 f2                	sub    %esi,%edx
  80422d:	19 cb                	sbb    %ecx,%ebx
  80422f:	89 d8                	mov    %ebx,%eax
  804231:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804235:	d3 e0                	shl    %cl,%eax
  804237:	89 e9                	mov    %ebp,%ecx
  804239:	d3 ea                	shr    %cl,%edx
  80423b:	09 d0                	or     %edx,%eax
  80423d:	89 e9                	mov    %ebp,%ecx
  80423f:	d3 eb                	shr    %cl,%ebx
  804241:	89 da                	mov    %ebx,%edx
  804243:	83 c4 1c             	add    $0x1c,%esp
  804246:	5b                   	pop    %ebx
  804247:	5e                   	pop    %esi
  804248:	5f                   	pop    %edi
  804249:	5d                   	pop    %ebp
  80424a:	c3                   	ret    
  80424b:	90                   	nop
  80424c:	89 fd                	mov    %edi,%ebp
  80424e:	85 ff                	test   %edi,%edi
  804250:	75 0b                	jne    80425d <__umoddi3+0xe9>
  804252:	b8 01 00 00 00       	mov    $0x1,%eax
  804257:	31 d2                	xor    %edx,%edx
  804259:	f7 f7                	div    %edi
  80425b:	89 c5                	mov    %eax,%ebp
  80425d:	89 f0                	mov    %esi,%eax
  80425f:	31 d2                	xor    %edx,%edx
  804261:	f7 f5                	div    %ebp
  804263:	89 c8                	mov    %ecx,%eax
  804265:	f7 f5                	div    %ebp
  804267:	89 d0                	mov    %edx,%eax
  804269:	e9 44 ff ff ff       	jmp    8041b2 <__umoddi3+0x3e>
  80426e:	66 90                	xchg   %ax,%ax
  804270:	89 c8                	mov    %ecx,%eax
  804272:	89 f2                	mov    %esi,%edx
  804274:	83 c4 1c             	add    $0x1c,%esp
  804277:	5b                   	pop    %ebx
  804278:	5e                   	pop    %esi
  804279:	5f                   	pop    %edi
  80427a:	5d                   	pop    %ebp
  80427b:	c3                   	ret    
  80427c:	3b 04 24             	cmp    (%esp),%eax
  80427f:	72 06                	jb     804287 <__umoddi3+0x113>
  804281:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804285:	77 0f                	ja     804296 <__umoddi3+0x122>
  804287:	89 f2                	mov    %esi,%edx
  804289:	29 f9                	sub    %edi,%ecx
  80428b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80428f:	89 14 24             	mov    %edx,(%esp)
  804292:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804296:	8b 44 24 04          	mov    0x4(%esp),%eax
  80429a:	8b 14 24             	mov    (%esp),%edx
  80429d:	83 c4 1c             	add    $0x1c,%esp
  8042a0:	5b                   	pop    %ebx
  8042a1:	5e                   	pop    %esi
  8042a2:	5f                   	pop    %edi
  8042a3:	5d                   	pop    %ebp
  8042a4:	c3                   	ret    
  8042a5:	8d 76 00             	lea    0x0(%esi),%esi
  8042a8:	2b 04 24             	sub    (%esp),%eax
  8042ab:	19 fa                	sbb    %edi,%edx
  8042ad:	89 d1                	mov    %edx,%ecx
  8042af:	89 c6                	mov    %eax,%esi
  8042b1:	e9 71 ff ff ff       	jmp    804227 <__umoddi3+0xb3>
  8042b6:	66 90                	xchg   %ax,%ax
  8042b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042bc:	72 ea                	jb     8042a8 <__umoddi3+0x134>
  8042be:	89 d9                	mov    %ebx,%ecx
  8042c0:	e9 62 ff ff ff       	jmp    804227 <__umoddi3+0xb3>
