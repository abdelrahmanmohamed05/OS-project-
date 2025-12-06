
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 3a 06 00 00       	call   800670 <libmain>
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
  80003e:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
	//disable the print of prog stats after finishing
	printStats = 0;
  800044:	c7 05 00 60 80 00 00 	movl   $0x0,0x806000
  80004b:	00 00 00 

	int32 parentenvID = sys_getparentenvid();
  80004e:	e8 f9 32 00 00       	call   80334c <sys_getparentenvid>
  800053:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _agentCapacity[] = "agentCapacity";
  800056:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800059:	bb 69 46 80 00       	mov    $0x804669,%ebx
  80005e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  80006b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80006e:	bb 77 46 80 00       	mov    $0x804677,%ebx
  800073:	ba 0a 00 00 00       	mov    $0xa,%edx
  800078:	89 c7                	mov    %eax,%edi
  80007a:	89 de                	mov    %ebx,%esi
  80007c:	89 d1                	mov    %edx,%ecx
  80007e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800080:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800083:	bb 81 46 80 00       	mov    $0x804681,%ebx
  800088:	ba 03 00 00 00       	mov    $0x3,%edx
  80008d:	89 c7                	mov    %eax,%edi
  80008f:	89 de                	mov    %ebx,%esi
  800091:	89 d1                	mov    %edx,%ecx
  800093:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800095:	8d 85 7d ff ff ff    	lea    -0x83(%ebp),%eax
  80009b:	bb 8d 46 80 00       	mov    $0x80468d,%ebx
  8000a0:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000a5:	89 c7                	mov    %eax,%edi
  8000a7:	89 de                	mov    %ebx,%esi
  8000a9:	89 d1                	mov    %edx,%ecx
  8000ab:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000ad:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000b3:	bb 9c 46 80 00       	mov    $0x80469c,%ebx
  8000b8:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000bd:	89 c7                	mov    %eax,%edi
  8000bf:	89 de                	mov    %ebx,%esi
  8000c1:	89 d1                	mov    %edx,%ecx
  8000c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000c5:	8d 85 59 ff ff ff    	lea    -0xa7(%ebp),%eax
  8000cb:	bb ab 46 80 00       	mov    $0x8046ab,%ebx
  8000d0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000d5:	89 c7                	mov    %eax,%edi
  8000d7:	89 de                	mov    %ebx,%esi
  8000d9:	89 d1                	mov    %edx,%ecx
  8000db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000dd:	8d 85 44 ff ff ff    	lea    -0xbc(%ebp),%eax
  8000e3:	bb c0 46 80 00       	mov    $0x8046c0,%ebx
  8000e8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ed:	89 c7                	mov    %eax,%edi
  8000ef:	89 de                	mov    %ebx,%esi
  8000f1:	89 d1                	mov    %edx,%ecx
  8000f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000f5:	8d 85 33 ff ff ff    	lea    -0xcd(%ebp),%eax
  8000fb:	bb d5 46 80 00       	mov    $0x8046d5,%ebx
  800100:	ba 11 00 00 00       	mov    $0x11,%edx
  800105:	89 c7                	mov    %eax,%edi
  800107:	89 de                	mov    %ebx,%esi
  800109:	89 d1                	mov    %edx,%ecx
  80010b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80010d:	8d 85 22 ff ff ff    	lea    -0xde(%ebp),%eax
  800113:	bb e6 46 80 00       	mov    $0x8046e6,%ebx
  800118:	ba 11 00 00 00       	mov    $0x11,%edx
  80011d:	89 c7                	mov    %eax,%edi
  80011f:	89 de                	mov    %ebx,%esi
  800121:	89 d1                	mov    %edx,%ecx
  800123:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800125:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80012b:	bb f7 46 80 00       	mov    $0x8046f7,%ebx
  800130:	ba 11 00 00 00       	mov    $0x11,%edx
  800135:	89 c7                	mov    %eax,%edi
  800137:	89 de                	mov    %ebx,%esi
  800139:	89 d1                	mov    %edx,%ecx
  80013b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80013d:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
  800143:	bb 08 47 80 00       	mov    $0x804708,%ebx
  800148:	ba 09 00 00 00       	mov    $0x9,%edx
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	89 de                	mov    %ebx,%esi
  800151:	89 d1                	mov    %edx,%ecx
  800153:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800155:	8d 85 fe fe ff ff    	lea    -0x102(%ebp),%eax
  80015b:	bb 11 47 80 00       	mov    $0x804711,%ebx
  800160:	ba 0a 00 00 00       	mov    $0xa,%edx
  800165:	89 c7                	mov    %eax,%edi
  800167:	89 de                	mov    %ebx,%esi
  800169:	89 d1                	mov    %edx,%ecx
  80016b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80016d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800173:	bb 1b 47 80 00       	mov    $0x80471b,%ebx
  800178:	ba 0b 00 00 00       	mov    $0xb,%edx
  80017d:	89 c7                	mov    %eax,%edi
  80017f:	89 de                	mov    %ebx,%esi
  800181:	89 d1                	mov    %edx,%ecx
  800183:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800185:	8d 85 e7 fe ff ff    	lea    -0x119(%ebp),%eax
  80018b:	bb 26 47 80 00       	mov    $0x804726,%ebx
  800190:	ba 03 00 00 00       	mov    $0x3,%edx
  800195:	89 c7                	mov    %eax,%edi
  800197:	89 de                	mov    %ebx,%esi
  800199:	89 d1                	mov    %edx,%ecx
  80019b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  80019d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8001a3:	bb 32 47 80 00       	mov    $0x804732,%ebx
  8001a8:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001ad:	89 c7                	mov    %eax,%edi
  8001af:	89 de                	mov    %ebx,%esi
  8001b1:	89 d1                	mov    %edx,%ecx
  8001b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001b5:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001bb:	bb 3c 47 80 00       	mov    $0x80473c,%ebx
  8001c0:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001c5:	89 c7                	mov    %eax,%edi
  8001c7:	89 de                	mov    %ebx,%esi
  8001c9:	89 d1                	mov    %edx,%ecx
  8001cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001cd:	c7 85 cd fe ff ff 63 	movl   $0x72656c63,-0x133(%ebp)
  8001d4:	6c 65 72 
  8001d7:	66 c7 85 d1 fe ff ff 	movw   $0x6b,-0x12f(%ebp)
  8001de:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001e0:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001e6:	bb 46 47 80 00       	mov    $0x804746,%ebx
  8001eb:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001f0:	89 c7                	mov    %eax,%edi
  8001f2:	89 de                	mov    %ebx,%esi
  8001f4:	89 d1                	mov    %edx,%ecx
  8001f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001f8:	8d 85 b0 fe ff ff    	lea    -0x150(%ebp),%eax
  8001fe:	bb 54 47 80 00       	mov    $0x804754,%ebx
  800203:	ba 0f 00 00 00       	mov    $0xf,%edx
  800208:	89 c7                	mov    %eax,%edi
  80020a:	89 de                	mov    %ebx,%esi
  80020c:	89 d1                	mov    %edx,%ecx
  80020e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800210:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800216:	bb 63 47 80 00       	mov    $0x804763,%ebx
  80021b:	ba 07 00 00 00       	mov    $0x7,%edx
  800220:	89 c7                	mov    %eax,%edi
  800222:	89 de                	mov    %ebx,%esi
  800224:	89 d1                	mov    %edx,%ecx
  800226:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800228:	8d 85 a2 fe ff ff    	lea    -0x15e(%ebp),%eax
  80022e:	bb 6a 47 80 00       	mov    $0x80476a,%ebx
  800233:	ba 07 00 00 00       	mov    $0x7,%edx
  800238:	89 c7                	mov    %eax,%edi
  80023a:	89 de                	mov    %ebx,%esi
  80023c:	89 d1                	mov    %edx,%ecx
  80023e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _flight1Customers[] = "flight1Customers";
  800240:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800246:	bb 71 47 80 00       	mov    $0x804771,%ebx
  80024b:	ba 11 00 00 00       	mov    $0x11,%edx
  800250:	89 c7                	mov    %eax,%edi
  800252:	89 de                	mov    %ebx,%esi
  800254:	89 d1                	mov    %edx,%ecx
  800256:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Customers[] = "flight2Customers";
  800258:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  80025e:	bb 82 47 80 00       	mov    $0x804782,%ebx
  800263:	ba 11 00 00 00       	mov    $0x11,%edx
  800268:	89 c7                	mov    %eax,%edi
  80026a:	89 de                	mov    %ebx,%esi
  80026c:	89 d1                	mov    %edx,%ecx
  80026e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight3Customers[] = "flight3Customers";
  800270:	8d 85 6f fe ff ff    	lea    -0x191(%ebp),%eax
  800276:	bb 93 47 80 00       	mov    $0x804793,%ebx
  80027b:	ba 11 00 00 00       	mov    $0x11,%edx
  800280:	89 c7                	mov    %eax,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	89 d1                	mov    %edx,%ecx
  800286:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800292:	e8 f2 20 00 00       	call   802389 <sget>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	8d 45 8c             	lea    -0x74(%ebp),%eax
  8002a3:	50                   	push   %eax
  8002a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a7:	e8 dd 20 00 00       	call   802389 <sget>
  8002ac:	83 c4 10             	add    $0x10,%esp
  8002af:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002bb:	50                   	push   %eax
  8002bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bf:	e8 c5 20 00 00       	call   802389 <sget>
  8002c4:	83 c4 10             	add    $0x10,%esp
  8002c7:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
  8002d3:	50                   	push   %eax
  8002d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d7:	e8 ad 20 00 00       	call   802389 <sget>
  8002dc:	83 c4 10             	add    $0x10,%esp
  8002df:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int* flight1Customers = sget(parentenvID, _flight1Customers);
  8002e2:	83 ec 08             	sub    $0x8,%esp
  8002e5:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8002eb:	50                   	push   %eax
  8002ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ef:	e8 95 20 00 00       	call   802389 <sget>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int* flight2Customers = sget(parentenvID, _flight2Customers);
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  800303:	50                   	push   %eax
  800304:	ff 75 e4             	pushl  -0x1c(%ebp)
  800307:	e8 7d 20 00 00       	call   802389 <sget>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight3Customers = sget(parentenvID, _flight3Customers);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 6f fe ff ff    	lea    -0x191(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 65 20 00 00       	call   802389 <sget>
  800324:	83 c4 10             	add    $0x10,%esp
  800327:	89 45 c8             	mov    %eax,-0x38(%ebp)

	// Get the shared semaphores from the main program ***********************************

	struct semaphore capacity = get_semaphore(parentenvID, _agentCapacity);
  80032a:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	8d 55 a2             	lea    -0x5e(%ebp),%edx
  800336:	52                   	push   %edx
  800337:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033a:	50                   	push   %eax
  80033b:	e8 64 3d 00 00       	call   8040a4 <get_semaphore>
  800340:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custCounterCS = get_semaphore(parentenvID, _custCounterCS);
  800343:	8d 85 64 fe ff ff    	lea    -0x19c(%ebp),%eax
  800349:	83 ec 04             	sub    $0x4,%esp
  80034c:	8d 95 bf fe ff ff    	lea    -0x141(%ebp),%edx
  800352:	52                   	push   %edx
  800353:	ff 75 e4             	pushl  -0x1c(%ebp)
  800356:	50                   	push   %eax
  800357:	e8 48 3d 00 00       	call   8040a4 <get_semaphore>
  80035c:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  80035f:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	8d 95 cd fe ff ff    	lea    -0x133(%ebp),%edx
  80036e:	52                   	push   %edx
  80036f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800372:	50                   	push   %eax
  800373:	e8 2c 3d 00 00       	call   8040a4 <get_semaphore>
  800378:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  80037b:	8d 85 5c fe ff ff    	lea    -0x1a4(%ebp),%eax
  800381:	83 ec 04             	sub    $0x4,%esp
  800384:	8d 95 e7 fe ff ff    	lea    -0x119(%ebp),%edx
  80038a:	52                   	push   %edx
  80038b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038e:	50                   	push   %eax
  80038f:	e8 10 3d 00 00       	call   8040a4 <get_semaphore>
  800394:	83 c4 0c             	add    $0xc,%esp
	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  800397:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	8d 95 f3 fe ff ff    	lea    -0x10d(%ebp),%edx
  8003a6:	52                   	push   %edx
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	50                   	push   %eax
  8003ab:	e8 f4 3c 00 00       	call   8040a4 <get_semaphore>
  8003b0:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custTerminated = get_semaphore(parentenvID, _custTerminated);
  8003b3:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	8d 95 b0 fe ff ff    	lea    -0x150(%ebp),%edx
  8003c2:	52                   	push   %edx
  8003c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c6:	50                   	push   %eax
  8003c7:	e8 d8 3c 00 00       	call   8040a4 <get_semaphore>
  8003cc:	83 c4 0c             	add    $0xc,%esp

	int custId, flightType;
	wait_semaphore(custCounterCS);
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  8003d8:	e8 e1 3c 00 00       	call   8040be <wait_semaphore>
  8003dd:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  8003e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  8003e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003eb:	8b 00                	mov    (%eax),%eax
  8003ed:	8d 50 01             	lea    0x1(%eax),%edx
  8003f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003f3:	89 10                	mov    %edx,(%eax)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8003f5:	0f 31                	rdtsc  
  8003f7:	89 85 44 fe ff ff    	mov    %eax,-0x1bc(%ebp)
  8003fd:	89 95 48 fe ff ff    	mov    %edx,-0x1b8(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  800403:	8b 85 44 fe ff ff    	mov    -0x1bc(%ebp),%eax
  800409:	8b 95 48 fe ff ff    	mov    -0x1b8(%ebp),%edx
  80040f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800412:	89 55 b4             	mov    %edx,-0x4c(%ebp)
		repFlightSel:
		//get random flight
		flightType = RANDU(1, 4);
  800415:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800418:	b9 03 00 00 00       	mov    $0x3,%ecx
  80041d:	ba 00 00 00 00       	mov    $0x0,%edx
  800422:	f7 f1                	div    %ecx
  800424:	89 d0                	mov    %edx,%eax
  800426:	40                   	inc    %eax
  800427:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if(flightType == 1 && *flight1Customers > 0)		(*flight1Customers)--;
  80042a:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  80042e:	75 18                	jne    800448 <_main+0x410>
  800430:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	85 c0                	test   %eax,%eax
  800437:	7e 0f                	jle    800448 <_main+0x410>
  800439:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800441:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800444:	89 10                	mov    %edx,(%eax)
  800446:	eb 3a                	jmp    800482 <_main+0x44a>
		else if(flightType == 2 && *flight2Customers > 0)	(*flight2Customers)--;
  800448:	83 7d c0 02          	cmpl   $0x2,-0x40(%ebp)
  80044c:	75 18                	jne    800466 <_main+0x42e>
  80044e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	85 c0                	test   %eax,%eax
  800455:	7e 0f                	jle    800466 <_main+0x42e>
  800457:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80045f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
  800464:	eb 1c                	jmp    800482 <_main+0x44a>
		else if(flightType == 3 && *flight3Customers > 0)	(*flight3Customers)--;
  800466:	83 7d c0 03          	cmpl   $0x3,-0x40(%ebp)
  80046a:	75 89                	jne    8003f5 <_main+0x3bd>
  80046c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	85 c0                	test   %eax,%eax
  800473:	7e 80                	jle    8003f5 <_main+0x3bd>
  800475:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80047d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800480:	89 10                	mov    %edx,(%eax)
		else goto repFlightSel;
	}
	signal_semaphore(custCounterCS);
  800482:	83 ec 0c             	sub    $0xc,%esp
  800485:	ff b5 64 fe ff ff    	pushl  -0x19c(%ebp)
  80048b:	e8 48 3c 00 00       	call   8040d8 <signal_semaphore>
  800490:	83 c4 10             	add    $0x10,%esp

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  800493:	0f 31                	rdtsc  
  800495:	89 85 4c fe ff ff    	mov    %eax,-0x1b4(%ebp)
  80049b:	89 95 50 fe ff ff    	mov    %edx,-0x1b0(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8004a1:	8b 85 4c fe ff ff    	mov    -0x1b4(%ebp),%eax
  8004a7:	8b 95 50 fe ff ff    	mov    -0x1b0(%ebp),%edx
  8004ad:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8004b0:	89 55 bc             	mov    %edx,-0x44(%ebp)

	//delay for a random time
	env_sleep(RANDU(100, 10000));
  8004b3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004b6:	b9 ac 26 00 00       	mov    $0x26ac,%ecx
  8004bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c0:	f7 f1                	div    %ecx
  8004c2:	89 d0                	mov    %edx,%eax
  8004c4:	83 c0 64             	add    $0x64,%eax
  8004c7:	83 ec 0c             	sub    $0xc,%esp
  8004ca:	50                   	push   %eax
  8004cb:	e8 2d 3c 00 00       	call   8040fd <env_sleep>
  8004d0:	83 c4 10             	add    $0x10,%esp

	//enter the agent if there's a space
	wait_semaphore(capacity);
  8004d3:	83 ec 0c             	sub    $0xc,%esp
  8004d6:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  8004dc:	e8 dd 3b 00 00       	call   8040be <wait_semaphore>
  8004e1:	83 c4 10             	add    $0x10,%esp
	{
		//wait on one of the clerks
		wait_semaphore(clerk);
  8004e4:	83 ec 0c             	sub    $0xc,%esp
  8004e7:	ff b5 60 fe ff ff    	pushl  -0x1a0(%ebp)
  8004ed:	e8 cc 3b 00 00       	call   8040be <wait_semaphore>
  8004f2:	83 c4 10             	add    $0x10,%esp

		//enqueue the request
		customers[custId].booked = 0 ;
  8004f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800502:	01 d0                	add    %edx,%eax
  800504:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		customers[custId].flightType = flightType ;
  80050b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80050e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800515:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800518:	01 c2                	add    %eax,%edx
  80051a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80051d:	89 02                	mov    %eax,(%edx)
		wait_semaphore(custQueueCS);
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  800528:	e8 91 3b 00 00       	call   8040be <wait_semaphore>
  80052d:	83 c4 10             	add    $0x10,%esp
		{
			cust_ready_queue[*queue_in] = custId;
  800530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80053f:	01 c2                	add    %eax,%edx
  800541:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800544:	89 02                	mov    %eax,(%edx)
			*queue_in = *queue_in +1;
  800546:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	8d 50 01             	lea    0x1(%eax),%edx
  80054e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800551:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(custQueueCS);
  800553:	83 ec 0c             	sub    $0xc,%esp
  800556:	ff b5 5c fe ff ff    	pushl  -0x1a4(%ebp)
  80055c:	e8 77 3b 00 00       	call   8040d8 <signal_semaphore>
  800561:	83 c4 10             	add    $0x10,%esp

		//signal ready
		signal_semaphore(cust_ready);
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  80056d:	e8 66 3b 00 00       	call   8040d8 <signal_semaphore>
  800572:	83 c4 10             	add    $0x10,%esp

		//wait on finished
		char prefix[30]="cust_finished";
  800575:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  80057b:	bb a4 47 80 00       	mov    $0x8047a4,%ebx
  800580:	ba 0e 00 00 00       	mov    $0xe,%edx
  800585:	89 c7                	mov    %eax,%edi
  800587:	89 de                	mov    %ebx,%esi
  800589:	89 d1                	mov    %edx,%ecx
  80058b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80058d:	8d 95 34 fe ff ff    	lea    -0x1cc(%ebp),%edx
  800593:	b9 04 00 00 00       	mov    $0x4,%ecx
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	89 d7                	mov    %edx,%edi
  80059f:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	8d 85 21 fe ff ff    	lea    -0x1df(%ebp),%eax
  8005aa:	50                   	push   %eax
  8005ab:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005ae:	e8 7b 0f 00 00       	call   80152e <ltostr>
  8005b3:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  8005bf:	50                   	push   %eax
  8005c0:	8d 85 21 fe ff ff    	lea    -0x1df(%ebp),%eax
  8005c6:	50                   	push   %eax
  8005c7:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  8005cd:	50                   	push   %eax
  8005ce:	e8 34 10 00 00       	call   801607 <strcconcat>
  8005d3:	83 c4 10             	add    $0x10,%esp
		//sys_waitSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  8005d6:	8d 85 1c fe ff ff    	lea    -0x1e4(%ebp),%eax
  8005dc:	83 ec 04             	sub    $0x4,%esp
  8005df:	8d 95 ea fd ff ff    	lea    -0x216(%ebp),%edx
  8005e5:	52                   	push   %edx
  8005e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005e9:	50                   	push   %eax
  8005ea:	e8 b5 3a 00 00       	call   8040a4 <get_semaphore>
  8005ef:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(cust_finished);
  8005f2:	83 ec 0c             	sub    $0xc,%esp
  8005f5:	ff b5 1c fe ff ff    	pushl  -0x1e4(%ebp)
  8005fb:	e8 be 3a 00 00       	call   8040be <wait_semaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//print the customer status
		if(customers[custId].booked == 1)
  800603:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800606:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800610:	01 d0                	add    %edx,%eax
  800612:	8b 40 04             	mov    0x4(%eax),%eax
  800615:	83 f8 01             	cmp    $0x1,%eax
  800618:	75 18                	jne    800632 <_main+0x5fa>
		{
			cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  80061a:	83 ec 04             	sub    $0x4,%esp
  80061d:	ff 75 c0             	pushl  -0x40(%ebp)
  800620:	ff 75 c4             	pushl  -0x3c(%ebp)
  800623:	68 20 46 80 00       	push   $0x804620
  800628:	e8 d3 02 00 00       	call   800900 <cprintf>
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	eb 13                	jmp    800645 <_main+0x60d>
		}
		else
		{
			cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 c4             	pushl  -0x3c(%ebp)
  800638:	68 48 46 80 00       	push   $0x804648
  80063d:	e8 be 02 00 00       	call   800900 <cprintf>
  800642:	83 c4 10             	add    $0x10,%esp
		}
	}
	//exit the agent
	signal_semaphore(capacity);
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	ff b5 68 fe ff ff    	pushl  -0x198(%ebp)
  80064e:	e8 85 3a 00 00       	call   8040d8 <signal_semaphore>
  800653:	83 c4 10             	add    $0x10,%esp

	//customer is terminated
	signal_semaphore(custTerminated);
  800656:	83 ec 0c             	sub    $0xc,%esp
  800659:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
  80065f:	e8 74 3a 00 00       	call   8040d8 <signal_semaphore>
  800664:	83 c4 10             	add    $0x10,%esp

	return;
  800667:	90                   	nop
}
  800668:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80066b:	5b                   	pop    %ebx
  80066c:	5e                   	pop    %esi
  80066d:	5f                   	pop    %edi
  80066e:	5d                   	pop    %ebp
  80066f:	c3                   	ret    

00800670 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
  800673:	57                   	push   %edi
  800674:	56                   	push   %esi
  800675:	53                   	push   %ebx
  800676:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800679:	e8 b5 2c 00 00       	call   803333 <sys_getenvindex>
  80067e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800681:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800684:	89 d0                	mov    %edx,%eax
  800686:	c1 e0 03             	shl    $0x3,%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	c1 e0 02             	shl    $0x2,%eax
  80068e:	01 d0                	add    %edx,%eax
  800690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800697:	01 d0                	add    %edx,%eax
  800699:	c1 e0 03             	shl    $0x3,%eax
  80069c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a1:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006a6:	a1 20 60 80 00       	mov    0x806020,%eax
  8006ab:	8a 40 20             	mov    0x20(%eax),%al
  8006ae:	84 c0                	test   %al,%al
  8006b0:	74 0d                	je     8006bf <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8006b2:	a1 20 60 80 00       	mov    0x806020,%eax
  8006b7:	83 c0 20             	add    $0x20,%eax
  8006ba:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006c3:	7e 0a                	jle    8006cf <libmain+0x5f>
		binaryname = argv[0];
  8006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	ff 75 08             	pushl  0x8(%ebp)
  8006d8:	e8 5b f9 ff ff       	call   800038 <_main>
  8006dd:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8006e0:	a1 00 60 80 00       	mov    0x806000,%eax
  8006e5:	85 c0                	test   %eax,%eax
  8006e7:	0f 84 01 01 00 00    	je     8007ee <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8006ed:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8006f3:	bb bc 48 80 00       	mov    $0x8048bc,%ebx
  8006f8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006fd:	89 c7                	mov    %eax,%edi
  8006ff:	89 de                	mov    %ebx,%esi
  800701:	89 d1                	mov    %edx,%ecx
  800703:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800705:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800708:	b9 56 00 00 00       	mov    $0x56,%ecx
  80070d:	b0 00                	mov    $0x0,%al
  80070f:	89 d7                	mov    %edx,%edi
  800711:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800713:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80071a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	50                   	push   %eax
  800721:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800727:	50                   	push   %eax
  800728:	e8 3c 2e 00 00       	call   803569 <sys_utilities>
  80072d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800730:	e8 85 29 00 00       	call   8030ba <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	68 dc 47 80 00       	push   $0x8047dc
  80073d:	e8 be 01 00 00       	call   800900 <cprintf>
  800742:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800748:	85 c0                	test   %eax,%eax
  80074a:	74 18                	je     800764 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80074c:	e8 36 2e 00 00       	call   803587 <sys_get_optimal_num_faults>
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	50                   	push   %eax
  800755:	68 04 48 80 00       	push   $0x804804
  80075a:	e8 a1 01 00 00       	call   800900 <cprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	eb 59                	jmp    8007bd <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800764:	a1 20 60 80 00       	mov    0x806020,%eax
  800769:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  80076f:	a1 20 60 80 00       	mov    0x806020,%eax
  800774:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80077a:	83 ec 04             	sub    $0x4,%esp
  80077d:	52                   	push   %edx
  80077e:	50                   	push   %eax
  80077f:	68 28 48 80 00       	push   $0x804828
  800784:	e8 77 01 00 00       	call   800900 <cprintf>
  800789:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80078c:	a1 20 60 80 00       	mov    0x806020,%eax
  800791:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  800797:	a1 20 60 80 00       	mov    0x806020,%eax
  80079c:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8007a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8007a7:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8007ad:	51                   	push   %ecx
  8007ae:	52                   	push   %edx
  8007af:	50                   	push   %eax
  8007b0:	68 50 48 80 00       	push   $0x804850
  8007b5:	e8 46 01 00 00       	call   800900 <cprintf>
  8007ba:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007bd:	a1 20 60 80 00       	mov    0x806020,%eax
  8007c2:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	50                   	push   %eax
  8007cc:	68 a8 48 80 00       	push   $0x8048a8
  8007d1:	e8 2a 01 00 00       	call   800900 <cprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8007d9:	83 ec 0c             	sub    $0xc,%esp
  8007dc:	68 dc 47 80 00       	push   $0x8047dc
  8007e1:	e8 1a 01 00 00       	call   800900 <cprintf>
  8007e6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8007e9:	e8 e6 28 00 00       	call   8030d4 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8007ee:	e8 1f 00 00 00       	call   800812 <exit>
}
  8007f3:	90                   	nop
  8007f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f7:	5b                   	pop    %ebx
  8007f8:	5e                   	pop    %esi
  8007f9:	5f                   	pop    %edi
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800802:	83 ec 0c             	sub    $0xc,%esp
  800805:	6a 00                	push   $0x0
  800807:	e8 f3 2a 00 00       	call   8032ff <sys_destroy_env>
  80080c:	83 c4 10             	add    $0x10,%esp
}
  80080f:	90                   	nop
  800810:	c9                   	leave  
  800811:	c3                   	ret    

00800812 <exit>:

void
exit(void)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800818:	e8 48 2b 00 00       	call   803365 <sys_exit_env>
}
  80081d:	90                   	nop
  80081e:	c9                   	leave  
  80081f:	c3                   	ret    

00800820 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	53                   	push   %ebx
  800824:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	8d 48 01             	lea    0x1(%eax),%ecx
  80082f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800832:	89 0a                	mov    %ecx,(%edx)
  800834:	8b 55 08             	mov    0x8(%ebp),%edx
  800837:	88 d1                	mov    %dl,%cl
  800839:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800840:	8b 45 0c             	mov    0xc(%ebp),%eax
  800843:	8b 00                	mov    (%eax),%eax
  800845:	3d ff 00 00 00       	cmp    $0xff,%eax
  80084a:	75 30                	jne    80087c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80084c:	8b 15 38 61 83 00    	mov    0x836138,%edx
  800852:	a0 64 e0 81 00       	mov    0x81e064,%al
  800857:	0f b6 c0             	movzbl %al,%eax
  80085a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085d:	8b 09                	mov    (%ecx),%ecx
  80085f:	89 cb                	mov    %ecx,%ebx
  800861:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800864:	83 c1 08             	add    $0x8,%ecx
  800867:	52                   	push   %edx
  800868:	50                   	push   %eax
  800869:	53                   	push   %ebx
  80086a:	51                   	push   %ecx
  80086b:	e8 06 28 00 00       	call   803076 <sys_cputs>
  800870:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800873:	8b 45 0c             	mov    0xc(%ebp),%eax
  800876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80087c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087f:	8b 40 04             	mov    0x4(%eax),%eax
  800882:	8d 50 01             	lea    0x1(%eax),%edx
  800885:	8b 45 0c             	mov    0xc(%ebp),%eax
  800888:	89 50 04             	mov    %edx,0x4(%eax)
}
  80088b:	90                   	nop
  80088c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088f:	c9                   	leave  
  800890:	c3                   	ret    

00800891 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80089a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008a1:	00 00 00 
	b.cnt = 0;
  8008a4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008ab:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8008ae:	ff 75 0c             	pushl  0xc(%ebp)
  8008b1:	ff 75 08             	pushl  0x8(%ebp)
  8008b4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008ba:	50                   	push   %eax
  8008bb:	68 20 08 80 00       	push   $0x800820
  8008c0:	e8 5a 02 00 00       	call   800b1f <vprintfmt>
  8008c5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8008c8:	8b 15 38 61 83 00    	mov    0x836138,%edx
  8008ce:	a0 64 e0 81 00       	mov    0x81e064,%al
  8008d3:	0f b6 c0             	movzbl %al,%eax
  8008d6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8008dc:	52                   	push   %edx
  8008dd:	50                   	push   %eax
  8008de:	51                   	push   %ecx
  8008df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008e5:	83 c0 08             	add    $0x8,%eax
  8008e8:	50                   	push   %eax
  8008e9:	e8 88 27 00 00       	call   803076 <sys_cputs>
  8008ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8008f1:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
	return b.cnt;
  8008f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8008fe:	c9                   	leave  
  8008ff:	c3                   	ret    

00800900 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800906:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	va_start(ap, fmt);
  80090d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800910:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 f4             	pushl  -0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	e8 6f ff ff ff       	call   800891 <vcprintf>
  800922:	83 c4 10             	add    $0x10,%esp
  800925:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800928:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800933:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	c1 e0 08             	shl    $0x8,%eax
  800940:	a3 38 61 83 00       	mov    %eax,0x836138
	va_start(ap, fmt);
  800945:	8d 45 0c             	lea    0xc(%ebp),%eax
  800948:	83 c0 04             	add    $0x4,%eax
  80094b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 f4             	pushl  -0xc(%ebp)
  800957:	50                   	push   %eax
  800958:	e8 34 ff ff ff       	call   800891 <vcprintf>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800963:	c7 05 38 61 83 00 00 	movl   $0x700,0x836138
  80096a:	07 00 00 

	return cnt;
  80096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800970:	c9                   	leave  
  800971:	c3                   	ret    

