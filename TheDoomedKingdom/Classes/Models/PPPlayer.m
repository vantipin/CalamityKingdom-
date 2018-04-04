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
        self.mana = [[PPGame instance].gameConstants.mana.constValue integerValue];
        self.kingRep = [[PPGame instance].gameConstants.king_rep.constValue integerValue];
        self.peopleRep = [[PPGame instance].gameConstants.people_rep.constValue integerValue];
        self.corrupt = [[PPGame instance].gameConstants.corrupt.constValue integerValue];
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

@end
