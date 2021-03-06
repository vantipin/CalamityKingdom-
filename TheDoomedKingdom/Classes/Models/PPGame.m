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
#import "SmartJSONAdapter.h"
#import "PPEvent.h"
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
    self.daysCount = 1;
    
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

- (void)updateGame:(PPGameCallback)completion progress:(PPProgressCallback)progress {
    NSLog(@"START LOADING");
    [self loadSheet:0 progress:progress completion:completion];
}

- (void)loadGameOffline:(PPGameCallback)completion progress:(PPProgressCallback)progress {
    NSString *type = @"json";
    
    for (PPTable *table in self.sheets) {
        NSString *fileName = [self sheetNameBySheet:table.sheet];
        NSString *filePath = [self filePathBySheet:table.sheet];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSString *bundleSettingsPath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
            
            if (bundleSettingsPath && [[NSFileManager defaultManager] fileExistsAtPath:bundleSettingsPath]) {
                [[NSFileManager defaultManager] copyItemAtPath:bundleSettingsPath toPath:filePath error:nil];
            }
        }
        
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];

        NSError *error = nil;
        
        if (jsonData && jsonData.length > 0) {
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
            
            if (!error) {
                NSMutableArray *objects = [@[] mutableCopy];
                
                for (NSDictionary *obj in jsonArray) {
                    Class modelClass = [self modelClassBySheet:table.sheet];
                    PPGoogleBaseModel *model = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:obj error:&error];
                    
                    if (!model || error) {
                        NSLog(@"error = %@, model = %@", error, model);
                        completion(NO, error);
                        return;
                    }
                    
                    [objects addObject:model];
                }
                
                [self configureObjects:objects forSheet:table.sheet];
                
            } else {
                NSLog(@"NSJSONSerialization ERROR = %@", error);
                completion(NO, error);
                return;
            }
        }
        
        progress((CGFloat)([self.sheets indexOfObject:table] + 1) / (CGFloat)[self.sheets count]);
    }
    
    self.player = [PPPlayer new];
    
    completion(YES, nil);
}

