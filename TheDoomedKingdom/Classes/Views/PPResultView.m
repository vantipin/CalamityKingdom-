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
    
    [danger.result peopleCountToDieWithType];
    
    PPCity *affCity = [danger affectedCity];
    NSInteger died = [affCity recalculateCurrentRatingWithDanger:danger andAbilityType:ability.abilityType];
    
    [[PPGame instance] player].mana -= ability.manaCost;
    [[PPGame instance] player].kingRep -= ability.kingRepCost;
    [[PPGame instance] player].peopleRep -= ability.peopleRepCost;
    [[PPGame instance] player].corrupt -= ability.corruptCost;

    
    [[SoundController sharedInstance] playBattleWin];
    
    PPGameConstant *gc = [PPGame instance].gameConstants;
    NSMutableString *final = [NSMutableString string];
    
    if (died > 0) {
        [final appendFormat:@"Жертвы: %li", (long)died];
    }
    
    if (ability.manaCost != 0) {
        [final appendFormat:@"%@%@: %li", final.length > 0 ? @", " : @"", gc.mana.name, (long)ability.manaCost];
    }
    
    if (ability.kingRepCost != 0) {
        [final appendFormat:@"%@%@: %li", final.length > 0 ? @", " : @"", gc.king_rep.name, (long)ability.kingRepCost];
    }
    
    if (ability.peopleRepCost != 0) {
        [final appendFormat:@"%@%@: %li", final.length > 0 ? @", " : @"", gc.people_rep.name, (long)ability.peopleRepCost];
    }
    
    if (ability.corruptCost != 0) {
        [final appendFormat:@"%@%@: %li", final.length > 0 ? @", " : @"", gc.corrupt.name, (long)ability.corruptCost];
    }
    
    self.finalLabel.text = final;
    
    affCity.currentDanger = nil;
}


@end
