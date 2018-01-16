//
//  PPResultView.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPResultView.h"
#import "PPDangerResult.h"
#import "PPCity.h"
#import "PPGame.h"
#import "SoundController.h"

@implementation PPResultView

- (void)initWithAbility:(PPAbility *)ability andDanger:(PPDanger *)danger
{
    danger.result.helpAbilityType = ability.abilityType;
    
    NSString *cityName = [danger.affectedCity name];
    
    self.resultDescriptionLabel.text = [ability.abilityDescription stringByReplacingOccurrencesOfString:@"gorodname" withString:cityName];
    
    NSInteger died = [danger.result peopleCountToDieWithType];
    
    PPCity *affCity = [danger affectedCity];
    [affCity recalculateCurrentRatingWithDanger:danger andAbilityType:ability.abilityType];
    
    [[PPGame instance] player].mana -= ability.value;
    
//    for (PPAbility *pAbility in [[[PPGame instance] player] abilities]) {
//        if (pAbility.abilityType == ability.abilityType) {
//            pAbility.value -= ability.value;
//            break;
//        }
//    }
//
    [[SoundController sharedInstance] playBattleWin];
    
    self.finalLabel.text = [NSString stringWithFormat:@"Жертвы: %li                   Популярность: %li", (long)died, (long)affCity.currentMagePopularity];
    
    affCity.currentDanger = nil;
}

@end
