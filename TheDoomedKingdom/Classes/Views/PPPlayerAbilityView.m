//
//  PPPlayerAbility.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPPlayerAbilityView.h"

@implementation PPPlayerAbilityView

- (void)setAbility:(PPAbility *)ability
{
    _ability = ability;
    
    self.nameLabel.text = ability.abilityName;
    
    [self.progressBar setProgress:ability.manaCost / 100.];
    [self.valueLabel setText:[NSString stringWithFormat:@"%li", (long)ability.manaCost]];
}

@end
