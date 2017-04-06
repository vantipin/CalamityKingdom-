//
//  PPCityInfoController.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCity.h"
#import "PPDanger.h"

@interface PPDangerProgressController : UIViewController

@property (nonatomic, strong) PPDanger *danger;
@property (nonatomic, strong) PPAbility *ability;

+ (instancetype)showWithDanger:(PPDanger *)danger andAbility:(PPAbility *)ability andCompletionBlock:(void (^)(BOOL result))aCompletionBlock;;
- (IBAction)hide:(id)sender;

@end
