//
//  PPDangerResult.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPDangerResult.h"
#import "PPValue.h"

@interface PPDangerResult()

@property (nonatomic, assign) NSInteger diedPeople;
@property (nonatomic, assign) NSInteger diedDefault;

@end

@implementation PPDangerResult

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.helpAbilityType = PPAbilityTypeNobody;
        self.diedPeople = -1;
        self.diedDefault = -1;
    }
    
    return self;
}

//- (NSString *)helpResultWithType
//{
//    NSString *result = @"Default Result";
//    NSInteger indexForResult = self.helpAbilityType;
//    
//    if (self.resultStrings && indexForResult < self.resultStrings.count) {
//        result = self.resultStrings[indexForResult];
//    } else {
//        NSLog(@"helpResultWithType ERROR");
//    }
//    
//    return result;
//}

- (NSInteger)peopleCountToDieWithType
{
    if (self.diedPeople >= 0) {
        return self.diedPeople;
    }
    
    NSInteger indexForResult = self.helpAbilityType + 1;
    
    if (self.helpAbilityType == PPAbilityTypeNobody) {
        self.diedPeople = [self defaultDieCount];
        return self.diedPeople;
    }
    
    if (self.peopleCountToDie && indexForResult < self.peopleCountToDie.count) {
        PPValue *value = self.peopleCountToDie[indexForResult];
        self.diedPeople = [value randomValue];
    } else {
        NSLog(@"percentPeopleToDieWithType ERROR");
    }
    
    return self.diedPeople;
}

- (NSInteger)defaultDieCount
{
    if (self.diedDefault >= 0) {
        return self.diedDefault;
    }
    
    NSInteger indexForResult = 0;
    
    if (self.peopleCountToDie && indexForResult < self.peopleCountToDie.count) {
        PPValue *value = self.peopleCountToDie[indexForResult];
        self.diedDefault = [value randomValue];
    } else {
        NSLog(@"defaultDieCount ERROR");
    }
    
    return self.diedDefault;
}

//- (NSInteger)ratingChangesWithType
//{
//    NSInteger result = 0;
//    NSInteger indexForResult = self.helpAbilityType;
//    
//    if (self.ratingChanges && indexForResult < self.ratingChanges.count) {
//        PPValue *value = self.ratingChanges[indexForResult];
//        result = [value randomValue];
//    } else {
//        NSLog(@"ratingChangesWithType ERROR");
//    }
//    
//    return result;
//}

@end
