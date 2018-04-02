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
#import "PPEventAbility.h"
#import "EndingsViewController.h"

@implementation PPResultView

- (void)initWithAbility:(PPAbility *)ability andDanger:(PPDanger *)danger
{
    danger.result.helpAbilityType = ability.abilityType;
    
    NSString *cityName = [danger.affectedCity name];
    
    self.resultDescriptionLabel.text = [ability.abilityDescription stringByReplacingOccurrencesOfString:@"gorodname" withString:cityName];
    
    NSInteger died = [danger.result peopleCountToDieWithType];
    
    PPCity *affCity = [danger affectedCity];
    [affCity recalculateCurrentRatingWithDanger:danger andAbilityType:ability.abilityType];
    
    [[PPGame instance] player].mana -= ability.manaCost;
    [[PPGame instance] player].kingRep -= ability.kingRepCost;
    [[PPGame instance] player].peopleRep -= ability.peopleRepCost;
    [[PPGame instance] player].corrupt -= ability.corruptCost;

    
    [[SoundController sharedInstance] playBattleWin];
    
    self.finalLabel.text = [NSString stringWithFormat:@"Жертвы: %li                   Популярность: %li", (long)died, (long)affCity.currentMagePopularity];
    
    affCity.currentDanger = nil;
}

- (void)initWithEventAbility:(PPEventAbility *)ability {
    self.resultDescriptionLabel.text = ability.abilityDescription;
    
    [[PPGame instance] player].mana += ability.mana;
    [[PPGame instance] player].kingRep += ability.kingRep;
    [[PPGame instance] player].peopleRep += ability.peopleRep;
    [[PPGame instance] player].corrupt += ability.corrupt;
    
    if (ability.ending != UndefValue) {
        [[SoundController sharedInstance] playBattleWin];
    } else {
        [EndingsViewController triggerEndingWithController:[UIApplication sharedApplication].keyWindow.rootViewController endingId:ability.ending];
    }
}

@end
