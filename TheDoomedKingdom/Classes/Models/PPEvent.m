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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ifMana = -1;
        self.ifCorrupt = -1;
        self.ifKingRep = -1;
        self.ifPeopleRep = -1;
    }
    
    return self;
}

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

+ (NSValueTransformer *)zeroTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return str.length > 0 ? @(str.integerValue) : @(-1);
    } reverseBlock:^(NSNumber *eventValue) {
        return eventValue.integerValue != -1 ? [NSString stringWithFormat:@"%li", eventValue.integerValue] : @"";
    }];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"if_mana"] ||
        [key isEqualToString:@"if_king_rep"] ||
        [key isEqualToString:@"if_people_rep"] ||
        [key isEqualToString:@"if_corrupt"]) {
        return [PPEvent zeroTransformer];
    }
    
    return nil;
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
