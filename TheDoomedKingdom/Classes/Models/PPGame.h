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
#import "PPGameConstant.h"

@class PPCity, PPEvent;

typedef void (^PPGameCallback)(BOOL success, NSError *error);
typedef void (^PPProgressCallback)(CGFloat progress);

@interface PPGame : NSObject

@property (nonatomic) PPGameConstant *gameConstants;
@property (nonatomic, strong) PPKingdom *kingdom; // Usless current kingdom model, remove in future (or use with multiple kingdoms)
@property (nonatomic, strong) PPPlayer *player; // Current player with abilities and popularity
@property (nonatomic, strong) NSArray *dangers; // All dangers
@property (nonatomic, strong) NSArray *events;
@property (nonatomic) NSArray *endings; // Game endings


@property (nonatomic, strong) NSArray *libraryItems; // All Library Items
@property (nonatomic, readonly) NSArray *shuffledLibraryItems;

@property (nonatomic, readonly) NSArray *liveDangers; // All not removed dangers
@property (nonatomic, readonly) NSArray *usedDangers; // All removed dangers

@property (nonatomic, readonly) PPEvent *currDayEvent; // Event for current day

@property (nonatomic, assign) NSInteger daysCount; // Current time in hours
@property (nonatomic, readonly) NSInteger leftTimeHours; // Time left for trigger ending

+ (PPGame *)instance;
- (void)parseGameWithUpdate:(BOOL)withUpdate
                   progress:(PPProgressCallback)progress
                 completion:(PPGameCallback)completion;

- (NSArray *)firedDangers; // Dangers for apply default damage

// Free dangers (whose time has come) and free (from dangers) cities to randomize and apply dangers
- (NSArray *)dangersToApply;
- (NSArray *)freeCities;


// - Send notification to recheck, update current state and redraw interface
- (void)checkState;

@end
