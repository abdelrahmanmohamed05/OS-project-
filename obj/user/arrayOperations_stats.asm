
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 31 06 00 00       	call   800667 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 68             	sub    $0x68,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 ce 32 00 00       	call   803311 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 f8 32 00 00       	call   803343 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SEMAPHORES*/
	struct semaphore ready = get_semaphore(parentenvID, "Ready");
  80004e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 c0 46 80 00       	push   $0x8046c0
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 39 40 00 00       	call   80409b <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore finished = get_semaphore(parentenvID, "Finished");
  800065:	8d 45 c0             	lea    -0x40(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 c6 46 80 00       	push   $0x8046c6
  800070:	ff 75 ec             	pushl  -0x14(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 22 40 00 00       	call   80409b <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	/*[2] WAIT A READY SIGNAL FROM THE MASTER*/
	wait_semaphore(ready);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800082:	e8 2e 40 00 00       	call   8040b5 <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp

	/*[3] GET SHARED VARs*/
	//Get the cons_mutex ownerID
	int* consMutexOwnerID = sget(parentenvID, "cons_mutex ownerID") ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	68 cf 46 80 00       	push   $0x8046cf
  800092:	ff 75 ec             	pushl  -0x14(%ebp)
  800095:	e8 e6 22 00 00       	call   802380 <sget>
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct semaphore cons_mutex = get_semaphore(*consMutexOwnerID, "Console Mutex");
  8000a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a3:	8b 10                	mov    (%eax),%edx
  8000a5:	8d 45 bc             	lea    -0x44(%ebp),%eax
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 e2 46 80 00       	push   $0x8046e2
  8000b0:	52                   	push   %edx
  8000b1:	50                   	push   %eax
  8000b2:	e8 e4 3f 00 00       	call   80409b <get_semaphore>
  8000b7:	83 c4 0c             	add    $0xc,%esp

	//Get the shared array & its size
	int *numOfElements = NULL;
  8000ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int *sharedArray = NULL;
  8000c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 f0 46 80 00       	push   $0x8046f0
  8000d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d3:	e8 a8 22 00 00       	call   802380 <sget>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 e0             	mov    %eax,-0x20(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  8000de:	83 ec 08             	sub    $0x8,%esp
  8000e1:	68 f4 46 80 00       	push   $0x8046f4
  8000e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e9:	e8 92 22 00 00       	call   802380 <sget>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	c1 e0 02             	shl    $0x2,%eax
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 00                	push   $0x0
  800101:	50                   	push   %eax
  800102:	68 fc 46 80 00       	push   $0x8046fc
  800107:	e8 1a 1f 00 00       	call   802026 <smalloc>
  80010c:	83 c4 10             	add    $0x10,%esp
  80010f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  800112:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800119:	eb 25                	jmp    800140 <_main+0x108>
	{
		tmpArray[i] = sharedArray[i];
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

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  80013d:	ff 45 f4             	incl   -0xc(%ebp)
  800140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800143:	8b 00                	mov    (%eax),%eax
  800145:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800148:	7f d1                	jg     80011b <_main+0xe3>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  80014a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014d:	8b 00                	mov    (%eax),%eax
  80014f:	83 ec 04             	sub    $0x4,%esp
  800152:	8d 55 9c             	lea    -0x64(%ebp),%edx
  800155:	52                   	push   %edx
  800156:	8d 55 a0             	lea    -0x60(%ebp),%edx
  800159:	52                   	push   %edx
  80015a:	8d 55 a4             	lea    -0x5c(%ebp),%edx
  80015d:	52                   	push   %edx
  80015e:	8d 55 a8             	lea    -0x58(%ebp),%edx
  800161:	52                   	push   %edx
  800162:	8d 55 b0             	lea    -0x50(%ebp),%edx
  800165:	52                   	push   %edx
  800166:	50                   	push   %eax
  800167:	ff 75 dc             	pushl  -0x24(%ebp)
  80016a:	e8 bf 02 00 00       	call   80042e <ArrayStats>
  80016f:	83 c4 20             	add    $0x20,%esp

	wait_semaphore(cons_mutex);
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	ff 75 bc             	pushl  -0x44(%ebp)
  800178:	e8 38 3f 00 00       	call   8040b5 <wait_semaphore>
  80017d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Stats Calculations are Finished!!!!\n") ;
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	68 04 47 80 00       	push   $0x804704
  800188:	e8 6a 07 00 00       	call   8008f7 <cprintf>
  80018d:	83 c4 10             	add    $0x10,%esp
		cprintf("will share the rsults & notify the master now...\n");
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 2c 47 80 00       	push   $0x80472c
  800198:	e8 5a 07 00 00       	call   8008f7 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	ff 75 bc             	pushl  -0x44(%ebp)
  8001a6:	e8 24 3f 00 00       	call   8040cf <signal_semaphore>
  8001ab:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int64 *shMean, *shVar;
	int *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int64), 0) ; *shMean = mean;
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	6a 00                	push   $0x0
  8001b3:	6a 08                	push   $0x8
  8001b5:	68 5e 47 80 00       	push   $0x80475e
  8001ba:	e8 67 1e 00 00       	call   802026 <smalloc>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001cb:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8001ce:	89 01                	mov    %eax,(%ecx)
  8001d0:	89 51 04             	mov    %edx,0x4(%ecx)
	shVar = smalloc("var", sizeof(int64), 0) ; *shVar = var;
  8001d3:	83 ec 04             	sub    $0x4,%esp
  8001d6:	6a 00                	push   $0x0
  8001d8:	6a 08                	push   $0x8
  8001da:	68 63 47 80 00       	push   $0x804763
  8001df:	e8 42 1e 00 00       	call   802026 <smalloc>
  8001e4:	83 c4 10             	add    $0x10,%esp
  8001e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001ea:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001ed:	8b 55 ac             	mov    -0x54(%ebp),%edx
  8001f0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8001f3:	89 01                	mov    %eax,(%ecx)
  8001f5:	89 51 04             	mov    %edx,0x4(%ecx)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  8001f8:	83 ec 04             	sub    $0x4,%esp
  8001fb:	6a 00                	push   $0x0
  8001fd:	6a 04                	push   $0x4
  8001ff:	68 67 47 80 00       	push   $0x804767
  800204:	e8 1d 1e 00 00       	call   802026 <smalloc>
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80020f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800212:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800215:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	6a 00                	push   $0x0
  80021c:	6a 04                	push   $0x4
  80021e:	68 6b 47 80 00       	push   $0x80476b
  800223:	e8 fe 1d 00 00       	call   802026 <smalloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80022e:	8b 55 a0             	mov    -0x60(%ebp),%edx
  800231:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800234:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	6a 00                	push   $0x0
  80023b:	6a 04                	push   $0x4
  80023d:	68 6f 47 80 00       	push   $0x80476f
  800242:	e8 df 1d 00 00       	call   802026 <smalloc>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80024d:	8b 55 9c             	mov    -0x64(%ebp),%edx
  800250:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800253:	89 10                	mov    %edx,(%eax)

	wait_semaphore(cons_mutex);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 bc             	pushl  -0x44(%ebp)
  80025b:	e8 55 3e 00 00       	call   8040b5 <wait_semaphore>
  800260:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Stats app says GOOD BYE :)\n") ;
  800263:	83 ec 0c             	sub    $0xc,%esp
  800266:	68 73 47 80 00       	push   $0x804773
  80026b:	e8 87 06 00 00       	call   8008f7 <cprintf>
  800270:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cons_mutex);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	ff 75 bc             	pushl  -0x44(%ebp)
  800279:	e8 51 3e 00 00       	call   8040cf <signal_semaphore>
  80027e:	83 c4 10             	add    $0x10,%esp

	signal_semaphore(finished);
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	ff 75 c0             	pushl  -0x40(%ebp)
  800287:	e8 43 3e 00 00       	call   8040cf <signal_semaphore>
  80028c:	83 c4 10             	add    $0x10,%esp

}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  800298:	8b 45 10             	mov    0x10(%ebp),%eax
  80029b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80029e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a1:	48                   	dec    %eax
  8002a2:	83 ec 0c             	sub    $0xc,%esp
  8002a5:	52                   	push   %edx
  8002a6:	50                   	push   %eax
  8002a7:	6a 00                	push   $0x0
  8002a9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ac:	ff 75 08             	pushl  0x8(%ebp)
  8002af:	e8 05 00 00 00       	call   8002b9 <QSort>
  8002b4:	83 c4 20             	add    $0x20,%esp
}
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    

008002b9 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  8002bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c2:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002c5:	7c 16                	jl     8002dd <QSort+0x24>
  8002c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 d0                	add    %edx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	e9 4f 01 00 00       	jmp    80042c <QSort+0x173>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8002dd:	0f 31                	rdtsc  
  8002df:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002e2:	89 55 e0             	mov    %edx,-0x20(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8002e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ee:	89 55 e8             	mov    %edx,-0x18(%ebp)

	int pvtIndex = RANDU(startIndex, finalIndex) ;
  8002f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002f4:	8b 55 14             	mov    0x14(%ebp),%edx
  8002f7:	2b 55 10             	sub    0x10(%ebp),%edx
  8002fa:	89 d1                	mov    %edx,%ecx
  8002fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800301:	f7 f1                	div    %ecx
  800303:	8b 45 10             	mov    0x10(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  80030b:	83 ec 04             	sub    $0x4,%esp
  80030e:	ff 75 ec             	pushl  -0x14(%ebp)
  800311:	ff 75 10             	pushl  0x10(%ebp)
  800314:	ff 75 08             	pushl  0x8(%ebp)
  800317:	e8 f8 02 00 00       	call   800614 <Swap>
  80031c:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80031f:	8b 45 10             	mov    0x10(%ebp),%eax
  800322:	40                   	inc    %eax
  800323:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800326:	8b 45 14             	mov    0x14(%ebp),%eax
  800329:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80032c:	e9 80 00 00 00       	jmp    8003b1 <QSort+0xf8>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800331:	ff 45 f4             	incl   -0xc(%ebp)
  800334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800337:	3b 45 14             	cmp    0x14(%ebp),%eax
  80033a:	7f 2b                	jg     800367 <QSort+0xae>
  80033c:	8b 45 10             	mov    0x10(%ebp),%eax
  80033f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	01 d0                	add    %edx,%eax
  80034b:	8b 10                	mov    (%eax),%edx
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	01 c8                	add    %ecx,%eax
  80035c:	8b 00                	mov    (%eax),%eax
  80035e:	39 c2                	cmp    %eax,%edx
  800360:	7d cf                	jge    800331 <QSort+0x78>
		while (j > startIndex && Elements[startIndex] < Elements[j]) j--;
  800362:	eb 03                	jmp    800367 <QSort+0xae>
  800364:	ff 4d f0             	decl   -0x10(%ebp)
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80036d:	7e 26                	jle    800395 <QSort+0xdc>
  80036f:	8b 45 10             	mov    0x10(%ebp),%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	8b 45 08             	mov    0x8(%ebp),%eax
  80037c:	01 d0                	add    %edx,%eax
  80037e:	8b 10                	mov    (%eax),%edx
  800380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800383:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80038a:	8b 45 08             	mov    0x8(%ebp),%eax
  80038d:	01 c8                	add    %ecx,%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	39 c2                	cmp    %eax,%edx
  800393:	7c cf                	jl     800364 <QSort+0xab>

		if (i <= j)
  800395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800398:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80039b:	7f 14                	jg     8003b1 <QSort+0xf8>
		{
			Swap(Elements, i, j);
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a6:	ff 75 08             	pushl  0x8(%ebp)
  8003a9:	e8 66 02 00 00       	call   800614 <Swap>
  8003ae:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RANDU(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8003b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b7:	0f 8e 77 ff ff ff    	jle    800334 <QSort+0x7b>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8003c3:	ff 75 10             	pushl  0x10(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	e8 46 02 00 00       	call   800614 <Swap>
  8003ce:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d7:	75 13                	jne    8003ec <QSort+0x133>
		return Elements[kIndex] ;
  8003d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 d0                	add    %edx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	eb 40                	jmp    80042c <QSort+0x173>
	else if (kIndex < j)
  8003ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003f2:	7d 1e                	jge    800412 <QSort+0x159>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  8003f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f7:	48                   	dec    %eax
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	ff 75 18             	pushl  0x18(%ebp)
  8003fe:	50                   	push   %eax
  8003ff:	ff 75 10             	pushl  0x10(%ebp)
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	ff 75 08             	pushl  0x8(%ebp)
  800408:	e8 ac fe ff ff       	call   8002b9 <QSort>
  80040d:	83 c4 20             	add    $0x20,%esp
  800410:	eb 1a                	jmp    80042c <QSort+0x173>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800412:	83 ec 0c             	sub    $0xc,%esp
  800415:	ff 75 18             	pushl  0x18(%ebp)
  800418:	ff 75 14             	pushl  0x14(%ebp)
  80041b:	ff 75 f4             	pushl  -0xc(%ebp)
  80041e:	ff 75 0c             	pushl  0xc(%ebp)
  800421:	ff 75 08             	pushl  0x8(%ebp)
  800424:	e8 90 fe ff ff       	call   8002b9 <QSort>
  800429:	83 c4 20             	add    $0x20,%esp
}
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int64 *mean, int64 *var, int *min, int *max, int *med)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	57                   	push   %edi
  800432:	56                   	push   %esi
  800433:	53                   	push   %ebx
  800434:	83 ec 2c             	sub    $0x2c,%esp
	int i ;
	*mean =0 ;
  800437:	8b 45 10             	mov    0x10(%ebp),%eax
  80043a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800440:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	*min = 0x7FFFFFFF ;
  800447:	8b 45 18             	mov    0x18(%ebp),%eax
  80044a:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  800450:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800453:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800459:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800460:	e9 89 00 00 00       	jmp    8004ee <ArrayStats+0xc0>
	{
		(*mean) += Elements[i];
  800465:	8b 45 10             	mov    0x10(%ebp),%eax
  800468:	8b 08                	mov    (%eax),%ecx
  80046a:	8b 58 04             	mov    0x4(%eax),%ebx
  80046d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800470:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800477:	8b 45 08             	mov    0x8(%ebp),%eax
  80047a:	01 d0                	add    %edx,%eax
  80047c:	8b 00                	mov    (%eax),%eax
  80047e:	99                   	cltd   
  80047f:	01 c8                	add    %ecx,%eax
  800481:	11 da                	adc    %ebx,%edx
  800483:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800486:	89 01                	mov    %eax,(%ecx)
  800488:	89 51 04             	mov    %edx,0x4(%ecx)
		if (Elements[i] < (*min))
  80048b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80048e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	01 d0                	add    %edx,%eax
  80049a:	8b 10                	mov    (%eax),%edx
  80049c:	8b 45 18             	mov    0x18(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	39 c2                	cmp    %eax,%edx
  8004a3:	7d 16                	jge    8004bb <ArrayStats+0x8d>
		{
			(*min) = Elements[i];
  8004a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	8b 10                	mov    (%eax),%edx
  8004b6:	8b 45 18             	mov    0x18(%ebp),%eax
  8004b9:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8004bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	8b 10                	mov    (%eax),%edx
  8004cc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	7e 16                	jle    8004eb <ArrayStats+0xbd>
		{
			(*max) = Elements[i];
  8004d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 d0                	add    %edx,%eax
  8004e4:	8b 10                	mov    (%eax),%edx
  8004e6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e9:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004eb:	ff 45 e4             	incl   -0x1c(%ebp)
  8004ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	0f 8c 6b ff ff ff    	jl     800465 <ArrayStats+0x37>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, (NumOfElements+1)/2);
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	40                   	inc    %eax
  8004fe:	89 c2                	mov    %eax,%edx
  800500:	c1 ea 1f             	shr    $0x1f,%edx
  800503:	01 d0                	add    %edx,%eax
  800505:	d1 f8                	sar    %eax
  800507:	83 ec 04             	sub    $0x4,%esp
  80050a:	50                   	push   %eax
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 7c fd ff ff       	call   800292 <KthElement>
  800516:	83 c4 10             	add    $0x10,%esp
  800519:	89 c2                	mov    %eax,%edx
  80051b:	8b 45 20             	mov    0x20(%ebp),%eax
  80051e:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	8b 50 04             	mov    0x4(%eax),%edx
  800526:	8b 00                	mov    (%eax),%eax
  800528:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80052b:	89 cb                	mov    %ecx,%ebx
  80052d:	c1 fb 1f             	sar    $0x1f,%ebx
  800530:	53                   	push   %ebx
  800531:	51                   	push   %ecx
  800532:	52                   	push   %edx
  800533:	50                   	push   %eax
  800534:	e8 ab 3d 00 00       	call   8042e4 <__divdi3>
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80053f:	89 01                	mov    %eax,(%ecx)
  800541:	89 51 04             	mov    %edx,0x4(%ecx)
	(*var) = 0;
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80054d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800554:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80055b:	eb 7e                	jmp    8005db <ArrayStats+0x1ad>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 50 04             	mov    0x4(%eax),%edx
  800563:	8b 00                	mov    (%eax),%eax
  800565:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800568:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80056b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80056e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800575:	8b 45 08             	mov    0x8(%ebp),%eax
  800578:	01 d0                	add    %edx,%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	89 c1                	mov    %eax,%ecx
  80057e:	89 c3                	mov    %eax,%ebx
  800580:	c1 fb 1f             	sar    $0x1f,%ebx
  800583:	8b 45 10             	mov    0x10(%ebp),%eax
  800586:	8b 50 04             	mov    0x4(%eax),%edx
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	29 c1                	sub    %eax,%ecx
  80058d:	19 d3                	sbb    %edx,%ebx
  80058f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 c6                	mov    %eax,%esi
  8005a2:	89 c7                	mov    %eax,%edi
  8005a4:	c1 ff 1f             	sar    $0x1f,%edi
  8005a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005aa:	8b 50 04             	mov    0x4(%eax),%edx
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	29 c6                	sub    %eax,%esi
  8005b1:	19 d7                	sbb    %edx,%edi
  8005b3:	89 f0                	mov    %esi,%eax
  8005b5:	89 fa                	mov    %edi,%edx
  8005b7:	89 df                	mov    %ebx,%edi
  8005b9:	0f af f8             	imul   %eax,%edi
  8005bc:	89 d6                	mov    %edx,%esi
  8005be:	0f af f1             	imul   %ecx,%esi
  8005c1:	01 fe                	add    %edi,%esi
  8005c3:	f7 e1                	mul    %ecx
  8005c5:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  8005c8:	89 ca                	mov    %ecx,%edx
  8005ca:	03 45 d0             	add    -0x30(%ebp),%eax
  8005cd:	13 55 d4             	adc    -0x2c(%ebp),%edx
  8005d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8005d3:	89 01                	mov    %eax,(%ecx)
  8005d5:	89 51 04             	mov    %edx,0x4(%ecx)

	(*med) = KthElement(Elements, NumOfElements, (NumOfElements+1)/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8005d8:	ff 45 e4             	incl   -0x1c(%ebp)
  8005db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005e1:	0f 8c 76 ff ff ff    	jl     80055d <ArrayStats+0x12f>
	{
		(*var) += (int64)((Elements[i] - (*mean))*(Elements[i] - (*mean)));
	}
	(*var) /= NumOfElements;
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 50 04             	mov    0x4(%eax),%edx
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005f2:	89 cb                	mov    %ecx,%ebx
  8005f4:	c1 fb 1f             	sar    $0x1f,%ebx
  8005f7:	53                   	push   %ebx
  8005f8:	51                   	push   %ecx
  8005f9:	52                   	push   %edx
  8005fa:	50                   	push   %eax
  8005fb:	e8 e4 3c 00 00       	call   8042e4 <__divdi3>
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800606:	89 01                	mov    %eax,(%ecx)
  800608:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80060b:	90                   	nop
  80060c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80060f:	5b                   	pop    %ebx
  800610:	5e                   	pop    %esi
  800611:	5f                   	pop    %edi
  800612:	5d                   	pop    %ebp
  800613:	c3                   	ret    

00800614 <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80061a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	01 d0                	add    %edx,%eax
  800629:	8b 00                	mov    (%eax),%eax
  80062b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	01 c2                	add    %eax,%edx
  80063d:	8b 45 10             	mov    0x10(%ebp),%eax
  800640:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800650:	8b 45 10             	mov    0x10(%ebp),%eax
  800653:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	01 c2                	add    %eax,%edx
  80065f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800662:	89 02                	mov    %eax,(%edx)
}
  800664:	90                   	nop
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	57                   	push   %edi
  80066b:	56                   	push   %esi
  80066c:	53                   	push   %ebx
  80066d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800670:	e8 b5 2c 00 00       	call   80332a <sys_getenvindex>
  800675:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800678:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80067b:	89 d0                	mov    %edx,%eax
  80067d:	c1 e0 03             	shl    $0x3,%eax
  800680:	01 d0                	add    %edx,%eax
  800682:	c1 e0 02             	shl    $0x2,%eax
  800685:	01 d0                	add    %edx,%eax
  800687:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80068e:	01 d0                	add    %edx,%eax
  800690:	c1 e0 03             	shl    $0x3,%eax
  800693:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800698:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80069d:	a1 20 60 80 00       	mov    0x806020,%eax
  8006a2:	8a 40 20             	mov    0x20(%eax),%al
  8006a5:	84 c0                	test   %al,%al
  8006a7:	74 0d                	je     8006b6 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8006a9:	a1 20 60 80 00       	mov    0x806020,%eax
  8006ae:	83 c0 20             	add    $0x20,%eax
  8006b1:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006ba:	7e 0a                	jle    8006c6 <libmain+0x5f>
		binaryname = argv[0];
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 0c             	pushl  0xc(%ebp)
  8006cc:	ff 75 08             	pushl  0x8(%ebp)
  8006cf:	e8 64 f9 ff ff       	call   800038 <_main>
  8006d4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006d7:	a1 00 60 80 00       	mov    0x806000,%eax
  8006dc:	85 c0                	test   %eax,%eax
  8006de:	0f 84 01 01 00 00    	je     8007e5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8006e4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006ea:	bb 88 48 80 00       	mov    $0x804888,%ebx
  8006ef:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006f4:	89 c7                	mov    %eax,%edi
  8006f6:	89 de                	mov    %ebx,%esi
  8006f8:	89 d1                	mov    %edx,%ecx
  8006fa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006fc:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8006ff:	b9 56 00 00 00       	mov    $0x56,%ecx
  800704:	b0 00                	mov    $0x0,%al
  800706:	89 d7                	mov    %edx,%edi
  800708:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80070a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800711:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	50                   	push   %eax
  800718:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80071e:	50                   	push   %eax
  80071f:	e8 3c 2e 00 00       	call   803560 <sys_utilities>
  800724:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800727:	e8 85 29 00 00       	call   8030b1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80072c:	83 ec 0c             	sub    $0xc,%esp
  80072f:	68 a8 47 80 00       	push   $0x8047a8
  800734:	e8 be 01 00 00       	call   8008f7 <cprintf>
  800739:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80073c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80073f:	85 c0                	test   %eax,%eax
  800741:	74 18                	je     80075b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800743:	e8 36 2e 00 00       	call   80357e <sys_get_optimal_num_faults>
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	50                   	push   %eax
  80074c:	68 d0 47 80 00       	push   $0x8047d0
  800751:	e8 a1 01 00 00       	call   8008f7 <cprintf>
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	eb 59                	jmp    8007b4 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80075b:	a1 20 60 80 00       	mov    0x806020,%eax
  800760:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800766:	a1 20 60 80 00       	mov    0x806020,%eax
  80076b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800771:	83 ec 04             	sub    $0x4,%esp
  800774:	52                   	push   %edx
  800775:	50                   	push   %eax
  800776:	68 f4 47 80 00       	push   $0x8047f4
  80077b:	e8 77 01 00 00       	call   8008f7 <cprintf>
  800780:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800783:	a1 20 60 80 00       	mov    0x806020,%eax
  800788:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  80078e:	a1 20 60 80 00       	mov    0x806020,%eax
  800793:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800799:	a1 20 60 80 00       	mov    0x806020,%eax
  80079e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007a4:	51                   	push   %ecx
  8007a5:	52                   	push   %edx
  8007a6:	50                   	push   %eax
  8007a7:	68 1c 48 80 00       	push   $0x80481c
  8007ac:	e8 46 01 00 00       	call   8008f7 <cprintf>
  8007b1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007b4:	a1 20 60 80 00       	mov    0x806020,%eax
  8007b9:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	50                   	push   %eax
  8007c3:	68 74 48 80 00       	push   $0x804874
  8007c8:	e8 2a 01 00 00       	call   8008f7 <cprintf>
  8007cd:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	68 a8 47 80 00       	push   $0x8047a8
  8007d8:	e8 1a 01 00 00       	call   8008f7 <cprintf>
  8007dd:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007e0:	e8 e6 28 00 00       	call   8030cb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8007e5:	e8 1f 00 00 00       	call   800809 <exit>
}
  8007ea:	90                   	nop
  8007eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ee:	5b                   	pop    %ebx
  8007ef:	5e                   	pop    %esi
  8007f0:	5f                   	pop    %edi
  8007f1:	5d                   	pop    %ebp
  8007f2:	c3                   	ret    

008007f3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007f9:	83 ec 0c             	sub    $0xc,%esp
  8007fc:	6a 00                	push   $0x0
  8007fe:	e8 f3 2a 00 00       	call   8032f6 <sys_destroy_env>
  800803:	83 c4 10             	add    $0x10,%esp
}
  800806:	90                   	nop
  800807:	c9                   	leave  
  800808:	c3                   	ret    

00800809 <exit>:

void
exit(void)
{
  800809:	55                   	push   %ebp
  80080a:	89 e5                	mov    %esp,%ebp
  80080c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80080f:	e8 48 2b 00 00       	call   80335c <sys_exit_env>
}
  800814:	90                   	nop
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80081e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	8d 48 01             	lea    0x1(%eax),%ecx
  800826:	8b 55 0c             	mov    0xc(%ebp),%edx
  800829:	89 0a                	mov    %ecx,(%edx)
  80082b:	8b 55 08             	mov    0x8(%ebp),%edx
  80082e:	88 d1                	mov    %dl,%cl
  800830:	8b 55 0c             	mov    0xc(%ebp),%edx
  800833:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800841:	75 30                	jne    800873 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800843:	8b 15 38 61 83 00    	mov    0x836138,%edx
  800849:	a0 64 e0 81 00       	mov    0x81e064,%al
  80084e:	0f b6 c0             	movzbl %al,%eax
  800851:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800854:	8b 09                	mov    (%ecx),%ecx
  800856:	89 cb                	mov    %ecx,%ebx
  800858:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085b:	83 c1 08             	add    $0x8,%ecx
  80085e:	52                   	push   %edx
  80085f:	50                   	push   %eax
  800860:	53                   	push   %ebx
  800861:	51                   	push   %ecx
  800862:	e8 06 28 00 00       	call   80306d <sys_cputs>
  800867:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80086a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800873:	8b 45 0c             	mov    0xc(%ebp),%eax
  800876:	8b 40 04             	mov    0x4(%eax),%eax
  800879:	8d 50 01             	lea    0x1(%eax),%edx
  80087c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800882:	90                   	nop
  800883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800891:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800898:	00 00 00 
	b.cnt = 0;
  80089b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008a2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	ff 75 08             	pushl  0x8(%ebp)
  8008ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008b1:	50                   	push   %eax
  8008b2:	68 17 08 80 00       	push   $0x800817
  8008b7:	e8 5a 02 00 00       	call   800b16 <vprintfmt>
  8008bc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8008bf:	8b 15 38 61 83 00    	mov    0x836138,%edx
  8008c5:	a0 64 e0 81 00       	mov    0x81e064,%al
  8008ca:	0f b6 c0             	movzbl %al,%eax
  8008cd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8008d3:	52                   	push   %edx
  8008d4:	50                   	push   %eax
  8008d5:	51                   	push   %ecx
  8008d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008dc:	83 c0 08             	add    $0x8,%eax
  8008df:	50                   	push   %eax
  8008e0:	e8 88 27 00 00       	call   80306d <sys_cputs>
  8008e5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8008e8:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  8008ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8008f5:	c9                   	leave  
  8008f6:	c3                   	ret    

008008f7 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008fd:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800904:	8d 45 0c             	lea    0xc(%ebp),%eax
  800907:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	ff 75 f4             	pushl  -0xc(%ebp)
  800913:	50                   	push   %eax
  800914:	e8 6f ff ff ff       	call   800888 <vcprintf>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80091f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800922:	c9                   	leave  
  800923:	c3                   	ret    

00800924 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80092a:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	c1 e0 08             	shl    $0x8,%eax
  800937:	a3 38 61 83 00       	mov    %eax,0x836138
	va_start(ap, fmt);
  80093c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80093f:	83 c0 04             	add    $0x4,%eax
  800942:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800945:	8b 45 0c             	mov    0xc(%ebp),%eax
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 f4             	pushl  -0xc(%ebp)
  80094e:	50                   	push   %eax
  80094f:	e8 34 ff ff ff       	call   800888 <vcprintf>
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80095a:	c7 05 38 61 83 00 00 	movl   $0x700,0x836138
  800961:	07 00 00 

	return cnt;
  800964:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800967:	c9                   	leave  
  800968:	c3                   	ret    

00800969 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80096f:	e8 3d 27 00 00       	call   8030b1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800974:	8d 45 0c             	lea    0xc(%ebp),%eax
  800977:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 ff fe ff ff       	call   800888 <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80098f:	e8 37 27 00 00       	call   8030cb <sys_unlock_cons>
	return cnt;
  800994:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	53                   	push   %ebx
  80099d:	83 ec 14             	sub    $0x14,%esp
  8009a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009ac:	8b 45 18             	mov    0x18(%ebp),%eax
  8009af:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009b7:	77 55                	ja     800a0e <printnum+0x75>
  8009b9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009bc:	72 05                	jb     8009c3 <printnum+0x2a>
  8009be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009c1:	77 4b                	ja     800a0e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009c3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009c6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009c9:	8b 45 18             	mov    0x18(%ebp),%eax
  8009cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d1:	52                   	push   %edx
  8009d2:	50                   	push   %eax
  8009d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8009d9:	e8 6e 3a 00 00       	call   80444c <__udivdi3>
  8009de:	83 c4 10             	add    $0x10,%esp
  8009e1:	83 ec 04             	sub    $0x4,%esp
  8009e4:	ff 75 20             	pushl  0x20(%ebp)
  8009e7:	53                   	push   %ebx
  8009e8:	ff 75 18             	pushl  0x18(%ebp)
  8009eb:	52                   	push   %edx
  8009ec:	50                   	push   %eax
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	ff 75 08             	pushl  0x8(%ebp)
  8009f3:	e8 a1 ff ff ff       	call   800999 <printnum>
  8009f8:	83 c4 20             	add    $0x20,%esp
  8009fb:	eb 1a                	jmp    800a17 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	ff 75 20             	pushl  0x20(%ebp)
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a0e:	ff 4d 1c             	decl   0x1c(%ebp)
  800a11:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a15:	7f e6                	jg     8009fd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a17:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a25:	53                   	push   %ebx
  800a26:	51                   	push   %ecx
  800a27:	52                   	push   %edx
  800a28:	50                   	push   %eax
  800a29:	e8 2e 3b 00 00       	call   80455c <__umoddi3>
  800a2e:	83 c4 10             	add    $0x10,%esp
  800a31:	05 14 4b 80 00       	add    $0x804b14,%eax
  800a36:	8a 00                	mov    (%eax),%al
  800a38:	0f be c0             	movsbl %al,%eax
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	50                   	push   %eax
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
}
  800a4a:	90                   	nop
  800a4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4e:	c9                   	leave  
  800a4f:	c3                   	ret    

00800a50 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a53:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a57:	7e 1c                	jle    800a75 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8b 00                	mov    (%eax),%eax
  800a5e:	8d 50 08             	lea    0x8(%eax),%edx
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	89 10                	mov    %edx,(%eax)
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	8b 00                	mov    (%eax),%eax
  800a6b:	83 e8 08             	sub    $0x8,%eax
  800a6e:	8b 50 04             	mov    0x4(%eax),%edx
  800a71:	8b 00                	mov    (%eax),%eax
  800a73:	eb 40                	jmp    800ab5 <getuint+0x65>
	else if (lflag)
  800a75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a79:	74 1e                	je     800a99 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 00                	mov    (%eax),%eax
  800a80:	8d 50 04             	lea    0x4(%eax),%edx
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	89 10                	mov    %edx,(%eax)
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	8b 00                	mov    (%eax),%eax
  800a8d:	83 e8 04             	sub    $0x4,%eax
  800a90:	8b 00                	mov    (%eax),%eax
  800a92:	ba 00 00 00 00       	mov    $0x0,%edx
  800a97:	eb 1c                	jmp    800ab5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	8d 50 04             	lea    0x4(%eax),%edx
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	89 10                	mov    %edx,(%eax)
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	83 e8 04             	sub    $0x4,%eax
  800aae:	8b 00                	mov    (%eax),%eax
  800ab0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800abe:	7e 1c                	jle    800adc <getint+0x25>
		return va_arg(*ap, long long);
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8b 00                	mov    (%eax),%eax
  800ac5:	8d 50 08             	lea    0x8(%eax),%edx
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	89 10                	mov    %edx,(%eax)
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	8b 00                	mov    (%eax),%eax
  800ad2:	83 e8 08             	sub    $0x8,%eax
  800ad5:	8b 50 04             	mov    0x4(%eax),%edx
  800ad8:	8b 00                	mov    (%eax),%eax
  800ada:	eb 38                	jmp    800b14 <getint+0x5d>
	else if (lflag)
  800adc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae0:	74 1a                	je     800afc <getint+0x45>
		return va_arg(*ap, long);
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	8d 50 04             	lea    0x4(%eax),%edx
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	89 10                	mov    %edx,(%eax)
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	83 e8 04             	sub    $0x4,%eax
  800af7:	8b 00                	mov    (%eax),%eax
  800af9:	99                   	cltd   
  800afa:	eb 18                	jmp    800b14 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	8d 50 04             	lea    0x4(%eax),%edx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	89 10                	mov    %edx,(%eax)
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 00                	mov    (%eax),%eax
  800b0e:	83 e8 04             	sub    $0x4,%eax
  800b11:	8b 00                	mov    (%eax),%eax
  800b13:	99                   	cltd   
}
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	56                   	push   %esi
  800b1a:	53                   	push   %ebx
  800b1b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b1e:	eb 17                	jmp    800b37 <vprintfmt+0x21>
			if (ch == '\0')
  800b20:	85 db                	test   %ebx,%ebx
  800b22:	0f 84 c1 03 00 00    	je     800ee9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	53                   	push   %ebx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	ff d0                	call   *%eax
  800b34:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b37:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3a:	8d 50 01             	lea    0x1(%eax),%edx
  800b3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800b40:	8a 00                	mov    (%eax),%al
  800b42:	0f b6 d8             	movzbl %al,%ebx
  800b45:	83 fb 25             	cmp    $0x25,%ebx
  800b48:	75 d6                	jne    800b20 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b4a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b4e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b55:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b5c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b63:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6d:	8d 50 01             	lea    0x1(%eax),%edx
  800b70:	89 55 10             	mov    %edx,0x10(%ebp)
  800b73:	8a 00                	mov    (%eax),%al
  800b75:	0f b6 d8             	movzbl %al,%ebx
  800b78:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b7b:	83 f8 5b             	cmp    $0x5b,%eax
  800b7e:	0f 87 3d 03 00 00    	ja     800ec1 <vprintfmt+0x3ab>
  800b84:	8b 04 85 38 4b 80 00 	mov    0x804b38(,%eax,4),%eax
  800b8b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b8d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b91:	eb d7                	jmp    800b6a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b93:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b97:	eb d1                	jmp    800b6a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b99:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ba0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ba3:	89 d0                	mov    %edx,%eax
  800ba5:	c1 e0 02             	shl    $0x2,%eax
  800ba8:	01 d0                	add    %edx,%eax
  800baa:	01 c0                	add    %eax,%eax
  800bac:	01 d8                	add    %ebx,%eax
  800bae:	83 e8 30             	sub    $0x30,%eax
  800bb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb7:	8a 00                	mov    (%eax),%al
  800bb9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bbc:	83 fb 2f             	cmp    $0x2f,%ebx
  800bbf:	7e 3e                	jle    800bff <vprintfmt+0xe9>
  800bc1:	83 fb 39             	cmp    $0x39,%ebx
  800bc4:	7f 39                	jg     800bff <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bc9:	eb d5                	jmp    800ba0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd7:	83 e8 04             	sub    $0x4,%eax
  800bda:	8b 00                	mov    (%eax),%eax
  800bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800bdf:	eb 1f                	jmp    800c00 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800be1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be5:	79 83                	jns    800b6a <vprintfmt+0x54>
				width = 0;
  800be7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800bee:	e9 77 ff ff ff       	jmp    800b6a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800bf3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800bfa:	e9 6b ff ff ff       	jmp    800b6a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800bff:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c04:	0f 89 60 ff ff ff    	jns    800b6a <vprintfmt+0x54>
				width = precision, precision = -1;
  800c0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c10:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c17:	e9 4e ff ff ff       	jmp    800b6a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c1c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c1f:	e9 46 ff ff ff       	jmp    800b6a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	83 c0 04             	add    $0x4,%eax
  800c2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	50                   	push   %eax
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
			break;
  800c44:	e9 9b 02 00 00       	jmp    800ee4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c49:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4c:	83 c0 04             	add    $0x4,%eax
  800c4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c52:	8b 45 14             	mov    0x14(%ebp),%eax
  800c55:	83 e8 04             	sub    $0x4,%eax
  800c58:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c5a:	85 db                	test   %ebx,%ebx
  800c5c:	79 02                	jns    800c60 <vprintfmt+0x14a>
				err = -err;
  800c5e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c60:	83 fb 64             	cmp    $0x64,%ebx
  800c63:	7f 0b                	jg     800c70 <vprintfmt+0x15a>
  800c65:	8b 34 9d 80 49 80 00 	mov    0x804980(,%ebx,4),%esi
  800c6c:	85 f6                	test   %esi,%esi
  800c6e:	75 19                	jne    800c89 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c70:	53                   	push   %ebx
  800c71:	68 25 4b 80 00       	push   $0x804b25
  800c76:	ff 75 0c             	pushl  0xc(%ebp)
  800c79:	ff 75 08             	pushl  0x8(%ebp)
  800c7c:	e8 70 02 00 00       	call   800ef1 <printfmt>
  800c81:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c84:	e9 5b 02 00 00       	jmp    800ee4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c89:	56                   	push   %esi
  800c8a:	68 2e 4b 80 00       	push   $0x804b2e
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	ff 75 08             	pushl  0x8(%ebp)
  800c95:	e8 57 02 00 00       	call   800ef1 <printfmt>
  800c9a:	83 c4 10             	add    $0x10,%esp
			break;
  800c9d:	e9 42 02 00 00       	jmp    800ee4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca5:	83 c0 04             	add    $0x4,%eax
  800ca8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 e8 04             	sub    $0x4,%eax
  800cb1:	8b 30                	mov    (%eax),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 05                	jne    800cbc <vprintfmt+0x1a6>
				p = "(null)";
  800cb7:	be 31 4b 80 00       	mov    $0x804b31,%esi
			if (width > 0 && padc != '-')
  800cbc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc0:	7e 6d                	jle    800d2f <vprintfmt+0x219>
  800cc2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cc6:	74 67                	je     800d2f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	50                   	push   %eax
  800ccf:	56                   	push   %esi
  800cd0:	e8 1e 03 00 00       	call   800ff3 <strnlen>
  800cd5:	83 c4 10             	add    $0x10,%esp
  800cd8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cdb:	eb 16                	jmp    800cf3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cdd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ce1:	83 ec 08             	sub    $0x8,%esp
  800ce4:	ff 75 0c             	pushl  0xc(%ebp)
  800ce7:	50                   	push   %eax
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	ff d0                	call   *%eax
  800ced:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf0:	ff 4d e4             	decl   -0x1c(%ebp)
  800cf3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf7:	7f e4                	jg     800cdd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf9:	eb 34                	jmp    800d2f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800cfb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800cff:	74 1c                	je     800d1d <vprintfmt+0x207>
  800d01:	83 fb 1f             	cmp    $0x1f,%ebx
  800d04:	7e 05                	jle    800d0b <vprintfmt+0x1f5>
  800d06:	83 fb 7e             	cmp    $0x7e,%ebx
  800d09:	7e 12                	jle    800d1d <vprintfmt+0x207>
					putch('?', putdat);
  800d0b:	83 ec 08             	sub    $0x8,%esp
  800d0e:	ff 75 0c             	pushl  0xc(%ebp)
  800d11:	6a 3f                	push   $0x3f
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	ff d0                	call   *%eax
  800d18:	83 c4 10             	add    $0x10,%esp
  800d1b:	eb 0f                	jmp    800d2c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d1d:	83 ec 08             	sub    $0x8,%esp
  800d20:	ff 75 0c             	pushl  0xc(%ebp)
  800d23:	53                   	push   %ebx
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	ff d0                	call   *%eax
  800d29:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d2c:	ff 4d e4             	decl   -0x1c(%ebp)
  800d2f:	89 f0                	mov    %esi,%eax
  800d31:	8d 70 01             	lea    0x1(%eax),%esi
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f be d8             	movsbl %al,%ebx
  800d39:	85 db                	test   %ebx,%ebx
  800d3b:	74 24                	je     800d61 <vprintfmt+0x24b>
  800d3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d41:	78 b8                	js     800cfb <vprintfmt+0x1e5>
  800d43:	ff 4d e0             	decl   -0x20(%ebp)
  800d46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d4a:	79 af                	jns    800cfb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d4c:	eb 13                	jmp    800d61 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d4e:	83 ec 08             	sub    $0x8,%esp
  800d51:	ff 75 0c             	pushl  0xc(%ebp)
  800d54:	6a 20                	push   $0x20
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	ff d0                	call   *%eax
  800d5b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d5e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d65:	7f e7                	jg     800d4e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d67:	e9 78 01 00 00       	jmp    800ee4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d6c:	83 ec 08             	sub    $0x8,%esp
  800d6f:	ff 75 e8             	pushl  -0x18(%ebp)
  800d72:	8d 45 14             	lea    0x14(%ebp),%eax
  800d75:	50                   	push   %eax
  800d76:	e8 3c fd ff ff       	call   800ab7 <getint>
  800d7b:	83 c4 10             	add    $0x10,%esp
  800d7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d81:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d8a:	85 d2                	test   %edx,%edx
  800d8c:	79 23                	jns    800db1 <vprintfmt+0x29b>
				putch('-', putdat);
  800d8e:	83 ec 08             	sub    $0x8,%esp
  800d91:	ff 75 0c             	pushl  0xc(%ebp)
  800d94:	6a 2d                	push   $0x2d
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	ff d0                	call   *%eax
  800d9b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da4:	f7 d8                	neg    %eax
  800da6:	83 d2 00             	adc    $0x0,%edx
  800da9:	f7 da                	neg    %edx
  800dab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800db1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800db8:	e9 bc 00 00 00       	jmp    800e79 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dbd:	83 ec 08             	sub    $0x8,%esp
  800dc0:	ff 75 e8             	pushl  -0x18(%ebp)
  800dc3:	8d 45 14             	lea    0x14(%ebp),%eax
  800dc6:	50                   	push   %eax
  800dc7:	e8 84 fc ff ff       	call   800a50 <getuint>
  800dcc:	83 c4 10             	add    $0x10,%esp
  800dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800dd5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ddc:	e9 98 00 00 00       	jmp    800e79 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800de1:	83 ec 08             	sub    $0x8,%esp
  800de4:	ff 75 0c             	pushl  0xc(%ebp)
  800de7:	6a 58                	push   $0x58
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	ff d0                	call   *%eax
  800dee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	6a 58                	push   $0x58
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	ff d0                	call   *%eax
  800dfe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e01:	83 ec 08             	sub    $0x8,%esp
  800e04:	ff 75 0c             	pushl  0xc(%ebp)
  800e07:	6a 58                	push   $0x58
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	ff d0                	call   *%eax
  800e0e:	83 c4 10             	add    $0x10,%esp
			break;
  800e11:	e9 ce 00 00 00       	jmp    800ee4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 0c             	pushl  0xc(%ebp)
  800e1c:	6a 30                	push   $0x30
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	ff d0                	call   *%eax
  800e23:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	6a 78                	push   $0x78
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	ff d0                	call   *%eax
  800e33:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e36:	8b 45 14             	mov    0x14(%ebp),%eax
  800e39:	83 c0 04             	add    $0x4,%eax
  800e3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 e8 04             	sub    $0x4,%eax
  800e45:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e51:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e58:	eb 1f                	jmp    800e79 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 e8             	pushl  -0x18(%ebp)
  800e60:	8d 45 14             	lea    0x14(%ebp),%eax
  800e63:	50                   	push   %eax
  800e64:	e8 e7 fb ff ff       	call   800a50 <getuint>
  800e69:	83 c4 10             	add    $0x10,%esp
  800e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e72:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e79:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e80:	83 ec 04             	sub    $0x4,%esp
  800e83:	52                   	push   %edx
  800e84:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e87:	50                   	push   %eax
  800e88:	ff 75 f4             	pushl  -0xc(%ebp)
  800e8b:	ff 75 f0             	pushl  -0x10(%ebp)
  800e8e:	ff 75 0c             	pushl  0xc(%ebp)
  800e91:	ff 75 08             	pushl  0x8(%ebp)
  800e94:	e8 00 fb ff ff       	call   800999 <printnum>
  800e99:	83 c4 20             	add    $0x20,%esp
			break;
  800e9c:	eb 46                	jmp    800ee4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e9e:	83 ec 08             	sub    $0x8,%esp
  800ea1:	ff 75 0c             	pushl  0xc(%ebp)
  800ea4:	53                   	push   %ebx
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	ff d0                	call   *%eax
  800eaa:	83 c4 10             	add    $0x10,%esp
			break;
  800ead:	eb 35                	jmp    800ee4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800eaf:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  800eb6:	eb 2c                	jmp    800ee4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800eb8:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  800ebf:	eb 23                	jmp    800ee4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ec1:	83 ec 08             	sub    $0x8,%esp
  800ec4:	ff 75 0c             	pushl  0xc(%ebp)
  800ec7:	6a 25                	push   $0x25
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	ff d0                	call   *%eax
  800ece:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ed1:	ff 4d 10             	decl   0x10(%ebp)
  800ed4:	eb 03                	jmp    800ed9 <vprintfmt+0x3c3>
  800ed6:	ff 4d 10             	decl   0x10(%ebp)
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	48                   	dec    %eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	3c 25                	cmp    $0x25,%al
  800ee1:	75 f3                	jne    800ed6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ee3:	90                   	nop
		}
	}
  800ee4:	e9 35 fc ff ff       	jmp    800b1e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ee9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800eea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    

