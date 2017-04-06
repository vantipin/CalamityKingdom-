//
//  PPLibraryViewController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 3/15/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPLibraryViewController.h"
#import "PPClosePopupView.h"
#import "PPGame.h"
#import "PPLibraryItem.h"

#define PPLibraryControllerId @"PPLibraryControllerId"
#define mainStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:nil]

@interface PPLibraryViewController ()

@property (nonatomic) NSArray *libraryItems;
@property (nonatomic) NSInteger selectedItemIndex;

@end

@implementation PPLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.libraryItems = [[PPGame instance] shuffledLibraryItems];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.selectedItemIndex = 0;
}

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex
{
    _selectedItemIndex = selectedItemIndex;
    
    if (self.libraryItems > 0) {
        selectedItemIndex %= self.libraryItems.count;
        
        PPLibraryItem *item = self.libraryItems[selectedItemIndex];
        
        [UIView transitionWithView:self.nameLabel duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.nameLabel.text = item.itemName;
        } completion:nil];
        
        [UIView transitionWithView:self.descrLabel duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.descrLabel.text = item.itemDescription;
        } completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)show
{
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [[PPClosePopupView alloc] initWithFrame:main.view.bounds];
    closeView.tag = 9999;
    closeView.backgroundColor = [UIColor clearColor];
    [main.view addSubview:closeView];
    
    PPLibraryViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:PPLibraryControllerId];
    [controller view];
    
    
    [controller.view setFrame:CGRectMake((1024.f - LibraryPopupSize.width) / 2., (768.f - LibraryPopupSize.height) / 2., LibraryPopupSize.width, LibraryPopupSize.height)];
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
    UIViewController *main = [UIApplication sharedApplication].keyWindow.rootViewController;
    PPClosePopupView *closeView = [main.view viewWithTag:9999];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.view setAlpha:0.];
    } completion:^(BOOL finished) {
        closeView.parent = nil;
        [closeView removeFromSuperview];
    }];
}

- (IBAction)backPressed:(id)sender
{
    self.selectedItemIndex--;
}

- (IBAction)nextPressed:(id)sender
{
    self.selectedItemIndex++;
}

@end
