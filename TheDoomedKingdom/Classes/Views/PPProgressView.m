//
//  PPProgressView.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPProgressView.h"
#import "PPDangerProgressController.h"

#define DurationPerImage 0.2

typedef void(^CompletionBlock)(BOOL result);

@interface PPProgressView()

@property (nonatomic, copy) CompletionBlock completionBlock;
@property (nonatomic, assign) NSInteger currentValue;

@end

@implementation PPProgressView

- (void)animatePlayerWithImages:(NSArray *)anImages nextImage:(NSInteger)next {
    NSInteger index = next % anImages.count;
    UIImage *newImage = anImages[index];
    __weak __typeof(self) weakSelf = self;
    __block NSInteger nextIndex = index + 1;
    
    [UIView transitionWithView:self.playerImageView
                      duration:DurationPerImage
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.playerImageView.image = newImage;
                    } completion:^(BOOL finished) {
                        [weakSelf animatePlayerWithImages:anImages nextImage:nextIndex];
                    }];
}

- (void)initWithAbility:(PPAbility *)ability
              andDanger:(PPDanger *)danger
andCompletionBlock:(void (^)(BOOL))aCompletionBlock
{
    self.completionBlock = aCompletionBlock;
    
    self.ability = ability;
    self.danger = danger;
    
    if (ability) {
        self.abilityActionStringLabel.text = [ability abilityActionString];
        PPAbilityType abType = ability.abilityType;
        
        NSArray *images = nil;
        
        if (abType == PPAbilityTypeTelekinesis) {
            images = @[[UIImage imageNamed:@"1_1.png"],
                       [UIImage imageNamed:@"1_2.png"],];
        } else if (abType == PPAbilityTypeAppeal) {
            images = @[[UIImage imageNamed:@"2_1.png"],
                       [UIImage imageNamed:@"2_2.png"],];
        } else if (abType == PPAbilityTypeHypnosis) {
            images = @[[UIImage imageNamed:@"4_1.png"],
                       [UIImage imageNamed:@"4_2.png"],
                       [UIImage imageNamed:@"4_3.png"],];
        } else if (abType == PPAbilityTypeChaos) {
            images = @[[UIImage imageNamed:@"3_1.png"],
                       [UIImage imageNamed:@"3_2.png"],];
        }
        
        
        self.playerImageView.image = images.firstObject;
        [self animatePlayerWithImages:images nextImage:1];
        
//        self.playerImageView.image = [UIImage animatedImageWithImages:images duration:DurationPerImage * images.count];
        
        NSInteger hoursToRemove = ability.timeToDestroyDanger;
        self.currentValue = 0.;
        
        [self.progressBar setProgress:0.];
        
        [[SoundController sharedInstance] playCasting];
        
        self.dangerImageView.image = [UIImage imageNamed:[danger dangerTypeIcon]];
        
        self.hoursLabel.text = [NSString stringWithFormat:@"%li часов / %li", (long)self.currentValue, (long)hoursToRemove];
    }
    
    [self performSelector:@selector(checkvalue) withObject:nil afterDelay:1.2];
}

- (void)checkvalue
{
    NSInteger timeToDestroy = self.ability.timeToDestroyDanger;
    
    if (self.currentValue < timeToDestroy) {
        self.currentValue += 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TICK" object:nil];
        [self.progressBar setProgress:(CGFloat)(self.currentValue) / (CGFloat)timeToDestroy animated:YES duration:0.8];
        
        
        self.hoursLabel.text = [NSString stringWithFormat:@"%li часов / %li", (long)self.currentValue, (long)timeToDestroy];
        [self performSelector:@selector(checkvalue) withObject:nil afterDelay:0.8];
    } else {
        if (self.completionBlock) {
            self.completionBlock(YES);
        }
        
        if (self.closeDelegate && [self.closeDelegate respondsToSelector:@selector(close)]) {
            [self.closeDelegate close];
        }
    }
}

@end