00800ef1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ef7:	8d 45 10             	lea    0x10(%ebp),%eax
  800efa:	83 c0 04             	add    $0x4,%eax
  800efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	ff 75 f4             	pushl  -0xc(%ebp)
  800f06:	50                   	push   %eax
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	ff 75 08             	pushl  0x8(%ebp)
  800f0d:	e8 04 fc ff ff       	call   800b16 <vprintfmt>
  800f12:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f15:	90                   	nop
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	8b 40 08             	mov    0x8(%eax),%eax
  800f21:	8d 50 01             	lea    0x1(%eax),%edx
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2d:	8b 10                	mov    (%eax),%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	8b 40 04             	mov    0x4(%eax),%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	73 12                	jae    800f4b <sprintputch+0x33>
		*b->buf++ = ch;
  800f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3c:	8b 00                	mov    (%eax),%eax
  800f3e:	8d 48 01             	lea    0x1(%eax),%ecx
  800f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f44:	89 0a                	mov    %ecx,(%edx)
  800f46:	8b 55 08             	mov    0x8(%ebp),%edx
  800f49:	88 10                	mov    %dl,(%eax)
}
  800f4b:	90                   	nop
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    

00800f4e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	01 d0                	add    %edx,%eax
  800f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f73:	74 06                	je     800f7b <vsnprintf+0x2d>
  800f75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f79:	7f 07                	jg     800f82 <vsnprintf+0x34>
		return -E_INVAL;
  800f7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800f80:	eb 20                	jmp    800fa2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f82:	ff 75 14             	pushl  0x14(%ebp)
  800f85:	ff 75 10             	pushl  0x10(%ebp)
  800f88:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f8b:	50                   	push   %eax
  800f8c:	68 18 0f 80 00       	push   $0x800f18
  800f91:	e8 80 fb ff ff       	call   800b16 <vprintfmt>
  800f96:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f9c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800faa:	8d 45 10             	lea    0x10(%ebp),%eax
  800fad:	83 c0 04             	add    $0x4,%eax
  800fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb9:	50                   	push   %eax
  800fba:	ff 75 0c             	pushl  0xc(%ebp)
  800fbd:	ff 75 08             	pushl  0x8(%ebp)
  800fc0:	e8 89 ff ff ff       	call   800f4e <vsnprintf>
  800fc5:	83 c4 10             	add    $0x10,%esp
  800fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fce:	c9                   	leave  
  800fcf:	c3                   	ret    

00800fd0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fdd:	eb 06                	jmp    800fe5 <strlen+0x15>
		n++;
  800fdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe2:	ff 45 08             	incl   0x8(%ebp)
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	84 c0                	test   %al,%al
  800fec:	75 f1                	jne    800fdf <strlen+0xf>
		n++;
	return n;
  800fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801000:	eb 09                	jmp    80100b <strnlen+0x18>
		n++;
  801002:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801005:	ff 45 08             	incl   0x8(%ebp)
  801008:	ff 4d 0c             	decl   0xc(%ebp)
  80100b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100f:	74 09                	je     80101a <strnlen+0x27>
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	84 c0                	test   %al,%al
  801018:	75 e8                	jne    801002 <strnlen+0xf>
		n++;
	return n;
  80101a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    

0080101f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80102b:	90                   	nop
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8d 50 01             	lea    0x1(%eax),%edx
  801032:	89 55 08             	mov    %edx,0x8(%ebp)
  801035:	8b 55 0c             	mov    0xc(%ebp),%edx
  801038:	8d 4a 01             	lea    0x1(%edx),%ecx
  80103b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80103e:	8a 12                	mov    (%edx),%dl
  801040:	88 10                	mov    %dl,(%eax)
  801042:	8a 00                	mov    (%eax),%al
  801044:	84 c0                	test   %al,%al
  801046:	75 e4                	jne    80102c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801048:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801060:	eb 1f                	jmp    801081 <strncpy+0x34>
		*dst++ = *src;
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8d 50 01             	lea    0x1(%eax),%edx
  801068:	89 55 08             	mov    %edx,0x8(%ebp)
  80106b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106e:	8a 12                	mov    (%edx),%dl
  801070:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801072:	8b 45 0c             	mov    0xc(%ebp),%eax
  801075:	8a 00                	mov    (%eax),%al
  801077:	84 c0                	test   %al,%al
  801079:	74 03                	je     80107e <strncpy+0x31>
			src++;
  80107b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80107e:	ff 45 fc             	incl   -0x4(%ebp)
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801084:	3b 45 10             	cmp    0x10(%ebp),%eax
  801087:	72 d9                	jb     801062 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80109a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109e:	74 30                	je     8010d0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010a0:	eb 16                	jmp    8010b8 <strlcpy+0x2a>
			*dst++ = *src++;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8d 50 01             	lea    0x1(%eax),%edx
  8010a8:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010b4:	8a 12                	mov    (%edx),%dl
  8010b6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010b8:	ff 4d 10             	decl   0x10(%ebp)
  8010bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bf:	74 09                	je     8010ca <strlcpy+0x3c>
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	75 d8                	jne    8010a2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d6:	29 c2                	sub    %eax,%edx
  8010d8:	89 d0                	mov    %edx,%eax
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010df:	eb 06                	jmp    8010e7 <strcmp+0xb>
		p++, q++;
  8010e1:	ff 45 08             	incl   0x8(%ebp)
  8010e4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	84 c0                	test   %al,%al
  8010ee:	74 0e                	je     8010fe <strcmp+0x22>
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 10                	mov    (%eax),%dl
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	38 c2                	cmp    %al,%dl
  8010fc:	74 e3                	je     8010e1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	0f b6 d0             	movzbl %al,%edx
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	0f b6 c0             	movzbl %al,%eax
  80110e:	29 c2                	sub    %eax,%edx
  801110:	89 d0                	mov    %edx,%eax
}
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801117:	eb 09                	jmp    801122 <strncmp+0xe>
		n--, p++, q++;
  801119:	ff 4d 10             	decl   0x10(%ebp)
  80111c:	ff 45 08             	incl   0x8(%ebp)
  80111f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801122:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801126:	74 17                	je     80113f <strncmp+0x2b>
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	84 c0                	test   %al,%al
  80112f:	74 0e                	je     80113f <strncmp+0x2b>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 10                	mov    (%eax),%dl
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	38 c2                	cmp    %al,%dl
  80113d:	74 da                	je     801119 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80113f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801143:	75 07                	jne    80114c <strncmp+0x38>
		return 0;
  801145:	b8 00 00 00 00       	mov    $0x0,%eax
  80114a:	eb 14                	jmp    801160 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f b6 d0             	movzbl %al,%edx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	0f b6 c0             	movzbl %al,%eax
  80115c:	29 c2                	sub    %eax,%edx
  80115e:	89 d0                	mov    %edx,%eax
}
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    

00801162 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 04             	sub    $0x4,%esp
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80116e:	eb 12                	jmp    801182 <strchr+0x20>
		if (*s == c)
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801178:	75 05                	jne    80117f <strchr+0x1d>
			return (char *) s;
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	eb 11                	jmp    801190 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	84 c0                	test   %al,%al
  801189:	75 e5                	jne    801170 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80118b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 04             	sub    $0x4,%esp
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80119e:	eb 0d                	jmp    8011ad <strfind+0x1b>
		if (*s == c)
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011a8:	74 0e                	je     8011b8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011aa:	ff 45 08             	incl   0x8(%ebp)
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	84 c0                	test   %al,%al
  8011b4:	75 ea                	jne    8011a0 <strfind+0xe>
  8011b6:	eb 01                	jmp    8011b9 <strfind+0x27>
		if (*s == c)
			break;
  8011b8:	90                   	nop
	return (char *) s;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011ca:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011ce:	76 63                	jbe    801233 <memset+0x75>
		uint64 data_block = c;
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	99                   	cltd   
  8011d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8011da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8011e4:	c1 e0 08             	shl    $0x8,%eax
  8011e7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011ea:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8011ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8011f7:	c1 e0 10             	shl    $0x10,%eax
  8011fa:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011fd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801203:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801206:	89 c2                	mov    %eax,%edx
  801208:	b8 00 00 00 00       	mov    $0x0,%eax
  80120d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801210:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801213:	eb 18                	jmp    80122d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801215:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801218:	8d 41 08             	lea    0x8(%ecx),%eax
  80121b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80121e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801224:	89 01                	mov    %eax,(%ecx)
  801226:	89 51 04             	mov    %edx,0x4(%ecx)
  801229:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80122d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801231:	77 e2                	ja     801215 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801233:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801237:	74 23                	je     80125c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801239:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80123f:	eb 0e                	jmp    80124f <memset+0x91>
			*p8++ = (uint8)c;
  801241:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801244:	8d 50 01             	lea    0x1(%eax),%edx
  801247:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80124a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80124f:	8b 45 10             	mov    0x10(%ebp),%eax
  801252:	8d 50 ff             	lea    -0x1(%eax),%edx
  801255:	89 55 10             	mov    %edx,0x10(%ebp)
  801258:	85 c0                	test   %eax,%eax
  80125a:	75 e5                	jne    801241 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125f:	c9                   	leave  
  801260:	c3                   	ret    

