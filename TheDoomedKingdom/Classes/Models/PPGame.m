//
//  PPGame.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPGame.h"
#import "PPDanger.h"
#import <CoreGraphics/CoreGraphics.h>

#import "CHCSVParser.h"
#import "PPValue.h"
#import "PPDangerResult.h"
#import "PPCity.h"
#import "PPConstant.h"
#import "PPLibraryItem.h"
#import "PPEvent.h"

#import "GoogleDocsServiceLayer.h"
#import "PPTable.h"
#import "PPEnding.h"
#import "PPArchimage.h"
#import "PPEventAbility.h"

@interface PPGame()

@property (nonatomic) NSArray *sheets;
@property (nonatomic) PPSheet loadedSheets;

@end

@implementation PPGame

static PPGame *instance = nil;

+ (PPGame *)instance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (instance == nil) {
            instance = [PPGame new];
        }
    });
    
    return instance;
}

- (void)reinitGame {
    self.kingdom = [PPKingdom new];
    
    
    self.loadedSheets = 0;
//    PPSheetCities + PPSheetDisasters + PPSheetReplies + PPSheetEndings + PPSheetArchimags + PPSheetLibrary + PPSheetEvents + PPSheetEventReplies + PPSheetConstants
    self.sheets = @[
                    [PPTable objectWithUrl:ConstantsSheetUrl type:PPSheetConstants],
                    [PPTable objectWithUrl:CitiesSheetUrl type:PPSheetCities],
                    [PPTable objectWithUrl:EndingsSheetUrl type:PPSheetEndings],
                    [PPTable objectWithUrl:DisasterSheetUrl type:PPSheetDisasters],
                    [PPTable objectWithUrl:RepliesSheetUrl type:PPSheetReplies],
                    [PPTable objectWithUrl:ArchimagsSheetUrl type:PPSheetArchimags],
                    [PPTable objectWithUrl:LibrarySheetUrl type:PPSheetLibrary],
                    [PPTable objectWithUrl:EventsSheetUrl type:PPSheetEvents],
                    [PPTable objectWithUrl:EventRepliesSheetUrl type:PPSheetEventReplies],
                    ];
    
    self.player.name = @"Вася";
    
    self.dangers = @[];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self reinitGame];
    }
    
    return self;
}

- (void)updateGame:(PPGameCallback)completion {
    NSLog(@"START LOADING");
    [self loadSheet:0 completion:completion];
}

