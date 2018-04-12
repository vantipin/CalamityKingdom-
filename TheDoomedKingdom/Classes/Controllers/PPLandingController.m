//
//  PPLandingController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 4/8/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPLandingController.h"
#import "PPIntroViewController.h"

#define PPLandingControllerID @"PPLandingControllerID"

@interface PPLandingController ()

@end

@implementation PPLandingController

+ (void)show {
    PPLandingController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:PPLandingControllerID];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [UIView transitionFromView:window.rootViewController.view
                        toView:viewController.view
                      duration:0.65f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished){
                        viewController.skipUpdates = YES;
                        window.rootViewController = viewController;
                        viewController.skipUpdates = NO;
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)startPressed:(id)sender {
    [PPIntroViewController show];
}

- (IBAction)creditsPressed:(id)sender {
    
}

- (IBAction)optionsPressed:(id)sender {
    
}


@end
