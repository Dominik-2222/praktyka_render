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
    IBOutlet NSImageView *imageView;

    }
@property (nonatomic, strong) NSImageView *imageView;

- (void)openImageView:(NSImage *)image;
typedef struct pixel_rgb{
    vector<uint8_t> r;
    vector<uint8_t> g;
    vector<uint8_t> b;
    vector<uint8_t> a;
}pixel_rgb;

@end

//odczyt piksela po wspolzednych:    pole=[self piksel_kol:tab_image width:width height:height map:pixels rowBytes:rowBytes radius:radius x_axis:62.4 y_axis:38.2 tab:0];

