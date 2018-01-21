//
//  SmartJSONAdapter.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/22/18.
//  Copyright © 2018 PP. All rights reserved.
//

#import "SmartJSONAdapter.h"

@implementation SmartJSONAdapter

- (NSSet *)serializablePropertyKeys:(NSSet *)propertyKeys
                           forModel:(id<SmartJSONAdapting>)model
{
    if ([[model class] respondsToSelector:@selector(withoutNil)]
        && [[model class] withoutNil]) {
        NSMutableSet *propertyKeys_ = [propertyKeys mutableCopy];
        
        [propertyKeys enumerateObjectsUsingBlock:^(NSString *_Nonnull propertyKey,
                                                   BOOL * _Nonnull stop) {
            if ([[NSNull null] isEqual:model.dictionaryValue[propertyKey]]) {
                [propertyKeys_ removeObject:propertyKey];
            }
        }];
        propertyKeys = [propertyKeys_ copy];
    }
    if ([[model class] respondsToSelector:@selector(propertyKeysForJSONRepresentation)]) {
        NSMutableSet *propertyKeys_ = [propertyKeys mutableCopy];
        [propertyKeys_ minusSet:[[model class] propertyKeysForJSONRepresentation]];
        
        propertyKeys = [propertyKeys_ copy];
    }
    return propertyKeys;
}

@end
