//
//  PPDangerAbilityView.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPAbility.h"
#import "PPEventAbility.h"

@interface PPDangerAbilityView : UIView

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *abilityTypeImageView;

@property (nonatomic, weak) IBOutlet UILabel *spentValueLabel;

@property (nonatomic, strong) PPAbility *ability;
@property (nonatomic, strong) PPEventAbility *eventAbility;


@property (nonatomic, assign) BOOL enabled;

@end
