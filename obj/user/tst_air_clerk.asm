
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 5b 07 00 00       	call   800791 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>

extern volatile bool printStats;
void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec dc 01 00 00    	sub    $0x1dc,%esp
	//disable the print of prog stats after finishing
	printStats = 0;
  800044:	c7 05 00 60 80 00 00 	movl   $0x0,0x806000
  80004b:	00 00 00 

	int parentenvID = sys_getparentenvid();
  80004e:	e8 08 36 00 00       	call   80365b <sys_getparentenvid>
  800053:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _isOpened[] = "isOpened";
  800056:	8d 45 ab             	lea    -0x55(%ebp),%eax
  800059:	bb bf 47 80 00       	mov    $0x8047bf,%ebx
  80005e:	ba 09 00 00 00       	mov    $0x9,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  80006b:	8d 45 a1             	lea    -0x5f(%ebp),%eax
  80006e:	bb c8 47 80 00       	mov    $0x8047c8,%ebx
  800073:	ba 0a 00 00 00       	mov    $0xa,%edx
  800078:	89 c7                	mov    %eax,%edi
  80007a:	89 de                	mov    %ebx,%esi
  80007c:	89 d1                	mov    %edx,%ecx
  80007e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800080:	8d 45 95             	lea    -0x6b(%ebp),%eax
  800083:	bb d2 47 80 00       	mov    $0x8047d2,%ebx
  800088:	ba 03 00 00 00       	mov    $0x3,%edx
  80008d:	89 c7                	mov    %eax,%edi
  80008f:	89 de                	mov    %ebx,%esi
  800091:	89 d1                	mov    %edx,%ecx
  800093:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800095:	8d 45 86             	lea    -0x7a(%ebp),%eax
  800098:	bb de 47 80 00       	mov    $0x8047de,%ebx
  80009d:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000a2:	89 c7                	mov    %eax,%edi
  8000a4:	89 de                	mov    %ebx,%esi
  8000a6:	89 d1                	mov    %edx,%ecx
  8000a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000aa:	8d 85 77 ff ff ff    	lea    -0x89(%ebp),%eax
  8000b0:	bb ed 47 80 00       	mov    $0x8047ed,%ebx
  8000b5:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ba:	89 c7                	mov    %eax,%edi
  8000bc:	89 de                	mov    %ebx,%esi
  8000be:	89 d1                	mov    %edx,%ecx
  8000c0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000c2:	8d 85 62 ff ff ff    	lea    -0x9e(%ebp),%eax
  8000c8:	bb fc 47 80 00       	mov    $0x8047fc,%ebx
  8000cd:	ba 15 00 00 00       	mov    $0x15,%edx
  8000d2:	89 c7                	mov    %eax,%edi
  8000d4:	89 de                	mov    %ebx,%esi
  8000d6:	89 d1                	mov    %edx,%ecx
  8000d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000da:	8d 85 4d ff ff ff    	lea    -0xb3(%ebp),%eax
  8000e0:	bb 11 48 80 00       	mov    $0x804811,%ebx
  8000e5:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ea:	89 c7                	mov    %eax,%edi
  8000ec:	89 de                	mov    %ebx,%esi
  8000ee:	89 d1                	mov    %edx,%ecx
  8000f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000f2:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000f8:	bb 26 48 80 00       	mov    $0x804826,%ebx
  8000fd:	ba 11 00 00 00       	mov    $0x11,%edx
  800102:	89 c7                	mov    %eax,%edi
  800104:	89 de                	mov    %ebx,%esi
  800106:	89 d1                	mov    %edx,%ecx
  800108:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80010a:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  800110:	bb 37 48 80 00       	mov    $0x804837,%ebx
  800115:	ba 11 00 00 00       	mov    $0x11,%edx
  80011a:	89 c7                	mov    %eax,%edi
  80011c:	89 de                	mov    %ebx,%esi
  80011e:	89 d1                	mov    %edx,%ecx
  800120:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800122:	8d 85 1a ff ff ff    	lea    -0xe6(%ebp),%eax
  800128:	bb 48 48 80 00       	mov    $0x804848,%ebx
  80012d:	ba 11 00 00 00       	mov    $0x11,%edx
  800132:	89 c7                	mov    %eax,%edi
  800134:	89 de                	mov    %ebx,%esi
  800136:	89 d1                	mov    %edx,%ecx
  800138:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80013a:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800140:	bb 59 48 80 00       	mov    $0x804859,%ebx
  800145:	ba 09 00 00 00       	mov    $0x9,%edx
  80014a:	89 c7                	mov    %eax,%edi
  80014c:	89 de                	mov    %ebx,%esi
  80014e:	89 d1                	mov    %edx,%ecx
  800150:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800152:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  800158:	bb 62 48 80 00       	mov    $0x804862,%ebx
  80015d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800162:	89 c7                	mov    %eax,%edi
  800164:	89 de                	mov    %ebx,%esi
  800166:	89 d1                	mov    %edx,%ecx
  800168:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80016a:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  800170:	bb 6c 48 80 00       	mov    $0x80486c,%ebx
  800175:	ba 0b 00 00 00       	mov    $0xb,%edx
  80017a:	89 c7                	mov    %eax,%edi
  80017c:	89 de                	mov    %ebx,%esi
  80017e:	89 d1                	mov    %edx,%ecx
  800180:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800182:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800188:	bb 77 48 80 00       	mov    $0x804877,%ebx
  80018d:	ba 03 00 00 00       	mov    $0x3,%edx
  800192:	89 c7                	mov    %eax,%edi
  800194:	89 de                	mov    %ebx,%esi
  800196:	89 d1                	mov    %edx,%ecx
  800198:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  80019a:	8d 85 e6 fe ff ff    	lea    -0x11a(%ebp),%eax
  8001a0:	bb 83 48 80 00       	mov    $0x804883,%ebx
  8001a5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001aa:	89 c7                	mov    %eax,%edi
  8001ac:	89 de                	mov    %ebx,%esi
  8001ae:	89 d1                	mov    %edx,%ecx
  8001b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001b2:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  8001b8:	bb 8d 48 80 00       	mov    $0x80488d,%ebx
  8001bd:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001c2:	89 c7                	mov    %eax,%edi
  8001c4:	89 de                	mov    %ebx,%esi
  8001c6:	89 d1                	mov    %edx,%ecx
  8001c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001ca:	c7 85 d6 fe ff ff 63 	movl   $0x72656c63,-0x12a(%ebp)
  8001d1:	6c 65 72 
  8001d4:	66 c7 85 da fe ff ff 	movw   $0x6b,-0x126(%ebp)
  8001db:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001dd:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
  8001e3:	bb 97 48 80 00       	mov    $0x804897,%ebx
  8001e8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ed:	89 c7                	mov    %eax,%edi
  8001ef:	89 de                	mov    %ebx,%esi
  8001f1:	89 d1                	mov    %edx,%ecx
  8001f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001f5:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8001fb:	bb a5 48 80 00       	mov    $0x8048a5,%ebx
  800200:	ba 0f 00 00 00       	mov    $0xf,%edx
  800205:	89 c7                	mov    %eax,%edi
  800207:	89 de                	mov    %ebx,%esi
  800209:	89 d1                	mov    %edx,%ecx
  80020b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _clerkTerminated[] = "clerkTerminated";
  80020d:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800213:	bb b4 48 80 00       	mov    $0x8048b4,%ebx
  800218:	ba 04 00 00 00       	mov    $0x4,%edx
  80021d:	89 c7                	mov    %eax,%edi
  80021f:	89 de                	mov    %ebx,%esi
  800221:	89 d1                	mov    %edx,%ecx
  800223:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800225:	8d 85 a2 fe ff ff    	lea    -0x15e(%ebp),%eax
  80022b:	bb c4 48 80 00       	mov    $0x8048c4,%ebx
  800230:	ba 07 00 00 00       	mov    $0x7,%edx
  800235:	89 c7                	mov    %eax,%edi
  800237:	89 de                	mov    %ebx,%esi
  800239:	89 d1                	mov    %edx,%ecx
  80023b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  80023d:	8d 85 9b fe ff ff    	lea    -0x165(%ebp),%eax
  800243:	bb cb 48 80 00       	mov    $0x8048cb,%ebx
  800248:	ba 07 00 00 00       	mov    $0x7,%edx
  80024d:	89 c7                	mov    %eax,%edi
  80024f:	89 de                	mov    %ebx,%esi
  800251:	89 d1                	mov    %edx,%ecx
  800253:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	8d 45 a1             	lea    -0x5f(%ebp),%eax
  80025b:	50                   	push   %eax
  80025c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025f:	e8 34 24 00 00       	call   802698 <sget>
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* isOpened = sget(parentenvID, _isOpened);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	8d 45 ab             	lea    -0x55(%ebp),%eax
  800270:	50                   	push   %eax
  800271:	ff 75 e4             	pushl  -0x1c(%ebp)
  800274:	e8 1f 24 00 00       	call   802698 <sget>
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	8d 45 86             	lea    -0x7a(%ebp),%eax
  800285:	50                   	push   %eax
  800286:	ff 75 e4             	pushl  -0x1c(%ebp)
  800289:	e8 0a 24 00 00       	call   802698 <sget>
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	8d 85 77 ff ff ff    	lea    -0x89(%ebp),%eax
  80029d:	50                   	push   %eax
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	e8 f2 23 00 00       	call   802698 <sget>
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	8d 85 62 ff ff ff    	lea    -0x9e(%ebp),%eax
  8002b5:	50                   	push   %eax
  8002b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b9:	e8 da 23 00 00       	call   802698 <sget>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	8d 85 4d ff ff ff    	lea    -0xb3(%ebp),%eax
  8002cd:	50                   	push   %eax
  8002ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d1:	e8 c2 23 00 00       	call   802698 <sget>
  8002d6:	83 c4 10             	add    $0x10,%esp
  8002d9:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8002e5:	50                   	push   %eax
  8002e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e9:	e8 aa 23 00 00       	call   802698 <sget>
  8002ee:	83 c4 10             	add    $0x10,%esp
  8002f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002f4:	83 ec 08             	sub    $0x8,%esp
  8002f7:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8002fd:	50                   	push   %eax
  8002fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800301:	e8 92 23 00 00       	call   802698 <sget>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	8d 85 1a ff ff ff    	lea    -0xe6(%ebp),%eax
  800315:	50                   	push   %eax
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	e8 7a 23 00 00       	call   802698 <sget>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 c0             	mov    %eax,-0x40(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80032d:	50                   	push   %eax
  80032e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800331:	e8 62 23 00 00       	call   802698 <sget>
  800336:	83 c4 10             	add    $0x10,%esp
  800339:	89 45 bc             	mov    %eax,-0x44(%ebp)
	//cprintf("address of queue_out = %d\n", queue_out);
	// *********************************************************************************

	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  80033c:	8d 85 94 fe ff ff    	lea    -0x16c(%ebp),%eax
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	8d 95 fc fe ff ff    	lea    -0x104(%ebp),%edx
  80034b:	52                   	push   %edx
  80034c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034f:	50                   	push   %eax
  800350:	e8 5e 40 00 00       	call   8043b3 <get_semaphore>
  800355:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800358:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  80035e:	83 ec 04             	sub    $0x4,%esp
  800361:	8d 95 f0 fe ff ff    	lea    -0x110(%ebp),%edx
  800367:	52                   	push   %edx
  800368:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036b:	50                   	push   %eax
  80036c:	e8 42 40 00 00       	call   8043b3 <get_semaphore>
  800371:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800374:	8d 85 8c fe ff ff    	lea    -0x174(%ebp),%eax
  80037a:	83 ec 04             	sub    $0x4,%esp
  80037d:	8d 95 e6 fe ff ff    	lea    -0x11a(%ebp),%edx
  800383:	52                   	push   %edx
  800384:	ff 75 e4             	pushl  -0x1c(%ebp)
  800387:	50                   	push   %eax
  800388:	e8 26 40 00 00       	call   8043b3 <get_semaphore>
  80038d:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  800390:	8d 85 88 fe ff ff    	lea    -0x178(%ebp),%eax
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  80039f:	52                   	push   %edx
  8003a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	e8 0a 40 00 00       	call   8043b3 <get_semaphore>
  8003a9:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  8003ac:	8d 85 84 fe ff ff    	lea    -0x17c(%ebp),%eax
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	8d 95 d6 fe ff ff    	lea    -0x12a(%ebp),%edx
  8003bb:	52                   	push   %edx
  8003bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003bf:	50                   	push   %eax
  8003c0:	e8 ee 3f 00 00       	call   8043b3 <get_semaphore>
  8003c5:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerkTerminated = get_semaphore(parentenvID, _clerkTerminated);
  8003c8:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	8d 95 a9 fe ff ff    	lea    -0x157(%ebp),%edx
  8003d7:	52                   	push   %edx
  8003d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	e8 d2 3f 00 00       	call   8043b3 <get_semaphore>
  8003e1:	83 c4 0c             	add    $0xc,%esp

	while(*isOpened)
  8003e4:	e9 71 03 00 00       	jmp    80075a <_main+0x722>
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	ff b5 94 fe ff ff    	pushl  -0x16c(%ebp)
  8003f2:	e8 d6 3f 00 00       	call   8043cd <wait_semaphore>
  8003f7:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800403:	e8 c5 3f 00 00       	call   8043cd <wait_semaphore>
  800408:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  80040b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800417:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80041a:	01 d0                	add    %edx,%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	89 45 b8             	mov    %eax,-0x48(%ebp)
			//there's no more customers for now...
			if (custId == -1)
  800421:	83 7d b8 ff          	cmpl   $0xffffffff,-0x48(%ebp)
  800425:	75 16                	jne    80043d <_main+0x405>
			{
				signal_semaphore(custQueueCS);
  800427:	83 ec 0c             	sub    $0xc,%esp
  80042a:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800430:	e8 b2 3f 00 00       	call   8043e7 <signal_semaphore>
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	e9 1d 03 00 00       	jmp    80075a <_main+0x722>
				continue;
			}
			*queue_out = *queue_out +1;
  80043d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 50 01             	lea    0x1(%eax),%edx
  800445:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800448:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(custQueueCS);
  80044a:	83 ec 0c             	sub    $0xc,%esp
  80044d:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800453:	e8 8f 3f 00 00       	call   8043e7 <signal_semaphore>
  800458:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80045b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80045e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800468:	01 d0                	add    %edx,%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  80046f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800472:	83 f8 02             	cmp    $0x2,%eax
  800475:	0f 84 9d 00 00 00    	je     800518 <_main+0x4e0>
  80047b:	83 f8 03             	cmp    $0x3,%eax
  80047e:	0f 84 1f 01 00 00    	je     8005a3 <_main+0x56b>
  800484:	83 f8 01             	cmp    $0x1,%eax
  800487:	0f 85 17 02 00 00    	jne    8006a4 <_main+0x66c>
		{
		case 1:
		{
			//Check and update Flight1
			wait_semaphore(flight1CS);
  80048d:	83 ec 0c             	sub    $0xc,%esp
  800490:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  800496:	e8 32 3f 00 00       	call   8043cd <wait_semaphore>
  80049b:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  80049e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	7e 48                	jle    8004ef <_main+0x4b7>
				{
					*flight1Counter = *flight1Counter - 1;
  8004a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b2:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004d9:	01 c2                	add    %eax,%edx
  8004db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004de:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	8d 50 01             	lea    0x1(%eax),%edx
  8004e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004eb:	89 10                	mov    %edx,(%eax)
  8004ed:	eb 13                	jmp    800502 <_main+0x4ca>
				}
				else
				{
					cprintf("%~\nFlight#1 is FULL! Reservation request of customer#%d is rejected\n", custId);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	ff 75 b8             	pushl  -0x48(%ebp)
  8004f5:	68 80 46 80 00       	push   $0x804680
  8004fa:	e8 10 07 00 00       	call   800c0f <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight1CS);
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  80050b:	e8 d7 3e 00 00       	call   8043e7 <signal_semaphore>
  800510:	83 c4 10             	add    $0x10,%esp
		}

		break;
  800513:	e9 a3 01 00 00       	jmp    8006bb <_main+0x683>
		case 2:
		{
			//Check and update Flight2
			wait_semaphore(flight2CS);
  800518:	83 ec 0c             	sub    $0xc,%esp
  80051b:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  800521:	e8 a7 3e 00 00       	call   8043cd <wait_semaphore>
  800526:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	85 c0                	test   %eax,%eax
  800530:	7e 48                	jle    80057a <_main+0x542>
				{
					*flight2Counter = *flight2Counter - 1;
  800532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800535:	8b 00                	mov    (%eax),%eax
  800537:	8d 50 ff             	lea    -0x1(%eax),%edx
  80053a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80053d:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  80053f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800542:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800549:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054c:	01 d0                	add    %edx,%eax
  80054e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800561:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800564:	01 c2                	add    %eax,%edx
  800566:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800569:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80056b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	8d 50 01             	lea    0x1(%eax),%edx
  800573:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800576:	89 10                	mov    %edx,(%eax)
  800578:	eb 13                	jmp    80058d <_main+0x555>
				}
				else
				{
					cprintf("%~\nFlight#2 is FULL! Reservation request of customer#%d is rejected\n", custId);
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 b8             	pushl  -0x48(%ebp)
  800580:	68 c8 46 80 00       	push   $0x8046c8
  800585:	e8 85 06 00 00       	call   800c0f <cprintf>
  80058a:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight2CS);
  80058d:	83 ec 0c             	sub    $0xc,%esp
  800590:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  800596:	e8 4c 3e 00 00       	call   8043e7 <signal_semaphore>
  80059b:	83 c4 10             	add    $0x10,%esp
		}
		break;
  80059e:	e9 18 01 00 00       	jmp    8006bb <_main+0x683>
		case 3:
		{
			//Check and update Both Flights
			wait_semaphore(flight1CS); wait_semaphore(flight2CS);
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  8005ac:	e8 1c 3e 00 00       	call   8043cd <wait_semaphore>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  8005bd:	e8 0b 3e 00 00       	call   8043cd <wait_semaphore>
  8005c2:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8005c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	85 c0                	test   %eax,%eax
  8005cc:	0f 8e 9b 00 00 00    	jle    80066d <_main+0x635>
  8005d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	85 c0                	test   %eax,%eax
  8005d9:	0f 8e 8e 00 00 00    	jle    80066d <_main+0x635>
				{
					*flight1Counter = *flight1Counter - 1;
  8005df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8005e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005ea:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8005ec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8005ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f9:	01 d0                	add    %edx,%eax
  8005fb:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  800602:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800611:	01 c2                	add    %eax,%edx
  800613:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800616:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  800618:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	8d 50 01             	lea    0x1(%eax),%edx
  800620:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800623:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800625:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80062d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800630:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800632:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800635:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80063c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063f:	01 d0                	add    %edx,%eax
  800641:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800648:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800654:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800657:	01 c2                	add    %eax,%edx
  800659:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80065c:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80065e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	8d 50 01             	lea    0x1(%eax),%edx
  800666:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800669:	89 10                	mov    %edx,(%eax)
  80066b:	eb 13                	jmp    800680 <_main+0x648>

				}
				else
				{
					cprintf("%~\nFlight#1 and/or Flight#2 is FULL! Reservation request of customer#%d is rejected\n", custId);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	ff 75 b8             	pushl  -0x48(%ebp)
  800673:	68 10 47 80 00       	push   $0x804710
  800678:	e8 92 05 00 00       	call   800c0f <cprintf>
  80067d:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight1CS); signal_semaphore(flight2CS);
  800680:	83 ec 0c             	sub    $0xc,%esp
  800683:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  800689:	e8 59 3d 00 00       	call   8043e7 <signal_semaphore>
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	83 ec 0c             	sub    $0xc,%esp
  800694:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  80069a:	e8 48 3d 00 00       	call   8043e7 <signal_semaphore>
  80069f:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8006a2:	eb 17                	jmp    8006bb <_main+0x683>
		default:
			panic("customer must have flight type\n");
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	68 68 47 80 00       	push   $0x804768
  8006ac:	68 a4 00 00 00       	push   $0xa4
  8006b1:	68 88 47 80 00       	push   $0x804788
  8006b6:	e8 86 02 00 00       	call   800941 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8006bb:	8d 85 62 fe ff ff    	lea    -0x19e(%ebp),%eax
  8006c1:	bb d2 48 80 00       	mov    $0x8048d2,%ebx
  8006c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006cb:	89 c7                	mov    %eax,%edi
  8006cd:	89 de                	mov    %ebx,%esi
  8006cf:	89 d1                	mov    %edx,%ecx
  8006d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006d3:	8d 95 70 fe ff ff    	lea    -0x190(%ebp),%edx
  8006d9:	b9 04 00 00 00       	mov    $0x4,%ecx
  8006de:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e3:	89 d7                	mov    %edx,%edi
  8006e5:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	8d 85 5d fe ff ff    	lea    -0x1a3(%ebp),%eax
  8006f0:	50                   	push   %eax
  8006f1:	ff 75 b8             	pushl  -0x48(%ebp)
  8006f4:	e8 44 11 00 00       	call   80183d <ltostr>
  8006f9:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  800705:	50                   	push   %eax
  800706:	8d 85 5d fe ff ff    	lea    -0x1a3(%ebp),%eax
  80070c:	50                   	push   %eax
  80070d:	8d 85 62 fe ff ff    	lea    -0x19e(%ebp),%eax
  800713:	50                   	push   %eax
  800714:	e8 fd 11 00 00       	call   801916 <strcconcat>
  800719:	83 c4 10             	add    $0x10,%esp
		//sys_signalSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  80071c:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800722:	83 ec 04             	sub    $0x4,%esp
  800725:	8d 95 26 fe ff ff    	lea    -0x1da(%ebp),%edx
  80072b:	52                   	push   %edx
  80072c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80072f:	50                   	push   %eax
  800730:	e8 7e 3c 00 00       	call   8043b3 <get_semaphore>
  800735:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  800738:	83 ec 0c             	sub    $0xc,%esp
  80073b:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800741:	e8 a1 3c 00 00       	call   8043e7 <signal_semaphore>
  800746:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  800749:	83 ec 0c             	sub    $0xc,%esp
  80074c:	ff b5 84 fe ff ff    	pushl  -0x17c(%ebp)
  800752:	e8 90 3c 00 00       	call   8043e7 <signal_semaphore>
  800757:	83 c4 10             	add    $0x10,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
	struct semaphore clerkTerminated = get_semaphore(parentenvID, _clerkTerminated);

	while(*isOpened)
  80075a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	0f 85 82 fc ff ff    	jne    8003e9 <_main+0x3b1>

		//signal the clerk
		signal_semaphore(clerk);
	}

	cprintf("\nclerk is finished...........\n");
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	68 a0 47 80 00       	push   $0x8047a0
  80076f:	e8 9b 04 00 00       	call   800c0f <cprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(clerkTerminated);
  800777:	83 ec 0c             	sub    $0xc,%esp
  80077a:	ff b5 80 fe ff ff    	pushl  -0x180(%ebp)
  800780:	e8 62 3c 00 00       	call   8043e7 <signal_semaphore>
  800785:	83 c4 10             	add    $0x10,%esp
}
  800788:	90                   	nop
  800789:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078c:	5b                   	pop    %ebx
  80078d:	5e                   	pop    %esi
  80078e:	5f                   	pop    %edi
  80078f:	5d                   	pop    %ebp
  800790:	c3                   	ret    

00800791 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	57                   	push   %edi
  800795:	56                   	push   %esi
  800796:	53                   	push   %ebx
  800797:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80079a:	e8 a3 2e 00 00       	call   803642 <sys_getenvindex>
  80079f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8007a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007a5:	89 d0                	mov    %edx,%eax
  8007a7:	c1 e0 03             	shl    $0x3,%eax
  8007aa:	01 d0                	add    %edx,%eax
  8007ac:	c1 e0 02             	shl    $0x2,%eax
  8007af:	01 d0                	add    %edx,%eax
  8007b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007b8:	01 d0                	add    %edx,%eax
  8007ba:	c1 e0 03             	shl    $0x3,%eax
  8007bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c2:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007c7:	a1 20 60 80 00       	mov    0x806020,%eax
  8007cc:	8a 40 20             	mov    0x20(%eax),%al
  8007cf:	84 c0                	test   %al,%al
  8007d1:	74 0d                	je     8007e0 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8007d3:	a1 20 60 80 00       	mov    0x806020,%eax
  8007d8:	83 c0 20             	add    $0x20,%eax
  8007db:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007e4:	7e 0a                	jle    8007f0 <libmain+0x5f>
		binaryname = argv[0];
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	ff 75 08             	pushl  0x8(%ebp)
  8007f9:	e8 3a f8 ff ff       	call   800038 <_main>
  8007fe:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800801:	a1 00 60 80 00       	mov    0x806000,%eax
  800806:	85 c0                	test   %eax,%eax
  800808:	0f 84 01 01 00 00    	je     80090f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80080e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800814:	bb e8 49 80 00       	mov    $0x8049e8,%ebx
  800819:	ba 0e 00 00 00       	mov    $0xe,%edx
  80081e:	89 c7                	mov    %eax,%edi
  800820:	89 de                	mov    %ebx,%esi
  800822:	89 d1                	mov    %edx,%ecx
  800824:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800826:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800829:	b9 56 00 00 00       	mov    $0x56,%ecx
  80082e:	b0 00                	mov    $0x0,%al
  800830:	89 d7                	mov    %edx,%edi
  800832:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800834:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80083b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	50                   	push   %eax
  800842:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800848:	50                   	push   %eax
  800849:	e8 2a 30 00 00       	call   803878 <sys_utilities>
  80084e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800851:	e8 73 2b 00 00       	call   8033c9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800856:	83 ec 0c             	sub    $0xc,%esp
  800859:	68 08 49 80 00       	push   $0x804908
  80085e:	e8 ac 03 00 00       	call   800c0f <cprintf>
  800863:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800866:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	74 18                	je     800885 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80086d:	e8 24 30 00 00       	call   803896 <sys_get_optimal_num_faults>
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	50                   	push   %eax
  800876:	68 30 49 80 00       	push   $0x804930
  80087b:	e8 8f 03 00 00       	call   800c0f <cprintf>
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	eb 59                	jmp    8008de <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800885:	a1 20 60 80 00       	mov    0x806020,%eax
  80088a:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  800890:	a1 20 60 80 00       	mov    0x806020,%eax
  800895:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	52                   	push   %edx
  80089f:	50                   	push   %eax
  8008a0:	68 54 49 80 00       	push   $0x804954
  8008a5:	e8 65 03 00 00       	call   800c0f <cprintf>
  8008aa:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8008ad:	a1 20 60 80 00       	mov    0x806020,%eax
  8008b2:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8008b8:	a1 20 60 80 00       	mov    0x806020,%eax
  8008bd:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8008c3:	a1 20 60 80 00       	mov    0x806020,%eax
  8008c8:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8008ce:	51                   	push   %ecx
  8008cf:	52                   	push   %edx
  8008d0:	50                   	push   %eax
  8008d1:	68 7c 49 80 00       	push   $0x80497c
  8008d6:	e8 34 03 00 00       	call   800c0f <cprintf>
  8008db:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008de:	a1 20 60 80 00       	mov    0x806020,%eax
  8008e3:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	50                   	push   %eax
  8008ed:	68 d4 49 80 00       	push   $0x8049d4
  8008f2:	e8 18 03 00 00       	call   800c0f <cprintf>
  8008f7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8008fa:	83 ec 0c             	sub    $0xc,%esp
  8008fd:	68 08 49 80 00       	push   $0x804908
  800902:	e8 08 03 00 00       	call   800c0f <cprintf>
  800907:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80090a:	e8 d4 2a 00 00       	call   8033e3 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80090f:	e8 1f 00 00 00       	call   800933 <exit>
}
  800914:	90                   	nop
  800915:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5f                   	pop    %edi
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800923:	83 ec 0c             	sub    $0xc,%esp
  800926:	6a 00                	push   $0x0
  800928:	e8 e1 2c 00 00       	call   80360e <sys_destroy_env>
  80092d:	83 c4 10             	add    $0x10,%esp
}
  800930:	90                   	nop
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <exit>:

void
exit(void)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800939:	e8 36 2d 00 00       	call   803674 <sys_exit_env>
}
  80093e:	90                   	nop
  80093f:	c9                   	leave  
  800940:	c3                   	ret    

00800941 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800947:	8d 45 10             	lea    0x10(%ebp),%eax
  80094a:	83 c0 04             	add    $0x4,%eax
  80094d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800950:	a1 38 61 83 00       	mov    0x836138,%eax
  800955:	85 c0                	test   %eax,%eax
  800957:	74 16                	je     80096f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800959:	a1 38 61 83 00       	mov    0x836138,%eax
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	50                   	push   %eax
  800962:	68 4c 4a 80 00       	push   $0x804a4c
  800967:	e8 a3 02 00 00       	call   800c0f <cprintf>
  80096c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80096f:	a1 04 60 80 00       	mov    0x806004,%eax
  800974:	83 ec 0c             	sub    $0xc,%esp
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	ff 75 08             	pushl  0x8(%ebp)
  80097d:	50                   	push   %eax
  80097e:	68 54 4a 80 00       	push   $0x804a54
  800983:	6a 74                	push   $0x74
  800985:	e8 b2 02 00 00       	call   800c3c <cprintf_colored>
  80098a:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80098d:	8b 45 10             	mov    0x10(%ebp),%eax
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 f4             	pushl  -0xc(%ebp)
  800996:	50                   	push   %eax
  800997:	e8 04 02 00 00       	call   800ba0 <vcprintf>
  80099c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	6a 00                	push   $0x0
  8009a4:	68 7c 4a 80 00       	push   $0x804a7c
  8009a9:	e8 f2 01 00 00       	call   800ba0 <vcprintf>
  8009ae:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8009b1:	e8 7d ff ff ff       	call   800933 <exit>

	// should not return here
	while (1) ;
  8009b6:	eb fe                	jmp    8009b6 <_panic+0x75>

