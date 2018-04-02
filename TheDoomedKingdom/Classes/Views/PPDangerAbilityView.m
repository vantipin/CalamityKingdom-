//
//  PPDangerAbilityView.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPDangerAbilityView.h"
#import "PPPlayer.h"
#import "PPGame.h"

@implementation PPDangerAbilityView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)setAbility:(PPAbility *)ability
{
    _ability = ability;
    
    self.nameLabel.text = ability.abilityName;

    self.spentValueLabel.text = [NSString stringWithFormat:@"-%li", (long)ability.manaCost];

    self.enabled = [[PPGame instance] player].mana >= ability.manaCost;
}

- (void)setEventAbility:(PPEventAbility *)eventAbility {
    _eventAbility = eventAbility;
    
    self.nameLabel.text = eventAbility.abilityName;
    PPPlayer *pl = [[PPGame instance] player];
    
    self.enabled = pl.mana >= eventAbility.mana;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    self.alpha = enabled ? 1. : 0.5;
    
    [self setUserInteractionEnabled:enabled];
}

@end
