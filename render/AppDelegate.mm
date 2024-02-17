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

bool switch_grayscale=0,switch_negative=0,switch_boxblur=0,switch_gaussian_blur=0,switch_kawasaki_blur=0, switch_GL_repeat=0,switch_GL_Mirrored_repeat=0, switch_GL_clamp_to_edge=0, switch_gl_clamp_to_border=0;

image_object orginal_picture;

NSString *path=@"/Users/motionvfx/Documents/kwiatek.tiff";


-(IBAction)switch__gray_scale:(id)sender{
    switch_grayscale=!switch_grayscale;
    NSLog(@"%d",switch_grayscale);
}
-(IBAction)switch__negative:(id)sender{
    switch_negative=!switch_negative;
    NSLog(@"%d",switch_negative);
}
-(IBAction)switch__boxblur:(id)sender{
    switch_boxblur=!switch_boxblur;
    NSLog(@"%d",switch_boxblur);
}-(IBAction)switch__gaussian_blur:(id)sender{
    switch_gaussian_blur=!switch_gaussian_blur;
    NSLog(@"%d",switch_gaussian_blur);
}
-(IBAction)switch__kawasaki_blur:(id)sender{
    switch_kawasaki_blur=!switch_kawasaki_blur;
    NSLog(@"%d",switch_kawasaki_blur);
}
-(IBAction)switch__GL_repeat:(id)sender{
    switch_GL_repeat=!switch_GL_repeat;
    NSLog(@"%d",switch_GL_repeat);
}
-(IBAction)switch__GL_Mirrored_repeat:(id)sender{
    switch_GL_Mirrored_repeat=!switch_GL_Mirrored_repeat;
    NSLog(@"%d",switch_GL_Mirrored_repeat);
}
-(IBAction)switch__GL_clamp_to_edge:(id)sender{
    switch_GL_clamp_to_edge=!switch_GL_clamp_to_edge;
    NSLog(@"%d",switch_GL_clamp_to_edge);
}
-(IBAction)switch_gl_clamp_to_border:(id)sender{
    switch_gl_clamp_to_border=!switch_gl_clamp_to_border;
    NSLog(@"%d",switch_gl_clamp_to_border);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSImage *image_org =[[NSImage alloc] initWithContentsOfFile:path];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithData:[image_org TIFFRepresentation ]];
     orginal_picture.width = [bitmapRep pixelsWide];
    orginal_picture.height = [bitmapRep pixelsHigh];
    orginal_picture.rowBytes = [bitmapRep bytesPerRow];
    unsigned char *pixels = [bitmapRep bitmapData];
//    NSDate *startTime = [NSDate date];
    pixel_rgb piksel;
    for (NSInteger row =  0; row < orginal_picture.height; row++) {
        unsigned char *rowStart = (unsigned char *)(pixels + (row * orginal_picture.rowBytes));
        for (NSInteger col =  0; col < orginal_picture.width; col++) {
            
                piksel.r=*rowStart++ ; // Red
                piksel.g=*rowStart++; // Green
                piksel.b=*rowStart++ ; // Blue
                piksel.a=*rowStart++;
            orginal_picture.obraz.push_back(piksel);
            }
    }
}
-(pixel_rgb)change_rgba:(pixel_rgb)piksel_org r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a tab:(int) tab{
    pixel_rgb piksel;
    return piksel;
}

