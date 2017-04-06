//
//  SoundController.h
//  TheDoomedKingdom
//
//  Created by Vlad Antipin on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundController : NSObject

//call to start play main music
+ (SoundController *)sharedInstance;

//SOUNDS
//play spell casting
- (void)playCasting;

//play danger
-(void)playDanger;

//play battle loosing
-(void)playBattleLost;

//play battle winning
-(void)playBattleWin;

//play time ticking
-(void)playTicking;

- (void)pause;
- (void)resume;

@end