00801261 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801273:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801277:	76 24                	jbe    80129d <memcpy+0x3c>
		while(n >= 8){
  801279:	eb 1c                	jmp    801297 <memcpy+0x36>
			*d64 = *s64;
  80127b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80127e:	8b 50 04             	mov    0x4(%eax),%edx
  801281:	8b 00                	mov    (%eax),%eax
  801283:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801286:	89 01                	mov    %eax,(%ecx)
  801288:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80128b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80128f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801293:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801297:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80129b:	77 de                	ja     80127b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80129d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a1:	74 31                	je     8012d4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012af:	eb 16                	jmp    8012c7 <memcpy+0x66>
			*d8++ = *s8++;
  8012b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b4:	8d 50 01             	lea    0x1(%eax),%edx
  8012b7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012c3:	8a 12                	mov    (%edx),%dl
  8012c5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	75 dd                	jne    8012b1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    

008012d9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012f1:	73 50                	jae    801343 <memmove+0x6a>
  8012f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f9:	01 d0                	add    %edx,%eax
  8012fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012fe:	76 43                	jbe    801343 <memmove+0x6a>
		s += n;
  801300:	8b 45 10             	mov    0x10(%ebp),%eax
  801303:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80130c:	eb 10                	jmp    80131e <memmove+0x45>
			*--d = *--s;
  80130e:	ff 4d f8             	decl   -0x8(%ebp)
  801311:	ff 4d fc             	decl   -0x4(%ebp)
  801314:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801317:	8a 10                	mov    (%eax),%dl
  801319:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80131e:	8b 45 10             	mov    0x10(%ebp),%eax
  801321:	8d 50 ff             	lea    -0x1(%eax),%edx
  801324:	89 55 10             	mov    %edx,0x10(%ebp)
  801327:	85 c0                	test   %eax,%eax
  801329:	75 e3                	jne    80130e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80132b:	eb 23                	jmp    801350 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80132d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801330:	8d 50 01             	lea    0x1(%eax),%edx
  801333:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801336:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801339:	8d 4a 01             	lea    0x1(%edx),%ecx
  80133c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80133f:	8a 12                	mov    (%edx),%dl
  801341:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801343:	8b 45 10             	mov    0x10(%ebp),%eax
  801346:	8d 50 ff             	lea    -0x1(%eax),%edx
  801349:	89 55 10             	mov    %edx,0x10(%ebp)
  80134c:	85 c0                	test   %eax,%eax
  80134e:	75 dd                	jne    80132d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801353:	c9                   	leave  
  801354:	c3                   	ret    

00801355 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801367:	eb 2a                	jmp    801393 <memcmp+0x3e>
		if (*s1 != *s2)
  801369:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80136c:	8a 10                	mov    (%eax),%dl
  80136e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801371:	8a 00                	mov    (%eax),%al
  801373:	38 c2                	cmp    %al,%dl
  801375:	74 16                	je     80138d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801377:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	0f b6 d0             	movzbl %al,%edx
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	0f b6 c0             	movzbl %al,%eax
  801387:	29 c2                	sub    %eax,%edx
  801389:	89 d0                	mov    %edx,%eax
  80138b:	eb 18                	jmp    8013a5 <memcmp+0x50>
		s1++, s2++;
  80138d:	ff 45 fc             	incl   -0x4(%ebp)
  801390:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801393:	8b 45 10             	mov    0x10(%ebp),%eax
  801396:	8d 50 ff             	lea    -0x1(%eax),%edx
  801399:	89 55 10             	mov    %edx,0x10(%ebp)
  80139c:	85 c0                	test   %eax,%eax
  80139e:	75 c9                	jne    801369 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 d0                	add    %edx,%eax
  8013b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013b8:	eb 15                	jmp    8013cf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	0f b6 d0             	movzbl %al,%edx
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	0f b6 c0             	movzbl %al,%eax
  8013c8:	39 c2                	cmp    %eax,%edx
  8013ca:	74 0d                	je     8013d9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013cc:	ff 45 08             	incl   0x8(%ebp)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013d5:	72 e3                	jb     8013ba <memfind+0x13>
  8013d7:	eb 01                	jmp    8013da <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013d9:	90                   	nop
	return (void *) s;
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    

008013df <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013f3:	eb 03                	jmp    8013f8 <strtol+0x19>
		s++;
  8013f5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	3c 20                	cmp    $0x20,%al
  8013ff:	74 f4                	je     8013f5 <strtol+0x16>
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	3c 09                	cmp    $0x9,%al
  801408:	74 eb                	je     8013f5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	3c 2b                	cmp    $0x2b,%al
  801411:	75 05                	jne    801418 <strtol+0x39>
		s++;
  801413:	ff 45 08             	incl   0x8(%ebp)
  801416:	eb 13                	jmp    80142b <strtol+0x4c>
	else if (*s == '-')
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	3c 2d                	cmp    $0x2d,%al
  80141f:	75 0a                	jne    80142b <strtol+0x4c>
		s++, neg = 1;
  801421:	ff 45 08             	incl   0x8(%ebp)
  801424:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	74 06                	je     801437 <strtol+0x58>
  801431:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801435:	75 20                	jne    801457 <strtol+0x78>
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	3c 30                	cmp    $0x30,%al
  80143e:	75 17                	jne    801457 <strtol+0x78>
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	40                   	inc    %eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	3c 78                	cmp    $0x78,%al
  801448:	75 0d                	jne    801457 <strtol+0x78>
		s += 2, base = 16;
  80144a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80144e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801455:	eb 28                	jmp    80147f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801457:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145b:	75 15                	jne    801472 <strtol+0x93>
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 30                	cmp    $0x30,%al
  801464:	75 0c                	jne    801472 <strtol+0x93>
		s++, base = 8;
  801466:	ff 45 08             	incl   0x8(%ebp)
  801469:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801470:	eb 0d                	jmp    80147f <strtol+0xa0>
	else if (base == 0)
  801472:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801476:	75 07                	jne    80147f <strtol+0xa0>
		base = 10;
  801478:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 2f                	cmp    $0x2f,%al
  801486:	7e 19                	jle    8014a1 <strtol+0xc2>
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	3c 39                	cmp    $0x39,%al
  80148f:	7f 10                	jg     8014a1 <strtol+0xc2>
			dig = *s - '0';
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8a 00                	mov    (%eax),%al
  801496:	0f be c0             	movsbl %al,%eax
  801499:	83 e8 30             	sub    $0x30,%eax
  80149c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80149f:	eb 42                	jmp    8014e3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3c 60                	cmp    $0x60,%al
  8014a8:	7e 19                	jle    8014c3 <strtol+0xe4>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 7a                	cmp    $0x7a,%al
  8014b1:	7f 10                	jg     8014c3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	0f be c0             	movsbl %al,%eax
  8014bb:	83 e8 57             	sub    $0x57,%eax
  8014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014c1:	eb 20                	jmp    8014e3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	3c 40                	cmp    $0x40,%al
  8014ca:	7e 39                	jle    801505 <strtol+0x126>
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	3c 5a                	cmp    $0x5a,%al
  8014d3:	7f 30                	jg     801505 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	0f be c0             	movsbl %al,%eax
  8014dd:	83 e8 37             	sub    $0x37,%eax
  8014e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014e9:	7d 19                	jge    801504 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014eb:	ff 45 08             	incl   0x8(%ebp)
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014f5:	89 c2                	mov    %eax,%edx
  8014f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fa:	01 d0                	add    %edx,%eax
  8014fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014ff:	e9 7b ff ff ff       	jmp    80147f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801504:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801505:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801509:	74 08                	je     801513 <strtol+0x134>
		*endptr = (char *) s;
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	8b 55 08             	mov    0x8(%ebp),%edx
  801511:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801513:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801517:	74 07                	je     801520 <strtol+0x141>
  801519:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151c:	f7 d8                	neg    %eax
  80151e:	eb 03                	jmp    801523 <strtol+0x144>
  801520:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <ltostr>:

void
ltostr(long value, char *str)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80152b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801532:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801539:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80153d:	79 13                	jns    801552 <ltostr+0x2d>
	{
		neg = 1;
  80153f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801546:	8b 45 0c             	mov    0xc(%ebp),%eax
  801549:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80154c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80154f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80155a:	99                   	cltd   
  80155b:	f7 f9                	idiv   %ecx
  80155d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801560:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801563:	8d 50 01             	lea    0x1(%eax),%edx
  801566:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801569:	89 c2                	mov    %eax,%edx
  80156b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156e:	01 d0                	add    %edx,%eax
  801570:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801573:	83 c2 30             	add    $0x30,%edx
  801576:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801578:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80157b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801580:	f7 e9                	imul   %ecx
  801582:	c1 fa 02             	sar    $0x2,%edx
  801585:	89 c8                	mov    %ecx,%eax
  801587:	c1 f8 1f             	sar    $0x1f,%eax
  80158a:	29 c2                	sub    %eax,%edx
  80158c:	89 d0                	mov    %edx,%eax
  80158e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801591:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801595:	75 bb                	jne    801552 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801597:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80159e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a1:	48                   	dec    %eax
  8015a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015a9:	74 3d                	je     8015e8 <ltostr+0xc3>
		start = 1 ;
  8015ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015b2:	eb 34                	jmp    8015e8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c7:	01 c2                	add    %eax,%edx
  8015c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 c8                	add    %ecx,%eax
  8015d1:	8a 00                	mov    (%eax),%al
  8015d3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015db:	01 c2                	add    %eax,%edx
  8015dd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015e0:	88 02                	mov    %al,(%edx)
		start++ ;
  8015e2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015e5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015ee:	7c c4                	jl     8015b4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 d0                	add    %edx,%eax
  8015f8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015fb:	90                   	nop
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801604:	ff 75 08             	pushl  0x8(%ebp)
  801607:	e8 c4 f9 ff ff       	call   800fd0 <strlen>
  80160c:	83 c4 04             	add    $0x4,%esp
  80160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801612:	ff 75 0c             	pushl  0xc(%ebp)
  801615:	e8 b6 f9 ff ff       	call   800fd0 <strlen>
  80161a:	83 c4 04             	add    $0x4,%esp
  80161d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801620:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801627:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80162e:	eb 17                	jmp    801647 <strcconcat+0x49>
		final[s] = str1[s] ;
  801630:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	01 c2                	add    %eax,%edx
  801638:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	01 c8                	add    %ecx,%eax
  801640:	8a 00                	mov    (%eax),%al
  801642:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801644:	ff 45 fc             	incl   -0x4(%ebp)
  801647:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80164d:	7c e1                	jl     801630 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80164f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801656:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80165d:	eb 1f                	jmp    80167e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80165f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801662:	8d 50 01             	lea    0x1(%eax),%edx
  801665:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801668:	89 c2                	mov    %eax,%edx
  80166a:	8b 45 10             	mov    0x10(%ebp),%eax
  80166d:	01 c2                	add    %eax,%edx
  80166f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801672:	8b 45 0c             	mov    0xc(%ebp),%eax
  801675:	01 c8                	add    %ecx,%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80167b:	ff 45 f8             	incl   -0x8(%ebp)
  80167e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801681:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801684:	7c d9                	jl     80165f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801686:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801689:	8b 45 10             	mov    0x10(%ebp),%eax
  80168c:	01 d0                	add    %edx,%eax
  80168e:	c6 00 00             	movb   $0x0,(%eax)
}
  801691:	90                   	nop
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801697:	8b 45 14             	mov    0x14(%ebp),%eax
  80169a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a3:	8b 00                	mov    (%eax),%eax
  8016a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8016af:	01 d0                	add    %edx,%eax
  8016b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b7:	eb 0c                	jmp    8016c5 <strsplit+0x31>
			*string++ = 0;
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8d 50 01             	lea    0x1(%eax),%edx
  8016bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 00                	mov    (%eax),%al
  8016ca:	84 c0                	test   %al,%al
  8016cc:	74 18                	je     8016e6 <strsplit+0x52>
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	0f be c0             	movsbl %al,%eax
  8016d6:	50                   	push   %eax
  8016d7:	ff 75 0c             	pushl  0xc(%ebp)
  8016da:	e8 83 fa ff ff       	call   801162 <strchr>
  8016df:	83 c4 08             	add    $0x8,%esp
  8016e2:	85 c0                	test   %eax,%eax
  8016e4:	75 d3                	jne    8016b9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	8a 00                	mov    (%eax),%al
  8016eb:	84 c0                	test   %al,%al
  8016ed:	74 5a                	je     801749 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	83 f8 0f             	cmp    $0xf,%eax
  8016f7:	75 07                	jne    801700 <strsplit+0x6c>
		{
			return 0;
  8016f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fe:	eb 66                	jmp    801766 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801700:	8b 45 14             	mov    0x14(%ebp),%eax
  801703:	8b 00                	mov    (%eax),%eax
  801705:	8d 48 01             	lea    0x1(%eax),%ecx
  801708:	8b 55 14             	mov    0x14(%ebp),%edx
  80170b:	89 0a                	mov    %ecx,(%edx)
  80170d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801714:	8b 45 10             	mov    0x10(%ebp),%eax
  801717:	01 c2                	add    %eax,%edx
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80171e:	eb 03                	jmp    801723 <strsplit+0x8f>
			string++;
  801720:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	84 c0                	test   %al,%al
  80172a:	74 8b                	je     8016b7 <strsplit+0x23>
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	0f be c0             	movsbl %al,%eax
  801734:	50                   	push   %eax
  801735:	ff 75 0c             	pushl  0xc(%ebp)
  801738:	e8 25 fa ff ff       	call   801162 <strchr>
  80173d:	83 c4 08             	add    $0x8,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	74 dc                	je     801720 <strsplit+0x8c>
			string++;
	}
  801744:	e9 6e ff ff ff       	jmp    8016b7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801749:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80174a:	8b 45 14             	mov    0x14(%ebp),%eax
  80174d:	8b 00                	mov    (%eax),%eax
  80174f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801756:	8b 45 10             	mov    0x10(%ebp),%eax
  801759:	01 d0                	add    %edx,%eax
  80175b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801761:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801774:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80177b:	eb 4a                	jmp    8017c7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80177d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	01 c2                	add    %eax,%edx
  801785:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178b:	01 c8                	add    %ecx,%eax
  80178d:	8a 00                	mov    (%eax),%al
  80178f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801791:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	01 d0                	add    %edx,%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	3c 40                	cmp    $0x40,%al
  80179d:	7e 25                	jle    8017c4 <str2lower+0x5c>
  80179f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a5:	01 d0                	add    %edx,%eax
  8017a7:	8a 00                	mov    (%eax),%al
  8017a9:	3c 5a                	cmp    $0x5a,%al
  8017ab:	7f 17                	jg     8017c4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	01 d0                	add    %edx,%eax
  8017b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017bb:	01 ca                	add    %ecx,%edx
  8017bd:	8a 12                	mov    (%edx),%dl
  8017bf:	83 c2 20             	add    $0x20,%edx
  8017c2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8017c4:	ff 45 fc             	incl   -0x4(%ebp)
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	e8 01 f8 ff ff       	call   800fd0 <strlen>
  8017cf:	83 c4 04             	add    $0x4,%esp
  8017d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017d5:	7f a6                	jg     80177d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8017d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8017e2:	a1 08 60 80 00       	mov    0x806008,%eax
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	74 42                	je     80182d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8017eb:	83 ec 08             	sub    $0x8,%esp
  8017ee:	68 00 00 00 82       	push   $0x82000000
  8017f3:	68 00 00 00 80       	push   $0x80000000
  8017f8:	e8 b0 1e 00 00       	call   8036ad <initialize_dynamic_allocator>
  8017fd:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801800:	e8 96 1c 00 00       	call   80349b <sys_get_uheap_strategy>
  801805:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80180a:	a1 60 e0 81 00       	mov    0x81e060,%eax
  80180f:	05 00 10 00 00       	add    $0x1000,%eax
  801814:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801819:	a1 30 61 83 00       	mov    0x836130,%eax
  80181e:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801823:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  80182a:	00 00 00 
	}
}
  80182d:	90                   	nop
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801844:	83 ec 08             	sub    $0x8,%esp
  801847:	68 06 04 00 00       	push   $0x406
  80184c:	50                   	push   %eax
  80184d:	e8 93 18 00 00       	call   8030e5 <__sys_allocate_page>
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801858:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80185c:	79 14                	jns    801872 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80185e:	83 ec 04             	sub    $0x4,%esp
  801861:	68 a8 4c 80 00       	push   $0x804ca8
  801866:	6a 1f                	push   $0x1f
  801868:	68 e4 4c 80 00       	push   $0x804ce4
  80186d:	e8 82 28 00 00       	call   8040f4 <_panic>
	return 0;
  801872:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801888:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80188d:	83 ec 0c             	sub    $0xc,%esp
  801890:	50                   	push   %eax
  801891:	e8 96 18 00 00       	call   80312c <__sys_unmap_frame>
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80189c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018a0:	79 14                	jns    8018b6 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	68 f0 4c 80 00       	push   $0x804cf0
  8018aa:	6a 2a                	push   $0x2a
  8018ac:	68 e4 4c 80 00       	push   $0x804ce4
  8018b1:	e8 3e 28 00 00       	call   8040f4 <_panic>
}
  8018b6:	90                   	nop
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018bf:	e8 18 ff ff ff       	call   8017dc <uheap_init>
	if (size == 0) return NULL ;
  8018c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018c8:	75 0a                	jne    8018d4 <malloc+0x1b>
  8018ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cf:	e9 43 03 00 00       	jmp    801c17 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8018d4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8018db:	77 13                	ja     8018f0 <malloc+0x37>
    {
        return alloc_block(size);
  8018dd:	83 ec 0c             	sub    $0xc,%esp
  8018e0:	ff 75 08             	pushl  0x8(%ebp)
  8018e3:	e8 78 20 00 00       	call   803960 <alloc_block>
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	e9 27 03 00 00       	jmp    801c17 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8018f0:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8018f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018fd:	01 d0                	add    %edx,%eax
  8018ff:	48                   	dec    %eax
  801900:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801903:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801906:	ba 00 00 00 00       	mov    $0x0,%edx
  80190b:	f7 75 dc             	divl   -0x24(%ebp)
  80190e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801911:	29 d0                	sub    %edx,%eax
  801913:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801916:	a1 40 e0 81 00       	mov    0x81e040,%eax
  80191b:	85 c0                	test   %eax,%eax
  80191d:	75 0a                	jne    801929 <malloc+0x70>
    {
        uhp_inited = 1;
  80191f:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801926:	00 00 00 
    }

    int exactIdx = -1;
  801929:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801930:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801937:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80193e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801945:	e9 85 00 00 00       	jmp    8019cf <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80194a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80194d:	89 d0                	mov    %edx,%eax
  80194f:	01 c0                	add    %eax,%eax
  801951:	01 d0                	add    %edx,%eax
  801953:	c1 e0 02             	shl    $0x2,%eax
  801956:	05 48 20 81 00       	add    $0x812048,%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	84 c0                	test   %al,%al
  80195f:	74 20                	je     801981 <malloc+0xc8>
  801961:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801964:	89 d0                	mov    %edx,%eax
  801966:	01 c0                	add    %eax,%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	c1 e0 02             	shl    $0x2,%eax
  80196d:	05 44 20 81 00       	add    $0x812044,%eax
  801972:	8b 00                	mov    (%eax),%eax
  801974:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801977:	75 08                	jne    801981 <malloc+0xc8>
        {
            exactIdx = i;
  801979:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80197c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80197f:	eb 5b                	jmp    8019dc <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801981:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801984:	89 d0                	mov    %edx,%eax
  801986:	01 c0                	add    %eax,%eax
  801988:	01 d0                	add    %edx,%eax
  80198a:	c1 e0 02             	shl    $0x2,%eax
  80198d:	05 48 20 81 00       	add    $0x812048,%eax
  801992:	8a 00                	mov    (%eax),%al
  801994:	84 c0                	test   %al,%al
  801996:	74 34                	je     8019cc <malloc+0x113>
  801998:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80199b:	89 d0                	mov    %edx,%eax
  80199d:	01 c0                	add    %eax,%eax
  80199f:	01 d0                	add    %edx,%eax
  8019a1:	c1 e0 02             	shl    $0x2,%eax
  8019a4:	05 44 20 81 00       	add    $0x812044,%eax
  8019a9:	8b 00                	mov    (%eax),%eax
  8019ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8019ae:	76 1c                	jbe    8019cc <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8019b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019b3:	89 d0                	mov    %edx,%eax
  8019b5:	01 c0                	add    %eax,%eax
  8019b7:	01 d0                	add    %edx,%eax
  8019b9:	c1 e0 02             	shl    $0x2,%eax
  8019bc:	05 44 20 81 00       	add    $0x812044,%eax
  8019c1:	8b 00                	mov    (%eax),%eax
  8019c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8019c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019cc:	ff 45 e8             	incl   -0x18(%ebp)
  8019cf:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8019d6:	0f 8e 6e ff ff ff    	jle    80194a <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8019dc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8019e3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8019e7:	74 7d                	je     801a66 <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8019e9:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8019f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f3:	89 d0                	mov    %edx,%eax
  8019f5:	01 c0                	add    %eax,%eax
  8019f7:	01 d0                	add    %edx,%eax
  8019f9:	c1 e0 02             	shl    $0x2,%eax
  8019fc:	05 40 20 81 00       	add    $0x812040,%eax
  801a01:	8b 10                	mov    (%eax),%edx
  801a03:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801a06:	01 d0                	add    %edx,%eax
  801a08:	48                   	dec    %eax
  801a09:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801a0c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801a0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a14:	f7 75 bc             	divl   -0x44(%ebp)
  801a17:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801a1a:	29 d0                	sub    %edx,%eax
  801a1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a22:	89 d0                	mov    %edx,%eax
  801a24:	01 c0                	add    %eax,%eax
  801a26:	01 d0                	add    %edx,%eax
  801a28:	c1 e0 02             	shl    $0x2,%eax
  801a2b:	05 48 20 81 00       	add    $0x812048,%eax
  801a30:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a36:	89 d0                	mov    %edx,%eax
  801a38:	01 c0                	add    %eax,%eax
  801a3a:	01 d0                	add    %edx,%eax
  801a3c:	c1 e0 02             	shl    $0x2,%eax
  801a3f:	05 44 20 81 00       	add    $0x812044,%eax
  801a44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a4d:	89 d0                	mov    %edx,%eax
  801a4f:	01 c0                	add    %eax,%eax
  801a51:	01 d0                	add    %edx,%eax
  801a53:	c1 e0 02             	shl    $0x2,%eax
  801a56:	05 40 20 81 00       	add    $0x812040,%eax
  801a5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a61:	e9 2d 01 00 00       	jmp    801b93 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801a66:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801a6a:	0f 84 ce 00 00 00    	je     801b3e <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801a70:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801a77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a7a:	89 d0                	mov    %edx,%eax
  801a7c:	01 c0                	add    %eax,%eax
  801a7e:	01 d0                	add    %edx,%eax
  801a80:	c1 e0 02             	shl    $0x2,%eax
  801a83:	05 40 20 81 00       	add    $0x812040,%eax
  801a88:	8b 10                	mov    (%eax),%edx
  801a8a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a8d:	01 d0                	add    %edx,%eax
  801a8f:	48                   	dec    %eax
  801a90:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801a93:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a96:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9b:	f7 75 c4             	divl   -0x3c(%ebp)
  801a9e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801aa1:	29 d0                	sub    %edx,%eax
  801aa3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801aa6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa9:	89 d0                	mov    %edx,%eax
  801aab:	01 c0                	add    %eax,%eax
  801aad:	01 d0                	add    %edx,%eax
  801aaf:	c1 e0 02             	shl    $0x2,%eax
  801ab2:	05 44 20 81 00       	add    $0x812044,%eax
  801ab7:	8b 00                	mov    (%eax),%eax
  801ab9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801abc:	75 47                	jne    801b05 <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801abe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ac1:	89 d0                	mov    %edx,%eax
  801ac3:	01 c0                	add    %eax,%eax
  801ac5:	01 d0                	add    %edx,%eax
  801ac7:	c1 e0 02             	shl    $0x2,%eax
  801aca:	05 48 20 81 00       	add    $0x812048,%eax
  801acf:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801ad2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ad5:	89 d0                	mov    %edx,%eax
  801ad7:	01 c0                	add    %eax,%eax
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	c1 e0 02             	shl    $0x2,%eax
  801ade:	05 44 20 81 00       	add    $0x812044,%eax
  801ae3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801ae9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aec:	89 d0                	mov    %edx,%eax
  801aee:	01 c0                	add    %eax,%eax
  801af0:	01 d0                	add    %edx,%eax
  801af2:	c1 e0 02             	shl    $0x2,%eax
  801af5:	05 40 20 81 00       	add    $0x812040,%eax
  801afa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b00:	e9 8e 00 00 00       	jmp    801b93 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801b05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b0b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801b0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b11:	89 d0                	mov    %edx,%eax
  801b13:	01 c0                	add    %eax,%eax
  801b15:	01 d0                	add    %edx,%eax
  801b17:	c1 e0 02             	shl    $0x2,%eax
  801b1a:	05 40 20 81 00       	add    $0x812040,%eax
  801b1f:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801b21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b24:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b27:	89 c2                	mov    %eax,%edx
  801b29:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b2c:	89 c8                	mov    %ecx,%eax
  801b2e:	01 c0                	add    %eax,%eax
  801b30:	01 c8                	add    %ecx,%eax
  801b32:	c1 e0 02             	shl    $0x2,%eax
  801b35:	05 44 20 81 00       	add    $0x812044,%eax
  801b3a:	89 10                	mov    %edx,(%eax)
  801b3c:	eb 55                	jmp    801b93 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801b3e:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801b45:	8b 15 88 60 83 00    	mov    0x836088,%edx
  801b4b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b4e:	01 d0                	add    %edx,%eax
  801b50:	48                   	dec    %eax
  801b51:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b57:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5c:	f7 75 d0             	divl   -0x30(%ebp)
  801b5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b62:	29 d0                	sub    %edx,%eax
  801b64:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801b67:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801b6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b6d:	01 d0                	add    %edx,%eax
  801b6f:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801b74:	76 0a                	jbe    801b80 <malloc+0x2c7>
            return NULL;
  801b76:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7b:	e9 97 00 00 00       	jmp    801c17 <malloc+0x35e>
        va = start;
  801b80:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801b86:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801b89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b8c:	01 d0                	add    %edx,%eax
  801b8e:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b93:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b9a:	eb 5e                	jmp    801bfa <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801b9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b9f:	89 d0                	mov    %edx,%eax
  801ba1:	01 c0                	add    %eax,%eax
  801ba3:	01 d0                	add    %edx,%eax
  801ba5:	c1 e0 02             	shl    $0x2,%eax
  801ba8:	05 48 60 80 00       	add    $0x806048,%eax
  801bad:	8a 00                	mov    (%eax),%al
  801baf:	84 c0                	test   %al,%al
  801bb1:	75 44                	jne    801bf7 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801bb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bb6:	89 d0                	mov    %edx,%eax
  801bb8:	01 c0                	add    %eax,%eax
  801bba:	01 d0                	add    %edx,%eax
  801bbc:	c1 e0 02             	shl    $0x2,%eax
  801bbf:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801bc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801bca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bcd:	89 d0                	mov    %edx,%eax
  801bcf:	01 c0                	add    %eax,%eax
  801bd1:	01 d0                	add    %edx,%eax
  801bd3:	c1 e0 02             	shl    $0x2,%eax
  801bd6:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801bdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bdf:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801be1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801be4:	89 d0                	mov    %edx,%eax
  801be6:	01 c0                	add    %eax,%eax
  801be8:	01 d0                	add    %edx,%eax
  801bea:	c1 e0 02             	shl    $0x2,%eax
  801bed:	05 48 60 80 00       	add    $0x806048,%eax
  801bf2:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801bf5:	eb 0c                	jmp    801c03 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801bf7:	ff 45 e0             	incl   -0x20(%ebp)
  801bfa:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801c01:	7e 99                	jle    801b9c <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801c03:	83 ec 08             	sub    $0x8,%esp
  801c06:	ff 75 d4             	pushl  -0x2c(%ebp)
  801c09:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c0c:	e8 a2 19 00 00       	call   8035b3 <sys_allocate_user_mem>
  801c11:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801c1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c23:	0f 84 fa 03 00 00    	je     802023 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801c2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c32:	85 c0                	test   %eax,%eax
  801c34:	79 1c                	jns    801c52 <free+0x39>
  801c36:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801c3d:	77 13                	ja     801c52 <free+0x39>
    {
        free_block(virtual_address);
  801c3f:	83 ec 0c             	sub    $0xc,%esp
  801c42:	ff 75 08             	pushl  0x8(%ebp)
  801c45:	e8 09 21 00 00       	call   803d53 <free_block>
  801c4a:	83 c4 10             	add    $0x10,%esp
        return;
  801c4d:	e9 d2 03 00 00       	jmp    802024 <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801c52:	a1 30 61 83 00       	mov    0x836130,%eax
  801c57:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801c5a:	72 09                	jb     801c65 <free+0x4c>
  801c5c:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801c63:	76 17                	jbe    801c7c <free+0x63>
        panic("free: invalid address");
  801c65:	83 ec 04             	sub    $0x4,%esp
  801c68:	68 2d 4d 80 00       	push   $0x804d2d
  801c6d:	68 9b 00 00 00       	push   $0x9b
  801c72:	68 e4 4c 80 00       	push   $0x804ce4
  801c77:	e8 78 24 00 00       	call   8040f4 <_panic>

    uint32 size = 0;
  801c7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801c83:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c8a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801c91:	eb 50                	jmp    801ce3 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801c93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c96:	89 d0                	mov    %edx,%eax
  801c98:	01 c0                	add    %eax,%eax
  801c9a:	01 d0                	add    %edx,%eax
  801c9c:	c1 e0 02             	shl    $0x2,%eax
  801c9f:	05 48 60 80 00       	add    $0x806048,%eax
  801ca4:	8a 00                	mov    (%eax),%al
  801ca6:	84 c0                	test   %al,%al
  801ca8:	74 36                	je     801ce0 <free+0xc7>
  801caa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cad:	89 d0                	mov    %edx,%eax
  801caf:	01 c0                	add    %eax,%eax
  801cb1:	01 d0                	add    %edx,%eax
  801cb3:	c1 e0 02             	shl    $0x2,%eax
  801cb6:	05 40 60 80 00       	add    $0x806040,%eax
  801cbb:	8b 00                	mov    (%eax),%eax
  801cbd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801cc0:	75 1e                	jne    801ce0 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801cc2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cc5:	89 d0                	mov    %edx,%eax
  801cc7:	01 c0                	add    %eax,%eax
  801cc9:	01 d0                	add    %edx,%eax
  801ccb:	c1 e0 02             	shl    $0x2,%eax
  801cce:	05 44 60 80 00       	add    $0x806044,%eax
  801cd3:	8b 00                	mov    (%eax),%eax
  801cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801cde:	eb 0c                	jmp    801cec <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ce0:	ff 45 ec             	incl   -0x14(%ebp)
  801ce3:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801cea:	7e a7                	jle    801c93 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801cec:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801cf0:	74 06                	je     801cf8 <free+0xdf>
  801cf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cf6:	75 17                	jne    801d0f <free+0xf6>
        panic("free: unknown block");
  801cf8:	83 ec 04             	sub    $0x4,%esp
  801cfb:	68 43 4d 80 00       	push   $0x804d43
  801d00:	68 a9 00 00 00       	push   $0xa9
  801d05:	68 e4 4c 80 00       	push   $0x804ce4
  801d0a:	e8 e5 23 00 00       	call   8040f4 <_panic>

    uhp_allocs[idx].used = 0;
  801d0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d12:	89 d0                	mov    %edx,%eax
  801d14:	01 c0                	add    %eax,%eax
  801d16:	01 d0                	add    %edx,%eax
  801d18:	c1 e0 02             	shl    $0x2,%eax
  801d1b:	05 48 60 80 00       	add    $0x806048,%eax
  801d20:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801d23:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d2a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801d31:	eb 64                	jmp    801d97 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801d33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d36:	89 d0                	mov    %edx,%eax
  801d38:	01 c0                	add    %eax,%eax
  801d3a:	01 d0                	add    %edx,%eax
  801d3c:	c1 e0 02             	shl    $0x2,%eax
  801d3f:	05 48 20 81 00       	add    $0x812048,%eax
  801d44:	8a 00                	mov    (%eax),%al
  801d46:	84 c0                	test   %al,%al
  801d48:	75 4a                	jne    801d94 <free+0x17b>
        {
            uhp_frees[i].va = va;
  801d4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d4d:	89 d0                	mov    %edx,%eax
  801d4f:	01 c0                	add    %eax,%eax
  801d51:	01 d0                	add    %edx,%eax
  801d53:	c1 e0 02             	shl    $0x2,%eax
  801d56:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  801d5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d5f:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801d61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d64:	89 d0                	mov    %edx,%eax
  801d66:	01 c0                	add    %eax,%eax
  801d68:	01 d0                	add    %edx,%eax
  801d6a:	c1 e0 02             	shl    $0x2,%eax
  801d6d:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  801d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d76:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801d78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d7b:	89 d0                	mov    %edx,%eax
  801d7d:	01 c0                	add    %eax,%eax
  801d7f:	01 d0                	add    %edx,%eax
  801d81:	c1 e0 02             	shl    $0x2,%eax
  801d84:	05 48 20 81 00       	add    $0x812048,%eax
  801d89:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801d8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801d92:	eb 0c                	jmp    801da0 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d94:	ff 45 e4             	incl   -0x1c(%ebp)
  801d97:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801d9e:	7e 93                	jle    801d33 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801da0:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801da4:	0f 84 f1 01 00 00    	je     801f9b <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801daa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801db1:	e9 d8 01 00 00       	jmp    801f8e <free+0x375>
        {
            if (i == fidx) continue;
  801db6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801dbc:	0f 84 c8 01 00 00    	je     801f8a <free+0x371>
            if (uhp_frees[i].free)
  801dc2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dc5:	89 d0                	mov    %edx,%eax
  801dc7:	01 c0                	add    %eax,%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	c1 e0 02             	shl    $0x2,%eax
  801dce:	05 48 20 81 00       	add    $0x812048,%eax
  801dd3:	8a 00                	mov    (%eax),%al
  801dd5:	84 c0                	test   %al,%al
  801dd7:	0f 84 ae 01 00 00    	je     801f8b <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801ddd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801de0:	89 d0                	mov    %edx,%eax
  801de2:	01 c0                	add    %eax,%eax
  801de4:	01 d0                	add    %edx,%eax
  801de6:	c1 e0 02             	shl    $0x2,%eax
  801de9:	05 40 20 81 00       	add    $0x812040,%eax
  801dee:	8b 08                	mov    (%eax),%ecx
  801df0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801df3:	89 d0                	mov    %edx,%eax
  801df5:	01 c0                	add    %eax,%eax
  801df7:	01 d0                	add    %edx,%eax
  801df9:	c1 e0 02             	shl    $0x2,%eax
  801dfc:	05 44 20 81 00       	add    $0x812044,%eax
  801e01:	8b 00                	mov    (%eax),%eax
  801e03:	01 c1                	add    %eax,%ecx
  801e05:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e08:	89 d0                	mov    %edx,%eax
  801e0a:	01 c0                	add    %eax,%eax
  801e0c:	01 d0                	add    %edx,%eax
  801e0e:	c1 e0 02             	shl    $0x2,%eax
  801e11:	05 40 20 81 00       	add    $0x812040,%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	39 c1                	cmp    %eax,%ecx
  801e1a:	0f 85 a8 00 00 00    	jne    801ec8 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801e20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e23:	89 d0                	mov    %edx,%eax
  801e25:	01 c0                	add    %eax,%eax
  801e27:	01 d0                	add    %edx,%eax
  801e29:	c1 e0 02             	shl    $0x2,%eax
  801e2c:	05 40 20 81 00       	add    $0x812040,%eax
  801e31:	8b 10                	mov    (%eax),%edx
  801e33:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801e36:	89 c8                	mov    %ecx,%eax
  801e38:	01 c0                	add    %eax,%eax
  801e3a:	01 c8                	add    %ecx,%eax
  801e3c:	c1 e0 02             	shl    $0x2,%eax
  801e3f:	05 40 20 81 00       	add    $0x812040,%eax
  801e44:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801e46:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e49:	89 d0                	mov    %edx,%eax
  801e4b:	01 c0                	add    %eax,%eax
  801e4d:	01 d0                	add    %edx,%eax
  801e4f:	c1 e0 02             	shl    $0x2,%eax
  801e52:	05 44 20 81 00       	add    $0x812044,%eax
  801e57:	8b 08                	mov    (%eax),%ecx
  801e59:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e5c:	89 d0                	mov    %edx,%eax
  801e5e:	01 c0                	add    %eax,%eax
  801e60:	01 d0                	add    %edx,%eax
  801e62:	c1 e0 02             	shl    $0x2,%eax
  801e65:	05 44 20 81 00       	add    $0x812044,%eax
  801e6a:	8b 00                	mov    (%eax),%eax
  801e6c:	01 c1                	add    %eax,%ecx
  801e6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e71:	89 d0                	mov    %edx,%eax
  801e73:	01 c0                	add    %eax,%eax
  801e75:	01 d0                	add    %edx,%eax
  801e77:	c1 e0 02             	shl    $0x2,%eax
  801e7a:	05 44 20 81 00       	add    $0x812044,%eax
  801e7f:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801e81:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e84:	89 d0                	mov    %edx,%eax
  801e86:	01 c0                	add    %eax,%eax
  801e88:	01 d0                	add    %edx,%eax
  801e8a:	c1 e0 02             	shl    $0x2,%eax
  801e8d:	05 48 20 81 00       	add    $0x812048,%eax
  801e92:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801e95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e98:	89 d0                	mov    %edx,%eax
  801e9a:	01 c0                	add    %eax,%eax
  801e9c:	01 d0                	add    %edx,%eax
  801e9e:	c1 e0 02             	shl    $0x2,%eax
  801ea1:	05 40 20 81 00       	add    $0x812040,%eax
  801ea6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801eac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eaf:	89 d0                	mov    %edx,%eax
  801eb1:	01 c0                	add    %eax,%eax
  801eb3:	01 d0                	add    %edx,%eax
  801eb5:	c1 e0 02             	shl    $0x2,%eax
  801eb8:	05 44 20 81 00       	add    $0x812044,%eax
  801ebd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ec3:	e9 c3 00 00 00       	jmp    801f8b <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801ec8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ecb:	89 d0                	mov    %edx,%eax
  801ecd:	01 c0                	add    %eax,%eax
  801ecf:	01 d0                	add    %edx,%eax
  801ed1:	c1 e0 02             	shl    $0x2,%eax
  801ed4:	05 40 20 81 00       	add    $0x812040,%eax
  801ed9:	8b 08                	mov    (%eax),%ecx
  801edb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ede:	89 d0                	mov    %edx,%eax
  801ee0:	01 c0                	add    %eax,%eax
  801ee2:	01 d0                	add    %edx,%eax
  801ee4:	c1 e0 02             	shl    $0x2,%eax
  801ee7:	05 44 20 81 00       	add    $0x812044,%eax
  801eec:	8b 00                	mov    (%eax),%eax
  801eee:	01 c1                	add    %eax,%ecx
  801ef0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ef3:	89 d0                	mov    %edx,%eax
  801ef5:	01 c0                	add    %eax,%eax
  801ef7:	01 d0                	add    %edx,%eax
  801ef9:	c1 e0 02             	shl    $0x2,%eax
  801efc:	05 40 20 81 00       	add    $0x812040,%eax
  801f01:	8b 00                	mov    (%eax),%eax
  801f03:	39 c1                	cmp    %eax,%ecx
  801f05:	0f 85 80 00 00 00    	jne    801f8b <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801f0b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f0e:	89 d0                	mov    %edx,%eax
  801f10:	01 c0                	add    %eax,%eax
  801f12:	01 d0                	add    %edx,%eax
  801f14:	c1 e0 02             	shl    $0x2,%eax
  801f17:	05 44 20 81 00       	add    $0x812044,%eax
  801f1c:	8b 08                	mov    (%eax),%ecx
  801f1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f21:	89 d0                	mov    %edx,%eax
  801f23:	01 c0                	add    %eax,%eax
  801f25:	01 d0                	add    %edx,%eax
  801f27:	c1 e0 02             	shl    $0x2,%eax
  801f2a:	05 44 20 81 00       	add    $0x812044,%eax
  801f2f:	8b 00                	mov    (%eax),%eax
  801f31:	01 c1                	add    %eax,%ecx
  801f33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f36:	89 d0                	mov    %edx,%eax
  801f38:	01 c0                	add    %eax,%eax
  801f3a:	01 d0                	add    %edx,%eax
  801f3c:	c1 e0 02             	shl    $0x2,%eax
  801f3f:	05 44 20 81 00       	add    $0x812044,%eax
  801f44:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801f46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f49:	89 d0                	mov    %edx,%eax
  801f4b:	01 c0                	add    %eax,%eax
  801f4d:	01 d0                	add    %edx,%eax
  801f4f:	c1 e0 02             	shl    $0x2,%eax
  801f52:	05 48 20 81 00       	add    $0x812048,%eax
  801f57:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801f5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f5d:	89 d0                	mov    %edx,%eax
  801f5f:	01 c0                	add    %eax,%eax
  801f61:	01 d0                	add    %edx,%eax
  801f63:	c1 e0 02             	shl    $0x2,%eax
  801f66:	05 40 20 81 00       	add    $0x812040,%eax
  801f6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801f71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f74:	89 d0                	mov    %edx,%eax
  801f76:	01 c0                	add    %eax,%eax
  801f78:	01 d0                	add    %edx,%eax
  801f7a:	c1 e0 02             	shl    $0x2,%eax
  801f7d:	05 44 20 81 00       	add    $0x812044,%eax
  801f82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f88:	eb 01                	jmp    801f8b <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801f8a:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f8b:	ff 45 e0             	incl   -0x20(%ebp)
  801f8e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f95:	0f 8e 1b fe ff ff    	jle    801db6 <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801f9b:	a1 30 61 83 00       	mov    0x836130,%eax
  801fa0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fa3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801faa:	eb 53                	jmp    801fff <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801fac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801faf:	89 d0                	mov    %edx,%eax
  801fb1:	01 c0                	add    %eax,%eax
  801fb3:	01 d0                	add    %edx,%eax
  801fb5:	c1 e0 02             	shl    $0x2,%eax
  801fb8:	05 48 60 80 00       	add    $0x806048,%eax
  801fbd:	8a 00                	mov    (%eax),%al
  801fbf:	84 c0                	test   %al,%al
  801fc1:	74 39                	je     801ffc <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801fc3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fc6:	89 d0                	mov    %edx,%eax
  801fc8:	01 c0                	add    %eax,%eax
  801fca:	01 d0                	add    %edx,%eax
  801fcc:	c1 e0 02             	shl    $0x2,%eax
  801fcf:	05 40 60 80 00       	add    $0x806040,%eax
  801fd4:	8b 08                	mov    (%eax),%ecx
  801fd6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fd9:	89 d0                	mov    %edx,%eax
  801fdb:	01 c0                	add    %eax,%eax
  801fdd:	01 d0                	add    %edx,%eax
  801fdf:	c1 e0 02             	shl    $0x2,%eax
  801fe2:	05 44 60 80 00       	add    $0x806044,%eax
  801fe7:	8b 00                	mov    (%eax),%eax
  801fe9:	01 c8                	add    %ecx,%eax
  801feb:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801fee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ff1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801ff4:	76 06                	jbe    801ffc <free+0x3e3>
  801ff6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ff9:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ffc:	ff 45 d8             	incl   -0x28(%ebp)
  801fff:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802006:	7e a4                	jle    801fac <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  802008:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80200b:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  802010:	83 ec 08             	sub    $0x8,%esp
  802013:	ff 75 f4             	pushl  -0xc(%ebp)
  802016:	ff 75 d4             	pushl  -0x2c(%ebp)
  802019:	e8 79 15 00 00       	call   803597 <sys_free_user_mem>
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	eb 01                	jmp    802024 <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  802023:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 68             	sub    $0x68,%esp
  80202c:	8b 45 10             	mov    0x10(%ebp),%eax
  80202f:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802032:	e8 a5 f7 ff ff       	call   8017dc <uheap_init>
	if (size == 0) return NULL ;
  802037:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80203b:	75 0a                	jne    802047 <smalloc+0x21>
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
  802042:	e9 37 03 00 00       	jmp    80237e <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  802047:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80204e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802051:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802054:	01 d0                	add    %edx,%eax
  802056:	48                   	dec    %eax
  802057:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80205a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80205d:	ba 00 00 00 00       	mov    $0x0,%edx
  802062:	f7 75 dc             	divl   -0x24(%ebp)
  802065:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802068:	29 d0                	sub    %edx,%eax
  80206a:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  80206d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802074:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80207b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802082:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802089:	e9 85 00 00 00       	jmp    802113 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80208e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802091:	89 d0                	mov    %edx,%eax
  802093:	01 c0                	add    %eax,%eax
  802095:	01 d0                	add    %edx,%eax
  802097:	c1 e0 02             	shl    $0x2,%eax
  80209a:	05 48 20 81 00       	add    $0x812048,%eax
  80209f:	8a 00                	mov    (%eax),%al
  8020a1:	84 c0                	test   %al,%al
  8020a3:	74 20                	je     8020c5 <smalloc+0x9f>
  8020a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020a8:	89 d0                	mov    %edx,%eax
  8020aa:	01 c0                	add    %eax,%eax
  8020ac:	01 d0                	add    %edx,%eax
  8020ae:	c1 e0 02             	shl    $0x2,%eax
  8020b1:	05 44 20 81 00       	add    $0x812044,%eax
  8020b6:	8b 00                	mov    (%eax),%eax
  8020b8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8020bb:	75 08                	jne    8020c5 <smalloc+0x9f>
        {
            exactIdx = i;
  8020bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8020c3:	eb 5b                	jmp    802120 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8020c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020c8:	89 d0                	mov    %edx,%eax
  8020ca:	01 c0                	add    %eax,%eax
  8020cc:	01 d0                	add    %edx,%eax
  8020ce:	c1 e0 02             	shl    $0x2,%eax
  8020d1:	05 48 20 81 00       	add    $0x812048,%eax
  8020d6:	8a 00                	mov    (%eax),%al
  8020d8:	84 c0                	test   %al,%al
  8020da:	74 34                	je     802110 <smalloc+0xea>
  8020dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020df:	89 d0                	mov    %edx,%eax
  8020e1:	01 c0                	add    %eax,%eax
  8020e3:	01 d0                	add    %edx,%eax
  8020e5:	c1 e0 02             	shl    $0x2,%eax
  8020e8:	05 44 20 81 00       	add    $0x812044,%eax
  8020ed:	8b 00                	mov    (%eax),%eax
  8020ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020f2:	76 1c                	jbe    802110 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  8020f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020f7:	89 d0                	mov    %edx,%eax
  8020f9:	01 c0                	add    %eax,%eax
  8020fb:	01 d0                	add    %edx,%eax
  8020fd:	c1 e0 02             	shl    $0x2,%eax
  802100:	05 44 20 81 00       	add    $0x812044,%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80210a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80210d:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802110:	ff 45 e8             	incl   -0x18(%ebp)
  802113:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80211a:	0f 8e 6e ff ff ff    	jle    80208e <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802120:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802127:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80212b:	74 7d                	je     8021aa <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80212d:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802137:	89 d0                	mov    %edx,%eax
  802139:	01 c0                	add    %eax,%eax
  80213b:	01 d0                	add    %edx,%eax
  80213d:	c1 e0 02             	shl    $0x2,%eax
  802140:	05 40 20 81 00       	add    $0x812040,%eax
  802145:	8b 10                	mov    (%eax),%edx
  802147:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80214a:	01 d0                	add    %edx,%eax
  80214c:	48                   	dec    %eax
  80214d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802150:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802153:	ba 00 00 00 00       	mov    $0x0,%edx
  802158:	f7 75 bc             	divl   -0x44(%ebp)
  80215b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80215e:	29 d0                	sub    %edx,%eax
  802160:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802163:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802166:	89 d0                	mov    %edx,%eax
  802168:	01 c0                	add    %eax,%eax
  80216a:	01 d0                	add    %edx,%eax
  80216c:	c1 e0 02             	shl    $0x2,%eax
  80216f:	05 48 20 81 00       	add    $0x812048,%eax
  802174:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802177:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217a:	89 d0                	mov    %edx,%eax
  80217c:	01 c0                	add    %eax,%eax
  80217e:	01 d0                	add    %edx,%eax
  802180:	c1 e0 02             	shl    $0x2,%eax
  802183:	05 44 20 81 00       	add    $0x812044,%eax
  802188:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80218e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802191:	89 d0                	mov    %edx,%eax
  802193:	01 c0                	add    %eax,%eax
  802195:	01 d0                	add    %edx,%eax
  802197:	c1 e0 02             	shl    $0x2,%eax
  80219a:	05 40 20 81 00       	add    $0x812040,%eax
  80219f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021a5:	e9 2d 01 00 00       	jmp    8022d7 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  8021aa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021ae:	0f 84 ce 00 00 00    	je     802282 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8021b4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8021bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021be:	89 d0                	mov    %edx,%eax
  8021c0:	01 c0                	add    %eax,%eax
  8021c2:	01 d0                	add    %edx,%eax
  8021c4:	c1 e0 02             	shl    $0x2,%eax
  8021c7:	05 40 20 81 00       	add    $0x812040,%eax
  8021cc:	8b 10                	mov    (%eax),%edx
  8021ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8021d1:	01 d0                	add    %edx,%eax
  8021d3:	48                   	dec    %eax
  8021d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8021d7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021da:	ba 00 00 00 00       	mov    $0x0,%edx
  8021df:	f7 75 c4             	divl   -0x3c(%ebp)
  8021e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021e5:	29 d0                	sub    %edx,%eax
  8021e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8021ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ed:	89 d0                	mov    %edx,%eax
  8021ef:	01 c0                	add    %eax,%eax
  8021f1:	01 d0                	add    %edx,%eax
  8021f3:	c1 e0 02             	shl    $0x2,%eax
  8021f6:	05 44 20 81 00       	add    $0x812044,%eax
  8021fb:	8b 00                	mov    (%eax),%eax
  8021fd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802200:	75 47                	jne    802249 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802202:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802205:	89 d0                	mov    %edx,%eax
  802207:	01 c0                	add    %eax,%eax
  802209:	01 d0                	add    %edx,%eax
  80220b:	c1 e0 02             	shl    $0x2,%eax
  80220e:	05 48 20 81 00       	add    $0x812048,%eax
  802213:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802216:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802219:	89 d0                	mov    %edx,%eax
  80221b:	01 c0                	add    %eax,%eax
  80221d:	01 d0                	add    %edx,%eax
  80221f:	c1 e0 02             	shl    $0x2,%eax
  802222:	05 44 20 81 00       	add    $0x812044,%eax
  802227:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80222d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802230:	89 d0                	mov    %edx,%eax
  802232:	01 c0                	add    %eax,%eax
  802234:	01 d0                	add    %edx,%eax
  802236:	c1 e0 02             	shl    $0x2,%eax
  802239:	05 40 20 81 00       	add    $0x812040,%eax
  80223e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802244:	e9 8e 00 00 00       	jmp    8022d7 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802249:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80224c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80224f:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802252:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802255:	89 d0                	mov    %edx,%eax
  802257:	01 c0                	add    %eax,%eax
  802259:	01 d0                	add    %edx,%eax
  80225b:	c1 e0 02             	shl    $0x2,%eax
  80225e:	05 40 20 81 00       	add    $0x812040,%eax
  802263:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802265:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802268:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80226b:	89 c2                	mov    %eax,%edx
  80226d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802270:	89 c8                	mov    %ecx,%eax
  802272:	01 c0                	add    %eax,%eax
  802274:	01 c8                	add    %ecx,%eax
  802276:	c1 e0 02             	shl    $0x2,%eax
  802279:	05 44 20 81 00       	add    $0x812044,%eax
  80227e:	89 10                	mov    %edx,(%eax)
  802280:	eb 55                	jmp    8022d7 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802282:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802289:	8b 15 88 60 83 00    	mov    0x836088,%edx
  80228f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802292:	01 d0                	add    %edx,%eax
  802294:	48                   	dec    %eax
  802295:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802298:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80229b:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a0:	f7 75 d0             	divl   -0x30(%ebp)
  8022a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8022a6:	29 d0                	sub    %edx,%eax
  8022a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8022ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8022ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022b1:	01 d0                	add    %edx,%eax
  8022b3:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8022b8:	76 0a                	jbe    8022c4 <smalloc+0x29e>
            return NULL;
  8022ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bf:	e9 ba 00 00 00       	jmp    80237e <smalloc+0x358>
        va = start;
  8022c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8022ca:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8022cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022d0:	01 d0                	add    %edx,%eax
  8022d2:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022d7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8022de:	eb 5e                	jmp    80233e <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8022e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022e3:	89 d0                	mov    %edx,%eax
  8022e5:	01 c0                	add    %eax,%eax
  8022e7:	01 d0                	add    %edx,%eax
  8022e9:	c1 e0 02             	shl    $0x2,%eax
  8022ec:	05 48 60 80 00       	add    $0x806048,%eax
  8022f1:	8a 00                	mov    (%eax),%al
  8022f3:	84 c0                	test   %al,%al
  8022f5:	75 44                	jne    80233b <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  8022f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022fa:	89 d0                	mov    %edx,%eax
  8022fc:	01 c0                	add    %eax,%eax
  8022fe:	01 d0                	add    %edx,%eax
  802300:	c1 e0 02             	shl    $0x2,%eax
  802303:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80230e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802311:	89 d0                	mov    %edx,%eax
  802313:	01 c0                	add    %eax,%eax
  802315:	01 d0                	add    %edx,%eax
  802317:	c1 e0 02             	shl    $0x2,%eax
  80231a:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802320:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802323:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802325:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802328:	89 d0                	mov    %edx,%eax
  80232a:	01 c0                	add    %eax,%eax
  80232c:	01 d0                	add    %edx,%eax
  80232e:	c1 e0 02             	shl    $0x2,%eax
  802331:	05 48 60 80 00       	add    $0x806048,%eax
  802336:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802339:	eb 0c                	jmp    802347 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80233b:	ff 45 e0             	incl   -0x20(%ebp)
  80233e:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802345:	7e 99                	jle    8022e0 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802347:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80234a:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  80234e:	52                   	push   %edx
  80234f:	50                   	push   %eax
  802350:	ff 75 d4             	pushl  -0x2c(%ebp)
  802353:	ff 75 08             	pushl  0x8(%ebp)
  802356:	e8 de 0e 00 00       	call   803239 <sys_create_shared_object>
  80235b:	83 c4 10             	add    $0x10,%esp
  80235e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802361:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  802365:	75 07                	jne    80236e <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802367:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80236c:	eb 10                	jmp    80237e <smalloc+0x358>
    if (r < 0)
  80236e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802372:	79 07                	jns    80237b <smalloc+0x355>
        return NULL;
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
  802379:	eb 03                	jmp    80237e <smalloc+0x358>
    return (void*)va;
  80237b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802386:	e8 51 f4 ff ff       	call   8017dc <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  80238b:	83 ec 08             	sub    $0x8,%esp
  80238e:	ff 75 0c             	pushl  0xc(%ebp)
  802391:	ff 75 08             	pushl  0x8(%ebp)
  802394:	e8 ca 0e 00 00       	call   803263 <sys_size_of_shared_object>
  802399:	83 c4 10             	add    $0x10,%esp
  80239c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  80239f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8023a3:	7f 0a                	jg     8023af <sget+0x2f>
        return NULL;
  8023a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023aa:	e9 28 03 00 00       	jmp    8026d7 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8023af:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8023b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023bc:	01 d0                	add    %edx,%eax
  8023be:	48                   	dec    %eax
  8023bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8023c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ca:	f7 75 d8             	divl   -0x28(%ebp)
  8023cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023d0:	29 d0                	sub    %edx,%eax
  8023d2:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8023d5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8023dc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8023e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8023ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8023f1:	e9 85 00 00 00       	jmp    80247b <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8023f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023f9:	89 d0                	mov    %edx,%eax
  8023fb:	01 c0                	add    %eax,%eax
  8023fd:	01 d0                	add    %edx,%eax
  8023ff:	c1 e0 02             	shl    $0x2,%eax
  802402:	05 48 20 81 00       	add    $0x812048,%eax
  802407:	8a 00                	mov    (%eax),%al
  802409:	84 c0                	test   %al,%al
  80240b:	74 20                	je     80242d <sget+0xad>
  80240d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802410:	89 d0                	mov    %edx,%eax
  802412:	01 c0                	add    %eax,%eax
  802414:	01 d0                	add    %edx,%eax
  802416:	c1 e0 02             	shl    $0x2,%eax
  802419:	05 44 20 81 00       	add    $0x812044,%eax
  80241e:	8b 00                	mov    (%eax),%eax
  802420:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802423:	75 08                	jne    80242d <sget+0xad>
        {
            exactIdx = i;
  802425:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802428:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  80242b:	eb 5b                	jmp    802488 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80242d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802430:	89 d0                	mov    %edx,%eax
  802432:	01 c0                	add    %eax,%eax
  802434:	01 d0                	add    %edx,%eax
  802436:	c1 e0 02             	shl    $0x2,%eax
  802439:	05 48 20 81 00       	add    $0x812048,%eax
  80243e:	8a 00                	mov    (%eax),%al
  802440:	84 c0                	test   %al,%al
  802442:	74 34                	je     802478 <sget+0xf8>
  802444:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802447:	89 d0                	mov    %edx,%eax
  802449:	01 c0                	add    %eax,%eax
  80244b:	01 d0                	add    %edx,%eax
  80244d:	c1 e0 02             	shl    $0x2,%eax
  802450:	05 44 20 81 00       	add    $0x812044,%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80245a:	76 1c                	jbe    802478 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  80245c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80245f:	89 d0                	mov    %edx,%eax
  802461:	01 c0                	add    %eax,%eax
  802463:	01 d0                	add    %edx,%eax
  802465:	c1 e0 02             	shl    $0x2,%eax
  802468:	05 44 20 81 00       	add    $0x812044,%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802475:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802478:	ff 45 e8             	incl   -0x18(%ebp)
  80247b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802482:	0f 8e 6e ff ff ff    	jle    8023f6 <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802488:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80248f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802493:	74 7d                	je     802512 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802495:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80249c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249f:	89 d0                	mov    %edx,%eax
  8024a1:	01 c0                	add    %eax,%eax
  8024a3:	01 d0                	add    %edx,%eax
  8024a5:	c1 e0 02             	shl    $0x2,%eax
  8024a8:	05 40 20 81 00       	add    $0x812040,%eax
  8024ad:	8b 10                	mov    (%eax),%edx
  8024af:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024b2:	01 d0                	add    %edx,%eax
  8024b4:	48                   	dec    %eax
  8024b5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8024b8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8024bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8024c0:	f7 75 b8             	divl   -0x48(%ebp)
  8024c3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8024c6:	29 d0                	sub    %edx,%eax
  8024c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8024cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ce:	89 d0                	mov    %edx,%eax
  8024d0:	01 c0                	add    %eax,%eax
  8024d2:	01 d0                	add    %edx,%eax
  8024d4:	c1 e0 02             	shl    $0x2,%eax
  8024d7:	05 48 20 81 00       	add    $0x812048,%eax
  8024dc:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8024df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e2:	89 d0                	mov    %edx,%eax
  8024e4:	01 c0                	add    %eax,%eax
  8024e6:	01 d0                	add    %edx,%eax
  8024e8:	c1 e0 02             	shl    $0x2,%eax
  8024eb:	05 44 20 81 00       	add    $0x812044,%eax
  8024f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8024f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f9:	89 d0                	mov    %edx,%eax
  8024fb:	01 c0                	add    %eax,%eax
  8024fd:	01 d0                	add    %edx,%eax
  8024ff:	c1 e0 02             	shl    $0x2,%eax
  802502:	05 40 20 81 00       	add    $0x812040,%eax
  802507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250d:	e9 2d 01 00 00       	jmp    80263f <sget+0x2bf>
    }
    else if (worstIdx != -1)
  802512:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802516:	0f 84 ce 00 00 00    	je     8025ea <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  80251c:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  802523:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802526:	89 d0                	mov    %edx,%eax
  802528:	01 c0                	add    %eax,%eax
  80252a:	01 d0                	add    %edx,%eax
  80252c:	c1 e0 02             	shl    $0x2,%eax
  80252f:	05 40 20 81 00       	add    $0x812040,%eax
  802534:	8b 10                	mov    (%eax),%edx
  802536:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802539:	01 d0                	add    %edx,%eax
  80253b:	48                   	dec    %eax
  80253c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80253f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802542:	ba 00 00 00 00       	mov    $0x0,%edx
  802547:	f7 75 c0             	divl   -0x40(%ebp)
  80254a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80254d:	29 d0                	sub    %edx,%eax
  80254f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802552:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802555:	89 d0                	mov    %edx,%eax
  802557:	01 c0                	add    %eax,%eax
  802559:	01 d0                	add    %edx,%eax
  80255b:	c1 e0 02             	shl    $0x2,%eax
  80255e:	05 44 20 81 00       	add    $0x812044,%eax
  802563:	8b 00                	mov    (%eax),%eax
  802565:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802568:	75 47                	jne    8025b1 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  80256a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80256d:	89 d0                	mov    %edx,%eax
  80256f:	01 c0                	add    %eax,%eax
  802571:	01 d0                	add    %edx,%eax
  802573:	c1 e0 02             	shl    $0x2,%eax
  802576:	05 48 20 81 00       	add    $0x812048,%eax
  80257b:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80257e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802581:	89 d0                	mov    %edx,%eax
  802583:	01 c0                	add    %eax,%eax
  802585:	01 d0                	add    %edx,%eax
  802587:	c1 e0 02             	shl    $0x2,%eax
  80258a:	05 44 20 81 00       	add    $0x812044,%eax
  80258f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802595:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802598:	89 d0                	mov    %edx,%eax
  80259a:	01 c0                	add    %eax,%eax
  80259c:	01 d0                	add    %edx,%eax
  80259e:	c1 e0 02             	shl    $0x2,%eax
  8025a1:	05 40 20 81 00       	add    $0x812040,%eax
  8025a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ac:	e9 8e 00 00 00       	jmp    80263f <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8025b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025b7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8025ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025bd:	89 d0                	mov    %edx,%eax
  8025bf:	01 c0                	add    %eax,%eax
  8025c1:	01 d0                	add    %edx,%eax
  8025c3:	c1 e0 02             	shl    $0x2,%eax
  8025c6:	05 40 20 81 00       	add    $0x812040,%eax
  8025cb:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8025cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d0:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8025d3:	89 c2                	mov    %eax,%edx
  8025d5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025d8:	89 c8                	mov    %ecx,%eax
  8025da:	01 c0                	add    %eax,%eax
  8025dc:	01 c8                	add    %ecx,%eax
  8025de:	c1 e0 02             	shl    $0x2,%eax
  8025e1:	05 44 20 81 00       	add    $0x812044,%eax
  8025e6:	89 10                	mov    %edx,(%eax)
  8025e8:	eb 55                	jmp    80263f <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8025ea:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025f1:	8b 15 88 60 83 00    	mov    0x836088,%edx
  8025f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025fa:	01 d0                	add    %edx,%eax
  8025fc:	48                   	dec    %eax
  8025fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802600:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802603:	ba 00 00 00 00       	mov    $0x0,%edx
  802608:	f7 75 cc             	divl   -0x34(%ebp)
  80260b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80260e:	29 d0                	sub    %edx,%eax
  802610:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  802613:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802616:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802619:	01 d0                	add    %edx,%eax
  80261b:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802620:	76 0a                	jbe    80262c <sget+0x2ac>
            return NULL;
  802622:	b8 00 00 00 00       	mov    $0x0,%eax
  802627:	e9 ab 00 00 00       	jmp    8026d7 <sget+0x357>
        va = start;
  80262c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80262f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  802632:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802635:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802638:	01 d0                	add    %edx,%eax
  80263a:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80263f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802646:	eb 5e                	jmp    8026a6 <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802648:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80264b:	89 d0                	mov    %edx,%eax
  80264d:	01 c0                	add    %eax,%eax
  80264f:	01 d0                	add    %edx,%eax
  802651:	c1 e0 02             	shl    $0x2,%eax
  802654:	05 48 60 80 00       	add    $0x806048,%eax
  802659:	8a 00                	mov    (%eax),%al
  80265b:	84 c0                	test   %al,%al
  80265d:	75 44                	jne    8026a3 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  80265f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802662:	89 d0                	mov    %edx,%eax
  802664:	01 c0                	add    %eax,%eax
  802666:	01 d0                	add    %edx,%eax
  802668:	c1 e0 02             	shl    $0x2,%eax
  80266b:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802674:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802676:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802679:	89 d0                	mov    %edx,%eax
  80267b:	01 c0                	add    %eax,%eax
  80267d:	01 d0                	add    %edx,%eax
  80267f:	c1 e0 02             	shl    $0x2,%eax
  802682:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802688:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80268b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80268d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802690:	89 d0                	mov    %edx,%eax
  802692:	01 c0                	add    %eax,%eax
  802694:	01 d0                	add    %edx,%eax
  802696:	c1 e0 02             	shl    $0x2,%eax
  802699:	05 48 60 80 00       	add    $0x806048,%eax
  80269e:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8026a1:	eb 0c                	jmp    8026af <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8026a3:	ff 45 e0             	incl   -0x20(%ebp)
  8026a6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8026ad:	7e 99                	jle    802648 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8026af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b2:	83 ec 04             	sub    $0x4,%esp
  8026b5:	50                   	push   %eax
  8026b6:	ff 75 0c             	pushl  0xc(%ebp)
  8026b9:	ff 75 08             	pushl  0x8(%ebp)
  8026bc:	e8 bf 0b 00 00       	call   803280 <sys_get_shared_object>
  8026c1:	83 c4 10             	add    $0x10,%esp
  8026c4:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8026c7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026cb:	79 07                	jns    8026d4 <sget+0x354>
        return NULL;
  8026cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d2:	eb 03                	jmp    8026d7 <sget+0x357>
    return (void*)va;
  8026d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8026d7:	c9                   	leave  
  8026d8:	c3                   	ret    

008026d9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8026d9:	55                   	push   %ebp
  8026da:	89 e5                	mov    %esp,%ebp
  8026dc:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026df:	e8 f8 f0 ff ff       	call   8017dc <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8026e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e8:	75 13                	jne    8026fd <realloc+0x24>
		return malloc(new_size);
  8026ea:	83 ec 0c             	sub    $0xc,%esp
  8026ed:	ff 75 0c             	pushl  0xc(%ebp)
  8026f0:	e8 c4 f1 ff ff       	call   8018b9 <malloc>
  8026f5:	83 c4 10             	add    $0x10,%esp
  8026f8:	e9 f4 05 00 00       	jmp    802cf1 <realloc+0x618>
	if (new_size == 0)
  8026fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802701:	75 18                	jne    80271b <realloc+0x42>
	{
		free(virtual_address);
  802703:	83 ec 0c             	sub    $0xc,%esp
  802706:	ff 75 08             	pushl  0x8(%ebp)
  802709:	e8 0b f5 ff ff       	call   801c19 <free>
  80270e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802711:	b8 00 00 00 00       	mov    $0x0,%eax
  802716:	e9 d6 05 00 00       	jmp    802cf1 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802721:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	79 74                	jns    80279c <realloc+0xc3>
  802728:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  80272f:	77 6b                	ja     80279c <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802731:	83 ec 0c             	sub    $0xc,%esp
  802734:	ff 75 0c             	pushl  0xc(%ebp)
  802737:	e8 7d f1 ff ff       	call   8018b9 <malloc>
  80273c:	83 c4 10             	add    $0x10,%esp
  80273f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802742:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802746:	75 0a                	jne    802752 <realloc+0x79>
			return NULL;
  802748:	b8 00 00 00 00       	mov    $0x0,%eax
  80274d:	e9 9f 05 00 00       	jmp    802cf1 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802752:	83 ec 0c             	sub    $0xc,%esp
  802755:	ff 75 08             	pushl  0x8(%ebp)
  802758:	e8 e0 11 00 00       	call   80393d <get_block_size>
  80275d:	83 c4 10             	add    $0x10,%esp
  802760:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802763:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802766:	8b 45 0c             	mov    0xc(%ebp),%eax
  802769:	39 d0                	cmp    %edx,%eax
  80276b:	76 02                	jbe    80276f <realloc+0x96>
  80276d:	89 d0                	mov    %edx,%eax
  80276f:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802772:	83 ec 04             	sub    $0x4,%esp
  802775:	ff 75 c0             	pushl  -0x40(%ebp)
  802778:	ff 75 08             	pushl  0x8(%ebp)
  80277b:	ff 75 c8             	pushl  -0x38(%ebp)
  80277e:	e8 56 eb ff ff       	call   8012d9 <memmove>
  802783:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802786:	83 ec 0c             	sub    $0xc,%esp
  802789:	ff 75 08             	pushl  0x8(%ebp)
  80278c:	e8 88 f4 ff ff       	call   801c19 <free>
  802791:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802794:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802797:	e9 55 05 00 00       	jmp    802cf1 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  80279c:	a1 30 61 83 00       	mov    0x836130,%eax
  8027a1:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8027a4:	72 09                	jb     8027af <realloc+0xd6>
  8027a6:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8027ad:	76 0a                	jbe    8027b9 <realloc+0xe0>
		return NULL;
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b4:	e9 38 05 00 00       	jmp    802cf1 <realloc+0x618>
	uint32 oldsz = 0;
  8027b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8027c0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8027c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8027ce:	eb 50                	jmp    802820 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8027d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027d3:	89 d0                	mov    %edx,%eax
  8027d5:	01 c0                	add    %eax,%eax
  8027d7:	01 d0                	add    %edx,%eax
  8027d9:	c1 e0 02             	shl    $0x2,%eax
  8027dc:	05 48 60 80 00       	add    $0x806048,%eax
  8027e1:	8a 00                	mov    (%eax),%al
  8027e3:	84 c0                	test   %al,%al
  8027e5:	74 36                	je     80281d <realloc+0x144>
  8027e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ea:	89 d0                	mov    %edx,%eax
  8027ec:	01 c0                	add    %eax,%eax
  8027ee:	01 d0                	add    %edx,%eax
  8027f0:	c1 e0 02             	shl    $0x2,%eax
  8027f3:	05 40 60 80 00       	add    $0x806040,%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8027fd:	75 1e                	jne    80281d <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  8027ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802802:	89 d0                	mov    %edx,%eax
  802804:	01 c0                	add    %eax,%eax
  802806:	01 d0                	add    %edx,%eax
  802808:	c1 e0 02             	shl    $0x2,%eax
  80280b:	05 44 60 80 00       	add    $0x806044,%eax
  802810:	8b 00                	mov    (%eax),%eax
  802812:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802818:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80281b:	eb 0c                	jmp    802829 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80281d:	ff 45 ec             	incl   -0x14(%ebp)
  802820:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802827:	7e a7                	jle    8027d0 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802829:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80282d:	75 0a                	jne    802839 <realloc+0x160>
		return NULL;
  80282f:	b8 00 00 00 00       	mov    $0x0,%eax
  802834:	e9 b8 04 00 00       	jmp    802cf1 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802839:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802840:	8b 55 0c             	mov    0xc(%ebp),%edx
  802843:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802846:	01 d0                	add    %edx,%eax
  802848:	48                   	dec    %eax
  802849:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80284c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80284f:	ba 00 00 00 00       	mov    $0x0,%edx
  802854:	f7 75 bc             	divl   -0x44(%ebp)
  802857:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80285a:	29 d0                	sub    %edx,%eax
  80285c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  80285f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802862:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802865:	75 08                	jne    80286f <realloc+0x196>
		return virtual_address;
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	e9 82 04 00 00       	jmp    802cf1 <realloc+0x618>
	if (req < oldsz)
  80286f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802872:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802875:	0f 83 cd 02 00 00    	jae    802b48 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802881:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802884:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802887:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80288a:	01 d0                	add    %edx,%eax
  80288c:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  80288f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802892:	89 d0                	mov    %edx,%eax
  802894:	01 c0                	add    %eax,%eax
  802896:	01 d0                	add    %edx,%eax
  802898:	c1 e0 02             	shl    $0x2,%eax
  80289b:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8028a1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028a4:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8028a6:	83 ec 08             	sub    $0x8,%esp
  8028a9:	ff 75 b0             	pushl  -0x50(%ebp)
  8028ac:	ff 75 ac             	pushl  -0x54(%ebp)
  8028af:	e8 e3 0c 00 00       	call   803597 <sys_free_user_mem>
  8028b4:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8028b7:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8028be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8028c5:	eb 64                	jmp    80292b <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8028c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028ca:	89 d0                	mov    %edx,%eax
  8028cc:	01 c0                	add    %eax,%eax
  8028ce:	01 d0                	add    %edx,%eax
  8028d0:	c1 e0 02             	shl    $0x2,%eax
  8028d3:	05 48 20 81 00       	add    $0x812048,%eax
  8028d8:	8a 00                	mov    (%eax),%al
  8028da:	84 c0                	test   %al,%al
  8028dc:	75 4a                	jne    802928 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8028de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028e1:	89 d0                	mov    %edx,%eax
  8028e3:	01 c0                	add    %eax,%eax
  8028e5:	01 d0                	add    %edx,%eax
  8028e7:	c1 e0 02             	shl    $0x2,%eax
  8028ea:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8028f0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8028f3:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  8028f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028f8:	89 d0                	mov    %edx,%eax
  8028fa:	01 c0                	add    %eax,%eax
  8028fc:	01 d0                	add    %edx,%eax
  8028fe:	c1 e0 02             	shl    $0x2,%eax
  802901:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802907:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80290a:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  80290c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80290f:	89 d0                	mov    %edx,%eax
  802911:	01 c0                	add    %eax,%eax
  802913:	01 d0                	add    %edx,%eax
  802915:	c1 e0 02             	shl    $0x2,%eax
  802918:	05 48 20 81 00       	add    $0x812048,%eax
  80291d:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802923:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802926:	eb 0c                	jmp    802934 <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802928:	ff 45 e4             	incl   -0x1c(%ebp)
  80292b:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802932:	7e 93                	jle    8028c7 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802934:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802938:	0f 84 8d 01 00 00    	je     802acb <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80293e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802945:	e9 74 01 00 00       	jmp    802abe <realloc+0x3e5>
			{
				if (k == fidx) continue;
  80294a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80294d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802950:	0f 84 64 01 00 00    	je     802aba <realloc+0x3e1>
				if (uhp_frees[k].free)
  802956:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802959:	89 d0                	mov    %edx,%eax
  80295b:	01 c0                	add    %eax,%eax
  80295d:	01 d0                	add    %edx,%eax
  80295f:	c1 e0 02             	shl    $0x2,%eax
  802962:	05 48 20 81 00       	add    $0x812048,%eax
  802967:	8a 00                	mov    (%eax),%al
  802969:	84 c0                	test   %al,%al
  80296b:	0f 84 4a 01 00 00    	je     802abb <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802971:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802974:	89 d0                	mov    %edx,%eax
  802976:	01 c0                	add    %eax,%eax
  802978:	01 d0                	add    %edx,%eax
  80297a:	c1 e0 02             	shl    $0x2,%eax
  80297d:	05 40 20 81 00       	add    $0x812040,%eax
  802982:	8b 08                	mov    (%eax),%ecx
  802984:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802987:	89 d0                	mov    %edx,%eax
  802989:	01 c0                	add    %eax,%eax
  80298b:	01 d0                	add    %edx,%eax
  80298d:	c1 e0 02             	shl    $0x2,%eax
  802990:	05 44 20 81 00       	add    $0x812044,%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	01 c1                	add    %eax,%ecx
  802999:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80299c:	89 d0                	mov    %edx,%eax
  80299e:	01 c0                	add    %eax,%eax
  8029a0:	01 d0                	add    %edx,%eax
  8029a2:	c1 e0 02             	shl    $0x2,%eax
  8029a5:	05 40 20 81 00       	add    $0x812040,%eax
  8029aa:	8b 00                	mov    (%eax),%eax
  8029ac:	39 c1                	cmp    %eax,%ecx
  8029ae:	75 7a                	jne    802a2a <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8029b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029b3:	89 d0                	mov    %edx,%eax
  8029b5:	01 c0                	add    %eax,%eax
  8029b7:	01 d0                	add    %edx,%eax
  8029b9:	c1 e0 02             	shl    $0x2,%eax
  8029bc:	05 40 20 81 00       	add    $0x812040,%eax
  8029c1:	8b 10                	mov    (%eax),%edx
  8029c3:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8029c6:	89 c8                	mov    %ecx,%eax
  8029c8:	01 c0                	add    %eax,%eax
  8029ca:	01 c8                	add    %ecx,%eax
  8029cc:	c1 e0 02             	shl    $0x2,%eax
  8029cf:	05 40 20 81 00       	add    $0x812040,%eax
  8029d4:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  8029d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029d9:	89 d0                	mov    %edx,%eax
  8029db:	01 c0                	add    %eax,%eax
  8029dd:	01 d0                	add    %edx,%eax
  8029df:	c1 e0 02             	shl    $0x2,%eax
  8029e2:	05 44 20 81 00       	add    $0x812044,%eax
  8029e7:	8b 08                	mov    (%eax),%ecx
  8029e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029ec:	89 d0                	mov    %edx,%eax
  8029ee:	01 c0                	add    %eax,%eax
  8029f0:	01 d0                	add    %edx,%eax
  8029f2:	c1 e0 02             	shl    $0x2,%eax
  8029f5:	05 44 20 81 00       	add    $0x812044,%eax
  8029fa:	8b 00                	mov    (%eax),%eax
  8029fc:	01 c1                	add    %eax,%ecx
  8029fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a01:	89 d0                	mov    %edx,%eax
  802a03:	01 c0                	add    %eax,%eax
  802a05:	01 d0                	add    %edx,%eax
  802a07:	c1 e0 02             	shl    $0x2,%eax
  802a0a:	05 44 20 81 00       	add    $0x812044,%eax
  802a0f:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802a11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a14:	89 d0                	mov    %edx,%eax
  802a16:	01 c0                	add    %eax,%eax
  802a18:	01 d0                	add    %edx,%eax
  802a1a:	c1 e0 02             	shl    $0x2,%eax
  802a1d:	05 48 20 81 00       	add    $0x812048,%eax
  802a22:	c6 00 00             	movb   $0x0,(%eax)
  802a25:	e9 91 00 00 00       	jmp    802abb <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802a2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a2d:	89 d0                	mov    %edx,%eax
  802a2f:	01 c0                	add    %eax,%eax
  802a31:	01 d0                	add    %edx,%eax
  802a33:	c1 e0 02             	shl    $0x2,%eax
  802a36:	05 40 20 81 00       	add    $0x812040,%eax
  802a3b:	8b 08                	mov    (%eax),%ecx
  802a3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a40:	89 d0                	mov    %edx,%eax
  802a42:	01 c0                	add    %eax,%eax
  802a44:	01 d0                	add    %edx,%eax
  802a46:	c1 e0 02             	shl    $0x2,%eax
  802a49:	05 44 20 81 00       	add    $0x812044,%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	01 c1                	add    %eax,%ecx
  802a52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a55:	89 d0                	mov    %edx,%eax
  802a57:	01 c0                	add    %eax,%eax
  802a59:	01 d0                	add    %edx,%eax
  802a5b:	c1 e0 02             	shl    $0x2,%eax
  802a5e:	05 40 20 81 00       	add    $0x812040,%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	39 c1                	cmp    %eax,%ecx
  802a67:	75 52                	jne    802abb <realloc+0x3e2>
					{
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
  802ab8:	eb 01                	jmp    802abb <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802aba:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802abb:	ff 45 e0             	incl   -0x20(%ebp)
  802abe:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802ac5:	0f 8e 7f fe ff ff    	jle    80294a <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802acb:	a1 30 61 83 00       	mov    0x836130,%eax
  802ad0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802ad3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802ada:	eb 53                	jmp    802b2f <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802adc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802adf:	89 d0                	mov    %edx,%eax
  802ae1:	01 c0                	add    %eax,%eax
  802ae3:	01 d0                	add    %edx,%eax
  802ae5:	c1 e0 02             	shl    $0x2,%eax
  802ae8:	05 48 60 80 00       	add    $0x806048,%eax
  802aed:	8a 00                	mov    (%eax),%al
  802aef:	84 c0                	test   %al,%al
  802af1:	74 39                	je     802b2c <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802af3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802af6:	89 d0                	mov    %edx,%eax
  802af8:	01 c0                	add    %eax,%eax
  802afa:	01 d0                	add    %edx,%eax
  802afc:	c1 e0 02             	shl    $0x2,%eax
  802aff:	05 40 60 80 00       	add    $0x806040,%eax
  802b04:	8b 08                	mov    (%eax),%ecx
  802b06:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b09:	89 d0                	mov    %edx,%eax
  802b0b:	01 c0                	add    %eax,%eax
  802b0d:	01 d0                	add    %edx,%eax
  802b0f:	c1 e0 02             	shl    $0x2,%eax
  802b12:	05 44 60 80 00       	add    $0x806044,%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	01 c8                	add    %ecx,%eax
  802b1b:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802b1e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b21:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802b24:	76 06                	jbe    802b2c <realloc+0x453>
  802b26:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b29:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802b2c:	ff 45 d8             	incl   -0x28(%ebp)
  802b2f:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802b36:	7e a4                	jle    802adc <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802b38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b3b:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	e9 a9 01 00 00       	jmp    802cf1 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802b48:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	01 d0                	add    %edx,%eax
  802b50:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802b53:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b5a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802b61:	eb 57                	jmp    802bba <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802b63:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b66:	89 d0                	mov    %edx,%eax
  802b68:	01 c0                	add    %eax,%eax
  802b6a:	01 d0                	add    %edx,%eax
  802b6c:	c1 e0 02             	shl    $0x2,%eax
  802b6f:	05 48 20 81 00       	add    $0x812048,%eax
  802b74:	8a 00                	mov    (%eax),%al
  802b76:	84 c0                	test   %al,%al
  802b78:	74 3d                	je     802bb7 <realloc+0x4de>
  802b7a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b7d:	89 d0                	mov    %edx,%eax
  802b7f:	01 c0                	add    %eax,%eax
  802b81:	01 d0                	add    %edx,%eax
  802b83:	c1 e0 02             	shl    $0x2,%eax
  802b86:	05 40 20 81 00       	add    $0x812040,%eax
  802b8b:	8b 00                	mov    (%eax),%eax
  802b8d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b90:	75 25                	jne    802bb7 <realloc+0x4de>
  802b92:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b95:	89 d0                	mov    %edx,%eax
  802b97:	01 c0                	add    %eax,%eax
  802b99:	01 d0                	add    %edx,%eax
  802b9b:	c1 e0 02             	shl    $0x2,%eax
  802b9e:	05 44 20 81 00       	add    $0x812044,%eax
  802ba3:	8b 10                	mov    (%eax),%edx
  802ba5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ba8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802bab:	39 c2                	cmp    %eax,%edx
  802bad:	72 08                	jb     802bb7 <realloc+0x4de>
		{
			adjIdx = j; break;
  802baf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bb2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802bb5:	eb 0c                	jmp    802bc3 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bb7:	ff 45 d0             	incl   -0x30(%ebp)
  802bba:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802bc1:	7e a0                	jle    802b63 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802bc3:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802bc7:	0f 84 d6 00 00 00    	je     802ca3 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802bcd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bd0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802bd3:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802bd6:	83 ec 08             	sub    $0x8,%esp
  802bd9:	ff 75 a0             	pushl  -0x60(%ebp)
  802bdc:	ff 75 a4             	pushl  -0x5c(%ebp)
  802bdf:	e8 cf 09 00 00       	call   8035b3 <sys_allocate_user_mem>
  802be4:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802be7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bea:	89 d0                	mov    %edx,%eax
  802bec:	01 c0                	add    %eax,%eax
  802bee:	01 d0                	add    %edx,%eax
  802bf0:	c1 e0 02             	shl    $0x2,%eax
  802bf3:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802bf9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bfc:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802bfe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c01:	89 d0                	mov    %edx,%eax
  802c03:	01 c0                	add    %eax,%eax
  802c05:	01 d0                	add    %edx,%eax
  802c07:	c1 e0 02             	shl    $0x2,%eax
  802c0a:	05 40 20 81 00       	add    $0x812040,%eax
  802c0f:	8b 10                	mov    (%eax),%edx
  802c11:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802c14:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802c17:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c1a:	89 d0                	mov    %edx,%eax
  802c1c:	01 c0                	add    %eax,%eax
  802c1e:	01 d0                	add    %edx,%eax
  802c20:	c1 e0 02             	shl    $0x2,%eax
  802c23:	05 40 20 81 00       	add    $0x812040,%eax
  802c28:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802c2a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c2d:	89 d0                	mov    %edx,%eax
  802c2f:	01 c0                	add    %eax,%eax
  802c31:	01 d0                	add    %edx,%eax
  802c33:	c1 e0 02             	shl    $0x2,%eax
  802c36:	05 44 20 81 00       	add    $0x812044,%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802c40:	89 c2                	mov    %eax,%edx
  802c42:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802c45:	89 c8                	mov    %ecx,%eax
  802c47:	01 c0                	add    %eax,%eax
  802c49:	01 c8                	add    %ecx,%eax
  802c4b:	c1 e0 02             	shl    $0x2,%eax
  802c4e:	05 44 20 81 00       	add    $0x812044,%eax
  802c53:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802c55:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c58:	89 d0                	mov    %edx,%eax
  802c5a:	01 c0                	add    %eax,%eax
  802c5c:	01 d0                	add    %edx,%eax
  802c5e:	c1 e0 02             	shl    $0x2,%eax
  802c61:	05 44 20 81 00       	add    $0x812044,%eax
  802c66:	8b 00                	mov    (%eax),%eax
  802c68:	85 c0                	test   %eax,%eax
  802c6a:	75 14                	jne    802c80 <realloc+0x5a7>
  802c6c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c6f:	89 d0                	mov    %edx,%eax
  802c71:	01 c0                	add    %eax,%eax
  802c73:	01 d0                	add    %edx,%eax
  802c75:	c1 e0 02             	shl    $0x2,%eax
  802c78:	05 48 20 81 00       	add    $0x812048,%eax
  802c7d:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802c80:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c83:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c86:	01 c2                	add    %eax,%edx
  802c88:	a1 88 60 83 00       	mov    0x836088,%eax
  802c8d:	39 c2                	cmp    %eax,%edx
  802c8f:	76 0d                	jbe    802c9e <realloc+0x5c5>
  802c91:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c94:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c97:	01 d0                	add    %edx,%eax
  802c99:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	eb 4e                	jmp    802cf1 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802ca3:	83 ec 0c             	sub    $0xc,%esp
  802ca6:	ff 75 0c             	pushl  0xc(%ebp)
  802ca9:	e8 0b ec ff ff       	call   8018b9 <malloc>
  802cae:	83 c4 10             	add    $0x10,%esp
  802cb1:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802cb4:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802cb8:	75 07                	jne    802cc1 <realloc+0x5e8>
		return NULL;
  802cba:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbf:	eb 30                	jmp    802cf1 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cc7:	39 d0                	cmp    %edx,%eax
  802cc9:	76 02                	jbe    802ccd <realloc+0x5f4>
  802ccb:	89 d0                	mov    %edx,%eax
  802ccd:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802cd0:	83 ec 04             	sub    $0x4,%esp
  802cd3:	50                   	push   %eax
  802cd4:	52                   	push   %edx
  802cd5:	ff 75 cc             	pushl  -0x34(%ebp)
  802cd8:	e8 cf 06 00 00       	call   8033ac <sys_move_user_mem>
  802cdd:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802ce0:	83 ec 0c             	sub    $0xc,%esp
  802ce3:	ff 75 08             	pushl  0x8(%ebp)
  802ce6:	e8 2e ef ff ff       	call   801c19 <free>
  802ceb:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802cee:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802cf1:	c9                   	leave  
  802cf2:	c3                   	ret    

00802cf3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802cf3:	55                   	push   %ebp
  802cf4:	89 e5                	mov    %esp,%ebp
  802cf6:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802cff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d03:	0f 84 33 03 00 00    	je     80303c <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802d09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d0c:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802d11:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802d14:	83 ec 08             	sub    $0x8,%esp
  802d17:	ff 75 08             	pushl  0x8(%ebp)
  802d1a:	ff 75 d8             	pushl  -0x28(%ebp)
  802d1d:	e8 7d 05 00 00       	call   80329f <sys_delete_shared_object>
  802d22:	83 c4 10             	add    $0x10,%esp
  802d25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802d28:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d2c:	0f 88 0d 03 00 00    	js     80303f <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802d32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d39:	e9 ef 02 00 00       	jmp    80302d <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802d3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d41:	89 d0                	mov    %edx,%eax
  802d43:	01 c0                	add    %eax,%eax
  802d45:	01 d0                	add    %edx,%eax
  802d47:	c1 e0 02             	shl    $0x2,%eax
  802d4a:	05 48 60 80 00       	add    $0x806048,%eax
  802d4f:	8a 00                	mov    (%eax),%al
  802d51:	84 c0                	test   %al,%al
  802d53:	0f 84 d1 02 00 00    	je     80302a <sfree+0x337>
  802d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d5c:	89 d0                	mov    %edx,%eax
  802d5e:	01 c0                	add    %eax,%eax
  802d60:	01 d0                	add    %edx,%eax
  802d62:	c1 e0 02             	shl    $0x2,%eax
  802d65:	05 40 60 80 00       	add    $0x806040,%eax
  802d6a:	8b 00                	mov    (%eax),%eax
  802d6c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d6f:	0f 85 b5 02 00 00    	jne    80302a <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d78:	89 d0                	mov    %edx,%eax
  802d7a:	01 c0                	add    %eax,%eax
  802d7c:	01 d0                	add    %edx,%eax
  802d7e:	c1 e0 02             	shl    $0x2,%eax
  802d81:	05 44 60 80 00       	add    $0x806044,%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8e:	89 d0                	mov    %edx,%eax
  802d90:	01 c0                	add    %eax,%eax
  802d92:	01 d0                	add    %edx,%eax
  802d94:	c1 e0 02             	shl    $0x2,%eax
  802d97:	05 48 60 80 00       	add    $0x806048,%eax
  802d9c:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802d9f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802da6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802dad:	eb 64                	jmp    802e13 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802daf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802db2:	89 d0                	mov    %edx,%eax
  802db4:	01 c0                	add    %eax,%eax
  802db6:	01 d0                	add    %edx,%eax
  802db8:	c1 e0 02             	shl    $0x2,%eax
  802dbb:	05 48 20 81 00       	add    $0x812048,%eax
  802dc0:	8a 00                	mov    (%eax),%al
  802dc2:	84 c0                	test   %al,%al
  802dc4:	75 4a                	jne    802e10 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802dc6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dc9:	89 d0                	mov    %edx,%eax
  802dcb:	01 c0                	add    %eax,%eax
  802dcd:	01 d0                	add    %edx,%eax
  802dcf:	c1 e0 02             	shl    $0x2,%eax
  802dd2:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802dd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ddb:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802ddd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de0:	89 d0                	mov    %edx,%eax
  802de2:	01 c0                	add    %eax,%eax
  802de4:	01 d0                	add    %edx,%eax
  802de6:	c1 e0 02             	shl    $0x2,%eax
  802de9:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802def:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802df2:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802df4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802df7:	89 d0                	mov    %edx,%eax
  802df9:	01 c0                	add    %eax,%eax
  802dfb:	01 d0                	add    %edx,%eax
  802dfd:	c1 e0 02             	shl    $0x2,%eax
  802e00:	05 48 20 81 00       	add    $0x812048,%eax
  802e05:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802e0e:	eb 0c                	jmp    802e1c <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802e10:	ff 45 ec             	incl   -0x14(%ebp)
  802e13:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802e1a:	7e 93                	jle    802daf <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802e1c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802e20:	0f 84 8d 01 00 00    	je     802fb3 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e26:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802e2d:	e9 74 01 00 00       	jmp    802fa6 <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802e32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e35:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e38:	0f 84 64 01 00 00    	je     802fa2 <sfree+0x2af>
					if (uhp_frees[k].free)
  802e3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e41:	89 d0                	mov    %edx,%eax
  802e43:	01 c0                	add    %eax,%eax
  802e45:	01 d0                	add    %edx,%eax
  802e47:	c1 e0 02             	shl    $0x2,%eax
  802e4a:	05 48 20 81 00       	add    $0x812048,%eax
  802e4f:	8a 00                	mov    (%eax),%al
  802e51:	84 c0                	test   %al,%al
  802e53:	0f 84 4a 01 00 00    	je     802fa3 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802e59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e5c:	89 d0                	mov    %edx,%eax
  802e5e:	01 c0                	add    %eax,%eax
  802e60:	01 d0                	add    %edx,%eax
  802e62:	c1 e0 02             	shl    $0x2,%eax
  802e65:	05 40 20 81 00       	add    $0x812040,%eax
  802e6a:	8b 08                	mov    (%eax),%ecx
  802e6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e6f:	89 d0                	mov    %edx,%eax
  802e71:	01 c0                	add    %eax,%eax
  802e73:	01 d0                	add    %edx,%eax
  802e75:	c1 e0 02             	shl    $0x2,%eax
  802e78:	05 44 20 81 00       	add    $0x812044,%eax
  802e7d:	8b 00                	mov    (%eax),%eax
  802e7f:	01 c1                	add    %eax,%ecx
  802e81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e84:	89 d0                	mov    %edx,%eax
  802e86:	01 c0                	add    %eax,%eax
  802e88:	01 d0                	add    %edx,%eax
  802e8a:	c1 e0 02             	shl    $0x2,%eax
  802e8d:	05 40 20 81 00       	add    $0x812040,%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	39 c1                	cmp    %eax,%ecx
  802e96:	75 7a                	jne    802f12 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802e98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e9b:	89 d0                	mov    %edx,%eax
  802e9d:	01 c0                	add    %eax,%eax
  802e9f:	01 d0                	add    %edx,%eax
  802ea1:	c1 e0 02             	shl    $0x2,%eax
  802ea4:	05 40 20 81 00       	add    $0x812040,%eax
  802ea9:	8b 10                	mov    (%eax),%edx
  802eab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802eae:	89 c8                	mov    %ecx,%eax
  802eb0:	01 c0                	add    %eax,%eax
  802eb2:	01 c8                	add    %ecx,%eax
  802eb4:	c1 e0 02             	shl    $0x2,%eax
  802eb7:	05 40 20 81 00       	add    $0x812040,%eax
  802ebc:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802ebe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec1:	89 d0                	mov    %edx,%eax
  802ec3:	01 c0                	add    %eax,%eax
  802ec5:	01 d0                	add    %edx,%eax
  802ec7:	c1 e0 02             	shl    $0x2,%eax
  802eca:	05 44 20 81 00       	add    $0x812044,%eax
  802ecf:	8b 08                	mov    (%eax),%ecx
  802ed1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ed4:	89 d0                	mov    %edx,%eax
  802ed6:	01 c0                	add    %eax,%eax
  802ed8:	01 d0                	add    %edx,%eax
  802eda:	c1 e0 02             	shl    $0x2,%eax
  802edd:	05 44 20 81 00       	add    $0x812044,%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	01 c1                	add    %eax,%ecx
  802ee6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee9:	89 d0                	mov    %edx,%eax
  802eeb:	01 c0                	add    %eax,%eax
  802eed:	01 d0                	add    %edx,%eax
  802eef:	c1 e0 02             	shl    $0x2,%eax
  802ef2:	05 44 20 81 00       	add    $0x812044,%eax
  802ef7:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802ef9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802efc:	89 d0                	mov    %edx,%eax
  802efe:	01 c0                	add    %eax,%eax
  802f00:	01 d0                	add    %edx,%eax
  802f02:	c1 e0 02             	shl    $0x2,%eax
  802f05:	05 48 20 81 00       	add    $0x812048,%eax
  802f0a:	c6 00 00             	movb   $0x0,(%eax)
  802f0d:	e9 91 00 00 00       	jmp    802fa3 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802f12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f15:	89 d0                	mov    %edx,%eax
  802f17:	01 c0                	add    %eax,%eax
  802f19:	01 d0                	add    %edx,%eax
  802f1b:	c1 e0 02             	shl    $0x2,%eax
  802f1e:	05 40 20 81 00       	add    $0x812040,%eax
  802f23:	8b 08                	mov    (%eax),%ecx
  802f25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f28:	89 d0                	mov    %edx,%eax
  802f2a:	01 c0                	add    %eax,%eax
  802f2c:	01 d0                	add    %edx,%eax
  802f2e:	c1 e0 02             	shl    $0x2,%eax
  802f31:	05 44 20 81 00       	add    $0x812044,%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	01 c1                	add    %eax,%ecx
  802f3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f3d:	89 d0                	mov    %edx,%eax
  802f3f:	01 c0                	add    %eax,%eax
  802f41:	01 d0                	add    %edx,%eax
  802f43:	c1 e0 02             	shl    $0x2,%eax
  802f46:	05 40 20 81 00       	add    $0x812040,%eax
  802f4b:	8b 00                	mov    (%eax),%eax
  802f4d:	39 c1                	cmp    %eax,%ecx
  802f4f:	75 52                	jne    802fa3 <sfree+0x2b0>
						{
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
  802fa0:	eb 01                	jmp    802fa3 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802fa2:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802fa3:	ff 45 e8             	incl   -0x18(%ebp)
  802fa6:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802fad:	0f 8e 7f fe ff ff    	jle    802e32 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802fb3:	a1 30 61 83 00       	mov    0x836130,%eax
  802fb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802fbb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802fc2:	eb 53                	jmp    803017 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802fc4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fc7:	89 d0                	mov    %edx,%eax
  802fc9:	01 c0                	add    %eax,%eax
  802fcb:	01 d0                	add    %edx,%eax
  802fcd:	c1 e0 02             	shl    $0x2,%eax
  802fd0:	05 48 60 80 00       	add    $0x806048,%eax
  802fd5:	8a 00                	mov    (%eax),%al
  802fd7:	84 c0                	test   %al,%al
  802fd9:	74 39                	je     803014 <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802fdb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fde:	89 d0                	mov    %edx,%eax
  802fe0:	01 c0                	add    %eax,%eax
  802fe2:	01 d0                	add    %edx,%eax
  802fe4:	c1 e0 02             	shl    $0x2,%eax
  802fe7:	05 40 60 80 00       	add    $0x806040,%eax
  802fec:	8b 08                	mov    (%eax),%ecx
  802fee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ff1:	89 d0                	mov    %edx,%eax
  802ff3:	01 c0                	add    %eax,%eax
  802ff5:	01 d0                	add    %edx,%eax
  802ff7:	c1 e0 02             	shl    $0x2,%eax
  802ffa:	05 44 60 80 00       	add    $0x806044,%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	01 c8                	add    %ecx,%eax
  803003:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  803006:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803009:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80300c:	76 06                	jbe    803014 <sfree+0x321>
  80300e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803011:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803014:	ff 45 e0             	incl   -0x20(%ebp)
  803017:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80301e:	7e a4                	jle    802fc4 <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803023:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  803028:	eb 16                	jmp    803040 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80302a:	ff 45 f4             	incl   -0xc(%ebp)
  80302d:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  803034:	0f 8e 04 fd ff ff    	jle    802d3e <sfree+0x4b>
  80303a:	eb 04                	jmp    803040 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  80303c:	90                   	nop
  80303d:	eb 01                	jmp    803040 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  80303f:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803040:	c9                   	leave  
  803041:	c3                   	ret    

00803042 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803042:	55                   	push   %ebp
  803043:	89 e5                	mov    %esp,%ebp
  803045:	57                   	push   %edi
  803046:	56                   	push   %esi
  803047:	53                   	push   %ebx
  803048:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803051:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803054:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803057:	8b 7d 18             	mov    0x18(%ebp),%edi
  80305a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80305d:	cd 30                	int    $0x30
  80305f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803062:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803065:	83 c4 10             	add    $0x10,%esp
  803068:	5b                   	pop    %ebx
  803069:	5e                   	pop    %esi
  80306a:	5f                   	pop    %edi
  80306b:	5d                   	pop    %ebp
  80306c:	c3                   	ret    

0080306d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80306d:	55                   	push   %ebp
  80306e:	89 e5                	mov    %esp,%ebp
  803070:	83 ec 04             	sub    $0x4,%esp
  803073:	8b 45 10             	mov    0x10(%ebp),%eax
  803076:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803079:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80307c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	6a 00                	push   $0x0
  803085:	51                   	push   %ecx
  803086:	52                   	push   %edx
  803087:	ff 75 0c             	pushl  0xc(%ebp)
  80308a:	50                   	push   %eax
  80308b:	6a 00                	push   $0x0
  80308d:	e8 b0 ff ff ff       	call   803042 <syscall>
  803092:	83 c4 18             	add    $0x18,%esp
}
  803095:	90                   	nop
  803096:	c9                   	leave  
  803097:	c3                   	ret    

00803098 <sys_cgetc>:

int
sys_cgetc(void)
{
  803098:	55                   	push   %ebp
  803099:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80309b:	6a 00                	push   $0x0
  80309d:	6a 00                	push   $0x0
  80309f:	6a 00                	push   $0x0
  8030a1:	6a 00                	push   $0x0
  8030a3:	6a 00                	push   $0x0
  8030a5:	6a 02                	push   $0x2
  8030a7:	e8 96 ff ff ff       	call   803042 <syscall>
  8030ac:	83 c4 18             	add    $0x18,%esp
}
  8030af:	c9                   	leave  
  8030b0:	c3                   	ret    

008030b1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8030b1:	55                   	push   %ebp
  8030b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8030b4:	6a 00                	push   $0x0
  8030b6:	6a 00                	push   $0x0
  8030b8:	6a 00                	push   $0x0
  8030ba:	6a 00                	push   $0x0
  8030bc:	6a 00                	push   $0x0
  8030be:	6a 03                	push   $0x3
  8030c0:	e8 7d ff ff ff       	call   803042 <syscall>
  8030c5:	83 c4 18             	add    $0x18,%esp
}
  8030c8:	90                   	nop
  8030c9:	c9                   	leave  
  8030ca:	c3                   	ret    

008030cb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8030cb:	55                   	push   %ebp
  8030cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8030ce:	6a 00                	push   $0x0
  8030d0:	6a 00                	push   $0x0
  8030d2:	6a 00                	push   $0x0
  8030d4:	6a 00                	push   $0x0
  8030d6:	6a 00                	push   $0x0
  8030d8:	6a 04                	push   $0x4
  8030da:	e8 63 ff ff ff       	call   803042 <syscall>
  8030df:	83 c4 18             	add    $0x18,%esp
}
  8030e2:	90                   	nop
  8030e3:	c9                   	leave  
  8030e4:	c3                   	ret    

008030e5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8030e5:	55                   	push   %ebp
  8030e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8030e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	6a 00                	push   $0x0
  8030f0:	6a 00                	push   $0x0
  8030f2:	6a 00                	push   $0x0
  8030f4:	52                   	push   %edx
  8030f5:	50                   	push   %eax
  8030f6:	6a 08                	push   $0x8
  8030f8:	e8 45 ff ff ff       	call   803042 <syscall>
  8030fd:	83 c4 18             	add    $0x18,%esp
}
  803100:	c9                   	leave  
  803101:	c3                   	ret    

00803102 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803102:	55                   	push   %ebp
  803103:	89 e5                	mov    %esp,%ebp
  803105:	56                   	push   %esi
  803106:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803107:	8b 75 18             	mov    0x18(%ebp),%esi
  80310a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80310d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803110:	8b 55 0c             	mov    0xc(%ebp),%edx
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	56                   	push   %esi
  803117:	53                   	push   %ebx
  803118:	51                   	push   %ecx
  803119:	52                   	push   %edx
  80311a:	50                   	push   %eax
  80311b:	6a 09                	push   $0x9
  80311d:	e8 20 ff ff ff       	call   803042 <syscall>
  803122:	83 c4 18             	add    $0x18,%esp
}
  803125:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803128:	5b                   	pop    %ebx
  803129:	5e                   	pop    %esi
  80312a:	5d                   	pop    %ebp
  80312b:	c3                   	ret    

0080312c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80312c:	55                   	push   %ebp
  80312d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80312f:	6a 00                	push   $0x0
  803131:	6a 00                	push   $0x0
  803133:	6a 00                	push   $0x0
  803135:	6a 00                	push   $0x0
  803137:	ff 75 08             	pushl  0x8(%ebp)
  80313a:	6a 0a                	push   $0xa
  80313c:	e8 01 ff ff ff       	call   803042 <syscall>
  803141:	83 c4 18             	add    $0x18,%esp
}
  803144:	c9                   	leave  
  803145:	c3                   	ret    

00803146 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803146:	55                   	push   %ebp
  803147:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803149:	6a 00                	push   $0x0
  80314b:	6a 00                	push   $0x0
  80314d:	6a 00                	push   $0x0
  80314f:	ff 75 0c             	pushl  0xc(%ebp)
  803152:	ff 75 08             	pushl  0x8(%ebp)
  803155:	6a 0b                	push   $0xb
  803157:	e8 e6 fe ff ff       	call   803042 <syscall>
  80315c:	83 c4 18             	add    $0x18,%esp
}
  80315f:	c9                   	leave  
  803160:	c3                   	ret    

00803161 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803161:	55                   	push   %ebp
  803162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803164:	6a 00                	push   $0x0
  803166:	6a 00                	push   $0x0
  803168:	6a 00                	push   $0x0
  80316a:	6a 00                	push   $0x0
  80316c:	6a 00                	push   $0x0
  80316e:	6a 0c                	push   $0xc
  803170:	e8 cd fe ff ff       	call   803042 <syscall>
  803175:	83 c4 18             	add    $0x18,%esp
}
  803178:	c9                   	leave  
  803179:	c3                   	ret    

0080317a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80317a:	55                   	push   %ebp
  80317b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80317d:	6a 00                	push   $0x0
  80317f:	6a 00                	push   $0x0
  803181:	6a 00                	push   $0x0
  803183:	6a 00                	push   $0x0
  803185:	6a 00                	push   $0x0
  803187:	6a 0d                	push   $0xd
  803189:	e8 b4 fe ff ff       	call   803042 <syscall>
  80318e:	83 c4 18             	add    $0x18,%esp
}
  803191:	c9                   	leave  
  803192:	c3                   	ret    

00803193 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803193:	55                   	push   %ebp
  803194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803196:	6a 00                	push   $0x0
  803198:	6a 00                	push   $0x0
  80319a:	6a 00                	push   $0x0
  80319c:	6a 00                	push   $0x0
  80319e:	6a 00                	push   $0x0
  8031a0:	6a 0e                	push   $0xe
  8031a2:	e8 9b fe ff ff       	call   803042 <syscall>
  8031a7:	83 c4 18             	add    $0x18,%esp
}
  8031aa:	c9                   	leave  
  8031ab:	c3                   	ret    

008031ac <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8031ac:	55                   	push   %ebp
  8031ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8031af:	6a 00                	push   $0x0
  8031b1:	6a 00                	push   $0x0
  8031b3:	6a 00                	push   $0x0
  8031b5:	6a 00                	push   $0x0
  8031b7:	6a 00                	push   $0x0
  8031b9:	6a 0f                	push   $0xf
  8031bb:	e8 82 fe ff ff       	call   803042 <syscall>
  8031c0:	83 c4 18             	add    $0x18,%esp
}
  8031c3:	c9                   	leave  
  8031c4:	c3                   	ret    

