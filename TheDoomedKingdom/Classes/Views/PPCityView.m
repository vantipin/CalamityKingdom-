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

- (void)configureShadow {
    self.cityIconImageView.layer.shadowColor = [UIColor whiteColor].CGColor;
}

- (void)setCity:(PPCity *)city
{
    _city = city;
    
    if (city) {
        [self configureShadow];
        
        self.nameLabel.text = city.name;
        
        if (self.descrLabel) {
            self.descrLabel.text = city.cityDescription;
        }
        
        if (self.popularityLabel) {
            NSInteger cityPopularity = city.currentMagePopularity;
            self.popularityLabel.text = [NSString stringWithFormat:@"Популярность: %li", (long)cityPopularity];
            
            [self.currLiveLabel setHidden:NO];
            [self.currLiveLabel setText:[NSString stringWithFormat:@"%li жителей (%li%% выживших)", (long)city.currPeopleCount, (long)(100. * (CGFloat)city.currPeopleCount / (CGFloat)city.initPeopleCount)]];
        } else {
            [self.currLiveLabel setHidden:YES];
        }
        
        NSInteger currValue = 100 - (100 * (CGFloat)city.currPeopleCount / (CGFloat)city.initPeopleCount);
        [self.progressBar updateToCurrentValue:currValue animated:YES];
        
        NSString *cityNameString = @"";
        
        switch (city.type) {
            case 1:
                cityNameString = @"CapitalCity.png";
                break;
                
            case 2:
                cityNameString = @"Town2City.png";
                break;
                
            case 3:
                cityNameString = @"Town1City.png";
                break;
                
            case 4:
                cityNameString = @"VillageLumbererCity.png";
                break;
                
            case 5:
                cityNameString = @"VillageVariorsCity.png";
                break;
                
            case 6:
                cityNameString = @"VillageFishermansCity.png";
                break;
                
            default:
                break;
        }
        
        self.cityIconImageView.image = [UIImage imageNamed:cityNameString];
        
        BOOL inDanger = city.cityInDanger;
        
        
        
        UIView *view = [self viewWithTag:666];
        
        if (view) {
            [view setHidden:!inDanger];
        }
        
        view = [self viewWithTag:6666];
        
        if (view) {
            [view setHidden:!inDanger];
        }
        
        if (inDanger) {
            self.cityIconImageView.layer.shadowOpacity = 0.5;
        }
        
        [self animateCityDander];
    }
}

- (void)stopAnimations {
    self.cityIconImageView.layer.shadowOpacity = 0;
    [self.cityIconImageView.layer removeAllAnimations];
}

- (void)animateCityDander
{
    if (!self.city || !self.city.cityInDanger) {
        [self stopAnimations];
        return;
    }
    
    
    static int count = 0;
    count++;
    UIView *trashView = [self viewWithTag:6666];
    trashView.alpha = 0;
    
    trashView = [self viewWithTag:666];
    trashView.alpha = 0;
    
    BOOL show = count % 2 == 1;
    CGFloat fromOpacity = show ? 0.0 : 1.0;
    CGFloat toOpacity = show ? 1.0 : 0.0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = @(fromOpacity);
    animation.toValue = @(toOpacity);
    animation.duration = 0.5;
    [animation setRemovedOnCompletion:NO];
    animation.delegate = self;
    
    [self.cityIconImageView.layer addAnimation:animation forKey:@"test"];
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//
//
//    [self.cityIconImageView.layer removeAllAnimations];
//    [self animateCityDander];
//}

@end
