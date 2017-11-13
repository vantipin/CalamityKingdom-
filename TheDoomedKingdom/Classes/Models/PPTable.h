//
//  PPSheet.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 11/14/17.
//  Copyright © 2017 PP. All rights reserved.
//

#import "GDBSheet.h"

@interface PPTable : GDBSheet

@property (nonatomic) PPSheet sheet;

+ (instancetype)objectWithUrl:(NSString *)url type:(PPSheet)type;

@end
