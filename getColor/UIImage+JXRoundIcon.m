//
//  UIImage+JXRoundIcon.m
//  getColor
//
//  Created by 项金鑫 on 16/6/15.
//  Copyright © 2016年 JX. All rights reserved.
//

#import "UIImage+JXRoundIcon.h"

@implementation UIImage (JXRoundIcon)

+(instancetype)createRoundIconWithImage:(UIImage *)image border:(int)border borderColor:(UIColor *)color
{

    CGSize size = CGSizeMake(image.size.width + border, image.size.height + border);
    
    //创建图片上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    //绘制边框的圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
    [color set ];
    CGContextFillPath(context);
    
    //设置头像frame
    CGFloat iconX = border / 2;
    CGFloat iconY = border / 2;
    CGFloat iconW = size.width;
    CGFloat iconH = size.height;
    
    //绘制圆形头像范围
    CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
    
    //剪切可视范围
    CGContextClip(context);
    
    //绘制头像
    [image drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    
    //取出整个图片上下文的图片
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return iconImage;
}

@end