008031c5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8031c5:	55                   	push   %ebp
  8031c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8031c8:	6a 00                	push   $0x0
  8031ca:	6a 00                	push   $0x0
  8031cc:	6a 00                	push   $0x0
  8031ce:	6a 00                	push   $0x0
  8031d0:	ff 75 08             	pushl  0x8(%ebp)
  8031d3:	6a 10                	push   $0x10
  8031d5:	e8 68 fe ff ff       	call   803042 <syscall>
  8031da:	83 c4 18             	add    $0x18,%esp
}
  8031dd:	c9                   	leave  
  8031de:	c3                   	ret    

008031df <sys_scarce_memory>:

void sys_scarce_memory()
{
  8031df:	55                   	push   %ebp
  8031e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8031e2:	6a 00                	push   $0x0
  8031e4:	6a 00                	push   $0x0
  8031e6:	6a 00                	push   $0x0
  8031e8:	6a 00                	push   $0x0
  8031ea:	6a 00                	push   $0x0
  8031ec:	6a 11                	push   $0x11
  8031ee:	e8 4f fe ff ff       	call   803042 <syscall>
  8031f3:	83 c4 18             	add    $0x18,%esp
}
  8031f6:	90                   	nop
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    

008031f9 <sys_cputc>:

void
sys_cputc(const char c)
{
  8031f9:	55                   	push   %ebp
  8031fa:	89 e5                	mov    %esp,%ebp
  8031fc:	83 ec 04             	sub    $0x4,%esp
  8031ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803202:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803205:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803209:	6a 00                	push   $0x0
  80320b:	6a 00                	push   $0x0
  80320d:	6a 00                	push   $0x0
  80320f:	6a 00                	push   $0x0
  803211:	50                   	push   %eax
  803212:	6a 01                	push   $0x1
  803214:	e8 29 fe ff ff       	call   803042 <syscall>
  803219:	83 c4 18             	add    $0x18,%esp
}
  80321c:	90                   	nop
  80321d:	c9                   	leave  
  80321e:	c3                   	ret    

