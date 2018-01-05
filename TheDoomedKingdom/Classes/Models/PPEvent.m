//
//  PPEvent.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/6/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPEvent.h"

@interface PPEvent()

@property (nonatomic) NSString *dayString;
@property (nonatomic, readwrite) NSRange dayRange;

@end

@implementation PPEvent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier" : @"id",
             @"name" : @"name",
             @"type" : @"type",
             @"dayString" : @"day",
             @"ifMana" : @"if_mana",
             @"ifKingRep" : @"if_king_rep",
             @"ifPeopleRep" : @"if_people_rep",
             @"ifCorrupt" : @"if_corrupt",
             @"eventDescription" : @"description",
             };
}

- (void)setDayString:(NSString *)dayString {
    _dayString = dayString;
    
    NSArray *numbers = [dayString componentsSeparatedByString:@", "];
    
    if (numbers.count == 2) {
        NSInteger min = [numbers[0] integerValue];
        NSInteger max = [numbers[1] integerValue];
        self.dayRange = NSMakeRange(min, max + 1 - min);
    }
}

@end
