//
//  PPConstant.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/6/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPGoogleBaseModel.h"

@interface PPConstant : PPGoogleBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *constDescription;
@property (nonatomic, strong) NSNumber *constValue;

@end
