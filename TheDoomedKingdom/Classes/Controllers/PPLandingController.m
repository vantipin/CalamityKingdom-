//
//  PPLandingController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 4/8/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPLandingController.h"
#import "PPIntroViewController.h"
#import "PPGame.h"

#define PPLandingControllerID @"PPLandingControllerID"

@interface PPLandingController ()

@property (nonatomic, assign) BOOL wasUpdated;

@end

@implementation PPLandingController
@synthesize wasUpdated;

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
    [self.progressBar setProgress:0];
    
    for (UIView *control in self.controlButtons) {
        [control setAlpha:0];
    }
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (wasUpdated) {
        return;
    }
    
    wasUpdated = true;
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        for (UIView *control in self.controlButtons) {
            [control setAlpha:0.];
        }
        
        [self.progressBar setAlpha:1];
    }];
    
    BOOL withUpdate = true;
    
    [[PPGame instance] parseGameWithUpdate:withUpdate progress:^(CGFloat progress) {
        [self.progressBar setProgress:progress animated:YES duration:0.2];
    } completion:^(BOOL success, NSError *error) {
        [UIView animateWithDuration:AnimationDuration animations:^{
            for (UIView *view in self.controlButtons) {
                view.alpha = 1;
            }
            
            [self.progressBar setAlpha:0];
        }];
        
    }];
    
}

- (IBAction)creditsPressed:(id)sender {
    
}

- (IBAction)optionsPressed:(id)sender {
    
}


@end
