//
//  PPGoogleBaseModel.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 12/27/17.
//  Copyright © 2017 PP. All rights reserved.
//

#import "PPGoogleBaseModel.h"

@implementation PPGoogleBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier" : @"id",
             };
}

+ (NSValueTransformer *)eventDateJSONTransformer {
    return [self googleDocsDateJSONTransformer];
}

//- (NSDictionary *)dictionaryValue {
//    return [self dictionaryWithValuesForKeys:self.class.JSONKeyPathsByPropertyKey.allValues];
//}

@end
