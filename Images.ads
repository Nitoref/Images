With ada.text_io, ada.Unchecked_Deallocation;
Use  ada.text_io; 

Package Images is

	Type Pixel is record
		R, V, B: float := 0.0;
	end record;
	Function RandomPix return Pixel;

	Type Image is array (integer range <>, integer range <>) of Pixel;
	Type T_Image is access Image;
	
	Procedure Free is new Ada.Unchecked_Deallocation(Image,T_Image); 

	Procedure Preview (Img : in     T_Image);
	Procedure Put     (File: in out File_type; Pix: Pixel);
	Procedure IniPPM  (File: in out File_Type; Cols, Rows, Max: in  integer := 255; Format: in  string := "P3");
	
	Function "/" (left: Pixel; right : float) return Pixel;
	Function "*" (left: Pixel; right : float) return Pixel;
	Function "*" (left: Pixel; right : Pixel) return Pixel;
	Function "+" (left: Pixel; right : Pixel) return Pixel;
	Function "-" (left: Pixel; right : Pixel) return Pixel;

	Procedure Save      (Img: in     T_Image; Name : String);
	Procedure Colorize  (Img: in out T_Image; Pix  : Pixel);
	Procedure TraceRow  (Row: integer; Pix: Pixel; Img: in out T_Image);
	Procedure TraceCol  (Col: integer; Pix: Pixel; Img: in out T_Image);
	Procedure Trace     (firstRow, lastRow, firstCol, lastCol: integer; Pix : Pixel; Img : T_Image);

	Procedure DegradeL  (first, last: integer; C1,C2      : Pixel; Img: in out T_Image);
	Procedure DegradeW  (first, last: integer; C1,C2      : Pixel; Img: in out T_Image);
	Procedure Degrade4  (first, last: integer; C1,C2,C3,C4: Pixel; Img: in out T_Image);

	Procedure Randomize (Img: in out T_Image);

end Images;