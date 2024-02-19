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
#include <thread>
using namespace std;
#define RGBA(i) (i).r,(i).g,(i).b,(i).a


@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

bool switch_grayscale=0,switch_negative=0,switch_boxblur=0,switch_gaussian_blur=0,switch_gauss_2_przebiegi=0,switch_kawasaki_blur=0, switch_GL_repeat=0,switch_GL_Mirrored_repeat=0, switch_GL_clamp_to_edge=0, switch_gl_clamp_to_border=0;

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
-(IBAction)switch__gauss_2_przebiegi:(id)sender{
    switch_gauss_2_przebiegi=!switch_gauss_2_przebiegi;
    NSLog(@"%d",switch_gauss_2_przebiegi);
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
-(pixel_rgb)change_rgba:(pixel_rgb)piksel_org r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a{
    pixel_rgb piksel;
    piksel.r=r;
    piksel.g=g;
    piksel.b=b;
    piksel.a=a;
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

// Poprawiona funkcja tworzenia jądra rozmycia gaussowskiego


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
//--gausse blur

- (vector<vector<double>>)createGaussianBlurKernel:(int)radius {
    int size = radius * 2 + 1;
    vector<vector<double>> kernel(size, vector<double>(size));
    double sigma = radius / 2.0;
    double sum = 0.0;

    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            int x = i - radius;
            int y = j - radius;
            double exponent = -(x * x + y * y) / (2 * sigma * sigma);
            kernel[i][j] = (exp(exponent) / (2 * M_PI * sigma * sigma));
            sum += kernel[i][j];
        }
    }
    // Normalizacja
    for (int i = 0; i < size; ++i) {
        for (int j = 0; j < size; ++j) {
            kernel[i][j] /= sum;
        }
    }
    return kernel;
}
-(image_object)Gausse_Blur:(image_object)obraz width:(NSInteger)width height:(NSInteger)height radius:(NSInteger)radius {
    vector<vector<double>> kernel = [self createGaussianBlurKernel:(int)radius];
    vector<vector<pixel_rgb>> tab_image2(height, vector<pixel_rgb>(width));
    tab_image2=[self n_2Dimage:obraz];
    vector<vector<pixel_rgb>>  tab_image=[self n_2Dimage:obraz];
    
    
    
    for (long i = radius; i < height - radius; i++) {
        for (long j = radius; j < width - radius; j++) {
            double sum_r = 0, sum_g = 0, sum_b = 0, tmpW = 0;
            for (long iy = i - radius, y_ker = 0; iy <= i + radius; iy++, y_ker++) {
                for (long jx = j - radius, x_ker = 0; jx <= j + radius; jx++, x_ker++) {
                    sum_r += tab_image[iy][jx].r * kernel[y_ker][x_ker];
                    sum_g += tab_image[iy][jx].g * kernel[y_ker][x_ker];
                    sum_b += tab_image[iy][jx].b * kernel[y_ker][x_ker];
                    tmpW += kernel[y_ker][x_ker];
                }
            }
            tab_image2[i][j]=[self change_rgba:tab_image2[i][j] r:floor(sum_r / tmpW) g:floor(sum_g / tmpW) b:floor(sum_b / tmpW) a:tab_image[i][j].a];
        }
    }
    int   nn=0;
    image_object new_image;
      for(int i=0;i<height;i++){
          for(int j=0;j<width;j++){
              new_image.obraz.push_back(tab_image2[i][j]);
              nn++;
          }
      }
    return new_image;
}
void a_kernel(vector<double>& kernel, double sigma, double radius, int i) {
    int x = i - radius;
    double exponent = -(x * x) / (2.0 * sigma);
    kernel[i] = (exp(exponent) / (2.0 * M_PI * sigma));
}

