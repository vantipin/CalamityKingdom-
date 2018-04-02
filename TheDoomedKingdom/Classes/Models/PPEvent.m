//
//  PPEvent.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/6/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPEvent.h"

@interface PPEvent()

@property (nonatomic, readwrite) NSArray *abilities;
@property (nonatomic) NSString *dayString;
@property (nonatomic, readwrite) NSRange dayRange;

@end

@implementation PPEvent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.abilities = @[];
        self.ifMana = UndefValue;
        self.ifCorrupt = UndefValue;
        self.ifKingRep = UndefValue;
        self.ifPeopleRep = UndefValue;
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
        return eventValue.integerValue != -1 ? [NSString stringWithFormat:@"%li", (long)eventValue.integerValue] : @"";
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

- (void)appendAbility:(id)ability {
    NSMutableArray *abs = [self.abilities mutableCopy];
    [abs addObject:ability];
    self.abilities = [abs copy];
}

- (NSString *)eventTypeIcon {
    switch (self.type) {
        case 1:
        return @"EventKingIcon.png";
        
        case 2:
        return @"EventDemonIcon.png";
        
        case 3:
        return @"EventMagIcon.png";
        
        case 4:
        return @"EventSwordsIcon.png";
        
        case 5:
        return @"EventTorchIcon.png";
        
        default:
        break;
    }
    
    return @"";
}

@end
