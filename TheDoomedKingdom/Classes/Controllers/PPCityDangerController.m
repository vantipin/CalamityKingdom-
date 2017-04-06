//
//  PPCityInfoController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPCityDangerController.h"
#import "PPCityView.h"
#import "PPClosePopupView.h"
#import "PPGame.h"

#define PPCityDangerControllerId @"PPCityDangerControllerId"

#define mainStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:nil]

@implementation PPCityDangerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(PPCityView *)self.view setCity:self.city];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)showWithCity:(PPCity *)city
{
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [[PPClosePopupView alloc] initWithFrame:main.view.bounds];
    closeView.tag = 9999;
    closeView.backgroundColor = [UIColor clearColor];
    [main.view addSubview:closeView];
    
    PPCityDangerController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:PPCityDangerControllerId];
    controller.city = city;
    [controller view];
    [controller.view setFrame:CGRectMake((1024 - PopupSize.width) / 2., (768 - PopupSize.height) / 2., PopupSize.width, PopupSize.height)];
    closeView.parent = controller;
    
    [controller.view setAlpha:0.];
    
    [closeView addSubview:controller.view];
    [controller.view setCenter:closeView.center];
    
    [UIView animateWithDuration:0.35 animations:^{
        [controller.view setAlpha:1.];
    }];
    
    return controller;
}

- (void)hide:(id)sender
{
    if (!sender) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEARDANGER" object:nil];
    }
    
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [main.view viewWithTag:9999];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.view setAlpha:0.];
    } completion:^(BOOL finished) {
        closeView.parent = nil;
        [closeView removeFromSuperview];
        
        [[PPGame instance] checkState];
    }];
}

@end
