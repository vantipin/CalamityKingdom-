//
//  PPResultView.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPAbility.h"
#import "PPDanger.h"
#import "PPClosePopupView.h"

@class PPDangerResultController;

@interface PPResultView : PPClosePopupView

@property (nonatomic, weak) IBOutlet UILabel *resultDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *finalLabel;

@property (nonatomic, strong) PPAbility *ability;
@property (nonatomic, strong) PPDanger *danger;

- (void)initWithAbility:(PPAbility *)ability andDanger:(PPDanger *)danger;

@end