0080321f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80321f:	55                   	push   %ebp
  803220:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803222:	6a 00                	push   $0x0
  803224:	6a 00                	push   $0x0
  803226:	6a 00                	push   $0x0
  803228:	6a 00                	push   $0x0
  80322a:	6a 00                	push   $0x0
  80322c:	6a 14                	push   $0x14
  80322e:	e8 0f fe ff ff       	call   803042 <syscall>
  803233:	83 c4 18             	add    $0x18,%esp
}
  803236:	90                   	nop
  803237:	c9                   	leave  
  803238:	c3                   	ret    

00803239 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803239:	55                   	push   %ebp
  80323a:	89 e5                	mov    %esp,%ebp
  80323c:	83 ec 04             	sub    $0x4,%esp
  80323f:	8b 45 10             	mov    0x10(%ebp),%eax
  803242:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803245:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803248:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	6a 00                	push   $0x0
  803251:	51                   	push   %ecx
  803252:	52                   	push   %edx
  803253:	ff 75 0c             	pushl  0xc(%ebp)
  803256:	50                   	push   %eax
  803257:	6a 15                	push   $0x15
  803259:	e8 e4 fd ff ff       	call   803042 <syscall>
  80325e:	83 c4 18             	add    $0x18,%esp
}
  803261:	c9                   	leave  
  803262:	c3                   	ret    

