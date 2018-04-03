//
//  PPEventResultController.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 4/3/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPEventAbility.h"

@interface PPEventResultController : UIViewController

@property (nonatomic) PPEventAbility *eventAbility;

+ (instancetype)showWithEventAbility:(PPEventAbility *)ability;
- (IBAction)hide:(id)sender;

@end