008009b8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8009be:	a1 20 60 80 00       	mov    0x806020,%eax
  8009c3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	39 c2                	cmp    %eax,%edx
  8009ce:	74 14                	je     8009e4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009d0:	83 ec 04             	sub    $0x4,%esp
  8009d3:	68 80 4a 80 00       	push   $0x804a80
  8009d8:	6a 26                	push   $0x26
  8009da:	68 cc 4a 80 00       	push   $0x804acc
  8009df:	e8 5d ff ff ff       	call   800941 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009f2:	e9 c5 00 00 00       	jmp    800abc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8009f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	01 d0                	add    %edx,%eax
  800a06:	8b 00                	mov    (%eax),%eax
  800a08:	85 c0                	test   %eax,%eax
  800a0a:	75 08                	jne    800a14 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800a0c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a0f:	e9 a5 00 00 00       	jmp    800ab9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a14:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a22:	eb 69                	jmp    800a8d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a24:	a1 20 60 80 00       	mov    0x806020,%eax
  800a29:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a32:	89 d0                	mov    %edx,%eax
  800a34:	01 c0                	add    %eax,%eax
  800a36:	01 d0                	add    %edx,%eax
  800a38:	c1 e0 03             	shl    $0x3,%eax
  800a3b:	01 c8                	add    %ecx,%eax
  800a3d:	8a 40 04             	mov    0x4(%eax),%al
  800a40:	84 c0                	test   %al,%al
  800a42:	75 46                	jne    800a8a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a44:	a1 20 60 80 00       	mov    0x806020,%eax
  800a49:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800a4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a52:	89 d0                	mov    %edx,%eax
  800a54:	01 c0                	add    %eax,%eax
  800a56:	01 d0                	add    %edx,%eax
  800a58:	c1 e0 03             	shl    $0x3,%eax
  800a5b:	01 c8                	add    %ecx,%eax
  800a5d:	8b 00                	mov    (%eax),%eax
  800a5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a6a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	01 c8                	add    %ecx,%eax
  800a7b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a7d:	39 c2                	cmp    %eax,%edx
  800a7f:	75 09                	jne    800a8a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a81:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a88:	eb 15                	jmp    800a9f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8a:	ff 45 e8             	incl   -0x18(%ebp)
  800a8d:	a1 20 60 80 00       	mov    0x806020,%eax
  800a92:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a9b:	39 c2                	cmp    %eax,%edx
  800a9d:	77 85                	ja     800a24 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aa3:	75 14                	jne    800ab9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800aa5:	83 ec 04             	sub    $0x4,%esp
  800aa8:	68 d8 4a 80 00       	push   $0x804ad8
  800aad:	6a 3a                	push   $0x3a
  800aaf:	68 cc 4a 80 00       	push   $0x804acc
  800ab4:	e8 88 fe ff ff       	call   800941 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ab9:	ff 45 f0             	incl   -0x10(%ebp)
  800abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800abf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ac2:	0f 8c 2f ff ff ff    	jl     8009f7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ac8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800acf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ad6:	eb 26                	jmp    800afe <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ad8:	a1 20 60 80 00       	mov    0x806020,%eax
  800add:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800ae3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ae6:	89 d0                	mov    %edx,%eax
  800ae8:	01 c0                	add    %eax,%eax
  800aea:	01 d0                	add    %edx,%eax
  800aec:	c1 e0 03             	shl    $0x3,%eax
  800aef:	01 c8                	add    %ecx,%eax
  800af1:	8a 40 04             	mov    0x4(%eax),%al
  800af4:	3c 01                	cmp    $0x1,%al
  800af6:	75 03                	jne    800afb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800af8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800afb:	ff 45 e0             	incl   -0x20(%ebp)
  800afe:	a1 20 60 80 00       	mov    0x806020,%eax
  800b03:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b0c:	39 c2                	cmp    %eax,%edx
  800b0e:	77 c8                	ja     800ad8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b13:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b16:	74 14                	je     800b2c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b18:	83 ec 04             	sub    $0x4,%esp
  800b1b:	68 2c 4b 80 00       	push   $0x804b2c
  800b20:	6a 44                	push   $0x44
  800b22:	68 cc 4a 80 00       	push   $0x804acc
  800b27:	e8 15 fe ff ff       	call   800941 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b2c:	90                   	nop
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	53                   	push   %ebx
  800b33:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b41:	89 0a                	mov    %ecx,(%edx)
  800b43:	8b 55 08             	mov    0x8(%ebp),%edx
  800b46:	88 d1                	mov    %dl,%cl
  800b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8b 00                	mov    (%eax),%eax
  800b54:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b59:	75 30                	jne    800b8b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b5b:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800b61:	a0 64 e0 81 00       	mov    0x81e064,%al
  800b66:	0f b6 c0             	movzbl %al,%eax
  800b69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6c:	8b 09                	mov    (%ecx),%ecx
  800b6e:	89 cb                	mov    %ecx,%ebx
  800b70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b73:	83 c1 08             	add    $0x8,%ecx
  800b76:	52                   	push   %edx
  800b77:	50                   	push   %eax
  800b78:	53                   	push   %ebx
  800b79:	51                   	push   %ecx
  800b7a:	e8 06 28 00 00       	call   803385 <sys_cputs>
  800b7f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	8b 40 04             	mov    0x4(%eax),%eax
  800b91:	8d 50 01             	lea    0x1(%eax),%edx
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b9a:	90                   	nop
  800b9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b9e:	c9                   	leave  
  800b9f:	c3                   	ret    

00800ba0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ba9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bb0:	00 00 00 
	b.cnt = 0;
  800bb3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bba:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bbd:	ff 75 0c             	pushl  0xc(%ebp)
  800bc0:	ff 75 08             	pushl  0x8(%ebp)
  800bc3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bc9:	50                   	push   %eax
  800bca:	68 2f 0b 80 00       	push   $0x800b2f
  800bcf:	e8 5a 02 00 00       	call   800e2e <vprintfmt>
  800bd4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800bd7:	8b 15 3c 61 83 00    	mov    0x83613c,%edx
  800bdd:	a0 64 e0 81 00       	mov    0x81e064,%al
  800be2:	0f b6 c0             	movzbl %al,%eax
  800be5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800beb:	52                   	push   %edx
  800bec:	50                   	push   %eax
  800bed:	51                   	push   %ecx
  800bee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bf4:	83 c0 08             	add    $0x8,%eax
  800bf7:	50                   	push   %eax
  800bf8:	e8 88 27 00 00       	call   803385 <sys_cputs>
  800bfd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c00:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  800c07:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c15:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  800c1c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	83 ec 08             	sub    $0x8,%esp
  800c28:	ff 75 f4             	pushl  -0xc(%ebp)
  800c2b:	50                   	push   %eax
  800c2c:	e8 6f ff ff ff       	call   800ba0 <vcprintf>
  800c31:	83 c4 10             	add    $0x10,%esp
  800c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c42:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	c1 e0 08             	shl    $0x8,%eax
  800c4f:	a3 3c 61 83 00       	mov    %eax,0x83613c
	va_start(ap, fmt);
  800c54:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c57:	83 c0 04             	add    $0x4,%eax
  800c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 f4             	pushl  -0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	e8 34 ff ff ff       	call   800ba0 <vcprintf>
  800c6c:	83 c4 10             	add    $0x10,%esp
  800c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c72:	c7 05 3c 61 83 00 00 	movl   $0x700,0x83613c
  800c79:	07 00 00 

	return cnt;
  800c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c87:	e8 3d 27 00 00       	call   8033c9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c8c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	83 ec 08             	sub    $0x8,%esp
  800c98:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9b:	50                   	push   %eax
  800c9c:	e8 ff fe ff ff       	call   800ba0 <vcprintf>
  800ca1:	83 c4 10             	add    $0x10,%esp
  800ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ca7:	e8 37 27 00 00       	call   8033e3 <sys_unlock_cons>
	return cnt;
  800cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	53                   	push   %ebx
  800cb5:	83 ec 14             	sub    $0x14,%esp
  800cb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cc4:	8b 45 18             	mov    0x18(%ebp),%eax
  800cc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ccf:	77 55                	ja     800d26 <printnum+0x75>
  800cd1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd4:	72 05                	jb     800cdb <printnum+0x2a>
  800cd6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cd9:	77 4b                	ja     800d26 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cdb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800cde:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce1:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce9:	52                   	push   %edx
  800cea:	50                   	push   %eax
  800ceb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cee:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf1:	e8 16 37 00 00       	call   80440c <__udivdi3>
  800cf6:	83 c4 10             	add    $0x10,%esp
  800cf9:	83 ec 04             	sub    $0x4,%esp
  800cfc:	ff 75 20             	pushl  0x20(%ebp)
  800cff:	53                   	push   %ebx
  800d00:	ff 75 18             	pushl  0x18(%ebp)
  800d03:	52                   	push   %edx
  800d04:	50                   	push   %eax
  800d05:	ff 75 0c             	pushl  0xc(%ebp)
  800d08:	ff 75 08             	pushl  0x8(%ebp)
  800d0b:	e8 a1 ff ff ff       	call   800cb1 <printnum>
  800d10:	83 c4 20             	add    $0x20,%esp
  800d13:	eb 1a                	jmp    800d2f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d15:	83 ec 08             	sub    $0x8,%esp
  800d18:	ff 75 0c             	pushl  0xc(%ebp)
  800d1b:	ff 75 20             	pushl  0x20(%ebp)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	ff d0                	call   *%eax
  800d23:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d26:	ff 4d 1c             	decl   0x1c(%ebp)
  800d29:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d2d:	7f e6                	jg     800d15 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d2f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3d:	53                   	push   %ebx
  800d3e:	51                   	push   %ecx
  800d3f:	52                   	push   %edx
  800d40:	50                   	push   %eax
  800d41:	e8 d6 37 00 00       	call   80451c <__umoddi3>
  800d46:	83 c4 10             	add    $0x10,%esp
  800d49:	05 94 4d 80 00       	add    $0x804d94,%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	0f be c0             	movsbl %al,%eax
  800d53:	83 ec 08             	sub    $0x8,%esp
  800d56:	ff 75 0c             	pushl  0xc(%ebp)
  800d59:	50                   	push   %eax
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	ff d0                	call   *%eax
  800d5f:	83 c4 10             	add    $0x10,%esp
}
  800d62:	90                   	nop
  800d63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d6b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d6f:	7e 1c                	jle    800d8d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8b 00                	mov    (%eax),%eax
  800d76:	8d 50 08             	lea    0x8(%eax),%edx
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	89 10                	mov    %edx,(%eax)
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	83 e8 08             	sub    $0x8,%eax
  800d86:	8b 50 04             	mov    0x4(%eax),%edx
  800d89:	8b 00                	mov    (%eax),%eax
  800d8b:	eb 40                	jmp    800dcd <getuint+0x65>
	else if (lflag)
  800d8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d91:	74 1e                	je     800db1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 00                	mov    (%eax),%eax
  800d98:	8d 50 04             	lea    0x4(%eax),%edx
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	89 10                	mov    %edx,(%eax)
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8b 00                	mov    (%eax),%eax
  800da5:	83 e8 04             	sub    $0x4,%eax
  800da8:	8b 00                	mov    (%eax),%eax
  800daa:	ba 00 00 00 00       	mov    $0x0,%edx
  800daf:	eb 1c                	jmp    800dcd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8b 00                	mov    (%eax),%eax
  800db6:	8d 50 04             	lea    0x4(%eax),%edx
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	89 10                	mov    %edx,(%eax)
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8b 00                	mov    (%eax),%eax
  800dc3:	83 e8 04             	sub    $0x4,%eax
  800dc6:	8b 00                	mov    (%eax),%eax
  800dc8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    

00800dcf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd6:	7e 1c                	jle    800df4 <getint+0x25>
		return va_arg(*ap, long long);
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8b 00                	mov    (%eax),%eax
  800ddd:	8d 50 08             	lea    0x8(%eax),%edx
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	89 10                	mov    %edx,(%eax)
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8b 00                	mov    (%eax),%eax
  800dea:	83 e8 08             	sub    $0x8,%eax
  800ded:	8b 50 04             	mov    0x4(%eax),%edx
  800df0:	8b 00                	mov    (%eax),%eax
  800df2:	eb 38                	jmp    800e2c <getint+0x5d>
	else if (lflag)
  800df4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df8:	74 1a                	je     800e14 <getint+0x45>
		return va_arg(*ap, long);
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8b 00                	mov    (%eax),%eax
  800dff:	8d 50 04             	lea    0x4(%eax),%edx
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	89 10                	mov    %edx,(%eax)
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8b 00                	mov    (%eax),%eax
  800e0c:	83 e8 04             	sub    $0x4,%eax
  800e0f:	8b 00                	mov    (%eax),%eax
  800e11:	99                   	cltd   
  800e12:	eb 18                	jmp    800e2c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8b 00                	mov    (%eax),%eax
  800e19:	8d 50 04             	lea    0x4(%eax),%edx
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	89 10                	mov    %edx,(%eax)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8b 00                	mov    (%eax),%eax
  800e26:	83 e8 04             	sub    $0x4,%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	99                   	cltd   
}
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    

00800e2e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
  800e33:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e36:	eb 17                	jmp    800e4f <vprintfmt+0x21>
			if (ch == '\0')
  800e38:	85 db                	test   %ebx,%ebx
  800e3a:	0f 84 c1 03 00 00    	je     801201 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e40:	83 ec 08             	sub    $0x8,%esp
  800e43:	ff 75 0c             	pushl  0xc(%ebp)
  800e46:	53                   	push   %ebx
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	ff d0                	call   *%eax
  800e4c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	8d 50 01             	lea    0x1(%eax),%edx
  800e55:	89 55 10             	mov    %edx,0x10(%ebp)
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	0f b6 d8             	movzbl %al,%ebx
  800e5d:	83 fb 25             	cmp    $0x25,%ebx
  800e60:	75 d6                	jne    800e38 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e62:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e66:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e6d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e7b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e82:	8b 45 10             	mov    0x10(%ebp),%eax
  800e85:	8d 50 01             	lea    0x1(%eax),%edx
  800e88:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	0f b6 d8             	movzbl %al,%ebx
  800e90:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e93:	83 f8 5b             	cmp    $0x5b,%eax
  800e96:	0f 87 3d 03 00 00    	ja     8011d9 <vprintfmt+0x3ab>
  800e9c:	8b 04 85 b8 4d 80 00 	mov    0x804db8(,%eax,4),%eax
  800ea3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ea5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ea9:	eb d7                	jmp    800e82 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800eab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eaf:	eb d1                	jmp    800e82 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eb8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ebb:	89 d0                	mov    %edx,%eax
  800ebd:	c1 e0 02             	shl    $0x2,%eax
  800ec0:	01 d0                	add    %edx,%eax
  800ec2:	01 c0                	add    %eax,%eax
  800ec4:	01 d8                	add    %ebx,%eax
  800ec6:	83 e8 30             	sub    $0x30,%eax
  800ec9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ed4:	83 fb 2f             	cmp    $0x2f,%ebx
  800ed7:	7e 3e                	jle    800f17 <vprintfmt+0xe9>
  800ed9:	83 fb 39             	cmp    $0x39,%ebx
  800edc:	7f 39                	jg     800f17 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ede:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee1:	eb d5                	jmp    800eb8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ee3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee6:	83 c0 04             	add    $0x4,%eax
  800ee9:	89 45 14             	mov    %eax,0x14(%ebp)
  800eec:	8b 45 14             	mov    0x14(%ebp),%eax
  800eef:	83 e8 04             	sub    $0x4,%eax
  800ef2:	8b 00                	mov    (%eax),%eax
  800ef4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ef7:	eb 1f                	jmp    800f18 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ef9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800efd:	79 83                	jns    800e82 <vprintfmt+0x54>
				width = 0;
  800eff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f06:	e9 77 ff ff ff       	jmp    800e82 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f0b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f12:	e9 6b ff ff ff       	jmp    800e82 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f17:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1c:	0f 89 60 ff ff ff    	jns    800e82 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f28:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f2f:	e9 4e ff ff ff       	jmp    800e82 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f34:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f37:	e9 46 ff ff ff       	jmp    800e82 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3f:	83 c0 04             	add    $0x4,%eax
  800f42:	89 45 14             	mov    %eax,0x14(%ebp)
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	83 e8 04             	sub    $0x4,%eax
  800f4b:	8b 00                	mov    (%eax),%eax
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	50                   	push   %eax
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	ff d0                	call   *%eax
  800f59:	83 c4 10             	add    $0x10,%esp
			break;
  800f5c:	e9 9b 02 00 00       	jmp    8011fc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f61:	8b 45 14             	mov    0x14(%ebp),%eax
  800f64:	83 c0 04             	add    $0x4,%eax
  800f67:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 e8 04             	sub    $0x4,%eax
  800f70:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f72:	85 db                	test   %ebx,%ebx
  800f74:	79 02                	jns    800f78 <vprintfmt+0x14a>
				err = -err;
  800f76:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f78:	83 fb 64             	cmp    $0x64,%ebx
  800f7b:	7f 0b                	jg     800f88 <vprintfmt+0x15a>
  800f7d:	8b 34 9d 00 4c 80 00 	mov    0x804c00(,%ebx,4),%esi
  800f84:	85 f6                	test   %esi,%esi
  800f86:	75 19                	jne    800fa1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f88:	53                   	push   %ebx
  800f89:	68 a5 4d 80 00       	push   $0x804da5
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	e8 70 02 00 00       	call   801209 <printfmt>
  800f99:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f9c:	e9 5b 02 00 00       	jmp    8011fc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa1:	56                   	push   %esi
  800fa2:	68 ae 4d 80 00       	push   $0x804dae
  800fa7:	ff 75 0c             	pushl  0xc(%ebp)
  800faa:	ff 75 08             	pushl  0x8(%ebp)
  800fad:	e8 57 02 00 00       	call   801209 <printfmt>
  800fb2:	83 c4 10             	add    $0x10,%esp
			break;
  800fb5:	e9 42 02 00 00       	jmp    8011fc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fba:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbd:	83 c0 04             	add    $0x4,%eax
  800fc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	83 e8 04             	sub    $0x4,%eax
  800fc9:	8b 30                	mov    (%eax),%esi
  800fcb:	85 f6                	test   %esi,%esi
  800fcd:	75 05                	jne    800fd4 <vprintfmt+0x1a6>
				p = "(null)";
  800fcf:	be b1 4d 80 00       	mov    $0x804db1,%esi
			if (width > 0 && padc != '-')
  800fd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd8:	7e 6d                	jle    801047 <vprintfmt+0x219>
  800fda:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fde:	74 67                	je     801047 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	50                   	push   %eax
  800fe7:	56                   	push   %esi
  800fe8:	e8 1e 03 00 00       	call   80130b <strnlen>
  800fed:	83 c4 10             	add    $0x10,%esp
  800ff0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ff3:	eb 16                	jmp    80100b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ff5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	50                   	push   %eax
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	ff d0                	call   *%eax
  801005:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801008:	ff 4d e4             	decl   -0x1c(%ebp)
  80100b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80100f:	7f e4                	jg     800ff5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801011:	eb 34                	jmp    801047 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801013:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801017:	74 1c                	je     801035 <vprintfmt+0x207>
  801019:	83 fb 1f             	cmp    $0x1f,%ebx
  80101c:	7e 05                	jle    801023 <vprintfmt+0x1f5>
  80101e:	83 fb 7e             	cmp    $0x7e,%ebx
  801021:	7e 12                	jle    801035 <vprintfmt+0x207>
					putch('?', putdat);
  801023:	83 ec 08             	sub    $0x8,%esp
  801026:	ff 75 0c             	pushl  0xc(%ebp)
  801029:	6a 3f                	push   $0x3f
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	ff d0                	call   *%eax
  801030:	83 c4 10             	add    $0x10,%esp
  801033:	eb 0f                	jmp    801044 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801035:	83 ec 08             	sub    $0x8,%esp
  801038:	ff 75 0c             	pushl  0xc(%ebp)
  80103b:	53                   	push   %ebx
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	ff d0                	call   *%eax
  801041:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801044:	ff 4d e4             	decl   -0x1c(%ebp)
  801047:	89 f0                	mov    %esi,%eax
  801049:	8d 70 01             	lea    0x1(%eax),%esi
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f be d8             	movsbl %al,%ebx
  801051:	85 db                	test   %ebx,%ebx
  801053:	74 24                	je     801079 <vprintfmt+0x24b>
  801055:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801059:	78 b8                	js     801013 <vprintfmt+0x1e5>
  80105b:	ff 4d e0             	decl   -0x20(%ebp)
  80105e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801062:	79 af                	jns    801013 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801064:	eb 13                	jmp    801079 <vprintfmt+0x24b>
				putch(' ', putdat);
  801066:	83 ec 08             	sub    $0x8,%esp
  801069:	ff 75 0c             	pushl  0xc(%ebp)
  80106c:	6a 20                	push   $0x20
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	ff d0                	call   *%eax
  801073:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801076:	ff 4d e4             	decl   -0x1c(%ebp)
  801079:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107d:	7f e7                	jg     801066 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80107f:	e9 78 01 00 00       	jmp    8011fc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801084:	83 ec 08             	sub    $0x8,%esp
  801087:	ff 75 e8             	pushl  -0x18(%ebp)
  80108a:	8d 45 14             	lea    0x14(%ebp),%eax
  80108d:	50                   	push   %eax
  80108e:	e8 3c fd ff ff       	call   800dcf <getint>
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80109c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a2:	85 d2                	test   %edx,%edx
  8010a4:	79 23                	jns    8010c9 <vprintfmt+0x29b>
				putch('-', putdat);
  8010a6:	83 ec 08             	sub    $0x8,%esp
  8010a9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ac:	6a 2d                	push   $0x2d
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	ff d0                	call   *%eax
  8010b3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010bc:	f7 d8                	neg    %eax
  8010be:	83 d2 00             	adc    $0x0,%edx
  8010c1:	f7 da                	neg    %edx
  8010c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010c9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d0:	e9 bc 00 00 00       	jmp    801191 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010d5:	83 ec 08             	sub    $0x8,%esp
  8010d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8010db:	8d 45 14             	lea    0x14(%ebp),%eax
  8010de:	50                   	push   %eax
  8010df:	e8 84 fc ff ff       	call   800d68 <getuint>
  8010e4:	83 c4 10             	add    $0x10,%esp
  8010e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f4:	e9 98 00 00 00       	jmp    801191 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	ff 75 0c             	pushl  0xc(%ebp)
  8010ff:	6a 58                	push   $0x58
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	ff d0                	call   *%eax
  801106:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	6a 58                	push   $0x58
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	ff d0                	call   *%eax
  801116:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	ff 75 0c             	pushl  0xc(%ebp)
  80111f:	6a 58                	push   $0x58
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	ff d0                	call   *%eax
  801126:	83 c4 10             	add    $0x10,%esp
			break;
  801129:	e9 ce 00 00 00       	jmp    8011fc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80112e:	83 ec 08             	sub    $0x8,%esp
  801131:	ff 75 0c             	pushl  0xc(%ebp)
  801134:	6a 30                	push   $0x30
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	ff d0                	call   *%eax
  80113b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80113e:	83 ec 08             	sub    $0x8,%esp
  801141:	ff 75 0c             	pushl  0xc(%ebp)
  801144:	6a 78                	push   $0x78
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	ff d0                	call   *%eax
  80114b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80114e:	8b 45 14             	mov    0x14(%ebp),%eax
  801151:	83 c0 04             	add    $0x4,%eax
  801154:	89 45 14             	mov    %eax,0x14(%ebp)
  801157:	8b 45 14             	mov    0x14(%ebp),%eax
  80115a:	83 e8 04             	sub    $0x4,%eax
  80115d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80115f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801162:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801169:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801170:	eb 1f                	jmp    801191 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801172:	83 ec 08             	sub    $0x8,%esp
  801175:	ff 75 e8             	pushl  -0x18(%ebp)
  801178:	8d 45 14             	lea    0x14(%ebp),%eax
  80117b:	50                   	push   %eax
  80117c:	e8 e7 fb ff ff       	call   800d68 <getuint>
  801181:	83 c4 10             	add    $0x10,%esp
  801184:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801187:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80118a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801191:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801198:	83 ec 04             	sub    $0x4,%esp
  80119b:	52                   	push   %edx
  80119c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80119f:	50                   	push   %eax
  8011a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	ff 75 08             	pushl  0x8(%ebp)
  8011ac:	e8 00 fb ff ff       	call   800cb1 <printnum>
  8011b1:	83 c4 20             	add    $0x20,%esp
			break;
  8011b4:	eb 46                	jmp    8011fc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011b6:	83 ec 08             	sub    $0x8,%esp
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	53                   	push   %ebx
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	ff d0                	call   *%eax
  8011c2:	83 c4 10             	add    $0x10,%esp
			break;
  8011c5:	eb 35                	jmp    8011fc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011c7:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  8011ce:	eb 2c                	jmp    8011fc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011d0:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  8011d7:	eb 23                	jmp    8011fc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011d9:	83 ec 08             	sub    $0x8,%esp
  8011dc:	ff 75 0c             	pushl  0xc(%ebp)
  8011df:	6a 25                	push   $0x25
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	ff d0                	call   *%eax
  8011e6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011e9:	ff 4d 10             	decl   0x10(%ebp)
  8011ec:	eb 03                	jmp    8011f1 <vprintfmt+0x3c3>
  8011ee:	ff 4d 10             	decl   0x10(%ebp)
  8011f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f4:	48                   	dec    %eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	3c 25                	cmp    $0x25,%al
  8011f9:	75 f3                	jne    8011ee <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8011fb:	90                   	nop
		}
	}
  8011fc:	e9 35 fc ff ff       	jmp    800e36 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801201:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801202:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801205:	5b                   	pop    %ebx
  801206:	5e                   	pop    %esi
  801207:	5d                   	pop    %ebp
  801208:	c3                   	ret    

00801209 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80120f:	8d 45 10             	lea    0x10(%ebp),%eax
  801212:	83 c0 04             	add    $0x4,%eax
  801215:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801218:	8b 45 10             	mov    0x10(%ebp),%eax
  80121b:	ff 75 f4             	pushl  -0xc(%ebp)
  80121e:	50                   	push   %eax
  80121f:	ff 75 0c             	pushl  0xc(%ebp)
  801222:	ff 75 08             	pushl  0x8(%ebp)
  801225:	e8 04 fc ff ff       	call   800e2e <vprintfmt>
  80122a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80122d:	90                   	nop
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    

00801230 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	8b 40 08             	mov    0x8(%eax),%eax
  801239:	8d 50 01             	lea    0x1(%eax),%edx
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801242:	8b 45 0c             	mov    0xc(%ebp),%eax
  801245:	8b 10                	mov    (%eax),%edx
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	8b 40 04             	mov    0x4(%eax),%eax
  80124d:	39 c2                	cmp    %eax,%edx
  80124f:	73 12                	jae    801263 <sprintputch+0x33>
		*b->buf++ = ch;
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	8b 00                	mov    (%eax),%eax
  801256:	8d 48 01             	lea    0x1(%eax),%ecx
  801259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125c:	89 0a                	mov    %ecx,(%edx)
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	88 10                	mov    %dl,(%eax)
}
  801263:	90                   	nop
  801264:	5d                   	pop    %ebp
  801265:	c3                   	ret    

00801266 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801272:	8b 45 0c             	mov    0xc(%ebp),%eax
  801275:	8d 50 ff             	lea    -0x1(%eax),%edx
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	01 d0                	add    %edx,%eax
  80127d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801287:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128b:	74 06                	je     801293 <vsnprintf+0x2d>
  80128d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801291:	7f 07                	jg     80129a <vsnprintf+0x34>
		return -E_INVAL;
  801293:	b8 03 00 00 00       	mov    $0x3,%eax
  801298:	eb 20                	jmp    8012ba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80129a:	ff 75 14             	pushl  0x14(%ebp)
  80129d:	ff 75 10             	pushl  0x10(%ebp)
  8012a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	68 30 12 80 00       	push   $0x801230
  8012a9:	e8 80 fb ff ff       	call   800e2e <vprintfmt>
  8012ae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8012c5:	83 c0 04             	add    $0x4,%eax
  8012c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d1:	50                   	push   %eax
  8012d2:	ff 75 0c             	pushl  0xc(%ebp)
  8012d5:	ff 75 08             	pushl  0x8(%ebp)
  8012d8:	e8 89 ff ff ff       	call   801266 <vsnprintf>
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f5:	eb 06                	jmp    8012fd <strlen+0x15>
		n++;
  8012f7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012fa:	ff 45 08             	incl   0x8(%ebp)
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 f1                	jne    8012f7 <strlen+0xf>
		n++;
	return n;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801311:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801318:	eb 09                	jmp    801323 <strnlen+0x18>
		n++;
  80131a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80131d:	ff 45 08             	incl   0x8(%ebp)
  801320:	ff 4d 0c             	decl   0xc(%ebp)
  801323:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801327:	74 09                	je     801332 <strnlen+0x27>
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	84 c0                	test   %al,%al
  801330:	75 e8                	jne    80131a <strnlen+0xf>
		n++;
	return n;
  801332:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801343:	90                   	nop
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	8d 50 01             	lea    0x1(%eax),%edx
  80134a:	89 55 08             	mov    %edx,0x8(%ebp)
  80134d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801350:	8d 4a 01             	lea    0x1(%edx),%ecx
  801353:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801356:	8a 12                	mov    (%edx),%dl
  801358:	88 10                	mov    %dl,(%eax)
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	84 c0                	test   %al,%al
  80135e:	75 e4                	jne    801344 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801360:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801378:	eb 1f                	jmp    801399 <strncpy+0x34>
		*dst++ = *src;
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8d 50 01             	lea    0x1(%eax),%edx
  801380:	89 55 08             	mov    %edx,0x8(%ebp)
  801383:	8b 55 0c             	mov    0xc(%ebp),%edx
  801386:	8a 12                	mov    (%edx),%dl
  801388:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80138a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138d:	8a 00                	mov    (%eax),%al
  80138f:	84 c0                	test   %al,%al
  801391:	74 03                	je     801396 <strncpy+0x31>
			src++;
  801393:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801396:	ff 45 fc             	incl   -0x4(%ebp)
  801399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80139f:	72 d9                	jb     80137a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b6:	74 30                	je     8013e8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013b8:	eb 16                	jmp    8013d0 <strlcpy+0x2a>
			*dst++ = *src++;
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8d 50 01             	lea    0x1(%eax),%edx
  8013c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013cc:	8a 12                	mov    (%edx),%dl
  8013ce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013d0:	ff 4d 10             	decl   0x10(%ebp)
  8013d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d7:	74 09                	je     8013e2 <strlcpy+0x3c>
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	84 c0                	test   %al,%al
  8013e0:	75 d8                	jne    8013ba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013f7:	eb 06                	jmp    8013ff <strcmp+0xb>
		p++, q++;
  8013f9:	ff 45 08             	incl   0x8(%ebp)
  8013fc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	84 c0                	test   %al,%al
  801406:	74 0e                	je     801416 <strcmp+0x22>
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 10                	mov    (%eax),%dl
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	8a 00                	mov    (%eax),%al
  801412:	38 c2                	cmp    %al,%dl
  801414:	74 e3                	je     8013f9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	0f b6 d0             	movzbl %al,%edx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	0f b6 c0             	movzbl %al,%eax
  801426:	29 c2                	sub    %eax,%edx
  801428:	89 d0                	mov    %edx,%eax
}
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80142f:	eb 09                	jmp    80143a <strncmp+0xe>
		n--, p++, q++;
  801431:	ff 4d 10             	decl   0x10(%ebp)
  801434:	ff 45 08             	incl   0x8(%ebp)
  801437:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80143a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143e:	74 17                	je     801457 <strncmp+0x2b>
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	84 c0                	test   %al,%al
  801447:	74 0e                	je     801457 <strncmp+0x2b>
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 10                	mov    (%eax),%dl
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	38 c2                	cmp    %al,%dl
  801455:	74 da                	je     801431 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801457:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145b:	75 07                	jne    801464 <strncmp+0x38>
		return 0;
  80145d:	b8 00 00 00 00       	mov    $0x0,%eax
  801462:	eb 14                	jmp    801478 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	0f b6 d0             	movzbl %al,%edx
  80146c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	0f b6 c0             	movzbl %al,%eax
  801474:	29 c2                	sub    %eax,%edx
  801476:	89 d0                	mov    %edx,%eax
}
  801478:	5d                   	pop    %ebp
  801479:	c3                   	ret    

