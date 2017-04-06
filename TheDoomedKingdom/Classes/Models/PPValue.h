//
//  PPValue.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPValue : NSObject

@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;

- (NSInteger)randomValue;

@end
