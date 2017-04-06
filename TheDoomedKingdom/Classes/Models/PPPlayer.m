//
//  PPPlayer.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPPlayer.h"
#import "PPAbility.h"
#import "PPGame.h"
#import "PPCity.h"

@implementation PPPlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.abilities = [@[] mutableCopy];
        
        for (PPAbilityType type = 0; type < PPAbilityTypeNobody; type++) {
            PPAbility *ability = [PPAbility new];
            ability.abilityType = type;
            ability.value = 100;
            [self.abilities addObject:ability];
        }
    }
    
    return self;
}
- (CGFloat)totalPopularity

{
    PPGame *game = [PPGame instance];
    NSArray *cities = game.kingdom.cities;
    
    NSInteger resultPopularity = 0;
    
    for (PPCity *city in cities) {
        resultPopularity += city.currentMagePopularity;
    }
    
    return resultPopularity;
}

@end