0080147a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	83 ec 04             	sub    $0x4,%esp
  801480:	8b 45 0c             	mov    0xc(%ebp),%eax
  801483:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801486:	eb 12                	jmp    80149a <strchr+0x20>
		if (*s == c)
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801490:	75 05                	jne    801497 <strchr+0x1d>
			return (char *) s;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	eb 11                	jmp    8014a8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801497:	ff 45 08             	incl   0x8(%ebp)
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	84 c0                	test   %al,%al
  8014a1:	75 e5                	jne    801488 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 04             	sub    $0x4,%esp
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014b6:	eb 0d                	jmp    8014c5 <strfind+0x1b>
		if (*s == c)
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	8a 00                	mov    (%eax),%al
  8014bd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014c0:	74 0e                	je     8014d0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014c2:	ff 45 08             	incl   0x8(%ebp)
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	8a 00                	mov    (%eax),%al
  8014ca:	84 c0                	test   %al,%al
  8014cc:	75 ea                	jne    8014b8 <strfind+0xe>
  8014ce:	eb 01                	jmp    8014d1 <strfind+0x27>
		if (*s == c)
			break;
  8014d0:	90                   	nop
	return (char *) s;
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014e2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014e6:	76 63                	jbe    80154b <memset+0x75>
		uint64 data_block = c;
  8014e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014eb:	99                   	cltd   
  8014ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8014fc:	c1 e0 08             	shl    $0x8,%eax
  8014ff:	09 45 f0             	or     %eax,-0x10(%ebp)
  801502:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80150f:	c1 e0 10             	shl    $0x10,%eax
  801512:	09 45 f0             	or     %eax,-0x10(%ebp)
  801515:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151e:	89 c2                	mov    %eax,%edx
  801520:	b8 00 00 00 00       	mov    $0x0,%eax
  801525:	09 45 f0             	or     %eax,-0x10(%ebp)
  801528:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80152b:	eb 18                	jmp    801545 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80152d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801530:	8d 41 08             	lea    0x8(%ecx),%eax
  801533:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801539:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80153c:	89 01                	mov    %eax,(%ecx)
  80153e:	89 51 04             	mov    %edx,0x4(%ecx)
  801541:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801545:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801549:	77 e2                	ja     80152d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80154b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154f:	74 23                	je     801574 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801551:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801554:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801557:	eb 0e                	jmp    801567 <memset+0x91>
			*p8++ = (uint8)c;
  801559:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80155c:	8d 50 01             	lea    0x1(%eax),%edx
  80155f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801562:	8b 55 0c             	mov    0xc(%ebp),%edx
  801565:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80156d:	89 55 10             	mov    %edx,0x10(%ebp)
  801570:	85 c0                	test   %eax,%eax
  801572:	75 e5                	jne    801559 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80157f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801582:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801585:	8b 45 08             	mov    0x8(%ebp),%eax
  801588:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80158b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80158f:	76 24                	jbe    8015b5 <memcpy+0x3c>
		while(n >= 8){
  801591:	eb 1c                	jmp    8015af <memcpy+0x36>
			*d64 = *s64;
  801593:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801596:	8b 50 04             	mov    0x4(%eax),%edx
  801599:	8b 00                	mov    (%eax),%eax
  80159b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80159e:	89 01                	mov    %eax,(%ecx)
  8015a0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015a3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015a7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015ab:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015af:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015b3:	77 de                	ja     801593 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b9:	74 31                	je     8015ec <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015c7:	eb 16                	jmp    8015df <memcpy+0x66>
			*d8++ = *s8++;
  8015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cc:	8d 50 01             	lea    0x1(%eax),%edx
  8015cf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015d8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015db:	8a 12                	mov    (%edx),%dl
  8015dd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015df:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	75 dd                	jne    8015c9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801603:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801606:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801609:	73 50                	jae    80165b <memmove+0x6a>
  80160b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160e:	8b 45 10             	mov    0x10(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801616:	76 43                	jbe    80165b <memmove+0x6a>
		s += n;
  801618:	8b 45 10             	mov    0x10(%ebp),%eax
  80161b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80161e:	8b 45 10             	mov    0x10(%ebp),%eax
  801621:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801624:	eb 10                	jmp    801636 <memmove+0x45>
			*--d = *--s;
  801626:	ff 4d f8             	decl   -0x8(%ebp)
  801629:	ff 4d fc             	decl   -0x4(%ebp)
  80162c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162f:	8a 10                	mov    (%eax),%dl
  801631:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801634:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801636:	8b 45 10             	mov    0x10(%ebp),%eax
  801639:	8d 50 ff             	lea    -0x1(%eax),%edx
  80163c:	89 55 10             	mov    %edx,0x10(%ebp)
  80163f:	85 c0                	test   %eax,%eax
  801641:	75 e3                	jne    801626 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801643:	eb 23                	jmp    801668 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801645:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801648:	8d 50 01             	lea    0x1(%eax),%edx
  80164b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801651:	8d 4a 01             	lea    0x1(%edx),%ecx
  801654:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801657:	8a 12                	mov    (%edx),%dl
  801659:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801661:	89 55 10             	mov    %edx,0x10(%ebp)
  801664:	85 c0                	test   %eax,%eax
  801666:	75 dd                	jne    801645 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801679:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80167f:	eb 2a                	jmp    8016ab <memcmp+0x3e>
		if (*s1 != *s2)
  801681:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801684:	8a 10                	mov    (%eax),%dl
  801686:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	38 c2                	cmp    %al,%dl
  80168d:	74 16                	je     8016a5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80168f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	0f b6 d0             	movzbl %al,%edx
  801697:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169a:	8a 00                	mov    (%eax),%al
  80169c:	0f b6 c0             	movzbl %al,%eax
  80169f:	29 c2                	sub    %eax,%edx
  8016a1:	89 d0                	mov    %edx,%eax
  8016a3:	eb 18                	jmp    8016bd <memcmp+0x50>
		s1++, s2++;
  8016a5:	ff 45 fc             	incl   -0x4(%ebp)
  8016a8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	75 c9                	jne    801681 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cb:	01 d0                	add    %edx,%eax
  8016cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016d0:	eb 15                	jmp    8016e7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	0f b6 d0             	movzbl %al,%edx
  8016da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dd:	0f b6 c0             	movzbl %al,%eax
  8016e0:	39 c2                	cmp    %eax,%edx
  8016e2:	74 0d                	je     8016f1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016e4:	ff 45 08             	incl   0x8(%ebp)
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016ed:	72 e3                	jb     8016d2 <memfind+0x13>
  8016ef:	eb 01                	jmp    8016f2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016f1:	90                   	nop
	return (void *) s;
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801704:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80170b:	eb 03                	jmp    801710 <strtol+0x19>
		s++;
  80170d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	8a 00                	mov    (%eax),%al
  801715:	3c 20                	cmp    $0x20,%al
  801717:	74 f4                	je     80170d <strtol+0x16>
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	8a 00                	mov    (%eax),%al
  80171e:	3c 09                	cmp    $0x9,%al
  801720:	74 eb                	je     80170d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	8a 00                	mov    (%eax),%al
  801727:	3c 2b                	cmp    $0x2b,%al
  801729:	75 05                	jne    801730 <strtol+0x39>
		s++;
  80172b:	ff 45 08             	incl   0x8(%ebp)
  80172e:	eb 13                	jmp    801743 <strtol+0x4c>
	else if (*s == '-')
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8a 00                	mov    (%eax),%al
  801735:	3c 2d                	cmp    $0x2d,%al
  801737:	75 0a                	jne    801743 <strtol+0x4c>
		s++, neg = 1;
  801739:	ff 45 08             	incl   0x8(%ebp)
  80173c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801743:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801747:	74 06                	je     80174f <strtol+0x58>
  801749:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80174d:	75 20                	jne    80176f <strtol+0x78>
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	3c 30                	cmp    $0x30,%al
  801756:	75 17                	jne    80176f <strtol+0x78>
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	40                   	inc    %eax
  80175c:	8a 00                	mov    (%eax),%al
  80175e:	3c 78                	cmp    $0x78,%al
  801760:	75 0d                	jne    80176f <strtol+0x78>
		s += 2, base = 16;
  801762:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801766:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80176d:	eb 28                	jmp    801797 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80176f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801773:	75 15                	jne    80178a <strtol+0x93>
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	3c 30                	cmp    $0x30,%al
  80177c:	75 0c                	jne    80178a <strtol+0x93>
		s++, base = 8;
  80177e:	ff 45 08             	incl   0x8(%ebp)
  801781:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801788:	eb 0d                	jmp    801797 <strtol+0xa0>
	else if (base == 0)
  80178a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80178e:	75 07                	jne    801797 <strtol+0xa0>
		base = 10;
  801790:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	3c 2f                	cmp    $0x2f,%al
  80179e:	7e 19                	jle    8017b9 <strtol+0xc2>
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	8a 00                	mov    (%eax),%al
  8017a5:	3c 39                	cmp    $0x39,%al
  8017a7:	7f 10                	jg     8017b9 <strtol+0xc2>
			dig = *s - '0';
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	8a 00                	mov    (%eax),%al
  8017ae:	0f be c0             	movsbl %al,%eax
  8017b1:	83 e8 30             	sub    $0x30,%eax
  8017b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017b7:	eb 42                	jmp    8017fb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8a 00                	mov    (%eax),%al
  8017be:	3c 60                	cmp    $0x60,%al
  8017c0:	7e 19                	jle    8017db <strtol+0xe4>
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	8a 00                	mov    (%eax),%al
  8017c7:	3c 7a                	cmp    $0x7a,%al
  8017c9:	7f 10                	jg     8017db <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	0f be c0             	movsbl %al,%eax
  8017d3:	83 e8 57             	sub    $0x57,%eax
  8017d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017d9:	eb 20                	jmp    8017fb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	8a 00                	mov    (%eax),%al
  8017e0:	3c 40                	cmp    $0x40,%al
  8017e2:	7e 39                	jle    80181d <strtol+0x126>
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	8a 00                	mov    (%eax),%al
  8017e9:	3c 5a                	cmp    $0x5a,%al
  8017eb:	7f 30                	jg     80181d <strtol+0x126>
			dig = *s - 'A' + 10;
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	8a 00                	mov    (%eax),%al
  8017f2:	0f be c0             	movsbl %al,%eax
  8017f5:	83 e8 37             	sub    $0x37,%eax
  8017f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fe:	3b 45 10             	cmp    0x10(%ebp),%eax
  801801:	7d 19                	jge    80181c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801803:	ff 45 08             	incl   0x8(%ebp)
  801806:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801809:	0f af 45 10          	imul   0x10(%ebp),%eax
  80180d:	89 c2                	mov    %eax,%edx
  80180f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801817:	e9 7b ff ff ff       	jmp    801797 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80181c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80181d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801821:	74 08                	je     80182b <strtol+0x134>
		*endptr = (char *) s;
  801823:	8b 45 0c             	mov    0xc(%ebp),%eax
  801826:	8b 55 08             	mov    0x8(%ebp),%edx
  801829:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80182b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80182f:	74 07                	je     801838 <strtol+0x141>
  801831:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801834:	f7 d8                	neg    %eax
  801836:	eb 03                	jmp    80183b <strtol+0x144>
  801838:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <ltostr>:

void
ltostr(long value, char *str)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801843:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80184a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801851:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801855:	79 13                	jns    80186a <ltostr+0x2d>
	{
		neg = 1;
  801857:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80185e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801861:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801864:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801867:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801872:	99                   	cltd   
  801873:	f7 f9                	idiv   %ecx
  801875:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801878:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187b:	8d 50 01             	lea    0x1(%eax),%edx
  80187e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801881:	89 c2                	mov    %eax,%edx
  801883:	8b 45 0c             	mov    0xc(%ebp),%eax
  801886:	01 d0                	add    %edx,%eax
  801888:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80188b:	83 c2 30             	add    $0x30,%edx
  80188e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801890:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801893:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801898:	f7 e9                	imul   %ecx
  80189a:	c1 fa 02             	sar    $0x2,%edx
  80189d:	89 c8                	mov    %ecx,%eax
  80189f:	c1 f8 1f             	sar    $0x1f,%eax
  8018a2:	29 c2                	sub    %eax,%edx
  8018a4:	89 d0                	mov    %edx,%eax
  8018a6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ad:	75 bb                	jne    80186a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b9:	48                   	dec    %eax
  8018ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018c1:	74 3d                	je     801900 <ltostr+0xc3>
		start = 1 ;
  8018c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018ca:	eb 34                	jmp    801900 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d2:	01 d0                	add    %edx,%eax
  8018d4:	8a 00                	mov    (%eax),%al
  8018d6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018df:	01 c2                	add    %eax,%edx
  8018e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e7:	01 c8                	add    %ecx,%eax
  8018e9:	8a 00                	mov    (%eax),%al
  8018eb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	01 c2                	add    %eax,%edx
  8018f5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018f8:	88 02                	mov    %al,(%edx)
		start++ ;
  8018fa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018fd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801903:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801906:	7c c4                	jl     8018cc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801908:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80190b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190e:	01 d0                	add    %edx,%eax
  801910:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801913:	90                   	nop
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80191c:	ff 75 08             	pushl  0x8(%ebp)
  80191f:	e8 c4 f9 ff ff       	call   8012e8 <strlen>
  801924:	83 c4 04             	add    $0x4,%esp
  801927:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	e8 b6 f9 ff ff       	call   8012e8 <strlen>
  801932:	83 c4 04             	add    $0x4,%esp
  801935:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801938:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80193f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801946:	eb 17                	jmp    80195f <strcconcat+0x49>
		final[s] = str1[s] ;
  801948:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80194b:	8b 45 10             	mov    0x10(%ebp),%eax
  80194e:	01 c2                	add    %eax,%edx
  801950:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	01 c8                	add    %ecx,%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80195c:	ff 45 fc             	incl   -0x4(%ebp)
  80195f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801965:	7c e1                	jl     801948 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801967:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80196e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801975:	eb 1f                	jmp    801996 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801977:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197a:	8d 50 01             	lea    0x1(%eax),%edx
  80197d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801980:	89 c2                	mov    %eax,%edx
  801982:	8b 45 10             	mov    0x10(%ebp),%eax
  801985:	01 c2                	add    %eax,%edx
  801987:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80198a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198d:	01 c8                	add    %ecx,%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801993:	ff 45 f8             	incl   -0x8(%ebp)
  801996:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801999:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80199c:	7c d9                	jl     801977 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80199e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a4:	01 d0                	add    %edx,%eax
  8019a6:	c6 00 00             	movb   $0x0,(%eax)
}
  8019a9:	90                   	nop
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019af:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bb:	8b 00                	mov    (%eax),%eax
  8019bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c7:	01 d0                	add    %edx,%eax
  8019c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019cf:	eb 0c                	jmp    8019dd <strsplit+0x31>
			*string++ = 0;
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	8d 50 01             	lea    0x1(%eax),%edx
  8019d7:	89 55 08             	mov    %edx,0x8(%ebp)
  8019da:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	8a 00                	mov    (%eax),%al
  8019e2:	84 c0                	test   %al,%al
  8019e4:	74 18                	je     8019fe <strsplit+0x52>
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8a 00                	mov    (%eax),%al
  8019eb:	0f be c0             	movsbl %al,%eax
  8019ee:	50                   	push   %eax
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	e8 83 fa ff ff       	call   80147a <strchr>
  8019f7:	83 c4 08             	add    $0x8,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	75 d3                	jne    8019d1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	8a 00                	mov    (%eax),%al
  801a03:	84 c0                	test   %al,%al
  801a05:	74 5a                	je     801a61 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a07:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0a:	8b 00                	mov    (%eax),%eax
  801a0c:	83 f8 0f             	cmp    $0xf,%eax
  801a0f:	75 07                	jne    801a18 <strsplit+0x6c>
		{
			return 0;
  801a11:	b8 00 00 00 00       	mov    $0x0,%eax
  801a16:	eb 66                	jmp    801a7e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a18:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1b:	8b 00                	mov    (%eax),%eax
  801a1d:	8d 48 01             	lea    0x1(%eax),%ecx
  801a20:	8b 55 14             	mov    0x14(%ebp),%edx
  801a23:	89 0a                	mov    %ecx,(%edx)
  801a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2f:	01 c2                	add    %eax,%edx
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a36:	eb 03                	jmp    801a3b <strsplit+0x8f>
			string++;
  801a38:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	8a 00                	mov    (%eax),%al
  801a40:	84 c0                	test   %al,%al
  801a42:	74 8b                	je     8019cf <strsplit+0x23>
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8a 00                	mov    (%eax),%al
  801a49:	0f be c0             	movsbl %al,%eax
  801a4c:	50                   	push   %eax
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	e8 25 fa ff ff       	call   80147a <strchr>
  801a55:	83 c4 08             	add    $0x8,%esp
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	74 dc                	je     801a38 <strsplit+0x8c>
			string++;
	}
  801a5c:	e9 6e ff ff ff       	jmp    8019cf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a61:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a62:	8b 45 14             	mov    0x14(%ebp),%eax
  801a65:	8b 00                	mov    (%eax),%eax
  801a67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a71:	01 d0                	add    %edx,%eax
  801a73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a79:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a93:	eb 4a                	jmp    801adf <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	01 c2                	add    %eax,%edx
  801a9d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa3:	01 c8                	add    %ecx,%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801aa9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	8a 00                	mov    (%eax),%al
  801ab3:	3c 40                	cmp    $0x40,%al
  801ab5:	7e 25                	jle    801adc <str2lower+0x5c>
  801ab7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abd:	01 d0                	add    %edx,%eax
  801abf:	8a 00                	mov    (%eax),%al
  801ac1:	3c 5a                	cmp    $0x5a,%al
  801ac3:	7f 17                	jg     801adc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ac5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	01 d0                	add    %edx,%eax
  801acd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ad0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ad3:	01 ca                	add    %ecx,%edx
  801ad5:	8a 12                	mov    (%edx),%dl
  801ad7:	83 c2 20             	add    $0x20,%edx
  801ada:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801adc:	ff 45 fc             	incl   -0x4(%ebp)
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	e8 01 f8 ff ff       	call   8012e8 <strlen>
  801ae7:	83 c4 04             	add    $0x4,%esp
  801aea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801aed:	7f a6                	jg     801a95 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801aef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801afa:	a1 08 60 80 00       	mov    0x806008,%eax
  801aff:	85 c0                	test   %eax,%eax
  801b01:	74 42                	je     801b45 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b03:	83 ec 08             	sub    $0x8,%esp
  801b06:	68 00 00 00 82       	push   $0x82000000
  801b0b:	68 00 00 00 80       	push   $0x80000000
  801b10:	e8 b0 1e 00 00       	call   8039c5 <initialize_dynamic_allocator>
  801b15:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b18:	e8 96 1c 00 00       	call   8037b3 <sys_get_uheap_strategy>
  801b1d:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b22:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801b27:	05 00 10 00 00       	add    $0x1000,%eax
  801b2c:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801b31:	a1 30 61 83 00       	mov    0x836130,%eax
  801b36:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  801b3b:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801b42:	00 00 00 
	}
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b5c:	83 ec 08             	sub    $0x8,%esp
  801b5f:	68 06 04 00 00       	push   $0x406
  801b64:	50                   	push   %eax
  801b65:	e8 93 18 00 00       	call   8033fd <__sys_allocate_page>
  801b6a:	83 c4 10             	add    $0x10,%esp
  801b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801b70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b74:	79 14                	jns    801b8a <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	68 28 4f 80 00       	push   $0x804f28
  801b7e:	6a 1f                	push   $0x1f
  801b80:	68 64 4f 80 00       	push   $0x804f64
  801b85:	e8 b7 ed ff ff       	call   800941 <_panic>
	return 0;
  801b8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ba5:	83 ec 0c             	sub    $0xc,%esp
  801ba8:	50                   	push   %eax
  801ba9:	e8 96 18 00 00       	call   803444 <__sys_unmap_frame>
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bb8:	79 14                	jns    801bce <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	68 70 4f 80 00       	push   $0x804f70
  801bc2:	6a 2a                	push   $0x2a
  801bc4:	68 64 4f 80 00       	push   $0x804f64
  801bc9:	e8 73 ed ff ff       	call   800941 <_panic>
}
  801bce:	90                   	nop
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801bd7:	e8 18 ff ff ff       	call   801af4 <uheap_init>
	if (size == 0) return NULL ;
  801bdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be0:	75 0a                	jne    801bec <malloc+0x1b>
  801be2:	b8 00 00 00 00       	mov    $0x0,%eax
  801be7:	e9 43 03 00 00       	jmp    801f2f <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801bec:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801bf3:	77 13                	ja     801c08 <malloc+0x37>
    {
        return alloc_block(size);
  801bf5:	83 ec 0c             	sub    $0xc,%esp
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	e8 78 20 00 00       	call   803c78 <alloc_block>
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	e9 27 03 00 00       	jmp    801f2f <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  801c08:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  801c12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c15:	01 d0                	add    %edx,%eax
  801c17:	48                   	dec    %eax
  801c18:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c23:	f7 75 dc             	divl   -0x24(%ebp)
  801c26:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c29:	29 d0                	sub    %edx,%eax
  801c2b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  801c2e:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801c33:	85 c0                	test   %eax,%eax
  801c35:	75 0a                	jne    801c41 <malloc+0x70>
    {
        uhp_inited = 1;
  801c37:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  801c3e:	00 00 00 
    }

    int exactIdx = -1;
  801c41:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801c48:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801c4f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801c56:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801c5d:	e9 85 00 00 00       	jmp    801ce7 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801c62:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c65:	89 d0                	mov    %edx,%eax
  801c67:	01 c0                	add    %eax,%eax
  801c69:	01 d0                	add    %edx,%eax
  801c6b:	c1 e0 02             	shl    $0x2,%eax
  801c6e:	05 48 20 81 00       	add    $0x812048,%eax
  801c73:	8a 00                	mov    (%eax),%al
  801c75:	84 c0                	test   %al,%al
  801c77:	74 20                	je     801c99 <malloc+0xc8>
  801c79:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c7c:	89 d0                	mov    %edx,%eax
  801c7e:	01 c0                	add    %eax,%eax
  801c80:	01 d0                	add    %edx,%eax
  801c82:	c1 e0 02             	shl    $0x2,%eax
  801c85:	05 44 20 81 00       	add    $0x812044,%eax
  801c8a:	8b 00                	mov    (%eax),%eax
  801c8c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c8f:	75 08                	jne    801c99 <malloc+0xc8>
        {
            exactIdx = i;
  801c91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801c97:	eb 5b                	jmp    801cf4 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  801c99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c9c:	89 d0                	mov    %edx,%eax
  801c9e:	01 c0                	add    %eax,%eax
  801ca0:	01 d0                	add    %edx,%eax
  801ca2:	c1 e0 02             	shl    $0x2,%eax
  801ca5:	05 48 20 81 00       	add    $0x812048,%eax
  801caa:	8a 00                	mov    (%eax),%al
  801cac:	84 c0                	test   %al,%al
  801cae:	74 34                	je     801ce4 <malloc+0x113>
  801cb0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801cb3:	89 d0                	mov    %edx,%eax
  801cb5:	01 c0                	add    %eax,%eax
  801cb7:	01 d0                	add    %edx,%eax
  801cb9:	c1 e0 02             	shl    $0x2,%eax
  801cbc:	05 44 20 81 00       	add    $0x812044,%eax
  801cc1:	8b 00                	mov    (%eax),%eax
  801cc3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801cc6:	76 1c                	jbe    801ce4 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  801cc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ccb:	89 d0                	mov    %edx,%eax
  801ccd:	01 c0                	add    %eax,%eax
  801ccf:	01 d0                	add    %edx,%eax
  801cd1:	c1 e0 02             	shl    $0x2,%eax
  801cd4:	05 44 20 81 00       	add    $0x812044,%eax
  801cd9:	8b 00                	mov    (%eax),%eax
  801cdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  801cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801ce4:	ff 45 e8             	incl   -0x18(%ebp)
  801ce7:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  801cee:	0f 8e 6e ff ff ff    	jle    801c62 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  801cf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  801cfb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  801cff:	74 7d                	je     801d7e <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  801d01:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801d08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	01 c0                	add    %eax,%eax
  801d0f:	01 d0                	add    %edx,%eax
  801d11:	c1 e0 02             	shl    $0x2,%eax
  801d14:	05 40 20 81 00       	add    $0x812040,%eax
  801d19:	8b 10                	mov    (%eax),%edx
  801d1b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d1e:	01 d0                	add    %edx,%eax
  801d20:	48                   	dec    %eax
  801d21:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801d24:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d27:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2c:	f7 75 bc             	divl   -0x44(%ebp)
  801d2f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d32:	29 d0                	sub    %edx,%eax
  801d34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801d37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3a:	89 d0                	mov    %edx,%eax
  801d3c:	01 c0                	add    %eax,%eax
  801d3e:	01 d0                	add    %edx,%eax
  801d40:	c1 e0 02             	shl    $0x2,%eax
  801d43:	05 48 20 81 00       	add    $0x812048,%eax
  801d48:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801d4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4e:	89 d0                	mov    %edx,%eax
  801d50:	01 c0                	add    %eax,%eax
  801d52:	01 d0                	add    %edx,%eax
  801d54:	c1 e0 02             	shl    $0x2,%eax
  801d57:	05 44 20 81 00       	add    $0x812044,%eax
  801d5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d65:	89 d0                	mov    %edx,%eax
  801d67:	01 c0                	add    %eax,%eax
  801d69:	01 d0                	add    %edx,%eax
  801d6b:	c1 e0 02             	shl    $0x2,%eax
  801d6e:	05 40 20 81 00       	add    $0x812040,%eax
  801d73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d79:	e9 2d 01 00 00       	jmp    801eab <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801d7e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d82:	0f 84 ce 00 00 00    	je     801e56 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801d88:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801d8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d92:	89 d0                	mov    %edx,%eax
  801d94:	01 c0                	add    %eax,%eax
  801d96:	01 d0                	add    %edx,%eax
  801d98:	c1 e0 02             	shl    $0x2,%eax
  801d9b:	05 40 20 81 00       	add    $0x812040,%eax
  801da0:	8b 10                	mov    (%eax),%edx
  801da2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801da5:	01 d0                	add    %edx,%eax
  801da7:	48                   	dec    %eax
  801da8:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801dab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801dae:	ba 00 00 00 00       	mov    $0x0,%edx
  801db3:	f7 75 c4             	divl   -0x3c(%ebp)
  801db6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801db9:	29 d0                	sub    %edx,%eax
  801dbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801dbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dc1:	89 d0                	mov    %edx,%eax
  801dc3:	01 c0                	add    %eax,%eax
  801dc5:	01 d0                	add    %edx,%eax
  801dc7:	c1 e0 02             	shl    $0x2,%eax
  801dca:	05 44 20 81 00       	add    $0x812044,%eax
  801dcf:	8b 00                	mov    (%eax),%eax
  801dd1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801dd4:	75 47                	jne    801e1d <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801dd6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dd9:	89 d0                	mov    %edx,%eax
  801ddb:	01 c0                	add    %eax,%eax
  801ddd:	01 d0                	add    %edx,%eax
  801ddf:	c1 e0 02             	shl    $0x2,%eax
  801de2:	05 48 20 81 00       	add    $0x812048,%eax
  801de7:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801dea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ded:	89 d0                	mov    %edx,%eax
  801def:	01 c0                	add    %eax,%eax
  801df1:	01 d0                	add    %edx,%eax
  801df3:	c1 e0 02             	shl    $0x2,%eax
  801df6:	05 44 20 81 00       	add    $0x812044,%eax
  801dfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801e01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e04:	89 d0                	mov    %edx,%eax
  801e06:	01 c0                	add    %eax,%eax
  801e08:	01 d0                	add    %edx,%eax
  801e0a:	c1 e0 02             	shl    $0x2,%eax
  801e0d:	05 40 20 81 00       	add    $0x812040,%eax
  801e12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e18:	e9 8e 00 00 00       	jmp    801eab <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801e1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e23:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801e26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e29:	89 d0                	mov    %edx,%eax
  801e2b:	01 c0                	add    %eax,%eax
  801e2d:	01 d0                	add    %edx,%eax
  801e2f:	c1 e0 02             	shl    $0x2,%eax
  801e32:	05 40 20 81 00       	add    $0x812040,%eax
  801e37:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801e3f:	89 c2                	mov    %eax,%edx
  801e41:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e44:	89 c8                	mov    %ecx,%eax
  801e46:	01 c0                	add    %eax,%eax
  801e48:	01 c8                	add    %ecx,%eax
  801e4a:	c1 e0 02             	shl    $0x2,%eax
  801e4d:	05 44 20 81 00       	add    $0x812044,%eax
  801e52:	89 10                	mov    %edx,(%eax)
  801e54:	eb 55                	jmp    801eab <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801e56:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801e5d:	8b 15 88 60 83 00    	mov    0x836088,%edx
  801e63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e66:	01 d0                	add    %edx,%eax
  801e68:	48                   	dec    %eax
  801e69:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e74:	f7 75 d0             	divl   -0x30(%ebp)
  801e77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e7a:	29 d0                	sub    %edx,%eax
  801e7c:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801e7f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801e82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e85:	01 d0                	add    %edx,%eax
  801e87:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801e8c:	76 0a                	jbe    801e98 <malloc+0x2c7>
            return NULL;
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e93:	e9 97 00 00 00       	jmp    801f2f <malloc+0x35e>
        va = start;
  801e98:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801e9e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801ea1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ea4:	01 d0                	add    %edx,%eax
  801ea6:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801eab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801eb2:	eb 5e                	jmp    801f12 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801eb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eb7:	89 d0                	mov    %edx,%eax
  801eb9:	01 c0                	add    %eax,%eax
  801ebb:	01 d0                	add    %edx,%eax
  801ebd:	c1 e0 02             	shl    $0x2,%eax
  801ec0:	05 48 60 80 00       	add    $0x806048,%eax
  801ec5:	8a 00                	mov    (%eax),%al
  801ec7:	84 c0                	test   %al,%al
  801ec9:	75 44                	jne    801f0f <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801ecb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ece:	89 d0                	mov    %edx,%eax
  801ed0:	01 c0                	add    %eax,%eax
  801ed2:	01 d0                	add    %edx,%eax
  801ed4:	c1 e0 02             	shl    $0x2,%eax
  801ed7:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801edd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ee0:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801ee2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ee5:	89 d0                	mov    %edx,%eax
  801ee7:	01 c0                	add    %eax,%eax
  801ee9:	01 d0                	add    %edx,%eax
  801eeb:	c1 e0 02             	shl    $0x2,%eax
  801eee:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801ef4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ef7:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801ef9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801efc:	89 d0                	mov    %edx,%eax
  801efe:	01 c0                	add    %eax,%eax
  801f00:	01 d0                	add    %edx,%eax
  801f02:	c1 e0 02             	shl    $0x2,%eax
  801f05:	05 48 60 80 00       	add    $0x806048,%eax
  801f0a:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801f0d:	eb 0c                	jmp    801f1b <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801f0f:	ff 45 e0             	incl   -0x20(%ebp)
  801f12:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f19:	7e 99                	jle    801eb4 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801f1b:	83 ec 08             	sub    $0x8,%esp
  801f1e:	ff 75 d4             	pushl  -0x2c(%ebp)
  801f21:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f24:	e8 a2 19 00 00       	call   8038cb <sys_allocate_user_mem>
  801f29:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801f2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801f37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f3b:	0f 84 fa 03 00 00    	je     80233b <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801f47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	79 1c                	jns    801f6a <free+0x39>
  801f4e:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801f55:	77 13                	ja     801f6a <free+0x39>
    {
        free_block(virtual_address);
  801f57:	83 ec 0c             	sub    $0xc,%esp
  801f5a:	ff 75 08             	pushl  0x8(%ebp)
  801f5d:	e8 09 21 00 00       	call   80406b <free_block>
  801f62:	83 c4 10             	add    $0x10,%esp
        return;
  801f65:	e9 d2 03 00 00       	jmp    80233c <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801f6a:	a1 30 61 83 00       	mov    0x836130,%eax
  801f6f:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801f72:	72 09                	jb     801f7d <free+0x4c>
  801f74:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801f7b:	76 17                	jbe    801f94 <free+0x63>
        panic("free: invalid address");
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	68 ad 4f 80 00       	push   $0x804fad
  801f85:	68 9b 00 00 00       	push   $0x9b
  801f8a:	68 64 4f 80 00       	push   $0x804f64
  801f8f:	e8 ad e9 ff ff       	call   800941 <_panic>

    uint32 size = 0;
  801f94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801f9b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fa2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801fa9:	eb 50                	jmp    801ffb <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801fab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fae:	89 d0                	mov    %edx,%eax
  801fb0:	01 c0                	add    %eax,%eax
  801fb2:	01 d0                	add    %edx,%eax
  801fb4:	c1 e0 02             	shl    $0x2,%eax
  801fb7:	05 48 60 80 00       	add    $0x806048,%eax
  801fbc:	8a 00                	mov    (%eax),%al
  801fbe:	84 c0                	test   %al,%al
  801fc0:	74 36                	je     801ff8 <free+0xc7>
  801fc2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fc5:	89 d0                	mov    %edx,%eax
  801fc7:	01 c0                	add    %eax,%eax
  801fc9:	01 d0                	add    %edx,%eax
  801fcb:	c1 e0 02             	shl    $0x2,%eax
  801fce:	05 40 60 80 00       	add    $0x806040,%eax
  801fd3:	8b 00                	mov    (%eax),%eax
  801fd5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801fd8:	75 1e                	jne    801ff8 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801fda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fdd:	89 d0                	mov    %edx,%eax
  801fdf:	01 c0                	add    %eax,%eax
  801fe1:	01 d0                	add    %edx,%eax
  801fe3:	c1 e0 02             	shl    $0x2,%eax
  801fe6:	05 44 60 80 00       	add    $0x806044,%eax
  801feb:	8b 00                	mov    (%eax),%eax
  801fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801ff6:	eb 0c                	jmp    802004 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ff8:	ff 45 ec             	incl   -0x14(%ebp)
  801ffb:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802002:	7e a7                	jle    801fab <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  802004:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802008:	74 06                	je     802010 <free+0xdf>
  80200a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200e:	75 17                	jne    802027 <free+0xf6>
        panic("free: unknown block");
  802010:	83 ec 04             	sub    $0x4,%esp
  802013:	68 c3 4f 80 00       	push   $0x804fc3
  802018:	68 a9 00 00 00       	push   $0xa9
  80201d:	68 64 4f 80 00       	push   $0x804f64
  802022:	e8 1a e9 ff ff       	call   800941 <_panic>

    uhp_allocs[idx].used = 0;
  802027:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80202a:	89 d0                	mov    %edx,%eax
  80202c:	01 c0                	add    %eax,%eax
  80202e:	01 d0                	add    %edx,%eax
  802030:	c1 e0 02             	shl    $0x2,%eax
  802033:	05 48 60 80 00       	add    $0x806048,%eax
  802038:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  80203b:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802049:	eb 64                	jmp    8020af <free+0x17e>
    {
        if (!uhp_frees[i].free)
  80204b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80204e:	89 d0                	mov    %edx,%eax
  802050:	01 c0                	add    %eax,%eax
  802052:	01 d0                	add    %edx,%eax
  802054:	c1 e0 02             	shl    $0x2,%eax
  802057:	05 48 20 81 00       	add    $0x812048,%eax
  80205c:	8a 00                	mov    (%eax),%al
  80205e:	84 c0                	test   %al,%al
  802060:	75 4a                	jne    8020ac <free+0x17b>
        {
            uhp_frees[i].va = va;
  802062:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802065:	89 d0                	mov    %edx,%eax
  802067:	01 c0                	add    %eax,%eax
  802069:	01 d0                	add    %edx,%eax
  80206b:	c1 e0 02             	shl    $0x2,%eax
  80206e:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802077:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  802079:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80207c:	89 d0                	mov    %edx,%eax
  80207e:	01 c0                	add    %eax,%eax
  802080:	01 d0                	add    %edx,%eax
  802082:	c1 e0 02             	shl    $0x2,%eax
  802085:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  80208b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208e:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  802090:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802093:	89 d0                	mov    %edx,%eax
  802095:	01 c0                	add    %eax,%eax
  802097:	01 d0                	add    %edx,%eax
  802099:	c1 e0 02             	shl    $0x2,%eax
  80209c:	05 48 20 81 00       	add    $0x812048,%eax
  8020a1:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  8020a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  8020aa:	eb 0c                	jmp    8020b8 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020ac:	ff 45 e4             	incl   -0x1c(%ebp)
  8020af:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  8020b6:	7e 93                	jle    80204b <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  8020b8:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  8020bc:	0f 84 f1 01 00 00    	je     8022b3 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8020c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8020c9:	e9 d8 01 00 00       	jmp    8022a6 <free+0x375>
        {
            if (i == fidx) continue;
  8020ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020d1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8020d4:	0f 84 c8 01 00 00    	je     8022a2 <free+0x371>
            if (uhp_frees[i].free)
  8020da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020dd:	89 d0                	mov    %edx,%eax
  8020df:	01 c0                	add    %eax,%eax
  8020e1:	01 d0                	add    %edx,%eax
  8020e3:	c1 e0 02             	shl    $0x2,%eax
  8020e6:	05 48 20 81 00       	add    $0x812048,%eax
  8020eb:	8a 00                	mov    (%eax),%al
  8020ed:	84 c0                	test   %al,%al
  8020ef:	0f 84 ae 01 00 00    	je     8022a3 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  8020f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020f8:	89 d0                	mov    %edx,%eax
  8020fa:	01 c0                	add    %eax,%eax
  8020fc:	01 d0                	add    %edx,%eax
  8020fe:	c1 e0 02             	shl    $0x2,%eax
  802101:	05 40 20 81 00       	add    $0x812040,%eax
  802106:	8b 08                	mov    (%eax),%ecx
  802108:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80210b:	89 d0                	mov    %edx,%eax
  80210d:	01 c0                	add    %eax,%eax
  80210f:	01 d0                	add    %edx,%eax
  802111:	c1 e0 02             	shl    $0x2,%eax
  802114:	05 44 20 81 00       	add    $0x812044,%eax
  802119:	8b 00                	mov    (%eax),%eax
  80211b:	01 c1                	add    %eax,%ecx
  80211d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802120:	89 d0                	mov    %edx,%eax
  802122:	01 c0                	add    %eax,%eax
  802124:	01 d0                	add    %edx,%eax
  802126:	c1 e0 02             	shl    $0x2,%eax
  802129:	05 40 20 81 00       	add    $0x812040,%eax
  80212e:	8b 00                	mov    (%eax),%eax
  802130:	39 c1                	cmp    %eax,%ecx
  802132:	0f 85 a8 00 00 00    	jne    8021e0 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  802138:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80213b:	89 d0                	mov    %edx,%eax
  80213d:	01 c0                	add    %eax,%eax
  80213f:	01 d0                	add    %edx,%eax
  802141:	c1 e0 02             	shl    $0x2,%eax
  802144:	05 40 20 81 00       	add    $0x812040,%eax
  802149:	8b 10                	mov    (%eax),%edx
  80214b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80214e:	89 c8                	mov    %ecx,%eax
  802150:	01 c0                	add    %eax,%eax
  802152:	01 c8                	add    %ecx,%eax
  802154:	c1 e0 02             	shl    $0x2,%eax
  802157:	05 40 20 81 00       	add    $0x812040,%eax
  80215c:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  80215e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802161:	89 d0                	mov    %edx,%eax
  802163:	01 c0                	add    %eax,%eax
  802165:	01 d0                	add    %edx,%eax
  802167:	c1 e0 02             	shl    $0x2,%eax
  80216a:	05 44 20 81 00       	add    $0x812044,%eax
  80216f:	8b 08                	mov    (%eax),%ecx
  802171:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802174:	89 d0                	mov    %edx,%eax
  802176:	01 c0                	add    %eax,%eax
  802178:	01 d0                	add    %edx,%eax
  80217a:	c1 e0 02             	shl    $0x2,%eax
  80217d:	05 44 20 81 00       	add    $0x812044,%eax
  802182:	8b 00                	mov    (%eax),%eax
  802184:	01 c1                	add    %eax,%ecx
  802186:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802189:	89 d0                	mov    %edx,%eax
  80218b:	01 c0                	add    %eax,%eax
  80218d:	01 d0                	add    %edx,%eax
  80218f:	c1 e0 02             	shl    $0x2,%eax
  802192:	05 44 20 81 00       	add    $0x812044,%eax
  802197:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802199:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80219c:	89 d0                	mov    %edx,%eax
  80219e:	01 c0                	add    %eax,%eax
  8021a0:	01 d0                	add    %edx,%eax
  8021a2:	c1 e0 02             	shl    $0x2,%eax
  8021a5:	05 48 20 81 00       	add    $0x812048,%eax
  8021aa:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  8021ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021b0:	89 d0                	mov    %edx,%eax
  8021b2:	01 c0                	add    %eax,%eax
  8021b4:	01 d0                	add    %edx,%eax
  8021b6:	c1 e0 02             	shl    $0x2,%eax
  8021b9:	05 40 20 81 00       	add    $0x812040,%eax
  8021be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  8021c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021c7:	89 d0                	mov    %edx,%eax
  8021c9:	01 c0                	add    %eax,%eax
  8021cb:	01 d0                	add    %edx,%eax
  8021cd:	c1 e0 02             	shl    $0x2,%eax
  8021d0:	05 44 20 81 00       	add    $0x812044,%eax
  8021d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021db:	e9 c3 00 00 00       	jmp    8022a3 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  8021e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021e3:	89 d0                	mov    %edx,%eax
  8021e5:	01 c0                	add    %eax,%eax
  8021e7:	01 d0                	add    %edx,%eax
  8021e9:	c1 e0 02             	shl    $0x2,%eax
  8021ec:	05 40 20 81 00       	add    $0x812040,%eax
  8021f1:	8b 08                	mov    (%eax),%ecx
  8021f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8021f6:	89 d0                	mov    %edx,%eax
  8021f8:	01 c0                	add    %eax,%eax
  8021fa:	01 d0                	add    %edx,%eax
  8021fc:	c1 e0 02             	shl    $0x2,%eax
  8021ff:	05 44 20 81 00       	add    $0x812044,%eax
  802204:	8b 00                	mov    (%eax),%eax
  802206:	01 c1                	add    %eax,%ecx
  802208:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80220b:	89 d0                	mov    %edx,%eax
  80220d:	01 c0                	add    %eax,%eax
  80220f:	01 d0                	add    %edx,%eax
  802211:	c1 e0 02             	shl    $0x2,%eax
  802214:	05 40 20 81 00       	add    $0x812040,%eax
  802219:	8b 00                	mov    (%eax),%eax
  80221b:	39 c1                	cmp    %eax,%ecx
  80221d:	0f 85 80 00 00 00    	jne    8022a3 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802223:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802226:	89 d0                	mov    %edx,%eax
  802228:	01 c0                	add    %eax,%eax
  80222a:	01 d0                	add    %edx,%eax
  80222c:	c1 e0 02             	shl    $0x2,%eax
  80222f:	05 44 20 81 00       	add    $0x812044,%eax
  802234:	8b 08                	mov    (%eax),%ecx
  802236:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802239:	89 d0                	mov    %edx,%eax
  80223b:	01 c0                	add    %eax,%eax
  80223d:	01 d0                	add    %edx,%eax
  80223f:	c1 e0 02             	shl    $0x2,%eax
  802242:	05 44 20 81 00       	add    $0x812044,%eax
  802247:	8b 00                	mov    (%eax),%eax
  802249:	01 c1                	add    %eax,%ecx
  80224b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80224e:	89 d0                	mov    %edx,%eax
  802250:	01 c0                	add    %eax,%eax
  802252:	01 d0                	add    %edx,%eax
  802254:	c1 e0 02             	shl    $0x2,%eax
  802257:	05 44 20 81 00       	add    $0x812044,%eax
  80225c:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  80225e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802261:	89 d0                	mov    %edx,%eax
  802263:	01 c0                	add    %eax,%eax
  802265:	01 d0                	add    %edx,%eax
  802267:	c1 e0 02             	shl    $0x2,%eax
  80226a:	05 48 20 81 00       	add    $0x812048,%eax
  80226f:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802272:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802275:	89 d0                	mov    %edx,%eax
  802277:	01 c0                	add    %eax,%eax
  802279:	01 d0                	add    %edx,%eax
  80227b:	c1 e0 02             	shl    $0x2,%eax
  80227e:	05 40 20 81 00       	add    $0x812040,%eax
  802283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802289:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80228c:	89 d0                	mov    %edx,%eax
  80228e:	01 c0                	add    %eax,%eax
  802290:	01 d0                	add    %edx,%eax
  802292:	c1 e0 02             	shl    $0x2,%eax
  802295:	05 44 20 81 00       	add    $0x812044,%eax
  80229a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a0:	eb 01                	jmp    8022a3 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  8022a2:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8022a3:	ff 45 e0             	incl   -0x20(%ebp)
  8022a6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8022ad:	0f 8e 1b fe ff ff    	jle    8020ce <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  8022b3:	a1 30 61 83 00       	mov    0x836130,%eax
  8022b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022bb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8022c2:	eb 53                	jmp    802317 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  8022c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022c7:	89 d0                	mov    %edx,%eax
  8022c9:	01 c0                	add    %eax,%eax
  8022cb:	01 d0                	add    %edx,%eax
  8022cd:	c1 e0 02             	shl    $0x2,%eax
  8022d0:	05 48 60 80 00       	add    $0x806048,%eax
  8022d5:	8a 00                	mov    (%eax),%al
  8022d7:	84 c0                	test   %al,%al
  8022d9:	74 39                	je     802314 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  8022db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022de:	89 d0                	mov    %edx,%eax
  8022e0:	01 c0                	add    %eax,%eax
  8022e2:	01 d0                	add    %edx,%eax
  8022e4:	c1 e0 02             	shl    $0x2,%eax
  8022e7:	05 40 60 80 00       	add    $0x806040,%eax
  8022ec:	8b 08                	mov    (%eax),%ecx
  8022ee:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022f1:	89 d0                	mov    %edx,%eax
  8022f3:	01 c0                	add    %eax,%eax
  8022f5:	01 d0                	add    %edx,%eax
  8022f7:	c1 e0 02             	shl    $0x2,%eax
  8022fa:	05 44 60 80 00       	add    $0x806044,%eax
  8022ff:	8b 00                	mov    (%eax),%eax
  802301:	01 c8                	add    %ecx,%eax
  802303:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  802306:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802309:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80230c:	76 06                	jbe    802314 <free+0x3e3>
  80230e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802311:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802314:	ff 45 d8             	incl   -0x28(%ebp)
  802317:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80231e:	7e a4                	jle    8022c4 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  802320:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802323:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  802328:	83 ec 08             	sub    $0x8,%esp
  80232b:	ff 75 f4             	pushl  -0xc(%ebp)
  80232e:	ff 75 d4             	pushl  -0x2c(%ebp)
  802331:	e8 79 15 00 00       	call   8038af <sys_free_user_mem>
  802336:	83 c4 10             	add    $0x10,%esp
  802339:	eb 01                	jmp    80233c <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  80233b:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 68             	sub    $0x68,%esp
  802344:	8b 45 10             	mov    0x10(%ebp),%eax
  802347:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80234a:	e8 a5 f7 ff ff       	call   801af4 <uheap_init>
	if (size == 0) return NULL ;
  80234f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802353:	75 0a                	jne    80235f <smalloc+0x21>
  802355:	b8 00 00 00 00       	mov    $0x0,%eax
  80235a:	e9 37 03 00 00       	jmp    802696 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  80235f:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802366:	8b 55 0c             	mov    0xc(%ebp),%edx
  802369:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80236c:	01 d0                	add    %edx,%eax
  80236e:	48                   	dec    %eax
  80236f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802372:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802375:	ba 00 00 00 00       	mov    $0x0,%edx
  80237a:	f7 75 dc             	divl   -0x24(%ebp)
  80237d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802380:	29 d0                	sub    %edx,%eax
  802382:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802385:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80238c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802393:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80239a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8023a1:	e9 85 00 00 00       	jmp    80242b <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8023a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023a9:	89 d0                	mov    %edx,%eax
  8023ab:	01 c0                	add    %eax,%eax
  8023ad:	01 d0                	add    %edx,%eax
  8023af:	c1 e0 02             	shl    $0x2,%eax
  8023b2:	05 48 20 81 00       	add    $0x812048,%eax
  8023b7:	8a 00                	mov    (%eax),%al
  8023b9:	84 c0                	test   %al,%al
  8023bb:	74 20                	je     8023dd <smalloc+0x9f>
  8023bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023c0:	89 d0                	mov    %edx,%eax
  8023c2:	01 c0                	add    %eax,%eax
  8023c4:	01 d0                	add    %edx,%eax
  8023c6:	c1 e0 02             	shl    $0x2,%eax
  8023c9:	05 44 20 81 00       	add    $0x812044,%eax
  8023ce:	8b 00                	mov    (%eax),%eax
  8023d0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8023d3:	75 08                	jne    8023dd <smalloc+0x9f>
        {
            exactIdx = i;
  8023d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8023db:	eb 5b                	jmp    802438 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8023dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023e0:	89 d0                	mov    %edx,%eax
  8023e2:	01 c0                	add    %eax,%eax
  8023e4:	01 d0                	add    %edx,%eax
  8023e6:	c1 e0 02             	shl    $0x2,%eax
  8023e9:	05 48 20 81 00       	add    $0x812048,%eax
  8023ee:	8a 00                	mov    (%eax),%al
  8023f0:	84 c0                	test   %al,%al
  8023f2:	74 34                	je     802428 <smalloc+0xea>
  8023f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023f7:	89 d0                	mov    %edx,%eax
  8023f9:	01 c0                	add    %eax,%eax
  8023fb:	01 d0                	add    %edx,%eax
  8023fd:	c1 e0 02             	shl    $0x2,%eax
  802400:	05 44 20 81 00       	add    $0x812044,%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80240a:	76 1c                	jbe    802428 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  80240c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80240f:	89 d0                	mov    %edx,%eax
  802411:	01 c0                	add    %eax,%eax
  802413:	01 d0                	add    %edx,%eax
  802415:	c1 e0 02             	shl    $0x2,%eax
  802418:	05 44 20 81 00       	add    $0x812044,%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802422:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802425:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802428:	ff 45 e8             	incl   -0x18(%ebp)
  80242b:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802432:	0f 8e 6e ff ff ff    	jle    8023a6 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802438:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  80243f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802443:	74 7d                	je     8024c2 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802445:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80244c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244f:	89 d0                	mov    %edx,%eax
  802451:	01 c0                	add    %eax,%eax
  802453:	01 d0                	add    %edx,%eax
  802455:	c1 e0 02             	shl    $0x2,%eax
  802458:	05 40 20 81 00       	add    $0x812040,%eax
  80245d:	8b 10                	mov    (%eax),%edx
  80245f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802462:	01 d0                	add    %edx,%eax
  802464:	48                   	dec    %eax
  802465:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802468:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80246b:	ba 00 00 00 00       	mov    $0x0,%edx
  802470:	f7 75 bc             	divl   -0x44(%ebp)
  802473:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802476:	29 d0                	sub    %edx,%eax
  802478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80247b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247e:	89 d0                	mov    %edx,%eax
  802480:	01 c0                	add    %eax,%eax
  802482:	01 d0                	add    %edx,%eax
  802484:	c1 e0 02             	shl    $0x2,%eax
  802487:	05 48 20 81 00       	add    $0x812048,%eax
  80248c:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  80248f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802492:	89 d0                	mov    %edx,%eax
  802494:	01 c0                	add    %eax,%eax
  802496:	01 d0                	add    %edx,%eax
  802498:	c1 e0 02             	shl    $0x2,%eax
  80249b:	05 44 20 81 00       	add    $0x812044,%eax
  8024a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8024a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a9:	89 d0                	mov    %edx,%eax
  8024ab:	01 c0                	add    %eax,%eax
  8024ad:	01 d0                	add    %edx,%eax
  8024af:	c1 e0 02             	shl    $0x2,%eax
  8024b2:	05 40 20 81 00       	add    $0x812040,%eax
  8024b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bd:	e9 2d 01 00 00       	jmp    8025ef <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  8024c2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8024c6:	0f 84 ce 00 00 00    	je     80259a <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8024cc:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8024d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d6:	89 d0                	mov    %edx,%eax
  8024d8:	01 c0                	add    %eax,%eax
  8024da:	01 d0                	add    %edx,%eax
  8024dc:	c1 e0 02             	shl    $0x2,%eax
  8024df:	05 40 20 81 00       	add    $0x812040,%eax
  8024e4:	8b 10                	mov    (%eax),%edx
  8024e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024e9:	01 d0                	add    %edx,%eax
  8024eb:	48                   	dec    %eax
  8024ec:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8024ef:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f7:	f7 75 c4             	divl   -0x3c(%ebp)
  8024fa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024fd:	29 d0                	sub    %edx,%eax
  8024ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802502:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802505:	89 d0                	mov    %edx,%eax
  802507:	01 c0                	add    %eax,%eax
  802509:	01 d0                	add    %edx,%eax
  80250b:	c1 e0 02             	shl    $0x2,%eax
  80250e:	05 44 20 81 00       	add    $0x812044,%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802518:	75 47                	jne    802561 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80251a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251d:	89 d0                	mov    %edx,%eax
  80251f:	01 c0                	add    %eax,%eax
  802521:	01 d0                	add    %edx,%eax
  802523:	c1 e0 02             	shl    $0x2,%eax
  802526:	05 48 20 81 00       	add    $0x812048,%eax
  80252b:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80252e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802531:	89 d0                	mov    %edx,%eax
  802533:	01 c0                	add    %eax,%eax
  802535:	01 d0                	add    %edx,%eax
  802537:	c1 e0 02             	shl    $0x2,%eax
  80253a:	05 44 20 81 00       	add    $0x812044,%eax
  80253f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802545:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802548:	89 d0                	mov    %edx,%eax
  80254a:	01 c0                	add    %eax,%eax
  80254c:	01 d0                	add    %edx,%eax
  80254e:	c1 e0 02             	shl    $0x2,%eax
  802551:	05 40 20 81 00       	add    $0x812040,%eax
  802556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255c:	e9 8e 00 00 00       	jmp    8025ef <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802561:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802564:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802567:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80256a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80256d:	89 d0                	mov    %edx,%eax
  80256f:	01 c0                	add    %eax,%eax
  802571:	01 d0                	add    %edx,%eax
  802573:	c1 e0 02             	shl    $0x2,%eax
  802576:	05 40 20 81 00       	add    $0x812040,%eax
  80257b:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80257d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802580:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802583:	89 c2                	mov    %eax,%edx
  802585:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802588:	89 c8                	mov    %ecx,%eax
  80258a:	01 c0                	add    %eax,%eax
  80258c:	01 c8                	add    %ecx,%eax
  80258e:	c1 e0 02             	shl    $0x2,%eax
  802591:	05 44 20 81 00       	add    $0x812044,%eax
  802596:	89 10                	mov    %edx,(%eax)
  802598:	eb 55                	jmp    8025ef <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80259a:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8025a1:	8b 15 88 60 83 00    	mov    0x836088,%edx
  8025a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025aa:	01 d0                	add    %edx,%eax
  8025ac:	48                   	dec    %eax
  8025ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8025b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b8:	f7 75 d0             	divl   -0x30(%ebp)
  8025bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025be:	29 d0                	sub    %edx,%eax
  8025c0:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8025c3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8025c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025c9:	01 d0                	add    %edx,%eax
  8025cb:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8025d0:	76 0a                	jbe    8025dc <smalloc+0x29e>
            return NULL;
  8025d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d7:	e9 ba 00 00 00       	jmp    802696 <smalloc+0x358>
        va = start;
  8025dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8025e2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8025e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025e8:	01 d0                	add    %edx,%eax
  8025ea:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8025ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8025f6:	eb 5e                	jmp    802656 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8025f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025fb:	89 d0                	mov    %edx,%eax
  8025fd:	01 c0                	add    %eax,%eax
  8025ff:	01 d0                	add    %edx,%eax
  802601:	c1 e0 02             	shl    $0x2,%eax
  802604:	05 48 60 80 00       	add    $0x806048,%eax
  802609:	8a 00                	mov    (%eax),%al
  80260b:	84 c0                	test   %al,%al
  80260d:	75 44                	jne    802653 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80260f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802612:	89 d0                	mov    %edx,%eax
  802614:	01 c0                	add    %eax,%eax
  802616:	01 d0                	add    %edx,%eax
  802618:	c1 e0 02             	shl    $0x2,%eax
  80261b:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802624:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802626:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802629:	89 d0                	mov    %edx,%eax
  80262b:	01 c0                	add    %eax,%eax
  80262d:	01 d0                	add    %edx,%eax
  80262f:	c1 e0 02             	shl    $0x2,%eax
  802632:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802638:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80263b:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80263d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802640:	89 d0                	mov    %edx,%eax
  802642:	01 c0                	add    %eax,%eax
  802644:	01 d0                	add    %edx,%eax
  802646:	c1 e0 02             	shl    $0x2,%eax
  802649:	05 48 60 80 00       	add    $0x806048,%eax
  80264e:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802651:	eb 0c                	jmp    80265f <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802653:	ff 45 e0             	incl   -0x20(%ebp)
  802656:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80265d:	7e 99                	jle    8025f8 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80265f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802662:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802666:	52                   	push   %edx
  802667:	50                   	push   %eax
  802668:	ff 75 d4             	pushl  -0x2c(%ebp)
  80266b:	ff 75 08             	pushl  0x8(%ebp)
  80266e:	e8 de 0e 00 00       	call   803551 <sys_create_shared_object>
  802673:	83 c4 10             	add    $0x10,%esp
  802676:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  802679:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80267d:	75 07                	jne    802686 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  80267f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802684:	eb 10                	jmp    802696 <smalloc+0x358>
    if (r < 0)
  802686:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80268a:	79 07                	jns    802693 <smalloc+0x355>
        return NULL;
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
  802691:	eb 03                	jmp    802696 <smalloc+0x358>
    return (void*)va;
  802693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802696:	c9                   	leave  
  802697:	c3                   	ret    

00802698 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
  80269b:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80269e:	e8 51 f4 ff ff       	call   801af4 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8026a3:	83 ec 08             	sub    $0x8,%esp
  8026a6:	ff 75 0c             	pushl  0xc(%ebp)
  8026a9:	ff 75 08             	pushl  0x8(%ebp)
  8026ac:	e8 ca 0e 00 00       	call   80357b <sys_size_of_shared_object>
  8026b1:	83 c4 10             	add    $0x10,%esp
  8026b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8026b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8026bb:	7f 0a                	jg     8026c7 <sget+0x2f>
        return NULL;
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c2:	e9 28 03 00 00       	jmp    8029ef <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8026c7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026d4:	01 d0                	add    %edx,%eax
  8026d6:	48                   	dec    %eax
  8026d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e2:	f7 75 d8             	divl   -0x28(%ebp)
  8026e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e8:	29 d0                	sub    %edx,%eax
  8026ea:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8026ed:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8026f4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8026fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802702:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802709:	e9 85 00 00 00       	jmp    802793 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80270e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802711:	89 d0                	mov    %edx,%eax
  802713:	01 c0                	add    %eax,%eax
  802715:	01 d0                	add    %edx,%eax
  802717:	c1 e0 02             	shl    $0x2,%eax
  80271a:	05 48 20 81 00       	add    $0x812048,%eax
  80271f:	8a 00                	mov    (%eax),%al
  802721:	84 c0                	test   %al,%al
  802723:	74 20                	je     802745 <sget+0xad>
  802725:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802728:	89 d0                	mov    %edx,%eax
  80272a:	01 c0                	add    %eax,%eax
  80272c:	01 d0                	add    %edx,%eax
  80272e:	c1 e0 02             	shl    $0x2,%eax
  802731:	05 44 20 81 00       	add    $0x812044,%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80273b:	75 08                	jne    802745 <sget+0xad>
        {
            exactIdx = i;
  80273d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802740:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802743:	eb 5b                	jmp    8027a0 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802745:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802748:	89 d0                	mov    %edx,%eax
  80274a:	01 c0                	add    %eax,%eax
  80274c:	01 d0                	add    %edx,%eax
  80274e:	c1 e0 02             	shl    $0x2,%eax
  802751:	05 48 20 81 00       	add    $0x812048,%eax
  802756:	8a 00                	mov    (%eax),%al
  802758:	84 c0                	test   %al,%al
  80275a:	74 34                	je     802790 <sget+0xf8>
  80275c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80275f:	89 d0                	mov    %edx,%eax
  802761:	01 c0                	add    %eax,%eax
  802763:	01 d0                	add    %edx,%eax
  802765:	c1 e0 02             	shl    $0x2,%eax
  802768:	05 44 20 81 00       	add    $0x812044,%eax
  80276d:	8b 00                	mov    (%eax),%eax
  80276f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802772:	76 1c                	jbe    802790 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802774:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802777:	89 d0                	mov    %edx,%eax
  802779:	01 c0                	add    %eax,%eax
  80277b:	01 d0                	add    %edx,%eax
  80277d:	c1 e0 02             	shl    $0x2,%eax
  802780:	05 44 20 81 00       	add    $0x812044,%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80278a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802790:	ff 45 e8             	incl   -0x18(%ebp)
  802793:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80279a:	0f 8e 6e ff ff ff    	jle    80270e <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8027a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8027a7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8027ab:	74 7d                	je     80282a <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8027ad:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8027b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b7:	89 d0                	mov    %edx,%eax
  8027b9:	01 c0                	add    %eax,%eax
  8027bb:	01 d0                	add    %edx,%eax
  8027bd:	c1 e0 02             	shl    $0x2,%eax
  8027c0:	05 40 20 81 00       	add    $0x812040,%eax
  8027c5:	8b 10                	mov    (%eax),%edx
  8027c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8027ca:	01 d0                	add    %edx,%eax
  8027cc:	48                   	dec    %eax
  8027cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8027d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d8:	f7 75 b8             	divl   -0x48(%ebp)
  8027db:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8027de:	29 d0                	sub    %edx,%eax
  8027e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8027e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e6:	89 d0                	mov    %edx,%eax
  8027e8:	01 c0                	add    %eax,%eax
  8027ea:	01 d0                	add    %edx,%eax
  8027ec:	c1 e0 02             	shl    $0x2,%eax
  8027ef:	05 48 20 81 00       	add    $0x812048,%eax
  8027f4:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8027f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fa:	89 d0                	mov    %edx,%eax
  8027fc:	01 c0                	add    %eax,%eax
  8027fe:	01 d0                	add    %edx,%eax
  802800:	c1 e0 02             	shl    $0x2,%eax
  802803:	05 44 20 81 00       	add    $0x812044,%eax
  802808:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80280e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802811:	89 d0                	mov    %edx,%eax
  802813:	01 c0                	add    %eax,%eax
  802815:	01 d0                	add    %edx,%eax
  802817:	c1 e0 02             	shl    $0x2,%eax
  80281a:	05 40 20 81 00       	add    $0x812040,%eax
  80281f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802825:	e9 2d 01 00 00       	jmp    802957 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80282a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80282e:	0f 84 ce 00 00 00    	je     802902 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802834:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80283b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283e:	89 d0                	mov    %edx,%eax
  802840:	01 c0                	add    %eax,%eax
  802842:	01 d0                	add    %edx,%eax
  802844:	c1 e0 02             	shl    $0x2,%eax
  802847:	05 40 20 81 00       	add    $0x812040,%eax
  80284c:	8b 10                	mov    (%eax),%edx
  80284e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802851:	01 d0                	add    %edx,%eax
  802853:	48                   	dec    %eax
  802854:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802857:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80285a:	ba 00 00 00 00       	mov    $0x0,%edx
  80285f:	f7 75 c0             	divl   -0x40(%ebp)
  802862:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802865:	29 d0                	sub    %edx,%eax
  802867:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80286a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80286d:	89 d0                	mov    %edx,%eax
  80286f:	01 c0                	add    %eax,%eax
  802871:	01 d0                	add    %edx,%eax
  802873:	c1 e0 02             	shl    $0x2,%eax
  802876:	05 44 20 81 00       	add    $0x812044,%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802880:	75 47                	jne    8028c9 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802882:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802885:	89 d0                	mov    %edx,%eax
  802887:	01 c0                	add    %eax,%eax
  802889:	01 d0                	add    %edx,%eax
  80288b:	c1 e0 02             	shl    $0x2,%eax
  80288e:	05 48 20 81 00       	add    $0x812048,%eax
  802893:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802896:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802899:	89 d0                	mov    %edx,%eax
  80289b:	01 c0                	add    %eax,%eax
  80289d:	01 d0                	add    %edx,%eax
  80289f:	c1 e0 02             	shl    $0x2,%eax
  8028a2:	05 44 20 81 00       	add    $0x812044,%eax
  8028a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8028ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b0:	89 d0                	mov    %edx,%eax
  8028b2:	01 c0                	add    %eax,%eax
  8028b4:	01 d0                	add    %edx,%eax
  8028b6:	c1 e0 02             	shl    $0x2,%eax
  8028b9:	05 40 20 81 00       	add    $0x812040,%eax
  8028be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c4:	e9 8e 00 00 00       	jmp    802957 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8028c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028cf:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8028d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d5:	89 d0                	mov    %edx,%eax
  8028d7:	01 c0                	add    %eax,%eax
  8028d9:	01 d0                	add    %edx,%eax
  8028db:	c1 e0 02             	shl    $0x2,%eax
  8028de:	05 40 20 81 00       	add    $0x812040,%eax
  8028e3:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8028e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e8:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8028eb:	89 c2                	mov    %eax,%edx
  8028ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8028f0:	89 c8                	mov    %ecx,%eax
  8028f2:	01 c0                	add    %eax,%eax
  8028f4:	01 c8                	add    %ecx,%eax
  8028f6:	c1 e0 02             	shl    $0x2,%eax
  8028f9:	05 44 20 81 00       	add    $0x812044,%eax
  8028fe:	89 10                	mov    %edx,(%eax)
  802900:	eb 55                	jmp    802957 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802902:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802909:	8b 15 88 60 83 00    	mov    0x836088,%edx
  80290f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802912:	01 d0                	add    %edx,%eax
  802914:	48                   	dec    %eax
  802915:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802918:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80291b:	ba 00 00 00 00       	mov    $0x0,%edx
  802920:	f7 75 cc             	divl   -0x34(%ebp)
  802923:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802926:	29 d0                	sub    %edx,%eax
  802928:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  80292b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80292e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802931:	01 d0                	add    %edx,%eax
  802933:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802938:	76 0a                	jbe    802944 <sget+0x2ac>
            return NULL;
  80293a:	b8 00 00 00 00       	mov    $0x0,%eax
  80293f:	e9 ab 00 00 00       	jmp    8029ef <sget+0x357>
        va = start;
  802944:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802947:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80294a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80294d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802950:	01 d0                	add    %edx,%eax
  802952:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802957:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80295e:	eb 5e                	jmp    8029be <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802960:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802963:	89 d0                	mov    %edx,%eax
  802965:	01 c0                	add    %eax,%eax
  802967:	01 d0                	add    %edx,%eax
  802969:	c1 e0 02             	shl    $0x2,%eax
  80296c:	05 48 60 80 00       	add    $0x806048,%eax
  802971:	8a 00                	mov    (%eax),%al
  802973:	84 c0                	test   %al,%al
  802975:	75 44                	jne    8029bb <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802977:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80297a:	89 d0                	mov    %edx,%eax
  80297c:	01 c0                	add    %eax,%eax
  80297e:	01 d0                	add    %edx,%eax
  802980:	c1 e0 02             	shl    $0x2,%eax
  802983:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802989:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80298e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802991:	89 d0                	mov    %edx,%eax
  802993:	01 c0                	add    %eax,%eax
  802995:	01 d0                	add    %edx,%eax
  802997:	c1 e0 02             	shl    $0x2,%eax
  80299a:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8029a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029a3:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8029a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029a8:	89 d0                	mov    %edx,%eax
  8029aa:	01 c0                	add    %eax,%eax
  8029ac:	01 d0                	add    %edx,%eax
  8029ae:	c1 e0 02             	shl    $0x2,%eax
  8029b1:	05 48 60 80 00       	add    $0x806048,%eax
  8029b6:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8029b9:	eb 0c                	jmp    8029c7 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029bb:	ff 45 e0             	incl   -0x20(%ebp)
  8029be:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8029c5:	7e 99                	jle    802960 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8029c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ca:	83 ec 04             	sub    $0x4,%esp
  8029cd:	50                   	push   %eax
  8029ce:	ff 75 0c             	pushl  0xc(%ebp)
  8029d1:	ff 75 08             	pushl  0x8(%ebp)
  8029d4:	e8 bf 0b 00 00       	call   803598 <sys_get_shared_object>
  8029d9:	83 c4 10             	add    $0x10,%esp
  8029dc:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8029df:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029e3:	79 07                	jns    8029ec <sget+0x354>
        return NULL;
  8029e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ea:	eb 03                	jmp    8029ef <sget+0x357>
    return (void*)va;
  8029ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8029ef:	c9                   	leave  
  8029f0:	c3                   	ret    

008029f1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8029f1:	55                   	push   %ebp
  8029f2:	89 e5                	mov    %esp,%ebp
  8029f4:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8029f7:	e8 f8 f0 ff ff       	call   801af4 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8029fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a00:	75 13                	jne    802a15 <realloc+0x24>
		return malloc(new_size);
  802a02:	83 ec 0c             	sub    $0xc,%esp
  802a05:	ff 75 0c             	pushl  0xc(%ebp)
  802a08:	e8 c4 f1 ff ff       	call   801bd1 <malloc>
  802a0d:	83 c4 10             	add    $0x10,%esp
  802a10:	e9 f4 05 00 00       	jmp    803009 <realloc+0x618>
	if (new_size == 0)
  802a15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a19:	75 18                	jne    802a33 <realloc+0x42>
	{
		free(virtual_address);
  802a1b:	83 ec 0c             	sub    $0xc,%esp
  802a1e:	ff 75 08             	pushl  0x8(%ebp)
  802a21:	e8 0b f5 ff ff       	call   801f31 <free>
  802a26:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802a29:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2e:	e9 d6 05 00 00       	jmp    803009 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802a39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	79 74                	jns    802ab4 <realloc+0xc3>
  802a40:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802a47:	77 6b                	ja     802ab4 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  802a49:	83 ec 0c             	sub    $0xc,%esp
  802a4c:	ff 75 0c             	pushl  0xc(%ebp)
  802a4f:	e8 7d f1 ff ff       	call   801bd1 <malloc>
  802a54:	83 c4 10             	add    $0x10,%esp
  802a57:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  802a5a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  802a5e:	75 0a                	jne    802a6a <realloc+0x79>
			return NULL;
  802a60:	b8 00 00 00 00       	mov    $0x0,%eax
  802a65:	e9 9f 05 00 00       	jmp    803009 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  802a6a:	83 ec 0c             	sub    $0xc,%esp
  802a6d:	ff 75 08             	pushl  0x8(%ebp)
  802a70:	e8 e0 11 00 00       	call   803c55 <get_block_size>
  802a75:	83 c4 10             	add    $0x10,%esp
  802a78:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  802a7b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a81:	39 d0                	cmp    %edx,%eax
  802a83:	76 02                	jbe    802a87 <realloc+0x96>
  802a85:	89 d0                	mov    %edx,%eax
  802a87:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  802a8a:	83 ec 04             	sub    $0x4,%esp
  802a8d:	ff 75 c0             	pushl  -0x40(%ebp)
  802a90:	ff 75 08             	pushl  0x8(%ebp)
  802a93:	ff 75 c8             	pushl  -0x38(%ebp)
  802a96:	e8 56 eb ff ff       	call   8015f1 <memmove>
  802a9b:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  802a9e:	83 ec 0c             	sub    $0xc,%esp
  802aa1:	ff 75 08             	pushl  0x8(%ebp)
  802aa4:	e8 88 f4 ff ff       	call   801f31 <free>
  802aa9:	83 c4 10             	add    $0x10,%esp
		return newptr;
  802aac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802aaf:	e9 55 05 00 00       	jmp    803009 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  802ab4:	a1 30 61 83 00       	mov    0x836130,%eax
  802ab9:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  802abc:	72 09                	jb     802ac7 <realloc+0xd6>
  802abe:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  802ac5:	76 0a                	jbe    802ad1 <realloc+0xe0>
		return NULL;
  802ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  802acc:	e9 38 05 00 00       	jmp    803009 <realloc+0x618>
	uint32 oldsz = 0;
  802ad1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  802ad8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802adf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802ae6:	eb 50                	jmp    802b38 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802ae8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aeb:	89 d0                	mov    %edx,%eax
  802aed:	01 c0                	add    %eax,%eax
  802aef:	01 d0                	add    %edx,%eax
  802af1:	c1 e0 02             	shl    $0x2,%eax
  802af4:	05 48 60 80 00       	add    $0x806048,%eax
  802af9:	8a 00                	mov    (%eax),%al
  802afb:	84 c0                	test   %al,%al
  802afd:	74 36                	je     802b35 <realloc+0x144>
  802aff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b02:	89 d0                	mov    %edx,%eax
  802b04:	01 c0                	add    %eax,%eax
  802b06:	01 d0                	add    %edx,%eax
  802b08:	c1 e0 02             	shl    $0x2,%eax
  802b0b:	05 40 60 80 00       	add    $0x806040,%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802b15:	75 1e                	jne    802b35 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802b17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1a:	89 d0                	mov    %edx,%eax
  802b1c:	01 c0                	add    %eax,%eax
  802b1e:	01 d0                	add    %edx,%eax
  802b20:	c1 e0 02             	shl    $0x2,%eax
  802b23:	05 44 60 80 00       	add    $0x806044,%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802b33:	eb 0c                	jmp    802b41 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802b35:	ff 45 ec             	incl   -0x14(%ebp)
  802b38:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802b3f:	7e a7                	jle    802ae8 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802b41:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802b45:	75 0a                	jne    802b51 <realloc+0x160>
		return NULL;
  802b47:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4c:	e9 b8 04 00 00       	jmp    803009 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802b51:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802b58:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b5b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b5e:	01 d0                	add    %edx,%eax
  802b60:	48                   	dec    %eax
  802b61:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802b64:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b67:	ba 00 00 00 00       	mov    $0x0,%edx
  802b6c:	f7 75 bc             	divl   -0x44(%ebp)
  802b6f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b72:	29 d0                	sub    %edx,%eax
  802b74:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802b77:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b7a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b7d:	75 08                	jne    802b87 <realloc+0x196>
		return virtual_address;
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	e9 82 04 00 00       	jmp    803009 <realloc+0x618>
	if (req < oldsz)
  802b87:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b8a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b8d:	0f 83 cd 02 00 00    	jae    802e60 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  802b99:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  802b9c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b9f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ba2:	01 d0                	add    %edx,%eax
  802ba4:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802ba7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802baa:	89 d0                	mov    %edx,%eax
  802bac:	01 c0                	add    %eax,%eax
  802bae:	01 d0                	add    %edx,%eax
  802bb0:	c1 e0 02             	shl    $0x2,%eax
  802bb3:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802bb9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bbc:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  802bbe:	83 ec 08             	sub    $0x8,%esp
  802bc1:	ff 75 b0             	pushl  -0x50(%ebp)
  802bc4:	ff 75 ac             	pushl  -0x54(%ebp)
  802bc7:	e8 e3 0c 00 00       	call   8038af <sys_free_user_mem>
  802bcc:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  802bcf:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bd6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802bdd:	eb 64                	jmp    802c43 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  802bdf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802be2:	89 d0                	mov    %edx,%eax
  802be4:	01 c0                	add    %eax,%eax
  802be6:	01 d0                	add    %edx,%eax
  802be8:	c1 e0 02             	shl    $0x2,%eax
  802beb:	05 48 20 81 00       	add    $0x812048,%eax
  802bf0:	8a 00                	mov    (%eax),%al
  802bf2:	84 c0                	test   %al,%al
  802bf4:	75 4a                	jne    802c40 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  802bf6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bf9:	89 d0                	mov    %edx,%eax
  802bfb:	01 c0                	add    %eax,%eax
  802bfd:	01 d0                	add    %edx,%eax
  802bff:	c1 e0 02             	shl    $0x2,%eax
  802c02:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802c08:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c0b:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  802c0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c10:	89 d0                	mov    %edx,%eax
  802c12:	01 c0                	add    %eax,%eax
  802c14:	01 d0                	add    %edx,%eax
  802c16:	c1 e0 02             	shl    $0x2,%eax
  802c19:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802c1f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c22:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802c24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c27:	89 d0                	mov    %edx,%eax
  802c29:	01 c0                	add    %eax,%eax
  802c2b:	01 d0                	add    %edx,%eax
  802c2d:	c1 e0 02             	shl    $0x2,%eax
  802c30:	05 48 20 81 00       	add    $0x812048,%eax
  802c35:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802c38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  802c3e:	eb 0c                	jmp    802c4c <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802c40:	ff 45 e4             	incl   -0x1c(%ebp)
  802c43:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802c4a:	7e 93                	jle    802bdf <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  802c4c:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802c50:	0f 84 8d 01 00 00    	je     802de3 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802c56:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802c5d:	e9 74 01 00 00       	jmp    802dd6 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802c62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c65:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c68:	0f 84 64 01 00 00    	je     802dd2 <realloc+0x3e1>
				if (uhp_frees[k].free)
  802c6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c71:	89 d0                	mov    %edx,%eax
  802c73:	01 c0                	add    %eax,%eax
  802c75:	01 d0                	add    %edx,%eax
  802c77:	c1 e0 02             	shl    $0x2,%eax
  802c7a:	05 48 20 81 00       	add    $0x812048,%eax
  802c7f:	8a 00                	mov    (%eax),%al
  802c81:	84 c0                	test   %al,%al
  802c83:	0f 84 4a 01 00 00    	je     802dd3 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802c89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c8c:	89 d0                	mov    %edx,%eax
  802c8e:	01 c0                	add    %eax,%eax
  802c90:	01 d0                	add    %edx,%eax
  802c92:	c1 e0 02             	shl    $0x2,%eax
  802c95:	05 40 20 81 00       	add    $0x812040,%eax
  802c9a:	8b 08                	mov    (%eax),%ecx
  802c9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c9f:	89 d0                	mov    %edx,%eax
  802ca1:	01 c0                	add    %eax,%eax
  802ca3:	01 d0                	add    %edx,%eax
  802ca5:	c1 e0 02             	shl    $0x2,%eax
  802ca8:	05 44 20 81 00       	add    $0x812044,%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	01 c1                	add    %eax,%ecx
  802cb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cb4:	89 d0                	mov    %edx,%eax
  802cb6:	01 c0                	add    %eax,%eax
  802cb8:	01 d0                	add    %edx,%eax
  802cba:	c1 e0 02             	shl    $0x2,%eax
  802cbd:	05 40 20 81 00       	add    $0x812040,%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	39 c1                	cmp    %eax,%ecx
  802cc6:	75 7a                	jne    802d42 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  802cc8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ccb:	89 d0                	mov    %edx,%eax
  802ccd:	01 c0                	add    %eax,%eax
  802ccf:	01 d0                	add    %edx,%eax
  802cd1:	c1 e0 02             	shl    $0x2,%eax
  802cd4:	05 40 20 81 00       	add    $0x812040,%eax
  802cd9:	8b 10                	mov    (%eax),%edx
  802cdb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802cde:	89 c8                	mov    %ecx,%eax
  802ce0:	01 c0                	add    %eax,%eax
  802ce2:	01 c8                	add    %ecx,%eax
  802ce4:	c1 e0 02             	shl    $0x2,%eax
  802ce7:	05 40 20 81 00       	add    $0x812040,%eax
  802cec:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  802cee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cf1:	89 d0                	mov    %edx,%eax
  802cf3:	01 c0                	add    %eax,%eax
  802cf5:	01 d0                	add    %edx,%eax
  802cf7:	c1 e0 02             	shl    $0x2,%eax
  802cfa:	05 44 20 81 00       	add    $0x812044,%eax
  802cff:	8b 08                	mov    (%eax),%ecx
  802d01:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d04:	89 d0                	mov    %edx,%eax
  802d06:	01 c0                	add    %eax,%eax
  802d08:	01 d0                	add    %edx,%eax
  802d0a:	c1 e0 02             	shl    $0x2,%eax
  802d0d:	05 44 20 81 00       	add    $0x812044,%eax
  802d12:	8b 00                	mov    (%eax),%eax
  802d14:	01 c1                	add    %eax,%ecx
  802d16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d19:	89 d0                	mov    %edx,%eax
  802d1b:	01 c0                	add    %eax,%eax
  802d1d:	01 d0                	add    %edx,%eax
  802d1f:	c1 e0 02             	shl    $0x2,%eax
  802d22:	05 44 20 81 00       	add    $0x812044,%eax
  802d27:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802d29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d2c:	89 d0                	mov    %edx,%eax
  802d2e:	01 c0                	add    %eax,%eax
  802d30:	01 d0                	add    %edx,%eax
  802d32:	c1 e0 02             	shl    $0x2,%eax
  802d35:	05 48 20 81 00       	add    $0x812048,%eax
  802d3a:	c6 00 00             	movb   $0x0,(%eax)
  802d3d:	e9 91 00 00 00       	jmp    802dd3 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802d42:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d45:	89 d0                	mov    %edx,%eax
  802d47:	01 c0                	add    %eax,%eax
  802d49:	01 d0                	add    %edx,%eax
  802d4b:	c1 e0 02             	shl    $0x2,%eax
  802d4e:	05 40 20 81 00       	add    $0x812040,%eax
  802d53:	8b 08                	mov    (%eax),%ecx
  802d55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d58:	89 d0                	mov    %edx,%eax
  802d5a:	01 c0                	add    %eax,%eax
  802d5c:	01 d0                	add    %edx,%eax
  802d5e:	c1 e0 02             	shl    $0x2,%eax
  802d61:	05 44 20 81 00       	add    $0x812044,%eax
  802d66:	8b 00                	mov    (%eax),%eax
  802d68:	01 c1                	add    %eax,%ecx
  802d6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d6d:	89 d0                	mov    %edx,%eax
  802d6f:	01 c0                	add    %eax,%eax
  802d71:	01 d0                	add    %edx,%eax
  802d73:	c1 e0 02             	shl    $0x2,%eax
  802d76:	05 40 20 81 00       	add    $0x812040,%eax
  802d7b:	8b 00                	mov    (%eax),%eax
  802d7d:	39 c1                	cmp    %eax,%ecx
  802d7f:	75 52                	jne    802dd3 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802d81:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d84:	89 d0                	mov    %edx,%eax
  802d86:	01 c0                	add    %eax,%eax
  802d88:	01 d0                	add    %edx,%eax
  802d8a:	c1 e0 02             	shl    $0x2,%eax
  802d8d:	05 44 20 81 00       	add    $0x812044,%eax
  802d92:	8b 08                	mov    (%eax),%ecx
  802d94:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d97:	89 d0                	mov    %edx,%eax
  802d99:	01 c0                	add    %eax,%eax
  802d9b:	01 d0                	add    %edx,%eax
  802d9d:	c1 e0 02             	shl    $0x2,%eax
  802da0:	05 44 20 81 00       	add    $0x812044,%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	01 c1                	add    %eax,%ecx
  802da9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dac:	89 d0                	mov    %edx,%eax
  802dae:	01 c0                	add    %eax,%eax
  802db0:	01 d0                	add    %edx,%eax
  802db2:	c1 e0 02             	shl    $0x2,%eax
  802db5:	05 44 20 81 00       	add    $0x812044,%eax
  802dba:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802dbc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dbf:	89 d0                	mov    %edx,%eax
  802dc1:	01 c0                	add    %eax,%eax
  802dc3:	01 d0                	add    %edx,%eax
  802dc5:	c1 e0 02             	shl    $0x2,%eax
  802dc8:	05 48 20 81 00       	add    $0x812048,%eax
  802dcd:	c6 00 00             	movb   $0x0,(%eax)
  802dd0:	eb 01                	jmp    802dd3 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802dd2:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802dd3:	ff 45 e0             	incl   -0x20(%ebp)
  802dd6:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802ddd:	0f 8e 7f fe ff ff    	jle    802c62 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802de3:	a1 30 61 83 00       	mov    0x836130,%eax
  802de8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802deb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802df2:	eb 53                	jmp    802e47 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802df4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802df7:	89 d0                	mov    %edx,%eax
  802df9:	01 c0                	add    %eax,%eax
  802dfb:	01 d0                	add    %edx,%eax
  802dfd:	c1 e0 02             	shl    $0x2,%eax
  802e00:	05 48 60 80 00       	add    $0x806048,%eax
  802e05:	8a 00                	mov    (%eax),%al
  802e07:	84 c0                	test   %al,%al
  802e09:	74 39                	je     802e44 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802e0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e0e:	89 d0                	mov    %edx,%eax
  802e10:	01 c0                	add    %eax,%eax
  802e12:	01 d0                	add    %edx,%eax
  802e14:	c1 e0 02             	shl    $0x2,%eax
  802e17:	05 40 60 80 00       	add    $0x806040,%eax
  802e1c:	8b 08                	mov    (%eax),%ecx
  802e1e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e21:	89 d0                	mov    %edx,%eax
  802e23:	01 c0                	add    %eax,%eax
  802e25:	01 d0                	add    %edx,%eax
  802e27:	c1 e0 02             	shl    $0x2,%eax
  802e2a:	05 44 60 80 00       	add    $0x806044,%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	01 c8                	add    %ecx,%eax
  802e33:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802e36:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e39:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802e3c:	76 06                	jbe    802e44 <realloc+0x453>
  802e3e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e41:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802e44:	ff 45 d8             	incl   -0x28(%ebp)
  802e47:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802e4e:	7e a4                	jle    802df4 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802e50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e53:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	e9 a9 01 00 00       	jmp    803009 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802e60:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	01 d0                	add    %edx,%eax
  802e68:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802e6b:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802e72:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802e79:	eb 57                	jmp    802ed2 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802e7b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e7e:	89 d0                	mov    %edx,%eax
  802e80:	01 c0                	add    %eax,%eax
  802e82:	01 d0                	add    %edx,%eax
  802e84:	c1 e0 02             	shl    $0x2,%eax
  802e87:	05 48 20 81 00       	add    $0x812048,%eax
  802e8c:	8a 00                	mov    (%eax),%al
  802e8e:	84 c0                	test   %al,%al
  802e90:	74 3d                	je     802ecf <realloc+0x4de>
  802e92:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802e95:	89 d0                	mov    %edx,%eax
  802e97:	01 c0                	add    %eax,%eax
  802e99:	01 d0                	add    %edx,%eax
  802e9b:	c1 e0 02             	shl    $0x2,%eax
  802e9e:	05 40 20 81 00       	add    $0x812040,%eax
  802ea3:	8b 00                	mov    (%eax),%eax
  802ea5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ea8:	75 25                	jne    802ecf <realloc+0x4de>
  802eaa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802ead:	89 d0                	mov    %edx,%eax
  802eaf:	01 c0                	add    %eax,%eax
  802eb1:	01 d0                	add    %edx,%eax
  802eb3:	c1 e0 02             	shl    $0x2,%eax
  802eb6:	05 44 20 81 00       	add    $0x812044,%eax
  802ebb:	8b 10                	mov    (%eax),%edx
  802ebd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ec0:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802ec3:	39 c2                	cmp    %eax,%edx
  802ec5:	72 08                	jb     802ecf <realloc+0x4de>
		{
			adjIdx = j; break;
  802ec7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802eca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802ecd:	eb 0c                	jmp    802edb <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802ecf:	ff 45 d0             	incl   -0x30(%ebp)
  802ed2:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802ed9:	7e a0                	jle    802e7b <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802edb:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802edf:	0f 84 d6 00 00 00    	je     802fbb <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802ee5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ee8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802eeb:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802eee:	83 ec 08             	sub    $0x8,%esp
  802ef1:	ff 75 a0             	pushl  -0x60(%ebp)
  802ef4:	ff 75 a4             	pushl  -0x5c(%ebp)
  802ef7:	e8 cf 09 00 00       	call   8038cb <sys_allocate_user_mem>
  802efc:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802eff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f02:	89 d0                	mov    %edx,%eax
  802f04:	01 c0                	add    %eax,%eax
  802f06:	01 d0                	add    %edx,%eax
  802f08:	c1 e0 02             	shl    $0x2,%eax
  802f0b:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802f11:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f14:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802f16:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f19:	89 d0                	mov    %edx,%eax
  802f1b:	01 c0                	add    %eax,%eax
  802f1d:	01 d0                	add    %edx,%eax
  802f1f:	c1 e0 02             	shl    $0x2,%eax
  802f22:	05 40 20 81 00       	add    $0x812040,%eax
  802f27:	8b 10                	mov    (%eax),%edx
  802f29:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802f2c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802f2f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f32:	89 d0                	mov    %edx,%eax
  802f34:	01 c0                	add    %eax,%eax
  802f36:	01 d0                	add    %edx,%eax
  802f38:	c1 e0 02             	shl    $0x2,%eax
  802f3b:	05 40 20 81 00       	add    $0x812040,%eax
  802f40:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802f42:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f45:	89 d0                	mov    %edx,%eax
  802f47:	01 c0                	add    %eax,%eax
  802f49:	01 d0                	add    %edx,%eax
  802f4b:	c1 e0 02             	shl    $0x2,%eax
  802f4e:	05 44 20 81 00       	add    $0x812044,%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802f58:	89 c2                	mov    %eax,%edx
  802f5a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802f5d:	89 c8                	mov    %ecx,%eax
  802f5f:	01 c0                	add    %eax,%eax
  802f61:	01 c8                	add    %ecx,%eax
  802f63:	c1 e0 02             	shl    $0x2,%eax
  802f66:	05 44 20 81 00       	add    $0x812044,%eax
  802f6b:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802f6d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f70:	89 d0                	mov    %edx,%eax
  802f72:	01 c0                	add    %eax,%eax
  802f74:	01 d0                	add    %edx,%eax
  802f76:	c1 e0 02             	shl    $0x2,%eax
  802f79:	05 44 20 81 00       	add    $0x812044,%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	85 c0                	test   %eax,%eax
  802f82:	75 14                	jne    802f98 <realloc+0x5a7>
  802f84:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802f87:	89 d0                	mov    %edx,%eax
  802f89:	01 c0                	add    %eax,%eax
  802f8b:	01 d0                	add    %edx,%eax
  802f8d:	c1 e0 02             	shl    $0x2,%eax
  802f90:	05 48 20 81 00       	add    $0x812048,%eax
  802f95:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802f98:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f9b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f9e:	01 c2                	add    %eax,%edx
  802fa0:	a1 88 60 83 00       	mov    0x836088,%eax
  802fa5:	39 c2                	cmp    %eax,%edx
  802fa7:	76 0d                	jbe    802fb6 <realloc+0x5c5>
  802fa9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fac:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802faf:	01 d0                	add    %edx,%eax
  802fb1:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	eb 4e                	jmp    803009 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802fbb:	83 ec 0c             	sub    $0xc,%esp
  802fbe:	ff 75 0c             	pushl  0xc(%ebp)
  802fc1:	e8 0b ec ff ff       	call   801bd1 <malloc>
  802fc6:	83 c4 10             	add    $0x10,%esp
  802fc9:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802fcc:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802fd0:	75 07                	jne    802fd9 <realloc+0x5e8>
		return NULL;
  802fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd7:	eb 30                	jmp    803009 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802fd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fdc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802fdf:	39 d0                	cmp    %edx,%eax
  802fe1:	76 02                	jbe    802fe5 <realloc+0x5f4>
  802fe3:	89 d0                	mov    %edx,%eax
  802fe5:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802fe8:	83 ec 04             	sub    $0x4,%esp
  802feb:	50                   	push   %eax
  802fec:	52                   	push   %edx
  802fed:	ff 75 cc             	pushl  -0x34(%ebp)
  802ff0:	e8 cf 06 00 00       	call   8036c4 <sys_move_user_mem>
  802ff5:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802ff8:	83 ec 0c             	sub    $0xc,%esp
  802ffb:	ff 75 08             	pushl  0x8(%ebp)
  802ffe:	e8 2e ef ff ff       	call   801f31 <free>
  803003:	83 c4 10             	add    $0x10,%esp
	return newptr;
  803006:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  803009:	c9                   	leave  
  80300a:	c3                   	ret    

0080300b <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80300b:	55                   	push   %ebp
  80300c:	89 e5                	mov    %esp,%ebp
  80300e:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  803017:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80301b:	0f 84 33 03 00 00    	je     803354 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  803021:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803024:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  803029:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  80302c:	83 ec 08             	sub    $0x8,%esp
  80302f:	ff 75 08             	pushl  0x8(%ebp)
  803032:	ff 75 d8             	pushl  -0x28(%ebp)
  803035:	e8 7d 05 00 00       	call   8035b7 <sys_delete_shared_object>
  80303a:	83 c4 10             	add    $0x10,%esp
  80303d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  803040:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803044:	0f 88 0d 03 00 00    	js     803357 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80304a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803051:	e9 ef 02 00 00       	jmp    803345 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  803056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803059:	89 d0                	mov    %edx,%eax
  80305b:	01 c0                	add    %eax,%eax
  80305d:	01 d0                	add    %edx,%eax
  80305f:	c1 e0 02             	shl    $0x2,%eax
  803062:	05 48 60 80 00       	add    $0x806048,%eax
  803067:	8a 00                	mov    (%eax),%al
  803069:	84 c0                	test   %al,%al
  80306b:	0f 84 d1 02 00 00    	je     803342 <sfree+0x337>
  803071:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803074:	89 d0                	mov    %edx,%eax
  803076:	01 c0                	add    %eax,%eax
  803078:	01 d0                	add    %edx,%eax
  80307a:	c1 e0 02             	shl    $0x2,%eax
  80307d:	05 40 60 80 00       	add    $0x806040,%eax
  803082:	8b 00                	mov    (%eax),%eax
  803084:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803087:	0f 85 b5 02 00 00    	jne    803342 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  80308d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803090:	89 d0                	mov    %edx,%eax
  803092:	01 c0                	add    %eax,%eax
  803094:	01 d0                	add    %edx,%eax
  803096:	c1 e0 02             	shl    $0x2,%eax
  803099:	05 44 60 80 00       	add    $0x806044,%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  8030a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a6:	89 d0                	mov    %edx,%eax
  8030a8:	01 c0                	add    %eax,%eax
  8030aa:	01 d0                	add    %edx,%eax
  8030ac:	c1 e0 02             	shl    $0x2,%eax
  8030af:	05 48 60 80 00       	add    $0x806048,%eax
  8030b4:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  8030b7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8030be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8030c5:	eb 64                	jmp    80312b <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  8030c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030ca:	89 d0                	mov    %edx,%eax
  8030cc:	01 c0                	add    %eax,%eax
  8030ce:	01 d0                	add    %edx,%eax
  8030d0:	c1 e0 02             	shl    $0x2,%eax
  8030d3:	05 48 20 81 00       	add    $0x812048,%eax
  8030d8:	8a 00                	mov    (%eax),%al
  8030da:	84 c0                	test   %al,%al
  8030dc:	75 4a                	jne    803128 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  8030de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030e1:	89 d0                	mov    %edx,%eax
  8030e3:	01 c0                	add    %eax,%eax
  8030e5:	01 d0                	add    %edx,%eax
  8030e7:	c1 e0 02             	shl    $0x2,%eax
  8030ea:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8030f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f3:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  8030f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030f8:	89 d0                	mov    %edx,%eax
  8030fa:	01 c0                	add    %eax,%eax
  8030fc:	01 d0                	add    %edx,%eax
  8030fe:	c1 e0 02             	shl    $0x2,%eax
  803101:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  803107:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80310a:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  80310c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80310f:	89 d0                	mov    %edx,%eax
  803111:	01 c0                	add    %eax,%eax
  803113:	01 d0                	add    %edx,%eax
  803115:	c1 e0 02             	shl    $0x2,%eax
  803118:	05 48 20 81 00       	add    $0x812048,%eax
  80311d:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  803120:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803123:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  803126:	eb 0c                	jmp    803134 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803128:	ff 45 ec             	incl   -0x14(%ebp)
  80312b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803132:	7e 93                	jle    8030c7 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  803134:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803138:	0f 84 8d 01 00 00    	je     8032cb <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  80313e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803145:	e9 74 01 00 00       	jmp    8032be <sfree+0x2b3>
				{
					if (k == fidx) continue;
  80314a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803150:	0f 84 64 01 00 00    	je     8032ba <sfree+0x2af>
					if (uhp_frees[k].free)
  803156:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803159:	89 d0                	mov    %edx,%eax
  80315b:	01 c0                	add    %eax,%eax
  80315d:	01 d0                	add    %edx,%eax
  80315f:	c1 e0 02             	shl    $0x2,%eax
  803162:	05 48 20 81 00       	add    $0x812048,%eax
  803167:	8a 00                	mov    (%eax),%al
  803169:	84 c0                	test   %al,%al
  80316b:	0f 84 4a 01 00 00    	je     8032bb <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  803171:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803174:	89 d0                	mov    %edx,%eax
  803176:	01 c0                	add    %eax,%eax
  803178:	01 d0                	add    %edx,%eax
  80317a:	c1 e0 02             	shl    $0x2,%eax
  80317d:	05 40 20 81 00       	add    $0x812040,%eax
  803182:	8b 08                	mov    (%eax),%ecx
  803184:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803187:	89 d0                	mov    %edx,%eax
  803189:	01 c0                	add    %eax,%eax
  80318b:	01 d0                	add    %edx,%eax
  80318d:	c1 e0 02             	shl    $0x2,%eax
  803190:	05 44 20 81 00       	add    $0x812044,%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	01 c1                	add    %eax,%ecx
  803199:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80319c:	89 d0                	mov    %edx,%eax
  80319e:	01 c0                	add    %eax,%eax
  8031a0:	01 d0                	add    %edx,%eax
  8031a2:	c1 e0 02             	shl    $0x2,%eax
  8031a5:	05 40 20 81 00       	add    $0x812040,%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	39 c1                	cmp    %eax,%ecx
  8031ae:	75 7a                	jne    80322a <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  8031b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b3:	89 d0                	mov    %edx,%eax
  8031b5:	01 c0                	add    %eax,%eax
  8031b7:	01 d0                	add    %edx,%eax
  8031b9:	c1 e0 02             	shl    $0x2,%eax
  8031bc:	05 40 20 81 00       	add    $0x812040,%eax
  8031c1:	8b 10                	mov    (%eax),%edx
  8031c3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8031c6:	89 c8                	mov    %ecx,%eax
  8031c8:	01 c0                	add    %eax,%eax
  8031ca:	01 c8                	add    %ecx,%eax
  8031cc:	c1 e0 02             	shl    $0x2,%eax
  8031cf:	05 40 20 81 00       	add    $0x812040,%eax
  8031d4:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  8031d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d9:	89 d0                	mov    %edx,%eax
  8031db:	01 c0                	add    %eax,%eax
  8031dd:	01 d0                	add    %edx,%eax
  8031df:	c1 e0 02             	shl    $0x2,%eax
  8031e2:	05 44 20 81 00       	add    $0x812044,%eax
  8031e7:	8b 08                	mov    (%eax),%ecx
  8031e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ec:	89 d0                	mov    %edx,%eax
  8031ee:	01 c0                	add    %eax,%eax
  8031f0:	01 d0                	add    %edx,%eax
  8031f2:	c1 e0 02             	shl    $0x2,%eax
  8031f5:	05 44 20 81 00       	add    $0x812044,%eax
  8031fa:	8b 00                	mov    (%eax),%eax
  8031fc:	01 c1                	add    %eax,%ecx
  8031fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803201:	89 d0                	mov    %edx,%eax
  803203:	01 c0                	add    %eax,%eax
  803205:	01 d0                	add    %edx,%eax
  803207:	c1 e0 02             	shl    $0x2,%eax
  80320a:	05 44 20 81 00       	add    $0x812044,%eax
  80320f:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803211:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803214:	89 d0                	mov    %edx,%eax
  803216:	01 c0                	add    %eax,%eax
  803218:	01 d0                	add    %edx,%eax
  80321a:	c1 e0 02             	shl    $0x2,%eax
  80321d:	05 48 20 81 00       	add    $0x812048,%eax
  803222:	c6 00 00             	movb   $0x0,(%eax)
  803225:	e9 91 00 00 00       	jmp    8032bb <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  80322a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80322d:	89 d0                	mov    %edx,%eax
  80322f:	01 c0                	add    %eax,%eax
  803231:	01 d0                	add    %edx,%eax
  803233:	c1 e0 02             	shl    $0x2,%eax
  803236:	05 40 20 81 00       	add    $0x812040,%eax
  80323b:	8b 08                	mov    (%eax),%ecx
  80323d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803240:	89 d0                	mov    %edx,%eax
  803242:	01 c0                	add    %eax,%eax
  803244:	01 d0                	add    %edx,%eax
  803246:	c1 e0 02             	shl    $0x2,%eax
  803249:	05 44 20 81 00       	add    $0x812044,%eax
  80324e:	8b 00                	mov    (%eax),%eax
  803250:	01 c1                	add    %eax,%ecx
  803252:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803255:	89 d0                	mov    %edx,%eax
  803257:	01 c0                	add    %eax,%eax
  803259:	01 d0                	add    %edx,%eax
  80325b:	c1 e0 02             	shl    $0x2,%eax
  80325e:	05 40 20 81 00       	add    $0x812040,%eax
  803263:	8b 00                	mov    (%eax),%eax
  803265:	39 c1                	cmp    %eax,%ecx
  803267:	75 52                	jne    8032bb <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  803269:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80326c:	89 d0                	mov    %edx,%eax
  80326e:	01 c0                	add    %eax,%eax
  803270:	01 d0                	add    %edx,%eax
  803272:	c1 e0 02             	shl    $0x2,%eax
  803275:	05 44 20 81 00       	add    $0x812044,%eax
  80327a:	8b 08                	mov    (%eax),%ecx
  80327c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80327f:	89 d0                	mov    %edx,%eax
  803281:	01 c0                	add    %eax,%eax
  803283:	01 d0                	add    %edx,%eax
  803285:	c1 e0 02             	shl    $0x2,%eax
  803288:	05 44 20 81 00       	add    $0x812044,%eax
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	01 c1                	add    %eax,%ecx
  803291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803294:	89 d0                	mov    %edx,%eax
  803296:	01 c0                	add    %eax,%eax
  803298:	01 d0                	add    %edx,%eax
  80329a:	c1 e0 02             	shl    $0x2,%eax
  80329d:	05 44 20 81 00       	add    $0x812044,%eax
  8032a2:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  8032a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a7:	89 d0                	mov    %edx,%eax
  8032a9:	01 c0                	add    %eax,%eax
  8032ab:	01 d0                	add    %edx,%eax
  8032ad:	c1 e0 02             	shl    $0x2,%eax
  8032b0:	05 48 20 81 00       	add    $0x812048,%eax
  8032b5:	c6 00 00             	movb   $0x0,(%eax)
  8032b8:	eb 01                	jmp    8032bb <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  8032ba:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  8032bb:	ff 45 e8             	incl   -0x18(%ebp)
  8032be:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8032c5:	0f 8e 7f fe ff ff    	jle    80314a <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  8032cb:	a1 30 61 83 00       	mov    0x836130,%eax
  8032d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  8032d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8032da:	eb 53                	jmp    80332f <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  8032dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032df:	89 d0                	mov    %edx,%eax
  8032e1:	01 c0                	add    %eax,%eax
  8032e3:	01 d0                	add    %edx,%eax
  8032e5:	c1 e0 02             	shl    $0x2,%eax
  8032e8:	05 48 60 80 00       	add    $0x806048,%eax
  8032ed:	8a 00                	mov    (%eax),%al
  8032ef:	84 c0                	test   %al,%al
  8032f1:	74 39                	je     80332c <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  8032f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032f6:	89 d0                	mov    %edx,%eax
  8032f8:	01 c0                	add    %eax,%eax
  8032fa:	01 d0                	add    %edx,%eax
  8032fc:	c1 e0 02             	shl    $0x2,%eax
  8032ff:	05 40 60 80 00       	add    $0x806040,%eax
  803304:	8b 08                	mov    (%eax),%ecx
  803306:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803309:	89 d0                	mov    %edx,%eax
  80330b:	01 c0                	add    %eax,%eax
  80330d:	01 d0                	add    %edx,%eax
  80330f:	c1 e0 02             	shl    $0x2,%eax
  803312:	05 44 60 80 00       	add    $0x806044,%eax
  803317:	8b 00                	mov    (%eax),%eax
  803319:	01 c8                	add    %ecx,%eax
  80331b:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  80331e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803321:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803324:	76 06                	jbe    80332c <sfree+0x321>
  803326:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80332c:	ff 45 e0             	incl   -0x20(%ebp)
  80332f:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803336:	7e a4                	jle    8032dc <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333b:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  803340:	eb 16                	jmp    803358 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803342:	ff 45 f4             	incl   -0xc(%ebp)
  803345:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  80334c:	0f 8e 04 fd ff ff    	jle    803056 <sfree+0x4b>
  803352:	eb 04                	jmp    803358 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  803354:	90                   	nop
  803355:	eb 01                	jmp    803358 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  803357:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803358:	c9                   	leave  
  803359:	c3                   	ret    

0080335a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80335a:	55                   	push   %ebp
  80335b:	89 e5                	mov    %esp,%ebp
  80335d:	57                   	push   %edi
  80335e:	56                   	push   %esi
  80335f:	53                   	push   %ebx
  803360:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	8b 55 0c             	mov    0xc(%ebp),%edx
  803369:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80336c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80336f:	8b 7d 18             	mov    0x18(%ebp),%edi
  803372:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803375:	cd 30                	int    $0x30
  803377:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80337a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80337d:	83 c4 10             	add    $0x10,%esp
  803380:	5b                   	pop    %ebx
  803381:	5e                   	pop    %esi
  803382:	5f                   	pop    %edi
  803383:	5d                   	pop    %ebp
  803384:	c3                   	ret    

00803385 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803385:	55                   	push   %ebp
  803386:	89 e5                	mov    %esp,%ebp
  803388:	83 ec 04             	sub    $0x4,%esp
  80338b:	8b 45 10             	mov    0x10(%ebp),%eax
  80338e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803391:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803394:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	6a 00                	push   $0x0
  80339d:	51                   	push   %ecx
  80339e:	52                   	push   %edx
  80339f:	ff 75 0c             	pushl  0xc(%ebp)
  8033a2:	50                   	push   %eax
  8033a3:	6a 00                	push   $0x0
  8033a5:	e8 b0 ff ff ff       	call   80335a <syscall>
  8033aa:	83 c4 18             	add    $0x18,%esp
}
  8033ad:	90                   	nop
  8033ae:	c9                   	leave  
  8033af:	c3                   	ret    

008033b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8033b0:	55                   	push   %ebp
  8033b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8033b3:	6a 00                	push   $0x0
  8033b5:	6a 00                	push   $0x0
  8033b7:	6a 00                	push   $0x0
  8033b9:	6a 00                	push   $0x0
  8033bb:	6a 00                	push   $0x0
  8033bd:	6a 02                	push   $0x2
  8033bf:	e8 96 ff ff ff       	call   80335a <syscall>
  8033c4:	83 c4 18             	add    $0x18,%esp
}
  8033c7:	c9                   	leave  
  8033c8:	c3                   	ret    

008033c9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8033c9:	55                   	push   %ebp
  8033ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8033cc:	6a 00                	push   $0x0
  8033ce:	6a 00                	push   $0x0
  8033d0:	6a 00                	push   $0x0
  8033d2:	6a 00                	push   $0x0
  8033d4:	6a 00                	push   $0x0
  8033d6:	6a 03                	push   $0x3
  8033d8:	e8 7d ff ff ff       	call   80335a <syscall>
  8033dd:	83 c4 18             	add    $0x18,%esp
}
  8033e0:	90                   	nop
  8033e1:	c9                   	leave  
  8033e2:	c3                   	ret    

008033e3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8033e3:	55                   	push   %ebp
  8033e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8033e6:	6a 00                	push   $0x0
  8033e8:	6a 00                	push   $0x0
  8033ea:	6a 00                	push   $0x0
  8033ec:	6a 00                	push   $0x0
  8033ee:	6a 00                	push   $0x0
  8033f0:	6a 04                	push   $0x4
  8033f2:	e8 63 ff ff ff       	call   80335a <syscall>
  8033f7:	83 c4 18             	add    $0x18,%esp
}
  8033fa:	90                   	nop
  8033fb:	c9                   	leave  
  8033fc:	c3                   	ret    

008033fd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8033fd:	55                   	push   %ebp
  8033fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803400:	8b 55 0c             	mov    0xc(%ebp),%edx
  803403:	8b 45 08             	mov    0x8(%ebp),%eax
  803406:	6a 00                	push   $0x0
  803408:	6a 00                	push   $0x0
  80340a:	6a 00                	push   $0x0
  80340c:	52                   	push   %edx
  80340d:	50                   	push   %eax
  80340e:	6a 08                	push   $0x8
  803410:	e8 45 ff ff ff       	call   80335a <syscall>
  803415:	83 c4 18             	add    $0x18,%esp
}
  803418:	c9                   	leave  
  803419:	c3                   	ret    

0080341a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80341a:	55                   	push   %ebp
  80341b:	89 e5                	mov    %esp,%ebp
  80341d:	56                   	push   %esi
  80341e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80341f:	8b 75 18             	mov    0x18(%ebp),%esi
  803422:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803425:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803428:	8b 55 0c             	mov    0xc(%ebp),%edx
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	56                   	push   %esi
  80342f:	53                   	push   %ebx
  803430:	51                   	push   %ecx
  803431:	52                   	push   %edx
  803432:	50                   	push   %eax
  803433:	6a 09                	push   $0x9
  803435:	e8 20 ff ff ff       	call   80335a <syscall>
  80343a:	83 c4 18             	add    $0x18,%esp
}
  80343d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803440:	5b                   	pop    %ebx
  803441:	5e                   	pop    %esi
  803442:	5d                   	pop    %ebp
  803443:	c3                   	ret    

00803444 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803444:	55                   	push   %ebp
  803445:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803447:	6a 00                	push   $0x0
  803449:	6a 00                	push   $0x0
  80344b:	6a 00                	push   $0x0
  80344d:	6a 00                	push   $0x0
  80344f:	ff 75 08             	pushl  0x8(%ebp)
  803452:	6a 0a                	push   $0xa
  803454:	e8 01 ff ff ff       	call   80335a <syscall>
  803459:	83 c4 18             	add    $0x18,%esp
}
  80345c:	c9                   	leave  
  80345d:	c3                   	ret    

0080345e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80345e:	55                   	push   %ebp
  80345f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803461:	6a 00                	push   $0x0
  803463:	6a 00                	push   $0x0
  803465:	6a 00                	push   $0x0
  803467:	ff 75 0c             	pushl  0xc(%ebp)
  80346a:	ff 75 08             	pushl  0x8(%ebp)
  80346d:	6a 0b                	push   $0xb
  80346f:	e8 e6 fe ff ff       	call   80335a <syscall>
  803474:	83 c4 18             	add    $0x18,%esp
}
  803477:	c9                   	leave  
  803478:	c3                   	ret    

00803479 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803479:	55                   	push   %ebp
  80347a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80347c:	6a 00                	push   $0x0
  80347e:	6a 00                	push   $0x0
  803480:	6a 00                	push   $0x0
  803482:	6a 00                	push   $0x0
  803484:	6a 00                	push   $0x0
  803486:	6a 0c                	push   $0xc
  803488:	e8 cd fe ff ff       	call   80335a <syscall>
  80348d:	83 c4 18             	add    $0x18,%esp
}
  803490:	c9                   	leave  
  803491:	c3                   	ret    

00803492 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803492:	55                   	push   %ebp
  803493:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803495:	6a 00                	push   $0x0
  803497:	6a 00                	push   $0x0
  803499:	6a 00                	push   $0x0
  80349b:	6a 00                	push   $0x0
  80349d:	6a 00                	push   $0x0
  80349f:	6a 0d                	push   $0xd
  8034a1:	e8 b4 fe ff ff       	call   80335a <syscall>
  8034a6:	83 c4 18             	add    $0x18,%esp
}
  8034a9:	c9                   	leave  
  8034aa:	c3                   	ret    

008034ab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8034ab:	55                   	push   %ebp
  8034ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8034ae:	6a 00                	push   $0x0
  8034b0:	6a 00                	push   $0x0
  8034b2:	6a 00                	push   $0x0
  8034b4:	6a 00                	push   $0x0
  8034b6:	6a 00                	push   $0x0
  8034b8:	6a 0e                	push   $0xe
  8034ba:	e8 9b fe ff ff       	call   80335a <syscall>
  8034bf:	83 c4 18             	add    $0x18,%esp
}
  8034c2:	c9                   	leave  
  8034c3:	c3                   	ret    