vector<double> automatic_kernel_1D(int radius) {
    int size = radius *  2 +  1;
    vector<double> kernel;
    double sigma = radius /  2.0;
    double sum =  0.0;
    kernel.resize(size);

    vector<thread*> wektorWatkow;

    for(int i =  0; i < size; i++) {
        thread *watek = new thread(a_kernel, ref(kernel), sigma, radius, i);
        wektorWatkow.push_back(watek);
    }

    for(int i =  0; i < size; i++) {
        wektorWatkow[i]->join();
        delete wektorWatkow[i];
        sum += kernel[i];
    }

    for(int i =  0; i < size; i++) {
        kernel[i] /= sum;
    }

    return kernel;
}
//vector<double> Kernel_1D (int radius){
//    int size = radius * 2 + 1;
//    vector<double> kernel;
//    kernel.resize(size);
//    double sigma = radius / 2.0;
//    double sum = 0.0;
//    for (int i = 0; i < size; i++) {
//            int x = i - radius;
//            double exponent = -(x * x ) / (2  * sigma);
//            kernel[i] = (exp(exponent) / (2 * M_PI * sigma));
//            sum += kernel[i];
//    }
//
//    for (int i = 0; i < size; ++i) {
//        kernel[i] /= sum;
//    }
//    return kernel;
//}
const int Max_thread=16;
//void gaussethread(int radius, vector<pixel_rgb> &strefa, vector<double>kernel) {
//    int size = radius *  2 +  1;
//    vector<thread*> wektorWatkow;
//
//        double sum_r = 0, sum_g = 0, sum_b = 0, tmpW = 0;
//        for(int kk=0;kk<size;kk++){
//            sum_r +=  strefa[kk].r * kernel[kk];
//            sum_g += strefa[kk].g * kernel[kk];
//            sum_b += strefa[kk].b * kernel[kk];
//            tmpW += kernel[kk];
//        }
//        strefa[(radius+1)].r=floor(sum_r/tmpW);
//        strefa[(radius+1)].g=floor(sum_g/tmpW);
//        strefa[(radius+1)].b=floor(sum_b/tmpW);
//}

void change_row (vector<pixel_rgb>&tab_image,int width, int radius,vector<double>kernel){
    vector<pixel_rgb>new_tab;
    new_tab=tab_image;
        double sum_r = 0, sum_g = 0, sum_b = 0, tmpW = 0;
    for (long j = radius; j <width - radius ; j++) {//x
        for(int ker=0;ker<(radius*2+1);ker++){
            sum_r += tab_image[j+ker].r * kernel[ker];
            sum_g += tab_image[j+ker].g * kernel[ker];
            sum_b += tab_image[j+ker].b * kernel[ker];
            tmpW += kernel[ker];}
        new_tab[j+radius+1].r=floor(sum_r/tmpW);
        
    new_tab[j+radius+1].g=floor(sum_r/tmpW);
        
    new_tab[j+radius+1].b=floor(sum_r/tmpW);
    }
    tab_image=new_tab;
    
    
}
void Gausse_zone_generator (vector<vector<pixel_rgb>> &image_map, int width,int height,int radius,vector<double>kernel){
//podzial mapy na strefy

    for (long i = radius; i <height - radius ; i++) {//y
        change_row(image_map[i],width,radius,kernel);
        
    }
}

-(image_object)Gausse_Blur_2_thread:(image_object)obraz width:(NSInteger)width height:(NSInteger)height radius:(NSInteger)radius {
    NSDate *startTime = [NSDate date];
        vector<double> kernel = automatic_kernel_1D((int)radius);
    vector<vector<pixel_rgb>> tab_image2(height, vector<pixel_rgb>(width));
    tab_image2=[self n_2Dimage:obraz];
    vector<vector<pixel_rgb>>  tab_image=[self n_2Dimage:obraz];
  
//
//    for (long i = radius; i <width - radius ; i++) {//y
//        for (long j = radius; j <height - radius ; j++) {//x
//            double sum_r = 0, sum_g = 0, sum_b = 0, tmpW = 0;
//                for (long jx = j - radius, x_ker = 0; jx <= j + radius; jx++, x_ker++) {
//                    sum_r += tab_image[jx][i].r * kernel[x_ker];
//                    sum_g += tab_image[jx][i].g * kernel[x_ker];
//                    sum_b += tab_image[jx][i].b * kernel[x_ker];
//                    tmpW += kernel[x_ker];
//                }
//            tab_image2[j][i]=[self change_rgba:tab_image2[j][i] r:floor(sum_r / tmpW) g:floor(sum_g / tmpW) b:floor(sum_b / tmpW) a:tab_image[j][i].a];
//        }
//    }
//    
    
    
    tab_image=tab_image2;
    for (long i = radius; i < height - radius; i++) {
        Gausse_zone_generator(tab_image, (int)width, (int)height, (int)radius, kernel);
    }
    tab_image2=tab_image;
  
    
    
    image_object new_image;
    int nn=0;
    for(int i=0;i<height;i++){
          for(int j=0;j<width;j++){
              new_image.obraz.push_back(tab_image2[i][j]);
              nn++;
          }
      }
    NSDate *endTime = [NSDate date];
    NSTimeInterval executionTime = [endTime timeIntervalSinceDate:startTime];
    NSLog(@"Czas_2_gausse_blur: %f", executionTime);
    return new_image;

}