00800972 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800978:	e8 3d 27 00 00       	call   8030ba <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80097d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800980:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 f4             	pushl  -0xc(%ebp)
  80098c:	50                   	push   %eax
  80098d:	e8 ff fe ff ff       	call   800891 <vcprintf>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800998:	e8 37 27 00 00       	call   8030d4 <sys_unlock_cons>
	return cnt;
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	83 ec 14             	sub    $0x14,%esp
  8009a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8009b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009c0:	77 55                	ja     800a17 <printnum+0x75>
  8009c2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009c5:	72 05                	jb     8009cc <printnum+0x2a>
  8009c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009ca:	77 4b                	ja     800a17 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009cc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009cf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009d2:	8b 45 18             	mov    0x18(%ebp),%eax
  8009d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009da:	52                   	push   %edx
  8009db:	50                   	push   %eax
  8009dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8009df:	ff 75 f0             	pushl  -0x10(%ebp)
  8009e2:	e8 c5 39 00 00       	call   8043ac <__udivdi3>
  8009e7:	83 c4 10             	add    $0x10,%esp
  8009ea:	83 ec 04             	sub    $0x4,%esp
  8009ed:	ff 75 20             	pushl  0x20(%ebp)
  8009f0:	53                   	push   %ebx
  8009f1:	ff 75 18             	pushl  0x18(%ebp)
  8009f4:	52                   	push   %edx
  8009f5:	50                   	push   %eax
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	ff 75 08             	pushl  0x8(%ebp)
  8009fc:	e8 a1 ff ff ff       	call   8009a2 <printnum>
  800a01:	83 c4 20             	add    $0x20,%esp
  800a04:	eb 1a                	jmp    800a20 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	ff 75 20             	pushl  0x20(%ebp)
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	ff d0                	call   *%eax
  800a14:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a17:	ff 4d 1c             	decl   0x1c(%ebp)
  800a1a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a1e:	7f e6                	jg     800a06 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a20:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a2e:	53                   	push   %ebx
  800a2f:	51                   	push   %ecx
  800a30:	52                   	push   %edx
  800a31:	50                   	push   %eax
  800a32:	e8 85 3a 00 00       	call   8044bc <__umoddi3>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	05 34 4b 80 00       	add    $0x804b34,%eax
  800a3f:	8a 00                	mov    (%eax),%al
  800a41:	0f be c0             	movsbl %al,%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	50                   	push   %eax
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	ff d0                	call   *%eax
  800a50:	83 c4 10             	add    $0x10,%esp
}
  800a53:	90                   	nop
  800a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a57:	c9                   	leave  
  800a58:	c3                   	ret    

00800a59 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a60:	7e 1c                	jle    800a7e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8b 00                	mov    (%eax),%eax
  800a67:	8d 50 08             	lea    0x8(%eax),%edx
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	89 10                	mov    %edx,(%eax)
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	8b 00                	mov    (%eax),%eax
  800a74:	83 e8 08             	sub    $0x8,%eax
  800a77:	8b 50 04             	mov    0x4(%eax),%edx
  800a7a:	8b 00                	mov    (%eax),%eax
  800a7c:	eb 40                	jmp    800abe <getuint+0x65>
	else if (lflag)
  800a7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a82:	74 1e                	je     800aa2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	8d 50 04             	lea    0x4(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 10                	mov    %edx,(%eax)
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 e8 04             	sub    $0x4,%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa0:	eb 1c                	jmp    800abe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 00                	mov    (%eax),%eax
  800aa7:	8d 50 04             	lea    0x4(%eax),%edx
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	89 10                	mov    %edx,(%eax)
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8b 00                	mov    (%eax),%eax
  800ab4:	83 e8 04             	sub    $0x4,%eax
  800ab7:	8b 00                	mov    (%eax),%eax
  800ab9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ac3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ac7:	7e 1c                	jle    800ae5 <getint+0x25>
		return va_arg(*ap, long long);
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 00                	mov    (%eax),%eax
  800ace:	8d 50 08             	lea    0x8(%eax),%edx
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	89 10                	mov    %edx,(%eax)
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	83 e8 08             	sub    $0x8,%eax
  800ade:	8b 50 04             	mov    0x4(%eax),%edx
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	eb 38                	jmp    800b1d <getint+0x5d>
	else if (lflag)
  800ae5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae9:	74 1a                	je     800b05 <getint+0x45>
		return va_arg(*ap, long);
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 50 04             	lea    0x4(%eax),%edx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 10                	mov    %edx,(%eax)
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	83 e8 04             	sub    $0x4,%eax
  800b00:	8b 00                	mov    (%eax),%eax
  800b02:	99                   	cltd   
  800b03:	eb 18                	jmp    800b1d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8b 00                	mov    (%eax),%eax
  800b0a:	8d 50 04             	lea    0x4(%eax),%edx
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	89 10                	mov    %edx,(%eax)
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8b 00                	mov    (%eax),%eax
  800b17:	83 e8 04             	sub    $0x4,%eax
  800b1a:	8b 00                	mov    (%eax),%eax
  800b1c:	99                   	cltd   
}
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
  800b24:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b27:	eb 17                	jmp    800b40 <vprintfmt+0x21>
			if (ch == '\0')
  800b29:	85 db                	test   %ebx,%ebx
  800b2b:	0f 84 c1 03 00 00    	je     800ef2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	53                   	push   %ebx
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	ff d0                	call   *%eax
  800b3d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b40:	8b 45 10             	mov    0x10(%ebp),%eax
  800b43:	8d 50 01             	lea    0x1(%eax),%edx
  800b46:	89 55 10             	mov    %edx,0x10(%ebp)
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f b6 d8             	movzbl %al,%ebx
  800b4e:	83 fb 25             	cmp    $0x25,%ebx
  800b51:	75 d6                	jne    800b29 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b53:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b73:	8b 45 10             	mov    0x10(%ebp),%eax
  800b76:	8d 50 01             	lea    0x1(%eax),%edx
  800b79:	89 55 10             	mov    %edx,0x10(%ebp)
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d8             	movzbl %al,%ebx
  800b81:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b84:	83 f8 5b             	cmp    $0x5b,%eax
  800b87:	0f 87 3d 03 00 00    	ja     800eca <vprintfmt+0x3ab>
  800b8d:	8b 04 85 58 4b 80 00 	mov    0x804b58(,%eax,4),%eax
  800b94:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b96:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b9a:	eb d7                	jmp    800b73 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b9c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ba0:	eb d1                	jmp    800b73 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ba2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ba9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bac:	89 d0                	mov    %edx,%eax
  800bae:	c1 e0 02             	shl    $0x2,%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	01 c0                	add    %eax,%eax
  800bb5:	01 d8                	add    %ebx,%eax
  800bb7:	83 e8 30             	sub    $0x30,%eax
  800bba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	8a 00                	mov    (%eax),%al
  800bc2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bc5:	83 fb 2f             	cmp    $0x2f,%ebx
  800bc8:	7e 3e                	jle    800c08 <vprintfmt+0xe9>
  800bca:	83 fb 39             	cmp    $0x39,%ebx
  800bcd:	7f 39                	jg     800c08 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bcf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bd2:	eb d5                	jmp    800ba9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd7:	83 c0 04             	add    $0x4,%eax
  800bda:	89 45 14             	mov    %eax,0x14(%ebp)
  800bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800be0:	83 e8 04             	sub    $0x4,%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800be8:	eb 1f                	jmp    800c09 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bee:	79 83                	jns    800b73 <vprintfmt+0x54>
				width = 0;
  800bf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800bf7:	e9 77 ff ff ff       	jmp    800b73 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800bfc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c03:	e9 6b ff ff ff       	jmp    800b73 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c08:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c0d:	0f 89 60 ff ff ff    	jns    800b73 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c20:	e9 4e ff ff ff       	jmp    800b73 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c25:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c28:	e9 46 ff ff ff       	jmp    800b73 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 c0 04             	add    $0x4,%eax
  800c33:	89 45 14             	mov    %eax,0x14(%ebp)
  800c36:	8b 45 14             	mov    0x14(%ebp),%eax
  800c39:	83 e8 04             	sub    $0x4,%eax
  800c3c:	8b 00                	mov    (%eax),%eax
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	ff 75 0c             	pushl  0xc(%ebp)
  800c44:	50                   	push   %eax
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	ff d0                	call   *%eax
  800c4a:	83 c4 10             	add    $0x10,%esp
			break;
  800c4d:	e9 9b 02 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c52:	8b 45 14             	mov    0x14(%ebp),%eax
  800c55:	83 c0 04             	add    $0x4,%eax
  800c58:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5e:	83 e8 04             	sub    $0x4,%eax
  800c61:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c63:	85 db                	test   %ebx,%ebx
  800c65:	79 02                	jns    800c69 <vprintfmt+0x14a>
				err = -err;
  800c67:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c69:	83 fb 64             	cmp    $0x64,%ebx
  800c6c:	7f 0b                	jg     800c79 <vprintfmt+0x15a>
  800c6e:	8b 34 9d a0 49 80 00 	mov    0x8049a0(,%ebx,4),%esi
  800c75:	85 f6                	test   %esi,%esi
  800c77:	75 19                	jne    800c92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c79:	53                   	push   %ebx
  800c7a:	68 45 4b 80 00       	push   $0x804b45
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	ff 75 08             	pushl  0x8(%ebp)
  800c85:	e8 70 02 00 00       	call   800efa <printfmt>
  800c8a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c8d:	e9 5b 02 00 00       	jmp    800eed <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c92:	56                   	push   %esi
  800c93:	68 4e 4b 80 00       	push   $0x804b4e
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	ff 75 08             	pushl  0x8(%ebp)
  800c9e:	e8 57 02 00 00       	call   800efa <printfmt>
  800ca3:	83 c4 10             	add    $0x10,%esp
			break;
  800ca6:	e9 42 02 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 c0 04             	add    $0x4,%eax
  800cb1:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb7:	83 e8 04             	sub    $0x4,%eax
  800cba:	8b 30                	mov    (%eax),%esi
  800cbc:	85 f6                	test   %esi,%esi
  800cbe:	75 05                	jne    800cc5 <vprintfmt+0x1a6>
				p = "(null)";
  800cc0:	be 51 4b 80 00       	mov    $0x804b51,%esi
			if (width > 0 && padc != '-')
  800cc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc9:	7e 6d                	jle    800d38 <vprintfmt+0x219>
  800ccb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ccf:	74 67                	je     800d38 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	50                   	push   %eax
  800cd8:	56                   	push   %esi
  800cd9:	e8 1e 03 00 00       	call   800ffc <strnlen>
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ce4:	eb 16                	jmp    800cfc <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ce6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800cea:	83 ec 08             	sub    $0x8,%esp
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	50                   	push   %eax
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	ff d0                	call   *%eax
  800cf6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf9:	ff 4d e4             	decl   -0x1c(%ebp)
  800cfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d00:	7f e4                	jg     800ce6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d02:	eb 34                	jmp    800d38 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d08:	74 1c                	je     800d26 <vprintfmt+0x207>
  800d0a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d0d:	7e 05                	jle    800d14 <vprintfmt+0x1f5>
  800d0f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d12:	7e 12                	jle    800d26 <vprintfmt+0x207>
					putch('?', putdat);
  800d14:	83 ec 08             	sub    $0x8,%esp
  800d17:	ff 75 0c             	pushl  0xc(%ebp)
  800d1a:	6a 3f                	push   $0x3f
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	ff d0                	call   *%eax
  800d21:	83 c4 10             	add    $0x10,%esp
  800d24:	eb 0f                	jmp    800d35 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d26:	83 ec 08             	sub    $0x8,%esp
  800d29:	ff 75 0c             	pushl  0xc(%ebp)
  800d2c:	53                   	push   %ebx
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	ff d0                	call   *%eax
  800d32:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d35:	ff 4d e4             	decl   -0x1c(%ebp)
  800d38:	89 f0                	mov    %esi,%eax
  800d3a:	8d 70 01             	lea    0x1(%eax),%esi
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f be d8             	movsbl %al,%ebx
  800d42:	85 db                	test   %ebx,%ebx
  800d44:	74 24                	je     800d6a <vprintfmt+0x24b>
  800d46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d4a:	78 b8                	js     800d04 <vprintfmt+0x1e5>
  800d4c:	ff 4d e0             	decl   -0x20(%ebp)
  800d4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d53:	79 af                	jns    800d04 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d55:	eb 13                	jmp    800d6a <vprintfmt+0x24b>
				putch(' ', putdat);
  800d57:	83 ec 08             	sub    $0x8,%esp
  800d5a:	ff 75 0c             	pushl  0xc(%ebp)
  800d5d:	6a 20                	push   $0x20
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	ff d0                	call   *%eax
  800d64:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d67:	ff 4d e4             	decl   -0x1c(%ebp)
  800d6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d6e:	7f e7                	jg     800d57 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d70:	e9 78 01 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d75:	83 ec 08             	sub    $0x8,%esp
  800d78:	ff 75 e8             	pushl  -0x18(%ebp)
  800d7b:	8d 45 14             	lea    0x14(%ebp),%eax
  800d7e:	50                   	push   %eax
  800d7f:	e8 3c fd ff ff       	call   800ac0 <getint>
  800d84:	83 c4 10             	add    $0x10,%esp
  800d87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d93:	85 d2                	test   %edx,%edx
  800d95:	79 23                	jns    800dba <vprintfmt+0x29b>
				putch('-', putdat);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	6a 2d                	push   $0x2d
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	ff d0                	call   *%eax
  800da4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dad:	f7 d8                	neg    %eax
  800daf:	83 d2 00             	adc    $0x0,%edx
  800db2:	f7 da                	neg    %edx
  800db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dc1:	e9 bc 00 00 00       	jmp    800e82 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dc6:	83 ec 08             	sub    $0x8,%esp
  800dc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800dcf:	50                   	push   %eax
  800dd0:	e8 84 fc ff ff       	call   800a59 <getuint>
  800dd5:	83 c4 10             	add    $0x10,%esp
  800dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800dde:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de5:	e9 98 00 00 00       	jmp    800e82 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	6a 58                	push   $0x58
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	ff d0                	call   *%eax
  800df7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800dfa:	83 ec 08             	sub    $0x8,%esp
  800dfd:	ff 75 0c             	pushl  0xc(%ebp)
  800e00:	6a 58                	push   $0x58
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	ff d0                	call   *%eax
  800e07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	ff 75 0c             	pushl  0xc(%ebp)
  800e10:	6a 58                	push   $0x58
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	ff d0                	call   *%eax
  800e17:	83 c4 10             	add    $0x10,%esp
			break;
  800e1a:	e9 ce 00 00 00       	jmp    800eed <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 30                	push   $0x30
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e2f:	83 ec 08             	sub    $0x8,%esp
  800e32:	ff 75 0c             	pushl  0xc(%ebp)
  800e35:	6a 78                	push   $0x78
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 c0 04             	add    $0x4,%eax
  800e45:	89 45 14             	mov    %eax,0x14(%ebp)
  800e48:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4b:	83 e8 04             	sub    $0x4,%eax
  800e4e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e61:	eb 1f                	jmp    800e82 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e63:	83 ec 08             	sub    $0x8,%esp
  800e66:	ff 75 e8             	pushl  -0x18(%ebp)
  800e69:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6c:	50                   	push   %eax
  800e6d:	e8 e7 fb ff ff       	call   800a59 <getuint>
  800e72:	83 c4 10             	add    $0x10,%esp
  800e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e89:	83 ec 04             	sub    $0x4,%esp
  800e8c:	52                   	push   %edx
  800e8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e90:	50                   	push   %eax
  800e91:	ff 75 f4             	pushl  -0xc(%ebp)
  800e94:	ff 75 f0             	pushl  -0x10(%ebp)
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	ff 75 08             	pushl  0x8(%ebp)
  800e9d:	e8 00 fb ff ff       	call   8009a2 <printnum>
  800ea2:	83 c4 20             	add    $0x20,%esp
			break;
  800ea5:	eb 46                	jmp    800eed <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	53                   	push   %ebx
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	ff d0                	call   *%eax
  800eb3:	83 c4 10             	add    $0x10,%esp
			break;
  800eb6:	eb 35                	jmp    800eed <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800eb8:	c6 05 64 e0 81 00 00 	movb   $0x0,0x81e064
			break;
  800ebf:	eb 2c                	jmp    800eed <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ec1:	c6 05 64 e0 81 00 01 	movb   $0x1,0x81e064
			break;
  800ec8:	eb 23                	jmp    800eed <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eca:	83 ec 08             	sub    $0x8,%esp
  800ecd:	ff 75 0c             	pushl  0xc(%ebp)
  800ed0:	6a 25                	push   $0x25
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	ff d0                	call   *%eax
  800ed7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eda:	ff 4d 10             	decl   0x10(%ebp)
  800edd:	eb 03                	jmp    800ee2 <vprintfmt+0x3c3>
  800edf:	ff 4d 10             	decl   0x10(%ebp)
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	48                   	dec    %eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	3c 25                	cmp    $0x25,%al
  800eea:	75 f3                	jne    800edf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800eec:	90                   	nop
		}
	}
  800eed:	e9 35 fc ff ff       	jmp    800b27 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ef2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ef3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    

00800efa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f00:	8d 45 10             	lea    0x10(%ebp),%eax
  800f03:	83 c0 04             	add    $0x4,%eax
  800f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f0f:	50                   	push   %eax
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	ff 75 08             	pushl  0x8(%ebp)
  800f16:	e8 04 fc ff ff       	call   800b1f <vprintfmt>
  800f1b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f1e:	90                   	nop
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	8b 40 08             	mov    0x8(%eax),%eax
  800f2a:	8d 50 01             	lea    0x1(%eax),%edx
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	8b 10                	mov    (%eax),%edx
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	8b 40 04             	mov    0x4(%eax),%eax
  800f3e:	39 c2                	cmp    %eax,%edx
  800f40:	73 12                	jae    800f54 <sprintputch+0x33>
		*b->buf++ = ch;
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8b 00                	mov    (%eax),%eax
  800f47:	8d 48 01             	lea    0x1(%eax),%ecx
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	89 0a                	mov    %ecx,(%edx)
  800f4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f52:	88 10                	mov    %dl,(%eax)
}
  800f54:	90                   	nop
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    

00800f57 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	01 d0                	add    %edx,%eax
  800f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f7c:	74 06                	je     800f84 <vsnprintf+0x2d>
  800f7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f82:	7f 07                	jg     800f8b <vsnprintf+0x34>
		return -E_INVAL;
  800f84:	b8 03 00 00 00       	mov    $0x3,%eax
  800f89:	eb 20                	jmp    800fab <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f8b:	ff 75 14             	pushl  0x14(%ebp)
  800f8e:	ff 75 10             	pushl  0x10(%ebp)
  800f91:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f94:	50                   	push   %eax
  800f95:	68 21 0f 80 00       	push   $0x800f21
  800f9a:	e8 80 fb ff ff       	call   800b1f <vprintfmt>
  800f9f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fa5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fb3:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb6:	83 c0 04             	add    $0x4,%eax
  800fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc2:	50                   	push   %eax
  800fc3:	ff 75 0c             	pushl  0xc(%ebp)
  800fc6:	ff 75 08             	pushl  0x8(%ebp)
  800fc9:	e8 89 ff ff ff       	call   800f57 <vsnprintf>
  800fce:	83 c4 10             	add    $0x10,%esp
  800fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fe6:	eb 06                	jmp    800fee <strlen+0x15>
		n++;
  800fe8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	84 c0                	test   %al,%al
  800ff5:	75 f1                	jne    800fe8 <strlen+0xf>
		n++;
	return n;
  800ff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ffa:	c9                   	leave  
  800ffb:	c3                   	ret    

00800ffc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801002:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801009:	eb 09                	jmp    801014 <strnlen+0x18>
		n++;
  80100b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80100e:	ff 45 08             	incl   0x8(%ebp)
  801011:	ff 4d 0c             	decl   0xc(%ebp)
  801014:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801018:	74 09                	je     801023 <strnlen+0x27>
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 e8                	jne    80100b <strnlen+0xf>
		n++;
	return n;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801034:	90                   	nop
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8d 50 01             	lea    0x1(%eax),%edx
  80103b:	89 55 08             	mov    %edx,0x8(%ebp)
  80103e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801041:	8d 4a 01             	lea    0x1(%edx),%ecx
  801044:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801047:	8a 12                	mov    (%edx),%dl
  801049:	88 10                	mov    %dl,(%eax)
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	84 c0                	test   %al,%al
  80104f:	75 e4                	jne    801035 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801051:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801054:	c9                   	leave  
  801055:	c3                   	ret    

00801056 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801062:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801069:	eb 1f                	jmp    80108a <strncpy+0x34>
		*dst++ = *src;
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8d 50 01             	lea    0x1(%eax),%edx
  801071:	89 55 08             	mov    %edx,0x8(%ebp)
  801074:	8b 55 0c             	mov    0xc(%ebp),%edx
  801077:	8a 12                	mov    (%edx),%dl
  801079:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	84 c0                	test   %al,%al
  801082:	74 03                	je     801087 <strncpy+0x31>
			src++;
  801084:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801087:	ff 45 fc             	incl   -0x4(%ebp)
  80108a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801090:	72 d9                	jb     80106b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801092:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a7:	74 30                	je     8010d9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010a9:	eb 16                	jmp    8010c1 <strlcpy+0x2a>
			*dst++ = *src++;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8d 50 01             	lea    0x1(%eax),%edx
  8010b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010bd:	8a 12                	mov    (%edx),%dl
  8010bf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010c1:	ff 4d 10             	decl   0x10(%ebp)
  8010c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c8:	74 09                	je     8010d3 <strlcpy+0x3c>
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	84 c0                	test   %al,%al
  8010d1:	75 d8                	jne    8010ab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010df:	29 c2                	sub    %eax,%edx
  8010e1:	89 d0                	mov    %edx,%eax
}
  8010e3:	c9                   	leave  
  8010e4:	c3                   	ret    

008010e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010e8:	eb 06                	jmp    8010f0 <strcmp+0xb>
		p++, q++;
  8010ea:	ff 45 08             	incl   0x8(%ebp)
  8010ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	84 c0                	test   %al,%al
  8010f7:	74 0e                	je     801107 <strcmp+0x22>
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8a 10                	mov    (%eax),%dl
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	38 c2                	cmp    %al,%dl
  801105:	74 e3                	je     8010ea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	0f b6 d0             	movzbl %al,%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	0f b6 c0             	movzbl %al,%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
}
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801120:	eb 09                	jmp    80112b <strncmp+0xe>
		n--, p++, q++;
  801122:	ff 4d 10             	decl   0x10(%ebp)
  801125:	ff 45 08             	incl   0x8(%ebp)
  801128:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80112b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112f:	74 17                	je     801148 <strncmp+0x2b>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	84 c0                	test   %al,%al
  801138:	74 0e                	je     801148 <strncmp+0x2b>
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 10                	mov    (%eax),%dl
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	38 c2                	cmp    %al,%dl
  801146:	74 da                	je     801122 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114c:	75 07                	jne    801155 <strncmp+0x38>
		return 0;
  80114e:	b8 00 00 00 00       	mov    $0x0,%eax
  801153:	eb 14                	jmp    801169 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	0f b6 d0             	movzbl %al,%edx
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	0f b6 c0             	movzbl %al,%eax
  801165:	29 c2                	sub    %eax,%edx
  801167:	89 d0                	mov    %edx,%eax
}
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    

