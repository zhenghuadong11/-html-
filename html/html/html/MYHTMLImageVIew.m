//
//  MYHTMLImageVIew.m
//  HTML排版
//
//  Created by apple on 17/4/13.
//  Copyright © 2017年 zhenghuadong. All rights reserved.
//

#import "MYHTMLImageVIew.h"
#define Mask8(x) ( (x) & 0xFF)
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )
@implementation MYHTMLImageVIew

-(instancetype)init{
    if (self = [super init]) {
        self.isGray = false;
    }
    return self;
}



- (UIImage *)processUsingPixels:(UIImage *)image{
    
    //1.获得图片的像素 以及上下文
    UInt32 *inputPixels;
    CGImageRef inputCGImage = [image CGImage];
    size_t w = CGImageGetWidth(inputCGImage);
    size_t h = CGImageGetHeight(inputCGImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSInteger bytesPerPixel = 4;//每个像素的字节数
    NSInteger bitsPerComponent = 8;//每个组成像素的 位深
    NSInteger bitmapBytesPerRow = w * bytesPerPixel;//每行字节数
    
    inputPixels = (UInt32 *)calloc(w * h , sizeof(UInt32));//通过calloc开辟一段连续的内存空间
    
    CGContextRef context = CGBitmapContextCreate(inputPixels, w, h, bitsPerComponent, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), inputCGImage);
    
    
    //2操作像素
    for (NSInteger j = 0; j < h; j ++) {
        for (NSInteger i = 0 ; i < w; i ++) {
            UInt32 *currentPixel = inputPixels + (w * j) + i;
            UInt32 color = *currentPixel;
            
            //灰度图（举例）
            UInt32 averageColor = (R(color) + G(color) + B(color)) / 3.0;
            *currentPixel = RGBAMake(averageColor, averageColor, averageColor, A(color));
            
        }
    }
    
    //3从上下文中取出
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //4释放
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(inputPixels);
    
    return newImage;
}

-(void)drawRect:(CGRect)rect{
    
    
    CGRect bounce = rect;
    bounce.origin = CGPointZero;
    if (self.image != nil) {
        UIImage * newImage;
        if (self.isGray == true) {
            newImage = [self processUsingPixels:self.image];
        }else{
            newImage = self.image;
        }
        
        [newImage drawInRect:bounce];
    }
}

@end