- (void)_2D_Image_Create:(vector<vector<pixel_rgb>>)tab_image width:(NSInteger)width height:(NSInteger)height map:(unsigned char*)pixels rowBytes:(NSInteger)rowBytes{
    for(int i =0;i<height;i++){
        unsigned char *rowStart = (unsigned char *)(pixels + (i * rowBytes));
        for(int j =0;j<width;j++){
            *rowStart++=tab_image[i][j].r;
            *rowStart++=tab_image[i][j].g;
            *rowStart++=tab_image[i][j].b;
            *rowStart++=tab_image[i][j].a;
            }
    }
}
//zapisz zdjecia do vectora
-(vector<vector<pixel_rgb>>) Save_image:(vector<vector<pixel_rgb>>) tab_image width:(NSInteger)width height:(NSInteger)height map:(unsigned char*)pixels rowBytes:(NSInteger)rowBytes radius:(NSInteger)radius{
    for(long i =  radius; i < (height-radius); i++) {
        unsigned char *rowStart = (unsigned char *)(pixels + (i * rowBytes));
        for(long j =  radius; j < (width); j++) {
            tab_image[i][j].r = *rowStart++;// Red
            tab_image[i][j].g = *rowStart++;// Green
            tab_image[i][j].b = *rowStart++;// Blue
            tab_image[i][j].a = *rowStart++;// Alpha
        }
    }
    return tab_image;
}
-(vector<vector<pixel_rgb>>) Blur_Clamp_To_Border:(vector<vector<pixel_rgb>>) tab_image width:(NSInteger)width height:(NSInteger)height map:(unsigned char*)pixels rowBytes:(NSInteger)rowBytes radius:(NSInteger)radius {
    vector<vector<pixel_rgb>> tab_image2;
    long sum_r=0, sum_g=0, sum_b=0;
    for(long i =  radius; i < (height-radius); i++) {
        for(long j =  radius; j < (width-radius); j++) {
            sum_r=0;
            sum_g=0;
            sum_b=0;
            
            for(long iy=(i-radius);iy<=(i+radius);iy++){
                for(long jx=(j-radius);jx<=(j+radius);jx++){
                    sum_r+=tab_image[iy][jx].r;
                    sum_g+=tab_image[iy][jx].g;
                    sum_b+=tab_image[iy][jx].b;
                }
            }
            long n=((radius*2+1)*(radius*2+1));
            tab_image2[i][j].r=(sum_r/n);// Red
            tab_image2[i][j].g=(sum_g/n);// Green
            tab_image2[i][j].b=(sum_b/n);// Blue
        }
    }
    return tab_image2;
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
    vector<vector<pixel_rgb>> tab_image2;
       
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
                    sum_r+=tab_image[iy][jx].r*ker[y_ker][x_ker];
                    sum_g+=tab_image[iy][jx].g*ker[y_ker][x_ker];
                    sum_b+=tab_image[iy][jx].b*ker[y_ker][x_ker];
                    x_ker++;
                    tmpW += ker[y_ker][x_ker];
                }y_ker++;
            }
            //long n=((radius*2+1)*(radius*2+1));
            sum_r=floor(sum_r);
            sum_r=floor(sum_g);
            sum_r=floor(sum_b);
            tab_image2[i][j].r=(sum_r/tmpW);// Red
            tab_image2[i][j].g=(sum_g/tmpW);// Green
            tab_image2[i][j].b=(sum_b/tmpW);// Blue
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

    NSLog(@"koniec%d",pole.r);

}

- (IBAction) Gausse_Blure_Button:(id)sender{
    NSImage *image =[[NSImage alloc] initWithContentsOfFile:path];
    long radius=2;
    [self blur:image rad:radius blur_option:2];
    
}




- (void)applicationWillTerminate:(NSNotification *)aNotification {
}
- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