008034c4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8034c4:	55                   	push   %ebp
  8034c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8034c7:	6a 00                	push   $0x0
  8034c9:	6a 00                	push   $0x0
  8034cb:	6a 00                	push   $0x0
  8034cd:	6a 00                	push   $0x0
  8034cf:	6a 00                	push   $0x0
  8034d1:	6a 0f                	push   $0xf
  8034d3:	e8 82 fe ff ff       	call   80335a <syscall>
  8034d8:	83 c4 18             	add    $0x18,%esp
}
  8034db:	c9                   	leave  
  8034dc:	c3                   	ret    

008034dd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8034dd:	55                   	push   %ebp
  8034de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8034e0:	6a 00                	push   $0x0
  8034e2:	6a 00                	push   $0x0
  8034e4:	6a 00                	push   $0x0
  8034e6:	6a 00                	push   $0x0
  8034e8:	ff 75 08             	pushl  0x8(%ebp)
  8034eb:	6a 10                	push   $0x10
  8034ed:	e8 68 fe ff ff       	call   80335a <syscall>
  8034f2:	83 c4 18             	add    $0x18,%esp
}
  8034f5:	c9                   	leave  
  8034f6:	c3                   	ret    

008034f7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8034f7:	55                   	push   %ebp
  8034f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8034fa:	6a 00                	push   $0x0
  8034fc:	6a 00                	push   $0x0
  8034fe:	6a 00                	push   $0x0
  803500:	6a 00                	push   $0x0
  803502:	6a 00                	push   $0x0
  803504:	6a 11                	push   $0x11
  803506:	e8 4f fe ff ff       	call   80335a <syscall>
  80350b:	83 c4 18             	add    $0x18,%esp
}
  80350e:	90                   	nop
  80350f:	c9                   	leave  
  803510:	c3                   	ret    

