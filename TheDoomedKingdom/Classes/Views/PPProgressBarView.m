//
//  PPProgressView.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 3/10/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPProgressBarView.h"

#define PPBgImageViewTag 334
#define PPIconLayerTag 335
#define PPProgressLayerTag 336

#define PPSmallProgressInset UIEdgeInsetsMake(6., 9., 6., 9.)
#define PPMiddleProgressInset UIEdgeInsetsMake(12., 34., 12., 34.)
#define PPBigProgressInset UIEdgeInsetsMake(22., 60., 22., 60.)

#define PPSmallIconSize 32.f



@implementation PPProgressBarView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)configureIcon
{
    UIImageView *bgImageView = [self viewWithTag:PPBgImageViewTag];
    
    if (self.withIcon && bgImageView) {
        NSString *imageName = nil;
        
        switch (self.icon) {
            case PPProgressViewIconHypno:
                imageName = @"HypnoPBIcon.png";
                break;
                
            case PPProgressViewIconSummon:
                imageName = @"SummonPBIcon.png";
                break;
                
            case PPProgressViewIconChaos:
                imageName = @"ChaosPBIcon.png";
                break;
                
            case PPProgressViewIconTele:
                imageName = @"TelePBIcon.png";
                break;
                
            default:
                break;
        }
        
        CALayer *iconLayer = nil;
        
        for (CALayer *layer in [bgImageView.layer sublayers]) {
            NSInteger tag = [[layer valueForKey:@"tag"] integerValue];
            
            if (tag == PPIconLayerTag) {
                iconLayer = layer;
                break;
            }
        }
        
        if (!iconLayer) {
            iconLayer = [CALayer new];
            iconLayer.backgroundColor = [UIColor clearColor].CGColor;
            [iconLayer setValue:@(PPIconLayerTag) forKey:@"tag"];
            iconLayer.frame = CGRectMake(-PPSmallIconSize / 2., (bgImageView.frame.size.height - PPSmallIconSize) / 2., PPSmallIconSize, PPSmallIconSize);
            [bgImageView.layer addSublayer:iconLayer];
        }
        
        UIImage *iconImage = [UIImage imageNamed:imageName];
        
        iconLayer.contents = (__bridge id _Nullable)(iconImage.CGImage);
    }
}
- (void)setProgress:(CGFloat)progress
           animated:(BOOL)anAnimated
           duration:(CGFloat)duration
{
    _progress = progress;
    
    UIImageView *bgImageView = [self viewWithTag:PPBgImageViewTag];
    
    if (bgImageView) {
        UIImageView *progressLayerView = nil;
        
        for (UIView *view in [bgImageView subviews]) {
            if (view.tag == PPProgressLayerTag) {
                progressLayerView = (UIImageView *)view;
                break;
            }
        }
        
        UIEdgeInsets inset = UIEdgeInsetsZero;
        
        switch (self.style) {
            case PPProgressViewStyleSmall: {
                inset = PPSmallProgressInset;
                break;
            }
            case PPProgressViewStyleMiddle: {
                inset = PPMiddleProgressInset;
                break;
            }
            case PPProgressViewStyleBig:
                inset = PPBigProgressInset;
                break;
                
            default:
                break;
        }
        
        if (progressLayerView) {
            CGRect elementFrame = [bgImageView.layer bounds];
            CGRect finalFrame = CGRectMake(inset.left, inset.top, (elementFrame.size.width - inset.left - inset.right) * progress, elementFrame.size.height - inset.top - inset.bottom);
            
            [UIView animateWithDuration:anAnimated ? duration : 0. delay:0. options:UIViewAnimationOptionCurveLinear animations:^{
                progressLayerView.frame = finalFrame;
            } completion:nil];
        }
    }
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)anAnimated
{
    [self setProgress:progress animated:anAnimated duration:0.5];
}


- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)configureProgress
{
    UIImageView *bgImageView = [self viewWithTag:PPBgImageViewTag];
    
    if (bgImageView) {
        UIImageView *progressLayerView = nil;
        UIImage *image = nil;
        UIEdgeInsets inset = UIEdgeInsetsZero;
        
        switch (self.style) {
            case PPProgressViewStyleSmall: {
                image = [[UIImage imageNamed:@"PBSmallProgress.png"] stretchableImageWithLeftCapWidth:5. topCapHeight:7.5];
                inset = PPSmallProgressInset;
                
                [self configureIcon];
                break;
            }
                
            case PPProgressViewStyleMiddle: {
                image = [[UIImage imageNamed:@"PBMiddleProgress.png"] stretchableImageWithLeftCapWidth:5. topCapHeight:22.];
                inset = PPMiddleProgressInset;
                break;
            }
                
            case PPProgressViewStyleBig:
                image = [[UIImage imageNamed:@"PBBigProgress.png"] stretchableImageWithLeftCapWidth:5. topCapHeight:40.];
                inset = PPBigProgressInset;
                break;
                
            default:
                break;
        }
        
        for (UIView *view in [bgImageView subviews]) {
            if (view.tag == PPProgressLayerTag) {
                progressLayerView = (UIImageView *)view;
                break;
            }
        }
        
        if (!progressLayerView) {
            progressLayerView = [UIImageView new];
            progressLayerView.backgroundColor = [UIColor clearColor];
            progressLayerView.tag = PPProgressLayerTag;
            
            [bgImageView addSubview:progressLayerView];
        }
        
        CGRect elementFrame = [bgImageView bounds];
        
        progressLayerView.frame = CGRectMake(inset.left, inset.top, elementFrame.size.width - inset.left - inset.right, elementFrame.size.height - inset.top - inset.bottom);
        
        [progressLayerView setImage:image];
    }
}

- (void)configureStyle
{
    UIImageView *bgImageView = [self viewWithTag:PPBgImageViewTag];
    
    if (bgImageView) {
        UIImage *image = nil;
        
        switch (self.style) {
            case PPProgressViewStyleSmall: {
                image = [[UIImage imageNamed:@"PBSmall.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:13];
                
                [self configureIcon];
                break;
            }
            
            case PPProgressViewStyleMiddle:
                image = [[UIImage imageNamed:@"PBMiddle.png"] stretchableImageWithLeftCapWidth:44 topCapHeight:35];
                break;
                
            case PPProgressViewStyleBig:
                image = [[UIImage imageNamed:@"PBBig.png"] stretchableImageWithLeftCapWidth:79 topCapHeight:52];
                break;
                
            default:
                break;
        }
        
        bgImageView.image = image;
        
        [self configureProgress];
    }
}

- (void)initialize
{
    [self setClipsToBounds:NO];
    self.backgroundColor = [UIColor clearColor];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [bgImageView setClipsToBounds:NO];
    [bgImageView setBackgroundColor:[UIColor clearColor]];
    bgImageView.tag = PPBgImageViewTag;
    [self addSubview:bgImageView];
    [bgImageView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin)];
    
    [bgImageView setContentMode:UIViewContentModeScaleToFill];
    
    [self configureStyle];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
