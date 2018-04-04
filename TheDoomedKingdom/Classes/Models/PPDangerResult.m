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

@property (nonatomic, assign) CGFloat diedPeople;

@end

@implementation PPDangerResult

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.helpAbilityType = PPAbilityTypeNobody;
        self.diedPeople = UndefValue;
    }
    
    return self;
}


- (CGFloat)peopleCountToDieWithType
{
    if (self.diedPeople >= 0) {
        return self.diedPeople;
    }
    
    NSInteger indexForResult = self.helpAbilityType;
    
    if (self.helpAbilityType == PPAbilityTypeNobody) {
        self.diedPeople = self.defaultDieCoef;
        return self.diedPeople;
    }
    
    if (self.peopleCountToDie && indexForResult < self.peopleCountToDie.count) {
        self.diedPeople = [self.peopleCountToDie[indexForResult] floatValue];
    }
    
    return self.diedPeople;
}

@end
