//
//  PPCity.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPGoogleBaseModel.h"
@class PPDanger;

@interface PPCity : PPGoogleBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cityDescription;

@property (nonatomic, assign) NSInteger initPeopleCount;
@property (nonatomic, assign) NSInteger currPeopleCount;

@property (nonatomic, assign) CGFloat currentMagePopularity;

@property (nonatomic, strong) PPDanger *currentDanger;



@property (nonatomic, assign, readonly) BOOL cityInDanger;

- (void)recalculateCurrentRatingWithDanger:(PPDanger *)danger;
- (void)recalculateCurrentRatingWithDanger:(PPDanger *)danger
                            andAbilityType:(PPAbilityType)abilityType;

@end