0080116b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801177:	eb 12                	jmp    80118b <strchr+0x20>
		if (*s == c)
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801181:	75 05                	jne    801188 <strchr+0x1d>
			return (char *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	eb 11                	jmp    801199 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801188:	ff 45 08             	incl   0x8(%ebp)
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	84 c0                	test   %al,%al
  801192:	75 e5                	jne    801179 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801194:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	83 ec 04             	sub    $0x4,%esp
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011a7:	eb 0d                	jmp    8011b6 <strfind+0x1b>
		if (*s == c)
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011b1:	74 0e                	je     8011c1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011b3:	ff 45 08             	incl   0x8(%ebp)
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	84 c0                	test   %al,%al
  8011bd:	75 ea                	jne    8011a9 <strfind+0xe>
  8011bf:	eb 01                	jmp    8011c2 <strfind+0x27>
		if (*s == c)
			break;
  8011c1:	90                   	nop
	return (char *) s;
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8011d3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011d7:	76 63                	jbe    80123c <memset+0x75>
		uint64 data_block = c;
  8011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dc:	99                   	cltd   
  8011dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8011e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8011ed:	c1 e0 08             	shl    $0x8,%eax
  8011f0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011f3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8011f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fc:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801200:	c1 e0 10             	shl    $0x10,%eax
  801203:	09 45 f0             	or     %eax,-0x10(%ebp)
  801206:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120f:	89 c2                	mov    %eax,%edx
  801211:	b8 00 00 00 00       	mov    $0x0,%eax
  801216:	09 45 f0             	or     %eax,-0x10(%ebp)
  801219:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80121c:	eb 18                	jmp    801236 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80121e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801221:	8d 41 08             	lea    0x8(%ecx),%eax
  801224:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122d:	89 01                	mov    %eax,(%ecx)
  80122f:	89 51 04             	mov    %edx,0x4(%ecx)
  801232:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801236:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80123a:	77 e2                	ja     80121e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80123c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801240:	74 23                	je     801265 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801242:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801245:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801248:	eb 0e                	jmp    801258 <memset+0x91>
			*p8++ = (uint8)c;
  80124a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801253:	8b 55 0c             	mov    0xc(%ebp),%edx
  801256:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801258:	8b 45 10             	mov    0x10(%ebp),%eax
  80125b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80125e:	89 55 10             	mov    %edx,0x10(%ebp)
  801261:	85 c0                	test   %eax,%eax
  801263:	75 e5                	jne    80124a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801270:	8b 45 0c             	mov    0xc(%ebp),%eax
  801273:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80127c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801280:	76 24                	jbe    8012a6 <memcpy+0x3c>
		while(n >= 8){
  801282:	eb 1c                	jmp    8012a0 <memcpy+0x36>
			*d64 = *s64;
  801284:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801287:	8b 50 04             	mov    0x4(%eax),%edx
  80128a:	8b 00                	mov    (%eax),%eax
  80128c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80128f:	89 01                	mov    %eax,(%ecx)
  801291:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801294:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801298:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80129c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8012a0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8012a4:	77 de                	ja     801284 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8012a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012aa:	74 31                	je     8012dd <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8012b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8012b8:	eb 16                	jmp    8012d0 <memcpy+0x66>
			*d8++ = *s8++;
  8012ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bd:	8d 50 01             	lea    0x1(%eax),%edx
  8012c0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8012c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8012cc:	8a 12                	mov    (%edx),%dl
  8012ce:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	75 dd                	jne    8012ba <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012fa:	73 50                	jae    80134c <memmove+0x6a>
  8012fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801307:	76 43                	jbe    80134c <memmove+0x6a>
		s += n;
  801309:	8b 45 10             	mov    0x10(%ebp),%eax
  80130c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801315:	eb 10                	jmp    801327 <memmove+0x45>
			*--d = *--s;
  801317:	ff 4d f8             	decl   -0x8(%ebp)
  80131a:	ff 4d fc             	decl   -0x4(%ebp)
  80131d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801320:	8a 10                	mov    (%eax),%dl
  801322:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801325:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801327:	8b 45 10             	mov    0x10(%ebp),%eax
  80132a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80132d:	89 55 10             	mov    %edx,0x10(%ebp)
  801330:	85 c0                	test   %eax,%eax
  801332:	75 e3                	jne    801317 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801334:	eb 23                	jmp    801359 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801336:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801339:	8d 50 01             	lea    0x1(%eax),%edx
  80133c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80133f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801342:	8d 4a 01             	lea    0x1(%edx),%ecx
  801345:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801348:	8a 12                	mov    (%edx),%dl
  80134a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80134c:	8b 45 10             	mov    0x10(%ebp),%eax
  80134f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801352:	89 55 10             	mov    %edx,0x10(%ebp)
  801355:	85 c0                	test   %eax,%eax
  801357:	75 dd                	jne    801336 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
  801361:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801364:	8b 45 08             	mov    0x8(%ebp),%eax
  801367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80136a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801370:	eb 2a                	jmp    80139c <memcmp+0x3e>
		if (*s1 != *s2)
  801372:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801375:	8a 10                	mov    (%eax),%dl
  801377:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	38 c2                	cmp    %al,%dl
  80137e:	74 16                	je     801396 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801380:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	0f b6 d0             	movzbl %al,%edx
  801388:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	0f b6 c0             	movzbl %al,%eax
  801390:	29 c2                	sub    %eax,%edx
  801392:	89 d0                	mov    %edx,%eax
  801394:	eb 18                	jmp    8013ae <memcmp+0x50>
		s1++, s2++;
  801396:	ff 45 fc             	incl   -0x4(%ebp)
  801399:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80139c:	8b 45 10             	mov    0x10(%ebp),%eax
  80139f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	75 c9                	jne    801372 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	01 d0                	add    %edx,%eax
  8013be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013c1:	eb 15                	jmp    8013d8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 00                	mov    (%eax),%al
  8013c8:	0f b6 d0             	movzbl %al,%edx
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	0f b6 c0             	movzbl %al,%eax
  8013d1:	39 c2                	cmp    %eax,%edx
  8013d3:	74 0d                	je     8013e2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013d5:	ff 45 08             	incl   0x8(%ebp)
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013de:	72 e3                	jb     8013c3 <memfind+0x13>
  8013e0:	eb 01                	jmp    8013e3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013e2:	90                   	nop
	return (void *) s;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013fc:	eb 03                	jmp    801401 <strtol+0x19>
		s++;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	3c 20                	cmp    $0x20,%al
  801408:	74 f4                	je     8013fe <strtol+0x16>
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	3c 09                	cmp    $0x9,%al
  801411:	74 eb                	je     8013fe <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	3c 2b                	cmp    $0x2b,%al
  80141a:	75 05                	jne    801421 <strtol+0x39>
		s++;
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	eb 13                	jmp    801434 <strtol+0x4c>
	else if (*s == '-')
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	3c 2d                	cmp    $0x2d,%al
  801428:	75 0a                	jne    801434 <strtol+0x4c>
		s++, neg = 1;
  80142a:	ff 45 08             	incl   0x8(%ebp)
  80142d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801434:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801438:	74 06                	je     801440 <strtol+0x58>
  80143a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80143e:	75 20                	jne    801460 <strtol+0x78>
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	3c 30                	cmp    $0x30,%al
  801447:	75 17                	jne    801460 <strtol+0x78>
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	40                   	inc    %eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 78                	cmp    $0x78,%al
  801451:	75 0d                	jne    801460 <strtol+0x78>
		s += 2, base = 16;
  801453:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801457:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80145e:	eb 28                	jmp    801488 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801460:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801464:	75 15                	jne    80147b <strtol+0x93>
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	3c 30                	cmp    $0x30,%al
  80146d:	75 0c                	jne    80147b <strtol+0x93>
		s++, base = 8;
  80146f:	ff 45 08             	incl   0x8(%ebp)
  801472:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801479:	eb 0d                	jmp    801488 <strtol+0xa0>
	else if (base == 0)
  80147b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147f:	75 07                	jne    801488 <strtol+0xa0>
		base = 10;
  801481:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	3c 2f                	cmp    $0x2f,%al
  80148f:	7e 19                	jle    8014aa <strtol+0xc2>
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8a 00                	mov    (%eax),%al
  801496:	3c 39                	cmp    $0x39,%al
  801498:	7f 10                	jg     8014aa <strtol+0xc2>
			dig = *s - '0';
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	0f be c0             	movsbl %al,%eax
  8014a2:	83 e8 30             	sub    $0x30,%eax
  8014a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014a8:	eb 42                	jmp    8014ec <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 60                	cmp    $0x60,%al
  8014b1:	7e 19                	jle    8014cc <strtol+0xe4>
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	3c 7a                	cmp    $0x7a,%al
  8014ba:	7f 10                	jg     8014cc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	0f be c0             	movsbl %al,%eax
  8014c4:	83 e8 57             	sub    $0x57,%eax
  8014c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014ca:	eb 20                	jmp    8014ec <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	3c 40                	cmp    $0x40,%al
  8014d3:	7e 39                	jle    80150e <strtol+0x126>
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	3c 5a                	cmp    $0x5a,%al
  8014dc:	7f 30                	jg     80150e <strtol+0x126>
			dig = *s - 'A' + 10;
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	0f be c0             	movsbl %al,%eax
  8014e6:	83 e8 37             	sub    $0x37,%eax
  8014e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ef:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f2:	7d 19                	jge    80150d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014f4:	ff 45 08             	incl   0x8(%ebp)
  8014f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fa:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014fe:	89 c2                	mov    %eax,%edx
  801500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801503:	01 d0                	add    %edx,%eax
  801505:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801508:	e9 7b ff ff ff       	jmp    801488 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80150d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80150e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801512:	74 08                	je     80151c <strtol+0x134>
		*endptr = (char *) s;
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	8b 55 08             	mov    0x8(%ebp),%edx
  80151a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80151c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801520:	74 07                	je     801529 <strtol+0x141>
  801522:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801525:	f7 d8                	neg    %eax
  801527:	eb 03                	jmp    80152c <strtol+0x144>
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <ltostr>:

void
ltostr(long value, char *str)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801534:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80153b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801542:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801546:	79 13                	jns    80155b <ltostr+0x2d>
	{
		neg = 1;
  801548:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80154f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801552:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801555:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801558:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801563:	99                   	cltd   
  801564:	f7 f9                	idiv   %ecx
  801566:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801569:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156c:	8d 50 01             	lea    0x1(%eax),%edx
  80156f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801572:	89 c2                	mov    %eax,%edx
  801574:	8b 45 0c             	mov    0xc(%ebp),%eax
  801577:	01 d0                	add    %edx,%eax
  801579:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80157c:	83 c2 30             	add    $0x30,%edx
  80157f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801581:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801584:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801589:	f7 e9                	imul   %ecx
  80158b:	c1 fa 02             	sar    $0x2,%edx
  80158e:	89 c8                	mov    %ecx,%eax
  801590:	c1 f8 1f             	sar    $0x1f,%eax
  801593:	29 c2                	sub    %eax,%edx
  801595:	89 d0                	mov    %edx,%eax
  801597:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80159a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80159e:	75 bb                	jne    80155b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015aa:	48                   	dec    %eax
  8015ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015b2:	74 3d                	je     8015f1 <ltostr+0xc3>
		start = 1 ;
  8015b4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015bb:	eb 34                	jmp    8015f1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8015bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	01 c2                	add    %eax,%edx
  8015d2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	01 c8                	add    %ecx,%eax
  8015da:	8a 00                	mov    (%eax),%al
  8015dc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	01 c2                	add    %eax,%edx
  8015e6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015e9:	88 02                	mov    %al,(%edx)
		start++ ;
  8015eb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015ee:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015f7:	7c c4                	jl     8015bd <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015f9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	01 d0                	add    %edx,%eax
  801601:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801604:	90                   	nop
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	e8 c4 f9 ff ff       	call   800fd9 <strlen>
  801615:	83 c4 04             	add    $0x4,%esp
  801618:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80161b:	ff 75 0c             	pushl  0xc(%ebp)
  80161e:	e8 b6 f9 ff ff       	call   800fd9 <strlen>
  801623:	83 c4 04             	add    $0x4,%esp
  801626:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801629:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801630:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801637:	eb 17                	jmp    801650 <strcconcat+0x49>
		final[s] = str1[s] ;
  801639:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163c:	8b 45 10             	mov    0x10(%ebp),%eax
  80163f:	01 c2                	add    %eax,%edx
  801641:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	01 c8                	add    %ecx,%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80164d:	ff 45 fc             	incl   -0x4(%ebp)
  801650:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801653:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801656:	7c e1                	jl     801639 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801658:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80165f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801666:	eb 1f                	jmp    801687 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801668:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166b:	8d 50 01             	lea    0x1(%eax),%edx
  80166e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801671:	89 c2                	mov    %eax,%edx
  801673:	8b 45 10             	mov    0x10(%ebp),%eax
  801676:	01 c2                	add    %eax,%edx
  801678:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80167b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167e:	01 c8                	add    %ecx,%eax
  801680:	8a 00                	mov    (%eax),%al
  801682:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801684:	ff 45 f8             	incl   -0x8(%ebp)
  801687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80168d:	7c d9                	jl     801668 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80168f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801692:	8b 45 10             	mov    0x10(%ebp),%eax
  801695:	01 d0                	add    %edx,%eax
  801697:	c6 00 00             	movb   $0x0,(%eax)
}
  80169a:	90                   	nop
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ac:	8b 00                	mov    (%eax),%eax
  8016ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b8:	01 d0                	add    %edx,%eax
  8016ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016c0:	eb 0c                	jmp    8016ce <strsplit+0x31>
			*string++ = 0;
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8d 50 01             	lea    0x1(%eax),%edx
  8016c8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016cb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	84 c0                	test   %al,%al
  8016d5:	74 18                	je     8016ef <strsplit+0x52>
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8a 00                	mov    (%eax),%al
  8016dc:	0f be c0             	movsbl %al,%eax
  8016df:	50                   	push   %eax
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	e8 83 fa ff ff       	call   80116b <strchr>
  8016e8:	83 c4 08             	add    $0x8,%esp
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	75 d3                	jne    8016c2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	84 c0                	test   %al,%al
  8016f6:	74 5a                	je     801752 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fb:	8b 00                	mov    (%eax),%eax
  8016fd:	83 f8 0f             	cmp    $0xf,%eax
  801700:	75 07                	jne    801709 <strsplit+0x6c>
		{
			return 0;
  801702:	b8 00 00 00 00       	mov    $0x0,%eax
  801707:	eb 66                	jmp    80176f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801709:	8b 45 14             	mov    0x14(%ebp),%eax
  80170c:	8b 00                	mov    (%eax),%eax
  80170e:	8d 48 01             	lea    0x1(%eax),%ecx
  801711:	8b 55 14             	mov    0x14(%ebp),%edx
  801714:	89 0a                	mov    %ecx,(%edx)
  801716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 c2                	add    %eax,%edx
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801727:	eb 03                	jmp    80172c <strsplit+0x8f>
			string++;
  801729:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	84 c0                	test   %al,%al
  801733:	74 8b                	je     8016c0 <strsplit+0x23>
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	8a 00                	mov    (%eax),%al
  80173a:	0f be c0             	movsbl %al,%eax
  80173d:	50                   	push   %eax
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	e8 25 fa ff ff       	call   80116b <strchr>
  801746:	83 c4 08             	add    $0x8,%esp
  801749:	85 c0                	test   %eax,%eax
  80174b:	74 dc                	je     801729 <strsplit+0x8c>
			string++;
	}
  80174d:	e9 6e ff ff ff       	jmp    8016c0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801752:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801753:	8b 45 14             	mov    0x14(%ebp),%eax
  801756:	8b 00                	mov    (%eax),%eax
  801758:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 d0                	add    %edx,%eax
  801764:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80176a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80177d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801784:	eb 4a                	jmp    8017d0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801786:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	01 c2                	add    %eax,%edx
  80178e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801791:	8b 45 0c             	mov    0xc(%ebp),%eax
  801794:	01 c8                	add    %ecx,%eax
  801796:	8a 00                	mov    (%eax),%al
  801798:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80179a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80179d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a0:	01 d0                	add    %edx,%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	3c 40                	cmp    $0x40,%al
  8017a6:	7e 25                	jle    8017cd <str2lower+0x5c>
  8017a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ae:	01 d0                	add    %edx,%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 5a                	cmp    $0x5a,%al
  8017b4:	7f 17                	jg     8017cd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8017b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c4:	01 ca                	add    %ecx,%edx
  8017c6:	8a 12                	mov    (%edx),%dl
  8017c8:	83 c2 20             	add    $0x20,%edx
  8017cb:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8017cd:	ff 45 fc             	incl   -0x4(%ebp)
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	e8 01 f8 ff ff       	call   800fd9 <strlen>
  8017d8:	83 c4 04             	add    $0x4,%esp
  8017db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017de:	7f a6                	jg     801786 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8017e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8017eb:	a1 08 60 80 00       	mov    0x806008,%eax
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	74 42                	je     801836 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8017f4:	83 ec 08             	sub    $0x8,%esp
  8017f7:	68 00 00 00 82       	push   $0x82000000
  8017fc:	68 00 00 00 80       	push   $0x80000000
  801801:	e8 b0 1e 00 00       	call   8036b6 <initialize_dynamic_allocator>
  801806:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801809:	e8 96 1c 00 00       	call   8034a4 <sys_get_uheap_strategy>
  80180e:	a3 80 60 83 00       	mov    %eax,0x836080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801813:	a1 60 e0 81 00       	mov    0x81e060,%eax
  801818:	05 00 10 00 00       	add    $0x1000,%eax
  80181d:	a3 30 61 83 00       	mov    %eax,0x836130
		uheapPageAllocBreak = uheapPageAllocStart;
  801822:	a1 30 61 83 00       	mov    0x836130,%eax
  801827:	a3 88 60 83 00       	mov    %eax,0x836088

		__firstTimeFlag = 0;
  80182c:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801833:	00 00 00 
	}
}
  801836:	90                   	nop
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801848:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80184d:	83 ec 08             	sub    $0x8,%esp
  801850:	68 06 04 00 00       	push   $0x406
  801855:	50                   	push   %eax
  801856:	e8 93 18 00 00       	call   8030ee <__sys_allocate_page>
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801861:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801865:	79 14                	jns    80187b <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801867:	83 ec 04             	sub    $0x4,%esp
  80186a:	68 c8 4c 80 00       	push   $0x804cc8
  80186f:	6a 1f                	push   $0x1f
  801871:	68 04 4d 80 00       	push   $0x804d04
  801876:	e8 40 29 00 00       	call   8041bb <_panic>
	return 0;
  80187b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801891:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801896:	83 ec 0c             	sub    $0xc,%esp
  801899:	50                   	push   %eax
  80189a:	e8 96 18 00 00       	call   803135 <__sys_unmap_frame>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8018a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018a9:	79 14                	jns    8018bf <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8018ab:	83 ec 04             	sub    $0x4,%esp
  8018ae:	68 10 4d 80 00       	push   $0x804d10
  8018b3:	6a 2a                	push   $0x2a
  8018b5:	68 04 4d 80 00       	push   $0x804d04
  8018ba:	e8 fc 28 00 00       	call   8041bb <_panic>
}
  8018bf:	90                   	nop
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018c8:	e8 18 ff ff ff       	call   8017e5 <uheap_init>
	if (size == 0) return NULL ;
  8018cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d1:	75 0a                	jne    8018dd <malloc+0x1b>
  8018d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d8:	e9 43 03 00 00       	jmp    801c20 <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8018dd:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8018e4:	77 13                	ja     8018f9 <malloc+0x37>
    {
        return alloc_block(size);
  8018e6:	83 ec 0c             	sub    $0xc,%esp
  8018e9:	ff 75 08             	pushl  0x8(%ebp)
  8018ec:	e8 78 20 00 00       	call   803969 <alloc_block>
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	e9 27 03 00 00       	jmp    801c20 <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  8018f9:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801900:	8b 55 08             	mov    0x8(%ebp),%edx
  801903:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801906:	01 d0                	add    %edx,%eax
  801908:	48                   	dec    %eax
  801909:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80190c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80190f:	ba 00 00 00 00       	mov    $0x0,%edx
  801914:	f7 75 dc             	divl   -0x24(%ebp)
  801917:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80191a:	29 d0                	sub    %edx,%eax
  80191c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  80191f:	a1 40 e0 81 00       	mov    0x81e040,%eax
  801924:	85 c0                	test   %eax,%eax
  801926:	75 0a                	jne    801932 <malloc+0x70>
    {
        uhp_inited = 1;
  801928:	c7 05 40 e0 81 00 01 	movl   $0x1,0x81e040
  80192f:	00 00 00 
    }

    int exactIdx = -1;
  801932:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  801939:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  801940:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801947:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80194e:	e9 85 00 00 00       	jmp    8019d8 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  801953:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801956:	89 d0                	mov    %edx,%eax
  801958:	01 c0                	add    %eax,%eax
  80195a:	01 d0                	add    %edx,%eax
  80195c:	c1 e0 02             	shl    $0x2,%eax
  80195f:	05 48 20 81 00       	add    $0x812048,%eax
  801964:	8a 00                	mov    (%eax),%al
  801966:	84 c0                	test   %al,%al
  801968:	74 20                	je     80198a <malloc+0xc8>
  80196a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80196d:	89 d0                	mov    %edx,%eax
  80196f:	01 c0                	add    %eax,%eax
  801971:	01 d0                	add    %edx,%eax
  801973:	c1 e0 02             	shl    $0x2,%eax
  801976:	05 44 20 81 00       	add    $0x812044,%eax
  80197b:	8b 00                	mov    (%eax),%eax
  80197d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801980:	75 08                	jne    80198a <malloc+0xc8>
        {
            exactIdx = i;
  801982:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801985:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  801988:	eb 5b                	jmp    8019e5 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  80198a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80198d:	89 d0                	mov    %edx,%eax
  80198f:	01 c0                	add    %eax,%eax
  801991:	01 d0                	add    %edx,%eax
  801993:	c1 e0 02             	shl    $0x2,%eax
  801996:	05 48 20 81 00       	add    $0x812048,%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	84 c0                	test   %al,%al
  80199f:	74 34                	je     8019d5 <malloc+0x113>
  8019a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019a4:	89 d0                	mov    %edx,%eax
  8019a6:	01 c0                	add    %eax,%eax
  8019a8:	01 d0                	add    %edx,%eax
  8019aa:	c1 e0 02             	shl    $0x2,%eax
  8019ad:	05 44 20 81 00       	add    $0x812044,%eax
  8019b2:	8b 00                	mov    (%eax),%eax
  8019b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8019b7:	76 1c                	jbe    8019d5 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  8019b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019bc:	89 d0                	mov    %edx,%eax
  8019be:	01 c0                	add    %eax,%eax
  8019c0:	01 d0                	add    %edx,%eax
  8019c2:	c1 e0 02             	shl    $0x2,%eax
  8019c5:	05 44 20 81 00       	add    $0x812044,%eax
  8019ca:	8b 00                	mov    (%eax),%eax
  8019cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8019cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8019d5:	ff 45 e8             	incl   -0x18(%ebp)
  8019d8:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8019df:	0f 8e 6e ff ff ff    	jle    801953 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  8019e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8019ec:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8019f0:	74 7d                	je     801a6f <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8019f2:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8019f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fc:	89 d0                	mov    %edx,%eax
  8019fe:	01 c0                	add    %eax,%eax
  801a00:	01 d0                	add    %edx,%eax
  801a02:	c1 e0 02             	shl    $0x2,%eax
  801a05:	05 40 20 81 00       	add    $0x812040,%eax
  801a0a:	8b 10                	mov    (%eax),%edx
  801a0c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801a0f:	01 d0                	add    %edx,%eax
  801a11:	48                   	dec    %eax
  801a12:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801a15:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801a18:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1d:	f7 75 bc             	divl   -0x44(%ebp)
  801a20:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801a23:	29 d0                	sub    %edx,%eax
  801a25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  801a28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2b:	89 d0                	mov    %edx,%eax
  801a2d:	01 c0                	add    %eax,%eax
  801a2f:	01 d0                	add    %edx,%eax
  801a31:	c1 e0 02             	shl    $0x2,%eax
  801a34:	05 48 20 81 00       	add    $0x812048,%eax
  801a39:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  801a3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a3f:	89 d0                	mov    %edx,%eax
  801a41:	01 c0                	add    %eax,%eax
  801a43:	01 d0                	add    %edx,%eax
  801a45:	c1 e0 02             	shl    $0x2,%eax
  801a48:	05 44 20 81 00       	add    $0x812044,%eax
  801a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  801a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a56:	89 d0                	mov    %edx,%eax
  801a58:	01 c0                	add    %eax,%eax
  801a5a:	01 d0                	add    %edx,%eax
  801a5c:	c1 e0 02             	shl    $0x2,%eax
  801a5f:	05 40 20 81 00       	add    $0x812040,%eax
  801a64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a6a:	e9 2d 01 00 00       	jmp    801b9c <malloc+0x2da>
    }
    else if (worstIdx != -1)
  801a6f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801a73:	0f 84 ce 00 00 00    	je     801b47 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  801a79:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  801a80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a83:	89 d0                	mov    %edx,%eax
  801a85:	01 c0                	add    %eax,%eax
  801a87:	01 d0                	add    %edx,%eax
  801a89:	c1 e0 02             	shl    $0x2,%eax
  801a8c:	05 40 20 81 00       	add    $0x812040,%eax
  801a91:	8b 10                	mov    (%eax),%edx
  801a93:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801a96:	01 d0                	add    %edx,%eax
  801a98:	48                   	dec    %eax
  801a99:	89 45 c0             	mov    %eax,-0x40(%ebp)
  801a9c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa4:	f7 75 c4             	divl   -0x3c(%ebp)
  801aa7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801aaa:	29 d0                	sub    %edx,%eax
  801aac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  801aaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ab2:	89 d0                	mov    %edx,%eax
  801ab4:	01 c0                	add    %eax,%eax
  801ab6:	01 d0                	add    %edx,%eax
  801ab8:	c1 e0 02             	shl    $0x2,%eax
  801abb:	05 44 20 81 00       	add    $0x812044,%eax
  801ac0:	8b 00                	mov    (%eax),%eax
  801ac2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ac5:	75 47                	jne    801b0e <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  801ac7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aca:	89 d0                	mov    %edx,%eax
  801acc:	01 c0                	add    %eax,%eax
  801ace:	01 d0                	add    %edx,%eax
  801ad0:	c1 e0 02             	shl    $0x2,%eax
  801ad3:	05 48 20 81 00       	add    $0x812048,%eax
  801ad8:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  801adb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ade:	89 d0                	mov    %edx,%eax
  801ae0:	01 c0                	add    %eax,%eax
  801ae2:	01 d0                	add    %edx,%eax
  801ae4:	c1 e0 02             	shl    $0x2,%eax
  801ae7:	05 44 20 81 00       	add    $0x812044,%eax
  801aec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  801af2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af5:	89 d0                	mov    %edx,%eax
  801af7:	01 c0                	add    %eax,%eax
  801af9:	01 d0                	add    %edx,%eax
  801afb:	c1 e0 02             	shl    $0x2,%eax
  801afe:	05 40 20 81 00       	add    $0x812040,%eax
  801b03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b09:	e9 8e 00 00 00       	jmp    801b9c <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  801b0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b14:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801b17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b1a:	89 d0                	mov    %edx,%eax
  801b1c:	01 c0                	add    %eax,%eax
  801b1e:	01 d0                	add    %edx,%eax
  801b20:	c1 e0 02             	shl    $0x2,%eax
  801b23:	05 40 20 81 00       	add    $0x812040,%eax
  801b28:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  801b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b2d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b30:	89 c2                	mov    %eax,%edx
  801b32:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b35:	89 c8                	mov    %ecx,%eax
  801b37:	01 c0                	add    %eax,%eax
  801b39:	01 c8                	add    %ecx,%eax
  801b3b:	c1 e0 02             	shl    $0x2,%eax
  801b3e:	05 44 20 81 00       	add    $0x812044,%eax
  801b43:	89 10                	mov    %edx,(%eax)
  801b45:	eb 55                	jmp    801b9c <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  801b47:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801b4e:	8b 15 88 60 83 00    	mov    0x836088,%edx
  801b54:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b57:	01 d0                	add    %edx,%eax
  801b59:	48                   	dec    %eax
  801b5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801b5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b60:	ba 00 00 00 00       	mov    $0x0,%edx
  801b65:	f7 75 d0             	divl   -0x30(%ebp)
  801b68:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b6b:	29 d0                	sub    %edx,%eax
  801b6d:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  801b70:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801b73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801b7d:	76 0a                	jbe    801b89 <malloc+0x2c7>
            return NULL;
  801b7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b84:	e9 97 00 00 00       	jmp    801c20 <malloc+0x35e>
        va = start;
  801b89:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  801b8f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801b92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b95:	01 d0                	add    %edx,%eax
  801b97:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801b9c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ba3:	eb 5e                	jmp    801c03 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  801ba5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ba8:	89 d0                	mov    %edx,%eax
  801baa:	01 c0                	add    %eax,%eax
  801bac:	01 d0                	add    %edx,%eax
  801bae:	c1 e0 02             	shl    $0x2,%eax
  801bb1:	05 48 60 80 00       	add    $0x806048,%eax
  801bb6:	8a 00                	mov    (%eax),%al
  801bb8:	84 c0                	test   %al,%al
  801bba:	75 44                	jne    801c00 <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  801bbc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bbf:	89 d0                	mov    %edx,%eax
  801bc1:	01 c0                	add    %eax,%eax
  801bc3:	01 d0                	add    %edx,%eax
  801bc5:	c1 e0 02             	shl    $0x2,%eax
  801bc8:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  801bce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd1:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  801bd3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bd6:	89 d0                	mov    %edx,%eax
  801bd8:	01 c0                	add    %eax,%eax
  801bda:	01 d0                	add    %edx,%eax
  801bdc:	c1 e0 02             	shl    $0x2,%eax
  801bdf:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  801be5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801be8:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  801bea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bed:	89 d0                	mov    %edx,%eax
  801bef:	01 c0                	add    %eax,%eax
  801bf1:	01 d0                	add    %edx,%eax
  801bf3:	c1 e0 02             	shl    $0x2,%eax
  801bf6:	05 48 60 80 00       	add    $0x806048,%eax
  801bfb:	c6 00 01             	movb   $0x1,(%eax)
            break;
  801bfe:	eb 0c                	jmp    801c0c <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c00:	ff 45 e0             	incl   -0x20(%ebp)
  801c03:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801c0a:	7e 99                	jle    801ba5 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  801c0c:	83 ec 08             	sub    $0x8,%esp
  801c0f:	ff 75 d4             	pushl  -0x2c(%ebp)
  801c12:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c15:	e8 a2 19 00 00       	call   8035bc <sys_allocate_user_mem>
  801c1a:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  801c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  801c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c2c:	0f 84 fa 03 00 00    	je     80202c <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  801c38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	79 1c                	jns    801c5b <free+0x39>
  801c3f:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  801c46:	77 13                	ja     801c5b <free+0x39>
    {
        free_block(virtual_address);
  801c48:	83 ec 0c             	sub    $0xc,%esp
  801c4b:	ff 75 08             	pushl  0x8(%ebp)
  801c4e:	e8 09 21 00 00       	call   803d5c <free_block>
  801c53:	83 c4 10             	add    $0x10,%esp
        return;
  801c56:	e9 d2 03 00 00       	jmp    80202d <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  801c5b:	a1 30 61 83 00       	mov    0x836130,%eax
  801c60:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  801c63:	72 09                	jb     801c6e <free+0x4c>
  801c65:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  801c6c:	76 17                	jbe    801c85 <free+0x63>
        panic("free: invalid address");
  801c6e:	83 ec 04             	sub    $0x4,%esp
  801c71:	68 4d 4d 80 00       	push   $0x804d4d
  801c76:	68 9b 00 00 00       	push   $0x9b
  801c7b:	68 04 4d 80 00       	push   $0x804d04
  801c80:	e8 36 25 00 00       	call   8041bb <_panic>

    uint32 size = 0;
  801c85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  801c8c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801c93:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801c9a:	eb 50                	jmp    801cec <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  801c9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c9f:	89 d0                	mov    %edx,%eax
  801ca1:	01 c0                	add    %eax,%eax
  801ca3:	01 d0                	add    %edx,%eax
  801ca5:	c1 e0 02             	shl    $0x2,%eax
  801ca8:	05 48 60 80 00       	add    $0x806048,%eax
  801cad:	8a 00                	mov    (%eax),%al
  801caf:	84 c0                	test   %al,%al
  801cb1:	74 36                	je     801ce9 <free+0xc7>
  801cb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cb6:	89 d0                	mov    %edx,%eax
  801cb8:	01 c0                	add    %eax,%eax
  801cba:	01 d0                	add    %edx,%eax
  801cbc:	c1 e0 02             	shl    $0x2,%eax
  801cbf:	05 40 60 80 00       	add    $0x806040,%eax
  801cc4:	8b 00                	mov    (%eax),%eax
  801cc6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801cc9:	75 1e                	jne    801ce9 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  801ccb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cce:	89 d0                	mov    %edx,%eax
  801cd0:	01 c0                	add    %eax,%eax
  801cd2:	01 d0                	add    %edx,%eax
  801cd4:	c1 e0 02             	shl    $0x2,%eax
  801cd7:	05 44 60 80 00       	add    $0x806044,%eax
  801cdc:	8b 00                	mov    (%eax),%eax
  801cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  801ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  801ce7:	eb 0c                	jmp    801cf5 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801ce9:	ff 45 ec             	incl   -0x14(%ebp)
  801cec:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  801cf3:	7e a7                	jle    801c9c <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  801cf5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801cf9:	74 06                	je     801d01 <free+0xdf>
  801cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cff:	75 17                	jne    801d18 <free+0xf6>
        panic("free: unknown block");
  801d01:	83 ec 04             	sub    $0x4,%esp
  801d04:	68 63 4d 80 00       	push   $0x804d63
  801d09:	68 a9 00 00 00       	push   $0xa9
  801d0e:	68 04 4d 80 00       	push   $0x804d04
  801d13:	e8 a3 24 00 00       	call   8041bb <_panic>

    uhp_allocs[idx].used = 0;
  801d18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d1b:	89 d0                	mov    %edx,%eax
  801d1d:	01 c0                	add    %eax,%eax
  801d1f:	01 d0                	add    %edx,%eax
  801d21:	c1 e0 02             	shl    $0x2,%eax
  801d24:	05 48 60 80 00       	add    $0x806048,%eax
  801d29:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  801d2c:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d33:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801d3a:	eb 64                	jmp    801da0 <free+0x17e>
    {
        if (!uhp_frees[i].free)
  801d3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d3f:	89 d0                	mov    %edx,%eax
  801d41:	01 c0                	add    %eax,%eax
  801d43:	01 d0                	add    %edx,%eax
  801d45:	c1 e0 02             	shl    $0x2,%eax
  801d48:	05 48 20 81 00       	add    $0x812048,%eax
  801d4d:	8a 00                	mov    (%eax),%al
  801d4f:	84 c0                	test   %al,%al
  801d51:	75 4a                	jne    801d9d <free+0x17b>
        {
            uhp_frees[i].va = va;
  801d53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d56:	89 d0                	mov    %edx,%eax
  801d58:	01 c0                	add    %eax,%eax
  801d5a:	01 d0                	add    %edx,%eax
  801d5c:	c1 e0 02             	shl    $0x2,%eax
  801d5f:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  801d65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d68:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  801d6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d6d:	89 d0                	mov    %edx,%eax
  801d6f:	01 c0                	add    %eax,%eax
  801d71:	01 d0                	add    %edx,%eax
  801d73:	c1 e0 02             	shl    $0x2,%eax
  801d76:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  801d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7f:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  801d81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d84:	89 d0                	mov    %edx,%eax
  801d86:	01 c0                	add    %eax,%eax
  801d88:	01 d0                	add    %edx,%eax
  801d8a:	c1 e0 02             	shl    $0x2,%eax
  801d8d:	05 48 20 81 00       	add    $0x812048,%eax
  801d92:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  801d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d98:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  801d9b:	eb 0c                	jmp    801da9 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801d9d:	ff 45 e4             	incl   -0x1c(%ebp)
  801da0:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  801da7:	7e 93                	jle    801d3c <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  801da9:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  801dad:	0f 84 f1 01 00 00    	je     801fa4 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801db3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801dba:	e9 d8 01 00 00       	jmp    801f97 <free+0x375>
        {
            if (i == fidx) continue;
  801dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801dc5:	0f 84 c8 01 00 00    	je     801f93 <free+0x371>
            if (uhp_frees[i].free)
  801dcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dce:	89 d0                	mov    %edx,%eax
  801dd0:	01 c0                	add    %eax,%eax
  801dd2:	01 d0                	add    %edx,%eax
  801dd4:	c1 e0 02             	shl    $0x2,%eax
  801dd7:	05 48 20 81 00       	add    $0x812048,%eax
  801ddc:	8a 00                	mov    (%eax),%al
  801dde:	84 c0                	test   %al,%al
  801de0:	0f 84 ae 01 00 00    	je     801f94 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  801de6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801de9:	89 d0                	mov    %edx,%eax
  801deb:	01 c0                	add    %eax,%eax
  801ded:	01 d0                	add    %edx,%eax
  801def:	c1 e0 02             	shl    $0x2,%eax
  801df2:	05 40 20 81 00       	add    $0x812040,%eax
  801df7:	8b 08                	mov    (%eax),%ecx
  801df9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dfc:	89 d0                	mov    %edx,%eax
  801dfe:	01 c0                	add    %eax,%eax
  801e00:	01 d0                	add    %edx,%eax
  801e02:	c1 e0 02             	shl    $0x2,%eax
  801e05:	05 44 20 81 00       	add    $0x812044,%eax
  801e0a:	8b 00                	mov    (%eax),%eax
  801e0c:	01 c1                	add    %eax,%ecx
  801e0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e11:	89 d0                	mov    %edx,%eax
  801e13:	01 c0                	add    %eax,%eax
  801e15:	01 d0                	add    %edx,%eax
  801e17:	c1 e0 02             	shl    $0x2,%eax
  801e1a:	05 40 20 81 00       	add    $0x812040,%eax
  801e1f:	8b 00                	mov    (%eax),%eax
  801e21:	39 c1                	cmp    %eax,%ecx
  801e23:	0f 85 a8 00 00 00    	jne    801ed1 <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  801e29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e2c:	89 d0                	mov    %edx,%eax
  801e2e:	01 c0                	add    %eax,%eax
  801e30:	01 d0                	add    %edx,%eax
  801e32:	c1 e0 02             	shl    $0x2,%eax
  801e35:	05 40 20 81 00       	add    $0x812040,%eax
  801e3a:	8b 10                	mov    (%eax),%edx
  801e3c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801e3f:	89 c8                	mov    %ecx,%eax
  801e41:	01 c0                	add    %eax,%eax
  801e43:	01 c8                	add    %ecx,%eax
  801e45:	c1 e0 02             	shl    $0x2,%eax
  801e48:	05 40 20 81 00       	add    $0x812040,%eax
  801e4d:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801e4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e52:	89 d0                	mov    %edx,%eax
  801e54:	01 c0                	add    %eax,%eax
  801e56:	01 d0                	add    %edx,%eax
  801e58:	c1 e0 02             	shl    $0x2,%eax
  801e5b:	05 44 20 81 00       	add    $0x812044,%eax
  801e60:	8b 08                	mov    (%eax),%ecx
  801e62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e65:	89 d0                	mov    %edx,%eax
  801e67:	01 c0                	add    %eax,%eax
  801e69:	01 d0                	add    %edx,%eax
  801e6b:	c1 e0 02             	shl    $0x2,%eax
  801e6e:	05 44 20 81 00       	add    $0x812044,%eax
  801e73:	8b 00                	mov    (%eax),%eax
  801e75:	01 c1                	add    %eax,%ecx
  801e77:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e7a:	89 d0                	mov    %edx,%eax
  801e7c:	01 c0                	add    %eax,%eax
  801e7e:	01 d0                	add    %edx,%eax
  801e80:	c1 e0 02             	shl    $0x2,%eax
  801e83:	05 44 20 81 00       	add    $0x812044,%eax
  801e88:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801e8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e8d:	89 d0                	mov    %edx,%eax
  801e8f:	01 c0                	add    %eax,%eax
  801e91:	01 d0                	add    %edx,%eax
  801e93:	c1 e0 02             	shl    $0x2,%eax
  801e96:	05 48 20 81 00       	add    $0x812048,%eax
  801e9b:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801e9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ea1:	89 d0                	mov    %edx,%eax
  801ea3:	01 c0                	add    %eax,%eax
  801ea5:	01 d0                	add    %edx,%eax
  801ea7:	c1 e0 02             	shl    $0x2,%eax
  801eaa:	05 40 20 81 00       	add    $0x812040,%eax
  801eaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801eb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eb8:	89 d0                	mov    %edx,%eax
  801eba:	01 c0                	add    %eax,%eax
  801ebc:	01 d0                	add    %edx,%eax
  801ebe:	c1 e0 02             	shl    $0x2,%eax
  801ec1:	05 44 20 81 00       	add    $0x812044,%eax
  801ec6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ecc:	e9 c3 00 00 00       	jmp    801f94 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  801ed1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ed4:	89 d0                	mov    %edx,%eax
  801ed6:	01 c0                	add    %eax,%eax
  801ed8:	01 d0                	add    %edx,%eax
  801eda:	c1 e0 02             	shl    $0x2,%eax
  801edd:	05 40 20 81 00       	add    $0x812040,%eax
  801ee2:	8b 08                	mov    (%eax),%ecx
  801ee4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ee7:	89 d0                	mov    %edx,%eax
  801ee9:	01 c0                	add    %eax,%eax
  801eeb:	01 d0                	add    %edx,%eax
  801eed:	c1 e0 02             	shl    $0x2,%eax
  801ef0:	05 44 20 81 00       	add    $0x812044,%eax
  801ef5:	8b 00                	mov    (%eax),%eax
  801ef7:	01 c1                	add    %eax,%ecx
  801ef9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801efc:	89 d0                	mov    %edx,%eax
  801efe:	01 c0                	add    %eax,%eax
  801f00:	01 d0                	add    %edx,%eax
  801f02:	c1 e0 02             	shl    $0x2,%eax
  801f05:	05 40 20 81 00       	add    $0x812040,%eax
  801f0a:	8b 00                	mov    (%eax),%eax
  801f0c:	39 c1                	cmp    %eax,%ecx
  801f0e:	0f 85 80 00 00 00    	jne    801f94 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  801f14:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f17:	89 d0                	mov    %edx,%eax
  801f19:	01 c0                	add    %eax,%eax
  801f1b:	01 d0                	add    %edx,%eax
  801f1d:	c1 e0 02             	shl    $0x2,%eax
  801f20:	05 44 20 81 00       	add    $0x812044,%eax
  801f25:	8b 08                	mov    (%eax),%ecx
  801f27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f2a:	89 d0                	mov    %edx,%eax
  801f2c:	01 c0                	add    %eax,%eax
  801f2e:	01 d0                	add    %edx,%eax
  801f30:	c1 e0 02             	shl    $0x2,%eax
  801f33:	05 44 20 81 00       	add    $0x812044,%eax
  801f38:	8b 00                	mov    (%eax),%eax
  801f3a:	01 c1                	add    %eax,%ecx
  801f3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f3f:	89 d0                	mov    %edx,%eax
  801f41:	01 c0                	add    %eax,%eax
  801f43:	01 d0                	add    %edx,%eax
  801f45:	c1 e0 02             	shl    $0x2,%eax
  801f48:	05 44 20 81 00       	add    $0x812044,%eax
  801f4d:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  801f4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f52:	89 d0                	mov    %edx,%eax
  801f54:	01 c0                	add    %eax,%eax
  801f56:	01 d0                	add    %edx,%eax
  801f58:	c1 e0 02             	shl    $0x2,%eax
  801f5b:	05 48 20 81 00       	add    $0x812048,%eax
  801f60:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  801f63:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f66:	89 d0                	mov    %edx,%eax
  801f68:	01 c0                	add    %eax,%eax
  801f6a:	01 d0                	add    %edx,%eax
  801f6c:	c1 e0 02             	shl    $0x2,%eax
  801f6f:	05 40 20 81 00       	add    $0x812040,%eax
  801f74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  801f7a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f7d:	89 d0                	mov    %edx,%eax
  801f7f:	01 c0                	add    %eax,%eax
  801f81:	01 d0                	add    %edx,%eax
  801f83:	c1 e0 02             	shl    $0x2,%eax
  801f86:	05 44 20 81 00       	add    $0x812044,%eax
  801f8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f91:	eb 01                	jmp    801f94 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  801f93:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  801f94:	ff 45 e0             	incl   -0x20(%ebp)
  801f97:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  801f9e:	0f 8e 1b fe ff ff    	jle    801dbf <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  801fa4:	a1 30 61 83 00       	mov    0x836130,%eax
  801fa9:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  801fac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801fb3:	eb 53                	jmp    802008 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  801fb5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fb8:	89 d0                	mov    %edx,%eax
  801fba:	01 c0                	add    %eax,%eax
  801fbc:	01 d0                	add    %edx,%eax
  801fbe:	c1 e0 02             	shl    $0x2,%eax
  801fc1:	05 48 60 80 00       	add    $0x806048,%eax
  801fc6:	8a 00                	mov    (%eax),%al
  801fc8:	84 c0                	test   %al,%al
  801fca:	74 39                	je     802005 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  801fcc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fcf:	89 d0                	mov    %edx,%eax
  801fd1:	01 c0                	add    %eax,%eax
  801fd3:	01 d0                	add    %edx,%eax
  801fd5:	c1 e0 02             	shl    $0x2,%eax
  801fd8:	05 40 60 80 00       	add    $0x806040,%eax
  801fdd:	8b 08                	mov    (%eax),%ecx
  801fdf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fe2:	89 d0                	mov    %edx,%eax
  801fe4:	01 c0                	add    %eax,%eax
  801fe6:	01 d0                	add    %edx,%eax
  801fe8:	c1 e0 02             	shl    $0x2,%eax
  801feb:	05 44 60 80 00       	add    $0x806044,%eax
  801ff0:	8b 00                	mov    (%eax),%eax
  801ff2:	01 c8                	add    %ecx,%eax
  801ff4:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  801ff7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ffa:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801ffd:	76 06                	jbe    802005 <free+0x3e3>
  801fff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802002:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802005:	ff 45 d8             	incl   -0x28(%ebp)
  802008:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80200f:	7e a4                	jle    801fb5 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  802011:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802014:	a3 88 60 83 00       	mov    %eax,0x836088

    sys_free_user_mem(va, size);
  802019:	83 ec 08             	sub    $0x8,%esp
  80201c:	ff 75 f4             	pushl  -0xc(%ebp)
  80201f:	ff 75 d4             	pushl  -0x2c(%ebp)
  802022:	e8 79 15 00 00       	call   8035a0 <sys_free_user_mem>
  802027:	83 c4 10             	add    $0x10,%esp
  80202a:	eb 01                	jmp    80202d <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  80202c:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 68             	sub    $0x68,%esp
  802035:	8b 45 10             	mov    0x10(%ebp),%eax
  802038:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80203b:	e8 a5 f7 ff ff       	call   8017e5 <uheap_init>
	if (size == 0) return NULL ;
  802040:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802044:	75 0a                	jne    802050 <smalloc+0x21>
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
  80204b:	e9 37 03 00 00       	jmp    802387 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  802050:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802057:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80205d:	01 d0                	add    %edx,%eax
  80205f:	48                   	dec    %eax
  802060:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802063:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802066:	ba 00 00 00 00       	mov    $0x0,%edx
  80206b:	f7 75 dc             	divl   -0x24(%ebp)
  80206e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802071:	29 d0                	sub    %edx,%eax
  802073:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802076:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  80207d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802084:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  80208b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802092:	e9 85 00 00 00       	jmp    80211c <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802097:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80209a:	89 d0                	mov    %edx,%eax
  80209c:	01 c0                	add    %eax,%eax
  80209e:	01 d0                	add    %edx,%eax
  8020a0:	c1 e0 02             	shl    $0x2,%eax
  8020a3:	05 48 20 81 00       	add    $0x812048,%eax
  8020a8:	8a 00                	mov    (%eax),%al
  8020aa:	84 c0                	test   %al,%al
  8020ac:	74 20                	je     8020ce <smalloc+0x9f>
  8020ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020b1:	89 d0                	mov    %edx,%eax
  8020b3:	01 c0                	add    %eax,%eax
  8020b5:	01 d0                	add    %edx,%eax
  8020b7:	c1 e0 02             	shl    $0x2,%eax
  8020ba:	05 44 20 81 00       	add    $0x812044,%eax
  8020bf:	8b 00                	mov    (%eax),%eax
  8020c1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8020c4:	75 08                	jne    8020ce <smalloc+0x9f>
        {
            exactIdx = i;
  8020c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8020cc:	eb 5b                	jmp    802129 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8020ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020d1:	89 d0                	mov    %edx,%eax
  8020d3:	01 c0                	add    %eax,%eax
  8020d5:	01 d0                	add    %edx,%eax
  8020d7:	c1 e0 02             	shl    $0x2,%eax
  8020da:	05 48 20 81 00       	add    $0x812048,%eax
  8020df:	8a 00                	mov    (%eax),%al
  8020e1:	84 c0                	test   %al,%al
  8020e3:	74 34                	je     802119 <smalloc+0xea>
  8020e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8020e8:	89 d0                	mov    %edx,%eax
  8020ea:	01 c0                	add    %eax,%eax
  8020ec:	01 d0                	add    %edx,%eax
  8020ee:	c1 e0 02             	shl    $0x2,%eax
  8020f1:	05 44 20 81 00       	add    $0x812044,%eax
  8020f6:	8b 00                	mov    (%eax),%eax
  8020f8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020fb:	76 1c                	jbe    802119 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  8020fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802100:	89 d0                	mov    %edx,%eax
  802102:	01 c0                	add    %eax,%eax
  802104:	01 d0                	add    %edx,%eax
  802106:	c1 e0 02             	shl    $0x2,%eax
  802109:	05 44 20 81 00       	add    $0x812044,%eax
  80210e:	8b 00                	mov    (%eax),%eax
  802110:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802116:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802119:	ff 45 e8             	incl   -0x18(%ebp)
  80211c:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802123:	0f 8e 6e ff ff ff    	jle    802097 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802129:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802130:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802134:	74 7d                	je     8021b3 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802136:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80213d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802140:	89 d0                	mov    %edx,%eax
  802142:	01 c0                	add    %eax,%eax
  802144:	01 d0                	add    %edx,%eax
  802146:	c1 e0 02             	shl    $0x2,%eax
  802149:	05 40 20 81 00       	add    $0x812040,%eax
  80214e:	8b 10                	mov    (%eax),%edx
  802150:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802153:	01 d0                	add    %edx,%eax
  802155:	48                   	dec    %eax
  802156:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802159:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80215c:	ba 00 00 00 00       	mov    $0x0,%edx
  802161:	f7 75 bc             	divl   -0x44(%ebp)
  802164:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802167:	29 d0                	sub    %edx,%eax
  802169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  80216c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216f:	89 d0                	mov    %edx,%eax
  802171:	01 c0                	add    %eax,%eax
  802173:	01 d0                	add    %edx,%eax
  802175:	c1 e0 02             	shl    $0x2,%eax
  802178:	05 48 20 81 00       	add    $0x812048,%eax
  80217d:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802183:	89 d0                	mov    %edx,%eax
  802185:	01 c0                	add    %eax,%eax
  802187:	01 d0                	add    %edx,%eax
  802189:	c1 e0 02             	shl    $0x2,%eax
  80218c:	05 44 20 81 00       	add    $0x812044,%eax
  802191:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802197:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219a:	89 d0                	mov    %edx,%eax
  80219c:	01 c0                	add    %eax,%eax
  80219e:	01 d0                	add    %edx,%eax
  8021a0:	c1 e0 02             	shl    $0x2,%eax
  8021a3:	05 40 20 81 00       	add    $0x812040,%eax
  8021a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ae:	e9 2d 01 00 00       	jmp    8022e0 <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  8021b3:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021b7:	0f 84 ce 00 00 00    	je     80228b <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8021bd:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8021c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c7:	89 d0                	mov    %edx,%eax
  8021c9:	01 c0                	add    %eax,%eax
  8021cb:	01 d0                	add    %edx,%eax
  8021cd:	c1 e0 02             	shl    $0x2,%eax
  8021d0:	05 40 20 81 00       	add    $0x812040,%eax
  8021d5:	8b 10                	mov    (%eax),%edx
  8021d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8021da:	01 d0                	add    %edx,%eax
  8021dc:	48                   	dec    %eax
  8021dd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8021e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e8:	f7 75 c4             	divl   -0x3c(%ebp)
  8021eb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8021ee:	29 d0                	sub    %edx,%eax
  8021f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8021f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021f6:	89 d0                	mov    %edx,%eax
  8021f8:	01 c0                	add    %eax,%eax
  8021fa:	01 d0                	add    %edx,%eax
  8021fc:	c1 e0 02             	shl    $0x2,%eax
  8021ff:	05 44 20 81 00       	add    $0x812044,%eax
  802204:	8b 00                	mov    (%eax),%eax
  802206:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802209:	75 47                	jne    802252 <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  80220b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80220e:	89 d0                	mov    %edx,%eax
  802210:	01 c0                	add    %eax,%eax
  802212:	01 d0                	add    %edx,%eax
  802214:	c1 e0 02             	shl    $0x2,%eax
  802217:	05 48 20 81 00       	add    $0x812048,%eax
  80221c:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  80221f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802222:	89 d0                	mov    %edx,%eax
  802224:	01 c0                	add    %eax,%eax
  802226:	01 d0                	add    %edx,%eax
  802228:	c1 e0 02             	shl    $0x2,%eax
  80222b:	05 44 20 81 00       	add    $0x812044,%eax
  802230:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802236:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802239:	89 d0                	mov    %edx,%eax
  80223b:	01 c0                	add    %eax,%eax
  80223d:	01 d0                	add    %edx,%eax
  80223f:	c1 e0 02             	shl    $0x2,%eax
  802242:	05 40 20 81 00       	add    $0x812040,%eax
  802247:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80224d:	e9 8e 00 00 00       	jmp    8022e0 <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802252:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802255:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802258:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80225b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80225e:	89 d0                	mov    %edx,%eax
  802260:	01 c0                	add    %eax,%eax
  802262:	01 d0                	add    %edx,%eax
  802264:	c1 e0 02             	shl    $0x2,%eax
  802267:	05 40 20 81 00       	add    $0x812040,%eax
  80226c:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  80226e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802271:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802274:	89 c2                	mov    %eax,%edx
  802276:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802279:	89 c8                	mov    %ecx,%eax
  80227b:	01 c0                	add    %eax,%eax
  80227d:	01 c8                	add    %ecx,%eax
  80227f:	c1 e0 02             	shl    $0x2,%eax
  802282:	05 44 20 81 00       	add    $0x812044,%eax
  802287:	89 10                	mov    %edx,(%eax)
  802289:	eb 55                	jmp    8022e0 <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  80228b:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802292:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802298:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80229b:	01 d0                	add    %edx,%eax
  80229d:	48                   	dec    %eax
  80229e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8022a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8022a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a9:	f7 75 d0             	divl   -0x30(%ebp)
  8022ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8022af:	29 d0                	sub    %edx,%eax
  8022b1:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8022b4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8022b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022ba:	01 d0                	add    %edx,%eax
  8022bc:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8022c1:	76 0a                	jbe    8022cd <smalloc+0x29e>
            return NULL;
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c8:	e9 ba 00 00 00       	jmp    802387 <smalloc+0x358>
        va = start;
  8022cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8022d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8022d3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8022d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8022e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8022e7:	eb 5e                	jmp    802347 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  8022e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022ec:	89 d0                	mov    %edx,%eax
  8022ee:	01 c0                	add    %eax,%eax
  8022f0:	01 d0                	add    %edx,%eax
  8022f2:	c1 e0 02             	shl    $0x2,%eax
  8022f5:	05 48 60 80 00       	add    $0x806048,%eax
  8022fa:	8a 00                	mov    (%eax),%al
  8022fc:	84 c0                	test   %al,%al
  8022fe:	75 44                	jne    802344 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  802300:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802303:	89 d0                	mov    %edx,%eax
  802305:	01 c0                	add    %eax,%eax
  802307:	01 d0                	add    %edx,%eax
  802309:	c1 e0 02             	shl    $0x2,%eax
  80230c:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  802312:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802315:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802317:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80231a:	89 d0                	mov    %edx,%eax
  80231c:	01 c0                	add    %eax,%eax
  80231e:	01 d0                	add    %edx,%eax
  802320:	c1 e0 02             	shl    $0x2,%eax
  802323:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802329:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80232c:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80232e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802331:	89 d0                	mov    %edx,%eax
  802333:	01 c0                	add    %eax,%eax
  802335:	01 d0                	add    %edx,%eax
  802337:	c1 e0 02             	shl    $0x2,%eax
  80233a:	05 48 60 80 00       	add    $0x806048,%eax
  80233f:	c6 00 01             	movb   $0x1,(%eax)
            break;
  802342:	eb 0c                	jmp    802350 <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802344:	ff 45 e0             	incl   -0x20(%ebp)
  802347:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80234e:	7e 99                	jle    8022e9 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  802350:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802353:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  802357:	52                   	push   %edx
  802358:	50                   	push   %eax
  802359:	ff 75 d4             	pushl  -0x2c(%ebp)
  80235c:	ff 75 08             	pushl  0x8(%ebp)
  80235f:	e8 de 0e 00 00       	call   803242 <sys_create_shared_object>
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  80236a:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  80236e:	75 07                	jne    802377 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  802370:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802375:	eb 10                	jmp    802387 <smalloc+0x358>
    if (r < 0)
  802377:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80237b:	79 07                	jns    802384 <smalloc+0x355>
        return NULL;
  80237d:	b8 00 00 00 00       	mov    $0x0,%eax
  802382:	eb 03                	jmp    802387 <smalloc+0x358>
    return (void*)va;
  802384:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80238f:	e8 51 f4 ff ff       	call   8017e5 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  802394:	83 ec 08             	sub    $0x8,%esp
  802397:	ff 75 0c             	pushl  0xc(%ebp)
  80239a:	ff 75 08             	pushl  0x8(%ebp)
  80239d:	e8 ca 0e 00 00       	call   80326c <sys_size_of_shared_object>
  8023a2:	83 c4 10             	add    $0x10,%esp
  8023a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8023a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8023ac:	7f 0a                	jg     8023b8 <sget+0x2f>
        return NULL;
  8023ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b3:	e9 28 03 00 00       	jmp    8026e0 <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  8023b8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8023bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023c5:	01 d0                	add    %edx,%eax
  8023c7:	48                   	dec    %eax
  8023c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8023cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8023d3:	f7 75 d8             	divl   -0x28(%ebp)
  8023d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023d9:	29 d0                	sub    %edx,%eax
  8023db:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  8023de:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  8023e5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  8023ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8023f3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8023fa:	e9 85 00 00 00       	jmp    802484 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8023ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802402:	89 d0                	mov    %edx,%eax
  802404:	01 c0                	add    %eax,%eax
  802406:	01 d0                	add    %edx,%eax
  802408:	c1 e0 02             	shl    $0x2,%eax
  80240b:	05 48 20 81 00       	add    $0x812048,%eax
  802410:	8a 00                	mov    (%eax),%al
  802412:	84 c0                	test   %al,%al
  802414:	74 20                	je     802436 <sget+0xad>
  802416:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802419:	89 d0                	mov    %edx,%eax
  80241b:	01 c0                	add    %eax,%eax
  80241d:	01 d0                	add    %edx,%eax
  80241f:	c1 e0 02             	shl    $0x2,%eax
  802422:	05 44 20 81 00       	add    $0x812044,%eax
  802427:	8b 00                	mov    (%eax),%eax
  802429:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80242c:	75 08                	jne    802436 <sget+0xad>
        {
            exactIdx = i;
  80242e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802431:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802434:	eb 5b                	jmp    802491 <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802436:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802439:	89 d0                	mov    %edx,%eax
  80243b:	01 c0                	add    %eax,%eax
  80243d:	01 d0                	add    %edx,%eax
  80243f:	c1 e0 02             	shl    $0x2,%eax
  802442:	05 48 20 81 00       	add    $0x812048,%eax
  802447:	8a 00                	mov    (%eax),%al
  802449:	84 c0                	test   %al,%al
  80244b:	74 34                	je     802481 <sget+0xf8>
  80244d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802450:	89 d0                	mov    %edx,%eax
  802452:	01 c0                	add    %eax,%eax
  802454:	01 d0                	add    %edx,%eax
  802456:	c1 e0 02             	shl    $0x2,%eax
  802459:	05 44 20 81 00       	add    $0x812044,%eax
  80245e:	8b 00                	mov    (%eax),%eax
  802460:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802463:	76 1c                	jbe    802481 <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  802465:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802468:	89 d0                	mov    %edx,%eax
  80246a:	01 c0                	add    %eax,%eax
  80246c:	01 d0                	add    %edx,%eax
  80246e:	c1 e0 02             	shl    $0x2,%eax
  802471:	05 44 20 81 00       	add    $0x812044,%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80247b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80247e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802481:	ff 45 e8             	incl   -0x18(%ebp)
  802484:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80248b:	0f 8e 6e ff ff ff    	jle    8023ff <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802491:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802498:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80249c:	74 7d                	je     80251b <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80249e:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8024a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a8:	89 d0                	mov    %edx,%eax
  8024aa:	01 c0                	add    %eax,%eax
  8024ac:	01 d0                	add    %edx,%eax
  8024ae:	c1 e0 02             	shl    $0x2,%eax
  8024b1:	05 40 20 81 00       	add    $0x812040,%eax
  8024b6:	8b 10                	mov    (%eax),%edx
  8024b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8024bb:	01 d0                	add    %edx,%eax
  8024bd:	48                   	dec    %eax
  8024be:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8024c1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8024c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024c9:	f7 75 b8             	divl   -0x48(%ebp)
  8024cc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8024cf:	29 d0                	sub    %edx,%eax
  8024d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  8024d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d7:	89 d0                	mov    %edx,%eax
  8024d9:	01 c0                	add    %eax,%eax
  8024db:	01 d0                	add    %edx,%eax
  8024dd:	c1 e0 02             	shl    $0x2,%eax
  8024e0:	05 48 20 81 00       	add    $0x812048,%eax
  8024e5:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  8024e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024eb:	89 d0                	mov    %edx,%eax
  8024ed:	01 c0                	add    %eax,%eax
  8024ef:	01 d0                	add    %edx,%eax
  8024f1:	c1 e0 02             	shl    $0x2,%eax
  8024f4:	05 44 20 81 00       	add    $0x812044,%eax
  8024f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8024ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802502:	89 d0                	mov    %edx,%eax
  802504:	01 c0                	add    %eax,%eax
  802506:	01 d0                	add    %edx,%eax
  802508:	c1 e0 02             	shl    $0x2,%eax
  80250b:	05 40 20 81 00       	add    $0x812040,%eax
  802510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802516:	e9 2d 01 00 00       	jmp    802648 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  80251b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80251f:	0f 84 ce 00 00 00    	je     8025f3 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802525:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80252c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252f:	89 d0                	mov    %edx,%eax
  802531:	01 c0                	add    %eax,%eax
  802533:	01 d0                	add    %edx,%eax
  802535:	c1 e0 02             	shl    $0x2,%eax
  802538:	05 40 20 81 00       	add    $0x812040,%eax
  80253d:	8b 10                	mov    (%eax),%edx
  80253f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802542:	01 d0                	add    %edx,%eax
  802544:	48                   	dec    %eax
  802545:	89 45 bc             	mov    %eax,-0x44(%ebp)
  802548:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80254b:	ba 00 00 00 00       	mov    $0x0,%edx
  802550:	f7 75 c0             	divl   -0x40(%ebp)
  802553:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802556:	29 d0                	sub    %edx,%eax
  802558:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  80255b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255e:	89 d0                	mov    %edx,%eax
  802560:	01 c0                	add    %eax,%eax
  802562:	01 d0                	add    %edx,%eax
  802564:	c1 e0 02             	shl    $0x2,%eax
  802567:	05 44 20 81 00       	add    $0x812044,%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802571:	75 47                	jne    8025ba <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  802573:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802576:	89 d0                	mov    %edx,%eax
  802578:	01 c0                	add    %eax,%eax
  80257a:	01 d0                	add    %edx,%eax
  80257c:	c1 e0 02             	shl    $0x2,%eax
  80257f:	05 48 20 81 00       	add    $0x812048,%eax
  802584:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802587:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80258a:	89 d0                	mov    %edx,%eax
  80258c:	01 c0                	add    %eax,%eax
  80258e:	01 d0                	add    %edx,%eax
  802590:	c1 e0 02             	shl    $0x2,%eax
  802593:	05 44 20 81 00       	add    $0x812044,%eax
  802598:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80259e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a1:	89 d0                	mov    %edx,%eax
  8025a3:	01 c0                	add    %eax,%eax
  8025a5:	01 d0                	add    %edx,%eax
  8025a7:	c1 e0 02             	shl    $0x2,%eax
  8025aa:	05 40 20 81 00       	add    $0x812040,%eax
  8025af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b5:	e9 8e 00 00 00       	jmp    802648 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  8025ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025c0:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8025c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c6:	89 d0                	mov    %edx,%eax
  8025c8:	01 c0                	add    %eax,%eax
  8025ca:	01 d0                	add    %edx,%eax
  8025cc:	c1 e0 02             	shl    $0x2,%eax
  8025cf:	05 40 20 81 00       	add    $0x812040,%eax
  8025d4:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  8025d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d9:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8025dc:	89 c2                	mov    %eax,%edx
  8025de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025e1:	89 c8                	mov    %ecx,%eax
  8025e3:	01 c0                	add    %eax,%eax
  8025e5:	01 c8                	add    %ecx,%eax
  8025e7:	c1 e0 02             	shl    $0x2,%eax
  8025ea:	05 44 20 81 00       	add    $0x812044,%eax
  8025ef:	89 10                	mov    %edx,(%eax)
  8025f1:	eb 55                	jmp    802648 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  8025f3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025fa:	8b 15 88 60 83 00    	mov    0x836088,%edx
  802600:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802603:	01 d0                	add    %edx,%eax
  802605:	48                   	dec    %eax
  802606:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802609:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80260c:	ba 00 00 00 00       	mov    $0x0,%edx
  802611:	f7 75 cc             	divl   -0x34(%ebp)
  802614:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802617:	29 d0                	sub    %edx,%eax
  802619:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  80261c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80261f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802622:	01 d0                	add    %edx,%eax
  802624:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  802629:	76 0a                	jbe    802635 <sget+0x2ac>
            return NULL;
  80262b:	b8 00 00 00 00       	mov    $0x0,%eax
  802630:	e9 ab 00 00 00       	jmp    8026e0 <sget+0x357>
        va = start;
  802635:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802638:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  80263b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80263e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802641:	01 d0                	add    %edx,%eax
  802643:	a3 88 60 83 00       	mov    %eax,0x836088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802648:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80264f:	eb 5e                	jmp    8026af <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  802651:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802654:	89 d0                	mov    %edx,%eax
  802656:	01 c0                	add    %eax,%eax
  802658:	01 d0                	add    %edx,%eax
  80265a:	c1 e0 02             	shl    $0x2,%eax
  80265d:	05 48 60 80 00       	add    $0x806048,%eax
  802662:	8a 00                	mov    (%eax),%al
  802664:	84 c0                	test   %al,%al
  802666:	75 44                	jne    8026ac <sget+0x323>
        {
            uhp_allocs[i].va = va;
  802668:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80266b:	89 d0                	mov    %edx,%eax
  80266d:	01 c0                	add    %eax,%eax
  80266f:	01 d0                	add    %edx,%eax
  802671:	c1 e0 02             	shl    $0x2,%eax
  802674:	8d 90 40 60 80 00    	lea    0x806040(%eax),%edx
  80267a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267d:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  80267f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802682:	89 d0                	mov    %edx,%eax
  802684:	01 c0                	add    %eax,%eax
  802686:	01 d0                	add    %edx,%eax
  802688:	c1 e0 02             	shl    $0x2,%eax
  80268b:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802691:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802694:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802696:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802699:	89 d0                	mov    %edx,%eax
  80269b:	01 c0                	add    %eax,%eax
  80269d:	01 d0                	add    %edx,%eax
  80269f:	c1 e0 02             	shl    $0x2,%eax
  8026a2:	05 48 60 80 00       	add    $0x806048,%eax
  8026a7:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8026aa:	eb 0c                	jmp    8026b8 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8026ac:	ff 45 e0             	incl   -0x20(%ebp)
  8026af:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  8026b6:	7e 99                	jle    802651 <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  8026b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bb:	83 ec 04             	sub    $0x4,%esp
  8026be:	50                   	push   %eax
  8026bf:	ff 75 0c             	pushl  0xc(%ebp)
  8026c2:	ff 75 08             	pushl  0x8(%ebp)
  8026c5:	e8 bf 0b 00 00       	call   803289 <sys_get_shared_object>
  8026ca:	83 c4 10             	add    $0x10,%esp
  8026cd:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  8026d0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026d4:	79 07                	jns    8026dd <sget+0x354>
        return NULL;
  8026d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026db:	eb 03                	jmp    8026e0 <sget+0x357>
    return (void*)va;
  8026dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8026e8:	e8 f8 f0 ff ff       	call   8017e5 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  8026ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026f1:	75 13                	jne    802706 <realloc+0x24>
		return malloc(new_size);
  8026f3:	83 ec 0c             	sub    $0xc,%esp
  8026f6:	ff 75 0c             	pushl  0xc(%ebp)
  8026f9:	e8 c4 f1 ff ff       	call   8018c2 <malloc>
  8026fe:	83 c4 10             	add    $0x10,%esp
  802701:	e9 f4 05 00 00       	jmp    802cfa <realloc+0x618>
	if (new_size == 0)
  802706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80270a:	75 18                	jne    802724 <realloc+0x42>
	{
		free(virtual_address);
  80270c:	83 ec 0c             	sub    $0xc,%esp
  80270f:	ff 75 08             	pushl  0x8(%ebp)
  802712:	e8 0b f5 ff ff       	call   801c22 <free>
  802717:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80271a:	b8 00 00 00 00       	mov    $0x0,%eax
  80271f:	e9 d6 05 00 00       	jmp    802cfa <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  80272a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	79 74                	jns    8027a5 <realloc+0xc3>
  802731:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  802738:	77 6b                	ja     8027a5 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  80273a:	83 ec 0c             	sub    $0xc,%esp
  80273d:	ff 75 0c             	pushl  0xc(%ebp)
  802740:	e8 7d f1 ff ff       	call   8018c2 <malloc>
  802745:	83 c4 10             	add    $0x10,%esp
  802748:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  80274b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80274f:	75 0a                	jne    80275b <realloc+0x79>
			return NULL;
  802751:	b8 00 00 00 00       	mov    $0x0,%eax
  802756:	e9 9f 05 00 00       	jmp    802cfa <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  80275b:	83 ec 0c             	sub    $0xc,%esp
  80275e:	ff 75 08             	pushl  0x8(%ebp)
  802761:	e8 e0 11 00 00       	call   803946 <get_block_size>
  802766:	83 c4 10             	add    $0x10,%esp
  802769:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  80276c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80276f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802772:	39 d0                	cmp    %edx,%eax
  802774:	76 02                	jbe    802778 <realloc+0x96>
  802776:	89 d0                	mov    %edx,%eax
  802778:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  80277b:	83 ec 04             	sub    $0x4,%esp
  80277e:	ff 75 c0             	pushl  -0x40(%ebp)
  802781:	ff 75 08             	pushl  0x8(%ebp)
  802784:	ff 75 c8             	pushl  -0x38(%ebp)
  802787:	e8 56 eb ff ff       	call   8012e2 <memmove>
  80278c:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  80278f:	83 ec 0c             	sub    $0xc,%esp
  802792:	ff 75 08             	pushl  0x8(%ebp)
  802795:	e8 88 f4 ff ff       	call   801c22 <free>
  80279a:	83 c4 10             	add    $0x10,%esp
		return newptr;
  80279d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027a0:	e9 55 05 00 00       	jmp    802cfa <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8027a5:	a1 30 61 83 00       	mov    0x836130,%eax
  8027aa:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8027ad:	72 09                	jb     8027b8 <realloc+0xd6>
  8027af:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  8027b6:	76 0a                	jbe    8027c2 <realloc+0xe0>
		return NULL;
  8027b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bd:	e9 38 05 00 00       	jmp    802cfa <realloc+0x618>
	uint32 oldsz = 0;
  8027c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  8027c9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8027d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8027d7:	eb 50                	jmp    802829 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8027d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027dc:	89 d0                	mov    %edx,%eax
  8027de:	01 c0                	add    %eax,%eax
  8027e0:	01 d0                	add    %edx,%eax
  8027e2:	c1 e0 02             	shl    $0x2,%eax
  8027e5:	05 48 60 80 00       	add    $0x806048,%eax
  8027ea:	8a 00                	mov    (%eax),%al
  8027ec:	84 c0                	test   %al,%al
  8027ee:	74 36                	je     802826 <realloc+0x144>
  8027f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027f3:	89 d0                	mov    %edx,%eax
  8027f5:	01 c0                	add    %eax,%eax
  8027f7:	01 d0                	add    %edx,%eax
  8027f9:	c1 e0 02             	shl    $0x2,%eax
  8027fc:	05 40 60 80 00       	add    $0x806040,%eax
  802801:	8b 00                	mov    (%eax),%eax
  802803:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  802806:	75 1e                	jne    802826 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  802808:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80280b:	89 d0                	mov    %edx,%eax
  80280d:	01 c0                	add    %eax,%eax
  80280f:	01 d0                	add    %edx,%eax
  802811:	c1 e0 02             	shl    $0x2,%eax
  802814:	05 44 60 80 00       	add    $0x806044,%eax
  802819:	8b 00                	mov    (%eax),%eax
  80281b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  80281e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802821:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802824:	eb 0c                	jmp    802832 <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802826:	ff 45 ec             	incl   -0x14(%ebp)
  802829:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802830:	7e a7                	jle    8027d9 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  802832:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802836:	75 0a                	jne    802842 <realloc+0x160>
		return NULL;
  802838:	b8 00 00 00 00       	mov    $0x0,%eax
  80283d:	e9 b8 04 00 00       	jmp    802cfa <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  802842:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80284f:	01 d0                	add    %edx,%eax
  802851:	48                   	dec    %eax
  802852:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802855:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802858:	ba 00 00 00 00       	mov    $0x0,%edx
  80285d:	f7 75 bc             	divl   -0x44(%ebp)
  802860:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802863:	29 d0                	sub    %edx,%eax
  802865:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  802868:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80286b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80286e:	75 08                	jne    802878 <realloc+0x196>
		return virtual_address;
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	e9 82 04 00 00       	jmp    802cfa <realloc+0x618>
	if (req < oldsz)
  802878:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80287b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80287e:	0f 83 cd 02 00 00    	jae    802b51 <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  80288a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  80288d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802890:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802893:	01 d0                	add    %edx,%eax
  802895:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  802898:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80289b:	89 d0                	mov    %edx,%eax
  80289d:	01 c0                	add    %eax,%eax
  80289f:	01 d0                	add    %edx,%eax
  8028a1:	c1 e0 02             	shl    $0x2,%eax
  8028a4:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  8028aa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8028ad:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8028af:	83 ec 08             	sub    $0x8,%esp
  8028b2:	ff 75 b0             	pushl  -0x50(%ebp)
  8028b5:	ff 75 ac             	pushl  -0x54(%ebp)
  8028b8:	e8 e3 0c 00 00       	call   8035a0 <sys_free_user_mem>
  8028bd:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  8028c0:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8028c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8028ce:	eb 64                	jmp    802934 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  8028d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028d3:	89 d0                	mov    %edx,%eax
  8028d5:	01 c0                	add    %eax,%eax
  8028d7:	01 d0                	add    %edx,%eax
  8028d9:	c1 e0 02             	shl    $0x2,%eax
  8028dc:	05 48 20 81 00       	add    $0x812048,%eax
  8028e1:	8a 00                	mov    (%eax),%al
  8028e3:	84 c0                	test   %al,%al
  8028e5:	75 4a                	jne    802931 <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  8028e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028ea:	89 d0                	mov    %edx,%eax
  8028ec:	01 c0                	add    %eax,%eax
  8028ee:	01 d0                	add    %edx,%eax
  8028f0:	c1 e0 02             	shl    $0x2,%eax
  8028f3:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  8028f9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8028fc:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  8028fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802901:	89 d0                	mov    %edx,%eax
  802903:	01 c0                	add    %eax,%eax
  802905:	01 d0                	add    %edx,%eax
  802907:	c1 e0 02             	shl    $0x2,%eax
  80290a:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802910:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802913:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  802915:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802918:	89 d0                	mov    %edx,%eax
  80291a:	01 c0                	add    %eax,%eax
  80291c:	01 d0                	add    %edx,%eax
  80291e:	c1 e0 02             	shl    $0x2,%eax
  802921:	05 48 20 81 00       	add    $0x812048,%eax
  802926:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  802929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80292c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  80292f:	eb 0c                	jmp    80293d <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802931:	ff 45 e4             	incl   -0x1c(%ebp)
  802934:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  80293b:	7e 93                	jle    8028d0 <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  80293d:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802941:	0f 84 8d 01 00 00    	je     802ad4 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802947:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80294e:	e9 74 01 00 00       	jmp    802ac7 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  802953:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802956:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802959:	0f 84 64 01 00 00    	je     802ac3 <realloc+0x3e1>
				if (uhp_frees[k].free)
  80295f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802962:	89 d0                	mov    %edx,%eax
  802964:	01 c0                	add    %eax,%eax
  802966:	01 d0                	add    %edx,%eax
  802968:	c1 e0 02             	shl    $0x2,%eax
  80296b:	05 48 20 81 00       	add    $0x812048,%eax
  802970:	8a 00                	mov    (%eax),%al
  802972:	84 c0                	test   %al,%al
  802974:	0f 84 4a 01 00 00    	je     802ac4 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  80297a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80297d:	89 d0                	mov    %edx,%eax
  80297f:	01 c0                	add    %eax,%eax
  802981:	01 d0                	add    %edx,%eax
  802983:	c1 e0 02             	shl    $0x2,%eax
  802986:	05 40 20 81 00       	add    $0x812040,%eax
  80298b:	8b 08                	mov    (%eax),%ecx
  80298d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802990:	89 d0                	mov    %edx,%eax
  802992:	01 c0                	add    %eax,%eax
  802994:	01 d0                	add    %edx,%eax
  802996:	c1 e0 02             	shl    $0x2,%eax
  802999:	05 44 20 81 00       	add    $0x812044,%eax
  80299e:	8b 00                	mov    (%eax),%eax
  8029a0:	01 c1                	add    %eax,%ecx
  8029a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029a5:	89 d0                	mov    %edx,%eax
  8029a7:	01 c0                	add    %eax,%eax
  8029a9:	01 d0                	add    %edx,%eax
  8029ab:	c1 e0 02             	shl    $0x2,%eax
  8029ae:	05 40 20 81 00       	add    $0x812040,%eax
  8029b3:	8b 00                	mov    (%eax),%eax
  8029b5:	39 c1                	cmp    %eax,%ecx
  8029b7:	75 7a                	jne    802a33 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  8029b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029bc:	89 d0                	mov    %edx,%eax
  8029be:	01 c0                	add    %eax,%eax
  8029c0:	01 d0                	add    %edx,%eax
  8029c2:	c1 e0 02             	shl    $0x2,%eax
  8029c5:	05 40 20 81 00       	add    $0x812040,%eax
  8029ca:	8b 10                	mov    (%eax),%edx
  8029cc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8029cf:	89 c8                	mov    %ecx,%eax
  8029d1:	01 c0                	add    %eax,%eax
  8029d3:	01 c8                	add    %ecx,%eax
  8029d5:	c1 e0 02             	shl    $0x2,%eax
  8029d8:	05 40 20 81 00       	add    $0x812040,%eax
  8029dd:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  8029df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029e2:	89 d0                	mov    %edx,%eax
  8029e4:	01 c0                	add    %eax,%eax
  8029e6:	01 d0                	add    %edx,%eax
  8029e8:	c1 e0 02             	shl    $0x2,%eax
  8029eb:	05 44 20 81 00       	add    $0x812044,%eax
  8029f0:	8b 08                	mov    (%eax),%ecx
  8029f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029f5:	89 d0                	mov    %edx,%eax
  8029f7:	01 c0                	add    %eax,%eax
  8029f9:	01 d0                	add    %edx,%eax
  8029fb:	c1 e0 02             	shl    $0x2,%eax
  8029fe:	05 44 20 81 00       	add    $0x812044,%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	01 c1                	add    %eax,%ecx
  802a07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a0a:	89 d0                	mov    %edx,%eax
  802a0c:	01 c0                	add    %eax,%eax
  802a0e:	01 d0                	add    %edx,%eax
  802a10:	c1 e0 02             	shl    $0x2,%eax
  802a13:	05 44 20 81 00       	add    $0x812044,%eax
  802a18:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802a1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a1d:	89 d0                	mov    %edx,%eax
  802a1f:	01 c0                	add    %eax,%eax
  802a21:	01 d0                	add    %edx,%eax
  802a23:	c1 e0 02             	shl    $0x2,%eax
  802a26:	05 48 20 81 00       	add    $0x812048,%eax
  802a2b:	c6 00 00             	movb   $0x0,(%eax)
  802a2e:	e9 91 00 00 00       	jmp    802ac4 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802a33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a36:	89 d0                	mov    %edx,%eax
  802a38:	01 c0                	add    %eax,%eax
  802a3a:	01 d0                	add    %edx,%eax
  802a3c:	c1 e0 02             	shl    $0x2,%eax
  802a3f:	05 40 20 81 00       	add    $0x812040,%eax
  802a44:	8b 08                	mov    (%eax),%ecx
  802a46:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a49:	89 d0                	mov    %edx,%eax
  802a4b:	01 c0                	add    %eax,%eax
  802a4d:	01 d0                	add    %edx,%eax
  802a4f:	c1 e0 02             	shl    $0x2,%eax
  802a52:	05 44 20 81 00       	add    $0x812044,%eax
  802a57:	8b 00                	mov    (%eax),%eax
  802a59:	01 c1                	add    %eax,%ecx
  802a5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a5e:	89 d0                	mov    %edx,%eax
  802a60:	01 c0                	add    %eax,%eax
  802a62:	01 d0                	add    %edx,%eax
  802a64:	c1 e0 02             	shl    $0x2,%eax
  802a67:	05 40 20 81 00       	add    $0x812040,%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	39 c1                	cmp    %eax,%ecx
  802a70:	75 52                	jne    802ac4 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  802a72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a75:	89 d0                	mov    %edx,%eax
  802a77:	01 c0                	add    %eax,%eax
  802a79:	01 d0                	add    %edx,%eax
  802a7b:	c1 e0 02             	shl    $0x2,%eax
  802a7e:	05 44 20 81 00       	add    $0x812044,%eax
  802a83:	8b 08                	mov    (%eax),%ecx
  802a85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a88:	89 d0                	mov    %edx,%eax
  802a8a:	01 c0                	add    %eax,%eax
  802a8c:	01 d0                	add    %edx,%eax
  802a8e:	c1 e0 02             	shl    $0x2,%eax
  802a91:	05 44 20 81 00       	add    $0x812044,%eax
  802a96:	8b 00                	mov    (%eax),%eax
  802a98:	01 c1                	add    %eax,%ecx
  802a9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a9d:	89 d0                	mov    %edx,%eax
  802a9f:	01 c0                	add    %eax,%eax
  802aa1:	01 d0                	add    %edx,%eax
  802aa3:	c1 e0 02             	shl    $0x2,%eax
  802aa6:	05 44 20 81 00       	add    $0x812044,%eax
  802aab:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  802aad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ab0:	89 d0                	mov    %edx,%eax
  802ab2:	01 c0                	add    %eax,%eax
  802ab4:	01 d0                	add    %edx,%eax
  802ab6:	c1 e0 02             	shl    $0x2,%eax
  802ab9:	05 48 20 81 00       	add    $0x812048,%eax
  802abe:	c6 00 00             	movb   $0x0,(%eax)
  802ac1:	eb 01                	jmp    802ac4 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  802ac3:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802ac4:	ff 45 e0             	incl   -0x20(%ebp)
  802ac7:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802ace:	0f 8e 7f fe ff ff    	jle    802953 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  802ad4:	a1 30 61 83 00       	mov    0x836130,%eax
  802ad9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802adc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802ae3:	eb 53                	jmp    802b38 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  802ae5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ae8:	89 d0                	mov    %edx,%eax
  802aea:	01 c0                	add    %eax,%eax
  802aec:	01 d0                	add    %edx,%eax
  802aee:	c1 e0 02             	shl    $0x2,%eax
  802af1:	05 48 60 80 00       	add    $0x806048,%eax
  802af6:	8a 00                	mov    (%eax),%al
  802af8:	84 c0                	test   %al,%al
  802afa:	74 39                	je     802b35 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802afc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802aff:	89 d0                	mov    %edx,%eax
  802b01:	01 c0                	add    %eax,%eax
  802b03:	01 d0                	add    %edx,%eax
  802b05:	c1 e0 02             	shl    $0x2,%eax
  802b08:	05 40 60 80 00       	add    $0x806040,%eax
  802b0d:	8b 08                	mov    (%eax),%ecx
  802b0f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b12:	89 d0                	mov    %edx,%eax
  802b14:	01 c0                	add    %eax,%eax
  802b16:	01 d0                	add    %edx,%eax
  802b18:	c1 e0 02             	shl    $0x2,%eax
  802b1b:	05 44 60 80 00       	add    $0x806044,%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	01 c8                	add    %ecx,%eax
  802b24:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  802b27:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b2a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802b2d:	76 06                	jbe    802b35 <realloc+0x453>
  802b2f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b32:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802b35:	ff 45 d8             	incl   -0x28(%ebp)
  802b38:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802b3f:	7e a4                	jle    802ae5 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  802b41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b44:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802b49:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4c:	e9 a9 01 00 00       	jmp    802cfa <realloc+0x618>
	}
	uint32 end = va + oldsz;
  802b51:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	01 d0                	add    %edx,%eax
  802b59:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  802b5c:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802b63:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  802b6a:	eb 57                	jmp    802bc3 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  802b6c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b6f:	89 d0                	mov    %edx,%eax
  802b71:	01 c0                	add    %eax,%eax
  802b73:	01 d0                	add    %edx,%eax
  802b75:	c1 e0 02             	shl    $0x2,%eax
  802b78:	05 48 20 81 00       	add    $0x812048,%eax
  802b7d:	8a 00                	mov    (%eax),%al
  802b7f:	84 c0                	test   %al,%al
  802b81:	74 3d                	je     802bc0 <realloc+0x4de>
  802b83:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b86:	89 d0                	mov    %edx,%eax
  802b88:	01 c0                	add    %eax,%eax
  802b8a:	01 d0                	add    %edx,%eax
  802b8c:	c1 e0 02             	shl    $0x2,%eax
  802b8f:	05 40 20 81 00       	add    $0x812040,%eax
  802b94:	8b 00                	mov    (%eax),%eax
  802b96:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b99:	75 25                	jne    802bc0 <realloc+0x4de>
  802b9b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802b9e:	89 d0                	mov    %edx,%eax
  802ba0:	01 c0                	add    %eax,%eax
  802ba2:	01 d0                	add    %edx,%eax
  802ba4:	c1 e0 02             	shl    $0x2,%eax
  802ba7:	05 44 20 81 00       	add    $0x812044,%eax
  802bac:	8b 10                	mov    (%eax),%edx
  802bae:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bb1:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802bb4:	39 c2                	cmp    %eax,%edx
  802bb6:	72 08                	jb     802bc0 <realloc+0x4de>
		{
			adjIdx = j; break;
  802bb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802bbb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802bbe:	eb 0c                	jmp    802bcc <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802bc0:	ff 45 d0             	incl   -0x30(%ebp)
  802bc3:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  802bca:	7e a0                	jle    802b6c <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  802bcc:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  802bd0:	0f 84 d6 00 00 00    	je     802cac <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  802bd6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bd9:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802bdc:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  802bdf:	83 ec 08             	sub    $0x8,%esp
  802be2:	ff 75 a0             	pushl  -0x60(%ebp)
  802be5:	ff 75 a4             	pushl  -0x5c(%ebp)
  802be8:	e8 cf 09 00 00       	call   8035bc <sys_allocate_user_mem>
  802bed:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  802bf0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf3:	89 d0                	mov    %edx,%eax
  802bf5:	01 c0                	add    %eax,%eax
  802bf7:	01 d0                	add    %edx,%eax
  802bf9:	c1 e0 02             	shl    $0x2,%eax
  802bfc:	8d 90 44 60 80 00    	lea    0x806044(%eax),%edx
  802c02:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c05:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  802c07:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c0a:	89 d0                	mov    %edx,%eax
  802c0c:	01 c0                	add    %eax,%eax
  802c0e:	01 d0                	add    %edx,%eax
  802c10:	c1 e0 02             	shl    $0x2,%eax
  802c13:	05 40 20 81 00       	add    $0x812040,%eax
  802c18:	8b 10                	mov    (%eax),%edx
  802c1a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802c1d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802c20:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c23:	89 d0                	mov    %edx,%eax
  802c25:	01 c0                	add    %eax,%eax
  802c27:	01 d0                	add    %edx,%eax
  802c29:	c1 e0 02             	shl    $0x2,%eax
  802c2c:	05 40 20 81 00       	add    $0x812040,%eax
  802c31:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  802c33:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c36:	89 d0                	mov    %edx,%eax
  802c38:	01 c0                	add    %eax,%eax
  802c3a:	01 d0                	add    %edx,%eax
  802c3c:	c1 e0 02             	shl    $0x2,%eax
  802c3f:	05 44 20 81 00       	add    $0x812044,%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	2b 45 a0             	sub    -0x60(%ebp),%eax
  802c49:	89 c2                	mov    %eax,%edx
  802c4b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  802c4e:	89 c8                	mov    %ecx,%eax
  802c50:	01 c0                	add    %eax,%eax
  802c52:	01 c8                	add    %ecx,%eax
  802c54:	c1 e0 02             	shl    $0x2,%eax
  802c57:	05 44 20 81 00       	add    $0x812044,%eax
  802c5c:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  802c5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c61:	89 d0                	mov    %edx,%eax
  802c63:	01 c0                	add    %eax,%eax
  802c65:	01 d0                	add    %edx,%eax
  802c67:	c1 e0 02             	shl    $0x2,%eax
  802c6a:	05 44 20 81 00       	add    $0x812044,%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	75 14                	jne    802c89 <realloc+0x5a7>
  802c75:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c78:	89 d0                	mov    %edx,%eax
  802c7a:	01 c0                	add    %eax,%eax
  802c7c:	01 d0                	add    %edx,%eax
  802c7e:	c1 e0 02             	shl    $0x2,%eax
  802c81:	05 48 20 81 00       	add    $0x812048,%eax
  802c86:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  802c89:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c8c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c8f:	01 c2                	add    %eax,%edx
  802c91:	a1 88 60 83 00       	mov    0x836088,%eax
  802c96:	39 c2                	cmp    %eax,%edx
  802c98:	76 0d                	jbe    802ca7 <realloc+0x5c5>
  802c9a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c9d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ca0:	01 d0                	add    %edx,%eax
  802ca2:	a3 88 60 83 00       	mov    %eax,0x836088
		return virtual_address;
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	eb 4e                	jmp    802cfa <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  802cac:	83 ec 0c             	sub    $0xc,%esp
  802caf:	ff 75 0c             	pushl  0xc(%ebp)
  802cb2:	e8 0b ec ff ff       	call   8018c2 <malloc>
  802cb7:	83 c4 10             	add    $0x10,%esp
  802cba:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  802cbd:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  802cc1:	75 07                	jne    802cca <realloc+0x5e8>
		return NULL;
  802cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc8:	eb 30                	jmp    802cfa <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  802cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cd0:	39 d0                	cmp    %edx,%eax
  802cd2:	76 02                	jbe    802cd6 <realloc+0x5f4>
  802cd4:	89 d0                	mov    %edx,%eax
  802cd6:	8b 55 9c             	mov    -0x64(%ebp),%edx
  802cd9:	83 ec 04             	sub    $0x4,%esp
  802cdc:	50                   	push   %eax
  802cdd:	52                   	push   %edx
  802cde:	ff 75 cc             	pushl  -0x34(%ebp)
  802ce1:	e8 cf 06 00 00       	call   8033b5 <sys_move_user_mem>
  802ce6:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  802ce9:	83 ec 0c             	sub    $0xc,%esp
  802cec:	ff 75 08             	pushl  0x8(%ebp)
  802cef:	e8 2e ef ff ff       	call   801c22 <free>
  802cf4:	83 c4 10             	add    $0x10,%esp
	return newptr;
  802cf7:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  802cfa:	c9                   	leave  
  802cfb:	c3                   	ret    

00802cfc <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802cfc:	55                   	push   %ebp
  802cfd:	89 e5                	mov    %esp,%ebp
  802cff:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  802d08:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d0c:	0f 84 33 03 00 00    	je     803045 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  802d12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d15:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  802d1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  802d1d:	83 ec 08             	sub    $0x8,%esp
  802d20:	ff 75 08             	pushl  0x8(%ebp)
  802d23:	ff 75 d8             	pushl  -0x28(%ebp)
  802d26:	e8 7d 05 00 00       	call   8032a8 <sys_delete_shared_object>
  802d2b:	83 c4 10             	add    $0x10,%esp
  802d2e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  802d31:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d35:	0f 88 0d 03 00 00    	js     803048 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802d3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d42:	e9 ef 02 00 00       	jmp    803036 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  802d47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d4a:	89 d0                	mov    %edx,%eax
  802d4c:	01 c0                	add    %eax,%eax
  802d4e:	01 d0                	add    %edx,%eax
  802d50:	c1 e0 02             	shl    $0x2,%eax
  802d53:	05 48 60 80 00       	add    $0x806048,%eax
  802d58:	8a 00                	mov    (%eax),%al
  802d5a:	84 c0                	test   %al,%al
  802d5c:	0f 84 d1 02 00 00    	je     803033 <sfree+0x337>
  802d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d65:	89 d0                	mov    %edx,%eax
  802d67:	01 c0                	add    %eax,%eax
  802d69:	01 d0                	add    %edx,%eax
  802d6b:	c1 e0 02             	shl    $0x2,%eax
  802d6e:	05 40 60 80 00       	add    $0x806040,%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d78:	0f 85 b5 02 00 00    	jne    803033 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  802d7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d81:	89 d0                	mov    %edx,%eax
  802d83:	01 c0                	add    %eax,%eax
  802d85:	01 d0                	add    %edx,%eax
  802d87:	c1 e0 02             	shl    $0x2,%eax
  802d8a:	05 44 60 80 00       	add    $0x806044,%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  802d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d97:	89 d0                	mov    %edx,%eax
  802d99:	01 c0                	add    %eax,%eax
  802d9b:	01 d0                	add    %edx,%eax
  802d9d:	c1 e0 02             	shl    $0x2,%eax
  802da0:	05 48 60 80 00       	add    $0x806048,%eax
  802da5:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  802da8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802daf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802db6:	eb 64                	jmp    802e1c <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  802db8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dbb:	89 d0                	mov    %edx,%eax
  802dbd:	01 c0                	add    %eax,%eax
  802dbf:	01 d0                	add    %edx,%eax
  802dc1:	c1 e0 02             	shl    $0x2,%eax
  802dc4:	05 48 20 81 00       	add    $0x812048,%eax
  802dc9:	8a 00                	mov    (%eax),%al
  802dcb:	84 c0                	test   %al,%al
  802dcd:	75 4a                	jne    802e19 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  802dcf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dd2:	89 d0                	mov    %edx,%eax
  802dd4:	01 c0                	add    %eax,%eax
  802dd6:	01 d0                	add    %edx,%eax
  802dd8:	c1 e0 02             	shl    $0x2,%eax
  802ddb:	8d 90 40 20 81 00    	lea    0x812040(%eax),%edx
  802de1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de4:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  802de6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de9:	89 d0                	mov    %edx,%eax
  802deb:	01 c0                	add    %eax,%eax
  802ded:	01 d0                	add    %edx,%eax
  802def:	c1 e0 02             	shl    $0x2,%eax
  802df2:	8d 90 44 20 81 00    	lea    0x812044(%eax),%edx
  802df8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dfb:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  802dfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e00:	89 d0                	mov    %edx,%eax
  802e02:	01 c0                	add    %eax,%eax
  802e04:	01 d0                	add    %edx,%eax
  802e06:	c1 e0 02             	shl    $0x2,%eax
  802e09:	05 48 20 81 00       	add    $0x812048,%eax
  802e0e:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  802e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  802e17:	eb 0c                	jmp    802e25 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  802e19:	ff 45 ec             	incl   -0x14(%ebp)
  802e1c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802e23:	7e 93                	jle    802db8 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  802e25:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802e29:	0f 84 8d 01 00 00    	je     802fbc <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802e2f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802e36:	e9 74 01 00 00       	jmp    802faf <sfree+0x2b3>
				{
					if (k == fidx) continue;
  802e3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e41:	0f 84 64 01 00 00    	je     802fab <sfree+0x2af>
					if (uhp_frees[k].free)
  802e47:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e4a:	89 d0                	mov    %edx,%eax
  802e4c:	01 c0                	add    %eax,%eax
  802e4e:	01 d0                	add    %edx,%eax
  802e50:	c1 e0 02             	shl    $0x2,%eax
  802e53:	05 48 20 81 00       	add    $0x812048,%eax
  802e58:	8a 00                	mov    (%eax),%al
  802e5a:	84 c0                	test   %al,%al
  802e5c:	0f 84 4a 01 00 00    	je     802fac <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  802e62:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e65:	89 d0                	mov    %edx,%eax
  802e67:	01 c0                	add    %eax,%eax
  802e69:	01 d0                	add    %edx,%eax
  802e6b:	c1 e0 02             	shl    $0x2,%eax
  802e6e:	05 40 20 81 00       	add    $0x812040,%eax
  802e73:	8b 08                	mov    (%eax),%ecx
  802e75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e78:	89 d0                	mov    %edx,%eax
  802e7a:	01 c0                	add    %eax,%eax
  802e7c:	01 d0                	add    %edx,%eax
  802e7e:	c1 e0 02             	shl    $0x2,%eax
  802e81:	05 44 20 81 00       	add    $0x812044,%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	01 c1                	add    %eax,%ecx
  802e8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e8d:	89 d0                	mov    %edx,%eax
  802e8f:	01 c0                	add    %eax,%eax
  802e91:	01 d0                	add    %edx,%eax
  802e93:	c1 e0 02             	shl    $0x2,%eax
  802e96:	05 40 20 81 00       	add    $0x812040,%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	39 c1                	cmp    %eax,%ecx
  802e9f:	75 7a                	jne    802f1b <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  802ea1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ea4:	89 d0                	mov    %edx,%eax
  802ea6:	01 c0                	add    %eax,%eax
  802ea8:	01 d0                	add    %edx,%eax
  802eaa:	c1 e0 02             	shl    $0x2,%eax
  802ead:	05 40 20 81 00       	add    $0x812040,%eax
  802eb2:	8b 10                	mov    (%eax),%edx
  802eb4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802eb7:	89 c8                	mov    %ecx,%eax
  802eb9:	01 c0                	add    %eax,%eax
  802ebb:	01 c8                	add    %ecx,%eax
  802ebd:	c1 e0 02             	shl    $0x2,%eax
  802ec0:	05 40 20 81 00       	add    $0x812040,%eax
  802ec5:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  802ec7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eca:	89 d0                	mov    %edx,%eax
  802ecc:	01 c0                	add    %eax,%eax
  802ece:	01 d0                	add    %edx,%eax
  802ed0:	c1 e0 02             	shl    $0x2,%eax
  802ed3:	05 44 20 81 00       	add    $0x812044,%eax
  802ed8:	8b 08                	mov    (%eax),%ecx
  802eda:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802edd:	89 d0                	mov    %edx,%eax
  802edf:	01 c0                	add    %eax,%eax
  802ee1:	01 d0                	add    %edx,%eax
  802ee3:	c1 e0 02             	shl    $0x2,%eax
  802ee6:	05 44 20 81 00       	add    $0x812044,%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	01 c1                	add    %eax,%ecx
  802eef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef2:	89 d0                	mov    %edx,%eax
  802ef4:	01 c0                	add    %eax,%eax
  802ef6:	01 d0                	add    %edx,%eax
  802ef8:	c1 e0 02             	shl    $0x2,%eax
  802efb:	05 44 20 81 00       	add    $0x812044,%eax
  802f00:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802f02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f05:	89 d0                	mov    %edx,%eax
  802f07:	01 c0                	add    %eax,%eax
  802f09:	01 d0                	add    %edx,%eax
  802f0b:	c1 e0 02             	shl    $0x2,%eax
  802f0e:	05 48 20 81 00       	add    $0x812048,%eax
  802f13:	c6 00 00             	movb   $0x0,(%eax)
  802f16:	e9 91 00 00 00       	jmp    802fac <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  802f1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f1e:	89 d0                	mov    %edx,%eax
  802f20:	01 c0                	add    %eax,%eax
  802f22:	01 d0                	add    %edx,%eax
  802f24:	c1 e0 02             	shl    $0x2,%eax
  802f27:	05 40 20 81 00       	add    $0x812040,%eax
  802f2c:	8b 08                	mov    (%eax),%ecx
  802f2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f31:	89 d0                	mov    %edx,%eax
  802f33:	01 c0                	add    %eax,%eax
  802f35:	01 d0                	add    %edx,%eax
  802f37:	c1 e0 02             	shl    $0x2,%eax
  802f3a:	05 44 20 81 00       	add    $0x812044,%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	01 c1                	add    %eax,%ecx
  802f43:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f46:	89 d0                	mov    %edx,%eax
  802f48:	01 c0                	add    %eax,%eax
  802f4a:	01 d0                	add    %edx,%eax
  802f4c:	c1 e0 02             	shl    $0x2,%eax
  802f4f:	05 40 20 81 00       	add    $0x812040,%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	39 c1                	cmp    %eax,%ecx
  802f58:	75 52                	jne    802fac <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  802f5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5d:	89 d0                	mov    %edx,%eax
  802f5f:	01 c0                	add    %eax,%eax
  802f61:	01 d0                	add    %edx,%eax
  802f63:	c1 e0 02             	shl    $0x2,%eax
  802f66:	05 44 20 81 00       	add    $0x812044,%eax
  802f6b:	8b 08                	mov    (%eax),%ecx
  802f6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f70:	89 d0                	mov    %edx,%eax
  802f72:	01 c0                	add    %eax,%eax
  802f74:	01 d0                	add    %edx,%eax
  802f76:	c1 e0 02             	shl    $0x2,%eax
  802f79:	05 44 20 81 00       	add    $0x812044,%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	01 c1                	add    %eax,%ecx
  802f82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f85:	89 d0                	mov    %edx,%eax
  802f87:	01 c0                	add    %eax,%eax
  802f89:	01 d0                	add    %edx,%eax
  802f8b:	c1 e0 02             	shl    $0x2,%eax
  802f8e:	05 44 20 81 00       	add    $0x812044,%eax
  802f93:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  802f95:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f98:	89 d0                	mov    %edx,%eax
  802f9a:	01 c0                	add    %eax,%eax
  802f9c:	01 d0                	add    %edx,%eax
  802f9e:	c1 e0 02             	shl    $0x2,%eax
  802fa1:	05 48 20 81 00       	add    $0x812048,%eax
  802fa6:	c6 00 00             	movb   $0x0,(%eax)
  802fa9:	eb 01                	jmp    802fac <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  802fab:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  802fac:	ff 45 e8             	incl   -0x18(%ebp)
  802faf:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802fb6:	0f 8e 7f fe ff ff    	jle    802e3b <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  802fbc:	a1 30 61 83 00       	mov    0x836130,%eax
  802fc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  802fc4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802fcb:	eb 53                	jmp    803020 <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  802fcd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fd0:	89 d0                	mov    %edx,%eax
  802fd2:	01 c0                	add    %eax,%eax
  802fd4:	01 d0                	add    %edx,%eax
  802fd6:	c1 e0 02             	shl    $0x2,%eax
  802fd9:	05 48 60 80 00       	add    $0x806048,%eax
  802fde:	8a 00                	mov    (%eax),%al
  802fe0:	84 c0                	test   %al,%al
  802fe2:	74 39                	je     80301d <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  802fe4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fe7:	89 d0                	mov    %edx,%eax
  802fe9:	01 c0                	add    %eax,%eax
  802feb:	01 d0                	add    %edx,%eax
  802fed:	c1 e0 02             	shl    $0x2,%eax
  802ff0:	05 40 60 80 00       	add    $0x806040,%eax
  802ff5:	8b 08                	mov    (%eax),%ecx
  802ff7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ffa:	89 d0                	mov    %edx,%eax
  802ffc:	01 c0                	add    %eax,%eax
  802ffe:	01 d0                	add    %edx,%eax
  803000:	c1 e0 02             	shl    $0x2,%eax
  803003:	05 44 60 80 00       	add    $0x806044,%eax
  803008:	8b 00                	mov    (%eax),%eax
  80300a:	01 c8                	add    %ecx,%eax
  80300c:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  80300f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803012:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803015:	76 06                	jbe    80301d <sfree+0x321>
  803017:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80301a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  80301d:	ff 45 e0             	incl   -0x20(%ebp)
  803020:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803027:	7e a4                	jle    802fcd <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302c:	a3 88 60 83 00       	mov    %eax,0x836088
			break;
  803031:	eb 16                	jmp    803049 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803033:	ff 45 f4             	incl   -0xc(%ebp)
  803036:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  80303d:	0f 8e 04 fd ff ff    	jle    802d47 <sfree+0x4b>
  803043:	eb 04                	jmp    803049 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  803045:	90                   	nop
  803046:	eb 01                	jmp    803049 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  803048:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803049:	c9                   	leave  
  80304a:	c3                   	ret    

0080304b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80304b:	55                   	push   %ebp
  80304c:	89 e5                	mov    %esp,%ebp
  80304e:	57                   	push   %edi
  80304f:	56                   	push   %esi
  803050:	53                   	push   %ebx
  803051:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 55 0c             	mov    0xc(%ebp),%edx
  80305a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80305d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803060:	8b 7d 18             	mov    0x18(%ebp),%edi
  803063:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803066:	cd 30                	int    $0x30
  803068:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80306b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80306e:	83 c4 10             	add    $0x10,%esp
  803071:	5b                   	pop    %ebx
  803072:	5e                   	pop    %esi
  803073:	5f                   	pop    %edi
  803074:	5d                   	pop    %ebp
  803075:	c3                   	ret    

00803076 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803076:	55                   	push   %ebp
  803077:	89 e5                	mov    %esp,%ebp
  803079:	83 ec 04             	sub    $0x4,%esp
  80307c:	8b 45 10             	mov    0x10(%ebp),%eax
  80307f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803082:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803085:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	6a 00                	push   $0x0
  80308e:	51                   	push   %ecx
  80308f:	52                   	push   %edx
  803090:	ff 75 0c             	pushl  0xc(%ebp)
  803093:	50                   	push   %eax
  803094:	6a 00                	push   $0x0
  803096:	e8 b0 ff ff ff       	call   80304b <syscall>
  80309b:	83 c4 18             	add    $0x18,%esp
}
  80309e:	90                   	nop
  80309f:	c9                   	leave  
  8030a0:	c3                   	ret    

008030a1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8030a1:	55                   	push   %ebp
  8030a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8030a4:	6a 00                	push   $0x0
  8030a6:	6a 00                	push   $0x0
  8030a8:	6a 00                	push   $0x0
  8030aa:	6a 00                	push   $0x0
  8030ac:	6a 00                	push   $0x0
  8030ae:	6a 02                	push   $0x2
  8030b0:	e8 96 ff ff ff       	call   80304b <syscall>
  8030b5:	83 c4 18             	add    $0x18,%esp
}
  8030b8:	c9                   	leave  
  8030b9:	c3                   	ret    

008030ba <sys_lock_cons>:

void sys_lock_cons(void)
{
  8030ba:	55                   	push   %ebp
  8030bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8030bd:	6a 00                	push   $0x0
  8030bf:	6a 00                	push   $0x0
  8030c1:	6a 00                	push   $0x0
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 00                	push   $0x0
  8030c7:	6a 03                	push   $0x3
  8030c9:	e8 7d ff ff ff       	call   80304b <syscall>
  8030ce:	83 c4 18             	add    $0x18,%esp
}
  8030d1:	90                   	nop
  8030d2:	c9                   	leave  
  8030d3:	c3                   	ret    

008030d4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8030d4:	55                   	push   %ebp
  8030d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8030d7:	6a 00                	push   $0x0
  8030d9:	6a 00                	push   $0x0
  8030db:	6a 00                	push   $0x0
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 00                	push   $0x0
  8030e1:	6a 04                	push   $0x4
  8030e3:	e8 63 ff ff ff       	call   80304b <syscall>
  8030e8:	83 c4 18             	add    $0x18,%esp
}
  8030eb:	90                   	nop
  8030ec:	c9                   	leave  
  8030ed:	c3                   	ret    

008030ee <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8030ee:	55                   	push   %ebp
  8030ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8030f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	6a 00                	push   $0x0
  8030f9:	6a 00                	push   $0x0
  8030fb:	6a 00                	push   $0x0
  8030fd:	52                   	push   %edx
  8030fe:	50                   	push   %eax
  8030ff:	6a 08                	push   $0x8
  803101:	e8 45 ff ff ff       	call   80304b <syscall>
  803106:	83 c4 18             	add    $0x18,%esp
}
  803109:	c9                   	leave  
  80310a:	c3                   	ret    

0080310b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80310b:	55                   	push   %ebp
  80310c:	89 e5                	mov    %esp,%ebp
  80310e:	56                   	push   %esi
  80310f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803110:	8b 75 18             	mov    0x18(%ebp),%esi
  803113:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803116:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803119:	8b 55 0c             	mov    0xc(%ebp),%edx
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	56                   	push   %esi
  803120:	53                   	push   %ebx
  803121:	51                   	push   %ecx
  803122:	52                   	push   %edx
  803123:	50                   	push   %eax
  803124:	6a 09                	push   $0x9
  803126:	e8 20 ff ff ff       	call   80304b <syscall>
  80312b:	83 c4 18             	add    $0x18,%esp
}
  80312e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803131:	5b                   	pop    %ebx
  803132:	5e                   	pop    %esi
  803133:	5d                   	pop    %ebp
  803134:	c3                   	ret    

00803135 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803135:	55                   	push   %ebp
  803136:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803138:	6a 00                	push   $0x0
  80313a:	6a 00                	push   $0x0
  80313c:	6a 00                	push   $0x0
  80313e:	6a 00                	push   $0x0
  803140:	ff 75 08             	pushl  0x8(%ebp)
  803143:	6a 0a                	push   $0xa
  803145:	e8 01 ff ff ff       	call   80304b <syscall>
  80314a:	83 c4 18             	add    $0x18,%esp
}
  80314d:	c9                   	leave  
  80314e:	c3                   	ret    

0080314f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80314f:	55                   	push   %ebp
  803150:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803152:	6a 00                	push   $0x0
  803154:	6a 00                	push   $0x0
  803156:	6a 00                	push   $0x0
  803158:	ff 75 0c             	pushl  0xc(%ebp)
  80315b:	ff 75 08             	pushl  0x8(%ebp)
  80315e:	6a 0b                	push   $0xb
  803160:	e8 e6 fe ff ff       	call   80304b <syscall>
  803165:	83 c4 18             	add    $0x18,%esp
}
  803168:	c9                   	leave  
  803169:	c3                   	ret    

0080316a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80316a:	55                   	push   %ebp
  80316b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80316d:	6a 00                	push   $0x0
  80316f:	6a 00                	push   $0x0
  803171:	6a 00                	push   $0x0
  803173:	6a 00                	push   $0x0
  803175:	6a 00                	push   $0x0
  803177:	6a 0c                	push   $0xc
  803179:	e8 cd fe ff ff       	call   80304b <syscall>
  80317e:	83 c4 18             	add    $0x18,%esp
}
  803181:	c9                   	leave  
  803182:	c3                   	ret    

00803183 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803183:	55                   	push   %ebp
  803184:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803186:	6a 00                	push   $0x0
  803188:	6a 00                	push   $0x0
  80318a:	6a 00                	push   $0x0
  80318c:	6a 00                	push   $0x0
  80318e:	6a 00                	push   $0x0
  803190:	6a 0d                	push   $0xd
  803192:	e8 b4 fe ff ff       	call   80304b <syscall>
  803197:	83 c4 18             	add    $0x18,%esp
}
  80319a:	c9                   	leave  
  80319b:	c3                   	ret    

0080319c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80319c:	55                   	push   %ebp
  80319d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80319f:	6a 00                	push   $0x0
  8031a1:	6a 00                	push   $0x0
  8031a3:	6a 00                	push   $0x0
  8031a5:	6a 00                	push   $0x0
  8031a7:	6a 00                	push   $0x0
  8031a9:	6a 0e                	push   $0xe
  8031ab:	e8 9b fe ff ff       	call   80304b <syscall>
  8031b0:	83 c4 18             	add    $0x18,%esp
}
  8031b3:	c9                   	leave  
  8031b4:	c3                   	ret    

