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
#import "EndingsViewController.h"
#import "PPDangerProgressController.h"
#import "PPLibraryViewController.h"

@interface PPBaseGameController ()

@property (nonatomic, strong) PPCityDangerController *dController;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *fieldControls;

@end

@implementation PPBaseGameController
- (IBAction)updatePressed:(id)sender {
    [self parseGameAnimatable:YES];
}

- (void)parseGameAnimatable:(BOOL)withAnimation {
    [SVProgressHUD show];
    
    [UIView animateWithDuration:withAnimation ? AnimationDuration : 0 animations:^{
        for (UIView *view in _fieldControls) {
            view.alpha = 0;
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(withAnimation ? 0.01 : 1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!withAnimation) {
            [SVProgressHUD dismiss];
            [self redrawInterface];
            
            [UIView animateWithDuration:AnimationDuration animations:^{
                for (UIView *view in _fieldControls) {
                    view.alpha = 1;
                }
            }];
        }
        
        [[PPGame instance] parseGameWithUpdate:withAnimation completion:^(BOOL success, NSError *error) {
            if (success) {
                [SVProgressHUD showSuccessWithStatus:@"Игра успешно обновлена!"];
            } else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"ОЙ-ЕЙ-ЕЙ! Ошибка при обновлении: %@", error.localizedDescription]];
            }
            
            [self checkAndRedraw];
            
            [UIView animateWithDuration:AnimationDuration animations:^{
                for (UIView *view in _fieldControls) {
                    view.alpha = 1;
                }
            }];
            
        }];
        
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"UPDATE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearUI:) name:@"CLEAR" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearDANGER:) name:@"CLEARDANGER" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plusHour:) name:@"TICK" object:nil];
    
    for (PPCityView *view in self.cityViews) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityPressed:)];
        [view addGestureRecognizer:tapRecognizer];
    }
    
    PPPlayer *player = [PPGame instance].player;
    self.playerName.text = player.name;
    self.popularityLabel.text = [NSString stringWithFormat:@"Популярность: %li", (long)[player totalPopularity]];
    
    // Do any additional setup after loading the view, typically from a nib.
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

- (void)showResolveDangerPopup:(PPCity *)city
{
    self.dController = [PPCityDangerController showWithCity:city];
}

- (void)showCityInfoPopup:(PPCity *)city
{
    self.dController = (PPCityDangerController *)[PPCityInfoController showWithCity:city];
}



- (void)redrawInterface
{
    
    NSArray *cities = [[[PPGame instance] kingdom] cities];
    
    for (PPCityView *view in self.cityViews) {
        if (view.tag < cities.count) {
            PPCity *city = cities[view.tag];
            [view setCity:city];
        }
    }
    
    PPPlayer *player = [PPGame instance].player;
    self.popularityLabel.text = [NSString stringWithFormat:@"Популярность: %li", (long)[player totalPopularity]];
    
    for (PPPlayerAbilityView *view in self.playerAbilities) {
        NSInteger abIndex = view.tag;
        
        PPAbility *ability = [PPAbility new];
        
        switch (abIndex) {
            case 0:
                ability.abilityName = @"Мана";
                ability.value = player.mana;
                break;
                
            case 1:
                ability.abilityName = @"Расположение короля";
                ability.value = player.kingRep;
                break;
                
            case 2:
                ability.abilityName = @"Расположение народа";
                ability.value = player.peopleRep;
                break;
                
            case 3:
                ability.abilityName = @"Коррапт";
                ability.value = player.corrupt;
                break;
                
            default:
                break;
        }
        
        [view setAbility:ability];
        
    }

    
    self.timeLabel.text = [NSString stringWithFormat:@"День: %li", (long)([[PPGame instance] currentTimeHours])];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)checkAndRedraw
{
    //    if (self.dController && self.dController.view.superview && [self.dController class] != [PPCityInfoController class]) {
    //        [self.dController hide:nil];
    //    }
    
    NSMutableArray *dangersInProgress = [@[] mutableCopy];
    
    NSArray *dangerToApply = [[PPGame instance] dangersToApply];
    
    if (dangerToApply && dangerToApply.count > 0) {
        BOOL wasDanger = NO;
        
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
                    if (!wasDanger) {
                        [[SoundController sharedInstance] playDanger];
                        wasDanger = YES;
                    }
                    
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
    
    [self redrawInterface];
}

- (void)timerTick
{
    
    [PPGame instance].currentTimeHours += 1;
    
    
    
    
    if ([[PPGame instance] leftTimeHours] <= 0) {
        [EndingsViewController triggerEndingWithController:self];
    } else {
        [[PPGame instance] player].mana += ABILITIES_REGEN_VALUE_IN_DAY;
//        for (PPAbility *abil in [ abilities]) {
//            abil.value += ABILITIES_REGEN_VALUE_IN_HOUR;
//        }
        
        [self checkAndRedraw];
    }
}

- (void)viewWillAppear:(BOOL)animated {
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
    [PPLibraryViewController show];
}

@end
