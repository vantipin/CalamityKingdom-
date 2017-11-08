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
@property (nonatomic, assign) PPCityViewType viewType;

@end

@implementation PPBaseGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewType = PPCityViewTypeDefault;
    
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
    
    self.viewType = PPCityViewTypeDefault;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)updateUI:(NSNotification *)notification
{
    [self checkAndRedraw];
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
    [self.viewTypeButton setHidden:![[PPGame instance] visionAffectedTime]];
    
    [self.viewTypeButton setTitle:(self.viewType == PPCityViewTypeDefault ? @"Обычный режим" : @"Режим предвидения") forState:UIControlStateNormal];
    
    NSArray *cities = [[[PPGame instance] kingdom] cities];
    
    for (PPCityView *view in self.cityViews) {
        if (view.tag < cities.count) {
            PPCity *city = cities[view.tag];
            [view setCity:city forVisionType:self.viewType];
        }
    }
    
    PPPlayer *player = [PPGame instance].player;
    self.popularityLabel.text = [NSString stringWithFormat:@"Популярность: %li", (long)[player totalPopularity]];
    
    NSArray *abilities = player.abilities;
    
    for (PPPlayerAbilityView *view in self.playerAbilities) {
        if (view.tag < abilities.count) {
            PPAbility *ability = abilities[view.tag];
            [view setAbility:ability];
        }
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"День: %li\nЧас: %li", (long)([[PPGame instance] currentTimeHours] / 24), (long)[[PPGame instance] currentTimeHours] % 24];
    
    [self.viewTypeButton setHidden:![[PPGame instance] visionAffectedTime]];
}

- (void)checkAndRedraw
{
    //    if (self.dController && self.dController.view.superview && [self.dController class] != [PPCityInfoController class]) {
    //        [self.dController hide:nil];
    //    }
    
    NSArray *dangerToApply = [[PPGame instance] dangersToApply];
    
    if (dangerToApply && dangerToApply.count > 0) {
        BOOL wasDanger = NO;
        
        for (PPDanger *danger in dangerToApply) {
            if (danger.predefinedCity) {
                PPCity *city = danger.predefinedCity;
                
                if (city.cityInDanger) {
                    PPDanger *cityDanger = city.currentDanger;
                    
                    if (!cityDanger.inProgress) {
                        danger.timeToAppear = cityDanger.timeToAppear + cityDanger.maxTimeForDanger + 1 + arc4random() % 3;
                    } else {
                        danger.timeToAppear += 1 + arc4random() % 3;
                    }
                } else {
                    city.currentDanger = danger;
                    danger.affectedCity = city;
                    danger.predefinedCity = nil;
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
    
    
    
    [self redrawInterface];
}

- (void)timerTick
{
    
    [PPGame instance].currentTimeHours += 1;
    
    
    
    
    if ([[PPGame instance] leftTimeHours] <= 0) {
        [EndingsViewController triggerEndingWithController:self];
    } else {
        for (PPAbility *abil in [[[PPGame instance] player] abilities]) {
            abil.value += ABILITIES_REGEN_VALUE_IN_HOUR;
        }
        
        [self checkAndRedraw];
        
        BOOL visionTime = [[PPGame instance] visionAffectedTime];
        
        if (self.viewType == PPCityViewTypeVision && !visionTime) {
            self.viewType = PPCityViewTypeDefault;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[PPGame instance] parseGame];
    [self checkAndRedraw];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)plusHour:(id)sender
{
    [self timerTick];
}

- (IBAction)activateVision:(id)sender
{
    PPGame *game = [PPGame instance];
    
    if (![game visionAffectedTime]) {
        
        [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:NO];
        
        __block PPDangerProgressController *cntroller = [PPDangerProgressController showWithDanger:nil
                                                                                andAbility:nil andCompletionBlock:^(BOOL result) {
                                                                                    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
                                                                                    [cntroller hide:nil];
                                                                                    
                                                                                    NSArray *affectedDangers = [game dangersAffectedWithVision];
                                                                                    NSArray *allCities = game.kingdom.cities;
                                                                                    NSMutableArray *usedCities = [@[] mutableCopy];
                                                                                    
                                                                                    for (PPDanger *danger in affectedDangers) {
                                                                                        NSMutableArray *freeCities = [[[PPGame instance] freeCities] mutableCopy];
                                                                                        
                                                                                        if (freeCities) {
                                                                                            [freeCities removeObjectsInArray:usedCities];
                                                                                        }
                                                                                        
                                                                                        NSMutableArray *currentlyNotFree = [allCities mutableCopy];
                                                                                        [currentlyNotFree removeObjectsInArray:usedCities];
                                                                                        
                                                                                        if (freeCities && freeCities.count > 0) {
                                                                                            NSInteger randomIndex = arc4random() % freeCities.count;
                                                                                            PPCity *affectedCity = freeCities[randomIndex];
                                                                                            
                                                                                            danger.predefinedCity = affectedCity;
                                                                                            [usedCities addObject:affectedCity];
                                                                                        } else if (currentlyNotFree && currentlyNotFree.count > 0) {
                                                                                            NSInteger randomIndex = arc4random() % currentlyNotFree.count;
                                                                                            PPCity *affectedCity = currentlyNotFree[randomIndex];
                                                                                            
                                                                                            danger.predefinedCity = affectedCity;
                                                                                            [usedCities addObject:affectedCity];
                                                                                        } else {
                                                                                            NSInteger randomIndex = arc4random() % allCities.count;
                                                                                            PPCity *affectedCity = allCities[randomIndex];
                                                                                            
                                                                                            danger.predefinedCity = affectedCity;
                                                                                            [usedCities addObject:affectedCity];
                                                                                        }
                                                                                        
                                                                                    }
                                                                                    
                                                                                    self.viewType = PPCityViewTypeVision;
                                                                                }];
        
    }
}

- (IBAction)changeViewType:(id)sender
{
    if ([[PPGame instance] visionAffectedTime]) {
        [self inverseViewType];
    }
}

- (IBAction)libraryPressed:(id)sender
{
    [PPLibraryViewController show];
}

- (void)inverseViewType
{
    self.viewType = self.viewType == PPCityViewTypeDefault ? PPCityViewTypeVision : PPCityViewTypeDefault;
}

- (void)setViewType:(PPCityViewType)viewType
{
    if (viewType != _viewType) {
        _viewType = viewType;
        
        [self redrawInterface];
    }
}

@end
