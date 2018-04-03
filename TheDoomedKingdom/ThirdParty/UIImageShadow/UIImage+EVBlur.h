//
//  UIImage+EVBlur.h
//  Zippany
//
//  Created by Pavel Stoma on 6/02/17.
//  Copyright © 2017 EV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (EVBlur)

/**
 Screen shot from view.
 */
+ (UIImage *)imageFromView:(UIView *)theView withSize:(CGSize)size;

/**
 Blur image
 */
- (UIImage *)blurImageWithRadius:(CGFloat)radius
                      iterations:(NSUInteger)iterations
                       tintColor:(UIColor *)tintColor;

@end
