//
//  PPEventViewController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 4/3/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPEventViewController.h"
#import "PPDangerView.h"

#define PPEventViewControllerID @"PPEventViewControllerID"

@implementation PPEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(PPDangerView *)self.view setEvent:self.event];
}

+ (instancetype)showWithEvent:(PPEvent *)event {
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIView *closeView = [[UIView alloc] initWithFrame:main.view.bounds];
    closeView.tag = 9999;
    closeView.backgroundColor = [UIColor clearColor];
    [main.view addSubview:closeView];
    
    PPEventViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:PPEventViewControllerID];
    controller.event = event;
    [controller view];
    [controller.view setFrame:CGRectMake((1024 - PopupSize.width) / 2., (768 - PopupSize.height) / 2., PopupSize.width, PopupSize.height)];
    
    [controller.view setAlpha:0.];
    
    [closeView addSubview:controller.view];
    [controller.view setCenter:closeView.center];
    
    [UIView animateWithDuration:0.35 animations:^{
        [controller.view setAlpha:1.];
    }];
    
    return controller;
}

- (void)hide {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEAREVENT" object:nil];
    
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIView *closeView = [main.view viewWithTag:9999];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.view setAlpha:0.];
    } completion:^(BOOL finished) {
        [closeView removeFromSuperview];
        
#warning - Game action here
//        [[PPGame instance] checkState];
    }];
}


@end
