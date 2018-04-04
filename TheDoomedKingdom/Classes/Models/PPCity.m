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

- (void)recalculateCurrentRatingWithDanger:(PPDanger *)danger
{
    [self recalculateCurrentRatingWithDanger:danger andAbilityType:PPAbilityTypeNobody];
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

- (void)recalculateCurrentRatingWithDanger:(PPDanger *)danger
                           andAbilityType:(PPAbilityType)abilityType
{
    if (danger && !danger.removed) {
        PPDangerResult *result = danger.result;
        result.helpAbilityType = abilityType;
        
        
        
        if (abilityType == PPAbilityTypeNobody) {
            NSInteger defaultCountToDie = MIN([result defaultDieCount], self.currPeopleCount);
            self.currPeopleCount -= defaultCountToDie;
        } else {
            NSInteger typedDie = MIN([result peopleCountToDieWithType], self.currPeopleCount);
            self.currPeopleCount -= typedDie;
        }
        
        danger.removed = YES;
    }
}

- (void)setRating:(CGFloat)rating
{
    _rating = MAX(MIN(1., rating), 0.);
}

- (void)setInitPeopleCount:(NSInteger)initPeopleCount {
    _initPeopleCount = initPeopleCount;
    _currPeopleCount = initPeopleCount;
}

- (void)setCurrentDanger:(PPDanger *)currentDanger {
    _currentDanger = currentDanger;
}

@end