008031b5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8031b5:	55                   	push   %ebp
  8031b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8031b8:	6a 00                	push   $0x0
  8031ba:	6a 00                	push   $0x0
  8031bc:	6a 00                	push   $0x0
  8031be:	6a 00                	push   $0x0
  8031c0:	6a 00                	push   $0x0
  8031c2:	6a 0f                	push   $0xf
  8031c4:	e8 82 fe ff ff       	call   80304b <syscall>
  8031c9:	83 c4 18             	add    $0x18,%esp
}
  8031cc:	c9                   	leave  
  8031cd:	c3                   	ret    

008031ce <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8031ce:	55                   	push   %ebp
  8031cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8031d1:	6a 00                	push   $0x0
  8031d3:	6a 00                	push   $0x0
  8031d5:	6a 00                	push   $0x0
  8031d7:	6a 00                	push   $0x0
  8031d9:	ff 75 08             	pushl  0x8(%ebp)
  8031dc:	6a 10                	push   $0x10
  8031de:	e8 68 fe ff ff       	call   80304b <syscall>
  8031e3:	83 c4 18             	add    $0x18,%esp
}
  8031e6:	c9                   	leave  
  8031e7:	c3                   	ret    

008031e8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8031e8:	55                   	push   %ebp
  8031e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8031eb:	6a 00                	push   $0x0
  8031ed:	6a 00                	push   $0x0
  8031ef:	6a 00                	push   $0x0
  8031f1:	6a 00                	push   $0x0
  8031f3:	6a 00                	push   $0x0
  8031f5:	6a 11                	push   $0x11
  8031f7:	e8 4f fe ff ff       	call   80304b <syscall>
  8031fc:	83 c4 18             	add    $0x18,%esp
}
  8031ff:	90                   	nop
  803200:	c9                   	leave  
  803201:	c3                   	ret    

