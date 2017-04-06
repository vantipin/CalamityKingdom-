//
//  PPPlayerAbility.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPGlobalConstants.h"

@interface PPAbility : NSObject

// MAGE ABILITY
@property (nonatomic, assign) PPAbilityType abilityType;
@property (nonatomic, assign) NSInteger value;

@property (nonatomic, assign) NSInteger timeToDestroyDanger;

@property (nonatomic, strong) NSString *abilityName;
@property (nonatomic, strong) NSString *abilityDescription;

- (NSString *)abilityIcon;
- (NSString *)defaultAbilityName;
- (NSString *)abilityActionString;

@end
