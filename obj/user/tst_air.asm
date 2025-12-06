
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 91 0f 00 00       	call   800fc7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 03 00 00    	sub    $0x39c,%esp
	int envID = sys_getenvid();
  800044:	e8 1e 40 00 00       	call   804067 <sys_getenvid>
  800049:	89 45 a0             	mov    %eax,-0x60(%ebp)

	int numOfClerks = 3;
  80004c:	c7 45 9c 03 00 00 00 	movl   $0x3,-0x64(%ebp)
	int agentCapacity = 20;
  800053:	c7 45 e4 14 00 00 00 	movl   $0x14,-0x1c(%ebp)
	int numOfCustomers = 30;
  80005a:	c7 45 e0 1e 00 00 00 	movl   $0x1e,-0x20(%ebp)
	int flight1NumOfCustomers = numOfCustomers/3;
  800061:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800064:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800069:	f7 e9                	imul   %ecx
  80006b:	c1 f9 1f             	sar    $0x1f,%ecx
  80006e:	89 d0                	mov    %edx,%eax
  800070:	29 c8                	sub    %ecx,%eax
  800072:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int flight2NumOfCustomers = numOfCustomers/3;
  800075:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800078:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80007d:	f7 e9                	imul   %ecx
  80007f:	c1 f9 1f             	sar    $0x1f,%ecx
  800082:	89 d0                	mov    %edx,%eax
  800084:	29 c8                	sub    %ecx,%eax
  800086:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int flight3NumOfCustomers = numOfCustomers - (flight1NumOfCustomers + flight2NumOfCustomers);
  800089:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80008c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80008f:	01 c2                	add    %eax,%edx
  800091:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800094:	29 d0                	sub    %edx,%eax
  800096:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int flight1NumOfTickets = 15;
  800099:	c7 45 d0 0f 00 00 00 	movl   $0xf,-0x30(%ebp)
	int flight2NumOfTickets = 8;
  8000a0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%ebp)
	// *************************************************************************************************
	/// Reading Inputs *********************************************************************************
	// *************************************************************************************************
	char Line[255] ;
	char Chose;
	sys_lock_cons();
  8000a7:	e8 5b 3d 00 00       	call   803e07 <sys_lock_cons>
	{
		cprintf("\n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 80 51 80 00       	push   $0x805180
  8000b4:	e8 8c 13 00 00       	call   801445 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 84 51 80 00       	push   $0x805184
  8000c4:	e8 7c 13 00 00       	call   801445 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! AIR PLANE RESERVATION !!!!\n");
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 a8 51 80 00       	push   $0x8051a8
  8000d4:	e8 6c 13 00 00       	call   801445 <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 84 51 80 00       	push   $0x805184
  8000e4:	e8 5c 13 00 00       	call   801445 <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 80 51 80 00       	push   $0x805180
  8000f4:	e8 4c 13 00 00       	call   801445 <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
		cprintf("%~Default #customers = %d (equally divided over the 3 flights).\n"
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800102:	ff 75 cc             	pushl  -0x34(%ebp)
  800105:	ff 75 d0             	pushl  -0x30(%ebp)
  800108:	ff 75 e0             	pushl  -0x20(%ebp)
  80010b:	68 cc 51 80 00       	push   $0x8051cc
  800110:	e8 30 13 00 00       	call   801445 <cprintf>
  800115:	83 c4 20             	add    $0x20,%esp
				"Flight1 Tickets = %d, Flight2 Tickets = %d\n"
				"Agent Capacity = %d\n", numOfCustomers, flight1NumOfTickets, flight2NumOfTickets, agentCapacity) ;
		Chose = 0 ;
  800118:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
		while (Chose != 'y' && Chose != 'n' && Chose != 'Y' && Chose != 'N')
  80011c:	eb 42                	jmp    800160 <_main+0x128>
		{
			cprintf("%~Do you want to change these values(y/n)? ") ;
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 4c 52 80 00       	push   $0x80524c
  800126:	e8 1a 13 00 00       	call   801445 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012e:	e8 77 0e 00 00       	call   800faa <getchar>
  800133:	88 45 cb             	mov    %al,-0x35(%ebp)
			cputchar(Chose);
  800136:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	50                   	push   %eax
  80013e:	e8 48 0e 00 00       	call   800f8b <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	6a 0a                	push   $0xa
  80014b:	e8 3b 0e 00 00       	call   800f8b <cputchar>
  800150:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	6a 0a                	push   $0xa
  800158:	e8 2e 0e 00 00       	call   800f8b <cputchar>
  80015d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
		cprintf("%~Default #customers = %d (equally divided over the 3 flights).\n"
				"Flight1 Tickets = %d, Flight2 Tickets = %d\n"
				"Agent Capacity = %d\n", numOfCustomers, flight1NumOfTickets, flight2NumOfTickets, agentCapacity) ;
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n' && Chose != 'Y' && Chose != 'N')
  800160:	80 7d cb 79          	cmpb   $0x79,-0x35(%ebp)
  800164:	74 12                	je     800178 <_main+0x140>
  800166:	80 7d cb 6e          	cmpb   $0x6e,-0x35(%ebp)
  80016a:	74 0c                	je     800178 <_main+0x140>
  80016c:	80 7d cb 59          	cmpb   $0x59,-0x35(%ebp)
  800170:	74 06                	je     800178 <_main+0x140>
  800172:	80 7d cb 4e          	cmpb   $0x4e,-0x35(%ebp)
  800176:	75 a6                	jne    80011e <_main+0xe6>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		if (Chose == 'y' || Chose == 'Y')
  800178:	80 7d cb 79          	cmpb   $0x79,-0x35(%ebp)
  80017c:	74 0a                	je     800188 <_main+0x150>
  80017e:	80 7d cb 59          	cmpb   $0x59,-0x35(%ebp)
  800182:	0f 85 ea 00 00 00    	jne    800272 <_main+0x23a>
		{
			readline("Enter the capacity of the agent: ", Line);
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800191:	50                   	push   %eax
  800192:	68 78 52 80 00       	push   $0x805278
  800197:	e8 82 19 00 00       	call   801b1e <readline>
  80019c:	83 c4 10             	add    $0x10,%esp
			agentCapacity = strtol(Line, NULL, 10) ;
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	6a 0a                	push   $0xa
  8001a4:	6a 00                	push   $0x0
  8001a6:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001ac:	50                   	push   %eax
  8001ad:	e8 83 1f 00 00       	call   802135 <strtol>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			readline("Enter the total number of customers: ", Line);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001c1:	50                   	push   %eax
  8001c2:	68 9c 52 80 00       	push   $0x80529c
  8001c7:	e8 52 19 00 00       	call   801b1e <readline>
  8001cc:	83 c4 10             	add    $0x10,%esp
			numOfCustomers = strtol(Line, NULL, 10) ;
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 0a                	push   $0xa
  8001d4:	6a 00                	push   $0x0
  8001d6:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001dc:	50                   	push   %eax
  8001dd:	e8 53 1f 00 00       	call   802135 <strtol>
  8001e2:	83 c4 10             	add    $0x10,%esp
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			flight1NumOfCustomers = flight2NumOfCustomers = numOfCustomers / 3;
  8001e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8001eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8001f0:	f7 e9                	imul   %ecx
  8001f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8001f5:	89 d0                	mov    %edx,%eax
  8001f7:	29 c8                	sub    %ecx,%eax
  8001f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
			flight3NumOfCustomers = numOfCustomers - (flight1NumOfCustomers + flight2NumOfCustomers);
  800202:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800205:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800208:	01 c2                	add    %eax,%edx
  80020a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80020d:	29 d0                	sub    %edx,%eax
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			readline("Enter # tickets of flight#1: ", Line);
  800212:	83 ec 08             	sub    $0x8,%esp
  800215:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  80021b:	50                   	push   %eax
  80021c:	68 c2 52 80 00       	push   $0x8052c2
  800221:	e8 f8 18 00 00       	call   801b1e <readline>
  800226:	83 c4 10             	add    $0x10,%esp
			flight1NumOfTickets = strtol(Line, NULL, 10) ;
  800229:	83 ec 04             	sub    $0x4,%esp
  80022c:	6a 0a                	push   $0xa
  80022e:	6a 00                	push   $0x0
  800230:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	e8 f9 1e 00 00       	call   802135 <strtol>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 d0             	mov    %eax,-0x30(%ebp)
			readline("Enter # tickets of flight#2: ", Line);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	68 e0 52 80 00       	push   $0x8052e0
  800251:	e8 c8 18 00 00       	call   801b1e <readline>
  800256:	83 c4 10             	add    $0x10,%esp
			flight2NumOfTickets = strtol(Line, NULL, 10) ;
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	6a 0a                	push   $0xa
  80025e:	6a 00                	push   $0x0
  800260:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800266:	50                   	push   %eax
  800267:	e8 c9 1e 00 00       	call   802135 <strtol>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		}
	}
	sys_unlock_cons();
  800272:	e8 aa 3b 00 00       	call   803e21 <sys_unlock_cons>

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************
	char _isOpened[] = "isOpened";
  800277:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  80027d:	bb f6 56 80 00       	mov    $0x8056f6,%ebx
  800282:	ba 09 00 00 00       	mov    $0x9,%edx
  800287:	89 c7                	mov    %eax,%edi
  800289:	89 de                	mov    %ebx,%esi
  80028b:	89 d1                	mov    %edx,%ecx
  80028d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _agentCapacity[] = "agentCapacity";
  80028f:	8d 85 42 fe ff ff    	lea    -0x1be(%ebp),%eax
  800295:	bb ff 56 80 00       	mov    $0x8056ff,%ebx
  80029a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80029f:	89 c7                	mov    %eax,%edi
  8002a1:	89 de                	mov    %ebx,%esi
  8002a3:	89 d1                	mov    %edx,%ecx
  8002a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  8002a7:	8d 85 38 fe ff ff    	lea    -0x1c8(%ebp),%eax
  8002ad:	bb 0d 57 80 00       	mov    $0x80570d,%ebx
  8002b2:	ba 0a 00 00 00       	mov    $0xa,%edx
  8002b7:	89 c7                	mov    %eax,%edi
  8002b9:	89 de                	mov    %ebx,%esi
  8002bb:	89 d1                	mov    %edx,%ecx
  8002bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  8002bf:	8d 85 2c fe ff ff    	lea    -0x1d4(%ebp),%eax
  8002c5:	bb 17 57 80 00       	mov    $0x805717,%ebx
  8002ca:	ba 03 00 00 00       	mov    $0x3,%edx
  8002cf:	89 c7                	mov    %eax,%edi
  8002d1:	89 de                	mov    %ebx,%esi
  8002d3:	89 d1                	mov    %edx,%ecx
  8002d5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Customers[] = "flight1Customers";
  8002d7:	8d 85 1b fe ff ff    	lea    -0x1e5(%ebp),%eax
  8002dd:	bb 23 57 80 00       	mov    $0x805723,%ebx
  8002e2:	ba 11 00 00 00       	mov    $0x11,%edx
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	89 de                	mov    %ebx,%esi
  8002eb:	89 d1                	mov    %edx,%ecx
  8002ed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Customers[] = "flight2Customers";
  8002ef:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
  8002f5:	bb 34 57 80 00       	mov    $0x805734,%ebx
  8002fa:	ba 11 00 00 00       	mov    $0x11,%edx
  8002ff:	89 c7                	mov    %eax,%edi
  800301:	89 de                	mov    %ebx,%esi
  800303:	89 d1                	mov    %edx,%ecx
  800305:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight3Customers[] = "flight3Customers";
  800307:	8d 85 f9 fd ff ff    	lea    -0x207(%ebp),%eax
  80030d:	bb 45 57 80 00       	mov    $0x805745,%ebx
  800312:	ba 11 00 00 00       	mov    $0x11,%edx
  800317:	89 c7                	mov    %eax,%edi
  800319:	89 de                	mov    %ebx,%esi
  80031b:	89 d1                	mov    %edx,%ecx
  80031d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  80031f:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  800325:	bb 56 57 80 00       	mov    $0x805756,%ebx
  80032a:	ba 0f 00 00 00       	mov    $0xf,%edx
  80032f:	89 c7                	mov    %eax,%edi
  800331:	89 de                	mov    %ebx,%esi
  800333:	89 d1                	mov    %edx,%ecx
  800335:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  800337:	8d 85 db fd ff ff    	lea    -0x225(%ebp),%eax
  80033d:	bb 65 57 80 00       	mov    $0x805765,%ebx
  800342:	ba 0f 00 00 00       	mov    $0xf,%edx
  800347:	89 c7                	mov    %eax,%edi
  800349:	89 de                	mov    %ebx,%esi
  80034b:	89 d1                	mov    %edx,%ecx
  80034d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  80034f:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
  800355:	bb 74 57 80 00       	mov    $0x805774,%ebx
  80035a:	ba 15 00 00 00       	mov    $0x15,%edx
  80035f:	89 c7                	mov    %eax,%edi
  800361:	89 de                	mov    %ebx,%esi
  800363:	89 d1                	mov    %edx,%ecx
  800365:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  800367:	8d 85 b1 fd ff ff    	lea    -0x24f(%ebp),%eax
  80036d:	bb 89 57 80 00       	mov    $0x805789,%ebx
  800372:	ba 15 00 00 00       	mov    $0x15,%edx
  800377:	89 c7                	mov    %eax,%edi
  800379:	89 de                	mov    %ebx,%esi
  80037b:	89 d1                	mov    %edx,%ecx
  80037d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  80037f:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  800385:	bb 9e 57 80 00       	mov    $0x80579e,%ebx
  80038a:	ba 11 00 00 00       	mov    $0x11,%edx
  80038f:	89 c7                	mov    %eax,%edi
  800391:	89 de                	mov    %ebx,%esi
  800393:	89 d1                	mov    %edx,%ecx
  800395:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  800397:	8d 85 8f fd ff ff    	lea    -0x271(%ebp),%eax
  80039d:	bb af 57 80 00       	mov    $0x8057af,%ebx
  8003a2:	ba 11 00 00 00       	mov    $0x11,%edx
  8003a7:	89 c7                	mov    %eax,%edi
  8003a9:	89 de                	mov    %ebx,%esi
  8003ab:	89 d1                	mov    %edx,%ecx
  8003ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8003af:	8d 85 7e fd ff ff    	lea    -0x282(%ebp),%eax
  8003b5:	bb c0 57 80 00       	mov    $0x8057c0,%ebx
  8003ba:	ba 11 00 00 00       	mov    $0x11,%edx
  8003bf:	89 c7                	mov    %eax,%edi
  8003c1:	89 de                	mov    %ebx,%esi
  8003c3:	89 d1                	mov    %edx,%ecx
  8003c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  8003c7:	8d 85 75 fd ff ff    	lea    -0x28b(%ebp),%eax
  8003cd:	bb d1 57 80 00       	mov    $0x8057d1,%ebx
  8003d2:	ba 09 00 00 00       	mov    $0x9,%edx
  8003d7:	89 c7                	mov    %eax,%edi
  8003d9:	89 de                	mov    %ebx,%esi
  8003db:	89 d1                	mov    %edx,%ecx
  8003dd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  8003df:	8d 85 6b fd ff ff    	lea    -0x295(%ebp),%eax
  8003e5:	bb da 57 80 00       	mov    $0x8057da,%ebx
  8003ea:	ba 0a 00 00 00       	mov    $0xa,%edx
  8003ef:	89 c7                	mov    %eax,%edi
  8003f1:	89 de                	mov    %ebx,%esi
  8003f3:	89 d1                	mov    %edx,%ecx
  8003f5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  8003f7:	8d 85 60 fd ff ff    	lea    -0x2a0(%ebp),%eax
  8003fd:	bb e4 57 80 00       	mov    $0x8057e4,%ebx
  800402:	ba 0b 00 00 00       	mov    $0xb,%edx
  800407:	89 c7                	mov    %eax,%edi
  800409:	89 de                	mov    %ebx,%esi
  80040b:	89 d1                	mov    %edx,%ecx
  80040d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80040f:	8d 85 54 fd ff ff    	lea    -0x2ac(%ebp),%eax
  800415:	bb ef 57 80 00       	mov    $0x8057ef,%ebx
  80041a:	ba 03 00 00 00       	mov    $0x3,%edx
  80041f:	89 c7                	mov    %eax,%edi
  800421:	89 de                	mov    %ebx,%esi
  800423:	89 d1                	mov    %edx,%ecx
  800425:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800427:	8d 85 4a fd ff ff    	lea    -0x2b6(%ebp),%eax
  80042d:	bb fb 57 80 00       	mov    $0x8057fb,%ebx
  800432:	ba 0a 00 00 00       	mov    $0xa,%edx
  800437:	89 c7                	mov    %eax,%edi
  800439:	89 de                	mov    %ebx,%esi
  80043b:	89 d1                	mov    %edx,%ecx
  80043d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80043f:	8d 85 40 fd ff ff    	lea    -0x2c0(%ebp),%eax
  800445:	bb 05 58 80 00       	mov    $0x805805,%ebx
  80044a:	ba 0a 00 00 00       	mov    $0xa,%edx
  80044f:	89 c7                	mov    %eax,%edi
  800451:	89 de                	mov    %ebx,%esi
  800453:	89 d1                	mov    %edx,%ecx
  800455:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  800457:	c7 85 3a fd ff ff 63 	movl   $0x72656c63,-0x2c6(%ebp)
  80045e:	6c 65 72 
  800461:	66 c7 85 3e fd ff ff 	movw   $0x6b,-0x2c2(%ebp)
  800468:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  80046a:	8d 85 2c fd ff ff    	lea    -0x2d4(%ebp),%eax
  800470:	bb 0f 58 80 00       	mov    $0x80580f,%ebx
  800475:	ba 0e 00 00 00       	mov    $0xe,%edx
  80047a:	89 c7                	mov    %eax,%edi
  80047c:	89 de                	mov    %ebx,%esi
  80047e:	89 d1                	mov    %edx,%ecx
  800480:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800482:	8d 85 1d fd ff ff    	lea    -0x2e3(%ebp),%eax
  800488:	bb 1d 58 80 00       	mov    $0x80581d,%ebx
  80048d:	ba 0f 00 00 00       	mov    $0xf,%edx
  800492:	89 c7                	mov    %eax,%edi
  800494:	89 de                	mov    %ebx,%esi
  800496:	89 d1                	mov    %edx,%ecx
  800498:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _clerkTerminated[] = "clerkTerminated";
  80049a:	8d 85 0d fd ff ff    	lea    -0x2f3(%ebp),%eax
  8004a0:	bb 2c 58 80 00       	mov    $0x80582c,%ebx
  8004a5:	ba 04 00 00 00       	mov    $0x4,%edx
  8004aa:	89 c7                	mov    %eax,%edi
  8004ac:	89 de                	mov    %ebx,%esi
  8004ae:	89 d1                	mov    %edx,%ecx
  8004b0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8004b2:	8d 85 06 fd ff ff    	lea    -0x2fa(%ebp),%eax
  8004b8:	bb 3c 58 80 00       	mov    $0x80583c,%ebx
  8004bd:	ba 07 00 00 00       	mov    $0x7,%edx
  8004c2:	89 c7                	mov    %eax,%edi
  8004c4:	89 de                	mov    %ebx,%esi
  8004c6:	89 d1                	mov    %edx,%ecx
  8004c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  8004ca:	8d 85 ff fc ff ff    	lea    -0x301(%ebp),%eax
  8004d0:	bb 43 58 80 00       	mov    $0x805843,%ebx
  8004d5:	ba 07 00 00 00       	mov    $0x7,%edx
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	89 de                	mov    %ebx,%esi
  8004de:	89 d1                	mov    %edx,%ecx
  8004e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*(numOfCustomers+1), 1);
  8004e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e5:	40                   	inc    %eax
  8004e6:	c1 e0 03             	shl    $0x3,%eax
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	6a 01                	push   $0x1
  8004ee:	50                   	push   %eax
  8004ef:	8d 85 38 fe ff ff    	lea    -0x1c8(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 81 28 00 00       	call   802d7c <smalloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 98             	mov    %eax,-0x68(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);

	int* flight1Customers = smalloc(_flight1Customers, sizeof(int), 1); *flight1Customers = flight1NumOfCustomers;
  800501:	83 ec 04             	sub    $0x4,%esp
  800504:	6a 01                	push   $0x1
  800506:	6a 04                	push   $0x4
  800508:	8d 85 1b fe ff ff    	lea    -0x1e5(%ebp),%eax
  80050e:	50                   	push   %eax
  80050f:	e8 68 28 00 00       	call   802d7c <smalloc>
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80051a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80051d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800520:	89 10                	mov    %edx,(%eax)
	int* flight2Customers = smalloc(_flight2Customers, sizeof(int), 1); *flight2Customers = flight2NumOfCustomers;
  800522:	83 ec 04             	sub    $0x4,%esp
  800525:	6a 01                	push   $0x1
  800527:	6a 04                	push   $0x4
  800529:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	e8 47 28 00 00       	call   802d7c <smalloc>
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	89 45 90             	mov    %eax,-0x70(%ebp)
  80053b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80053e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800541:	89 10                	mov    %edx,(%eax)
	int* flight3Customers = smalloc(_flight3Customers, sizeof(int), 1); *flight3Customers = flight3NumOfCustomers;
  800543:	83 ec 04             	sub    $0x4,%esp
  800546:	6a 01                	push   $0x1
  800548:	6a 04                	push   $0x4
  80054a:	8d 85 f9 fd ff ff    	lea    -0x207(%ebp),%eax
  800550:	50                   	push   %eax
  800551:	e8 26 28 00 00       	call   802d7c <smalloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 8c             	mov    %eax,-0x74(%ebp)
  80055c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80055f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800562:	89 10                	mov    %edx,(%eax)

	int* isOpened = smalloc(_isOpened, sizeof(int), 0);
  800564:	83 ec 04             	sub    $0x4,%esp
  800567:	6a 00                	push   $0x0
  800569:	6a 04                	push   $0x4
  80056b:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  800571:	50                   	push   %eax
  800572:	e8 05 28 00 00       	call   802d7c <smalloc>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	89 45 88             	mov    %eax,-0x78(%ebp)
	*isOpened = 1;
  80057d:	8b 45 88             	mov    -0x78(%ebp),%eax
  800580:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800586:	83 ec 04             	sub    $0x4,%esp
  800589:	6a 01                	push   $0x1
  80058b:	6a 04                	push   $0x4
  80058d:	8d 85 2c fe ff ff    	lea    -0x1d4(%ebp),%eax
  800593:	50                   	push   %eax
  800594:	e8 e3 27 00 00       	call   802d7c <smalloc>
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	89 45 84             	mov    %eax,-0x7c(%ebp)
	*custCounter = 0;
  80059f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  8005a8:	83 ec 04             	sub    $0x4,%esp
  8005ab:	6a 01                	push   $0x1
  8005ad:	6a 04                	push   $0x4
  8005af:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  8005b5:	50                   	push   %eax
  8005b6:	e8 c1 27 00 00       	call   802d7c <smalloc>
  8005bb:	83 c4 10             	add    $0x10,%esp
  8005be:	89 45 80             	mov    %eax,-0x80(%ebp)
	*flight1Counter = flight1NumOfTickets;
  8005c1:	8b 45 80             	mov    -0x80(%ebp),%eax
  8005c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005c7:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	6a 01                	push   $0x1
  8005ce:	6a 04                	push   $0x4
  8005d0:	8d 85 db fd ff ff    	lea    -0x225(%ebp),%eax
  8005d6:	50                   	push   %eax
  8005d7:	e8 a0 27 00 00       	call   802d7c <smalloc>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*flight2Counter = flight2NumOfTickets;
  8005e5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005eb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8005ee:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	6a 01                	push   $0x1
  8005f5:	6a 04                	push   $0x4
  8005f7:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
  8005fd:	50                   	push   %eax
  8005fe:	e8 79 27 00 00       	call   802d7c <smalloc>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*flight1BookedCounter = 0;
  80060c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800612:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	6a 01                	push   $0x1
  80061d:	6a 04                	push   $0x4
  80061f:	8d 85 b1 fd ff ff    	lea    -0x24f(%ebp),%eax
  800625:	50                   	push   %eax
  800626:	e8 51 27 00 00       	call   802d7c <smalloc>
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	*flight2BookedCounter = 0;
  800634:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80063a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  800640:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800643:	c1 e0 02             	shl    $0x2,%eax
  800646:	83 ec 04             	sub    $0x4,%esp
  800649:	6a 01                	push   $0x1
  80064b:	50                   	push   %eax
  80064c:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  800652:	50                   	push   %eax
  800653:	e8 24 27 00 00       	call   802d7c <smalloc>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  800661:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800664:	c1 e0 02             	shl    $0x2,%eax
  800667:	83 ec 04             	sub    $0x4,%esp
  80066a:	6a 01                	push   $0x1
  80066c:	50                   	push   %eax
  80066d:	8d 85 8f fd ff ff    	lea    -0x271(%ebp),%eax
  800673:	50                   	push   %eax
  800674:	e8 03 27 00 00       	call   802d7c <smalloc>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*(numOfCustomers+1), 1);
  800682:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800685:	40                   	inc    %eax
  800686:	c1 e0 02             	shl    $0x2,%eax
  800689:	83 ec 04             	sub    $0x4,%esp
  80068c:	6a 01                	push   $0x1
  80068e:	50                   	push   %eax
  80068f:	8d 85 7e fd ff ff    	lea    -0x282(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	e8 e1 26 00 00       	call   802d7c <smalloc>
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	6a 01                	push   $0x1
  8006a9:	6a 04                	push   $0x4
  8006ab:	8d 85 75 fd ff ff    	lea    -0x28b(%ebp),%eax
  8006b1:	50                   	push   %eax
  8006b2:	e8 c5 26 00 00       	call   802d7c <smalloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
	*queue_in = 0;
  8006c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  8006cc:	83 ec 04             	sub    $0x4,%esp
  8006cf:	6a 01                	push   $0x1
  8006d1:	6a 04                	push   $0x4
  8006d3:	8d 85 6b fd ff ff    	lea    -0x295(%ebp),%eax
  8006d9:	50                   	push   %eax
  8006da:	e8 9d 26 00 00       	call   802d7c <smalloc>
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	*queue_out = 0;
  8006e8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8006ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	struct semaphore capacity = create_semaphore(_agentCapacity, agentCapacity);
  8006f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006f7:	8d 85 f8 fc ff ff    	lea    -0x308(%ebp),%eax
  8006fd:	83 ec 04             	sub    $0x4,%esp
  800700:	52                   	push   %edx
  800701:	8d 95 42 fe ff ff    	lea    -0x1be(%ebp),%edx
  800707:	52                   	push   %edx
  800708:	50                   	push   %eax
  800709:	e8 c9 46 00 00       	call   804dd7 <create_semaphore>
  80070e:	83 c4 0c             	add    $0xc,%esp

	struct semaphore flight1CS = create_semaphore(_flight1CS, 1);
  800711:	8d 85 f4 fc ff ff    	lea    -0x30c(%ebp),%eax
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	6a 01                	push   $0x1
  80071c:	8d 95 4a fd ff ff    	lea    -0x2b6(%ebp),%edx
  800722:	52                   	push   %edx
  800723:	50                   	push   %eax
  800724:	e8 ae 46 00 00       	call   804dd7 <create_semaphore>
  800729:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  80072c:	8d 85 f0 fc ff ff    	lea    -0x310(%ebp),%eax
  800732:	83 ec 04             	sub    $0x4,%esp
  800735:	6a 01                	push   $0x1
  800737:	8d 95 40 fd ff ff    	lea    -0x2c0(%ebp),%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	e8 93 46 00 00       	call   804dd7 <create_semaphore>
  800744:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  800747:	8d 85 ec fc ff ff    	lea    -0x314(%ebp),%eax
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	6a 01                	push   $0x1
  800752:	8d 95 2c fd ff ff    	lea    -0x2d4(%ebp),%edx
  800758:	52                   	push   %edx
  800759:	50                   	push   %eax
  80075a:	e8 78 46 00 00       	call   804dd7 <create_semaphore>
  80075f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  800762:	8d 85 e8 fc ff ff    	lea    -0x318(%ebp),%eax
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	6a 01                	push   $0x1
  80076d:	8d 95 54 fd ff ff    	lea    -0x2ac(%ebp),%edx
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	e8 5d 46 00 00       	call   804dd7 <create_semaphore>
  80077a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  80077d:	8d 85 e4 fc ff ff    	lea    -0x31c(%ebp),%eax
  800783:	83 ec 04             	sub    $0x4,%esp
  800786:	6a 03                	push   $0x3
  800788:	8d 95 3a fd ff ff    	lea    -0x2c6(%ebp),%edx
  80078e:	52                   	push   %edx
  80078f:	50                   	push   %eax
  800790:	e8 42 46 00 00       	call   804dd7 <create_semaphore>
  800795:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  800798:	8d 85 e0 fc ff ff    	lea    -0x320(%ebp),%eax
  80079e:	83 ec 04             	sub    $0x4,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	8d 95 60 fd ff ff    	lea    -0x2a0(%ebp),%edx
  8007a9:	52                   	push   %edx
  8007aa:	50                   	push   %eax
  8007ab:	e8 27 46 00 00       	call   804dd7 <create_semaphore>
  8007b0:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  8007b3:	8d 85 dc fc ff ff    	lea    -0x324(%ebp),%eax
  8007b9:	83 ec 04             	sub    $0x4,%esp
  8007bc:	6a 00                	push   $0x0
  8007be:	8d 95 1d fd ff ff    	lea    -0x2e3(%ebp),%edx
  8007c4:	52                   	push   %edx
  8007c5:	50                   	push   %eax
  8007c6:	e8 0c 46 00 00       	call   804dd7 <create_semaphore>
  8007cb:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerkTerminated = create_semaphore(_clerkTerminated, 0);
  8007ce:	8d 85 d8 fc ff ff    	lea    -0x328(%ebp),%eax
  8007d4:	83 ec 04             	sub    $0x4,%esp
  8007d7:	6a 00                	push   $0x0
  8007d9:	8d 95 0d fd ff ff    	lea    -0x2f3(%ebp),%edx
  8007df:	52                   	push   %edx
  8007e0:	50                   	push   %eax
  8007e1:	e8 f1 45 00 00       	call   804dd7 <create_semaphore>
  8007e6:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  8007e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ec:	c1 e0 02             	shl    $0x2,%eax
  8007ef:	83 ec 04             	sub    $0x4,%esp
  8007f2:	6a 01                	push   $0x1
  8007f4:	50                   	push   %eax
  8007f5:	68 fe 52 80 00       	push   $0x8052fe
  8007fa:	e8 7d 25 00 00       	call   802d7c <smalloc>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)

	int s=0;
  800808:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  80080f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  800816:	e9 9a 00 00 00       	jmp    8008b5 <_main+0x87d>
	{
		char prefix[30]="cust_finished";
  80081b:	8d 85 ae fc ff ff    	lea    -0x352(%ebp),%eax
  800821:	bb 4a 58 80 00       	mov    $0x80584a,%ebx
  800826:	ba 0e 00 00 00       	mov    $0xe,%edx
  80082b:	89 c7                	mov    %eax,%edi
  80082d:	89 de                	mov    %ebx,%esi
  80082f:	89 d1                	mov    %edx,%ecx
  800831:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800833:	8d 95 bc fc ff ff    	lea    -0x344(%ebp),%edx
  800839:	b9 04 00 00 00       	mov    $0x4,%ecx
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
  800843:	89 d7                	mov    %edx,%edi
  800845:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	8d 85 a9 fc ff ff    	lea    -0x357(%ebp),%eax
  800850:	50                   	push   %eax
  800851:	ff 75 c4             	pushl  -0x3c(%ebp)
  800854:	e8 22 1a 00 00       	call   80227b <ltostr>
  800859:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  80085c:	83 ec 04             	sub    $0x4,%esp
  80085f:	8d 85 77 fc ff ff    	lea    -0x389(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	8d 85 a9 fc ff ff    	lea    -0x357(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	8d 85 ae fc ff ff    	lea    -0x352(%ebp),%eax
  800873:	50                   	push   %eax
  800874:	e8 db 1a 00 00       	call   802354 <strcconcat>
  800879:	83 c4 10             	add    $0x10,%esp
		//sys_createSemaphore(sname, 0);
		cust_finished[s] = create_semaphore(sname, 0);
  80087c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80087f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800886:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80088c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80088f:	8d 85 64 fc ff ff    	lea    -0x39c(%ebp),%eax
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	6a 00                	push   $0x0
  80089a:	8d 95 77 fc ff ff    	lea    -0x389(%ebp),%edx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	e8 30 45 00 00       	call   804dd7 <create_semaphore>
  8008a7:	83 c4 0c             	add    $0xc,%esp
  8008aa:	8b 85 64 fc ff ff    	mov    -0x39c(%ebp),%eax
  8008b0:	89 03                	mov    %eax,(%ebx)
	struct semaphore clerkTerminated = create_semaphore(_clerkTerminated, 0);

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  8008b2:	ff 45 c4             	incl   -0x3c(%ebp)
  8008b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8008b8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8008bb:	0f 8c 5a ff ff ff    	jl     80081b <_main+0x7e3>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//clerks
	uint32 envId;
	for (int k = 0; k < numOfClerks; ++k)
  8008c1:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8008c8:	eb 50                	jmp    80091a <_main+0x8e2>
	{
		envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8008ca:	a1 20 70 80 00       	mov    0x807020,%eax
  8008cf:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8008d5:	a1 20 70 80 00       	mov    0x807020,%eax
  8008da:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8008e0:	89 c1                	mov    %eax,%ecx
  8008e2:	a1 20 70 80 00       	mov    0x807020,%eax
  8008e7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8008ed:	52                   	push   %edx
  8008ee:	51                   	push   %ecx
  8008ef:	50                   	push   %eax
  8008f0:	8d 85 06 fd ff ff    	lea    -0x2fa(%ebp),%eax
  8008f6:	50                   	push   %eax
  8008f7:	e8 16 37 00 00       	call   804012 <sys_create_env>
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		sys_run_env(envId);
  800905:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80090b:	83 ec 0c             	sub    $0xc,%esp
  80090e:	50                   	push   %eax
  80090f:	e8 1c 37 00 00       	call   804030 <sys_run_env>
  800914:	83 c4 10             	add    $0x10,%esp
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//clerks
	uint32 envId;
	for (int k = 0; k < numOfClerks; ++k)
  800917:	ff 45 c0             	incl   -0x40(%ebp)
  80091a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80091d:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800920:	7c a8                	jl     8008ca <_main+0x892>
		sys_run_env(envId);
	}

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800922:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  800929:	eb 70                	jmp    80099b <_main+0x963>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80092b:	a1 20 70 80 00       	mov    0x807020,%eax
  800930:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800936:	a1 20 70 80 00       	mov    0x807020,%eax
  80093b:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800941:	89 c1                	mov    %eax,%ecx
  800943:	a1 20 70 80 00       	mov    0x807020,%eax
  800948:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80094e:	52                   	push   %edx
  80094f:	51                   	push   %ecx
  800950:	50                   	push   %eax
  800951:	8d 85 ff fc ff ff    	lea    -0x301(%ebp),%eax
  800957:	50                   	push   %eax
  800958:	e8 b5 36 00 00       	call   804012 <sys_create_env>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800966:	83 bd 58 ff ff ff ef 	cmpl   $0xffffffef,-0xa8(%ebp)
  80096d:	75 17                	jne    800986 <_main+0x94e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	68 14 53 80 00       	push   $0x805314
  800977:	68 b5 00 00 00       	push   $0xb5
  80097c:	68 5a 53 80 00       	push   $0x80535a
  800981:	e8 f1 07 00 00       	call   801177 <_panic>

		sys_run_env(envId);
  800986:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 9b 36 00 00       	call   804030 <sys_run_env>
  800995:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envId);
	}

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800998:	ff 45 bc             	incl   -0x44(%ebp)
  80099b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80099e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a1:	7c 88                	jl     80092b <_main+0x8f3>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8009a3:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  8009aa:	eb 14                	jmp    8009c0 <_main+0x988>
	{
		wait_semaphore(custTerminated);
  8009ac:	83 ec 0c             	sub    $0xc,%esp
  8009af:	ff b5 dc fc ff ff    	pushl  -0x324(%ebp)
  8009b5:	e8 51 44 00 00       	call   804e0b <wait_semaphore>
  8009ba:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8009bd:	ff 45 bc             	incl   -0x44(%ebp)
  8009c0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8009c3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009c6:	7c e4                	jl     8009ac <_main+0x974>
	{
		wait_semaphore(custTerminated);
	}

	env_sleep(1500);
  8009c8:	83 ec 0c             	sub    $0xc,%esp
  8009cb:	68 dc 05 00 00       	push   $0x5dc
  8009d0:	e8 75 44 00 00       	call   804e4a <env_sleep>
  8009d5:	83 c4 10             	add    $0x10,%esp
	int b;

	sys_lock_cons();
  8009d8:	e8 2a 34 00 00       	call   803e07 <sys_lock_cons>
	{
	//print out the results
	for(b=0; b< (*flight1BookedCounter);++b)
  8009dd:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  8009e4:	eb 4b                	jmp    800a31 <_main+0x9f9>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  8009e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	8b 00                	mov    (%eax),%eax
  8009fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a01:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a04:	01 d0                	add    %edx,%eax
  800a06:	8b 10                	mov    (%eax),%edx
  800a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a0b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a12:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a18:	01 c8                	add    %ecx,%eax
  800a1a:	8b 00                	mov    (%eax),%eax
  800a1c:	83 ec 04             	sub    $0x4,%esp
  800a1f:	52                   	push   %edx
  800a20:	50                   	push   %eax
  800a21:	68 6c 53 80 00       	push   $0x80536c
  800a26:	e8 1a 0a 00 00       	call   801445 <cprintf>
  800a2b:	83 c4 10             	add    $0x10,%esp
	int b;

	sys_lock_cons();
	{
	//print out the results
	for(b=0; b< (*flight1BookedCounter);++b)
  800a2e:	ff 45 b8             	incl   -0x48(%ebp)
  800a31:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800a3c:	7f a8                	jg     8009e6 <_main+0x9ae>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800a3e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800a45:	eb 4b                	jmp    800a92 <_main+0xa5a>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800a47:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a51:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a57:	01 d0                	add    %edx,%eax
  800a59:	8b 00                	mov    (%eax),%eax
  800a5b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a62:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a65:	01 d0                	add    %edx,%eax
  800a67:	8b 10                	mov    (%eax),%edx
  800a69:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a6c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a73:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a79:	01 c8                	add    %ecx,%eax
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	83 ec 04             	sub    $0x4,%esp
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	68 9c 53 80 00       	push   $0x80539c
  800a87:	e8 b9 09 00 00       	call   801445 <cprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800a8f:	ff 45 b8             	incl   -0x48(%ebp)
  800a92:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800a98:	8b 00                	mov    (%eax),%eax
  800a9a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800a9d:	7f a8                	jg     800a47 <_main+0xa0f>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}
	}
	sys_unlock_cons();
  800a9f:	e8 7d 33 00 00       	call   803e21 <sys_unlock_cons>

	int numOfBookings = 0;
  800aa4:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	int numOfFCusts[3] = {0};
  800aab:	8d 95 cc fc ff ff    	lea    -0x334(%ebp),%edx
  800ab1:	b9 03 00 00 00       	mov    $0x3,%ecx
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  800abb:	89 d7                	mov    %edx,%edi
  800abd:	f3 ab                	rep stos %eax,%es:(%edi)

	for(b=0; b< numOfCustomers;++b)
  800abf:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800ac6:	eb 3d                	jmp    800b05 <_main+0xacd>
	{
		if (custs[b].booked)
  800ac8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800acb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800ad2:	8b 45 98             	mov    -0x68(%ebp),%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	74 24                	je     800b02 <_main+0xaca>
		{
			numOfBookings++;
  800ade:	ff 45 b4             	incl   -0x4c(%ebp)
			numOfFCusts[custs[b].flightType - 1]++ ;
  800ae1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ae4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800aeb:	8b 45 98             	mov    -0x68(%ebp),%eax
  800aee:	01 d0                	add    %edx,%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	48                   	dec    %eax
  800af3:	8b 94 85 cc fc ff ff 	mov    -0x334(%ebp,%eax,4),%edx
  800afa:	42                   	inc    %edx
  800afb:	89 94 85 cc fc ff ff 	mov    %edx,-0x334(%ebp,%eax,4)
	sys_unlock_cons();

	int numOfBookings = 0;
	int numOfFCusts[3] = {0};

	for(b=0; b< numOfCustomers;++b)
  800b02:	ff 45 b8             	incl   -0x48(%ebp)
  800b05:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b08:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b0b:	7c bb                	jl     800ac8 <_main+0xa90>
			numOfBookings++;
			numOfFCusts[custs[b].flightType - 1]++ ;
		}
	}

	sys_lock_cons();
  800b0d:	e8 f5 32 00 00       	call   803e07 <sys_lock_cons>
	{
	cprintf("%~[*] FINAL RESULTS:\n");
  800b12:	83 ec 0c             	sub    $0xc,%esp
  800b15:	68 cc 53 80 00       	push   $0x8053cc
  800b1a:	e8 26 09 00 00       	call   801445 <cprintf>
  800b1f:	83 c4 10             	add    $0x10,%esp
	cprintf("%~\tTotal number of customers = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfCustomers, flight1NumOfCustomers,flight2NumOfCustomers,flight3NumOfCustomers);
  800b22:	83 ec 0c             	sub    $0xc,%esp
  800b25:	ff 75 d4             	pushl  -0x2c(%ebp)
  800b28:	ff 75 d8             	pushl  -0x28(%ebp)
  800b2b:	ff 75 dc             	pushl  -0x24(%ebp)
  800b2e:	ff 75 e0             	pushl  -0x20(%ebp)
  800b31:	68 e4 53 80 00       	push   $0x8053e4
  800b36:	e8 0a 09 00 00       	call   801445 <cprintf>
  800b3b:	83 c4 20             	add    $0x20,%esp
	cprintf("%~\tTotal number of customers who receive tickets = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfBookings, numOfFCusts[0],numOfFCusts[1],numOfFCusts[2]);
  800b3e:	8b 8d d4 fc ff ff    	mov    -0x32c(%ebp),%ecx
  800b44:	8b 95 d0 fc ff ff    	mov    -0x330(%ebp),%edx
  800b4a:	8b 85 cc fc ff ff    	mov    -0x334(%ebp),%eax
  800b50:	83 ec 0c             	sub    $0xc,%esp
  800b53:	51                   	push   %ecx
  800b54:	52                   	push   %edx
  800b55:	50                   	push   %eax
  800b56:	ff 75 b4             	pushl  -0x4c(%ebp)
  800b59:	68 38 54 80 00       	push   $0x805438
  800b5e:	e8 e2 08 00 00       	call   801445 <cprintf>
  800b63:	83 c4 20             	add    $0x20,%esp
	}
	sys_unlock_cons();
  800b66:	e8 b6 32 00 00       	call   803e21 <sys_unlock_cons>
	//check out the final results and semaphores
	{
		for(int c = 0; c < numOfCustomers; ++c)
  800b6b:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  800b72:	e9 13 01 00 00       	jmp    800c8a <_main+0xc52>
		{
			if (custs[c].booked)
  800b77:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800b7a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b81:	8b 45 98             	mov    -0x68(%ebp),%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	8b 40 04             	mov    0x4(%eax),%eax
  800b89:	85 c0                	test   %eax,%eax
  800b8b:	0f 84 f6 00 00 00    	je     800c87 <_main+0xc4f>
			{
				if(custs[c].flightType ==1 && find(flight1BookedArr, flight1NumOfTickets, c) != 1)
  800b91:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800b94:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b9b:	8b 45 98             	mov    -0x68(%ebp),%eax
  800b9e:	01 d0                	add    %edx,%eax
  800ba0:	8b 00                	mov    (%eax),%eax
  800ba2:	83 f8 01             	cmp    $0x1,%eax
  800ba5:	75 33                	jne    800bda <_main+0xba2>
  800ba7:	83 ec 04             	sub    $0x4,%esp
  800baa:	ff 75 b0             	pushl  -0x50(%ebp)
  800bad:	ff 75 d0             	pushl  -0x30(%ebp)
  800bb0:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  800bb6:	e8 8b 03 00 00       	call   800f46 <find>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	83 f8 01             	cmp    $0x1,%eax
  800bc1:	74 17                	je     800bda <_main+0xba2>
				{
					panic("Error, wrong booking for user %d\n", c);
  800bc3:	ff 75 b0             	pushl  -0x50(%ebp)
  800bc6:	68 a0 54 80 00       	push   $0x8054a0
  800bcb:	68 ed 00 00 00       	push   $0xed
  800bd0:	68 5a 53 80 00       	push   $0x80535a
  800bd5:	e8 9d 05 00 00       	call   801177 <_panic>
				}
				if(custs[c].flightType ==2 && find(flight2BookedArr, flight2NumOfTickets, c) != 1)
  800bda:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800bdd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800be4:	8b 45 98             	mov    -0x68(%ebp),%eax
  800be7:	01 d0                	add    %edx,%eax
  800be9:	8b 00                	mov    (%eax),%eax
  800beb:	83 f8 02             	cmp    $0x2,%eax
  800bee:	75 33                	jne    800c23 <_main+0xbeb>
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	ff 75 b0             	pushl  -0x50(%ebp)
  800bf6:	ff 75 cc             	pushl  -0x34(%ebp)
  800bf9:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  800bff:	e8 42 03 00 00       	call   800f46 <find>
  800c04:	83 c4 10             	add    $0x10,%esp
  800c07:	83 f8 01             	cmp    $0x1,%eax
  800c0a:	74 17                	je     800c23 <_main+0xbeb>
				{
					panic("Error, wrong booking for user %d\n", c);
  800c0c:	ff 75 b0             	pushl  -0x50(%ebp)
  800c0f:	68 a0 54 80 00       	push   $0x8054a0
  800c14:	68 f1 00 00 00       	push   $0xf1
  800c19:	68 5a 53 80 00       	push   $0x80535a
  800c1e:	e8 54 05 00 00       	call   801177 <_panic>
				}
				if(custs[c].flightType ==3 && ((find(flight1BookedArr, flight1NumOfTickets, c) + find(flight2BookedArr, flight2NumOfTickets, c)) != 2))
  800c23:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c26:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800c2d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800c30:	01 d0                	add    %edx,%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	83 f8 03             	cmp    $0x3,%eax
  800c37:	75 4e                	jne    800c87 <_main+0xc4f>
  800c39:	83 ec 04             	sub    $0x4,%esp
  800c3c:	ff 75 b0             	pushl  -0x50(%ebp)
  800c3f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c42:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  800c48:	e8 f9 02 00 00       	call   800f46 <find>
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	89 c3                	mov    %eax,%ebx
  800c52:	83 ec 04             	sub    $0x4,%esp
  800c55:	ff 75 b0             	pushl  -0x50(%ebp)
  800c58:	ff 75 cc             	pushl  -0x34(%ebp)
  800c5b:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  800c61:	e8 e0 02 00 00       	call   800f46 <find>
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	01 d8                	add    %ebx,%eax
  800c6b:	83 f8 02             	cmp    $0x2,%eax
  800c6e:	74 17                	je     800c87 <_main+0xc4f>
				{
					panic("Error, wrong booking for user %d\n", c);
  800c70:	ff 75 b0             	pushl  -0x50(%ebp)
  800c73:	68 a0 54 80 00       	push   $0x8054a0
  800c78:	68 f5 00 00 00       	push   $0xf5
  800c7d:	68 5a 53 80 00       	push   $0x80535a
  800c82:	e8 f0 04 00 00       	call   801177 <_panic>
	cprintf("%~\tTotal number of customers who receive tickets = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfBookings, numOfFCusts[0],numOfFCusts[1],numOfFCusts[2]);
	}
	sys_unlock_cons();
	//check out the final results and semaphores
	{
		for(int c = 0; c < numOfCustomers; ++c)
  800c87:	ff 45 b0             	incl   -0x50(%ebp)
  800c8a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c8d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800c90:	0f 8c e1 fe ff ff    	jl     800b77 <_main+0xb3f>
					panic("Error, wrong booking for user %d\n", c);
				}
			}
		}

		assert(semaphore_count(capacity) == agentCapacity);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	ff b5 f8 fc ff ff    	pushl  -0x308(%ebp)
  800c9f:	e8 9b 41 00 00       	call   804e3f <semaphore_count>
  800ca4:	83 c4 10             	add    $0x10,%esp
  800ca7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800caa:	74 19                	je     800cc5 <_main+0xc8d>
  800cac:	68 c4 54 80 00       	push   $0x8054c4
  800cb1:	68 ef 54 80 00       	push   $0x8054ef
  800cb6:	68 fa 00 00 00       	push   $0xfa
  800cbb:	68 5a 53 80 00       	push   $0x80535a
  800cc0:	e8 b2 04 00 00       	call   801177 <_panic>

		assert(semaphore_count(flight1CS) == 1);
  800cc5:	83 ec 0c             	sub    $0xc,%esp
  800cc8:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
  800cce:	e8 6c 41 00 00       	call   804e3f <semaphore_count>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	83 f8 01             	cmp    $0x1,%eax
  800cd9:	74 19                	je     800cf4 <_main+0xcbc>
  800cdb:	68 04 55 80 00       	push   $0x805504
  800ce0:	68 ef 54 80 00       	push   $0x8054ef
  800ce5:	68 fc 00 00 00       	push   $0xfc
  800cea:	68 5a 53 80 00       	push   $0x80535a
  800cef:	e8 83 04 00 00       	call   801177 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	ff b5 f0 fc ff ff    	pushl  -0x310(%ebp)
  800cfd:	e8 3d 41 00 00       	call   804e3f <semaphore_count>
  800d02:	83 c4 10             	add    $0x10,%esp
  800d05:	83 f8 01             	cmp    $0x1,%eax
  800d08:	74 19                	je     800d23 <_main+0xceb>
  800d0a:	68 24 55 80 00       	push   $0x805524
  800d0f:	68 ef 54 80 00       	push   $0x8054ef
  800d14:	68 fd 00 00 00       	push   $0xfd
  800d19:	68 5a 53 80 00       	push   $0x80535a
  800d1e:	e8 54 04 00 00       	call   801177 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  800d23:	83 ec 0c             	sub    $0xc,%esp
  800d26:	ff b5 ec fc ff ff    	pushl  -0x314(%ebp)
  800d2c:	e8 0e 41 00 00       	call   804e3f <semaphore_count>
  800d31:	83 c4 10             	add    $0x10,%esp
  800d34:	83 f8 01             	cmp    $0x1,%eax
  800d37:	74 19                	je     800d52 <_main+0xd1a>
  800d39:	68 44 55 80 00       	push   $0x805544
  800d3e:	68 ef 54 80 00       	push   $0x8054ef
  800d43:	68 ff 00 00 00       	push   $0xff
  800d48:	68 5a 53 80 00       	push   $0x80535a
  800d4d:	e8 25 04 00 00       	call   801177 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	ff b5 e8 fc ff ff    	pushl  -0x318(%ebp)
  800d5b:	e8 df 40 00 00       	call   804e3f <semaphore_count>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	83 f8 01             	cmp    $0x1,%eax
  800d66:	74 19                	je     800d81 <_main+0xd49>
  800d68:	68 68 55 80 00       	push   $0x805568
  800d6d:	68 ef 54 80 00       	push   $0x8054ef
  800d72:	68 00 01 00 00       	push   $0x100
  800d77:	68 5a 53 80 00       	push   $0x80535a
  800d7c:	e8 f6 03 00 00       	call   801177 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	ff b5 e4 fc ff ff    	pushl  -0x31c(%ebp)
  800d8a:	e8 b0 40 00 00       	call   804e3f <semaphore_count>
  800d8f:	83 c4 10             	add    $0x10,%esp
  800d92:	83 f8 03             	cmp    $0x3,%eax
  800d95:	74 19                	je     800db0 <_main+0xd78>
  800d97:	68 8a 55 80 00       	push   $0x80558a
  800d9c:	68 ef 54 80 00       	push   $0x8054ef
  800da1:	68 02 01 00 00       	push   $0x102
  800da6:	68 5a 53 80 00       	push   $0x80535a
  800dab:	e8 c7 03 00 00       	call   801177 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	ff b5 e0 fc ff ff    	pushl  -0x320(%ebp)
  800db9:	e8 81 40 00 00       	call   804e3f <semaphore_count>
  800dbe:	83 c4 10             	add    $0x10,%esp
  800dc1:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800dc4:	74 19                	je     800ddf <_main+0xda7>
  800dc6:	68 a8 55 80 00       	push   $0x8055a8
  800dcb:	68 ef 54 80 00       	push   $0x8054ef
  800dd0:	68 04 01 00 00       	push   $0x104
  800dd5:	68 5a 53 80 00       	push   $0x80535a
  800dda:	e8 98 03 00 00       	call   801177 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	ff b5 dc fc ff ff    	pushl  -0x324(%ebp)
  800de8:	e8 52 40 00 00       	call   804e3f <semaphore_count>
  800ded:	83 c4 10             	add    $0x10,%esp
  800df0:	85 c0                	test   %eax,%eax
  800df2:	74 19                	je     800e0d <_main+0xdd5>
  800df4:	68 cc 55 80 00       	push   $0x8055cc
  800df9:	68 ef 54 80 00       	push   $0x8054ef
  800dfe:	68 06 01 00 00       	push   $0x106
  800e03:	68 5a 53 80 00       	push   $0x80535a
  800e08:	e8 6a 03 00 00       	call   801177 <_panic>

		int s=0;
  800e0d:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800e14:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  800e1b:	eb 3f                	jmp    800e5c <_main+0xe24>
		{
			assert(semaphore_count(cust_finished[s]) ==  0);
  800e1d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800e20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e27:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800e2d:	01 d0                	add    %edx,%eax
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	ff 30                	pushl  (%eax)
  800e34:	e8 06 40 00 00       	call   804e3f <semaphore_count>
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	74 19                	je     800e59 <_main+0xe21>
  800e40:	68 f4 55 80 00       	push   $0x8055f4
  800e45:	68 ef 54 80 00       	push   $0x8054ef
  800e4a:	68 0b 01 00 00       	push   $0x10b
  800e4f:	68 5a 53 80 00       	push   $0x80535a
  800e54:	e8 1e 03 00 00       	call   801177 <_panic>
		assert(semaphore_count(cust_ready) == -3);

		assert(semaphore_count(custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800e59:	ff 45 ac             	incl   -0x54(%ebp)
  800e5c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800e5f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800e62:	7c b9                	jl     800e1d <_main+0xde5>
		{
			assert(semaphore_count(cust_finished[s]) ==  0);
		}

		atomic_cprintf("%~\nAll reservations are successfully done... have a nice flight :)\n");
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	68 1c 56 80 00       	push   $0x80561c
  800e6c:	e8 46 06 00 00       	call   8014b7 <atomic_cprintf>
  800e71:	83 c4 10             	add    $0x10,%esp

		//waste some time then close the agency
		env_sleep(5000) ;
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	68 88 13 00 00       	push   $0x1388
  800e7c:	e8 c9 3f 00 00       	call   804e4a <env_sleep>
  800e81:	83 c4 10             	add    $0x10,%esp
		*isOpened = 0;
  800e84:	8b 45 88             	mov    -0x78(%ebp),%eax
  800e87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		atomic_cprintf("\n%~The agency is closing now...\n");
  800e8d:	83 ec 0c             	sub    $0xc,%esp
  800e90:	68 60 56 80 00       	push   $0x805660
  800e95:	e8 1d 06 00 00       	call   8014b7 <atomic_cprintf>
  800e9a:	83 c4 10             	add    $0x10,%esp

		//Signal all clerks to continue and recheck the isOpened flag
		cust_ready_queue[numOfCustomers] = -1; //to indicate, for the clerk, there's no more customers
  800e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ea0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ea7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800ead:	01 d0                	add    %edx,%eax
  800eaf:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
		for (int k = 0; k < numOfClerks; ++k)
  800eb5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
  800ebc:	eb 14                	jmp    800ed2 <_main+0xe9a>
		{
			signal_semaphore(cust_ready);
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	ff b5 e0 fc ff ff    	pushl  -0x320(%ebp)
  800ec7:	e8 59 3f 00 00       	call   804e25 <signal_semaphore>
  800ecc:	83 c4 10             	add    $0x10,%esp
		*isOpened = 0;
		atomic_cprintf("\n%~The agency is closing now...\n");

		//Signal all clerks to continue and recheck the isOpened flag
		cust_ready_queue[numOfCustomers] = -1; //to indicate, for the clerk, there's no more customers
		for (int k = 0; k < numOfClerks; ++k)
  800ecf:	ff 45 a8             	incl   -0x58(%ebp)
  800ed2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800ed5:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800ed8:	7c e4                	jl     800ebe <_main+0xe86>
		{
			signal_semaphore(cust_ready);
		}

		//Wait all clerks to finished
		for (int k = 0; k < numOfClerks; ++k)
  800eda:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  800ee1:	eb 14                	jmp    800ef7 <_main+0xebf>
		{
			wait_semaphore(clerkTerminated);
  800ee3:	83 ec 0c             	sub    $0xc,%esp
  800ee6:	ff b5 d8 fc ff ff    	pushl  -0x328(%ebp)
  800eec:	e8 1a 3f 00 00       	call   804e0b <wait_semaphore>
  800ef1:	83 c4 10             	add    $0x10,%esp
		{
			signal_semaphore(cust_ready);
		}

		//Wait all clerks to finished
		for (int k = 0; k < numOfClerks; ++k)
  800ef4:	ff 45 a4             	incl   -0x5c(%ebp)
  800ef7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800efa:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800efd:	7c e4                	jl     800ee3 <_main+0xeab>
		{
			wait_semaphore(clerkTerminated);
		}

		assert(semaphore_count(clerkTerminated) ==  0);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	ff b5 d8 fc ff ff    	pushl  -0x328(%ebp)
  800f08:	e8 32 3f 00 00       	call   804e3f <semaphore_count>
  800f0d:	83 c4 10             	add    $0x10,%esp
  800f10:	85 c0                	test   %eax,%eax
  800f12:	74 19                	je     800f2d <_main+0xef5>
  800f14:	68 84 56 80 00       	push   $0x805684
  800f19:	68 ef 54 80 00       	push   $0x8054ef
  800f1e:	68 22 01 00 00       	push   $0x122
  800f23:	68 5a 53 80 00       	push   $0x80535a
  800f28:	e8 4a 02 00 00       	call   801177 <_panic>

		atomic_cprintf("%~\nCongratulations... Airplane Reservation App is Finished Successfully\n\n");
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	68 ac 56 80 00       	push   $0x8056ac
  800f35:	e8 7d 05 00 00       	call   8014b7 <atomic_cprintf>
  800f3a:	83 c4 10             	add    $0x10,%esp
	}

}
  800f3d:	90                   	nop
  800f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <find>:


int find(int* arr, int size, int val)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800f4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800f53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f5a:	eb 22                	jmp    800f7e <find+0x38>
	{
		if(arr[i] == val)
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
  800f6b:	8b 00                	mov    (%eax),%eax
  800f6d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f70:	75 09                	jne    800f7b <find+0x35>
		{
			result = 1;
  800f72:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800f79:	eb 0b                	jmp    800f86 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800f7b:	ff 45 f8             	incl   -0x8(%ebp)
  800f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f81:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f84:	7c d6                	jl     800f5c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800f97:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800f9b:	83 ec 0c             	sub    $0xc,%esp
  800f9e:	50                   	push   %eax
  800f9f:	e8 ab 2f 00 00       	call   803f4f <sys_cputc>
  800fa4:	83 c4 10             	add    $0x10,%esp
}
  800fa7:	90                   	nop
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <getchar>:


int
getchar(void)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800fb0:	e8 39 2e 00 00       	call   803dee <sys_cgetc>
  800fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <iscons>:

int iscons(int fdnum)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800fc0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
  800fcd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800fd0:	e8 ab 30 00 00       	call   804080 <sys_getenvindex>
  800fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800fd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fdb:	89 d0                	mov    %edx,%eax
  800fdd:	c1 e0 03             	shl    $0x3,%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	c1 e0 02             	shl    $0x2,%eax
  800fe5:	01 d0                	add    %edx,%eax
  800fe7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	c1 e0 03             	shl    $0x3,%eax
  800ff3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ff8:	a3 20 70 80 00       	mov    %eax,0x807020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ffd:	a1 20 70 80 00       	mov    0x807020,%eax
  801002:	8a 40 20             	mov    0x20(%eax),%al
  801005:	84 c0                	test   %al,%al
  801007:	74 0d                	je     801016 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  801009:	a1 20 70 80 00       	mov    0x807020,%eax
  80100e:	83 c0 20             	add    $0x20,%eax
  801011:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801016:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80101a:	7e 0a                	jle    801026 <libmain+0x5f>
		binaryname = argv[0];
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8b 00                	mov    (%eax),%eax
  801021:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	ff 75 08             	pushl  0x8(%ebp)
  80102f:	e8 04 f0 ff ff       	call   800038 <_main>
  801034:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801037:	a1 00 70 80 00       	mov    0x807000,%eax
  80103c:	85 c0                	test   %eax,%eax
  80103e:	0f 84 01 01 00 00    	je     801145 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801044:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80104a:	bb 60 59 80 00       	mov    $0x805960,%ebx
  80104f:	ba 0e 00 00 00       	mov    $0xe,%edx
  801054:	89 c7                	mov    %eax,%edi
  801056:	89 de                	mov    %ebx,%esi
  801058:	89 d1                	mov    %edx,%ecx
  80105a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80105c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80105f:	b9 56 00 00 00       	mov    $0x56,%ecx
  801064:	b0 00                	mov    $0x0,%al
  801066:	89 d7                	mov    %edx,%edi
  801068:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80106a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801071:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801074:	83 ec 08             	sub    $0x8,%esp
  801077:	50                   	push   %eax
  801078:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80107e:	50                   	push   %eax
  80107f:	e8 32 32 00 00       	call   8042b6 <sys_utilities>
  801084:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801087:	e8 7b 2d 00 00       	call   803e07 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80108c:	83 ec 0c             	sub    $0xc,%esp
  80108f:	68 80 58 80 00       	push   $0x805880
  801094:	e8 ac 03 00 00       	call   801445 <cprintf>
  801099:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80109c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	74 18                	je     8010bb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8010a3:	e8 2c 32 00 00       	call   8042d4 <sys_get_optimal_num_faults>
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	50                   	push   %eax
  8010ac:	68 a8 58 80 00       	push   $0x8058a8
  8010b1:	e8 8f 03 00 00       	call   801445 <cprintf>
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	eb 59                	jmp    801114 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8010bb:	a1 20 70 80 00       	mov    0x807020,%eax
  8010c0:	8b 90 ac 05 00 00    	mov    0x5ac(%eax),%edx
  8010c6:	a1 20 70 80 00       	mov    0x807020,%eax
  8010cb:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8010d1:	83 ec 04             	sub    $0x4,%esp
  8010d4:	52                   	push   %edx
  8010d5:	50                   	push   %eax
  8010d6:	68 cc 58 80 00       	push   $0x8058cc
  8010db:	e8 65 03 00 00       	call   801445 <cprintf>
  8010e0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8010e3:	a1 20 70 80 00       	mov    0x807020,%eax
  8010e8:	8b 88 c0 05 00 00    	mov    0x5c0(%eax),%ecx
  8010ee:	a1 20 70 80 00       	mov    0x807020,%eax
  8010f3:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8010f9:	a1 20 70 80 00       	mov    0x807020,%eax
  8010fe:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801104:	51                   	push   %ecx
  801105:	52                   	push   %edx
  801106:	50                   	push   %eax
  801107:	68 f4 58 80 00       	push   $0x8058f4
  80110c:	e8 34 03 00 00       	call   801445 <cprintf>
  801111:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801114:	a1 20 70 80 00       	mov    0x807020,%eax
  801119:	8b 80 c4 05 00 00    	mov    0x5c4(%eax),%eax
  80111f:	83 ec 08             	sub    $0x8,%esp
  801122:	50                   	push   %eax
  801123:	68 4c 59 80 00       	push   $0x80594c
  801128:	e8 18 03 00 00       	call   801445 <cprintf>
  80112d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	68 80 58 80 00       	push   $0x805880
  801138:	e8 08 03 00 00       	call   801445 <cprintf>
  80113d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801140:	e8 dc 2c 00 00       	call   803e21 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801145:	e8 1f 00 00 00       	call   801169 <exit>
}
  80114a:	90                   	nop
  80114b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114e:	5b                   	pop    %ebx
  80114f:	5e                   	pop    %esi
  801150:	5f                   	pop    %edi
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    

00801153 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801159:	83 ec 0c             	sub    $0xc,%esp
  80115c:	6a 00                	push   $0x0
  80115e:	e8 e9 2e 00 00       	call   80404c <sys_destroy_env>
  801163:	83 c4 10             	add    $0x10,%esp
}
  801166:	90                   	nop
  801167:	c9                   	leave  
  801168:	c3                   	ret    

00801169 <exit>:

void
exit(void)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80116f:	e8 3e 2f 00 00       	call   8040b2 <sys_exit_env>
}
  801174:	90                   	nop
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80117d:	8d 45 10             	lea    0x10(%ebp),%eax
  801180:	83 c0 04             	add    $0x4,%eax
  801183:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801186:	a1 38 71 83 00       	mov    0x837138,%eax
  80118b:	85 c0                	test   %eax,%eax
  80118d:	74 16                	je     8011a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80118f:	a1 38 71 83 00       	mov    0x837138,%eax
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	50                   	push   %eax
  801198:	68 c4 59 80 00       	push   $0x8059c4
  80119d:	e8 a3 02 00 00       	call   801445 <cprintf>
  8011a2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8011a5:	a1 04 70 80 00       	mov    0x807004,%eax
  8011aa:	83 ec 0c             	sub    $0xc,%esp
  8011ad:	ff 75 0c             	pushl  0xc(%ebp)
  8011b0:	ff 75 08             	pushl  0x8(%ebp)
  8011b3:	50                   	push   %eax
  8011b4:	68 cc 59 80 00       	push   $0x8059cc
  8011b9:	6a 74                	push   $0x74
  8011bb:	e8 b2 02 00 00       	call   801472 <cprintf_colored>
  8011c0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8011c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c6:	83 ec 08             	sub    $0x8,%esp
  8011c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011cc:	50                   	push   %eax
  8011cd:	e8 04 02 00 00       	call   8013d6 <vcprintf>
  8011d2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8011d5:	83 ec 08             	sub    $0x8,%esp
  8011d8:	6a 00                	push   $0x0
  8011da:	68 f4 59 80 00       	push   $0x8059f4
  8011df:	e8 f2 01 00 00       	call   8013d6 <vcprintf>
  8011e4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8011e7:	e8 7d ff ff ff       	call   801169 <exit>

	// should not return here
	while (1) ;
  8011ec:	eb fe                	jmp    8011ec <_panic+0x75>

008011ee <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8011f4:	a1 20 70 80 00       	mov    0x807020,%eax
  8011f9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8011ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801202:	39 c2                	cmp    %eax,%edx
  801204:	74 14                	je     80121a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801206:	83 ec 04             	sub    $0x4,%esp
  801209:	68 f8 59 80 00       	push   $0x8059f8
  80120e:	6a 26                	push   $0x26
  801210:	68 44 5a 80 00       	push   $0x805a44
  801215:	e8 5d ff ff ff       	call   801177 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80121a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801221:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801228:	e9 c5 00 00 00       	jmp    8012f2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80122d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801230:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	8b 00                	mov    (%eax),%eax
  80123e:	85 c0                	test   %eax,%eax
  801240:	75 08                	jne    80124a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801242:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801245:	e9 a5 00 00 00       	jmp    8012ef <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80124a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801251:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801258:	eb 69                	jmp    8012c3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80125a:	a1 20 70 80 00       	mov    0x807020,%eax
  80125f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801265:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801268:	89 d0                	mov    %edx,%eax
  80126a:	01 c0                	add    %eax,%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	c1 e0 03             	shl    $0x3,%eax
  801271:	01 c8                	add    %ecx,%eax
  801273:	8a 40 04             	mov    0x4(%eax),%al
  801276:	84 c0                	test   %al,%al
  801278:	75 46                	jne    8012c0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80127a:	a1 20 70 80 00       	mov    0x807020,%eax
  80127f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801285:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801288:	89 d0                	mov    %edx,%eax
  80128a:	01 c0                	add    %eax,%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	c1 e0 03             	shl    $0x3,%eax
  801291:	01 c8                	add    %ecx,%eax
  801293:	8b 00                	mov    (%eax),%eax
  801295:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801298:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80129b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8012a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	01 c8                	add    %ecx,%eax
  8012b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8012b3:	39 c2                	cmp    %eax,%edx
  8012b5:	75 09                	jne    8012c0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8012b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8012be:	eb 15                	jmp    8012d5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8012c0:	ff 45 e8             	incl   -0x18(%ebp)
  8012c3:	a1 20 70 80 00       	mov    0x807020,%eax
  8012c8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8012ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012d1:	39 c2                	cmp    %eax,%edx
  8012d3:	77 85                	ja     80125a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8012d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012d9:	75 14                	jne    8012ef <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8012db:	83 ec 04             	sub    $0x4,%esp
  8012de:	68 50 5a 80 00       	push   $0x805a50
  8012e3:	6a 3a                	push   $0x3a
  8012e5:	68 44 5a 80 00       	push   $0x805a44
  8012ea:	e8 88 fe ff ff       	call   801177 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8012ef:	ff 45 f0             	incl   -0x10(%ebp)
  8012f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8012f8:	0f 8c 2f ff ff ff    	jl     80122d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8012fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801305:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80130c:	eb 26                	jmp    801334 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80130e:	a1 20 70 80 00       	mov    0x807020,%eax
  801313:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801319:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80131c:	89 d0                	mov    %edx,%eax
  80131e:	01 c0                	add    %eax,%eax
  801320:	01 d0                	add    %edx,%eax
  801322:	c1 e0 03             	shl    $0x3,%eax
  801325:	01 c8                	add    %ecx,%eax
  801327:	8a 40 04             	mov    0x4(%eax),%al
  80132a:	3c 01                	cmp    $0x1,%al
  80132c:	75 03                	jne    801331 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80132e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801331:	ff 45 e0             	incl   -0x20(%ebp)
  801334:	a1 20 70 80 00       	mov    0x807020,%eax
  801339:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80133f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801342:	39 c2                	cmp    %eax,%edx
  801344:	77 c8                	ja     80130e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801349:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80134c:	74 14                	je     801362 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80134e:	83 ec 04             	sub    $0x4,%esp
  801351:	68 a4 5a 80 00       	push   $0x805aa4
  801356:	6a 44                	push   $0x44
  801358:	68 44 5a 80 00       	push   $0x805a44
  80135d:	e8 15 fe ff ff       	call   801177 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801362:	90                   	nop
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	53                   	push   %ebx
  801369:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	8b 00                	mov    (%eax),%eax
  801371:	8d 48 01             	lea    0x1(%eax),%ecx
  801374:	8b 55 0c             	mov    0xc(%ebp),%edx
  801377:	89 0a                	mov    %ecx,(%edx)
  801379:	8b 55 08             	mov    0x8(%ebp),%edx
  80137c:	88 d1                	mov    %dl,%cl
  80137e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801381:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801385:	8b 45 0c             	mov    0xc(%ebp),%eax
  801388:	8b 00                	mov    (%eax),%eax
  80138a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80138f:	75 30                	jne    8013c1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801391:	8b 15 3c 71 83 00    	mov    0x83713c,%edx
  801397:	a0 64 f0 81 00       	mov    0x81f064,%al
  80139c:	0f b6 c0             	movzbl %al,%eax
  80139f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a2:	8b 09                	mov    (%ecx),%ecx
  8013a4:	89 cb                	mov    %ecx,%ebx
  8013a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013a9:	83 c1 08             	add    $0x8,%ecx
  8013ac:	52                   	push   %edx
  8013ad:	50                   	push   %eax
  8013ae:	53                   	push   %ebx
  8013af:	51                   	push   %ecx
  8013b0:	e8 0e 2a 00 00       	call   803dc3 <sys_cputs>
  8013b5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	8b 40 04             	mov    0x4(%eax),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8013d0:	90                   	nop
  8013d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8013df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8013e6:	00 00 00 
	b.cnt = 0;
  8013e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8013f0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	ff 75 08             	pushl  0x8(%ebp)
  8013f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8013ff:	50                   	push   %eax
  801400:	68 65 13 80 00       	push   $0x801365
  801405:	e8 5a 02 00 00       	call   801664 <vprintfmt>
  80140a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80140d:	8b 15 3c 71 83 00    	mov    0x83713c,%edx
  801413:	a0 64 f0 81 00       	mov    0x81f064,%al
  801418:	0f b6 c0             	movzbl %al,%eax
  80141b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801421:	52                   	push   %edx
  801422:	50                   	push   %eax
  801423:	51                   	push   %ecx
  801424:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80142a:	83 c0 08             	add    $0x8,%eax
  80142d:	50                   	push   %eax
  80142e:	e8 90 29 00 00       	call   803dc3 <sys_cputs>
  801433:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801436:	c6 05 64 f0 81 00 00 	movb   $0x0,0x81f064
	return b.cnt;
  80143d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80144b:	c6 05 64 f0 81 00 01 	movb   $0x1,0x81f064
	va_start(ap, fmt);
  801452:	8d 45 0c             	lea    0xc(%ebp),%eax
  801455:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801458:	8b 45 08             	mov    0x8(%ebp),%eax
  80145b:	83 ec 08             	sub    $0x8,%esp
  80145e:	ff 75 f4             	pushl  -0xc(%ebp)
  801461:	50                   	push   %eax
  801462:	e8 6f ff ff ff       	call   8013d6 <vcprintf>
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80146d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801478:	c6 05 64 f0 81 00 01 	movb   $0x1,0x81f064
	curTextClr = (textClr << 8) ; //set text color by the given value
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	c1 e0 08             	shl    $0x8,%eax
  801485:	a3 3c 71 83 00       	mov    %eax,0x83713c
	va_start(ap, fmt);
  80148a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80148d:	83 c0 04             	add    $0x4,%eax
  801490:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	83 ec 08             	sub    $0x8,%esp
  801499:	ff 75 f4             	pushl  -0xc(%ebp)
  80149c:	50                   	push   %eax
  80149d:	e8 34 ff ff ff       	call   8013d6 <vcprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8014a8:	c7 05 3c 71 83 00 00 	movl   $0x700,0x83713c
  8014af:	07 00 00 

	return cnt;
  8014b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8014bd:	e8 45 29 00 00       	call   803e07 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8014c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8014c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	83 ec 08             	sub    $0x8,%esp
  8014ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d1:	50                   	push   %eax
  8014d2:	e8 ff fe ff ff       	call   8013d6 <vcprintf>
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8014dd:	e8 3f 29 00 00       	call   803e21 <sys_unlock_cons>
	return cnt;
  8014e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	53                   	push   %ebx
  8014eb:	83 ec 14             	sub    $0x14,%esp
  8014ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8014fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8014fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801502:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801505:	77 55                	ja     80155c <printnum+0x75>
  801507:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80150a:	72 05                	jb     801511 <printnum+0x2a>
  80150c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80150f:	77 4b                	ja     80155c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801511:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801514:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801517:	8b 45 18             	mov    0x18(%ebp),%eax
  80151a:	ba 00 00 00 00       	mov    $0x0,%edx
  80151f:	52                   	push   %edx
  801520:	50                   	push   %eax
  801521:	ff 75 f4             	pushl  -0xc(%ebp)
  801524:	ff 75 f0             	pushl  -0x10(%ebp)
  801527:	e8 dc 39 00 00       	call   804f08 <__udivdi3>
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	ff 75 20             	pushl  0x20(%ebp)
  801535:	53                   	push   %ebx
  801536:	ff 75 18             	pushl  0x18(%ebp)
  801539:	52                   	push   %edx
  80153a:	50                   	push   %eax
  80153b:	ff 75 0c             	pushl  0xc(%ebp)
  80153e:	ff 75 08             	pushl  0x8(%ebp)
  801541:	e8 a1 ff ff ff       	call   8014e7 <printnum>
  801546:	83 c4 20             	add    $0x20,%esp
  801549:	eb 1a                	jmp    801565 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	ff 75 0c             	pushl  0xc(%ebp)
  801551:	ff 75 20             	pushl  0x20(%ebp)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	ff d0                	call   *%eax
  801559:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80155c:	ff 4d 1c             	decl   0x1c(%ebp)
  80155f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801563:	7f e6                	jg     80154b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801565:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801568:	bb 00 00 00 00       	mov    $0x0,%ebx
  80156d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801573:	53                   	push   %ebx
  801574:	51                   	push   %ecx
  801575:	52                   	push   %edx
  801576:	50                   	push   %eax
  801577:	e8 9c 3a 00 00       	call   805018 <__umoddi3>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	05 14 5d 80 00       	add    $0x805d14,%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	0f be c0             	movsbl %al,%eax
  801589:	83 ec 08             	sub    $0x8,%esp
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	50                   	push   %eax
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	ff d0                	call   *%eax
  801595:	83 c4 10             	add    $0x10,%esp
}
  801598:	90                   	nop
  801599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8015a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8015a5:	7e 1c                	jle    8015c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	8b 00                	mov    (%eax),%eax
  8015ac:	8d 50 08             	lea    0x8(%eax),%edx
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	89 10                	mov    %edx,(%eax)
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8b 00                	mov    (%eax),%eax
  8015b9:	83 e8 08             	sub    $0x8,%eax
  8015bc:	8b 50 04             	mov    0x4(%eax),%edx
  8015bf:	8b 00                	mov    (%eax),%eax
  8015c1:	eb 40                	jmp    801603 <getuint+0x65>
	else if (lflag)
  8015c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c7:	74 1e                	je     8015e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8b 00                	mov    (%eax),%eax
  8015ce:	8d 50 04             	lea    0x4(%eax),%edx
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	89 10                	mov    %edx,(%eax)
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8b 00                	mov    (%eax),%eax
  8015db:	83 e8 04             	sub    $0x4,%eax
  8015de:	8b 00                	mov    (%eax),%eax
  8015e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e5:	eb 1c                	jmp    801603 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	8b 00                	mov    (%eax),%eax
  8015ec:	8d 50 04             	lea    0x4(%eax),%edx
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	89 10                	mov    %edx,(%eax)
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	8b 00                	mov    (%eax),%eax
  8015f9:	83 e8 04             	sub    $0x4,%eax
  8015fc:	8b 00                	mov    (%eax),%eax
  8015fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801603:	5d                   	pop    %ebp
  801604:	c3                   	ret    

00801605 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801608:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80160c:	7e 1c                	jle    80162a <getint+0x25>
		return va_arg(*ap, long long);
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	8b 00                	mov    (%eax),%eax
  801613:	8d 50 08             	lea    0x8(%eax),%edx
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	89 10                	mov    %edx,(%eax)
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8b 00                	mov    (%eax),%eax
  801620:	83 e8 08             	sub    $0x8,%eax
  801623:	8b 50 04             	mov    0x4(%eax),%edx
  801626:	8b 00                	mov    (%eax),%eax
  801628:	eb 38                	jmp    801662 <getint+0x5d>
	else if (lflag)
  80162a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80162e:	74 1a                	je     80164a <getint+0x45>
		return va_arg(*ap, long);
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	8b 00                	mov    (%eax),%eax
  801635:	8d 50 04             	lea    0x4(%eax),%edx
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	89 10                	mov    %edx,(%eax)
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	8b 00                	mov    (%eax),%eax
  801642:	83 e8 04             	sub    $0x4,%eax
  801645:	8b 00                	mov    (%eax),%eax
  801647:	99                   	cltd   
  801648:	eb 18                	jmp    801662 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	8b 00                	mov    (%eax),%eax
  80164f:	8d 50 04             	lea    0x4(%eax),%edx
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	89 10                	mov    %edx,(%eax)
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	83 e8 04             	sub    $0x4,%eax
  80165f:	8b 00                	mov    (%eax),%eax
  801661:	99                   	cltd   
}
  801662:	5d                   	pop    %ebp
  801663:	c3                   	ret    

00801664 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	56                   	push   %esi
  801668:	53                   	push   %ebx
  801669:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80166c:	eb 17                	jmp    801685 <vprintfmt+0x21>
			if (ch == '\0')
  80166e:	85 db                	test   %ebx,%ebx
  801670:	0f 84 c1 03 00 00    	je     801a37 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	ff 75 0c             	pushl  0xc(%ebp)
  80167c:	53                   	push   %ebx
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	ff d0                	call   *%eax
  801682:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	8d 50 01             	lea    0x1(%eax),%edx
  80168b:	89 55 10             	mov    %edx,0x10(%ebp)
  80168e:	8a 00                	mov    (%eax),%al
  801690:	0f b6 d8             	movzbl %al,%ebx
  801693:	83 fb 25             	cmp    $0x25,%ebx
  801696:	75 d6                	jne    80166e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801698:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80169c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8016a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8016b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	8d 50 01             	lea    0x1(%eax),%edx
  8016be:	89 55 10             	mov    %edx,0x10(%ebp)
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	0f b6 d8             	movzbl %al,%ebx
  8016c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8016c9:	83 f8 5b             	cmp    $0x5b,%eax
  8016cc:	0f 87 3d 03 00 00    	ja     801a0f <vprintfmt+0x3ab>
  8016d2:	8b 04 85 38 5d 80 00 	mov    0x805d38(,%eax,4),%eax
  8016d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8016db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8016df:	eb d7                	jmp    8016b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8016e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8016e5:	eb d1                	jmp    8016b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8016e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8016ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016f1:	89 d0                	mov    %edx,%eax
  8016f3:	c1 e0 02             	shl    $0x2,%eax
  8016f6:	01 d0                	add    %edx,%eax
  8016f8:	01 c0                	add    %eax,%eax
  8016fa:	01 d8                	add    %ebx,%eax
  8016fc:	83 e8 30             	sub    $0x30,%eax
  8016ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801702:	8b 45 10             	mov    0x10(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80170a:	83 fb 2f             	cmp    $0x2f,%ebx
  80170d:	7e 3e                	jle    80174d <vprintfmt+0xe9>
  80170f:	83 fb 39             	cmp    $0x39,%ebx
  801712:	7f 39                	jg     80174d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801714:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801717:	eb d5                	jmp    8016ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801719:	8b 45 14             	mov    0x14(%ebp),%eax
  80171c:	83 c0 04             	add    $0x4,%eax
  80171f:	89 45 14             	mov    %eax,0x14(%ebp)
  801722:	8b 45 14             	mov    0x14(%ebp),%eax
  801725:	83 e8 04             	sub    $0x4,%eax
  801728:	8b 00                	mov    (%eax),%eax
  80172a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80172d:	eb 1f                	jmp    80174e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80172f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801733:	79 83                	jns    8016b8 <vprintfmt+0x54>
				width = 0;
  801735:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80173c:	e9 77 ff ff ff       	jmp    8016b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801741:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801748:	e9 6b ff ff ff       	jmp    8016b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80174d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80174e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801752:	0f 89 60 ff ff ff    	jns    8016b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  801758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80175b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80175e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801765:	e9 4e ff ff ff       	jmp    8016b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80176a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80176d:	e9 46 ff ff ff       	jmp    8016b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801772:	8b 45 14             	mov    0x14(%ebp),%eax
  801775:	83 c0 04             	add    $0x4,%eax
  801778:	89 45 14             	mov    %eax,0x14(%ebp)
  80177b:	8b 45 14             	mov    0x14(%ebp),%eax
  80177e:	83 e8 04             	sub    $0x4,%eax
  801781:	8b 00                	mov    (%eax),%eax
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	ff 75 0c             	pushl  0xc(%ebp)
  801789:	50                   	push   %eax
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	ff d0                	call   *%eax
  80178f:	83 c4 10             	add    $0x10,%esp
			break;
  801792:	e9 9b 02 00 00       	jmp    801a32 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801797:	8b 45 14             	mov    0x14(%ebp),%eax
  80179a:	83 c0 04             	add    $0x4,%eax
  80179d:	89 45 14             	mov    %eax,0x14(%ebp)
  8017a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a3:	83 e8 04             	sub    $0x4,%eax
  8017a6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8017a8:	85 db                	test   %ebx,%ebx
  8017aa:	79 02                	jns    8017ae <vprintfmt+0x14a>
				err = -err;
  8017ac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8017ae:	83 fb 64             	cmp    $0x64,%ebx
  8017b1:	7f 0b                	jg     8017be <vprintfmt+0x15a>
  8017b3:	8b 34 9d 80 5b 80 00 	mov    0x805b80(,%ebx,4),%esi
  8017ba:	85 f6                	test   %esi,%esi
  8017bc:	75 19                	jne    8017d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8017be:	53                   	push   %ebx
  8017bf:	68 25 5d 80 00       	push   $0x805d25
  8017c4:	ff 75 0c             	pushl  0xc(%ebp)
  8017c7:	ff 75 08             	pushl  0x8(%ebp)
  8017ca:	e8 70 02 00 00       	call   801a3f <printfmt>
  8017cf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8017d2:	e9 5b 02 00 00       	jmp    801a32 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8017d7:	56                   	push   %esi
  8017d8:	68 2e 5d 80 00       	push   $0x805d2e
  8017dd:	ff 75 0c             	pushl  0xc(%ebp)
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	e8 57 02 00 00       	call   801a3f <printfmt>
  8017e8:	83 c4 10             	add    $0x10,%esp
			break;
  8017eb:	e9 42 02 00 00       	jmp    801a32 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8017f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f3:	83 c0 04             	add    $0x4,%eax
  8017f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8017f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fc:	83 e8 04             	sub    $0x4,%eax
  8017ff:	8b 30                	mov    (%eax),%esi
  801801:	85 f6                	test   %esi,%esi
  801803:	75 05                	jne    80180a <vprintfmt+0x1a6>
				p = "(null)";
  801805:	be 31 5d 80 00       	mov    $0x805d31,%esi
			if (width > 0 && padc != '-')
  80180a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80180e:	7e 6d                	jle    80187d <vprintfmt+0x219>
  801810:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801814:	74 67                	je     80187d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	50                   	push   %eax
  80181d:	56                   	push   %esi
  80181e:	e8 26 05 00 00       	call   801d49 <strnlen>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801829:	eb 16                	jmp    801841 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80182b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	ff 75 0c             	pushl  0xc(%ebp)
  801835:	50                   	push   %eax
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	ff d0                	call   *%eax
  80183b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80183e:	ff 4d e4             	decl   -0x1c(%ebp)
  801841:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801845:	7f e4                	jg     80182b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801847:	eb 34                	jmp    80187d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801849:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80184d:	74 1c                	je     80186b <vprintfmt+0x207>
  80184f:	83 fb 1f             	cmp    $0x1f,%ebx
  801852:	7e 05                	jle    801859 <vprintfmt+0x1f5>
  801854:	83 fb 7e             	cmp    $0x7e,%ebx
  801857:	7e 12                	jle    80186b <vprintfmt+0x207>
					putch('?', putdat);
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	6a 3f                	push   $0x3f
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	ff d0                	call   *%eax
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	eb 0f                	jmp    80187a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	53                   	push   %ebx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	ff d0                	call   *%eax
  801877:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80187a:	ff 4d e4             	decl   -0x1c(%ebp)
  80187d:	89 f0                	mov    %esi,%eax
  80187f:	8d 70 01             	lea    0x1(%eax),%esi
  801882:	8a 00                	mov    (%eax),%al
  801884:	0f be d8             	movsbl %al,%ebx
  801887:	85 db                	test   %ebx,%ebx
  801889:	74 24                	je     8018af <vprintfmt+0x24b>
  80188b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80188f:	78 b8                	js     801849 <vprintfmt+0x1e5>
  801891:	ff 4d e0             	decl   -0x20(%ebp)
  801894:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801898:	79 af                	jns    801849 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80189a:	eb 13                	jmp    8018af <vprintfmt+0x24b>
				putch(' ', putdat);
  80189c:	83 ec 08             	sub    $0x8,%esp
  80189f:	ff 75 0c             	pushl  0xc(%ebp)
  8018a2:	6a 20                	push   $0x20
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	ff d0                	call   *%eax
  8018a9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8018ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8018af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018b3:	7f e7                	jg     80189c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8018b5:	e9 78 01 00 00       	jmp    801a32 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8018ba:	83 ec 08             	sub    $0x8,%esp
  8018bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8018c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8018c3:	50                   	push   %eax
  8018c4:	e8 3c fd ff ff       	call   801605 <getint>
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8018d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d8:	85 d2                	test   %edx,%edx
  8018da:	79 23                	jns    8018ff <vprintfmt+0x29b>
				putch('-', putdat);
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	ff 75 0c             	pushl  0xc(%ebp)
  8018e2:	6a 2d                	push   $0x2d
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	ff d0                	call   *%eax
  8018e9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8018ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f2:	f7 d8                	neg    %eax
  8018f4:	83 d2 00             	adc    $0x0,%edx
  8018f7:	f7 da                	neg    %edx
  8018f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8018ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801906:	e9 bc 00 00 00       	jmp    8019c7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80190b:	83 ec 08             	sub    $0x8,%esp
  80190e:	ff 75 e8             	pushl  -0x18(%ebp)
  801911:	8d 45 14             	lea    0x14(%ebp),%eax
  801914:	50                   	push   %eax
  801915:	e8 84 fc ff ff       	call   80159e <getuint>
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801920:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801923:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80192a:	e9 98 00 00 00       	jmp    8019c7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80192f:	83 ec 08             	sub    $0x8,%esp
  801932:	ff 75 0c             	pushl  0xc(%ebp)
  801935:	6a 58                	push   $0x58
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	ff d0                	call   *%eax
  80193c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	6a 58                	push   $0x58
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	ff d0                	call   *%eax
  80194c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80194f:	83 ec 08             	sub    $0x8,%esp
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	6a 58                	push   $0x58
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	ff d0                	call   *%eax
  80195c:	83 c4 10             	add    $0x10,%esp
			break;
  80195f:	e9 ce 00 00 00       	jmp    801a32 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801964:	83 ec 08             	sub    $0x8,%esp
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	6a 30                	push   $0x30
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	ff d0                	call   *%eax
  801971:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	6a 78                	push   $0x78
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	ff d0                	call   *%eax
  801981:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801984:	8b 45 14             	mov    0x14(%ebp),%eax
  801987:	83 c0 04             	add    $0x4,%eax
  80198a:	89 45 14             	mov    %eax,0x14(%ebp)
  80198d:	8b 45 14             	mov    0x14(%ebp),%eax
  801990:	83 e8 04             	sub    $0x4,%eax
  801993:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801995:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80199f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8019a6:	eb 1f                	jmp    8019c7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8019a8:	83 ec 08             	sub    $0x8,%esp
  8019ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8019ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8019b1:	50                   	push   %eax
  8019b2:	e8 e7 fb ff ff       	call   80159e <getuint>
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8019c0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8019c7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8019cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	52                   	push   %edx
  8019d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019d5:	50                   	push   %eax
  8019d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	ff 75 08             	pushl  0x8(%ebp)
  8019e2:	e8 00 fb ff ff       	call   8014e7 <printnum>
  8019e7:	83 c4 20             	add    $0x20,%esp
			break;
  8019ea:	eb 46                	jmp    801a32 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8019ec:	83 ec 08             	sub    $0x8,%esp
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	53                   	push   %ebx
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	ff d0                	call   *%eax
  8019f8:	83 c4 10             	add    $0x10,%esp
			break;
  8019fb:	eb 35                	jmp    801a32 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8019fd:	c6 05 64 f0 81 00 00 	movb   $0x0,0x81f064
			break;
  801a04:	eb 2c                	jmp    801a32 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801a06:	c6 05 64 f0 81 00 01 	movb   $0x1,0x81f064
			break;
  801a0d:	eb 23                	jmp    801a32 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	6a 25                	push   $0x25
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	ff d0                	call   *%eax
  801a1c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801a1f:	ff 4d 10             	decl   0x10(%ebp)
  801a22:	eb 03                	jmp    801a27 <vprintfmt+0x3c3>
  801a24:	ff 4d 10             	decl   0x10(%ebp)
  801a27:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2a:	48                   	dec    %eax
  801a2b:	8a 00                	mov    (%eax),%al
  801a2d:	3c 25                	cmp    $0x25,%al
  801a2f:	75 f3                	jne    801a24 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801a31:	90                   	nop
		}
	}
  801a32:	e9 35 fc ff ff       	jmp    80166c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801a37:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801a38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    

00801a3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a45:	8d 45 10             	lea    0x10(%ebp),%eax
  801a48:	83 c0 04             	add    $0x4,%eax
  801a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a51:	ff 75 f4             	pushl  -0xc(%ebp)
  801a54:	50                   	push   %eax
  801a55:	ff 75 0c             	pushl  0xc(%ebp)
  801a58:	ff 75 08             	pushl  0x8(%ebp)
  801a5b:	e8 04 fc ff ff       	call   801664 <vprintfmt>
  801a60:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801a63:	90                   	nop
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6c:	8b 40 08             	mov    0x8(%eax),%eax
  801a6f:	8d 50 01             	lea    0x1(%eax),%edx
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a75:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7b:	8b 10                	mov    (%eax),%edx
  801a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a80:	8b 40 04             	mov    0x4(%eax),%eax
  801a83:	39 c2                	cmp    %eax,%edx
  801a85:	73 12                	jae    801a99 <sprintputch+0x33>
		*b->buf++ = ch;
  801a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8a:	8b 00                	mov    (%eax),%eax
  801a8c:	8d 48 01             	lea    0x1(%eax),%ecx
  801a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a92:	89 0a                	mov    %ecx,(%edx)
  801a94:	8b 55 08             	mov    0x8(%ebp),%edx
  801a97:	88 10                	mov    %dl,(%eax)
}
  801a99:	90                   	nop
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    

00801a9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aab:	8d 50 ff             	lea    -0x1(%eax),%edx
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	01 d0                	add    %edx,%eax
  801ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ab6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801abd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ac1:	74 06                	je     801ac9 <vsnprintf+0x2d>
  801ac3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ac7:	7f 07                	jg     801ad0 <vsnprintf+0x34>
		return -E_INVAL;
  801ac9:	b8 03 00 00 00       	mov    $0x3,%eax
  801ace:	eb 20                	jmp    801af0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ad0:	ff 75 14             	pushl  0x14(%ebp)
  801ad3:	ff 75 10             	pushl  0x10(%ebp)
  801ad6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ad9:	50                   	push   %eax
  801ada:	68 66 1a 80 00       	push   $0x801a66
  801adf:	e8 80 fb ff ff       	call   801664 <vprintfmt>
  801ae4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801af8:	8d 45 10             	lea    0x10(%ebp),%eax
  801afb:	83 c0 04             	add    $0x4,%eax
  801afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801b01:	8b 45 10             	mov    0x10(%ebp),%eax
  801b04:	ff 75 f4             	pushl  -0xc(%ebp)
  801b07:	50                   	push   %eax
  801b08:	ff 75 0c             	pushl  0xc(%ebp)
  801b0b:	ff 75 08             	pushl  0x8(%ebp)
  801b0e:	e8 89 ff ff ff       	call   801a9c <vsnprintf>
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801b24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b28:	74 13                	je     801b3d <readline+0x1f>
		cprintf("%s", prompt);
  801b2a:	83 ec 08             	sub    $0x8,%esp
  801b2d:	ff 75 08             	pushl  0x8(%ebp)
  801b30:	68 a8 5e 80 00       	push   $0x805ea8
  801b35:	e8 0b f9 ff ff       	call   801445 <cprintf>
  801b3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801b3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801b44:	83 ec 0c             	sub    $0xc,%esp
  801b47:	6a 00                	push   $0x0
  801b49:	e8 6f f4 ff ff       	call   800fbd <iscons>
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801b54:	e8 51 f4 ff ff       	call   800faa <getchar>
  801b59:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801b5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b60:	79 22                	jns    801b84 <readline+0x66>
			if (c != -E_EOF)
  801b62:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801b66:	0f 84 ad 00 00 00    	je     801c19 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801b6c:	83 ec 08             	sub    $0x8,%esp
  801b6f:	ff 75 ec             	pushl  -0x14(%ebp)
  801b72:	68 ab 5e 80 00       	push   $0x805eab
  801b77:	e8 c9 f8 ff ff       	call   801445 <cprintf>
  801b7c:	83 c4 10             	add    $0x10,%esp
			break;
  801b7f:	e9 95 00 00 00       	jmp    801c19 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801b84:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801b88:	7e 34                	jle    801bbe <readline+0xa0>
  801b8a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801b91:	7f 2b                	jg     801bbe <readline+0xa0>
			if (echoing)
  801b93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b97:	74 0e                	je     801ba7 <readline+0x89>
				cputchar(c);
  801b99:	83 ec 0c             	sub    $0xc,%esp
  801b9c:	ff 75 ec             	pushl  -0x14(%ebp)
  801b9f:	e8 e7 f3 ff ff       	call   800f8b <cputchar>
  801ba4:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baa:	8d 50 01             	lea    0x1(%eax),%edx
  801bad:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801bb0:	89 c2                	mov    %eax,%edx
  801bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb5:	01 d0                	add    %edx,%eax
  801bb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bba:	88 10                	mov    %dl,(%eax)
  801bbc:	eb 56                	jmp    801c14 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801bbe:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801bc2:	75 1f                	jne    801be3 <readline+0xc5>
  801bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bc8:	7e 19                	jle    801be3 <readline+0xc5>
			if (echoing)
  801bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bce:	74 0e                	je     801bde <readline+0xc0>
				cputchar(c);
  801bd0:	83 ec 0c             	sub    $0xc,%esp
  801bd3:	ff 75 ec             	pushl  -0x14(%ebp)
  801bd6:	e8 b0 f3 ff ff       	call   800f8b <cputchar>
  801bdb:	83 c4 10             	add    $0x10,%esp

			i--;
  801bde:	ff 4d f4             	decl   -0xc(%ebp)
  801be1:	eb 31                	jmp    801c14 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801be3:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801be7:	74 0a                	je     801bf3 <readline+0xd5>
  801be9:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801bed:	0f 85 61 ff ff ff    	jne    801b54 <readline+0x36>
			if (echoing)
  801bf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bf7:	74 0e                	je     801c07 <readline+0xe9>
				cputchar(c);
  801bf9:	83 ec 0c             	sub    $0xc,%esp
  801bfc:	ff 75 ec             	pushl  -0x14(%ebp)
  801bff:	e8 87 f3 ff ff       	call   800f8b <cputchar>
  801c04:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0d:	01 d0                	add    %edx,%eax
  801c0f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801c12:	eb 06                	jmp    801c1a <readline+0xfc>
		}
	}
  801c14:	e9 3b ff ff ff       	jmp    801b54 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801c19:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801c1a:	90                   	nop
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801c23:	e8 df 21 00 00       	call   803e07 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c2c:	74 13                	je     801c41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801c2e:	83 ec 08             	sub    $0x8,%esp
  801c31:	ff 75 08             	pushl  0x8(%ebp)
  801c34:	68 a8 5e 80 00       	push   $0x805ea8
  801c39:	e8 07 f8 ff ff       	call   801445 <cprintf>
  801c3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801c48:	83 ec 0c             	sub    $0xc,%esp
  801c4b:	6a 00                	push   $0x0
  801c4d:	e8 6b f3 ff ff       	call   800fbd <iscons>
  801c52:	83 c4 10             	add    $0x10,%esp
  801c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801c58:	e8 4d f3 ff ff       	call   800faa <getchar>
  801c5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801c60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c64:	79 22                	jns    801c88 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801c66:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801c6a:	0f 84 ad 00 00 00    	je     801d1d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801c70:	83 ec 08             	sub    $0x8,%esp
  801c73:	ff 75 ec             	pushl  -0x14(%ebp)
  801c76:	68 ab 5e 80 00       	push   $0x805eab
  801c7b:	e8 c5 f7 ff ff       	call   801445 <cprintf>
  801c80:	83 c4 10             	add    $0x10,%esp
				break;
  801c83:	e9 95 00 00 00       	jmp    801d1d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801c88:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801c8c:	7e 34                	jle    801cc2 <atomic_readline+0xa5>
  801c8e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801c95:	7f 2b                	jg     801cc2 <atomic_readline+0xa5>
				if (echoing)
  801c97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c9b:	74 0e                	je     801cab <atomic_readline+0x8e>
					cputchar(c);
  801c9d:	83 ec 0c             	sub    $0xc,%esp
  801ca0:	ff 75 ec             	pushl  -0x14(%ebp)
  801ca3:	e8 e3 f2 ff ff       	call   800f8b <cputchar>
  801ca8:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cae:	8d 50 01             	lea    0x1(%eax),%edx
  801cb1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801cb4:	89 c2                	mov    %eax,%edx
  801cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb9:	01 d0                	add    %edx,%eax
  801cbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cbe:	88 10                	mov    %dl,(%eax)
  801cc0:	eb 56                	jmp    801d18 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801cc2:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801cc6:	75 1f                	jne    801ce7 <atomic_readline+0xca>
  801cc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ccc:	7e 19                	jle    801ce7 <atomic_readline+0xca>
				if (echoing)
  801cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cd2:	74 0e                	je     801ce2 <atomic_readline+0xc5>
					cputchar(c);
  801cd4:	83 ec 0c             	sub    $0xc,%esp
  801cd7:	ff 75 ec             	pushl  -0x14(%ebp)
  801cda:	e8 ac f2 ff ff       	call   800f8b <cputchar>
  801cdf:	83 c4 10             	add    $0x10,%esp
				i--;
  801ce2:	ff 4d f4             	decl   -0xc(%ebp)
  801ce5:	eb 31                	jmp    801d18 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801ce7:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801ceb:	74 0a                	je     801cf7 <atomic_readline+0xda>
  801ced:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801cf1:	0f 85 61 ff ff ff    	jne    801c58 <atomic_readline+0x3b>
				if (echoing)
  801cf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cfb:	74 0e                	je     801d0b <atomic_readline+0xee>
					cputchar(c);
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	ff 75 ec             	pushl  -0x14(%ebp)
  801d03:	e8 83 f2 ff ff       	call   800f8b <cputchar>
  801d08:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d11:	01 d0                	add    %edx,%eax
  801d13:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801d16:	eb 06                	jmp    801d1e <atomic_readline+0x101>
			}
		}
  801d18:	e9 3b ff ff ff       	jmp    801c58 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801d1d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801d1e:	e8 fe 20 00 00       	call   803e21 <sys_unlock_cons>
}
  801d23:	90                   	nop
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d33:	eb 06                	jmp    801d3b <strlen+0x15>
		n++;
  801d35:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d38:	ff 45 08             	incl   0x8(%ebp)
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	8a 00                	mov    (%eax),%al
  801d40:	84 c0                	test   %al,%al
  801d42:	75 f1                	jne    801d35 <strlen+0xf>
		n++;
	return n;
  801d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d56:	eb 09                	jmp    801d61 <strnlen+0x18>
		n++;
  801d58:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d5b:	ff 45 08             	incl   0x8(%ebp)
  801d5e:	ff 4d 0c             	decl   0xc(%ebp)
  801d61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d65:	74 09                	je     801d70 <strnlen+0x27>
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	8a 00                	mov    (%eax),%al
  801d6c:	84 c0                	test   %al,%al
  801d6e:	75 e8                	jne    801d58 <strnlen+0xf>
		n++;
	return n;
  801d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801d81:	90                   	nop
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	8d 50 01             	lea    0x1(%eax),%edx
  801d88:	89 55 08             	mov    %edx,0x8(%ebp)
  801d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d94:	8a 12                	mov    (%edx),%dl
  801d96:	88 10                	mov    %dl,(%eax)
  801d98:	8a 00                	mov    (%eax),%al
  801d9a:	84 c0                	test   %al,%al
  801d9c:	75 e4                	jne    801d82 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801daf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801db6:	eb 1f                	jmp    801dd7 <strncpy+0x34>
		*dst++ = *src;
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	8d 50 01             	lea    0x1(%eax),%edx
  801dbe:	89 55 08             	mov    %edx,0x8(%ebp)
  801dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc4:	8a 12                	mov    (%edx),%dl
  801dc6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcb:	8a 00                	mov    (%eax),%al
  801dcd:	84 c0                	test   %al,%al
  801dcf:	74 03                	je     801dd4 <strncpy+0x31>
			src++;
  801dd1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801dd4:	ff 45 fc             	incl   -0x4(%ebp)
  801dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dda:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ddd:	72 d9                	jb     801db8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801df4:	74 30                	je     801e26 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801df6:	eb 16                	jmp    801e0e <strlcpy+0x2a>
			*dst++ = *src++;
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	8d 50 01             	lea    0x1(%eax),%edx
  801dfe:	89 55 08             	mov    %edx,0x8(%ebp)
  801e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e07:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e0a:	8a 12                	mov    (%edx),%dl
  801e0c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e0e:	ff 4d 10             	decl   0x10(%ebp)
  801e11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e15:	74 09                	je     801e20 <strlcpy+0x3c>
  801e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1a:	8a 00                	mov    (%eax),%al
  801e1c:	84 c0                	test   %al,%al
  801e1e:	75 d8                	jne    801df8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e26:	8b 55 08             	mov    0x8(%ebp),%edx
  801e29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e2c:	29 c2                	sub    %eax,%edx
  801e2e:	89 d0                	mov    %edx,%eax
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e35:	eb 06                	jmp    801e3d <strcmp+0xb>
		p++, q++;
  801e37:	ff 45 08             	incl   0x8(%ebp)
  801e3a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	8a 00                	mov    (%eax),%al
  801e42:	84 c0                	test   %al,%al
  801e44:	74 0e                	je     801e54 <strcmp+0x22>
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	8a 10                	mov    (%eax),%dl
  801e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4e:	8a 00                	mov    (%eax),%al
  801e50:	38 c2                	cmp    %al,%dl
  801e52:	74 e3                	je     801e37 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	8a 00                	mov    (%eax),%al
  801e59:	0f b6 d0             	movzbl %al,%edx
  801e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5f:	8a 00                	mov    (%eax),%al
  801e61:	0f b6 c0             	movzbl %al,%eax
  801e64:	29 c2                	sub    %eax,%edx
  801e66:	89 d0                	mov    %edx,%eax
}
  801e68:	5d                   	pop    %ebp
  801e69:	c3                   	ret    

00801e6a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801e6d:	eb 09                	jmp    801e78 <strncmp+0xe>
		n--, p++, q++;
  801e6f:	ff 4d 10             	decl   0x10(%ebp)
  801e72:	ff 45 08             	incl   0x8(%ebp)
  801e75:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801e78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e7c:	74 17                	je     801e95 <strncmp+0x2b>
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	8a 00                	mov    (%eax),%al
  801e83:	84 c0                	test   %al,%al
  801e85:	74 0e                	je     801e95 <strncmp+0x2b>
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	8a 10                	mov    (%eax),%dl
  801e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8f:	8a 00                	mov    (%eax),%al
  801e91:	38 c2                	cmp    %al,%dl
  801e93:	74 da                	je     801e6f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801e95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e99:	75 07                	jne    801ea2 <strncmp+0x38>
		return 0;
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea0:	eb 14                	jmp    801eb6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	8a 00                	mov    (%eax),%al
  801ea7:	0f b6 d0             	movzbl %al,%edx
  801eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ead:	8a 00                	mov    (%eax),%al
  801eaf:	0f b6 c0             	movzbl %al,%eax
  801eb2:	29 c2                	sub    %eax,%edx
  801eb4:	89 d0                	mov    %edx,%eax
}
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    

00801eb8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 04             	sub    $0x4,%esp
  801ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ec4:	eb 12                	jmp    801ed8 <strchr+0x20>
		if (*s == c)
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	8a 00                	mov    (%eax),%al
  801ecb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ece:	75 05                	jne    801ed5 <strchr+0x1d>
			return (char *) s;
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	eb 11                	jmp    801ee6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801ed5:	ff 45 08             	incl   0x8(%ebp)
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	84 c0                	test   %al,%al
  801edf:	75 e5                	jne    801ec6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ef4:	eb 0d                	jmp    801f03 <strfind+0x1b>
		if (*s == c)
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	8a 00                	mov    (%eax),%al
  801efb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801efe:	74 0e                	je     801f0e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f00:	ff 45 08             	incl   0x8(%ebp)
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	8a 00                	mov    (%eax),%al
  801f08:	84 c0                	test   %al,%al
  801f0a:	75 ea                	jne    801ef6 <strfind+0xe>
  801f0c:	eb 01                	jmp    801f0f <strfind+0x27>
		if (*s == c)
			break;
  801f0e:	90                   	nop
	return (char *) s;
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801f20:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f24:	76 63                	jbe    801f89 <memset+0x75>
		uint64 data_block = c;
  801f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f29:	99                   	cltd   
  801f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f36:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801f3a:	c1 e0 08             	shl    $0x8,%eax
  801f3d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f40:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f49:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801f4d:	c1 e0 10             	shl    $0x10,%eax
  801f50:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f53:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5c:	89 c2                	mov    %eax,%edx
  801f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f63:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f66:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801f69:	eb 18                	jmp    801f83 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801f6b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f6e:	8d 41 08             	lea    0x8(%ecx),%eax
  801f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7a:	89 01                	mov    %eax,(%ecx)
  801f7c:	89 51 04             	mov    %edx,0x4(%ecx)
  801f7f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801f83:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f87:	77 e2                	ja     801f6b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801f89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f8d:	74 23                	je     801fb2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f92:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801f95:	eb 0e                	jmp    801fa5 <memset+0x91>
			*p8++ = (uint8)c;
  801f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f9a:	8d 50 01             	lea    0x1(%eax),%edx
  801f9d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa8:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fab:	89 55 10             	mov    %edx,0x10(%ebp)
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	75 e5                	jne    801f97 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801fc9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801fcd:	76 24                	jbe    801ff3 <memcpy+0x3c>
		while(n >= 8){
  801fcf:	eb 1c                	jmp    801fed <memcpy+0x36>
			*d64 = *s64;
  801fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd4:	8b 50 04             	mov    0x4(%eax),%edx
  801fd7:	8b 00                	mov    (%eax),%eax
  801fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801fdc:	89 01                	mov    %eax,(%ecx)
  801fde:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801fe1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801fe5:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801fe9:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801fed:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801ff1:	77 de                	ja     801fd1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801ff3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ff7:	74 31                	je     80202a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801ff9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802002:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  802005:	eb 16                	jmp    80201d <memcpy+0x66>
			*d8++ = *s8++;
  802007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200a:	8d 50 01             	lea    0x1(%eax),%edx
  80200d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802013:	8d 4a 01             	lea    0x1(%edx),%ecx
  802016:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802019:	8a 12                	mov    (%edx),%dl
  80201b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80201d:	8b 45 10             	mov    0x10(%ebp),%eax
  802020:	8d 50 ff             	lea    -0x1(%eax),%edx
  802023:	89 55 10             	mov    %edx,0x10(%ebp)
  802026:	85 c0                	test   %eax,%eax
  802028:	75 dd                	jne    802007 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802035:	8b 45 0c             	mov    0xc(%ebp),%eax
  802038:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802044:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802047:	73 50                	jae    802099 <memmove+0x6a>
  802049:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80204c:	8b 45 10             	mov    0x10(%ebp),%eax
  80204f:	01 d0                	add    %edx,%eax
  802051:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802054:	76 43                	jbe    802099 <memmove+0x6a>
		s += n;
  802056:	8b 45 10             	mov    0x10(%ebp),%eax
  802059:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80205c:	8b 45 10             	mov    0x10(%ebp),%eax
  80205f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802062:	eb 10                	jmp    802074 <memmove+0x45>
			*--d = *--s;
  802064:	ff 4d f8             	decl   -0x8(%ebp)
  802067:	ff 4d fc             	decl   -0x4(%ebp)
  80206a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206d:	8a 10                	mov    (%eax),%dl
  80206f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802072:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802074:	8b 45 10             	mov    0x10(%ebp),%eax
  802077:	8d 50 ff             	lea    -0x1(%eax),%edx
  80207a:	89 55 10             	mov    %edx,0x10(%ebp)
  80207d:	85 c0                	test   %eax,%eax
  80207f:	75 e3                	jne    802064 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802081:	eb 23                	jmp    8020a6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802086:	8d 50 01             	lea    0x1(%eax),%edx
  802089:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80208c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80208f:	8d 4a 01             	lea    0x1(%edx),%ecx
  802092:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802095:	8a 12                	mov    (%edx),%dl
  802097:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802099:	8b 45 10             	mov    0x10(%ebp),%eax
  80209c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80209f:	89 55 10             	mov    %edx,0x10(%ebp)
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	75 dd                	jne    802083 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8020b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ba:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8020bd:	eb 2a                	jmp    8020e9 <memcmp+0x3e>
		if (*s1 != *s2)
  8020bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c2:	8a 10                	mov    (%eax),%dl
  8020c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c7:	8a 00                	mov    (%eax),%al
  8020c9:	38 c2                	cmp    %al,%dl
  8020cb:	74 16                	je     8020e3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8020cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d0:	8a 00                	mov    (%eax),%al
  8020d2:	0f b6 d0             	movzbl %al,%edx
  8020d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020d8:	8a 00                	mov    (%eax),%al
  8020da:	0f b6 c0             	movzbl %al,%eax
  8020dd:	29 c2                	sub    %eax,%edx
  8020df:	89 d0                	mov    %edx,%eax
  8020e1:	eb 18                	jmp    8020fb <memcmp+0x50>
		s1++, s2++;
  8020e3:	ff 45 fc             	incl   -0x4(%ebp)
  8020e6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8020e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	75 c9                	jne    8020bf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8020f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802103:	8b 55 08             	mov    0x8(%ebp),%edx
  802106:	8b 45 10             	mov    0x10(%ebp),%eax
  802109:	01 d0                	add    %edx,%eax
  80210b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80210e:	eb 15                	jmp    802125 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	8a 00                	mov    (%eax),%al
  802115:	0f b6 d0             	movzbl %al,%edx
  802118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211b:	0f b6 c0             	movzbl %al,%eax
  80211e:	39 c2                	cmp    %eax,%edx
  802120:	74 0d                	je     80212f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802122:	ff 45 08             	incl   0x8(%ebp)
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80212b:	72 e3                	jb     802110 <memfind+0x13>
  80212d:	eb 01                	jmp    802130 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80212f:	90                   	nop
	return (void *) s;
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80213b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802142:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802149:	eb 03                	jmp    80214e <strtol+0x19>
		s++;
  80214b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	3c 20                	cmp    $0x20,%al
  802155:	74 f4                	je     80214b <strtol+0x16>
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	8a 00                	mov    (%eax),%al
  80215c:	3c 09                	cmp    $0x9,%al
  80215e:	74 eb                	je     80214b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	8a 00                	mov    (%eax),%al
  802165:	3c 2b                	cmp    $0x2b,%al
  802167:	75 05                	jne    80216e <strtol+0x39>
		s++;
  802169:	ff 45 08             	incl   0x8(%ebp)
  80216c:	eb 13                	jmp    802181 <strtol+0x4c>
	else if (*s == '-')
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	8a 00                	mov    (%eax),%al
  802173:	3c 2d                	cmp    $0x2d,%al
  802175:	75 0a                	jne    802181 <strtol+0x4c>
		s++, neg = 1;
  802177:	ff 45 08             	incl   0x8(%ebp)
  80217a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802181:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802185:	74 06                	je     80218d <strtol+0x58>
  802187:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80218b:	75 20                	jne    8021ad <strtol+0x78>
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	8a 00                	mov    (%eax),%al
  802192:	3c 30                	cmp    $0x30,%al
  802194:	75 17                	jne    8021ad <strtol+0x78>
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	40                   	inc    %eax
  80219a:	8a 00                	mov    (%eax),%al
  80219c:	3c 78                	cmp    $0x78,%al
  80219e:	75 0d                	jne    8021ad <strtol+0x78>
		s += 2, base = 16;
  8021a0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8021a4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8021ab:	eb 28                	jmp    8021d5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8021ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021b1:	75 15                	jne    8021c8 <strtol+0x93>
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	8a 00                	mov    (%eax),%al
  8021b8:	3c 30                	cmp    $0x30,%al
  8021ba:	75 0c                	jne    8021c8 <strtol+0x93>
		s++, base = 8;
  8021bc:	ff 45 08             	incl   0x8(%ebp)
  8021bf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8021c6:	eb 0d                	jmp    8021d5 <strtol+0xa0>
	else if (base == 0)
  8021c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021cc:	75 07                	jne    8021d5 <strtol+0xa0>
		base = 10;
  8021ce:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8a 00                	mov    (%eax),%al
  8021da:	3c 2f                	cmp    $0x2f,%al
  8021dc:	7e 19                	jle    8021f7 <strtol+0xc2>
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	8a 00                	mov    (%eax),%al
  8021e3:	3c 39                	cmp    $0x39,%al
  8021e5:	7f 10                	jg     8021f7 <strtol+0xc2>
			dig = *s - '0';
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	8a 00                	mov    (%eax),%al
  8021ec:	0f be c0             	movsbl %al,%eax
  8021ef:	83 e8 30             	sub    $0x30,%eax
  8021f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f5:	eb 42                	jmp    802239 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	8a 00                	mov    (%eax),%al
  8021fc:	3c 60                	cmp    $0x60,%al
  8021fe:	7e 19                	jle    802219 <strtol+0xe4>
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	8a 00                	mov    (%eax),%al
  802205:	3c 7a                	cmp    $0x7a,%al
  802207:	7f 10                	jg     802219 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	8a 00                	mov    (%eax),%al
  80220e:	0f be c0             	movsbl %al,%eax
  802211:	83 e8 57             	sub    $0x57,%eax
  802214:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802217:	eb 20                	jmp    802239 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	8a 00                	mov    (%eax),%al
  80221e:	3c 40                	cmp    $0x40,%al
  802220:	7e 39                	jle    80225b <strtol+0x126>
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	8a 00                	mov    (%eax),%al
  802227:	3c 5a                	cmp    $0x5a,%al
  802229:	7f 30                	jg     80225b <strtol+0x126>
			dig = *s - 'A' + 10;
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	8a 00                	mov    (%eax),%al
  802230:	0f be c0             	movsbl %al,%eax
  802233:	83 e8 37             	sub    $0x37,%eax
  802236:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80223f:	7d 19                	jge    80225a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802241:	ff 45 08             	incl   0x8(%ebp)
  802244:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802247:	0f af 45 10          	imul   0x10(%ebp),%eax
  80224b:	89 c2                	mov    %eax,%edx
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	01 d0                	add    %edx,%eax
  802252:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802255:	e9 7b ff ff ff       	jmp    8021d5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80225a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80225b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80225f:	74 08                	je     802269 <strtol+0x134>
		*endptr = (char *) s;
  802261:	8b 45 0c             	mov    0xc(%ebp),%eax
  802264:	8b 55 08             	mov    0x8(%ebp),%edx
  802267:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802269:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80226d:	74 07                	je     802276 <strtol+0x141>
  80226f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802272:	f7 d8                	neg    %eax
  802274:	eb 03                	jmp    802279 <strtol+0x144>
  802276:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <ltostr>:

void
ltostr(long value, char *str)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802281:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802288:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80228f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802293:	79 13                	jns    8022a8 <ltostr+0x2d>
	{
		neg = 1;
  802295:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80229c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8022a2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8022a5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8022b0:	99                   	cltd   
  8022b1:	f7 f9                	idiv   %ecx
  8022b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8022b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022b9:	8d 50 01             	lea    0x1(%eax),%edx
  8022bc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022bf:	89 c2                	mov    %eax,%edx
  8022c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c4:	01 d0                	add    %edx,%eax
  8022c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022c9:	83 c2 30             	add    $0x30,%edx
  8022cc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8022ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8022d6:	f7 e9                	imul   %ecx
  8022d8:	c1 fa 02             	sar    $0x2,%edx
  8022db:	89 c8                	mov    %ecx,%eax
  8022dd:	c1 f8 1f             	sar    $0x1f,%eax
  8022e0:	29 c2                	sub    %eax,%edx
  8022e2:	89 d0                	mov    %edx,%eax
  8022e4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8022e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022eb:	75 bb                	jne    8022a8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8022ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8022f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022f7:	48                   	dec    %eax
  8022f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8022fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022ff:	74 3d                	je     80233e <ltostr+0xc3>
		start = 1 ;
  802301:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802308:	eb 34                	jmp    80233e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80230a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802310:	01 d0                	add    %edx,%eax
  802312:	8a 00                	mov    (%eax),%al
  802314:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802317:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231d:	01 c2                	add    %eax,%edx
  80231f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802322:	8b 45 0c             	mov    0xc(%ebp),%eax
  802325:	01 c8                	add    %ecx,%eax
  802327:	8a 00                	mov    (%eax),%al
  802329:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80232b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80232e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802331:	01 c2                	add    %eax,%edx
  802333:	8a 45 eb             	mov    -0x15(%ebp),%al
  802336:	88 02                	mov    %al,(%edx)
		start++ ;
  802338:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80233b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802344:	7c c4                	jl     80230a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802346:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234c:	01 d0                	add    %edx,%eax
  80234e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802351:	90                   	nop
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80235a:	ff 75 08             	pushl  0x8(%ebp)
  80235d:	e8 c4 f9 ff ff       	call   801d26 <strlen>
  802362:	83 c4 04             	add    $0x4,%esp
  802365:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802368:	ff 75 0c             	pushl  0xc(%ebp)
  80236b:	e8 b6 f9 ff ff       	call   801d26 <strlen>
  802370:	83 c4 04             	add    $0x4,%esp
  802373:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80237d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802384:	eb 17                	jmp    80239d <strcconcat+0x49>
		final[s] = str1[s] ;
  802386:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802389:	8b 45 10             	mov    0x10(%ebp),%eax
  80238c:	01 c2                	add    %eax,%edx
  80238e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	01 c8                	add    %ecx,%eax
  802396:	8a 00                	mov    (%eax),%al
  802398:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80239a:	ff 45 fc             	incl   -0x4(%ebp)
  80239d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8023a3:	7c e1                	jl     802386 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8023a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8023ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8023b3:	eb 1f                	jmp    8023d4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8023b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b8:	8d 50 01             	lea    0x1(%eax),%edx
  8023bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8023be:	89 c2                	mov    %eax,%edx
  8023c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c3:	01 c2                	add    %eax,%edx
  8023c5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8023c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cb:	01 c8                	add    %ecx,%eax
  8023cd:	8a 00                	mov    (%eax),%al
  8023cf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8023d1:	ff 45 f8             	incl   -0x8(%ebp)
  8023d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023da:	7c d9                	jl     8023b5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8023dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023df:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e2:	01 d0                	add    %edx,%eax
  8023e4:	c6 00 00             	movb   $0x0,(%eax)
}
  8023e7:	90                   	nop
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8023ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8023f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802402:	8b 45 10             	mov    0x10(%ebp),%eax
  802405:	01 d0                	add    %edx,%eax
  802407:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80240d:	eb 0c                	jmp    80241b <strsplit+0x31>
			*string++ = 0;
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	8d 50 01             	lea    0x1(%eax),%edx
  802415:	89 55 08             	mov    %edx,0x8(%ebp)
  802418:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	8a 00                	mov    (%eax),%al
  802420:	84 c0                	test   %al,%al
  802422:	74 18                	je     80243c <strsplit+0x52>
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	8a 00                	mov    (%eax),%al
  802429:	0f be c0             	movsbl %al,%eax
  80242c:	50                   	push   %eax
  80242d:	ff 75 0c             	pushl  0xc(%ebp)
  802430:	e8 83 fa ff ff       	call   801eb8 <strchr>
  802435:	83 c4 08             	add    $0x8,%esp
  802438:	85 c0                	test   %eax,%eax
  80243a:	75 d3                	jne    80240f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80243c:	8b 45 08             	mov    0x8(%ebp),%eax
  80243f:	8a 00                	mov    (%eax),%al
  802441:	84 c0                	test   %al,%al
  802443:	74 5a                	je     80249f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802445:	8b 45 14             	mov    0x14(%ebp),%eax
  802448:	8b 00                	mov    (%eax),%eax
  80244a:	83 f8 0f             	cmp    $0xf,%eax
  80244d:	75 07                	jne    802456 <strsplit+0x6c>
		{
			return 0;
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax
  802454:	eb 66                	jmp    8024bc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802456:	8b 45 14             	mov    0x14(%ebp),%eax
  802459:	8b 00                	mov    (%eax),%eax
  80245b:	8d 48 01             	lea    0x1(%eax),%ecx
  80245e:	8b 55 14             	mov    0x14(%ebp),%edx
  802461:	89 0a                	mov    %ecx,(%edx)
  802463:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80246a:	8b 45 10             	mov    0x10(%ebp),%eax
  80246d:	01 c2                	add    %eax,%edx
  80246f:	8b 45 08             	mov    0x8(%ebp),%eax
  802472:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802474:	eb 03                	jmp    802479 <strsplit+0x8f>
			string++;
  802476:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	8a 00                	mov    (%eax),%al
  80247e:	84 c0                	test   %al,%al
  802480:	74 8b                	je     80240d <strsplit+0x23>
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
  802485:	8a 00                	mov    (%eax),%al
  802487:	0f be c0             	movsbl %al,%eax
  80248a:	50                   	push   %eax
  80248b:	ff 75 0c             	pushl  0xc(%ebp)
  80248e:	e8 25 fa ff ff       	call   801eb8 <strchr>
  802493:	83 c4 08             	add    $0x8,%esp
  802496:	85 c0                	test   %eax,%eax
  802498:	74 dc                	je     802476 <strsplit+0x8c>
			string++;
	}
  80249a:	e9 6e ff ff ff       	jmp    80240d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80249f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8024a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8024a3:	8b 00                	mov    (%eax),%eax
  8024a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8024ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8024af:	01 d0                	add    %edx,%eax
  8024b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8024b7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8024ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024d1:	eb 4a                	jmp    80251d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8024d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	01 c2                	add    %eax,%edx
  8024db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e1:	01 c8                	add    %ecx,%eax
  8024e3:	8a 00                	mov    (%eax),%al
  8024e5:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8024e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ed:	01 d0                	add    %edx,%eax
  8024ef:	8a 00                	mov    (%eax),%al
  8024f1:	3c 40                	cmp    $0x40,%al
  8024f3:	7e 25                	jle    80251a <str2lower+0x5c>
  8024f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	8a 00                	mov    (%eax),%al
  8024ff:	3c 5a                	cmp    $0x5a,%al
  802501:	7f 17                	jg     80251a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802503:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	01 d0                	add    %edx,%eax
  80250b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80250e:	8b 55 08             	mov    0x8(%ebp),%edx
  802511:	01 ca                	add    %ecx,%edx
  802513:	8a 12                	mov    (%edx),%dl
  802515:	83 c2 20             	add    $0x20,%edx
  802518:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80251a:	ff 45 fc             	incl   -0x4(%ebp)
  80251d:	ff 75 0c             	pushl  0xc(%ebp)
  802520:	e8 01 f8 ff ff       	call   801d26 <strlen>
  802525:	83 c4 04             	add    $0x4,%esp
  802528:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80252b:	7f a6                	jg     8024d3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80252d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
  802535:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802538:	a1 08 70 80 00       	mov    0x807008,%eax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	74 42                	je     802583 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802541:	83 ec 08             	sub    $0x8,%esp
  802544:	68 00 00 00 82       	push   $0x82000000
  802549:	68 00 00 00 80       	push   $0x80000000
  80254e:	e8 b0 1e 00 00       	call   804403 <initialize_dynamic_allocator>
  802553:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802556:	e8 96 1c 00 00       	call   8041f1 <sys_get_uheap_strategy>
  80255b:	a3 80 70 83 00       	mov    %eax,0x837080
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802560:	a1 60 f0 81 00       	mov    0x81f060,%eax
  802565:	05 00 10 00 00       	add    $0x1000,%eax
  80256a:	a3 30 71 83 00       	mov    %eax,0x837130
		uheapPageAllocBreak = uheapPageAllocStart;
  80256f:	a1 30 71 83 00       	mov    0x837130,%eax
  802574:	a3 88 70 83 00       	mov    %eax,0x837088

		__firstTimeFlag = 0;
  802579:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  802580:	00 00 00 
	}
}
  802583:	90                   	nop
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80259a:	83 ec 08             	sub    $0x8,%esp
  80259d:	68 06 04 00 00       	push   $0x406
  8025a2:	50                   	push   %eax
  8025a3:	e8 93 18 00 00       	call   803e3b <__sys_allocate_page>
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8025ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025b2:	79 14                	jns    8025c8 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8025b4:	83 ec 04             	sub    $0x4,%esp
  8025b7:	68 bc 5e 80 00       	push   $0x805ebc
  8025bc:	6a 1f                	push   $0x1f
  8025be:	68 f8 5e 80 00       	push   $0x805ef8
  8025c3:	e8 af eb ff ff       	call   801177 <_panic>
	return 0;
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8025d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	50                   	push   %eax
  8025e7:	e8 96 18 00 00       	call   803e82 <__sys_unmap_frame>
  8025ec:	83 c4 10             	add    $0x10,%esp
  8025ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8025f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025f6:	79 14                	jns    80260c <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8025f8:	83 ec 04             	sub    $0x4,%esp
  8025fb:	68 04 5f 80 00       	push   $0x805f04
  802600:	6a 2a                	push   $0x2a
  802602:	68 f8 5e 80 00       	push   $0x805ef8
  802607:	e8 6b eb ff ff       	call   801177 <_panic>
}
  80260c:	90                   	nop
  80260d:	c9                   	leave  
  80260e:	c3                   	ret    

0080260f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
  802612:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802615:	e8 18 ff ff ff       	call   802532 <uheap_init>
	if (size == 0) return NULL ;
  80261a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80261e:	75 0a                	jne    80262a <malloc+0x1b>
  802620:	b8 00 00 00 00       	mov    $0x0,%eax
  802625:	e9 43 03 00 00       	jmp    80296d <malloc+0x35e>
	//==============================================================
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80262a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802631:	77 13                	ja     802646 <malloc+0x37>
    {
        return alloc_block(size);
  802633:	83 ec 0c             	sub    $0xc,%esp
  802636:	ff 75 08             	pushl  0x8(%ebp)
  802639:	e8 78 20 00 00       	call   8046b6 <alloc_block>
  80263e:	83 c4 10             	add    $0x10,%esp
  802641:	e9 27 03 00 00       	jmp    80296d <malloc+0x35e>
    }

    uint32 req = ROUNDUP(size, PAGE_SIZE);
  802646:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80264d:	8b 55 08             	mov    0x8(%ebp),%edx
  802650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802653:	01 d0                	add    %edx,%eax
  802655:	48                   	dec    %eax
  802656:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802659:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80265c:	ba 00 00 00 00       	mov    $0x0,%edx
  802661:	f7 75 dc             	divl   -0x24(%ebp)
  802664:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802667:	29 d0                	sub    %edx,%eax
  802669:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if (!uhp_inited)
  80266c:	a1 40 f0 81 00       	mov    0x81f040,%eax
  802671:	85 c0                	test   %eax,%eax
  802673:	75 0a                	jne    80267f <malloc+0x70>
    {
        uhp_inited = 1;
  802675:	c7 05 40 f0 81 00 01 	movl   $0x1,0x81f040
  80267c:	00 00 00 
    }

    int exactIdx = -1;
  80267f:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802686:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  80268d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802694:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80269b:	e9 85 00 00 00       	jmp    802725 <malloc+0x116>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  8026a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026a3:	89 d0                	mov    %edx,%eax
  8026a5:	01 c0                	add    %eax,%eax
  8026a7:	01 d0                	add    %edx,%eax
  8026a9:	c1 e0 02             	shl    $0x2,%eax
  8026ac:	05 48 30 81 00       	add    $0x813048,%eax
  8026b1:	8a 00                	mov    (%eax),%al
  8026b3:	84 c0                	test   %al,%al
  8026b5:	74 20                	je     8026d7 <malloc+0xc8>
  8026b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ba:	89 d0                	mov    %edx,%eax
  8026bc:	01 c0                	add    %eax,%eax
  8026be:	01 d0                	add    %edx,%eax
  8026c0:	c1 e0 02             	shl    $0x2,%eax
  8026c3:	05 44 30 81 00       	add    $0x813044,%eax
  8026c8:	8b 00                	mov    (%eax),%eax
  8026ca:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8026cd:	75 08                	jne    8026d7 <malloc+0xc8>
        {
            exactIdx = i;
  8026cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  8026d5:	eb 5b                	jmp    802732 <malloc+0x123>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  8026d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026da:	89 d0                	mov    %edx,%eax
  8026dc:	01 c0                	add    %eax,%eax
  8026de:	01 d0                	add    %edx,%eax
  8026e0:	c1 e0 02             	shl    $0x2,%eax
  8026e3:	05 48 30 81 00       	add    $0x813048,%eax
  8026e8:	8a 00                	mov    (%eax),%al
  8026ea:	84 c0                	test   %al,%al
  8026ec:	74 34                	je     802722 <malloc+0x113>
  8026ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026f1:	89 d0                	mov    %edx,%eax
  8026f3:	01 c0                	add    %eax,%eax
  8026f5:	01 d0                	add    %edx,%eax
  8026f7:	c1 e0 02             	shl    $0x2,%eax
  8026fa:	05 44 30 81 00       	add    $0x813044,%eax
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802704:	76 1c                	jbe    802722 <malloc+0x113>
        {
            worstSize = uhp_frees[i].size;
  802706:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802709:	89 d0                	mov    %edx,%eax
  80270b:	01 c0                	add    %eax,%eax
  80270d:	01 d0                	add    %edx,%eax
  80270f:	c1 e0 02             	shl    $0x2,%eax
  802712:	05 44 30 81 00       	add    $0x813044,%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  80271c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802722:	ff 45 e8             	incl   -0x18(%ebp)
  802725:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  80272c:	0f 8e 6e ff ff ff    	jle    8026a0 <malloc+0x91>
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }

    uint32 va = 0;
  802732:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802739:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  80273d:	74 7d                	je     8027bc <malloc+0x1ad>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  80273f:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802746:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802749:	89 d0                	mov    %edx,%eax
  80274b:	01 c0                	add    %eax,%eax
  80274d:	01 d0                	add    %edx,%eax
  80274f:	c1 e0 02             	shl    $0x2,%eax
  802752:	05 40 30 81 00       	add    $0x813040,%eax
  802757:	8b 10                	mov    (%eax),%edx
  802759:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80275c:	01 d0                	add    %edx,%eax
  80275e:	48                   	dec    %eax
  80275f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802762:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802765:	ba 00 00 00 00       	mov    $0x0,%edx
  80276a:	f7 75 bc             	divl   -0x44(%ebp)
  80276d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802770:	29 d0                	sub    %edx,%eax
  802772:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802775:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802778:	89 d0                	mov    %edx,%eax
  80277a:	01 c0                	add    %eax,%eax
  80277c:	01 d0                	add    %edx,%eax
  80277e:	c1 e0 02             	shl    $0x2,%eax
  802781:	05 48 30 81 00       	add    $0x813048,%eax
  802786:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802789:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278c:	89 d0                	mov    %edx,%eax
  80278e:	01 c0                	add    %eax,%eax
  802790:	01 d0                	add    %edx,%eax
  802792:	c1 e0 02             	shl    $0x2,%eax
  802795:	05 44 30 81 00       	add    $0x813044,%eax
  80279a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  8027a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a3:	89 d0                	mov    %edx,%eax
  8027a5:	01 c0                	add    %eax,%eax
  8027a7:	01 d0                	add    %edx,%eax
  8027a9:	c1 e0 02             	shl    $0x2,%eax
  8027ac:	05 40 30 81 00       	add    $0x813040,%eax
  8027b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b7:	e9 2d 01 00 00       	jmp    8028e9 <malloc+0x2da>
    }
    else if (worstIdx != -1)
  8027bc:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8027c0:	0f 84 ce 00 00 00    	je     802894 <malloc+0x285>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  8027c6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8027cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d0:	89 d0                	mov    %edx,%eax
  8027d2:	01 c0                	add    %eax,%eax
  8027d4:	01 d0                	add    %edx,%eax
  8027d6:	c1 e0 02             	shl    $0x2,%eax
  8027d9:	05 40 30 81 00       	add    $0x813040,%eax
  8027de:	8b 10                	mov    (%eax),%edx
  8027e0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027e3:	01 d0                	add    %edx,%eax
  8027e5:	48                   	dec    %eax
  8027e6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8027e9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f1:	f7 75 c4             	divl   -0x3c(%ebp)
  8027f4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027f7:	29 d0                	sub    %edx,%eax
  8027f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8027fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ff:	89 d0                	mov    %edx,%eax
  802801:	01 c0                	add    %eax,%eax
  802803:	01 d0                	add    %edx,%eax
  802805:	c1 e0 02             	shl    $0x2,%eax
  802808:	05 44 30 81 00       	add    $0x813044,%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802812:	75 47                	jne    80285b <malloc+0x24c>
        {
            uhp_frees[worstIdx].free = 0;
  802814:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802817:	89 d0                	mov    %edx,%eax
  802819:	01 c0                	add    %eax,%eax
  80281b:	01 d0                	add    %edx,%eax
  80281d:	c1 e0 02             	shl    $0x2,%eax
  802820:	05 48 30 81 00       	add    $0x813048,%eax
  802825:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802828:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282b:	89 d0                	mov    %edx,%eax
  80282d:	01 c0                	add    %eax,%eax
  80282f:	01 d0                	add    %edx,%eax
  802831:	c1 e0 02             	shl    $0x2,%eax
  802834:	05 44 30 81 00       	add    $0x813044,%eax
  802839:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  80283f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802842:	89 d0                	mov    %edx,%eax
  802844:	01 c0                	add    %eax,%eax
  802846:	01 d0                	add    %edx,%eax
  802848:	c1 e0 02             	shl    $0x2,%eax
  80284b:	05 40 30 81 00       	add    $0x813040,%eax
  802850:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802856:	e9 8e 00 00 00       	jmp    8028e9 <malloc+0x2da>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  80285b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80285e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802861:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802864:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802867:	89 d0                	mov    %edx,%eax
  802869:	01 c0                	add    %eax,%eax
  80286b:	01 d0                	add    %edx,%eax
  80286d:	c1 e0 02             	shl    $0x2,%eax
  802870:	05 40 30 81 00       	add    $0x813040,%eax
  802875:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80287d:	89 c2                	mov    %eax,%edx
  80287f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802882:	89 c8                	mov    %ecx,%eax
  802884:	01 c0                	add    %eax,%eax
  802886:	01 c8                	add    %ecx,%eax
  802888:	c1 e0 02             	shl    $0x2,%eax
  80288b:	05 44 30 81 00       	add    $0x813044,%eax
  802890:	89 10                	mov    %edx,(%eax)
  802892:	eb 55                	jmp    8028e9 <malloc+0x2da>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802894:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  80289b:	8b 15 88 70 83 00    	mov    0x837088,%edx
  8028a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028a4:	01 d0                	add    %edx,%eax
  8028a6:	48                   	dec    %eax
  8028a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8028aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b2:	f7 75 d0             	divl   -0x30(%ebp)
  8028b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028b8:	29 d0                	sub    %edx,%eax
  8028ba:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  8028bd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8028c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028c3:	01 d0                	add    %edx,%eax
  8028c5:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  8028ca:	76 0a                	jbe    8028d6 <malloc+0x2c7>
            return NULL;
  8028cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d1:	e9 97 00 00 00       	jmp    80296d <malloc+0x35e>
        va = start;
  8028d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8028d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  8028dc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8028df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028e2:	01 d0                	add    %edx,%eax
  8028e4:	a3 88 70 83 00       	mov    %eax,0x837088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8028e9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8028f0:	eb 5e                	jmp    802950 <malloc+0x341>
    {
        if (!uhp_allocs[i].used)
  8028f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028f5:	89 d0                	mov    %edx,%eax
  8028f7:	01 c0                	add    %eax,%eax
  8028f9:	01 d0                	add    %edx,%eax
  8028fb:	c1 e0 02             	shl    $0x2,%eax
  8028fe:	05 48 70 80 00       	add    $0x807048,%eax
  802903:	8a 00                	mov    (%eax),%al
  802905:	84 c0                	test   %al,%al
  802907:	75 44                	jne    80294d <malloc+0x33e>
        {
            uhp_allocs[i].va = va;
  802909:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80290c:	89 d0                	mov    %edx,%eax
  80290e:	01 c0                	add    %eax,%eax
  802910:	01 d0                	add    %edx,%eax
  802912:	c1 e0 02             	shl    $0x2,%eax
  802915:	8d 90 40 70 80 00    	lea    0x807040(%eax),%edx
  80291b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80291e:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  802920:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802923:	89 d0                	mov    %edx,%eax
  802925:	01 c0                	add    %eax,%eax
  802927:	01 d0                	add    %edx,%eax
  802929:	c1 e0 02             	shl    $0x2,%eax
  80292c:	8d 90 44 70 80 00    	lea    0x807044(%eax),%edx
  802932:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802935:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  802937:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80293a:	89 d0                	mov    %edx,%eax
  80293c:	01 c0                	add    %eax,%eax
  80293e:	01 d0                	add    %edx,%eax
  802940:	c1 e0 02             	shl    $0x2,%eax
  802943:	05 48 70 80 00       	add    $0x807048,%eax
  802948:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80294b:	eb 0c                	jmp    802959 <malloc+0x34a>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80294d:	ff 45 e0             	incl   -0x20(%ebp)
  802950:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802957:	7e 99                	jle    8028f2 <malloc+0x2e3>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    sys_allocate_user_mem(va, req);
  802959:	83 ec 08             	sub    $0x8,%esp
  80295c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80295f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802962:	e8 a2 19 00 00       	call   804309 <sys_allocate_user_mem>
  802967:	83 c4 10             	add    $0x10,%esp
    return (void*)va;
  80296a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80296d:	c9                   	leave  
  80296e:	c3                   	ret    

0080296f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	83 ec 38             	sub    $0x38,%esp
    if (virtual_address == NULL)
  802975:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802979:	0f 84 fa 03 00 00    	je     802d79 <free+0x40a>
        return;

    uint32 va = (uint32)virtual_address;
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  802985:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	79 1c                	jns    8029a8 <free+0x39>
  80298c:	81 7d d4 ff ff ff 81 	cmpl   $0x81ffffff,-0x2c(%ebp)
  802993:	77 13                	ja     8029a8 <free+0x39>
    {
        free_block(virtual_address);
  802995:	83 ec 0c             	sub    $0xc,%esp
  802998:	ff 75 08             	pushl  0x8(%ebp)
  80299b:	e8 09 21 00 00       	call   804aa9 <free_block>
  8029a0:	83 c4 10             	add    $0x10,%esp
        return;
  8029a3:	e9 d2 03 00 00       	jmp    802d7a <free+0x40b>
    }

    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8029a8:	a1 30 71 83 00       	mov    0x837130,%eax
  8029ad:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  8029b0:	72 09                	jb     8029bb <free+0x4c>
  8029b2:	81 7d d4 ff ff ff 9f 	cmpl   $0x9fffffff,-0x2c(%ebp)
  8029b9:	76 17                	jbe    8029d2 <free+0x63>
        panic("free: invalid address");
  8029bb:	83 ec 04             	sub    $0x4,%esp
  8029be:	68 41 5f 80 00       	push   $0x805f41
  8029c3:	68 9b 00 00 00       	push   $0x9b
  8029c8:	68 f8 5e 80 00       	push   $0x805ef8
  8029cd:	e8 a5 e7 ff ff       	call   801177 <_panic>

    uint32 size = 0;
  8029d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int idx = -1;
  8029d9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8029e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8029e7:	eb 50                	jmp    802a39 <free+0xca>
    {
        if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  8029e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ec:	89 d0                	mov    %edx,%eax
  8029ee:	01 c0                	add    %eax,%eax
  8029f0:	01 d0                	add    %edx,%eax
  8029f2:	c1 e0 02             	shl    $0x2,%eax
  8029f5:	05 48 70 80 00       	add    $0x807048,%eax
  8029fa:	8a 00                	mov    (%eax),%al
  8029fc:	84 c0                	test   %al,%al
  8029fe:	74 36                	je     802a36 <free+0xc7>
  802a00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a03:	89 d0                	mov    %edx,%eax
  802a05:	01 c0                	add    %eax,%eax
  802a07:	01 d0                	add    %edx,%eax
  802a09:	c1 e0 02             	shl    $0x2,%eax
  802a0c:	05 40 70 80 00       	add    $0x807040,%eax
  802a11:	8b 00                	mov    (%eax),%eax
  802a13:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802a16:	75 1e                	jne    802a36 <free+0xc7>
        {
            size = uhp_allocs[i].size;
  802a18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a1b:	89 d0                	mov    %edx,%eax
  802a1d:	01 c0                	add    %eax,%eax
  802a1f:	01 d0                	add    %edx,%eax
  802a21:	c1 e0 02             	shl    $0x2,%eax
  802a24:	05 44 70 80 00       	add    $0x807044,%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            idx = i;
  802a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
            break;
  802a34:	eb 0c                	jmp    802a42 <free+0xd3>
    if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
        panic("free: invalid address");

    uint32 size = 0;
    int idx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802a36:	ff 45 ec             	incl   -0x14(%ebp)
  802a39:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802a40:	7e a7                	jle    8029e9 <free+0x7a>
            size = uhp_allocs[i].size;
            idx = i;
            break;
        }
    }
    if (idx == -1 || size == 0)
  802a42:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802a46:	74 06                	je     802a4e <free+0xdf>
  802a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4c:	75 17                	jne    802a65 <free+0xf6>
        panic("free: unknown block");
  802a4e:	83 ec 04             	sub    $0x4,%esp
  802a51:	68 57 5f 80 00       	push   $0x805f57
  802a56:	68 a9 00 00 00       	push   $0xa9
  802a5b:	68 f8 5e 80 00       	push   $0x805ef8
  802a60:	e8 12 e7 ff ff       	call   801177 <_panic>

    uhp_allocs[idx].used = 0;
  802a65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a68:	89 d0                	mov    %edx,%eax
  802a6a:	01 c0                	add    %eax,%eax
  802a6c:	01 d0                	add    %edx,%eax
  802a6e:	c1 e0 02             	shl    $0x2,%eax
  802a71:	05 48 70 80 00       	add    $0x807048,%eax
  802a76:	c6 00 00             	movb   $0x0,(%eax)

    int fidx = -1;
  802a79:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802a80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802a87:	eb 64                	jmp    802aed <free+0x17e>
    {
        if (!uhp_frees[i].free)
  802a89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a8c:	89 d0                	mov    %edx,%eax
  802a8e:	01 c0                	add    %eax,%eax
  802a90:	01 d0                	add    %edx,%eax
  802a92:	c1 e0 02             	shl    $0x2,%eax
  802a95:	05 48 30 81 00       	add    $0x813048,%eax
  802a9a:	8a 00                	mov    (%eax),%al
  802a9c:	84 c0                	test   %al,%al
  802a9e:	75 4a                	jne    802aea <free+0x17b>
        {
            uhp_frees[i].va = va;
  802aa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802aa3:	89 d0                	mov    %edx,%eax
  802aa5:	01 c0                	add    %eax,%eax
  802aa7:	01 d0                	add    %edx,%eax
  802aa9:	c1 e0 02             	shl    $0x2,%eax
  802aac:	8d 90 40 30 81 00    	lea    0x813040(%eax),%edx
  802ab2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ab5:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].size = size;
  802ab7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802aba:	89 d0                	mov    %edx,%eax
  802abc:	01 c0                	add    %eax,%eax
  802abe:	01 d0                	add    %edx,%eax
  802ac0:	c1 e0 02             	shl    $0x2,%eax
  802ac3:	8d 90 44 30 81 00    	lea    0x813044(%eax),%edx
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	89 02                	mov    %eax,(%edx)
            uhp_frees[i].free = 1;
  802ace:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ad1:	89 d0                	mov    %edx,%eax
  802ad3:	01 c0                	add    %eax,%eax
  802ad5:	01 d0                	add    %edx,%eax
  802ad7:	c1 e0 02             	shl    $0x2,%eax
  802ada:	05 48 30 81 00       	add    $0x813048,%eax
  802adf:	c6 00 01             	movb   $0x1,(%eax)
            fidx = i;
  802ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae5:	89 45 e8             	mov    %eax,-0x18(%ebp)
            break;
  802ae8:	eb 0c                	jmp    802af6 <free+0x187>
        panic("free: unknown block");

    uhp_allocs[idx].used = 0;

    int fidx = -1;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802aea:	ff 45 e4             	incl   -0x1c(%ebp)
  802aed:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  802af4:	7e 93                	jle    802a89 <free+0x11a>
            fidx = i;
            break;
        }
    }

    if (fidx != -1)
  802af6:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  802afa:	0f 84 f1 01 00 00    	je     802cf1 <free+0x382>
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802b00:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802b07:	e9 d8 01 00 00       	jmp    802ce4 <free+0x375>
        {
            if (i == fidx) continue;
  802b0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b12:	0f 84 c8 01 00 00    	je     802ce0 <free+0x371>
            if (uhp_frees[i].free)
  802b18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b1b:	89 d0                	mov    %edx,%eax
  802b1d:	01 c0                	add    %eax,%eax
  802b1f:	01 d0                	add    %edx,%eax
  802b21:	c1 e0 02             	shl    $0x2,%eax
  802b24:	05 48 30 81 00       	add    $0x813048,%eax
  802b29:	8a 00                	mov    (%eax),%al
  802b2b:	84 c0                	test   %al,%al
  802b2d:	0f 84 ae 01 00 00    	je     802ce1 <free+0x372>
            {
                if (uhp_frees[i].va + uhp_frees[i].size == uhp_frees[fidx].va)
  802b33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b36:	89 d0                	mov    %edx,%eax
  802b38:	01 c0                	add    %eax,%eax
  802b3a:	01 d0                	add    %edx,%eax
  802b3c:	c1 e0 02             	shl    $0x2,%eax
  802b3f:	05 40 30 81 00       	add    $0x813040,%eax
  802b44:	8b 08                	mov    (%eax),%ecx
  802b46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b49:	89 d0                	mov    %edx,%eax
  802b4b:	01 c0                	add    %eax,%eax
  802b4d:	01 d0                	add    %edx,%eax
  802b4f:	c1 e0 02             	shl    $0x2,%eax
  802b52:	05 44 30 81 00       	add    $0x813044,%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	01 c1                	add    %eax,%ecx
  802b5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b5e:	89 d0                	mov    %edx,%eax
  802b60:	01 c0                	add    %eax,%eax
  802b62:	01 d0                	add    %edx,%eax
  802b64:	c1 e0 02             	shl    $0x2,%eax
  802b67:	05 40 30 81 00       	add    $0x813040,%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	39 c1                	cmp    %eax,%ecx
  802b70:	0f 85 a8 00 00 00    	jne    802c1e <free+0x2af>
                {
                    uhp_frees[fidx].va = uhp_frees[i].va;
  802b76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b79:	89 d0                	mov    %edx,%eax
  802b7b:	01 c0                	add    %eax,%eax
  802b7d:	01 d0                	add    %edx,%eax
  802b7f:	c1 e0 02             	shl    $0x2,%eax
  802b82:	05 40 30 81 00       	add    $0x813040,%eax
  802b87:	8b 10                	mov    (%eax),%edx
  802b89:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  802b8c:	89 c8                	mov    %ecx,%eax
  802b8e:	01 c0                	add    %eax,%eax
  802b90:	01 c8                	add    %ecx,%eax
  802b92:	c1 e0 02             	shl    $0x2,%eax
  802b95:	05 40 30 81 00       	add    $0x813040,%eax
  802b9a:	89 10                	mov    %edx,(%eax)
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802b9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b9f:	89 d0                	mov    %edx,%eax
  802ba1:	01 c0                	add    %eax,%eax
  802ba3:	01 d0                	add    %edx,%eax
  802ba5:	c1 e0 02             	shl    $0x2,%eax
  802ba8:	05 44 30 81 00       	add    $0x813044,%eax
  802bad:	8b 08                	mov    (%eax),%ecx
  802baf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bb2:	89 d0                	mov    %edx,%eax
  802bb4:	01 c0                	add    %eax,%eax
  802bb6:	01 d0                	add    %edx,%eax
  802bb8:	c1 e0 02             	shl    $0x2,%eax
  802bbb:	05 44 30 81 00       	add    $0x813044,%eax
  802bc0:	8b 00                	mov    (%eax),%eax
  802bc2:	01 c1                	add    %eax,%ecx
  802bc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bc7:	89 d0                	mov    %edx,%eax
  802bc9:	01 c0                	add    %eax,%eax
  802bcb:	01 d0                	add    %edx,%eax
  802bcd:	c1 e0 02             	shl    $0x2,%eax
  802bd0:	05 44 30 81 00       	add    $0x813044,%eax
  802bd5:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802bd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bda:	89 d0                	mov    %edx,%eax
  802bdc:	01 c0                	add    %eax,%eax
  802bde:	01 d0                	add    %edx,%eax
  802be0:	c1 e0 02             	shl    $0x2,%eax
  802be3:	05 48 30 81 00       	add    $0x813048,%eax
  802be8:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802beb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bee:	89 d0                	mov    %edx,%eax
  802bf0:	01 c0                	add    %eax,%eax
  802bf2:	01 d0                	add    %edx,%eax
  802bf4:	c1 e0 02             	shl    $0x2,%eax
  802bf7:	05 40 30 81 00       	add    $0x813040,%eax
  802bfc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802c02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c05:	89 d0                	mov    %edx,%eax
  802c07:	01 c0                	add    %eax,%eax
  802c09:	01 d0                	add    %edx,%eax
  802c0b:	c1 e0 02             	shl    $0x2,%eax
  802c0e:	05 44 30 81 00       	add    $0x813044,%eax
  802c13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c19:	e9 c3 00 00 00       	jmp    802ce1 <free+0x372>
                }
                else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[i].va)
  802c1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c21:	89 d0                	mov    %edx,%eax
  802c23:	01 c0                	add    %eax,%eax
  802c25:	01 d0                	add    %edx,%eax
  802c27:	c1 e0 02             	shl    $0x2,%eax
  802c2a:	05 40 30 81 00       	add    $0x813040,%eax
  802c2f:	8b 08                	mov    (%eax),%ecx
  802c31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c34:	89 d0                	mov    %edx,%eax
  802c36:	01 c0                	add    %eax,%eax
  802c38:	01 d0                	add    %edx,%eax
  802c3a:	c1 e0 02             	shl    $0x2,%eax
  802c3d:	05 44 30 81 00       	add    $0x813044,%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	01 c1                	add    %eax,%ecx
  802c46:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c49:	89 d0                	mov    %edx,%eax
  802c4b:	01 c0                	add    %eax,%eax
  802c4d:	01 d0                	add    %edx,%eax
  802c4f:	c1 e0 02             	shl    $0x2,%eax
  802c52:	05 40 30 81 00       	add    $0x813040,%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	39 c1                	cmp    %eax,%ecx
  802c5b:	0f 85 80 00 00 00    	jne    802ce1 <free+0x372>
                {
                    uhp_frees[fidx].size += uhp_frees[i].size;
  802c61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c64:	89 d0                	mov    %edx,%eax
  802c66:	01 c0                	add    %eax,%eax
  802c68:	01 d0                	add    %edx,%eax
  802c6a:	c1 e0 02             	shl    $0x2,%eax
  802c6d:	05 44 30 81 00       	add    $0x813044,%eax
  802c72:	8b 08                	mov    (%eax),%ecx
  802c74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c77:	89 d0                	mov    %edx,%eax
  802c79:	01 c0                	add    %eax,%eax
  802c7b:	01 d0                	add    %edx,%eax
  802c7d:	c1 e0 02             	shl    $0x2,%eax
  802c80:	05 44 30 81 00       	add    $0x813044,%eax
  802c85:	8b 00                	mov    (%eax),%eax
  802c87:	01 c1                	add    %eax,%ecx
  802c89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c8c:	89 d0                	mov    %edx,%eax
  802c8e:	01 c0                	add    %eax,%eax
  802c90:	01 d0                	add    %edx,%eax
  802c92:	c1 e0 02             	shl    $0x2,%eax
  802c95:	05 44 30 81 00       	add    $0x813044,%eax
  802c9a:	89 08                	mov    %ecx,(%eax)
                    uhp_frees[i].free = 0;
  802c9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c9f:	89 d0                	mov    %edx,%eax
  802ca1:	01 c0                	add    %eax,%eax
  802ca3:	01 d0                	add    %edx,%eax
  802ca5:	c1 e0 02             	shl    $0x2,%eax
  802ca8:	05 48 30 81 00       	add    $0x813048,%eax
  802cad:	c6 00 00             	movb   $0x0,(%eax)
                    uhp_frees[i].va = 0;
  802cb0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cb3:	89 d0                	mov    %edx,%eax
  802cb5:	01 c0                	add    %eax,%eax
  802cb7:	01 d0                	add    %edx,%eax
  802cb9:	c1 e0 02             	shl    $0x2,%eax
  802cbc:	05 40 30 81 00       	add    $0x813040,%eax
  802cc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    uhp_frees[i].size = 0;
  802cc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cca:	89 d0                	mov    %edx,%eax
  802ccc:	01 c0                	add    %eax,%eax
  802cce:	01 d0                	add    %edx,%eax
  802cd0:	c1 e0 02             	shl    $0x2,%eax
  802cd3:	05 44 30 81 00       	add    $0x813044,%eax
  802cd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cde:	eb 01                	jmp    802ce1 <free+0x372>

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
        {
            if (i == fidx) continue;
  802ce0:	90                   	nop
        }
    }

    if (fidx != -1)
    {
        for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802ce1:	ff 45 e0             	incl   -0x20(%ebp)
  802ce4:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  802ceb:	0f 8e 1b fe ff ff    	jle    802b0c <free+0x19d>
                }
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
  802cf1:	a1 30 71 83 00       	mov    0x837130,%eax
  802cf6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802cf9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  802d00:	eb 53                	jmp    802d55 <free+0x3e6>
    {
        if (uhp_allocs[i].used)
  802d02:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d05:	89 d0                	mov    %edx,%eax
  802d07:	01 c0                	add    %eax,%eax
  802d09:	01 d0                	add    %edx,%eax
  802d0b:	c1 e0 02             	shl    $0x2,%eax
  802d0e:	05 48 70 80 00       	add    $0x807048,%eax
  802d13:	8a 00                	mov    (%eax),%al
  802d15:	84 c0                	test   %al,%al
  802d17:	74 39                	je     802d52 <free+0x3e3>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
  802d19:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d1c:	89 d0                	mov    %edx,%eax
  802d1e:	01 c0                	add    %eax,%eax
  802d20:	01 d0                	add    %edx,%eax
  802d22:	c1 e0 02             	shl    $0x2,%eax
  802d25:	05 40 70 80 00       	add    $0x807040,%eax
  802d2a:	8b 08                	mov    (%eax),%ecx
  802d2c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d2f:	89 d0                	mov    %edx,%eax
  802d31:	01 c0                	add    %eax,%eax
  802d33:	01 d0                	add    %edx,%eax
  802d35:	c1 e0 02             	shl    $0x2,%eax
  802d38:	05 44 70 80 00       	add    $0x807044,%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	01 c8                	add    %ecx,%eax
  802d41:	89 45 d0             	mov    %eax,-0x30(%ebp)
            if (end > maxEnd) maxEnd = end;
  802d44:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d47:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d4a:	76 06                	jbe    802d52 <free+0x3e3>
  802d4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d4f:	89 45 dc             	mov    %eax,-0x24(%ebp)
            }
        }
    }

    uint32 maxEnd = uheapPageAllocStart;
    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  802d52:	ff 45 d8             	incl   -0x28(%ebp)
  802d55:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  802d5c:	7e a4                	jle    802d02 <free+0x393>
        {
            uint32 end = uhp_allocs[i].va + uhp_allocs[i].size;
            if (end > maxEnd) maxEnd = end;
        }
    }
    uheapPageAllocBreak = maxEnd;
  802d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d61:	a3 88 70 83 00       	mov    %eax,0x837088

    sys_free_user_mem(va, size);
  802d66:	83 ec 08             	sub    $0x8,%esp
  802d69:	ff 75 f4             	pushl  -0xc(%ebp)
  802d6c:	ff 75 d4             	pushl  -0x2c(%ebp)
  802d6f:	e8 79 15 00 00       	call   8042ed <sys_free_user_mem>
  802d74:	83 c4 10             	add    $0x10,%esp
  802d77:	eb 01                	jmp    802d7a <free+0x40b>
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
    if (virtual_address == NULL)
        return;
  802d79:	90                   	nop
        }
    }
    uheapPageAllocBreak = maxEnd;

    sys_free_user_mem(va, size);
}
  802d7a:	c9                   	leave  
  802d7b:	c3                   	ret    

00802d7c <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802d7c:	55                   	push   %ebp
  802d7d:	89 e5                	mov    %esp,%ebp
  802d7f:	83 ec 68             	sub    $0x68,%esp
  802d82:	8b 45 10             	mov    0x10(%ebp),%eax
  802d85:	88 45 a4             	mov    %al,-0x5c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802d88:	e8 a5 f7 ff ff       	call   802532 <uheap_init>
	if (size == 0) return NULL ;
  802d8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d91:	75 0a                	jne    802d9d <smalloc+0x21>
  802d93:	b8 00 00 00 00       	mov    $0x0,%eax
  802d98:	e9 37 03 00 00       	jmp    8030d4 <smalloc+0x358>
	//==============================================================
    uint32 req = ROUNDUP(size, PAGE_SIZE);
  802d9d:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  802da4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802daa:	01 d0                	add    %edx,%eax
  802dac:	48                   	dec    %eax
  802dad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802db0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802db3:	ba 00 00 00 00       	mov    $0x0,%edx
  802db8:	f7 75 dc             	divl   -0x24(%ebp)
  802dbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dbe:	29 d0                	sub    %edx,%eax
  802dc0:	89 45 d4             	mov    %eax,-0x2c(%ebp)


    int exactIdx = -1;
  802dc3:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  802dca:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  802dd1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802dd8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802ddf:	e9 85 00 00 00       	jmp    802e69 <smalloc+0xed>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  802de4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802de7:	89 d0                	mov    %edx,%eax
  802de9:	01 c0                	add    %eax,%eax
  802deb:	01 d0                	add    %edx,%eax
  802ded:	c1 e0 02             	shl    $0x2,%eax
  802df0:	05 48 30 81 00       	add    $0x813048,%eax
  802df5:	8a 00                	mov    (%eax),%al
  802df7:	84 c0                	test   %al,%al
  802df9:	74 20                	je     802e1b <smalloc+0x9f>
  802dfb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dfe:	89 d0                	mov    %edx,%eax
  802e00:	01 c0                	add    %eax,%eax
  802e02:	01 d0                	add    %edx,%eax
  802e04:	c1 e0 02             	shl    $0x2,%eax
  802e07:	05 44 30 81 00       	add    $0x813044,%eax
  802e0c:	8b 00                	mov    (%eax),%eax
  802e0e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802e11:	75 08                	jne    802e1b <smalloc+0x9f>
        {
            exactIdx = i;
  802e13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  802e19:	eb 5b                	jmp    802e76 <smalloc+0xfa>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  802e1b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e1e:	89 d0                	mov    %edx,%eax
  802e20:	01 c0                	add    %eax,%eax
  802e22:	01 d0                	add    %edx,%eax
  802e24:	c1 e0 02             	shl    $0x2,%eax
  802e27:	05 48 30 81 00       	add    $0x813048,%eax
  802e2c:	8a 00                	mov    (%eax),%al
  802e2e:	84 c0                	test   %al,%al
  802e30:	74 34                	je     802e66 <smalloc+0xea>
  802e32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e35:	89 d0                	mov    %edx,%eax
  802e37:	01 c0                	add    %eax,%eax
  802e39:	01 d0                	add    %edx,%eax
  802e3b:	c1 e0 02             	shl    $0x2,%eax
  802e3e:	05 44 30 81 00       	add    $0x813044,%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802e48:	76 1c                	jbe    802e66 <smalloc+0xea>
        {
            worstSize = uhp_frees[i].size;
  802e4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e4d:	89 d0                	mov    %edx,%eax
  802e4f:	01 c0                	add    %eax,%eax
  802e51:	01 d0                	add    %edx,%eax
  802e53:	c1 e0 02             	shl    $0x2,%eax
  802e56:	05 44 30 81 00       	add    $0x813044,%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  802e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e63:	89 45 f0             	mov    %eax,-0x10(%ebp)


    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  802e66:	ff 45 e8             	incl   -0x18(%ebp)
  802e69:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  802e70:	0f 8e 6e ff ff ff    	jle    802de4 <smalloc+0x68>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  802e76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  802e7d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  802e81:	74 7d                	je     802f00 <smalloc+0x184>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  802e83:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  802e8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e8d:	89 d0                	mov    %edx,%eax
  802e8f:	01 c0                	add    %eax,%eax
  802e91:	01 d0                	add    %edx,%eax
  802e93:	c1 e0 02             	shl    $0x2,%eax
  802e96:	05 40 30 81 00       	add    $0x813040,%eax
  802e9b:	8b 10                	mov    (%eax),%edx
  802e9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ea0:	01 d0                	add    %edx,%eax
  802ea2:	48                   	dec    %eax
  802ea3:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802ea6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ea9:	ba 00 00 00 00       	mov    $0x0,%edx
  802eae:	f7 75 bc             	divl   -0x44(%ebp)
  802eb1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802eb4:	29 d0                	sub    %edx,%eax
  802eb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  802eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebc:	89 d0                	mov    %edx,%eax
  802ebe:	01 c0                	add    %eax,%eax
  802ec0:	01 d0                	add    %edx,%eax
  802ec2:	c1 e0 02             	shl    $0x2,%eax
  802ec5:	05 48 30 81 00       	add    $0x813048,%eax
  802eca:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  802ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed0:	89 d0                	mov    %edx,%eax
  802ed2:	01 c0                	add    %eax,%eax
  802ed4:	01 d0                	add    %edx,%eax
  802ed6:	c1 e0 02             	shl    $0x2,%eax
  802ed9:	05 44 30 81 00       	add    $0x813044,%eax
  802ede:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  802ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee7:	89 d0                	mov    %edx,%eax
  802ee9:	01 c0                	add    %eax,%eax
  802eeb:	01 d0                	add    %edx,%eax
  802eed:	c1 e0 02             	shl    $0x2,%eax
  802ef0:	05 40 30 81 00       	add    $0x813040,%eax
  802ef5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efb:	e9 2d 01 00 00       	jmp    80302d <smalloc+0x2b1>
    }
    else if (worstIdx != -1)
  802f00:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802f04:	0f 84 ce 00 00 00    	je     802fd8 <smalloc+0x25c>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  802f0a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f14:	89 d0                	mov    %edx,%eax
  802f16:	01 c0                	add    %eax,%eax
  802f18:	01 d0                	add    %edx,%eax
  802f1a:	c1 e0 02             	shl    $0x2,%eax
  802f1d:	05 40 30 81 00       	add    $0x813040,%eax
  802f22:	8b 10                	mov    (%eax),%edx
  802f24:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f27:	01 d0                	add    %edx,%eax
  802f29:	48                   	dec    %eax
  802f2a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f2d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f30:	ba 00 00 00 00       	mov    $0x0,%edx
  802f35:	f7 75 c4             	divl   -0x3c(%ebp)
  802f38:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f3b:	29 d0                	sub    %edx,%eax
  802f3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  802f40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f43:	89 d0                	mov    %edx,%eax
  802f45:	01 c0                	add    %eax,%eax
  802f47:	01 d0                	add    %edx,%eax
  802f49:	c1 e0 02             	shl    $0x2,%eax
  802f4c:	05 44 30 81 00       	add    $0x813044,%eax
  802f51:	8b 00                	mov    (%eax),%eax
  802f53:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802f56:	75 47                	jne    802f9f <smalloc+0x223>
        {
            uhp_frees[worstIdx].free = 0;
  802f58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5b:	89 d0                	mov    %edx,%eax
  802f5d:	01 c0                	add    %eax,%eax
  802f5f:	01 d0                	add    %edx,%eax
  802f61:	c1 e0 02             	shl    $0x2,%eax
  802f64:	05 48 30 81 00       	add    $0x813048,%eax
  802f69:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  802f6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f6f:	89 d0                	mov    %edx,%eax
  802f71:	01 c0                	add    %eax,%eax
  802f73:	01 d0                	add    %edx,%eax
  802f75:	c1 e0 02             	shl    $0x2,%eax
  802f78:	05 44 30 81 00       	add    $0x813044,%eax
  802f7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  802f83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f86:	89 d0                	mov    %edx,%eax
  802f88:	01 c0                	add    %eax,%eax
  802f8a:	01 d0                	add    %edx,%eax
  802f8c:	c1 e0 02             	shl    $0x2,%eax
  802f8f:	05 40 30 81 00       	add    $0x813040,%eax
  802f94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9a:	e9 8e 00 00 00       	jmp    80302d <smalloc+0x2b1>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  802f9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fa2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fa5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  802fa8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fab:	89 d0                	mov    %edx,%eax
  802fad:	01 c0                	add    %eax,%eax
  802faf:	01 d0                	add    %edx,%eax
  802fb1:	c1 e0 02             	shl    $0x2,%eax
  802fb4:	05 40 30 81 00       	add    $0x813040,%eax
  802fb9:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  802fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbe:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802fc1:	89 c2                	mov    %eax,%edx
  802fc3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802fc6:	89 c8                	mov    %ecx,%eax
  802fc8:	01 c0                	add    %eax,%eax
  802fca:	01 c8                	add    %ecx,%eax
  802fcc:	c1 e0 02             	shl    $0x2,%eax
  802fcf:	05 44 30 81 00       	add    $0x813044,%eax
  802fd4:	89 10                	mov    %edx,(%eax)
  802fd6:	eb 55                	jmp    80302d <smalloc+0x2b1>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  802fd8:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802fdf:	8b 15 88 70 83 00    	mov    0x837088,%edx
  802fe5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fe8:	01 d0                	add    %edx,%eax
  802fea:	48                   	dec    %eax
  802feb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802fee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ff6:	f7 75 d0             	divl   -0x30(%ebp)
  802ff9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ffc:	29 d0                	sub    %edx,%eax
  802ffe:	89 45 c8             	mov    %eax,-0x38(%ebp)
        if (start + req > USER_HEAP_MAX)
  803001:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803004:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803007:	01 d0                	add    %edx,%eax
  803009:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  80300e:	76 0a                	jbe    80301a <smalloc+0x29e>
            return NULL;
  803010:	b8 00 00 00 00       	mov    $0x0,%eax
  803015:	e9 ba 00 00 00       	jmp    8030d4 <smalloc+0x358>
        va = start;
  80301a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80301d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  803020:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803023:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803026:	01 d0                	add    %edx,%eax
  803028:	a3 88 70 83 00       	mov    %eax,0x837088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80302d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803034:	eb 5e                	jmp    803094 <smalloc+0x318>
    {
        if (!uhp_allocs[i].used)
  803036:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803039:	89 d0                	mov    %edx,%eax
  80303b:	01 c0                	add    %eax,%eax
  80303d:	01 d0                	add    %edx,%eax
  80303f:	c1 e0 02             	shl    $0x2,%eax
  803042:	05 48 70 80 00       	add    $0x807048,%eax
  803047:	8a 00                	mov    (%eax),%al
  803049:	84 c0                	test   %al,%al
  80304b:	75 44                	jne    803091 <smalloc+0x315>
        {
            uhp_allocs[i].va = va;
  80304d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803050:	89 d0                	mov    %edx,%eax
  803052:	01 c0                	add    %eax,%eax
  803054:	01 d0                	add    %edx,%eax
  803056:	c1 e0 02             	shl    $0x2,%eax
  803059:	8d 90 40 70 80 00    	lea    0x807040(%eax),%edx
  80305f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803062:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  803064:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803067:	89 d0                	mov    %edx,%eax
  803069:	01 c0                	add    %eax,%eax
  80306b:	01 d0                	add    %edx,%eax
  80306d:	c1 e0 02             	shl    $0x2,%eax
  803070:	8d 90 44 70 80 00    	lea    0x807044(%eax),%edx
  803076:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803079:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  80307b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80307e:	89 d0                	mov    %edx,%eax
  803080:	01 c0                	add    %eax,%eax
  803082:	01 d0                	add    %edx,%eax
  803084:	c1 e0 02             	shl    $0x2,%eax
  803087:	05 48 70 80 00       	add    $0x807048,%eax
  80308c:	c6 00 01             	movb   $0x1,(%eax)
            break;
  80308f:	eb 0c                	jmp    80309d <smalloc+0x321>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803091:	ff 45 e0             	incl   -0x20(%ebp)
  803094:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80309b:	7e 99                	jle    803036 <smalloc+0x2ba>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_create_shared_object(sharedVarName, req, isWritable, (void*)va);
  80309d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030a0:	0f b6 45 a4          	movzbl -0x5c(%ebp),%eax
  8030a4:	52                   	push   %edx
  8030a5:	50                   	push   %eax
  8030a6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8030a9:	ff 75 08             	pushl  0x8(%ebp)
  8030ac:	e8 de 0e 00 00       	call   803f8f <sys_create_shared_object>
  8030b1:	83 c4 10             	add    $0x10,%esp
  8030b4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (r == E_SHARED_MEM_EXISTS)
  8030b7:	83 7d b4 f1          	cmpl   $0xfffffff1,-0x4c(%ebp)
  8030bb:	75 07                	jne    8030c4 <smalloc+0x348>
        return (void*)E_SHARED_MEM_EXISTS;
  8030bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8030c2:	eb 10                	jmp    8030d4 <smalloc+0x358>
    if (r < 0)
  8030c4:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8030c8:	79 07                	jns    8030d1 <smalloc+0x355>
        return NULL;
  8030ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8030cf:	eb 03                	jmp    8030d4 <smalloc+0x358>
    return (void*)va;
  8030d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  8030d4:	c9                   	leave  
  8030d5:	c3                   	ret    

008030d6 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8030d6:	55                   	push   %ebp
  8030d7:	89 e5                	mov    %esp,%ebp
  8030d9:	83 ec 58             	sub    $0x58,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8030dc:	e8 51 f4 ff ff       	call   802532 <uheap_init>
	//==============================================================
    int sz = sys_size_of_shared_object(ownerEnvID, sharedVarName);
  8030e1:	83 ec 08             	sub    $0x8,%esp
  8030e4:	ff 75 0c             	pushl  0xc(%ebp)
  8030e7:	ff 75 08             	pushl  0x8(%ebp)
  8030ea:	e8 ca 0e 00 00       	call   803fb9 <sys_size_of_shared_object>
  8030ef:	83 c4 10             	add    $0x10,%esp
  8030f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (sz <= 0)
  8030f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030f9:	7f 0a                	jg     803105 <sget+0x2f>
        return NULL;
  8030fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803100:	e9 28 03 00 00       	jmp    80342d <sget+0x357>
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);
  803105:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80310c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80310f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803112:	01 d0                	add    %edx,%eax
  803114:	48                   	dec    %eax
  803115:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803118:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80311b:	ba 00 00 00 00       	mov    $0x0,%edx
  803120:	f7 75 d8             	divl   -0x28(%ebp)
  803123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803126:	29 d0                	sub    %edx,%eax
  803128:	89 45 d0             	mov    %eax,-0x30(%ebp)

    int exactIdx = -1;
  80312b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    int worstIdx = -1;
  803132:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    uint32 worstSize = 0;
  803139:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  803140:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803147:	e9 85 00 00 00       	jmp    8031d1 <sget+0xfb>
    {
        if (uhp_frees[i].free && uhp_frees[i].size == req)
  80314c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80314f:	89 d0                	mov    %edx,%eax
  803151:	01 c0                	add    %eax,%eax
  803153:	01 d0                	add    %edx,%eax
  803155:	c1 e0 02             	shl    $0x2,%eax
  803158:	05 48 30 81 00       	add    $0x813048,%eax
  80315d:	8a 00                	mov    (%eax),%al
  80315f:	84 c0                	test   %al,%al
  803161:	74 20                	je     803183 <sget+0xad>
  803163:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803166:	89 d0                	mov    %edx,%eax
  803168:	01 c0                	add    %eax,%eax
  80316a:	01 d0                	add    %edx,%eax
  80316c:	c1 e0 02             	shl    $0x2,%eax
  80316f:	05 44 30 81 00       	add    $0x813044,%eax
  803174:	8b 00                	mov    (%eax),%eax
  803176:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803179:	75 08                	jne    803183 <sget+0xad>
        {
            exactIdx = i;
  80317b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  803181:	eb 5b                	jmp    8031de <sget+0x108>
        }
        if (uhp_frees[i].free && uhp_frees[i].size > worstSize)
  803183:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803186:	89 d0                	mov    %edx,%eax
  803188:	01 c0                	add    %eax,%eax
  80318a:	01 d0                	add    %edx,%eax
  80318c:	c1 e0 02             	shl    $0x2,%eax
  80318f:	05 48 30 81 00       	add    $0x813048,%eax
  803194:	8a 00                	mov    (%eax),%al
  803196:	84 c0                	test   %al,%al
  803198:	74 34                	je     8031ce <sget+0xf8>
  80319a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80319d:	89 d0                	mov    %edx,%eax
  80319f:	01 c0                	add    %eax,%eax
  8031a1:	01 d0                	add    %edx,%eax
  8031a3:	c1 e0 02             	shl    $0x2,%eax
  8031a6:	05 44 30 81 00       	add    $0x813044,%eax
  8031ab:	8b 00                	mov    (%eax),%eax
  8031ad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8031b0:	76 1c                	jbe    8031ce <sget+0xf8>
        {
            worstSize = uhp_frees[i].size;
  8031b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b5:	89 d0                	mov    %edx,%eax
  8031b7:	01 c0                	add    %eax,%eax
  8031b9:	01 d0                	add    %edx,%eax
  8031bb:	c1 e0 02             	shl    $0x2,%eax
  8031be:	05 44 30 81 00       	add    $0x813044,%eax
  8031c3:	8b 00                	mov    (%eax),%eax
  8031c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
            worstIdx = i;
  8031c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32 req = ROUNDUP((uint32)sz, PAGE_SIZE);

    int exactIdx = -1;
    int worstIdx = -1;
    uint32 worstSize = 0;
    for (int i = 0; i < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); i++)
  8031ce:	ff 45 e8             	incl   -0x18(%ebp)
  8031d1:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8031d8:	0f 8e 6e ff ff ff    	jle    80314c <sget+0x76>
        {
            worstSize = uhp_frees[i].size;
            worstIdx = i;
        }
    }
    uint32 va = 0;
  8031de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (exactIdx != -1)
  8031e5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  8031e9:	74 7d                	je     803268 <sget+0x192>
    {
        va = ROUNDUP(uhp_frees[exactIdx].va, PAGE_SIZE);
  8031eb:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8031f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f5:	89 d0                	mov    %edx,%eax
  8031f7:	01 c0                	add    %eax,%eax
  8031f9:	01 d0                	add    %edx,%eax
  8031fb:	c1 e0 02             	shl    $0x2,%eax
  8031fe:	05 40 30 81 00       	add    $0x813040,%eax
  803203:	8b 10                	mov    (%eax),%edx
  803205:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803208:	01 d0                	add    %edx,%eax
  80320a:	48                   	dec    %eax
  80320b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80320e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803211:	ba 00 00 00 00       	mov    $0x0,%edx
  803216:	f7 75 b8             	divl   -0x48(%ebp)
  803219:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80321c:	29 d0                	sub    %edx,%eax
  80321e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uhp_frees[exactIdx].free = 0;
  803221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803224:	89 d0                	mov    %edx,%eax
  803226:	01 c0                	add    %eax,%eax
  803228:	01 d0                	add    %edx,%eax
  80322a:	c1 e0 02             	shl    $0x2,%eax
  80322d:	05 48 30 81 00       	add    $0x813048,%eax
  803232:	c6 00 00             	movb   $0x0,(%eax)
        uhp_frees[exactIdx].size = 0;
  803235:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803238:	89 d0                	mov    %edx,%eax
  80323a:	01 c0                	add    %eax,%eax
  80323c:	01 d0                	add    %edx,%eax
  80323e:	c1 e0 02             	shl    $0x2,%eax
  803241:	05 44 30 81 00       	add    $0x813044,%eax
  803246:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        uhp_frees[exactIdx].va = 0;
  80324c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80324f:	89 d0                	mov    %edx,%eax
  803251:	01 c0                	add    %eax,%eax
  803253:	01 d0                	add    %edx,%eax
  803255:	c1 e0 02             	shl    $0x2,%eax
  803258:	05 40 30 81 00       	add    $0x813040,%eax
  80325d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803263:	e9 2d 01 00 00       	jmp    803395 <sget+0x2bf>
    }
    else if (worstIdx != -1)
  803268:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80326c:	0f 84 ce 00 00 00    	je     803340 <sget+0x26a>
    {
        va = ROUNDUP(uhp_frees[worstIdx].va, PAGE_SIZE);
  803272:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  803279:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80327c:	89 d0                	mov    %edx,%eax
  80327e:	01 c0                	add    %eax,%eax
  803280:	01 d0                	add    %edx,%eax
  803282:	c1 e0 02             	shl    $0x2,%eax
  803285:	05 40 30 81 00       	add    $0x813040,%eax
  80328a:	8b 10                	mov    (%eax),%edx
  80328c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80328f:	01 d0                	add    %edx,%eax
  803291:	48                   	dec    %eax
  803292:	89 45 bc             	mov    %eax,-0x44(%ebp)
  803295:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803298:	ba 00 00 00 00       	mov    $0x0,%edx
  80329d:	f7 75 c0             	divl   -0x40(%ebp)
  8032a0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8032a3:	29 d0                	sub    %edx,%eax
  8032a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (uhp_frees[worstIdx].size == req)
  8032a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ab:	89 d0                	mov    %edx,%eax
  8032ad:	01 c0                	add    %eax,%eax
  8032af:	01 d0                	add    %edx,%eax
  8032b1:	c1 e0 02             	shl    $0x2,%eax
  8032b4:	05 44 30 81 00       	add    $0x813044,%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8032be:	75 47                	jne    803307 <sget+0x231>
        {
            uhp_frees[worstIdx].free = 0;
  8032c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c3:	89 d0                	mov    %edx,%eax
  8032c5:	01 c0                	add    %eax,%eax
  8032c7:	01 d0                	add    %edx,%eax
  8032c9:	c1 e0 02             	shl    $0x2,%eax
  8032cc:	05 48 30 81 00       	add    $0x813048,%eax
  8032d1:	c6 00 00             	movb   $0x0,(%eax)
            uhp_frees[worstIdx].size = 0;
  8032d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032d7:	89 d0                	mov    %edx,%eax
  8032d9:	01 c0                	add    %eax,%eax
  8032db:	01 d0                	add    %edx,%eax
  8032dd:	c1 e0 02             	shl    $0x2,%eax
  8032e0:	05 44 30 81 00       	add    $0x813044,%eax
  8032e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            uhp_frees[worstIdx].va = 0;
  8032eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ee:	89 d0                	mov    %edx,%eax
  8032f0:	01 c0                	add    %eax,%eax
  8032f2:	01 d0                	add    %edx,%eax
  8032f4:	c1 e0 02             	shl    $0x2,%eax
  8032f7:	05 40 30 81 00       	add    $0x813040,%eax
  8032fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803302:	e9 8e 00 00 00       	jmp    803395 <sget+0x2bf>
        }
        else
        {
            uhp_frees[worstIdx].va = va + req;
  803307:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80330a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80330d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  803310:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803313:	89 d0                	mov    %edx,%eax
  803315:	01 c0                	add    %eax,%eax
  803317:	01 d0                	add    %edx,%eax
  803319:	c1 e0 02             	shl    $0x2,%eax
  80331c:	05 40 30 81 00       	add    $0x813040,%eax
  803321:	89 08                	mov    %ecx,(%eax)
            uhp_frees[worstIdx].size = worstSize - req;
  803323:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803326:	2b 45 d0             	sub    -0x30(%ebp),%eax
  803329:	89 c2                	mov    %eax,%edx
  80332b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80332e:	89 c8                	mov    %ecx,%eax
  803330:	01 c0                	add    %eax,%eax
  803332:	01 c8                	add    %ecx,%eax
  803334:	c1 e0 02             	shl    $0x2,%eax
  803337:	05 44 30 81 00       	add    $0x813044,%eax
  80333c:	89 10                	mov    %edx,(%eax)
  80333e:	eb 55                	jmp    803395 <sget+0x2bf>
        }
    }
    else
    {
        uint32 start = ROUNDUP(uheapPageAllocBreak, PAGE_SIZE);
  803340:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  803347:	8b 15 88 70 83 00    	mov    0x837088,%edx
  80334d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803350:	01 d0                	add    %edx,%eax
  803352:	48                   	dec    %eax
  803353:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803356:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803359:	ba 00 00 00 00       	mov    $0x0,%edx
  80335e:	f7 75 cc             	divl   -0x34(%ebp)
  803361:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803364:	29 d0                	sub    %edx,%eax
  803366:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        if (start + req > USER_HEAP_MAX)
  803369:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80336c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80336f:	01 d0                	add    %edx,%eax
  803371:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  803376:	76 0a                	jbe    803382 <sget+0x2ac>
            return NULL;
  803378:	b8 00 00 00 00       	mov    $0x0,%eax
  80337d:	e9 ab 00 00 00       	jmp    80342d <sget+0x357>
        va = start;
  803382:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803385:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        uheapPageAllocBreak = start + req;
  803388:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80338b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80338e:	01 d0                	add    %edx,%eax
  803390:	a3 88 70 83 00       	mov    %eax,0x837088
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803395:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80339c:	eb 5e                	jmp    8033fc <sget+0x326>
    {
        if (!uhp_allocs[i].used)
  80339e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033a1:	89 d0                	mov    %edx,%eax
  8033a3:	01 c0                	add    %eax,%eax
  8033a5:	01 d0                	add    %edx,%eax
  8033a7:	c1 e0 02             	shl    $0x2,%eax
  8033aa:	05 48 70 80 00       	add    $0x807048,%eax
  8033af:	8a 00                	mov    (%eax),%al
  8033b1:	84 c0                	test   %al,%al
  8033b3:	75 44                	jne    8033f9 <sget+0x323>
        {
            uhp_allocs[i].va = va;
  8033b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033b8:	89 d0                	mov    %edx,%eax
  8033ba:	01 c0                	add    %eax,%eax
  8033bc:	01 d0                	add    %edx,%eax
  8033be:	c1 e0 02             	shl    $0x2,%eax
  8033c1:	8d 90 40 70 80 00    	lea    0x807040(%eax),%edx
  8033c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ca:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].size = req;
  8033cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033cf:	89 d0                	mov    %edx,%eax
  8033d1:	01 c0                	add    %eax,%eax
  8033d3:	01 d0                	add    %edx,%eax
  8033d5:	c1 e0 02             	shl    $0x2,%eax
  8033d8:	8d 90 44 70 80 00    	lea    0x807044(%eax),%edx
  8033de:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033e1:	89 02                	mov    %eax,(%edx)
            uhp_allocs[i].used = 1;
  8033e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033e6:	89 d0                	mov    %edx,%eax
  8033e8:	01 c0                	add    %eax,%eax
  8033ea:	01 d0                	add    %edx,%eax
  8033ec:	c1 e0 02             	shl    $0x2,%eax
  8033ef:	05 48 70 80 00       	add    $0x807048,%eax
  8033f4:	c6 00 01             	movb   $0x1,(%eax)
            break;
  8033f7:	eb 0c                	jmp    803405 <sget+0x32f>
            return NULL;
        va = start;
        uheapPageAllocBreak = start + req;
    }

    for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  8033f9:	ff 45 e0             	incl   -0x20(%ebp)
  8033fc:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803403:	7e 99                	jle    80339e <sget+0x2c8>
            uhp_allocs[i].used = 1;
            break;
        }
    }

    int r = sys_get_shared_object(ownerEnvID, sharedVarName, (void*)va);
  803405:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803408:	83 ec 04             	sub    $0x4,%esp
  80340b:	50                   	push   %eax
  80340c:	ff 75 0c             	pushl  0xc(%ebp)
  80340f:	ff 75 08             	pushl  0x8(%ebp)
  803412:	e8 bf 0b 00 00       	call   803fd6 <sys_get_shared_object>
  803417:	83 c4 10             	add    $0x10,%esp
  80341a:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (r < 0)
  80341d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803421:	79 07                	jns    80342a <sget+0x354>
        return NULL;
  803423:	b8 00 00 00 00       	mov    $0x0,%eax
  803428:	eb 03                	jmp    80342d <sget+0x357>
    return (void*)va;
  80342a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  80342d:	c9                   	leave  
  80342e:	c3                   	ret    

0080342f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80342f:	55                   	push   %ebp
  803430:	89 e5                	mov    %esp,%ebp
  803432:	83 ec 68             	sub    $0x68,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803435:	e8 f8 f0 ff ff       	call   802532 <uheap_init>
	//==============================================================
	if (virtual_address == NULL)
  80343a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80343e:	75 13                	jne    803453 <realloc+0x24>
		return malloc(new_size);
  803440:	83 ec 0c             	sub    $0xc,%esp
  803443:	ff 75 0c             	pushl  0xc(%ebp)
  803446:	e8 c4 f1 ff ff       	call   80260f <malloc>
  80344b:	83 c4 10             	add    $0x10,%esp
  80344e:	e9 f4 05 00 00       	jmp    803a47 <realloc+0x618>
	if (new_size == 0)
  803453:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803457:	75 18                	jne    803471 <realloc+0x42>
	{
		free(virtual_address);
  803459:	83 ec 0c             	sub    $0xc,%esp
  80345c:	ff 75 08             	pushl  0x8(%ebp)
  80345f:	e8 0b f5 ff ff       	call   80296f <free>
  803464:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803467:	b8 00 00 00 00       	mov    $0x0,%eax
  80346c:	e9 d6 05 00 00       	jmp    803a47 <realloc+0x618>
	}
	uint32 va = (uint32)virtual_address;
  803471:	8b 45 08             	mov    0x8(%ebp),%eax
  803474:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (va >= USER_HEAP_START && va < (USER_HEAP_START + DYN_ALLOC_MAX_SIZE))
  803477:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80347a:	85 c0                	test   %eax,%eax
  80347c:	79 74                	jns    8034f2 <realloc+0xc3>
  80347e:	81 7d cc ff ff ff 81 	cmpl   $0x81ffffff,-0x34(%ebp)
  803485:	77 6b                	ja     8034f2 <realloc+0xc3>
	{
		void* newptr = malloc(new_size);
  803487:	83 ec 0c             	sub    $0xc,%esp
  80348a:	ff 75 0c             	pushl  0xc(%ebp)
  80348d:	e8 7d f1 ff ff       	call   80260f <malloc>
  803492:	83 c4 10             	add    $0x10,%esp
  803495:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (newptr == NULL)
  803498:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80349c:	75 0a                	jne    8034a8 <realloc+0x79>
			return NULL;
  80349e:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a3:	e9 9f 05 00 00       	jmp    803a47 <realloc+0x618>
		uint32 oldsz = get_block_size(virtual_address);
  8034a8:	83 ec 0c             	sub    $0xc,%esp
  8034ab:	ff 75 08             	pushl  0x8(%ebp)
  8034ae:	e8 e0 11 00 00       	call   804693 <get_block_size>
  8034b3:	83 c4 10             	add    $0x10,%esp
  8034b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 cpsz = oldsz < new_size ? oldsz : new_size;
  8034b9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8034bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034bf:	39 d0                	cmp    %edx,%eax
  8034c1:	76 02                	jbe    8034c5 <realloc+0x96>
  8034c3:	89 d0                	mov    %edx,%eax
  8034c5:	89 45 c0             	mov    %eax,-0x40(%ebp)
		memmove(newptr, virtual_address, cpsz);
  8034c8:	83 ec 04             	sub    $0x4,%esp
  8034cb:	ff 75 c0             	pushl  -0x40(%ebp)
  8034ce:	ff 75 08             	pushl  0x8(%ebp)
  8034d1:	ff 75 c8             	pushl  -0x38(%ebp)
  8034d4:	e8 56 eb ff ff       	call   80202f <memmove>
  8034d9:	83 c4 10             	add    $0x10,%esp
		free(virtual_address);
  8034dc:	83 ec 0c             	sub    $0xc,%esp
  8034df:	ff 75 08             	pushl  0x8(%ebp)
  8034e2:	e8 88 f4 ff ff       	call   80296f <free>
  8034e7:	83 c4 10             	add    $0x10,%esp
		return newptr;
  8034ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8034ed:	e9 55 05 00 00       	jmp    803a47 <realloc+0x618>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
  8034f2:	a1 30 71 83 00       	mov    0x837130,%eax
  8034f7:	39 45 cc             	cmp    %eax,-0x34(%ebp)
  8034fa:	72 09                	jb     803505 <realloc+0xd6>
  8034fc:	81 7d cc ff ff ff 9f 	cmpl   $0x9fffffff,-0x34(%ebp)
  803503:	76 0a                	jbe    80350f <realloc+0xe0>
		return NULL;
  803505:	b8 00 00 00 00       	mov    $0x0,%eax
  80350a:	e9 38 05 00 00       	jmp    803a47 <realloc+0x618>
	uint32 oldsz = 0;
  80350f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int idx = -1;
  803516:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  80351d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803524:	eb 50                	jmp    803576 <realloc+0x147>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  803526:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803529:	89 d0                	mov    %edx,%eax
  80352b:	01 c0                	add    %eax,%eax
  80352d:	01 d0                	add    %edx,%eax
  80352f:	c1 e0 02             	shl    $0x2,%eax
  803532:	05 48 70 80 00       	add    $0x807048,%eax
  803537:	8a 00                	mov    (%eax),%al
  803539:	84 c0                	test   %al,%al
  80353b:	74 36                	je     803573 <realloc+0x144>
  80353d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803540:	89 d0                	mov    %edx,%eax
  803542:	01 c0                	add    %eax,%eax
  803544:	01 d0                	add    %edx,%eax
  803546:	c1 e0 02             	shl    $0x2,%eax
  803549:	05 40 70 80 00       	add    $0x807040,%eax
  80354e:	8b 00                	mov    (%eax),%eax
  803550:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  803553:	75 1e                	jne    803573 <realloc+0x144>
		{
			oldsz = uhp_allocs[i].size;
  803555:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803558:	89 d0                	mov    %edx,%eax
  80355a:	01 c0                	add    %eax,%eax
  80355c:	01 d0                	add    %edx,%eax
  80355e:	c1 e0 02             	shl    $0x2,%eax
  803561:	05 44 70 80 00       	add    $0x807044,%eax
  803566:	8b 00                	mov    (%eax),%eax
  803568:	89 45 f4             	mov    %eax,-0xc(%ebp)
			idx = i;
  80356b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  803571:	eb 0c                	jmp    80357f <realloc+0x150>
	}
	if (va < uheapPageAllocStart || va >= USER_HEAP_MAX)
		return NULL;
	uint32 oldsz = 0;
	int idx = -1;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803573:	ff 45 ec             	incl   -0x14(%ebp)
  803576:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80357d:	7e a7                	jle    803526 <realloc+0xf7>
			oldsz = uhp_allocs[i].size;
			idx = i;
			break;
		}
	}
	if (idx == -1)
  80357f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803583:	75 0a                	jne    80358f <realloc+0x160>
		return NULL;
  803585:	b8 00 00 00 00       	mov    $0x0,%eax
  80358a:	e9 b8 04 00 00       	jmp    803a47 <realloc+0x618>
	uint32 req = ROUNDUP(new_size, PAGE_SIZE);
  80358f:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  803596:	8b 55 0c             	mov    0xc(%ebp),%edx
  803599:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80359c:	01 d0                	add    %edx,%eax
  80359e:	48                   	dec    %eax
  80359f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8035a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8035aa:	f7 75 bc             	divl   -0x44(%ebp)
  8035ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035b0:	29 d0                	sub    %edx,%eax
  8035b2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if (req == oldsz)
  8035b5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8035b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8035bb:	75 08                	jne    8035c5 <realloc+0x196>
		return virtual_address;
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	e9 82 04 00 00       	jmp    803a47 <realloc+0x618>
	if (req < oldsz)
  8035c5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8035c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8035cb:	0f 83 cd 02 00 00    	jae    80389e <realloc+0x46f>
	{
		uint32 shrink = oldsz - req;
  8035d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d4:	2b 45 b4             	sub    -0x4c(%ebp),%eax
  8035d7:	89 45 b0             	mov    %eax,-0x50(%ebp)
		uint32 tail = va + req;
  8035da:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8035dd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8035e0:	01 d0                	add    %edx,%eax
  8035e2:	89 45 ac             	mov    %eax,-0x54(%ebp)
		uhp_allocs[idx].size = req;
  8035e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035e8:	89 d0                	mov    %edx,%eax
  8035ea:	01 c0                	add    %eax,%eax
  8035ec:	01 d0                	add    %edx,%eax
  8035ee:	c1 e0 02             	shl    $0x2,%eax
  8035f1:	8d 90 44 70 80 00    	lea    0x807044(%eax),%edx
  8035f7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8035fa:	89 02                	mov    %eax,(%edx)
		sys_free_user_mem(tail, shrink);
  8035fc:	83 ec 08             	sub    $0x8,%esp
  8035ff:	ff 75 b0             	pushl  -0x50(%ebp)
  803602:	ff 75 ac             	pushl  -0x54(%ebp)
  803605:	e8 e3 0c 00 00       	call   8042ed <sys_free_user_mem>
  80360a:	83 c4 10             	add    $0x10,%esp
		int fidx = -1;
  80360d:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803614:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80361b:	eb 64                	jmp    803681 <realloc+0x252>
		{
			if (!uhp_frees[j].free)
  80361d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803620:	89 d0                	mov    %edx,%eax
  803622:	01 c0                	add    %eax,%eax
  803624:	01 d0                	add    %edx,%eax
  803626:	c1 e0 02             	shl    $0x2,%eax
  803629:	05 48 30 81 00       	add    $0x813048,%eax
  80362e:	8a 00                	mov    (%eax),%al
  803630:	84 c0                	test   %al,%al
  803632:	75 4a                	jne    80367e <realloc+0x24f>
			{
				uhp_frees[j].va = tail;
  803634:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803637:	89 d0                	mov    %edx,%eax
  803639:	01 c0                	add    %eax,%eax
  80363b:	01 d0                	add    %edx,%eax
  80363d:	c1 e0 02             	shl    $0x2,%eax
  803640:	8d 90 40 30 81 00    	lea    0x813040(%eax),%edx
  803646:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803649:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].size = shrink;
  80364b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80364e:	89 d0                	mov    %edx,%eax
  803650:	01 c0                	add    %eax,%eax
  803652:	01 d0                	add    %edx,%eax
  803654:	c1 e0 02             	shl    $0x2,%eax
  803657:	8d 90 44 30 81 00    	lea    0x813044(%eax),%edx
  80365d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803660:	89 02                	mov    %eax,(%edx)
				uhp_frees[j].free = 1;
  803662:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803665:	89 d0                	mov    %edx,%eax
  803667:	01 c0                	add    %eax,%eax
  803669:	01 d0                	add    %edx,%eax
  80366b:	c1 e0 02             	shl    $0x2,%eax
  80366e:	05 48 30 81 00       	add    $0x813048,%eax
  803673:	c6 00 01             	movb   $0x1,(%eax)
				fidx = j;
  803676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803679:	89 45 e8             	mov    %eax,-0x18(%ebp)
				break;
  80367c:	eb 0c                	jmp    80368a <realloc+0x25b>
		uint32 shrink = oldsz - req;
		uint32 tail = va + req;
		uhp_allocs[idx].size = req;
		sys_free_user_mem(tail, shrink);
		int fidx = -1;
		for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80367e:	ff 45 e4             	incl   -0x1c(%ebp)
  803681:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
  803688:	7e 93                	jle    80361d <realloc+0x1ee>
				uhp_frees[j].free = 1;
				fidx = j;
				break;
			}
		}
		if (fidx != -1)
  80368a:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  80368e:	0f 84 8d 01 00 00    	je     803821 <realloc+0x3f2>
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803694:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80369b:	e9 74 01 00 00       	jmp    803814 <realloc+0x3e5>
			{
				if (k == fidx) continue;
  8036a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036a3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036a6:	0f 84 64 01 00 00    	je     803810 <realloc+0x3e1>
				if (uhp_frees[k].free)
  8036ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036af:	89 d0                	mov    %edx,%eax
  8036b1:	01 c0                	add    %eax,%eax
  8036b3:	01 d0                	add    %edx,%eax
  8036b5:	c1 e0 02             	shl    $0x2,%eax
  8036b8:	05 48 30 81 00       	add    $0x813048,%eax
  8036bd:	8a 00                	mov    (%eax),%al
  8036bf:	84 c0                	test   %al,%al
  8036c1:	0f 84 4a 01 00 00    	je     803811 <realloc+0x3e2>
				{
					if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  8036c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036ca:	89 d0                	mov    %edx,%eax
  8036cc:	01 c0                	add    %eax,%eax
  8036ce:	01 d0                	add    %edx,%eax
  8036d0:	c1 e0 02             	shl    $0x2,%eax
  8036d3:	05 40 30 81 00       	add    $0x813040,%eax
  8036d8:	8b 08                	mov    (%eax),%ecx
  8036da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036dd:	89 d0                	mov    %edx,%eax
  8036df:	01 c0                	add    %eax,%eax
  8036e1:	01 d0                	add    %edx,%eax
  8036e3:	c1 e0 02             	shl    $0x2,%eax
  8036e6:	05 44 30 81 00       	add    $0x813044,%eax
  8036eb:	8b 00                	mov    (%eax),%eax
  8036ed:	01 c1                	add    %eax,%ecx
  8036ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f2:	89 d0                	mov    %edx,%eax
  8036f4:	01 c0                	add    %eax,%eax
  8036f6:	01 d0                	add    %edx,%eax
  8036f8:	c1 e0 02             	shl    $0x2,%eax
  8036fb:	05 40 30 81 00       	add    $0x813040,%eax
  803700:	8b 00                	mov    (%eax),%eax
  803702:	39 c1                	cmp    %eax,%ecx
  803704:	75 7a                	jne    803780 <realloc+0x351>
					{
						uhp_frees[fidx].va = uhp_frees[k].va;
  803706:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803709:	89 d0                	mov    %edx,%eax
  80370b:	01 c0                	add    %eax,%eax
  80370d:	01 d0                	add    %edx,%eax
  80370f:	c1 e0 02             	shl    $0x2,%eax
  803712:	05 40 30 81 00       	add    $0x813040,%eax
  803717:	8b 10                	mov    (%eax),%edx
  803719:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80371c:	89 c8                	mov    %ecx,%eax
  80371e:	01 c0                	add    %eax,%eax
  803720:	01 c8                	add    %ecx,%eax
  803722:	c1 e0 02             	shl    $0x2,%eax
  803725:	05 40 30 81 00       	add    $0x813040,%eax
  80372a:	89 10                	mov    %edx,(%eax)
						uhp_frees[fidx].size += uhp_frees[k].size;
  80372c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80372f:	89 d0                	mov    %edx,%eax
  803731:	01 c0                	add    %eax,%eax
  803733:	01 d0                	add    %edx,%eax
  803735:	c1 e0 02             	shl    $0x2,%eax
  803738:	05 44 30 81 00       	add    $0x813044,%eax
  80373d:	8b 08                	mov    (%eax),%ecx
  80373f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803742:	89 d0                	mov    %edx,%eax
  803744:	01 c0                	add    %eax,%eax
  803746:	01 d0                	add    %edx,%eax
  803748:	c1 e0 02             	shl    $0x2,%eax
  80374b:	05 44 30 81 00       	add    $0x813044,%eax
  803750:	8b 00                	mov    (%eax),%eax
  803752:	01 c1                	add    %eax,%ecx
  803754:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803757:	89 d0                	mov    %edx,%eax
  803759:	01 c0                	add    %eax,%eax
  80375b:	01 d0                	add    %edx,%eax
  80375d:	c1 e0 02             	shl    $0x2,%eax
  803760:	05 44 30 81 00       	add    $0x813044,%eax
  803765:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  803767:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80376a:	89 d0                	mov    %edx,%eax
  80376c:	01 c0                	add    %eax,%eax
  80376e:	01 d0                	add    %edx,%eax
  803770:	c1 e0 02             	shl    $0x2,%eax
  803773:	05 48 30 81 00       	add    $0x813048,%eax
  803778:	c6 00 00             	movb   $0x0,(%eax)
  80377b:	e9 91 00 00 00       	jmp    803811 <realloc+0x3e2>
					}
					else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  803780:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803783:	89 d0                	mov    %edx,%eax
  803785:	01 c0                	add    %eax,%eax
  803787:	01 d0                	add    %edx,%eax
  803789:	c1 e0 02             	shl    $0x2,%eax
  80378c:	05 40 30 81 00       	add    $0x813040,%eax
  803791:	8b 08                	mov    (%eax),%ecx
  803793:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803796:	89 d0                	mov    %edx,%eax
  803798:	01 c0                	add    %eax,%eax
  80379a:	01 d0                	add    %edx,%eax
  80379c:	c1 e0 02             	shl    $0x2,%eax
  80379f:	05 44 30 81 00       	add    $0x813044,%eax
  8037a4:	8b 00                	mov    (%eax),%eax
  8037a6:	01 c1                	add    %eax,%ecx
  8037a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037ab:	89 d0                	mov    %edx,%eax
  8037ad:	01 c0                	add    %eax,%eax
  8037af:	01 d0                	add    %edx,%eax
  8037b1:	c1 e0 02             	shl    $0x2,%eax
  8037b4:	05 40 30 81 00       	add    $0x813040,%eax
  8037b9:	8b 00                	mov    (%eax),%eax
  8037bb:	39 c1                	cmp    %eax,%ecx
  8037bd:	75 52                	jne    803811 <realloc+0x3e2>
					{
						uhp_frees[fidx].size += uhp_frees[k].size;
  8037bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037c2:	89 d0                	mov    %edx,%eax
  8037c4:	01 c0                	add    %eax,%eax
  8037c6:	01 d0                	add    %edx,%eax
  8037c8:	c1 e0 02             	shl    $0x2,%eax
  8037cb:	05 44 30 81 00       	add    $0x813044,%eax
  8037d0:	8b 08                	mov    (%eax),%ecx
  8037d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037d5:	89 d0                	mov    %edx,%eax
  8037d7:	01 c0                	add    %eax,%eax
  8037d9:	01 d0                	add    %edx,%eax
  8037db:	c1 e0 02             	shl    $0x2,%eax
  8037de:	05 44 30 81 00       	add    $0x813044,%eax
  8037e3:	8b 00                	mov    (%eax),%eax
  8037e5:	01 c1                	add    %eax,%ecx
  8037e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ea:	89 d0                	mov    %edx,%eax
  8037ec:	01 c0                	add    %eax,%eax
  8037ee:	01 d0                	add    %edx,%eax
  8037f0:	c1 e0 02             	shl    $0x2,%eax
  8037f3:	05 44 30 81 00       	add    $0x813044,%eax
  8037f8:	89 08                	mov    %ecx,(%eax)
						uhp_frees[k].free = 0;
  8037fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037fd:	89 d0                	mov    %edx,%eax
  8037ff:	01 c0                	add    %eax,%eax
  803801:	01 d0                	add    %edx,%eax
  803803:	c1 e0 02             	shl    $0x2,%eax
  803806:	05 48 30 81 00       	add    $0x813048,%eax
  80380b:	c6 00 00             	movb   $0x0,(%eax)
  80380e:	eb 01                	jmp    803811 <realloc+0x3e2>
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
			{
				if (k == fidx) continue;
  803810:	90                   	nop
				break;
			}
		}
		if (fidx != -1)
		{
			for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803811:	ff 45 e0             	incl   -0x20(%ebp)
  803814:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  80381b:	0f 8e 7f fe ff ff    	jle    8036a0 <realloc+0x271>
						uhp_frees[k].free = 0;
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
  803821:	a1 30 71 83 00       	mov    0x837130,%eax
  803826:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803829:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  803830:	eb 53                	jmp    803885 <realloc+0x456>
		{
			if (uhp_allocs[m].used)
  803832:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803835:	89 d0                	mov    %edx,%eax
  803837:	01 c0                	add    %eax,%eax
  803839:	01 d0                	add    %edx,%eax
  80383b:	c1 e0 02             	shl    $0x2,%eax
  80383e:	05 48 70 80 00       	add    $0x807048,%eax
  803843:	8a 00                	mov    (%eax),%al
  803845:	84 c0                	test   %al,%al
  803847:	74 39                	je     803882 <realloc+0x453>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  803849:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80384c:	89 d0                	mov    %edx,%eax
  80384e:	01 c0                	add    %eax,%eax
  803850:	01 d0                	add    %edx,%eax
  803852:	c1 e0 02             	shl    $0x2,%eax
  803855:	05 40 70 80 00       	add    $0x807040,%eax
  80385a:	8b 08                	mov    (%eax),%ecx
  80385c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80385f:	89 d0                	mov    %edx,%eax
  803861:	01 c0                	add    %eax,%eax
  803863:	01 d0                	add    %edx,%eax
  803865:	c1 e0 02             	shl    $0x2,%eax
  803868:	05 44 70 80 00       	add    $0x807044,%eax
  80386d:	8b 00                	mov    (%eax),%eax
  80386f:	01 c8                	add    %ecx,%eax
  803871:	89 45 a8             	mov    %eax,-0x58(%ebp)
				if (end > maxEnd) maxEnd = end;
  803874:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803877:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80387a:	76 06                	jbe    803882 <realloc+0x453>
  80387c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80387f:	89 45 dc             	mov    %eax,-0x24(%ebp)
					}
				}
			}
		}
		uint32 maxEnd = uheapPageAllocStart;
		for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803882:	ff 45 d8             	incl   -0x28(%ebp)
  803885:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
  80388c:	7e a4                	jle    803832 <realloc+0x403>
			{
				uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
				if (end > maxEnd) maxEnd = end;
			}
		}
		uheapPageAllocBreak = maxEnd;
  80388e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803891:	a3 88 70 83 00       	mov    %eax,0x837088
		return virtual_address;
  803896:	8b 45 08             	mov    0x8(%ebp),%eax
  803899:	e9 a9 01 00 00       	jmp    803a47 <realloc+0x618>
	}
	uint32 end = va + oldsz;
  80389e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8038a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a4:	01 d0                	add    %edx,%eax
  8038a6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int adjIdx = -1;
  8038a9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  8038b0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8038b7:	eb 57                	jmp    803910 <realloc+0x4e1>
	{
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
  8038b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8038bc:	89 d0                	mov    %edx,%eax
  8038be:	01 c0                	add    %eax,%eax
  8038c0:	01 d0                	add    %edx,%eax
  8038c2:	c1 e0 02             	shl    $0x2,%eax
  8038c5:	05 48 30 81 00       	add    $0x813048,%eax
  8038ca:	8a 00                	mov    (%eax),%al
  8038cc:	84 c0                	test   %al,%al
  8038ce:	74 3d                	je     80390d <realloc+0x4de>
  8038d0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8038d3:	89 d0                	mov    %edx,%eax
  8038d5:	01 c0                	add    %eax,%eax
  8038d7:	01 d0                	add    %edx,%eax
  8038d9:	c1 e0 02             	shl    $0x2,%eax
  8038dc:	05 40 30 81 00       	add    $0x813040,%eax
  8038e1:	8b 00                	mov    (%eax),%eax
  8038e3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8038e6:	75 25                	jne    80390d <realloc+0x4de>
  8038e8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8038eb:	89 d0                	mov    %edx,%eax
  8038ed:	01 c0                	add    %eax,%eax
  8038ef:	01 d0                	add    %edx,%eax
  8038f1:	c1 e0 02             	shl    $0x2,%eax
  8038f4:	05 44 30 81 00       	add    $0x813044,%eax
  8038f9:	8b 10                	mov    (%eax),%edx
  8038fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8038fe:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803901:	39 c2                	cmp    %eax,%edx
  803903:	72 08                	jb     80390d <realloc+0x4de>
		{
			adjIdx = j; break;
  803905:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803908:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80390b:	eb 0c                	jmp    803919 <realloc+0x4ea>
		uheapPageAllocBreak = maxEnd;
		return virtual_address;
	}
	uint32 end = va + oldsz;
	int adjIdx = -1;
	for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  80390d:	ff 45 d0             	incl   -0x30(%ebp)
  803910:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
  803917:	7e a0                	jle    8038b9 <realloc+0x48a>
		if (uhp_frees[j].free && uhp_frees[j].va == end && uhp_frees[j].size >= (req - oldsz))
		{
			adjIdx = j; break;
		}
	}
	if (adjIdx != -1)
  803919:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%ebp)
  80391d:	0f 84 d6 00 00 00    	je     8039f9 <realloc+0x5ca>
	{
		uint32 add = req - oldsz;
  803923:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803926:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803929:	89 45 a0             	mov    %eax,-0x60(%ebp)
		sys_allocate_user_mem(end, add);
  80392c:	83 ec 08             	sub    $0x8,%esp
  80392f:	ff 75 a0             	pushl  -0x60(%ebp)
  803932:	ff 75 a4             	pushl  -0x5c(%ebp)
  803935:	e8 cf 09 00 00       	call   804309 <sys_allocate_user_mem>
  80393a:	83 c4 10             	add    $0x10,%esp
		uhp_allocs[idx].size = req;
  80393d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803940:	89 d0                	mov    %edx,%eax
  803942:	01 c0                	add    %eax,%eax
  803944:	01 d0                	add    %edx,%eax
  803946:	c1 e0 02             	shl    $0x2,%eax
  803949:	8d 90 44 70 80 00    	lea    0x807044(%eax),%edx
  80394f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803952:	89 02                	mov    %eax,(%edx)
		uhp_frees[adjIdx].va += add;
  803954:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803957:	89 d0                	mov    %edx,%eax
  803959:	01 c0                	add    %eax,%eax
  80395b:	01 d0                	add    %edx,%eax
  80395d:	c1 e0 02             	shl    $0x2,%eax
  803960:	05 40 30 81 00       	add    $0x813040,%eax
  803965:	8b 10                	mov    (%eax),%edx
  803967:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80396a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80396d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803970:	89 d0                	mov    %edx,%eax
  803972:	01 c0                	add    %eax,%eax
  803974:	01 d0                	add    %edx,%eax
  803976:	c1 e0 02             	shl    $0x2,%eax
  803979:	05 40 30 81 00       	add    $0x813040,%eax
  80397e:	89 08                	mov    %ecx,(%eax)
		uhp_frees[adjIdx].size -= add;
  803980:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803983:	89 d0                	mov    %edx,%eax
  803985:	01 c0                	add    %eax,%eax
  803987:	01 d0                	add    %edx,%eax
  803989:	c1 e0 02             	shl    $0x2,%eax
  80398c:	05 44 30 81 00       	add    $0x813044,%eax
  803991:	8b 00                	mov    (%eax),%eax
  803993:	2b 45 a0             	sub    -0x60(%ebp),%eax
  803996:	89 c2                	mov    %eax,%edx
  803998:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80399b:	89 c8                	mov    %ecx,%eax
  80399d:	01 c0                	add    %eax,%eax
  80399f:	01 c8                	add    %ecx,%eax
  8039a1:	c1 e0 02             	shl    $0x2,%eax
  8039a4:	05 44 30 81 00       	add    $0x813044,%eax
  8039a9:	89 10                	mov    %edx,(%eax)
		if (uhp_frees[adjIdx].size == 0) uhp_frees[adjIdx].free = 0;
  8039ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039ae:	89 d0                	mov    %edx,%eax
  8039b0:	01 c0                	add    %eax,%eax
  8039b2:	01 d0                	add    %edx,%eax
  8039b4:	c1 e0 02             	shl    $0x2,%eax
  8039b7:	05 44 30 81 00       	add    $0x813044,%eax
  8039bc:	8b 00                	mov    (%eax),%eax
  8039be:	85 c0                	test   %eax,%eax
  8039c0:	75 14                	jne    8039d6 <realloc+0x5a7>
  8039c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8039c5:	89 d0                	mov    %edx,%eax
  8039c7:	01 c0                	add    %eax,%eax
  8039c9:	01 d0                	add    %edx,%eax
  8039cb:	c1 e0 02             	shl    $0x2,%eax
  8039ce:	05 48 30 81 00       	add    $0x813048,%eax
  8039d3:	c6 00 00             	movb   $0x0,(%eax)
		if (uheapPageAllocBreak < va + req) uheapPageAllocBreak = va + req;
  8039d6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8039d9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039dc:	01 c2                	add    %eax,%edx
  8039de:	a1 88 70 83 00       	mov    0x837088,%eax
  8039e3:	39 c2                	cmp    %eax,%edx
  8039e5:	76 0d                	jbe    8039f4 <realloc+0x5c5>
  8039e7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8039ea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8039ed:	01 d0                	add    %edx,%eax
  8039ef:	a3 88 70 83 00       	mov    %eax,0x837088
		return virtual_address;
  8039f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f7:	eb 4e                	jmp    803a47 <realloc+0x618>
	}
	void* newptr = malloc(new_size);
  8039f9:	83 ec 0c             	sub    $0xc,%esp
  8039fc:	ff 75 0c             	pushl  0xc(%ebp)
  8039ff:	e8 0b ec ff ff       	call   80260f <malloc>
  803a04:	83 c4 10             	add    $0x10,%esp
  803a07:	89 45 9c             	mov    %eax,-0x64(%ebp)
	if (newptr == NULL)
  803a0a:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  803a0e:	75 07                	jne    803a17 <realloc+0x5e8>
		return NULL;
  803a10:	b8 00 00 00 00       	mov    $0x0,%eax
  803a15:	eb 30                	jmp    803a47 <realloc+0x618>
    sys_move_user_mem((uint32)va, (uint32)newptr, oldsz < req ? oldsz : req);
  803a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a1a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803a1d:	39 d0                	cmp    %edx,%eax
  803a1f:	76 02                	jbe    803a23 <realloc+0x5f4>
  803a21:	89 d0                	mov    %edx,%eax
  803a23:	8b 55 9c             	mov    -0x64(%ebp),%edx
  803a26:	83 ec 04             	sub    $0x4,%esp
  803a29:	50                   	push   %eax
  803a2a:	52                   	push   %edx
  803a2b:	ff 75 cc             	pushl  -0x34(%ebp)
  803a2e:	e8 cf 06 00 00       	call   804102 <sys_move_user_mem>
  803a33:	83 c4 10             	add    $0x10,%esp
	free(virtual_address);
  803a36:	83 ec 0c             	sub    $0xc,%esp
  803a39:	ff 75 08             	pushl  0x8(%ebp)
  803a3c:	e8 2e ef ff ff       	call   80296f <free>
  803a41:	83 c4 10             	add    $0x10,%esp
	return newptr;
  803a44:	8b 45 9c             	mov    -0x64(%ebp),%eax
}
  803a47:	c9                   	leave  
  803a48:	c3                   	ret    

00803a49 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803a49:	55                   	push   %ebp
  803a4a:	89 e5                	mov    %esp,%ebp
  803a4c:	83 ec 38             	sub    $0x38,%esp
	//Your code is here
	uint32 va = (uint32)virtual_address;
  803a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a52:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (va == 0) return;
  803a55:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803a59:	0f 84 33 03 00 00    	je     803d92 <sfree+0x349>
	int id = (int)(va & 0x7FFFFFFF);
  803a5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a62:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  803a67:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int r = sys_delete_shared_object(id, virtual_address);
  803a6a:	83 ec 08             	sub    $0x8,%esp
  803a6d:	ff 75 08             	pushl  0x8(%ebp)
  803a70:	ff 75 d8             	pushl  -0x28(%ebp)
  803a73:	e8 7d 05 00 00       	call   803ff5 <sys_delete_shared_object>
  803a78:	83 c4 10             	add    $0x10,%esp
  803a7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (r < 0) return;
  803a7e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a82:	0f 88 0d 03 00 00    	js     803d95 <sfree+0x34c>
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803a8f:	e9 ef 02 00 00       	jmp    803d83 <sfree+0x33a>
	{
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
  803a94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a97:	89 d0                	mov    %edx,%eax
  803a99:	01 c0                	add    %eax,%eax
  803a9b:	01 d0                	add    %edx,%eax
  803a9d:	c1 e0 02             	shl    $0x2,%eax
  803aa0:	05 48 70 80 00       	add    $0x807048,%eax
  803aa5:	8a 00                	mov    (%eax),%al
  803aa7:	84 c0                	test   %al,%al
  803aa9:	0f 84 d1 02 00 00    	je     803d80 <sfree+0x337>
  803aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ab2:	89 d0                	mov    %edx,%eax
  803ab4:	01 c0                	add    %eax,%eax
  803ab6:	01 d0                	add    %edx,%eax
  803ab8:	c1 e0 02             	shl    $0x2,%eax
  803abb:	05 40 70 80 00       	add    $0x807040,%eax
  803ac0:	8b 00                	mov    (%eax),%eax
  803ac2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803ac5:	0f 85 b5 02 00 00    	jne    803d80 <sfree+0x337>
		{
			uint32 size = uhp_allocs[i].size;
  803acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ace:	89 d0                	mov    %edx,%eax
  803ad0:	01 c0                	add    %eax,%eax
  803ad2:	01 d0                	add    %edx,%eax
  803ad4:	c1 e0 02             	shl    $0x2,%eax
  803ad7:	05 44 70 80 00       	add    $0x807044,%eax
  803adc:	8b 00                	mov    (%eax),%eax
  803ade:	89 45 d0             	mov    %eax,-0x30(%ebp)
			uhp_allocs[i].used = 0;
  803ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ae4:	89 d0                	mov    %edx,%eax
  803ae6:	01 c0                	add    %eax,%eax
  803ae8:	01 d0                	add    %edx,%eax
  803aea:	c1 e0 02             	shl    $0x2,%eax
  803aed:	05 48 70 80 00       	add    $0x807048,%eax
  803af2:	c6 00 00             	movb   $0x0,(%eax)
			int fidx = -1;
  803af5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803afc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803b03:	eb 64                	jmp    803b69 <sfree+0x120>
			{
				if (!uhp_frees[j].free)
  803b05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b08:	89 d0                	mov    %edx,%eax
  803b0a:	01 c0                	add    %eax,%eax
  803b0c:	01 d0                	add    %edx,%eax
  803b0e:	c1 e0 02             	shl    $0x2,%eax
  803b11:	05 48 30 81 00       	add    $0x813048,%eax
  803b16:	8a 00                	mov    (%eax),%al
  803b18:	84 c0                	test   %al,%al
  803b1a:	75 4a                	jne    803b66 <sfree+0x11d>
				{
					uhp_frees[j].va = va;
  803b1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b1f:	89 d0                	mov    %edx,%eax
  803b21:	01 c0                	add    %eax,%eax
  803b23:	01 d0                	add    %edx,%eax
  803b25:	c1 e0 02             	shl    $0x2,%eax
  803b28:	8d 90 40 30 81 00    	lea    0x813040(%eax),%edx
  803b2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b31:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].size = size;
  803b33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b36:	89 d0                	mov    %edx,%eax
  803b38:	01 c0                	add    %eax,%eax
  803b3a:	01 d0                	add    %edx,%eax
  803b3c:	c1 e0 02             	shl    $0x2,%eax
  803b3f:	8d 90 44 30 81 00    	lea    0x813044(%eax),%edx
  803b45:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803b48:	89 02                	mov    %eax,(%edx)
					uhp_frees[j].free = 1;
  803b4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b4d:	89 d0                	mov    %edx,%eax
  803b4f:	01 c0                	add    %eax,%eax
  803b51:	01 d0                	add    %edx,%eax
  803b53:	c1 e0 02             	shl    $0x2,%eax
  803b56:	05 48 30 81 00       	add    $0x813048,%eax
  803b5b:	c6 00 01             	movb   $0x1,(%eax)
					fidx = j;
  803b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
					break;
  803b64:	eb 0c                	jmp    803b72 <sfree+0x129>
		if (uhp_allocs[i].used && uhp_allocs[i].va == va)
		{
			uint32 size = uhp_allocs[i].size;
			uhp_allocs[i].used = 0;
			int fidx = -1;
			for (int j = 0; j < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); j++)
  803b66:	ff 45 ec             	incl   -0x14(%ebp)
  803b69:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803b70:	7e 93                	jle    803b05 <sfree+0xbc>
					uhp_frees[j].free = 1;
					fidx = j;
					break;
				}
			}
			if (fidx != -1)
  803b72:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  803b76:	0f 84 8d 01 00 00    	je     803d09 <sfree+0x2c0>
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803b7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b83:	e9 74 01 00 00       	jmp    803cfc <sfree+0x2b3>
				{
					if (k == fidx) continue;
  803b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803b8e:	0f 84 64 01 00 00    	je     803cf8 <sfree+0x2af>
					if (uhp_frees[k].free)
  803b94:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b97:	89 d0                	mov    %edx,%eax
  803b99:	01 c0                	add    %eax,%eax
  803b9b:	01 d0                	add    %edx,%eax
  803b9d:	c1 e0 02             	shl    $0x2,%eax
  803ba0:	05 48 30 81 00       	add    $0x813048,%eax
  803ba5:	8a 00                	mov    (%eax),%al
  803ba7:	84 c0                	test   %al,%al
  803ba9:	0f 84 4a 01 00 00    	je     803cf9 <sfree+0x2b0>
					{
						if (uhp_frees[k].va + uhp_frees[k].size == uhp_frees[fidx].va)
  803baf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bb2:	89 d0                	mov    %edx,%eax
  803bb4:	01 c0                	add    %eax,%eax
  803bb6:	01 d0                	add    %edx,%eax
  803bb8:	c1 e0 02             	shl    $0x2,%eax
  803bbb:	05 40 30 81 00       	add    $0x813040,%eax
  803bc0:	8b 08                	mov    (%eax),%ecx
  803bc2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bc5:	89 d0                	mov    %edx,%eax
  803bc7:	01 c0                	add    %eax,%eax
  803bc9:	01 d0                	add    %edx,%eax
  803bcb:	c1 e0 02             	shl    $0x2,%eax
  803bce:	05 44 30 81 00       	add    $0x813044,%eax
  803bd3:	8b 00                	mov    (%eax),%eax
  803bd5:	01 c1                	add    %eax,%ecx
  803bd7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bda:	89 d0                	mov    %edx,%eax
  803bdc:	01 c0                	add    %eax,%eax
  803bde:	01 d0                	add    %edx,%eax
  803be0:	c1 e0 02             	shl    $0x2,%eax
  803be3:	05 40 30 81 00       	add    $0x813040,%eax
  803be8:	8b 00                	mov    (%eax),%eax
  803bea:	39 c1                	cmp    %eax,%ecx
  803bec:	75 7a                	jne    803c68 <sfree+0x21f>
						{
							uhp_frees[fidx].va = uhp_frees[k].va;
  803bee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bf1:	89 d0                	mov    %edx,%eax
  803bf3:	01 c0                	add    %eax,%eax
  803bf5:	01 d0                	add    %edx,%eax
  803bf7:	c1 e0 02             	shl    $0x2,%eax
  803bfa:	05 40 30 81 00       	add    $0x813040,%eax
  803bff:	8b 10                	mov    (%eax),%edx
  803c01:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803c04:	89 c8                	mov    %ecx,%eax
  803c06:	01 c0                	add    %eax,%eax
  803c08:	01 c8                	add    %ecx,%eax
  803c0a:	c1 e0 02             	shl    $0x2,%eax
  803c0d:	05 40 30 81 00       	add    $0x813040,%eax
  803c12:	89 10                	mov    %edx,(%eax)
							uhp_frees[fidx].size += uhp_frees[k].size;
  803c14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c17:	89 d0                	mov    %edx,%eax
  803c19:	01 c0                	add    %eax,%eax
  803c1b:	01 d0                	add    %edx,%eax
  803c1d:	c1 e0 02             	shl    $0x2,%eax
  803c20:	05 44 30 81 00       	add    $0x813044,%eax
  803c25:	8b 08                	mov    (%eax),%ecx
  803c27:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c2a:	89 d0                	mov    %edx,%eax
  803c2c:	01 c0                	add    %eax,%eax
  803c2e:	01 d0                	add    %edx,%eax
  803c30:	c1 e0 02             	shl    $0x2,%eax
  803c33:	05 44 30 81 00       	add    $0x813044,%eax
  803c38:	8b 00                	mov    (%eax),%eax
  803c3a:	01 c1                	add    %eax,%ecx
  803c3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c3f:	89 d0                	mov    %edx,%eax
  803c41:	01 c0                	add    %eax,%eax
  803c43:	01 d0                	add    %edx,%eax
  803c45:	c1 e0 02             	shl    $0x2,%eax
  803c48:	05 44 30 81 00       	add    $0x813044,%eax
  803c4d:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803c4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c52:	89 d0                	mov    %edx,%eax
  803c54:	01 c0                	add    %eax,%eax
  803c56:	01 d0                	add    %edx,%eax
  803c58:	c1 e0 02             	shl    $0x2,%eax
  803c5b:	05 48 30 81 00       	add    $0x813048,%eax
  803c60:	c6 00 00             	movb   $0x0,(%eax)
  803c63:	e9 91 00 00 00       	jmp    803cf9 <sfree+0x2b0>
						}
						else if (uhp_frees[fidx].va + uhp_frees[fidx].size == uhp_frees[k].va)
  803c68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c6b:	89 d0                	mov    %edx,%eax
  803c6d:	01 c0                	add    %eax,%eax
  803c6f:	01 d0                	add    %edx,%eax
  803c71:	c1 e0 02             	shl    $0x2,%eax
  803c74:	05 40 30 81 00       	add    $0x813040,%eax
  803c79:	8b 08                	mov    (%eax),%ecx
  803c7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c7e:	89 d0                	mov    %edx,%eax
  803c80:	01 c0                	add    %eax,%eax
  803c82:	01 d0                	add    %edx,%eax
  803c84:	c1 e0 02             	shl    $0x2,%eax
  803c87:	05 44 30 81 00       	add    $0x813044,%eax
  803c8c:	8b 00                	mov    (%eax),%eax
  803c8e:	01 c1                	add    %eax,%ecx
  803c90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c93:	89 d0                	mov    %edx,%eax
  803c95:	01 c0                	add    %eax,%eax
  803c97:	01 d0                	add    %edx,%eax
  803c99:	c1 e0 02             	shl    $0x2,%eax
  803c9c:	05 40 30 81 00       	add    $0x813040,%eax
  803ca1:	8b 00                	mov    (%eax),%eax
  803ca3:	39 c1                	cmp    %eax,%ecx
  803ca5:	75 52                	jne    803cf9 <sfree+0x2b0>
						{
							uhp_frees[fidx].size += uhp_frees[k].size;
  803ca7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803caa:	89 d0                	mov    %edx,%eax
  803cac:	01 c0                	add    %eax,%eax
  803cae:	01 d0                	add    %edx,%eax
  803cb0:	c1 e0 02             	shl    $0x2,%eax
  803cb3:	05 44 30 81 00       	add    $0x813044,%eax
  803cb8:	8b 08                	mov    (%eax),%ecx
  803cba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cbd:	89 d0                	mov    %edx,%eax
  803cbf:	01 c0                	add    %eax,%eax
  803cc1:	01 d0                	add    %edx,%eax
  803cc3:	c1 e0 02             	shl    $0x2,%eax
  803cc6:	05 44 30 81 00       	add    $0x813044,%eax
  803ccb:	8b 00                	mov    (%eax),%eax
  803ccd:	01 c1                	add    %eax,%ecx
  803ccf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cd2:	89 d0                	mov    %edx,%eax
  803cd4:	01 c0                	add    %eax,%eax
  803cd6:	01 d0                	add    %edx,%eax
  803cd8:	c1 e0 02             	shl    $0x2,%eax
  803cdb:	05 44 30 81 00       	add    $0x813044,%eax
  803ce0:	89 08                	mov    %ecx,(%eax)
							uhp_frees[k].free = 0;
  803ce2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ce5:	89 d0                	mov    %edx,%eax
  803ce7:	01 c0                	add    %eax,%eax
  803ce9:	01 d0                	add    %edx,%eax
  803ceb:	c1 e0 02             	shl    $0x2,%eax
  803cee:	05 48 30 81 00       	add    $0x813048,%eax
  803cf3:	c6 00 00             	movb   $0x0,(%eax)
  803cf6:	eb 01                	jmp    803cf9 <sfree+0x2b0>
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
				{
					if (k == fidx) continue;
  803cf8:	90                   	nop
					break;
				}
			}
			if (fidx != -1)
			{
				for (int k = 0; k < (int)(sizeof(uhp_frees)/sizeof(uhp_frees[0])); k++)
  803cf9:	ff 45 e8             	incl   -0x18(%ebp)
  803cfc:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  803d03:	0f 8e 7f fe ff ff    	jle    803b88 <sfree+0x13f>
							uhp_frees[k].free = 0;
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
  803d09:	a1 30 71 83 00       	mov    0x837130,%eax
  803d0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803d11:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803d18:	eb 53                	jmp    803d6d <sfree+0x324>
			{
				if (uhp_allocs[m].used)
  803d1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d1d:	89 d0                	mov    %edx,%eax
  803d1f:	01 c0                	add    %eax,%eax
  803d21:	01 d0                	add    %edx,%eax
  803d23:	c1 e0 02             	shl    $0x2,%eax
  803d26:	05 48 70 80 00       	add    $0x807048,%eax
  803d2b:	8a 00                	mov    (%eax),%al
  803d2d:	84 c0                	test   %al,%al
  803d2f:	74 39                	je     803d6a <sfree+0x321>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
  803d31:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d34:	89 d0                	mov    %edx,%eax
  803d36:	01 c0                	add    %eax,%eax
  803d38:	01 d0                	add    %edx,%eax
  803d3a:	c1 e0 02             	shl    $0x2,%eax
  803d3d:	05 40 70 80 00       	add    $0x807040,%eax
  803d42:	8b 08                	mov    (%eax),%ecx
  803d44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d47:	89 d0                	mov    %edx,%eax
  803d49:	01 c0                	add    %eax,%eax
  803d4b:	01 d0                	add    %edx,%eax
  803d4d:	c1 e0 02             	shl    $0x2,%eax
  803d50:	05 44 70 80 00       	add    $0x807044,%eax
  803d55:	8b 00                	mov    (%eax),%eax
  803d57:	01 c8                	add    %ecx,%eax
  803d59:	89 45 cc             	mov    %eax,-0x34(%ebp)
					if (end > maxEnd) maxEnd = end;
  803d5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d5f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803d62:	76 06                	jbe    803d6a <sfree+0x321>
  803d64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
						}
					}
				}
			}
			uint32 maxEnd = uheapPageAllocStart;
			for (int m = 0; m < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); m++)
  803d6a:	ff 45 e0             	incl   -0x20(%ebp)
  803d6d:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
  803d74:	7e a4                	jle    803d1a <sfree+0x2d1>
				{
					uint32 end = uhp_allocs[m].va + uhp_allocs[m].size;
					if (end > maxEnd) maxEnd = end;
				}
			}
			uheapPageAllocBreak = maxEnd;
  803d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d79:	a3 88 70 83 00       	mov    %eax,0x837088
			break;
  803d7e:	eb 16                	jmp    803d96 <sfree+0x34d>
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
	for (int i = 0; i < (int)(sizeof(uhp_allocs)/sizeof(uhp_allocs[0])); i++)
  803d80:	ff 45 f4             	incl   -0xc(%ebp)
  803d83:	81 7d f4 ff 0f 00 00 	cmpl   $0xfff,-0xc(%ebp)
  803d8a:	0f 8e 04 fd ff ff    	jle    803a94 <sfree+0x4b>
  803d90:	eb 04                	jmp    803d96 <sfree+0x34d>
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//Your code is here
	uint32 va = (uint32)virtual_address;
	if (va == 0) return;
  803d92:	90                   	nop
  803d93:	eb 01                	jmp    803d96 <sfree+0x34d>
	int id = (int)(va & 0x7FFFFFFF);
	int r = sys_delete_shared_object(id, virtual_address);
	if (r < 0) return;
  803d95:	90                   	nop
		}
	}

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}
  803d96:	c9                   	leave  
  803d97:	c3                   	ret    

00803d98 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803d98:	55                   	push   %ebp
  803d99:	89 e5                	mov    %esp,%ebp
  803d9b:	57                   	push   %edi
  803d9c:	56                   	push   %esi
  803d9d:	53                   	push   %ebx
  803d9e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803da1:	8b 45 08             	mov    0x8(%ebp),%eax
  803da4:	8b 55 0c             	mov    0xc(%ebp),%edx
  803da7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803daa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803dad:	8b 7d 18             	mov    0x18(%ebp),%edi
  803db0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803db3:	cd 30                	int    $0x30
  803db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803dbb:	83 c4 10             	add    $0x10,%esp
  803dbe:	5b                   	pop    %ebx
  803dbf:	5e                   	pop    %esi
  803dc0:	5f                   	pop    %edi
  803dc1:	5d                   	pop    %ebp
  803dc2:	c3                   	ret    

00803dc3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803dc3:	55                   	push   %ebp
  803dc4:	89 e5                	mov    %esp,%ebp
  803dc6:	83 ec 04             	sub    $0x4,%esp
  803dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  803dcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803dcf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803dd2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd9:	6a 00                	push   $0x0
  803ddb:	51                   	push   %ecx
  803ddc:	52                   	push   %edx
  803ddd:	ff 75 0c             	pushl  0xc(%ebp)
  803de0:	50                   	push   %eax
  803de1:	6a 00                	push   $0x0
  803de3:	e8 b0 ff ff ff       	call   803d98 <syscall>
  803de8:	83 c4 18             	add    $0x18,%esp
}
  803deb:	90                   	nop
  803dec:	c9                   	leave  
  803ded:	c3                   	ret    

00803dee <sys_cgetc>:

int
sys_cgetc(void)
{
  803dee:	55                   	push   %ebp
  803def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803df1:	6a 00                	push   $0x0
  803df3:	6a 00                	push   $0x0
  803df5:	6a 00                	push   $0x0
  803df7:	6a 00                	push   $0x0
  803df9:	6a 00                	push   $0x0
  803dfb:	6a 02                	push   $0x2
  803dfd:	e8 96 ff ff ff       	call   803d98 <syscall>
  803e02:	83 c4 18             	add    $0x18,%esp
}
  803e05:	c9                   	leave  
  803e06:	c3                   	ret    

00803e07 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803e07:	55                   	push   %ebp
  803e08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803e0a:	6a 00                	push   $0x0
  803e0c:	6a 00                	push   $0x0
  803e0e:	6a 00                	push   $0x0
  803e10:	6a 00                	push   $0x0
  803e12:	6a 00                	push   $0x0
  803e14:	6a 03                	push   $0x3
  803e16:	e8 7d ff ff ff       	call   803d98 <syscall>
  803e1b:	83 c4 18             	add    $0x18,%esp
}
  803e1e:	90                   	nop
  803e1f:	c9                   	leave  
  803e20:	c3                   	ret    

00803e21 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803e21:	55                   	push   %ebp
  803e22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803e24:	6a 00                	push   $0x0
  803e26:	6a 00                	push   $0x0
  803e28:	6a 00                	push   $0x0
  803e2a:	6a 00                	push   $0x0
  803e2c:	6a 00                	push   $0x0
  803e2e:	6a 04                	push   $0x4
  803e30:	e8 63 ff ff ff       	call   803d98 <syscall>
  803e35:	83 c4 18             	add    $0x18,%esp
}
  803e38:	90                   	nop
  803e39:	c9                   	leave  
  803e3a:	c3                   	ret    

00803e3b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803e3b:	55                   	push   %ebp
  803e3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e41:	8b 45 08             	mov    0x8(%ebp),%eax
  803e44:	6a 00                	push   $0x0
  803e46:	6a 00                	push   $0x0
  803e48:	6a 00                	push   $0x0
  803e4a:	52                   	push   %edx
  803e4b:	50                   	push   %eax
  803e4c:	6a 08                	push   $0x8
  803e4e:	e8 45 ff ff ff       	call   803d98 <syscall>
  803e53:	83 c4 18             	add    $0x18,%esp
}
  803e56:	c9                   	leave  
  803e57:	c3                   	ret    

00803e58 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803e58:	55                   	push   %ebp
  803e59:	89 e5                	mov    %esp,%ebp
  803e5b:	56                   	push   %esi
  803e5c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803e5d:	8b 75 18             	mov    0x18(%ebp),%esi
  803e60:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803e63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803e66:	8b 55 0c             	mov    0xc(%ebp),%edx
  803e69:	8b 45 08             	mov    0x8(%ebp),%eax
  803e6c:	56                   	push   %esi
  803e6d:	53                   	push   %ebx
  803e6e:	51                   	push   %ecx
  803e6f:	52                   	push   %edx
  803e70:	50                   	push   %eax
  803e71:	6a 09                	push   $0x9
  803e73:	e8 20 ff ff ff       	call   803d98 <syscall>
  803e78:	83 c4 18             	add    $0x18,%esp
}
  803e7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803e7e:	5b                   	pop    %ebx
  803e7f:	5e                   	pop    %esi
  803e80:	5d                   	pop    %ebp
  803e81:	c3                   	ret    

00803e82 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803e82:	55                   	push   %ebp
  803e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803e85:	6a 00                	push   $0x0
  803e87:	6a 00                	push   $0x0
  803e89:	6a 00                	push   $0x0
  803e8b:	6a 00                	push   $0x0
  803e8d:	ff 75 08             	pushl  0x8(%ebp)
  803e90:	6a 0a                	push   $0xa
  803e92:	e8 01 ff ff ff       	call   803d98 <syscall>
  803e97:	83 c4 18             	add    $0x18,%esp
}
  803e9a:	c9                   	leave  
  803e9b:	c3                   	ret    

00803e9c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803e9c:	55                   	push   %ebp
  803e9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803e9f:	6a 00                	push   $0x0
  803ea1:	6a 00                	push   $0x0
  803ea3:	6a 00                	push   $0x0
  803ea5:	ff 75 0c             	pushl  0xc(%ebp)
  803ea8:	ff 75 08             	pushl  0x8(%ebp)
  803eab:	6a 0b                	push   $0xb
  803ead:	e8 e6 fe ff ff       	call   803d98 <syscall>
  803eb2:	83 c4 18             	add    $0x18,%esp
}
  803eb5:	c9                   	leave  
  803eb6:	c3                   	ret    

00803eb7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803eb7:	55                   	push   %ebp
  803eb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803eba:	6a 00                	push   $0x0
  803ebc:	6a 00                	push   $0x0
  803ebe:	6a 00                	push   $0x0
  803ec0:	6a 00                	push   $0x0
  803ec2:	6a 00                	push   $0x0
  803ec4:	6a 0c                	push   $0xc
  803ec6:	e8 cd fe ff ff       	call   803d98 <syscall>
  803ecb:	83 c4 18             	add    $0x18,%esp
}
  803ece:	c9                   	leave  
  803ecf:	c3                   	ret    

00803ed0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803ed0:	55                   	push   %ebp
  803ed1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803ed3:	6a 00                	push   $0x0
  803ed5:	6a 00                	push   $0x0
  803ed7:	6a 00                	push   $0x0
  803ed9:	6a 00                	push   $0x0
  803edb:	6a 00                	push   $0x0
  803edd:	6a 0d                	push   $0xd
  803edf:	e8 b4 fe ff ff       	call   803d98 <syscall>
  803ee4:	83 c4 18             	add    $0x18,%esp
}
  803ee7:	c9                   	leave  
  803ee8:	c3                   	ret    

00803ee9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803ee9:	55                   	push   %ebp
  803eea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803eec:	6a 00                	push   $0x0
  803eee:	6a 00                	push   $0x0
  803ef0:	6a 00                	push   $0x0
  803ef2:	6a 00                	push   $0x0
  803ef4:	6a 00                	push   $0x0
  803ef6:	6a 0e                	push   $0xe
  803ef8:	e8 9b fe ff ff       	call   803d98 <syscall>
  803efd:	83 c4 18             	add    $0x18,%esp
}
  803f00:	c9                   	leave  
  803f01:	c3                   	ret    

00803f02 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803f02:	55                   	push   %ebp
  803f03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803f05:	6a 00                	push   $0x0
  803f07:	6a 00                	push   $0x0
  803f09:	6a 00                	push   $0x0
  803f0b:	6a 00                	push   $0x0
  803f0d:	6a 00                	push   $0x0
  803f0f:	6a 0f                	push   $0xf
  803f11:	e8 82 fe ff ff       	call   803d98 <syscall>
  803f16:	83 c4 18             	add    $0x18,%esp
}
  803f19:	c9                   	leave  
  803f1a:	c3                   	ret    

00803f1b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803f1b:	55                   	push   %ebp
  803f1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803f1e:	6a 00                	push   $0x0
  803f20:	6a 00                	push   $0x0
  803f22:	6a 00                	push   $0x0
  803f24:	6a 00                	push   $0x0
  803f26:	ff 75 08             	pushl  0x8(%ebp)
  803f29:	6a 10                	push   $0x10
  803f2b:	e8 68 fe ff ff       	call   803d98 <syscall>
  803f30:	83 c4 18             	add    $0x18,%esp
}
  803f33:	c9                   	leave  
  803f34:	c3                   	ret    

00803f35 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803f35:	55                   	push   %ebp
  803f36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803f38:	6a 00                	push   $0x0
  803f3a:	6a 00                	push   $0x0
  803f3c:	6a 00                	push   $0x0
  803f3e:	6a 00                	push   $0x0
  803f40:	6a 00                	push   $0x0
  803f42:	6a 11                	push   $0x11
  803f44:	e8 4f fe ff ff       	call   803d98 <syscall>
  803f49:	83 c4 18             	add    $0x18,%esp
}
  803f4c:	90                   	nop
  803f4d:	c9                   	leave  
  803f4e:	c3                   	ret    

00803f4f <sys_cputc>:

void
sys_cputc(const char c)
{
  803f4f:	55                   	push   %ebp
  803f50:	89 e5                	mov    %esp,%ebp
  803f52:	83 ec 04             	sub    $0x4,%esp
  803f55:	8b 45 08             	mov    0x8(%ebp),%eax
  803f58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803f5b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803f5f:	6a 00                	push   $0x0
  803f61:	6a 00                	push   $0x0
  803f63:	6a 00                	push   $0x0
  803f65:	6a 00                	push   $0x0
  803f67:	50                   	push   %eax
  803f68:	6a 01                	push   $0x1
  803f6a:	e8 29 fe ff ff       	call   803d98 <syscall>
  803f6f:	83 c4 18             	add    $0x18,%esp
}
  803f72:	90                   	nop
  803f73:	c9                   	leave  
  803f74:	c3                   	ret    

00803f75 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803f75:	55                   	push   %ebp
  803f76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803f78:	6a 00                	push   $0x0
  803f7a:	6a 00                	push   $0x0
  803f7c:	6a 00                	push   $0x0
  803f7e:	6a 00                	push   $0x0
  803f80:	6a 00                	push   $0x0
  803f82:	6a 14                	push   $0x14
  803f84:	e8 0f fe ff ff       	call   803d98 <syscall>
  803f89:	83 c4 18             	add    $0x18,%esp
}
  803f8c:	90                   	nop
  803f8d:	c9                   	leave  
  803f8e:	c3                   	ret    

00803f8f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803f8f:	55                   	push   %ebp
  803f90:	89 e5                	mov    %esp,%ebp
  803f92:	83 ec 04             	sub    $0x4,%esp
  803f95:	8b 45 10             	mov    0x10(%ebp),%eax
  803f98:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803f9b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803f9e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa5:	6a 00                	push   $0x0
  803fa7:	51                   	push   %ecx
  803fa8:	52                   	push   %edx
  803fa9:	ff 75 0c             	pushl  0xc(%ebp)
  803fac:	50                   	push   %eax
  803fad:	6a 15                	push   $0x15
  803faf:	e8 e4 fd ff ff       	call   803d98 <syscall>
  803fb4:	83 c4 18             	add    $0x18,%esp
}
  803fb7:	c9                   	leave  
  803fb8:	c3                   	ret    

00803fb9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803fb9:	55                   	push   %ebp
  803fba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  803fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc2:	6a 00                	push   $0x0
  803fc4:	6a 00                	push   $0x0
  803fc6:	6a 00                	push   $0x0
  803fc8:	52                   	push   %edx
  803fc9:	50                   	push   %eax
  803fca:	6a 16                	push   $0x16
  803fcc:	e8 c7 fd ff ff       	call   803d98 <syscall>
  803fd1:	83 c4 18             	add    $0x18,%esp
}
  803fd4:	c9                   	leave  
  803fd5:	c3                   	ret    

00803fd6 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803fd6:	55                   	push   %ebp
  803fd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803fd9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803fdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  803fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe2:	6a 00                	push   $0x0
  803fe4:	6a 00                	push   $0x0
  803fe6:	51                   	push   %ecx
  803fe7:	52                   	push   %edx
  803fe8:	50                   	push   %eax
  803fe9:	6a 17                	push   $0x17
  803feb:	e8 a8 fd ff ff       	call   803d98 <syscall>
  803ff0:	83 c4 18             	add    $0x18,%esp
}
  803ff3:	c9                   	leave  
  803ff4:	c3                   	ret    

00803ff5 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803ff5:	55                   	push   %ebp
  803ff6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffe:	6a 00                	push   $0x0
  804000:	6a 00                	push   $0x0
  804002:	6a 00                	push   $0x0
  804004:	52                   	push   %edx
  804005:	50                   	push   %eax
  804006:	6a 18                	push   $0x18
  804008:	e8 8b fd ff ff       	call   803d98 <syscall>
  80400d:	83 c4 18             	add    $0x18,%esp
}
  804010:	c9                   	leave  
  804011:	c3                   	ret    

00804012 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  804012:	55                   	push   %ebp
  804013:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  804015:	8b 45 08             	mov    0x8(%ebp),%eax
  804018:	6a 00                	push   $0x0
  80401a:	ff 75 14             	pushl  0x14(%ebp)
  80401d:	ff 75 10             	pushl  0x10(%ebp)
  804020:	ff 75 0c             	pushl  0xc(%ebp)
  804023:	50                   	push   %eax
  804024:	6a 19                	push   $0x19
  804026:	e8 6d fd ff ff       	call   803d98 <syscall>
  80402b:	83 c4 18             	add    $0x18,%esp
}
  80402e:	c9                   	leave  
  80402f:	c3                   	ret    

00804030 <sys_run_env>:

void sys_run_env(int32 envId)
{
  804030:	55                   	push   %ebp
  804031:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  804033:	8b 45 08             	mov    0x8(%ebp),%eax
  804036:	6a 00                	push   $0x0
  804038:	6a 00                	push   $0x0
  80403a:	6a 00                	push   $0x0
  80403c:	6a 00                	push   $0x0
  80403e:	50                   	push   %eax
  80403f:	6a 1a                	push   $0x1a
  804041:	e8 52 fd ff ff       	call   803d98 <syscall>
  804046:	83 c4 18             	add    $0x18,%esp
}
  804049:	90                   	nop
  80404a:	c9                   	leave  
  80404b:	c3                   	ret    

0080404c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80404c:	55                   	push   %ebp
  80404d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80404f:	8b 45 08             	mov    0x8(%ebp),%eax
  804052:	6a 00                	push   $0x0
  804054:	6a 00                	push   $0x0
  804056:	6a 00                	push   $0x0
  804058:	6a 00                	push   $0x0
  80405a:	50                   	push   %eax
  80405b:	6a 1b                	push   $0x1b
  80405d:	e8 36 fd ff ff       	call   803d98 <syscall>
  804062:	83 c4 18             	add    $0x18,%esp
}
  804065:	c9                   	leave  
  804066:	c3                   	ret    

00804067 <sys_getenvid>:

int32 sys_getenvid(void)
{
  804067:	55                   	push   %ebp
  804068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80406a:	6a 00                	push   $0x0
  80406c:	6a 00                	push   $0x0
  80406e:	6a 00                	push   $0x0
  804070:	6a 00                	push   $0x0
  804072:	6a 00                	push   $0x0
  804074:	6a 05                	push   $0x5
  804076:	e8 1d fd ff ff       	call   803d98 <syscall>
  80407b:	83 c4 18             	add    $0x18,%esp
}
  80407e:	c9                   	leave  
  80407f:	c3                   	ret    

00804080 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  804080:	55                   	push   %ebp
  804081:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  804083:	6a 00                	push   $0x0
  804085:	6a 00                	push   $0x0
  804087:	6a 00                	push   $0x0
  804089:	6a 00                	push   $0x0
  80408b:	6a 00                	push   $0x0
  80408d:	6a 06                	push   $0x6
  80408f:	e8 04 fd ff ff       	call   803d98 <syscall>
  804094:	83 c4 18             	add    $0x18,%esp
}
  804097:	c9                   	leave  
  804098:	c3                   	ret    

00804099 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  804099:	55                   	push   %ebp
  80409a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80409c:	6a 00                	push   $0x0
  80409e:	6a 00                	push   $0x0
  8040a0:	6a 00                	push   $0x0
  8040a2:	6a 00                	push   $0x0
  8040a4:	6a 00                	push   $0x0
  8040a6:	6a 07                	push   $0x7
  8040a8:	e8 eb fc ff ff       	call   803d98 <syscall>
  8040ad:	83 c4 18             	add    $0x18,%esp
}
  8040b0:	c9                   	leave  
  8040b1:	c3                   	ret    

008040b2 <sys_exit_env>:


void sys_exit_env(void)
{
  8040b2:	55                   	push   %ebp
  8040b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8040b5:	6a 00                	push   $0x0
  8040b7:	6a 00                	push   $0x0
  8040b9:	6a 00                	push   $0x0
  8040bb:	6a 00                	push   $0x0
  8040bd:	6a 00                	push   $0x0
  8040bf:	6a 1c                	push   $0x1c
  8040c1:	e8 d2 fc ff ff       	call   803d98 <syscall>
  8040c6:	83 c4 18             	add    $0x18,%esp
}
  8040c9:	90                   	nop
  8040ca:	c9                   	leave  
  8040cb:	c3                   	ret    

008040cc <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8040cc:	55                   	push   %ebp
  8040cd:	89 e5                	mov    %esp,%ebp
  8040cf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8040d2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8040d5:	8d 50 04             	lea    0x4(%eax),%edx
  8040d8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8040db:	6a 00                	push   $0x0
  8040dd:	6a 00                	push   $0x0
  8040df:	6a 00                	push   $0x0
  8040e1:	52                   	push   %edx
  8040e2:	50                   	push   %eax
  8040e3:	6a 1d                	push   $0x1d
  8040e5:	e8 ae fc ff ff       	call   803d98 <syscall>
  8040ea:	83 c4 18             	add    $0x18,%esp
	return result;
  8040ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8040f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8040f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8040f6:	89 01                	mov    %eax,(%ecx)
  8040f8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8040fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8040fe:	c9                   	leave  
  8040ff:	c2 04 00             	ret    $0x4

00804102 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  804102:	55                   	push   %ebp
  804103:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  804105:	6a 00                	push   $0x0
  804107:	6a 00                	push   $0x0
  804109:	ff 75 10             	pushl  0x10(%ebp)
  80410c:	ff 75 0c             	pushl  0xc(%ebp)
  80410f:	ff 75 08             	pushl  0x8(%ebp)
  804112:	6a 13                	push   $0x13
  804114:	e8 7f fc ff ff       	call   803d98 <syscall>
  804119:	83 c4 18             	add    $0x18,%esp
	return ;
  80411c:	90                   	nop
}
  80411d:	c9                   	leave  
  80411e:	c3                   	ret    

0080411f <sys_rcr2>:
uint32 sys_rcr2()
{
  80411f:	55                   	push   %ebp
  804120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  804122:	6a 00                	push   $0x0
  804124:	6a 00                	push   $0x0
  804126:	6a 00                	push   $0x0
  804128:	6a 00                	push   $0x0
  80412a:	6a 00                	push   $0x0
  80412c:	6a 1e                	push   $0x1e
  80412e:	e8 65 fc ff ff       	call   803d98 <syscall>
  804133:	83 c4 18             	add    $0x18,%esp
}
  804136:	c9                   	leave  
  804137:	c3                   	ret    

00804138 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  804138:	55                   	push   %ebp
  804139:	89 e5                	mov    %esp,%ebp
  80413b:	83 ec 04             	sub    $0x4,%esp
  80413e:	8b 45 08             	mov    0x8(%ebp),%eax
  804141:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  804144:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  804148:	6a 00                	push   $0x0
  80414a:	6a 00                	push   $0x0
  80414c:	6a 00                	push   $0x0
  80414e:	6a 00                	push   $0x0
  804150:	50                   	push   %eax
  804151:	6a 1f                	push   $0x1f
  804153:	e8 40 fc ff ff       	call   803d98 <syscall>
  804158:	83 c4 18             	add    $0x18,%esp
	return ;
  80415b:	90                   	nop
}
  80415c:	c9                   	leave  
  80415d:	c3                   	ret    

0080415e <rsttst>:
void rsttst()
{
  80415e:	55                   	push   %ebp
  80415f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  804161:	6a 00                	push   $0x0
  804163:	6a 00                	push   $0x0
  804165:	6a 00                	push   $0x0
  804167:	6a 00                	push   $0x0
  804169:	6a 00                	push   $0x0
  80416b:	6a 21                	push   $0x21
  80416d:	e8 26 fc ff ff       	call   803d98 <syscall>
  804172:	83 c4 18             	add    $0x18,%esp
	return ;
  804175:	90                   	nop
}
  804176:	c9                   	leave  
  804177:	c3                   	ret    

00804178 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  804178:	55                   	push   %ebp
  804179:	89 e5                	mov    %esp,%ebp
  80417b:	83 ec 04             	sub    $0x4,%esp
  80417e:	8b 45 14             	mov    0x14(%ebp),%eax
  804181:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  804184:	8b 55 18             	mov    0x18(%ebp),%edx
  804187:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80418b:	52                   	push   %edx
  80418c:	50                   	push   %eax
  80418d:	ff 75 10             	pushl  0x10(%ebp)
  804190:	ff 75 0c             	pushl  0xc(%ebp)
  804193:	ff 75 08             	pushl  0x8(%ebp)
  804196:	6a 20                	push   $0x20
  804198:	e8 fb fb ff ff       	call   803d98 <syscall>
  80419d:	83 c4 18             	add    $0x18,%esp
	return ;
  8041a0:	90                   	nop
}
  8041a1:	c9                   	leave  
  8041a2:	c3                   	ret    

008041a3 <chktst>:
void chktst(uint32 n)
{
  8041a3:	55                   	push   %ebp
  8041a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8041a6:	6a 00                	push   $0x0
  8041a8:	6a 00                	push   $0x0
  8041aa:	6a 00                	push   $0x0
  8041ac:	6a 00                	push   $0x0
  8041ae:	ff 75 08             	pushl  0x8(%ebp)
  8041b1:	6a 22                	push   $0x22
  8041b3:	e8 e0 fb ff ff       	call   803d98 <syscall>
  8041b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8041bb:	90                   	nop
}
  8041bc:	c9                   	leave  
  8041bd:	c3                   	ret    

008041be <inctst>:

void inctst()
{
  8041be:	55                   	push   %ebp
  8041bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8041c1:	6a 00                	push   $0x0
  8041c3:	6a 00                	push   $0x0
  8041c5:	6a 00                	push   $0x0
  8041c7:	6a 00                	push   $0x0
  8041c9:	6a 00                	push   $0x0
  8041cb:	6a 23                	push   $0x23
  8041cd:	e8 c6 fb ff ff       	call   803d98 <syscall>
  8041d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8041d5:	90                   	nop
}
  8041d6:	c9                   	leave  
  8041d7:	c3                   	ret    

008041d8 <gettst>:
uint32 gettst()
{
  8041d8:	55                   	push   %ebp
  8041d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8041db:	6a 00                	push   $0x0
  8041dd:	6a 00                	push   $0x0
  8041df:	6a 00                	push   $0x0
  8041e1:	6a 00                	push   $0x0
  8041e3:	6a 00                	push   $0x0
  8041e5:	6a 24                	push   $0x24
  8041e7:	e8 ac fb ff ff       	call   803d98 <syscall>
  8041ec:	83 c4 18             	add    $0x18,%esp
}
  8041ef:	c9                   	leave  
  8041f0:	c3                   	ret    

008041f1 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8041f1:	55                   	push   %ebp
  8041f2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8041f4:	6a 00                	push   $0x0
  8041f6:	6a 00                	push   $0x0
  8041f8:	6a 00                	push   $0x0
  8041fa:	6a 00                	push   $0x0
  8041fc:	6a 00                	push   $0x0
  8041fe:	6a 25                	push   $0x25
  804200:	e8 93 fb ff ff       	call   803d98 <syscall>
  804205:	83 c4 18             	add    $0x18,%esp
  804208:	a3 80 70 83 00       	mov    %eax,0x837080
	return uheapPlaceStrategy ;
  80420d:	a1 80 70 83 00       	mov    0x837080,%eax
}
  804212:	c9                   	leave  
  804213:	c3                   	ret    

00804214 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  804214:	55                   	push   %ebp
  804215:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  804217:	8b 45 08             	mov    0x8(%ebp),%eax
  80421a:	a3 80 70 83 00       	mov    %eax,0x837080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80421f:	6a 00                	push   $0x0
  804221:	6a 00                	push   $0x0
  804223:	6a 00                	push   $0x0
  804225:	6a 00                	push   $0x0
  804227:	ff 75 08             	pushl  0x8(%ebp)
  80422a:	6a 26                	push   $0x26
  80422c:	e8 67 fb ff ff       	call   803d98 <syscall>
  804231:	83 c4 18             	add    $0x18,%esp
	return ;
  804234:	90                   	nop
}
  804235:	c9                   	leave  
  804236:	c3                   	ret    

00804237 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  804237:	55                   	push   %ebp
  804238:	89 e5                	mov    %esp,%ebp
  80423a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80423b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80423e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804241:	8b 55 0c             	mov    0xc(%ebp),%edx
  804244:	8b 45 08             	mov    0x8(%ebp),%eax
  804247:	6a 00                	push   $0x0
  804249:	53                   	push   %ebx
  80424a:	51                   	push   %ecx
  80424b:	52                   	push   %edx
  80424c:	50                   	push   %eax
  80424d:	6a 27                	push   $0x27
  80424f:	e8 44 fb ff ff       	call   803d98 <syscall>
  804254:	83 c4 18             	add    $0x18,%esp
}
  804257:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80425a:	c9                   	leave  
  80425b:	c3                   	ret    

0080425c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80425c:	55                   	push   %ebp
  80425d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80425f:	8b 55 0c             	mov    0xc(%ebp),%edx
  804262:	8b 45 08             	mov    0x8(%ebp),%eax
  804265:	6a 00                	push   $0x0
  804267:	6a 00                	push   $0x0
  804269:	6a 00                	push   $0x0
  80426b:	52                   	push   %edx
  80426c:	50                   	push   %eax
  80426d:	6a 28                	push   $0x28
  80426f:	e8 24 fb ff ff       	call   803d98 <syscall>
  804274:	83 c4 18             	add    $0x18,%esp
}
  804277:	c9                   	leave  
  804278:	c3                   	ret    

00804279 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  804279:	55                   	push   %ebp
  80427a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80427c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80427f:	8b 55 0c             	mov    0xc(%ebp),%edx
  804282:	8b 45 08             	mov    0x8(%ebp),%eax
  804285:	6a 00                	push   $0x0
  804287:	51                   	push   %ecx
  804288:	ff 75 10             	pushl  0x10(%ebp)
  80428b:	52                   	push   %edx
  80428c:	50                   	push   %eax
  80428d:	6a 29                	push   $0x29
  80428f:	e8 04 fb ff ff       	call   803d98 <syscall>
  804294:	83 c4 18             	add    $0x18,%esp
}
  804297:	c9                   	leave  
  804298:	c3                   	ret    

00804299 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  804299:	55                   	push   %ebp
  80429a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80429c:	6a 00                	push   $0x0
  80429e:	6a 00                	push   $0x0
  8042a0:	ff 75 10             	pushl  0x10(%ebp)
  8042a3:	ff 75 0c             	pushl  0xc(%ebp)
  8042a6:	ff 75 08             	pushl  0x8(%ebp)
  8042a9:	6a 12                	push   $0x12
  8042ab:	e8 e8 fa ff ff       	call   803d98 <syscall>
  8042b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8042b3:	90                   	nop
}
  8042b4:	c9                   	leave  
  8042b5:	c3                   	ret    

008042b6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8042b6:	55                   	push   %ebp
  8042b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8042b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8042bf:	6a 00                	push   $0x0
  8042c1:	6a 00                	push   $0x0
  8042c3:	6a 00                	push   $0x0
  8042c5:	52                   	push   %edx
  8042c6:	50                   	push   %eax
  8042c7:	6a 2a                	push   $0x2a
  8042c9:	e8 ca fa ff ff       	call   803d98 <syscall>
  8042ce:	83 c4 18             	add    $0x18,%esp
	return;
  8042d1:	90                   	nop
}
  8042d2:	c9                   	leave  
  8042d3:	c3                   	ret    

008042d4 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8042d4:	55                   	push   %ebp
  8042d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8042d7:	6a 00                	push   $0x0
  8042d9:	6a 00                	push   $0x0
  8042db:	6a 00                	push   $0x0
  8042dd:	6a 00                	push   $0x0
  8042df:	6a 00                	push   $0x0
  8042e1:	6a 2b                	push   $0x2b
  8042e3:	e8 b0 fa ff ff       	call   803d98 <syscall>
  8042e8:	83 c4 18             	add    $0x18,%esp
}
  8042eb:	c9                   	leave  
  8042ec:	c3                   	ret    

008042ed <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8042ed:	55                   	push   %ebp
  8042ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8042f0:	6a 00                	push   $0x0
  8042f2:	6a 00                	push   $0x0
  8042f4:	6a 00                	push   $0x0
  8042f6:	ff 75 0c             	pushl  0xc(%ebp)
  8042f9:	ff 75 08             	pushl  0x8(%ebp)
  8042fc:	6a 2d                	push   $0x2d
  8042fe:	e8 95 fa ff ff       	call   803d98 <syscall>
  804303:	83 c4 18             	add    $0x18,%esp
	return;
  804306:	90                   	nop
}
  804307:	c9                   	leave  
  804308:	c3                   	ret    

00804309 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  804309:	55                   	push   %ebp
  80430a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80430c:	6a 00                	push   $0x0
  80430e:	6a 00                	push   $0x0
  804310:	6a 00                	push   $0x0
  804312:	ff 75 0c             	pushl  0xc(%ebp)
  804315:	ff 75 08             	pushl  0x8(%ebp)
  804318:	6a 2c                	push   $0x2c
  80431a:	e8 79 fa ff ff       	call   803d98 <syscall>
  80431f:	83 c4 18             	add    $0x18,%esp
	return ;
  804322:	90                   	nop
}
  804323:	c9                   	leave  
  804324:	c3                   	ret    

00804325 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  804325:	55                   	push   %ebp
  804326:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  804328:	8b 55 0c             	mov    0xc(%ebp),%edx
  80432b:	8b 45 08             	mov    0x8(%ebp),%eax
  80432e:	6a 00                	push   $0x0
  804330:	6a 00                	push   $0x0
  804332:	6a 00                	push   $0x0
  804334:	52                   	push   %edx
  804335:	50                   	push   %eax
  804336:	6a 2e                	push   $0x2e
  804338:	e8 5b fa ff ff       	call   803d98 <syscall>
  80433d:	83 c4 18             	add    $0x18,%esp
}
  804340:	90                   	nop
  804341:	c9                   	leave  
  804342:	c3                   	ret    

00804343 <to_page_va>:

//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  804343:	55                   	push   %ebp
  804344:	89 e5                	mov    %esp,%ebp
  804346:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  804349:	81 7d 08 80 f0 81 00 	cmpl   $0x81f080,0x8(%ebp)
  804350:	72 09                	jb     80435b <to_page_va+0x18>
  804352:	81 7d 08 80 70 83 00 	cmpl   $0x837080,0x8(%ebp)
  804359:	72 14                	jb     80436f <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80435b:	83 ec 04             	sub    $0x4,%esp
  80435e:	68 6c 5f 80 00       	push   $0x805f6c
  804363:	6a 15                	push   $0x15
  804365:	68 97 5f 80 00       	push   $0x805f97
  80436a:	e8 08 ce ff ff       	call   801177 <_panic>
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  80436f:	8b 45 08             	mov    0x8(%ebp),%eax
  804372:	ba 80 f0 81 00       	mov    $0x81f080,%edx
  804377:	29 d0                	sub    %edx,%eax
  804379:	c1 f8 02             	sar    $0x2,%eax
  80437c:	89 c2                	mov    %eax,%edx
  80437e:	89 d0                	mov    %edx,%eax
  804380:	c1 e0 02             	shl    $0x2,%eax
  804383:	01 d0                	add    %edx,%eax
  804385:	c1 e0 02             	shl    $0x2,%eax
  804388:	01 d0                	add    %edx,%eax
  80438a:	c1 e0 02             	shl    $0x2,%eax
  80438d:	01 d0                	add    %edx,%eax
  80438f:	89 c1                	mov    %eax,%ecx
  804391:	c1 e1 08             	shl    $0x8,%ecx
  804394:	01 c8                	add    %ecx,%eax
  804396:	89 c1                	mov    %eax,%ecx
  804398:	c1 e1 10             	shl    $0x10,%ecx
  80439b:	01 c8                	add    %ecx,%eax
  80439d:	01 c0                	add    %eax,%eax
  80439f:	01 d0                	add    %edx,%eax
  8043a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8043a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a7:	c1 e0 0c             	shl    $0xc,%eax
  8043aa:	89 c2                	mov    %eax,%edx
  8043ac:	a1 84 70 83 00       	mov    0x837084,%eax
  8043b1:	01 d0                	add    %edx,%eax
}
  8043b3:	c9                   	leave  
  8043b4:	c3                   	ret    

008043b5 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8043b5:	55                   	push   %ebp
  8043b6:	89 e5                	mov    %esp,%ebp
  8043b8:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  8043bb:	a1 84 70 83 00       	mov    0x837084,%eax
  8043c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8043c3:	29 c2                	sub    %eax,%edx
  8043c5:	89 d0                	mov    %edx,%eax
  8043c7:	c1 e8 0c             	shr    $0xc,%eax
  8043ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  8043cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043d1:	78 09                	js     8043dc <to_page_info+0x27>
  8043d3:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  8043da:	7e 14                	jle    8043f0 <to_page_info+0x3b>
		panic("to_page_info called with invalid va");
  8043dc:	83 ec 04             	sub    $0x4,%esp
  8043df:	68 b0 5f 80 00       	push   $0x805fb0
  8043e4:	6a 21                	push   $0x21
  8043e6:	68 97 5f 80 00       	push   $0x805f97
  8043eb:	e8 87 cd ff ff       	call   801177 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8043f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8043f3:	89 d0                	mov    %edx,%eax
  8043f5:	01 c0                	add    %eax,%eax
  8043f7:	01 d0                	add    %edx,%eax
  8043f9:	c1 e0 02             	shl    $0x2,%eax
  8043fc:	05 80 f0 81 00       	add    $0x81f080,%eax
}
  804401:	c9                   	leave  
  804402:	c3                   	ret    

00804403 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  804403:	55                   	push   %ebp
  804404:	89 e5                	mov    %esp,%ebp
  804406:	83 ec 18             	sub    $0x18,%esp
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  804409:	8b 45 08             	mov    0x8(%ebp),%eax
  80440c:	05 00 00 00 02       	add    $0x2000000,%eax
  804411:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804414:	73 16                	jae    80442c <initialize_dynamic_allocator+0x29>
  804416:	68 d4 5f 80 00       	push   $0x805fd4
  80441b:	68 fa 5f 80 00       	push   $0x805ffa
  804420:	6a 2f                	push   $0x2f
  804422:	68 97 5f 80 00       	push   $0x805f97
  804427:	e8 4b cd ff ff       	call   801177 <_panic>
	dynAllocStart = daStart;
  80442c:	8b 45 08             	mov    0x8(%ebp),%eax
  80442f:	a3 84 70 83 00       	mov    %eax,0x837084
	dynAllocEnd = daEnd;
  804434:	8b 45 0c             	mov    0xc(%ebp),%eax
  804437:	a3 60 f0 81 00       	mov    %eax,0x81f060

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80443c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804443:	eb 36                	jmp    80447b <initialize_dynamic_allocator+0x78>
		LIST_INIT(&freeBlockLists[i]);
  804445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804448:	c1 e0 04             	shl    $0x4,%eax
  80444b:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804459:	c1 e0 04             	shl    $0x4,%eax
  80445c:	05 a4 70 83 00       	add    $0x8370a4,%eax
  804461:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80446a:	c1 e0 04             	shl    $0x4,%eax
  80446d:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804472:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
	dynAllocStart = daStart;
	dynAllocEnd = daEnd;

	// Initialize free lists for each block size
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  804478:	ff 45 f4             	incl   -0xc(%ebp)
  80447b:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80447f:	7e c4                	jle    804445 <initialize_dynamic_allocator+0x42>
		LIST_INIT(&freeBlockLists[i]);

	// Initialize free pages list
	LIST_INIT(&freePagesList);
  804481:	c7 05 68 f0 81 00 00 	movl   $0x0,0x81f068
  804488:	00 00 00 
  80448b:	c7 05 6c f0 81 00 00 	movl   $0x0,0x81f06c
  804492:	00 00 00 
  804495:	c7 05 74 f0 81 00 00 	movl   $0x0,0x81f074
  80449c:	00 00 00 

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  80449f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8044a6:	e9 1b 01 00 00       	jmp    8045c6 <initialize_dynamic_allocator+0x1c3>
	{
		pageBlockInfoArr[i].block_size = 0;
  8044ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044ae:	89 d0                	mov    %edx,%eax
  8044b0:	01 c0                	add    %eax,%eax
  8044b2:	01 d0                	add    %edx,%eax
  8044b4:	c1 e0 02             	shl    $0x2,%eax
  8044b7:	05 88 f0 81 00       	add    $0x81f088,%eax
  8044bc:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[i].num_of_free_blocks = 0;
  8044c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044c4:	89 d0                	mov    %edx,%eax
  8044c6:	01 c0                	add    %eax,%eax
  8044c8:	01 d0                	add    %edx,%eax
  8044ca:	c1 e0 02             	shl    $0x2,%eax
  8044cd:	05 8a f0 81 00       	add    $0x81f08a,%eax
  8044d2:	66 c7 00 00 00       	movw   $0x0,(%eax)
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
  8044d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044da:	89 d0                	mov    %edx,%eax
  8044dc:	01 c0                	add    %eax,%eax
  8044de:	01 d0                	add    %edx,%eax
  8044e0:	c1 e0 02             	shl    $0x2,%eax
  8044e3:	05 80 f0 81 00       	add    $0x81f080,%eax
  8044e8:	8b 00                	mov    (%eax),%eax
  8044ea:	85 c0                	test   %eax,%eax
  8044ec:	74 2b                	je     804519 <initialize_dynamic_allocator+0x116>
  8044ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044f1:	89 d0                	mov    %edx,%eax
  8044f3:	01 c0                	add    %eax,%eax
  8044f5:	01 d0                	add    %edx,%eax
  8044f7:	c1 e0 02             	shl    $0x2,%eax
  8044fa:	05 80 f0 81 00       	add    $0x81f080,%eax
  8044ff:	8b 10                	mov    (%eax),%edx
  804501:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804504:	89 c8                	mov    %ecx,%eax
  804506:	01 c0                	add    %eax,%eax
  804508:	01 c8                	add    %ecx,%eax
  80450a:	c1 e0 02             	shl    $0x2,%eax
  80450d:	05 84 f0 81 00       	add    $0x81f084,%eax
  804512:	8b 00                	mov    (%eax),%eax
  804514:	89 42 04             	mov    %eax,0x4(%edx)
  804517:	eb 18                	jmp    804531 <initialize_dynamic_allocator+0x12e>
  804519:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80451c:	89 d0                	mov    %edx,%eax
  80451e:	01 c0                	add    %eax,%eax
  804520:	01 d0                	add    %edx,%eax
  804522:	c1 e0 02             	shl    $0x2,%eax
  804525:	05 84 f0 81 00       	add    $0x81f084,%eax
  80452a:	8b 00                	mov    (%eax),%eax
  80452c:	a3 6c f0 81 00       	mov    %eax,0x81f06c
  804531:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804534:	89 d0                	mov    %edx,%eax
  804536:	01 c0                	add    %eax,%eax
  804538:	01 d0                	add    %edx,%eax
  80453a:	c1 e0 02             	shl    $0x2,%eax
  80453d:	05 84 f0 81 00       	add    $0x81f084,%eax
  804542:	8b 00                	mov    (%eax),%eax
  804544:	85 c0                	test   %eax,%eax
  804546:	74 2a                	je     804572 <initialize_dynamic_allocator+0x16f>
  804548:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80454b:	89 d0                	mov    %edx,%eax
  80454d:	01 c0                	add    %eax,%eax
  80454f:	01 d0                	add    %edx,%eax
  804551:	c1 e0 02             	shl    $0x2,%eax
  804554:	05 84 f0 81 00       	add    $0x81f084,%eax
  804559:	8b 10                	mov    (%eax),%edx
  80455b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80455e:	89 c8                	mov    %ecx,%eax
  804560:	01 c0                	add    %eax,%eax
  804562:	01 c8                	add    %ecx,%eax
  804564:	c1 e0 02             	shl    $0x2,%eax
  804567:	05 80 f0 81 00       	add    $0x81f080,%eax
  80456c:	8b 00                	mov    (%eax),%eax
  80456e:	89 02                	mov    %eax,(%edx)
  804570:	eb 18                	jmp    80458a <initialize_dynamic_allocator+0x187>
  804572:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804575:	89 d0                	mov    %edx,%eax
  804577:	01 c0                	add    %eax,%eax
  804579:	01 d0                	add    %edx,%eax
  80457b:	c1 e0 02             	shl    $0x2,%eax
  80457e:	05 80 f0 81 00       	add    $0x81f080,%eax
  804583:	8b 00                	mov    (%eax),%eax
  804585:	a3 68 f0 81 00       	mov    %eax,0x81f068
  80458a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80458d:	89 d0                	mov    %edx,%eax
  80458f:	01 c0                	add    %eax,%eax
  804591:	01 d0                	add    %edx,%eax
  804593:	c1 e0 02             	shl    $0x2,%eax
  804596:	05 80 f0 81 00       	add    $0x81f080,%eax
  80459b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8045a4:	89 d0                	mov    %edx,%eax
  8045a6:	01 c0                	add    %eax,%eax
  8045a8:	01 d0                	add    %edx,%eax
  8045aa:	c1 e0 02             	shl    $0x2,%eax
  8045ad:	05 84 f0 81 00       	add    $0x81f084,%eax
  8045b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045b8:	a1 74 f0 81 00       	mov    0x81f074,%eax
  8045bd:	48                   	dec    %eax
  8045be:	a3 74 f0 81 00       	mov    %eax,0x81f074

	// Initialize free pages list
	LIST_INIT(&freePagesList);

	// Initialize page info array
	for (int i = 0; i < DYN_ALLOC_MAX_SIZE / PAGE_SIZE; i++)
  8045c3:	ff 45 f0             	incl   -0x10(%ebp)
  8045c6:	81 7d f0 ff 1f 00 00 	cmpl   $0x1fff,-0x10(%ebp)
  8045cd:	0f 8e d8 fe ff ff    	jle    8044ab <initialize_dynamic_allocator+0xa8>
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  8045d3:	c7 45 ec ff 1f 00 00 	movl   $0x1fff,-0x14(%ebp)
  8045da:	e9 9d 00 00 00       	jmp    80467c <initialize_dynamic_allocator+0x279>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
  8045df:	8b 15 68 f0 81 00    	mov    0x81f068,%edx
  8045e5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8045e8:	89 c8                	mov    %ecx,%eax
  8045ea:	01 c0                	add    %eax,%eax
  8045ec:	01 c8                	add    %ecx,%eax
  8045ee:	c1 e0 02             	shl    $0x2,%eax
  8045f1:	05 80 f0 81 00       	add    $0x81f080,%eax
  8045f6:	89 10                	mov    %edx,(%eax)
  8045f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8045fb:	89 d0                	mov    %edx,%eax
  8045fd:	01 c0                	add    %eax,%eax
  8045ff:	01 d0                	add    %edx,%eax
  804601:	c1 e0 02             	shl    $0x2,%eax
  804604:	05 80 f0 81 00       	add    $0x81f080,%eax
  804609:	8b 00                	mov    (%eax),%eax
  80460b:	85 c0                	test   %eax,%eax
  80460d:	74 1c                	je     80462b <initialize_dynamic_allocator+0x228>
  80460f:	8b 15 68 f0 81 00    	mov    0x81f068,%edx
  804615:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  804618:	89 c8                	mov    %ecx,%eax
  80461a:	01 c0                	add    %eax,%eax
  80461c:	01 c8                	add    %ecx,%eax
  80461e:	c1 e0 02             	shl    $0x2,%eax
  804621:	05 80 f0 81 00       	add    $0x81f080,%eax
  804626:	89 42 04             	mov    %eax,0x4(%edx)
  804629:	eb 16                	jmp    804641 <initialize_dynamic_allocator+0x23e>
  80462b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80462e:	89 d0                	mov    %edx,%eax
  804630:	01 c0                	add    %eax,%eax
  804632:	01 d0                	add    %edx,%eax
  804634:	c1 e0 02             	shl    $0x2,%eax
  804637:	05 80 f0 81 00       	add    $0x81f080,%eax
  80463c:	a3 6c f0 81 00       	mov    %eax,0x81f06c
  804641:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804644:	89 d0                	mov    %edx,%eax
  804646:	01 c0                	add    %eax,%eax
  804648:	01 d0                	add    %edx,%eax
  80464a:	c1 e0 02             	shl    $0x2,%eax
  80464d:	05 80 f0 81 00       	add    $0x81f080,%eax
  804652:	a3 68 f0 81 00       	mov    %eax,0x81f068
  804657:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80465a:	89 d0                	mov    %edx,%eax
  80465c:	01 c0                	add    %eax,%eax
  80465e:	01 d0                	add    %edx,%eax
  804660:	c1 e0 02             	shl    $0x2,%eax
  804663:	05 84 f0 81 00       	add    $0x81f084,%eax
  804668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80466e:	a1 74 f0 81 00       	mov    0x81f074,%eax
  804673:	40                   	inc    %eax
  804674:	a3 74 f0 81 00       	mov    %eax,0x81f074
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_REMOVE(&freePagesList, &pageBlockInfoArr[i]); // ensure clean
	}

	// Fill freePagesList with all pages in correct order
	for (int i = (DYN_ALLOC_MAX_SIZE / PAGE_SIZE) - 1; i >= 0; --i)
  804679:	ff 4d ec             	decl   -0x14(%ebp)
  80467c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804680:	0f 89 59 ff ff ff    	jns    8045df <initialize_dynamic_allocator+0x1dc>
	{
		LIST_INSERT_HEAD(&freePagesList, &pageBlockInfoArr[i]);
	}

	is_initialized = 1;
  804686:	c7 05 44 f0 81 00 01 	movl   $0x1,0x81f044
  80468d:	00 00 00 
}
  804690:	90                   	nop
  804691:	c9                   	leave  
  804692:	c3                   	ret    

00804693 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  804693:	55                   	push   %ebp
  804694:	89 e5                	mov    %esp,%ebp
  804696:	83 ec 18             	sub    $0x18,%esp
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  804699:	8b 45 08             	mov    0x8(%ebp),%eax
  80469c:	83 ec 0c             	sub    $0xc,%esp
  80469f:	50                   	push   %eax
  8046a0:	e8 10 fd ff ff       	call   8043b5 <to_page_info>
  8046a5:	83 c4 10             	add    $0x10,%esp
  8046a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return pageInfo->block_size;
  8046ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046ae:	8b 40 08             	mov    0x8(%eax),%eax
  8046b1:	0f b7 c0             	movzwl %ax,%eax
}
  8046b4:	c9                   	leave  
  8046b5:	c3                   	ret    

008046b6 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8046b6:	55                   	push   %ebp
  8046b7:	89 e5                	mov    %esp,%ebp
  8046b9:	83 ec 38             	sub    $0x38,%esp
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8046bc:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8046c3:	76 16                	jbe    8046db <alloc_block+0x25>
  8046c5:	68 10 60 80 00       	push   $0x806010
  8046ca:	68 fa 5f 80 00       	push   $0x805ffa
  8046cf:	6a 59                	push   $0x59
  8046d1:	68 97 5f 80 00       	push   $0x805f97
  8046d6:	e8 9c ca ff ff       	call   801177 <_panic>

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
  8046db:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8046e2:	eb 08                	jmp    8046ec <alloc_block+0x36>
		allocSize <<= 1;
  8046e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046e7:	01 c0                	add    %eax,%eax
  8046e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
	assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);

	// Round size up to next power-of-two
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
  8046ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8046f2:	73 09                	jae    8046fd <alloc_block+0x47>
  8046f4:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  8046fb:	76 e7                	jbe    8046e4 <alloc_block+0x2e>
		allocSize <<= 1;

	int listIndex = 0;
  8046fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  804704:	eb 03                	jmp    804709 <alloc_block+0x53>
		listIndex++;
  804706:	ff 45 f0             	incl   -0x10(%ebp)
	uint32 allocSize = DYN_ALLOC_MIN_BLOCK_SIZE;
	while (allocSize < size && allocSize < DYN_ALLOC_MAX_BLOCK_SIZE)
		allocSize <<= 1;

	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
  804709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80470c:	ba 08 00 00 00       	mov    $0x8,%edx
  804711:	88 c1                	mov    %al,%cl
  804713:	d3 e2                	shl    %cl,%edx
  804715:	89 d0                	mov    %edx,%eax
  804717:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80471a:	72 ea                	jb     804706 <alloc_block+0x50>
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  80471c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80471f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804722:	e9 f4 00 00 00       	jmp    80481b <alloc_block+0x165>
	{
		if (!LIST_EMPTY(&freeBlockLists[i]))
  804727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80472a:	c1 e0 04             	shl    $0x4,%eax
  80472d:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804732:	8b 00                	mov    (%eax),%eax
  804734:	85 c0                	test   %eax,%eax
  804736:	0f 84 dc 00 00 00    	je     804818 <alloc_block+0x162>
		{
			// Take the first block
			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  80473c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80473f:	c1 e0 04             	shl    $0x4,%eax
  804742:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804747:	8b 00                	mov    (%eax),%eax
  804749:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freeBlockLists[i], block);
  80474c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804750:	75 14                	jne    804766 <alloc_block+0xb0>
  804752:	83 ec 04             	sub    $0x4,%esp
  804755:	68 31 60 80 00       	push   $0x806031
  80475a:	6a 6b                	push   $0x6b
  80475c:	68 97 5f 80 00       	push   $0x805f97
  804761:	e8 11 ca ff ff       	call   801177 <_panic>
  804766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804769:	8b 00                	mov    (%eax),%eax
  80476b:	85 c0                	test   %eax,%eax
  80476d:	74 10                	je     80477f <alloc_block+0xc9>
  80476f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804772:	8b 00                	mov    (%eax),%eax
  804774:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804777:	8b 52 04             	mov    0x4(%edx),%edx
  80477a:	89 50 04             	mov    %edx,0x4(%eax)
  80477d:	eb 14                	jmp    804793 <alloc_block+0xdd>
  80477f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804782:	8b 40 04             	mov    0x4(%eax),%eax
  804785:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804788:	c1 e2 04             	shl    $0x4,%edx
  80478b:	81 c2 a4 70 83 00    	add    $0x8370a4,%edx
  804791:	89 02                	mov    %eax,(%edx)
  804793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804796:	8b 40 04             	mov    0x4(%eax),%eax
  804799:	85 c0                	test   %eax,%eax
  80479b:	74 0f                	je     8047ac <alloc_block+0xf6>
  80479d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047a0:	8b 40 04             	mov    0x4(%eax),%eax
  8047a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8047a6:	8b 12                	mov    (%edx),%edx
  8047a8:	89 10                	mov    %edx,(%eax)
  8047aa:	eb 13                	jmp    8047bf <alloc_block+0x109>
  8047ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047af:	8b 00                	mov    (%eax),%eax
  8047b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8047b4:	c1 e2 04             	shl    $0x4,%edx
  8047b7:	81 c2 a0 70 83 00    	add    $0x8370a0,%edx
  8047bd:	89 02                	mov    %eax,(%edx)
  8047bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8047d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047d5:	c1 e0 04             	shl    $0x4,%eax
  8047d8:	05 ac 70 83 00       	add    $0x8370ac,%eax
  8047dd:	8b 00                	mov    (%eax),%eax
  8047df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8047e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8047e5:	c1 e0 04             	shl    $0x4,%eax
  8047e8:	05 ac 70 83 00       	add    $0x8370ac,%eax
  8047ed:	89 10                	mov    %edx,(%eax)

			// Update page info
			struct PageInfoElement *pageInfo = to_page_info((uint32)block);
  8047ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047f2:	83 ec 0c             	sub    $0xc,%esp
  8047f5:	50                   	push   %eax
  8047f6:	e8 ba fb ff ff       	call   8043b5 <to_page_info>
  8047fb:	83 c4 10             	add    $0x10,%esp
  8047fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			pageInfo->num_of_free_blocks--;
  804801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804804:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804808:	48                   	dec    %eax
  804809:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80480c:	66 89 42 0a          	mov    %ax,0xa(%edx)

			return block;
  804810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804813:	e9 8f 02 00 00       	jmp    804aa7 <alloc_block+0x3f1>
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < allocSize)
		listIndex++;

	// Search for a free block in the corresponding list or bigger
	for (int i = listIndex; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++)
  804818:	ff 45 ec             	incl   -0x14(%ebp)
  80481b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80481f:	0f 8e 02 ff ff ff    	jle    804727 <alloc_block+0x71>
			return block;
		}
	}

	// No block found → allocate a new page
	if (LIST_EMPTY(&freePagesList))
  804825:	a1 68 f0 81 00       	mov    0x81f068,%eax
  80482a:	85 c0                	test   %eax,%eax
  80482c:	75 14                	jne    804842 <alloc_block+0x18c>
		panic("alloc_block(): no free pages available");
  80482e:	83 ec 04             	sub    $0x4,%esp
  804831:	68 50 60 80 00       	push   $0x806050
  804836:	6a 77                	push   $0x77
  804838:	68 97 5f 80 00       	push   $0x805f97
  80483d:	e8 35 c9 ff ff       	call   801177 <_panic>

	struct PageInfoElement *newPage = LIST_FIRST(&freePagesList);
  804842:	a1 68 f0 81 00       	mov    0x81f068,%eax
  804847:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&freePagesList, newPage);
  80484a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80484e:	75 14                	jne    804864 <alloc_block+0x1ae>
  804850:	83 ec 04             	sub    $0x4,%esp
  804853:	68 31 60 80 00       	push   $0x806031
  804858:	6a 7a                	push   $0x7a
  80485a:	68 97 5f 80 00       	push   $0x805f97
  80485f:	e8 13 c9 ff ff       	call   801177 <_panic>
  804864:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804867:	8b 00                	mov    (%eax),%eax
  804869:	85 c0                	test   %eax,%eax
  80486b:	74 10                	je     80487d <alloc_block+0x1c7>
  80486d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804870:	8b 00                	mov    (%eax),%eax
  804872:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804875:	8b 52 04             	mov    0x4(%edx),%edx
  804878:	89 50 04             	mov    %edx,0x4(%eax)
  80487b:	eb 0b                	jmp    804888 <alloc_block+0x1d2>
  80487d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804880:	8b 40 04             	mov    0x4(%eax),%eax
  804883:	a3 6c f0 81 00       	mov    %eax,0x81f06c
  804888:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80488b:	8b 40 04             	mov    0x4(%eax),%eax
  80488e:	85 c0                	test   %eax,%eax
  804890:	74 0f                	je     8048a1 <alloc_block+0x1eb>
  804892:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804895:	8b 40 04             	mov    0x4(%eax),%eax
  804898:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80489b:	8b 12                	mov    (%edx),%edx
  80489d:	89 10                	mov    %edx,(%eax)
  80489f:	eb 0a                	jmp    8048ab <alloc_block+0x1f5>
  8048a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8048a4:	8b 00                	mov    (%eax),%eax
  8048a6:	a3 68 f0 81 00       	mov    %eax,0x81f068
  8048ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8048ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8048b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8048b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8048be:	a1 74 f0 81 00       	mov    0x81f074,%eax
  8048c3:	48                   	dec    %eax
  8048c4:	a3 74 f0 81 00       	mov    %eax,0x81f074

	// Allocate the page via kernel page allocator
	uint32 pageVA = to_page_va(newPage);
  8048c9:	83 ec 0c             	sub    $0xc,%esp
  8048cc:	ff 75 dc             	pushl  -0x24(%ebp)
  8048cf:	e8 6f fa ff ff       	call   804343 <to_page_va>
  8048d4:	83 c4 10             	add    $0x10,%esp
  8048d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if (get_page((void*)pageVA) != 0)
  8048da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8048dd:	83 ec 0c             	sub    $0xc,%esp
  8048e0:	50                   	push   %eax
  8048e1:	e8 a0 dc ff ff       	call   802586 <get_page>
  8048e6:	83 c4 10             	add    $0x10,%esp
  8048e9:	85 c0                	test   %eax,%eax
  8048eb:	74 14                	je     804901 <alloc_block+0x24b>
		panic("alloc_block(): failed to allocate page");
  8048ed:	83 ec 04             	sub    $0x4,%esp
  8048f0:	68 78 60 80 00       	push   $0x806078
  8048f5:	6a 7f                	push   $0x7f
  8048f7:	68 97 5f 80 00       	push   $0x805f97
  8048fc:	e8 76 c8 ff ff       	call   801177 <_panic>

	// Initialize the page blocks
	newPage->block_size = allocSize;
  804901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804904:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804907:	66 89 42 08          	mov    %ax,0x8(%edx)
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;
  80490b:	b8 00 10 00 00       	mov    $0x1000,%eax
  804910:	ba 00 00 00 00       	mov    $0x0,%edx
  804915:	f7 75 f4             	divl   -0xc(%ebp)
  804918:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80491b:	66 89 42 0a          	mov    %ax,0xa(%edx)

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  80491f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  804926:	e9 a7 00 00 00       	jmp    8049d2 <alloc_block+0x31c>
	{
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
  80492b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80492e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804931:	01 d0                	add    %edx,%eax
  804933:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
  804936:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80493a:	75 17                	jne    804953 <alloc_block+0x29d>
  80493c:	83 ec 04             	sub    $0x4,%esp
  80493f:	68 a0 60 80 00       	push   $0x8060a0
  804944:	68 88 00 00 00       	push   $0x88
  804949:	68 97 5f 80 00       	push   $0x805f97
  80494e:	e8 24 c8 ff ff       	call   801177 <_panic>
  804953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804956:	c1 e0 04             	shl    $0x4,%eax
  804959:	05 a0 70 83 00       	add    $0x8370a0,%eax
  80495e:	8b 10                	mov    (%eax),%edx
  804960:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804963:	89 10                	mov    %edx,(%eax)
  804965:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804968:	8b 00                	mov    (%eax),%eax
  80496a:	85 c0                	test   %eax,%eax
  80496c:	74 15                	je     804983 <alloc_block+0x2cd>
  80496e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804971:	c1 e0 04             	shl    $0x4,%eax
  804974:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804979:	8b 00                	mov    (%eax),%eax
  80497b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80497e:	89 50 04             	mov    %edx,0x4(%eax)
  804981:	eb 11                	jmp    804994 <alloc_block+0x2de>
  804983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804986:	c1 e0 04             	shl    $0x4,%eax
  804989:	8d 90 a4 70 83 00    	lea    0x8370a4(%eax),%edx
  80498f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804992:	89 02                	mov    %eax,(%edx)
  804994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804997:	c1 e0 04             	shl    $0x4,%eax
  80499a:	8d 90 a0 70 83 00    	lea    0x8370a0(%eax),%edx
  8049a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049a3:	89 02                	mov    %eax,(%edx)
  8049a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8049af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049b2:	c1 e0 04             	shl    $0x4,%eax
  8049b5:	05 ac 70 83 00       	add    $0x8370ac,%eax
  8049ba:	8b 00                	mov    (%eax),%eax
  8049bc:	8d 50 01             	lea    0x1(%eax),%edx
  8049bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049c2:	c1 e0 04             	shl    $0x4,%eax
  8049c5:	05 ac 70 83 00       	add    $0x8370ac,%eax
  8049ca:	89 10                	mov    %edx,(%eax)

	// Initialize the page blocks
	newPage->block_size = allocSize;
	newPage->num_of_free_blocks = PAGE_SIZE / allocSize;

	for (uint32 offset = 0; offset < PAGE_SIZE; offset += allocSize)
  8049cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8049cf:	01 45 e8             	add    %eax,-0x18(%ebp)
  8049d2:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
  8049d9:	0f 86 4c ff ff ff    	jbe    80492b <alloc_block+0x275>
		struct BlockElement *b = (struct BlockElement*)(pageVA + offset);
		LIST_INSERT_HEAD(&freeBlockLists[listIndex], b);
	}

	// Now take one block from the list
	struct BlockElement *block = LIST_FIRST(&freeBlockLists[listIndex]);
  8049df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049e2:	c1 e0 04             	shl    $0x4,%eax
  8049e5:	05 a0 70 83 00       	add    $0x8370a0,%eax
  8049ea:	8b 00                	mov    (%eax),%eax
  8049ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
	LIST_REMOVE(&freeBlockLists[listIndex], block);
  8049ef:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8049f3:	75 17                	jne    804a0c <alloc_block+0x356>
  8049f5:	83 ec 04             	sub    $0x4,%esp
  8049f8:	68 31 60 80 00       	push   $0x806031
  8049fd:	68 8d 00 00 00       	push   $0x8d
  804a02:	68 97 5f 80 00       	push   $0x805f97
  804a07:	e8 6b c7 ff ff       	call   801177 <_panic>
  804a0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804a0f:	8b 00                	mov    (%eax),%eax
  804a11:	85 c0                	test   %eax,%eax
  804a13:	74 10                	je     804a25 <alloc_block+0x36f>
  804a15:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804a18:	8b 00                	mov    (%eax),%eax
  804a1a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804a1d:	8b 52 04             	mov    0x4(%edx),%edx
  804a20:	89 50 04             	mov    %edx,0x4(%eax)
  804a23:	eb 14                	jmp    804a39 <alloc_block+0x383>
  804a25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804a28:	8b 40 04             	mov    0x4(%eax),%eax
  804a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804a2e:	c1 e2 04             	shl    $0x4,%edx
  804a31:	81 c2 a4 70 83 00    	add    $0x8370a4,%edx
  804a37:	89 02                	mov    %eax,(%edx)
  804a39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804a3c:	8b 40 04             	mov    0x4(%eax),%eax
  804a3f:	85 c0                	test   %eax,%eax
  804a41:	74 0f                	je     804a52 <alloc_block+0x39c>
  804a43:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804a46:	8b 40 04             	mov    0x4(%eax),%eax
  804a49:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804a4c:	8b 12                	mov    (%edx),%edx
  804a4e:	89 10                	mov    %edx,(%eax)
  804a50:	eb 13                	jmp    804a65 <alloc_block+0x3af>
  804a52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804a55:	8b 00                	mov    (%eax),%eax
  804a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804a5a:	c1 e2 04             	shl    $0x4,%edx
  804a5d:	81 c2 a0 70 83 00    	add    $0x8370a0,%edx
  804a63:	89 02                	mov    %eax,(%edx)
  804a65:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804a71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804a7b:	c1 e0 04             	shl    $0x4,%eax
  804a7e:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804a83:	8b 00                	mov    (%eax),%eax
  804a85:	8d 50 ff             	lea    -0x1(%eax),%edx
  804a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804a8b:	c1 e0 04             	shl    $0x4,%eax
  804a8e:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804a93:	89 10                	mov    %edx,(%eax)
	newPage->num_of_free_blocks--;
  804a95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804a98:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804a9c:	48                   	dec    %eax
  804a9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804aa0:	66 89 42 0a          	mov    %ax,0xa(%edx)

	return block;
  804aa4:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  804aa7:	c9                   	leave  
  804aa8:	c3                   	ret    

00804aa9 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804aa9:	55                   	push   %ebp
  804aaa:	89 e5                	mov    %esp,%ebp
  804aac:	83 ec 28             	sub    $0x28,%esp
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804aaf:	8b 55 08             	mov    0x8(%ebp),%edx
  804ab2:	a1 84 70 83 00       	mov    0x837084,%eax
  804ab7:	39 c2                	cmp    %eax,%edx
  804ab9:	72 0c                	jb     804ac7 <free_block+0x1e>
  804abb:	8b 55 08             	mov    0x8(%ebp),%edx
  804abe:	a1 60 f0 81 00       	mov    0x81f060,%eax
  804ac3:	39 c2                	cmp    %eax,%edx
  804ac5:	72 19                	jb     804ae0 <free_block+0x37>
  804ac7:	68 c4 60 80 00       	push   $0x8060c4
  804acc:	68 fa 5f 80 00       	push   $0x805ffa
  804ad1:	68 98 00 00 00       	push   $0x98
  804ad6:	68 97 5f 80 00       	push   $0x805f97
  804adb:	e8 97 c6 ff ff       	call   801177 <_panic>

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  804ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  804ae3:	83 ec 0c             	sub    $0xc,%esp
  804ae6:	50                   	push   %eax
  804ae7:	e8 c9 f8 ff ff       	call   8043b5 <to_page_info>
  804aec:	83 c4 10             	add    $0x10,%esp
  804aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 blockSize = pageInfo->block_size;
  804af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804af5:	8b 40 08             	mov    0x8(%eax),%eax
  804af8:	0f b7 c0             	movzwl %ax,%eax
  804afb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int listIndex = 0;
  804afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804b05:	eb 03                	jmp    804b0a <free_block+0x61>
		listIndex++;
  804b07:	ff 45 f4             	incl   -0xc(%ebp)
	assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);

	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blockSize = pageInfo->block_size;
	int listIndex = 0;
	while ((DYN_ALLOC_MIN_BLOCK_SIZE << listIndex) < blockSize)
  804b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b0d:	ba 08 00 00 00       	mov    $0x8,%edx
  804b12:	88 c1                	mov    %al,%cl
  804b14:	d3 e2                	shl    %cl,%edx
  804b16:	89 d0                	mov    %edx,%eax
  804b18:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804b1b:	72 ea                	jb     804b07 <free_block+0x5e>
		listIndex++;

	// Return block to its free list
	struct BlockElement *block = (struct BlockElement*)va;
  804b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  804b20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_HEAD(&freeBlockLists[listIndex], block);
  804b23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804b27:	75 17                	jne    804b40 <free_block+0x97>
  804b29:	83 ec 04             	sub    $0x4,%esp
  804b2c:	68 a0 60 80 00       	push   $0x8060a0
  804b31:	68 a2 00 00 00       	push   $0xa2
  804b36:	68 97 5f 80 00       	push   $0x805f97
  804b3b:	e8 37 c6 ff ff       	call   801177 <_panic>
  804b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b43:	c1 e0 04             	shl    $0x4,%eax
  804b46:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804b4b:	8b 10                	mov    (%eax),%edx
  804b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b50:	89 10                	mov    %edx,(%eax)
  804b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b55:	8b 00                	mov    (%eax),%eax
  804b57:	85 c0                	test   %eax,%eax
  804b59:	74 15                	je     804b70 <free_block+0xc7>
  804b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b5e:	c1 e0 04             	shl    $0x4,%eax
  804b61:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804b66:	8b 00                	mov    (%eax),%eax
  804b68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b6b:	89 50 04             	mov    %edx,0x4(%eax)
  804b6e:	eb 11                	jmp    804b81 <free_block+0xd8>
  804b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b73:	c1 e0 04             	shl    $0x4,%eax
  804b76:	8d 90 a4 70 83 00    	lea    0x8370a4(%eax),%edx
  804b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b7f:	89 02                	mov    %eax,(%edx)
  804b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b84:	c1 e0 04             	shl    $0x4,%eax
  804b87:	8d 90 a0 70 83 00    	lea    0x8370a0(%eax),%edx
  804b8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b90:	89 02                	mov    %eax,(%edx)
  804b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b9f:	c1 e0 04             	shl    $0x4,%eax
  804ba2:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804ba7:	8b 00                	mov    (%eax),%eax
  804ba9:	8d 50 01             	lea    0x1(%eax),%edx
  804bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804baf:	c1 e0 04             	shl    $0x4,%eax
  804bb2:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804bb7:	89 10                	mov    %edx,(%eax)
	pageInfo->num_of_free_blocks++;
  804bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804bbc:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804bc0:	40                   	inc    %eax
  804bc1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804bc4:	66 89 42 0a          	mov    %ax,0xa(%edx)

	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
  804bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804bcb:	66 8b 40 0a          	mov    0xa(%eax),%ax
  804bcf:	0f b7 c8             	movzwl %ax,%ecx
  804bd2:	b8 00 10 00 00       	mov    $0x1000,%eax
  804bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  804bdc:	f7 75 e8             	divl   -0x18(%ebp)
  804bdf:	39 c1                	cmp    %eax,%ecx
  804be1:	0f 85 ed 01 00 00    	jne    804dd4 <free_block+0x32b>
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804bea:	c1 e0 04             	shl    $0x4,%eax
  804bed:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804bf2:	8b 00                	mov    (%eax),%eax
  804bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804bf7:	eb 2a                	jmp    804c23 <free_block+0x17a>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
  804bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804bfc:	83 ec 0c             	sub    $0xc,%esp
  804bff:	50                   	push   %eax
  804c00:	e8 b0 f7 ff ff       	call   8043b5 <to_page_info>
  804c05:	83 c4 10             	add    $0x10,%esp
  804c08:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804c0b:	75 06                	jne    804c13 <free_block+0x16a>
				tmp = b;
  804c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c10:	89 45 e0             	mov    %eax,-0x20(%ebp)
	// If page is fully free, return page to freePagesList
	if (pageInfo->num_of_free_blocks == PAGE_SIZE / blockSize)
	{
		// Remove all blocks from free list
		struct BlockElement *b, *tmp;
		LIST_FOREACH(b, &freeBlockLists[listIndex])
  804c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c16:	c1 e0 04             	shl    $0x4,%eax
  804c19:	05 a8 70 83 00       	add    $0x8370a8,%eax
  804c1e:	8b 00                	mov    (%eax),%eax
  804c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804c23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804c27:	74 07                	je     804c30 <free_block+0x187>
  804c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c2c:	8b 00                	mov    (%eax),%eax
  804c2e:	eb 05                	jmp    804c35 <free_block+0x18c>
  804c30:	b8 00 00 00 00       	mov    $0x0,%eax
  804c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804c38:	c1 e2 04             	shl    $0x4,%edx
  804c3b:	81 c2 a8 70 83 00    	add    $0x8370a8,%edx
  804c41:	89 02                	mov    %eax,(%edx)
  804c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c46:	c1 e0 04             	shl    $0x4,%eax
  804c49:	05 a8 70 83 00       	add    $0x8370a8,%eax
  804c4e:	8b 00                	mov    (%eax),%eax
  804c50:	85 c0                	test   %eax,%eax
  804c52:	75 a5                	jne    804bf9 <free_block+0x150>
  804c54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804c58:	75 9f                	jne    804bf9 <free_block+0x150>
		{
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
  804c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804c5d:	c1 e0 04             	shl    $0x4,%eax
  804c60:	05 a0 70 83 00       	add    $0x8370a0,%eax
  804c65:	8b 00                	mov    (%eax),%eax
  804c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (b)
  804c6a:	e9 cc 00 00 00       	jmp    804d3b <free_block+0x292>
		{
			struct BlockElement *next = LIST_NEXT(b);
  804c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c72:	8b 00                	mov    (%eax),%eax
  804c74:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (to_page_info((uint32)b) == pageInfo)
  804c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804c7a:	83 ec 0c             	sub    $0xc,%esp
  804c7d:	50                   	push   %eax
  804c7e:	e8 32 f7 ff ff       	call   8043b5 <to_page_info>
  804c83:	83 c4 10             	add    $0x10,%esp
  804c86:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  804c89:	0f 85 a6 00 00 00    	jne    804d35 <free_block+0x28c>
				LIST_REMOVE(&freeBlockLists[listIndex], b);
  804c8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804c93:	75 17                	jne    804cac <free_block+0x203>
  804c95:	83 ec 04             	sub    $0x4,%esp
  804c98:	68 31 60 80 00       	push   $0x806031
  804c9d:	68 b5 00 00 00       	push   $0xb5
  804ca2:	68 97 5f 80 00       	push   $0x805f97
  804ca7:	e8 cb c4 ff ff       	call   801177 <_panic>
  804cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804caf:	8b 00                	mov    (%eax),%eax
  804cb1:	85 c0                	test   %eax,%eax
  804cb3:	74 10                	je     804cc5 <free_block+0x21c>
  804cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804cb8:	8b 00                	mov    (%eax),%eax
  804cba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804cbd:	8b 52 04             	mov    0x4(%edx),%edx
  804cc0:	89 50 04             	mov    %edx,0x4(%eax)
  804cc3:	eb 14                	jmp    804cd9 <free_block+0x230>
  804cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804cc8:	8b 40 04             	mov    0x4(%eax),%eax
  804ccb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804cce:	c1 e2 04             	shl    $0x4,%edx
  804cd1:	81 c2 a4 70 83 00    	add    $0x8370a4,%edx
  804cd7:	89 02                	mov    %eax,(%edx)
  804cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804cdc:	8b 40 04             	mov    0x4(%eax),%eax
  804cdf:	85 c0                	test   %eax,%eax
  804ce1:	74 0f                	je     804cf2 <free_block+0x249>
  804ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804ce6:	8b 40 04             	mov    0x4(%eax),%eax
  804ce9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804cec:	8b 12                	mov    (%edx),%edx
  804cee:	89 10                	mov    %edx,(%eax)
  804cf0:	eb 13                	jmp    804d05 <free_block+0x25c>
  804cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804cf5:	8b 00                	mov    (%eax),%eax
  804cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804cfa:	c1 e2 04             	shl    $0x4,%edx
  804cfd:	81 c2 a0 70 83 00    	add    $0x8370a0,%edx
  804d03:	89 02                	mov    %eax,(%edx)
  804d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804d08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804d11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d1b:	c1 e0 04             	shl    $0x4,%eax
  804d1e:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804d23:	8b 00                	mov    (%eax),%eax
  804d25:	8d 50 ff             	lea    -0x1(%eax),%edx
  804d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d2b:	c1 e0 04             	shl    $0x4,%eax
  804d2e:	05 ac 70 83 00       	add    $0x8370ac,%eax
  804d33:	89 10                	mov    %edx,(%eax)
			b = next;
  804d35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if ((to_page_info((uint32)b)) == pageInfo)
				tmp = b;
		}
		// Actually remove blocks of this page from the freeBlockList
		b = LIST_FIRST(&freeBlockLists[listIndex]);
		while (b)
  804d3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804d3f:	0f 85 2a ff ff ff    	jne    804c6f <free_block+0x1c6>
			if (to_page_info((uint32)b) == pageInfo)
				LIST_REMOVE(&freeBlockLists[listIndex], b);
			b = next;
		}

		pageInfo->block_size = 0;
  804d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d48:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  804d4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d51:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)

		LIST_INSERT_HEAD(&freePagesList, pageInfo);
  804d57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804d5b:	75 17                	jne    804d74 <free_block+0x2cb>
  804d5d:	83 ec 04             	sub    $0x4,%esp
  804d60:	68 a0 60 80 00       	push   $0x8060a0
  804d65:	68 bc 00 00 00       	push   $0xbc
  804d6a:	68 97 5f 80 00       	push   $0x805f97
  804d6f:	e8 03 c4 ff ff       	call   801177 <_panic>
  804d74:	8b 15 68 f0 81 00    	mov    0x81f068,%edx
  804d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d7d:	89 10                	mov    %edx,(%eax)
  804d7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d82:	8b 00                	mov    (%eax),%eax
  804d84:	85 c0                	test   %eax,%eax
  804d86:	74 0d                	je     804d95 <free_block+0x2ec>
  804d88:	a1 68 f0 81 00       	mov    0x81f068,%eax
  804d8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804d90:	89 50 04             	mov    %edx,0x4(%eax)
  804d93:	eb 08                	jmp    804d9d <free_block+0x2f4>
  804d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804d98:	a3 6c f0 81 00       	mov    %eax,0x81f06c
  804d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804da0:	a3 68 f0 81 00       	mov    %eax,0x81f068
  804da5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804da8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804daf:	a1 74 f0 81 00       	mov    0x81f074,%eax
  804db4:	40                   	inc    %eax
  804db5:	a3 74 f0 81 00       	mov    %eax,0x81f074

		// Return page to kernel
		return_page((void*)to_page_va(pageInfo));
  804dba:	83 ec 0c             	sub    $0xc,%esp
  804dbd:	ff 75 ec             	pushl  -0x14(%ebp)
  804dc0:	e8 7e f5 ff ff       	call   804343 <to_page_va>
  804dc5:	83 c4 10             	add    $0x10,%esp
  804dc8:	83 ec 0c             	sub    $0xc,%esp
  804dcb:	50                   	push   %eax
  804dcc:	e8 fe d7 ff ff       	call   8025cf <return_page>
  804dd1:	83 c4 10             	add    $0x10,%esp
	}
}
  804dd4:	90                   	nop
  804dd5:	c9                   	leave  
  804dd6:	c3                   	ret    

00804dd7 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  804dd7:	55                   	push   %ebp
  804dd8:	89 e5                	mov    %esp,%ebp
  804dda:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  804ddd:	83 ec 04             	sub    $0x4,%esp
  804de0:	68 fc 60 80 00       	push   $0x8060fc
  804de5:	6a 07                	push   $0x7
  804de7:	68 2b 61 80 00       	push   $0x80612b
  804dec:	e8 86 c3 ff ff       	call   801177 <_panic>

00804df1 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  804df1:	55                   	push   %ebp
  804df2:	89 e5                	mov    %esp,%ebp
  804df4:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  804df7:	83 ec 04             	sub    $0x4,%esp
  804dfa:	68 3c 61 80 00       	push   $0x80613c
  804dff:	6a 0b                	push   $0xb
  804e01:	68 2b 61 80 00       	push   $0x80612b
  804e06:	e8 6c c3 ff ff       	call   801177 <_panic>

00804e0b <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  804e0b:	55                   	push   %ebp
  804e0c:	89 e5                	mov    %esp,%ebp
  804e0e:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  804e11:	83 ec 04             	sub    $0x4,%esp
  804e14:	68 68 61 80 00       	push   $0x806168
  804e19:	6a 10                	push   $0x10
  804e1b:	68 2b 61 80 00       	push   $0x80612b
  804e20:	e8 52 c3 ff ff       	call   801177 <_panic>

00804e25 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  804e25:	55                   	push   %ebp
  804e26:	89 e5                	mov    %esp,%ebp
  804e28:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  804e2b:	83 ec 04             	sub    $0x4,%esp
  804e2e:	68 98 61 80 00       	push   $0x806198
  804e33:	6a 15                	push   $0x15
  804e35:	68 2b 61 80 00       	push   $0x80612b
  804e3a:	e8 38 c3 ff ff       	call   801177 <_panic>

00804e3f <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  804e3f:	55                   	push   %ebp
  804e40:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804e42:	8b 45 08             	mov    0x8(%ebp),%eax
  804e45:	8b 40 10             	mov    0x10(%eax),%eax
}
  804e48:	5d                   	pop    %ebp
  804e49:	c3                   	ret    

00804e4a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804e4a:	55                   	push   %ebp
  804e4b:	89 e5                	mov    %esp,%ebp
  804e4d:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804e50:	8b 55 08             	mov    0x8(%ebp),%edx
  804e53:	89 d0                	mov    %edx,%eax
  804e55:	c1 e0 02             	shl    $0x2,%eax
  804e58:	01 d0                	add    %edx,%eax
  804e5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804e61:	01 d0                	add    %edx,%eax
  804e63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804e6a:	01 d0                	add    %edx,%eax
  804e6c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804e73:	01 d0                	add    %edx,%eax
  804e75:	c1 e0 04             	shl    $0x4,%eax
  804e78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  804e7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  804e82:	0f 31                	rdtsc  
  804e84:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804e87:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804e8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804e90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804e93:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  804e96:	eb 46                	jmp    804ede <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  804e98:	0f 31                	rdtsc  
  804e9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  804e9d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804ea0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804ea3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804ea6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  804ea9:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804eac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804eb2:	29 c2                	sub    %eax,%edx
  804eb4:	89 d0                	mov    %edx,%eax
  804eb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804eb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ebf:	89 d1                	mov    %edx,%ecx
  804ec1:	29 c1                	sub    %eax,%ecx
  804ec3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804ec9:	39 c2                	cmp    %eax,%edx
  804ecb:	0f 97 c0             	seta   %al
  804ece:	0f b6 c0             	movzbl %al,%eax
  804ed1:	29 c1                	sub    %eax,%ecx
  804ed3:	89 c8                	mov    %ecx,%eax
  804ed5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804ed8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  804ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804ee1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804ee4:	72 b2                	jb     804e98 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804ee6:	90                   	nop
  804ee7:	c9                   	leave  
  804ee8:	c3                   	ret    

00804ee9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804ee9:	55                   	push   %ebp
  804eea:	89 e5                	mov    %esp,%ebp
  804eec:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804eef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804ef6:	eb 03                	jmp    804efb <busy_wait+0x12>
  804ef8:	ff 45 fc             	incl   -0x4(%ebp)
  804efb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804efe:	3b 45 08             	cmp    0x8(%ebp),%eax
  804f01:	72 f5                	jb     804ef8 <busy_wait+0xf>
	return i;
  804f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804f06:	c9                   	leave  
  804f07:	c3                   	ret    

00804f08 <__udivdi3>:
  804f08:	55                   	push   %ebp
  804f09:	57                   	push   %edi
  804f0a:	56                   	push   %esi
  804f0b:	53                   	push   %ebx
  804f0c:	83 ec 1c             	sub    $0x1c,%esp
  804f0f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804f13:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804f17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804f1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804f1f:	89 ca                	mov    %ecx,%edx
  804f21:	89 f8                	mov    %edi,%eax
  804f23:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804f27:	85 f6                	test   %esi,%esi
  804f29:	75 2d                	jne    804f58 <__udivdi3+0x50>
  804f2b:	39 cf                	cmp    %ecx,%edi
  804f2d:	77 65                	ja     804f94 <__udivdi3+0x8c>
  804f2f:	89 fd                	mov    %edi,%ebp
  804f31:	85 ff                	test   %edi,%edi
  804f33:	75 0b                	jne    804f40 <__udivdi3+0x38>
  804f35:	b8 01 00 00 00       	mov    $0x1,%eax
  804f3a:	31 d2                	xor    %edx,%edx
  804f3c:	f7 f7                	div    %edi
  804f3e:	89 c5                	mov    %eax,%ebp
  804f40:	31 d2                	xor    %edx,%edx
  804f42:	89 c8                	mov    %ecx,%eax
  804f44:	f7 f5                	div    %ebp
  804f46:	89 c1                	mov    %eax,%ecx
  804f48:	89 d8                	mov    %ebx,%eax
  804f4a:	f7 f5                	div    %ebp
  804f4c:	89 cf                	mov    %ecx,%edi
  804f4e:	89 fa                	mov    %edi,%edx
  804f50:	83 c4 1c             	add    $0x1c,%esp
  804f53:	5b                   	pop    %ebx
  804f54:	5e                   	pop    %esi
  804f55:	5f                   	pop    %edi
  804f56:	5d                   	pop    %ebp
  804f57:	c3                   	ret    
  804f58:	39 ce                	cmp    %ecx,%esi
  804f5a:	77 28                	ja     804f84 <__udivdi3+0x7c>
  804f5c:	0f bd fe             	bsr    %esi,%edi
  804f5f:	83 f7 1f             	xor    $0x1f,%edi
  804f62:	75 40                	jne    804fa4 <__udivdi3+0x9c>
  804f64:	39 ce                	cmp    %ecx,%esi
  804f66:	72 0a                	jb     804f72 <__udivdi3+0x6a>
  804f68:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804f6c:	0f 87 9e 00 00 00    	ja     805010 <__udivdi3+0x108>
  804f72:	b8 01 00 00 00       	mov    $0x1,%eax
  804f77:	89 fa                	mov    %edi,%edx
  804f79:	83 c4 1c             	add    $0x1c,%esp
  804f7c:	5b                   	pop    %ebx
  804f7d:	5e                   	pop    %esi
  804f7e:	5f                   	pop    %edi
  804f7f:	5d                   	pop    %ebp
  804f80:	c3                   	ret    
  804f81:	8d 76 00             	lea    0x0(%esi),%esi
  804f84:	31 ff                	xor    %edi,%edi
  804f86:	31 c0                	xor    %eax,%eax
  804f88:	89 fa                	mov    %edi,%edx
  804f8a:	83 c4 1c             	add    $0x1c,%esp
  804f8d:	5b                   	pop    %ebx
  804f8e:	5e                   	pop    %esi
  804f8f:	5f                   	pop    %edi
  804f90:	5d                   	pop    %ebp
  804f91:	c3                   	ret    
  804f92:	66 90                	xchg   %ax,%ax
  804f94:	89 d8                	mov    %ebx,%eax
  804f96:	f7 f7                	div    %edi
  804f98:	31 ff                	xor    %edi,%edi
  804f9a:	89 fa                	mov    %edi,%edx
  804f9c:	83 c4 1c             	add    $0x1c,%esp
  804f9f:	5b                   	pop    %ebx
  804fa0:	5e                   	pop    %esi
  804fa1:	5f                   	pop    %edi
  804fa2:	5d                   	pop    %ebp
  804fa3:	c3                   	ret    
  804fa4:	bd 20 00 00 00       	mov    $0x20,%ebp
  804fa9:	89 eb                	mov    %ebp,%ebx
  804fab:	29 fb                	sub    %edi,%ebx
  804fad:	89 f9                	mov    %edi,%ecx
  804faf:	d3 e6                	shl    %cl,%esi
  804fb1:	89 c5                	mov    %eax,%ebp
  804fb3:	88 d9                	mov    %bl,%cl
  804fb5:	d3 ed                	shr    %cl,%ebp
  804fb7:	89 e9                	mov    %ebp,%ecx
  804fb9:	09 f1                	or     %esi,%ecx
  804fbb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804fbf:	89 f9                	mov    %edi,%ecx
  804fc1:	d3 e0                	shl    %cl,%eax
  804fc3:	89 c5                	mov    %eax,%ebp
  804fc5:	89 d6                	mov    %edx,%esi
  804fc7:	88 d9                	mov    %bl,%cl
  804fc9:	d3 ee                	shr    %cl,%esi
  804fcb:	89 f9                	mov    %edi,%ecx
  804fcd:	d3 e2                	shl    %cl,%edx
  804fcf:	8b 44 24 08          	mov    0x8(%esp),%eax
  804fd3:	88 d9                	mov    %bl,%cl
  804fd5:	d3 e8                	shr    %cl,%eax
  804fd7:	09 c2                	or     %eax,%edx
  804fd9:	89 d0                	mov    %edx,%eax
  804fdb:	89 f2                	mov    %esi,%edx
  804fdd:	f7 74 24 0c          	divl   0xc(%esp)
  804fe1:	89 d6                	mov    %edx,%esi
  804fe3:	89 c3                	mov    %eax,%ebx
  804fe5:	f7 e5                	mul    %ebp
  804fe7:	39 d6                	cmp    %edx,%esi
  804fe9:	72 19                	jb     805004 <__udivdi3+0xfc>
  804feb:	74 0b                	je     804ff8 <__udivdi3+0xf0>
  804fed:	89 d8                	mov    %ebx,%eax
  804fef:	31 ff                	xor    %edi,%edi
  804ff1:	e9 58 ff ff ff       	jmp    804f4e <__udivdi3+0x46>
  804ff6:	66 90                	xchg   %ax,%ax
  804ff8:	8b 54 24 08          	mov    0x8(%esp),%edx
  804ffc:	89 f9                	mov    %edi,%ecx
  804ffe:	d3 e2                	shl    %cl,%edx
  805000:	39 c2                	cmp    %eax,%edx
  805002:	73 e9                	jae    804fed <__udivdi3+0xe5>
  805004:	8d 43 ff             	lea    -0x1(%ebx),%eax
  805007:	31 ff                	xor    %edi,%edi
  805009:	e9 40 ff ff ff       	jmp    804f4e <__udivdi3+0x46>
  80500e:	66 90                	xchg   %ax,%ax
  805010:	31 c0                	xor    %eax,%eax
  805012:	e9 37 ff ff ff       	jmp    804f4e <__udivdi3+0x46>
  805017:	90                   	nop

00805018 <__umoddi3>:
  805018:	55                   	push   %ebp
  805019:	57                   	push   %edi
  80501a:	56                   	push   %esi
  80501b:	53                   	push   %ebx
  80501c:	83 ec 1c             	sub    $0x1c,%esp
  80501f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  805023:	8b 74 24 34          	mov    0x34(%esp),%esi
  805027:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80502b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80502f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  805033:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  805037:	89 f3                	mov    %esi,%ebx
  805039:	89 fa                	mov    %edi,%edx
  80503b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80503f:	89 34 24             	mov    %esi,(%esp)
  805042:	85 c0                	test   %eax,%eax
  805044:	75 1a                	jne    805060 <__umoddi3+0x48>
  805046:	39 f7                	cmp    %esi,%edi
  805048:	0f 86 a2 00 00 00    	jbe    8050f0 <__umoddi3+0xd8>
  80504e:	89 c8                	mov    %ecx,%eax
  805050:	89 f2                	mov    %esi,%edx
  805052:	f7 f7                	div    %edi
  805054:	89 d0                	mov    %edx,%eax
  805056:	31 d2                	xor    %edx,%edx
  805058:	83 c4 1c             	add    $0x1c,%esp
  80505b:	5b                   	pop    %ebx
  80505c:	5e                   	pop    %esi
  80505d:	5f                   	pop    %edi
  80505e:	5d                   	pop    %ebp
  80505f:	c3                   	ret    
  805060:	39 f0                	cmp    %esi,%eax
  805062:	0f 87 ac 00 00 00    	ja     805114 <__umoddi3+0xfc>
  805068:	0f bd e8             	bsr    %eax,%ebp
  80506b:	83 f5 1f             	xor    $0x1f,%ebp
  80506e:	0f 84 ac 00 00 00    	je     805120 <__umoddi3+0x108>
  805074:	bf 20 00 00 00       	mov    $0x20,%edi
  805079:	29 ef                	sub    %ebp,%edi
  80507b:	89 fe                	mov    %edi,%esi
  80507d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  805081:	89 e9                	mov    %ebp,%ecx
  805083:	d3 e0                	shl    %cl,%eax
  805085:	89 d7                	mov    %edx,%edi
  805087:	89 f1                	mov    %esi,%ecx
  805089:	d3 ef                	shr    %cl,%edi
  80508b:	09 c7                	or     %eax,%edi
  80508d:	89 e9                	mov    %ebp,%ecx
  80508f:	d3 e2                	shl    %cl,%edx
  805091:	89 14 24             	mov    %edx,(%esp)
  805094:	89 d8                	mov    %ebx,%eax
  805096:	d3 e0                	shl    %cl,%eax
  805098:	89 c2                	mov    %eax,%edx
  80509a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80509e:	d3 e0                	shl    %cl,%eax
  8050a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8050a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8050a8:	89 f1                	mov    %esi,%ecx
  8050aa:	d3 e8                	shr    %cl,%eax
  8050ac:	09 d0                	or     %edx,%eax
  8050ae:	d3 eb                	shr    %cl,%ebx
  8050b0:	89 da                	mov    %ebx,%edx
  8050b2:	f7 f7                	div    %edi
  8050b4:	89 d3                	mov    %edx,%ebx
  8050b6:	f7 24 24             	mull   (%esp)
  8050b9:	89 c6                	mov    %eax,%esi
  8050bb:	89 d1                	mov    %edx,%ecx
  8050bd:	39 d3                	cmp    %edx,%ebx
  8050bf:	0f 82 87 00 00 00    	jb     80514c <__umoddi3+0x134>
  8050c5:	0f 84 91 00 00 00    	je     80515c <__umoddi3+0x144>
  8050cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8050cf:	29 f2                	sub    %esi,%edx
  8050d1:	19 cb                	sbb    %ecx,%ebx
  8050d3:	89 d8                	mov    %ebx,%eax
  8050d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8050d9:	d3 e0                	shl    %cl,%eax
  8050db:	89 e9                	mov    %ebp,%ecx
  8050dd:	d3 ea                	shr    %cl,%edx
  8050df:	09 d0                	or     %edx,%eax
  8050e1:	89 e9                	mov    %ebp,%ecx
  8050e3:	d3 eb                	shr    %cl,%ebx
  8050e5:	89 da                	mov    %ebx,%edx
  8050e7:	83 c4 1c             	add    $0x1c,%esp
  8050ea:	5b                   	pop    %ebx
  8050eb:	5e                   	pop    %esi
  8050ec:	5f                   	pop    %edi
  8050ed:	5d                   	pop    %ebp
  8050ee:	c3                   	ret    
  8050ef:	90                   	nop
  8050f0:	89 fd                	mov    %edi,%ebp
  8050f2:	85 ff                	test   %edi,%edi
  8050f4:	75 0b                	jne    805101 <__umoddi3+0xe9>
  8050f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8050fb:	31 d2                	xor    %edx,%edx
  8050fd:	f7 f7                	div    %edi
  8050ff:	89 c5                	mov    %eax,%ebp
  805101:	89 f0                	mov    %esi,%eax
  805103:	31 d2                	xor    %edx,%edx
  805105:	f7 f5                	div    %ebp
  805107:	89 c8                	mov    %ecx,%eax
  805109:	f7 f5                	div    %ebp
  80510b:	89 d0                	mov    %edx,%eax
  80510d:	e9 44 ff ff ff       	jmp    805056 <__umoddi3+0x3e>
  805112:	66 90                	xchg   %ax,%ax
  805114:	89 c8                	mov    %ecx,%eax
  805116:	89 f2                	mov    %esi,%edx
  805118:	83 c4 1c             	add    $0x1c,%esp
  80511b:	5b                   	pop    %ebx
  80511c:	5e                   	pop    %esi
  80511d:	5f                   	pop    %edi
  80511e:	5d                   	pop    %ebp
  80511f:	c3                   	ret    
  805120:	3b 04 24             	cmp    (%esp),%eax
  805123:	72 06                	jb     80512b <__umoddi3+0x113>
  805125:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  805129:	77 0f                	ja     80513a <__umoddi3+0x122>
  80512b:	89 f2                	mov    %esi,%edx
  80512d:	29 f9                	sub    %edi,%ecx
  80512f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  805133:	89 14 24             	mov    %edx,(%esp)
  805136:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80513a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80513e:	8b 14 24             	mov    (%esp),%edx
  805141:	83 c4 1c             	add    $0x1c,%esp
  805144:	5b                   	pop    %ebx
  805145:	5e                   	pop    %esi
  805146:	5f                   	pop    %edi
  805147:	5d                   	pop    %ebp
  805148:	c3                   	ret    
  805149:	8d 76 00             	lea    0x0(%esi),%esi
  80514c:	2b 04 24             	sub    (%esp),%eax
  80514f:	19 fa                	sbb    %edi,%edx
  805151:	89 d1                	mov    %edx,%ecx
  805153:	89 c6                	mov    %eax,%esi
  805155:	e9 71 ff ff ff       	jmp    8050cb <__umoddi3+0xb3>
  80515a:	66 90                	xchg   %ax,%ax
  80515c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  805160:	72 ea                	jb     80514c <__umoddi3+0x134>
  805162:	89 d9                	mov    %ebx,%ecx
  805164:	e9 62 ff ff ff       	jmp    8050cb <__umoddi3+0xb3>