00803202 <sys_cputc>:

void
sys_cputc(const char c)
{
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
  803205:	83 ec 04             	sub    $0x4,%esp
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80320e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803212:	6a 00                	push   $0x0
  803214:	6a 00                	push   $0x0
  803216:	6a 00                	push   $0x0
  803218:	6a 00                	push   $0x0
  80321a:	50                   	push   %eax
  80321b:	6a 01                	push   $0x1
  80321d:	e8 29 fe ff ff       	call   80304b <syscall>
  803222:	83 c4 18             	add    $0x18,%esp
}
  803225:	90                   	nop
  803226:	c9                   	leave  
  803227:	c3                   	ret    

00803228 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803228:	55                   	push   %ebp
  803229:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80322b:	6a 00                	push   $0x0
  80322d:	6a 00                	push   $0x0
  80322f:	6a 00                	push   $0x0
  803231:	6a 00                	push   $0x0
  803233:	6a 00                	push   $0x0
  803235:	6a 14                	push   $0x14
  803237:	e8 0f fe ff ff       	call   80304b <syscall>
  80323c:	83 c4 18             	add    $0x18,%esp
}
  80323f:	90                   	nop
  803240:	c9                   	leave  
  803241:	c3                   	ret    

00803242 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803242:	55                   	push   %ebp
  803243:	89 e5                	mov    %esp,%ebp
  803245:	83 ec 04             	sub    $0x4,%esp
  803248:	8b 45 10             	mov    0x10(%ebp),%eax
  80324b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80324e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803251:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	6a 00                	push   $0x0
  80325a:	51                   	push   %ecx
  80325b:	52                   	push   %edx
  80325c:	ff 75 0c             	pushl  0xc(%ebp)
  80325f:	50                   	push   %eax
  803260:	6a 15                	push   $0x15
  803262:	e8 e4 fd ff ff       	call   80304b <syscall>
  803267:	83 c4 18             	add    $0x18,%esp
}
  80326a:	c9                   	leave  
  80326b:	c3                   	ret    

