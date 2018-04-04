//
//  PPPlayerAbility.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPGoogleBaseModel.h"

@interface PPAbility : PPGoogleBaseModel

@property (nonatomic) NSString *dangerId;


// MAGE ABILITY
@property (nonatomic, assign) PPAbilityType abilityType;
@property (nonatomic, assign) NSInteger manaCost;

@property (nonatomic, assign) NSInteger kingRepCost;
@property (nonatomic, assign) NSInteger peopleRepCost;
@property (nonatomic, assign) NSInteger corruptCost;

@property (nonatomic, assign) CGFloat damage;
@property (nonatomic, assign) NSInteger timeToDestroyDanger;

@property (nonatomic, strong) NSString *abilityName;
@property (nonatomic, strong) NSString *abilityDescription;

- (NSString *)abilityIcon;
- (NSString *)abilityActionString;

@end
