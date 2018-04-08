//
//  PPLandingController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 4/8/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPLandingController.h"

#define PPLandingControllerID @"PPLandingControllerID"

@interface PPLandingController ()

@end

@implementation PPLandingController

+ (void)show {
    PPLandingController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:PPLandingControllerID];
    viewController.skipUpdates = YES;

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [UIView transitionFromView:window.rootViewController.view
                        toView:viewController.view
                      duration:0.65f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished){
                        viewController.skipUpdates = NO;
                        window.rootViewController = viewController;
                    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
