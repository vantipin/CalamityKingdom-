//
//  SoundController.m
//  TheDoomedKingdom
//
//  Created by Vlad Antipin on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "SoundController.h"
#import <AVFoundation/AVFoundation.h>

#define PLAY_SOUND 1

static SoundController *instance = nil;

@interface SoundController()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioPlayer *soundPlayer;

@end

@implementation SoundController

+ (SoundController *)sharedInstance {
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        if (nil == instance) {
            instance = [[SoundController alloc] init];
            //launch music
            NSURL *audioFileURL = [[NSBundle mainBundle] URLForResource:@"main_music" withExtension:@"mp3"];
            NSError *error;
            instance.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:&error];
            
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }
            
            [instance.audioPlayer setNumberOfLoops:-1];
            
            if (PLAY_SOUND && [instance.audioPlayer prepareToPlay]) {
                [instance.audioPlayer play];
            }
        }
    });
    return instance;
}

- (void)playSoundWithName:(NSString *)name withExtension:(NSString *)extension
{
    if (!PLAY_SOUND) {
        return;
    }
    
    if (self.soundPlayer) {
        [self.soundPlayer stop];
    }
    
    NSURL *audioFileURL = [[NSBundle mainBundle] URLForResource:name withExtension:extension];
    NSError *error;
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self.soundPlayer setNumberOfLoops:0];
    
    if ([self.soundPlayer prepareToPlay]) {
        [self.soundPlayer play];
    }
}

- (void)pause {
    [instance.audioPlayer pause];
}

- (void)resume {
    if (!PLAY_SOUND) {
        return;
    }
    if ([self.soundPlayer prepareToPlay]) {
        [self.soundPlayer play];
    }
}

//play spell casting
- (void)playCasting {
    [self playSoundWithName:@"casting" withExtension:@"m4a"];
}

//play danger
- (void)playDanger {
    [self playSoundWithName:@"danger_happen" withExtension:@"wav"];
}

//play battle loosing
- (void)playBattleLost {
    [self playSoundWithName:@"battle_loosing" withExtension:@"wav"];
}

//play battle winning
- (void)playBattleWin {
    [self playSoundWithName:@"battle_win" withExtension:@"wav"];
}

- (void)playSoundName:(NSString *)soundName {
    [self playSoundWithName:soundName withExtension:@"wav"];
}

//play time ticking
- (void)playTicking {
    [self playSoundWithName:@"time_ticking" withExtension:@"wav"];
}


@end
