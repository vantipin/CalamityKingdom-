//
//  PPArchimage.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/13/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPArchimage.h"

@implementation PPArchimage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier" : @"id",
             @"name" : @"name",
             @"popularity" : @"popularity",
             };
}

@end
