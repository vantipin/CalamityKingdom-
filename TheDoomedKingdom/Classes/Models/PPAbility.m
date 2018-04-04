//
//  PPPlayerAbility.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPAbility.h"
#import "PPGame.h"

@implementation PPAbility
@synthesize manaCost;
@synthesize abilityName;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"dangerId" : @"id_disaster",
             @"identifier" : @"id_reply",
             @"abilityName" : @"text",
             @"abilityDescription": @"result",
             @"abilityType": @"type",
             @"manaCost": @"mana",
             @"kingRepCost": @"king_rep",
             @"peopleRepCost": @"people_rep",
             @"corruptCost": @"corrupt",
             @"timeToDestroyDanger": @"time",
             @"damage": @"damage"
             };
}

- (NSString *)abilityIcon
{
    NSString *name = @"ability_chaos.png";
    
    switch (self.abilityType) {
        case PPAbilityTypeAppeal:
            name = @"ability_summon.png";
            break;
            
        case PPAbilityTypeHypnosis:
            name = @"ability_hypnos.png";
            break;
            
        case PPAbilityTypeChaos:
            name = @"ability_chaos.png";
            break;
            
        case PPAbilityTypeTelekinesis:
            name = @"ability_telekenisis.png";
            break;
            
        default:
            break;
    }
    
    return name;
}

- (void)setManaCost:(NSInteger)aManaCost {
    manaCost = MIN(MAX(aManaCost, MinAbilityValue), MaxAbilityValue);
}

- (void)setKingRepCost:(NSInteger)kingRepCost {
    _kingRepCost = MIN(MAX(kingRepCost, MinAbilityValue), MaxAbilityValue);
}

- (void)setPeopleRepCost:(NSInteger)peopleRepCost {
    _peopleRepCost = MIN(MAX(peopleRepCost, MinAbilityValue), MaxAbilityValue);
}

- (void)setCorruptCost:(NSInteger)corruptCost {
    _corruptCost = MIN(MAX(corruptCost, MinAbilityValue), MaxAbilityValue);
}

- (NSString *)abilityName
{
    if (abilityName) {
        return abilityName;
    }
    
    NSString *name = @"DefaultName";
    
    switch (self.abilityType) {
        case PPAbilityTypeAppeal:
            name = [PPGame instance].gameConstants.ability_appeal.name;
            break;
            
        case PPAbilityTypeHypnosis:
            name = [PPGame instance].gameConstants.ability_hypnosis.name;
            break;
            
        case PPAbilityTypeChaos:
            name = [PPGame instance].gameConstants.ability_chaos.name;
            break;
            
        case PPAbilityTypeTelekinesis:
            name = [PPGame instance].gameConstants.ability_telekinesis.name;
            break;
            
        default:
            break;
    }
    
    return name;
}

- (NSString *)abilityActionString
{
    NSString *name = @"DefaultName";
    
    switch (self.abilityType) {
        case PPAbilityTypeAppeal:
            name = [PPGame instance].gameConstants.ability_appeal_action.name;
            break;
            
        case PPAbilityTypeHypnosis:
            name = [PPGame instance].gameConstants.ability_hypnosis_action.name;
            break;
            
        case PPAbilityTypeChaos:
            name = [PPGame instance].gameConstants.ability_chaos_action.name;
            break;
            
        case PPAbilityTypeTelekinesis:
            name = [PPGame instance].gameConstants.ability_telekinesis_action.name;
            break;
            
        default:
            break;
    }
    
    return name;
}

@end
