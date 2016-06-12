//
//  ViewController.h
//  getColor
//
//  Created by 项金鑫 on 16/6/12.
//  Copyright © 2016年 JX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

-(UIColor *) getColorAtLocation:(CGPoint )point inImage:(UIImage *)image;

-(CGContextRef) createRBGBitmapContextFormImage:(CGImageRef )image;

@end

