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

@property (nonatomic, strong) NSArray *peopleCountToDie;

@property (nonatomic) CGFloat defaultDieCoef;

- (CGFloat)peopleCountToDieWithType;

@end
