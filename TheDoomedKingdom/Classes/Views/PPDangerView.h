//
//  PPDangerView.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/31/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCity.h"
#import "PPEvent.h"
#import "PPDanger.h"
//#import "PaperView.h"

@interface PPDangerView : UIView

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descrLabel;

@property (nonatomic, weak) IBOutlet UIImageView *dangerTypeImageView;
@property (nonatomic, weak) IBOutlet UILabel *dangerTypeName;

@property (nonatomic, weak) IBOutlet UILabel *dangerLevelName;

@property (strong, nonatomic) IBOutletCollection(id) NSArray *abilities;

@property (nonatomic, strong) PPCity *city;
@property (nonatomic, strong) PPEvent *event;

@end
