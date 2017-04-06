//
//  PPCityInfoController.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCity.h"

@interface PPCityInfoController : UIViewController

@property (nonatomic, strong) PPCity *city;

+ (instancetype)showWithCity:(PPCity *)city;
- (IBAction)hide:(id)sender;

@end