00803511 <sys_cputc>:

void
sys_cputc(const char c)
{
  803511:	55                   	push   %ebp
  803512:	89 e5                	mov    %esp,%ebp
  803514:	83 ec 04             	sub    $0x4,%esp
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80351d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803521:	6a 00                	push   $0x0
  803523:	6a 00                	push   $0x0
  803525:	6a 00                	push   $0x0
  803527:	6a 00                	push   $0x0
  803529:	50                   	push   %eax
  80352a:	6a 01                	push   $0x1
  80352c:	e8 29 fe ff ff       	call   80335a <syscall>
  803531:	83 c4 18             	add    $0x18,%esp
}
  803534:	90                   	nop
  803535:	c9                   	leave  
  803536:	c3                   	ret    

00803537 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803537:	55                   	push   %ebp
  803538:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80353a:	6a 00                	push   $0x0
  80353c:	6a 00                	push   $0x0
  80353e:	6a 00                	push   $0x0
  803540:	6a 00                	push   $0x0
  803542:	6a 00                	push   $0x0
  803544:	6a 14                	push   $0x14
  803546:	e8 0f fe ff ff       	call   80335a <syscall>
  80354b:	83 c4 18             	add    $0x18,%esp
}
  80354e:	90                   	nop
  80354f:	c9                   	leave  
  803550:	c3                   	ret    

