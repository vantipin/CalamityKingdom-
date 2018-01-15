//
//  PPEventAbility.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/16/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPEventAbility.h"

@implementation PPEventAbility

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"eventId" : @"id_event",
             @"identifier" : @"id_reply",
             @"abilityName" : @"text",
             @"abilityDescription": @"result",
             @"mana" : @"mana",
             @"kingRep" : @"king_rep",
             @"peopleRep" : @"people_rep",
             @"corrupt" : @"corrupt",
             @"ending" : @"ending",
             @"cost" : @"cost"
             };
}

@end
