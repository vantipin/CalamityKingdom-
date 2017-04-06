//
//  PPKingdom.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPKingdom.h"

@implementation PPKingdom

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.cities = [@[] mutableCopy];
    }
    
    return self;
}

@end
