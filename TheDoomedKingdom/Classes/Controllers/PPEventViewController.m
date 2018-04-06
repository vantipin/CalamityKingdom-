//
//  PPEventViewController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 4/3/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPEventViewController.h"
#import "PPDangerView.h"
#import "UIImage+EVBlur.h"

#define PPEventViewControllerID @"PPEventViewControllerID"

@implementation PPEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(PPDangerView *)self.view setEvent:self.event];
}

+ (instancetype)showWithEvent:(PPEvent *)event completion:(void (^)(void))completion {
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIView *closeView = [[UIView alloc] initWithFrame:main.view.bounds];
    closeView.tag = 9999;
    closeView.backgroundColor = [UIColor clearColor];
    [main.view addSubview:closeView];
    
    UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:closeView.bounds];
    blurImageView.backgroundColor = [UIColor clearColor];
    [closeView addSubview:blurImageView];
    
    CGSize screenSize = CGSizeMake(1024, 768);
    
    UIImage *image = [UIImage imageFromView:[UIApplication sharedApplication].keyWindow.rootViewController.view withSize:screenSize];
    
    UIImage *blurredImage = [image blurImageWithRadius:5. iterations:3 tintColor:[UIColor colorWithWhite:0. alpha:0.7]];
    
    [UIView animateWithDuration:0.5 animations:^{
        [blurImageView setImage:blurredImage];
    }];
    
    PPEventViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:PPEventViewControllerID];
    controller.event = event;
    [controller view];
    [controller.view setFrame:CGRectMake((1024 - PopupSize.width) / 2., (768 - PopupSize.height) / 2., PopupSize.width, PopupSize.height)];
    
    [controller.view setAlpha:0.];
    
    [closeView addSubview:controller.view];
    [controller.view setCenter:closeView.center];
    
    [UIView animateWithDuration:0.35 animations:^{
        [controller.view setAlpha:1.];
    } completion:^(BOOL finished) {
        completion();
    }];
    
    return controller;
}

- (void)hide {
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIView *closeView = [main.view viewWithTag:9999];

    [closeView removeFromSuperview];
}


@end
