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

@property (nonatomic, strong, readwrite) NSArray *abilitiesToRemove;

@end

@implementation PPDanger

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableArray *abilities = [@[] mutableCopy];
        
        for (PPAbilityType type = 0; type < PPAbilityTypeNobody; type++) {
            PPAbility *ability = [PPAbility new];
            ability.abilityType = type;
            [abilities addObject:ability];
        }
        
        self.abilitiesToRemove = [abilities copy];
        self.removed = NO;
        self.result = [PPDangerResult new];
    }
    
    return self;
}

- (NSInteger)dangerDuration
{
    return (self.maxTimeForDanger - self.timeToAppear);
}

- (NSInteger)dangerLeftDuration
{
    return (self.maxTimeForDanger - [[PPGame instance] currentTimeHours]);
}

- (NSString *)dangelLevelName
{
    NSString *levelName = @"SIMPLELEVEL";
    
    switch (self.dangerLevel) {
        case PPDangerLevelImperator:
            levelName = @"Императорский";
            break;
            
        case PPDangerLevelKing:
            levelName = @"Королевский";
            break;
            
        case PPDangerLevelKolhoz:
            levelName = @"Колхозный";
            break;
            
        default:
            break;
    }
    
    return levelName;
}

- (NSString *)dangelLevelIcon
{
    NSString *levelName = @"SIMPLELEVEL";
    
    switch (self.dangerLevel) {
        case PPDangerLevelImperator:
            levelName = @"icon_danger_hight.png";
            break;
            
        case PPDangerLevelKing:
            levelName = @"icon_danger_medium.png";
            break;
            
        case PPDangerLevelKolhoz:
            levelName = @"icon_danger_low.png";
            break;
            
        default:
            break;
    }
    
    return levelName;
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