-(image_object)Gausse_Blur_2:(image_object)obraz width:(NSInteger)width height:(NSInteger)height radius:(NSInteger)radius {
    NSDate *startTime = [NSDate date];
        vector<double> kernel = automatic_kernel_1D((int)radius);
    vector<vector<pixel_rgb>> tab_image2(height, vector<pixel_rgb>(width));
    tab_image2=[self n_2Dimage:obraz];
    vector<vector<pixel_rgb>>  tab_image=[self n_2Dimage:obraz];
 
    for (long i = radius; i <width - radius ; i++) {
        for (long j = radius; j <height - radius ; j++) {
            double sum_r = 0, sum_g = 0, sum_b = 0, tmpW = 0;
                for (long jx = j - radius, x_ker = 0; jx <= j + radius; jx++, x_ker++) {
                    sum_r += tab_image[jx][i].r * kernel[x_ker];
                    sum_g += tab_image[jx][i].g * kernel[x_ker];
                    sum_b += tab_image[jx][i].b * kernel[x_ker];
                    tmpW += kernel[x_ker];
                }
            tab_image2[j][i]=[self change_rgba:tab_image2[j][i] r:floor(sum_r / tmpW) g:floor(sum_g / tmpW) b:floor(sum_b / tmpW) a:tab_image[j][i].a];
        }
    }
    
    tab_image=tab_image2;
    for (long i = radius; i < height - radius; i++) {
        for (long j = radius; j <width - radius ; j++) {
            double sum_r = 0, sum_g = 0, sum_b = 0, tmpW = 0;
                for (long jx = j - radius, x_ker = 0; jx <= j + radius; jx++, x_ker++) {
                    sum_r += tab_image[i][jx].r * kernel[x_ker];
                    sum_g += tab_image[i][jx].g * kernel[x_ker];
                    sum_b += tab_image[i][jx].b * kernel[x_ker];
                    tmpW += kernel[x_ker];
                }
            tab_image2[i][j]=[self change_rgba:tab_image2[i][j] r:floor(sum_r / tmpW) g:floor(sum_g / tmpW) b:floor(sum_b / tmpW) a:tab_image[i][j].a];
        }
    }
    image_object new_image;
    int nn=0;
    for(int i=0;i<height;i++){
          for(int j=0;j<width;j++){
              new_image.obraz.push_back(tab_image2[i][j]);
              nn++;
          }
      }
    NSDate *endTime = [NSDate date];
    NSTimeInterval executionTime = [endTime timeIntervalSinceDate:startTime];
    NSLog(@"Czas_2_gausse_blur: %f", executionTime);
    return new_image;

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
void resize2DVector(vector<vector<pixel_rgb>>& vec, int newHeight, int newWidth) {
    vec.resize(newHeight);
    // Zmiana szerokości każdego wiersza
    for (auto& row : vec) {
        row.resize(newWidth);
    }
}
-(image_object)n_GL_clamp_to_border:(image_object)obraz offsetx:(int)offsetx offsety:(int)offsety{
    vector<vector<pixel_rgb>> tab_image;//orginalny obraz
    vector<vector<pixel_rgb>> tab_image2;
    image_object new_image;
    tab_image=[self n_2Dimage:obraz];
   resize2DVector(tab_image2, (int)(obraz.height+(2*offsety)), (int)(obraz.width+(2*offsetx)));
    pixel_rgb piksel;
    int ii=0,jj=0;
    piksel=[self change_rgba:piksel r:255 g:255 b:255 a:255];
    for(int i=0;i<(tab_image2.size());i++){
        for(int j=0;j<(tab_image2[i].size());j++){
            tab_image2[i][j]=piksel;
        }}
    for(int i=offsety;i<(tab_image2.size()-offsety);i++){
        for(int j=offsetx;j<(tab_image2[i].size()-offsetx);j++){
            tab_image2[i][j]=tab_image[ii][jj];
        }jj++;
        ii++;
    }
        for(int i=0;i<(tab_image2.size());i++){
            for(int j=0;j<(tab_image2[i].size());j++){
                piksel=tab_image2[i][j];
                new_image.obraz.push_back(piksel);
            }}
        new_image.width=(new_image.width+offsetx*2);
        new_image.height=(new_image.width+offsety*2);
      int   nn=0;
        for(int i=0;i<new_image.height;i++){
            for(int j=0;j<new_image.width;j++){
                new_image.obraz[nn]=tab_image2[i][j];
                nn++;
            }
        }
    return new_image;
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
        obraz.obraz[pixelIndex]=[self change_rgba:obraz.obraz[pixelIndex] r:grayscale g:grayscale b:grayscale a:grayscale];
        }
    return obraz;
}