00803551 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803551:	55                   	push   %ebp
  803552:	89 e5                	mov    %esp,%ebp
  803554:	83 ec 04             	sub    $0x4,%esp
  803557:	8b 45 10             	mov    0x10(%ebp),%eax
  80355a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80355d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803560:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803564:	8b 45 08             	mov    0x8(%ebp),%eax
  803567:	6a 00                	push   $0x0
  803569:	51                   	push   %ecx
  80356a:	52                   	push   %edx
  80356b:	ff 75 0c             	pushl  0xc(%ebp)
  80356e:	50                   	push   %eax
  80356f:	6a 15                	push   $0x15
  803571:	e8 e4 fd ff ff       	call   80335a <syscall>
  803576:	83 c4 18             	add    $0x18,%esp
}
  803579:	c9                   	leave  
  80357a:	c3                   	ret    

0080357b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80357b:	55                   	push   %ebp
  80357c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80357e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803581:	8b 45 08             	mov    0x8(%ebp),%eax
  803584:	6a 00                	push   $0x0
  803586:	6a 00                	push   $0x0
  803588:	6a 00                	push   $0x0
  80358a:	52                   	push   %edx
  80358b:	50                   	push   %eax
  80358c:	6a 16                	push   $0x16
  80358e:	e8 c7 fd ff ff       	call   80335a <syscall>
  803593:	83 c4 18             	add    $0x18,%esp
}
  803596:	c9                   	leave  
  803597:	c3                   	ret    

00803598 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803598:	55                   	push   %ebp
  803599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80359b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80359e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	6a 00                	push   $0x0
  8035a6:	6a 00                	push   $0x0
  8035a8:	51                   	push   %ecx
  8035a9:	52                   	push   %edx
  8035aa:	50                   	push   %eax
  8035ab:	6a 17                	push   $0x17
  8035ad:	e8 a8 fd ff ff       	call   80335a <syscall>
  8035b2:	83 c4 18             	add    $0x18,%esp
}
  8035b5:	c9                   	leave  
  8035b6:	c3                   	ret    

008035b7 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8035b7:	55                   	push   %ebp
  8035b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8035ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	6a 00                	push   $0x0
  8035c2:	6a 00                	push   $0x0
  8035c4:	6a 00                	push   $0x0
  8035c6:	52                   	push   %edx
  8035c7:	50                   	push   %eax
  8035c8:	6a 18                	push   $0x18
  8035ca:	e8 8b fd ff ff       	call   80335a <syscall>
  8035cf:	83 c4 18             	add    $0x18,%esp
}
  8035d2:	c9                   	leave  
  8035d3:	c3                   	ret    

008035d4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8035d4:	55                   	push   %ebp
  8035d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8035d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035da:	6a 00                	push   $0x0
  8035dc:	ff 75 14             	pushl  0x14(%ebp)
  8035df:	ff 75 10             	pushl  0x10(%ebp)
  8035e2:	ff 75 0c             	pushl  0xc(%ebp)
  8035e5:	50                   	push   %eax
  8035e6:	6a 19                	push   $0x19
  8035e8:	e8 6d fd ff ff       	call   80335a <syscall>
  8035ed:	83 c4 18             	add    $0x18,%esp
}
  8035f0:	c9                   	leave  
  8035f1:	c3                   	ret    

008035f2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8035f2:	55                   	push   %ebp
  8035f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	6a 00                	push   $0x0
  8035fa:	6a 00                	push   $0x0
  8035fc:	6a 00                	push   $0x0
  8035fe:	6a 00                	push   $0x0
  803600:	50                   	push   %eax
  803601:	6a 1a                	push   $0x1a
  803603:	e8 52 fd ff ff       	call   80335a <syscall>
  803608:	83 c4 18             	add    $0x18,%esp
}
  80360b:	90                   	nop
  80360c:	c9                   	leave  
  80360d:	c3                   	ret    

0080360e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80360e:	55                   	push   %ebp
  80360f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803611:	8b 45 08             	mov    0x8(%ebp),%eax
  803614:	6a 00                	push   $0x0
  803616:	6a 00                	push   $0x0
  803618:	6a 00                	push   $0x0
  80361a:	6a 00                	push   $0x0
  80361c:	50                   	push   %eax
  80361d:	6a 1b                	push   $0x1b
  80361f:	e8 36 fd ff ff       	call   80335a <syscall>
  803624:	83 c4 18             	add    $0x18,%esp
}
  803627:	c9                   	leave  
  803628:	c3                   	ret    

00803629 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803629:	55                   	push   %ebp
  80362a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80362c:	6a 00                	push   $0x0
  80362e:	6a 00                	push   $0x0
  803630:	6a 00                	push   $0x0
  803632:	6a 00                	push   $0x0
  803634:	6a 00                	push   $0x0
  803636:	6a 05                	push   $0x5
  803638:	e8 1d fd ff ff       	call   80335a <syscall>
  80363d:	83 c4 18             	add    $0x18,%esp
}
  803640:	c9                   	leave  
  803641:	c3                   	ret    

00803642 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803642:	55                   	push   %ebp
  803643:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803645:	6a 00                	push   $0x0
  803647:	6a 00                	push   $0x0
  803649:	6a 00                	push   $0x0
  80364b:	6a 00                	push   $0x0
  80364d:	6a 00                	push   $0x0
  80364f:	6a 06                	push   $0x6
  803651:	e8 04 fd ff ff       	call   80335a <syscall>
  803656:	83 c4 18             	add    $0x18,%esp
}
  803659:	c9                   	leave  
  80365a:	c3                   	ret    

0080365b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80365b:	55                   	push   %ebp
  80365c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80365e:	6a 00                	push   $0x0
  803660:	6a 00                	push   $0x0
  803662:	6a 00                	push   $0x0
  803664:	6a 00                	push   $0x0
  803666:	6a 00                	push   $0x0
  803668:	6a 07                	push   $0x7
  80366a:	e8 eb fc ff ff       	call   80335a <syscall>
  80366f:	83 c4 18             	add    $0x18,%esp
}
  803672:	c9                   	leave  
  803673:	c3                   	ret    

00803674 <sys_exit_env>:


void sys_exit_env(void)
{
  803674:	55                   	push   %ebp
  803675:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803677:	6a 00                	push   $0x0
  803679:	6a 00                	push   $0x0
  80367b:	6a 00                	push   $0x0
  80367d:	6a 00                	push   $0x0
  80367f:	6a 00                	push   $0x0
  803681:	6a 1c                	push   $0x1c
  803683:	e8 d2 fc ff ff       	call   80335a <syscall>
  803688:	83 c4 18             	add    $0x18,%esp
}
  80368b:	90                   	nop
  80368c:	c9                   	leave  
  80368d:	c3                   	ret    

0080368e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80368e:	55                   	push   %ebp
  80368f:	89 e5                	mov    %esp,%ebp
  803691:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803694:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803697:	8d 50 04             	lea    0x4(%eax),%edx
  80369a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80369d:	6a 00                	push   $0x0
  80369f:	6a 00                	push   $0x0
  8036a1:	6a 00                	push   $0x0
  8036a3:	52                   	push   %edx
  8036a4:	50                   	push   %eax
  8036a5:	6a 1d                	push   $0x1d
  8036a7:	e8 ae fc ff ff       	call   80335a <syscall>
  8036ac:	83 c4 18             	add    $0x18,%esp
	return result;
  8036af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8036b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8036b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8036b8:	89 01                	mov    %eax,(%ecx)
  8036ba:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8036bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c0:	c9                   	leave  
  8036c1:	c2 04 00             	ret    $0x4

008036c4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8036c4:	55                   	push   %ebp
  8036c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8036c7:	6a 00                	push   $0x0
  8036c9:	6a 00                	push   $0x0
  8036cb:	ff 75 10             	pushl  0x10(%ebp)
  8036ce:	ff 75 0c             	pushl  0xc(%ebp)
  8036d1:	ff 75 08             	pushl  0x8(%ebp)
  8036d4:	6a 13                	push   $0x13
  8036d6:	e8 7f fc ff ff       	call   80335a <syscall>
  8036db:	83 c4 18             	add    $0x18,%esp
	return ;
  8036de:	90                   	nop
}
  8036df:	c9                   	leave  
  8036e0:	c3                   	ret    

008036e1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8036e1:	55                   	push   %ebp
  8036e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8036e4:	6a 00                	push   $0x0
  8036e6:	6a 00                	push   $0x0
  8036e8:	6a 00                	push   $0x0
  8036ea:	6a 00                	push   $0x0
  8036ec:	6a 00                	push   $0x0
  8036ee:	6a 1e                	push   $0x1e
  8036f0:	e8 65 fc ff ff       	call   80335a <syscall>
  8036f5:	83 c4 18             	add    $0x18,%esp
}
  8036f8:	c9                   	leave  
  8036f9:	c3                   	ret    

