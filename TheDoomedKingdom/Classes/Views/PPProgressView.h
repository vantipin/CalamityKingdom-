//
//  PPProgressView.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPProgressBarView.h"
#import "PPAbility.h"
#import "PPDanger.h"
#import "PPClosePopupView.h"
#import "SoundController.h"

@class PPDangerProgressController;

@interface PPProgressView : PPClosePopupView

@property (nonatomic, weak) IBOutlet UIImageView *playerImageView;
@property (nonatomic, weak) IBOutlet UIImageView *dangerImageView;

@property (nonatomic, weak) IBOutlet UILabel *abilityActionStringLabel;
@property (nonatomic, weak) IBOutlet UILabel *hoursLabel;

@property (nonatomic, weak) IBOutlet PPProgressBarView *progressBar;

@property (nonatomic, strong) PPAbility *ability;
@property (nonatomic, strong) PPDanger *danger;

- (void)initWithAbility:(PPAbility *)ability andDanger:(PPDanger *)danger andCompletionBlock:(void (^)(BOOL result))aCompletionBlock;

@end
