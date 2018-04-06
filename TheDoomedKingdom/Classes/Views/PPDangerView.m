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
#import "PPEventResultController.h"

@interface PPDangerView()

@property (nonatomic) BOOL wasTapped;

@end

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

- (void)setEvent:(PPEvent *)event {
    _event = event;

    if (event) {
        self.descrLabel.text = event.eventDescription;
        [self.dangerTypeImageView setImage:[UIImage imageNamed:[event eventTypeIcon]]];

        self.dangerTypeName.text = [event name];
        
        NSArray *eventAbilities = event.abilities;
        
        for (PPDangerAbilityView *view in self.abilities) {
            if (view.tag < eventAbilities.count) {
                PPEventAbility *ability = eventAbilities[view.tag];
                [view setEventAbility:ability];
                
                UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventPressed:)];
                [view addGestureRecognizer:tapRecognizer];
            }
        }
    }
}

- (void)eventPressed:(UITapGestureRecognizer *)tap {
    if (self.wasTapped) {
        return;
    }
    
    self.wasTapped = YES;
    
    PPDangerAbilityView *view = (PPDangerAbilityView *)tap.view;
    PPEventAbility *ability = view.eventAbility;
    
    [PPEventResultController showWithEventAbility:ability];
}


- (void)abilityPressed:(UITapGestureRecognizer *)tap
{
    if (self.wasTapped) {
        return;
    }
    
    self.wasTapped = YES;
    
    PPDangerAbilityView *view = (PPDangerAbilityView *)tap.view;
    PPAbility *ability = view.ability;
    
    PPDanger *danger = self.city.currentDanger;
    danger.inProgress = YES;
    
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:NO];
    
     __weak __typeof(self) weakSelf = self;
    
    __block PPDangerProgressController *cntroller = [PPDangerProgressController showWithDanger:_city.currentDanger andAbility:ability andCompletionBlock:^(BOOL result) {
        [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
        [cntroller hide:nil];
        [PPDangerResultController showWithDanger:weakSelf.city.currentDanger andAbility:ability];
    }];
    
}

@end