pixel_rgb interpolacja(vector<vector<pixel_rgb>> map, double x, double y) {
    pixel_rgb piksel;
    int x_left = floor(x); // w dol
    int x_right = ceil(x); // w gore
    int y_g = ceil(y);
    int y_d = floor(y);

    piksel.r = (uint8_t)((1 - (x - x_left)) * (1 - (y - y_d)) * map[x_left][y_d].r +
                         (x - x_left) * (1 - (y - y_d)) * map[x_right][y_d].r +
                         (1 - (x - x_left)) * (y - y_d) * map[x_left][y_g].r +
                         (x - x_left) * (y - y_d) * map[x_right][y_g].r);

    piksel.g = (uint8_t)((1 - (x - x_left)) * (1 - (y - y_d)) * map[x_left][y_d].g +
                         (x - x_left) * (1 - (y - y_d)) * map[x_right][y_d].g +
                         (1 - (x - x_left)) * (y - y_d) * map[x_left][y_g].g +
                         (x - x_left) * (y - y_d) * map[x_right][y_g].g);

    piksel.b = (uint8_t)((1 - (x - x_left)) * (1 - (y - y_d)) * map[x_left][y_d].b +
                         (x - x_left) * (1 - (y - y_d)) * map[x_right][y_d].b +
                         (1 - (x - x_left)) * (y - y_d) * map[x_left][y_g].b +
                         (x - x_left) * (y - y_d) * map[x_right][y_g].b);
    piksel.a = map[x_left][y_d].a;
    return piksel;
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
    NSInteger radius=10;
    if(switch_grayscale==1){
        new_picture=[self n_grayfilter_filter:new_picture];
    }
    if(switch_negative==1){
        new_picture=[self n_nativefilter_filter:new_picture];
    }
    if(switch_boxblur==1){
        new_picture=[self n_BoxBlur_filter:new_picture radius:radius];
    }
    if(switch_gl_clamp_to_border==1){
        NSInteger offsetx=100,offsety=100;
        new_picture=[self n_GL_clamp_to_border:new_picture offsetx:(int)offsetx offsety:(int)offsety];
    
    }
    if(switch_gaussian_blur==1){
        
        new_picture=[self Gausse_Blur:new_picture width:new_picture.width height:new_picture.height radius:radius];
    }
    if(switch_gauss_2_przebiegi==1){
        new_picture=[self Gausse_Blur_2_thread:new_picture width:new_picture.width height:new_picture.height radius:radius];
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



@end
