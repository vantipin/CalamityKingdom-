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

@property (nonatomic, assign) CGFloat rating;

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
             @"initPeopleCount": @"people"
             };
}

-(void)recalculateCurrentRatingWithDanger:(PPDanger *)danger
                           andAbilityType:(PPAbilityType)abilityType
{
    if (danger && !danger.removed) {
        PPDangerResult *result = danger.result;
        result.helpAbilityType = abilityType;
        
        NSInteger defaultCountToDie = MIN([result defaultDieCount], self.currPeopleCount);
        
        if (abilityType == PPAbilityTypeNobody) {
            self.rating -= (CGFloat)defaultCountToDie / (CGFloat)self.initPeopleCount;
            self.currPeopleCount -= defaultCountToDie;
        } else {
            NSInteger typedDie = MIN([result peopleCountToDieWithType], self.currPeopleCount);
            self.rating += ((CGFloat)defaultCountToDie - (CGFloat)typedDie) / (CGFloat)self.initPeopleCount;
            self.currPeopleCount -= typedDie;
        }
        
        self.currentMagePopularity = self.rating * self.currPeopleCount;
        
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

@end
