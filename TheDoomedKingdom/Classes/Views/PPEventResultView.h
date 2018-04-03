//
//  PPEventResultView.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 4/3/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPClosePopupView.h"
#import "PPEventAbility.h"

@interface PPEventResultView : PPClosePopupView

@property (nonatomic, weak) IBOutlet UILabel *resultDescriptionLabel;

@property (nonatomic) PPEventAbility *eventAbility;

- (void)initWithEventAbility:(PPEventAbility *)ability;

@end
