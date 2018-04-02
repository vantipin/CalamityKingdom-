//
//  PPCityInfoController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPDangerProgressController.h"
#import "PPProgressView.h"
#import "PPClosePopupView.h"
#import "PPGame.h"

typedef void(^CompletionBlock)(BOOL result);


#define PPDangerProgressControllerID @"PPDangerProgressControllerID"

@interface PPDangerProgressController() <PPCloseDelegate>

@property (nonatomic, copy) CompletionBlock completionBlock;

@end

@implementation PPDangerProgressController

- (void)close
{
    [self hide:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [(PPProgressView *)self.view setCloseDelegate:self];
    [(PPProgressView *)self.view initWithAbility:self.ability andDanger:self.danger andCompletionBlock:self.completionBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)showWithDanger:(PPDanger *)danger andAbility:(PPAbility *)ability andCompletionBlock:(void (^)(BOOL))aCompletionBlock
{
    
        
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [[PPClosePopupView alloc] initWithFrame:main.view.bounds];
    closeView.tag = 8888;
    closeView.backgroundColor = [UIColor clearColor];
    [main.view addSubview:closeView];
    
    PPDangerProgressController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:PPDangerProgressControllerID];
    controller.danger = danger;
    controller.ability = ability;
    controller.completionBlock = aCompletionBlock;
    [controller view];
    [controller.view setFrame:CGRectMake((1024 - PopupSize.width) / 2., (768 - PopupSize.height) / 2., PopupSize.width, PopupSize.height)];
    closeView.parent = controller;
    closeView.userInteractionEnabled = NO;
    
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
    
    
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [main.view viewWithTag:8888];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.view setAlpha:0.];
    } completion:^(BOOL finished) {
        closeView.parent = nil;
        [closeView removeFromSuperview];
        
//        [[PPGame instance] checkState];
    }];
}

@end
