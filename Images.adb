With Rand, Console, ada.integer_text_io, ada.numerics.elementary_functions;
Use  Rand, Console, ada.integer_text_io, ada.numerics.elementary_functions;

Package body Images is

	Function RandomPix return Pixel is
	begin
		return (Rand.Flt,Rand.Flt,Rand.Flt);
	end RandomPix;

	Procedure Preview (Img: T_Image) is
	begin
		for y in reverse Img'range(1) loop
			for x in Img'range(2) loop
				Put ("  ", integer(Img(y,x).R),
					       integer(Img(y,x).V),
					       integer(Img(y,x).B), 220,220,220);
			end loop;
			NextLine;
		end loop;
	end Preview;

	Procedure Put (File: in out File_type; Pix: Pixel) is
		Pix2: Pixel;
	begin
		Pix2.R := (if Pix.R > 1.0 then 1.0 else Pix.R);
		Pix2.V := (if Pix.V > 1.0 then 1.0 else Pix.V);
		Pix2.B := (if Pix.B > 1.0 then 1.0 else Pix.B);
		Put (File, (integer (255.0 * Pix2.R)), 0); put (File,  " ");
		Put (File, (integer (255.0 * Pix2.V)), 0); put (File,  " ");
		Put (File, (integer (255.0 * Pix2.B)), 0); put (File,  " ");
	end Put;

	Procedure iniPPM (File: in out File_type; Cols, Rows, Max: integer := 255; Format: string := "P3") is
	begin
		Put_line (File, Format);
		Put      (File, Cols, 0)  ; Put      (File, " ");
		Put      (File, Rows, 0)  ; Put_line (File, " ");
		Put      (File, Max , 0);
		New_line (File);
	end iniPPM;

-------------------------------------------------------------------------
-- Operateurs -----------------------------------------------------------
-------------------------------------------------------------------------

	Function "/" (left: Pixel; right : float) return Pixel is
	begin
		return(
			left.R / right,
			left.V / right,
			left.B / right
		);
	end "/";

	Function "*" (left: Pixel; right : float) return Pixel is
	begin
		return(
			left.R * right,
			left.V * right,
			left.B * right
		);
	end "*";

	Function "*" (left: Pixel; right : Pixel) return Pixel is
	begin
		return(
			left.R * right.R,
			left.V * right.V,
			left.B * right.B
		);
	end "*";

	Function "+" (left: Pixel; right : Pixel) return Pixel is
	begin
		return(
			left.R + right.R,
			left.V + right.V,
			left.B + right.B
		);
	end "+";

	Function "-" (left: Pixel; right : Pixel) return Pixel is
	begin
		return(
			left.R - right.R,
			left.V - right.V,
			left.B - right.B
		);
	end "-";

-------------------------------------------------------------------------
-- Functions ------------------------------------------------------------
-------------------------------------------------------------------------

	Procedure Save (
		Img: T_Image;
		Name: string
	) is
		File : File_Type;
		Nul  : Pixel := (0.0,0.0,0.0);
	begin
		Create (File, Name => Name);
		iniPPM (File, Img'length(2), Img'length(1));
		for y in reverse Img'range(1) loop
			for x in Img'range(2) loop
				Put (File, Img(y,x));
			end loop;
			New_line (File);
		end loop;
		Close (File);
	end Save;

	Procedure Colorize (
		Img: in out T_Image;
		Pix: Pixel
	) is
	begin
		for y in Img'range(1) loop
			for x in Img'range(2) loop
				img (y,x) := pix;
			end loop;
		end loop;
	end Colorize;

	Procedure TraceRow (
		Row: integer;
		Pix: Pixel;
		Img: in out T_Image
	) is
		File : File_Type;
	begin
		for x in Img'range(2) loop
			Img(Row, x) := Pix;
		end loop;
	end TraceRow;

	Procedure TraceCol (
		Col: integer;
		Pix: Pixel;
		Img: in out T_Image
	) is
		File : File_Type;
	begin
		for y in Img'range(1) loop
			Img(y, Col) := Pix;
		end loop;
	end TraceCol;

	Procedure Trace (
		firstRow,
		lastRow ,
		firstCol,
		lastCol : integer;
		Pix     : Pixel;
		Img     : T_Image
	) is
	begin
		for y in firstRow..lastRow loop
			for x in firstCol..lastCol loop
				img (y,x) := pix;
			end loop;
		end loop;
	end Trace;

	Procedure DegradeL (
		first ,
		last  : in     integer;
		C1,C2 : in     Pixel;
		Img   : in out T_Image
	) is
		C  : Pixel;
		Tot: float := float(last-first);
	begin
		for y in first..last loop
			C := (C1 * float(last-Y)+ C2 * float(Y-first-1)) / Tot;
			for x in Img'range(2) loop
				img (y,x) := C;
			end loop;
		end loop;
	end DegradeL;

	Procedure DegradeW (
		first ,
		last  : in     integer;
		C1,C2 : in     Pixel;
		Img   : in out T_Image
	) is
		C  : Pixel;
		Tot: float := float(last-first);
	begin
		for x in first..last loop
			C := (C1 * (float(last-X))+ C2 * float(X-first-1)) / Tot;
			
			for y in Img'range(1) loop
				img (y,x) := C;
			end loop;
		end loop;
	end DegradeW;

	Procedure Degrade4 (
		first ,
		last  : in     integer;
		C1,C2,
		C3,C4 : in     Pixel;
		Img   : in out T_Image
	) is
		C,Ca,Cb: Pixel;
		L: float := float(last-first);
		W: float := float(Img'length(2));
	begin
		for y in first..last loop
			for x in Img'range(2) loop
				Ca := (C1 * (W-float(X)) + C2 * float(X-1))/W ;

				Cb := (C3 * (W-float(X)) + C4 * float(X-1))/W ;

				C  := (Ca * (float(last-Y)) + Cb * float(Y-first-1))/L ;

				img (y,x) := C;
			end loop;
		end loop;
	end Degrade4;

	Procedure Randomize (Img: in out T_Image) is
	begin
		for y in Img'range(1) loop
			for x in Img'range(2) loop
				img (y,x) := RandomPix;
			end loop;
		end loop;
	end Randomize;

end Images;