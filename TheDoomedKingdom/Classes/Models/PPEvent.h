//
//  PPEvent.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/6/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPGoogleBaseModel.h"

@interface PPEvent : PPGoogleBaseModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger type;
@property (nonatomic, readonly) NSIndexSet *days;

@property (nonatomic) NSInteger ifMana;
@property (nonatomic) NSInteger ifKingRep;
@property (nonatomic) NSInteger ifPeopleRep;
@property (nonatomic) NSInteger ifCorrupt;

@property (nonatomic) CGFloat defaultDiePercent;

@property (nonatomic) NSString *eventDescription;

@property (nonatomic, readonly) NSArray *abilities;

- (void)appendAbility:(id)ability;
- (NSString *)eventTypeIcon;

@end
