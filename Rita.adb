With ada.text_io, ada.integer_text_io, Images, Bresenham, Tools, Console, Ada.strings.unbounded;
Use  ada.text_io, ada.integer_text_io, Images, Bresenham, Tools, Console, Ada.strings.unbounded;

Procedure Rita is

    choix: character;
    r, v, b: integer;
    Nom : unbounded_string;
    H, L,
    x0, y0,
    x1, y1,
    xmin, xmax,
    ymin, ymax,
    marge: integer;

    MyImg : T_Image;
    MyPix : Pixel;


begin
    clearBelow;
    Put      ("Faites votre choix.", White, Black); new_line;
    Put_line ("1. Tracé de segment");
    Put_line ("2. Tracé de cercle");
    sGet (choix, "12");
    moveCursor (Up, 3); clearBelow;

    Case choix is
        when '1' => 
            Put      ("Tracé de segment de Bresenham", White, Black); new_line;
            Put_line ("x0    : ");
            Put_line ("y0    : ");
            Put_line ("x1    : ");
            Put_line ("y1    : ");
            Put_line ("Marge : ");
            Put_line ("R     : ");
            Put_line ("v     : ");
            Put_line ("B     : ");
            Put      ("Nom   : ");

            moveCursor (Up, 8);    sGet (x0);
            moveCursor (right, 8); sGet (y0);
            moveCursor (right, 8); sGet (x1);
            moveCursor (right, 8); sGet (y1);
            moveCursor (right, 8); sGet (marge, 0);
            moveCursor (right, 8); sGet (R, 0, 255);
            moveCursor (right, 8); sGet (V, 0, 255);
            moveCursor (right, 8); sGet (B, 0, 255);
            moveCursor (right, 8); Nom := to_unbounded_string(get_line);
            MyPix := (float(R)/255.0,float(V)/255.0,float(B)/255.0);
            if x0 < x1 then
                xmin := x0;
                xmax := x1;
            else
                xmin := x1;
                xmax := x0;
            end if;
            if y0 < y1 then
                ymin := y0;
                ymax := y1;
            else
                ymin := y1;
                ymax := y0;
            end if;
            MyImg := new Image (ymin - marge..ymax + marge, 
                                xmin - marge..xmax + marge);
            traceLine (x0,y0,x1,y1, MyPix, MyImg);


        when '2' =>
            moveCursor (Up, 1); clearBelow;
            Put      ("Tracé de cercle", White, Black); new_line;
            Put_line ("1. Bresenham");
            Put_line ("2. Andrès");
            sGet (choix, "12");
            moveCursor (Up, 2); clearBelow;

            if choix = '1' then
                Put ("Tracé de cercle de Bresenham", White, Black); new_line;
            else
                Put ("Tracé de cercle d'Andrès", White, Black); new_line;
            end if;

            Put_line ("Rayon : ");
            Put_line ("Marge : ");
            Put_line ("R     : ");
            Put_line ("v     : ");
            Put_line ("B     : ");
            Put      ("Nom   : ");
            moveCursor (Up, 5);    sGet (H);
            moveCursor (right, 8); sGet (marge, 0);
            moveCursor (right, 8); sGet (R, 0, 255);
            moveCursor (right, 8); sGet (V, 0, 255);
            moveCursor (right, 8); sGet (B, 0, 255);
            moveCursor (right, 8); Nom := to_unbounded_string(get_line);
            MyPix := (float(R)/255.0,float(V)/255.0,float(B)/255.0);

            L := H;
            H := H + marge;
            MyImg := new Image (-H..H,
                                -H..H);

            if choix = '1' then
                BresenhamCircle ( 
                    0, 0, L, 
                    MyPix,
                    TRUE,
                    MyImg);
            else
                AndresCircle ( 
                    0, 0, L, 
                    MyPix,
                    TRUE,
                    MyImg);
            end if;
    
        when others => null;
    end case;

    Save (MyImg, to_string(nom)&".ppm");


end Rita;