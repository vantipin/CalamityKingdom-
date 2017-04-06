//
//  PPGlobalConstants.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#ifndef PPGlobalConstants_h
#define PPGlobalConstants_h

typedef NS_ENUM(NSInteger, PPAbilityType) {
    PPAbilityTypeTelekinesis = 0,
    PPAbilityTypeAppeal = 1,
    PPAbilityTypeHypnosis,
    PPAbilityTypeChaos,
    PPAbilityTypeNobody,
};

typedef NS_ENUM(NSInteger, PPCityViewType) {
    PPCityViewTypeDefault = 0,
    PPCityViewTypeVision = 1,
};

#define PopupSize CGSizeMake(769., 497)
#define LibraryPopupSize CGSizeMake(699., 451.)

#define GameDaysCount 10
#define HoursInDay 24

#pragma mark - Vision

#define VisionHours 48
#define VisionCost 6

#pragma mark - Abilities

#define MinAbilityValue 0
#define MaxAbilityValue 100

#define ABILITIES_REGEN_VALUE_IN_HOUR 1.


#define CityShieldAbsorbValue 0.9

#endif /* PPGlobalConstants_h */
