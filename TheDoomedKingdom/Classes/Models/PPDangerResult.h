//
//  PPDangerResult.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPAbility.h"

@interface PPDangerResult : NSObject

@property (nonatomic, assign) PPAbilityType helpAbilityType;

//@property (nonatomic, strong) NSArray *resultStrings;
@property (nonatomic, strong) NSArray *peopleCountToDie;
//@property (nonatomic, strong) NSArray *ratingChanges;

//- (NSString *)helpResultWithType;
- (NSInteger)peopleCountToDieWithType;

- (NSInteger)defaultDieCount;
//- (NSInteger)ratingChangesWithType;

@end
