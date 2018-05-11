With Images, Vectors, Rand, Ada.numerics.elementary_functions, ada.text_io, Tools;
Use  Images, Vectors, Rand, Ada.numerics.elementary_functions, ada.text_io, Tools;

procedure Main is

    J : Pixel := (1.0, 1.0, 0.0);
    C : Pixel := (0.0, 1.0, 1.0);
    V : Pixel := (0.0, 1.0, 0.0);
    M : Pixel := (1.0, 0.0, 1.0);
    R : Pixel := (1.0, 0.0, 0.0);
    B : Pixel := (0.0, 0.0, 1.0);

    Noir      : Pixel := (0.0, 0.0, 0.0);
    Blanc     : Pixel := (1.0, 1.0, 1.0);
    Corail    : Pixel := (0.8, 0.3, 0.4);
    Turquoise : Pixel := (0.2, 0.7, 0.8);
    BleuNuit  : Pixel := (0.3, 0.4, 0.8);
    BleuClair : Pixel := (0.2, 0.5, 0.9);
    Gris      : Pixel := (0.75, 0.75, 0.75);

    MyImg, MyImg2  : T_Image ;

begin

----------------------------------------------------------------------------------------
-- Image 0 -----------------------------------------------------------------------------
----------------------------------------------------------------------------------------
    MyImg  := new Image (1..1080, 1..1080);
    MyImg2 := new Image (1..1080, 1..1080);
    declare
        Source: Vec3 := (540.0, 1080.0, 100.0);
        Cercle  : T_Cercle  := ((540.0, 540.0, 0.0), 385.0);
        Glitch1 : float; 
        Glitch2 : integer;
    begin
        trace (539, 925, 155, 265, Gris, MyImg);
        trace (539, 925, 266, 375, J,    MyImg);
        trace (539, 925, 376, 485, C,    MyImg);
        trace (539, 925, 486, 595, V,    MyImg);
        trace (539, 925, 596, 705, M,    MyImg);
        trace (539, 925, 706, 815, R,    MyImg);
        trace (539, 925, 816, 925, B,    MyImg);

        trace (411, 538, 155, 265, B,    MyImg);
        trace (411, 538, 266, 375, Noir, MyImg);
        trace (411, 538, 376, 485, M,    MyImg);
        trace (411, 538, 486, 595, Noir, MyImg);
        trace (411, 538, 596, 705, C,    MyImg);
        trace (411, 538, 706, 815, Noir, MyImg);
        trace (411, 538, 816, 925, Gris, MyImg);

        trace (155, 410, 155, 305, (0.0, 0.14, 0.28), MyImg);
        trace (155, 410, 306, 455, Blanc, MyImg);
        trace (155, 410, 456, 605, (0.2, 0.0, 0.4), MyImg);
        trace (155, 410, 606, 755, (0.1, 0.1, 0.1), MyImg);
        noSphere (Cercle, Noir, MyImg);

        for y in MyImg'range(1) loop
            glitch1 := abs (sin (float(y)/2.0));
            glitch2 := integer (tan (float(y)/100.0)**2);
            for x in MyImg'range(2) loop
                begin
                    MyImg2 (y, x) := MyImg (y, x + glitch2) * glitch1;
                exception when others => null;
                end; 
            end loop;   
        end loop;

        LightBack (Source, Blanc, MyImg2);
        Save (MyImg2, "ImageN4.ppm");
    end;

----------------------------------------------------------------------------------------
-- Image 1 -----------------------------------------------------------------------------
----------------------------------------------------------------------------------------
    MyImg  := new Image (1..1080, 1..1920);
    MyImg2 := new Image (1..1080, 1..1920);
    declare
        KbLune  : Pixel     := (0.9, 0.3, 0.4);
        Source  : Vec3      := (1750.0, 540.0, 100.0);
        Lune    : T_Cercle  := (( 700.0, 850.0, 0.0), 135.0);
    begin
        trace  (1, 540, 1, 1920, BleuNuit, MyImg);
        LightBack (Source, Blanc, MyImg, Phong => true, Kd => Blanc, Kn => 200.0, Obs => (0.0,2.0,1.0));
        Degrade4 (541, 1080, Noir, Corail, Noir, Turquoise, MyImg);
        SphereFaded (Source, Lune, Blanc, KbLune, MyImg);

        Save (MyImg, "ImageN1.ppm");
    end;

----------------------------------------------------------------------------------------
-- Image 2 -----------------------------------------------------------------------------
----------------------------------------------------------------------------------------
    MyImg  := new Image (-1080..1080, -1080..1080);
    declare
        Source  : Vec3     := (-1080.0, 0.0, -100.0);
        Source2 : Vec3     := ( 1080.0, 0.0, -100.0);
        Cercle  : T_Cercle := ((0.0, 0.0, 0.0), 900.0);
    begin
        for i in 1..8 loop
            SphereFaded (Source, Cercle, Blanc, BleuClair, MyImg);
            Source.x := Source.x + 270.0;
            Source.y := sqrt (1166400.0 - Source.x **2);

            SphereFaded (Source2, Cercle, Blanc, BleuClair, MyImg);
            Source2.x := Source2.x - 270.0;
            Source2.y := - sqrt (1166400.0 - Source2.x **2);

            Cercle.rayon := Cercle.rayon - 100.0;
        end loop;
        Save (MyImg, "ImageN2.ppm");
    end;

-- ----------------------------------------------------------------------------------------
-- -- Image 3 -----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------
    MyImg := New Image (1..1080,1..1920);
    declare
        Source : Vec3      := (800.0, 500.0, 100.0);
        Terre  : T_Cercle  := ((1080.0,  -2700.0, 0.0), 3000.0);
        Lune   : T_Cercle  := (( 140.0,    620.0, 0.0),  140.0);
        i: float;
        j: integer;
    begin
        for y in MyImg'range(1) loop
            for x in MyImg'range(2) loop
                i := (Rand.flt - 0.9998);
                if i > 0.0 then
                    j := integer (10000.0 * i);
                    for k in (x-j)..(x) loop
                        for l in (y-j)..(y) loop
                            begin
                                MyImg (l, k) := (if j /= 1 then Blanc else RandomPix);
                            exception when others => null;
                            end;
                        end loop;
                    end loop;
                end if;
            end loop;
        end loop;

        Sphere (Source, Terre, Blanc, BleuNuit, myImg);
        Source := (800.0, 670.0, -100.0);
        for i in 1..10 loop
            SphereFaded (Source, Lune, Blanc, (0.7,0.7,0.4), MyImg);
            Lune.centre.y := Lune.centre.y + 10.0;
            Lune.centre.x := Lune.centre.x + 180.0;
        end loop;
        Save (MyImg, "ImageN3.ppm");
    end;

----------------------------------------------------------------------------------------
-- Image 4 -----------------------------------------------------------------------------
----------------------------------------------------------------------------------------
    MyImg  := new Image (1..1080, 1..1920);
    MyImg2 := new Image (1..1080, 1..1920);
    declare
        KbLune  : Pixel     := (0.9, 0.3, 0.4);
        Source  : Vec3      := (1750.0, 540.0, 400.0);
        Lune    : T_Cercle  := (( 1200.0, 450.0, 0.0), 235.0);
    begin
        Sphere (Source, Lune, Blanc, KbLune, MyImg, Phong => true, Kn => 300.0);
        Save (MyImg, "ImageN1.ppm");
    end;

    


end Main;