//
//  PPPlayerAbility.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPProgressBarView.h"
#import "PPAbility.h"
//#import "PaperView.h"

@interface PPPlayerAbilityView : UIView

@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, weak) IBOutlet PPProgressBarView *progressBar;

@property (nonatomic, strong) PPAbility *ability;

@end
