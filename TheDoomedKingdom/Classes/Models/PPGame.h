//
//  PPGame.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPKingdom.h"
#import "PPPlayer.h"
#import "PPGlobalConstants.h"

@class PPCity;

@interface PPGame : NSObject

@property (nonatomic, strong) PPKingdom *kingdom; // Usless current kingdom model, remove in future (or use with multiple kingdoms)
@property (nonatomic, strong) PPPlayer *player; // Current player with abilities and popularity
@property (nonatomic, strong) NSArray *dangers; // All dangers

@property (nonatomic, strong) NSArray *libraryItems; // All Library Items
@property (nonatomic, readonly) NSArray *shuffledLibraryItems;

@property (nonatomic, readonly) NSArray *liveDangers; // All not removed dangers
@property (nonatomic, readonly) NSArray *usedDangers; // All removed dangers

@property (nonatomic, assign) NSInteger currentTimeHours; // Current time in hours
@property (nonatomic, readonly) NSInteger leftTimeHours; // Time left for trigger ending

+ (PPGame *)instance;
- (void)parseGame;

- (NSArray *)firedDangers; // Dangers for apply default damage

// Visison methods
- (NSArray *)dangersAffectedWithVision; // Dangers for apply with vision to cities
- (BOOL)visionAffectedTime; // Check current vision state
- (BOOL)cityInVisionDanger:(PPCity *)city; // Check City for Predefined danger

// Free dangers (whose time has come) and free (from dangers) cities to randomize and apply dangers
- (NSArray *)dangersToApply;
- (NSArray *)freeCities;


// - Send notification to recheck, update current state and redraw interface
- (void)checkState;

@end
