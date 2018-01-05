//
//  PPLibraryItem.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 3/15/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPLibraryItem.h"

@implementation PPLibraryItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier" : @"id",
             @"itemName": @"name",
             @"itemDescription": @"text",
             @"day": @"day"
             };
}

@end
