//
//  PPConstant.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/6/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPConstant.h"

@implementation PPConstant

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier" : @"id",
             @"name": @"name",
             @"constDescription": @"description",
             @"constValue": @"value"
             };
}

@end
