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

    self.spentValueLabel.text = [NSString stringWithFormat:@"-%li", (long)ability.value];
    self.spentTimeLabel.text = [NSString stringWithFormat:@"%liч", (long)ability.timeToDestroyDanger];
    [self.timeProgress setProgress:(CGFloat)ability.timeToDestroyDanger / 12.f];

    self.enabled = [[PPGame instance] player].mana >= ability.value;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    self.alpha = enabled ? 1. : 0.5;
    
    [self setUserInteractionEnabled:enabled];
}

@end
