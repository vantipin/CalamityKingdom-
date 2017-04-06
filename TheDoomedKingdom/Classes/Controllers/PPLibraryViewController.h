//
//  PPLibraryViewController.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 3/15/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPLibraryViewController : UIViewController

+ (instancetype)show;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descrLabel;

- (IBAction)hide:(id)sender;

- (IBAction)backPressed:(id)sender;
- (IBAction)nextPressed:(id)sender;

@end
