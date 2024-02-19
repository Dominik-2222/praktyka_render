//
//  AppDelegate.h
//  render
//
//  Created by MotionVFX on 12/02/2024.
//

#import <Cocoa/Cocoa.h>
#include <vector>
using namespace std;
@interface AppDelegate : NSObject <NSApplicationDelegate>{
    

    }
@property (nonatomic, strong) NSImageView *imageView;


typedef struct pixel_rgb{
    uint8_t r;
    uint8_t g;
    uint8_t b;
    uint8_t a;
}pixel_rgb;
typedef struct image_object{
    vector<pixel_rgb> obraz;
    NSInteger width;
    NSInteger height;
    NSInteger rowBytes;
    
}image_object;



@end

//odczyt piksela po wspolzednych:    pole=[self piksel_kol:tab_image width:width height:height map:pixels rowBytes:rowBytes radius:radius x_axis:62.4 y_axis:38.2 tab:0];

