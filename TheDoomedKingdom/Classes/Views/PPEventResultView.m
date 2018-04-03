//
//  PPEventResultView.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 4/3/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPEventResultView.h"
#import "PPGame.h"
#import "SoundController.h"
//#import "EndingsViewController.h"

@implementation PPEventResultView

- (void)initWithEventAbility:(PPEventAbility *)ability {
    self.resultDescriptionLabel.text = ability.abilityDescription;
    
    [[PPGame instance] player].mana += ability.mana;
    [[PPGame instance] player].kingRep += ability.kingRep;
    [[PPGame instance] player].peopleRep += ability.peopleRep;
    [[PPGame instance] player].corrupt += ability.corrupt;
    
    if (ability.ending < 1) {
        [[SoundController sharedInstance] playBattleWin];
    }
}

@end
