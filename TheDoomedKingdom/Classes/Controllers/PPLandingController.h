//
//  PPLandingController.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 4/8/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPProgressBarView.h"

@interface PPLandingController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *controlButtons;

@property (weak, nonatomic) IBOutlet PPProgressBarView *progressBar;

@property (nonatomic) BOOL skipUpdates;

+ (void)show;

@end