008036fa <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8036fa:	55                   	push   %ebp
  8036fb:	89 e5                	mov    %esp,%ebp
  8036fd:	83 ec 04             	sub    $0x4,%esp
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803706:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80370a:	6a 00                	push   $0x0
  80370c:	6a 00                	push   $0x0
  80370e:	6a 00                	push   $0x0
  803710:	6a 00                	push   $0x0
  803712:	50                   	push   %eax
  803713:	6a 1f                	push   $0x1f
  803715:	e8 40 fc ff ff       	call   80335a <syscall>
  80371a:	83 c4 18             	add    $0x18,%esp
	return ;
  80371d:	90                   	nop
}
  80371e:	c9                   	leave  
  80371f:	c3                   	ret    

00803720 <rsttst>:
void rsttst()
{
  803720:	55                   	push   %ebp
  803721:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803723:	6a 00                	push   $0x0
  803725:	6a 00                	push   $0x0
  803727:	6a 00                	push   $0x0
  803729:	6a 00                	push   $0x0
  80372b:	6a 00                	push   $0x0
  80372d:	6a 21                	push   $0x21
  80372f:	e8 26 fc ff ff       	call   80335a <syscall>
  803734:	83 c4 18             	add    $0x18,%esp
	return ;
  803737:	90                   	nop
}
  803738:	c9                   	leave  
  803739:	c3                   	ret    

0080373a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80373a:	55                   	push   %ebp
  80373b:	89 e5                	mov    %esp,%ebp
  80373d:	83 ec 04             	sub    $0x4,%esp
  803740:	8b 45 14             	mov    0x14(%ebp),%eax
  803743:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803746:	8b 55 18             	mov    0x18(%ebp),%edx
  803749:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80374d:	52                   	push   %edx
  80374e:	50                   	push   %eax
  80374f:	ff 75 10             	pushl  0x10(%ebp)
  803752:	ff 75 0c             	pushl  0xc(%ebp)
  803755:	ff 75 08             	pushl  0x8(%ebp)
  803758:	6a 20                	push   $0x20
  80375a:	e8 fb fb ff ff       	call   80335a <syscall>
  80375f:	83 c4 18             	add    $0x18,%esp
	return ;
  803762:	90                   	nop
}
  803763:	c9                   	leave  
  803764:	c3                   	ret    

00803765 <chktst>:
void chktst(uint32 n)
{
  803765:	55                   	push   %ebp
  803766:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803768:	6a 00                	push   $0x0
  80376a:	6a 00                	push   $0x0
  80376c:	6a 00                	push   $0x0
  80376e:	6a 00                	push   $0x0
  803770:	ff 75 08             	pushl  0x8(%ebp)
  803773:	6a 22                	push   $0x22
  803775:	e8 e0 fb ff ff       	call   80335a <syscall>
  80377a:	83 c4 18             	add    $0x18,%esp
	return ;
  80377d:	90                   	nop
}
  80377e:	c9                   	leave  
  80377f:	c3                   	ret    

00803780 <inctst>:

void inctst()
{
  803780:	55                   	push   %ebp
  803781:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803783:	6a 00                	push   $0x0
  803785:	6a 00                	push   $0x0
  803787:	6a 00                	push   $0x0
  803789:	6a 00                	push   $0x0
  80378b:	6a 00                	push   $0x0
  80378d:	6a 23                	push   $0x23
  80378f:	e8 c6 fb ff ff       	call   80335a <syscall>
  803794:	83 c4 18             	add    $0x18,%esp
	return ;
  803797:	90                   	nop
}
  803798:	c9                   	leave  
  803799:	c3                   	ret    

0080379a <gettst>:
uint32 gettst()
{
  80379a:	55                   	push   %ebp
  80379b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80379d:	6a 00                	push   $0x0
  80379f:	6a 00                	push   $0x0
  8037a1:	6a 00                	push   $0x0
  8037a3:	6a 00                	push   $0x0
  8037a5:	6a 00                	push   $0x0
  8037a7:	6a 24                	push   $0x24
  8037a9:	e8 ac fb ff ff       	call   80335a <syscall>
  8037ae:	83 c4 18             	add    $0x18,%esp
}
  8037b1:	c9                   	leave  
  8037b2:	c3                   	ret    

008037b3 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8037b3:	55                   	push   %ebp
  8037b4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8037b6:	6a 00                	push   $0x0
  8037b8:	6a 00                	push   $0x0
  8037ba:	6a 00                	push   $0x0
  8037bc:	6a 00                	push   $0x0
  8037be:	6a 00                	push   $0x0
  8037c0:	6a 25                	push   $0x25
  8037c2:	e8 93 fb ff ff       	call   80335a <syscall>
  8037c7:	83 c4 18             	add    $0x18,%esp
  8037ca:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  8037cf:	a1 80 60 83 00       	mov    0x836080,%eax
}
  8037d4:	c9                   	leave  
  8037d5:	c3                   	ret    

008037d6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8037d6:	55                   	push   %ebp
  8037d7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8037d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dc:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8037e1:	6a 00                	push   $0x0
  8037e3:	6a 00                	push   $0x0
  8037e5:	6a 00                	push   $0x0
  8037e7:	6a 00                	push   $0x0
  8037e9:	ff 75 08             	pushl  0x8(%ebp)
  8037ec:	6a 26                	push   $0x26
  8037ee:	e8 67 fb ff ff       	call   80335a <syscall>
  8037f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8037f6:	90                   	nop
}
  8037f7:	c9                   	leave  
  8037f8:	c3                   	ret    

008037f9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8037f9:	55                   	push   %ebp
  8037fa:	89 e5                	mov    %esp,%ebp
  8037fc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8037fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803800:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803803:	8b 55 0c             	mov    0xc(%ebp),%edx
  803806:	8b 45 08             	mov    0x8(%ebp),%eax
  803809:	6a 00                	push   $0x0
  80380b:	53                   	push   %ebx
  80380c:	51                   	push   %ecx
  80380d:	52                   	push   %edx
  80380e:	50                   	push   %eax
  80380f:	6a 27                	push   $0x27
  803811:	e8 44 fb ff ff       	call   80335a <syscall>
  803816:	83 c4 18             	add    $0x18,%esp
}
  803819:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80381c:	c9                   	leave  
  80381d:	c3                   	ret    

0080381e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80381e:	55                   	push   %ebp
  80381f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803821:	8b 55 0c             	mov    0xc(%ebp),%edx
  803824:	8b 45 08             	mov    0x8(%ebp),%eax
  803827:	6a 00                	push   $0x0
  803829:	6a 00                	push   $0x0
  80382b:	6a 00                	push   $0x0
  80382d:	52                   	push   %edx
  80382e:	50                   	push   %eax
  80382f:	6a 28                	push   $0x28
  803831:	e8 24 fb ff ff       	call   80335a <syscall>
  803836:	83 c4 18             	add    $0x18,%esp
}
  803839:	c9                   	leave  
  80383a:	c3                   	ret    

0080383b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80383b:	55                   	push   %ebp
  80383c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80383e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803841:	8b 55 0c             	mov    0xc(%ebp),%edx
  803844:	8b 45 08             	mov    0x8(%ebp),%eax
  803847:	6a 00                	push   $0x0
  803849:	51                   	push   %ecx
  80384a:	ff 75 10             	pushl  0x10(%ebp)
  80384d:	52                   	push   %edx
  80384e:	50                   	push   %eax
  80384f:	6a 29                	push   $0x29
  803851:	e8 04 fb ff ff       	call   80335a <syscall>
  803856:	83 c4 18             	add    $0x18,%esp
}
  803859:	c9                   	leave  
  80385a:	c3                   	ret    

0080385b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80385b:	55                   	push   %ebp
  80385c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80385e:	6a 00                	push   $0x0
  803860:	6a 00                	push   $0x0
  803862:	ff 75 10             	pushl  0x10(%ebp)
  803865:	ff 75 0c             	pushl  0xc(%ebp)
  803868:	ff 75 08             	pushl  0x8(%ebp)
  80386b:	6a 12                	push   $0x12
  80386d:	e8 e8 fa ff ff       	call   80335a <syscall>
  803872:	83 c4 18             	add    $0x18,%esp
	return ;
  803875:	90                   	nop
}
  803876:	c9                   	leave  
  803877:	c3                   	ret    

00803878 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803878:	55                   	push   %ebp
  803879:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80387b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80387e:	8b 45 08             	mov    0x8(%ebp),%eax
  803881:	6a 00                	push   $0x0
  803883:	6a 00                	push   $0x0
  803885:	6a 00                	push   $0x0
  803887:	52                   	push   %edx
  803888:	50                   	push   %eax
  803889:	6a 2a                	push   $0x2a
  80388b:	e8 ca fa ff ff       	call   80335a <syscall>
  803890:	83 c4 18             	add    $0x18,%esp
	return;
  803893:	90                   	nop
}
  803894:	c9                   	leave  
  803895:	c3                   	ret    

00803896 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803896:	55                   	push   %ebp
  803897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803899:	6a 00                	push   $0x0
  80389b:	6a 00                	push   $0x0
  80389d:	6a 00                	push   $0x0
  80389f:	6a 00                	push   $0x0
  8038a1:	6a 00                	push   $0x0
  8038a3:	6a 2b                	push   $0x2b
  8038a5:	e8 b0 fa ff ff       	call   80335a <syscall>
  8038aa:	83 c4 18             	add    $0x18,%esp
}
  8038ad:	c9                   	leave  
  8038ae:	c3                   	ret    

008038af <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8038af:	55                   	push   %ebp
  8038b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8038b2:	6a 00                	push   $0x0
  8038b4:	6a 00                	push   $0x0
  8038b6:	6a 00                	push   $0x0
  8038b8:	ff 75 0c             	pushl  0xc(%ebp)
  8038bb:	ff 75 08             	pushl  0x8(%ebp)
  8038be:	6a 2d                	push   $0x2d
  8038c0:	e8 95 fa ff ff       	call   80335a <syscall>
  8038c5:	83 c4 18             	add    $0x18,%esp
	return;
  8038c8:	90                   	nop
}
  8038c9:	c9                   	leave  
  8038ca:	c3                   	ret    

008038cb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8038cb:	55                   	push   %ebp
  8038cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8038ce:	6a 00                	push   $0x0
  8038d0:	6a 00                	push   $0x0
  8038d2:	6a 00                	push   $0x0
  8038d4:	ff 75 0c             	pushl  0xc(%ebp)
  8038d7:	ff 75 08             	pushl  0x8(%ebp)
  8038da:	6a 2c                	push   $0x2c
  8038dc:	e8 79 fa ff ff       	call   80335a <syscall>
  8038e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8038e4:	90                   	nop
}
  8038e5:	c9                   	leave  
  8038e6:	c3                   	ret    

008038e7 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8038e7:	55                   	push   %ebp
  8038e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8038ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f0:	6a 00                	push   $0x0
  8038f2:	6a 00                	push   $0x0
  8038f4:	6a 00                	push   $0x0
  8038f6:	52                   	push   %edx
  8038f7:	50                   	push   %eax
  8038f8:	6a 2e                	push   $0x2e
  8038fa:	e8 5b fa ff ff       	call   80335a <syscall>
  8038ff:	83 c4 18             	add    $0x18,%esp
}
  803902:	90                   	nop
  803903:	c9                   	leave  
  803904:	c3                   	ret    

00803905 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803905:	55                   	push   %ebp
  803906:	89 e5                	mov    %esp,%ebp
  803908:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80390b:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  803912:	72 09                	jb     80391d <to_page_va+0x18>
  803914:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  80391b:	72 14                	jb     803931 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80391d:	83 ec 04             	sub    $0x4,%esp
  803920:	68 d8 4f 80 00       	push   $0x804fd8
  803925:	6a 15                	push   $0x15
  803927:	68 03 50 80 00       	push   $0x805003
  80392c:	e8 10 d0 ff ff       	call   800941 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803931:	8b 45 08             	mov    0x8(%ebp),%eax
  803934:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  803939:	29 d0                	sub    %edx,%eax
  80393b:	c1 f8 02             	sar    $0x2,%eax
  80393e:	89 c2                	mov    %eax,%edx
  803940:	89 d0                	mov    %edx,%eax
  803942:	c1 e0 02             	shl    $0x2,%eax
  803945:	01 d0                	add    %edx,%eax
  803947:	c1 e0 02             	shl    $0x2,%eax
  80394a:	01 d0                	add    %edx,%eax
  80394c:	c1 e0 02             	shl    $0x2,%eax
  80394f:	01 d0                	add    %edx,%eax
  803951:	89 c1                	mov    %eax,%ecx
  803953:	c1 e1 08             	shl    $0x8,%ecx
  803956:	01 c8                	add    %ecx,%eax
  803958:	89 c1                	mov    %eax,%ecx
  80395a:	c1 e1 10             	shl    $0x10,%ecx
  80395d:	01 c8                	add    %ecx,%eax
  80395f:	01 c0                	add    %eax,%eax
  803961:	01 d0                	add    %edx,%eax
  803963:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803969:	c1 e0 0c             	shl    $0xc,%eax
  80396c:	89 c2                	mov    %eax,%edx
  80396e:	a1 84 60 83 00       	mov    0x836084,%eax
  803973:	01 d0                	add    %edx,%eax
}
  803975:	c9                   	leave  
  803976:	c3                   	ret    

00803977 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803977:	55                   	push   %ebp
  803978:	89 e5                	mov    %esp,%ebp
  80397a:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80397d:	a1 84 60 83 00       	mov    0x836084,%eax
  803982:	8b 55 08             	mov    0x8(%ebp),%edx
  803985:	29 c2                	sub    %eax,%edx
  803987:	89 d0                	mov    %edx,%eax
  803989:	c1 e8 0c             	shr    $0xc,%eax
  80398c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  80398f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803993:	78 09                	js     80399e <to_page_info+0x27>
  803995:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80399c:	7e 14                	jle    8039b2 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  80399e:	83 ec 04             	sub    $0x4,%esp
  8039a1:	68 1c 50 80 00       	push   $0x80501c
  8039a6:	6a 21                	push   $0x21
  8039a8:	68 03 50 80 00       	push   $0x805003
  8039ad:	e8 8f cf ff ff       	call   800941 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8039b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039b5:	89 d0                	mov    %edx,%eax
  8039b7:	01 c0                	add    %eax,%eax
  8039b9:	01 d0                	add    %edx,%eax
  8039bb:	c1 e0 02             	shl    $0x2,%eax
  8039be:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  8039c3:	c9                   	leave  
  8039c4:	c3                   	ret    

008039c5 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8039c5:	55                   	push   %ebp
  8039c6:	89 e5                	mov    %esp,%ebp
  8039c8:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8039cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ce:	05 00 00 00 02       	add    $0x2000000,%eax
  8039d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8039d6:	73 16                	jae    8039ee <initialize_dynamic_allocator+0x29>
  8039d8:	68 40 50 80 00       	push   $0x805040
  8039dd:	68 66 50 80 00       	push   $0x805066
  8039e2:	6a 2f                	push   $0x2f
  8039e4:	68 03 50 80 00       	push   $0x805003
  8039e9:	e8 53 cf ff ff       	call   800941 <_panic>
	dynAllocStart = daStart;
  8039ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f1:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  8039f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039f9:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8039fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a05:	eb 36                	jmp    803a3d <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  803a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0a:	c1 e0 04             	shl    $0x4,%eax
  803a0d:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803a12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1b:	c1 e0 04             	shl    $0x4,%eax
  803a1e:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803a23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2c:	c1 e0 04             	shl    $0x4,%eax
  803a2f:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803a34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803a3a:	ff 45 f4             	incl   -0xc(%ebp)
  803a3d:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803a41:	7e c4                	jle    803a07 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803a43:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  803a4a:	00 00 00 
  803a4d:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803a54:	00 00 00 
  803a57:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  803a5e:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803a61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a68:	e9 1b 01 00 00       	jmp    803b88 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  803a6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a70:	89 d0                	mov    %edx,%eax
  803a72:	01 c0                	add    %eax,%eax
  803a74:	01 d0                	add    %edx,%eax
  803a76:	c1 e0 02             	shl    $0x2,%eax
  803a79:	05 88 e0 81 00       	add    $0x81e088,%eax
  803a7e:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803a83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a86:	89 d0                	mov    %edx,%eax
  803a88:	01 c0                	add    %eax,%eax
  803a8a:	01 d0                	add    %edx,%eax
  803a8c:	c1 e0 02             	shl    $0x2,%eax
  803a8f:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803a94:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  803a99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a9c:	89 d0                	mov    %edx,%eax
  803a9e:	01 c0                	add    %eax,%eax
  803aa0:	01 d0                	add    %edx,%eax
  803aa2:	c1 e0 02             	shl    $0x2,%eax
  803aa5:	05 80 e0 81 00       	add    $0x81e080,%eax
  803aaa:	8b 00                	mov    (%eax),%eax
  803aac:	85 c0                	test   %eax,%eax
  803aae:	74 2b                	je     803adb <initialize_dynamic_allocator+0x116>
  803ab0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ab3:	89 d0                	mov    %edx,%eax
  803ab5:	01 c0                	add    %eax,%eax
  803ab7:	01 d0                	add    %edx,%eax
  803ab9:	c1 e0 02             	shl    $0x2,%eax
  803abc:	05 80 e0 81 00       	add    $0x81e080,%eax
  803ac1:	8b 10                	mov    (%eax),%edx
  803ac3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803ac6:	89 c8                	mov    %ecx,%eax
  803ac8:	01 c0                	add    %eax,%eax
  803aca:	01 c8                	add    %ecx,%eax
  803acc:	c1 e0 02             	shl    $0x2,%eax
  803acf:	05 84 e0 81 00       	add    $0x81e084,%eax
  803ad4:	8b 00                	mov    (%eax),%eax
  803ad6:	89 42 04             	mov    %eax,0x4(%edx)
  803ad9:	eb 18                	jmp    803af3 <initialize_dynamic_allocator+0x12e>
  803adb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ade:	89 d0                	mov    %edx,%eax
  803ae0:	01 c0                	add    %eax,%eax
  803ae2:	01 d0                	add    %edx,%eax
  803ae4:	c1 e0 02             	shl    $0x2,%eax
  803ae7:	05 84 e0 81 00       	add    $0x81e084,%eax
  803aec:	8b 00                	mov    (%eax),%eax
  803aee:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803af3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803af6:	89 d0                	mov    %edx,%eax
  803af8:	01 c0                	add    %eax,%eax
  803afa:	01 d0                	add    %edx,%eax
  803afc:	c1 e0 02             	shl    $0x2,%eax
  803aff:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b04:	8b 00                	mov    (%eax),%eax
  803b06:	85 c0                	test   %eax,%eax
  803b08:	74 2a                	je     803b34 <initialize_dynamic_allocator+0x16f>
  803b0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b0d:	89 d0                	mov    %edx,%eax
  803b0f:	01 c0                	add    %eax,%eax
  803b11:	01 d0                	add    %edx,%eax
  803b13:	c1 e0 02             	shl    $0x2,%eax
  803b16:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b1b:	8b 10                	mov    (%eax),%edx
  803b1d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b20:	89 c8                	mov    %ecx,%eax
  803b22:	01 c0                	add    %eax,%eax
  803b24:	01 c8                	add    %ecx,%eax
  803b26:	c1 e0 02             	shl    $0x2,%eax
  803b29:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b2e:	8b 00                	mov    (%eax),%eax
  803b30:	89 02                	mov    %eax,(%edx)
  803b32:	eb 18                	jmp    803b4c <initialize_dynamic_allocator+0x187>
  803b34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b37:	89 d0                	mov    %edx,%eax
  803b39:	01 c0                	add    %eax,%eax
  803b3b:	01 d0                	add    %edx,%eax
  803b3d:	c1 e0 02             	shl    $0x2,%eax
  803b40:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b45:	8b 00                	mov    (%eax),%eax
  803b47:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803b4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b4f:	89 d0                	mov    %edx,%eax
  803b51:	01 c0                	add    %eax,%eax
  803b53:	01 d0                	add    %edx,%eax
  803b55:	c1 e0 02             	shl    $0x2,%eax
  803b58:	05 80 e0 81 00       	add    $0x81e080,%eax
  803b5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b66:	89 d0                	mov    %edx,%eax
  803b68:	01 c0                	add    %eax,%eax
  803b6a:	01 d0                	add    %edx,%eax
  803b6c:	c1 e0 02             	shl    $0x2,%eax
  803b6f:	05 84 e0 81 00       	add    $0x81e084,%eax
  803b74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b7a:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803b7f:	48                   	dec    %eax
  803b80:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803b85:	ff 45 f0             	incl   -0x10(%ebp)
  803b88:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803b8f:	0f 8e d8 fe ff ff    	jle    803a6d <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803b95:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  803b9c:	e9 9d 00 00 00       	jmp    803c3e <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803ba1:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803ba7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803baa:	89 c8                	mov    %ecx,%eax
  803bac:	01 c0                	add    %eax,%eax
  803bae:	01 c8                	add    %ecx,%eax
  803bb0:	c1 e0 02             	shl    $0x2,%eax
  803bb3:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bb8:	89 10                	mov    %edx,(%eax)
  803bba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bbd:	89 d0                	mov    %edx,%eax
  803bbf:	01 c0                	add    %eax,%eax
  803bc1:	01 d0                	add    %edx,%eax
  803bc3:	c1 e0 02             	shl    $0x2,%eax
  803bc6:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bcb:	8b 00                	mov    (%eax),%eax
  803bcd:	85 c0                	test   %eax,%eax
  803bcf:	74 1c                	je     803bed <initialize_dynamic_allocator+0x228>
  803bd1:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803bd7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803bda:	89 c8                	mov    %ecx,%eax
  803bdc:	01 c0                	add    %eax,%eax
  803bde:	01 c8                	add    %ecx,%eax
  803be0:	c1 e0 02             	shl    $0x2,%eax
  803be3:	05 80 e0 81 00       	add    $0x81e080,%eax
  803be8:	89 42 04             	mov    %eax,0x4(%edx)
  803beb:	eb 16                	jmp    803c03 <initialize_dynamic_allocator+0x23e>
  803bed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bf0:	89 d0                	mov    %edx,%eax
  803bf2:	01 c0                	add    %eax,%eax
  803bf4:	01 d0                	add    %edx,%eax
  803bf6:	c1 e0 02             	shl    $0x2,%eax
  803bf9:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bfe:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803c03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c06:	89 d0                	mov    %edx,%eax
  803c08:	01 c0                	add    %eax,%eax
  803c0a:	01 d0                	add    %edx,%eax
  803c0c:	c1 e0 02             	shl    $0x2,%eax
  803c0f:	05 80 e0 81 00       	add    $0x81e080,%eax
  803c14:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803c19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c1c:	89 d0                	mov    %edx,%eax
  803c1e:	01 c0                	add    %eax,%eax
  803c20:	01 d0                	add    %edx,%eax
  803c22:	c1 e0 02             	shl    $0x2,%eax
  803c25:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c30:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803c35:	40                   	inc    %eax
  803c36:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803c3b:	ff 4d ec             	decl   -0x14(%ebp)
  803c3e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c42:	0f 89 59 ff ff ff    	jns    803ba1 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803c48:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803c4f:	00 00 00 
}
  803c52:	90                   	nop
  803c53:	c9                   	leave  
  803c54:	c3                   	ret    

00803c55 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803c55:	55                   	push   %ebp
  803c56:	89 e5                	mov    %esp,%ebp
  803c58:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5e:	83 ec 0c             	sub    $0xc,%esp
  803c61:	50                   	push   %eax
  803c62:	e8 10 fd ff ff       	call   803977 <to_page_info>
  803c67:	83 c4 10             	add    $0x10,%esp
  803c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  803c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c70:	8b 40 08             	mov    0x8(%eax),%eax
  803c73:	0f b7 c0             	movzwl %ax,%eax
}
  803c76:	c9                   	leave  
  803c77:	c3                   	ret    

00803c78 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803c78:	55                   	push   %ebp
  803c79:	89 e5                	mov    %esp,%ebp
  803c7b:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803c7e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803c85:	76 16                	jbe    803c9d <alloc_block+0x25>
  803c87:	68 7c 50 80 00       	push   $0x80507c
  803c8c:	68 66 50 80 00       	push   $0x805066
  803c91:	6a 59                	push   $0x59
  803c93:	68 03 50 80 00       	push   $0x805003
  803c98:	e8 a4 cc ff ff       	call   800941 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  803c9d:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803ca4:	eb 08                	jmp    803cae <alloc_block+0x36>
		allocSize <<= 1;
  803ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca9:	01 c0                	add    %eax,%eax
  803cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  803cb4:	73 09                	jae    803cbf <alloc_block+0x47>
  803cb6:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  803cbd:	76 e7                	jbe    803ca6 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  803cbf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803cc6:	eb 03                	jmp    803ccb <alloc_block+0x53>
		listIndex++;
  803cc8:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  803ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cce:	ba 08 00 00 00       	mov    $0x8,%edx
  803cd3:	88 c1                	mov    %al,%cl
  803cd5:	d3 e2                	shl    %cl,%edx
  803cd7:	89 d0                	mov    %edx,%eax
  803cd9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803cdc:	72 ea                	jb     803cc8 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ce1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803ce4:	e9 f4 00 00 00       	jmp    803ddd <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  803ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cec:	c1 e0 04             	shl    $0x4,%eax
  803cef:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803cf4:	8b 00                	mov    (%eax),%eax
  803cf6:	85 c0                	test   %eax,%eax
  803cf8:	0f 84 dc 00 00 00    	je     803dda <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d01:	c1 e0 04             	shl    $0x4,%eax
  803d04:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803d09:	8b 00                	mov    (%eax),%eax
  803d0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  803d0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d12:	75 14                	jne    803d28 <alloc_block+0xb0>
  803d14:	83 ec 04             	sub    $0x4,%esp
  803d17:	68 9d 50 80 00       	push   $0x80509d
  803d1c:	6a 6b                	push   $0x6b
  803d1e:	68 03 50 80 00       	push   $0x805003
  803d23:	e8 19 cc ff ff       	call   800941 <_panic>
  803d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2b:	8b 00                	mov    (%eax),%eax
  803d2d:	85 c0                	test   %eax,%eax
  803d2f:	74 10                	je     803d41 <alloc_block+0xc9>
  803d31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d34:	8b 00                	mov    (%eax),%eax
  803d36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d39:	8b 52 04             	mov    0x4(%edx),%edx
  803d3c:	89 50 04             	mov    %edx,0x4(%eax)
  803d3f:	eb 14                	jmp    803d55 <alloc_block+0xdd>
  803d41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d44:	8b 40 04             	mov    0x4(%eax),%eax
  803d47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d4a:	c1 e2 04             	shl    $0x4,%edx
  803d4d:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803d53:	89 02                	mov    %eax,(%edx)
  803d55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d58:	8b 40 04             	mov    0x4(%eax),%eax
  803d5b:	85 c0                	test   %eax,%eax
  803d5d:	74 0f                	je     803d6e <alloc_block+0xf6>
  803d5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d62:	8b 40 04             	mov    0x4(%eax),%eax
  803d65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d68:	8b 12                	mov    (%edx),%edx
  803d6a:	89 10                	mov    %edx,(%eax)
  803d6c:	eb 13                	jmp    803d81 <alloc_block+0x109>
  803d6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d71:	8b 00                	mov    (%eax),%eax
  803d73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d76:	c1 e2 04             	shl    $0x4,%edx
  803d79:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803d7f:	89 02                	mov    %eax,(%edx)
  803d81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d97:	c1 e0 04             	shl    $0x4,%eax
  803d9a:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803d9f:	8b 00                	mov    (%eax),%eax
  803da1:	8d 50 ff             	lea    -0x1(%eax),%edx
  803da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803da7:	c1 e0 04             	shl    $0x4,%eax
  803daa:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803daf:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db4:	83 ec 0c             	sub    $0xc,%esp
  803db7:	50                   	push   %eax
  803db8:	e8 ba fb ff ff       	call   803977 <to_page_info>
  803dbd:	83 c4 10             	add    $0x10,%esp
  803dc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dc6:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803dca:	48                   	dec    %eax
  803dcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803dce:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd5:	e9 8f 02 00 00       	jmp    804069 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803dda:	ff 45 ec             	incl   -0x14(%ebp)
  803ddd:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803de1:	0f 8e 02 ff ff ff    	jle    803ce9 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803de7:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803dec:	85 c0                	test   %eax,%eax
  803dee:	75 14                	jne    803e04 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803df0:	83 ec 04             	sub    $0x4,%esp
  803df3:	68 bc 50 80 00       	push   $0x8050bc
  803df8:	6a 77                	push   $0x77
  803dfa:	68 03 50 80 00       	push   $0x805003
  803dff:	e8 3d cb ff ff       	call   800941 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803e04:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803e09:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803e0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803e10:	75 14                	jne    803e26 <alloc_block+0x1ae>
  803e12:	83 ec 04             	sub    $0x4,%esp
  803e15:	68 9d 50 80 00       	push   $0x80509d
  803e1a:	6a 7a                	push   $0x7a
  803e1c:	68 03 50 80 00       	push   $0x805003
  803e21:	e8 1b cb ff ff       	call   800941 <_panic>
  803e26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e29:	8b 00                	mov    (%eax),%eax
  803e2b:	85 c0                	test   %eax,%eax
  803e2d:	74 10                	je     803e3f <alloc_block+0x1c7>
  803e2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e32:	8b 00                	mov    (%eax),%eax
  803e34:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e37:	8b 52 04             	mov    0x4(%edx),%edx
  803e3a:	89 50 04             	mov    %edx,0x4(%eax)
  803e3d:	eb 0b                	jmp    803e4a <alloc_block+0x1d2>
  803e3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e42:	8b 40 04             	mov    0x4(%eax),%eax
  803e45:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803e4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e4d:	8b 40 04             	mov    0x4(%eax),%eax
  803e50:	85 c0                	test   %eax,%eax
  803e52:	74 0f                	je     803e63 <alloc_block+0x1eb>
  803e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e57:	8b 40 04             	mov    0x4(%eax),%eax
  803e5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e5d:	8b 12                	mov    (%edx),%edx
  803e5f:	89 10                	mov    %edx,(%eax)
  803e61:	eb 0a                	jmp    803e6d <alloc_block+0x1f5>
  803e63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e66:	8b 00                	mov    (%eax),%eax
  803e68:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803e6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e80:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803e85:	48                   	dec    %eax
  803e86:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803e8b:	83 ec 0c             	sub    $0xc,%esp
  803e8e:	ff 75 dc             	pushl  -0x24(%ebp)
  803e91:	e8 6f fa ff ff       	call   803905 <to_page_va>
  803e96:	83 c4 10             	add    $0x10,%esp
  803e99:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803e9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803e9f:	83 ec 0c             	sub    $0xc,%esp
  803ea2:	50                   	push   %eax
  803ea3:	e8 a0 dc ff ff       	call   801b48 <get_page>
  803ea8:	83 c4 10             	add    $0x10,%esp
  803eab:	85 c0                	test   %eax,%eax
  803ead:	74 14                	je     803ec3 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803eaf:	83 ec 04             	sub    $0x4,%esp
  803eb2:	68 e4 50 80 00       	push   $0x8050e4
  803eb7:	6a 7f                	push   $0x7f
  803eb9:	68 03 50 80 00       	push   $0x805003
  803ebe:	e8 7e ca ff ff       	call   800941 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ec9:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803ecd:	b8 00 10 00 00       	mov    $0x1000,%eax
  803ed2:	ba 00 00 00 00       	mov    $0x0,%edx
  803ed7:	f7 75 f4             	divl   -0xc(%ebp)
  803eda:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803edd:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803ee1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ee8:	e9 a7 00 00 00       	jmp    803f94 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803eed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803ef0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ef3:	01 d0                	add    %edx,%eax
  803ef5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803ef8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803efc:	75 17                	jne    803f15 <alloc_block+0x29d>
  803efe:	83 ec 04             	sub    $0x4,%esp
  803f01:	68 0c 51 80 00       	push   $0x80510c
  803f06:	68 88 00 00 00       	push   $0x88
  803f0b:	68 03 50 80 00       	push   $0x805003
  803f10:	e8 2c ca ff ff       	call   800941 <_panic>
  803f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f18:	c1 e0 04             	shl    $0x4,%eax
  803f1b:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f20:	8b 10                	mov    (%eax),%edx
  803f22:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f25:	89 10                	mov    %edx,(%eax)
  803f27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f2a:	8b 00                	mov    (%eax),%eax
  803f2c:	85 c0                	test   %eax,%eax
  803f2e:	74 15                	je     803f45 <alloc_block+0x2cd>
  803f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f33:	c1 e0 04             	shl    $0x4,%eax
  803f36:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f3b:	8b 00                	mov    (%eax),%eax
  803f3d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803f40:	89 50 04             	mov    %edx,0x4(%eax)
  803f43:	eb 11                	jmp    803f56 <alloc_block+0x2de>
  803f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f48:	c1 e0 04             	shl    $0x4,%eax
  803f4b:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803f51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f54:	89 02                	mov    %eax,(%edx)
  803f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f59:	c1 e0 04             	shl    $0x4,%eax
  803f5c:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803f62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f65:	89 02                	mov    %eax,(%edx)
  803f67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803f6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f74:	c1 e0 04             	shl    $0x4,%eax
  803f77:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f7c:	8b 00                	mov    (%eax),%eax
  803f7e:	8d 50 01             	lea    0x1(%eax),%edx
  803f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f84:	c1 e0 04             	shl    $0x4,%eax
  803f87:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803f8c:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f91:	01 45 e8             	add    %eax,-0x18(%ebp)
  803f94:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803f9b:	0f 86 4c ff ff ff    	jbe    803eed <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa4:	c1 e0 04             	shl    $0x4,%eax
  803fa7:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803fac:	8b 00                	mov    (%eax),%eax
  803fae:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803fb1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803fb5:	75 17                	jne    803fce <alloc_block+0x356>
  803fb7:	83 ec 04             	sub    $0x4,%esp
  803fba:	68 9d 50 80 00       	push   $0x80509d
  803fbf:	68 8d 00 00 00       	push   $0x8d
  803fc4:	68 03 50 80 00       	push   $0x805003
  803fc9:	e8 73 c9 ff ff       	call   800941 <_panic>
  803fce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fd1:	8b 00                	mov    (%eax),%eax
  803fd3:	85 c0                	test   %eax,%eax
  803fd5:	74 10                	je     803fe7 <alloc_block+0x36f>
  803fd7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fda:	8b 00                	mov    (%eax),%eax
  803fdc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803fdf:	8b 52 04             	mov    0x4(%edx),%edx
  803fe2:	89 50 04             	mov    %edx,0x4(%eax)
  803fe5:	eb 14                	jmp    803ffb <alloc_block+0x383>
  803fe7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803fea:	8b 40 04             	mov    0x4(%eax),%eax
  803fed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ff0:	c1 e2 04             	shl    $0x4,%edx
  803ff3:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803ff9:	89 02                	mov    %eax,(%edx)
  803ffb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ffe:	8b 40 04             	mov    0x4(%eax),%eax
  804001:	85 c0                	test   %eax,%eax
  804003:	74 0f                	je     804014 <alloc_block+0x39c>
  804005:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804008:	8b 40 04             	mov    0x4(%eax),%eax
  80400b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80400e:	8b 12                	mov    (%edx),%edx
  804010:	89 10                	mov    %edx,(%eax)
  804012:	eb 13                	jmp    804027 <alloc_block+0x3af>
  804014:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804017:	8b 00                	mov    (%eax),%eax
  804019:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80401c:	c1 e2 04             	shl    $0x4,%edx
  80401f:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  804025:	89 02                	mov    %eax,(%edx)
  804027:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80402a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804030:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804033:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80403a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80403d:	c1 e0 04             	shl    $0x4,%eax
  804040:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804045:	8b 00                	mov    (%eax),%eax
  804047:	8d 50 ff             	lea    -0x1(%eax),%edx
  80404a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80404d:	c1 e0 04             	shl    $0x4,%eax
  804050:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804055:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  804057:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80405a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80405e:	48                   	dec    %eax
  80405f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804062:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  804066:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  804069:	c9                   	leave  
  80406a:	c3                   	ret    

