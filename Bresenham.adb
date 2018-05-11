With ada.text_io, ada.integer_text_io, Tools, Rand;
Use  ada.text_io, ada.integer_text_io, Tools, Rand;

Package body Bresenham is 


    Procedure BresenhamCircle (
        Xcentre,
        Ycentre,
        Rayon  : integer;
        MyPix  : in out Pixel;
        Full   : boolean;
        MyImg: T_Image)
    is
        x : integer := 0;
        y : integer := Rayon;
        m : integer := 5 - 4*y;
    begin
        while x <= y loop
            MyImg (Ycentre + y, Xcentre + x) := MyPix;
            MyImg (Ycentre + x, Xcentre + y) := MyPix;
            MyImg (Ycentre + y, Xcentre - x) := MyPix;
            MyImg (Ycentre + x, Xcentre - y) := MyPix;
            MyImg (Ycentre - y, Xcentre + x) := MyPix;
            MyImg (Ycentre - x, Xcentre + y) := MyPix;
            MyImg (Ycentre - y, Xcentre - x) := MyPix;
            MyImg (Ycentre - x, Xcentre - y) := MyPix;
                if m > 0 then
                        y := y - 1;
                        m := m - 8 * y;
                end if;
                x := x + 1;
                m := m + 8 * x + 4 ;
        end loop;
        if Full and then Rayon /= 0 then
            MyPix := (Rand.flt, Rand.flt, Rand.flt);
            BresenhamCircle (Xcentre, Ycentre, Rayon-1, MyPix, true, MyImg);
        end if;
    end BresenhamCircle;


    Procedure AndresCircle (
        Xcentre,
        Ycentre,
        Rayon  : integer;
        MyPix  : in out Pixel;
        Full   : boolean;
        MyImg: T_Image)
    is
        x : integer := 0;
        y : integer := Rayon;
        d : integer := Rayon -1;
    begin
        x := 0;
        y := Rayon;
        d := Rayon - 1;
        while y >=x loop
                MyImg (Xcentre + x , Ycentre + y ) := MyPix;
                MyImg (Xcentre + y , Ycentre + x ) := MyPix;
                MyImg (Xcentre - x , Ycentre + y ) := MyPix;
                MyImg (Xcentre - y , Ycentre + x ) := MyPix;
                MyImg (Xcentre + x , Ycentre - y ) := MyPix;
                MyImg (Xcentre + y , Ycentre - x ) := MyPix;
                MyImg (Xcentre - x , Ycentre - y ) := MyPix;
                MyImg (Xcentre - y , Ycentre - x ) := MyPix;
                if d >= 2 * x then
                        d := d - 2*x - 1;
                        x := x+1;
                elsif d < 2 * (Rayon-y) then
                        d := d + 2*y - 1;
                        y := y-1;   
                else 
                        d := d + 2 * (y-x-1);
                        y := y-1;
                        x := x+1;
            end if;
        end loop;

        if Full and then Rayon /= 0 then
            MyPix := (Rand.flt, Rand.flt, Rand.flt);
            AndresCircle (Xcentre, Ycentre, Rayon-1, MyPix, true, MyImg);
        end if;
    end AndresCircle;


    Procedure traceLine (
        xa, ya  , 
        xb, yb  : integer;
        MyPix   : Pixel;
        MyImg   : T_Image) 
    is
        x0 : integer := xa;
        y0 : integer := ya;
        x1 : integer := xb;
        y1 : integer := yb;
        x, y    ,
        dx,dy,dp,
        deltaE  ,
        deltaNE : integer;

        Procedure Swap is new Tools.Swap (integer);

    begin

        if y1 < y0 then
            Swap (x0, x1);
            Swap (y0, y1);
        end if;

        x := x0;
        y := y0;

        if x1 >= x0 then
            dx:= x1 - x0;
            dy:= y1 - y0;
    -----------------------------------------------
                if dx >= dy then
                    Put_line ("1a");
                    dp     := 2*dy-dx;
                    deltaE := 2*dy;
                    deltaNE:= 2*(dy-dx);
                    while x <= x1 loop
                        if dp <= 0 then
                            MyImg (y,x) := MyPix;
                            dp := dp + deltaE;
                            x := x +1;
                        else
                            MyImg (y,x) := MyPix;
                            dp := dp + deltaNE;
                            x := x +1;
                            y := y +1;
                        end if;
                        Put (x); Put (y); new_line;
                    end loop;
    -----------------------------------------------
                elsif dx < dy then
                    Put_line ("1b");
                    dp     := 2*dx-dy;
                    deltaE := 2*dx;
                    deltaNE:= 2*(dx-dy);
                    while y <= y1 loop
                        if dp <= 0 then
                            MyImg (y,x) := MyPix;
                            dp := dp + deltaE;
                            y:= y +1;
                        else
                            MyImg (y,x) := MyPix;
                            dp := dp + deltaNE;
                            x := x +1;
                            y := y +1;
                        end if;
                        Put (x); Put (y); new_line;
                    end loop;
                end if;
    -----------------------------------------------
        ELSIF x1 < x0 then
            dx:= x0 - x1;
            dy:= y1 - y0;
    -----------------------------------------------
                if dx >= dy then
                    Put_line ("2a");
                    dp     := 2*dy-dx;
                    deltaE := 2*dy;
                    deltaNE:= 2*(dy-dx);
                    while x >= x1 loop
                        if dp <= 0 then
                            MyImg (y,x) := MyPix;
                            dp := dp + deltaE;
                            x := x -1;
                        else
                            MyImg (y,x) := MyPix;
                            dp := dp + deltaNE;
                            x := x -1;
                            y := y +1;
                        end if;
                        Put (x); Put (y); new_line;
                    end loop;
    -----------------------------------------------
                elsif dx < dy then
                    Put_line ("2b");
                    dp     := 2*dx-dy;
                    deltaE := 2*dx;
                    deltaNE:= 2*(dx-dy);
                    while y <= y1 loop
                        if dp <= 0 then
                            MyImg (y,x) := MyPix;
                            dp := dp + deltaE;
                            y := y +1;
                        else
                            MyImg (y,x) := MyPix;
                            dp := dp + deltaNE;
                            x := x -1;
                            y := y +1;
                        end if;
                        Put (x); Put (y); new_line;
                    end loop;
                end if;
    -----------------------------------------------
        end if;
    end traceLine;

end Bresenham;
