//
//  PPCityInfoController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPDangerResultController.h"
#import "PPResultView.h"
#import "PPClosePopupView.h"
#import "PPGame.h"

typedef void(^CompletionBlock)(BOOL result);


#define PPDangerResultControllerID @"PPDangerResultControllerID"

#define mainStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:nil]

@interface PPDangerResultController() <PPCloseDelegate>

@property (nonatomic, copy) CompletionBlock completionBlock;

@end

@implementation PPDangerResultController

- (void)close
{
    [self hide:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [(PPResultView *)self.view setCloseDelegate:self];
    [(PPResultView *)self.view initWithAbility:self.ability andDanger:self.danger];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)showWithDanger:(PPDanger *)danger andAbility:(PPAbility *)ability
{
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [[PPClosePopupView alloc] initWithFrame:main.view.bounds];
    closeView.tag = 7777;
    closeView.backgroundColor = [UIColor clearColor];
    [main.view addSubview:closeView];
    
    PPDangerResultController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:PPDangerResultControllerID];
    controller.danger = danger;
    controller.ability = ability;
    [controller view];
    [controller.view setFrame:CGRectMake((1024 - PopupSize.width) / 2., (768 - PopupSize.height) / 2., PopupSize.width, PopupSize.height)];
    closeView.parent = controller;
    
    [controller.view setAlpha:0.];
    
    [closeView addSubview:controller.view];
    [controller.view setCenter:closeView.center];
    
    [UIView animateWithDuration:0.15 animations:^{
        [controller.view setAlpha:1.];
    }];
    
    return controller;
}

- (void)hide:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEARDANGER" object:nil];
    
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [main.view viewWithTag:7777];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.view setAlpha:0.];
    } completion:^(BOOL finished) {
        closeView.parent = nil;
        [closeView removeFromSuperview];
        
        [[PPGame instance] checkState];
    }];
}

@end
