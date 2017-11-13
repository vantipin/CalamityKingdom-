//
//  PPPlayerAbility.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPAbility.h"

@implementation PPAbility
@synthesize value;
@synthesize abilityName;

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

- (NSString *)defaultAbilityName
{
    NSString *name = @"DefaultName";
    
    switch (self.abilityType) {
        case PPAbilityTypeAppeal:
            name = @"Призыв";
            break;
            
        case PPAbilityTypeHypnosis:
            name = @"Гипноз";
            break;
            
        case PPAbilityTypeChaos:
            name = @"Хаос";
            break;
            
        case PPAbilityTypeTelekinesis:
            name = @"Телекинез";
            break;
            
        default:
            break;
    }
    
    return name;
}

- (void)setValue:(NSInteger)aValue
{
    value = MIN(MAX(aValue, MinAbilityValue), MaxAbilityValue);
}

- (NSString *)abilityName
{
    if (abilityName) {
        return abilityName;
    }
    
    NSString *name = @"DefaultName";
    
    switch (self.abilityType) {
        case PPAbilityTypeAppeal:
            name = @"Призыв";
            break;
            
        case PPAbilityTypeHypnosis:
            name = @"Гипноз";
            break;
            
        case PPAbilityTypeChaos:
            name = @"Хаос";
            break;
            
        case PPAbilityTypeTelekinesis:
            name = @"Телекинез";
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
            name = @"Призываем...";
            break;
            
        case PPAbilityTypeHypnosis:
            name = @"Гипнотизируем...";
            break;
            
        case PPAbilityTypeChaos:
            name = @"Вносим хаос...";
            break;
            
        case PPAbilityTypeTelekinesis:
            name = @"Плющим и левитируем...";
            break;
            
        default:
            break;
    }
    
    return name;
}

@end