00803263 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803263:	55                   	push   %ebp
  803264:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803266:	8b 55 0c             	mov    0xc(%ebp),%edx
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	6a 00                	push   $0x0
  80326e:	6a 00                	push   $0x0
  803270:	6a 00                	push   $0x0
  803272:	52                   	push   %edx
  803273:	50                   	push   %eax
  803274:	6a 16                	push   $0x16
  803276:	e8 c7 fd ff ff       	call   803042 <syscall>
  80327b:	83 c4 18             	add    $0x18,%esp
}
  80327e:	c9                   	leave  
  80327f:	c3                   	ret    

00803280 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803280:	55                   	push   %ebp
  803281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803283:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803286:	8b 55 0c             	mov    0xc(%ebp),%edx
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	6a 00                	push   $0x0
  80328e:	6a 00                	push   $0x0
  803290:	51                   	push   %ecx
  803291:	52                   	push   %edx
  803292:	50                   	push   %eax
  803293:	6a 17                	push   $0x17
  803295:	e8 a8 fd ff ff       	call   803042 <syscall>
  80329a:	83 c4 18             	add    $0x18,%esp
}
  80329d:	c9                   	leave  
  80329e:	c3                   	ret    

0080329f <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80329f:	55                   	push   %ebp
  8032a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8032a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	6a 00                	push   $0x0
  8032aa:	6a 00                	push   $0x0
  8032ac:	6a 00                	push   $0x0
  8032ae:	52                   	push   %edx
  8032af:	50                   	push   %eax
  8032b0:	6a 18                	push   $0x18
  8032b2:	e8 8b fd ff ff       	call   803042 <syscall>
  8032b7:	83 c4 18             	add    $0x18,%esp
}
  8032ba:	c9                   	leave  
  8032bb:	c3                   	ret    

008032bc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8032bc:	55                   	push   %ebp
  8032bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	6a 00                	push   $0x0
  8032c4:	ff 75 14             	pushl  0x14(%ebp)
  8032c7:	ff 75 10             	pushl  0x10(%ebp)
  8032ca:	ff 75 0c             	pushl  0xc(%ebp)
  8032cd:	50                   	push   %eax
  8032ce:	6a 19                	push   $0x19
  8032d0:	e8 6d fd ff ff       	call   803042 <syscall>
  8032d5:	83 c4 18             	add    $0x18,%esp
}
  8032d8:	c9                   	leave  
  8032d9:	c3                   	ret    

008032da <sys_run_env>:

void sys_run_env(int32 envId)
{
  8032da:	55                   	push   %ebp
  8032db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	6a 00                	push   $0x0
  8032e2:	6a 00                	push   $0x0
  8032e4:	6a 00                	push   $0x0
  8032e6:	6a 00                	push   $0x0
  8032e8:	50                   	push   %eax
  8032e9:	6a 1a                	push   $0x1a
  8032eb:	e8 52 fd ff ff       	call   803042 <syscall>
  8032f0:	83 c4 18             	add    $0x18,%esp
}
  8032f3:	90                   	nop
  8032f4:	c9                   	leave  
  8032f5:	c3                   	ret    

008032f6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8032f6:	55                   	push   %ebp
  8032f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	6a 00                	push   $0x0
  8032fe:	6a 00                	push   $0x0
  803300:	6a 00                	push   $0x0
  803302:	6a 00                	push   $0x0
  803304:	50                   	push   %eax
  803305:	6a 1b                	push   $0x1b
  803307:	e8 36 fd ff ff       	call   803042 <syscall>
  80330c:	83 c4 18             	add    $0x18,%esp
}
  80330f:	c9                   	leave  
  803310:	c3                   	ret    

00803311 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803311:	55                   	push   %ebp
  803312:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803314:	6a 00                	push   $0x0
  803316:	6a 00                	push   $0x0
  803318:	6a 00                	push   $0x0
  80331a:	6a 00                	push   $0x0
  80331c:	6a 00                	push   $0x0
  80331e:	6a 05                	push   $0x5
  803320:	e8 1d fd ff ff       	call   803042 <syscall>
  803325:	83 c4 18             	add    $0x18,%esp
}
  803328:	c9                   	leave  
  803329:	c3                   	ret    

0080332a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80332a:	55                   	push   %ebp
  80332b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80332d:	6a 00                	push   $0x0
  80332f:	6a 00                	push   $0x0
  803331:	6a 00                	push   $0x0
  803333:	6a 00                	push   $0x0
  803335:	6a 00                	push   $0x0
  803337:	6a 06                	push   $0x6
  803339:	e8 04 fd ff ff       	call   803042 <syscall>
  80333e:	83 c4 18             	add    $0x18,%esp
}
  803341:	c9                   	leave  
  803342:	c3                   	ret    

00803343 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803343:	55                   	push   %ebp
  803344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803346:	6a 00                	push   $0x0
  803348:	6a 00                	push   $0x0
  80334a:	6a 00                	push   $0x0
  80334c:	6a 00                	push   $0x0
  80334e:	6a 00                	push   $0x0
  803350:	6a 07                	push   $0x7
  803352:	e8 eb fc ff ff       	call   803042 <syscall>
  803357:	83 c4 18             	add    $0x18,%esp
}
  80335a:	c9                   	leave  
  80335b:	c3                   	ret    

0080335c <sys_exit_env>:


void sys_exit_env(void)
{
  80335c:	55                   	push   %ebp
  80335d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80335f:	6a 00                	push   $0x0
  803361:	6a 00                	push   $0x0
  803363:	6a 00                	push   $0x0
  803365:	6a 00                	push   $0x0
  803367:	6a 00                	push   $0x0
  803369:	6a 1c                	push   $0x1c
  80336b:	e8 d2 fc ff ff       	call   803042 <syscall>
  803370:	83 c4 18             	add    $0x18,%esp
}
  803373:	90                   	nop
  803374:	c9                   	leave  
  803375:	c3                   	ret    

00803376 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803376:	55                   	push   %ebp
  803377:	89 e5                	mov    %esp,%ebp
  803379:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80337c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80337f:	8d 50 04             	lea    0x4(%eax),%edx
  803382:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803385:	6a 00                	push   $0x0
  803387:	6a 00                	push   $0x0
  803389:	6a 00                	push   $0x0
  80338b:	52                   	push   %edx
  80338c:	50                   	push   %eax
  80338d:	6a 1d                	push   $0x1d
  80338f:	e8 ae fc ff ff       	call   803042 <syscall>
  803394:	83 c4 18             	add    $0x18,%esp
	return result;
  803397:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80339a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80339d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033a0:	89 01                	mov    %eax,(%ecx)
  8033a2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	c9                   	leave  
  8033a9:	c2 04 00             	ret    $0x4

008033ac <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8033ac:	55                   	push   %ebp
  8033ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8033af:	6a 00                	push   $0x0
  8033b1:	6a 00                	push   $0x0
  8033b3:	ff 75 10             	pushl  0x10(%ebp)
  8033b6:	ff 75 0c             	pushl  0xc(%ebp)
  8033b9:	ff 75 08             	pushl  0x8(%ebp)
  8033bc:	6a 13                	push   $0x13
  8033be:	e8 7f fc ff ff       	call   803042 <syscall>
  8033c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8033c6:	90                   	nop
}
  8033c7:	c9                   	leave  
  8033c8:	c3                   	ret    

008033c9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8033c9:	55                   	push   %ebp
  8033ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8033cc:	6a 00                	push   $0x0
  8033ce:	6a 00                	push   $0x0
  8033d0:	6a 00                	push   $0x0
  8033d2:	6a 00                	push   $0x0
  8033d4:	6a 00                	push   $0x0
  8033d6:	6a 1e                	push   $0x1e
  8033d8:	e8 65 fc ff ff       	call   803042 <syscall>
  8033dd:	83 c4 18             	add    $0x18,%esp
}
  8033e0:	c9                   	leave  
  8033e1:	c3                   	ret    

008033e2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8033e2:	55                   	push   %ebp
  8033e3:	89 e5                	mov    %esp,%ebp
  8033e5:	83 ec 04             	sub    $0x4,%esp
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8033ee:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8033f2:	6a 00                	push   $0x0
  8033f4:	6a 00                	push   $0x0
  8033f6:	6a 00                	push   $0x0
  8033f8:	6a 00                	push   $0x0
  8033fa:	50                   	push   %eax
  8033fb:	6a 1f                	push   $0x1f
  8033fd:	e8 40 fc ff ff       	call   803042 <syscall>
  803402:	83 c4 18             	add    $0x18,%esp
	return ;
  803405:	90                   	nop
}
  803406:	c9                   	leave  
  803407:	c3                   	ret    

00803408 <rsttst>:
void rsttst()
{
  803408:	55                   	push   %ebp
  803409:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80340b:	6a 00                	push   $0x0
  80340d:	6a 00                	push   $0x0
  80340f:	6a 00                	push   $0x0
  803411:	6a 00                	push   $0x0
  803413:	6a 00                	push   $0x0
  803415:	6a 21                	push   $0x21
  803417:	e8 26 fc ff ff       	call   803042 <syscall>
  80341c:	83 c4 18             	add    $0x18,%esp
	return ;
  80341f:	90                   	nop
}
  803420:	c9                   	leave  
  803421:	c3                   	ret    

00803422 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803422:	55                   	push   %ebp
  803423:	89 e5                	mov    %esp,%ebp
  803425:	83 ec 04             	sub    $0x4,%esp
  803428:	8b 45 14             	mov    0x14(%ebp),%eax
  80342b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80342e:	8b 55 18             	mov    0x18(%ebp),%edx
  803431:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803435:	52                   	push   %edx
  803436:	50                   	push   %eax
  803437:	ff 75 10             	pushl  0x10(%ebp)
  80343a:	ff 75 0c             	pushl  0xc(%ebp)
  80343d:	ff 75 08             	pushl  0x8(%ebp)
  803440:	6a 20                	push   $0x20
  803442:	e8 fb fb ff ff       	call   803042 <syscall>
  803447:	83 c4 18             	add    $0x18,%esp
	return ;
  80344a:	90                   	nop
}
  80344b:	c9                   	leave  
  80344c:	c3                   	ret    

0080344d <chktst>:
void chktst(uint32 n)
{
  80344d:	55                   	push   %ebp
  80344e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803450:	6a 00                	push   $0x0
  803452:	6a 00                	push   $0x0
  803454:	6a 00                	push   $0x0
  803456:	6a 00                	push   $0x0
  803458:	ff 75 08             	pushl  0x8(%ebp)
  80345b:	6a 22                	push   $0x22
  80345d:	e8 e0 fb ff ff       	call   803042 <syscall>
  803462:	83 c4 18             	add    $0x18,%esp
	return ;
  803465:	90                   	nop
}
  803466:	c9                   	leave  
  803467:	c3                   	ret    

00803468 <inctst>:

void inctst()
{
  803468:	55                   	push   %ebp
  803469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80346b:	6a 00                	push   $0x0
  80346d:	6a 00                	push   $0x0
  80346f:	6a 00                	push   $0x0
  803471:	6a 00                	push   $0x0
  803473:	6a 00                	push   $0x0
  803475:	6a 23                	push   $0x23
  803477:	e8 c6 fb ff ff       	call   803042 <syscall>
  80347c:	83 c4 18             	add    $0x18,%esp
	return ;
  80347f:	90                   	nop
}
  803480:	c9                   	leave  
  803481:	c3                   	ret    

00803482 <gettst>:
uint32 gettst()
{
  803482:	55                   	push   %ebp
  803483:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803485:	6a 00                	push   $0x0
  803487:	6a 00                	push   $0x0
  803489:	6a 00                	push   $0x0
  80348b:	6a 00                	push   $0x0
  80348d:	6a 00                	push   $0x0
  80348f:	6a 24                	push   $0x24
  803491:	e8 ac fb ff ff       	call   803042 <syscall>
  803496:	83 c4 18             	add    $0x18,%esp
}
  803499:	c9                   	leave  
  80349a:	c3                   	ret    

0080349b <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80349b:	55                   	push   %ebp
  80349c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80349e:	6a 00                	push   $0x0
  8034a0:	6a 00                	push   $0x0
  8034a2:	6a 00                	push   $0x0
  8034a4:	6a 00                	push   $0x0
  8034a6:	6a 00                	push   $0x0
  8034a8:	6a 25                	push   $0x25
  8034aa:	e8 93 fb ff ff       	call   803042 <syscall>
  8034af:	83 c4 18             	add    $0x18,%esp
  8034b2:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  8034b7:	a1 80 60 83 00       	mov    0x836080,%eax
}
  8034bc:	c9                   	leave  
  8034bd:	c3                   	ret    

008034be <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8034be:	55                   	push   %ebp
  8034bf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8034c9:	6a 00                	push   $0x0
  8034cb:	6a 00                	push   $0x0
  8034cd:	6a 00                	push   $0x0
  8034cf:	6a 00                	push   $0x0
  8034d1:	ff 75 08             	pushl  0x8(%ebp)
  8034d4:	6a 26                	push   $0x26
  8034d6:	e8 67 fb ff ff       	call   803042 <syscall>
  8034db:	83 c4 18             	add    $0x18,%esp
	return ;
  8034de:	90                   	nop
}
  8034df:	c9                   	leave  
  8034e0:	c3                   	ret    

008034e1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8034e1:	55                   	push   %ebp
  8034e2:	89 e5                	mov    %esp,%ebp
  8034e4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8034e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8034e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8034eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	6a 00                	push   $0x0
  8034f3:	53                   	push   %ebx
  8034f4:	51                   	push   %ecx
  8034f5:	52                   	push   %edx
  8034f6:	50                   	push   %eax
  8034f7:	6a 27                	push   $0x27
  8034f9:	e8 44 fb ff ff       	call   803042 <syscall>
  8034fe:	83 c4 18             	add    $0x18,%esp
}
  803501:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803504:	c9                   	leave  
  803505:	c3                   	ret    

00803506 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803506:	55                   	push   %ebp
  803507:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803509:	8b 55 0c             	mov    0xc(%ebp),%edx
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	6a 00                	push   $0x0
  803511:	6a 00                	push   $0x0
  803513:	6a 00                	push   $0x0
  803515:	52                   	push   %edx
  803516:	50                   	push   %eax
  803517:	6a 28                	push   $0x28
  803519:	e8 24 fb ff ff       	call   803042 <syscall>
  80351e:	83 c4 18             	add    $0x18,%esp
}
  803521:	c9                   	leave  
  803522:	c3                   	ret    

00803523 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803523:	55                   	push   %ebp
  803524:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803526:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803529:	8b 55 0c             	mov    0xc(%ebp),%edx
  80352c:	8b 45 08             	mov    0x8(%ebp),%eax
  80352f:	6a 00                	push   $0x0
  803531:	51                   	push   %ecx
  803532:	ff 75 10             	pushl  0x10(%ebp)
  803535:	52                   	push   %edx
  803536:	50                   	push   %eax
  803537:	6a 29                	push   $0x29
  803539:	e8 04 fb ff ff       	call   803042 <syscall>
  80353e:	83 c4 18             	add    $0x18,%esp
}
  803541:	c9                   	leave  
  803542:	c3                   	ret    

00803543 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803543:	55                   	push   %ebp
  803544:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803546:	6a 00                	push   $0x0
  803548:	6a 00                	push   $0x0
  80354a:	ff 75 10             	pushl  0x10(%ebp)
  80354d:	ff 75 0c             	pushl  0xc(%ebp)
  803550:	ff 75 08             	pushl  0x8(%ebp)
  803553:	6a 12                	push   $0x12
  803555:	e8 e8 fa ff ff       	call   803042 <syscall>
  80355a:	83 c4 18             	add    $0x18,%esp
	return ;
  80355d:	90                   	nop
}
  80355e:	c9                   	leave  
  80355f:	c3                   	ret    

00803560 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803560:	55                   	push   %ebp
  803561:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803563:	8b 55 0c             	mov    0xc(%ebp),%edx
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	6a 00                	push   $0x0
  80356b:	6a 00                	push   $0x0
  80356d:	6a 00                	push   $0x0
  80356f:	52                   	push   %edx
  803570:	50                   	push   %eax
  803571:	6a 2a                	push   $0x2a
  803573:	e8 ca fa ff ff       	call   803042 <syscall>
  803578:	83 c4 18             	add    $0x18,%esp
	return;
  80357b:	90                   	nop
}
  80357c:	c9                   	leave  
  80357d:	c3                   	ret    

0080357e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80357e:	55                   	push   %ebp
  80357f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803581:	6a 00                	push   $0x0
  803583:	6a 00                	push   $0x0
  803585:	6a 00                	push   $0x0
  803587:	6a 00                	push   $0x0
  803589:	6a 00                	push   $0x0
  80358b:	6a 2b                	push   $0x2b
  80358d:	e8 b0 fa ff ff       	call   803042 <syscall>
  803592:	83 c4 18             	add    $0x18,%esp
}
  803595:	c9                   	leave  
  803596:	c3                   	ret    

00803597 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803597:	55                   	push   %ebp
  803598:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80359a:	6a 00                	push   $0x0
  80359c:	6a 00                	push   $0x0
  80359e:	6a 00                	push   $0x0
  8035a0:	ff 75 0c             	pushl  0xc(%ebp)
  8035a3:	ff 75 08             	pushl  0x8(%ebp)
  8035a6:	6a 2d                	push   $0x2d
  8035a8:	e8 95 fa ff ff       	call   803042 <syscall>
  8035ad:	83 c4 18             	add    $0x18,%esp
	return;
  8035b0:	90                   	nop
}
  8035b1:	c9                   	leave  
  8035b2:	c3                   	ret    

008035b3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8035b3:	55                   	push   %ebp
  8035b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8035b6:	6a 00                	push   $0x0
  8035b8:	6a 00                	push   $0x0
  8035ba:	6a 00                	push   $0x0
  8035bc:	ff 75 0c             	pushl  0xc(%ebp)
  8035bf:	ff 75 08             	pushl  0x8(%ebp)
  8035c2:	6a 2c                	push   $0x2c
  8035c4:	e8 79 fa ff ff       	call   803042 <syscall>
  8035c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8035cc:	90                   	nop
}
  8035cd:	c9                   	leave  
  8035ce:	c3                   	ret    

008035cf <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8035cf:	55                   	push   %ebp
  8035d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8035d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d8:	6a 00                	push   $0x0
  8035da:	6a 00                	push   $0x0
  8035dc:	6a 00                	push   $0x0
  8035de:	52                   	push   %edx
  8035df:	50                   	push   %eax
  8035e0:	6a 2e                	push   $0x2e
  8035e2:	e8 5b fa ff ff       	call   803042 <syscall>
  8035e7:	83 c4 18             	add    $0x18,%esp
}
  8035ea:	90                   	nop
  8035eb:	c9                   	leave  
  8035ec:	c3                   	ret    

008035ed <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8035ed:	55                   	push   %ebp
  8035ee:	89 e5                	mov    %esp,%ebp
  8035f0:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8035f3:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  8035fa:	72 09                	jb     803605 <to_page_va+0x18>
  8035fc:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  803603:	72 14                	jb     803619 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  803605:	83 ec 04             	sub    $0x4,%esp
  803608:	68 58 4d 80 00       	push   $0x804d58
  80360d:	6a 15                	push   $0x15
  80360f:	68 83 4d 80 00       	push   $0x804d83
  803614:	e8 db 0a 00 00       	call   8040f4 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803621:	29 d0                	sub    %edx,%eax
  803623:	c1 f8 02             	sar    $0x2,%eax
  803626:	89 c2                	mov    %eax,%edx
  803628:	89 d0                	mov    %edx,%eax
  80362a:	c1 e0 02             	shl    $0x2,%eax
  80362d:	01 d0                	add    %edx,%eax
  80362f:	c1 e0 02             	shl    $0x2,%eax
  803632:	01 d0                	add    %edx,%eax
  803634:	c1 e0 02             	shl    $0x2,%eax
  803637:	01 d0                	add    %edx,%eax
  803639:	89 c1                	mov    %eax,%ecx
  80363b:	c1 e1 08             	shl    $0x8,%ecx
  80363e:	01 c8                	add    %ecx,%eax
  803640:	89 c1                	mov    %eax,%ecx
  803642:	c1 e1 10             	shl    $0x10,%ecx
  803645:	01 c8                	add    %ecx,%eax
  803647:	01 c0                	add    %eax,%eax
  803649:	01 d0                	add    %edx,%eax
  80364b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80364e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803651:	c1 e0 0c             	shl    $0xc,%eax
  803654:	89 c2                	mov    %eax,%edx
  803656:	a1 84 60 83 00       	mov    0x836084,%eax
  80365b:	01 d0                	add    %edx,%eax
}
  80365d:	c9                   	leave  
  80365e:	c3                   	ret    

0080365f <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  80365f:	55                   	push   %ebp
  803660:	89 e5                	mov    %esp,%ebp
  803662:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803665:	a1 84 60 83 00       	mov    0x836084,%eax
  80366a:	8b 55 08             	mov    0x8(%ebp),%edx
  80366d:	29 c2                	sub    %eax,%edx
  80366f:	89 d0                	mov    %edx,%eax
  803671:	c1 e8 0c             	shr    $0xc,%eax
  803674:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367b:	78 09                	js     803686 <to_page_info+0x27>
  80367d:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803684:	7e 14                	jle    80369a <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  803686:	83 ec 04             	sub    $0x4,%esp
  803689:	68 9c 4d 80 00       	push   $0x804d9c
  80368e:	6a 21                	push   $0x21
  803690:	68 83 4d 80 00       	push   $0x804d83
  803695:	e8 5a 0a 00 00       	call   8040f4 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80369a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80369d:	89 d0                	mov    %edx,%eax
  80369f:	01 c0                	add    %eax,%eax
  8036a1:	01 d0                	add    %edx,%eax
  8036a3:	c1 e0 02             	shl    $0x2,%eax
  8036a6:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  8036ab:	c9                   	leave  
  8036ac:	c3                   	ret    