- (void)configureObjects:(NSArray *)objects forSheet:(PPSheet)sheet {
//    NSLog(@"filtered objects = %@", objects);
    
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
                danger.result.peopleCountToDie = @[@(danger.defaultDieCoef)];
                danger.result.defaultDieCoef = danger.defaultDieCoef;
            }
            
            self.dangers = objects;
            break;
        }
            
        case PPSheetReplies: {
            for (PPAbility *ability in objects) {
                PPDanger *danger = [[self.dangers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.identifier == %@", ability.dangerId]] lastObject];
                
                if (danger) {
                    NSMutableArray *dieArray = [danger.result.peopleCountToDie mutableCopy];
                    [dieArray addObject:@(ability.damage / 100.)];
                    
                    danger.result.peopleCountToDie = [dieArray copy];
                    
                    [danger appendAbility:ability];
                }
            }
            break;
        }
        case PPSheetEvents: {
            self.events = objects;
            
            break;
        }
        case PPSheetArchimags:

            
            break;
            
        case PPSheetLibrary:
            self.libraryItems = objects;
            break;
            
        case PPSheetEventReplies: {
            for (PPEventAbility *ability in objects) {
                PPEvent *event = [[self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.identifier == %@", ability.eventId]] lastObject];
                
                if (event) {
                    [event appendAbility:ability];
                }
            }
            
            break;
        }
            
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
    
    NSMutableArray *jsons = [@[] mutableCopy];
    
    for (PPGoogleBaseModel *model in objects) {
        NSDictionary *JSONDictionary = [SmartJSONAdapter JSONDictionaryFromModel:model];
        [jsons addObject:JSONDictionary];
    }
    
    NSData *jsonData = [self jsonDataForObject:jsons];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:4];
//    NSLog(@"saved json = %@", jsonString);
//    NSLog(@"1234");
    
    [jsonData writeToFile:[self filePathBySheet:sheet] atomically:YES];
}

- (Class)modelClassBySheet:(PPSheet)sheet {
    Class modelClass = [PPGoogleBaseModel class];
    
    switch (sheet) {
        case PPSheetCities:
            modelClass = [PPCity class];
            break;
            
        case PPSheetDisasters:
            modelClass = [PPDanger class];
            break;
            
        case PPSheetReplies:
            modelClass = [PPAbility class];
            break;
            
        case PPSheetEvents:
            modelClass = [PPEvent class];
            break;
            
        case PPSheetArchimags:
            modelClass = [PPArchimage class];
            break;
            
        case PPSheetLibrary:
            modelClass = [PPLibraryItem class];
            break;
            
        case PPSheetEventReplies:
            modelClass = [PPEventAbility class];
            break;
            
        case PPSheetConstants:
            modelClass = [PPConstant class];
            break;
            
        case PPSheetEndings:
            modelClass = [PPEnding class];
            break;
            
        default:
            break;
    }
    
    return modelClass;
}

- (NSString *)updateStatusBySheet:(PPSheet)sheet {
    NSString *status = @"";
    
    switch (sheet) {
        case PPSheetCities:
            status = @"Парсим города";
            break;
            
        case PPSheetDisasters:
            status = @"Парсим опасности";
            break;
            
        case PPSheetReplies:
            status = @"Парсим результаты опасностей";
            break;
            
        case PPSheetEvents:
            status = @"Парсим события";
            break;
            
        case PPSheetArchimags:
            status = @"Парсим архимагов";
            break;
            
        case PPSheetLibrary:
            status = @"Парсим библиотеку";
            break;
            
        case PPSheetEventReplies:
            status = @"Парсим результаты событий";
            break;
            
        case PPSheetConstants:
            status = @"Парсим константы";
            break;
            
        case PPSheetEndings:
            status = @"Парсим концовки";
            break;
            
        default:
            break;
    }
    
    return status;
}

- (void)loadSheet:(NSInteger)sheetIndex progress:(PPProgressCallback)progress completion:(PPGameCallback)completion {
    if (sheetIndex >= self.sheets.count) {
        NSLog(@"Sheet index ERRROR!");
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    
    PPTable *table = self.sheets[sheetIndex];
    
    __block PPSheet loadedSheet = table.sheet;
    
    Class modelClass = [self modelClassBySheet:table.sheet];
//    NSString *status = [self updateStatusBySheet:table.sheet];
//
//    [SVProgressHUD showWithStatus:status];

    
    [GoogleDocsServiceLayer objectsForWorksheetKey:table.worksheetId sheetId:table.sheetId modelClass:modelClass callback:^(NSArray *objects, NSError *error) {
        
//        NSLog(@"\n\n+++ loaded %li", (long)table.sheet);
        
        if (!error) {
            
            
            NSArray *filteredObjects = [objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier != nil"]];
            [self configureObjects:filteredObjects forSheet:loadedSheet];
            [self saveObjects:filteredObjects forSheet:loadedSheet];
            
            progress((CGFloat)(sheetIndex + 1) / (CGFloat)[self.sheets count]);
            
            weakSelf.loadedSheets += loadedSheet;
            
            if (weakSelf.loadedSheets == PPSheetAll) {
                NSLog(@"all loaded! without error!!!");
                
                self.player = [PPPlayer new];
                
                if (completion) {
                    completion(YES, nil);
                }
            } else {
                [weakSelf loadSheet:sheetIndex + 1 progress:progress completion:completion];
            }
        } else {
            NSLog(@"SHEET ERROR!!! = %@", error);
            
            if (completion) {
                completion(NO, error);
            }
            
        }
        
    }];
}

- (void)parseGameWithUpdate:(BOOL)withUpdate
                   progress:(PPProgressCallback)progress
                 completion:(PPGameCallback)completion {
    [self reinitGame];
    
    if (withUpdate) {
//        [SVProgressHUD show];
        
        [self updateGame:completion progress:progress];
    } else {
        [self loadGameOffline:completion progress:progress];
    }
}

- (NSArray *)shuffledLibraryItems
{
    NSMutableArray *shuffledElements = [[self.libraryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.day == %li", [PPGame instance].daysCount]] mutableCopy];
    NSUInteger count = [shuffledElements count];
    
    if (count == 0) {
        return @[];
    }
    
    for (NSUInteger elementIndex = 0; elementIndex < count - 1; ++elementIndex) {
        NSInteger nElements = count - elementIndex;
        NSUInteger randomIndex = arc4random_uniform((u_int32_t)nElements) + elementIndex;
        [shuffledElements exchangeObjectAtIndex:elementIndex withObjectAtIndex:randomIndex];
    }
    
    return shuffledElements;
}

- (PPEvent *)currDayEvent {
    NSMutableArray *events = [@[] mutableCopy];
    
    for (PPEvent *event in self.events) {
        if ([event.days containsIndex:[PPGame instance].daysCount]) {
            BOOL manaSuitable = event.ifMana == UndefValue || (event.ifMana == self.player.mana);
            BOOL peopleSuitable = event.ifPeopleRep == UndefValue || (event.ifPeopleRep == self.player.peopleRep);
            BOOL kingSuitable = event.ifKingRep == UndefValue || (event.ifKingRep == self.player.kingRep);
            BOOL corruptSuitable = event.ifCorrupt == UndefValue || (event.ifCorrupt == self.player.corrupt);
            
            if (manaSuitable && peopleSuitable && kingSuitable && corruptSuitable) {
                [events addObject:event];
            }
        }
    }
    
    if (events.count > 0) {
        return events[arc4random() % events.count];
    }
    
    return nil;
}

- (NSInteger)leftTimeHours
{
    return ([[PPGame instance].gameConstants.days_count.constValue integerValue] - self.daysCount);
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
