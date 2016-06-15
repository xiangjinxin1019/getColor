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


static int num = 0;

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
        
        //定义YUV模式下的灰阶
        int grayLevel = red * 0.299 + green * 0.587 + blue * 0.114;
        NSLog(@"灰阶值为：%d",grayLevel);
        
        //选点的偏移量
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
  
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    // plist中url数组
    NSArray *picUrlArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picUrl.plist" ofType:nil]];
    
    int totalNum = (int)picUrlArray.count;   // plist中url总数

    
    if (num < totalNum) {
        
        // 取url
        NSString *picUrlString = picUrlArray[num];
        
        NSURL *picUrl = [NSURL URLWithString:picUrlString];
        
        NSData *imageData = [NSData dataWithContentsOfURL:picUrl];
        
        UIImage *image = [UIImage imageWithData:imageData]; // 显示图片
        
        self.imageView.image = image;
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // 得到image的尺寸
        CGSize imageSize = image.size;
        
//        NSLog(@"image尺寸 | 宽：%f",imageSize.width);
//        NSLog(@"image尺寸 | 高：%f",imageSize.height);
        
        // 设置位置坐标
        CGPoint leftTopPoint = CGPointMake(imageSize.width * 0.1, imageSize.height * 0.1);      // 取左上
        CGPoint topPoint = CGPointMake(imageSize.width * 0.5, imageSize.height * 0.1);          // 取上
        CGPoint rightTopPoint = CGPointMake(imageSize.width * 0.9, imageSize.height * 0.1);     // 取右上
        CGPoint rightPoint = CGPointMake(imageSize.width * 0.9, imageSize.height * 0.5);        // 取右
        CGPoint rightDownPoint = CGPointMake(imageSize.width * 0.9, imageSize.height * 0.9);    // 取右下
        CGPoint downPoint = CGPointMake(imageSize.width * 0.5, imageSize.height * 0.9);         // 取下
        CGPoint leftDownPoint = CGPointMake(imageSize.width * 0.1, imageSize.height * 0.9);     // 取左下
        CGPoint leftPoint = CGPointMake(imageSize.width * 0.1, imageSize.height * 0.5);         // 取左
        

//        NSLog(@"leftTopPoint | 宽:%f",imageSize.width * 0.1);
//        NSLog(@"leftTopPoint | 高:%f",imageSize.height * 0.1);
//        
       
        // 得到颜色
        UIColor *leftTopPointColor = [self getColorAtLocation:leftTopPoint inImage:image];
        UIColor *topPointColor = [self getColorAtLocation:topPoint inImage:image];
        UIColor *rightTopPointColor = [self getColorAtLocation:rightTopPoint inImage:image];
        UIColor *rightPointColor = [self getColorAtLocation:rightPoint inImage:image];
        UIColor *rightDownPointColor = [self getColorAtLocation:rightDownPoint inImage:image];
        UIColor *downPointColor = [self getColorAtLocation:downPoint inImage:image];
        UIColor *leftDownPointColor = [self getColorAtLocation:leftDownPoint inImage:image];
        UIColor *leftPointColor = [self getColorAtLocation:leftPoint inImage:image];
        
        
        
//        NSLog(@"%@",color);
        
        num++;
        
        NSLog(@"%@", picUrlString);
    }
    
    
    
    
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
