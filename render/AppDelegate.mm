//
//  AppDelegate.m
//  render
//
//  Created by MotionVFX on 12/02/2024.
//

#import "AppDelegate.h"


#include <vector>
#include <cstdint>
#include <cmath>
#include <cstring>

using namespace std;
#define RGBA(i) (i).r,(i).g,(i).b,(i).a
@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate


NSString *path=@"/Users/motionvfx/Documents/kwiatek.tiff";


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}
-(pixel_rgb)change_rgba:(pixel_rgb)piksel_org r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a tab:(int) tab{
    
    pixel_rgb piksel;
    return piksel;
}
- (void)_2D_Image_Create:(vector<vector<pixel_rgb>>)tab_image width:(NSInteger)width height:(NSInteger)height map:(unsigned char*)pixels rowBytes:(NSInteger)rowBytes{
    for(int i =0;i<height;i++){
        unsigned char *rowStart = (unsigned char *)(pixels + (i * rowBytes));
        for(int j =0;j<width;j++){
            *rowStart++=tab_image[i][j].r[1];
            *rowStart++=tab_image[i][j].g[1];
            *rowStart++=tab_image[i][j].b[1];
            *rowStart++=tab_image[i][j].a[1];
            }
    }
}
//zapisz zdjecia do vectora
-(vector<vector<pixel_rgb>>) Save_image:(vector<vector<pixel_rgb>>) tab_image width:(NSInteger)width height:(NSInteger)height map:(unsigned char*)pixels rowBytes:(NSInteger)rowBytes radius:(NSInteger)radius{
    for(long i =  radius; i < (height-radius); i++) {
        unsigned char *rowStart = (unsigned char *)(pixels + (i * rowBytes));
        for(long j =  radius; j < (width); j++) {
            tab_image[i][j].r[0] = *rowStart++;// Red
            tab_image[i][j].g[0] = *rowStart++;// Green
            tab_image[i][j].b[0] = *rowStart++;// Blue
            tab_image[i][j].a[0] = *rowStart++;// Alpha
        }
    }
    return tab_image;
}
-(vector<vector<pixel_rgb>>) Blur_Clamp_To_Border:(vector<vector<pixel_rgb>>) tab_image width:(NSInteger)width height:(NSInteger)height map:(unsigned char*)pixels rowBytes:(NSInteger)rowBytes radius:(NSInteger)radius {
    
    long sum_r=0, sum_g=0, sum_b=0;
    for(long i =  radius; i < (height-radius); i++) {
        for(long j =  radius; j < (width-radius); j++) {
            sum_r=0;
            sum_g=0;
            sum_b=0;
            
            for(long iy=(i-radius);iy<=(i+radius);iy++){
                for(long jx=(j-radius);jx<=(j+radius);jx++){
                    sum_r+=tab_image[iy][jx].r[0];
                    sum_g+=tab_image[iy][jx].g[0];
                    sum_b+=tab_image[iy][jx].b[0];
                }
            }
            long n=((radius*2+1)*(radius*2+1));
            tab_image[i][j].r[1]=(sum_r/n);// Red
            tab_image[i][j].g[1]=(sum_g/n);// Green
            tab_image[i][j].b[1]=(sum_b/n);// Blue
        }
    }
    return tab_image;
}
-(pixel_rgb) piksel_kol:(vector<vector<pixel_rgb>>) tab_image width:(NSInteger)width height:(NSInteger)height map:(unsigned char*)pixels rowBytes:(NSInteger)rowBytes radius:(NSInteger)radius x_axis:(double) x y_axis:(double) y tab:(NSInteger) tab{
    pixel_rgb piksel;
    
    int x_= static_cast<int>(floor(x));//calkowia
    
    int y_=static_cast<int>(floor(y));;//calkowita

    x=(x-x_);
    y=(y-y_);
//zmiennoprzecinkowa bez cyfry z przodu
    double pola [2][2];
    pola[0][0]=(1-y)*x;
    pola[0][1]=(y*x);
    pola[1][0]=(1-y)*(1-x);
    pola[1][1]=(1-x)*(y);
    //wyciagam wzory na 4 czesci pikselu
    double r=0,g=0,b=0,a=0;
    for(int j=0;j<2;j++){
        for(int i=0;i<2;i++){
           r+=pola[i][j]*tab_image[x_+i][y_+j].r[tab];
           g+=pola[i][j]*tab_image[x_+i][y_+j].g[tab];
           b+=pola[i][j]*tab_image[x_+i][y_+j].b[tab];
           a+=pola[i][j]*tab_image[x_+i][y_+j].a[tab];
        }
    }
    r=floor(r);
    piksel.r[tab]=(uint8_t)r;
    g=floor(g);
    piksel.g[tab]=(uint8_t)g;
    b=floor(b);
    piksel.b[tab]=(uint8_t)b;
    a=floor(a);
    piksel.a[tab]=(uint8_t)a;
    return piksel;
}