0080406b <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80406b:	55                   	push   %ebp
  80406c:	89 e5                	mov    %esp,%ebp
  80406e:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804071:	8b 55 08             	mov    0x8(%ebp),%edx
  804074:	a1 84 60 83 00       	mov    0x836084,%eax
  804079:	39 c2                	cmp    %eax,%edx
  80407b:	72 0c                	jb     804089 <free_block+0x1e>
  80407d:	8b 55 08             	mov    0x8(%ebp),%edx
  804080:	a1 60 e0 81 00       	mov    0x81e060,%eax
  804085:	39 c2                	cmp    %eax,%edx
  804087:	72 19                	jb     8040a2 <free_block+0x37>
  804089:	68 30 51 80 00       	push   $0x805130
  80408e:	68 66 50 80 00       	push   $0x805066
  804093:	68 98 00 00 00       	push   $0x98
  804098:	68 03 50 80 00       	push   $0x805003
  80409d:	e8 9f c8 ff ff       	call   800941 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8040a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a5:	83 ec 0c             	sub    $0xc,%esp
  8040a8:	50                   	push   %eax
  8040a9:	e8 c9 f8 ff ff       	call   803977 <to_page_info>
  8040ae:	83 c4 10             	add    $0x10,%esp
  8040b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  8040b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040b7:	8b 40 08             	mov    0x8(%eax),%eax
  8040ba:	0f b7 c0             	movzwl %ax,%eax
  8040bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  8040c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8040c7:	eb 03                	jmp    8040cc <free_block+0x61>
		listIndex++;
  8040c9:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  8040cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040cf:	ba 08 00 00 00       	mov    $0x8,%edx
  8040d4:	88 c1                	mov    %al,%cl
  8040d6:	d3 e2                	shl    %cl,%edx
  8040d8:	89 d0                	mov    %edx,%eax
  8040da:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8040dd:	72 ea                	jb     8040c9 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  8040df:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  8040e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040e9:	75 17                	jne    804102 <free_block+0x97>
  8040eb:	83 ec 04             	sub    $0x4,%esp
  8040ee:	68 0c 51 80 00       	push   $0x80510c
  8040f3:	68 a2 00 00 00       	push   $0xa2
  8040f8:	68 03 50 80 00       	push   $0x805003
  8040fd:	e8 3f c8 ff ff       	call   800941 <_panic>
  804102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804105:	c1 e0 04             	shl    $0x4,%eax
  804108:	05 a0 60 83 00       	add    $0x8360a0,%eax
  80410d:	8b 10                	mov    (%eax),%edx
  80410f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804112:	89 10                	mov    %edx,(%eax)
  804114:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804117:	8b 00                	mov    (%eax),%eax
  804119:	85 c0                	test   %eax,%eax
  80411b:	74 15                	je     804132 <free_block+0xc7>
  80411d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804120:	c1 e0 04             	shl    $0x4,%eax
  804123:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804128:	8b 00                	mov    (%eax),%eax
  80412a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80412d:	89 50 04             	mov    %edx,0x4(%eax)
  804130:	eb 11                	jmp    804143 <free_block+0xd8>
  804132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804135:	c1 e0 04             	shl    $0x4,%eax
  804138:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  80413e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804141:	89 02                	mov    %eax,(%edx)
  804143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804146:	c1 e0 04             	shl    $0x4,%eax
  804149:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  80414f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804152:	89 02                	mov    %eax,(%edx)
  804154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804157:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80415e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804161:	c1 e0 04             	shl    $0x4,%eax
  804164:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804169:	8b 00                	mov    (%eax),%eax
  80416b:	8d 50 01             	lea    0x1(%eax),%edx
  80416e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804171:	c1 e0 04             	shl    $0x4,%eax
  804174:	05 ac 60 83 00       	add    $0x8360ac,%eax
  804179:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  80417b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80417e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804182:	40                   	inc    %eax
  804183:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804186:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  80418a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80418d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804191:	0f b7 c8             	movzwl %ax,%ecx
  804194:	b8 00 10 00 00       	mov    $0x1000,%eax
  804199:	ba 00 00 00 00       	mov    $0x0,%edx
  80419e:	f7 75 e8             	divl   -0x18(%ebp)
  8041a1:	39 c1                	cmp    %eax,%ecx
  8041a3:	0f 85 ed 01 00 00    	jne    804396 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8041a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ac:	c1 e0 04             	shl    $0x4,%eax
  8041af:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8041b4:	8b 00                	mov    (%eax),%eax
  8041b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8041b9:	eb 2a                	jmp    8041e5 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  8041bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041be:	83 ec 0c             	sub    $0xc,%esp
  8041c1:	50                   	push   %eax
  8041c2:	e8 b0 f7 ff ff       	call   803977 <to_page_info>
  8041c7:	83 c4 10             	add    $0x10,%esp
  8041ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8041cd:	75 06                	jne    8041d5 <free_block+0x16a>
				tmp = b;
  8041cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  8041d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041d8:	c1 e0 04             	shl    $0x4,%eax
  8041db:	05 a8 60 83 00       	add    $0x8360a8,%eax
  8041e0:	8b 00                	mov    (%eax),%eax
  8041e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8041e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8041e9:	74 07                	je     8041f2 <free_block+0x187>
  8041eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041ee:	8b 00                	mov    (%eax),%eax
  8041f0:	eb 05                	jmp    8041f7 <free_block+0x18c>
  8041f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8041f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8041fa:	c1 e2 04             	shl    $0x4,%edx
  8041fd:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  804203:	89 02                	mov    %eax,(%edx)
  804205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804208:	c1 e0 04             	shl    $0x4,%eax
  80420b:	05 a8 60 83 00       	add    $0x8360a8,%eax
  804210:	8b 00                	mov    (%eax),%eax
  804212:	85 c0                	test   %eax,%eax
  804214:	75 a5                	jne    8041bb <free_block+0x150>
  804216:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80421a:	75 9f                	jne    8041bb <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  80421c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80421f:	c1 e0 04             	shl    $0x4,%eax
  804222:	05 a0 60 83 00       	add    $0x8360a0,%eax
  804227:	8b 00                	mov    (%eax),%eax
  804229:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  80422c:	e9 cc 00 00 00       	jmp    8042fd <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  804231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804234:	8b 00                	mov    (%eax),%eax
  804236:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  804239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80423c:	83 ec 0c             	sub    $0xc,%esp
  80423f:	50                   	push   %eax
  804240:	e8 32 f7 ff ff       	call   803977 <to_page_info>
  804245:	83 c4 10             	add    $0x10,%esp
  804248:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80424b:	0f 85 a6 00 00 00    	jne    8042f7 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  804251:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804255:	75 17                	jne    80426e <free_block+0x203>
  804257:	83 ec 04             	sub    $0x4,%esp
  80425a:	68 9d 50 80 00       	push   $0x80509d
  80425f:	68 b5 00 00 00       	push   $0xb5
  804264:	68 03 50 80 00       	push   $0x805003
  804269:	e8 d3 c6 ff ff       	call   800941 <_panic>
  80426e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804271:	8b 00                	mov    (%eax),%eax
  804273:	85 c0                	test   %eax,%eax
  804275:	74 10                	je     804287 <free_block+0x21c>
  804277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80427a:	8b 00                	mov    (%eax),%eax
  80427c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80427f:	8b 52 04             	mov    0x4(%edx),%edx
  804282:	89 50 04             	mov    %edx,0x4(%eax)
  804285:	eb 14                	jmp    80429b <free_block+0x230>
  804287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80428a:	8b 40 04             	mov    0x4(%eax),%eax
  80428d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804290:	c1 e2 04             	shl    $0x4,%edx
  804293:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  804299:	89 02                	mov    %eax,(%edx)
  80429b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80429e:	8b 40 04             	mov    0x4(%eax),%eax
  8042a1:	85 c0                	test   %eax,%eax
  8042a3:	74 0f                	je     8042b4 <free_block+0x249>
  8042a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042a8:	8b 40 04             	mov    0x4(%eax),%eax
  8042ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042ae:	8b 12                	mov    (%edx),%edx
  8042b0:	89 10                	mov    %edx,(%eax)
  8042b2:	eb 13                	jmp    8042c7 <free_block+0x25c>
  8042b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b7:	8b 00                	mov    (%eax),%eax
  8042b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042bc:	c1 e2 04             	shl    $0x4,%edx
  8042bf:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  8042c5:	89 02                	mov    %eax,(%edx)
  8042c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042dd:	c1 e0 04             	shl    $0x4,%eax
  8042e0:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042e5:	8b 00                	mov    (%eax),%eax
  8042e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8042ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ed:	c1 e0 04             	shl    $0x4,%eax
  8042f0:	05 ac 60 83 00       	add    $0x8360ac,%eax
  8042f5:	89 10                	mov    %edx,(%eax)
			b = next;
  8042f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  8042fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804301:	0f 85 2a ff ff ff    	jne    804231 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  804307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80430a:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  804310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804313:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804319:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80431d:	75 17                	jne    804336 <free_block+0x2cb>
  80431f:	83 ec 04             	sub    $0x4,%esp
  804322:	68 0c 51 80 00       	push   $0x80510c
  804327:	68 bc 00 00 00       	push   $0xbc
  80432c:	68 03 50 80 00       	push   $0x805003
  804331:	e8 0b c6 ff ff       	call   800941 <_panic>
  804336:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80433c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80433f:	89 10                	mov    %edx,(%eax)
  804341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804344:	8b 00                	mov    (%eax),%eax
  804346:	85 c0                	test   %eax,%eax
  804348:	74 0d                	je     804357 <free_block+0x2ec>
  80434a:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80434f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804352:	89 50 04             	mov    %edx,0x4(%eax)
  804355:	eb 08                	jmp    80435f <free_block+0x2f4>
  804357:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80435a:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  80435f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804362:	a3 68 e0 81 00       	mov    %eax,0x81e068
  804367:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80436a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804371:	a1 74 e0 81 00       	mov    0x81e074,%eax
  804376:	40                   	inc    %eax
  804377:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  80437c:	83 ec 0c             	sub    $0xc,%esp
  80437f:	ff 75 ec             	pushl  -0x14(%ebp)
  804382:	e8 7e f5 ff ff       	call   803905 <to_page_va>
  804387:	83 c4 10             	add    $0x10,%esp
  80438a:	83 ec 0c             	sub    $0xc,%esp
  80438d:	50                   	push   %eax
  80438e:	e8 fe d7 ff ff       	call   801b91 <return_page>
  804393:	83 c4 10             	add    $0x10,%esp
	}
}
  804396:	90                   	nop
  804397:	c9                   	leave  
  804398:	c3                   	ret    

00804399 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  804399:	55                   	push   %ebp
  80439a:	89 e5                	mov    %esp,%ebp
  80439c:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80439f:	83 ec 04             	sub    $0x4,%esp
  8043a2:	68 68 51 80 00       	push   $0x805168
  8043a7:	6a 07                	push   $0x7
  8043a9:	68 97 51 80 00       	push   $0x805197
  8043ae:	e8 8e c5 ff ff       	call   800941 <_panic>

008043b3 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8043b3:	55                   	push   %ebp
  8043b4:	89 e5                	mov    %esp,%ebp
  8043b6:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8043b9:	83 ec 04             	sub    $0x4,%esp
  8043bc:	68 a8 51 80 00       	push   $0x8051a8
  8043c1:	6a 0b                	push   $0xb
  8043c3:	68 97 51 80 00       	push   $0x805197
  8043c8:	e8 74 c5 ff ff       	call   800941 <_panic>

008043cd <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8043cd:	55                   	push   %ebp
  8043ce:	89 e5                	mov    %esp,%ebp
  8043d0:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8043d3:	83 ec 04             	sub    $0x4,%esp
  8043d6:	68 d4 51 80 00       	push   $0x8051d4
  8043db:	6a 10                	push   $0x10
  8043dd:	68 97 51 80 00       	push   $0x805197
  8043e2:	e8 5a c5 ff ff       	call   800941 <_panic>

008043e7 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8043e7:	55                   	push   %ebp
  8043e8:	89 e5                	mov    %esp,%ebp
  8043ea:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8043ed:	83 ec 04             	sub    $0x4,%esp
  8043f0:	68 04 52 80 00       	push   $0x805204
  8043f5:	6a 15                	push   $0x15
  8043f7:	68 97 51 80 00       	push   $0x805197
  8043fc:	e8 40 c5 ff ff       	call   800941 <_panic>

00804401 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  804401:	55                   	push   %ebp
  804402:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804404:	8b 45 08             	mov    0x8(%ebp),%eax
  804407:	8b 40 10             	mov    0x10(%eax),%eax
}
  80440a:	5d                   	pop    %ebp
  80440b:	c3                   	ret    

0080440c <__udivdi3>:
  80440c:	55                   	push   %ebp
  80440d:	57                   	push   %edi
  80440e:	56                   	push   %esi
  80440f:	53                   	push   %ebx
  804410:	83 ec 1c             	sub    $0x1c,%esp
  804413:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804417:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80441b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80441f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804423:	89 ca                	mov    %ecx,%edx
  804425:	89 f8                	mov    %edi,%eax
  804427:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80442b:	85 f6                	test   %esi,%esi
  80442d:	75 2d                	jne    80445c <__udivdi3+0x50>
  80442f:	39 cf                	cmp    %ecx,%edi
  804431:	77 65                	ja     804498 <__udivdi3+0x8c>
  804433:	89 fd                	mov    %edi,%ebp
  804435:	85 ff                	test   %edi,%edi
  804437:	75 0b                	jne    804444 <__udivdi3+0x38>
  804439:	b8 01 00 00 00       	mov    $0x1,%eax
  80443e:	31 d2                	xor    %edx,%edx
  804440:	f7 f7                	div    %edi
  804442:	89 c5                	mov    %eax,%ebp
  804444:	31 d2                	xor    %edx,%edx
  804446:	89 c8                	mov    %ecx,%eax
  804448:	f7 f5                	div    %ebp
  80444a:	89 c1                	mov    %eax,%ecx
  80444c:	89 d8                	mov    %ebx,%eax
  80444e:	f7 f5                	div    %ebp
  804450:	89 cf                	mov    %ecx,%edi
  804452:	89 fa                	mov    %edi,%edx
  804454:	83 c4 1c             	add    $0x1c,%esp
  804457:	5b                   	pop    %ebx
  804458:	5e                   	pop    %esi
  804459:	5f                   	pop    %edi
  80445a:	5d                   	pop    %ebp
  80445b:	c3                   	ret    
  80445c:	39 ce                	cmp    %ecx,%esi
  80445e:	77 28                	ja     804488 <__udivdi3+0x7c>
  804460:	0f bd fe             	bsr    %esi,%edi
  804463:	83 f7 1f             	xor    $0x1f,%edi
  804466:	75 40                	jne    8044a8 <__udivdi3+0x9c>
  804468:	39 ce                	cmp    %ecx,%esi
  80446a:	72 0a                	jb     804476 <__udivdi3+0x6a>
  80446c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804470:	0f 87 9e 00 00 00    	ja     804514 <__udivdi3+0x108>
  804476:	b8 01 00 00 00       	mov    $0x1,%eax
  80447b:	89 fa                	mov    %edi,%edx
  80447d:	83 c4 1c             	add    $0x1c,%esp
  804480:	5b                   	pop    %ebx
  804481:	5e                   	pop    %esi
  804482:	5f                   	pop    %edi
  804483:	5d                   	pop    %ebp
  804484:	c3                   	ret    
  804485:	8d 76 00             	lea    0x0(%esi),%esi
  804488:	31 ff                	xor    %edi,%edi
  80448a:	31 c0                	xor    %eax,%eax
  80448c:	89 fa                	mov    %edi,%edx
  80448e:	83 c4 1c             	add    $0x1c,%esp
  804491:	5b                   	pop    %ebx
  804492:	5e                   	pop    %esi
  804493:	5f                   	pop    %edi
  804494:	5d                   	pop    %ebp
  804495:	c3                   	ret    
  804496:	66 90                	xchg   %ax,%ax
  804498:	89 d8                	mov    %ebx,%eax
  80449a:	f7 f7                	div    %edi
  80449c:	31 ff                	xor    %edi,%edi
  80449e:	89 fa                	mov    %edi,%edx
  8044a0:	83 c4 1c             	add    $0x1c,%esp
  8044a3:	5b                   	pop    %ebx
  8044a4:	5e                   	pop    %esi
  8044a5:	5f                   	pop    %edi
  8044a6:	5d                   	pop    %ebp
  8044a7:	c3                   	ret    
  8044a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8044ad:	89 eb                	mov    %ebp,%ebx
  8044af:	29 fb                	sub    %edi,%ebx
  8044b1:	89 f9                	mov    %edi,%ecx
  8044b3:	d3 e6                	shl    %cl,%esi
  8044b5:	89 c5                	mov    %eax,%ebp
  8044b7:	88 d9                	mov    %bl,%cl
  8044b9:	d3 ed                	shr    %cl,%ebp
  8044bb:	89 e9                	mov    %ebp,%ecx
  8044bd:	09 f1                	or     %esi,%ecx
  8044bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8044c3:	89 f9                	mov    %edi,%ecx
  8044c5:	d3 e0                	shl    %cl,%eax
  8044c7:	89 c5                	mov    %eax,%ebp
  8044c9:	89 d6                	mov    %edx,%esi
  8044cb:	88 d9                	mov    %bl,%cl
  8044cd:	d3 ee                	shr    %cl,%esi
  8044cf:	89 f9                	mov    %edi,%ecx
  8044d1:	d3 e2                	shl    %cl,%edx
  8044d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044d7:	88 d9                	mov    %bl,%cl
  8044d9:	d3 e8                	shr    %cl,%eax
  8044db:	09 c2                	or     %eax,%edx
  8044dd:	89 d0                	mov    %edx,%eax
  8044df:	89 f2                	mov    %esi,%edx
  8044e1:	f7 74 24 0c          	divl   0xc(%esp)
  8044e5:	89 d6                	mov    %edx,%esi
  8044e7:	89 c3                	mov    %eax,%ebx
  8044e9:	f7 e5                	mul    %ebp
  8044eb:	39 d6                	cmp    %edx,%esi
  8044ed:	72 19                	jb     804508 <__udivdi3+0xfc>
  8044ef:	74 0b                	je     8044fc <__udivdi3+0xf0>
  8044f1:	89 d8                	mov    %ebx,%eax
  8044f3:	31 ff                	xor    %edi,%edi
  8044f5:	e9 58 ff ff ff       	jmp    804452 <__udivdi3+0x46>
  8044fa:	66 90                	xchg   %ax,%ax
  8044fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  804500:	89 f9                	mov    %edi,%ecx
  804502:	d3 e2                	shl    %cl,%edx
  804504:	39 c2                	cmp    %eax,%edx
  804506:	73 e9                	jae    8044f1 <__udivdi3+0xe5>
  804508:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80450b:	31 ff                	xor    %edi,%edi
  80450d:	e9 40 ff ff ff       	jmp    804452 <__udivdi3+0x46>
  804512:	66 90                	xchg   %ax,%ax
  804514:	31 c0                	xor    %eax,%eax
  804516:	e9 37 ff ff ff       	jmp    804452 <__udivdi3+0x46>
  80451b:	90                   	nop

0080451c <__umoddi3>:
  80451c:	55                   	push   %ebp
  80451d:	57                   	push   %edi
  80451e:	56                   	push   %esi
  80451f:	53                   	push   %ebx
  804520:	83 ec 1c             	sub    $0x1c,%esp
  804523:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804527:	8b 74 24 34          	mov    0x34(%esp),%esi
  80452b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80452f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804533:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804537:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80453b:	89 f3                	mov    %esi,%ebx
  80453d:	89 fa                	mov    %edi,%edx
  80453f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804543:	89 34 24             	mov    %esi,(%esp)
  804546:	85 c0                	test   %eax,%eax
  804548:	75 1a                	jne    804564 <__umoddi3+0x48>
  80454a:	39 f7                	cmp    %esi,%edi
  80454c:	0f 86 a2 00 00 00    	jbe    8045f4 <__umoddi3+0xd8>
  804552:	89 c8                	mov    %ecx,%eax
  804554:	89 f2                	mov    %esi,%edx
  804556:	f7 f7                	div    %edi
  804558:	89 d0                	mov    %edx,%eax
  80455a:	31 d2                	xor    %edx,%edx
  80455c:	83 c4 1c             	add    $0x1c,%esp
  80455f:	5b                   	pop    %ebx
  804560:	5e                   	pop    %esi
  804561:	5f                   	pop    %edi
  804562:	5d                   	pop    %ebp
  804563:	c3                   	ret    
  804564:	39 f0                	cmp    %esi,%eax
  804566:	0f 87 ac 00 00 00    	ja     804618 <__umoddi3+0xfc>
  80456c:	0f bd e8             	bsr    %eax,%ebp
  80456f:	83 f5 1f             	xor    $0x1f,%ebp
  804572:	0f 84 ac 00 00 00    	je     804624 <__umoddi3+0x108>
  804578:	bf 20 00 00 00       	mov    $0x20,%edi
  80457d:	29 ef                	sub    %ebp,%edi
  80457f:	89 fe                	mov    %edi,%esi
  804581:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804585:	89 e9                	mov    %ebp,%ecx
  804587:	d3 e0                	shl    %cl,%eax
  804589:	89 d7                	mov    %edx,%edi
  80458b:	89 f1                	mov    %esi,%ecx
  80458d:	d3 ef                	shr    %cl,%edi
  80458f:	09 c7                	or     %eax,%edi
  804591:	89 e9                	mov    %ebp,%ecx
  804593:	d3 e2                	shl    %cl,%edx
  804595:	89 14 24             	mov    %edx,(%esp)
  804598:	89 d8                	mov    %ebx,%eax
  80459a:	d3 e0                	shl    %cl,%eax
  80459c:	89 c2                	mov    %eax,%edx
  80459e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045a2:	d3 e0                	shl    %cl,%eax
  8045a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8045a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045ac:	89 f1                	mov    %esi,%ecx
  8045ae:	d3 e8                	shr    %cl,%eax
  8045b0:	09 d0                	or     %edx,%eax
  8045b2:	d3 eb                	shr    %cl,%ebx
  8045b4:	89 da                	mov    %ebx,%edx
  8045b6:	f7 f7                	div    %edi
  8045b8:	89 d3                	mov    %edx,%ebx
  8045ba:	f7 24 24             	mull   (%esp)
  8045bd:	89 c6                	mov    %eax,%esi
  8045bf:	89 d1                	mov    %edx,%ecx
  8045c1:	39 d3                	cmp    %edx,%ebx
  8045c3:	0f 82 87 00 00 00    	jb     804650 <__umoddi3+0x134>
  8045c9:	0f 84 91 00 00 00    	je     804660 <__umoddi3+0x144>
  8045cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8045d3:	29 f2                	sub    %esi,%edx
  8045d5:	19 cb                	sbb    %ecx,%ebx
  8045d7:	89 d8                	mov    %ebx,%eax
  8045d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8045dd:	d3 e0                	shl    %cl,%eax
  8045df:	89 e9                	mov    %ebp,%ecx
  8045e1:	d3 ea                	shr    %cl,%edx
  8045e3:	09 d0                	or     %edx,%eax
  8045e5:	89 e9                	mov    %ebp,%ecx
  8045e7:	d3 eb                	shr    %cl,%ebx
  8045e9:	89 da                	mov    %ebx,%edx
  8045eb:	83 c4 1c             	add    $0x1c,%esp
  8045ee:	5b                   	pop    %ebx
  8045ef:	5e                   	pop    %esi
  8045f0:	5f                   	pop    %edi
  8045f1:	5d                   	pop    %ebp
  8045f2:	c3                   	ret    
  8045f3:	90                   	nop
  8045f4:	89 fd                	mov    %edi,%ebp
  8045f6:	85 ff                	test   %edi,%edi
  8045f8:	75 0b                	jne    804605 <__umoddi3+0xe9>
  8045fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8045ff:	31 d2                	xor    %edx,%edx
  804601:	f7 f7                	div    %edi
  804603:	89 c5                	mov    %eax,%ebp
  804605:	89 f0                	mov    %esi,%eax
  804607:	31 d2                	xor    %edx,%edx
  804609:	f7 f5                	div    %ebp
  80460b:	89 c8                	mov    %ecx,%eax
  80460d:	f7 f5                	div    %ebp
  80460f:	89 d0                	mov    %edx,%eax
  804611:	e9 44 ff ff ff       	jmp    80455a <__umoddi3+0x3e>
  804616:	66 90                	xchg   %ax,%ax
  804618:	89 c8                	mov    %ecx,%eax
  80461a:	89 f2                	mov    %esi,%edx
  80461c:	83 c4 1c             	add    $0x1c,%esp
  80461f:	5b                   	pop    %ebx
  804620:	5e                   	pop    %esi
  804621:	5f                   	pop    %edi
  804622:	5d                   	pop    %ebp
  804623:	c3                   	ret    
  804624:	3b 04 24             	cmp    (%esp),%eax
  804627:	72 06                	jb     80462f <__umoddi3+0x113>
  804629:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80462d:	77 0f                	ja     80463e <__umoddi3+0x122>
  80462f:	89 f2                	mov    %esi,%edx
  804631:	29 f9                	sub    %edi,%ecx
  804633:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804637:	89 14 24             	mov    %edx,(%esp)
  80463a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80463e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804642:	8b 14 24             	mov    (%esp),%edx
  804645:	83 c4 1c             	add    $0x1c,%esp
  804648:	5b                   	pop    %ebx
  804649:	5e                   	pop    %esi
  80464a:	5f                   	pop    %edi
  80464b:	5d                   	pop    %ebp
  80464c:	c3                   	ret    
  80464d:	8d 76 00             	lea    0x0(%esi),%esi
  804650:	2b 04 24             	sub    (%esp),%eax
  804653:	19 fa                	sbb    %edi,%edx
  804655:	89 d1                	mov    %edx,%ecx
  804657:	89 c6                	mov    %eax,%esi
  804659:	e9 71 ff ff ff       	jmp    8045cf <__umoddi3+0xb3>
  80465e:	66 90                	xchg   %ax,%ax
  804660:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804664:	72 ea                	jb     804650 <__umoddi3+0x134>
  804666:	89 d9                	mov    %ebx,%ecx
  804668:	e9 62 ff ff ff       	jmp    8045cf <__umoddi3+0xb3>
