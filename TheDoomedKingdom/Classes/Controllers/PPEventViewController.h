//
//  PPEventViewController.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 4/3/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPEvent.h"

@interface PPEventViewController : UIViewController

@property (nonatomic, strong) PPEvent *event;

+ (instancetype)showWithEvent:(PPEvent *)event;
- (void)hide;

@end