- (void)configureObjects:(NSArray *)objects forSheet:(PPSheet)sheet {
    NSLog(@"filtered objects = %@", objects);
    
    switch (sheet) {
        case PPSheetCities: {
            for (PPCity *city in objects) {
                city.currPeopleCount = city.initPeopleCount;
            }
            
            [self.kingdom.cities addObjectsFromArray:objects];
            break;
        }
            
        case PPSheetDisasters: {
            for (PPDanger *danger in objects) {
                PPValue *peopleToDie = [PPValue new];
                peopleToDie.minValue = danger.minValue;
                peopleToDie.maxValue = danger.maxValue;
                
                danger.result.peopleCountToDie = @[peopleToDie];
            }
            
            self.dangers = objects;
            break;
        }
            
        case PPSheetReplies: {
            for (PPAbility *ability in objects) {
                PPDanger *danger = [[self.dangers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.identifier == %@", ability.dangerId]] lastObject];
                
                if (danger) {
                    NSMutableArray *dieArray = [danger.result.peopleCountToDie mutableCopy];
                    PPValue *dieValue = dieArray[0];
                    PPValue *modifiedValue = [PPValue new];
                    
                    CGFloat modifier = ability.coef;
                    modifiedValue.minValue = dieValue.minValue * modifier;
                    modifiedValue.maxValue = dieValue.maxValue * modifier;
                    [dieArray addObject:modifiedValue];
                    
                    danger.result.peopleCountToDie = [dieArray copy];
                    
                    [danger appendAbility:ability];
                    
                    ability.abilityType--;
                }
            }
            break;
        }
        case PPSheetEvents:

            
            break;
            
        case PPSheetArchimags:

            
            break;
            
        case PPSheetLibrary:
            self.libraryItems = objects;
            break;
            
        case PPSheetEventReplies:

            
            break;
            
        case PPSheetConstants: {
            PPGameConstant *gc = [PPGameConstant new];
            
            for (PPConstant *constant in objects) {
                if ([constant.identifier isEqualToString:@"ability_hypnosis_action"]) {
                    gc.ability_hypnosis_action = constant;
                } else if ([constant.identifier isEqualToString:@"ability_chaos_action"]) {
                    gc.ability_chaos_action = constant;
                } else if ([constant.identifier isEqualToString:@"ability_telekinesis_action"]) {
                    gc.ability_telekinesis_action = constant;
                } else if ([constant.identifier isEqualToString:@"ability_appeal_action"]) {
                    gc.ability_appeal_action = constant;
                } else if ([constant.identifier isEqualToString:@"danger_type_disaster"]) {
                    gc.danger_type_disaster = constant;
                } else if ([constant.identifier isEqualToString:@"danger_type_monsters"]) {
                    gc.danger_type_monsters = constant;
                } else if ([constant.identifier isEqualToString:@"danger_type_plague"]) {
                    gc.danger_type_plague = constant;
                } else if ([constant.identifier isEqualToString:@"danger_type_curse"]) {
                    gc.danger_type_curse = constant;
                } else if ([constant.identifier isEqualToString:@"ability_appeal"]) {
                    gc.ability_appeal = constant;
                } else if ([constant.identifier isEqualToString:@"ability_hypnosis"]) {
                    gc.ability_hypnosis = constant;
                } else if ([constant.identifier isEqualToString:@"ability_chaos"]) {
                    gc.ability_chaos = constant;
                } else if ([constant.identifier isEqualToString:@"ability_telekinesis"]) {
                    gc.ability_telekinesis = constant;
                } else if ([constant.identifier isEqualToString:@"corrupt"]) {
                    gc.corrupt = constant;
                } else if ([constant.identifier isEqualToString:@"mana"]) {
                    gc.mana = constant;
                } else if ([constant.identifier isEqualToString:@"king_rep"]) {
                    gc.king_rep = constant;
                } else if ([constant.identifier isEqualToString:@"people_rep"]) {
                    gc.people_rep = constant;
                } else if ([constant.identifier isEqualToString:@"mana_regen"]) {
                    gc.mana_regen = constant;
                } else if ([constant.identifier isEqualToString:@"mana_to_king_rep"]) {
                    gc.mana_to_king_rep = constant;
                } else if ([constant.identifier isEqualToString:@"mana_to_corrupt"]) {
                    gc.mana_to_corrupt = constant;
                } else if ([constant.identifier isEqualToString:@"mana_to_people_rep"]) {
                    gc.mana_to_people_rep = constant;
                } else if ([constant.identifier isEqualToString:@"days_count"]) {
                    gc.days_count = constant;
                }   
            }
            
            self.gameConstants = gc;
            
            break;
        }
            
        case PPSheetEndings: {
            self.endings = objects;
            break;
        }

        default:
            break;
    }
}

- (NSString *)sheetNameBySheet:(PPSheet)sheet {
    NSString *sheetName = @"DefaultName";
    
    switch (sheet) {
        case PPSheetCities: {
            sheetName = @"Cities";
            break;
        }
            
        case PPSheetDisasters: {
            sheetName = @"Disasters";
            break;
        }
            
        case PPSheetReplies: {
            sheetName = @"Replies";
            break;
        }
        case PPSheetEvents:
            sheetName = @"Events";
            break;
            
        case PPSheetArchimags:
            sheetName = @"Archimags";
            break;
            
        case PPSheetLibrary:
            sheetName = @"Library";
            break;
            
        case PPSheetEventReplies:
            sheetName = @"EventReplies";
            break;
            
        case PPSheetConstants: {
            sheetName = @"Constants";
            break;
        }
            
        case PPSheetEndings: {
            sheetName = @"Endings";
            break;
        }
            
        default:
            break;
    }
    
    return sheetName;
}

- (NSData *)jsonDataForObject:(id)obj
{
    return [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)filePathBySheet:(PPSheet)sheet
{
    NSString *fileName = [self sheetNameBySheet:sheet];
    NSString *type = @"json";
    
    NSString *bookSettingsPath = [NSString stringWithFormat:@"%@.%@", fileName, type];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docDir stringByAppendingPathComponent:bookSettingsPath];
    
    return filePath;
}


- (void)saveObjects:(NSArray *)objects forSheet:(PPSheet)sheet {
    return;
    NSMutableArray *jsons = [@[] mutableCopy];
    
    for (PPGoogleBaseModel *model in objects) {
        NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:model];
        [jsons addObject:JSONDictionary];
    }
    
    NSData *jsonData = [self jsonDataForObject:jsons];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:4];
    NSLog(@"saved json = %@", jsonString);
    NSLog(@"1234");
    
    [jsonData writeToFile:[self filePathBySheet:sheet] atomically:YES];
}