008036ad <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8036ad:	55                   	push   %ebp
  8036ae:	89 e5                	mov    %esp,%ebp
  8036b0:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8036b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b6:	05 00 00 00 02       	add    $0x2000000,%eax
  8036bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036be:	73 16                	jae    8036d6 <initialize_dynamic_allocator+0x29>
  8036c0:	68 c0 4d 80 00       	push   $0x804dc0
  8036c5:	68 e6 4d 80 00       	push   $0x804de6
  8036ca:	6a 2f                	push   $0x2f
  8036cc:	68 83 4d 80 00       	push   $0x804d83
  8036d1:	e8 1e 0a 00 00       	call   8040f4 <_panic>
	dynAllocStart = daStart;
  8036d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d9:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  8036de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e1:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8036e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8036ed:	eb 36                	jmp    803725 <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8036ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f2:	c1 e0 04             	shl    $0x4,%eax
  8036f5:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8036fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803703:	c1 e0 04             	shl    $0x4,%eax
  803706:	05 a4 60 83 00       	add    $0x8360a4,%eax
  80370b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803714:	c1 e0 04             	shl    $0x4,%eax
  803717:	05 ac 60 83 00       	add    $0x8360ac,%eax
  80371c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803722:	ff 45 f4             	incl   -0xc(%ebp)
  803725:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803729:	7e c4                	jle    8036ef <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  80372b:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803732:	00 00 00 
  803735:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  80373c:	00 00 00 
  80373f:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803746:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803749:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803750:	e9 1b 01 00 00       	jmp    803870 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803755:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803758:	89 d0                	mov    %edx,%eax
  80375a:	01 c0                	add    %eax,%eax
  80375c:	01 d0                	add    %edx,%eax
  80375e:	c1 e0 02             	shl    $0x2,%eax
  803761:	05 88 e0 81 00       	add    $0x81e088,%eax
  803766:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  80376b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80376e:	89 d0                	mov    %edx,%eax
  803770:	01 c0                	add    %eax,%eax
  803772:	01 d0                	add    %edx,%eax
  803774:	c1 e0 02             	shl    $0x2,%eax
  803777:	05 8a e0 81 00       	add    $0x81e08a,%eax
  80377c:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803781:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803784:	89 d0                	mov    %edx,%eax
  803786:	01 c0                	add    %eax,%eax
  803788:	01 d0                	add    %edx,%eax
  80378a:	c1 e0 02             	shl    $0x2,%eax
  80378d:	05 80 e0 81 00       	add    $0x81e080,%eax
  803792:	8b 00                	mov    (%eax),%eax
  803794:	85 c0                	test   %eax,%eax
  803796:	74 2b                	je     8037c3 <initialize_dynamic_allocator+0x116>
  803798:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80379b:	89 d0                	mov    %edx,%eax
  80379d:	01 c0                	add    %eax,%eax
  80379f:	01 d0                	add    %edx,%eax
  8037a1:	c1 e0 02             	shl    $0x2,%eax
  8037a4:	05 80 e0 81 00       	add    $0x81e080,%eax
  8037a9:	8b 10                	mov    (%eax),%edx
  8037ab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8037ae:	89 c8                	mov    %ecx,%eax
  8037b0:	01 c0                	add    %eax,%eax
  8037b2:	01 c8                	add    %ecx,%eax
  8037b4:	c1 e0 02             	shl    $0x2,%eax
  8037b7:	05 84 e0 81 00       	add    $0x81e084,%eax
  8037bc:	8b 00                	mov    (%eax),%eax
  8037be:	89 42 04             	mov    %eax,0x4(%edx)
  8037c1:	eb 18                	jmp    8037db <initialize_dynamic_allocator+0x12e>
  8037c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037c6:	89 d0                	mov    %edx,%eax
  8037c8:	01 c0                	add    %eax,%eax
  8037ca:	01 d0                	add    %edx,%eax
  8037cc:	c1 e0 02             	shl    $0x2,%eax
  8037cf:	05 84 e0 81 00       	add    $0x81e084,%eax
  8037d4:	8b 00                	mov    (%eax),%eax
  8037d6:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8037db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037de:	89 d0                	mov    %edx,%eax
  8037e0:	01 c0                	add    %eax,%eax
  8037e2:	01 d0                	add    %edx,%eax
  8037e4:	c1 e0 02             	shl    $0x2,%eax
  8037e7:	05 84 e0 81 00       	add    $0x81e084,%eax
  8037ec:	8b 00                	mov    (%eax),%eax
  8037ee:	85 c0                	test   %eax,%eax
  8037f0:	74 2a                	je     80381c <initialize_dynamic_allocator+0x16f>
  8037f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037f5:	89 d0                	mov    %edx,%eax
  8037f7:	01 c0                	add    %eax,%eax
  8037f9:	01 d0                	add    %edx,%eax
  8037fb:	c1 e0 02             	shl    $0x2,%eax
  8037fe:	05 84 e0 81 00       	add    $0x81e084,%eax
  803803:	8b 10                	mov    (%eax),%edx
  803805:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803808:	89 c8                	mov    %ecx,%eax
  80380a:	01 c0                	add    %eax,%eax
  80380c:	01 c8                	add    %ecx,%eax
  80380e:	c1 e0 02             	shl    $0x2,%eax
  803811:	05 80 e0 81 00       	add    $0x81e080,%eax
  803816:	8b 00                	mov    (%eax),%eax
  803818:	89 02                	mov    %eax,(%edx)
  80381a:	eb 18                	jmp    803834 <initialize_dynamic_allocator+0x187>
  80381c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80381f:	89 d0                	mov    %edx,%eax
  803821:	01 c0                	add    %eax,%eax
  803823:	01 d0                	add    %edx,%eax
  803825:	c1 e0 02             	shl    $0x2,%eax
  803828:	05 80 e0 81 00       	add    $0x81e080,%eax
  80382d:	8b 00                	mov    (%eax),%eax
  80382f:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803834:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803837:	89 d0                	mov    %edx,%eax
  803839:	01 c0                	add    %eax,%eax
  80383b:	01 d0                	add    %edx,%eax
  80383d:	c1 e0 02             	shl    $0x2,%eax
  803840:	05 80 e0 81 00       	add    $0x81e080,%eax
  803845:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80384b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80384e:	89 d0                	mov    %edx,%eax
  803850:	01 c0                	add    %eax,%eax
  803852:	01 d0                	add    %edx,%eax
  803854:	c1 e0 02             	shl    $0x2,%eax
  803857:	05 84 e0 81 00       	add    $0x81e084,%eax
  80385c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803862:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803867:	48                   	dec    %eax
  803868:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80386d:	ff 45 f0             	incl   -0x10(%ebp)
  803870:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803877:	0f 8e d8 fe ff ff    	jle    803755 <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80387d:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803884:	e9 9d 00 00 00       	jmp    803926 <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803889:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80388f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803892:	89 c8                	mov    %ecx,%eax
  803894:	01 c0                	add    %eax,%eax
  803896:	01 c8                	add    %ecx,%eax
  803898:	c1 e0 02             	shl    $0x2,%eax
  80389b:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038a0:	89 10                	mov    %edx,(%eax)
  8038a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038a5:	89 d0                	mov    %edx,%eax
  8038a7:	01 c0                	add    %eax,%eax
  8038a9:	01 d0                	add    %edx,%eax
  8038ab:	c1 e0 02             	shl    $0x2,%eax
  8038ae:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038b3:	8b 00                	mov    (%eax),%eax
  8038b5:	85 c0                	test   %eax,%eax
  8038b7:	74 1c                	je     8038d5 <initialize_dynamic_allocator+0x228>
  8038b9:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8038bf:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8038c2:	89 c8                	mov    %ecx,%eax
  8038c4:	01 c0                	add    %eax,%eax
  8038c6:	01 c8                	add    %ecx,%eax
  8038c8:	c1 e0 02             	shl    $0x2,%eax
  8038cb:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038d0:	89 42 04             	mov    %eax,0x4(%edx)
  8038d3:	eb 16                	jmp    8038eb <initialize_dynamic_allocator+0x23e>
  8038d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038d8:	89 d0                	mov    %edx,%eax
  8038da:	01 c0                	add    %eax,%eax
  8038dc:	01 d0                	add    %edx,%eax
  8038de:	c1 e0 02             	shl    $0x2,%eax
  8038e1:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038e6:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8038eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038ee:	89 d0                	mov    %edx,%eax
  8038f0:	01 c0                	add    %eax,%eax
  8038f2:	01 d0                	add    %edx,%eax
  8038f4:	c1 e0 02             	shl    $0x2,%eax
  8038f7:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038fc:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803901:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803904:	89 d0                	mov    %edx,%eax
  803906:	01 c0                	add    %eax,%eax
  803908:	01 d0                	add    %edx,%eax
  80390a:	c1 e0 02             	shl    $0x2,%eax
  80390d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803918:	a1 74 e0 81 00       	mov    0x81e074,%eax
  80391d:	40                   	inc    %eax
  80391e:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803923:	ff 4d ec             	decl   -0x14(%ebp)
  803926:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80392a:	0f 89 59 ff ff ff    	jns    803889 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803930:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803937:	00 00 00 
}
  80393a:	90                   	nop
  80393b:	c9                   	leave  
  80393c:	c3                   	ret    

0080393d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80393d:	55                   	push   %ebp
  80393e:	89 e5                	mov    %esp,%ebp
  803940:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803943:	8b 45 08             	mov    0x8(%ebp),%eax
  803946:	83 ec 0c             	sub    $0xc,%esp
  803949:	50                   	push   %eax
  80394a:	e8 10 fd ff ff       	call   80365f <to_page_info>
  80394f:	83 c4 10             	add    $0x10,%esp
  803952:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803958:	8b 40 08             	mov    0x8(%eax),%eax
  80395b:	0f b7 c0             	movzwl %ax,%eax
}
  80395e:	c9                   	leave  
  80395f:	c3                   	ret    

00803960 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803960:	55                   	push   %ebp
  803961:	89 e5                	mov    %esp,%ebp
  803963:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803966:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80396d:	76 16                	jbe    803985 <alloc_block+0x25>
  80396f:	68 fc 4d 80 00       	push   $0x804dfc
  803974:	68 e6 4d 80 00       	push   $0x804de6
  803979:	6a 59                	push   $0x59
  80397b:	68 83 4d 80 00       	push   $0x804d83
  803980:	e8 6f 07 00 00       	call   8040f4 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803985:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80398c:	eb 08                	jmp    803996 <alloc_block+0x36>
		allocSize <<= 1;
  80398e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803991:	01 c0                	add    %eax,%eax
  803993:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803999:	3b 45 08             	cmp    0x8(%ebp),%eax
  80399c:	73 09                	jae    8039a7 <alloc_block+0x47>
  80399e:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8039a5:	76 e7                	jbe    80398e <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8039a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8039ae:	eb 03                	jmp    8039b3 <alloc_block+0x53>
		listIndex++;
  8039b0:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8039b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b6:	ba 08 00 00 00       	mov    $0x8,%edx
  8039bb:	88 c1                	mov    %al,%cl
  8039bd:	d3 e2                	shl    %cl,%edx
  8039bf:	89 d0                	mov    %edx,%eax
  8039c1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8039c4:	72 ea                	jb     8039b0 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8039c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8039cc:	e9 f4 00 00 00       	jmp    803ac5 <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8039d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039d4:	c1 e0 04             	shl    $0x4,%eax
  8039d7:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8039dc:	8b 00                	mov    (%eax),%eax
  8039de:	85 c0                	test   %eax,%eax
  8039e0:	0f 84 dc 00 00 00    	je     803ac2 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8039e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039e9:	c1 e0 04             	shl    $0x4,%eax
  8039ec:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8039f1:	8b 00                	mov    (%eax),%eax
  8039f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  8039f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039fa:	75 14                	jne    803a10 <alloc_block+0xb0>
  8039fc:	83 ec 04             	sub    $0x4,%esp
  8039ff:	68 1d 4e 80 00       	push   $0x804e1d
  803a04:	6a 6b                	push   $0x6b
  803a06:	68 83 4d 80 00       	push   $0x804d83
  803a0b:	e8 e4 06 00 00       	call   8040f4 <_panic>
  803a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a13:	8b 00                	mov    (%eax),%eax
  803a15:	85 c0                	test   %eax,%eax
  803a17:	74 10                	je     803a29 <alloc_block+0xc9>
  803a19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1c:	8b 00                	mov    (%eax),%eax
  803a1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a21:	8b 52 04             	mov    0x4(%edx),%edx
  803a24:	89 50 04             	mov    %edx,0x4(%eax)
  803a27:	eb 14                	jmp    803a3d <alloc_block+0xdd>
  803a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2c:	8b 40 04             	mov    0x4(%eax),%eax
  803a2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a32:	c1 e2 04             	shl    $0x4,%edx
  803a35:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803a3b:	89 02                	mov    %eax,(%edx)
  803a3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a40:	8b 40 04             	mov    0x4(%eax),%eax
  803a43:	85 c0                	test   %eax,%eax
  803a45:	74 0f                	je     803a56 <alloc_block+0xf6>
  803a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4a:	8b 40 04             	mov    0x4(%eax),%eax
  803a4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a50:	8b 12                	mov    (%edx),%edx
  803a52:	89 10                	mov    %edx,(%eax)
  803a54:	eb 13                	jmp    803a69 <alloc_block+0x109>
  803a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a59:	8b 00                	mov    (%eax),%eax
  803a5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a5e:	c1 e2 04             	shl    $0x4,%edx
  803a61:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803a67:	89 02                	mov    %eax,(%edx)
  803a69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a7f:	c1 e0 04             	shl    $0x4,%eax
  803a82:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803a87:	8b 00                	mov    (%eax),%eax
  803a89:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a8f:	c1 e0 04             	shl    $0x4,%eax
  803a92:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803a97:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803a99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9c:	83 ec 0c             	sub    $0xc,%esp
  803a9f:	50                   	push   %eax
  803aa0:	e8 ba fb ff ff       	call   80365f <to_page_info>
  803aa5:	83 c4 10             	add    $0x10,%esp
  803aa8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aae:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803ab2:	48                   	dec    %eax
  803ab3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ab6:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803aba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abd:	e9 8f 02 00 00       	jmp    803d51 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803ac2:	ff 45 ec             	incl   -0x14(%ebp)
  803ac5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803ac9:	0f 8e 02 ff ff ff    	jle    8039d1 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803acf:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803ad4:	85 c0                	test   %eax,%eax
  803ad6:	75 14                	jne    803aec <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803ad8:	83 ec 04             	sub    $0x4,%esp
  803adb:	68 3c 4e 80 00       	push   $0x804e3c
  803ae0:	6a 77                	push   $0x77
  803ae2:	68 83 4d 80 00       	push   $0x804d83
  803ae7:	e8 08 06 00 00       	call   8040f4 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803aec:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803af1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803af4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803af8:	75 14                	jne    803b0e <alloc_block+0x1ae>
  803afa:	83 ec 04             	sub    $0x4,%esp
  803afd:	68 1d 4e 80 00       	push   $0x804e1d
  803b02:	6a 7a                	push   $0x7a
  803b04:	68 83 4d 80 00       	push   $0x804d83
  803b09:	e8 e6 05 00 00       	call   8040f4 <_panic>
  803b0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b11:	8b 00                	mov    (%eax),%eax
  803b13:	85 c0                	test   %eax,%eax
  803b15:	74 10                	je     803b27 <alloc_block+0x1c7>
  803b17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b1a:	8b 00                	mov    (%eax),%eax
  803b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b1f:	8b 52 04             	mov    0x4(%edx),%edx
  803b22:	89 50 04             	mov    %edx,0x4(%eax)
  803b25:	eb 0b                	jmp    803b32 <alloc_block+0x1d2>
  803b27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b2a:	8b 40 04             	mov    0x4(%eax),%eax
  803b2d:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803b32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b35:	8b 40 04             	mov    0x4(%eax),%eax
  803b38:	85 c0                	test   %eax,%eax
  803b3a:	74 0f                	je     803b4b <alloc_block+0x1eb>
  803b3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b3f:	8b 40 04             	mov    0x4(%eax),%eax
  803b42:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b45:	8b 12                	mov    (%edx),%edx
  803b47:	89 10                	mov    %edx,(%eax)
  803b49:	eb 0a                	jmp    803b55 <alloc_block+0x1f5>
  803b4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b4e:	8b 00                	mov    (%eax),%eax
  803b50:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803b55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b68:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803b6d:	48                   	dec    %eax
  803b6e:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803b73:	83 ec 0c             	sub    $0xc,%esp
  803b76:	ff 75 dc             	pushl  -0x24(%ebp)
  803b79:	e8 6f fa ff ff       	call   8035ed <to_page_va>
  803b7e:	83 c4 10             	add    $0x10,%esp
  803b81:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803b84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b87:	83 ec 0c             	sub    $0xc,%esp
  803b8a:	50                   	push   %eax
  803b8b:	e8 a0 dc ff ff       	call   801830 <get_page>
  803b90:	83 c4 10             	add    $0x10,%esp
  803b93:	85 c0                	test   %eax,%eax
  803b95:	74 14                	je     803bab <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803b97:	83 ec 04             	sub    $0x4,%esp
  803b9a:	68 64 4e 80 00       	push   $0x804e64
  803b9f:	6a 7f                	push   $0x7f
  803ba1:	68 83 4d 80 00       	push   $0x804d83
  803ba6:	e8 49 05 00 00       	call   8040f4 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bb1:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803bb5:	b8 00 10 00 00       	mov    $0x1000,%eax
  803bba:	ba 00 00 00 00       	mov    $0x0,%edx
  803bbf:	f7 75 f4             	divl   -0xc(%ebp)
  803bc2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bc5:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803bc9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803bd0:	e9 a7 00 00 00       	jmp    803c7c <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803bd5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803bd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bdb:	01 d0                	add    %edx,%eax
  803bdd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803be0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803be4:	75 17                	jne    803bfd <alloc_block+0x29d>
  803be6:	83 ec 04             	sub    $0x4,%esp
  803be9:	68 8c 4e 80 00       	push   $0x804e8c
  803bee:	68 88 00 00 00       	push   $0x88
  803bf3:	68 83 4d 80 00       	push   $0x804d83
  803bf8:	e8 f7 04 00 00       	call   8040f4 <_panic>
  803bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c00:	c1 e0 04             	shl    $0x4,%eax
  803c03:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803c08:	8b 10                	mov    (%eax),%edx
  803c0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c0d:	89 10                	mov    %edx,(%eax)
  803c0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c12:	8b 00                	mov    (%eax),%eax
  803c14:	85 c0                	test   %eax,%eax
  803c16:	74 15                	je     803c2d <alloc_block+0x2cd>
  803c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c1b:	c1 e0 04             	shl    $0x4,%eax
  803c1e:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803c23:	8b 00                	mov    (%eax),%eax
  803c25:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c28:	89 50 04             	mov    %edx,0x4(%eax)
  803c2b:	eb 11                	jmp    803c3e <alloc_block+0x2de>
  803c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c30:	c1 e0 04             	shl    $0x4,%eax
  803c33:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803c39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c3c:	89 02                	mov    %eax,(%edx)
  803c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c41:	c1 e0 04             	shl    $0x4,%eax
  803c44:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803c4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c4d:	89 02                	mov    %eax,(%edx)
  803c4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c5c:	c1 e0 04             	shl    $0x4,%eax
  803c5f:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803c64:	8b 00                	mov    (%eax),%eax
  803c66:	8d 50 01             	lea    0x1(%eax),%edx
  803c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c6c:	c1 e0 04             	shl    $0x4,%eax
  803c6f:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803c74:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c79:	01 45 e8             	add    %eax,-0x18(%ebp)
  803c7c:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803c83:	0f 86 4c ff ff ff    	jbe    803bd5 <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c8c:	c1 e0 04             	shl    $0x4,%eax
  803c8f:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803c94:	8b 00                	mov    (%eax),%eax
  803c96:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803c99:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c9d:	75 17                	jne    803cb6 <alloc_block+0x356>
  803c9f:	83 ec 04             	sub    $0x4,%esp
  803ca2:	68 1d 4e 80 00       	push   $0x804e1d
  803ca7:	68 8d 00 00 00       	push   $0x8d
  803cac:	68 83 4d 80 00       	push   $0x804d83
  803cb1:	e8 3e 04 00 00       	call   8040f4 <_panic>
  803cb6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cb9:	8b 00                	mov    (%eax),%eax
  803cbb:	85 c0                	test   %eax,%eax
  803cbd:	74 10                	je     803ccf <alloc_block+0x36f>
  803cbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cc2:	8b 00                	mov    (%eax),%eax
  803cc4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803cc7:	8b 52 04             	mov    0x4(%edx),%edx
  803cca:	89 50 04             	mov    %edx,0x4(%eax)
  803ccd:	eb 14                	jmp    803ce3 <alloc_block+0x383>
  803ccf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cd2:	8b 40 04             	mov    0x4(%eax),%eax
  803cd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cd8:	c1 e2 04             	shl    $0x4,%edx
  803cdb:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803ce1:	89 02                	mov    %eax,(%edx)
  803ce3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ce6:	8b 40 04             	mov    0x4(%eax),%eax
  803ce9:	85 c0                	test   %eax,%eax
  803ceb:	74 0f                	je     803cfc <alloc_block+0x39c>
  803ced:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cf0:	8b 40 04             	mov    0x4(%eax),%eax
  803cf3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803cf6:	8b 12                	mov    (%edx),%edx
  803cf8:	89 10                	mov    %edx,(%eax)
  803cfa:	eb 13                	jmp    803d0f <alloc_block+0x3af>
  803cfc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cff:	8b 00                	mov    (%eax),%eax
  803d01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d04:	c1 e2 04             	shl    $0x4,%edx
  803d07:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803d0d:	89 02                	mov    %eax,(%edx)
  803d0f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d18:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d25:	c1 e0 04             	shl    $0x4,%eax
  803d28:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803d2d:	8b 00                	mov    (%eax),%eax
  803d2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d35:	c1 e0 04             	shl    $0x4,%eax
  803d38:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803d3d:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803d3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d42:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803d46:	48                   	dec    %eax
  803d47:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d4a:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803d4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803d51:	c9                   	leave  
  803d52:	c3                   	ret    

00803d53 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803d53:	55                   	push   %ebp
  803d54:	89 e5                	mov    %esp,%ebp
  803d56:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803d59:	8b 55 08             	mov    0x8(%ebp),%edx
  803d5c:	a1 84 60 83 00       	mov    0x836084,%eax
  803d61:	39 c2                	cmp    %eax,%edx
  803d63:	72 0c                	jb     803d71 <free_block+0x1e>
  803d65:	8b 55 08             	mov    0x8(%ebp),%edx
  803d68:	a1 60 e0 81 00       	mov    0x81e060,%eax
  803d6d:	39 c2                	cmp    %eax,%edx
  803d6f:	72 19                	jb     803d8a <free_block+0x37>
  803d71:	68 b0 4e 80 00       	push   $0x804eb0
  803d76:	68 e6 4d 80 00       	push   $0x804de6
  803d7b:	68 98 00 00 00       	push   $0x98
  803d80:	68 83 4d 80 00       	push   $0x804d83
  803d85:	e8 6a 03 00 00       	call   8040f4 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8d:	83 ec 0c             	sub    $0xc,%esp
  803d90:	50                   	push   %eax
  803d91:	e8 c9 f8 ff ff       	call   80365f <to_page_info>
  803d96:	83 c4 10             	add    $0x10,%esp
  803d99:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d9f:	8b 40 08             	mov    0x8(%eax),%eax
  803da2:	0f b7 c0             	movzwl %ax,%eax
  803da5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803da8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803daf:	eb 03                	jmp    803db4 <free_block+0x61>
		listIndex++;
  803db1:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db7:	ba 08 00 00 00       	mov    $0x8,%edx
  803dbc:	88 c1                	mov    %al,%cl
  803dbe:	d3 e2                	shl    %cl,%edx
  803dc0:	89 d0                	mov    %edx,%eax
  803dc2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803dc5:	72 ea                	jb     803db1 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803dca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803dcd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dd1:	75 17                	jne    803dea <free_block+0x97>
  803dd3:	83 ec 04             	sub    $0x4,%esp
  803dd6:	68 8c 4e 80 00       	push   $0x804e8c
  803ddb:	68 a2 00 00 00       	push   $0xa2
  803de0:	68 83 4d 80 00       	push   $0x804d83
  803de5:	e8 0a 03 00 00       	call   8040f4 <_panic>
  803dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ded:	c1 e0 04             	shl    $0x4,%eax
  803df0:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803df5:	8b 10                	mov    (%eax),%edx
  803df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dfa:	89 10                	mov    %edx,(%eax)
  803dfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dff:	8b 00                	mov    (%eax),%eax
  803e01:	85 c0                	test   %eax,%eax
  803e03:	74 15                	je     803e1a <free_block+0xc7>
  803e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e08:	c1 e0 04             	shl    $0x4,%eax
  803e0b:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803e10:	8b 00                	mov    (%eax),%eax
  803e12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e15:	89 50 04             	mov    %edx,0x4(%eax)
  803e18:	eb 11                	jmp    803e2b <free_block+0xd8>
  803e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1d:	c1 e0 04             	shl    $0x4,%eax
  803e20:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e29:	89 02                	mov    %eax,(%edx)
  803e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2e:	c1 e0 04             	shl    $0x4,%eax
  803e31:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e3a:	89 02                	mov    %eax,(%edx)
  803e3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e49:	c1 e0 04             	shl    $0x4,%eax
  803e4c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e51:	8b 00                	mov    (%eax),%eax
  803e53:	8d 50 01             	lea    0x1(%eax),%edx
  803e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e59:	c1 e0 04             	shl    $0x4,%eax
  803e5c:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e61:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e66:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e6a:	40                   	inc    %eax
  803e6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e6e:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e75:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e79:	0f b7 c8             	movzwl %ax,%ecx
  803e7c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803e81:	ba 00 00 00 00       	mov    $0x0,%edx
  803e86:	f7 75 e8             	divl   -0x18(%ebp)
  803e89:	39 c1                	cmp    %eax,%ecx
  803e8b:	0f 85 ed 01 00 00    	jne    80407e <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e94:	c1 e0 04             	shl    $0x4,%eax
  803e97:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803e9c:	8b 00                	mov    (%eax),%eax
  803e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ea1:	eb 2a                	jmp    803ecd <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ea6:	83 ec 0c             	sub    $0xc,%esp
  803ea9:	50                   	push   %eax
  803eaa:	e8 b0 f7 ff ff       	call   80365f <to_page_info>
  803eaf:	83 c4 10             	add    $0x10,%esp
  803eb2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803eb5:	75 06                	jne    803ebd <free_block+0x16a>
				tmp = b;
  803eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eba:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec0:	c1 e0 04             	shl    $0x4,%eax
  803ec3:	05 a8 60 83 00       	add    $0x8360a8,%eax
  803ec8:	8b 00                	mov    (%eax),%eax
  803eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ecd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ed1:	74 07                	je     803eda <free_block+0x187>
  803ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ed6:	8b 00                	mov    (%eax),%eax
  803ed8:	eb 05                	jmp    803edf <free_block+0x18c>
  803eda:	b8 00 00 00 00       	mov    $0x0,%eax
  803edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ee2:	c1 e2 04             	shl    $0x4,%edx
  803ee5:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  803eeb:	89 02                	mov    %eax,(%edx)
  803eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef0:	c1 e0 04             	shl    $0x4,%eax
  803ef3:	05 a8 60 83 00       	add    $0x8360a8,%eax
  803ef8:	8b 00                	mov    (%eax),%eax
  803efa:	85 c0                	test   %eax,%eax
  803efc:	75 a5                	jne    803ea3 <free_block+0x150>
  803efe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f02:	75 9f                	jne    803ea3 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f07:	c1 e0 04             	shl    $0x4,%eax
  803f0a:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f0f:	8b 00                	mov    (%eax),%eax
  803f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803f14:	e9 cc 00 00 00       	jmp    803fe5 <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f1c:	8b 00                	mov    (%eax),%eax
  803f1e:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f24:	83 ec 0c             	sub    $0xc,%esp
  803f27:	50                   	push   %eax
  803f28:	e8 32 f7 ff ff       	call   80365f <to_page_info>
  803f2d:	83 c4 10             	add    $0x10,%esp
  803f30:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803f33:	0f 85 a6 00 00 00    	jne    803fdf <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803f39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f3d:	75 17                	jne    803f56 <free_block+0x203>
  803f3f:	83 ec 04             	sub    $0x4,%esp
  803f42:	68 1d 4e 80 00       	push   $0x804e1d
  803f47:	68 b5 00 00 00       	push   $0xb5
  803f4c:	68 83 4d 80 00       	push   $0x804d83
  803f51:	e8 9e 01 00 00       	call   8040f4 <_panic>
  803f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f59:	8b 00                	mov    (%eax),%eax
  803f5b:	85 c0                	test   %eax,%eax
  803f5d:	74 10                	je     803f6f <free_block+0x21c>
  803f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f62:	8b 00                	mov    (%eax),%eax
  803f64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f67:	8b 52 04             	mov    0x4(%edx),%edx
  803f6a:	89 50 04             	mov    %edx,0x4(%eax)
  803f6d:	eb 14                	jmp    803f83 <free_block+0x230>
  803f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f72:	8b 40 04             	mov    0x4(%eax),%eax
  803f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f78:	c1 e2 04             	shl    $0x4,%edx
  803f7b:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803f81:	89 02                	mov    %eax,(%edx)
  803f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f86:	8b 40 04             	mov    0x4(%eax),%eax
  803f89:	85 c0                	test   %eax,%eax
  803f8b:	74 0f                	je     803f9c <free_block+0x249>
  803f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f90:	8b 40 04             	mov    0x4(%eax),%eax
  803f93:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f96:	8b 12                	mov    (%edx),%edx
  803f98:	89 10                	mov    %edx,(%eax)
  803f9a:	eb 13                	jmp    803faf <free_block+0x25c>
  803f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f9f:	8b 00                	mov    (%eax),%eax
  803fa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fa4:	c1 e2 04             	shl    $0x4,%edx
  803fa7:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803fad:	89 02                	mov    %eax,(%edx)
  803faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc5:	c1 e0 04             	shl    $0x4,%eax
  803fc8:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803fcd:	8b 00                	mov    (%eax),%eax
  803fcf:	8d 50 ff             	lea    -0x1(%eax),%edx
  803fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd5:	c1 e0 04             	shl    $0x4,%eax
  803fd8:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803fdd:	89 10                	mov    %edx,(%eax)
			b = next;
  803fdf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803fe5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803fe9:	0f 85 2a ff ff ff    	jne    803f19 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ff2:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ffb:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804001:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804005:	75 17                	jne    80401e <free_block+0x2cb>
  804007:	83 ec 04             	sub    $0x4,%esp
  80400a:	68 8c 4e 80 00       	push   $0x804e8c
  80400f:	68 bc 00 00 00       	push   $0xbc
  804014:	68 83 4d 80 00       	push   $0x804d83
  804019:	e8 d6 00 00 00       	call   8040f4 <_panic>
  80401e:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  804024:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804027:	89 10                	mov    %edx,(%eax)
  804029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80402c:	8b 00                	mov    (%eax),%eax
  80402e:	85 c0                	test   %eax,%eax
  804030:	74 0d                	je     80403f <free_block+0x2ec>
  804032:	a1 68 e0 81 00       	mov    0x81e068,%eax
  804037:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80403a:	89 50 04             	mov    %edx,0x4(%eax)
  80403d:	eb 08                	jmp    804047 <free_block+0x2f4>
  80403f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804042:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  804047:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80404a:	a3 68 e0 81 00       	mov    %eax,0x81e068
  80404f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804052:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804059:	a1 74 e0 81 00       	mov    0x81e074,%eax
  80405e:	40                   	inc    %eax
  80405f:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  804064:	83 ec 0c             	sub    $0xc,%esp
  804067:	ff 75 ec             	pushl  -0x14(%ebp)
  80406a:	e8 7e f5 ff ff       	call   8035ed <to_page_va>
  80406f:	83 c4 10             	add    $0x10,%esp
  804072:	83 ec 0c             	sub    $0xc,%esp
  804075:	50                   	push   %eax
  804076:	e8 fe d7 ff ff       	call   801879 <return_page>
  80407b:	83 c4 10             	add    $0x10,%esp
	}
}
  80407e:	90                   	nop
  80407f:	c9                   	leave  
  804080:	c3                   	ret    

