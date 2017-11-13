//
//  PPSheet.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 11/14/17.
//  Copyright © 2017 PP. All rights reserved.
//

#import "PPTable.h"

@implementation PPTable

+ (instancetype)objectWithUrl:(NSString *)url type:(PPSheet)type {
    PPTable *table = [PPTable new];
    table.sheetUrl = url;
    table.sheet = type;
    return table;
}

@end
