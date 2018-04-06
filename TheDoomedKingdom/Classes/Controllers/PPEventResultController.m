//
//  PPEventResultController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 4/3/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPEventResultController.h"
#import "PPEventResultView.h"
#import "PPClosePopupView.h"
#import "PPGame.h"
#import "PPEndingsViewController.h"

typedef void(^CompletionBlock)(BOOL result);


#define PPEventResultControllerID @"PPEventResultControllerID"

@interface PPEventResultController () <PPCloseDelegate>

@property (nonatomic, copy) CompletionBlock completionBlock;


@end

@implementation PPEventResultController


- (void)close
{
    [self hide:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [(PPEventResultView *)self.view setCloseDelegate:self];
    [(PPEventResultView *)self.view initWithEventAbility:self.eventAbility];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)showWithEventAbility:(PPEventAbility *)ability
{
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [[PPClosePopupView alloc] initWithFrame:main.view.bounds];
    closeView.tag = 7777;
    closeView.backgroundColor = [UIColor clearColor];
    [main.view addSubview:closeView];
    
    PPEventResultController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:PPEventResultControllerID];
    controller.eventAbility = ability;
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
    if (self.eventAbility.ending > 0) {
         [PPEndingsViewController showWithEndingId:self.eventAbility.ending];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEAREVENT" object:nil];
    
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [main.view viewWithTag:7777];
    self.eventAbility = nil;
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.view setAlpha:0.];
    } completion:^(BOOL finished) {
        closeView.parent = nil;
        
        [closeView removeFromSuperview];
        
        [[PPGame instance] checkState];
    }];
}

@end
