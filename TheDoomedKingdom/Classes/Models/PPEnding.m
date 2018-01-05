//
//  PPEnding.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/6/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPEnding.h"

@implementation PPEnding

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier" : @"ending_id",
             @"text": @"text",
             @"imageType": @"image_type",
             };
}

@end
