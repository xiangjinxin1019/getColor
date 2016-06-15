//
//  UIImage+JXBlurPic.h
//  getColor
//
//  Created by 项金鑫 on 16/6/15.
//  Copyright © 2016年 JX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JXBlurPic)

-(UIImage *) blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end
