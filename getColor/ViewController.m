//
//  ViewController.m
//  getColor
//
//  Created by 项金鑫 on 16/6/12.
//  Copyright © 2016年 JX. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "UIImage+JXRoundIcon.h"
#import "UIImage+JXBlurPic.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UILabel *grayLevelLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *FontLabel;

@end

@implementation ViewController


static int num = 0;

#pragma mark - 获取图片某点的像素RGB颜色,转灰阶值
-(double)getColorAtLocation:(CGPoint)point inImage:(UIImage *)image
{
    
    // 定义灰阶
    double grayLevel = 0;
    
//    UIColor* color = nil;
    
    CGImageRef inImage = image.CGImage;
    
    CGContextRef contextRef = [self createRGBBitmapContextFormImage:inImage];
    
    if (contextRef == NULL) {
        
        return 0.0;
        /* error */
    }
    
    size_t w = CGImageGetWidth(inImage);  //图像宽
    
    size_t h = CGImageGetHeight(inImage);
    
    CGRect rect = {{0,0},{w,h}};
    
    CGContextDrawImage(contextRef, rect, inImage);
    
    unsigned char *data = CGBitmapContextGetData (contextRef);
    
    if (data != NULL) {
        
        int offset = 4 * ( w * round(point.y) + round(point.x) );
        
//        int alpha =  data[offset];
        
        int red = data[offset + 1];
        
        int green = data[offset + 2];
        
        int blue = data[offset + 3];
        
//        NSLog(@"offset: %i colors: RGB : %i %i %i %i",offset,red,green,blue,alpha);
        
        //定义YUV模式下的灰阶
        grayLevel = red * 0.299 + green * 0.587 + blue * 0.114;
        
//        NSLog(@"灰阶值为：%f",grayLevel);
        
        //选点的偏移量
//        NSLog(@"x:%f y:%f", point.x, point.y);
        
//        color = [UIColor colorWithRed:(red/255.0f)
//                                green:(green/255.0f)
//                                 blue:(blue/255.0f)
//                                alpha:(alpha/255.0f)];
    }
    
    CGContextRelease(contextRef);
    
    if (data) free(data);
    
    return grayLevel;
 
}


#pragma mark - 创建RGB信息
-(CGContextRef)createRGBBitmapContextFormImage:(CGImageRef)image
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


#pragma mark - 每次touch，从plist中选择一张图片计算灰阶值
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
        
        // 显示头像图片
        UIImage *image = [UIImage imageWithData:imageData];
        
        self.imageView.image = [UIImage createRoundIconWithImage:image border:0.5 borderColor:[UIColor blackColor]];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // 显示背景图片
        CGFloat blurRadius = 200;
        NSUInteger interation = 10;
        UIColor *tintColor = [UIColor grayColor];
        UIImage *blurredImage = [image blurredImageWithRadius:blurRadius iterations:interation tintColor:tintColor];
        self.backgroundImageView.image = blurredImage;
//        self.backgroundImageView.image = [[UIImage alloc] blurredImageWithRadius:blurRadius iterations:interation tintColor:tintColor];
//        self.backgroundImageView.backgroundColor = [UIColor grayColor];
        
        // 得到image的尺寸
        CGSize imageSize = image.size;
        
        NSLog(@"image width: %f",imageSize.width);
        NSLog(@"image width: %f",imageSize.height);
        
        const double interval = 0.1;
        // 设置8个位置坐标
        CGPoint leftTopPoint = CGPointMake(imageSize.width * interval, imageSize.height * interval);                    // 取左上
        CGPoint topPoint = CGPointMake(imageSize.width * 0.5, imageSize.height * interval);                             // 取上
        CGPoint rightTopPoint = CGPointMake(imageSize.width * (1 - interval), imageSize.height * interval);             // 取右上
        CGPoint rightPoint = CGPointMake(imageSize.width * (1 - interval), imageSize.height * 0.5);                     // 取右
        CGPoint rightDownPoint = CGPointMake(imageSize.width * (1 - interval), imageSize.height * (1 - interval));      // 取右下
        CGPoint downPoint = CGPointMake(imageSize.width * 0.5, imageSize.height * (1 - interval));                      // 取下
        CGPoint leftDownPoint = CGPointMake(imageSize.width * interval, imageSize.height * (1 - interval));             // 取左下
        CGPoint leftPoint = CGPointMake(imageSize.width * interval, imageSize.height * 0.5);                            // 取左
  
        // 得到8个位置灰阶值
        double leftTopPointColor = [self getColorAtLocation:leftTopPoint inImage:image];
        double topPointColor = [self getColorAtLocation:topPoint inImage:image];
        double rightTopPointColor = [self getColorAtLocation:rightTopPoint inImage:image];
        double rightPointColor = [self getColorAtLocation:rightPoint inImage:image];
        double rightDownPointColor = [self getColorAtLocation:rightDownPoint inImage:image];
        double downPointColor = [self getColorAtLocation:downPoint inImage:image];
        double leftDownPointColor = [self getColorAtLocation:leftDownPoint inImage:image];
        double eftPointColor = [self getColorAtLocation:leftPoint inImage:image];
        
        // 平均灰阶值
        double grayLevel = ( leftTopPointColor + topPointColor + rightTopPointColor + rightPointColor +
                            rightDownPointColor + downPointColor + leftDownPointColor + eftPointColor ) / 8.0;
        
        // 显示灰阶值
        if (num >= 0) {
            
            self.textLabel.hidden = NO;
            self.FontLabel.hidden = NO;
            
            self.grayLevelLabel.text = [NSString stringWithFormat:@"%f",grayLevel];
            
            self.grayLevelLabel.numberOfLines = 0;
            
            NSLog(@"%f",grayLevel);
        }
        
        num++;
        
        NSLog(@"%@", picUrlString);
    }
    
    
    
    
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
