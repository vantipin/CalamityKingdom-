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
//#import "PPEndingsViewController.h"

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
    
    PPGameConstant *gc = [PPGame instance].gameConstants;
    
    NSMutableString *final = [NSMutableString string];
    
    if (ability.mana != 0) {
        [final appendFormat:@"%@: %li", gc.mana.name, (long)ability.mana];
    }
    
    if (ability.kingRep != 0) {
        [final appendFormat:@"%@%@: %li", final.length > 0 ? @", " : @"", gc.king_rep.name, (long)ability.kingRep];
    }
    
    if (ability.peopleRep != 0) {
        [final appendFormat:@"%@%@: %li", final.length > 0 ? @", " : @"", gc.people_rep.name, (long)ability.peopleRep];
    }
    
    if (ability.corrupt != 0) {
        [final appendFormat:@"%@%@: %li", final.length > 0 ? @", " : @"", gc.corrupt.name, (long)ability.corrupt];
    }
    
    self.finalLabel.text = final;
}

@end