00804081 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  804081:	55                   	push   %ebp
  804082:	89 e5                	mov    %esp,%ebp
  804084:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  804087:	83 ec 04             	sub    $0x4,%esp
  80408a:	68 e8 4e 80 00       	push   $0x804ee8
  80408f:	6a 07                	push   $0x7
  804091:	68 17 4f 80 00       	push   $0x804f17
  804096:	e8 59 00 00 00       	call   8040f4 <_panic>

0080409b <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80409b:	55                   	push   %ebp
  80409c:	89 e5                	mov    %esp,%ebp
  80409e:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8040a1:	83 ec 04             	sub    $0x4,%esp
  8040a4:	68 28 4f 80 00       	push   $0x804f28
  8040a9:	6a 0b                	push   $0xb
  8040ab:	68 17 4f 80 00       	push   $0x804f17
  8040b0:	e8 3f 00 00 00       	call   8040f4 <_panic>

008040b5 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8040b5:	55                   	push   %ebp
  8040b6:	89 e5                	mov    %esp,%ebp
  8040b8:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8040bb:	83 ec 04             	sub    $0x4,%esp
  8040be:	68 54 4f 80 00       	push   $0x804f54
  8040c3:	6a 10                	push   $0x10
  8040c5:	68 17 4f 80 00       	push   $0x804f17
  8040ca:	e8 25 00 00 00       	call   8040f4 <_panic>

008040cf <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8040cf:	55                   	push   %ebp
  8040d0:	89 e5                	mov    %esp,%ebp
  8040d2:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8040d5:	83 ec 04             	sub    $0x4,%esp
  8040d8:	68 84 4f 80 00       	push   $0x804f84
  8040dd:	6a 15                	push   $0x15
  8040df:	68 17 4f 80 00       	push   $0x804f17
  8040e4:	e8 0b 00 00 00       	call   8040f4 <_panic>

008040e9 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8040e9:	55                   	push   %ebp
  8040ea:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8040ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ef:	8b 40 10             	mov    0x10(%eax),%eax
}
  8040f2:	5d                   	pop    %ebp
  8040f3:	c3                   	ret    

008040f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8040f4:	55                   	push   %ebp
  8040f5:	89 e5                	mov    %esp,%ebp
  8040f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8040fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8040fd:	83 c0 04             	add    $0x4,%eax
  804100:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  804103:	a1 3c 61 83 00       	mov    0x83613c,%eax
  804108:	85 c0                	test   %eax,%eax
  80410a:	74 16                	je     804122 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80410c:	a1 3c 61 83 00       	mov    0x83613c,%eax
  804111:	83 ec 08             	sub    $0x8,%esp
  804114:	50                   	push   %eax
  804115:	68 b4 4f 80 00       	push   $0x804fb4
  80411a:	e8 d8 c7 ff ff       	call   8008f7 <cprintf>
  80411f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  804122:	a1 04 60 80 00       	mov    0x806004,%eax
  804127:	83 ec 0c             	sub    $0xc,%esp
  80412a:	ff 75 0c             	pushl  0xc(%ebp)
  80412d:	ff 75 08             	pushl  0x8(%ebp)
  804130:	50                   	push   %eax
  804131:	68 bc 4f 80 00       	push   $0x804fbc
  804136:	6a 74                	push   $0x74
  804138:	e8 e7 c7 ff ff       	call   800924 <cprintf_colored>
  80413d:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  804140:	8b 45 10             	mov    0x10(%ebp),%eax
  804143:	83 ec 08             	sub    $0x8,%esp
  804146:	ff 75 f4             	pushl  -0xc(%ebp)
  804149:	50                   	push   %eax
  80414a:	e8 39 c7 ff ff       	call   800888 <vcprintf>
  80414f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  804152:	83 ec 08             	sub    $0x8,%esp
  804155:	6a 00                	push   $0x0
  804157:	68 e4 4f 80 00       	push   $0x804fe4
  80415c:	e8 27 c7 ff ff       	call   800888 <vcprintf>
  804161:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  804164:	e8 a0 c6 ff ff       	call   800809 <exit>

	// should not return here
	while (1) ;
  804169:	eb fe                	jmp    804169 <_panic+0x75>

0080416b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80416b:	55                   	push   %ebp
  80416c:	89 e5                	mov    %esp,%ebp
  80416e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  804171:	a1 20 60 80 00       	mov    0x806020,%eax
  804176:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80417c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80417f:	39 c2                	cmp    %eax,%edx
  804181:	74 14                	je     804197 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  804183:	83 ec 04             	sub    $0x4,%esp
  804186:	68 e8 4f 80 00       	push   $0x804fe8
  80418b:	6a 26                	push   $0x26
  80418d:	68 34 50 80 00       	push   $0x805034
  804192:	e8 5d ff ff ff       	call   8040f4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  804197:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80419e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8041a5:	e9 c5 00 00 00       	jmp    80426f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8041aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8041b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8041b7:	01 d0                	add    %edx,%eax
  8041b9:	8b 00                	mov    (%eax),%eax
  8041bb:	85 c0                	test   %eax,%eax
  8041bd:	75 08                	jne    8041c7 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8041bf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8041c2:	e9 a5 00 00 00       	jmp    80426c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8041c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8041ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8041d5:	eb 69                	jmp    804240 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8041d7:	a1 20 60 80 00       	mov    0x806020,%eax
  8041dc:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8041e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8041e5:	89 d0                	mov    %edx,%eax
  8041e7:	01 c0                	add    %eax,%eax
  8041e9:	01 d0                	add    %edx,%eax
  8041eb:	c1 e0 03             	shl    $0x3,%eax
  8041ee:	01 c8                	add    %ecx,%eax
  8041f0:	8a 40 04             	mov    0x4(%eax),%al
  8041f3:	84 c0                	test   %al,%al
  8041f5:	75 46                	jne    80423d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8041f7:	a1 20 60 80 00       	mov    0x806020,%eax
  8041fc:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  804202:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804205:	89 d0                	mov    %edx,%eax
  804207:	01 c0                	add    %eax,%eax
  804209:	01 d0                	add    %edx,%eax
  80420b:	c1 e0 03             	shl    $0x3,%eax
  80420e:	01 c8                	add    %ecx,%eax
  804210:	8b 00                	mov    (%eax),%eax
  804212:	89 45 dc             	mov    %eax,-0x24(%ebp)
  804215:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804218:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80421d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80421f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804222:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  804229:	8b 45 08             	mov    0x8(%ebp),%eax
  80422c:	01 c8                	add    %ecx,%eax
  80422e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  804230:	39 c2                	cmp    %eax,%edx
  804232:	75 09                	jne    80423d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  804234:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80423b:	eb 15                	jmp    804252 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80423d:	ff 45 e8             	incl   -0x18(%ebp)
  804240:	a1 20 60 80 00       	mov    0x806020,%eax
  804245:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80424b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80424e:	39 c2                	cmp    %eax,%edx
  804250:	77 85                	ja     8041d7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  804252:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804256:	75 14                	jne    80426c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  804258:	83 ec 04             	sub    $0x4,%esp
  80425b:	68 40 50 80 00       	push   $0x805040
  804260:	6a 3a                	push   $0x3a
  804262:	68 34 50 80 00       	push   $0x805034
  804267:	e8 88 fe ff ff       	call   8040f4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80426c:	ff 45 f0             	incl   -0x10(%ebp)
  80426f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804272:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804275:	0f 8c 2f ff ff ff    	jl     8041aa <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80427b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804282:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  804289:	eb 26                	jmp    8042b1 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80428b:	a1 20 60 80 00       	mov    0x806020,%eax
  804290:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  804296:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804299:	89 d0                	mov    %edx,%eax
  80429b:	01 c0                	add    %eax,%eax
  80429d:	01 d0                	add    %edx,%eax
  80429f:	c1 e0 03             	shl    $0x3,%eax
  8042a2:	01 c8                	add    %ecx,%eax
  8042a4:	8a 40 04             	mov    0x4(%eax),%al
  8042a7:	3c 01                	cmp    $0x1,%al
  8042a9:	75 03                	jne    8042ae <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8042ab:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8042ae:	ff 45 e0             	incl   -0x20(%ebp)
  8042b1:	a1 20 60 80 00       	mov    0x806020,%eax
  8042b6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8042bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042bf:	39 c2                	cmp    %eax,%edx
  8042c1:	77 c8                	ja     80428b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8042c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8042c9:	74 14                	je     8042df <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8042cb:	83 ec 04             	sub    $0x4,%esp
  8042ce:	68 94 50 80 00       	push   $0x805094
  8042d3:	6a 44                	push   $0x44
  8042d5:	68 34 50 80 00       	push   $0x805034
  8042da:	e8 15 fe ff ff       	call   8040f4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8042df:	90                   	nop
  8042e0:	c9                   	leave  
  8042e1:	c3                   	ret    
  8042e2:	66 90                	xchg   %ax,%ax

008042e4 <__divdi3>:
  8042e4:	55                   	push   %ebp
  8042e5:	57                   	push   %edi
  8042e6:	56                   	push   %esi
  8042e7:	53                   	push   %ebx
  8042e8:	83 ec 1c             	sub    $0x1c,%esp
  8042eb:	8b 44 24 30          	mov    0x30(%esp),%eax
  8042ef:	8b 54 24 34          	mov    0x34(%esp),%edx
  8042f3:	8b 74 24 38          	mov    0x38(%esp),%esi
  8042f7:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  8042fb:	89 f9                	mov    %edi,%ecx
  8042fd:	85 d2                	test   %edx,%edx
  8042ff:	0f 88 bb 00 00 00    	js     8043c0 <__divdi3+0xdc>
  804305:	31 ed                	xor    %ebp,%ebp
  804307:	85 c9                	test   %ecx,%ecx
  804309:	0f 88 99 00 00 00    	js     8043a8 <__divdi3+0xc4>
  80430f:	89 34 24             	mov    %esi,(%esp)
  804312:	89 7c 24 04          	mov    %edi,0x4(%esp)
  804316:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80431a:	89 d3                	mov    %edx,%ebx
  80431c:	8b 34 24             	mov    (%esp),%esi
  80431f:	8b 7c 24 04          	mov    0x4(%esp),%edi
  804323:	89 74 24 08          	mov    %esi,0x8(%esp)
  804327:	8b 34 24             	mov    (%esp),%esi
  80432a:	89 c1                	mov    %eax,%ecx
  80432c:	85 ff                	test   %edi,%edi
  80432e:	75 10                	jne    804340 <__divdi3+0x5c>
  804330:	8b 7c 24 08          	mov    0x8(%esp),%edi
  804334:	39 d7                	cmp    %edx,%edi
  804336:	76 4c                	jbe    804384 <__divdi3+0xa0>
  804338:	f7 f7                	div    %edi
  80433a:	89 c1                	mov    %eax,%ecx
  80433c:	31 f6                	xor    %esi,%esi
  80433e:	eb 08                	jmp    804348 <__divdi3+0x64>
  804340:	39 d7                	cmp    %edx,%edi
  804342:	76 1c                	jbe    804360 <__divdi3+0x7c>
  804344:	31 f6                	xor    %esi,%esi
  804346:	31 c9                	xor    %ecx,%ecx
  804348:	89 c8                	mov    %ecx,%eax
  80434a:	89 f2                	mov    %esi,%edx
  80434c:	85 ed                	test   %ebp,%ebp
  80434e:	74 07                	je     804357 <__divdi3+0x73>
  804350:	f7 d8                	neg    %eax
  804352:	83 d2 00             	adc    $0x0,%edx
  804355:	f7 da                	neg    %edx
  804357:	83 c4 1c             	add    $0x1c,%esp
  80435a:	5b                   	pop    %ebx
  80435b:	5e                   	pop    %esi
  80435c:	5f                   	pop    %edi
  80435d:	5d                   	pop    %ebp
  80435e:	c3                   	ret    
  80435f:	90                   	nop
  804360:	0f bd f7             	bsr    %edi,%esi
  804363:	83 f6 1f             	xor    $0x1f,%esi
  804366:	75 6c                	jne    8043d4 <__divdi3+0xf0>
  804368:	39 d7                	cmp    %edx,%edi
  80436a:	72 0e                	jb     80437a <__divdi3+0x96>
  80436c:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  804370:	39 7c 24 08          	cmp    %edi,0x8(%esp)
  804374:	0f 87 ca 00 00 00    	ja     804444 <__divdi3+0x160>
  80437a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80437f:	eb c7                	jmp    804348 <__divdi3+0x64>
  804381:	8d 76 00             	lea    0x0(%esi),%esi
  804384:	85 f6                	test   %esi,%esi
  804386:	75 0b                	jne    804393 <__divdi3+0xaf>
  804388:	b8 01 00 00 00       	mov    $0x1,%eax
  80438d:	31 d2                	xor    %edx,%edx
  80438f:	f7 f6                	div    %esi
  804391:	89 c6                	mov    %eax,%esi
  804393:	31 d2                	xor    %edx,%edx
  804395:	89 d8                	mov    %ebx,%eax
  804397:	f7 f6                	div    %esi
  804399:	89 c7                	mov    %eax,%edi
  80439b:	89 c8                	mov    %ecx,%eax
  80439d:	f7 f6                	div    %esi
  80439f:	89 c1                	mov    %eax,%ecx
  8043a1:	89 fe                	mov    %edi,%esi
  8043a3:	eb a3                	jmp    804348 <__divdi3+0x64>
  8043a5:	8d 76 00             	lea    0x0(%esi),%esi
  8043a8:	f7 d5                	not    %ebp
  8043aa:	f7 de                	neg    %esi
  8043ac:	83 d7 00             	adc    $0x0,%edi
  8043af:	f7 df                	neg    %edi
  8043b1:	89 34 24             	mov    %esi,(%esp)
  8043b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8043b8:	e9 59 ff ff ff       	jmp    804316 <__divdi3+0x32>
  8043bd:	8d 76 00             	lea    0x0(%esi),%esi
  8043c0:	f7 d8                	neg    %eax
  8043c2:	83 d2 00             	adc    $0x0,%edx
  8043c5:	f7 da                	neg    %edx
  8043c7:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  8043cc:	e9 36 ff ff ff       	jmp    804307 <__divdi3+0x23>
  8043d1:	8d 76 00             	lea    0x0(%esi),%esi
  8043d4:	b8 20 00 00 00       	mov    $0x20,%eax
  8043d9:	29 f0                	sub    %esi,%eax
  8043db:	89 f1                	mov    %esi,%ecx
  8043dd:	d3 e7                	shl    %cl,%edi
  8043df:	8b 54 24 08          	mov    0x8(%esp),%edx
  8043e3:	88 c1                	mov    %al,%cl
  8043e5:	d3 ea                	shr    %cl,%edx
  8043e7:	89 d1                	mov    %edx,%ecx
  8043e9:	09 f9                	or     %edi,%ecx
  8043eb:	89 0c 24             	mov    %ecx,(%esp)
  8043ee:	8b 54 24 08          	mov    0x8(%esp),%edx
  8043f2:	89 f1                	mov    %esi,%ecx
  8043f4:	d3 e2                	shl    %cl,%edx
  8043f6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8043fa:	89 df                	mov    %ebx,%edi
  8043fc:	88 c1                	mov    %al,%cl
  8043fe:	d3 ef                	shr    %cl,%edi
  804400:	89 f1                	mov    %esi,%ecx
  804402:	d3 e3                	shl    %cl,%ebx
  804404:	8b 54 24 0c          	mov    0xc(%esp),%edx
  804408:	88 c1                	mov    %al,%cl
  80440a:	d3 ea                	shr    %cl,%edx
  80440c:	09 d3                	or     %edx,%ebx
  80440e:	89 d8                	mov    %ebx,%eax
  804410:	89 fa                	mov    %edi,%edx
  804412:	f7 34 24             	divl   (%esp)
  804415:	89 d1                	mov    %edx,%ecx
  804417:	89 c3                	mov    %eax,%ebx
  804419:	f7 64 24 08          	mull   0x8(%esp)
  80441d:	39 d1                	cmp    %edx,%ecx
  80441f:	72 17                	jb     804438 <__divdi3+0x154>
  804421:	74 09                	je     80442c <__divdi3+0x148>
  804423:	89 d9                	mov    %ebx,%ecx
  804425:	31 f6                	xor    %esi,%esi
  804427:	e9 1c ff ff ff       	jmp    804348 <__divdi3+0x64>
  80442c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  804430:	89 f1                	mov    %esi,%ecx
  804432:	d3 e2                	shl    %cl,%edx
  804434:	39 c2                	cmp    %eax,%edx
  804436:	73 eb                	jae    804423 <__divdi3+0x13f>
  804438:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  80443b:	31 f6                	xor    %esi,%esi
  80443d:	e9 06 ff ff ff       	jmp    804348 <__divdi3+0x64>
  804442:	66 90                	xchg   %ax,%ax
  804444:	31 c9                	xor    %ecx,%ecx
  804446:	e9 fd fe ff ff       	jmp    804348 <__divdi3+0x64>
  80444b:	90                   	nop

0080444c <__udivdi3>:
  80444c:	55                   	push   %ebp
  80444d:	57                   	push   %edi
  80444e:	56                   	push   %esi
  80444f:	53                   	push   %ebx
  804450:	83 ec 1c             	sub    $0x1c,%esp
  804453:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804457:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80445b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80445f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804463:	89 ca                	mov    %ecx,%edx
  804465:	89 f8                	mov    %edi,%eax
  804467:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80446b:	85 f6                	test   %esi,%esi
  80446d:	75 2d                	jne    80449c <__udivdi3+0x50>
  80446f:	39 cf                	cmp    %ecx,%edi
  804471:	77 65                	ja     8044d8 <__udivdi3+0x8c>
  804473:	89 fd                	mov    %edi,%ebp
  804475:	85 ff                	test   %edi,%edi
  804477:	75 0b                	jne    804484 <__udivdi3+0x38>
  804479:	b8 01 00 00 00       	mov    $0x1,%eax
  80447e:	31 d2                	xor    %edx,%edx
  804480:	f7 f7                	div    %edi
  804482:	89 c5                	mov    %eax,%ebp
  804484:	31 d2                	xor    %edx,%edx
  804486:	89 c8                	mov    %ecx,%eax
  804488:	f7 f5                	div    %ebp
  80448a:	89 c1                	mov    %eax,%ecx
  80448c:	89 d8                	mov    %ebx,%eax
  80448e:	f7 f5                	div    %ebp
  804490:	89 cf                	mov    %ecx,%edi
  804492:	89 fa                	mov    %edi,%edx
  804494:	83 c4 1c             	add    $0x1c,%esp
  804497:	5b                   	pop    %ebx
  804498:	5e                   	pop    %esi
  804499:	5f                   	pop    %edi
  80449a:	5d                   	pop    %ebp
  80449b:	c3                   	ret    
  80449c:	39 ce                	cmp    %ecx,%esi
  80449e:	77 28                	ja     8044c8 <__udivdi3+0x7c>
  8044a0:	0f bd fe             	bsr    %esi,%edi
  8044a3:	83 f7 1f             	xor    $0x1f,%edi
  8044a6:	75 40                	jne    8044e8 <__udivdi3+0x9c>
  8044a8:	39 ce                	cmp    %ecx,%esi
  8044aa:	72 0a                	jb     8044b6 <__udivdi3+0x6a>
  8044ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8044b0:	0f 87 9e 00 00 00    	ja     804554 <__udivdi3+0x108>
  8044b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8044bb:	89 fa                	mov    %edi,%edx
  8044bd:	83 c4 1c             	add    $0x1c,%esp
  8044c0:	5b                   	pop    %ebx
  8044c1:	5e                   	pop    %esi
  8044c2:	5f                   	pop    %edi
  8044c3:	5d                   	pop    %ebp
  8044c4:	c3                   	ret    
  8044c5:	8d 76 00             	lea    0x0(%esi),%esi
  8044c8:	31 ff                	xor    %edi,%edi
  8044ca:	31 c0                	xor    %eax,%eax
  8044cc:	89 fa                	mov    %edi,%edx
  8044ce:	83 c4 1c             	add    $0x1c,%esp
  8044d1:	5b                   	pop    %ebx
  8044d2:	5e                   	pop    %esi
  8044d3:	5f                   	pop    %edi
  8044d4:	5d                   	pop    %ebp
  8044d5:	c3                   	ret    
  8044d6:	66 90                	xchg   %ax,%ax
  8044d8:	89 d8                	mov    %ebx,%eax
  8044da:	f7 f7                	div    %edi
  8044dc:	31 ff                	xor    %edi,%edi
  8044de:	89 fa                	mov    %edi,%edx
  8044e0:	83 c4 1c             	add    $0x1c,%esp
  8044e3:	5b                   	pop    %ebx
  8044e4:	5e                   	pop    %esi
  8044e5:	5f                   	pop    %edi
  8044e6:	5d                   	pop    %ebp
  8044e7:	c3                   	ret    
  8044e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8044ed:	89 eb                	mov    %ebp,%ebx
  8044ef:	29 fb                	sub    %edi,%ebx
  8044f1:	89 f9                	mov    %edi,%ecx
  8044f3:	d3 e6                	shl    %cl,%esi
  8044f5:	89 c5                	mov    %eax,%ebp
  8044f7:	88 d9                	mov    %bl,%cl
  8044f9:	d3 ed                	shr    %cl,%ebp
  8044fb:	89 e9                	mov    %ebp,%ecx
  8044fd:	09 f1                	or     %esi,%ecx
  8044ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804503:	89 f9                	mov    %edi,%ecx
  804505:	d3 e0                	shl    %cl,%eax
  804507:	89 c5                	mov    %eax,%ebp
  804509:	89 d6                	mov    %edx,%esi
  80450b:	88 d9                	mov    %bl,%cl
  80450d:	d3 ee                	shr    %cl,%esi
  80450f:	89 f9                	mov    %edi,%ecx
  804511:	d3 e2                	shl    %cl,%edx
  804513:	8b 44 24 08          	mov    0x8(%esp),%eax
  804517:	88 d9                	mov    %bl,%cl
  804519:	d3 e8                	shr    %cl,%eax
  80451b:	09 c2                	or     %eax,%edx
  80451d:	89 d0                	mov    %edx,%eax
  80451f:	89 f2                	mov    %esi,%edx
  804521:	f7 74 24 0c          	divl   0xc(%esp)
  804525:	89 d6                	mov    %edx,%esi
  804527:	89 c3                	mov    %eax,%ebx
  804529:	f7 e5                	mul    %ebp
  80452b:	39 d6                	cmp    %edx,%esi
  80452d:	72 19                	jb     804548 <__udivdi3+0xfc>
  80452f:	74 0b                	je     80453c <__udivdi3+0xf0>
  804531:	89 d8                	mov    %ebx,%eax
  804533:	31 ff                	xor    %edi,%edi
  804535:	e9 58 ff ff ff       	jmp    804492 <__udivdi3+0x46>
  80453a:	66 90                	xchg   %ax,%ax
  80453c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804540:	89 f9                	mov    %edi,%ecx
  804542:	d3 e2                	shl    %cl,%edx
  804544:	39 c2                	cmp    %eax,%edx
  804546:	73 e9                	jae    804531 <__udivdi3+0xe5>
  804548:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80454b:	31 ff                	xor    %edi,%edi
  80454d:	e9 40 ff ff ff       	jmp    804492 <__udivdi3+0x46>
  804552:	66 90                	xchg   %ax,%ax
  804554:	31 c0                	xor    %eax,%eax
  804556:	e9 37 ff ff ff       	jmp    804492 <__udivdi3+0x46>
  80455b:	90                   	nop

0080455c <__umoddi3>:
  80455c:	55                   	push   %ebp
  80455d:	57                   	push   %edi
  80455e:	56                   	push   %esi
  80455f:	53                   	push   %ebx
  804560:	83 ec 1c             	sub    $0x1c,%esp
  804563:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804567:	8b 74 24 34          	mov    0x34(%esp),%esi
  80456b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80456f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804573:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804577:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80457b:	89 f3                	mov    %esi,%ebx
  80457d:	89 fa                	mov    %edi,%edx
  80457f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804583:	89 34 24             	mov    %esi,(%esp)
  804586:	85 c0                	test   %eax,%eax
  804588:	75 1a                	jne    8045a4 <__umoddi3+0x48>
  80458a:	39 f7                	cmp    %esi,%edi
  80458c:	0f 86 a2 00 00 00    	jbe    804634 <__umoddi3+0xd8>
  804592:	89 c8                	mov    %ecx,%eax
  804594:	89 f2                	mov    %esi,%edx
  804596:	f7 f7                	div    %edi
  804598:	89 d0                	mov    %edx,%eax
  80459a:	31 d2                	xor    %edx,%edx
  80459c:	83 c4 1c             	add    $0x1c,%esp
  80459f:	5b                   	pop    %ebx
  8045a0:	5e                   	pop    %esi
  8045a1:	5f                   	pop    %edi
  8045a2:	5d                   	pop    %ebp
  8045a3:	c3                   	ret    
  8045a4:	39 f0                	cmp    %esi,%eax
  8045a6:	0f 87 ac 00 00 00    	ja     804658 <__umoddi3+0xfc>
  8045ac:	0f bd e8             	bsr    %eax,%ebp
  8045af:	83 f5 1f             	xor    $0x1f,%ebp
  8045b2:	0f 84 ac 00 00 00    	je     804664 <__umoddi3+0x108>
  8045b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8045bd:	29 ef                	sub    %ebp,%edi
  8045bf:	89 fe                	mov    %edi,%esi
  8045c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8045c5:	89 e9                	mov    %ebp,%ecx
  8045c7:	d3 e0                	shl    %cl,%eax
  8045c9:	89 d7                	mov    %edx,%edi
  8045cb:	89 f1                	mov    %esi,%ecx
  8045cd:	d3 ef                	shr    %cl,%edi
  8045cf:	09 c7                	or     %eax,%edi
  8045d1:	89 e9                	mov    %ebp,%ecx
  8045d3:	d3 e2                	shl    %cl,%edx
  8045d5:	89 14 24             	mov    %edx,(%esp)
  8045d8:	89 d8                	mov    %ebx,%eax
  8045da:	d3 e0                	shl    %cl,%eax
  8045dc:	89 c2                	mov    %eax,%edx
  8045de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045e2:	d3 e0                	shl    %cl,%eax
  8045e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8045e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045ec:	89 f1                	mov    %esi,%ecx
  8045ee:	d3 e8                	shr    %cl,%eax
  8045f0:	09 d0                	or     %edx,%eax
  8045f2:	d3 eb                	shr    %cl,%ebx
  8045f4:	89 da                	mov    %ebx,%edx
  8045f6:	f7 f7                	div    %edi
  8045f8:	89 d3                	mov    %edx,%ebx
  8045fa:	f7 24 24             	mull   (%esp)
  8045fd:	89 c6                	mov    %eax,%esi
  8045ff:	89 d1                	mov    %edx,%ecx
  804601:	39 d3                	cmp    %edx,%ebx
  804603:	0f 82 87 00 00 00    	jb     804690 <__umoddi3+0x134>
  804609:	0f 84 91 00 00 00    	je     8046a0 <__umoddi3+0x144>
  80460f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804613:	29 f2                	sub    %esi,%edx
  804615:	19 cb                	sbb    %ecx,%ebx
  804617:	89 d8                	mov    %ebx,%eax
  804619:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80461d:	d3 e0                	shl    %cl,%eax
  80461f:	89 e9                	mov    %ebp,%ecx
  804621:	d3 ea                	shr    %cl,%edx
  804623:	09 d0                	or     %edx,%eax
  804625:	89 e9                	mov    %ebp,%ecx
  804627:	d3 eb                	shr    %cl,%ebx
  804629:	89 da                	mov    %ebx,%edx
  80462b:	83 c4 1c             	add    $0x1c,%esp
  80462e:	5b                   	pop    %ebx
  80462f:	5e                   	pop    %esi
  804630:	5f                   	pop    %edi
  804631:	5d                   	pop    %ebp
  804632:	c3                   	ret    
  804633:	90                   	nop
  804634:	89 fd                	mov    %edi,%ebp
  804636:	85 ff                	test   %edi,%edi
  804638:	75 0b                	jne    804645 <__umoddi3+0xe9>
  80463a:	b8 01 00 00 00       	mov    $0x1,%eax
  80463f:	31 d2                	xor    %edx,%edx
  804641:	f7 f7                	div    %edi
  804643:	89 c5                	mov    %eax,%ebp
  804645:	89 f0                	mov    %esi,%eax
  804647:	31 d2                	xor    %edx,%edx
  804649:	f7 f5                	div    %ebp
  80464b:	89 c8                	mov    %ecx,%eax
  80464d:	f7 f5                	div    %ebp
  80464f:	89 d0                	mov    %edx,%eax
  804651:	e9 44 ff ff ff       	jmp    80459a <__umoddi3+0x3e>
  804656:	66 90                	xchg   %ax,%ax
  804658:	89 c8                	mov    %ecx,%eax
  80465a:	89 f2                	mov    %esi,%edx
  80465c:	83 c4 1c             	add    $0x1c,%esp
  80465f:	5b                   	pop    %ebx
  804660:	5e                   	pop    %esi
  804661:	5f                   	pop    %edi
  804662:	5d                   	pop    %ebp
  804663:	c3                   	ret    
  804664:	3b 04 24             	cmp    (%esp),%eax
  804667:	72 06                	jb     80466f <__umoddi3+0x113>
  804669:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80466d:	77 0f                	ja     80467e <__umoddi3+0x122>
  80466f:	89 f2                	mov    %esi,%edx
  804671:	29 f9                	sub    %edi,%ecx
  804673:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804677:	89 14 24             	mov    %edx,(%esp)
  80467a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80467e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804682:	8b 14 24             	mov    (%esp),%edx
  804685:	83 c4 1c             	add    $0x1c,%esp
  804688:	5b                   	pop    %ebx
  804689:	5e                   	pop    %esi
  80468a:	5f                   	pop    %edi
  80468b:	5d                   	pop    %ebp
  80468c:	c3                   	ret    
  80468d:	8d 76 00             	lea    0x0(%esi),%esi
  804690:	2b 04 24             	sub    (%esp),%eax
  804693:	19 fa                	sbb    %edi,%edx
  804695:	89 d1                	mov    %edx,%ecx
  804697:	89 c6                	mov    %eax,%esi
  804699:	e9 71 ff ff ff       	jmp    80460f <__umoddi3+0xb3>
  80469e:	66 90                	xchg   %ax,%ax
  8046a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8046a4:	72 ea                	jb     804690 <__umoddi3+0x134>
  8046a6:	89 d9                	mov    %ebx,%ecx
  8046a8:	e9 62 ff ff ff       	jmp    80460f <__umoddi3+0xb3>
