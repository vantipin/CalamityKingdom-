//
//  ViewController.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPBaseGameController.h"
#import "PPGame.h"
#import "PPCity.h"
#import "PPDanger.h"
#import "PPDangerResult.h"
#import "PPCityView.h"
#import "PPPlayer.h"
#import "PPPlayerAbilityView.h"
#import "PPCityInfoController.h"
#import "PPCityDangerController.h"
#import "SoundController.h"
#import "PPEndingsViewController.h"
#import "PPDangerProgressController.h"
#import "PPEventViewController.h"
#import "PPLibraryViewController.h"
#import "PPLandingController.h"

@interface PPBaseGameController ()

@property (nonatomic, strong) PPCityDangerController *dController;
@property (nonatomic, strong) PPEventViewController *eventController;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *fieldControls;

@property (nonatomic) BOOL wasTapped;

@end

@implementation PPBaseGameController

- (IBAction)updatePressed:(id)sender {
    [self parseGameAnimatable:YES];
}

- (IBAction)magePressed:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Меню" message:@"Показать меню?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [PPLandingController show];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

+ (void)show {
    PPBaseGameController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PPBaseGameControllerID"];
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [UIView transitionFromView:window.rootViewController.view
                        toView:viewController.view
                      duration:0.65f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished){
                       
                        viewController.skipUpdates = YES;
                        window.rootViewController = viewController;
                        viewController.skipUpdates = NO;
                    }];
}

- (void)parseGameAnimatable:(BOOL)withAnimation {
    [SVProgressHUD show];
    
    [UIView animateWithDuration:withAnimation ? AnimationDuration : 0 animations:^{
        for (UIView *view in self->_fieldControls) {
            view.alpha = 0;
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(withAnimation ? 0.01 : 1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!withAnimation) {
            [SVProgressHUD dismiss];
            [self redrawInterface];
            
            [UIView animateWithDuration:AnimationDuration animations:^{
                for (UIView *view in self->_fieldControls) {
                    view.alpha = 1;
                }
            }];
        }
        
        [[PPGame instance] parseGameWithUpdate:withAnimation progress:^(CGFloat progress) {
//            <#code#>
        } completion:^(BOOL success, NSError *error) {
            [SVProgressHUD dismiss];
            
            [self checkAndRedraw];
            
            [UIView animateWithDuration:AnimationDuration animations:^{
                for (UIView *view in self->_fieldControls) {
                    view.alpha = 1;
                }
            }];
            
        }];
        
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger viewIndex = 0; viewIndex < self.view.subviews.count; viewIndex++) {
        UIView *view = self.view.subviews[viewIndex];
        view.alpha = (viewIndex == 0 || viewIndex == self.view.subviews.count - 1) ? 1 : 0;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"UPDATE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearUI:) name:@"CLEAR" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearDANGER:) name:CLEARDANGER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearEvent:) name:CLEAREVENT object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plusHour:) name:@"TICK" object:nil];
    
    for (PPCityView *view in self.cityViews) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityPressed:)];
        [view addGestureRecognizer:tapRecognizer];
    }
}

- (void)updateUI:(NSNotification *)notification
{
    [self redrawInterface];
}

- (void)clearUI:(NSNotification *)notification
{
    if (self.dController && [self.dController class] == [PPCityInfoController class]) {
        self.dController = nil;
    }
}

- (void)clearEvent:(NSNotification *)notification
{
    if (self.eventController && [self.eventController class] == [PPEventViewController class]) {
        [self.eventController hide];
        self.eventController = nil;
    }
}

- (void)clearDANGER:(NSNotification *)notification
{
    if (self.dController && [self.dController class] == [PPCityDangerController class]) {
        [self.dController hide:@(1)];
        self.dController = nil;
    }
}

- (void)cityPressed:(UITapGestureRecognizer *)tap
{
    PPCityView *view = (PPCityView *)[tap view];
    NSArray *cities = [[[PPGame instance] kingdom] cities];
    
    if (view.tag < cities.count) {
        PPCity *city = cities[view.tag];
        
        if (city.cityInDanger) {
            [self showResolveDangerPopup:city];
        } else {
            [self showCityInfoPopup:city];
        }
    }
}

- (void)showResolveDangerPopup:(PPCity *)city {
    if (self.wasTapped) {
        return;
    }
    
    self.wasTapped = YES;

    self.dController = [PPCityDangerController showWithCity:city completion:^{
        self.wasTapped = NO;
    }];
}

- (void)showCityInfoPopup:(PPCity *)city {
    if (self.wasTapped) {
        return;
    }
    
    self.wasTapped = YES;

    self.dController = (PPCityDangerController *)[PPCityInfoController showWithCity:city completion:^{
        self.wasTapped = NO;
    }];
}