-(vector<vector<pixel_rgb>>) Mirrored_repeat:(vector<vector<pixel_rgb>>) tab_image width:(NSInteger)width height:(NSInteger)height map:(unsigned char*)pixels rowBytes:(NSInteger)rowBytes radius:(NSInteger)radius{
  
    for(long i =  0; i < height; i++) {
        
        for(long j =  0; j < width; j++) {
        }
    }
    return tab_image;
}

- (vector<vector<double>>) createGaussianBlurKernel:(int)radius przebieg:(int)przebieg{
    int size = radius * 2 + 1;

    vector<vector<double>> kernel(size, vector<double>(size));
    
    double r=0,pom2=0;
    int x=0,y=0;
    vector<double>r_wartosci;//zbior wszystkich promieni
    
    for (int i =  0; i <= radius; ++i) {
        for (int j =  0; j <= i; ++j) {
            x = i ;
            y = j ;
            r = sqrt(x * x + y * y);
            r_wartosci.push_back(r);
        }}
    double wegihtsum=0,weightsum2=0;
    for (int i =  0; i < size; i++) {
        for (int j =  0; j < size; j++) {
            x = abs(i - radius);
            y =  abs(j - radius);
            r = sqrt(x * x + y * y);
            pom2 = (pow(M_E,-(pow(r,2)))*2/radius);
            kernel[i][j]=pom2;
            wegihtsum++;
        }
    }
    for(int i=0;i<size;i++)
    {
        for(int j=0;j<size;j++)
        {
            weightsum2+=kernel[i][j];
        }
    }
  //  wegihtsum;weightsum2;
    return kernel;
}
//Gausse blur

-(void) effectDiference:(vector<vector<pixel_rgb>>)tab_image width:(NSInteger)width height:(NSInteger)height map:(unsigned char*)pixels tab1:(int) tab1 tab2:(int) tab2{
    
}	
-(vector<vector<pixel_rgb>>) Gausse_Blur:(vector<vector<pixel_rgb>>) tab_image width:(NSInteger)width height:(NSInteger)height map:(unsigned char*)pixels rowBytes:(NSInteger)rowBytes radius:(NSInteger)radius{
    int przebieg=1;
     vector<vector<double>> ker = [self createGaussianBlurKernel:((int)radius) przebieg:przebieg];

       
    int x_ker=0;
    int y_ker=0;
    double sum_r=0, sum_g=0, sum_b=0;
    for(long i =  radius; i < (height-radius); i++) {
        for(long j =  radius; j < (width-radius); j++) {
            sum_r=0;
            sum_g=0;
            sum_b=0;
            x_ker=0;
            y_ker=0;
            
            double tmpW = 0.;
            
            for(long iy=(i-radius);iy<=(i+radius);iy++){
                for(long jx=(j-radius);jx<=(j+radius);jx++){
                    sum_r+=tab_image[iy][jx].r[0]*ker[y_ker][x_ker];
                    sum_g+=tab_image[iy][jx].g[0]*ker[y_ker][x_ker];
                    sum_b+=tab_image[iy][jx].b[0]*ker[y_ker][x_ker];
                    x_ker++;
                    
                    tmpW += ker[y_ker][x_ker];
                    
                }y_ker++;
            }
            
            
            
            //long n=((radius*2+1)*(radius*2+1));
            sum_r=floor(sum_r);
            sum_r=floor(sum_g);
            sum_r=floor(sum_b);
            tab_image[i][j].r[1]=(sum_r/tmpW);// Red
            tab_image[i][j].g[1]=(sum_g/tmpW);// Green
            tab_image[i][j].b[1]=(sum_b/tmpW);// Blue
        }
    }
    return tab_image;
}
-(void)blur:(NSImage *)image rad:(long)radius blur_option:(int)blur_option{
    NSDate *startTime = [NSDate date];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithData:[image TIFFRepresentation ]];
    NSInteger width = [bitmapRep pixelsWide];
    NSInteger height = [bitmapRep pixelsHigh];
    NSInteger rowBytes = [bitmapRep bytesPerRow];
    unsigned char *pixels = [bitmapRep bitmapData];
    vector<vector<pixel_rgb>>tab_image;
    tab_image.resize(height);
    for (int i = 0; i < height; i++){
        tab_image[i].resize(width);
        
    }
    for(int i=0;i<height;i++){
        for(int j=0;j<width;j++){
            tab_image[i][j].r.resize(2);
            tab_image[i][j].g.resize(2);
            tab_image[i][j].b.resize(2);
            tab_image[i][j].a.resize(2);
           
        }
    }
    //zapis orginalnego obrazka to tablicy tab_image.r[0]
    tab_image=[self Save_image:tab_image width:width height:height map:pixels rowBytes:rowBytes radius:radius];
    //operacje na nowym obrazku tab_image.r[1];
    switch (blur_option){
    case 1://Blur Clamp To border
            tab_image=[self Blur_Clamp_To_Border:tab_image width:width height:height map:pixels rowBytes:rowBytes radius:radius];
            break;
        case 2:
            tab_image=[self Gausse_Blur:tab_image width:width height:height map:pixels rowBytes:rowBytes radius:radius];
           
            break;
        case 3:
            tab_image=[self Mirrored_repeat:tab_image width:width height:height map:pixels rowBytes:rowBytes radius:radius];
           
            break;
        case 4:
            [self effectDiference:tab_image width:width height:height map:pixels tab1:0 tab2:1];
            break;
    }
    //tab_image=[self Blur_Clamp_To_Border:tab_image width:width height:height map:pixels rowBytes:rowBytes radius:radius];
    //tworzenie dwuwymiarowego obrazka
    [self _2D_Image_Create:tab_image width:width height:height map:pixels rowBytes:rowBytes];
    //tworzenie obrazka
    NSImage *grayScaleImage = [[NSImage alloc] initWithSize:[bitmapRep size]];
    [grayScaleImage addRepresentation:bitmapRep];
    [self OpenImageView:grayScaleImage];
    NSDate *endTime = [NSDate date];
    NSTimeInterval executionTime = [endTime timeIntervalSinceDate:startTime];
    NSLog(@"Czas-Blur: %f", executionTime);
    pixel_rgb pole;
    pole.r.resize(2);
    pole.g.resize(2);
    pole.b.resize(2);
    pole.a.resize(2);
    NSLog(@"koniec%d",pole.r[0]);

}
- (IBAction)filtr_blur:(id)sender{
    NSImage *image =[[NSImage alloc] initWithContentsOfFile:path];
    long radius=4;
    [self blur:image rad:radius blur_option:1];
}
- (IBAction) Gausse_Blure_Button:(id)sender{
    NSImage *image =[[NSImage alloc] initWithContentsOfFile:path];
    long radius=2;
    [self blur:image rad:radius blur_option:2];
    
}

