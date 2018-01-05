//
//  PPLibraryItem.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 3/15/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPGoogleBaseModel.h"

@interface PPLibraryItem : PPGoogleBaseModel

@property (nonatomic) NSString *itemName;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSString *itemDescription;

@end
