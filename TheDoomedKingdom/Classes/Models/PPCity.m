//
//  PPCity.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPCity.h"
#import <CoreGraphics/CoreGraphics.h>
#import "PPDanger.h"
#import "PPDangerResult.h"

@interface PPCity()

@end

@implementation PPCity

- (BOOL)cityInDanger
{
    return (nil != self.currentDanger);
}

- (NSInteger)recalculateCurrentRatingWithDanger:(PPDanger *)danger
{
    return [self recalculateCurrentRatingWithDanger:danger andAbilityType:PPAbilityTypeNobody];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier" : @"id",
             @"name": @"name",
             @"cityDescription": @"description",
             @"initPeopleCount": @"people",
             @"type" : @"type"
             };
}

- (NSInteger)recalculateCurrentRatingWithDanger:(PPDanger *)danger
                           andAbilityType:(PPAbilityType)abilityType
{
    NSInteger died = 0;
    
    if (danger && !danger.removed) {
        PPDangerResult *result = danger.result;
        result.helpAbilityType = abilityType;
        
        if (abilityType == PPAbilityTypeNobody) {
            died = MIN(result.defaultDieCoef * self.initPeopleCount, self.currPeopleCount);
        } else {
            died = MIN([result peopleCountToDieWithType] * self.initPeopleCount, self.currPeopleCount);
        }
        
        self.currPeopleCount -= died;
        danger.removed = YES;
    }
    
    return died;
}

- (void)setInitPeopleCount:(NSInteger)initPeopleCount {
    _initPeopleCount = initPeopleCount;
    _currPeopleCount = initPeopleCount;
}

- (void)setCurrentDanger:(PPDanger *)currentDanger {
    _currentDanger = currentDanger;
}

@end