0080326c <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80326c:	55                   	push   %ebp
  80326d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80326f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	6a 00                	push   $0x0
  803277:	6a 00                	push   $0x0
  803279:	6a 00                	push   $0x0
  80327b:	52                   	push   %edx
  80327c:	50                   	push   %eax
  80327d:	6a 16                	push   $0x16
  80327f:	e8 c7 fd ff ff       	call   80304b <syscall>
  803284:	83 c4 18             	add    $0x18,%esp
}
  803287:	c9                   	leave  
  803288:	c3                   	ret    

00803289 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803289:	55                   	push   %ebp
  80328a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80328c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80328f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	6a 00                	push   $0x0
  803297:	6a 00                	push   $0x0
  803299:	51                   	push   %ecx
  80329a:	52                   	push   %edx
  80329b:	50                   	push   %eax
  80329c:	6a 17                	push   $0x17
  80329e:	e8 a8 fd ff ff       	call   80304b <syscall>
  8032a3:	83 c4 18             	add    $0x18,%esp
}
  8032a6:	c9                   	leave  
  8032a7:	c3                   	ret    

008032a8 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8032a8:	55                   	push   %ebp
  8032a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8032ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	6a 00                	push   $0x0
  8032b3:	6a 00                	push   $0x0
  8032b5:	6a 00                	push   $0x0
  8032b7:	52                   	push   %edx
  8032b8:	50                   	push   %eax
  8032b9:	6a 18                	push   $0x18
  8032bb:	e8 8b fd ff ff       	call   80304b <syscall>
  8032c0:	83 c4 18             	add    $0x18,%esp
}
  8032c3:	c9                   	leave  
  8032c4:	c3                   	ret    

008032c5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8032c5:	55                   	push   %ebp
  8032c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	6a 00                	push   $0x0
  8032cd:	ff 75 14             	pushl  0x14(%ebp)
  8032d0:	ff 75 10             	pushl  0x10(%ebp)
  8032d3:	ff 75 0c             	pushl  0xc(%ebp)
  8032d6:	50                   	push   %eax
  8032d7:	6a 19                	push   $0x19
  8032d9:	e8 6d fd ff ff       	call   80304b <syscall>
  8032de:	83 c4 18             	add    $0x18,%esp
}
  8032e1:	c9                   	leave  
  8032e2:	c3                   	ret    

008032e3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	6a 00                	push   $0x0
  8032eb:	6a 00                	push   $0x0
  8032ed:	6a 00                	push   $0x0
  8032ef:	6a 00                	push   $0x0
  8032f1:	50                   	push   %eax
  8032f2:	6a 1a                	push   $0x1a
  8032f4:	e8 52 fd ff ff       	call   80304b <syscall>
  8032f9:	83 c4 18             	add    $0x18,%esp
}
  8032fc:	90                   	nop
  8032fd:	c9                   	leave  
  8032fe:	c3                   	ret    

008032ff <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8032ff:	55                   	push   %ebp
  803300:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	6a 00                	push   $0x0
  803307:	6a 00                	push   $0x0
  803309:	6a 00                	push   $0x0
  80330b:	6a 00                	push   $0x0
  80330d:	50                   	push   %eax
  80330e:	6a 1b                	push   $0x1b
  803310:	e8 36 fd ff ff       	call   80304b <syscall>
  803315:	83 c4 18             	add    $0x18,%esp
}
  803318:	c9                   	leave  
  803319:	c3                   	ret    

0080331a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80331a:	55                   	push   %ebp
  80331b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80331d:	6a 00                	push   $0x0
  80331f:	6a 00                	push   $0x0
  803321:	6a 00                	push   $0x0
  803323:	6a 00                	push   $0x0
  803325:	6a 00                	push   $0x0
  803327:	6a 05                	push   $0x5
  803329:	e8 1d fd ff ff       	call   80304b <syscall>
  80332e:	83 c4 18             	add    $0x18,%esp
}
  803331:	c9                   	leave  
  803332:	c3                   	ret    

00803333 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803333:	55                   	push   %ebp
  803334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803336:	6a 00                	push   $0x0
  803338:	6a 00                	push   $0x0
  80333a:	6a 00                	push   $0x0
  80333c:	6a 00                	push   $0x0
  80333e:	6a 00                	push   $0x0
  803340:	6a 06                	push   $0x6
  803342:	e8 04 fd ff ff       	call   80304b <syscall>
  803347:	83 c4 18             	add    $0x18,%esp
}
  80334a:	c9                   	leave  
  80334b:	c3                   	ret    

0080334c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80334c:	55                   	push   %ebp
  80334d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80334f:	6a 00                	push   $0x0
  803351:	6a 00                	push   $0x0
  803353:	6a 00                	push   $0x0
  803355:	6a 00                	push   $0x0
  803357:	6a 00                	push   $0x0
  803359:	6a 07                	push   $0x7
  80335b:	e8 eb fc ff ff       	call   80304b <syscall>
  803360:	83 c4 18             	add    $0x18,%esp
}
  803363:	c9                   	leave  
  803364:	c3                   	ret    

00803365 <sys_exit_env>:


void sys_exit_env(void)
{
  803365:	55                   	push   %ebp
  803366:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803368:	6a 00                	push   $0x0
  80336a:	6a 00                	push   $0x0
  80336c:	6a 00                	push   $0x0
  80336e:	6a 00                	push   $0x0
  803370:	6a 00                	push   $0x0
  803372:	6a 1c                	push   $0x1c
  803374:	e8 d2 fc ff ff       	call   80304b <syscall>
  803379:	83 c4 18             	add    $0x18,%esp
}
  80337c:	90                   	nop
  80337d:	c9                   	leave  
  80337e:	c3                   	ret    

0080337f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80337f:	55                   	push   %ebp
  803380:	89 e5                	mov    %esp,%ebp
  803382:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803385:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803388:	8d 50 04             	lea    0x4(%eax),%edx
  80338b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80338e:	6a 00                	push   $0x0
  803390:	6a 00                	push   $0x0
  803392:	6a 00                	push   $0x0
  803394:	52                   	push   %edx
  803395:	50                   	push   %eax
  803396:	6a 1d                	push   $0x1d
  803398:	e8 ae fc ff ff       	call   80304b <syscall>
  80339d:	83 c4 18             	add    $0x18,%esp
	return result;
  8033a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8033a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8033a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033a9:	89 01                	mov    %eax,(%ecx)
  8033ab:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	c9                   	leave  
  8033b2:	c2 04 00             	ret    $0x4

008033b5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8033b5:	55                   	push   %ebp
  8033b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8033b8:	6a 00                	push   $0x0
  8033ba:	6a 00                	push   $0x0
  8033bc:	ff 75 10             	pushl  0x10(%ebp)
  8033bf:	ff 75 0c             	pushl  0xc(%ebp)
  8033c2:	ff 75 08             	pushl  0x8(%ebp)
  8033c5:	6a 13                	push   $0x13
  8033c7:	e8 7f fc ff ff       	call   80304b <syscall>
  8033cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8033cf:	90                   	nop
}
  8033d0:	c9                   	leave  
  8033d1:	c3                   	ret    

008033d2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8033d2:	55                   	push   %ebp
  8033d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8033d5:	6a 00                	push   $0x0
  8033d7:	6a 00                	push   $0x0
  8033d9:	6a 00                	push   $0x0
  8033db:	6a 00                	push   $0x0
  8033dd:	6a 00                	push   $0x0
  8033df:	6a 1e                	push   $0x1e
  8033e1:	e8 65 fc ff ff       	call   80304b <syscall>
  8033e6:	83 c4 18             	add    $0x18,%esp
}
  8033e9:	c9                   	leave  
  8033ea:	c3                   	ret    

008033eb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8033eb:	55                   	push   %ebp
  8033ec:	89 e5                	mov    %esp,%ebp
  8033ee:	83 ec 04             	sub    $0x4,%esp
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8033f7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8033fb:	6a 00                	push   $0x0
  8033fd:	6a 00                	push   $0x0
  8033ff:	6a 00                	push   $0x0
  803401:	6a 00                	push   $0x0
  803403:	50                   	push   %eax
  803404:	6a 1f                	push   $0x1f
  803406:	e8 40 fc ff ff       	call   80304b <syscall>
  80340b:	83 c4 18             	add    $0x18,%esp
	return ;
  80340e:	90                   	nop
}
  80340f:	c9                   	leave  
  803410:	c3                   	ret    

00803411 <rsttst>:
void rsttst()
{
  803411:	55                   	push   %ebp
  803412:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803414:	6a 00                	push   $0x0
  803416:	6a 00                	push   $0x0
  803418:	6a 00                	push   $0x0
  80341a:	6a 00                	push   $0x0
  80341c:	6a 00                	push   $0x0
  80341e:	6a 21                	push   $0x21
  803420:	e8 26 fc ff ff       	call   80304b <syscall>
  803425:	83 c4 18             	add    $0x18,%esp
	return ;
  803428:	90                   	nop
}
  803429:	c9                   	leave  
  80342a:	c3                   	ret    

0080342b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80342b:	55                   	push   %ebp
  80342c:	89 e5                	mov    %esp,%ebp
  80342e:	83 ec 04             	sub    $0x4,%esp
  803431:	8b 45 14             	mov    0x14(%ebp),%eax
  803434:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803437:	8b 55 18             	mov    0x18(%ebp),%edx
  80343a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80343e:	52                   	push   %edx
  80343f:	50                   	push   %eax
  803440:	ff 75 10             	pushl  0x10(%ebp)
  803443:	ff 75 0c             	pushl  0xc(%ebp)
  803446:	ff 75 08             	pushl  0x8(%ebp)
  803449:	6a 20                	push   $0x20
  80344b:	e8 fb fb ff ff       	call   80304b <syscall>
  803450:	83 c4 18             	add    $0x18,%esp
	return ;
  803453:	90                   	nop
}
  803454:	c9                   	leave  
  803455:	c3                   	ret    

00803456 <chktst>:
void chktst(uint32 n)
{
  803456:	55                   	push   %ebp
  803457:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803459:	6a 00                	push   $0x0
  80345b:	6a 00                	push   $0x0
  80345d:	6a 00                	push   $0x0
  80345f:	6a 00                	push   $0x0
  803461:	ff 75 08             	pushl  0x8(%ebp)
  803464:	6a 22                	push   $0x22
  803466:	e8 e0 fb ff ff       	call   80304b <syscall>
  80346b:	83 c4 18             	add    $0x18,%esp
	return ;
  80346e:	90                   	nop
}
  80346f:	c9                   	leave  
  803470:	c3                   	ret    

00803471 <inctst>:

void inctst()
{
  803471:	55                   	push   %ebp
  803472:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803474:	6a 00                	push   $0x0
  803476:	6a 00                	push   $0x0
  803478:	6a 00                	push   $0x0
  80347a:	6a 00                	push   $0x0
  80347c:	6a 00                	push   $0x0
  80347e:	6a 23                	push   $0x23
  803480:	e8 c6 fb ff ff       	call   80304b <syscall>
  803485:	83 c4 18             	add    $0x18,%esp
	return ;
  803488:	90                   	nop
}
  803489:	c9                   	leave  
  80348a:	c3                   	ret    

0080348b <gettst>:
uint32 gettst()
{
  80348b:	55                   	push   %ebp
  80348c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80348e:	6a 00                	push   $0x0
  803490:	6a 00                	push   $0x0
  803492:	6a 00                	push   $0x0
  803494:	6a 00                	push   $0x0
  803496:	6a 00                	push   $0x0
  803498:	6a 24                	push   $0x24
  80349a:	e8 ac fb ff ff       	call   80304b <syscall>
  80349f:	83 c4 18             	add    $0x18,%esp
}
  8034a2:	c9                   	leave  
  8034a3:	c3                   	ret    

008034a4 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8034a4:	55                   	push   %ebp
  8034a5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8034a7:	6a 00                	push   $0x0
  8034a9:	6a 00                	push   $0x0
  8034ab:	6a 00                	push   $0x0
  8034ad:	6a 00                	push   $0x0
  8034af:	6a 00                	push   $0x0
  8034b1:	6a 25                	push   $0x25
  8034b3:	e8 93 fb ff ff       	call   80304b <syscall>
  8034b8:	83 c4 18             	add    $0x18,%esp
  8034bb:	a3 80 60 83 00       	mov    %eax,0x836080
	return uheapPlaceStrategy ;
  8034c0:	a1 80 60 83 00       	mov    0x836080,%eax
}
  8034c5:	c9                   	leave  
  8034c6:	c3                   	ret    

008034c7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8034c7:	55                   	push   %ebp
  8034c8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cd:	a3 80 60 83 00       	mov    %eax,0x836080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8034d2:	6a 00                	push   $0x0
  8034d4:	6a 00                	push   $0x0
  8034d6:	6a 00                	push   $0x0
  8034d8:	6a 00                	push   $0x0
  8034da:	ff 75 08             	pushl  0x8(%ebp)
  8034dd:	6a 26                	push   $0x26
  8034df:	e8 67 fb ff ff       	call   80304b <syscall>
  8034e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8034e7:	90                   	nop
}
  8034e8:	c9                   	leave  
  8034e9:	c3                   	ret    

008034ea <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8034ea:	55                   	push   %ebp
  8034eb:	89 e5                	mov    %esp,%ebp
  8034ed:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8034ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8034f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8034f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	6a 00                	push   $0x0
  8034fc:	53                   	push   %ebx
  8034fd:	51                   	push   %ecx
  8034fe:	52                   	push   %edx
  8034ff:	50                   	push   %eax
  803500:	6a 27                	push   $0x27
  803502:	e8 44 fb ff ff       	call   80304b <syscall>
  803507:	83 c4 18             	add    $0x18,%esp
}
  80350a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80350d:	c9                   	leave  
  80350e:	c3                   	ret    

0080350f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80350f:	55                   	push   %ebp
  803510:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803512:	8b 55 0c             	mov    0xc(%ebp),%edx
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	6a 00                	push   $0x0
  80351a:	6a 00                	push   $0x0
  80351c:	6a 00                	push   $0x0
  80351e:	52                   	push   %edx
  80351f:	50                   	push   %eax
  803520:	6a 28                	push   $0x28
  803522:	e8 24 fb ff ff       	call   80304b <syscall>
  803527:	83 c4 18             	add    $0x18,%esp
}
  80352a:	c9                   	leave  
  80352b:	c3                   	ret    

0080352c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80352c:	55                   	push   %ebp
  80352d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80352f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803532:	8b 55 0c             	mov    0xc(%ebp),%edx
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	6a 00                	push   $0x0
  80353a:	51                   	push   %ecx
  80353b:	ff 75 10             	pushl  0x10(%ebp)
  80353e:	52                   	push   %edx
  80353f:	50                   	push   %eax
  803540:	6a 29                	push   $0x29
  803542:	e8 04 fb ff ff       	call   80304b <syscall>
  803547:	83 c4 18             	add    $0x18,%esp
}
  80354a:	c9                   	leave  
  80354b:	c3                   	ret    

0080354c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80354c:	55                   	push   %ebp
  80354d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80354f:	6a 00                	push   $0x0
  803551:	6a 00                	push   $0x0
  803553:	ff 75 10             	pushl  0x10(%ebp)
  803556:	ff 75 0c             	pushl  0xc(%ebp)
  803559:	ff 75 08             	pushl  0x8(%ebp)
  80355c:	6a 12                	push   $0x12
  80355e:	e8 e8 fa ff ff       	call   80304b <syscall>
  803563:	83 c4 18             	add    $0x18,%esp
	return ;
  803566:	90                   	nop
}
  803567:	c9                   	leave  
  803568:	c3                   	ret    

00803569 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803569:	55                   	push   %ebp
  80356a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80356c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80356f:	8b 45 08             	mov    0x8(%ebp),%eax
  803572:	6a 00                	push   $0x0
  803574:	6a 00                	push   $0x0
  803576:	6a 00                	push   $0x0
  803578:	52                   	push   %edx
  803579:	50                   	push   %eax
  80357a:	6a 2a                	push   $0x2a
  80357c:	e8 ca fa ff ff       	call   80304b <syscall>
  803581:	83 c4 18             	add    $0x18,%esp
	return;
  803584:	90                   	nop
}
  803585:	c9                   	leave  
  803586:	c3                   	ret    

00803587 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  803587:	55                   	push   %ebp
  803588:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80358a:	6a 00                	push   $0x0
  80358c:	6a 00                	push   $0x0
  80358e:	6a 00                	push   $0x0
  803590:	6a 00                	push   $0x0
  803592:	6a 00                	push   $0x0
  803594:	6a 2b                	push   $0x2b
  803596:	e8 b0 fa ff ff       	call   80304b <syscall>
  80359b:	83 c4 18             	add    $0x18,%esp
}
  80359e:	c9                   	leave  
  80359f:	c3                   	ret    

008035a0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8035a0:	55                   	push   %ebp
  8035a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8035a3:	6a 00                	push   $0x0
  8035a5:	6a 00                	push   $0x0
  8035a7:	6a 00                	push   $0x0
  8035a9:	ff 75 0c             	pushl  0xc(%ebp)
  8035ac:	ff 75 08             	pushl  0x8(%ebp)
  8035af:	6a 2d                	push   $0x2d
  8035b1:	e8 95 fa ff ff       	call   80304b <syscall>
  8035b6:	83 c4 18             	add    $0x18,%esp
	return;
  8035b9:	90                   	nop
}
  8035ba:	c9                   	leave  
  8035bb:	c3                   	ret    

008035bc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8035bc:	55                   	push   %ebp
  8035bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8035bf:	6a 00                	push   $0x0
  8035c1:	6a 00                	push   $0x0
  8035c3:	6a 00                	push   $0x0
  8035c5:	ff 75 0c             	pushl  0xc(%ebp)
  8035c8:	ff 75 08             	pushl  0x8(%ebp)
  8035cb:	6a 2c                	push   $0x2c
  8035cd:	e8 79 fa ff ff       	call   80304b <syscall>
  8035d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8035d5:	90                   	nop
}
  8035d6:	c9                   	leave  
  8035d7:	c3                   	ret    

