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
    self.player = [PPPlayer new];
    
    self.loadedSheets = 0;
//    PPSheetCities + PPSheetDisasters + PPSheetReplies + PPSheetEndings + PPSheetArchimags + PPSheetLibrary + PPSheetEvents + PPSheetEventReplies + PPSheetConstants
    self.sheets = @[
                    [PPTable objectWithUrl:CitiesSheetUrl type:PPSheetCities],
                    [PPTable objectWithUrl:ConstantsSheetUrl type:PPSheetConstants],
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
        [self reinitGame];
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
                    PPAbility *currAbility = [[danger.abilitiesToRemove filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.abilityType == %@",  @(ability.abilityType - 1)]] lastObject];
                    
                    if (currAbility) {
                        NSMutableArray *dieArray = [danger.result.peopleCountToDie mutableCopy];
                        PPValue *dieValue = dieArray[0];
                        PPValue *modifiedValue = [PPValue new];
                        
                        CGFloat modifier = ability.coef;
                        modifiedValue.minValue = dieValue.minValue * modifier;
                        modifiedValue.maxValue = dieValue.maxValue * modifier;
                        [dieArray addObject:modifiedValue];
                        
                        danger.result.peopleCountToDie = [dieArray copy];
                    }
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
            
        case PPSheetConstants:

            
            break;
            
        case PPSheetEndings:

            
            break;
            
        default:
            break;
    }
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
            
            weakSelf.loadedSheets += loadedSheet;
            
            if (weakSelf.loadedSheets == PPSheetAll) {
                NSLog(@"all loaded! without error!!!");
                
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
    
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"tsv"];
//
//    NSArray *cities = [NSArray arrayWithContentsOfCSVFile:filePath options:CHCSVParserOptionsRecognizesBackslashesAsEscapes delimiter:'\t'];
//
//    for (NSArray *cityArray in cities) {
//        if (cityArray.count == 4) {
//            PPCity *city = [PPCity new];
//            city.name = cityArray[1];
//            city.initPeopleCount = [cityArray[2] integerValue];
//            city.currPeopleCount = city.initPeopleCount;
//            city.cityDescription = cityArray[3];
//
//            [self.kingdom.cities addObject:city];
//        }
//    }
//
////    NSLog(@"cities = %@", self.kingdom.cities);
//
//    filePath = [[NSBundle mainBundle] pathForResource:@"dangers" ofType:@"tsv"];
//
//    NSArray *dangers = [NSArray arrayWithContentsOfCSVFile:filePath options:CHCSVParserOptionsRecognizesBackslashesAsEscapes delimiter:'\t'];
//
//    NSMutableArray *parsedDangers = [@[] mutableCopy];
//
//    for (NSArray *dangerArr in dangers) {
//        if (dangerArr.count == 10) {
//            PPDanger *danger = [PPDanger new];
//            danger.identifier = dangerArr[0];
//            danger.name = dangerArr[1];
//            danger.dangerDescription = dangerArr[9];
//
//            danger.dangerType = [dangerArr[3] integerValue];
//
//
//
//            PPValue *peopleToDie = [PPValue new];
//            peopleToDie.minValue = [dangerArr[5] integerValue];
//            peopleToDie.maxValue = [dangerArr[6] integerValue];
//
//            NSMutableArray *dieArray = [@[] mutableCopy];
////#warning first with replics
//            dieArray[0] = peopleToDie;
//            danger.result.peopleCountToDie = [dieArray copy];
//
//            PPValue *dangerAppearTime = [PPValue new];
//            dangerAppearTime.minValue = [dangerArr[7] integerValue] * HoursInDay;
//            dangerAppearTime.maxValue = [dangerArr[8] integerValue] * HoursInDay;
//
//
//            danger.timeToAppear = [dangerAppearTime randomValue];
//
//            [parsedDangers addObject:danger];
//        }
//    }
//
////    NSLog(@"parsedDangers = %@", parsedDangers);
//
//    filePath = [[NSBundle mainBundle] pathForResource:@"replics" ofType:@"tsv"];
//
//    NSArray *replics = [NSArray arrayWithContentsOfCSVFile:filePath options:CHCSVParserOptionsRecognizesBackslashesAsEscapes delimiter:'\t'];
//
//    for (NSArray *replArr in replics) {
//        if (replArr.count == 8) {
//            PPDanger *danger = [[parsedDangers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.identifier == %@", replArr[1]]] lastObject];
//
//            if (danger) {
//                PPAbility *currAbility = [[danger.abilitiesToRemove filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.abilityType == %@",  @([replArr[2] integerValue] - 1)]] lastObject];
//
//                if (currAbility) {
//                    currAbility.abilityName = replArr[3];
//                    currAbility.value = [replArr[4] integerValue];
//                    currAbility.timeToDestroyDanger = [replArr[5] integerValue];
//
//                    NSMutableArray *dieArray = [danger.result.peopleCountToDie mutableCopy];
//                    PPValue *dieValue = dieArray[0];
//                    PPValue *modifiedValue = [PPValue new];
//
//                    CGFloat modifier = [replArr[6] floatValue];
//                    modifiedValue.minValue = dieValue.minValue * modifier;
//                    modifiedValue.maxValue = dieValue.maxValue * modifier;
//                    [dieArray addObject:modifiedValue];
//
//                    danger.result.peopleCountToDie = [dieArray copy];
//
//                    currAbility.abilityDescription = replArr[7];
//                }
//            }
//        }
//    }
//
//    self.dangers = [parsedDangers copy];
//
//    filePath = [[NSBundle mainBundle] pathForResource:@"library" ofType:@"tsv"];
//
//    NSArray *items = [NSArray arrayWithContentsOfCSVFile:filePath options:CHCSVParserOptionsRecognizesBackslashesAsEscapes delimiter:'\t'];
//
//    NSMutableArray *libItems = [@[] mutableCopy];
//
//    for (NSArray *itemArr in items) {
//        if (itemArr.count == 3) {
//            PPLibraryItem *item = [PPLibraryItem new];
//
//            item.itemName = itemArr[1];
//            item.itemDescription = itemArr[2];
//            [libItems addObject:item];
//        }
//    }
//
//    self.libraryItems = [libItems copy];
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
    return (GameDaysCount - self.currentTimeHours);
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
    return [self.dangers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.removed == NO) AND (self.timeToAppear <= %@) AND (self.inProgress == NO)", @(self.currentTimeHours)]];
}

- (NSArray *)dangersToApply
{
    return [self.dangers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self.removed == NO) AND (timeToAppear <= %@) AND (self.affectedCity == nil)", @(self.currentTimeHours)]];
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
