with Images;
use  Images;

Package Vectors is

    Type Vec3 is record
        x, y, z: float;
    end record;

    Type T_Cercle is record
        Centre: Vec3;
        Rayon : float;
    end record;

    Function "+"   (A, B: Vec3) return Vec3;
    Function "-"   (A, B: Vec3) return Vec3;
    Function "*"   (A, B: Vec3) return Vec3;
    Function  Dot  (A, B: Vec3) return float;
    Function  Norm (A   : Vec3) return float;

    Procedure Normalize (A: in out Vec3);

    Procedure Light(
        Source: Vec3 ;
        Li,
        Kb    : Pixel;
        Img   : in out T_Image
    );

    Procedure LightBack (
        Source : Vec3 ;
        Li     : Pixel;
        Img    : in out T_Image;
        Phong  : boolean := false;
        Kd     : Pixel := (1.0,1.0,1.0); 
        Kn     : float := 100.0;
        Obs    : Vec3  := (0.0,0.0,1.0)
    );

    Procedure noSphere(
        Cercle: T_Cercle;
        C     : Pixel; 
        Img   : in out T_Image 
    );

    Procedure Sphere(
        Source: Vec3 ;
        Cercle: T_Cercle;
        Li    : Pixel;
        Kb    : Pixel;
        Img   : in out T_Image;
        Phong  : boolean := false;
        Kd     : Pixel   := (1.0,1.0,1.0); 
        Kn     : float := 100.0
    );

    Procedure SphereFaded(
        Source: Vec3 ;
        Cercle: T_Cercle;
        Li    : Pixel;
        Kb    : Pixel;
        Img   : in out T_Image
    );

end Vectors;
