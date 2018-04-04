//
//  PPPlayer.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PPAbility;

@interface PPPlayer : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic) NSString *playerProfileIcon;
@property (nonatomic) NSInteger mana;
@property (nonatomic) NSInteger kingRep;
@property (nonatomic) NSInteger peopleRep;
@property (nonatomic) NSInteger corrupt;

@end
