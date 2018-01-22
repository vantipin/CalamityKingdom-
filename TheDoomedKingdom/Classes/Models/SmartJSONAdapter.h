//
//  SmartJSONAdapter.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/22/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import <Mantle/Mantle.h>

@protocol SmartJSONAdapting <MTLJSONSerializing, NSObject>

@optional
/// whitelist only if present
+ (NSSet<NSString *> *)propertyKeysForJSONRepresentation;
/// remove properties with `nil` value from set
+ (BOOL)withoutNil;

@end

@interface SmartJSONAdapter : MTLJSONAdapter

- (NSSet *)serializablePropertyKeys:(NSSet *)propertyKeys
                           forModel:(MTLModel *)model;

@end
