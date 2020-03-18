MODULE Commander;
	IMPORT
		Texts, Oberon, Viewers, TextFrames, Out;
	
	CONST
		(* Whitespace *)
		TAB = 9X;  CR = 0DX; LF = 0AX;
		
		(* Scanner types *)
		params* = 0; selection* = 1; markedviewer* = 2;
		
	TYPE
		Scanner* = RECORD (Texts.Reader)
			nextCh- : CHAR;
			type- : INTEGER;
			line-, beg-, end- : LONGINT;
			s- : ARRAY 256 OF CHAR;
		END;
		
		ScannerProc* = PROCEDURE(s : Scanner);
		
	PROCEDURE InitScanner*(VAR scanner : Scanner; type : INTEGER);
	VAR
		v : Viewers.Viewer;
		f : TextFrames.Frame;
		text : Texts.Text;
		beg, end, time : LONGINT;
		
	BEGIN
		ASSERT((type >= 0) & (type <= 2));
		scanner.type := type;
		scanner.line := 0;
		scanner.s := "";
		IF type = params THEN
			Texts.OpenReader(scanner, Oberon.Par.text, Oberon.Par.pos);
		ELSIF type = markedviewer THEN
			v := Oberon.MarkedViewer();
			IF (v.dsc # NIL) & (v.dsc.next IS TextFrames.Frame) THEN
				f := v.dsc.next(TextFrames.Frame);
				Texts.OpenReader(scanner, f.text, 0);
			END
		ELSIF type =  selection THEN
			Oberon.GetSelection(text, scanner.beg, scanner.end, time);
			IF time > 0 THEN
				Texts.OpenReader(scanner, text, scanner.beg);
				scanner.end := end;
			END;
		END;
	END InitScanner;

	PROCEDURE IsWhitespace*(ch : CHAR):BOOLEAN;
	BEGIN
		RETURN (ch = " ") OR (ch = TAB) OR (ch = LF) OR (ch = CR) OR (ch = 0X);
	END IsWhitespace;
		
	PROCEDURE AtEnd*(scanner : Scanner):BOOLEAN;
	BEGIN
		IF scanner.type = params THEN
			RETURN (scanner.nextCh = "~") OR (scanner.eot);
		ELSIF scanner.type = selection THEN
			RETURN (scanner.beg >= scanner.end) OR (scanner.eot);
		ELSIF scanner.type = markedviewer THEN
			RETURN scanner.eot;
		END; 
	END AtEnd;
	
	PROCEDURE SkipWhitespace*(VAR scanner : Scanner);
	BEGIN
		REPEAT
			Texts.Read(scanner, scanner.nextCh);
			INC(scanner.beg);
		UNTIL ~IsWhitespace(scanner.nextCh) OR AtEnd(scanner);
	END SkipWhitespace;

	PROCEDURE InitGlobalScanner*(VAR scanner : Scanner);
	VAR
		paramscanner : Scanner;
		
	BEGIN
		InitScanner(paramscanner, params);
		SkipWhitespace(paramscanner);
		IF paramscanner.nextCh = "^" THEN
			InitScanner(scanner, selection);			
		ELSIF paramscanner.nextCh = "*" THEN
			InitScanner(scanner, markedviewer);
		ELSE
			InitScanner(scanner, params);
		END;
	END InitGlobalScanner;

	PROCEDURE ScanWhitespace*(VAR scanner : Scanner);
	VAR 
		pos : INTEGER;
		
	BEGIN
		scanner.s := "";
		SkipWhitespace(scanner);
		pos := 0;
		REPEAT
			scanner.s[pos] := scanner.nextCh; INC(pos);
			Texts.Read(scanner, scanner.nextCh);
			INC(scanner.beg);
			IF (scanner.nextCh = CR) OR (scanner.nextCh = LF) THEN INC(scanner.line) END;
		UNTIL IsWhitespace(scanner.nextCh) OR AtEnd(scanner);
	END ScanWhitespace;
END Commander.
