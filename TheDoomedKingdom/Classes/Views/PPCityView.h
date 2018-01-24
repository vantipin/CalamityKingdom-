//
//  PPCityView.h
//  TheDoomedKingdom
//
//  Created by Pavel Stoma on 1/30/16.
//  Copyright © 2016 PP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPCity.h"
#import "EAColourfulProgressView.h"
//#import "PaperView.h"

@interface PPCityView : UIView <CAAnimationDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *cityIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descrLabel;
@property (nonatomic, weak) IBOutlet UILabel *popularityLabel;
@property (nonatomic, weak) IBOutlet UILabel *currLiveLabel;
@property (nonatomic, weak) IBOutlet EAColourfulProgressView *progressBar;

@property (nonatomic, strong) PPCity *city;

@end
