//
//  PPCityView.m
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import "PPCityView.h"
#import "PPGame.h"
#import <QuartzCore/QuartzCore.h>

@implementation PPCityView

- (void)setCity:(PPCity *)city
{
    [self setCity:city forVisionType:PPCityViewTypeDefault];
}

- (void)setCity:(PPCity *)city forVisionType:(PPCityViewType)viewType
{
    _city = city;
    
    if (city) {
        self.nameLabel.text = city.name;
        
        if (self.descrLabel) {
            self.descrLabel.text = city.cityDescription;
        }
        
        if (self.popularityLabel) {
            NSInteger cityPopularity = city.currentMagePopularity;
            self.popularityLabel.text = [NSString stringWithFormat:@"Популярность: %li", (long)cityPopularity];
        }
        
        NSInteger currValue = 100 - (100 * (CGFloat)city.currPeopleCount / (CGFloat)city.initPeopleCount);
        [self.progressBar updateToCurrentValue:currValue animated:YES];
        
        if (self.currLiveLabel) {
            [self.currLiveLabel setHidden:YES];
//            [self.currLiveLabel setText:[NSString stringWithFormat:@"%li жителей (%li%% выживших)", (long)city.currPeopleCount, (long)(100. * (CGFloat)city.currPeopleCount / (CGFloat)city.initPeopleCount)]];
//            [self.currLiveLabel.layer setMasksToBounds:NO];
//            self.currLiveLabel.layer.shadowRadius = 6.;
//            self.currLiveLabel.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//            self.currLiveLabel.layer.shadowOffset = CGSizeMake(2., 2.);
//            self.currLiveLabel.layer.shadowOpacity = 0.5;
        }
        
        NSString *cityNameString = @"";
        
        if ([city.name isEqualToString:@"Удачбург"]) {
            cityNameString = @"CapitalCity.png";
        } else if ([city.name isEqualToString:@"Потехогорск"]) {
            cityNameString = @"Town2City.png";
        } else if ([city.name isEqualToString:@"Счастьеградск"]) {
            cityNameString = @"Town1City.png";
        } else if ([city.name isEqualToString:@"Васьки"] || [city.name isEqualToString:@"Овнище"]) {
            cityNameString = @"VillageLumbererCity.png";
        } else if ([city.name isEqualToString:@"Кайфобад"] || [city.name isEqualToString:@"Блинск"]) {
            cityNameString = @"VillageVariorsCity.png";
        } else if ([city.name isEqualToString:@"Чпокино"] || [city.name isEqualToString:@"Новопозорнино"]) {
            cityNameString = @"VillageFishermansCity.png";
        }
        
//            if (city.initPeopleCount >= 10000 && city.initPeopleCount < 20000) {
//                cityNameString = @"MidCity.png";
//            } else if (city.initPeopleCount < 10000) {
//                cityNameString = @"SmallCity.png";
//            }
//            
            self.cityIconImageView.image = [UIImage imageNamed:cityNameString];
//        }
        
        BOOL inDanger = NO;
        
        if (viewType == PPCityViewTypeDefault) {
            inDanger = city.cityInDanger;
        } else {
            inDanger = [[PPGame instance] cityInVisionDanger:city];
        }
        
        self.cityIconImageView.alpha = viewType == PPCityViewTypeDefault ? 1. : 0.7;
        
        UIView *view = [self viewWithTag:666];
        
        if (view) {
            [view setHidden:!inDanger];
        }
        
        view = [self viewWithTag:6666];
        
        if (view) {
            [view setHidden:!inDanger];
        }
    }
}

@end
