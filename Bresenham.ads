with Images;
use  Images;

Package Bresenham is 

    Procedure BresenhamCircle  (
        Xcentre,
        Ycentre, 
        Rayon  : in     integer; 
        MyPix  : in out Pixel;
        Full   : in     boolean;
        MyImg  : in     T_Image
    );

    Procedure AndresCircle (
        Xcentre,
        Ycentre,
        Rayon  : in     integer;
        MyPix  : in out Pixel;
        Full   : in     boolean;
        MyImg  : in     T_Image
    );

    Procedure traceLine (
        xa, ya,
        xb, yb: integer; 
        MyPix : Pixel;
        MyImg : T_Image
    );

end Bresenham;