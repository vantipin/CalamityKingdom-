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
        self.mana = InitialManaValue;
        self.kingRep = InitialKingRep;
        self.peopleRep = InitialPeopleRep;
        self.corrupt = InitialCorrupt;
    }
    
    return self;
}

- (void)setMana:(NSInteger)mana {
    _mana = MIN(MAX(mana, MinAbilityValue), MaxAbilityValue);
}

- (void)setKingRep:(NSInteger)kingRep {
    _kingRep = MIN(MAX(kingRep, MinAbilityValue), MaxAbilityValue);
}

- (void)setPeopleRep:(NSInteger)peopleRep {
    _peopleRep = MIN(MAX(peopleRep, MinAbilityValue), MaxAbilityValue);
}

- (void)setCorrupt:(NSInteger)corrupt {
    _corrupt = MIN(MAX(corrupt, MinAbilityValue), MaxAbilityValue);
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