- (void)loadSheet:(NSInteger)sheetIndex completion:(PPGameCallback)completion {
    if (sheetIndex >= self.sheets.count) {
        NSLog(@"Sheet index ERRROR!");
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    
    PPTable *table = self.sheets[sheetIndex];
    
    __block PPSheet loadedSheet = table.sheet;
    
    Class modelClass = [PPGoogleBaseModel class];
    NSString *status = @"";
    
    switch (table.sheet) {
        case PPSheetCities:
            modelClass = [PPCity class];
            status = @"Парсим города";
            break;
            
        case PPSheetDisasters:
            modelClass = [PPDanger class];
            status = @"Парсим опасности";
            break;
            
        case PPSheetReplies:
            modelClass = [PPAbility class];
            status = @"Парсим результаты опасностей";
            break;
            
        case PPSheetEvents:
            modelClass = [PPEvent class];
            status = @"Парсим события";
            break;
            
        case PPSheetArchimags:
            modelClass = [PPArchimage class];
            status = @"Парсим архимагов";
            break;
            
        case PPSheetLibrary:
            modelClass = [PPLibraryItem class];
            status = @"Парсим библиотеку";
            break;
            
        case PPSheetEventReplies:
            modelClass = [PPEventAbility class];
            status = @"Парсим результаты событий";
            break;
            
        case PPSheetConstants:
            modelClass = [PPConstant class];
            status = @"Парсим константы";
            break;
            
        case PPSheetEndings:
            modelClass = [PPEnding class];
            status = @"Парсим концовки";
            break;

        default:
            break;
    }
    
    [SVProgressHUD showWithStatus:status];

    
    [GoogleDocsServiceLayer objectsForWorksheetKey:table.worksheetId sheetId:table.sheetId modelClass:modelClass callback:^(NSArray *objects, NSError *error) {
        
        NSLog(@"\n\n+++ loaded %li", (long)table.sheet);
        
        if (!error) {
            
            
            NSArray *filteredObjects = [objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier != nil"]];
            [self configureObjects:filteredObjects forSheet:loadedSheet];
            [self saveObjects:filteredObjects forSheet:loadedSheet];
            
            weakSelf.loadedSheets += loadedSheet;
            
            if (weakSelf.loadedSheets == PPSheetAll) {
                NSLog(@"all loaded! without error!!!");
                
                self.player = [PPPlayer new];
                
                if (completion) {
                    completion(YES, nil);
                }
            } else {
                [weakSelf loadSheet:sheetIndex + 1 completion:completion];
            }
        } else {
            NSLog(@"SHEET ERROR!!! = %@", error);
            
            if (completion) {
                completion(NO, error);
            }
            
        }
        
    }];
}

- (void)parseGameWithUpdate:(BOOL)withUpdate completion:(PPGameCallback)completion {
    [self reinitGame];
    
    if (withUpdate) {
        [SVProgressHUD show];
        
        [self updateGame:completion];
    }
}

- (NSArray *)shuffledLibraryItems
{
    NSMutableArray *shuffledElements = [self.libraryItems mutableCopy];
    NSUInteger count = [shuffledElements count];
    
    for (NSUInteger elementIndex = 0; elementIndex < count - 1; ++elementIndex) {
        NSInteger nElements = count - elementIndex;
        NSUInteger randomIndex = arc4random_uniform((u_int32_t)nElements) + elementIndex;
        [shuffledElements exchangeObjectAtIndex:elementIndex withObjectAtIndex:randomIndex];
    }
    
    return shuffledElements;
}

- (NSInteger)leftTimeHours
{
    return ([PPGame instance].gameConstants.days_count.constValue.integerValue - self.daysCount);
}

- (NSArray *)liveDangers
{
    return [self.dangers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.removed == NO"]];
}

- (NSArray *)usedDangers
{
    return [self.dangers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.removed == YES"]];
}

- (NSArray *)firedDangers
{
    return [self.dangers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.removed == NO) AND (self.timeToAppear <= %@) AND (self.inProgress == NO)", @(self.daysCount)]];
}

- (NSArray *)dangersToApply
{
    return [self.dangers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.removed == NO) AND (timeToAppear <= %@) AND (self.affectedCity == nil)", @(self.daysCount)]];
}

- (NSArray *)freeCities
{
    return [self.kingdom.cities filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.currentDanger == nil) AND (self.currPeopleCount > 0)"]];
}

- (void)checkState
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE" object:nil];
}

@end
