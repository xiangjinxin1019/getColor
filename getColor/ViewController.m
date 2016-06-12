//
//  ViewController.m
//  getColor
//
//  Created by 项金鑫 on 16/6/12.
//  Copyright © 2016年 JX. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController


#pragma mark - 获取图片某点的像素颜色
-(UIColor *)getColorAtLocation:(CGPoint)point inImage:(UIImage *)image
{
    
    UIColor* color = nil;
    
    CGImageRef inImage = image.CGImage;
    
    CGContextRef contextRef = [self createRBGBitmapContextFormImage:inImage];
    
    if (contextRef == NULL) {
        
        return nil;
        /* error */
    }
    
    size_t w = CGImageGetWidth(inImage);  //图像宽
    
    size_t h = CGImageGetHeight(inImage);
    
    CGRect rect = {{0,0},{w,h}};
    
    CGContextDrawImage(contextRef, rect, inImage);
    
    unsigned char* data = CGBitmapContextGetData (contextRef);
    
    if (data != NULL) {
        
        int offset = 4 * ( w * round(point.y) + round(point.x) );
        
        int alpha =  data[offset];
        
        int red = data[offset+1];
        
        int green = data[offset+2];
        
        int blue = data[offset+3];
        
        NSLog(@"offset: %i colors: RGB : %i %i %i %i",offset,red,green,blue,alpha);
        
        NSLog(@"x:%f y:%f", point.x, point.y);
        
        color = [UIColor colorWithRed:(red/255.0f)
                                green:(green/255.0f)
                                 blue:(blue/255.0f)
                                alpha:(alpha/255.0f)];
    }
    
    CGContextRelease(contextRef);
    
    if (data) free(data);
    
    return color;
 
}


#pragma mark - 创建RGB信息
-(CGContextRef)createRBGBitmapContextFormImage:(CGImageRef)image
{
    CGContextRef context = NULL;
    
    CGColorSpaceRef colorSpace;
    
    void *bitmapData;
    
    int bitmapByteCount;
    
    int bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(image);  // 图像宽
    
    size_t pixelsHigh = CGImageGetHeight(image);
    
    bitmapBytesPerRow = (int)(pixelsWide * 4);
    
    bitmapByteCount = (int)(bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
        
    {
        
        fprintf(stderr, "Error allocating color space\n");
        
        return NULL;
        
    }
    
    bitmapData = malloc( bitmapByteCount );
    
    if (bitmapData == NULL)
        
    {
        
        fprintf (stderr, "Memory not allocated!");
        
        CGColorSpaceRelease( colorSpace );
        
        return NULL;
        
    }
    
    context = CGBitmapContextCreate (bitmapData,
                                     
                                     pixelsWide,
                                     
                                     pixelsHigh,
                                     
                                     8,      
                                     
                                     bitmapBytesPerRow,
                                     
                                     colorSpace,
                                     
                                     kCGImageAlphaPremultipliedFirst);
    
    if (context == NULL)
        
    {
        
        free (bitmapData);
        
        fprintf (stderr, "Context not created!");
        
    }
    
    CGColorSpaceRelease( colorSpace );
    
    return context;
    
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://d.hiphotos.baidu.com/zhidao/pic/item/0b55b319ebc4b745404d7870cffc1e178b8215fe.jpg"];
    
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.imageView.image = image;

    
    CGPoint point = CGPointMake(150, 50);
    
    UIColor *color = [self getColorAtLocation:point inImage:image];
    
    NSLog(@"%@",color);
    
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
