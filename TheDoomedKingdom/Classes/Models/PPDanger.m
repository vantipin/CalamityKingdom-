//
//  PPDanger.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPDanger.h"
#import "PPGame.h"
#import "PPAbility.h"
#import "PPCity.h"
#import "PPDangerResult.h"

@interface PPDanger()

//@property (nonatomic, strong, readwrite) NSArray *abilitiesToRemove;

@end

@implementation PPDanger

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.abilitiesToRemove = @[];
        self.removed = NO;
        self.result = [PPDangerResult new];
    }
    
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier" : @"id_disaster",
             @"name": @"name",
             @"dangerDescription": @"description",
             @"dangerType": @"type",
             @"minValue": @"min_dmg",
             @"maxValue": @"max_dmg",
             @"timeToAppear": @"day",
             };
}

- (NSString *)dangelTypeName
{
    NSString *levelType = @"SIMPLETYPE";
    
    switch (self.dangerType) {
        case PPDangerTypeDisaster:
            levelType = @"Стихия";
            break;
            
        case PPDangerTypeMonsters:
            levelType = @"Чудовища";
            break;
            
        case PPDangerTypePlague:
            levelType = @"Мор";
            break;
            
        case PPDangerTypeCurse:
            levelType = @"Проклятие";
            break;
            
        default:
            break;
    }
    
    return levelType;
}

- (NSString *)dangerTypeIcon
{
    NSString *levelType = @"SIMPLETYPE";
    
    switch (self.dangerType) {
        case PPDangerTypeDisaster:
            levelType = @"danger_elements.png";
            break;
            
        case PPDangerTypeMonsters:
            levelType = @"danger_monsters.png";
            break;
            
        case PPDangerTypePlague:
            levelType = @"danger_plages.png";
            break;
            
        case PPDangerTypeCurse:
            levelType = @"danger_curse.png";
            break;
            
        default:
            break;
    }
    
    return levelType;
}

@end
