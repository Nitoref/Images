with ada.numerics.elementary_functions, Rand;
use  ada.numerics.elementary_functions, Rand;

Package body Vectors is
-----------------------------------------------------

    Function "+" (A, B: Vec3) return Vec3 is
    begin
        return ((A.x+B.x),(A.y+B.y),(A.z+B.z));
    end "+";
-----------------------------------------------------

    Function "-" (A, B: Vec3) return Vec3 is
    begin
        return ((A.x-B.x),(A.y-B.y),(A.z-B.z));
    end "-";
-----------------------------------------------------
 
    Function "*" (A, B: Vec3) return Vec3 is
    begin
        return ((A.x*B.x), (A.y*B.y), (A.z*B.z));
    end "*";
-----------------------------------------------------

   Function Dot (A, B: Vec3) return float is
    begin
        return (A.x*B.x + A.y*B.y + A.z*B.z);
    end Dot;
-----------------------------------------------------

    Function Norm (A: Vec3) return float is
    begin
        return Sqrt (A.x**2 + A.y**2 + A.z**2);
    end Norm;
-----------------------------------------------------

    Procedure Normalize (A: in out Vec3) is
        Len: float := Norm (A);
    begin
        A := ((A.x/Len, A.y/Len, A.z/Len));
        exception
            when others => A := (0.0,0.0,0.0);
    end Normalize;

-----------------------------------------------------
-- Eclaire un pixel Kb d'une lumiere Li.
-----------------------------------------------------
    Procedure Light (
        Source : Vec3 ;
        Li, Kb : Pixel;
        Img    : in out T_Image
    )is
        P,Vi,N : Vec3 ;
        Cos  : float;
    begin
        for y in Img'range(1) loop
            for x in Img'range(2) loop
                P := (float(x), float(y), 0.0);
                
                Vi := Source - P;     Normalize (Vi);
                N := (0.0,0.0,1.0);   --Normalize (N);

                Cos := Dot (N, Vi) ;
                Img(y,x) := Kb * Li * Cos; -- /3.14;
            end loop;
        end loop;
    end Light;

-------------------------------------------------------------------
-- Eclaire tous les pixels d'une image d'une lumière Li.
-------------------------------------------------------------------
--                   ( possibilité de mettre deux sources opposées)

    Procedure LightBack (
        Source : Vec3 ;
        Li     : Pixel;
        Img    : in out T_Image;
        Phong  : boolean := false;
        Kd     : Pixel   := (1.0,1.0,1.0); 
        Kn     : float   := 100.0;
        Obs    : Vec3    := (0.0,0.0,1.0))
    is
        -- Source2: Vec3 := (Source.x, float(Img'last(1))-Source.y, Source.z);
        P,Vi,H : Vec3 ;
        N      : Vec3 := (0.0,2.0,1.0);
        -- Vi2,N2 : Vec3 ;
        CosT,
        CosA   : float;
        -- Ratio2 : float;
    begin
        Normalize (N);
        for y in Img'range(1) loop
            for x in Img'range(2) loop
                P := (float(x), float(y), 0.0);

                Vi := Source - P; Normalize (Vi);

                -- Vi2 := Source2 - P;     Normalize (Vi2);
                -- N2 := (0.0,-3.0,1.0);   Normalize (N2);

                CosT := Dot (N, Vi);
                if CosT < 0.0 then CosT := 0.0; end if;
                -- Ratio2 := Dot (N2, Vi2);
                -- if Ratio2 < 0.0 then Ratio2 := 0.0; end if;
                -- Cos := (Cos + Ratio2)/ 2.0;

                if Phong then
                    H := (Vi + Obs); Normalize (H);
                    CosA := Dot (H, N);
                    Img(y,x) := (Li * CosT * (Img(y,x) + Kd * (cosA ** Kn)) / (1.0+CosA ** Kn)) * (Rand.flt/2.0+0.5);
                    -- Img(y,x) :=  Li * CosT * (Kb/3.14 + (Kd (Kn+2) * (CosA ** Kn)) / 6.28); 
                else
                    Img(y,x) := Li * CosT * Img(y,x); -- /3.14;
                end if;
            end loop;
        end loop;
    end LightBack;

-------------------------------------------------------------------
-- Met des pixels aléatoires partout ailleurs que dans le cercle.
-------------------------------------------------------------------
    Procedure noSphere (
        Cercle : T_Cercle; 
        C      : Pixel;
        Img    : in out T_Image)
    is
        P : Vec3;
        l : float;
    begin
        for y in Img'range(1) loop
            for x in Img'range(2) loop
                P  := (float (x), float (y), 0.0);
                l := Norm (P - Cercle.Centre);
                if l > Cercle.Rayon then
                    img (y,x) := RandomPix;
                end if;
            end loop;
        end loop;
    end noSphere;

-------------------------------------------------------------------
-- Simule l'eclairage d'une sphere.
-------------------------------------------------------------------
    Procedure Sphere (
        Source : Vec3 ;
        Cercle : T_Cercle; 
        Li, Kb : Pixel; 
        Img    : in out T_Image;
        Phong  : boolean := false;
        Kd     : Pixel   := (1.0,1.0,1.0);
        Kn     : float := 100.0)
    is
        P,Vi,H : Vec3;
        N      : Vec3 := (0.0,0.0,1.0);
        CosT,l: float;
        CosA: float;
    begin
        for y in Img'range(1) loop
            for x in Img'range(2) loop
                P  := (float (x), float (y), 0.0);
                l := Norm (P - Cercle.Centre);

                if l <= Cercle.Rayon then
                    P := (float (x), float (y), sqrt (Cercle.Rayon**2-l**2));

                    N  := P - Cercle.Centre;
                    Normalize (N);

                    Vi := Source - P;
                    Normalize (Vi);

                    CosT := Dot (N, Vi);
                    if CosT < 0.0 then CosT := 0.0; end if;

                    if Phong then
                        H := (Vi + N); Normalize (H);
                        CosA := Dot (H, N);
                        Img(y,x) := Li * CosT * (Kb + Kd * (CosA ** Kn)) / (1.0+CosA ** Kn);
                        -- Img(y,x) := Li * CosT * (Kb/3.14 + (Kd + (Kn+2.0) * (CosA ** Kn))/6.28);
                    else
                        Img (y,x) := Kb * Li * CosT; -- / 3.14;
                    end if;
                end if;
            end loop;
        end loop;
    end Sphere;

-------------------------------------------------------------------
-- Simule l'eclairage d'une sphere avec fondu sur l'image.
-------------------------------------------------------------------
    Procedure SphereFaded (
        Source : Vec3 ;
        Cercle : T_Cercle; 
        Li, Kb : Pixel; 
        Img    : in out T_Image)
    is
        P,Vi,N : Vec3;
        CosT,L : float;
    begin
        for y in Img'range(1) loop
            for x in Img'range(2) loop
                P  := (float (x), float (y), 0.0);
                L := Norm (P - Cercle.Centre);

                if L <= Cercle.Rayon then
                    P := (float (x), float (y), sqrt (Cercle.Rayon**2-l**2));

                    N  := P - Cercle.Centre;
                    Normalize (N);

                    Vi := Source - P;
                    Normalize (Vi);

                    CosT := Dot (N, Vi);
                    if CosT < 0.0 then CosT := 0.0; end if;

                    Img (y,x) := Kb * Li * CosT + Img (y,x) * (1.0 - CosT);
                end if;
            end loop;
        end loop;
    end SphereFaded;

end Vectors;