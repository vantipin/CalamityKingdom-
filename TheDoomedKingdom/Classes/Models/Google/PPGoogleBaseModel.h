//
//  PPGoogleBaseModel.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 12/27/17.
//  Copyright © 2017 PP. All rights reserved.
//

#import "GDBModel.h"

@interface PPGoogleBaseModel : GDBModel

@property (nonatomic) NSString *identifier;

+ (BOOL)withoutNil;

@end