008035d8 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8035d8:	55                   	push   %ebp
  8035d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8035db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035de:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e1:	6a 00                	push   $0x0
  8035e3:	6a 00                	push   $0x0
  8035e5:	6a 00                	push   $0x0
  8035e7:	52                   	push   %edx
  8035e8:	50                   	push   %eax
  8035e9:	6a 2e                	push   $0x2e
  8035eb:	e8 5b fa ff ff       	call   80304b <syscall>
  8035f0:	83 c4 18             	add    $0x18,%esp
}
  8035f3:	90                   	nop
  8035f4:	c9                   	leave  
  8035f5:	c3                   	ret    

008035f6 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  8035f6:	55                   	push   %ebp
  8035f7:	89 e5                	mov    %esp,%ebp
  8035f9:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  8035fc:	81 7d 08 80 e0 81 00 	cmpl   $0x81e080,0x8(%ebp)
  803603:	72 09                	jb     80360e <to_page_va+0x18>
  803605:	81 7d 08 80 60 83 00 	cmpl   $0x836080,0x8(%ebp)
  80360c:	72 14                	jb     803622 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80360e:	83 ec 04             	sub    $0x4,%esp
  803611:	68 78 4d 80 00       	push   $0x804d78
  803616:	6a 15                	push   $0x15
  803618:	68 a3 4d 80 00       	push   $0x804da3
  80361d:	e8 99 0b 00 00       	call   8041bb <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803622:	8b 45 08             	mov    0x8(%ebp),%eax
  803625:	ba 80 e0 81 00       	mov    $0x81e080,%edx
  80362a:	29 d0                	sub    %edx,%eax
  80362c:	c1 f8 02             	sar    $0x2,%eax
  80362f:	89 c2                	mov    %eax,%edx
  803631:	89 d0                	mov    %edx,%eax
  803633:	c1 e0 02             	shl    $0x2,%eax
  803636:	01 d0                	add    %edx,%eax
  803638:	c1 e0 02             	shl    $0x2,%eax
  80363b:	01 d0                	add    %edx,%eax
  80363d:	c1 e0 02             	shl    $0x2,%eax
  803640:	01 d0                	add    %edx,%eax
  803642:	89 c1                	mov    %eax,%ecx
  803644:	c1 e1 08             	shl    $0x8,%ecx
  803647:	01 c8                	add    %ecx,%eax
  803649:	89 c1                	mov    %eax,%ecx
  80364b:	c1 e1 10             	shl    $0x10,%ecx
  80364e:	01 c8                	add    %ecx,%eax
  803650:	01 c0                	add    %eax,%eax
  803652:	01 d0                	add    %edx,%eax
  803654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	c1 e0 0c             	shl    $0xc,%eax
  80365d:	89 c2                	mov    %eax,%edx
  80365f:	a1 84 60 83 00       	mov    0x836084,%eax
  803664:	01 d0                	add    %edx,%eax
}
  803666:	c9                   	leave  
  803667:	c3                   	ret    

00803668 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  803668:	55                   	push   %ebp
  803669:	89 e5                	mov    %esp,%ebp
  80366b:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80366e:	a1 84 60 83 00       	mov    0x836084,%eax
  803673:	8b 55 08             	mov    0x8(%ebp),%edx
  803676:	29 c2                	sub    %eax,%edx
  803678:	89 d0                	mov    %edx,%eax
  80367a:	c1 e8 0c             	shr    $0xc,%eax
  80367d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803680:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803684:	78 09                	js     80368f <to_page_info+0x27>
  803686:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80368d:	7e 14                	jle    8036a3 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  80368f:	83 ec 04             	sub    $0x4,%esp
  803692:	68 bc 4d 80 00       	push   $0x804dbc
  803697:	6a 21                	push   $0x21
  803699:	68 a3 4d 80 00       	push   $0x804da3
  80369e:	e8 18 0b 00 00       	call   8041bb <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8036a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036a6:	89 d0                	mov    %edx,%eax
  8036a8:	01 c0                	add    %eax,%eax
  8036aa:	01 d0                	add    %edx,%eax
  8036ac:	c1 e0 02             	shl    $0x2,%eax
  8036af:	05 80 e0 81 00       	add    $0x81e080,%eax
}
  8036b4:	c9                   	leave  
  8036b5:	c3                   	ret    

008036b6 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8036b6:	55                   	push   %ebp
  8036b7:	89 e5                	mov    %esp,%ebp
  8036b9:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8036bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bf:	05 00 00 00 02       	add    $0x2000000,%eax
  8036c4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036c7:	73 16                	jae    8036df <initialize_dynamic_allocator+0x29>
  8036c9:	68 e0 4d 80 00       	push   $0x804de0
  8036ce:	68 06 4e 80 00       	push   $0x804e06
  8036d3:	6a 2f                	push   $0x2f
  8036d5:	68 a3 4d 80 00       	push   $0x804da3
  8036da:	e8 dc 0a 00 00       	call   8041bb <_panic>
	dynAllocStart = daStart;
  8036df:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e2:	a3 84 60 83 00       	mov    %eax,0x836084
	dynAllocEnd = daEnd;
  8036e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ea:	a3 60 e0 81 00       	mov    %eax,0x81e060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8036ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8036f6:	eb 36                	jmp    80372e <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  8036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fb:	c1 e0 04             	shl    $0x4,%eax
  8036fe:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803703:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370c:	c1 e0 04             	shl    $0x4,%eax
  80370f:	05 a4 60 83 00       	add    $0x8360a4,%eax
  803714:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80371a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371d:	c1 e0 04             	shl    $0x4,%eax
  803720:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803725:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80372b:	ff 45 f4             	incl   -0xc(%ebp)
  80372e:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803732:	7e c4                	jle    8036f8 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  803734:	c7 05 68 e0 81 00 00 	movl   $0x0,0x81e068
  80373b:	00 00 00 
  80373e:	c7 05 6c e0 81 00 00 	movl   $0x0,0x81e06c
  803745:	00 00 00 
  803748:	c7 05 74 e0 81 00 00 	movl   $0x0,0x81e074
  80374f:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803752:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803759:	e9 1b 01 00 00       	jmp    803879 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  80375e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803761:	89 d0                	mov    %edx,%eax
  803763:	01 c0                	add    %eax,%eax
  803765:	01 d0                	add    %edx,%eax
  803767:	c1 e0 02             	shl    $0x2,%eax
  80376a:	05 88 e0 81 00       	add    $0x81e088,%eax
  80376f:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  803774:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803777:	89 d0                	mov    %edx,%eax
  803779:	01 c0                	add    %eax,%eax
  80377b:	01 d0                	add    %edx,%eax
  80377d:	c1 e0 02             	shl    $0x2,%eax
  803780:	05 8a e0 81 00       	add    $0x81e08a,%eax
  803785:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  80378a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80378d:	89 d0                	mov    %edx,%eax
  80378f:	01 c0                	add    %eax,%eax
  803791:	01 d0                	add    %edx,%eax
  803793:	c1 e0 02             	shl    $0x2,%eax
  803796:	05 80 e0 81 00       	add    $0x81e080,%eax
  80379b:	8b 00                	mov    (%eax),%eax
  80379d:	85 c0                	test   %eax,%eax
  80379f:	74 2b                	je     8037cc <initialize_dynamic_allocator+0x116>
  8037a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037a4:	89 d0                	mov    %edx,%eax
  8037a6:	01 c0                	add    %eax,%eax
  8037a8:	01 d0                	add    %edx,%eax
  8037aa:	c1 e0 02             	shl    $0x2,%eax
  8037ad:	05 80 e0 81 00       	add    $0x81e080,%eax
  8037b2:	8b 10                	mov    (%eax),%edx
  8037b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8037b7:	89 c8                	mov    %ecx,%eax
  8037b9:	01 c0                	add    %eax,%eax
  8037bb:	01 c8                	add    %ecx,%eax
  8037bd:	c1 e0 02             	shl    $0x2,%eax
  8037c0:	05 84 e0 81 00       	add    $0x81e084,%eax
  8037c5:	8b 00                	mov    (%eax),%eax
  8037c7:	89 42 04             	mov    %eax,0x4(%edx)
  8037ca:	eb 18                	jmp    8037e4 <initialize_dynamic_allocator+0x12e>
  8037cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037cf:	89 d0                	mov    %edx,%eax
  8037d1:	01 c0                	add    %eax,%eax
  8037d3:	01 d0                	add    %edx,%eax
  8037d5:	c1 e0 02             	shl    $0x2,%eax
  8037d8:	05 84 e0 81 00       	add    $0x81e084,%eax
  8037dd:	8b 00                	mov    (%eax),%eax
  8037df:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8037e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037e7:	89 d0                	mov    %edx,%eax
  8037e9:	01 c0                	add    %eax,%eax
  8037eb:	01 d0                	add    %edx,%eax
  8037ed:	c1 e0 02             	shl    $0x2,%eax
  8037f0:	05 84 e0 81 00       	add    $0x81e084,%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	85 c0                	test   %eax,%eax
  8037f9:	74 2a                	je     803825 <initialize_dynamic_allocator+0x16f>
  8037fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037fe:	89 d0                	mov    %edx,%eax
  803800:	01 c0                	add    %eax,%eax
  803802:	01 d0                	add    %edx,%eax
  803804:	c1 e0 02             	shl    $0x2,%eax
  803807:	05 84 e0 81 00       	add    $0x81e084,%eax
  80380c:	8b 10                	mov    (%eax),%edx
  80380e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803811:	89 c8                	mov    %ecx,%eax
  803813:	01 c0                	add    %eax,%eax
  803815:	01 c8                	add    %ecx,%eax
  803817:	c1 e0 02             	shl    $0x2,%eax
  80381a:	05 80 e0 81 00       	add    $0x81e080,%eax
  80381f:	8b 00                	mov    (%eax),%eax
  803821:	89 02                	mov    %eax,(%edx)
  803823:	eb 18                	jmp    80383d <initialize_dynamic_allocator+0x187>
  803825:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803828:	89 d0                	mov    %edx,%eax
  80382a:	01 c0                	add    %eax,%eax
  80382c:	01 d0                	add    %edx,%eax
  80382e:	c1 e0 02             	shl    $0x2,%eax
  803831:	05 80 e0 81 00       	add    $0x81e080,%eax
  803836:	8b 00                	mov    (%eax),%eax
  803838:	a3 68 e0 81 00       	mov    %eax,0x81e068
  80383d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803840:	89 d0                	mov    %edx,%eax
  803842:	01 c0                	add    %eax,%eax
  803844:	01 d0                	add    %edx,%eax
  803846:	c1 e0 02             	shl    $0x2,%eax
  803849:	05 80 e0 81 00       	add    $0x81e080,%eax
  80384e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803854:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803857:	89 d0                	mov    %edx,%eax
  803859:	01 c0                	add    %eax,%eax
  80385b:	01 d0                	add    %edx,%eax
  80385d:	c1 e0 02             	shl    $0x2,%eax
  803860:	05 84 e0 81 00       	add    $0x81e084,%eax
  803865:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80386b:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803870:	48                   	dec    %eax
  803871:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  803876:	ff 45 f0             	incl   -0x10(%ebp)
  803879:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  803880:	0f 8e d8 fe ff ff    	jle    80375e <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  803886:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  80388d:	e9 9d 00 00 00       	jmp    80392f <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  803892:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  803898:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  80389b:	89 c8                	mov    %ecx,%eax
  80389d:	01 c0                	add    %eax,%eax
  80389f:	01 c8                	add    %ecx,%eax
  8038a1:	c1 e0 02             	shl    $0x2,%eax
  8038a4:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038a9:	89 10                	mov    %edx,(%eax)
  8038ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038ae:	89 d0                	mov    %edx,%eax
  8038b0:	01 c0                	add    %eax,%eax
  8038b2:	01 d0                	add    %edx,%eax
  8038b4:	c1 e0 02             	shl    $0x2,%eax
  8038b7:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038bc:	8b 00                	mov    (%eax),%eax
  8038be:	85 c0                	test   %eax,%eax
  8038c0:	74 1c                	je     8038de <initialize_dynamic_allocator+0x228>
  8038c2:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  8038c8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8038cb:	89 c8                	mov    %ecx,%eax
  8038cd:	01 c0                	add    %eax,%eax
  8038cf:	01 c8                	add    %ecx,%eax
  8038d1:	c1 e0 02             	shl    $0x2,%eax
  8038d4:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038d9:	89 42 04             	mov    %eax,0x4(%edx)
  8038dc:	eb 16                	jmp    8038f4 <initialize_dynamic_allocator+0x23e>
  8038de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038e1:	89 d0                	mov    %edx,%eax
  8038e3:	01 c0                	add    %eax,%eax
  8038e5:	01 d0                	add    %edx,%eax
  8038e7:	c1 e0 02             	shl    $0x2,%eax
  8038ea:	05 80 e0 81 00       	add    $0x81e080,%eax
  8038ef:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  8038f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038f7:	89 d0                	mov    %edx,%eax
  8038f9:	01 c0                	add    %eax,%eax
  8038fb:	01 d0                	add    %edx,%eax
  8038fd:	c1 e0 02             	shl    $0x2,%eax
  803900:	05 80 e0 81 00       	add    $0x81e080,%eax
  803905:	a3 68 e0 81 00       	mov    %eax,0x81e068
  80390a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80390d:	89 d0                	mov    %edx,%eax
  80390f:	01 c0                	add    %eax,%eax
  803911:	01 d0                	add    %edx,%eax
  803913:	c1 e0 02             	shl    $0x2,%eax
  803916:	05 84 e0 81 00       	add    $0x81e084,%eax
  80391b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803921:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803926:	40                   	inc    %eax
  803927:	a3 74 e0 81 00       	mov    %eax,0x81e074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  80392c:	ff 4d ec             	decl   -0x14(%ebp)
  80392f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803933:	0f 89 59 ff ff ff    	jns    803892 <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  803939:	c7 05 44 e0 81 00 01 	movl   $0x1,0x81e044
  803940:	00 00 00 
}
  803943:	90                   	nop
  803944:	c9                   	leave  
  803945:	c3                   	ret    

00803946 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  803946:	55                   	push   %ebp
  803947:	89 e5                	mov    %esp,%ebp
  803949:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80394c:	8b 45 08             	mov    0x8(%ebp),%eax
  80394f:	83 ec 0c             	sub    $0xc,%esp
  803952:	50                   	push   %eax
  803953:	e8 10 fd ff ff       	call   803668 <to_page_info>
  803958:	83 c4 10             	add    $0x10,%esp
  80395b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  80395e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803961:	8b 40 08             	mov    0x8(%eax),%eax
  803964:	0f b7 c0             	movzwl %ax,%eax
}
  803967:	c9                   	leave  
  803968:	c3                   	ret    

00803969 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803969:	55                   	push   %ebp
  80396a:	89 e5                	mov    %esp,%ebp
  80396c:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80396f:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803976:	76 16                	jbe    80398e <alloc_block+0x25>
  803978:	68 1c 4e 80 00       	push   $0x804e1c
  80397d:	68 06 4e 80 00       	push   $0x804e06
  803982:	6a 59                	push   $0x59
  803984:	68 a3 4d 80 00       	push   $0x804da3
  803989:	e8 2d 08 00 00       	call   8041bb <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  80398e:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  803995:	eb 08                	jmp    80399f <alloc_block+0x36>
		allocSize <<= 1;
  803997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399a:	01 c0                	add    %eax,%eax
  80399c:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  80399f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039a5:	73 09                	jae    8039b0 <alloc_block+0x47>
  8039a7:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8039ae:	76 e7                	jbe    803997 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8039b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8039b7:	eb 03                	jmp    8039bc <alloc_block+0x53>
		listIndex++;
  8039b9:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  8039bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039bf:	ba 08 00 00 00       	mov    $0x8,%edx
  8039c4:	88 c1                	mov    %al,%cl
  8039c6:	d3 e2                	shl    %cl,%edx
  8039c8:	89 d0                	mov    %edx,%eax
  8039ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8039cd:	72 ea                	jb     8039b9 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  8039cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8039d5:	e9 f4 00 00 00       	jmp    803ace <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  8039da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039dd:	c1 e0 04             	shl    $0x4,%eax
  8039e0:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8039e5:	8b 00                	mov    (%eax),%eax
  8039e7:	85 c0                	test   %eax,%eax
  8039e9:	0f 84 dc 00 00 00    	je     803acb <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  8039ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039f2:	c1 e0 04             	shl    $0x4,%eax
  8039f5:	05 a0 60 83 00       	add    $0x8360a0,%eax
  8039fa:	8b 00                	mov    (%eax),%eax
  8039fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  8039ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a03:	75 14                	jne    803a19 <alloc_block+0xb0>
  803a05:	83 ec 04             	sub    $0x4,%esp
  803a08:	68 3d 4e 80 00       	push   $0x804e3d
  803a0d:	6a 6b                	push   $0x6b
  803a0f:	68 a3 4d 80 00       	push   $0x804da3
  803a14:	e8 a2 07 00 00       	call   8041bb <_panic>
  803a19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1c:	8b 00                	mov    (%eax),%eax
  803a1e:	85 c0                	test   %eax,%eax
  803a20:	74 10                	je     803a32 <alloc_block+0xc9>
  803a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a25:	8b 00                	mov    (%eax),%eax
  803a27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a2a:	8b 52 04             	mov    0x4(%edx),%edx
  803a2d:	89 50 04             	mov    %edx,0x4(%eax)
  803a30:	eb 14                	jmp    803a46 <alloc_block+0xdd>
  803a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a35:	8b 40 04             	mov    0x4(%eax),%eax
  803a38:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a3b:	c1 e2 04             	shl    $0x4,%edx
  803a3e:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803a44:	89 02                	mov    %eax,(%edx)
  803a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a49:	8b 40 04             	mov    0x4(%eax),%eax
  803a4c:	85 c0                	test   %eax,%eax
  803a4e:	74 0f                	je     803a5f <alloc_block+0xf6>
  803a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a53:	8b 40 04             	mov    0x4(%eax),%eax
  803a56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a59:	8b 12                	mov    (%edx),%edx
  803a5b:	89 10                	mov    %edx,(%eax)
  803a5d:	eb 13                	jmp    803a72 <alloc_block+0x109>
  803a5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a62:	8b 00                	mov    (%eax),%eax
  803a64:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a67:	c1 e2 04             	shl    $0x4,%edx
  803a6a:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803a70:	89 02                	mov    %eax,(%edx)
  803a72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a88:	c1 e0 04             	shl    $0x4,%eax
  803a8b:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803a90:	8b 00                	mov    (%eax),%eax
  803a92:	8d 50 ff             	lea    -0x1(%eax),%edx
  803a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a98:	c1 e0 04             	shl    $0x4,%eax
  803a9b:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803aa0:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  803aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa5:	83 ec 0c             	sub    $0xc,%esp
  803aa8:	50                   	push   %eax
  803aa9:	e8 ba fb ff ff       	call   803668 <to_page_info>
  803aae:	83 c4 10             	add    $0x10,%esp
  803ab1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  803ab4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ab7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803abb:	48                   	dec    %eax
  803abc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803abf:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  803ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac6:	e9 8f 02 00 00       	jmp    803d5a <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  803acb:	ff 45 ec             	incl   -0x14(%ebp)
  803ace:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803ad2:	0f 8e 02 ff ff ff    	jle    8039da <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  803ad8:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803add:	85 c0                	test   %eax,%eax
  803adf:	75 14                	jne    803af5 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  803ae1:	83 ec 04             	sub    $0x4,%esp
  803ae4:	68 5c 4e 80 00       	push   $0x804e5c
  803ae9:	6a 77                	push   $0x77
  803aeb:	68 a3 4d 80 00       	push   $0x804da3
  803af0:	e8 c6 06 00 00       	call   8041bb <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  803af5:	a1 68 e0 81 00       	mov    0x81e068,%eax
  803afa:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  803afd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803b01:	75 14                	jne    803b17 <alloc_block+0x1ae>
  803b03:	83 ec 04             	sub    $0x4,%esp
  803b06:	68 3d 4e 80 00       	push   $0x804e3d
  803b0b:	6a 7a                	push   $0x7a
  803b0d:	68 a3 4d 80 00       	push   $0x804da3
  803b12:	e8 a4 06 00 00       	call   8041bb <_panic>
  803b17:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b1a:	8b 00                	mov    (%eax),%eax
  803b1c:	85 c0                	test   %eax,%eax
  803b1e:	74 10                	je     803b30 <alloc_block+0x1c7>
  803b20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b23:	8b 00                	mov    (%eax),%eax
  803b25:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b28:	8b 52 04             	mov    0x4(%edx),%edx
  803b2b:	89 50 04             	mov    %edx,0x4(%eax)
  803b2e:	eb 0b                	jmp    803b3b <alloc_block+0x1d2>
  803b30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b33:	8b 40 04             	mov    0x4(%eax),%eax
  803b36:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  803b3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b3e:	8b 40 04             	mov    0x4(%eax),%eax
  803b41:	85 c0                	test   %eax,%eax
  803b43:	74 0f                	je     803b54 <alloc_block+0x1eb>
  803b45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b48:	8b 40 04             	mov    0x4(%eax),%eax
  803b4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b4e:	8b 12                	mov    (%edx),%edx
  803b50:	89 10                	mov    %edx,(%eax)
  803b52:	eb 0a                	jmp    803b5e <alloc_block+0x1f5>
  803b54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b57:	8b 00                	mov    (%eax),%eax
  803b59:	a3 68 e0 81 00       	mov    %eax,0x81e068
  803b5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b71:	a1 74 e0 81 00       	mov    0x81e074,%eax
  803b76:	48                   	dec    %eax
  803b77:	a3 74 e0 81 00       	mov    %eax,0x81e074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  803b7c:	83 ec 0c             	sub    $0xc,%esp
  803b7f:	ff 75 dc             	pushl  -0x24(%ebp)
  803b82:	e8 6f fa ff ff       	call   8035f6 <to_page_va>
  803b87:	83 c4 10             	add    $0x10,%esp
  803b8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  803b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b90:	83 ec 0c             	sub    $0xc,%esp
  803b93:	50                   	push   %eax
  803b94:	e8 a0 dc ff ff       	call   801839 <get_page>
  803b99:	83 c4 10             	add    $0x10,%esp
  803b9c:	85 c0                	test   %eax,%eax
  803b9e:	74 14                	je     803bb4 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  803ba0:	83 ec 04             	sub    $0x4,%esp
  803ba3:	68 84 4e 80 00       	push   $0x804e84
  803ba8:	6a 7f                	push   $0x7f
  803baa:	68 a3 4d 80 00       	push   $0x804da3
  803baf:	e8 07 06 00 00       	call   8041bb <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  803bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bba:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  803bbe:	b8 00 10 00 00       	mov    $0x1000,%eax
  803bc3:	ba 00 00 00 00       	mov    $0x0,%edx
  803bc8:	f7 75 f4             	divl   -0xc(%ebp)
  803bcb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803bce:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803bd2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803bd9:	e9 a7 00 00 00       	jmp    803c85 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  803bde:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be4:	01 d0                	add    %edx,%eax
  803be6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  803be9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bed:	75 17                	jne    803c06 <alloc_block+0x29d>
  803bef:	83 ec 04             	sub    $0x4,%esp
  803bf2:	68 ac 4e 80 00       	push   $0x804eac
  803bf7:	68 88 00 00 00       	push   $0x88
  803bfc:	68 a3 4d 80 00       	push   $0x804da3
  803c01:	e8 b5 05 00 00       	call   8041bb <_panic>
  803c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c09:	c1 e0 04             	shl    $0x4,%eax
  803c0c:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803c11:	8b 10                	mov    (%eax),%edx
  803c13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c16:	89 10                	mov    %edx,(%eax)
  803c18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c1b:	8b 00                	mov    (%eax),%eax
  803c1d:	85 c0                	test   %eax,%eax
  803c1f:	74 15                	je     803c36 <alloc_block+0x2cd>
  803c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c24:	c1 e0 04             	shl    $0x4,%eax
  803c27:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803c2c:	8b 00                	mov    (%eax),%eax
  803c2e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c31:	89 50 04             	mov    %edx,0x4(%eax)
  803c34:	eb 11                	jmp    803c47 <alloc_block+0x2de>
  803c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c39:	c1 e0 04             	shl    $0x4,%eax
  803c3c:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803c42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c45:	89 02                	mov    %eax,(%edx)
  803c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c4a:	c1 e0 04             	shl    $0x4,%eax
  803c4d:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803c53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c56:	89 02                	mov    %eax,(%edx)
  803c58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c65:	c1 e0 04             	shl    $0x4,%eax
  803c68:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803c6d:	8b 00                	mov    (%eax),%eax
  803c6f:	8d 50 01             	lea    0x1(%eax),%edx
  803c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c75:	c1 e0 04             	shl    $0x4,%eax
  803c78:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803c7d:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  803c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c82:	01 45 e8             	add    %eax,-0x18(%ebp)
  803c85:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803c8c:	0f 86 4c ff ff ff    	jbe    803bde <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  803c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c95:	c1 e0 04             	shl    $0x4,%eax
  803c98:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803c9d:	8b 00                	mov    (%eax),%eax
  803c9f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  803ca2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ca6:	75 17                	jne    803cbf <alloc_block+0x356>
  803ca8:	83 ec 04             	sub    $0x4,%esp
  803cab:	68 3d 4e 80 00       	push   $0x804e3d
  803cb0:	68 8d 00 00 00       	push   $0x8d
  803cb5:	68 a3 4d 80 00       	push   $0x804da3
  803cba:	e8 fc 04 00 00       	call   8041bb <_panic>
  803cbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cc2:	8b 00                	mov    (%eax),%eax
  803cc4:	85 c0                	test   %eax,%eax
  803cc6:	74 10                	je     803cd8 <alloc_block+0x36f>
  803cc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ccb:	8b 00                	mov    (%eax),%eax
  803ccd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803cd0:	8b 52 04             	mov    0x4(%edx),%edx
  803cd3:	89 50 04             	mov    %edx,0x4(%eax)
  803cd6:	eb 14                	jmp    803cec <alloc_block+0x383>
  803cd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cdb:	8b 40 04             	mov    0x4(%eax),%eax
  803cde:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ce1:	c1 e2 04             	shl    $0x4,%edx
  803ce4:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803cea:	89 02                	mov    %eax,(%edx)
  803cec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cef:	8b 40 04             	mov    0x4(%eax),%eax
  803cf2:	85 c0                	test   %eax,%eax
  803cf4:	74 0f                	je     803d05 <alloc_block+0x39c>
  803cf6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803cf9:	8b 40 04             	mov    0x4(%eax),%eax
  803cfc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803cff:	8b 12                	mov    (%edx),%edx
  803d01:	89 10                	mov    %edx,(%eax)
  803d03:	eb 13                	jmp    803d18 <alloc_block+0x3af>
  803d05:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d08:	8b 00                	mov    (%eax),%eax
  803d0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d0d:	c1 e2 04             	shl    $0x4,%edx
  803d10:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803d16:	89 02                	mov    %eax,(%edx)
  803d18:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d21:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d2e:	c1 e0 04             	shl    $0x4,%eax
  803d31:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803d36:	8b 00                	mov    (%eax),%eax
  803d38:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d3e:	c1 e0 04             	shl    $0x4,%eax
  803d41:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803d46:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  803d48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d4b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803d4f:	48                   	dec    %eax
  803d50:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d53:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  803d57:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  803d5a:	c9                   	leave  
  803d5b:	c3                   	ret    