-(IBAction)negatyw:(id)sender{
    [self filtr_:1];
}

-(void)filtr_:(int)filtr{
    NSImage *image2 =[[NSImage alloc] initWithContentsOfFile:path];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithData:[image2 TIFFRepresentation ]];
    NSInteger width = [bitmapRep pixelsWide];
    NSInteger height = [bitmapRep pixelsHigh];
    NSInteger rowBytes = [bitmapRep bytesPerRow];
    unsigned char *pixels = [bitmapRep bitmapData];
    NSDate *startTime = [NSDate date];
    for (NSInteger row =  0; row < height; row++) {
        unsigned char *rowStart = (unsigned char *)(pixels + (row * rowBytes));
        for (NSInteger col =  0; col < width; col++) {
            if(filtr==0){
                unsigned char grayscale = (*rowStart *  0.3) + (*(rowStart +  1) *  0.59) + (*(rowStart +  2) *  0.11);
                *rowStart++ = grayscale; // Red
                *rowStart++ = grayscale; // Green
                *rowStart++ = grayscale; // Blue
                rowStart++;
            }
            else if(filtr==1){
                *rowStart++ = (255-*rowStart); // Red
                *rowStart++ = (255-*rowStart); // Green
                *rowStart++ = (255-*rowStart); // Blue
                rowStart++;
            }
        }
    }
    NSDate *endTime = [NSDate date];
    NSTimeInterval executionTime = [endTime timeIntervalSinceDate:startTime];
    NSLog(@"Czas: %f", executionTime);
    NSImage *grayScaleImage = [[NSImage alloc] initWithSize:[bitmapRep size]];
      [grayScaleImage addRepresentation:bitmapRep];
    [self OpenImageView:grayScaleImage];
}
-(IBAction)gray:(id)sender{
[self filtr_:0];
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
}
- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}
- (IBAction)otworz_zdjecie:(id)sender{
}
-(void)OpenImageView:(NSImage * )image{
    [[self.window contentView]addSubview:imageView];
    imageView = [[NSImageView alloc]initWithFrame:[self.window.contentView bounds]];
    [imageView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [imageView setImage:image];
}
- (IBAction)wyswietl:(id)sender{
    //NSImage *image =[NSImage imageNamed:@"zdjecie"];
    NSImage *image =[[NSImage alloc] initWithContentsOfFile:path];
    [self OpenImageView:image];
    NSLog(@"wyświetl");
}
@end
