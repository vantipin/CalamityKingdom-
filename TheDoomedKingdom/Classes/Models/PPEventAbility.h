//
//  PPEventAbility.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/16/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPGoogleBaseModel.h"

@interface PPEventAbility : PPGoogleBaseModel

@property (nonatomic) NSString *eventId;
@property (nonatomic, assign) NSInteger cost;

@property (nonatomic, strong) NSString *abilityName;
@property (nonatomic, strong) NSString *abilityDescription;

@property (nonatomic) NSInteger mana;
@property (nonatomic) NSInteger kingRep;
@property (nonatomic) NSInteger peopleRep;
@property (nonatomic) NSInteger corrupt;

@property (nonatomic) NSInteger ending;

@end
