//
//  PPEnding.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/6/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "PPGoogleBaseModel.h"

@interface PPEnding : PPGoogleBaseModel

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger imageType; // must be enum type

@end
