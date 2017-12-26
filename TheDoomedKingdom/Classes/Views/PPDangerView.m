//
//  PPDangerView.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPDangerView.h"
#import "PPDangerAbilityView.h"
#import "PPDangerProgressController.h"
#import "PPDangerResultController.h"

@implementation PPDangerView

- (void)setCity:(PPCity *)city
{
    _city = city;
    
    PPDanger *danger = city.currentDanger;
    
    if (danger) {
//        self.nameLabel.text = danger.name;
        
        NSString *cityName = [city name];
        
        self.descrLabel.text = [danger.dangerDescription stringByReplacingOccurrencesOfString:@"gorodname" withString:cityName];
        
        [self.dangerTypeImageView setImage:[UIImage imageNamed:[danger dangerTypeIcon]]];
        
//        self.dangerLevelName.text = [NSString stringWithFormat:@"Уровень угрозы: %@", [danger dangelLevelName]];
        self.dangerTypeName.text = [danger dangelTypeName];
        
        NSArray *dangerAbilities = danger.abilitiesToRemove;
        
        for (PPDangerAbilityView *view in self.abilities) {
            if (view.tag < dangerAbilities.count) {
                PPAbility *ability = dangerAbilities[view.tag];
                [view setAbility:ability];
                
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(abilityPressed:)];
                [view addGestureRecognizer:tapRecognizer];
            }
        }
    }    
}

- (void)abilityPressed:(UITapGestureRecognizer *)tap
{
    PPDangerAbilityView *view = (PPDangerAbilityView *)tap.view;
    PPAbility *ability = view.ability;
    
    PPDanger *danger = self.city.currentDanger;
    danger.inProgress = YES;
    
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:NO];
    
    __block PPDangerProgressController *cntroller = [PPDangerProgressController showWithDanger:_city.currentDanger andAbility:ability andCompletionBlock:^(BOOL result) {
        [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
        [cntroller hide:nil];
        [PPDangerResultController showWithDanger:_city.currentDanger andAbility:ability];
    }];
    
}

@end