- (void)redrawInterface {
    NSArray *cities = [[[PPGame instance] kingdom] cities];
    
    for (PPCityView *view in self.cityViews) {
        if (view.tag < cities.count) {
            PPCity *city = cities[view.tag];
            [view setCity:city];
        }
    }
    
    PPPlayer *player = [PPGame instance].player;
    
    for (PPPlayerAbilityView *view in self.playerAbilities) {
        NSInteger abIndex = view.tag;
        
        PPAbility *ability = [PPAbility new];
        
        switch (abIndex) {
            case 0:
                ability.abilityName = [PPGame instance].gameConstants.mana.name;
                ability.manaCost = player.mana;
                break;
                
            case 1:
                ability.abilityName = [PPGame instance].gameConstants.king_rep.name;
                ability.manaCost = player.kingRep;
                break;
                
            case 2:
                ability.abilityName = [PPGame instance].gameConstants.people_rep.name;
                ability.manaCost = player.peopleRep;
                break;
                
            case 3:
                ability.abilityName = [PPGame instance].gameConstants.corrupt.name;
                ability.manaCost = player.corrupt;
                break;
                
            default:
                break;
        }
        
        [view setAbility:ability];
        
    }

    
    self.timeLabel.text = [NSString stringWithFormat:@"День: %li", (long)([[PPGame instance] daysCount])];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)checkAndRedraw
{
    NSMutableArray *dangersInProgress = [@[] mutableCopy];
    
    NSArray *dangerToApply = [[PPGame instance] dangersToApply];
    
    if (dangerToApply && dangerToApply.count > 0) {
        for (PPDanger *danger in dangerToApply) {
            if (danger.predefinedCity) {
                PPCity *city = danger.predefinedCity;
                
                if (city.cityInDanger) {
                    PPDanger *cityDanger = city.currentDanger;
                    
                    if (!cityDanger.inProgress) {
                        danger.timeToAppear += 1 + arc4random() % 3;
                    }
                } else {
                    city.currentDanger = danger;
                    danger.affectedCity = city;
                    danger.inProgress = YES;
                    danger.predefinedCity = nil;
                    
                    [dangersInProgress addObject:danger];
                }
            } else {
                NSArray *freeCities = [[PPGame instance] freeCities];
                
                if (freeCities && freeCities.count > 0) {
                    NSInteger randomIndex = arc4random() % freeCities.count;
                    PPCity *affectedCity = freeCities[randomIndex];
                    affectedCity.currentDanger = danger;
                    danger.affectedCity = affectedCity;
                    danger.predefinedCity = nil;
                    danger.inProgress = YES;
                    
                    [dangersInProgress addObject:danger];
                }
            }
        }
    }
    
    // FIRE
    NSArray *firedDangers = [[PPGame instance] firedDangers];
    
    if (firedDangers && firedDangers.count > 0) {
        for (PPDanger *danger in firedDangers) {
            PPCity *affectedCity = danger.affectedCity;
            
            [affectedCity recalculateCurrentRatingWithDanger:danger];
            danger.removed = YES;
            affectedCity.currentDanger = nil;
        }
    }
    
    for (PPDanger *danger in dangersInProgress) {
        danger.inProgress = NO;
    }
    
    [dangersInProgress removeAllObjects];
    
    BOOL hasPeople = false;
    
    for (PPCity *city in [PPGame instance].kingdom.cities) {
        if (city.currPeopleCount > 0) {
            hasPeople = true;
            break;
        }
    }
    
    if (hasPeople) {
        [self redrawInterface];
        [self checkEvents];
    } else {
        [PPEndingsViewController showWithEndingId:DEFEAT_ENDING_ID];
    }
}

- (void)checkEvents {
    PPEvent *event = [[PPGame instance] currDayEvent];
    
    if (event) {
        if (self.wasTapped) {
            return;
        }
        
        self.wasTapped = YES;
        
        self.eventController = [PPEventViewController showWithEvent:event completion:^{
            self.wasTapped = NO;
        }];
    }
}

- (void)timerTick {
    [PPGame instance].daysCount += 1;
    
    if ([[PPGame instance] leftTimeHours] <= 0) {
        [PPEndingsViewController showWithEndingId:WON_ENDING_ID];
    } else {
        [[PPGame instance] player].mana += [PPGame instance].gameConstants.mana_regen.constValue.integerValue;

        [self checkAndRedraw];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.skipUpdates) {
        return;
    }
    
    [super viewWillAppear:animated];
    
    [self parseGameAnimatable:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)plusHour:(id)sender
{
    [self timerTick];
}

- (IBAction)libraryPressed:(id)sender
{
    if (self.wasTapped) {
        return;
    }
    
    self.wasTapped = YES;
    
    [PPLibraryViewController showWithCompletion:^{
        self.wasTapped = NO;
    }];
}

@end
