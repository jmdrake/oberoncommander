MODULE ConnectionTask;

IMPORT TCP, Out, Commander, Oberon, Input;

	CONST
		TAB = 9X;  CR = 0DX; LF = 0AX;
	
	VAR
		quiet : BOOLEAN;
		taskrunning : BOOLEAN;
		scannertask : Oberon.Task;
		scanner : Commander.Scanner;
				
	PROCEDURE TestConnection(name : ARRAY OF CHAR);
	VAR
		res : INTEGER;
		adr: TCP.IpAdr;
		
	BEGIN
		TCP.HostByName(name, adr, res);
		IF res = TCP.Done THEN
			IF ~quiet THEN
				Out.String("Alive: "); 
			END;
			Out.String(name); Out.Ln;
		ELSIF (res = TCP.NotDone) & ~quiet THEN
			Out.String("Failed: "); Out.String(name); Out.Ln;
		ELSIF (res = TCP.Timeout) & ~quiet THEN
			Out.String("Timeout: "); Out.String(name); Out.Ln;
		ELSIF ~quiet THEN
			Out.String("Unknown error: "); Out.String(name); Out.Ln;
		END;
	END TestConnection;

	PROCEDURE ProcessItems(scanner : Commander.Scanner);
	BEGIN
		REPEAT
			Commander.ScanWhitespace(scanner);
			TestConnection(scanner.s);
		UNTIL Commander.AtEnd(scanner);
	END ProcessItems;

	PROCEDURE ProcessNextItem;
	BEGIN
		Commander.ScanWhitespace(scanner);
		TestConnection(scanner.s);
		IF Commander.AtEnd(scanner) THEN
			Oberon.Remove(scannertask);
			taskrunning := FALSE;
		ELSE
			scannertask.time := Input.Time() + Input.TimeUnit * 5;
		END;
	END ProcessNextItem;


	PROCEDURE Test*;
	BEGIN
		IF ~taskrunning THEN
	 		Commander.InitGlobalScanner(scanner);
 			scannertask.time := Input.Time() + Input.TimeUnit * 5;
 			Oberon.Install(scannertask);
 		END;
 	END Test;
 	
	PROCEDURE SetOptions*;
	VAR
		scanner : Commander.Scanner;
		
	BEGIN
		Commander.InitGlobalScanner(scanner);
		REPEAT
			Commander.ScanWhitespace(scanner);
			IF scanner.s = "quiet" THEN
				quiet := TRUE;
				Out.String("quiet"); Out.Ln();
			ELSIF scanner.s = "verbose" THEN
				quiet := FALSE;
				Out.String("verbose"); Out.Ln();
			END;
		UNTIL Commander.AtEnd(scanner);
	END SetOptions;
  
BEGIN
 	Out.Open();
 	quiet := FALSE;
 	taskrunning := FALSE;
 	NEW(scannertask);
 	scannertask.safe := TRUE;
 	scannertask.handle := ProcessNextItem;
END ConnectionTask.