-(void)OpenImageView:(NSImage * )image{
    if (!self.imageView) {
            self.imageView = [[NSImageView alloc] initWithFrame:self.window.contentView.bounds];
            [self.imageView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            [[self.window contentView] addSubview:self.imageView];
        } else {
            // Jeśli imageView już istnieje, usuwamy poprzedni obraz
            [self.imageView setImage:nil];
        }
        
        // Ustawiamy nowy obraz
        [self.imageView setImage:image];
    
}










-(vector<vector<pixel_rgb>>)resize:(vector<vector<pixel_rgb>>)tab_image width:(int)width height:(int)height{
    tab_image.resize(height);
    for(int i=0;i<height;i++){
        tab_image[i].resize(width);
    }
    return tab_image;
}
-(vector<vector<pixel_rgb>>)n_2Dimage:(image_object)obraz{
    vector<vector<pixel_rgb>> tab_image;
    tab_image=[self resize:tab_image width:(int)obraz.width height:(int)obraz.height];
    int nn=0;
    for(int i=0;i<obraz.height;i++){
                for(int j=0;j<obraz.width;j++){
                    tab_image[i][j].r=obraz.obraz[nn].r;
                    tab_image[i][j].g=obraz.obraz[nn].g;
                    tab_image[i][j].b=obraz.obraz[nn].b;
                    tab_image[i][j].a=obraz.obraz[nn].a;
                nn++;
            }
    }
    return tab_image;
}

-(image_object)n_GL_clamp_to_border:(image_object)obraz offsetx:(int)offsetx offsety:(int)offsety{
    vector<vector<pixel_rgb>> tab_image;
    int nn=0;
    tab_image=[self n_2Dimage:obraz];
    return obraz;
    
}
-(image_object)n_BoxBlur_filter: (image_object)obraz radius:(NSInteger)radius{
    vector<vector<pixel_rgb>> tab_image;
    tab_image=[self n_2Dimage:obraz];
    long sum_r=0, sum_g=0, sum_b=0;
    int nn=0;
    for(long i =  radius; i < (obraz.height-radius); i++) {
        for(long j =  radius; j < (obraz.width-radius); j++) {
            sum_r=0;
            sum_g=0;
            sum_b=0;
            
            for(long iy=(i-radius);iy<=(i+radius);iy++){
                for(long jx=(j-radius);jx<=(j+radius);jx++){
                    sum_r+=tab_image[iy][jx].r;
                    sum_g+=tab_image[iy][jx].g;
                    sum_b+=tab_image[iy][jx].b;
                }
            }
            long n=((radius*2+1)*(radius*2+1));
            tab_image[i][j].r=(sum_r/n);// Red
            tab_image[i][j].g=(sum_g/n);// Green
            tab_image[i][j].b=(sum_b/n);// Blue
        }
    }
    nn=0;
    for(int i=0;i<obraz.height;i++){
        for(int j=0;j<obraz.width;j++){
            obraz.obraz[nn].r=tab_image[i][j].r;
            obraz.obraz[nn].g=tab_image[i][j].g;
            obraz.obraz[nn].b=tab_image[i][j].b;
            obraz.obraz[nn].a=tab_image[i][j].a;
            nn++;
        }
    }
    
    return obraz;
}

-(image_object)n_nativefilter_filter: (image_object)obraz{
    NSInteger totalPixels=obraz.width*obraz.height;
   // pixel_rgb piksl;
    for (NSInteger pixelIndex = 0; pixelIndex < totalPixels; pixelIndex++) {
        obraz.obraz[pixelIndex].r=(255-obraz.obraz[pixelIndex].r)  ;
        obraz.obraz[pixelIndex].g=(255-obraz.obraz[pixelIndex].g) ;
        obraz.obraz[pixelIndex].b=(255-obraz.obraz[pixelIndex].b) ;
        obraz.obraz[pixelIndex].a=(255-obraz.obraz[pixelIndex].a) ;
        }
    return obraz;
}
-(image_object)n_grayfilter_filter: (image_object)obraz{
    NSInteger totalPixels=obraz.width*obraz.height;
  //  pixel_rgb piksl;
    uint8_t grayscale;
    for (NSInteger pixelIndex = 0; pixelIndex < totalPixels; pixelIndex++) {
        grayscale = (obraz.obraz[pixelIndex].r * 0.3) + (obraz.obraz[pixelIndex].g* 0.59) + (obraz.obraz[pixelIndex].b * 0.11);
        obraz.obraz[pixelIndex].r=grayscale  ;
        obraz.obraz[pixelIndex].g=grayscale ;
        obraz.obraz[pixelIndex].b=grayscale ;
        obraz.obraz[pixelIndex].a=grayscale ;
        }
    return obraz;
}
- (IBAction)wyswietl:(id)sender{
    NSImage *image2 =[[NSImage alloc] initWithContentsOfFile:path];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithData:[image2 TIFFRepresentation ]];
    orginal_picture.width = [bitmapRep pixelsWide];
    orginal_picture.height = [bitmapRep pixelsHigh];
    orginal_picture.rowBytes = [bitmapRep bytesPerRow];
    unsigned char *pixels = [bitmapRep bitmapData];
    NSDate *startTime = [NSDate date];
    NSInteger totalPixels = orginal_picture.width * orginal_picture.height;
    pixel_rgb piksl;
    for (NSInteger pixelIndex = 0; pixelIndex < totalPixels; pixelIndex++) {
        unsigned char *pixel = pixels + (pixelIndex * 4); // Dostęp do piksela
        piksl.r=pixel[0] ; // Red
        piksl.g=pixel[1] ; // Green
        piksl.b=pixel[2] ; // Blue
        piksl.a=pixel[3];
        orginal_picture.obraz.push_back(piksl);
        }
    
    image_object new_picture=orginal_picture;
 //OBSLUGA  OBRAZU
    
    if(switch_grayscale==1){
        new_picture=[self n_grayfilter_filter:new_picture];
    }
    if(switch_negative==1){
        new_picture=[self n_nativefilter_filter:new_picture];
    }
    if(switch_boxblur==1){
        NSInteger radius =5;
        new_picture=[self n_BoxBlur_filter:new_picture radius:radius];
    }
    for (NSInteger pixelIndex = 0; pixelIndex < totalPixels; pixelIndex++) {
        unsigned char *pixel = pixels + (pixelIndex * 4); // Dostęp do piksela
        pixel[0]=new_picture.obraz[pixelIndex].r; // Red
        pixel[1]=piksl.g=new_picture.obraz[pixelIndex].g ; // Greenś
        pixel[2]=piksl.b=new_picture.obraz[pixelIndex].b ; // Blue
        pixel[3]=piksl.a=new_picture.obraz[pixelIndex].a;
        }
    NSDate *endTime = [NSDate date];
    NSTimeInterval executionTime = [endTime timeIntervalSinceDate:startTime];
    NSLog(@"Czas: %f", executionTime);
    NSImage *ScaleImage = [[NSImage alloc] initWithSize:[bitmapRep size]];
      [ScaleImage addRepresentation:bitmapRep];
    [self OpenImageView:ScaleImage];
    NSLog(@"wyświetl");
}

- (void)openImageView:(NSImage *)image {
}

@end
