MODULE Connections;

IMPORT TCP, Out, Commander;

	CONST
		TAB = 9X;  CR = 0DX; LF = 0AX;
	
	VAR
		quiet : BOOLEAN;
				
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

	PROCEDURE Test*;
	VAR
		scanner : Commander.Scanner;

 	BEGIN
 		Commander.InitGlobalScanner(scanner);
 		ProcessItems(scanner);
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
 END Connections.
