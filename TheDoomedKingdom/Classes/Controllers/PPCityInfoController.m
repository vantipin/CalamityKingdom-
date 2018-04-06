//
//  PPCityInfoController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPCityInfoController.h"
#import "PPCityView.h"
#import "PPClosePopupView.h"
#import "PPGame.h"

#define CityInfoControllerId @"CityInfoControllerId"

@implementation PPCityInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(PPCityView *)self.view setCity:self.city];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)showWithCity:(PPCity *)city completion:(void (^)(void))completion {
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [[PPClosePopupView alloc] initWithFrame:main.view.bounds];
    closeView.tag = 9999;
    closeView.backgroundColor = [UIColor clearColor];
    [main.view addSubview:closeView];
    
    PPCityInfoController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:CityInfoControllerId];
    controller.city = city;
    [controller view];
    [controller.view setFrame:CGRectMake((1024.f - PopupSize.width) / 2., (768.f - PopupSize.height) / 2., PopupSize.width, PopupSize.height)];
    closeView.parent = controller;
    
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

- (void)hide:(id)sender
{
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [main.view viewWithTag:9999];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.view setAlpha:0.];
    } completion:^(BOOL finished) {
        closeView.parent = nil;
        [closeView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEAR" object:nil];
        [[PPGame instance] checkState];
    }];
}

@end