00803d5c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803d5c:	55                   	push   %ebp
  803d5d:	89 e5                	mov    %esp,%ebp
  803d5f:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803d62:	8b 55 08             	mov    0x8(%ebp),%edx
  803d65:	a1 84 60 83 00       	mov    0x836084,%eax
  803d6a:	39 c2                	cmp    %eax,%edx
  803d6c:	72 0c                	jb     803d7a <free_block+0x1e>
  803d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  803d71:	a1 60 e0 81 00       	mov    0x81e060,%eax
  803d76:	39 c2                	cmp    %eax,%edx
  803d78:	72 19                	jb     803d93 <free_block+0x37>
  803d7a:	68 d0 4e 80 00       	push   $0x804ed0
  803d7f:	68 06 4e 80 00       	push   $0x804e06
  803d84:	68 98 00 00 00       	push   $0x98
  803d89:	68 a3 4d 80 00       	push   $0x804da3
  803d8e:	e8 28 04 00 00       	call   8041bb <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803d93:	8b 45 08             	mov    0x8(%ebp),%eax
  803d96:	83 ec 0c             	sub    $0xc,%esp
  803d99:	50                   	push   %eax
  803d9a:	e8 c9 f8 ff ff       	call   803668 <to_page_info>
  803d9f:	83 c4 10             	add    $0x10,%esp
  803da2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  803da5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803da8:	8b 40 08             	mov    0x8(%eax),%eax
  803dab:	0f b7 c0             	movzwl %ax,%eax
  803dae:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  803db1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803db8:	eb 03                	jmp    803dbd <free_block+0x61>
		listIndex++;
  803dba:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  803dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc0:	ba 08 00 00 00       	mov    $0x8,%edx
  803dc5:	88 c1                	mov    %al,%cl
  803dc7:	d3 e2                	shl    %cl,%edx
  803dc9:	89 d0                	mov    %edx,%eax
  803dcb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803dce:	72 ea                	jb     803dba <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  803dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  803dd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dda:	75 17                	jne    803df3 <free_block+0x97>
  803ddc:	83 ec 04             	sub    $0x4,%esp
  803ddf:	68 ac 4e 80 00       	push   $0x804eac
  803de4:	68 a2 00 00 00       	push   $0xa2
  803de9:	68 a3 4d 80 00       	push   $0x804da3
  803dee:	e8 c8 03 00 00       	call   8041bb <_panic>
  803df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df6:	c1 e0 04             	shl    $0x4,%eax
  803df9:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803dfe:	8b 10                	mov    (%eax),%edx
  803e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e03:	89 10                	mov    %edx,(%eax)
  803e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e08:	8b 00                	mov    (%eax),%eax
  803e0a:	85 c0                	test   %eax,%eax
  803e0c:	74 15                	je     803e23 <free_block+0xc7>
  803e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e11:	c1 e0 04             	shl    $0x4,%eax
  803e14:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803e19:	8b 00                	mov    (%eax),%eax
  803e1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e1e:	89 50 04             	mov    %edx,0x4(%eax)
  803e21:	eb 11                	jmp    803e34 <free_block+0xd8>
  803e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e26:	c1 e0 04             	shl    $0x4,%eax
  803e29:	8d 90 a4 60 83 00    	lea    0x8360a4(%eax),%edx
  803e2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e32:	89 02                	mov    %eax,(%edx)
  803e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e37:	c1 e0 04             	shl    $0x4,%eax
  803e3a:	8d 90 a0 60 83 00    	lea    0x8360a0(%eax),%edx
  803e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e43:	89 02                	mov    %eax,(%edx)
  803e45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e52:	c1 e0 04             	shl    $0x4,%eax
  803e55:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e5a:	8b 00                	mov    (%eax),%eax
  803e5c:	8d 50 01             	lea    0x1(%eax),%edx
  803e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e62:	c1 e0 04             	shl    $0x4,%eax
  803e65:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803e6a:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  803e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e6f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e73:	40                   	inc    %eax
  803e74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e77:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  803e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e7e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803e82:	0f b7 c8             	movzwl %ax,%ecx
  803e85:	b8 00 10 00 00       	mov    $0x1000,%eax
  803e8a:	ba 00 00 00 00       	mov    $0x0,%edx
  803e8f:	f7 75 e8             	divl   -0x18(%ebp)
  803e92:	39 c1                	cmp    %eax,%ecx
  803e94:	0f 85 ed 01 00 00    	jne    804087 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9d:	c1 e0 04             	shl    $0x4,%eax
  803ea0:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803ea5:	8b 00                	mov    (%eax),%eax
  803ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803eaa:	eb 2a                	jmp    803ed6 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  803eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eaf:	83 ec 0c             	sub    $0xc,%esp
  803eb2:	50                   	push   %eax
  803eb3:	e8 b0 f7 ff ff       	call   803668 <to_page_info>
  803eb8:	83 c4 10             	add    $0x10,%esp
  803ebb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803ebe:	75 06                	jne    803ec6 <free_block+0x16a>
				tmp = b;
  803ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ec3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  803ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec9:	c1 e0 04             	shl    $0x4,%eax
  803ecc:	05 a8 60 83 00       	add    $0x8360a8,%eax
  803ed1:	8b 00                	mov    (%eax),%eax
  803ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803ed6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803eda:	74 07                	je     803ee3 <free_block+0x187>
  803edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803edf:	8b 00                	mov    (%eax),%eax
  803ee1:	eb 05                	jmp    803ee8 <free_block+0x18c>
  803ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803eeb:	c1 e2 04             	shl    $0x4,%edx
  803eee:	81 c2 a8 60 83 00    	add    $0x8360a8,%edx
  803ef4:	89 02                	mov    %eax,(%edx)
  803ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef9:	c1 e0 04             	shl    $0x4,%eax
  803efc:	05 a8 60 83 00       	add    $0x8360a8,%eax
  803f01:	8b 00                	mov    (%eax),%eax
  803f03:	85 c0                	test   %eax,%eax
  803f05:	75 a5                	jne    803eac <free_block+0x150>
  803f07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f0b:	75 9f                	jne    803eac <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  803f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f10:	c1 e0 04             	shl    $0x4,%eax
  803f13:	05 a0 60 83 00       	add    $0x8360a0,%eax
  803f18:	8b 00                	mov    (%eax),%eax
  803f1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  803f1d:	e9 cc 00 00 00       	jmp    803fee <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  803f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f25:	8b 00                	mov    (%eax),%eax
  803f27:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  803f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f2d:	83 ec 0c             	sub    $0xc,%esp
  803f30:	50                   	push   %eax
  803f31:	e8 32 f7 ff ff       	call   803668 <to_page_info>
  803f36:	83 c4 10             	add    $0x10,%esp
  803f39:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803f3c:	0f 85 a6 00 00 00    	jne    803fe8 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  803f42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f46:	75 17                	jne    803f5f <free_block+0x203>
  803f48:	83 ec 04             	sub    $0x4,%esp
  803f4b:	68 3d 4e 80 00       	push   $0x804e3d
  803f50:	68 b5 00 00 00       	push   $0xb5
  803f55:	68 a3 4d 80 00       	push   $0x804da3
  803f5a:	e8 5c 02 00 00       	call   8041bb <_panic>
  803f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f62:	8b 00                	mov    (%eax),%eax
  803f64:	85 c0                	test   %eax,%eax
  803f66:	74 10                	je     803f78 <free_block+0x21c>
  803f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f6b:	8b 00                	mov    (%eax),%eax
  803f6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f70:	8b 52 04             	mov    0x4(%edx),%edx
  803f73:	89 50 04             	mov    %edx,0x4(%eax)
  803f76:	eb 14                	jmp    803f8c <free_block+0x230>
  803f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f7b:	8b 40 04             	mov    0x4(%eax),%eax
  803f7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f81:	c1 e2 04             	shl    $0x4,%edx
  803f84:	81 c2 a4 60 83 00    	add    $0x8360a4,%edx
  803f8a:	89 02                	mov    %eax,(%edx)
  803f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f8f:	8b 40 04             	mov    0x4(%eax),%eax
  803f92:	85 c0                	test   %eax,%eax
  803f94:	74 0f                	je     803fa5 <free_block+0x249>
  803f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f99:	8b 40 04             	mov    0x4(%eax),%eax
  803f9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f9f:	8b 12                	mov    (%edx),%edx
  803fa1:	89 10                	mov    %edx,(%eax)
  803fa3:	eb 13                	jmp    803fb8 <free_block+0x25c>
  803fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa8:	8b 00                	mov    (%eax),%eax
  803faa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fad:	c1 e2 04             	shl    $0x4,%edx
  803fb0:	81 c2 a0 60 83 00    	add    $0x8360a0,%edx
  803fb6:	89 02                	mov    %eax,(%edx)
  803fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fce:	c1 e0 04             	shl    $0x4,%eax
  803fd1:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803fd6:	8b 00                	mov    (%eax),%eax
  803fd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  803fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fde:	c1 e0 04             	shl    $0x4,%eax
  803fe1:	05 ac 60 83 00       	add    $0x8360ac,%eax
  803fe6:	89 10                	mov    %edx,(%eax)
			b = next;
  803fe8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803feb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  803fee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ff2:	0f 85 2a ff ff ff    	jne    803f22 <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  803ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ffb:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  804001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804004:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  80400a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80400e:	75 17                	jne    804027 <free_block+0x2cb>
  804010:	83 ec 04             	sub    $0x4,%esp
  804013:	68 ac 4e 80 00       	push   $0x804eac
  804018:	68 bc 00 00 00       	push   $0xbc
  80401d:	68 a3 4d 80 00       	push   $0x804da3
  804022:	e8 94 01 00 00       	call   8041bb <_panic>
  804027:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80402d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804030:	89 10                	mov    %edx,(%eax)
  804032:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804035:	8b 00                	mov    (%eax),%eax
  804037:	85 c0                	test   %eax,%eax
  804039:	74 0d                	je     804048 <free_block+0x2ec>
  80403b:	a1 68 e0 81 00       	mov    0x81e068,%eax
  804040:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804043:	89 50 04             	mov    %edx,0x4(%eax)
  804046:	eb 08                	jmp    804050 <free_block+0x2f4>
  804048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80404b:	a3 6c e0 81 00       	mov    %eax,0x81e06c
  804050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804053:	a3 68 e0 81 00       	mov    %eax,0x81e068
  804058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80405b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804062:	a1 74 e0 81 00       	mov    0x81e074,%eax
  804067:	40                   	inc    %eax
  804068:	a3 74 e0 81 00       	mov    %eax,0x81e074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  80406d:	83 ec 0c             	sub    $0xc,%esp
  804070:	ff 75 ec             	pushl  -0x14(%ebp)
  804073:	e8 7e f5 ff ff       	call   8035f6 <to_page_va>
  804078:	83 c4 10             	add    $0x10,%esp
  80407b:	83 ec 0c             	sub    $0xc,%esp
  80407e:	50                   	push   %eax
  80407f:	e8 fe d7 ff ff       	call   801882 <return_page>
  804084:	83 c4 10             	add    $0x10,%esp
	}
}
  804087:	90                   	nop
  804088:	c9                   	leave  
  804089:	c3                   	ret    

0080408a <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80408a:	55                   	push   %ebp
  80408b:	89 e5                	mov    %esp,%ebp
  80408d:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  804090:	83 ec 04             	sub    $0x4,%esp
  804093:	68 08 4f 80 00       	push   $0x804f08
  804098:	6a 07                	push   $0x7
  80409a:	68 37 4f 80 00       	push   $0x804f37
  80409f:	e8 17 01 00 00       	call   8041bb <_panic>

008040a4 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8040a4:	55                   	push   %ebp
  8040a5:	89 e5                	mov    %esp,%ebp
  8040a7:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  8040aa:	83 ec 04             	sub    $0x4,%esp
  8040ad:	68 48 4f 80 00       	push   $0x804f48
  8040b2:	6a 0b                	push   $0xb
  8040b4:	68 37 4f 80 00       	push   $0x804f37
  8040b9:	e8 fd 00 00 00       	call   8041bb <_panic>

008040be <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8040be:	55                   	push   %ebp
  8040bf:	89 e5                	mov    %esp,%ebp
  8040c1:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8040c4:	83 ec 04             	sub    $0x4,%esp
  8040c7:	68 74 4f 80 00       	push   $0x804f74
  8040cc:	6a 10                	push   $0x10
  8040ce:	68 37 4f 80 00       	push   $0x804f37
  8040d3:	e8 e3 00 00 00       	call   8041bb <_panic>

008040d8 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8040d8:	55                   	push   %ebp
  8040d9:	89 e5                	mov    %esp,%ebp
  8040db:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8040de:	83 ec 04             	sub    $0x4,%esp
  8040e1:	68 a4 4f 80 00       	push   $0x804fa4
  8040e6:	6a 15                	push   $0x15
  8040e8:	68 37 4f 80 00       	push   $0x804f37
  8040ed:	e8 c9 00 00 00       	call   8041bb <_panic>

008040f2 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8040f2:	55                   	push   %ebp
  8040f3:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8040f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f8:	8b 40 10             	mov    0x10(%eax),%eax
}
  8040fb:	5d                   	pop    %ebp
  8040fc:	c3                   	ret    

008040fd <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8040fd:	55                   	push   %ebp
  8040fe:	89 e5                	mov    %esp,%ebp
  804100:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804103:	8b 55 08             	mov    0x8(%ebp),%edx
  804106:	89 d0                	mov    %edx,%eax
  804108:	c1 e0 02             	shl    $0x2,%eax
  80410b:	01 d0                	add    %edx,%eax
  80410d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804114:	01 d0                	add    %edx,%eax
  804116:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80411d:	01 d0                	add    %edx,%eax
  80411f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804126:	01 d0                	add    %edx,%eax
  804128:	c1 e0 04             	shl    $0x4,%eax
  80412b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  80412e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  804135:	0f 31                	rdtsc  
  804137:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80413a:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80413d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804140:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804143:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804146:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  804149:	eb 46                	jmp    804191 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80414b:	0f 31                	rdtsc  
  80414d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  804150:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804153:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804156:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804159:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80415c:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80415f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804165:	29 c2                	sub    %eax,%edx
  804167:	89 d0                	mov    %edx,%eax
  804169:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80416c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80416f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804172:	89 d1                	mov    %edx,%ecx
  804174:	29 c1                	sub    %eax,%ecx
  804176:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804179:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80417c:	39 c2                	cmp    %eax,%edx
  80417e:	0f 97 c0             	seta   %al
  804181:	0f b6 c0             	movzbl %al,%eax
  804184:	29 c1                	sub    %eax,%ecx
  804186:	89 c8                	mov    %ecx,%eax
  804188:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80418b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80418e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  804191:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804194:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804197:	72 b2                	jb     80414b <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804199:	90                   	nop
  80419a:	c9                   	leave  
  80419b:	c3                   	ret    

0080419c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80419c:	55                   	push   %ebp
  80419d:	89 e5                	mov    %esp,%ebp
  80419f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8041a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8041a9:	eb 03                	jmp    8041ae <busy_wait+0x12>
  8041ab:	ff 45 fc             	incl   -0x4(%ebp)
  8041ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8041b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8041b4:	72 f5                	jb     8041ab <busy_wait+0xf>
	return i;
  8041b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8041b9:	c9                   	leave  
  8041ba:	c3                   	ret    

008041bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8041bb:	55                   	push   %ebp
  8041bc:	89 e5                	mov    %esp,%ebp
  8041be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8041c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8041c4:	83 c0 04             	add    $0x4,%eax
  8041c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8041ca:	a1 3c 61 83 00       	mov    0x83613c,%eax
  8041cf:	85 c0                	test   %eax,%eax
  8041d1:	74 16                	je     8041e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8041d3:	a1 3c 61 83 00       	mov    0x83613c,%eax
  8041d8:	83 ec 08             	sub    $0x8,%esp
  8041db:	50                   	push   %eax
  8041dc:	68 d4 4f 80 00       	push   $0x804fd4
  8041e1:	e8 1a c7 ff ff       	call   800900 <cprintf>
  8041e6:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8041e9:	a1 04 60 80 00       	mov    0x806004,%eax
  8041ee:	83 ec 0c             	sub    $0xc,%esp
  8041f1:	ff 75 0c             	pushl  0xc(%ebp)
  8041f4:	ff 75 08             	pushl  0x8(%ebp)
  8041f7:	50                   	push   %eax
  8041f8:	68 dc 4f 80 00       	push   $0x804fdc
  8041fd:	6a 74                	push   $0x74
  8041ff:	e8 29 c7 ff ff       	call   80092d <cprintf_colored>
  804204:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  804207:	8b 45 10             	mov    0x10(%ebp),%eax
  80420a:	83 ec 08             	sub    $0x8,%esp
  80420d:	ff 75 f4             	pushl  -0xc(%ebp)
  804210:	50                   	push   %eax
  804211:	e8 7b c6 ff ff       	call   800891 <vcprintf>
  804216:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  804219:	83 ec 08             	sub    $0x8,%esp
  80421c:	6a 00                	push   $0x0
  80421e:	68 04 50 80 00       	push   $0x805004
  804223:	e8 69 c6 ff ff       	call   800891 <vcprintf>
  804228:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80422b:	e8 e2 c5 ff ff       	call   800812 <exit>

	// should not return here
	while (1) ;
  804230:	eb fe                	jmp    804230 <_panic+0x75>

00804232 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  804232:	55                   	push   %ebp
  804233:	89 e5                	mov    %esp,%ebp
  804235:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  804238:	a1 20 60 80 00       	mov    0x806020,%eax
  80423d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  804243:	8b 45 0c             	mov    0xc(%ebp),%eax
  804246:	39 c2                	cmp    %eax,%edx
  804248:	74 14                	je     80425e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80424a:	83 ec 04             	sub    $0x4,%esp
  80424d:	68 08 50 80 00       	push   $0x805008
  804252:	6a 26                	push   $0x26
  804254:	68 54 50 80 00       	push   $0x805054
  804259:	e8 5d ff ff ff       	call   8041bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80425e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  804265:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80426c:	e9 c5 00 00 00       	jmp    804336 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  804271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804274:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80427b:	8b 45 08             	mov    0x8(%ebp),%eax
  80427e:	01 d0                	add    %edx,%eax
  804280:	8b 00                	mov    (%eax),%eax
  804282:	85 c0                	test   %eax,%eax
  804284:	75 08                	jne    80428e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  804286:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  804289:	e9 a5 00 00 00       	jmp    804333 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80428e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804295:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80429c:	eb 69                	jmp    804307 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80429e:	a1 20 60 80 00       	mov    0x806020,%eax
  8042a3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8042a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042ac:	89 d0                	mov    %edx,%eax
  8042ae:	01 c0                	add    %eax,%eax
  8042b0:	01 d0                	add    %edx,%eax
  8042b2:	c1 e0 03             	shl    $0x3,%eax
  8042b5:	01 c8                	add    %ecx,%eax
  8042b7:	8a 40 04             	mov    0x4(%eax),%al
  8042ba:	84 c0                	test   %al,%al
  8042bc:	75 46                	jne    804304 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8042be:	a1 20 60 80 00       	mov    0x806020,%eax
  8042c3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8042c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042cc:	89 d0                	mov    %edx,%eax
  8042ce:	01 c0                	add    %eax,%eax
  8042d0:	01 d0                	add    %edx,%eax
  8042d2:	c1 e0 03             	shl    $0x3,%eax
  8042d5:	01 c8                	add    %ecx,%eax
  8042d7:	8b 00                	mov    (%eax),%eax
  8042d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8042dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8042e4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8042e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042e9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8042f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8042f3:	01 c8                	add    %ecx,%eax
  8042f5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8042f7:	39 c2                	cmp    %eax,%edx
  8042f9:	75 09                	jne    804304 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8042fb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  804302:	eb 15                	jmp    804319 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804304:	ff 45 e8             	incl   -0x18(%ebp)
  804307:	a1 20 60 80 00       	mov    0x806020,%eax
  80430c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  804312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804315:	39 c2                	cmp    %eax,%edx
  804317:	77 85                	ja     80429e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  804319:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80431d:	75 14                	jne    804333 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80431f:	83 ec 04             	sub    $0x4,%esp
  804322:	68 60 50 80 00       	push   $0x805060
  804327:	6a 3a                	push   $0x3a
  804329:	68 54 50 80 00       	push   $0x805054
  80432e:	e8 88 fe ff ff       	call   8041bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  804333:	ff 45 f0             	incl   -0x10(%ebp)
  804336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804339:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80433c:	0f 8c 2f ff ff ff    	jl     804271 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  804342:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804349:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  804350:	eb 26                	jmp    804378 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  804352:	a1 20 60 80 00       	mov    0x806020,%eax
  804357:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80435d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804360:	89 d0                	mov    %edx,%eax
  804362:	01 c0                	add    %eax,%eax
  804364:	01 d0                	add    %edx,%eax
  804366:	c1 e0 03             	shl    $0x3,%eax
  804369:	01 c8                	add    %ecx,%eax
  80436b:	8a 40 04             	mov    0x4(%eax),%al
  80436e:	3c 01                	cmp    $0x1,%al
  804370:	75 03                	jne    804375 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  804372:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  804375:	ff 45 e0             	incl   -0x20(%ebp)
  804378:	a1 20 60 80 00       	mov    0x806020,%eax
  80437d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  804383:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804386:	39 c2                	cmp    %eax,%edx
  804388:	77 c8                	ja     804352 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80438a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80438d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  804390:	74 14                	je     8043a6 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  804392:	83 ec 04             	sub    $0x4,%esp
  804395:	68 b4 50 80 00       	push   $0x8050b4
  80439a:	6a 44                	push   $0x44
  80439c:	68 54 50 80 00       	push   $0x805054
  8043a1:	e8 15 fe ff ff       	call   8041bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8043a6:	90                   	nop
  8043a7:	c9                   	leave  
  8043a8:	c3                   	ret    
  8043a9:	66 90                	xchg   %ax,%ax
  8043ab:	90                   	nop

008043ac <__udivdi3>:
  8043ac:	55                   	push   %ebp
  8043ad:	57                   	push   %edi
  8043ae:	56                   	push   %esi
  8043af:	53                   	push   %ebx
  8043b0:	83 ec 1c             	sub    $0x1c,%esp
  8043b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8043b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8043bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8043c3:	89 ca                	mov    %ecx,%edx
  8043c5:	89 f8                	mov    %edi,%eax
  8043c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8043cb:	85 f6                	test   %esi,%esi
  8043cd:	75 2d                	jne    8043fc <__udivdi3+0x50>
  8043cf:	39 cf                	cmp    %ecx,%edi
  8043d1:	77 65                	ja     804438 <__udivdi3+0x8c>
  8043d3:	89 fd                	mov    %edi,%ebp
  8043d5:	85 ff                	test   %edi,%edi
  8043d7:	75 0b                	jne    8043e4 <__udivdi3+0x38>
  8043d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8043de:	31 d2                	xor    %edx,%edx
  8043e0:	f7 f7                	div    %edi
  8043e2:	89 c5                	mov    %eax,%ebp
  8043e4:	31 d2                	xor    %edx,%edx
  8043e6:	89 c8                	mov    %ecx,%eax
  8043e8:	f7 f5                	div    %ebp
  8043ea:	89 c1                	mov    %eax,%ecx
  8043ec:	89 d8                	mov    %ebx,%eax
  8043ee:	f7 f5                	div    %ebp
  8043f0:	89 cf                	mov    %ecx,%edi
  8043f2:	89 fa                	mov    %edi,%edx
  8043f4:	83 c4 1c             	add    $0x1c,%esp
  8043f7:	5b                   	pop    %ebx
  8043f8:	5e                   	pop    %esi
  8043f9:	5f                   	pop    %edi
  8043fa:	5d                   	pop    %ebp
  8043fb:	c3                   	ret    
  8043fc:	39 ce                	cmp    %ecx,%esi
  8043fe:	77 28                	ja     804428 <__udivdi3+0x7c>
  804400:	0f bd fe             	bsr    %esi,%edi
  804403:	83 f7 1f             	xor    $0x1f,%edi
  804406:	75 40                	jne    804448 <__udivdi3+0x9c>
  804408:	39 ce                	cmp    %ecx,%esi
  80440a:	72 0a                	jb     804416 <__udivdi3+0x6a>
  80440c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804410:	0f 87 9e 00 00 00    	ja     8044b4 <__udivdi3+0x108>
  804416:	b8 01 00 00 00       	mov    $0x1,%eax
  80441b:	89 fa                	mov    %edi,%edx
  80441d:	83 c4 1c             	add    $0x1c,%esp
  804420:	5b                   	pop    %ebx
  804421:	5e                   	pop    %esi
  804422:	5f                   	pop    %edi
  804423:	5d                   	pop    %ebp
  804424:	c3                   	ret    
  804425:	8d 76 00             	lea    0x0(%esi),%esi
  804428:	31 ff                	xor    %edi,%edi
  80442a:	31 c0                	xor    %eax,%eax
  80442c:	89 fa                	mov    %edi,%edx
  80442e:	83 c4 1c             	add    $0x1c,%esp
  804431:	5b                   	pop    %ebx
  804432:	5e                   	pop    %esi
  804433:	5f                   	pop    %edi
  804434:	5d                   	pop    %ebp
  804435:	c3                   	ret    
  804436:	66 90                	xchg   %ax,%ax
  804438:	89 d8                	mov    %ebx,%eax
  80443a:	f7 f7                	div    %edi
  80443c:	31 ff                	xor    %edi,%edi
  80443e:	89 fa                	mov    %edi,%edx
  804440:	83 c4 1c             	add    $0x1c,%esp
  804443:	5b                   	pop    %ebx
  804444:	5e                   	pop    %esi
  804445:	5f                   	pop    %edi
  804446:	5d                   	pop    %ebp
  804447:	c3                   	ret    
  804448:	bd 20 00 00 00       	mov    $0x20,%ebp
  80444d:	89 eb                	mov    %ebp,%ebx
  80444f:	29 fb                	sub    %edi,%ebx
  804451:	89 f9                	mov    %edi,%ecx
  804453:	d3 e6                	shl    %cl,%esi
  804455:	89 c5                	mov    %eax,%ebp
  804457:	88 d9                	mov    %bl,%cl
  804459:	d3 ed                	shr    %cl,%ebp
  80445b:	89 e9                	mov    %ebp,%ecx
  80445d:	09 f1                	or     %esi,%ecx
  80445f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804463:	89 f9                	mov    %edi,%ecx
  804465:	d3 e0                	shl    %cl,%eax
  804467:	89 c5                	mov    %eax,%ebp
  804469:	89 d6                	mov    %edx,%esi
  80446b:	88 d9                	mov    %bl,%cl
  80446d:	d3 ee                	shr    %cl,%esi
  80446f:	89 f9                	mov    %edi,%ecx
  804471:	d3 e2                	shl    %cl,%edx
  804473:	8b 44 24 08          	mov    0x8(%esp),%eax
  804477:	88 d9                	mov    %bl,%cl
  804479:	d3 e8                	shr    %cl,%eax
  80447b:	09 c2                	or     %eax,%edx
  80447d:	89 d0                	mov    %edx,%eax
  80447f:	89 f2                	mov    %esi,%edx
  804481:	f7 74 24 0c          	divl   0xc(%esp)
  804485:	89 d6                	mov    %edx,%esi
  804487:	89 c3                	mov    %eax,%ebx
  804489:	f7 e5                	mul    %ebp
  80448b:	39 d6                	cmp    %edx,%esi
  80448d:	72 19                	jb     8044a8 <__udivdi3+0xfc>
  80448f:	74 0b                	je     80449c <__udivdi3+0xf0>
  804491:	89 d8                	mov    %ebx,%eax
  804493:	31 ff                	xor    %edi,%edi
  804495:	e9 58 ff ff ff       	jmp    8043f2 <__udivdi3+0x46>
  80449a:	66 90                	xchg   %ax,%ax
  80449c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8044a0:	89 f9                	mov    %edi,%ecx
  8044a2:	d3 e2                	shl    %cl,%edx
  8044a4:	39 c2                	cmp    %eax,%edx
  8044a6:	73 e9                	jae    804491 <__udivdi3+0xe5>
  8044a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8044ab:	31 ff                	xor    %edi,%edi
  8044ad:	e9 40 ff ff ff       	jmp    8043f2 <__udivdi3+0x46>
  8044b2:	66 90                	xchg   %ax,%ax
  8044b4:	31 c0                	xor    %eax,%eax
  8044b6:	e9 37 ff ff ff       	jmp    8043f2 <__udivdi3+0x46>
  8044bb:	90                   	nop

008044bc <__umoddi3>:
  8044bc:	55                   	push   %ebp
  8044bd:	57                   	push   %edi
  8044be:	56                   	push   %esi
  8044bf:	53                   	push   %ebx
  8044c0:	83 ec 1c             	sub    $0x1c,%esp
  8044c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8044c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8044cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8044cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8044d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8044d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8044db:	89 f3                	mov    %esi,%ebx
  8044dd:	89 fa                	mov    %edi,%edx
  8044df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044e3:	89 34 24             	mov    %esi,(%esp)
  8044e6:	85 c0                	test   %eax,%eax
  8044e8:	75 1a                	jne    804504 <__umoddi3+0x48>
  8044ea:	39 f7                	cmp    %esi,%edi
  8044ec:	0f 86 a2 00 00 00    	jbe    804594 <__umoddi3+0xd8>
  8044f2:	89 c8                	mov    %ecx,%eax
  8044f4:	89 f2                	mov    %esi,%edx
  8044f6:	f7 f7                	div    %edi
  8044f8:	89 d0                	mov    %edx,%eax
  8044fa:	31 d2                	xor    %edx,%edx
  8044fc:	83 c4 1c             	add    $0x1c,%esp
  8044ff:	5b                   	pop    %ebx
  804500:	5e                   	pop    %esi
  804501:	5f                   	pop    %edi
  804502:	5d                   	pop    %ebp
  804503:	c3                   	ret    
  804504:	39 f0                	cmp    %esi,%eax
  804506:	0f 87 ac 00 00 00    	ja     8045b8 <__umoddi3+0xfc>
  80450c:	0f bd e8             	bsr    %eax,%ebp
  80450f:	83 f5 1f             	xor    $0x1f,%ebp
  804512:	0f 84 ac 00 00 00    	je     8045c4 <__umoddi3+0x108>
  804518:	bf 20 00 00 00       	mov    $0x20,%edi
  80451d:	29 ef                	sub    %ebp,%edi
  80451f:	89 fe                	mov    %edi,%esi
  804521:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804525:	89 e9                	mov    %ebp,%ecx
  804527:	d3 e0                	shl    %cl,%eax
  804529:	89 d7                	mov    %edx,%edi
  80452b:	89 f1                	mov    %esi,%ecx
  80452d:	d3 ef                	shr    %cl,%edi
  80452f:	09 c7                	or     %eax,%edi
  804531:	89 e9                	mov    %ebp,%ecx
  804533:	d3 e2                	shl    %cl,%edx
  804535:	89 14 24             	mov    %edx,(%esp)
  804538:	89 d8                	mov    %ebx,%eax
  80453a:	d3 e0                	shl    %cl,%eax
  80453c:	89 c2                	mov    %eax,%edx
  80453e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804542:	d3 e0                	shl    %cl,%eax
  804544:	89 44 24 04          	mov    %eax,0x4(%esp)
  804548:	8b 44 24 08          	mov    0x8(%esp),%eax
  80454c:	89 f1                	mov    %esi,%ecx
  80454e:	d3 e8                	shr    %cl,%eax
  804550:	09 d0                	or     %edx,%eax
  804552:	d3 eb                	shr    %cl,%ebx
  804554:	89 da                	mov    %ebx,%edx
  804556:	f7 f7                	div    %edi
  804558:	89 d3                	mov    %edx,%ebx
  80455a:	f7 24 24             	mull   (%esp)
  80455d:	89 c6                	mov    %eax,%esi
  80455f:	89 d1                	mov    %edx,%ecx
  804561:	39 d3                	cmp    %edx,%ebx
  804563:	0f 82 87 00 00 00    	jb     8045f0 <__umoddi3+0x134>
  804569:	0f 84 91 00 00 00    	je     804600 <__umoddi3+0x144>
  80456f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804573:	29 f2                	sub    %esi,%edx
  804575:	19 cb                	sbb    %ecx,%ebx
  804577:	89 d8                	mov    %ebx,%eax
  804579:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80457d:	d3 e0                	shl    %cl,%eax
  80457f:	89 e9                	mov    %ebp,%ecx
  804581:	d3 ea                	shr    %cl,%edx
  804583:	09 d0                	or     %edx,%eax
  804585:	89 e9                	mov    %ebp,%ecx
  804587:	d3 eb                	shr    %cl,%ebx
  804589:	89 da                	mov    %ebx,%edx
  80458b:	83 c4 1c             	add    $0x1c,%esp
  80458e:	5b                   	pop    %ebx
  80458f:	5e                   	pop    %esi
  804590:	5f                   	pop    %edi
  804591:	5d                   	pop    %ebp
  804592:	c3                   	ret    
  804593:	90                   	nop
  804594:	89 fd                	mov    %edi,%ebp
  804596:	85 ff                	test   %edi,%edi
  804598:	75 0b                	jne    8045a5 <__umoddi3+0xe9>
  80459a:	b8 01 00 00 00       	mov    $0x1,%eax
  80459f:	31 d2                	xor    %edx,%edx
  8045a1:	f7 f7                	div    %edi
  8045a3:	89 c5                	mov    %eax,%ebp
  8045a5:	89 f0                	mov    %esi,%eax
  8045a7:	31 d2                	xor    %edx,%edx
  8045a9:	f7 f5                	div    %ebp
  8045ab:	89 c8                	mov    %ecx,%eax
  8045ad:	f7 f5                	div    %ebp
  8045af:	89 d0                	mov    %edx,%eax
  8045b1:	e9 44 ff ff ff       	jmp    8044fa <__umoddi3+0x3e>
  8045b6:	66 90                	xchg   %ax,%ax
  8045b8:	89 c8                	mov    %ecx,%eax
  8045ba:	89 f2                	mov    %esi,%edx
  8045bc:	83 c4 1c             	add    $0x1c,%esp
  8045bf:	5b                   	pop    %ebx
  8045c0:	5e                   	pop    %esi
  8045c1:	5f                   	pop    %edi
  8045c2:	5d                   	pop    %ebp
  8045c3:	c3                   	ret    
  8045c4:	3b 04 24             	cmp    (%esp),%eax
  8045c7:	72 06                	jb     8045cf <__umoddi3+0x113>
  8045c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8045cd:	77 0f                	ja     8045de <__umoddi3+0x122>
  8045cf:	89 f2                	mov    %esi,%edx
  8045d1:	29 f9                	sub    %edi,%ecx
  8045d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8045d7:	89 14 24             	mov    %edx,(%esp)
  8045da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8045de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8045e2:	8b 14 24             	mov    (%esp),%edx
  8045e5:	83 c4 1c             	add    $0x1c,%esp
  8045e8:	5b                   	pop    %ebx
  8045e9:	5e                   	pop    %esi
  8045ea:	5f                   	pop    %edi
  8045eb:	5d                   	pop    %ebp
  8045ec:	c3                   	ret    
  8045ed:	8d 76 00             	lea    0x0(%esi),%esi
  8045f0:	2b 04 24             	sub    (%esp),%eax
  8045f3:	19 fa                	sbb    %edi,%edx
  8045f5:	89 d1                	mov    %edx,%ecx
  8045f7:	89 c6                	mov    %eax,%esi
  8045f9:	e9 71 ff ff ff       	jmp    80456f <__umoddi3+0xb3>
  8045fe:	66 90                	xchg   %ax,%ax
  804600:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804604:	72 ea                	jb     8045f0 <__umoddi3+0x134>
  804606:	89 d9                	mov    %ebx,%ecx
  804608:	e9 62 ff ff ff       	jmp    80456f <__umoddi3+0xb3>
