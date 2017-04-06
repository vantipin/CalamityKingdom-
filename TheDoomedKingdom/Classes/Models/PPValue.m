//
//  PPValue.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPValue.h"

@implementation PPValue

- (NSInteger)randomValue
{
    if (self.maxValue > self.minValue) {
        return (self.minValue + arc4random() % (self.maxValue - self.minValue));
    } else {
        return self.minValue;
    }
}

@end
