//
//  PPProgressView.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 3/10/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PPProgressViewStyleSmall = 0,
    PPProgressViewStyleMiddle,
    PPProgressViewStyleBig,
} PPProgressViewStyle;

typedef enum : NSUInteger {
    PPProgressViewIconTele = 0,
    PPProgressViewIconSummon,
    PPProgressViewIconHypno,
    PPProgressViewIconChaos,
} PPProgressViewIcon;

IB_DESIGNABLE
@interface PPProgressBarView : UIView

@property (nonatomic) CGFloat progress;
@property (nonatomic) IBInspectable BOOL withIcon; // only for PPProgressViewStyleSmall

#if TARGET_INTERFACE_BUILDER

@property (nonatomic, assign) IBInspectable NSInteger style;
@property (nonatomic, assign) IBInspectable NSInteger icon;

#else

@property (nonatomic, assign) PPProgressViewStyle style;
@property (nonatomic, assign) PPProgressViewIcon icon;

#endif

- (void)setProgress:(CGFloat)progress
           animated:(BOOL)anAnimated
           duration:(CGFloat)duration;



@end
