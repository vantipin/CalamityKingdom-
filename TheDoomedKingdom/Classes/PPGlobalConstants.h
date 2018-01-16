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

typedef NS_ENUM(NSUInteger, PPSheet) {
    PPSheetCities = 1 << 0,
    PPSheetDisasters = 1 << 1,
    PPSheetReplies = 1 << 2,
    PPSheetEndings = 1 << 3,
    PPSheetArchimags = 1 << 4,
    PPSheetLibrary = 1 << 5,
    PPSheetEvents = 1 << 6,
    PPSheetEventReplies = 1 << 7,
    PPSheetConstants = 1 << 8,
    
    PPSheetAll = PPSheetCities + PPSheetDisasters + PPSheetReplies + PPSheetEndings + PPSheetArchimags + PPSheetLibrary + PPSheetEvents + PPSheetEventReplies + PPSheetConstants
};

#define PopupSize CGSizeMake(769., 497)
#define LibraryPopupSize CGSizeMake(699., 451.)

#define GameDaysCount 30
#define HoursInDay 1

#pragma mark - Abilities

#define MinAbilityValue 0
#define MaxAbilityValue 100

#define ABILITIES_REGEN_VALUE_IN_DAY 20
#define AnimationDuration 0.3

#pragma mark - Sheets constants

#define DisasterSheetUrl @"https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/od6"
#define RepliesSheetUrl @"https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/o1e9lp4"
#define CitiesSheetUrl @"https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/ommsews"
#define EndingsSheetUrl @"https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/ocghpen"
#define ArchimagsSheetUrl @"https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/oagl4ao"
#define LibrarySheetUrl @"https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/okm6ig0"
#define EventsSheetUrl @"https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/oe9dn37"
#define EventRepliesSheetUrl @"https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/odwe38y"
#define ConstantsSheetUrl @"https://spreadsheets.google.com/feeds/worksheets/1cOaBRJ4vhP9oPt-sA0P9TiCY8RksoGHG-d8C5anUIR0/public/basic/oj5lh0f"

#pragma mark - Parse game constants

#define IdKey @"id"
#define DisasterIdKey @"id_disaster"
#define NameKey @"name"
#define TypeKey "type"
#define MinDmgKey @"min_dmg"
#define MaxDmgKey @"max_dmg"
#define DayKey @"day"
#define DescriptionKey @"description"
#define PeopleKey @"people"
#define ReplyIdKey @"id_reply"
#define TextKey @"text"
#define CostKey @"cost"
#define CoefKey @"coef"
#define TimeKey @"time"
#define ResultKey @"result"

#endif /* PPGlobalConstants_h */
